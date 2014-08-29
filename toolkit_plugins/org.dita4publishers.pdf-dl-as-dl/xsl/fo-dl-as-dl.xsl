<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs xd"  
  version="2.0">
<!--Definition list - attributes -->
	<xsl:attribute-set name="dlentry.dt__content">
		<xsl:attribute name="start-indent">from-parent(start-indent) + 0mm</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="dlentry.dd__content">
		<xsl:attribute name="start-indent">from-parent(start-indent) + 5mm</xsl:attribute>
	</xsl:attribute-set>

	<!--Definition list - as list -->
	<xsl:template match="*[contains(@class, ' topic/dl ')]">
		<fo:block>
			<xsl:call-template name="commonattributes" />
			<xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]" />
		</fo:block>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/dlentry ')]">
		<fo:block xsl:use-attribute-sets="dlentry">
			<xsl:apply-templates select="*[contains(@class, ' topic/dt ')]" />
			<xsl:apply-templates select="*[contains(@class, ' topic/dd ')]" />
		</fo:block>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/dt ')]">
		<fo:block xsl:use-attribute-sets="dlentry.dt__content">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/dd ')]">
		<fo:block xsl:use-attribute-sets="dlentry.dd__content">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
  
</xsl:stylesheet>