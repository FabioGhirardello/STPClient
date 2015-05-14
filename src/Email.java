import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Properties;

public class Email
{
    public static Logger log = Logger.getLogger("STPClient");
    private Session session;

    private String FROM;
    private String TO;
    private String STYLESHEET;
    private String SUBJECT;
    private String IMAGE;


    public Email(String from, String to, String host, String port, String username,
                    String password, String auth, String stylesheet, String subject, String image) {
        FROM = from;
        TO = to;
        STYLESHEET = stylesheet;
        SUBJECT = subject;
        IMAGE = image;

        try {
            // Get system properties
            Properties properties = System.getProperties();

            // Setup mail server
            properties.setProperty("mail.smtp.host", host);
            properties.setProperty("mail.smtp.port", port);
            properties.setProperty("mail.user", username);
            properties.setProperty("mail.password", password);
            properties.setProperty("mail.smtp.auth", auth);

            // Get the default Session object.
            session = Session.getDefaultInstance(properties);
        } catch (Exception e) {
            log.error("[EMA003] The property file is not correctly formatted");
        }
    }


    public void send (String tradeID, Document doc) {
        this.send(tradeID, doc, this.TO, this.STYLESHEET, this.SUBJECT);
    }

    public void send (String tradeID, Document doc, String to, String stylesheet, String subjectFormat) {
        if (!to.equalsIgnoreCase("")) {
            try {
                // Create a default MimeMessage object.
                MimeMessage message = new MimeMessage(this.session);

                // Set From: header field of the header.
                message.setFrom(new InternetAddress(this.FROM));

                // Set To: header field of the header.
                message.addRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

                // Set Subject: header field
                String subject = getSubject(doc, subjectFormat);
                if (subject.equalsIgnoreCase("")) {
                    message.setSubject(tradeID);
                }
                else {
                    message.setSubject(subject);
                }

                // Now set the actual message
                if (!stylesheet.equalsIgnoreCase("")) {

                    StreamSource isXsl = new StreamSource(new File(stylesheet).getAbsoluteFile());
                    String res = XslTransform(new DOMSource(doc), isXsl);
                    // This mail has 2 part, the BODY and the embedded image
                    MimeMultipart multipart = new MimeMultipart("related");
                    // first part (the html)
                    BodyPart messageBodyPart = new MimeBodyPart();
                    messageBodyPart.setContent(res, "text/html");
                    multipart.addBodyPart(messageBodyPart);

                    // second part (the image)
                    if (!this.IMAGE.equalsIgnoreCase("")) {
                        messageBodyPart = new MimeBodyPart();
                        DataSource fds = new FileDataSource(this.IMAGE);
                        messageBodyPart.setDataHandler(new DataHandler(fds));
                        messageBodyPart.setHeader("Content-ID", "<image>");
                        // add image to the multipart
                        multipart.addBodyPart(messageBodyPart);
                    }

                    // put everything together
                    message.setContent(multipart);
                } else {
                    message.setText(STPClient.docToString(doc).replaceAll("><", ">\n<"));
                }

                // Send message
                Transport.send(message);
                log.info(tradeID + " - E-mail sent to " + to);
            } catch (MessagingException mex) {
                log.error("[EMA001] E-mail failed for deal " + tradeID + ": " + mex.getMessage());
            } catch (Exception e) {
                log.error("[EMA002] E-mail failed for deal " + tradeID + ": " + e.getMessage());
            }
        }
    }

    private String XslTransform(Source xml, Source xsl) {
        String outputString = null;
        try {
            TransformerFactory tFactory = TransformerFactory.newInstance();
            Transformer transformer = tFactory.newTransformer(xsl);

            Writer outputWriter = new StringWriter();
            Result outputResult = new StreamResult(outputWriter);
            transformer.transform(xml, outputResult);
            outputString = outputWriter.toString();
        }
        catch (TransformerConfigurationException e)  {
            e.printStackTrace();
        }
        catch (TransformerFactoryConfigurationError e) {
            e.printStackTrace();
        }
        catch (TransformerException e)  {
            e.printStackTrace();
        }
        return outputString ;
    }

    private String getSubject(Document doc, String subjectFormat) {
        String t = "";
        String[] fields = subjectFormat.split(",");

        try {
            Element docEle = doc.getDocumentElement();
            NodeList nl = docEle.getChildNodes();

            for (int j = 0; j < fields.length; j++) {
                if (fields[j].charAt(0) == '<') {
                    String n = fields[j].replace("<", "").replace(">","");

                    for (int i = 0; i < nl.getLength(); i++) {
                        if (nl.item(i).getNodeType() == Node.ELEMENT_NODE) {
                            Element el = (Element) nl.item(i);
                            if (el.getNodeName().equalsIgnoreCase(n)) {
                                t += el.getTextContent();
                                break;
                            }
                        }
                    }
                }
                else {
                    t += fields[j];
                }
            }
        }
        catch (Exception e) {
            log.error("[EMA004] - Unable to build the email subject");
            t = "";
        }
        return t;
    }
}


