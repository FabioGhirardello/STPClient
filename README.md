# STP CLIENT

Version: 2.8
Last update: 2016-02-24

### Java Dependencies:

The app was compiled with Java 1.8.0_65.
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

	application.DB.SWITCH=ON
	application.DB.JDBC_DRIVER=org.sqlite.JDBC
	application.DB.URL=jdbc:sqlite:STPMessages.db
	application.DB.USERNAME=
	application.DB.PASSWORD=


### Email

Optionally, an email can be sent for every new message. If the stylesheet file is creating a XML file, then
you can reformat the body of the email using another stylesheet file, and you can also customize the subject using
as keywords the nodes in the XML message.
You can add an address book with key value pairs to send the email to specific receivers depending on one or more specific factors. 
For example, your address book can look like this:

	1000BRKZ/1000BRKZle=team1@whatnot.com
	1000BRKZ/1000BRKZLE2=team2@whatnot.com

and the email will be sent to the specific team if the key specified in *ADDRESS_BOOK_KEY* matches any key in the address book, 
otherwise it will be sent to the default which is what is set in *TO*.

You can also add a logo image. Below the properties.


	EMAIL.SWITCH=ON
	EMAIL.FROM=stp@integral.com
	EMAIL.TO=fabio@integral.com
	EMAIL.ADDRESS_BOOK=config/AddressBook.txt
	EMAIL.ADDRESS_BOOK_KEY=<OrgID>,/,<OrgLE>
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
Set property *application.WL.SIDE_INDICATOR* to help customize the subject of the email with the direction from the perspective
of the application.WL client. The value to this property should be the field name that indicates the side followed by the indicators
used to identify a buy or a sell (eg: Buy/Sell; B/S; 1/2; etc.). The 3 values should be comma separated (eg:Side,Buy,Sell).
Once this property is configured, adding eg: \<Side\> to the application.WL.SUBJECT will return the direction from the perspective of the
application.WL client. You must set in application.WL.CPTY_ID the node in the XML file that identifies the application.WL client organization.
You are required to set EMAIL.SWITCH to 'ON'.

	application.WL.SWITCH=ON
    application.WL.CPTY_ID=CptyID
    application.WL.STYLESHEET=config/wlEmail.xsl
    application.WL.SUBJECT=<TradeID>, ,<CptyUser>, ,<Side>,s, ,<BaseCcy>,/,<TermCcy>, ,<BaseAmt>, ,<ValueDate>, @ ,<AllInRate>
    application.WL.SIDE_INDICATOR=Side,Buy,Sell
    application.WL.CLIENTS_EMAILS=config/WLClients.txt
    application.WL.IMAGE=config/wlIntegral.jpg


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

	application.QFJ.SWITCH=OFF
	application.QFJ.CONFIG_FILE=config/qfj.properties
	
### Running the app

Below is the command to run the application. This assumes you have all the required libraries in lib/,
and the properties file, the xsl files and a log4j.xml file in config/.

	java -cp lib/* -Dlog4j.configuration=file:config/log4j.xml STPClient config/app.properties


### Logging

Messages can be saved into a separate log file. This is accomplished with the logging utility 'log4j' by setting the proper
appender to the category "MyTrade".
Log4j requires its own configuration file. The category that returns the application logging is 'STPClient'.

### Custom manipulation 

You can write a custom class that creates an instance of STPApplication and manipulates the parsed Document object before it is further processed. 


# CHANGE LOG

### 2.8 (2016-02-24)

- Separated the core code from the main() method into a separate class *STPApplication*.
- Added interface *CustomModification* in the STPApplication class, to allow for modification of the Document object.
- the main() method now creates an object of class *STPApplication* and implements the interfece. By default, the same object is returned - no modification.

# 2.7 (2015-12-14)

- Added Address Book functionality to the application.Email feature.


### 2.6 (2015-06-30)

- Added Thread.sleep() to lower CPU load.

### 2.5 (2015-06-03)

- Incorporated STPConnector.jar into STPClient.jar.

### 2.4 (2015-05-18)

- Added new property *application.WL.IMAGE* to insert a custom image on application.WL emails.
- Added new property *application.WL.SIDE_INDICATOR* to help customize the subject of the email with the direction from the perspective
of the application.WL client. The value to this property should be the field name that indicates the side followed by the indicators
used to identify a buy or a sell (eg: Buy/Sell; B/S; 1/2; etc.). The 3 values should be comma separated (eg:Side,Buy,Sell).
Once this property is configured, adding eg: <Side> to the application.WL.SUBJECT will return the direction from the perspective of the
application.WL client.
- The stylesheet for sending FIX messages uses now parameters to identify the tag, rather than the "field_#" convention (eg: <TradeID_17>).
For example, to send *\<TradeId\>* as tag #17, use *\<TradeId tag="17"\>*.
- Logging configuration file log4j.xml should be updated with the new class names, as follows:
    - *com.integral* --> *application.IBMMQClient* (to grab connection logging and the raw finXML file);
    - *FabSTPClient* --> *STPClient* (to grab all application logging).
- STPClient.jar now features the version in the filename.


### 2.3 (2015-05-14)

- Recompiled *STPConnector.jar* to return a Document object instead of String, thus the stylesheet should return a XML file.
- Renamed *FabSTPClient* to *STPClient*. This is important to launch the app.
- Stylesheet files meant to return plain text should be enclosed in a *\<root\>* node; this is so that the app recognizes 
these Document objects are actually plain text files. An example is *csv.xsl*.
- Renamed properties *EMAIL.TITLE, application.WL.TITLE, FILE.TITLE* to *EMAIL.SUBJECT, application.WL.SUBJECT, FILE.NAME*.
- Added class *application.WriteFile* to separate the function to save the message to an individual file from class STPClient.
