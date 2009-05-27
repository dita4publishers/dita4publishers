<!-- Convert a DITA map to an EPUB toc.ncx file. -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">

  <xsl:param name="IdURIStub">http://example.org/dummy/URIstub/</xsl:param>

  <xsl:strip-space elements="*"/>
  <xsl:output indent="yes"/>


  <xsl:template match="*[contains(@class,' map/map ')]">
    <ncx xmlns="http://www.daisy.org/z3986/2005/ncx/"
         version="2005-1" xml:lang="en">
      <head xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">
        <meta name="dtb:uid" content="{$IdURIStub}{@id}"/>
        <meta name="dtb:depth" content="1"/>
        <meta name="dtb:totalPageCount" content="0"/>
        <meta name="dtb:maxPageNumber" content="0"/>
      </head>
      <docTitle xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">
        <!-- title is an attribute of map, but bookmap puts title in
             bookmap/booktitle/mainbooktitle -->
        <text>
          <xsl:choose>
            <xsl:when test="*[contains(@class,' bookmap/booktitle ')]/
                            *[contains(@class,' bookmap/mainbooktitle ')]">
              <xsl:value-of select="*[contains(@class,' bookmap/booktitle ')]/
                                    *[contains(@class,' bookmap/mainbooktitle ')]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@title"/>
            </xsl:otherwise>
          </xsl:choose>
        </text>
      </docTitle>
      <navMap>
        <xsl:apply-templates select="*[contains(@class,' map/topicref ')]"/>
      </navMap>
    </ncx>

  </xsl:template>


  <!-- Convert each topicref to a navPoint. -->
  <xsl:template match="*[contains(@class,' map/topicref ')][@href]"
                xmlns="http://www.daisy.org/z3986/2005/ncx/">
    <!-- For title that shows up in ncx:text, use the navtitle. If it's
    not there, use the first title element in the referenced file. -->
    <xsl:variable name="navPointTitleBase">
      <xsl:choose>
        <xsl:when test="@navtitle and string(@navtitle) != ''">
          <xsl:value-of select="@navtitle"/>
        </xsl:when>
<!--        <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]">
          <!- Navtitle is added in DITA 1.2 ->
          <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]"/>
          <xsl:message> + [DEBUG] navtitle subelement found"</xsl:message>
        </xsl:when>
--> 
        <xsl:otherwise>
          <xsl:variable name="hrefValue" select="@href"/>
          <xsl:variable name="topicId">
            <xsl:choose>
              <xsl:when test="contains($hrefValue, '#')">
                <xsl:value-of select="substring-after($hrefValue, '#')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="''"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="docUri">
            <xsl:choose>
              <xsl:when test="contains($hrefValue, '#')">
                <xsl:value-of select="substring-before($hrefValue, '#')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$hrefValue"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="targetDoc" select="document($docUri, .)"/>
          <!-- FIXME: doesn't account for <dita> case -->
          <xsl:choose>
            <xsl:when test="$topicId = ''">
              <xsl:variable name="targetTopic" select="$targetDoc/*[1]"/>
              <xsl:message> + [DEBUG] targetTopic=<xsl:value-of select="name($targetTopic)"/>: </xsl:message>
              <xsl:variable name="title">
                <xsl:apply-templates
                  select="$targetTopic/*[contains(@class,' topic/title ')]"/>
              </xsl:variable>
              <xsl:message> + [DEBUG] title="<xsl:value-of select="$title"/></xsl:message>
              <xsl:apply-templates
                select="$targetTopic/*[contains(@class,' topic/title ')]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="targetTopic" 
                select="$targetDoc/*[contains(@class,' topic/topic ') and @id = $topicId]"/>
              <xsl:variable name="title">
                <xsl:apply-templates
                select="$targetTopic/*[contains(@class,' topic/title ')]"/>
              </xsl:variable>
              <xsl:message> + [DEBUG] title="<xsl:value-of select="$title"/></xsl:message>
              <xsl:apply-templates
                select="$targetTopic/*[contains(@class,' topic/title ')]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="navPointTitle">
      <xsl:apply-templates select="." mode="nav-point-title">
        <xsl:with-param name="navPointTitleBase" select="$navPointTitleBase"/>
      </xsl:apply-templates>
    </xsl:variable>
    
    <navPoint id="{generate-id()}"
                  playOrder="{count(preceding::*[contains(@class,' map/topicref ')]) +
                             count(ancestor::*[contains(@class,' map/topicref ')]) + 1}"> 
      <navLabel>
        <text><xsl:value-of select="$navPointTitle"/></text>
      </navLabel>
      <content src="{substring-before(@href,'.xml')}.html"/>
      <xsl:apply-templates/>
    </navPoint>
  </xsl:template>
  
  <xsl:template mode="nav-point-title" match="*[contains(@class, ' map/topicref ')]">
    <xsl:param name="navPointTitleBase"/>
    <xsl:value-of select="$navPointTitleBase"/>
  </xsl:template>
  
  <xsl:template mode="nav-point-title" match="*[contains(@class, ' pubmap/chapter ')]" priority="10">
    <xsl:param name="navPointTitleBase"/>
    <xsl:text>Chapter </xsl:text>
    <xsl:number count="*[contains(@class, ' pubmap/chapter ')]"
      from="*[contains(@class, ' pubmap/pubbody ')]"
      level="any"
      format="1."
    />
    <xsl:text>&#xa0;</xsl:text>
    <xsl:value-of select="$navPointTitleBase"/>
  </xsl:template>
  
  <xsl:template match="*[contains(./@class,' pubmap/pubbody ')] |
    *[contains(./@class,' pubmap/covers ')] |
    *[contains(./@class,' pubmap/frontmatter ')] |
    *[contains(./@class,' pubmap/backmatter ')]
    " priority="10">
    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]"/>
  </xsl:template>


  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[contains(@class,' mapgroup-d/topichead ')] |
                       *[contains(@class,' map/topicref ')][not(@href)]"
                xmlns="http://www.daisy.org/z3986/2005/ncx/">
    <navPoint id="{generate-id()}"
                  playOrder="{count(preceding::*[contains(@class,' map/topicref ')]) +
                             count(ancestor::*[contains(@class,' map/topicref ')]) + 1}"> 
      <navLabel>
        <xsl:variable name="navtitleText">        
          <xsl:choose>
            <xsl:when test="contains(./@class,' bookmap/frontmatter ')">
              <xsl:value-of select="'Frontmatter'"/>
            </xsl:when>
            <xsl:when test="contains(@class,' bookmap/backmatter ')">
              <xsl:value-of select="'Backmatter'"/>
            </xsl:when>
            <xsl:when test="contains(./@class,' pubmap/appendixes ')">
              <xsl:value-of select="'Appendixes'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@navtitle"/>            
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <text><xsl:value-of select="$navtitleText"/></text>
      </navLabel>
      <content src=""/>
      <xsl:apply-templates/>
    </navPoint>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/tm ')]"> 
    <xsl:apply-templates/><xsl:text>[tm]</xsl:text>
  </xsl:template>
  
  <xsl:template match="
    *[contains(@class,' topic/topicmeta ')] | 
    *[contains(@class,' map/navtitle ')] | 
    *[contains(@class,' topic/title ')] | 
    *[contains(@class,' topic/ph ')] |
    *[contains(@class,' topic/cite ')] |
    *[contains(@class,' topic/image ')] |
    *[contains(@class,' topic/keyword ')] |
    *[contains(@class,' topic/term ')]
    ">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/title ')]//text()">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="text()"/>


</xsl:stylesheet>
