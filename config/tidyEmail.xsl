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

</xsl:template>

<xsl:template match="/STPMessage">

<body style="font-family:Verdana; font-size: 11px; margin-left: 50px; margin-top: 25px;">

<img src="cid:image"/>

    <h5>The following trade has been executed between <xsl:value-of select="OrgID"/> and <xsl:value-of select="CptyID"/></h5>

    <!-- if the deal is a FXSpot or FXOutright -->
		<xsl:if test="Type = 'FXSpot' or Type = 'FXOutright'">

        <table border="0" style="text-align: left; font-family:Verdana; font-size: 11px;">
	        <tr>
	          <th></th>
	          <th></th>
	        </tr>

	          <tr>
	            <td style="width: 150px;">Trade ID</td>
	            <td style="color: #000066;">: <xsl:value-of select="TradeId"/></td>
	          </tr>
	        <tr>
	          <td>Order ID</td>
	          <td style="color: #000066;">: <xsl:value-of select="OrderID"/></td>
	        </tr>
	        <tr>
	          <td>Platform Type</td>
	          <td style="color: #000066;">: <xsl:value-of select="WorkflowChannel"/></td>
	        </tr>
	        <tr>
	          <td>Organization</td>
	          <td style="color: #000066;">: <xsl:value-of select="OrgID"/></td>
	        </tr>
	        <tr>
	          <td>Org Legal Entity</td>
	          <td style="color: #000066;">: <xsl:value-of select="OrgLE"/></td>
	        </tr>
	        <tr>
	          <td>Org Trader</td>
	          <td style="color: #000066;">: <xsl:value-of select="OrgUser"/></td>
	        </tr>
	        <tr>
	           <td>Role</td>
	           <td style="color: #000066;">: <xsl:value-of select="Role"/></td>
	        </tr>
	   <tr>
	        <td>TradeDate</td>
	        <td style="color: #000066;">: <xsl:call-template name="formatDate">
	                 <xsl:with-param name="DateTime" select="TradeDate" />
				</xsl:call-template></td>
	    </tr>
	    <tr>
	        <td>Value Date</td>
	        <td style="color: #000066;">: <xsl:call-template name="formatDate">
		         <xsl:with-param name="DateTime" select="ValueDate" />
				</xsl:call-template></td>
	    </tr>
	        <tr>
	              <td>Execution Date/Time</td>
	              <td style="color: #000066;">: <xsl:value-of select="TradeExecTimeStamp"/></td>
	        </tr>
	        <tr>
	            <td>Trade Type</td>
	            <td style="color: #000066;">: <xsl:value-of select="Type"/></td>
	        </tr>
	        <tr>
	            <td>Currency Pair</td>
	            <td style="color: #000066;">: <xsl:value-of select="BaseCcy"/>/<xsl:value-of select="TermCcy"/></td>
	        </tr>
	        <tr>
	            <td>Dealt Currency</td>
	            <td style="color: #000066;">: <xsl:value-of select="Dealt"/></td>
	        </tr>

			<xsl:choose><xsl:when test="Side = 'Buy'">
				<tr>
				<td>Buy</td><td style="color: #000066;">: <xsl:value-of select="concat(BaseCcy,' ',format-number(BaseAmt,'$#,##0.00'))"/></td>
				</tr>
				<tr>
				<td>Sell</td><td style="color: #000066;">: <xsl:value-of select="concat(TermCcy,' ',format-number(TermAmt,'$#,##0.00'))"/></td>
				</tr></xsl:when>
			<xsl:otherwise>
				<tr>
				<td>Sell</td><td style="color: #000066;">: <xsl:value-of select="concat(BaseCcy,' ',format-number(BaseAmt,'$#,##0.00'))"/></td>
				</tr>
				<tr>
				<td>Buy</td><td style="color: #000066;">: <xsl:value-of select="concat(TermCcy,' ',format-number(TermAmt,'$#,##0.00'))"/></td>
				</tr></xsl:otherwise>
			</xsl:choose>



	        <xsl:if test="Type = 'FXOutright'">
	        <tr>
	          <td>Spot Rate</td>
	          <td style="color: #000066;">: <xsl:value-of select="SpotRate"/></td>
	        </tr>
	        <tr>
	          <td>Fwd Points</td>
	          <td style="color: #000066;">: <xsl:value-of select="FwdPoints"/></td>
	        </tr>
	        </xsl:if>
			<tr>
			  <td>All In Rate</td>
			  <td style="color: #000066;">: <xsl:value-of select="AllInRate"/></td>
	        </tr>



	        <xsl:if test="Role = 'Maker'">
	         	<tr/>
				<tr>
				<td>Stream Spread</td>
				<xsl:choose><xsl:when test="Type = 'FXSpot'">
					<td style="color: #000066;">: <xsl:value-of select="Sprd_PM_Spot"/></td></xsl:when>
				<xsl:otherwise>
					<td style="color: #000066;">: <xsl:value-of select="Sprd_PM_Fwd"/></td></xsl:otherwise>
				</xsl:choose>
	        	</tr>
				<tr>
				<td>Sales Spread</td>
				<td style="color: #000066;">: <xsl:value-of select="Sprd_PP_Total"/></td>
				</tr>
				<tr/>
			</xsl:if>

	        <tr>
	           <td>Counterparty</td>
	           <td style="color: #000066;">: <xsl:value-of select="CptyID"/></td>
	        </tr>
	        <tr>
	           <td>Counterparty Account</td>
	           <td style="color: #000066;">: <xsl:value-of select="CptyLE"/></td>
	        </tr>
	        <tr>
	          <td>Counterparty User</td>
	          <td style="color: #000066;">: <xsl:value-of select="CptyUser"/></td>
	        </tr>
	        <tr>
	          <td>UTI</td>
	          <td style="color: #000066;">: <xsl:value-of select="UTI"/></td>
	        </tr>


	        <tr>
	        <xsl:choose><xsl:when test="Role = 'Maker'">
				<td>Offsetting Trade</td>
				<td style="color: #000066;">: <xsl:value-of select="CoverTradesID"/></td></xsl:when>
			<xsl:otherwise>
				<td>Originating Trade</td>
				<td style="color: #000066;">: <xsl:value-of select="CoveredTradeID"/></td></xsl:otherwise>
   			</xsl:choose>
	        </tr>



	        <tr>
		  <td>Trade Status</td>
		  <td style="color: #000066;">: <xsl:value-of select="Status"/></td>
	        </tr>
	        <tr>
		  <td>Order Notes</td>
		  <td style="color: #000066;">: <xsl:value-of select="OrderNotes"/></td>
		</tr>

  </table>

	</xsl:if>






 <!-- if the deal is a FXSpotFwd or a FXFwdFwd -->
 	<xsl:if test="Type = 'FXSpotFwd' or Type = 'FXFwdFwd'">



    <table border="0" style="text-align: left; font-family:Verdana; font-size: 11px;">
        <tr>
          <th></th>
          <th></th>
        </tr>

          <tr>
            <td style="width: 150px;">Trade ID</td>
            <td style="color: #000066;">: <xsl:value-of select="TradeId"/></td>
          </tr>
        <tr>
          <td>Order ID</td>
          <td style="color: #000066;">: <xsl:value-of select="OrderID"/></td>
        </tr>
        <tr>
          <td>Platform Type</td>
          <td style="color: #000066;">: <xsl:value-of select="WorkflowChannel"/></td>
        </tr>
        <tr>
          <td>Organization</td>
          <td style="color: #000066;">: <xsl:value-of select="OrgID"/></td>
        </tr>
        <tr>
          <td>Org Legal Entity</td>
          <td style="color: #000066;">: <xsl:value-of select="OrgLE"/></td>
        </tr>
        <tr>
          <td>Org Trader</td>
          <td style="color: #000066;">: <xsl:value-of select="OrgUser"/></td>
        </tr>
        <tr>
           <td>Role</td>
           <td style="color: #000066;">: <xsl:value-of select="Role"/></td>
        </tr>
   <tr>
        <td>TradeDate</td>
        <td style="color: #000066;">: <xsl:call-template name="formatDate">
                 <xsl:with-param name="DateTime" select="TradeDate" />
			</xsl:call-template></td>
    </tr>

        <tr>
              <td>Execution Date/Time</td>
              <td style="color: #000066;">: <xsl:value-of select="TradeExecTimeStamp"/></td>
        </tr>
        <tr>
            <td>Trade Type</td>
            <td style="color: #000066;">: <xsl:value-of select="Type"/></td>
        </tr>
        <tr>
            <td>Currency Pair</td>
            <td style="color: #000066;">: <xsl:value-of select="BaseCcy"/>/<xsl:value-of select="TermCcy"/></td>
        </tr>
        <tr>
		  <td>Reference Spot Rate</td>
		  <td style="color: #000066;">: <xsl:value-of select="SpotRate"/></td>
		</tr>


        <tr>
        <td>Dealt Currency</td>
        <td style="color: #000066;">: <xsl:value-of select="Dealt"/></td>
        </tr>

        <tr/>


        <xsl:choose><xsl:when test="Side = 'Buy'">
			<tr>
			<td>Near Buy</td><td style="color: #000066;">: <xsl:value-of select="concat(BaseCcy,' ',format-number(BaseAmt,'$#,##0.00'))"/></td>
			</tr>
			<tr>
			<td>Near Sell</td><td style="color: #000066;">: <xsl:value-of select="concat(TermCcy,' ',format-number(TermAmt,'$#,##0.00'))"/></td>
			</tr></xsl:when>
		<xsl:otherwise>
			<tr>
			<td>Near Sell</td><td style="color: #000066;">: <xsl:value-of select="concat(BaseCcy,' ',format-number(BaseAmt,'$#,##0.00'))"/></td>
			</tr>
			<tr>
			<td>Near Buy</td><td style="color: #000066;">: <xsl:value-of select="concat(TermCcy,' ',format-number(TermAmt,'$#,##0.00'))"/></td>
			</tr></xsl:otherwise>
		</xsl:choose>


    	<tr>
			<td>Near Value Date</td>
			<td style="color: #000066;">: <xsl:call-template name="formatDate">
			 <xsl:with-param name="DateTime" select="ValueDate" />
			</xsl:call-template></td>
    	</tr>
        <tr>
          <td>Near Tenor</td>
          <td style="color: #000066;">: <xsl:value-of select="Tenor"/></td>
        </tr>


        <tr>
          <td>Near Fwd Points</td>
          <td style="color: #000066;">: <xsl:value-of select="FwdPoints"/></td>
        </tr>
        <tr>
          <td>Near All In Rate</td>
          <td style="color: #000066;">: <xsl:value-of select="AllInRate"/></td>
        </tr>

		<tr/>

		<xsl:choose><xsl:when test="Side = 'Buy'">
			<tr>
			<td>Far Sell</td><td style="color: #000066;">: <xsl:value-of select="concat(BaseCcy,' ',format-number(FarBaseAmt,'$#,##0.00'))"/></td>
			</tr>
			<tr>
			<td>Far Buy</td><td style="color: #000066;">: <xsl:value-of select="concat(TermCcy,' ',format-number(FarTermAmt,'$#,##0.00'))"/></td>
			</tr></xsl:when>
		<xsl:otherwise>
			<tr>
			<td>Far Buy</td><td style="color: #000066;">: <xsl:value-of select="concat(BaseCcy,' ',format-number(FarBaseAmt,'$#,##0.00'))"/></td>
			</tr>
			<tr>
			<td>Far Sell</td><td style="color: #000066;">: <xsl:value-of select="concat(TermCcy,' ',format-number(FarTermAmt,'$#,##0.00'))"/></td>
			</tr></xsl:otherwise>
		</xsl:choose>

    	<tr>
		<td>Far Value Date</td>
		<td style="color: #000066;">: <xsl:call-template name="formatDate">
			 <xsl:with-param name="DateTime" select="FarValueDate" />
			</xsl:call-template></td>
    	</tr>
        <tr>
          <td>Far Tenor</td>
          <td style="color: #000066;">: <xsl:value-of select="FarTenor"/></td>
        </tr>


        <tr>
          <td>Far Fwd Points</td>
          <td style="color: #000066;">: <xsl:value-of select="FarFwdPoints"/></td>
        </tr>
        <tr>
          <td>Far All In Rate</td>
          <td style="color: #000066;">: <xsl:value-of select="FarAllInRate"/></td>
        </tr>


<tr/>

		<xsl:if test="Role = 'Maker'">
        <tr>
           <td>Sales Spread</td>
           <td style="color: #000066;">: <xsl:value-of select="Sprd_PP_Total"/></td>
        </tr>
        <tr/>
        </xsl:if>


        <tr>
           <td>Counterparty</td>
           <td style="color: #000066;">: <xsl:value-of select="CptyID"/></td>
        </tr>
        <tr>
           <td>Counterparty Account</td>
           <td style="color: #000066;">: <xsl:value-of select="CptyLE"/></td>
        </tr>
        <tr>
          <td>Counterparty User</td>
          <td style="color: #000066;">: <xsl:value-of select="CptyUser"/></td>
        </tr>
        <tr>
          <td>Near UTI</td>
          <td style="color: #000066;">: <xsl:value-of select="UTI"/></td>
        </tr>
		<tr>
		  <td>Far UTI</td>
		  <td style="color: #000066;">: <xsl:value-of select="FarUTI"/></td>
        </tr>
	        <tr>
	        <xsl:choose>
				<xsl:when test="Role = 'Maker'">
			<td>Offsetting Trade</td>
			<td style="color: #000066;">: <xsl:value-of select="CoverTradesID"/></td></xsl:when>
			<xsl:otherwise>
			<td>Originating Trade</td>
			<td style="color: #000066;">: <xsl:value-of select="CoveredTradeID"/></td></xsl:otherwise>
   			</xsl:choose>
	        </tr>
        <tr>
	  <td>Trade Status</td>
	  <td style="color: #000066;">: <xsl:value-of select="Status"/></td>
        </tr>
        <tr>
	  <td>Order Notes</td>
	  <td style="color: #000066;">: <xsl:value-of select="OrderNotes"/></td>
	</tr>

  </table>

  </xsl:if>

    	<p>If you have any questions regarding this email, please contact the Integral FX Team.</p>
   	<p style="color: #666;"><b>Integral FX Support</b><br />
   	 Email: <a href="mailto:support@integral.com">support@integral.com </a><br />
    	Tel: +1.212.252.2243<br />
	Toll Free: +1.212.252.2243</p>
  </body>



</xsl:template>

</xsl:stylesheet>

