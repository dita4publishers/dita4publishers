<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  
  exclude-result-prefixes="df xs relpath htmlutil xd"
  version="2.0">
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  <xsl:import href="html-generation-utils.xsl"/>
  
<xsl:template match="*[df:class(., 'map/map')]" mode="generate-static-toc">
  <html><xsl:sequence select="'&#x0a;'"/>
    <head>
      <xsl:call-template name="generateMapTitle"/>
      <xsl:sequence select="'&#x0a;'"/>
      <xsl:if test="string-length($contenttarget)>0 and
        $contenttarget!='NONE'">
        <base target="{$contenttarget}"/><xsl:sequence select="'&#x0a;'"/>
      </xsl:if>
      <!-- initial meta information -->
      
      <!-- Generate stuff for dynamic TOC. Need to parameterize/extensify this -->
      
      <link rel="stylesheet" type="text/css" href="css/screen.css"/><xsl:sequence select="'&#x0a;'"/>
      <link rel="stylesheet" type="text/css" href="css/local/tree.css"/><xsl:sequence select="'&#x0a;'"/>
      
    </head><xsl:sequence select="'&#x0a;'"/>
    
    <body>
      <xsl:if test="string-length($staticTocBodyOutputclass) &gt; 0">
        <xsl:attribute name="class" select="$staticTocBodyOutputclass"/>
      </xsl:if>
      <div class="dynamic-toc"><xsl:sequence select="'&#x0a;'"/>
        <div id="container">   <xsl:sequence select="'&#x0a;'"/>       
          <div id="containerTop"><xsl:sequence select="'&#x0a;'"/>
            <div id="main"><xsl:sequence select="'&#x0a;'"/>
              <div id="content"><xsl:sequence select="'&#x0a;'"/>
                <form name="mainForm" action="javscript:;"><xsl:sequence select="'&#x0a;'"/>
                  <div class="newsItem"><xsl:sequence select="'&#x0a;'"/>
                    <div id="expandcontractdiv"><xsl:sequence select="'&#x0a;'"/>
                      <a href="javascript:tree.expandAll()">Expand all</a><xsl:sequence select="'&#x0a;'"/>
                      <a href="javascript:tree.collapseAll()">Collapse all</a><xsl:sequence select="'&#x0a;'"/>
                    </div><xsl:sequence select="'&#x0a;'"/>
                    <div id="treeDiv1">&#xa0;</div><xsl:sequence select="'&#x0a;'"/>
                  </div><xsl:sequence select="'&#x0a;'"/>
                </form><xsl:sequence select="'&#x0a;'"/>
              </div><xsl:sequence select="'&#x0a;'"/>
            </div><xsl:sequence select="'&#x0a;'"/>
          </div><xsl:sequence select="'&#x0a;'"/>
        </div><xsl:sequence select="'&#x0a;'"/>        
      </div><xsl:sequence select="'&#x0a;'"/>
      <div class="static-toc" style="display: none;"><xsl:sequence select="'&#x0a;'"/>
        <xsl:sequence select="'&#x0a;'"/>
        <ul><xsl:sequence select="'&#x0a;'"/>        
          <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="generate-static-toc"/>
        </ul><xsl:sequence select="'&#x0a;'"/>
      </div><xsl:sequence select="'&#x0a;'"/>
      
      <!-- For dynamic ToC: -->
      <script type="text/javascript" src="yahoo.js" >&#xa0;</script><xsl:sequence select="'&#x0a;'"/>
      <script type="text/javascript" src="event.js">&#xa0;</script><xsl:sequence select="'&#x0a;'"/>
      <script type="text/javascript" src="treeview.js" >&#xa0;</script><xsl:sequence select="'&#x0a;'"/>
      <script type="text/javascript" src="toc.js">&#xa0;</script><xsl:sequence select="'&#x0a;'"/>
    </body><xsl:sequence select="'&#x0a;'"/>
  </html>  
</xsl:template>
  
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-static-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <li id="{generate-id()}"><xsl:apply-templates mode="toc-title" select="."/>
        <xsl:if test="(*[df:class(., 'map/topicref')][not(@toc = 'no')]) and
          ($tocDepth lt $maxTocDepthInt)">
          <ul><xsl:sequence select="'&#x0a;'"/>
            <xsl:apply-templates mode="#current" 
          select="*[df:class(., 'map/topicref')]">
              <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                select="$tocDepth + 1"
              />
            </xsl:apply-templates>
          </ul><xsl:sequence select="'&#x0a;'"/>
        </xsl:if>
      </li><xsl:sequence select="'&#x0a;'"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicGroup(.)]" mode="generate-static-toc">
    <xsl:apply-templates mode="#current" 
      select="*[df:class(., 'map/topicref')]"/>        
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)][not(@toc = 'no')]" mode="generate-static-toc">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">

      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>

      <xsl:choose>
        <xsl:when test="not($topic)">
          <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($topicsOutputPath, root($topic))" as="xs:string"/>
          <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>
          <li id="{generate-id()}"
            ><a href="{$relativeUri}" target="{$contenttarget}"><xsl:apply-templates select="." mode="enumeration"/>
              <xsl:apply-templates select="." mode="toc-title"/></a>              
            <xsl:if test="($topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')][not(@toc = 'no')]) and
                          ($tocDepth lt $maxTocDepthInt)">
              <ul><xsl:sequence select="'&#x0a;'"/>
                <!-- Any subordinate topics in the currently-referenced topic are
                  reflected in the ToC before any subordinate topicrefs.
                -->
                <xsl:apply-templates mode="#current" 
                  select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                  <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                    select="$tocDepth + 1"
                  />
                </xsl:apply-templates>                
              </ul><xsl:sequence select="'&#x0a;'"/>              
            </xsl:if>
          </li><xsl:sequence select="'&#x0a;'"/>
        </xsl:otherwise>
      </xsl:choose>    
    </xsl:if>    
  </xsl:template>
  
  <xsl:template mode="toc-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="titleValue" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$titleValue"/>    
  </xsl:template>
  
  
  <xsl:template name="generateMapTitle">
    <!-- FIXME: Replace this with a separate mode that will handle markup within titles -->
    <!-- Title processing - special handling for short descriptions -->
    <xsl:if test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')] or /*[contains(@class,' map/map ')]/@title">
      <title>
        <xsl:call-template name="gen-user-panel-title-pfx"/> <!-- hook for a user-XSL title prefix -->
        <xsl:choose>
          <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
            <xsl:value-of select="normalize-space(/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')])"/>
          </xsl:when>
          <xsl:when test="/*[contains(@class,' map/map ')]/@title">
            <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
          </xsl:when>
        </xsl:choose>
      </title><xsl:value-of select="$newline"/>
    </xsl:if>
  </xsl:template>
  
  
</xsl:stylesheet>