2.3 - Recompiled STPConnector.jar to return a Document object instead of String,
      thus the stylesheet should return a XML file.
      Stylesheet files meant to return plain text should be enclosed in a <root> element; this is so that
      the app recognizes these Document objects are actually plain text files. An example of is 'csv.xsl'.
      Renamed properties EMAIL.TITLE, WL.TITLE, FILE.TITLE to EMAIL.SUBJECT, WL.SUBJECT, FILE.NAME.
      Added class WriteFile to separate the function to save the message to an individual file from class STPClient.
