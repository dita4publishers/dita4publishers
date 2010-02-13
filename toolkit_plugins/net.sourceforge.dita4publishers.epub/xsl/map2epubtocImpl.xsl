<!-- Convert a DITA map to an EPUB toc.ncx file. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl"
  >
  
  <xsl:import href="lib/dita-support-lib.xsl"/>
  
  <xsl:include href="map2epubCommon.xsl"/>

  <xsl:param name="IdURIStub">http://example.org/dummy/URIstub/</xsl:param>

  <xsl:strip-space elements="*"/>
  <xsl:output indent="yes"/>


  <xsl:template match="*[df:class(., 'map/map')]">
    <xsl:variable name="pubTitle" as="xs:string">
      <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
    </xsl:variable>           
      
    <ncx xmlns="http://www.daisy.org/z3986/2005/ncx/"
         version="2005-1" xml:lang="en">
      <head xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">
        <meta name="dtb:uid" content="{$IdURIStub}{@id}"/>
        <meta name="dtb:depth" content="1"/>
        <meta name="dtb:totalPageCount" content="0"/>
        <meta name="dtb:maxPageNumber" content="0"/>
      </head>
      <docTitle xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">

        <text><xsl:sequence select="$pubTitle"/></text>
      </docTitle>
      <navMap>
        <xsl:choose>
          <xsl:when test="$pubTitle != ''">
            <!-- FIXME: If there is a pubtitle, generate a root navPoint for the title.
                        This will require passing down a parameter with the offset to
                        use for calculating playOrder.
                        
                        When I created a root node, Adobe Digital Editions refused
                        to show it in the TOC view.
              -->
            <xsl:apply-templates select="*[df:class(., 'map/topicref')]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="*[df:class(., 'map/topicref')]"/>
          </xsl:otherwise>
        </xsl:choose>
        
      </navMap>
    </ncx>

  </xsl:template>
  

  <!-- Convert each topicref to a navPoint. -->
  <xsl:template match="*[df:isTopicRef(.)]"
                xmlns="http://www.daisy.org/z3986/2005/ncx/">
    <!-- For title that shows up in ncx:text, use the navtitle. If it's
    not there, use the first title element in the referenced file. -->
    <xsl:variable name="navPointTitle">
      <xsl:apply-templates select="." mode="nav-point-title"/>      
    </xsl:variable>
    
    <navPoint id="{generate-id()}"
                  playOrder="{local:getPlayOrder(.)}"> 
      <navLabel>
        <text><xsl:value-of select="$navPointTitle"/></text>
      </navLabel>
      <content src="{substring-before(@href,'.xml')}.html"/>
      <xsl:apply-templates/>
    </navPoint>
  </xsl:template>
  
  <xsl:template mode="nav-point-title" match="*[df:class(., 'map/topicref')]">
    <xsl:variable name="navPointTitleString" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$navPointTitleString"/>    
  </xsl:template>
    
  <xsl:template match="*[df:isTopicGroup(.)]" priority="10">
    <xsl:apply-templates select="*[df:class(., 'map/topicref')]"/>
  </xsl:template>


  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[df:isTopicHead(.)]"
                xmlns="http://www.daisy.org/z3986/2005/ncx/">
    <navPoint id="{generate-id()}"
      playOrder="{local:getPlayOrder(.)}"> 
      <navLabel>
        <text><xsl:apply-templates select="." mode="nav-point-title"/></text>
      </navLabel>
      <content src=""/>
      <xsl:apply-templates/>
    </navPoint>
  </xsl:template>

  <xsl:template match="*[df:class(.,' bookmap/frontmatter')]" priority="10" mode="nav-point-title">
    <xsl:value-of select="'Frontmatter'"/>
  </xsl:template>
  <xsl:template match="*[df:class(., 'bookmap/backmatter')]" priority="10" mode="nav-point-title">
    <xsl:value-of select="'Backmatter'"/>
  </xsl:template>
  <xsl:template match="*[df:class(.,' pubmap/appendixes')]" priority="10" mode="nav-point-title">
    <xsl:value-of select="'Appendixes'"/>
  </xsl:template>
  
  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/fn')]">
    <!-- Suppress footnotes in titles -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tm')]"> 
    <xsl:apply-templates/><xsl:text>[tm]</xsl:text>
  </xsl:template>
  
  <xsl:template match="
    *[df:class(., 'topic/topicmeta')] | 
    *[df:class(., 'map/navtitle')] | 
    *[df:class(., 'topic/title')] | 
    *[df:class(., 'topic/ph')] |
    *[df:class(., 'topic/cite')] |
    *[df:class(., 'topic/image')] |
    *[df:class(., 'topic/keyword')] |
    *[df:class(., 'topic/term')]
    ">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/title')]//text()">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="text()"/>
  
  <xsl:function name="local:getPlayOrder" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="playOrder" 
      select="count($context/preceding::*[df:class(., 'map/topicref') and not(@processing-role = 'resource-only')]) + 
      count($context/ancestor::*[df:class(., 'map/topicref') and not(@processing-role = 'resource-only')]) +
      1" as="xs:integer"/>
<!--    <xsl:message> + [DEBUG] getPlayOrder: playOrder="<xsl:sequence select="$playOrder"/>"</xsl:message>-->
    <xsl:sequence select="string($playOrder)"/>
  </xsl:function>


</xsl:stylesheet>
