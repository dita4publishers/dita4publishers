<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns="http://www.daisy.org/z3986/2005/ncx/"
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms"
  >
  <!-- Convert a DITA map to an EPUB toc.ncx file. -->
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
  

  <xsl:output indent="yes" name="ncx" method="xml"/>


  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-toc">
    <xsl:param name="index-terms" as="element()"/>
    <xsl:variable name="pubTitle" as="xs:string*">
      <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
    </xsl:variable>           
    <xsl:variable name="resultUri" 
      select="relpath:newFile($outdir, 'toc.ncx')" 
      as="xs:string"/>
    <xsl:if test="false()">
      <xsl:message> + [DEBUG] navPoints
        
        <xsl:for-each select="//*[local:isNavPoint(.)]">
 + [DEBUG] <xsl:copy/>
        </xsl:for-each>
        
      </xsl:message>
    </xsl:if>
    
    <xsl:message> + [INFO] Constructing effective ToC structure...</xsl:message>
    
    <!-- Build the ToC tree so we can then calculate the playorder of the navitems. -->
    <xsl:variable name="navmap" as="element()">
      <!-- kindlegen does not like the ncx prefix -->
      <!--<ncx:navMap>-->
      <navMap>
        <xsl:choose>
          <xsl:when test="$pubTitle != ''">
            <!-- FIXME: If there is a pubtitle, generate a root navPoint for the title.
              
              This will require generating an HTML file to represent the whole publication,
              e.g., as for topicheads. This would be a good opportunity to generate a
              document cover, which should be defined as an extension point.
            -->
            <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="1"/>              
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="1"/>                            
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>        
        <xsl:if test="$index-terms/index-terms:index-term">
          <xsl:message> + [DEBUG] found index terms, adding navpoint to generated index...</xsl:message>
          <navPoint id="{generate-id($index-terms)}"
            > 
            <navLabel>
              <text>Index</text>
            </navLabel>
            <content src="generated-index.html"/>
          </navPoint>          
        </xsl:if>
      </navMap>
    </xsl:variable>
        
    <xsl:message> + [INFO] Generating ToC (NCX) file "<xsl:sequence select="$resultUri"/>"...</xsl:message>
    
    <xsl:result-document href="{$resultUri}" format="ncx">
      <ncx xmlns="http://www.daisy.org/z3986/2005/ncx/"
        version="2005-1" xml:lang="en">
        <head xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">
          <meta name="dtb:uid" content="{$idURIStub}{@id}"/>
          <meta name="dtb:depth" content="1"/>
          <meta name="dtb:totalPageCount" content="0"/>
          <meta name="dtb:maxPageNumber" content="0"/>
        </head>
        <docTitle xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/">          
          <text><xsl:sequence select="$pubTitle"/></text>
        </docTitle>
        <xsl:apply-templates select="$navmap" mode="calc-play-order"/>
      </ncx>
    </xsl:result-document>  
    <xsl:message> + [INFO] ToC generation done.</xsl:message>
  </xsl:template>
  
  <xsl:template mode="calc-play-order" match="ncx:navPoint">
    <xsl:variable name="playOrder">
      <xsl:number  count="ncx:navPoint" level="any" format="1"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="playOrder" select="$playOrder"/>
      <xsl:apply-templates select="@*,*" mode="#current"/>      
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="calc-play-order" match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="calc-play-order" match="@*|text()" priority="-1">
    <xsl:copy/>
  </xsl:template>

  <!-- Convert each topicref to a navPoint. -->
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
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
          <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, root($topic))" as="xs:string"/>
          <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
          <navPoint id="{generate-id()}"
            > 
            <navLabel>
              <xsl:variable name="enumeration" as="xs:string?">
                <xsl:apply-templates select="." mode="enumeration"/>
              </xsl:variable>
              <text><xsl:value-of select="
                if ($enumeration = '')
                   then normalize-space($navPointTitle)
                   else concat($enumeration, ' ', $navPointTitle)
                   "/></text>
            </navLabel>
            <content src="{$relativeUri}"/>
            <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
            -->
            <xsl:apply-templates mode="#current" 
              select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                select="$tocDepth + 1"
              />
            </xsl:apply-templates>
          </navPoint>
        </xsl:otherwise>
      </xsl:choose>    
    </xsl:if>    
  </xsl:template>
  
  <xsl:template mode="nav-point-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="navPointTitleString" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$navPointTitleString"/>    
  </xsl:template>
    
  <xsl:template match="*[df:isTopicGroup(.)]" priority="10" mode="generate-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="rawNavPointTitle" as="xs:string*">
        <xsl:apply-templates select="." mode="nav-point-title"/>
      </xsl:variable>
      <xsl:variable name="navPointTitle" select="normalize-space(string-join($rawNavPointTitle, ' '))" as="xs:string"/>
  <!--    <xsl:message> + [DEBUG] isTopicGroup(): navPointTitle="<xsl:sequence select="$navPointTitle"/>"</xsl:message>-->
      <xsl:choose>
        <xsl:when test="$navPointTitle != ''">
          <navPoint id="{generate-id()}"
            > 
            <navLabel>
              <text><xsl:sequence select="$navPointTitle"/></text>
            </navLabel>
            <!-- FIXME: This is bogus, but we should never get here. -->
            <content src="topics/topicgroup_00000.html"/>          
            <xsl:apply-templates select="*[df:class(.,'map/topicref')]" mode="#current">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                select="$tocDepth + 1"
              />            
            </xsl:apply-templates>
          </navPoint>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-toc">
    <!-- Non-root topics generate ToC entries if they are within the ToC depth -->
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="rawNavPointTitle" as="xs:string*">
        <xsl:apply-templates select="*[df:class(., 'topic/title')]" mode="nav-point-title"/>
      </xsl:variable>
      <xsl:variable name="navPointTitle" select="normalize-space(string-join($rawNavPointTitle, ' '))" as="xs:string"/>
      <navPoint id="{generate-id()}"
        > 
        <navLabel>
          <text><xsl:sequence select="$navPointTitle"/></text>
        </navLabel>
        <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, root(.))" as="xs:string"/>
        <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
        <!-- FIXME: Likely need to map input IDs to output IDs. -->
        <xsl:variable name="fragId" as="xs:string"
          select="string(@id)"
        />
        <content src="{concat($relativeUri, '#', $fragId)}"/>          
        <xsl:apply-templates select="*[df:class(.,'topic/topic')]" mode="#current">
          <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
            select="$tocDepth + 1"
          />
        </xsl:apply-templates>
      </navPoint>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="#all" match="*[df:class(., 'map/topicref') and (@processing-role = 'resource-only')]" priority="20"/>


  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="titleOnlyTopicFilename" as="xs:string"
        select="normalize-space(htmlutil:getTopicheadHtmlResultTopicFilename(.))"
      />
      <xsl:variable name="rawNavPointTitle" as="xs:string*">
        <xsl:apply-templates select="." mode="nav-point-title"/>
      </xsl:variable>
      <navPoint id="{generate-id()}"
        > 
        <navLabel>
          <xsl:variable name="enumeration" as="xs:string?">
            <xsl:apply-templates select="." mode="enumeration"/>
          </xsl:variable>
          <text><xsl:value-of select="
            if ($enumeration = '')
            then normalize-space($rawNavPointTitle)
            else concat($enumeration, ' ', $rawNavPointTitle)
            "/></text>
        </navLabel>
        <xsl:variable name="contentUri" as="xs:string"
          select="          
          if ($topicsOutputDir != '') 
          then concat($topicsOutputDir, '/', $titleOnlyTopicFilename) 
          else $titleOnlyTopicFilename"
        />
        <content src="{$contentUri}"/>                
        <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
          <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
            select="$tocDepth + 1"
          />        
        </xsl:apply-templates>
      </navPoint>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- Per the 1.2 spec, topic group navtitles are always ignored -->
  </xsl:template>
  
<!--  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/title')]" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
-->  
<!--  WEK: included #default mode, which is bad. -->

  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tm')]" mode="generate-toc"> 
    <xsl:apply-templates mode="#current"/>
    <xsl:choose>
      <xsl:when test="@type = 'reg'">
        <xsl:text>[reg]</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'sm'">
        <xsl:text>[sm]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[tm]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    
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
