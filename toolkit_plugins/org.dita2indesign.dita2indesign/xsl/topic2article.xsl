<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:local="urn:local-functions"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs df local relpath e2s"
      version="2.0">
  
  <!-- Transform to generate an InCopy article (.incx) from a DITA topic
       
       The mapping of elements to InDesign styles is managed through a separate
       mapping file, which overrides default style names used in a "standard"
       DITA-specific InDesign template. 
       
       Copyright (c) 2009, 2010 DITA2InDesign.org
              
  -->
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:import href="lib/incx_generation_util.xsl"/>
  <xsl:import href="elem2styleMapper.xsl"/>
  <xsl:include href="topic2indesignImpl.xsl"/>
  
  <xsl:param name="articleFilenameBase" as="xs:string" select="''"/>
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>

  <xsl:template match="/">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] topic2article.xsl: Processing doc root...</xsl:message>
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
    <xsl:message> + [DEBUG] topic2article.xsl: effectiveFilenameBase="<xsl:sequence select="$effectiveFilenameBase"/>"</xsl:message>
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
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] topic2article.xsl: Processing root topic...</xsl:message>
    </xsl:if>
   <xsl:call-template name="makeInCopyArticle">
     <xsl:with-param name="styleCatalog" select="$styleCatalog"/>    
     <xsl:with-param name="articleType" select="name(.)" tunnel="yes"/>     
   </xsl:call-template> 
  </xsl:template>
  
</xsl:stylesheet>
