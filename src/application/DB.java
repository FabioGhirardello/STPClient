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
    public static Logger log = Logger.getLogger("STPClient");

    // JDBC driver name and database URL
    private String jdbcDriver;
    private String dbUrl;
    //  Database credentials
    private String username;
    private String password;

    public DB(String jdbcDriver, String url, String username, String password) {
        this.jdbcDriver = jdbcDriver;
        this.dbUrl = url;
        this.username = username;
        this.password = password;
    }

    public void insert(String tradeID, Document doc) {
        String sql = getSQLFromXML(doc);
        Connection conn = null;
        Statement stmt = null;
        try{
            //STEP 2: Register JDBC driver
            Class.forName(jdbcDriver);
            // I prefer to test conn is up and running by executing the sql query.
            // http://stackoverflow.com/questions/7764671/java-jdbc-connection-status
            //STEP 3: Open a connection
             conn = DriverManager.getConnection(dbUrl, username, password);

            //STEP 4: Execute a query
            stmt = conn.createStatement();

            stmt.executeUpdate(sql);
            log.info(tradeID + " - Database record created");
        }
        catch(SQLException e) {
            //Handle errors for JDBC
            log.error("[DB001] " + e.getMessage() + " - SQL query for deal " + tradeID + ": " + sql);
        }
        catch(Exception e) {
            //Handle errors for Class.forName
            log.error("[DB002] " + e.getMessage() + " - SQL query for deal " + tradeID + ": " + sql);
        }
        finally {
            //finally block used to close resources
            try {
                if(stmt!=null) {stmt.close();}
                if(conn!=null) {conn.close();}
            }
            catch(SQLException se) {
                // do nothing
            }
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
            log.error("[DB005] ", e);
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


