<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic"
    version="2.0">
  
  <!-- Override of base toc_1.0.xsl -->

    <xsl:template name="createToc">
      <xsl:message>*** pdf-d4p: toc_1.0.xsl: createToc</xsl:message>

        <xsl:variable name="toc" as="node()*">
            <xsl:choose>
                <xsl:when test="($ditaVersion &gt;= 1.1) and $map//*[contains(@class,' bookmap/toc ')][@href]"/>
                <xsl:when test="($ditaVersion &gt;= 1.1) and $map//*[contains(@class,' bookmap/toc ')]">
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:when>
                <xsl:when test="($ditaVersion &gt;= 1.1) and /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:when>
                <xsl:when test="$ditaVersion &gt;= 1.1"/>
                <xsl:otherwise>
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="count($toc/*) > 0">
          <fo:block
            xsl:use-attribute-sets="topic-first-block-toc"
            >
             <xsl:sequence select="$toc"/>
          </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="processTocList">
      <fo:block
            xsl:use-attribute-sets="topic-first-block-toc"
      >
        <xsl:apply-templates/>
      </fo:block>
    </xsl:template>

</xsl:stylesheet>
