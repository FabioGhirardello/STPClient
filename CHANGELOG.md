### 2.5 (2015-06-03)

- Incorporated STPConnector.jar into STPClient.jar.

### 2.4 (2015-05-18)

- Added new property *WL.IMAGE* to insert a custom image on WL emails.
- Added new property *WL.SIDE_INDICATOR* to help customize the subject of the email with the direction from the perspective
of the WL client. The value to this property should be the field name that indicates the side followed by the indicators 
used to identify a buy or a sell (eg: Buy/Sell; B/S; 1/2; etc.). The 3 values should be comma separated (eg:Side,Buy,Sell).
Once this property is configured, adding eg: <Side> to the WL.SUBJECT will return the direction from the perspective of the 
WL client.
- The stylesheet for sending FIX messages uses now parameters to identify the tag, rather than the "field_#" convention (eg: <TradeID_17>).
For example, to send *\<TradeId\>* as tag #17, use *\<TradeId tag="17"\>*.
- Logging configuration file log4j.xml should be updated with the new class names, as follows:
    - *com.integral* --> *IBMMQClient* (to grab connection logging and the raw finXML file);
    - *FabSTPClient* --> *STPClient* (to grab all application logging).
- STPClient.jar now features the version in the filename.


### 2.3 (2015-05-14)

- Recompiled *STPConnector.jar* to return a Document object instead of String, thus the stylesheet should return a XML file.
- Renamed *FabSTPClient* to *STPClient*. This is important to launch the app.
- Stylesheet files meant to return plain text should be enclosed in a *\<root\>* node; this is so that the app recognizes 
these Document objects are actually plain text files. An example is *csv.xsl*.
- Renamed properties *EMAIL.TITLE, WL.TITLE, FILE.TITLE* to *EMAIL.SUBJECT, WL.SUBJECT, FILE.NAME*.
- Added class *WriteFile* to separate the function to save the message to an individual file from class STPClient.
