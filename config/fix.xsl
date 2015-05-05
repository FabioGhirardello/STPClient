<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				exclude-result-prefixes="xsi"
				version="1.0">

	<xsl:output method="html" indent="no"/>

	<xsl:template match="/">

		<STPMessage>
			<TradeId_17>
				<xsl:value-of select="workflowMessage/entityReference/transactionId"/></TradeId_17>
			<Type_18>
				<xsl:value-of select="workflowMessage/parameter[1]"/></Type_18>

			<!-- if the deal is a FXSpot or FXOutright, the data is in the <fxSingleLeg> node -->
			<xsl:if test="workflowMessage/parameter[1] = 'FXSpot' or workflowMessage/parameter[1] = 'FXOutright'">

				<OrderID_11>
					<xsl:value-of select="workflowMessage/fxSingleLeg/@orderId"/></OrderID_11>
				<WorkflowChannel_578>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/channel"/></WorkflowChannel_578>
				<TradeExecTimeStamp_60>
					<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/entryDateTime,0,20)"/></TradeExecTimeStamp_60>
				<TradeDate_75>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/tradeDate"/></TradeDate_75>
				<Role_7549>
					<xsl:value-of select="workflowMessage/parameter[3]"/></Role_7549>
				<xsl:choose>
					<xsl:when test="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/legalEntityBuysBase = 'true'">
						<Side_54>1</Side_54></xsl:when>
					<xsl:otherwise>
						<Side_54>2</Side_54></xsl:otherwise>
				</xsl:choose>

				<BaseCcy_55>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/baseCurrency"/></BaseCcy_55>
				<TermCcy_120>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/variableCurrency"/></TermCcy_120>
				<Dealt_15>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/dealtCurrency"/></Dealt_15>
				<BaseAmt_32>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/baseCurrencyAmount"/></BaseAmt_32>
				<TermAmt_119>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/termCurrencyAmount"/></TermAmt_119>
				<ValueDate_64>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/valueDate"/></ValueDate_64>
				<Tenor_541>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/tenor"/></Tenor_541>

				<AllInRate_31>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/rate"/></AllInRate_31>
				<SpotRate_194>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/spotRate"/></SpotRate_194>
				<FwdPoints_195>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/forwardPoints"/></FwdPoints_195>

				<MidRate_631>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/midRate/rate"/></MidRate_631>


				<!-- Party organizations -->
				<OrgID_57>
					<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID_57>
				<OrgLE_128>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntity"/></OrgLE_128>
				<OrgUser_129>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser"/></OrgUser_129>


				<xsl:choose>
					<xsl:when test="workflowMessage/parameter[3] = 'Maker'">
						<CptyID_115>
							<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyA/namespace,6)"/></CptyID_115></xsl:when>
					<xsl:otherwise>
						<CptyID_115>
							<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyB/namespace,6)"/></CptyID_115></xsl:otherwise>
				</xsl:choose>
				<CptyLE_116>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingParty"/></CptyLE_116>
				<CptyUser_117>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/tradingPartyUser"/></CptyUser_117>

				<CoveredTradeID_7602>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coveredTrade"/></CoveredTradeID_7602>
				<CoverTradesID_7601>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/cptyTrade/coverTrade"/></CoverTradesID_7601>

				<UTI_9380>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/UTI"/></UTI_9380>
				<UPI_9381>
					<xsl:value-of select="/workflowMessage/fxSingleLeg/@UPI"/></UPI_9381>

			</xsl:if>

			<!-- if the deal is a FXSpotFwd or a FXFwdFwd, the data is in the <fxSwap> node and there are 2 legs -->
			<xsl:if test="workflowMessage/parameter[1] = 'FXSpotFwd' or workflowMessage/parameter[1] = 'FXFwdFwd'">

				<OrderID_11>
					<xsl:value-of select="workflowMessage/fxSwap/@orderId"/></OrderID_11>
				<WorkflowChannel_578>
					<xsl:value-of select="/workflowMessage/fxSwap/channel"/></WorkflowChannel_578>
				<TradeExecTimeStamp_60>
					<xsl:value-of select="substring(/workflowMessage/fxSwap/entryDateTime,0,20)"/></TradeExecTimeStamp_60>
				<TradeDate_75>
					<xsl:value-of select="/workflowMessage/fxSwap/tradeDate"/></TradeDate_75>
				<Role_7549>
					<xsl:value-of select="workflowMessage/parameter[3]"/></Role_7549>
				<xsl:choose>
					<xsl:when test="/workflowMessage/fxSwap/nearLeg/fxPayment/legalEntityBuysBase = 'true'" >
						<Side_54>1</Side_54></xsl:when>
					<xsl:otherwise>
						<Side_54>2</Side_54></xsl:otherwise>
				</xsl:choose>

				<BaseCcy_55>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/baseCurrency"/></BaseCcy_55>
				<TermCcy_120>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/variableCurrency"/></TermCcy_120>

				<NearDealt_15>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/dealtCurrency"/></NearDealt_15>

				<NearBaseAmt_32>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/baseCurrencyAmount"/></NearBaseAmt_32>
				<NearTermAmt_120>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/termCurrencyAmount"/></NearTermAmt_120>
				<NearValueDate_64>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/valueDate"/></NearValueDate_64>
				<NearTenor_541>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/tenor"/></NearTenor_541>

				<SpotRate_194>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/spotRate"/></SpotRate_194>

				<NearFwdPoints_195>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/forwardPoints"/></NearFwdPoints_195>
				<NearAllInRate_31>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/fxRate/rate"/></NearAllInRate_31>

				<NearMidRateSpot_629>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/spotRate"/></NearMidRateSpot_629>
				<NearMidRateFwdPoints_630>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/forwardPoints"/></NearMidRateFwdPoints_630>
				<NearMidAllInRate_631>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/fxPayment/midRate/rate"/></NearMidAllInRate_631>


				<FarBaseAmt_192>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/baseCurrencyAmount"/></FarBaseAmt_192>
				<FarTermAmt_191>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/termCurrencyAmount"/></FarTermAmt_191>
				<FarValueDate_193>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/valueDate"/></FarValueDate_193>
				<FarTenor_542>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/tenor"/></FarTenor_542>
				<FarFwdPoints_641>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/forwardPoints"/></FarFwdPoints_641>
				<FarAllInRate_7541>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/fxRate/rate"/></FarAllInRate_7541>

				<FarMidRateSpot_7629>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/spotRate"/></FarMidRateSpot_7629>
				<FarMidRateFwdPoints_7630>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/forwardPoints"/></FarMidRateFwdPoints_7630>
				<FarMidAllInRate_7631>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/fxPayment/midRate/rate"/></FarMidAllInRate_7631>

				<!-- Party organizations -->
				<OrgID_57>
					<xsl:value-of select="/workflowMessage/to/shortName"/></OrgID_57>
				<OrgLE_128>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntity"/></OrgLE_128>
				<OrgUser_129>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/legalEntityUser"/></OrgUser_129>

				<xsl:choose>
					<xsl:when test="workflowMessage/parameter[3] = 'Maker'">
						<CptyID_115>
							<xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyA/namespace,6)"/></CptyID_115></xsl:when>
					<xsl:otherwise>
						<CptyID_115>
							<xsl:value-of select="substring(/workflowMessage/fxSwap/counterpartyB/namespace,6)"/></CptyID_115></xsl:otherwise>
				</xsl:choose>
				<CptyLE_116>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingParty"/></CptyLE_116>
				<CptyUser_117>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/tradingPartyUser"/></CptyUser_117>

				<CoveredTradeID_7602>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coveredTrade"/></CoveredTradeID_7602>
				<CoverTradesID_7601>
					<xsl:value-of select="/workflowMessage/fxSwap/cptyTrade/coverTrade"/></CoverTradesID_7601>

				<NearUTI_9380>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/UTI"/></NearUTI_9380>
				<FarUTI_9381>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/UTI"/></FarUTI_9381>
				<NearUSI_9376>
					<xsl:value-of select="/workflowMessage/fxSwap/nearLeg/USI"/></NearUSI_9376>
				<FarUSI_9377>
					<xsl:value-of select="/workflowMessage/fxSwap/farLeg/USI"/></FarUSI_9377>
				<UPI_9381>
					<xsl:value-of select="/workflowMessage/fxSwap/@UPI"/></UPI_9381>

			</xsl:if>


		</STPMessage>

	</xsl:template>
</xsl:stylesheet>