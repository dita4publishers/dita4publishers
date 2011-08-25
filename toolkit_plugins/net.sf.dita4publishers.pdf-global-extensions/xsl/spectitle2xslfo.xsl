<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
 
  exclude-result-prefixes="xs xd dita2xslfo"
  version="2.0">

  <xsl:template match="*[contains(@class,' topic/section ')][@spectitle != '' and not(*[contains(@class, ' topic/title ')])]" 
    mode="dita2xslfo:section-heading">
    <fo:block xsl:use-attribute-sets="section.title">
      <xsl:call-template name="commonattributes"/>
      <!-- FIXME: This should really be a lookup of a localized string keyed by the
           @spectitle value.
           
        -->
      <xsl:variable name="spectitleValue" as="xs:string" select="string(@spectitle)"/>
      <xsl:call-template name="insertVariable">
        <xsl:with-param name="theVariableID" select="$spectitleValue"/>
      </xsl:call-template>
    </fo:block>
    
  </xsl:template>
  
  
</xsl:stylesheet>