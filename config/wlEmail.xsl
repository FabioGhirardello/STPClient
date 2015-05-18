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

            <tr>
              <td>TradeId</td>
              <td><xsl:value-of select="TradeId"/></td>
            </tr>
          <tr>
            <td>Type</td>
            <td><xsl:value-of select="Type"/></td>
          </tr>
          <tr>
            <td>OrderID</td>
            <td><xsl:value-of select="OrderID"/></td>
          </tr>
          <tr>
            <td>TimeStamp</td>
            <td><xsl:value-of select="TradeExecTimeStamp"/></td>
          </tr>
          <tr>
            <td>TradeDate</td>
            <td><xsl:value-of select="TradeDate"/></td>
          </tr>
          <tr>
            <td>Side</td>



          <xsl:choose>
            <xsl:when test="Side = 'Buy'">
              <td>Sell</td></xsl:when>
            <xsl:otherwise>
              <td>Buy</td></xsl:otherwise>
          </xsl:choose>

          </tr>


          <tr>
            <td>BaseCcy</td>
            <td><xsl:value-of select="BaseCcy"/></td>
          </tr>
          <tr>
            <td>TermCcy</td>
            <td><xsl:value-of select="TermCcy"/></td>
          </tr>
          <tr>
            <td>Dealt</td>
            <td><xsl:value-of select="Dealt"/></td>
          </tr>
          <tr>
            <td>BaseAmt</td>
            <td><xsl:value-of select="BaseAmt"/></td>
          </tr>
          <tr>
            <td>TermAmt</td>
            <td><xsl:value-of select="TermAmt"/></td>
          </tr>
          <tr>
            <td>ValueDate</td>
            <td><xsl:value-of select="ValueDate"/></td>
          </tr>
          <tr>
            <td>Tenor</td>
            <td><xsl:value-of select="Tenor"/></td>
          </tr>
          <tr>
            <td>AllInRate</td>
            <td><xsl:value-of select="AllInRate"/></td>
          </tr>
          <tr>
            <td>SpotRate</td>
            <td><xsl:value-of select="SpotRate"/></td>
          </tr>
          <tr>
            <td>FwdPoints</td>
            <td><xsl:value-of select="FwdPoints"/></td>
          </tr>
          <tr>
            <td>MidRate</td>
            <td><xsl:value-of select="MidRate"/></td>
          </tr>
          <tr>
            <td>OrgID</td>
            <td><xsl:value-of select="CptyID"/></td>
          </tr>
          <tr>
            <td>OrgLE</td>
            <td><xsl:value-of select="CptyLE"/></td>
          </tr>
          <tr>
            <td>OrgUser</td>
            <td><xsl:value-of select="CptyUser"/></td>
          </tr>
          <tr>
            <td>CptyID</td>
            <td><xsl:value-of select="OrgID"/></td>
          </tr>
          <tr>
            <td>UTI</td>
            <td><xsl:value-of select="UTI"/></td>
          </tr>


        </table>
        <h4>Concentra Financial</h4>
        <p>A Credit Union Company</p>
      </body>
    </h1>
  </xsl:template>

</xsl:stylesheet>

