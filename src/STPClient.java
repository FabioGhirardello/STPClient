import com.integral.stpclient.STPDownloadClientC;
import org.apache.log4j.Logger;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

public class STPClient {
    private static Logger log = Logger.getLogger("STPClient");
    private static Logger logTrade = Logger.getLogger("MyTrade");
    private static String VERSION = " 2.2 - 2015-05-05";

    private static DB db;
    private static Email email;
    private static WL wl;
    private static QFJ qfj;
    private static boolean isToBeSaved = false;


    // STP connection variables
    private static String STP_STYLESHEET;
    private static String STP_IP;
    private static String STP_PORT;
    private static String STP_QUEUE_MANAGER;
    private static String STP_QUEUE_NAME;
    private static String STP_CHANNEL;
    private static String STP_USERNAME;
    private static String STP_PASSWORD;
    private static String STP_CERT_NAME;
    private static String STP_SSL_CIPHER_SUITE;

    // DB Properties variables
    private static String DB_SWITCH;
    private static String DB_JDBC_DRIVER;
    private static String DB_URL;
    private static String DB_USERNAME;
    private static String DB_PASSWORD;

    // Email Properties variables
    private static String EMAIL_SWITCH;
    private static String EMAIL_FROM;
    private static String EMAIL_TO;
    private static String EMAIL_HOST;
    private static String EMAIL_PORT;
    private static String EMAIL_AUTH;
    private static String EMAIL_USERNAME;
    private static String EMAIL_PASSWORD;
    private static String EMAIL_STYLESHEET;
    private static String EMAIL_TITLE;
    private static String EMAIL_IMAGE;

    // White Label Properties variables
    private static String WL_SWITCH;
    private static String WL_CPTY_ID;
    private static String WL_STYLESHEET;
    private static String WL_TITLE;
    private static String WL_CLIENTS_EMAILS;

    // Save To File variables
    private static String FILE_SWITCH;
    private static String FILE_PATH;
    private static String FILE_DATE_FORMAT;
    private static String FILE_COUNTER;
    private static String FILE_TITLE;

    // QuickFix/J variables
    private static String QFJ_SWITCH;
    private static String QFJ_CONFIG_FILE;


    public static void main(String args[])
    {
        log.info("FabSTPClient version" + VERSION);

        // print out the config file
        try {
            String line = new String(Files.readAllBytes(Paths.get(args[0])));
            log.info("Reading configuration file " + args[0] + ":\n" + line);
        } catch (IOException e) {
            log.error("[ERR001] ", e);
        }

        readProperties(args[0]);

        // check if there's a db connection setup
        if (DB_SWITCH.equalsIgnoreCase("ON")) {
            db = new DB(DB_JDBC_DRIVER, DB_URL, DB_USERNAME, DB_PASSWORD);
        }

        // check if there's a email setup
        if (EMAIL_SWITCH.equalsIgnoreCase("ON")) {
            email = new Email(EMAIL_FROM, EMAIL_TO, EMAIL_HOST, EMAIL_PORT, EMAIL_USERNAME,
                    EMAIL_PASSWORD, EMAIL_AUTH, EMAIL_STYLESHEET, EMAIL_TITLE, EMAIL_IMAGE);
        }

        //check if there's a WL email setup
        if (WL_SWITCH.equalsIgnoreCase("ON") && EMAIL_SWITCH.equalsIgnoreCase("ON") ) {
            wl = new WL(email, WL_CPTY_ID, WL_STYLESHEET, WL_TITLE, WL_CLIENTS_EMAILS);
        }

        // check if deals need to be saved to an individual file
        if (FILE_SWITCH.equalsIgnoreCase("ON")) {
            isToBeSaved = true;
        }

        // check if deals need to be sent via FIX
        if (QFJ_SWITCH.equalsIgnoreCase("ON")) {
            qfj = new QFJ(QFJ_CONFIG_FILE);
        }

        // launch the STP listener
        STPDownloadClientC stpConnector = new STPDownloadClientC(STP_STYLESHEET, STP_IP, STP_PORT, STP_QUEUE_MANAGER, STP_QUEUE_NAME,
                STP_CHANNEL, STP_USERNAME, STP_PASSWORD, STP_CERT_NAME, STP_SSL_CIPHER_SUITE,
                new STPDownloadClientC.OnMessageReceived() {
                    @Override
                    //here 'messageReceived' method-event is implemented
                    public void messageReceived(String tradeID, String xmlmessage) {
                        publish(tradeID, xmlmessage);
                    }
                });
    }

    private static void readProperties(String configFile ){
        InputStream input = null;
        try {
            Properties prop = new Properties();
            input = new FileInputStream(configFile);

            // load a properties file
            prop.load(input);

            // get STP Connection properties
            STP_STYLESHEET = prop.getProperty("STP.STYLESHEET");
            STP_IP = prop.getProperty("STP.IP");
            STP_PORT = prop.getProperty("STP.PORT");
            STP_QUEUE_MANAGER = prop.getProperty("STP.QUEUE_MANAGER");
            STP_QUEUE_NAME = prop.getProperty("STP.QUEUE_NAME");
            STP_CHANNEL = prop.getProperty("STP.CHANNEL");
            STP_USERNAME = prop.getProperty("STP.USERNAME");
            STP_PASSWORD = prop.getProperty("STP.PASSWORD");
            STP_CERT_NAME = prop.getProperty("STP.CERT_NAME");
            STP_SSL_CIPHER_SUITE = prop.getProperty("STP.SSL_CIPHER_SUITE");

            // get the DB properties
            DB_SWITCH = prop.getProperty("DB.SWITCH", "OFF");
            DB_JDBC_DRIVER = prop.getProperty("DB.JDBC_DRIVER");
            DB_URL = prop.getProperty("DB.URL");
            DB_USERNAME = prop.getProperty("DB.USERNAME");
            DB_PASSWORD = prop.getProperty("DB.PASSWORD");

            // get the Email Properties
            EMAIL_SWITCH = prop.getProperty("EMAIL.SWITCH", "OFF");
            EMAIL_FROM = prop.getProperty("EMAIL.FROM");
            EMAIL_TO = prop.getProperty("EMAIL.TO", "");
            EMAIL_HOST = prop.getProperty("EMAIL.HOST");
            EMAIL_PORT = prop.getProperty("EMAIL.PORT");
            EMAIL_AUTH = prop.getProperty("EMAIL.AUTH");
            EMAIL_USERNAME = prop.getProperty("EMAIL.USERNAME");
            EMAIL_PASSWORD = prop.getProperty("EMAIL.PASSWORD");
            EMAIL_STYLESHEET = prop.getProperty("EMAIL.STYLESHEET", "");
            EMAIL_TITLE = prop.getProperty("EMAIL.TITLE", "");
            EMAIL_IMAGE = prop.getProperty("EMAIL.IMAGE", "");

            // get the White Label properties
            WL_SWITCH = prop.getProperty("WL.SWITCH","OFF");
            WL_CPTY_ID = prop.getProperty("WL.CPTY_ID");
            WL_STYLESHEET = prop.getProperty("WL.STYLESHEET");
            WL_TITLE = prop.getProperty("WL.TITLE");
            WL_CLIENTS_EMAILS = prop.getProperty("WL.CLIENTS_EMAILS");

            // get Save to File properties
            FILE_SWITCH = prop.getProperty("FILE.SWITCH", "OFF");
            FILE_PATH = prop.getProperty("FILE.PATH");
            FILE_DATE_FORMAT = prop.getProperty("FILE.DATE_FORMAT", "");
            FILE_COUNTER = prop.getProperty("FILE.COUNTER", "");
            FILE_TITLE = prop.getProperty("FILE.TITLE");

            // get QuickFix/J  properties
            QFJ_SWITCH = prop.getProperty("QFJ.SWITCH", "OFF");
            QFJ_CONFIG_FILE = prop.getProperty("QFJ.CONFIG_FILE");

        }
        catch (IOException e) {
            log.error("[ERR002] - Error reading properties file. ", e);
        }
        finally {
            if (input != null) {
                try {
                    input.close();
                }
                catch (IOException e) {
                    //do nothing
                }
            }
        }
    }

    /*
     * This method is called once a new STP message has arrived
     */
    private static void publish(String tradeID, String xmlMessage) {
        logTrade.info(xmlMessage);
        if (isToBeSaved) writeToFile(tradeID, xmlMessage);
        if (db != null) {
            db.insert(tradeID, xmlMessage);
        }
        if (email != null) {
            email.send(tradeID, xmlMessage);
        }
        if (wl != null) {
            wl.sendEmailToWLClient(tradeID,xmlMessage);
        }
        if (qfj != null) {
            qfj.sendTradeCaptureReport(xmlMessage);
        }
    }



    private static void writeToFile(String tradeId, String xmlMessage) {
        Date dateNow = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(FILE_DATE_FORMAT);
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
        int counter = 0;

        if (!FILE_COUNTER.equalsIgnoreCase("")) {
            // Open the Counter file
            String fileCounterName = FILE_COUNTER + "." + sdf2.format(dateNow);
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
                FileWriter f2 = null;
                f2 = new FileWriter(fileCounterName, false);
                f2.write(String.valueOf(counter + 1));
                f2.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        // Title
        String fileTitle = "";
        String[] fields = FILE_TITLE.split(",");
        try {
            for (int j = 0; j < fields.length; j++) {
                if (fields[j].charAt(0) == '<') {
                    String n = fields[j].replace("<", "").replace(">", "");

                    switch (n.toUpperCase()) {
                        case "COUNTER":
                            fileTitle += counter;
                            break;
                        case "TRADEID":
                            fileTitle += tradeId;
                            break;
                        case "DATE":
                            fileTitle += sdf.format(dateNow);
                            break;
                        default:
                            fileTitle += n;
                            log.error("[ERR004] - The only valid keywords are 'Counter', 'Date' and 'TradeID'.");
                    }
                } else {
                    fileTitle += fields[j];
                }
            }
        }
        catch (Exception e) {
            log.error("[ERR005] ", e);
        }

        String filename = FILE_PATH + "/" + fileTitle;

        try {
            PrintWriter out = new PrintWriter(filename);
            out.println(xmlMessage);
            out.close();
            log.info(tradeId + " - Saved to file " + filename);
        } catch (FileNotFoundException e) {
            log.error("[ERR006] ", e);
        }
    }

}


