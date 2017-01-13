<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				exclude-result-prefixes="xsi"
				version="1.0">

	<xsl:output method="html" indent="no"/>
	<xsl:template match="/">

<root>
	<xsl:text>TradeId,Type,LegalEntityRole,OrgId,OriginatingCpty,OriginatingUser,OriginatingOrderID,CptyOrg,OrderID,WorkflowChannel,TradeExecTimeStamp,TradeDate,BuySell,BaseCcy,TermCcy,SpotRate,LegalEntity,Dealer,Cpty,CptyUser,CoveredTradeID,CoverTradesID,Stream,UPI,Dealt,BaseAmt,TermAmt,ValueDate,Tenor,Rate,FwdPoints,MidRate,UTI,NearDealt,NearBaseAmt,NearTermAmt,NearValueDate,NearTenor,NearSpotDate,NearFwdPoints,NearRate,NearMidRateSpot,NearMidRateFwdPoints,NearMidRate,FarDealt,FarBaseAmt,FarTermAmt,FarValueDate,FarTenor,FarSpotDate,FarFwdPoints,FarRate,FarMidRateSpot,FarMidRateFwdPoints,FarMidRate,NearUTI,FarUTI,NearUSI,FarUSI</xsl:text>
	<!-- add a newline character -->
	<xsl:text>&#xa;</xsl:text>

	<!-- fields common to both nodes <fxSingleLeg> and <fxSwap> -->
	<!-- TradeId -->				<xsl:value-of select="workflowMessage/entityReference/transactionId"/><xsl:text>,</xsl:text>
	<!-- Type -->					<xsl:value-of select="workflowMessage/parameter[1]"/><xsl:text>,</xsl:text>
	<!-- LegalEntityRole -->		<xsl:value-of select="workflowMessage/parameter[3]"/><xsl:text>,</xsl:text>
	<!-- OrgId -->					<xsl:value-of select="/workflowMessage/to/shortName"/><xsl:text>,</xsl:text>
	<!-- OriginatingCpty -->		<xsl:value-of select="/workflowMessage/parameter[2]"/><xsl:text>,</xsl:text>
	<!-- OriginatingUser -->		<xsl:value-of select="/workflowMessage/parameter[4]"/><xsl:text>,</xsl:text>
	<!-- OriginatingOrderID -->		<xsl:value-of select="/workflowMessage/entityProperty/request/externalRequestId"/><xsl:text>,</xsl:text>
	<!-- CptyOrg -->				<xsl:value-of select="/workflowMessage/entityProperty/request/toOrganization/shortName"/><xsl:text>,</xsl:text>



	<!-- fields common to both nodes <fxSingleLeg> and <fxSwap> but located in different paths -->

	<!-- if the deal is a FXSpot or FXOutright, the data is in the <fxSingleLeg> node -->
	<xsl:if test="workflowMessage/parameter[1] = 'FXSpot' or workflowMessage/parameter[1] = 'FXOutright'">
		<!-- OrderID -->			<xsl:value-of select="workflowMessage/fxSingleLeg/@orderId"/><xsl:text>,</xsl:text>
		<!-- WorkflowChannel -->	<xsl:value-of select="/workflowMessage/fxSingleLeg/channel"/><xsl:text>,</xsl:text>
		<!-- TradeExecTimeStamp -->	<xsl:value-of select="concat(substring(/workflowMessage/fxSingleLeg/entryDateTime,0,11),'T', substring(/workflowMessage/fxSingleLeg/entryDateTime,12,8))"/><xsl:text>,</xsl:text>
		<!-- TradeDate -->			<xsl:value-of select="/workflowMessage/fxSingleLeg/tradeDate"/><xsl:text>,</xsl:text>
		<!-- BuySell -->
		<xsl:choose>
			<xsl:when test="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/legalEntityBuysBase = 'true'">
				<xsl:text>Buy</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Sell</xsl:text>
			</xsl:otherwise>
		</xsl:choose><xsl:text>,</xsl:text>
		<!-- BaseCcy -->			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/baseCurrency"/><xsl:text>,</xsl:text>
		<!-- TermCcy -->			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/variableCurrency"/><xsl:text>,</xsl:text>
		<!-- SpotRate -->			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/spotRate"/><xsl:text>,</xsl:text>
		<!-- LegalEntity -->		<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntity"/><xsl:text>,</xsl:text>
		<!-- Dealer -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser"/><xsl:text>,</xsl:text>
		<!-- Cpty -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingParty"/><xsl:text>,</xsl:text>
		<!-- CptyUser -->			<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingPartyUser"/><xsl:text>,</xsl:text>
		<!-- CoveredTradeID -->		<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coveredTrade"/><xsl:text>,</xsl:text>
		<!-- CoverTradesID -->		<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coverTrade"/><xsl:text>,</xsl:text>
		<!-- Stream -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/streamLP"/><xsl:text>,</xsl:text>
		<!-- UPI -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/@UPI"/><xsl:text>,</xsl:text>

	</xsl:if>

	<!-- if the deal is a FXSpotFwd or a FXFwdFwd, the data is in the <fxSwap> node and there are 2 legs -->
	<xsl:if test="workflowMessage/parameter[1] = 'FXSpotFwd' or workflowMessage/parameter[1] = 'FXFwdFwd'">

		<!-- OrderID -->			<xsl:value-of select="workflowMessage/fxSwap/@orderId"/><xsl:text>,</xsl:text>
		<!-- WorkflowChannel -->	<xsl:value-of select="/workflowMessage/fxSwap/channel"/><xsl:text>,</xsl:text>
		<!-- TradeExecTimeStamp -->	<xsl:value-of select="concat(substring(/workflowMessage/fxSwap/entryDateTime,0,11),'T', substring(/workflowMessage/fxSwap/entryDateTime,12,8))"/><xsl:text>,</xsl:text>
		<!-- TradeDate -->			<xsl:value-of select="/workflowMessage/fxSwap/tradeDate"/><xsl:text>,</xsl:text>
		<!-- BuySell -->
		<xsl:choose>
			<xsl:when test="/workflowMessage/fxSwap/nearLeg/fxPayment/legalEntityBuysBase = 'true'">
				<xsl:text>Buy</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Sell</xsl:text>
			</xsl:otherwise>
		</xsl:choose><xsl:text>,</xsl:text>
		<!-- BaseCcy -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/baseCurrency"/><xsl:text>,</xsl:text>
		<!-- TermCcy -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/variableCurrency"/><xsl:text>,</xsl:text>
		<!-- SpotRate -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/spotRate"/><xsl:text>,</xsl:text>
		<!-- LegalEntity -->		<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntity"/><xsl:text>,</xsl:text>
		<!-- Dealer -->				<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntityUser"/><xsl:text>,</xsl:text>
		<!-- Cpty -->				<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingParty"/><xsl:text>,</xsl:text>
		<!-- CptyUser -->			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingPartyUser"/><xsl:text>,</xsl:text>
		<!-- CoveredTradeID -->		<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coveredTrade"/><xsl:text>,</xsl:text>
		<!-- CoverTradesID -->		<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coverTrade"/><xsl:text>,</xsl:text>
		<!-- Stream -->				<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/streamLP"/><xsl:text>,</xsl:text>
		<!-- UPI -->				<xsl:value-of select="/workflowMessage/fxSwap/@UPI"/><xsl:text>,</xsl:text>
	</xsl:if>





	<!-- all fields in node <fxSingleLeg> -->
	<!-- Dealt -->					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/dealtCurrency"/><xsl:text>,</xsl:text>
	<!-- BaseAmt -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/baseCurrencyAmount"/><xsl:text>,</xsl:text>
	<!-- TermAmt -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/termCurrencyAmount"/><xsl:text>,</xsl:text>
	<!-- ValueDate -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/valueDate"/><xsl:text>,</xsl:text>
	<!-- Tenor -->					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/tenor"/><xsl:text>,</xsl:text>
	<!-- Rate -->					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/rate"/><xsl:text>,</xsl:text>
	<!-- FwdPoints -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/forwardPoints"/><xsl:text>,</xsl:text>
	<!-- MidRate -->				<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/midRate/rate"/><xsl:text>,</xsl:text>
	<!-- UTI -->					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/UTI"/><xsl:text>,</xsl:text>

	<!-- all fields in node <fxSwap> -->
	<!-- NearDealt -->				<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/dealtCurrency"/><xsl:text>,</xsl:text>
	<!-- NearBaseAmt -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/baseCurrencyAmount"/><xsl:text>,</xsl:text>
	<!-- NearTermAmt -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/termCurrencyAmount"/><xsl:text>,</xsl:text>
	<!-- NearValueDate -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/valueDate"/><xsl:text>,</xsl:text>
	<!-- NearTenor -->				<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/tenor"/><xsl:text>,</xsl:text>
	<!-- NearSpotDate -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/spotDate"/><xsl:text>,</xsl:text>
	<!-- NearFwdPoints -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/forwardPoints"/><xsl:text>,</xsl:text>
	<!-- NearRate -->				<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/rate"/><xsl:text>,</xsl:text>
	<!-- NearMidRateSpot -->		<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/spotRate"/><xsl:text>,</xsl:text>
	<!-- NearMidRateFwdPoints -->	<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/forwardPoints"/><xsl:text>,</xsl:text>
	<!-- NearMidRate -->			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/rate"/><xsl:text>,</xsl:text>
	<!-- FarDealt -->				<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/dealtCurrency"/><xsl:text>,</xsl:text>
	<!-- FarBaseAmt -->				<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/baseCurrencyAmount"/><xsl:text>,</xsl:text>
	<!-- FarTermAmt -->				<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/termCurrencyAmount"/><xsl:text>,</xsl:text>
	<!-- FarValueDate -->			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/valueDate"/><xsl:text>,</xsl:text>
	<!-- FarTenor -->				<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/tenor"/><xsl:text>,</xsl:text>
	<!-- FarSpotDate -->			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/spotDate"/><xsl:text>,</xsl:text>
	<!-- FarFwdPoints -->			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/forwardPoints"/><xsl:text>,</xsl:text>
	<!-- FarRate -->				<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/rate"/><xsl:text>,</xsl:text>
	<!-- FarMidRateSpot -->			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/spotRate"/><xsl:text>,</xsl:text>
	<!-- FarMidRateFwdPoints -->	<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/forwardPoints"/><xsl:text>,</xsl:text>
	<!-- FarMidRate -->				<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/rate"/><xsl:text>,</xsl:text>
	<!-- NearUTI -->				<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/UTI"/><xsl:text>,</xsl:text>
	<!-- FarUTI -->					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/UTI"/><xsl:text>,</xsl:text>
	<!-- NearUSI -->				<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/USI"/><xsl:text>,</xsl:text>
	<!-- FarUSI -->					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/USI"/><xsl:text>,</xsl:text>

</root>

	</xsl:template>
</xsl:stylesheet>
