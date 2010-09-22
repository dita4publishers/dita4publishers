<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"

  xmlns:local="urn:functions:local"
  
  xmlns="http://www.w3.org/1999/xhtml"
  
  exclude-result-prefixes="local xs df xsl relpath kindleutil index-terms">

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="kindle-generation-utils.xsl"/>

  <xsl:output indent="yes" name="html" method="html"/>


  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-html-toc">
    <xsl:param name="index-terms" as="element()"/>
    <xsl:variable name="pubTitle" as="xs:string*">
      <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
    </xsl:variable>
    <xsl:variable name="resultUri" select="relpath:newFile($outdir, 'toc.html')" as="xs:string"/>
    <xsl:if test="false()">
      <xsl:message> + [DEBUG] navPoints <xsl:for-each select="//*[local:isHtmlNavPoint(.)]"> +
          [DEBUG] <xsl:copy/>
        </xsl:for-each>
      </xsl:message>
    </xsl:if>

    <xsl:message> + [INFO] Constructing effective ToC structure for HTML ToC...</xsl:message>

    <!-- Build the ToC tree so we can then calculate the playorder of the navitems. -->

    <xsl:variable name="navmap" as="element()">

        <div class="main">
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
          <xsl:message> + [DEBUG] found index terms, adding navpoint to generated
            index...</xsl:message>
          <div class="navPoint-index" id="{generate-id($index-terms)}">
            <a href="generated-index.html">Index</a>
          </div>
        </xsl:if>
        </div>
    </xsl:variable>

    <xsl:message> + [INFO] Generating HTML ToC file "<xsl:sequence select="$resultUri"/>"...</xsl:message>

    <xsl:result-document href="{$resultUri}" format="html" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
      <html>
        <head>
          <title>Table of Contents</title>
        </head>
        <body>
          <xsl:apply-templates select="$navmap" mode="html-toc"/>
        </body>
     </html>
    </xsl:result-document>
    <xsl:message> + [INFO] HTML ToC generation done.</xsl:message>
  </xsl:template>

  <xsl:template mode="html-toc" match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
    </xsl:template>

  <xsl:template mode="html-toc" match="@*|text()" priority="-1">
    <xsl:copy/>
  </xsl:template>
  
<!-- ================================================================================== -->

  <!-- Convert each topicref to a navPoint. -->
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-html-toc">
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
          <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence
              select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="targetUri"
            select="kindleutil:getTopicResultUrl($topicsOutputPath, root($topic))" as="xs:string"/>
          <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
            as="xs:string"/>
          <div class="navPoint-{$tocDepth}" id="{generate-id()}">
              <div class="navLabel-{$tocDepth}">
              <xsl:variable name="enumeration" as="xs:string?">
                <xsl:apply-templates select="." mode="enumeration"/>
              </xsl:variable>
              <a href="{$relativeUri}">
                <xsl:value-of
                  select="
                  if ($enumeration = '')
                  then normalize-space($navPointTitle)
                  else concat($enumeration, ' ', $navPointTitle)
                  "
                />
              </a>
            </div>

            <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
            -->
            <xsl:apply-templates mode="#current"
              select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
            </xsl:apply-templates>
              </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="nav-point-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="navPointTitleString" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$navPointTitleString"/>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" priority="10" mode="generate-html-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="rawNavPointTitle" as="xs:string*">
        <xsl:apply-templates select="." mode="nav-point-title"/>
      </xsl:variable>
      <xsl:variable name="navPointTitle"
        select="normalize-space(string-join($rawNavPointTitle, ' '))" as="xs:string"/>
      <xsl:choose>
        <xsl:when test="$navPointTitle != ''">
          <div class="navPoint-{$tocDepth}" id="{generate-id()}">
            <div class="navLabel-{$tocDepth}">
              <!-- FIXME: This is bogus, but we should never get here. -->
              <a href="topics/topicgroup_00000.html">
                <xsl:sequence select="$navPointTitle"/>
              </a>
            </div>
            
            <xsl:apply-templates select="*[df:class(.,'map/topicref')]" mode="#current">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
            </xsl:apply-templates>
            </div>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-html-toc">
    <!-- Non-root topics generate ToC entries if they are within the ToC depth -->
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="rawNavPointTitle" as="xs:string*">
        <xsl:apply-templates select="*[df:class(., 'topic/title')]" mode="nav-point-title"/>
      </xsl:variable>
      <xsl:variable name="navPointTitle"
        select="normalize-space(string-join($rawNavPointTitle, ' '))" as="xs:string"/>
      <div class="navPoint-{$tocDepth}" id="{generate-id()}">
        <div class="navLabel-{$tocDepth}">
<!--      get rid of this and make the div wrap around link

<p><xsl:sequence select="$navPointTitle"/></p>-->

        <xsl:variable name="targetUri"
          select="kindleutil:getTopicResultUrl($topicsOutputPath, root(.))" as="xs:string"/>
        <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
          as="xs:string"/>
        <!-- FIXME: Likely need to map input IDs to output IDs. -->
        <xsl:variable name="fragId" as="xs:string" select="string(@id)"/>
        <a href="{concat($relativeUri, '#', $fragId)}"><xsl:sequence select="$navPointTitle"/></a>
        <xsl:apply-templates select="*[df:class(.,'topic/topic')]" mode="#current">
          <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
        </xsl:apply-templates>
        </div>
        </div>
    </xsl:if>
  </xsl:template>
  <!-- ========================================================================== -->
  <xsl:template mode="#all"
    match="*[df:class(., 'map/topicref') and (@processing-role = 'resource-only')]" priority="20"/>

  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-html-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="titleOnlyTopicFilename" as="xs:string"
        select="normalize-space(kindleutil:getTopicheadHtmlResultTopicFilename(.))"/>
      <xsl:variable name="rawNavPointTitle" as="xs:string*">
        <xsl:apply-templates select="." mode="nav-point-title"/>
      </xsl:variable>
      <div class="navPoint-{$tocDepth}" id="{generate-id()}">

          <xsl:variable name="enumeration" as="xs:string?">
            <xsl:apply-templates select="." mode="enumeration"/>
          </xsl:variable>
        
        <xsl:variable name="contentUri" as="xs:string"
          select="          
          if ($topicsOutputDir != '') 
          then concat($topicsOutputDir, '/', $titleOnlyTopicFilename) 
          else $titleOnlyTopicFilename"/>
        <a href="{$contentUri}">
          <xsl:value-of
            select="
            if ($enumeration = '')
            then normalize-space($rawNavPointTitle)
            else concat($enumeration, ' ', $rawNavPointTitle)
            "
          />
        </a>
        <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
          <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
        </xsl:apply-templates>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- Per the 1.2 spec, topic group navtitles are always ignored -->
  </xsl:template>

  <xsl:template mode="nav-point-title #default" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/tm')]" mode="generate-html-toc">
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

  <xsl:template
    match="
    *[df:class(., 'topic/topicmeta')] | 
    *[df:class(., 'map/navtitle')] | 
    *[df:class(., 'topic/title')] | 
    *[df:class(., 'topic/ph')] |
    *[df:class(., 'topic/cite')] |
    *[df:class(., 'topic/image')] |
    *[df:class(., 'topic/keyword')] |
    *[df:class(., 'topic/term')]
    "
    mode="generate-html-toc">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/title')]//text()" mode="generate-html-toc">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="text()" mode="generate-html-toc"/>

  <xsl:function name="local:isHtmlNavPoint" as="xs:boolean">
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
        <xsl:sequence select="normalize-space(string-join($navPointTitle, ' ')) != ''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>


</xsl:stylesheet>
