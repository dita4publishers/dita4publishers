<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ncx="http://www.daisy.org/z3986/2005/ncx/"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns="http://www.daisy.org/z3986/2005/ncx/" xmlns:local="urn:functions:local"
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
      <!-- kindlegen does not like the ncx prefix -->
      <!--<ncx:navMap>-->
      <!--<navMap>-->
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
          <!-- ================================= -->
          <!-- adding div to see if it will work -->
          <!-- commenting out navPoint to see if it breaks anything -->
          <!-- I do not see this showing up in the html toc at all, because no evidence of the paragraphs below -->
          <!--<navPoint id="{generate-id($index-terms)}">-->
          <div class="navPoint" id="{generate-id($index-terms)}">
            <!--<p>This is contained in a div of class "navPoint" that used to be an NCX navPoint.</p>
            <p>This contained index terms in generate id variable.</p>
            <p>This is in &lt;xsl:template match="*[df:class(., 'map/map')]"
              mode="generate-html-toc"&gt;</p>-->
            <navLabel>
              <text>Index</text>
            </navLabel>
            <content src="generated-index.html"/>
          </div>
          <!--</navPoint>-->
        </xsl:if>
        </div>
      <!--</navMap>-->
    </xsl:variable>

    <xsl:message> + [INFO] Generating HTML ToC file "<xsl:sequence select="$resultUri"
      />"...</xsl:message>

    <xsl:result-document href="{$resultUri}" format="html">
      <html>
        <head>
          <title>Table of Contents</title>
        </head>
        <body>
          <xsl:apply-templates select="$navmap" mode="calc-play-order-html"/>
        </body>
      </html>
    </xsl:result-document>
    <xsl:message> + [INFO] HTML ToC generation done.</xsl:message>
  </xsl:template>

  <xsl:template mode="calc-play-order-html" match="ncx:navPoint">
    <xsl:variable name="playOrder">
      <xsl:number count="ncx:navPoint" level="any" format="1"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="playOrder" select="$playOrder"/>
      <xsl:apply-templates select="@*,*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="calc-play-order-html" match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="calc-play-order-html" match="@*|text()" priority="-1">
    <xsl:copy/>
  </xsl:template>

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
          <!-- =============================================== -->
          <!-- ============= adding div worked =============== -->
          <!-- = commenting out navPoint to see if it breaks = -->
          <!--<navPoint id="{generate-id()}">-->
            <div class="navPoint" id="{generate-id()}">
            <!--<p>This is in &lt;xsl:template match="*[df:isTopicRef(.)]"
            mode="generate-html-toc"&gt;</p>
              <p>Used to have a navPoint here.</p>-->
            <div class="navLabel">
              <xsl:variable name="enumeration" as="xs:string?">
                <xsl:apply-templates select="." mode="enumeration"/>
              </xsl:variable>
              <a href="{$relativeUri}">
                <!-- the following value-of used to be the content of a "text" element for the NCX file
                      now it supplies the text for an "a" element -->
                <xsl:value-of
                  select="
                  if ($enumeration = '')
                  then normalize-space($navPointTitle)
                  else concat($enumeration, ' ', $navPointTitle)
                  "
                />
              </a>
            </div>
            <content src="{$relativeUri}"/>

            <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
            -->
            <xsl:apply-templates mode="#current"
              select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
            </xsl:apply-templates>
              </div>
          <!--</navPoint>-->
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
      <!--    <xsl:message> + [DEBUG] isTopicGroup(): navPointTitle="<xsl:sequence select="$navPointTitle"/>"</xsl:message>-->
      <xsl:choose>
        <xsl:when test="$navPointTitle != ''">
          <!-- ===================================================== -->
          <!-- =========== adding div 7 21 pm ====================== -->
          <!-- ===== commenting out navPoint 7 28 pm =============== -->
          <!--<navPoint id="{generate-id()}">-->
            <div class="navPoint" id="{generate-id()}">
            <p>This is in &lt;xsl:template match="*[df:isTopicGroup(.)]" priority="10"
              mode="generate-html-toc"&gt;</p>
            <div class="navLabel">
              <!-- FIXME: This is bogus, but we should never get here. -->
              <a href="topics/topicgroup_00000.html">
                <xsl:sequence select="$navPointTitle"/>
              </a>
            </div>
            
            <xsl:apply-templates select="*[df:class(.,'map/topicref')]" mode="#current">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
            </xsl:apply-templates>
            </div>
          <!--</navPoint>-->
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
      <!-- ====================================================== -->
      <!-- 7 30 pm 9sept2010 adding div -->
      <!-- 7 32 pm commenting out navPoint -->
      <!-- 1 41 pm 10 sept, commenting out the navPoint to see if it breaks anything -->
      <!--<navPoint id="{generate-id()}">-->
        <div class="navPoint" id="{generate-id()}">
        <!--<p>This is in &lt;xsl:template match="*[df:class(., 'topic/topic')]"
        mode="generate-html-toc"&gt;</p>
        <p>Should be a content and a text and a new a below.</p>-->
        <div class="navLabel">
          <p><xsl:sequence select="$navPointTitle"/></p>
        </div>
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
      <!--</navPoint>-->
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
      <!--<navPoint id="{generate-id()}">-->
      <div class="navPoint" id="{generate-id()}">
        <!--<p>This is contained in a div of class "navPoint" that used to be an NCX navPoint.</p>
        <p>This is in &lt;xsl:template match="*[df:isTopicHead(.)]"
        mode="generate-html-toc"&gt;</p>
        <p>This had blank text element below. Does uncommenting navPoint bring it back? Yes, it does.</p>-->

          <xsl:variable name="enumeration" as="xs:string?">
            <xsl:apply-templates select="." mode="enumeration"/>
          </xsl:variable>
<!--          <text>
            <xsl:value-of select="
            if ($enumeration = '')
            then normalize-space($rawNavPointTitle)
            else concat($enumeration, ' ', $rawNavPointTitle)
            "
            />
          </text>-->
        
        <xsl:variable name="contentUri" as="xs:string"
          select="          
          if ($topicsOutputDir != '') 
          then concat($topicsOutputDir, '/', $titleOnlyTopicFilename) 
          else $titleOnlyTopicFilename"/>
        <content src="{$contentUri}"/>
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
     <!-- </navPoint>-->
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- Per the 1.2 spec, topic group navtitles are always ignored -->
  </xsl:template>

  <!--  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/title')]" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
-->
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
