<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:exsl="http://exslt.org/common"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic exsl opentopic-index dita2xslfo ot-placeholder"
    version="2.0">
  
    <!-- Override of base lot-lof.xsl -->
  <!--   LOT   -->
  
  <xsl:template match="ot-placeholder:tablelist">
<!--    <xsl:message>+ [DEBUG] Handling ot-placeholder:tablelist</xsl:message>-->
    <xsl:if test="//*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ' )]">
      <!--exists tables with titles-->
          <fo:block start-indent="0in"
            xsl:use-attribute-sets="topic-first-block-tablelist"
            >
            <xsl:call-template name="createLOTHeader"/>
            
            <xsl:apply-templates select="//*[contains (@class, ' topic/table ')][child::*[contains(@class, ' topic/title ' )]]" mode="list.of.tables"/>
          </fo:block>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="ot-placeholder:figurelist">
<!--    <xsl:message> + [DEBUG] #default: override lot-lof.xsl: figurelist</xsl:message>-->
    <xsl:if test="//*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ' )]">
      <fo:block start-indent="0in">
        <xsl:call-template name="createLOFHeader"/>

        <xsl:apply-templates select="//*[contains (@class, ' topic/fig ')][*[contains(@class, ' topic/title ' )]]" mode="list.of.figures"/>
      </fo:block>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="processFigureList">
    <xsl:apply-templates select="."/>
  </xsl:template>
  
  <xsl:template name="processTableList">
    <xsl:apply-templates select="."/>
  </xsl:template>
</xsl:stylesheet>
