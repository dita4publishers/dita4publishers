<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms" xmlns:local="urn:functions:local"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms">
  
  <xsl:output indent="yes" name="html" method="html"/>
  
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-html-toc">
    <xsl:param name="resultUri" as="xs:string"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    
    <xsl:variable name="index-terms" as="element()?" select="$collected-data/index-terms:index-terms"/>
    <xsl:variable name="pubTitle" as="xs:string*">
      <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
    </xsl:variable>
    
    <xsl:message> + [INFO] Constructing effective ToC structure for HTML ToC...</xsl:message>
    
    <!-- Build the ToC tree so we can then calculate the playorder of the navitems. -->
    
    <xsl:variable name="navmap" as="element()">      
      <ul class="html-toc-root html-toc html-toc_0">        
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
          <li class="html-toc-entry html-toc-entry_1">
            <span class="html-toc-entry-text html-toc-entry-text_1"><a href="generated-index.html">Index</a></span>
          </li>
        </xsl:if>
      </ul>  
    </xsl:variable>
        
    <xsl:message> + [INFO] Generating HTML ToC file "<xsl:sequence select="$resultUri"
    />"...</xsl:message>
    
    <xsl:result-document href="{$resultUri}" format="html"
      doctype-public="-//W3C//DTD XHTML 1.1//EN"
      doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
      <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />         
          <title>Table of Contents</title>
          <xsl:call-template name="constructToCStyle"/>
        </head>
        <body class="toc-list-of-tables html-toc">
          <!-- FIXME: localize and parameterize the ToC page title. -->
          <h2 class="toc-title">Contents</h2>
          <div class="html-toc toc-entries">
            <xsl:apply-templates select="$navmap" mode="html-toc"/>
          </div>
        </body>
      </html>
    </xsl:result-document>
    <xsl:message> + [INFO] HTML ToC generation done.</xsl:message>
  </xsl:template>
  
  <xsl:template name="constructToCStyle">
    <!-- FIXME: This template is a short-term fix for the fact that the 
         TOC files are not output in the same location as the topics,
         so a reference to the base CSS file is wrong with the
         current code.
      -->
    <style type="text/css">
      .html-toc {
      font-family: Myriad, Verdana, sans-serif;
      }
      .html-toc-entry_1 {
      margin-top: 10px;
      }
      
      .html-toc_2 {
      margin-top: 10px;
      }
      
      
      .html-toc-entry-text_1 {
      font-weight: bold;
      }
      
      .html-toc-entry-text_3 {
      font-style: italic;
      }
    </style>
  </xsl:template>
  
  <!-- ================================================================================== -->
  
  <xsl:template mode="html-toc" match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="html-toc" match="@*|text()" priority="-1">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-html-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <!-- For title that shows up in link text, use the navtitle. If it's
        not there, use the first title element in the referenced file. -->
      
      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      <xsl:choose>
        <xsl:when test="not($topic)">
          <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence
            select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="navPointTitle">
              <xsl:apply-templates select="." mode="nav-point-title"/>
            </xsl:variable>
            <xsl:variable name="enumeration" as="xs:string?">
              <xsl:apply-templates select="." mode="enumeration"/>
            </xsl:variable>
            <xsl:variable name="targetUri"
              select="htmlutil:getTopicResultUrl($outdir, root($topic))" as="xs:string"/>
            <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
              as="xs:string"/>
          <li class="html-toc-entry html-toc-entry_{$tocDepth}">
            <span class="html-toc-entry-text html-toc-entry-text_{$tocDepth}"><a href="{$relativeUri}">
                <xsl:value-of
                  select="
                  if ($enumeration = '')
                  then normalize-space($navPointTitle)
                  else concat($enumeration, ' ', $navPointTitle)
                  "
                />
              </a></span>
              <xsl:variable name="subentries" as="node()*">
                <xsl:apply-templates mode="#current"
                  select="$topic/*[df:class(., 'topic/topic')]">
                  <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"
                  />
                </xsl:apply-templates>        
                <xsl:if test="not(contains(@chunk, 'to-content'))">
                  <xsl:apply-templates mode="#current"
                    select="*[df:class(., 'map/topicref')]">
                    <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"
                    />
                  </xsl:apply-templates>        
                </xsl:if>
              </xsl:variable>
              <xsl:if test="count($subentries) > 0">
                <ul class="html-toc html-toc_{$tocDepth + 1}">
                  <xsl:sequence select="$subentries"/>
                </ul>
              </xsl:if>
            </li>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicGroup(.)]" priority="10" mode="generate-html-toc">
    <!-- Topic groups never contribute to navigation, per the 1.2 spec -->
    <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, '/figurelist')]" priority="20" mode="generate-html-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="targetUri"
        select="relpath:newFile($outdir, concat('list-of-figures_', generate-id(.), '.html'))" 
        as="xs:string"
      />
      <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
        as="xs:string"/>
      <xsl:variable name="lof-title" as="node()*">
        <xsl:text>List of Figures</xsl:text><!-- FIXME: Get this string from string config -->
      </xsl:variable>
      <xsl:message> + [INFO] Generating figure list HTML page as "<xsl:sequence select="$relativeUri"/>"...</xsl:message>
      <xsl:result-document href="{$targetUri}"
        format="html"
        doctype-public="-//W3C//DTD XHTML 1.1//EN"
        doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
        <html>
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />         
            <title><xsl:sequence select="$lof-title"/></title>
            <xsl:call-template name="constructToCStyle"/>
          </head>
          <body class="toc-list-of-figures html-toc">
            <h2 class="toc-title"><xsl:sequence select="$lof-title"/></h2>
            <ul  class="html-toc html-toc_{$tocDepth + 1} list-of-figures">
              <xsl:apply-templates select="root(.)" mode="generate-list-of-figures-html-toc"/>
            </ul>
          </body>
        </html>
      </xsl:result-document>
      
      <li class="html-toc-entry html-toc-entry_{$tocDepth}">
        <span class="html-toc-entry-text html-toc-entry-text_{$tocDepth}"
          ><a href="{$relativeUri}">
            <xsl:sequence select="$lof-title"/>
        </a></span>
      </li>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, '/tablelist')]" priority="20" mode="generate-html-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="targetUri"
        select="relpath:newFile($outdir, concat('list-of-tables_', generate-id(.), '.html'))" 
        as="xs:string"
      />
      <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
        as="xs:string"/>
      <xsl:variable name="lot-title" as="node()*">
        <xsl:text>List of Tables</xsl:text><!-- FIXME: Get this string from string config -->
      </xsl:variable>
      <xsl:message> + [INFO] Generating table list HTML page as "<xsl:sequence select="$relativeUri"/>"...</xsl:message>
      <xsl:result-document href="{$targetUri}"
        format="html"
        doctype-public="-//W3C//DTD XHTML 1.1//EN"
        doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
        <html>
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />         
            <title><xsl:sequence select="$lot-title"/></title>
            <xsl:call-template name="constructToCStyle"/>
          </head>
          <body class="toc-list-of-tables html-toc">
            <h2 class="toc-title"><xsl:sequence select="$lot-title"/></h2>
            <ul  class="html-toc html-toc_{$tocDepth + 1} list-of-tables">
              <xsl:apply-templates select="root(.)" mode="generate-list-of-tables-html-toc"/>
            </ul>
          </body>
        </html>
      </xsl:result-document>
      
      <li class="html-toc-entry html-toc-entry_{$tocDepth}">
        <span class="html-toc-entry-text html-toc-entry-text_{$tocDepth}"
          ><a href="{$relativeUri}">
            <xsl:sequence select="$lot-title"/>
          </a></span>
      </li>
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
        <xsl:variable name="targetUri"
          select="htmlutil:getTopicResultUrl($outdir, root(.))" as="xs:string"/>
        <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
          as="xs:string"/>
        <!-- FIXME: Likely need to map input IDs to output IDs. -->
        <xsl:variable name="fragId" as="xs:string" select="string(@id)"/>
      <li class="html-toc-entry html-toc-entry_{$tocDepth}">
        <span class="html-toc-entry-text html-toc-entry-text_{$tocDepth}"><a href="{concat($relativeUri, '#', $fragId)}">
          <xsl:sequence select="$navPointTitle"/>
          </a></span>
        <xsl:variable name="subentries" as="node()*">
          <xsl:apply-templates select="*[df:class(.,'topic/topic')]" mode="#current">
            <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="count($subentries) > 0">
          <ul class="html-toc html-toc_{$tocDepth + 1}">
            <xsl:sequence select="$subentries"/>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>
  <!-- ========================================================================== -->
  
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-html-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="titleOnlyTopicFilename" as="xs:string"
        select="normalize-space(htmlutil:getTopicheadHtmlResultTopicFilename(.))"/>
      <xsl:variable name="rawNavPointTitle" as="xs:string*">
        <xsl:apply-templates select="." mode="nav-point-title"/>
      </xsl:variable>
      
        <xsl:variable name="enumeration" as="xs:string?">
          <xsl:apply-templates select="." mode="enumeration"/>
        </xsl:variable>
        <xsl:variable name="contentUri" as="xs:string"
          select="          
          if ($topicsOutputDir != '') 
          then concat($topicsOutputDir, '/', $titleOnlyTopicFilename) 
          else $titleOnlyTopicFilename"/>
      <li class="html-toc-entry html-toc-entry_{$tocDepth}">
        <span class="html-toc-entry-text html-toc-entry-text_{$tocDepth}"><a href="{$contentUri}">
            <xsl:value-of
              select="
              if ($enumeration = '')
              then normalize-space($rawNavPointTitle)
              else concat($enumeration, ' ', $rawNavPointTitle)
              "
            />
          </a></span>
        <xsl:variable name="subentries" as="node()*">
          <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
            <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="count($subentries) > 0 and normalize-space($subentries) != ''">
          <ul class="html-toc html-toc__{$tocDepth}">
            <xsl:sequence select="$subentries"/>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>
  
  <!--  WEK: included #default mode, which is bad. -->
  
  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
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
        <!-- Topic groups never contribute to navigation tree even if they
             have titles.
          -->
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  
</xsl:stylesheet>
