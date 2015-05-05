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

		<!-- Party organizations -->
		<xsl:choose>
			<xsl:when test="workflowMessage/parameter[3] = 'Maker'">
				<xsl:choose>
					<xsl:when test="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/legalEntityBuysBase = 'true'">
						<BuySell>Sell</BuySell></xsl:when>
					<xsl:otherwise>
						<BuySell>Buy</BuySell></xsl:otherwise>
				</xsl:choose>
				<OrgID>
					<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyA/namespace,6)"/></OrgID>
				<OrgLE>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/counterpartyA/shortName"/></OrgLE>
				<OrgUser>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/user/shortName"/></OrgUser>

				<CptyID>
					<xsl:value-of select="/workflowMessage/to/shortName"/></CptyID>
				<CptyLE>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntity"/></CptyLE>
				<CptyUser>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser"/></CptyUser>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/legalEntityBuysBase = 'true'">
						<BuySell>Buy</BuySell></xsl:when>
					<xsl:otherwise>
						<BuySell>Sell</BuySell></xsl:otherwise>
				</xsl:choose>
				<OrgID>
					<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID>
				<OrgLE>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntity"/></OrgLE>
				<OrgUser>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser"/></OrgUser>

				<CptyID>
					<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyB/namespace,6)"/></CptyID>
				<CptyLE>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingParty"/></CptyLE>
				<CptyUser>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingPartyUser"/></CptyUser>
			</xsl:otherwise>
		</xsl:choose>



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

		<BaseCcy>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/baseCurrency"/></BaseCcy>
		<TermCcy>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/variableCurrency"/></TermCcy>

		<NearDealt>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/dealtCurrency"/></NearDealt>

		<NearBaseAmt>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/baseCurrencyAmount"/></NearBaseAmt>
		<NearTermAmt>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/termCurrencyAmount"/></NearTermAmt>
		<NearValueDate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/valueDate"/></NearValueDate>
		<NearTenor>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/tenor"/></NearTenor>

		<SpotRate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/spotRate"/></SpotRate>

		<NearSpotDate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/spotDate"/></NearSpotDate>
		<NearFwdPoints>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/forwardPoints"/></NearFwdPoints>
		<NearAllInRate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/rate"/></NearAllInRate>

		<NearMidRateSpot>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/spotRate"/></NearMidRateSpot>
		<NearMidRateFwdPoints>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/forwardPoints"/></NearMidRateFwdPoints>
		<NearMidAllInRate>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/rate"/></NearMidAllInRate>

        <!-- Near Market Rate -->
        <NearMkt_AllInRate>
            <xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxCoverRate/rate"/></NearMkt_AllInRate>
        <NearMkt_SpotRate>
            <xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxCoverRate/baseSpotRate"/></NearMkt_SpotRate>
        <NearMkt_FwdPoints>
            <xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxCoverRate/baseForwardPoints"/></NearMkt_FwdPoints>



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


		<!-- Party organizations -->
		<xsl:choose>
			<xsl:when test="workflowMessage/parameter[3] = 'Maker'">
				<xsl:choose>
					<xsl:when test="/workflowMessage/fxSwap/nearLeg/fxPayment/legalEntityBuysBase = 'true'">
						<BuySell>Sell</BuySell></xsl:when>
					<xsl:otherwise>
						<BuySell>Buy</BuySell></xsl:otherwise>
				</xsl:choose>
				<OrgID>
					<xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyA/namespace,6)"/></OrgID>
				<OrgLE>
					<xsl:value-of select="/workflowMessage/fxSwap/counterpartyA/shortName"/></OrgLE>
				<OrgUser>
					<xsl:value-of select="/workflowMessage/fxSwap/user/shortName"/></OrgUser>

				<CptyID>
					<xsl:value-of select="/workflowMessage/to/shortName"/></CptyID>
				<CptyLE>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntity"/></CptyLE>
				<CptyUser>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntityUser"/></CptyUser>
			</xsl:when>
			<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="/workflowMessage/fxSwap/nearLeg/fxPayment/legalEntityBuysBase = 'true'">
							<BuySell>Buy</BuySell></xsl:when>
						<xsl:otherwise>
							<BuySell>Sell</BuySell></xsl:otherwise>
				</xsl:choose>

				<OrgID>
					<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID>
				<OrgLE>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntity"/></OrgLE>
				<OrgUser>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntityUser"/></OrgUser>

				<CptyID>
					<xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyB/namespace,6)"/></CptyID>
				<CptyLE>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingParty"/></CptyLE>
				<CptyUser>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingPartyUser"/></CptyUser>
			</xsl:otherwise>
		</xsl:choose>


		<CoveredTradeID>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coveredTrade"/></CoveredTradeID>
		<CoverTradesID>
			<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coverTrade"/></CoverTradesID>

		<OriginatingOrderID>
			<xsl:value-of select="/workflowMessage/entityProperty/request/externalRequestId"/></OriginatingOrderID>

		<NearUTI>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/UTI"/></NearUTI>
		<FarUTI>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/UTI"/></FarUTI>
		<NearUSI>
			<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/USI"/></NearUSI>
		<FarUSI>
			<xsl:value-of select="/workflowMessage/fxSwap/farLeg/USI"/></FarUSI>
		<UPI>
			<xsl:value-of select="/workflowMessage/fxSwap/@UPI"/></UPI>

	</xsl:if>


	<Status>
			<xsl:value-of select="workflowMessage/event"/></Status>


</STPMessage>

</xsl:template>
</xsl:stylesheet>