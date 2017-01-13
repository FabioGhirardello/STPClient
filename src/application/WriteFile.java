package application;

import org.apache.log4j.Logger;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;

public class WriteFile {
    private static Logger log = Logger.getLogger(WriteFile.class.getSimpleName());
    final private String path;
    final private String dateFormat;
    final private String counter;
    final private String[] name;
    final private String client;

    public WriteFile(String client, String fileDateFormat, String fileCounter, String fileName, String filePath) {
        this.client = client;
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
                log.error(client + " " + "[ERR003] ", e);
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
                            log.error(client + " " + "[ERR004] - The only valid keywords are 'Counter', 'Date' and 'TradeID'.");
                    }
                } else {
                    fileName += field;
                }
            }
        }
        catch (Exception e) {
            log.error(client + " " + "[ERR005] ", e);
        }

        fileName = this.path + "/" + fileName;

        try {
            PrintWriter out = new PrintWriter(fileName);
            out.print(message);
            out.close();
            log.info(client + " " + tradeId + " - Saved to file " + fileName);
        } catch (FileNotFoundException e) {
            log.error(client + " " + "[ERR006] ", e);
        }
    }

}
