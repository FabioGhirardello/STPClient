<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="xsi"
                version="1.0">

<xsl:output method="html" indent="no"/>

<xsl:template match="/">


<transaccion>
	<id>SP1</id>

	<tipo_operacion>I</tipo_operacion>

	<mercado>174</mercado>

	<origen>CLIENTES</origen>

	<sub_mercado>SPOT</sub_mercado>

	<xsl:choose>
		<xsl:when test="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/legalEntityBuysBase = 'true'"><operacion>COMPRA</operacion></xsl:when>
		<xsl:otherwise><operacion>VENTA</operacion></xsl:otherwise>
	</xsl:choose>

	<xsl:choose>
		<xsl:when test="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser = 'admin18'"><id_usuario>123456789</id_usuario></xsl:when>
		<xsl:when test="/workflowMessage/fxSingleLeg/cptyTrade/legalEntityUser = 'BRKZQuoter'"><id_usuario>999888777</id_usuario></xsl:when>
		<xsl:otherwise><id_usuario>ERROR_INVALID_USER</id_usuario></xsl:otherwise>
	</xsl:choose>

	<codigo_especial_fiduciario>123</codigo_especial_fiduciario>

	<fecha_transaccion>
		<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/entryDateTime,0,11)"/></fecha_transaccion>

	<hora_transaccion>
		<xsl:value-of select="substring(/workflowMessage/fxSingleLeg/entryDateTime,11,9)"/></hora_transaccion>

	<fecha_valor></fecha_valor>

	<fecha_inicio_contrato></fecha_inicio_contrato>

	<fecha_fin_contrato></fecha_fin_contrato>

	<precio>
		<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/rate"/></precio>

	<monto_transado>
		<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/baseCurrencyAmount"/></monto_transado>

	<moneda_monto>
		<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/baseCurrency"/></moneda_monto>

	<moneda_contraparte>
		<xsl:value-of select="/workflowMessage/fxSingleLeg/fxLeg/fxPayment/fxRate/variableCurrency"/></moneda_contraparte>

	<descripcion_opcionalidad></descripcion_opcionalidad>

	<tasa_referencial></tasa_referencial>

	<tipo_identificacion>C</tipo_identificacion>

	<xsl:choose>
		<xsl:when test="workflowMessage/parameter[3] = 'Maker'">
			<xsl:choose>
				<xsl:when test="substring(/workflowMessage/fxSingleLeg/counterpartyA/namespace,6) = '1000BRKZ'"><identificacion_contraparte>55551000</identificacion_contraparte></xsl:when>
				<xsl:when test="substring(/workflowMessage/fxSingleLeg/counterpartyA/namespace,6) = '1001BRKZ'"><identificacion_contraparte>55551001</identificacion_contraparte></xsl:when>
				<xsl:otherwise><identificacion_contraparte>UNMAPPED TAKER CPTY: <xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyA/namespace,6)"/></identificacion_contraparte></xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="substring(/workflowMessage/fxSingleLeg/counterpartyB/namespace,6) = 'FXDD'"><identificacion_contraparte>66FXDD</identificacion_contraparte></xsl:when>
				<xsl:when test="substring(/workflowMessage/fxSingleLeg/counterpartyB/namespace,6) = 'BRKX'"><identificacion_contraparte>66BRKX</identificacion_contraparte></xsl:when>
				<xsl:otherwise><identificacion_contraparte>UNMAPPED MAKER CPTY: <xsl:value-of select="substring(/workflowMessage/fxSingleLeg/counterpartyB/namespace,6)"/></identificacion_contraparte></xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>

	<periodo_interes></periodo_interes>

	<comentario>
		<xsl:value-of select="workflowMessage/entityReference/transactionId"/></comentario>

	<cumplimiento></cumplimiento>

	<tasa_interes_moneda_monto></tasa_interes_moneda_monto>
	<tasa_interes_moneda_contraparte></tasa_interes_moneda_contraparte>

	<condicion_ejercicio></condicion_ejercicio>

	<precio_ejercicio></precio_ejercicio>

	<volatilidad></volatilidad>

	<precio_spot></precio_spot>

	<prima></prima>

	<tipo_opcion></tipo_opcion>

	<tipo_swap></tipo_swap>

	<numeral_cambiario>1000</numeral_cambiario>

	<forma_de_pago>EFECTIVO</forma_de_pago>

	<tipo_de_operacion_complementaria>POSICION PROPIA</tipo_de_operacion_complementaria>

	<porcentaje_comision></porcentaje_comision>

	<sistema_origen>X</sistema_origen>
</transaccion>



</xsl:template>
</xsl:stylesheet>