package application;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.util.Properties;

public class Email
{
    public static Logger log = Logger.getLogger(Email.class.getSimpleName());
    private Session session;

    final private String from;
    final private String to;
    final private String stylesheet;
    final private String[] addressBookKey;
    final private String[] subjectFields;
    final private String image;
    private Properties prop;

    private String client;

    public Email(String client, String from, String to, String addressBook, String addressBookKey, String host, String port, String username,
                 String password, String auth, String stylesheet, String subjectFields, String image) {

        this.client = client;
        this.from = from;
        this.to = to;
        this.addressBookKey = addressBookKey.split(",");
        this.stylesheet = stylesheet;
        this.subjectFields = subjectFields.split(",");
        this.image = image;

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
            log.error(client + " " + "[EMA003] The property file is not correctly formatted");
        }

        if (!addressBook.equalsIgnoreCase("")) {
            readAddressBook(addressBook);
        }
        else {
            this.prop = null;
        }
    }


    public void send(String tradeID, Document doc) {
        if (this.prop == null) {
            this.send(tradeID, doc, this.to, this.stylesheet, getSubject(doc), this.image);
        }
        else {
            String addressee = prop.getProperty(getAddressBookKey(doc), "");
            if (addressee.equalsIgnoreCase("")){
                this.send(tradeID, doc, this.to, this.stylesheet, getSubject(doc), this.image);
            }
            else {
                this.send(tradeID, doc, addressee, this.stylesheet, getSubject(doc), this.image);
            }
        }
    }

    public void send (String tradeID, Document doc, String to, String stylesheet, String subject, String image) {
        if (!to.equalsIgnoreCase("")) {
            try {
                // Create a default MimeMessage object.
                MimeMessage message = new MimeMessage(this.session);

                // Set From: header field of the header.
                message.setFrom(new InternetAddress(this.from));

                // Set To: header field of the header.
                message.addRecipients(Message.RecipientType.TO, InternetAddress.parse(to));

                // Set Subject: header field
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
                    MimeMultipart mimeMultipart = new MimeMultipart("related");
                    // first part (the html)
                    BodyPart messageBodyPart = new MimeBodyPart();
                    messageBodyPart.setContent(res, "text/html");
                    mimeMultipart.addBodyPart(messageBodyPart);

                    // second part (the image)
                    if (!image.equalsIgnoreCase("")) {
                        messageBodyPart = new MimeBodyPart();
                        DataSource fds = new FileDataSource(image);
                        messageBodyPart.setDataHandler(new DataHandler(fds));
                        messageBodyPart.setHeader("Content-ID", "<image>");
                        // add image to the mimeMultiPart
                        mimeMultipart.addBodyPart(messageBodyPart);
                    }

                    // put everything together
                    message.setContent(mimeMultipart);
                } else {
                    message.setText(STPApp.docToString(doc).replaceAll("><", ">\n<"));
                }

                // Send message
                Transport.send(message);
                log.info(client + " " + tradeID + " - E-mail sent to " + to);
            }
            catch (MessagingException mex) {
                log.error(client + " " + "[EMA001] E-mail failed for deal " + tradeID + ": " + mex.getMessage());
            }
            //catch (Exception e) {
            //  log.error("[EMA002] E-mail failed for deal " + tradeID + ": " + e.getMessage());
            //}
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
        catch (TransformerFactoryConfigurationError | TransformerException e)  {
            e.printStackTrace();
        }
        return outputString ;
    }

    private void readAddressBook(String addressBook) {
        InputStream input = null;
        try {
            prop = new Properties();
            input = new FileInputStream(addressBook);

            // load a properties file
            prop.load(input);
        }
        catch (IOException e) {
            log.error(client + " " + "[EMA003] - Error reading properties file. ", e);
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

    private String getAddressBookKey(Document doc) {
        String addressBookKey = "";
        try {
            NodeList nodeList = doc.getDocumentElement().getChildNodes();

            for (String key : this.addressBookKey) {
                if (key.charAt(0) == '<') {
                    String field = key.replace("<", "").replace(">", "");

                    for (int i = 0; i < nodeList.getLength(); i++) {
                        if (nodeList.item(i).getNodeType() == Node.ELEMENT_NODE) {
                            Element element = (Element) nodeList.item(i);
                            if (element.getNodeName().equalsIgnoreCase(field)) {
                                addressBookKey += element.getTextContent();
                                break;
                            }
                        }
                    }
                } else {
                    addressBookKey += key;
                }
            }
        }
        catch (Exception e) {
            log.error(client + " " + "[EMA005] - Unable to build the AddressBookKey");
            addressBookKey = "";
        }
        return addressBookKey;
    }

    private String getSubject(Document doc) {
        String subject = "";
        try {
            NodeList nodeList = doc.getDocumentElement().getChildNodes();
            for (String f : this.subjectFields) {
                if (f.charAt(0) == '<') {
                    String field = f.replace("<", "").replace(">", "");

                    for (int i = 0; i < nodeList.getLength(); i++) {
                        if (nodeList.item(i).getNodeType() == Node.ELEMENT_NODE) {
                            Element element = (Element) nodeList.item(i);
                            if (element.getNodeName().equalsIgnoreCase(field)) {
                                subject += element.getTextContent();
                                break;
                            }
                        }
                    }
                } else {
                    subject += f;
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


