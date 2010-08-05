<!-- Convert a DITA map to an EPUB toc.ncx file. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:epubutil="http://dita4publishers.org/functions/epubutil"
                xmlns="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath epubutil"
  >
  
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  <xsl:import href="epub-generation-utils.xsl"/>
  
  <xsl:param name="IdURIStub">http://example.org/dummy/URIstub/</xsl:param>

  <xsl:strip-space elements="*"/>
  <xsl:output indent="yes" name="ncx" method="xml"/>


  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-toc">
    <xsl:variable name="pubTitle" as="xs:string">
      <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
    </xsl:variable>           
    <xsl:variable name="resultUri" 
      select="relpath:newFile($outdir, 'toc.ncx')" 
      as="xs:string"/>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] navPoints
        
        <xsl:for-each select="//*[local:isNavPoint(.)]">
 + [DEBUG] <xsl:copy/>
        </xsl:for-each>
        
      </xsl:message>
    </xsl:if>
    
    <xsl:message> + [INFO] Generating ToC (NCX) file "<xsl:sequence select="$resultUri"/>"...</xsl:message>
    
    <xsl:result-document href="{$resultUri}" format="ncx">
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
              <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
            </xsl:otherwise>
          </xsl:choose>
          
        </navMap>
      </ncx>
    </xsl:result-document>  
    <xsl:message> + [INFO] ToC generation done.</xsl:message>
  </xsl:template>
  

  <!-- Convert each topicref to a navPoint. -->
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-toc">
    <!-- For title that shows up in ncx:text, use the navtitle. If it's
    not there, use the first title element in the referenced file. -->
    <xsl:variable name="navPointTitle">
      <xsl:apply-templates select="." mode="nav-point-title"/>      
    </xsl:variable>
    
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetUri" select="epubutil:getTopicResultUrl($topicsOutputPath, root($topic))" as="xs:string"/>
        <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
        <navPoint id="{generate-id()}"
                      playOrder="{local:getPlayOrder(.)}"> 
          <navLabel>
            <text><xsl:value-of select="$navPointTitle"/></text>
          </navLabel>
          <content src="{$relativeUri}"/>
          <xsl:apply-templates mode="#current"/>
        </navPoint>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template mode="nav-point-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="navPointTitleString" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$navPointTitleString"/>    
  </xsl:template>
    
  <xsl:template match="*[df:isTopicGroup(.)]" priority="10" mode="generate-toc">
    <xsl:variable name="navPointTitle" as="xs:string*">
      <xsl:apply-templates select="." mode="nav-point-title"/>
    </xsl:variable>
<!--    <xsl:message> + [DEBUG] isTopicGroup(): navPointTitle="<xsl:sequence select="$navPointTitle"/>"</xsl:message>-->
    <xsl:choose>
      <xsl:when test="normalize-space(string-join($navPointTitle, ' ')) != ''">
        <navPoint id="{generate-id()}"
          playOrder="{local:getPlayOrder(.)}"> 
          <navLabel>
            <text><xsl:sequence select="$navPointTitle"/></text>
          </navLabel>
          <xsl:apply-templates select="*[df:class(.,'map/topicref')]" mode="#current"/>
        </navPoint>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template mode="#all" match="*[df:class(., 'map/topicref') and (@processing-role = 'resource-only')]" priority="20"/>


  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[df:isTopicHead(.) or df:isTopicGroup(.)]" mode="generate-toc">
    <navPoint id="{generate-id()}"
      playOrder="{local:getPlayOrder(.)}"> 
      <navLabel>
        <text><xsl:apply-templates select="." mode="nav-point-title"/></text>
      </navLabel>
      <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
    </navPoint>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- By default, topic groups have no titles -->
  </xsl:template>
  
  <xsl:template mode="nav-point-title #default" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tm')]" mode="generate-toc"> 
    <xsl:apply-templates mode="#current"/><xsl:text>[tm]</xsl:text>
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
    " mode="generate-toc">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/title')]//text()" mode="generate-toc">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="text()" mode="generate-toc"/>
  
  <xsl:function name="local:getPlayOrder" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="playOrder" as="xs:string">
      <xsl:number count="*[local:isNavPoint(.)]" level="any" format="1" select="$context"/>      
    </xsl:variable> 
<!--    <xsl:message> + [DEBUG] getPlayOrder: playOrder="<xsl:sequence select="$playOrder"/>"</xsl:message>-->
    <xsl:sequence select="string($playOrder)"/>
  </xsl:function>
  
  <xsl:function name="local:isNavPoint" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:choose>
      <xsl:when test="$context/@processing-role = 'resource-only'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:when test="df:isTopicRef($context) or df:isTopicHead($context)">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:when test="df:isTopicGroup($context)">
        <xsl:variable name="navPointTitle" as="xs:string*">
          <xsl:apply-templates select="$context" mode="nav-point-title"/>
        </xsl:variable>
        <!-- If topic head has a title (e.g., a generated title), then it 
             acts as a navigation point.
          -->
        <xsl:sequence
           select="normalize-space(string-join($navPointTitle, ' ')) != ''"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>


</xsl:stylesheet>
