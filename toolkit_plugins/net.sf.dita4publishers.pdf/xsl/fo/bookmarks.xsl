<?xml version='1.0'?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:exsl="http://exslt.org/common"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:dita-ot-pdf="http://net.sf.dita-ot/transforms/pdf"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="opentopic-index opentopic dita-ot-pdf xs"
  version="2.0">

  <!-- ==============================
       Override of base bookmarks.xsl
       ============================== -->


  <xsl:template
    match="*[contains(@class, ' topic/topic ')]"
    mode="bookmark">
    <xsl:param name="pubRegion" as="xs:string" select="dita-ot-pdf:getPublicationRegion(.)" tunnel="yes"/>
    <xsl:variable
      name="id"
      select="@id"/>
    <xsl:variable
      name="gid"
      select="generate-id()"/>
    <xsl:variable
      name="topicNumber"
      select="count($topicNumbers/topic[@id = $id][following-sibling::topic[@guid = $gid]]) + 1"/>
    <xsl:variable
      name="topicTitle">
      <xsl:call-template
        name="getNavTitle">
        <xsl:with-param
          name="topicNumber"
          select="$topicNumber"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- normalize the title bug:3065853 -->
    <xsl:variable as="xs:string"
      name="normalizedTitle"
      select="normalize-space($topicTitle)"/>
    <xsl:variable
      name="mapTopic" as="element()?"
      select="/*/opentopic:map//*[@id = $id]"
    />

    <xsl:choose>
      <xsl:when
        test="($mapTopic/*[position() = $topicNumber][@toc = 'yes' or not(@toc)]) or (not($mapTopic/*))">
        <fo:bookmark>
          <xsl:attribute
            name="internal-destination">
            <xsl:call-template
              name="generate-toc-id"/>
          </xsl:attribute>
          <xsl:if
            test="$bookmarkStyle!='EXPANDED'">
            <xsl:attribute
              name="starting-state" select="'hide'"/>
          </xsl:if>
          <fo:bookmark-title>
            <xsl:sequence
              select="$normalizedTitle"/>
          </fo:bookmark-title>
          <xsl:apply-templates
            mode="bookmark">
            <xsl:with-param name="pubRegion" tunnel="yes" as="xs:string"
              select="$pubRegion"
            />
          </xsl:apply-templates>
        </fo:bookmark>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates
          mode="bookmark">
          <xsl:with-param name="pubRegion" tunnel="yes" as="xs:string"
            select="$pubRegion"
          />          
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
