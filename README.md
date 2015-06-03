# STP CLIENT

Version: 2.5
Last update: 2015-06-03

### Java Dependencies:

The app was compiled with Java 1.7.
If you plan to insert deals into a database, ensure the JRE and database have the same architecture (32/64 bits).

Main jars: 
- STPClient.jar,
- com.ibm.mq.jar,
- com.ibm.mqjms.jar,
- jbossall-client.jar,

Enable emails:
- activation.jar,
- mail.jar,

Logging utility: 
- log4j.jar,

ODBC Driver, as required:
- sqlite-jdbc-3.7.2.jar,

QuickFix/J:
- mina-core-1.1.7.jar
- mina-filter-ssl-1.1.7.jar
- proxool-0.9.1.jar
- quickfixj-all-1.5.3.jar
- sleepycat-je_2.1.30.jar
- slf4j-api-1.6.3.jar
- slf4j-log4j12-1.6.3.jar


### Queue Connection and XSLT

This application connects to the IBM MQ queue and automatically downloads the messages. The details of the connection need
to be set in the properties file. The same property file will be used to configure all options described below.

The message downloaded is a special XML file called FinXML; once downloaded, the FinXML file is transformed into 
another format using XSLT (http://www.w3schools.com/xsl/).
XSLT requires a stylesheet file; the stylesheet file informs the XSLTransformer how the new file should look like. 
For example, tidyXml.xsl will create a nicer and simpler xml file, while csv.xsl will create a comma separated line.

These are the properties. You need to set the Stylesheet, while the other properties will be provided by Integral.

	STP.STYLESHEET=config/tidyXml.xsl
	STP.IP=xxx.xxx.xxx.xxx
	STP.PORT=yyyy
	STP.QUEUE_MANAGER=
	STP.QUEUE_NAME=XXX.PROD.QUEUE
	STP.CHANNEL=XXXX.PROD.CHANNEL
	STP.USERNAME=
	STP.PASSWORD=
	STP.CERT_NAME=
	STP.SSL_CIPHER_SUITE=


### Database Connection

Optionally, and only if the XSLT creates an xml file with just 1 level of depth - like tidyXml.xsl does -, the message
can be saved to a database via the standard ODBC/JDBC connection properties.

The stylesheet must be written with the database schema in mind: the application will use the output 
xml file from the XSL Transformation as input for the SQL query, for example, say the XSLT file outputs:

	<myMessage>
		<dealid>FXI123456789</dealid>
		<tradedate>2014-10-07</tradedate>
		<rate>1.65897</rate>
	</myMessage>

Then the sql query will be:

	INSERT INTO myMessage (dealid, tradedate, rate) VALUES ('FXI123456789', '2014-10-07', 1.65897);


Relevant properties are below. These are the standard ODBC connection details.

	DB.SWITCH=ON
	DB.JDBC_DRIVER=org.sqlite.JDBC
	DB.URL=jdbc:sqlite:STPMessages.db
	DB.USERNAME=
	DB.PASSWORD=


### Email

Optionally, an email can be sent for every new message. If the stylesheet file is creating a XML file, then
you can reformat the body of the email using another stylesheet file, and you can also customize the subject using
as keywords the nodes in the XML message.
You can also add a logo image. Below the properties.


	EMAIL.SWITCH=ON
	EMAIL.FROM=stp@integral.com
	EMAIL.TO=fabio@integral.com
	EMAIL.HOST=out.int.com
	EMAIL.PORT=25
	EMAIL.AUTH=FALSE
	EMAIL.USERNAME=
	EMAIL.PASSWORD=
	EMAIL.STYLESHEET=config/tidyEmail.xsl
	EMAIL.SUBJECT=<TradeID>, ,<OrgID>, ,<BuySell>, ,<BaseCcy>,/,<TermCcy>, ,<BaseAmt>, ,<ValueDate>, vs ,<CptyID>, @ ,<AllInRate>
	EMAIL.IMAGE=config/integral.jpg

### White Label Email

In addition, you can send an email to the counterparty. You will require a file with key-value pairs for the email 
addresses. An example is below; the key is the Counterparty ID:

	8000BRKZ=treasury@bigbank.com
    1000BRKZ=joe@abcbank.com,sue@abcbank.com

You can specify a custom stylesheet, image and subject so that the deal is from the client's perspective. 
Set property *WL.SIDE_INDICATOR* to help customize the subject of the email with the direction from the perspective
of the WL client. The value to this property should be the field name that indicates the side followed by the indicators 
used to identify a buy or a sell (eg: Buy/Sell; B/S; 1/2; etc.). The 3 values should be comma separated (eg:Side,Buy,Sell).
Once this property is configured, adding eg: \<Side\> to the WL.SUBJECT will return the direction from the perspective of the
WL client. You must set in WL.CPTY_ID the node in the XML file that identifies the WL client organization.
You are required to set EMAIL.SWITCH to 'ON'.

	WL.SWITCH=ON
    WL.CPTY_ID=CptyID
    WL.STYLESHEET=config/wlEmail.xsl
    WL.SUBJECT=<TradeID>, ,<CptyUser>, ,<Side>,s, ,<BaseCcy>,/,<TermCcy>, ,<BaseAmt>, ,<ValueDate>, @ ,<AllInRate>
    WL.SIDE_INDICATOR=Side,Buy,Sell
    WL.CLIENTS_EMAILS=config/WLClients.txt
    WL.IMAGE=config/wlIntegral.jpg


### Save individual deals to a file

Optionally, you can save each deal to an individual file. You can use specific keywords (Date, TradeID
and Counter) to customize the file name.
The counter reset every day and starts at 0 if not specified. To enable the counter, you must specify the file location.

	FILE.SWITCH=ON
	FILE.PATH=C:/Users/ghirardellof/IdeaProjects/STPclient
	FILE.DATE_FORMAT=yyyyMMdd_HHmmss
	FILE.COUNTER=config/counter
	FILE.NAME=<TradeID>,.,<Date>,.xml

### FIX messaging

You can convert the FinXML message into a FIX message. The stylesheet must output a file with parameter 'tag'.
Example output file:

	<myMessage>
		<TradeId tag="17">FXI123456789</TradeId>
		<TradeDate tag="64">2014-10-07</TradeDate>
		<AllInRate tag="44">1.65897</AllInRate>
	</myMessage>

Then the FIX message TradeCaptureReport (AE) will output something like this:

	[...]|17=FXI123456789|64=2014-10-07|44=1.65897|[...]
	
The FIX configuration file is a separate file whose location needs to be specified in the properties. 

	QFJ.SWITCH=OFF
	QFJ.CONFIG_FILE=config/qfj.properties
	

### Running the app

Below is the command to run the application. This assumes you have all the required libraries in lib/,
and the properties file, the xsl files and a log4j.xml file in config/.

	java -cp lib/* -Dlog4j.configuration=file:config/log4j.xml STPClient config/app.properties


### Logging

Messages can be saved into a separate log file. This is accomplished with the logging utility 'log4j' by setting the proper
appender to the category "MyTrade".
Log4j requires its own configuration file. The category that returns the application logging is 'STPClient'.