<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				exclude-result-prefixes="xsi"
				version="1.0">

	<xsl:output method="html" indent="no"/>

	<xsl:template match="/">

		<STPMessage>
			<TradeId tag="17">
				<xsl:value-of select="workflowMessage/entityReference/transactionId"/></TradeId>
			<Type tag="18">
				<xsl:value-of select="workflowMessage/parameter[1]"/></Type>

			<!-- if the deal is a FXSpot or FXOutright, the data is in the <fxSingleLeg> node -->
			<xsl:if test="workflowMessage/parameter[1] = 'FXSpot' or workflowMessage/parameter[1] = 'FXOutright'">

				<OrderID tag="11">
					<xsl:value-of select="workflowMessage/fxSingleLeg/@orderId"/></OrderID>
				<WorkflowChannel tag="578">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/channel"/></WorkflowChannel>
				<TradeExecTimeStamp tag="60">
					<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/entryDateTime,0,20)"/></TradeExecTimeStamp>
				<TradeDate tag="75">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/tradeDate"/></TradeDate>
				<Role tag="7549">
					<xsl:value-of select="workflowMessage/parameter[3]"/></Role>
				<xsl:choose>
					<xsl:when test="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/legalEntityBuysBase = 'true'">
						<Side tag="54">1</Side></xsl:when>
					<xsl:otherwise>
						<Side tag="54">2</Side></xsl:otherwise>
				</xsl:choose>

				<BaseCcy tag="55">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/baseCurrency"/></BaseCcy>
				<TermCcy tag="120">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/variableCurrency"/></TermCcy>
				<Dealt tag="15">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/dealtCurrency"/></Dealt>
				<BaseAmt tag="32">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/baseCurrencyAmount"/></BaseAmt>
				<TermAmt tag="119">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/termCurrencyAmount"/></TermAmt>
				<ValueDate tag="64">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/valueDate"/></ValueDate>
				<Tenor tag="541">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/tenor"/></Tenor>

				<AllInRate tag="31">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/rate"/></AllInRate>
				<SpotRate tag="194">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/spotRate"/></SpotRate>
				<FwdPoints tag="195">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/forwardPoints"/></FwdPoints>

				<MidRate tag="631">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/midRate/rate"/></MidRate>


				<!-- Party organizations -->
				<OrgID tag="57">
					<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID>
				<OrgLE tag="128">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntity"/></OrgLE>
				<OrgUser tag="129">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser"/></OrgUser>


				<xsl:choose>
					<xsl:when test="workflowMessage/parameter[3] = 'Maker'">
						<CptyID tag="115">
							<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyA/namespace,6)"/></CptyID></xsl:when>
					<xsl:otherwise>
						<CptyID tag="115">
							<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyB/namespace,6)"/></CptyID></xsl:otherwise>
				</xsl:choose>
				<CptyLE tag="116">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingParty"/></CptyLE>
				<CptyUser tag="117">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingPartyUser"/></CptyUser>

				<CoveredTradeID tag="7602">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coveredTrade"/></CoveredTradeID>
				<CoverTradesID tag="7601">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coverTrade"/></CoverTradesID>

				<UTI tag="9380">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/UTI"/></UTI>
				<UPI tag="9381">
					<xsl:value-of select="/workflowMessage/fxSingleLeg/@UPI"/></UPI>

			</xsl:if>

			<!-- if the deal is a FXSpotFwd or a FXFwdFwd, the data is in the <fxSwap> node and there are 2 legs -->
			<xsl:if test="workflowMessage/parameter[1] = 'FXSpotFwd' or workflowMessage/parameter[1] = 'FXFwdFwd'">

				<OrderID tag="11">
					<xsl:value-of select="workflowMessage/fxSwap/@orderId"/></OrderID>
				<WorkflowChannel tag="578">
					<xsl:value-of select="/workflowMessage/fxSwap/channel"/></WorkflowChannel>
				<TradeExecTimeStamp tag="60">
					<xsl:value-of select="substring(/workflowMessage/fxSwap/entryDateTime,0,20)"/></TradeExecTimeStamp>
				<TradeDate tag="75">
					<xsl:value-of select="/workflowMessage/fxSwap/tradeDate"/></TradeDate>
				<Role tag="7549">
					<xsl:value-of select="workflowMessage/parameter[3]"/></Role>
				<xsl:choose>
					<xsl:when test="/workflowMessage/fxSwap/nearLeg/fxPayment/legalEntityBuysBase = 'true'" >
						<Side tag="54">1</Side></xsl:when>
					<xsl:otherwise>
						<Side tag="54">2</Side></xsl:otherwise>
				</xsl:choose>

				<BaseCcy tag="55">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/baseCurrency"/></BaseCcy>
				<TermCcy tag="120">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/variableCurrency"/></TermCcy>

				<NearDealt tag="15">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/dealtCurrency"/></NearDealt>

				<NearBaseAmt tag="32">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/baseCurrencyAmount"/></NearBaseAmt>
				<NearTermAmt tag="120">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/termCurrencyAmount"/></NearTermAmt>
				<NearValueDate tag="64">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/valueDate"/></NearValueDate>
				<NearTenor tag="541">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/tenor"/></NearTenor>

				<SpotRate tag="194">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/spotRate"/></SpotRate>

				<NearFwdPoints tag="195">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/forwardPoints"/></NearFwdPoints>
				<NearAllInRate tag="31">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/rate"/></NearAllInRate>

				<NearMidRateSpot tag="629">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/spotRate"/></NearMidRateSpot>
				<NearMidRateFwdPoints tag="630">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/forwardPoints"/></NearMidRateFwdPoints>
				<NearMidAllInRate tag="631">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/rate"/></NearMidAllInRate>


				<FarBaseAmt tag="192">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/baseCurrencyAmount"/></FarBaseAmt>
				<FarTermAmt tag="191">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/termCurrencyAmount"/></FarTermAmt>
				<FarValueDate tag="193">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/valueDate"/></FarValueDate>
				<FarTenor tag="542">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/tenor"/></FarTenor>
				<FarFwdPoints tag="641">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/forwardPoints"/></FarFwdPoints>
				<FarAllInRate tag="7541">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/rate"/></FarAllInRate>

				<FarMidRateSpot tag="7629">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/spotRate"/></FarMidRateSpot>
				<FarMidRateFwdPoints tag="7630">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/forwardPoints"/></FarMidRateFwdPoints>
				<FarMidAllInRate tag="7631">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/rate"/></FarMidAllInRate>

				<!-- Party organizations -->
				<OrgID tag="57">
					<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID>
				<OrgLE tag="128">
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntity"/></OrgLE>
				<OrgUser tag="129">
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntityUser"/></OrgUser>

				<xsl:choose>
					<xsl:when test="workflowMessage/parameter[3] = 'Maker'">
						<CptyID tag="115">
							<xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyA/namespace,6)"/></CptyID></xsl:when>
					<xsl:otherwise>
						<CptyID tag="115">
							<xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyB/namespace,6)"/></CptyID></xsl:otherwise>
				</xsl:choose>
				<CptyLE tag="116">
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingParty"/></CptyLE>
				<CptyUser tag="117">
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingPartyUser"/></CptyUser>

				<CoveredTradeID tag="7602">
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coveredTrade"/></CoveredTradeID>
				<CoverTradesID tag="7601">
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coverTrade"/></CoverTradesID>

				<NearUTI tag="9380">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/UTI"/></NearUTI>
				<FarUTI tag="9381">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/UTI"/></FarUTI>
				<NearUSI tag="9376">
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/USI"/></NearUSI>
				<FarUSI tag="9377">
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/USI"/></FarUSI>
				<UPI tag="9381">
					<xsl:value-of select="/workflowMessage/fxSwap/@UPI"/></UPI>
			</xsl:if>

		</STPMessage>

	</xsl:template>
</xsl:stylesheet>