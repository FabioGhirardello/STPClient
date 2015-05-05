<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/STPMessage">
  <h1>
    <img src="cid:image"/>
  <body>
    <h2><xsl:value-of select="TradeId"/></h2>
    <table border="1">
      <tr bgcolor="#9acd32">
        <th>Field</th>
        <th>Value</th>
      </tr>
      <xsl:for-each select="*">
      <tr>
        <td><xsl:value-of select="name()"/></td>
        <td><xsl:value-of select="current()"/></td>
      </tr>
      </xsl:for-each>
    </table>
    <h4>Your Commpany name</h4>
    <p>The slogan can go here!</p>
  </body>
  </h1>
</xsl:template>

</xsl:stylesheet>

