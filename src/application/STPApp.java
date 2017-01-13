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
import java.util.HashMap;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class STPApp {
    private static Logger log = Logger.getLogger(STPApp.class.getSimpleName());
    private static Logger logTrade = Logger.getLogger("MyTrade");

    private static final String VERSION = "3.0";
    private static final String COMPILE_DATE = "2017-01-13";
    private static final String JDK_VERSION = "1.8.0_101";

    // PROPERTIES
    private static final String DEFAULT = "DEFAULT";
    private Properties variableValues = System.getProperties();
    private static final Pattern VARIABLE_PATTERN = Pattern.compile("\\$\\{(.+?)}");
    // This was using the line.separator system property but that caused
    // problems with moving configuration files between *nix and Windows.
    private static final String NEWLINE = "\r\n";

    private final HashMap<String, Properties> propsMap = new HashMap<>();
    private final HashMap<String, DB> dbMap = new HashMap<>();
    private final HashMap<String, Email> emailMap = new HashMap<>();
    private final HashMap<String, WL> wlMap = new HashMap<>();
    private final HashMap<String, WriteFile> writeFileMap = new HashMap<>();
    private final HashMap<String, QFJ> qfjMap = new HashMap<>();
    private final HashMap<String, MQ> mqMap = new HashMap<>();


    // interface
    private static CustomModification customModification;


    public STPApp(String properties, CustomModification customModification) {
        log.info("MultiSTPClient version " + VERSION + ". Compiled with JDK version " + JDK_VERSION + " on " + COMPILE_DATE + ".");
        // print out the config file
        try {
            String line = new String(Files.readAllBytes(Paths.get(properties)));
            log.info("Reading configuration file " + properties + ":\n" + line);
        } catch (IOException e) {
            log.error("[ERR001] ", e);
        }
        STPApp.customModification = customModification;

        readProperties(properties);

        for (String client : propsMap.keySet()) {
            if (!client.equalsIgnoreCase(DEFAULT)) {
                // check if there's a db connection setup
                if (propsMap.get(client).getProperty("DB.SWITCH", propsMap.get(DEFAULT).getProperty("DB.SWITCH", "OFF")).equalsIgnoreCase("ON")) {
                    dbMap.put(client, new DB(
                            client,
                            propsMap.get(client).getProperty("DB.JDBC_DRIVER", propsMap.get(DEFAULT).getProperty("DB.JDBC_DRIVER")),
                            propsMap.get(client).getProperty("DB.URL", propsMap.get(DEFAULT).getProperty("DB.URL")),
                            propsMap.get(client).getProperty("DB.USERNAME", propsMap.get(DEFAULT).getProperty("DB.USERNAME")),
                            propsMap.get(client).getProperty("DB.PASSWORD", propsMap.get(DEFAULT).getProperty("DB.PASSWORD")))
                    );
                }

                // check if there's a email setup
                if (propsMap.get(client).getProperty("EMAIL.SWITCH", propsMap.get(DEFAULT).getProperty("EMAIL.SWITCH", "OFF")).equalsIgnoreCase("ON")) {
                    emailMap.put(client, new Email(
                            client,
                            propsMap.get(client).getProperty("EMAIL.FROM", propsMap.get(DEFAULT).getProperty("EMAIL.FROM")),
                            propsMap.get(client).getProperty("EMAIL.TO", propsMap.get(DEFAULT).getProperty("EMAIL.TO", "")),
                            propsMap.get(client).getProperty("EMAIL.ADDRESS_BOOK", propsMap.get(DEFAULT).getProperty("EMAIL.ADDRESS_BOOK", "")),
                            propsMap.get(client).getProperty("EMAIL.ADDRESS_BOOK_KEY", propsMap.get(DEFAULT).getProperty("EMAIL.ADDRESS_BOOK_KEY", "")),
                            propsMap.get(client).getProperty("EMAIL.HOST", propsMap.get(DEFAULT).getProperty("EMAIL.HOST")),
                            propsMap.get(client).getProperty("EMAIL.PORT", propsMap.get(DEFAULT).getProperty("EMAIL.PORT")),
                            propsMap.get(client).getProperty("EMAIL.USERNAME", propsMap.get(DEFAULT).getProperty("EMAIL.USERNAME")),
                            propsMap.get(client).getProperty("EMAIL.PASSWORD", propsMap.get(DEFAULT).getProperty("EMAIL.PASSWORD")),
                            propsMap.get(client).getProperty("EMAIL.AUTH", propsMap.get(DEFAULT).getProperty("EMAIL.AUTH")),
                            propsMap.get(client).getProperty("EMAIL.STYLESHEET", propsMap.get(DEFAULT).getProperty("EMAIL.STYLESHEET", "")),
                            propsMap.get(client).getProperty("EMAIL.SUBJECT", propsMap.get(DEFAULT).getProperty("EMAIL.SUBJECT", "")),
                            propsMap.get(client).getProperty("EMAIL.IMAGE", propsMap.get(DEFAULT).getProperty("EMAIL.IMAGE","")))
                    );
                }

                //check if there's a WL email setup  email, CPTY_ID, STYLESHEET, SUBJECT, SIDE_INDICATOR, CLIENTS_EMAILS, IMAGE
                if (propsMap.get(client).getProperty("WL.SWITCH", propsMap.get(DEFAULT).getProperty("WL.SWITCH", "OFF")).equalsIgnoreCase("ON")
                        && propsMap.get(client).getProperty("EMAIL.SWITCH", propsMap.get(DEFAULT).getProperty("EMAIL.SWITCH", "OFF")).equalsIgnoreCase("ON")) {
                    wlMap.put(client, new WL(
                            client,
                            emailMap.get(client),
                            propsMap.get(client).getProperty("WL.CPTY_ID", propsMap.get(DEFAULT).getProperty("WL.CPTY_ID")),
                            propsMap.get(client).getProperty("WL.STYLESHEET", propsMap.get(DEFAULT).getProperty("WL.STYLESHEET", "")),
                            propsMap.get(client).getProperty("WL.SUBJECT", propsMap.get(DEFAULT).getProperty("WL.SUBJECT")),
                            propsMap.get(client).getProperty("WL.SIDE_INDICATOR", propsMap.get(DEFAULT).getProperty("WL.SIDE_INDICATOR", " , , ")),
                            propsMap.get(client).getProperty("WL.CLIENTS_EMAILS", propsMap.get(DEFAULT).getProperty("WL.CLIENTS_EMAILS")),
                            propsMap.get(client).getProperty("WL.IMAGE", propsMap.get(DEFAULT).getProperty("WL.IMAGE", "")))
                    );
                }

                // check if deals need to be saved to an individual file
                if (propsMap.get(client).getProperty("FILE.SWITCH", propsMap.get(DEFAULT).getProperty("FILE.SWITCH", "OFF")).equalsIgnoreCase("ON")) {
                    writeFileMap.put(client, new WriteFile(
                            client,
                            propsMap.get(client).getProperty("FILE.DATE_FORMAT", propsMap.get(DEFAULT).getProperty("FILE.DATE_FORMAT", "")),
                            propsMap.get(client).getProperty("FILE.COUNTER", propsMap.get(DEFAULT).getProperty("FILE.COUNTER", "")),
                            propsMap.get(client).getProperty("FILE.NAME", propsMap.get(DEFAULT).getProperty("FILE.NAME")),
                            propsMap.get(client).getProperty("FILE.PATH", propsMap.get(DEFAULT).getProperty("FILE.PATH")))
                    );
                }

                // check if deals need to be sent via FIX
                if (propsMap.get(client).getProperty("QFJ.SWITCH", propsMap.get(DEFAULT).getProperty("QFJ.SWITCH", "OFF")).equalsIgnoreCase("ON")) {
                    qfjMap.put(client, new QFJ(client, propsMap.get(client).getProperty("QFJ.CONFIG_FILE", propsMap.get(DEFAULT).getProperty("QFJ.CONFIG_FILE"))));
                }


                // launch the STP listener
                mqMap.put(client, new MQ(
                        client,
                        propsMap.get(client).getProperty("STP.IP", propsMap.get(DEFAULT).getProperty("STP.IP")),
                        propsMap.get(client).getProperty("STP.PORT", propsMap.get(DEFAULT).getProperty("STP.PORT")),
                        propsMap.get(client).getProperty("STP.QUEUE_MANAGER", propsMap.get(DEFAULT).getProperty("STP.QUEUE_MANAGER")),
                        propsMap.get(client).getProperty("STP.QUEUE_NAME", propsMap.get(DEFAULT).getProperty("STP.QUEUE_NAME")),
                        propsMap.get(client).getProperty("STP.CHANNEL", propsMap.get(DEFAULT).getProperty("STP.CHANNEL")),
                        propsMap.get(client).getProperty("STP.USERNAME", propsMap.get(DEFAULT).getProperty("STP.USERNAME")),
                        propsMap.get(client).getProperty("STP.PASSWORD", propsMap.get(DEFAULT).getProperty("STP.PASSWORD")),
                        propsMap.get(client).getProperty("STP.SSL_CIPHER_SUITE", propsMap.get(DEFAULT).getProperty("STP.SSL_CIPHER_SUITE")),
                        new MQ.OnMessageReceived() {
                            @Override
                            //here 'messageReceived' method-event is implemented
                            public void messageReceived(String client, String tradeID, String finXML) {
                                publish(client, tradeID, finXML);
                            }
                        })
                );

                mqMap.get(client).login();
            }
        }
    }



    /*
     * This method is called once a new STP message has arrived
     */
    public final void publish(String client, String tradeID, String finXML) {
        Document doc = XslTransform(propsMap.get(client).getProperty("STP.STYLESHEET", propsMap.get(DEFAULT).getProperty("STP.STYLESHEET")), finXML);

        doc = customModification.customWork(doc);
        logTrade.info(docToString(doc));
        if (dbMap.containsKey(client)) {
            dbMap.get(client).insert(tradeID, doc);
        }
        if (emailMap.containsKey(client)) {
            emailMap.get(client).send(tradeID, doc);
        }
        if (wlMap.containsKey(client)) {
            wlMap.get(client).sendEmailToWLClient(tradeID, doc);
        }
        if (writeFileMap.containsKey(client)) {
            writeFileMap.get(client).writeToFile(tradeID, docToString(doc));
        }
        if (qfjMap.containsKey(client)) {
            qfjMap.get(client).sendTradeCaptureReport(doc);
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

    private void readProperties(String configFile){
        propsMap.clear();
        propsMap.put(DEFAULT, new Properties());

        InputStream input = null;
        try {
            input = new FileInputStream(configFile);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        try {
            Properties currentSection = null;
            String currentSectionId = null;
            final Tokenizer tokenizer = new Tokenizer();
            final Reader reader = new InputStreamReader(input);
            Tokenizer.Token token = tokenizer.getToken(reader);
            while (token != null) {
                if (token.getType() == Tokenizer.SECTION_TOKEN) {
                    storeSection(currentSectionId, currentSection);
                    if (token.getValue().equalsIgnoreCase(DEFAULT)) {
                        currentSectionId = DEFAULT;
                        currentSection = propsMap.get(DEFAULT);
                    } else  {
                        currentSectionId = token.getValue();
                        currentSection = new Properties(propsMap.get(DEFAULT));
                    }
                } else if (token.getType() == Tokenizer.ID_TOKEN) {
                    final Tokenizer.Token valueToken = tokenizer.getToken(reader);
                    if (currentSection != null) {
                        final String value = interpolate(valueToken.getValue());
                        currentSection.put(token.getValue(), value);
                    }
                }
                token = tokenizer.getToken(reader);
            }
            storeSection(currentSectionId, currentSection);
        } catch (final IOException e) {
            //
        }
    }

    private void storeSection(String currentSectionId, Properties currentSection) {
        if (currentSectionId != null && !currentSectionId.equals(DEFAULT)) {
            propsMap.put(currentSectionId, currentSection);
        }
    }

    private static class Tokenizer {
        //public static final int NONE_TOKEN = 1;
        public static final int ID_TOKEN = 2;
        public static final int VALUE_TOKEN = 3;
        public static final int SECTION_TOKEN = 4;

        private static class Token {
            private final int type;

            private final String value;

            public Token(int type, String value) {
                super();
                this.type = type;
                this.value = value;
            }

            public int getType() {
                return type;
            }

            public String getValue() {
                return value;
            }

            @Override
            public String toString() {
                return type + ": " + value;
            }
        }

        private char ch = '\0';

        private final StringBuilder sb = new StringBuilder();

        private Token getToken(Reader reader) throws IOException {
            if (ch == '\0') {
                ch = nextCharacter(reader);
            }
            skipWhitespace(reader);
            if (isLabelCharacter(ch)) {
                sb.setLength(0);
                do {
                    sb.append(ch);
                    ch = nextCharacter(reader);
                } while (isLabelCharacter(ch));
                return new Token(ID_TOKEN, sb.toString());
            } else if (ch == '=') {
                ch = nextCharacter(reader);
                sb.setLength(0);
                if (isValueCharacter(ch)) {
                    do {
                        sb.append(ch);
                        ch = nextCharacter(reader);
                    } while (isValueCharacter(ch));
                }
                return new Token(VALUE_TOKEN, sb.toString().trim());
            } else if (ch == '[') {
                ch = nextCharacter(reader);
                final Token id = getToken(reader);
                // check ]
                ch = nextCharacter(reader); // skip ]
                return new Token(SECTION_TOKEN, id.getValue());
            } else if (ch == '#') {
                do {
                    ch = nextCharacter(reader);
                } while (isValueCharacter(ch));
                return getToken(reader);
            }
            return null;
        }

        private boolean isNewLineCharacter(char ch) {
            return NEWLINE.indexOf(ch) != -1;
        }

        private boolean isLabelCharacter(char ch) {
            return !isEndOfStream(ch) && "[]=#".indexOf(ch) == -1;
        }

        private boolean isValueCharacter(char ch) {
            return !isEndOfStream(ch) && !isNewLineCharacter(ch);
        }

        private boolean isEndOfStream(char ch) {
            return (byte) ch == -1;
        }

        private char nextCharacter(Reader reader) throws IOException {
            return (char) reader.read();
        }

        private void skipWhitespace(Reader reader) throws IOException {
            if (Character.isWhitespace(ch)) {
                do {
                    ch = nextCharacter(reader);
                } while (Character.isWhitespace(ch));
            }
        }
    }

    private String interpolate(String value) {
        if (value == null || value.indexOf('$') == -1) {
            return value;
        }
        final StringBuffer buffer = new StringBuffer();
        final Matcher m = VARIABLE_PATTERN.matcher(value);
        while (m.find()) {
            if (m.start() > 0 && value.charAt(m.start() - 1) == '\\') {
                continue;
            }
            final String variable = m.group(1);
            final String variableValue = variableValues.getProperty(variable);
            if (variableValue != null) {
                m.appendReplacement(buffer, variableValue);
            }
        }
        m.appendTail(buffer);
        return buffer.toString();
    }

    public interface CustomModification {
        Document customWork(Document document);
    }
}


