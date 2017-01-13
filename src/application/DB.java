package application;//STEP 1. Import required packages

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;


public class DB {
    public static Logger log = Logger.getLogger(DB.class.getSimpleName());

    // JDBC driver name and database URL
    final private String dbUrl;
    //  Database credentials
    final private String username;
    final private String password;

    final private String client;

    public DB(String client, String jdbcDriver, String url, String username, String password) {
        this.client = client;
        this.dbUrl = url;
        this.username = username;
        this.password = password;
        try {
            Class.forName(jdbcDriver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void insert(String tradeID, Document doc){
        String sql = getSQLFromXML(doc);
        try (Connection conn = DriverManager.getConnection(dbUrl, username, password)) {
            try (Statement stmt = conn.createStatement()){
                stmt.executeUpdate(sql);
                log.info(client + " " + tradeID + " - Database record created");
            }
        } catch (SQLException e) {
            log.error(client + " " + "[DB001] " + e.getMessage() + " - SQL query for deal " + tradeID + ": " + sql);
        }
    }


    /* converts the string xml message into a proper xml document
     * then iterates through each node&value forming the final sql query.
     * The root node is the db table name, while each node is a column in the database.
     * Thus the stylesheet needs to be built with the database schema in mind.
     */
    private String getSQLFromXML(Document doc) {
        String root;
        String into = "";
        String values = "";
        String sql = "";
        try {
            Element docEle = doc.getDocumentElement();
            root = docEle.getNodeName();
            NodeList nl = docEle.getChildNodes();
            if (nl != null && nl.getLength() > 0) {
                for (int i = 0; i < nl.getLength(); i++) {
                    if (nl.item(i).getNodeType() == Node.ELEMENT_NODE) {
                        Element el = (Element) nl.item(i);
                        // avoid empty fields
                        if (!el.getTextContent().equals("")) {
                            into = into + el.getNodeName() + ", ";
                            //ensure that strings starts and ends with a '
                            if (isNumeric(el.getTextContent())) {
                                values = values + el.getTextContent() + ", ";
                            }
                            else {
                                values = values + "'" + el.getTextContent() + "', ";
                            }
                        }
                    }
                }
            }
            // remove the last comma
            into = into.substring(0, into.length() -2);
            values  = values.substring(0, values.length() -2);
            // form the final sql query
            sql = "INSERT INTO " + root + "(" + into + ") VALUES (" + values + ");" ;
        }
        catch (Exception e) {
            log.error(client + " " + "[DB005] ", e);
        }
        return sql;
    }

    private static boolean isNumeric(String str)  {
        try {
            Double.parseDouble(str);
        }
        catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }

}


