package application;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

public class STPApplication {
    private static Logger log = Logger.getLogger("STPClient");
    private static Logger logTrade = Logger.getLogger("MyTrade");
    private static final String VERSION = "2.8";
    private static final String COMPILE_DATE = "2016-02-24";
    private static final String JDK_VERSION = "1.8.0_65";

    private static DB db;
    private static Email email;
    private static WL wl;
    private static QFJ qfj;
    private static WriteFile writeFile;


    // STP connection variables
    private static String STP_STYLESHEET;
    private static String STP_IP;
    private static String STP_PORT;
    private static String STP_QUEUE_MANAGER;
    private static String STP_QUEUE_NAME;
    private static String STP_CHANNEL;
    private static String STP_USERNAME;
    private static String STP_PASSWORD;
    private static String STP_SSL_CIPHER_SUITE;

    // application.DB Properties variables
    private static String DB_SWITCH;
    private static String DB_JDBC_DRIVER;
    private static String DB_URL;
    private static String DB_USERNAME;
    private static String DB_PASSWORD;

    // application.Email Properties variables
    private static String EMAIL_SWITCH;
    private static String EMAIL_FROM;
    private static String EMAIL_TO;
    private static String EMAIL_ADDRESS_BOOK;
    private static String EMAIL_ADDRESS_BOOK_KEY;
    private static String EMAIL_HOST;
    private static String EMAIL_PORT;
    private static String EMAIL_AUTH;
    private static String EMAIL_USERNAME;
    private static String EMAIL_PASSWORD;
    private static String EMAIL_STYLESHEET;
    private static String EMAIL_SUBJECT;
    private static String EMAIL_IMAGE;

    // White Label Properties variables
    private static String WL_SWITCH;
    private static String WL_CPTY_ID;
    private static String WL_STYLESHEET;
    private static String WL_SUBJECT;
    private static String WL_SIDE_INDICATOR;
    private static String WL_CLIENTS_EMAILS;
    private static String WL_IMAGE;

    // Save To File variables
    private static String FILE_SWITCH;
    private static String FILE_PATH;
    private static String FILE_DATE_FORMAT;
    private static String FILE_COUNTER;
    private static String FILE_TITLE;

    // QuickFix/J variables
    private static String QFJ_SWITCH;
    private static String QFJ_CONFIG_FILE;

    // interface
    private static CustomModification customModification;


    public STPApplication(String properties, CustomModification customModification) {
        log.info("STPClient version " + VERSION + ". Compiled with JDK version " + JDK_VERSION + " on " + COMPILE_DATE + ".");
        // print out the config file
        try {
            String line = new String(Files.readAllBytes(Paths.get(properties)));
            log.info("Reading configuration file " + properties + ":\n" + line);
        } catch (IOException e) {
            log.error("[ERR001] ", e);
        }
        STPApplication.customModification = customModification;
        readProperties(properties);

        // check if there's a db connection setup
        if (DB_SWITCH.equalsIgnoreCase("ON")) {
            db = new DB(DB_JDBC_DRIVER, DB_URL, DB_USERNAME, DB_PASSWORD);
        }

        // check if there's a email setup
        if (EMAIL_SWITCH.equalsIgnoreCase("ON")) {
            email = new Email(EMAIL_FROM, EMAIL_TO, EMAIL_ADDRESS_BOOK, EMAIL_ADDRESS_BOOK_KEY, EMAIL_HOST, EMAIL_PORT,
                    EMAIL_USERNAME, EMAIL_PASSWORD, EMAIL_AUTH, EMAIL_STYLESHEET, EMAIL_SUBJECT, EMAIL_IMAGE);
        }

        //check if there's a application.WL email setup
        if (WL_SWITCH.equalsIgnoreCase("ON") && EMAIL_SWITCH.equalsIgnoreCase("ON") ) {
            wl = new WL(email, WL_CPTY_ID, WL_STYLESHEET, WL_SUBJECT, WL_SIDE_INDICATOR, WL_CLIENTS_EMAILS, WL_IMAGE);
        }

        // check if deals need to be saved to an individual file
        if (FILE_SWITCH.equalsIgnoreCase("ON")) {
            writeFile = new WriteFile(FILE_DATE_FORMAT, FILE_COUNTER, FILE_TITLE, FILE_PATH);
        }

        // check if deals need to be sent via FIX
        if (QFJ_SWITCH.equalsIgnoreCase("ON")) {
            qfj = new QFJ(QFJ_CONFIG_FILE);
        }

        // launch the STP listener
        IBMMQClient ibmmqClient = new IBMMQClient(STP_IP, STP_PORT, STP_QUEUE_MANAGER, STP_QUEUE_NAME,
                STP_CHANNEL, STP_USERNAME, STP_PASSWORD, STP_SSL_CIPHER_SUITE,
                new IBMMQClient.OnMessageReceived() {
                    @Override
                    //here 'messageReceived' method-event is implemented
                    public void messageReceived(String tradeID, String finXML) {
                        publish(tradeID, finXML);
                    }
                });

        ibmmqClient.login();
    }



    private void readProperties(String configFile ){
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
            //STP_CERT_NAME = prop.getProperty("STP.CERT_NAME");
            STP_SSL_CIPHER_SUITE = prop.getProperty("STP.SSL_CIPHER_SUITE");

            // get the application.DB properties
            DB_SWITCH = prop.getProperty("DB.SWITCH", "OFF");
            DB_JDBC_DRIVER = prop.getProperty("DB.JDBC_DRIVER");
            DB_URL = prop.getProperty("DB.URL");
            DB_USERNAME = prop.getProperty("DB.USERNAME");
            DB_PASSWORD = prop.getProperty("DB.PASSWORD");

            // get the application.Email Properties
            EMAIL_SWITCH = prop.getProperty("EMAIL.SWITCH", "OFF");
            EMAIL_FROM = prop.getProperty("EMAIL.FROM");
            EMAIL_TO = prop.getProperty("EMAIL.TO", "");
            EMAIL_ADDRESS_BOOK = prop.getProperty("EMAIL.ADDRESS_BOOK", "");
            EMAIL_ADDRESS_BOOK_KEY = prop.getProperty("EMAIL.ADDRESS_BOOK_KEY", "");
            EMAIL_HOST = prop.getProperty("EMAIL.HOST");
            EMAIL_PORT = prop.getProperty("EMAIL.PORT");
            EMAIL_AUTH = prop.getProperty("EMAIL.AUTH");
            EMAIL_USERNAME = prop.getProperty("EMAIL.USERNAME");
            EMAIL_PASSWORD = prop.getProperty("EMAIL.PASSWORD");
            EMAIL_STYLESHEET = prop.getProperty("EMAIL.STYLESHEET", "");
            EMAIL_SUBJECT = prop.getProperty("EMAIL.SUBJECT", "");
            EMAIL_IMAGE = prop.getProperty("EMAIL.IMAGE", "");

            // get the White Label properties
            WL_SWITCH = prop.getProperty("WL.SWITCH","OFF");
            WL_CPTY_ID = prop.getProperty("WL.CPTY_ID");
            WL_STYLESHEET = prop.getProperty("WL.STYLESHEET","");
            WL_SUBJECT = prop.getProperty("WL.SUBJECT","");
            WL_SIDE_INDICATOR = prop.getProperty("WL.SIDE_INDICATOR"," , , ");
            WL_CLIENTS_EMAILS = prop.getProperty("WL.CLIENTS_EMAILS");
            WL_IMAGE = prop.getProperty("WL.IMAGE", "");

            // get Save to File properties
            FILE_SWITCH = prop.getProperty("FILE.SWITCH", "OFF");
            FILE_PATH = prop.getProperty("FILE.PATH");
            FILE_DATE_FORMAT = prop.getProperty("FILE.DATE_FORMAT", "");
            FILE_COUNTER = prop.getProperty("FILE.COUNTER", "");
            FILE_TITLE = prop.getProperty("FILE.NAME");

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
    public final void publish(String tradeID, String finXML) {
        Document doc = XslTransform(STP_STYLESHEET, finXML);

        doc = customModification.customWork(doc);
        logTrade.info(docToString(doc));
        if (db != null) {
            db.insert(tradeID, doc);
        }
        if (email != null) {
            email.send(tradeID, doc);
        }
        if (wl != null) {
            wl.sendEmailToWLClient(tradeID, doc);
        }
        if (writeFile != null) {
            writeFile.writeToFile(tradeID, docToString(doc));
        }
        if (qfj != null) {
            qfj.sendTradeCaptureReport(doc);
        }
    }


    public static Document XslTransform(String stylesheet, String finXML) {
        StreamSource xml = new StreamSource(new StringReader(finXML));
        StreamSource xsl = new StreamSource(new File(stylesheet).getAbsoluteFile());
        Document doc = null;
        try {
            TransformerFactory tFactory = TransformerFactory.newInstance();
            Transformer transformer = tFactory.newTransformer(xsl);
            DOMResult domResult = new DOMResult();
            transformer.transform(xml, domResult);
            doc = (Document)domResult.getNode();
        }
        catch (TransformerFactoryConfigurationError | TransformerException e) {
            e.printStackTrace();
        }
        return doc ;
    }

    public static String docToString(Document doc) {
        try {
            StringWriter sw = new StringWriter();
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");

            if (doc.getFirstChild().getNodeName().equalsIgnoreCase("root")) {
                transformer.setOutputProperty(OutputKeys.METHOD, "text");
            }
            //transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            //transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");

            transformer.transform(new DOMSource(doc), new StreamResult(sw));
            return sw.toString();
        } catch (Exception ex) {
            throw new RuntimeException("Error converting to String", ex);
        }
    }

    public interface CustomModification {
        Document customWork(Document document);
    }
}


