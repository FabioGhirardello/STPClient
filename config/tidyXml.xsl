<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="xsi"
                version="1.0">

<xsl:output method="html" indent="no"/>

<xsl:template match="/">

<STPMessage>
		<TradeId>
			<xsl:value-of select="workflowMessage/entityReference/transactionId"/></TradeId>
		<Type>
			<xsl:value-of select="workflowMessage/parameter[1]"/></Type>

<!-- if the deal is a FXSpot or FXOutright, the data is in the <fxSingleLeg> node -->
	<xsl:if test="workflowMessage/parameter[1] = 'FXSpot' or workflowMessage/parameter[1] = 'FXOutright'">

		<OrderID>
			<xsl:value-of select="workflowMessage/fxSingleLeg/@orderId"/></OrderID>
		<WorkflowChannel>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/channel"/></WorkflowChannel>
		<TradeExecTimeStamp>
			<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/entryDateTime,0,20)"/></TradeExecTimeStamp>
		<TradeDate>
		<xsl:value-of select="/workflowMessage/fxSingleLeg/tradeDate"/></TradeDate>
		<Role>
			<xsl:value-of select="workflowMessage/parameter[3]"/></Role>
		<xsl:choose>
			<xsl:when test="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/legalEntityBuysBase = 'true'">
				<Side>Buy</Side></xsl:when>
			<xsl:otherwise>
				<Side>Sell</Side></xsl:otherwise>
		</xsl:choose>

		<BaseCcy>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/baseCurrency"/></BaseCcy>
		<TermCcy>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/variableCurrency"/></TermCcy>
		<Dealt>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/dealtCurrency"/></Dealt>
		<BaseAmt>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/baseCurrencyAmount"/></BaseAmt>
		<TermAmt>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/termCurrencyAmount"/></TermAmt>
		<ValueDate>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/valueDate"/></ValueDate>
		<Tenor>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/tenor"/></Tenor>

		<AllInRate>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/rate"/></AllInRate>
		<SpotRate>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/spotRate"/></SpotRate>
		<FwdPoints>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/forwardPoints"/></FwdPoints>

		<MidRate>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/midRate/rate"/></MidRate>

        <!-- Market Rate -->
        <Mkt_AllInRate>
            <xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/rate"/></Mkt_AllInRate>
        <Mkt_SpotRate>
            <xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/baseSpotRate"/></Mkt_SpotRate>
        <Mkt_FwdPoints>
            <xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/baseForwardPoints"/></Mkt_FwdPoints>


		<!-- Spreads -->
		<Sprd_PM_Spot>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/spread[@name='PMSpotSprd']"/></Sprd_PM_Spot>
		<Sprd_PM_Fwd>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/spread[@name='PMFwdSprd']"/></Sprd_PM_Fwd>
		<Sprd_PP_Spot>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/spread[@name='PPSpotSprd']"/></Sprd_PP_Spot>
		<Sprd_PP_Fwd>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/spread[@name='PPFwdSprd']"/></Sprd_PP_Fwd>
		<Sprd_PP_Total>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxCoverRate/spread[@name='PPCustSprd']"/></Sprd_PP_Total>


		<!-- Party organizations -->
		<OrgID>
			<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID>
		<OrgLE>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntity"/></OrgLE>
		<OrgUser>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser"/></OrgUser>


        <xsl:choose>
            <xsl:when test="workflowMessage/parameter[3] = 'Maker'">
                <CptyID>
                    <xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyA/namespace,6)"/></CptyID></xsl:when>
            <xsl:otherwise>
                <CptyID>
                    <xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyB/namespace,6)"/></CptyID></xsl:otherwise>
        </xsl:choose>
		<CptyLE>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingParty"/></CptyLE>
		<CptyUser>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingPartyUser"/></CptyUser>

        <!-- Only useful for intra-floor trades
		<OriginatingID>
			<xsl:value-of select="substring(/workflowMessage/entityProperty/request/user/namespace, 6)"/></OriginatingID>
		<OriginatingLE>
			<xsl:value-of select="/workflowMessage/parameter[2]"/></OriginatingLE>
		<OriginatingUser>
			<xsl:value-of select="/workflowMessage/parameter[4]"/></OriginatingUser>
        -->

		<CoveredTradeID>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coveredTrade"/></CoveredTradeID>
		<CoverTradesID>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coverTrade"/></CoverTradesID>

		<OriginatingOrderID>
			<xsl:value-of select="/workflowMessage/entityProperty/request/externalRequestId"/></OriginatingOrderID>
		<UTI>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/UTI"/></UTI>
		<UPI>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/@UPI"/></UPI>
		<OrderNotes>
			<xsl:value-of select="/workflowMessage/fxSingleLeg/orderNotes"/></OrderNotes>

	</xsl:if>

<!-- if the deal is a FXSpotFwd or a FXFwdFwd, the data is in the <fxSwap> node and there are 2 legs -->
	<xsl:if test="workflowMessage/parameter[1] = 'FXSpotFwd' or workflowMessage/parameter[1] = 'FXFwdFwd'">

		<OrderID>
			<xsl:value-of select="workflowMessage/fxSwap/@orderId"/></OrderID>
		<WorkflowChannel>
			<xsl:value-of select="/workflowMessage/fxSwap/channel"/></WorkflowChannel>
		<TradeExecTimeStamp>
			<xsl:value-of select="substring(/workflowMessage/fxSwap/entryDateTime,0,20)"/></TradeExecTimeStamp>
		<TradeDate>
			<xsl:value-of select="/workflowMessage/fxSwap/tradeDate"/></TradeDate>
		<Role>
			<xsl:value-of select="workflowMessage/parameter[3]"/></Role>
		<xsl:choose>
			<xsl:when test="/workflowMessage/fxSwap/nearLeg/fxPayment/legalEntityBuysBase = 'true'" >
				<Side>Buy</Side></xsl:when>
			<xsl:otherwise>
				<Side>Sell</Side></xsl:otherwise>
		</xsl:choose>

		<BaseCcy>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/baseCurrency"/></BaseCcy>
		<TermCcy>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/variableCurrency"/></TermCcy>

		<Dealt>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/dealtCurrency"/></Dealt>

		<BaseAmt>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/baseCurrencyAmount"/></BaseAmt>
		<TermAmt>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/termCurrencyAmount"/></TermAmt>
		<ValueDate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/valueDate"/></ValueDate>
		<Tenor>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/tenor"/></Tenor>

		<SpotRate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/spotRate"/></SpotRate>

		<SpotDate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/spotDate"/></SpotDate>
		<FwdPoints>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/forwardPoints"/></FwdPoints>
		<AllInRate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/rate"/></AllInRate>

		<MidRateSpot>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/spotRate"/></MidRateSpot>
		<MidRateFwdPoints>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/forwardPoints"/></MidRateFwdPoints>
		<MidAllInRate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/rate"/></MidAllInRate>

        <!-- Near Market Rate -->
        <Mkt_AllInRate>
            <xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxCoverRate/rate"/></Mkt_AllInRate>
        <Mkt_SpotRate>
            <xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxCoverRate/baseSpotRate"/></Mkt_SpotRate>
        <Mkt_FwdPoints>
            <xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxCoverRate/baseForwardPoints"/></Mkt_FwdPoints>


		<FarDealt>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/dealtCurrency"/></FarDealt>
		<FarBaseAmt>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/baseCurrencyAmount"/></FarBaseAmt>
		<FarTermAmt>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/termCurrencyAmount"/></FarTermAmt>
		<FarValueDate>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/valueDate"/></FarValueDate>
		<FarTenor>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/tenor"/></FarTenor>
		<FarSpotDate>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/spotDate"/></FarSpotDate>
		<FarFwdPoints>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/forwardPoints"/></FarFwdPoints>
		<FarAllInRate>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/rate"/></FarAllInRate>

		<FarMidRateSpot>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/spotRate"/></FarMidRateSpot>
		<FarMidRateFwdPoints>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/forwardPoints"/></FarMidRateFwdPoints>
		<FarMidAllInRate>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/rate"/></FarMidAllInRate>

        <!-- Far Market Rate -->
        <FarMkt_AllInRate>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/rate"/></FarMkt_AllInRate>
        <FarMkt_SpotRate>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/baseSpotRate"/></FarMkt_SpotRate>
        <FarMkt_FwdPoints>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/baseForwardPoints"/></FarMkt_FwdPoints>

        <!-- Spreads -->
        <Sprd_PM_FarSpot>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/spread[@name='PMSpotSprd']"/></Sprd_PM_FarSpot>
        <!-- market convention is to put the spread on the far forward points only
        <Sprd_PP_Spot>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/spread[@name='PPSpotSprd']"/></Sprd_PP_Spot>
        <Sprd_PP_Near>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/spread[@name='PPNearSprd']"/></Sprd_PP_Near>
        -->
        <Sprd_PP_Far>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/spread[@name='PPFarSprd']"/></Sprd_PP_Far>
        <Sprd_PP_Total>
            <xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxCoverRate/spread[@name='PPCustSprd']"/></Sprd_PP_Total>

		<!-- Party organizations -->
		<OrgID>
			<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID>
		<OrgLE>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntity"/></OrgLE>
		<OrgUser>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntityUser"/></OrgUser>

        <xsl:choose>
            <xsl:when test="workflowMessage/parameter[3] = 'Maker'">
                <CptyID>
                    <xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyA/namespace,6)"/></CptyID></xsl:when>
            <xsl:otherwise>
                <CptyID>
                    <xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyB/namespace,6)"/></CptyID></xsl:otherwise>
        </xsl:choose>
		<CptyLE>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingParty"/></CptyLE>
		<CptyUser>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingPartyUser"/></CptyUser>

        <!-- only useful for intra-floor trades
		<OriginatingID>
			<xsl:value-of select="substring(/workflowMessage/entityProperty/request/user/namespace, 6)"/></OriginatingID>
		<OriginatingLE>
			<xsl:value-of select="/workflowMessage/parameter[2]"/></OriginatingLE>
		<OriginatingUser>
			<xsl:value-of select="/workflowMessage/parameter[4]"/></OriginatingUser>
        -->

		<CoveredTradeID>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coveredTrade"/></CoveredTradeID>
		<CoverTradesID>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coverTrade"/></CoverTradesID>

		<OriginatingOrderID>
			<xsl:value-of select="/workflowMessage/entityProperty/request/externalRequestId"/></OriginatingOrderID>

		<UTI>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/UTI"/></UTI>
		<FarUTI>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/UTI"/></FarUTI>
		<USI>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/USI"/></USI>
		<FarUSI>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/USI"/></FarUSI>
		<UPI>
			<xsl:value-of select="/workflowMessage/fxSwap/@UPI"/></UPI>

		<OrderNotes>
			<xsl:value-of select="/workflowMessage/fxSwap/orderNotes"/></OrderNotes>

	</xsl:if>


</STPMessage>

</xsl:template>
</xsl:stylesheet>