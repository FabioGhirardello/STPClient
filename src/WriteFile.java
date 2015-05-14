import org.apache.log4j.Logger;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;

public class WriteFile {
    private static Logger log = Logger.getLogger("STPClient");
    private String PATH;
    private String DATE_FORMAT;
    private String COUNTER;
    private String NAME;

    public WriteFile(String fileDateFormat, String fileCounter, String fileName, String filePath) {
        this.DATE_FORMAT = fileDateFormat;
        this.COUNTER = fileCounter;
        this.PATH = filePath;
        this.NAME = fileName;
    }

    public void writeToFile(String tradeId, String message) {
        Date dateNow = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(this.DATE_FORMAT);
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
        int counter = 0;

        if (!this.COUNTER.equalsIgnoreCase("")) {
            // Open the Counter file
            String fileCounterName = this.COUNTER + "." + sdf2.format(dateNow);
            try {
                File f = new File(fileCounterName);
                if (f.exists() && !f.isDirectory()) {
                    String line = new String(Files.readAllBytes(Paths.get(fileCounterName)));
                    counter = Integer.parseInt(line);
                }
            } catch (IOException e) {
                log.error("[ERR003] ", e);
            }

            // update the counter
            try {
                FileWriter f2;
                f2 = new FileWriter(fileCounterName, false);
                f2.write(String.valueOf(counter + 1));
                f2.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        // Name
        String fileName = "";
        String[] fields = this.NAME.split(",");
        try {
            for (String field : fields) {
                if (field.charAt(0) == '<') {
                    String n = field.replace("<", "").replace(">", "");

                    switch (n.toUpperCase()) {
                        case "COUNTER":
                            fileName += counter;
                            break;
                        case "TRADEID":
                            fileName += tradeId;
                            break;
                        case "DATE":
                            fileName += sdf.format(dateNow);
                            break;
                        default:
                            fileName += n;
                            log.error("[ERR004] - The only valid keywords are 'Counter', 'Date' and 'TradeID'.");
                    }
                } else {
                    fileName += field;
                }
            }
        }
        catch (Exception e) {
            log.error("[ERR005] ", e);
        }

        fileName = this.PATH + "/" + fileName;

        try {
            PrintWriter out = new PrintWriter(fileName);
            out.print(message);
            out.close();
            log.info(tradeId + " - Saved to file " + fileName);
        } catch (FileNotFoundException e) {
            log.error("[ERR006] ", e);
        }
    }

}
