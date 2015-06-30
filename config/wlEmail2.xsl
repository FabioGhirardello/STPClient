<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="formatDate">
	<xsl:param name="DateTime" />
		<xsl:variable name="year" select="substring($DateTime,1,4)" />
		<xsl:variable name="month" select="substring($DateTime,6,2)" />
		<xsl:variable name="day" select="substring($DateTime,9,2)" />
		<xsl:variable name="hh" select="substring($DateTime,12,2)" />
		<xsl:variable name="mm" select="substring($DateTime,15,2)" />
		<xsl:variable name="ss" select="substring($DateTime,18,2)" />


		<!-- Long DATE FORMAT -->
		<xsl:choose>
			<xsl:when test="$month= '01'">January</xsl:when>
			<xsl:when test="$month= '02'">February</xsl:when>
			<xsl:when test="$month= '03'">March</xsl:when>
			<xsl:when test="$month= '04'">April</xsl:when>
			<xsl:when test="$month= '05'">May</xsl:when>
			<xsl:when test="$month= '06'">June</xsl:when>
			<xsl:when test="$month= '07'">July</xsl:when>
			<xsl:when test="$month= '08'">August</xsl:when>
			<xsl:when test="$month= '09'">September</xsl:when>
			<xsl:when test="$month= '10'">October</xsl:when>
			<xsl:when test="$month= '11'">November</xsl:when>
			<xsl:when test="$month= '12'">December</xsl:when>
		</xsl:choose>
		<xsl:value-of select="' '"/>
		<xsl:value-of select="$day"/>
		<xsl:value-of select="', '"/>
		<xsl:value-of select="$year"/>
		<xsl:value-of select="' @'"/>


		<xsl:value-of select="$hh"/>
		<xsl:value-of select="':'"/>
		<xsl:value-of select="$mm"/>
		<xsl:value-of select="':'"/>
		<xsl:value-of select="$ss"/>

</xsl:template>

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
            <td><xsl:call-template name="formatDate">
				<xsl:with-param name="DateTime" select="TradeExecTimeStamp" />
			</xsl:call-template></td>
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

