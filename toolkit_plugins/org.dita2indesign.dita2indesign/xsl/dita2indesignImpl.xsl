<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:df="http://dita2indesign.org/dita/functions"
      exclude-result-prefixes="xs local df"
      version="2.0">
  
  <!-- =====================================================================
       DITA Map to InCopy Articles
       
       Generates one or more InCopy articles (.icml) from a DITA map.
       Each topic will be processed to generate one or more InCopy 
       articles.
       
       The direct output of the transform is an XML manifest file that
       lists the InCopy articles generated.
    
       Copyright (c) 2013 DITA for Publishers
    
    Parameters:
    
    chunkLevel - Indicates hierarchical level at which result chunks are created. Default is "0", 
    indicating the entire map is produced as one chunk.
    
    debug - Turns template debugging on and off: 
    
      'true' - Turns debugging on
      'false' - Turns it off (the default)
    =====================================================================-->
    
  <xsl:include href="topic2icmlImpl.xsl"/>
  
  <xsl:param name="WORKDIR" as="xs:string" select="''"/>
  <xsl:param name="PATH2PROJ" as="xs:string" select="''"/>
  <xsl:param name="KEYREF-FILE" as="xs:string" select="''"/>
  

  <xsl:param name="platform" select="'unknown'" as="xs:string"/>
  <xsl:param name="outdir" select="./indesign"/>
  <xsl:param name="tempdir" select="./temp"/>
  <xsl:param name="titleOnlyTopicClassSpec" select="'- topic/topic '" as="xs:string"/>
  
  <xsl:param name="titleOnlyTopicTitleClassSpec" select="'- topic/title '" as="xs:string"/>
  
  <xsl:param name="chunkLevel" select="'0'"/>
  <xsl:variable name="chunkLevelNum" select="number($chunkLevel) idiv 1" as="xs:integer"/>
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>
  
  <!-- 
    The direct output of the transform is an XML manifest file
    that lists all the files generated.
  -->
  <xsl:output encoding="UTF-8"
    indent="yes"
    method="xml"
  />
  
  <!--NOTE: topic2icmlImpl.xsl defines the icml output type -->
  
  <xsl:template match="/">
    <xsl:param name="isRoot" as="xs:boolean" select="true()" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$isRoot">
        <xsl:apply-templates select="." mode="report-parameters"/>
        <manifest>&#x0020;
          <xsl:apply-templates>
            <xsl:with-param name="articleType" select="'topic'" as="xs:string" tunnel="yes"/>
            <xsl:with-param name="isRoot" tunnel="yes" as="xs:boolean" select="false()"/>
          </xsl:apply-templates>
        </manifest>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates>
          <xsl:with-param name="articleType" select="'topic'" as="xs:string" tunnel="yes"/>
          <xsl:with-param name="isRoot" tunnel="yes" as="xs:boolean" select="false()"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:message> 
      ==========================================
      Plugin version: ^version^ - build ^buildnumber^ at ^timestamp^
      
      Parameters:
      
      + outdir          = "<xsl:sequence select="$outdir"/>"
      + tempdir         = "<xsl:sequence select="$tempdir"/>"
      + linksPath       = "<xsl:sequence select="$linksPath"/>"
      
      + WORKDIR         = "<xsl:sequence select="$WORKDIR"/>"
      + PATH2PROJ       = "<xsl:sequence select="$PATH2PROJ"/>"
      + KEYREF-FILE     = "<xsl:sequence select="$KEYREF-FILE"/>"
      + debug           = "<xsl:sequence select="$debug"/>"
      
      Global Variables:
      
      + platform         = "<xsl:sequence select="$platform"/>"
      + debugBoolean     = "<xsl:sequence select="$debugBoolean"/>"
      
      ==========================================
    </xsl:message>
  </xsl:template>
  
  <xsl:template match="/*[df:class(., 'map/map')]">
    <xsl:apply-templates mode="process-map"/>
  </xsl:template>

  <xsl:template mode="process-map" match="*[df:class(.,'map/map')]">    
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template mode="process-map #default" match="*[df:class(.,'map/map')]/*[df:class(.,'topic/title')]">
    <!-- Map titles for submaps are always suppressed -->    
  </xsl:template>
  
  <xsl:template mode="process-map" match="*[df:class(., 'map/topicref')][@href]">
    <!-- Handle references to topics -->
    <xsl:variable name="targetTopic" select="df:resolveTopicRef(.)" as="element()?"/>
    <xsl:choose>
      <xsl:when test="not($targetTopic)">
        <xsl:message> + [ERROR] Failed to resolve topicref to URL "<xsl:sequence select="string(@href)"/>".</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [INFO] process-map: Processing topic <xsl:sequence select="document-uri(root($targetTopic))"/> in default mode...</xsl:message>
        <!-- Apply templates to the root node of the topic, rather than
             the topic doc, so we don't have each topic match the "/"
             template.
          -->
        <xsl:apply-templates select="$targetTopic">
          <!-- Give the topic access to its referencing topicref so it can know where it 
               lives in the map structure, what the topicref properties were, etc.
            -->
          <xsl:with-param name="topicref" as="element()" tunnel="yes" select="."/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="process-map" 
    match="*[df:class(.,'map/topicref')]
    [not(@href) and 
     df:hasSpecifiedNavtitle(.)]">
    <!-- Handle topicrefs with only navtitles -->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="process-map"
    match="*[df:class(.,'map/topicref')]
    [not(@href) and 
     not(df:hasSpecifiedNavtitle(.))]">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="process-map" match="text()"/><!-- Suppress text in process-map mode -->
  
  <xsl:template 
    match="
    *[df:class(.,'topic/title')] |
    *[df:class(.,'map/topicmeta')]
    " 
    mode="process-map"/>  
  
  <xsl:template match="text()" mode="process-map"/>  
  <!-- Suppress all text within the map: there should be no output 
    resulting from the input map itself.
  -->
  
  <xsl:template mode="process-map" match="*" priority="-1">
    <xsl:message> + [WARNING] dita2indesignImpl.xsl: (process-map mode): Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
</xsl:stylesheet>
