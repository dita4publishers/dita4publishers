<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dita-ot-pdf="http://net.sf.dita-ot/transforms/pdf"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="opentopic ot-placeholder xs dita-ot-pdf"
    version="2.0">
  
  <!-- Override of base toc_1.0.xsl -->

    <xsl:template name="createToc" match="ot-placeholder:toc">
      <xsl:message>+ [DEBUG] pdf-d4p toc.xsl: createToc</xsl:message>
      
        <xsl:variable name="toc" as="node()*">
            <xsl:choose>
                <xsl:when test="($ditaVersion &gt;= 1.1) and $map//*[contains(@class,' bookmap/toc ')][@href]"/>
                <xsl:otherwise>
                    <xsl:apply-templates select="/" mode="toc"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="count($toc/*) > 0">
          <fo:block
            xsl:use-attribute-sets="topic-first-block-toc"
            >
             <xsl:call-template name="createTocHeader"/>
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

  <xsl:template match="*[contains(@class, ' topic/topic ') and not(contains(@class, ' bkinfo/bkinfo '))]" mode="toc">
    <xsl:param name="include"/>

    <xsl:variable name="pubRegion" as="xs:string"
      select="dita-ot-pdf:getPublicationRegion(.)
      "
    />
    
    <xsl:variable name="topicref" select="dita-ot-pdf:getNearestTopicrefForTopic(.)" as="element()"/>
    
    <xsl:variable name="topicLevel" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
    <xsl:if test="$topicLevel &lt; $tocMaximumLevel">
      <xsl:variable name="topicTitle">
        <xsl:call-template name="getNavTitle" >
          <xsl:with-param name="pubRegion" as="xs:string" tunnel="yes" select="$pubRegion"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="gid" select="generate-id()"/>
      <xsl:variable name="topicNumber" select="count($topicNumbers/topic[@id = $id][following-sibling::topic[@guid = $gid]]) + 1"/>
      <xsl:variable name="mapTopic" as="element()?"
        select="$map//*[@id = $id]"/>
      <xsl:variable name="topicType">
        <xsl:call-template name="determineTopicType"/>
      </xsl:variable>
      
      <xsl:choose>
        <xsl:when test="($mapTopic/*[position() = $topicNumber][@toc = 'yes' or not(@toc)]) or (not($mapTopic/*) and $include = 'true')">
          <fo:block xsl:use-attribute-sets="__toc__indent">
            <xsl:variable name="tocItemContent">
              <fo:basic-link xsl:use-attribute-sets="__toc__link">
                <xsl:attribute name="internal-destination">
                  <xsl:call-template name="generate-toc-id"/>
                </xsl:attribute>
                <xsl:apply-templates select="$topicType" mode="toc-prefix-text">
                  <xsl:with-param name="id" select="@id"/>
                  <xsl:with-param name="pubRegion" as="xs:string" tunnel="yes" select="$pubRegion"/>
                </xsl:apply-templates>
                <fo:inline xsl:use-attribute-sets="__toc__title">
                  <!-- FIXME: This should not be a value-of, it should be an apply-templates
                              in a distinct mode.
                    -->
                  <xsl:value-of select="$topicTitle"/>
                </fo:inline>
                <fo:inline xsl:use-attribute-sets="__toc__page-number">
                  <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                  <fo:page-number-citation>
                    <xsl:attribute name="ref-id">
                      <xsl:call-template name="generate-toc-id"/>
                    </xsl:attribute>
                  </fo:page-number-citation>
                </fo:inline>
              </fo:basic-link>
            </xsl:variable>
            <xsl:apply-templates select="$topicType" mode="toc-topic-text">
              <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
              <xsl:with-param name="currentNode" select="."/>
              <xsl:with-param name="pubRegion" as="xs:string" tunnel="yes" select="$pubRegion"/>
            </xsl:apply-templates>
          </fo:block>
          <!-- In a future version, suppressing Notices in the TOC should not be hard-coded. -->
          <xsl:if test="not($topicType = 'topicNotices')">
            <xsl:apply-templates mode="toc">
              <xsl:with-param name="include" select="'true'"/>
              <xsl:with-param name="pubRegion" as="xs:string" tunnel="yes" select="$pubRegion"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="toc">
            <xsl:with-param name="include" select="'true'"/>
            <xsl:with-param name="pubRegion" as="xs:string" tunnel="yes" select="$pubRegion"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
