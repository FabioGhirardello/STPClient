import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class WL {
    public static Logger log = Logger.getLogger("STPClient");

    private Email email;
    private String cptyId;
    private String stylesheet;
    private String subject;

    private Properties prop;

    public WL(Email email, String cptyId, String stylesheet, String subject, String wlClientsEmails) {
        this.email = email;
        this.cptyId = cptyId;
        this.stylesheet = stylesheet;
        this.subject = subject;

        this.readWLClientsProperties(wlClientsEmails);
    }

    public void sendEmailToWLClient(String tradeId, Document doc) {
        // get the email address from the file
        email.send(tradeId, doc, prop.getProperty(this.getCptyID(doc), ""), this.stylesheet, this.subject);
    }


    private String getCptyID(Document doc) {
        String cpty = "";
        try {
            Element docEle = doc.getDocumentElement();
            NodeList nl = docEle.getChildNodes();
            if (nl != null && nl.getLength() > 0) {
                for (int i = 0; i < nl.getLength(); i++) {
                    if (nl.item(i).getNodeType() == Node.ELEMENT_NODE) {
                        Element el = (Element) nl.item(i);
                        if (el.getNodeName().equals(this.cptyId)) {
                            cpty = el.getTextContent();
                            break;
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            log.error("[WL001] ", e);
        }
        return cpty;
    }


    private void readWLClientsProperties(String wlClientsEmails) {
        InputStream input = null;
        try {
            prop = new Properties();
            input = new FileInputStream(wlClientsEmails);

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
