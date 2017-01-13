package application;

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
    public static Logger log = Logger.getLogger(WL.class.getSimpleName());

    final private Email email;
    final private String cptyId;
    final private String stylesheet;
    final private String[] subjectFields;
    final private String[] sideIndicator;
    final private String image;
    final private String client;

    private Properties prop;

    public WL(String client, Email email, String cptyId, String stylesheet, String subjectFields, String sideIndicator,
              String wlClientsEmails, String image) {
        this.email = email;
        this.cptyId = cptyId;
        this.stylesheet = stylesheet;
        this.subjectFields = subjectFields.split(",");
        this.sideIndicator = sideIndicator.split(",");
        this.image = image;
        this.client = client;

        this.readWLClients(wlClientsEmails);
    }

    public void sendEmailToWLClient(String tradeId, Document doc) {
        // get the email address from the file
        email.send(tradeId, doc, prop.getProperty(this.getCptyID(doc), ""), this.stylesheet,
                getSubject(doc), this.image);
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
            log.error(client + " " + "[WL001] ", e);
        }
        return cpty;
    }


    private void readWLClients(String wlClientsEmails) {
        InputStream input = null;
        try {
            prop = new Properties();
            input = new FileInputStream(wlClientsEmails);

            // load a properties file
            prop.load(input);
        }
        catch (IOException e) {
            log.error(client + " " + "[WL002] - Error reading properties file. ", e);
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

    private String getSubject(Document doc) {
        String subject = "";
        try {
            NodeList nodeList = doc.getDocumentElement().getChildNodes();

            for (String subjectField : this.subjectFields) {
                if (subjectField.charAt(0) == '<') {
                    String field = subjectField.replace("<", "").replace(">", "");

                    for (int i = 0; i < nodeList.getLength(); i++) {
                        if (nodeList.item(i).getNodeType() == Node.ELEMENT_NODE) {
                            Element element = (Element) nodeList.item(i);
                            if (element.getNodeName().equalsIgnoreCase(field)) {
                                if (field.equalsIgnoreCase(this.sideIndicator[0])) {
                                    if (element.getTextContent().equalsIgnoreCase(this.sideIndicator[1])) {
                                        subject += this.sideIndicator[2];
                                    } else {
                                        subject += this.sideIndicator[1];
                                    }
                                } else {
                                    subject += element.getTextContent();
                                }
                                break;
                            }
                        }
                    }
                } else {
                    subject += subjectField;
                }
            }
        }
        catch (Exception e) {
            log.error(client + " " + "[EMA004] - Unable to build the email subject");
            subject = "";
        }
        return subject;
    }

}
