<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:local="urn:local-functions"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs df local relpath e2s"
      version="2.0">
  
  <!-- Transform to generate an InCopy article (.icml) from a DITA topic
       
       The mapping of elements to InDesign styles is managed through a separate
       mapping file, which overrides default style names used in a "standard"
       DITA-specific InDesign template. 
       
       Copyright (c) 2009, 2012 DITA for Publishers
              
  -->
  <!--
    
    Required libraries (imported by topic2icmlImpl.xsl): 
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="lib/icml_generation_util.xsl"/>
  <xsl:import href="elem2styleMapper.xsl"/>
    -->

  <xsl:include href="topic2icmlImpl.xsl"/>
  
  <!-- 
    The base part of the result filename, e.g. "myarticlefile".
    
    If not specified, then the name of the input topic is used for
    the article filename base.
    -->
  <xsl:param name="articleFilenameBase" as="xs:string" select="''"/>
  
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>

  <xsl:template match="/">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] topic2articleIcml.xsl: Processing doc root...</xsl:message>
    </xsl:if>
    <xsl:if test="not(/*[1][df:class(., 'topic/topic')])">
      <xsl:message terminate="yes"> + [ERROR] Input document does not appear to be a DITA topic. Got <xsl:sequence
      select="name(/*[1])"/> with @class value "<xsl:sequence
        select="string(/*[1]/@class)"
      /></xsl:message>
    </xsl:if>
    
    <xsl:message> + [DEBUG] topic2article.xsl: articleFilenameBase="<xsl:sequence select="$articleFilenameBase"/>"</xsl:message>
    
    <xsl:variable name="effectiveFilenameBase" as="xs:string"
      select="if ($articleFilenameBase = '')
      then relpath:getNamePart(document-uri(root(.)))
      else $articleFilenameBase"
    />
    <xsl:message> + [DEBUG] topic2articleIcml.xsl: effectiveFilenameBase="<xsl:sequence select="$effectiveFilenameBase"/>"</xsl:message>
    <!-- Using a mode for map processing so topic processing
         can be the default mode for convenience.
    -->
    <manifest>&#x0020;
      <xsl:apply-templates>
        <xsl:with-param name="articleFilenameBase" 
          tunnel="yes" 
          select="$effectiveFilenameBase"/>
      </xsl:apply-templates>
    </manifest>
  </xsl:template>
  
  <xsl:template match="/*[df:class(., 'topic/topic')]" priority="10">
    <!-- The topicref that points to this topic -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>
    <xsl:param name="articleFilenameBase" 
      tunnel="yes"
      as="xs:string"
    />

    <xsl:if test="true()">
      <xsl:message> + [DEBUG] topic2article.xsl: Processing root topic...</xsl:message>
    </xsl:if>
    
    <xsl:if test="contains($outputPath, '\')">
      <xsl:message terminate="yes"> + [ERROR] Value of outputPath parameter has backslashes, which suggest a Windows file path. The value just be a URI: "<xsl:sequence select="$outputPath"/></xsl:message>
    </xsl:if>
    
    <xsl:message> + [DEBUG] topic2articleIcml: $outputPath="<xsl:sequence select="$outputPath"/>"</xsl:message>

    <xsl:variable name="effectiveOutputPath" as="xs:string"
      select="if (matches($outputPath, '^[\w]+:.+'))
      then $outputPath
      else concat('file:', $outputPath)
      "
    />
    <xsl:message> + [DEBUG] topic2articleIcml: $effectiveOutputPath="<xsl:sequence select="$effectiveOutputPath"/>"</xsl:message>
    <xsl:variable name="incopyFileUri" as="xs:string"      
      select="relpath:newFile($effectiveOutputPath, 
                              concat($articleFilenameBase, '.icml'))"
    />
   
    <xsl:message> + [INFO] topic2icmlImpl.xsl: incopyFileUri="<xsl:sequence select="$incopyFileUri"/>"</xsl:message>

    <!-- First, generate any result docs from subelements -->
    <xsl:message> + [INFO] topic2icmlImpl.xsl: Applying result-docs mode to children of root topic...</xsl:message>
    <xsl:apply-templates select="*" mode="result-docs">
      <xsl:with-param name="articleType" select="name(.)" tunnel="yes"/>           
    </xsl:apply-templates>

    <xsl:variable name="mainArticle" as="node()*">
      <xsl:call-template name="makeInCopyArticle">
        <xsl:with-param name="articleType" select="name(.)" tunnel="yes"/>     
        <xsl:with-param name="styleCatalog" select="$styleCatalog"/>
      </xsl:call-template> 
    </xsl:variable>

    <xsl:message> + [DEBUG] topic2article.xsl: Creating result document "<xsl:sequence select="$incopyFileUri"/></xsl:message>
        
    <xsl:result-document href="{$incopyFileUri}">
      <xsl:sequence select="$mainArticle"/>
    </xsl:result-document>

    <xsl:call-template name="constructManifestFileEntry">
      <xsl:with-param name="incopyFileUri" select="$incopyFileUri" as="xs:string"/>
    </xsl:call-template>
    <xsl:message> + [DEBUG] topic2article.xsl: Root topic processing complete.</xsl:message> 
  </xsl:template>
  
  <xsl:template match="*" mode="result-docs">
    <!--
    <xsl:message> + [DEBUG] topic2article.xsl: in result-docs catch-all: <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/>.</xsl:message>
    -->
    <xsl:apply-templates mode="#current" select="*"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="result-docs"/>
  
  
</xsl:stylesheet>
