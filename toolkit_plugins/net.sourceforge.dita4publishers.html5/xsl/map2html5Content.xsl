<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  
  exclude-result-prefixes="df xs relpath htmlutil xd"
  version="2.0">

  <xsl:template match="*" mode="chapterBody">
    <!-- This template is an override of the one in dta2htmlImpl.xsl in the 
         main HTML transform type. The context node is a topic
         that is the root of an output file (e.g., a "chapter")
         
         It's main purpose is to wrap the body content in
         an HTML5 <section> element.
      -->
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <body>
      <!-- Already put xml:lang on <html>; do not copy to body with commonattributes -->
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
      </xsl:call-template>
      <!--output parent or first "topic" tag's outputclass as class -->
      <xsl:if test="@outputclass">
        <xsl:attribute name="class"><xsl:value-of select="@outputclass" /></xsl:attribute>
      </xsl:if>
      <xsl:if test="self::dita">
        <xsl:if test="*[contains(@class,' topic/topic ')][1]/@outputclass">
          <xsl:attribute name="class"><xsl:value-of select="*[contains(@class,' topic/topic ')][1]/@outputclass" /></xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="." mode="addAttributesToBody"/>
      <xsl:call-template name="setidaname"/>
      <xsl:value-of select="$newline"/>
      <xsl:call-template name="start-flagit">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>     
      </xsl:call-template>
      <xsl:call-template name="start-revflag">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:call-template name="generateBreadcrumbs"/>
      <xsl:call-template name="gen-user-header"/>  <!-- include user's XSL running header here -->
      <xsl:call-template name="processHDR"/>
      <xsl:if test="$INDEXSHOW='yes'">
        <xsl:apply-templates select="/*/*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/indexterm ')] |
          /dita/*[1]/*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/indexterm ')]"/>
      </xsl:if>
      <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
      <xsl:call-template name="gen-user-sidetoc"/>
      <!-- WEK: Added wrapper <section> element around the body content -->
      <section>
      <div class="{concat(@outputclass, ' ', name(.))}">
         <xsl:apply-templates/> <!-- this will include all things within topic; therefore, -->   </div>   
      </section>
      <!-- title content will appear here by fall-through -->
      <!-- followed by prolog (but no fall-through is permitted for it) -->
      <!-- followed by body content, again by fall-through in document order -->
      <!-- followed by related links -->
      <!-- followed by child topics by fall-through -->
      
      <xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->
      <xsl:call-template name="gen-user-footer"/> <!-- include user's XSL running footer here -->
      <xsl:call-template name="processFTR"/>      <!-- Include XHTML footer, if specified -->
      <xsl:call-template name="end-revflag">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:call-template name="end-flagit">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param> 
      </xsl:call-template>
    </body>
    <xsl:value-of select="$newline"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-content">
    <!-- WEK: Override of sample template in html2 so we have control
         over the details of how the HTML file is constructed.
      -->
    <!-- This template generates the output file for a referenced topic.
    -->
    <!-- The topicref that referenced the topic -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>    
    <!-- Enumerables structure: -->
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>    
    
    <!-- Result URI to which the document should be written. -->
    <xsl:param name="resultUri" as="xs:string" tunnel="yes"/>
    
    <xsl:message> + [INFO] Writing topic <xsl:sequence select="document-uri(root(.))"/> to HTML file "<xsl:sequence 
      select="$resultUri"/>"...</xsl:message>
    <xsl:variable name="htmlNoNamespace" as="node()*">
      <xsl:apply-templates select="." mode="map-driven-content-processing" >
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
        <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>    
      </xsl:apply-templates>      
    </xsl:variable>
    <xsl:if test="true() and $debugBoolean">
      <xsl:result-document href="{concat($outdir, '/', 'htmlNoNamespace/', relpath:getName($resultUri))}">
        <xsl:sequence select="$htmlNoNamespace"/>
      </xsl:result-document>
    </xsl:if>
    <xsl:result-document format="topic-html" href="{$resultUri}" >
      <xsl:apply-templates select="$htmlNoNamespace" mode="no-namespace-html-post-process">
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
        <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>    
        <xsl:with-param name="resultUri" select="$resultUri" as="xs:string" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>
  
  
  <xsl:template name="gen-user-header">
    <!-- WEK: Wrap header in HTML5 header element -->
    <header>
      <xsl:apply-templates select="." mode="gen-user-header"/>
    </header>
  </xsl:template>
  
  <xsl:template name="gen-user-footer">
    <!-- WEK: Wrap header in HTML5 header element -->
    <footer>
      <xsl:apply-templates select="." mode="gen-user-footer"/>
    </footer>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-content">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] HTML5 -- Generating content...</xsl:message>
    
    <xsl:if test="false() and $debugBoolean">    
      <xsl:message> + [DEBUG] ------------------------------- 
        + [DEBUG] Unique topics:      
        <xsl:for-each select="$uniqueTopicRefs">
          + [DEBUG] <xsl:sequence select="name(.)"/>: generated id="<xsl:sequence select="generate-id(.)"/>", URI=<xsl:sequence select="document-uri(root(.))"/>                
        </xsl:for-each>
        + [DEBUG] -------------------------------    
      </xsl:message>
    </xsl:if>    
    <xsl:apply-templates select="$uniqueTopicRefs" mode="generate-content"/>
    <xsl:message> + [INFO] Generating title-only topics for topicheads...</xsl:message>
    <xsl:apply-templates select=".//*[df:isTopicHead(.)]" mode="generate-content"/>
    <xsl:message> + [INFO] Content generated.</xsl:message>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-content">
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] Handling topichead "<xsl:sequence select="df:getNavtitleForTopicref(.)"/>" in mode generate-content</xsl:message>
    </xsl:if>
    <xsl:variable name="topicheadFilename" as="xs:string"
      select="normalize-space(htmlutil:getTopicheadHtmlResultTopicFilename(.))" />
    <xsl:variable name="generatedTopic" as="document-node()">
      <xsl:document>
        <topic id="{relpath:getNamePart($topicheadFilename)}"
          xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
          ditaarch:DITAArchVersion="1.2"
          domains="(topic topic)"
          >
          <xsl:attribute name="class"
            select="$titleOnlyTopicClassSpec"
          />
          <title>
            <xsl:attribute name="class"
              select="$titleOnlyTopicTitleClassSpec"
            />
            <xsl:sequence select="df:getNavtitleForTopicref(.)"/></title>
        </topic>
      </xsl:document>
    </xsl:variable>
    <xsl:apply-templates select="$generatedTopic" mode="generate-content">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="yes"/>
      <xsl:with-param name="resultUri" select="relpath:newFile($topicsOutputPath, $topicheadFilename)" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="generateCssLinks">
    <xsl:variable name="childlang">
      <xsl:choose>
        <!-- Update with DITA 1.2: /dita can have xml:lang -->
        <xsl:when test="self::dita[not(@xml:lang)]">
          <xsl:for-each select="*[1]"><xsl:call-template name="getLowerCaseLang"/></xsl:for-each>
        </xsl:when>
        <xsl:otherwise><xsl:call-template name="getLowerCaseLang"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="direction">
      <xsl:apply-templates select="." mode="get-render-direction">
        <xsl:with-param name="lang" select="$childlang"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="urltest"> <!-- test for URL -->
      <xsl:call-template name="url-string">
        <xsl:with-param name="urltext">
          <xsl:value-of select="concat($CSSPATH,$CSS)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="($direction='rtl') and ($urltest='url') ">
        <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$bidi-dita-css}" />
      </xsl:when>
      <xsl:when test="($direction='rtl') and ($urltest='')">
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$bidi-dita-css}" />
      </xsl:when>
      <xsl:when test="($urltest='url')">
        <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$dita-css}" />
        <!-- FIXME: This is a quick hack for demo purposes -->
        <link rel="stylesheet" type="text/css" href="{$CSSPATH}topic-html5.css" />
      </xsl:when>
      <xsl:otherwise>
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$dita-css}" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$newline"/>
    <!-- Add user's style sheet if requested to -->
    <xsl:if test="string-length($CSS)>0">
      <xsl:choose>
        <xsl:when test="$urltest='url'">
          <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$CSS}" />
        </xsl:when>
        <xsl:otherwise>
          <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}" />
        </xsl:otherwise>
      </xsl:choose><xsl:value-of select="$newline"/>
    </xsl:if>
    
  </xsl:template>
  
  
</xsl:stylesheet>