<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    xmlns:exsl="http://exslt.org/common"
    xmlns:exslf="http://exslt.org/functions"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:comparer="com.idiominc.ws.opentopic.xsl.extension.CompareStrings"
    extension-element-prefixes="exsl"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    exclude-result-prefixes="opentopic-index exsl comparer rx opentopic-func exslf">
  
  <!-- Override of index-1.0.xsl -->
  
      <xsl:template name="createIndex">
        <xsl:if test="(//opentopic-index:index.groups//opentopic-index:index.entry) and (count($index-entries//opentopic-index:index.entry) &gt; 0) and ($pdfFormatter = 'xep')">
            <xsl:variable name="index">
                <xsl:choose>
                    <xsl:when test="($ditaVersion &gt;= 1.1) and $map//*[contains(@class,' bookmap/indexlist ')][@href]"/>
                    <xsl:when test="($ditaVersion &gt;= 1.1) and $map//*[contains(@class,' bookmap/indexlist ')]">
                        <xsl:apply-templates select="/" mode="index-postprocess"/>
                    </xsl:when>
                    <xsl:when test="($ditaVersion &gt;= 1.1) and /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                        <xsl:apply-templates select="/" mode="index-postprocess"/>
                    </xsl:when>
                    <xsl:when test="$ditaVersion &gt;= 1.1"/>
                    <xsl:otherwise>
                        <xsl:apply-templates select="/" mode="index-postprocess"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="$index/*">
              <fo:block xsl:use-attribute-sets="topic-first-block-index">
                <xsl:sequence select="$index"/>
              </fo:block>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="processIndexList">
                <fo:block 
                  xsl:use-attribute-sets="
                  __index__label
                  topic-first-block-index
                  " 
                  id="{$id.index}">
                    <xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Index'"/>
                    </xsl:call-template>
                </fo:block>

                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
    </xsl:template>


</xsl:stylesheet>