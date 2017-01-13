package application;

import com.ibm.mq.MQEnvironment;
import com.ibm.mq.jms.JMSC;
import com.ibm.mq.jms.MQQueueConnectionFactory;
import org.apache.log4j.Logger;
import javax.jms.*;
import java.util.Enumeration;

public class MQ implements ExceptionListener, MessageListener {

    static Logger log = Logger.getLogger(MQ.class.getSimpleName());
    final private String client;
    private String IP = null;
    private int port = 1000;
    private String channel = null;
    private String queueManager = null;
    private String queueName = null;
    private String username = null;
    private String password = null;
    private String sslCipherSuite = null;

    private QueueConnection connection = null;
    private QueueSession session = null;
    private QueueReceiver queueReceiver = null;

    private static final String DEAL_ID_PROPERTY = "com_integral_message_messageId";

    private OnMessageReceived mMessageListener = null;


    public MQ(String client, String ip, String port, String queue_manager, String queue_name,
              String channel, String username, String password,
              String ssl_cipher_suite,
              OnMessageReceived listener) {

        this.client = client;
        IP = ip;
        if (!port.equalsIgnoreCase("")) {
            this.port = Integer.parseInt(port);
        }
        this.queueManager = queue_manager;
        this.queueName = queue_name;
        this.channel = channel;
        this.username = username;
        this.password = password;
        this.sslCipherSuite = ssl_cipher_suite;

        this.mMessageListener = listener;

    }

    public void login() {
        try {
            // setup SSL if required
            if (sslCipherSuite != null && sslCipherSuite.length() > 0) {
                MQEnvironment.hostname = IP;
                MQEnvironment.channel = channel;
                MQEnvironment.sslCipherSuite = sslCipherSuite;
                log.info(client + " SSL initialized");
            }

            // create connection
            MQQueueConnectionFactory factory = new MQQueueConnectionFactory();

            log.info(client + " Connecting to broker " + IP + ":" + port
                    + "[channel=" + channel + ",queueManager=" + queueManager
                    + ",user=" + username + ",password=" + password
                    + "]...");

            factory.setHostName(IP);
            factory.setPort(port);
            factory.setChannel(channel);
            factory.setQueueManager(queueManager);
            factory.setTransportType(JMSC.MQJMS_TP_CLIENT_MQ_TCPIP);

            if (null == username || username.length() == 0) {
                connection = factory.createQueueConnection();
            }
            else {
                connection = factory.createQueueConnection(username, password);
            }

            log.info(client + " Connection established");

            // start connection
            connection.start();
            log.info(client + " Connection started");

            // register exception handler
            connection.setExceptionListener(this);

            // create session
            session = connection.createQueueSession(false, javax.jms.Session.CLIENT_ACKNOWLEDGE);
            log.info(client + " Session created");

            // create queue
            Queue queue = session.createQueue(queueName);
            log.info(client + " Queue connection established for queue " + queueName);

            // create receiver
            queueReceiver = session.createReceiver(queue);
            log.info(client + " Queue receiver created");

            // register listener
            queueReceiver.setMessageListener(this);
            log.info(client + " Queue listener registered");

        }
        catch (Exception e) {
            log.error(client + "MQ.login: Error connecting to broker",e);
        }
    }

    public void logout() {
        try {
            if (queueReceiver != null) {
                queueReceiver.close();
            }
        }
        catch (Exception e) {
            log.debug(client +  " Error when closing queue receiver", e);
        }

        queueReceiver = null;
        log.info(client + " Queue receiver closed");

        try {
            if (session != null) {
                session.close();
            }
        }
        catch (Exception e) {
            log.debug(client + " Error when closing session", e);
        }

        session = null;
        log.info(client + " Session closed");

        try {
            if (connection != null) {
                connection.stop();
            }
        }
        catch (Exception e) {
            log.debug(client + " Error when stopping connection", e);
        }

        log.info(client + " Connection stopped");

        try {
            if (connection != null) {
                connection.stop();
                connection.close();
            }
        }
        catch (Exception e) {
            log.debug(client + " Error when closing connection", e);
        }

        connection = null;
        log.info(client + " Connection closed");
    }

    /**
     * Called on JMS exception.
     * @param e The exception
     */
    public void onException(JMSException e) {
        log.error(client + " JMS exception received. Reconnecting...", e);

        this.logout();
        this.login();
    }

    /**
     * Called when a new JMS message is received.
     * @param message The message
     */
    public void onMessage(Message message)	{
        if (message instanceof TextMessage) {
            TextMessage textMessage = (TextMessage) message;
            try {
                String finXML = textMessage.getText().replaceAll("(\\r|\\n)", "");

                Enumeration propertyNames = textMessage.getPropertyNames();
                String tradeId = null;
                while (propertyNames.hasMoreElements()) {
                    String prop = (String) propertyNames.nextElement();
                    if (prop.equals(DEAL_ID_PROPERTY)) {
                        tradeId = textMessage.getStringProperty(prop);
                        break;
                    }
                }

                log.info(client + " " + tradeId + " " + finXML);

                mMessageListener.messageReceived(client, tradeId, finXML);
            }
            catch (Exception e) {
                log.warn(client + " Error when extracting text from the JMS message payload.", e);
            }
        }
        else {
            log.debug(client + " Received JMS message <" + message + ">");
        }

        try  {
            message.acknowledge();
        }
        catch (Exception e) {
            log.error(client + " MQ.onMessage: Exception when trying to acknowledge message", e);
        }
    }



    //Declare the interface. The method messageReceived(String message) must be implemented in the MyActivity
    //class at on asynckTask doInBackground
    public interface OnMessageReceived {
        void messageReceived(String client, String tradeID, String message);
    }

}
