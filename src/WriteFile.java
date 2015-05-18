import org.apache.log4j.Logger;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;

public class WriteFile {
    private static Logger log = Logger.getLogger("STPClient");
    private String path;
    private String dateFormat;
    private String counter;
    private String[] name;

    public WriteFile(String fileDateFormat, String fileCounter, String fileName, String filePath) {
        this.dateFormat = fileDateFormat;
        this.counter = fileCounter;
        this.path = filePath;
        this.name = fileName.split(",");
    }

    public void writeToFile(String tradeId, String message) {
        Date dateNow = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(this.dateFormat);
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
        int counter = 0;

        if (!this.counter.equalsIgnoreCase("")) {
            // Open the Counter file
            String fileCounterName = this.counter + "." + sdf2.format(dateNow);
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
        try {
            for (String field : this.name) {
                if (field.charAt(0) == '<') {
                    String n = field.replace("<", "").replace(">", "");

                    switch (n.toUpperCase()) {
                        case "counter":
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

        fileName = this.path + "/" + fileName;

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
