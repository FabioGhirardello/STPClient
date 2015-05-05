import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.util.Properties;

public class WL {
    public static Logger log = Logger.getLogger("STPClient");

    private Email fabEmail;
    private String cptyId;
    private String stylesheet;
    private String title;

    private DocumentBuilderFactory dbf;
    private Properties prop;

    public WL(Email fabEmail, String cptyId, String stylesheet, String title, String wlClientsEmails) {
        this.fabEmail = fabEmail;
        this.cptyId = cptyId;
        this.stylesheet = stylesheet;
        this.title = title;
        this.readProperties(wlClientsEmails);

        dbf = DocumentBuilderFactory.newInstance();
    }

    public void sendEmailToWLClient(String tradeId, String xmlMessage) {
        // get the email address from the file
        String wlEmail = prop.getProperty(this.getCptyID(xmlMessage),"");
        fabEmail.send(tradeId, xmlMessage, wlEmail, this.stylesheet, this.title);
    }


    private String getCptyID(String xmlMessage) {
        String cpty = "";
        try {
            DocumentBuilder db = dbf.newDocumentBuilder();
            InputSource is = new InputSource();
            is.setCharacterStream(new StringReader(xmlMessage));

            Document doc = db.parse(is);
            Element docEle = doc.getDocumentElement();
            NodeList nl = docEle.getChildNodes();
            if (nl != null && nl.getLength() > 0) {
                for (int i = 0; i < nl.getLength(); i++) {
                    if (nl.item(i).getNodeType() == Node.ELEMENT_NODE) {
                        Element el = (Element) nl.item(i);
                        // avoid empty fields
                        if (el.getNodeName().equals(this.cptyId)) {
                            cpty = el.getTextContent();
                            break;
                        }
                    }
                }
            };
        }
        catch (Exception e) {
            log.error("[WL001] ", e);
        }
        return cpty;
    }


    private void readProperties(String dbProperties) {
        InputStream input = null;
        try {
            prop = new Properties();
            input = new FileInputStream(dbProperties);

            // load a properties file
            prop.load(input);
        }
        catch (IOException e) {
            log.error("[WL002] - Error reading properties file. ", e);
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

}
