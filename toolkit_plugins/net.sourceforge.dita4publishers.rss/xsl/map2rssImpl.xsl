<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  exclude-result-prefixes="xs xd df relpath mapdriven"
  xmlns:java="org.dita.dost.util.ImgUtils"
  version="2.0">

  <!-- =============================================================

       DITA Map to RSS Transformation

       Copyright (c) 2010, 2012 DITA For Publishers

       Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
       The intent of this license is for this material to be licensed in a way that is
       consistent with and compatible with the license of the DITA Open Toolkit.

       This transform requires XSLT 2.


       ============================================================== -->
  <!-- These two libraries end up getting imported via the dita2xhtml.xsl from the main toolkit
     because the base XSL support lib is integrated into that file. So these inclusions are redundant.
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  -->
  
  <!--xsl:import href="../../net.sourceforge.dita4publishers.html2/xsl/map2html2Impl.xsl"/-->
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/reportParametersBase.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.mapdriven/xsl/dataCollection.xsl"/>
  <!-- Import the base HTML output generation transform. -->
  <xsl:import href="plugin:org.dita.xhtml:xsl/dita2xhtml.xsl"/>
  
  
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/graphicMap2AntCopyScript.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/map2graphicMap.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/topicHrefFixup.xsl"/>
  
  <xsl:import href="../../../xsl/common/dita-utilities.xsl"/>
  
  <xsl:include href="../../net.sourceforge.dita4publishers.common.html/xsl/commonHtmlOverrides.xsl"/>
  <xsl:include href="../../net.sourceforge.dita4publishers.common.html/xsl/commonHtmlEnumeration.xsl"/>
  <xsl:include href="../../net.sourceforge.dita4publishers.common.html/xsl/commonHtmlBookmapEnumeration.xsl"/>


  <xsl:include href="map2rssNav.xsl"/>
  <xsl:include href="map2rssRootPages.xsl"/>
  
  
  <xsl:param name="inputFileNameParam"/>
  <!-- Directory into which the generated output is put.

       -->
  <xsl:param name="outdir" select="./html2"/>
  <!-- NOTE: Case of OUTEXT parameter matches case used in base HTML
       transformation type.
    -->
  <xsl:param name="OUTEXT" select="'.html'"/>
   <xsl:param name="RSSEXT" select="'.xml'"/>
    <xsl:param name="RSSDIR" select="''"/>
  <xsl:param name="tempdir" select="./temp"/>
  <xsl:param name="FILENAME" select="'feed'"/>
  
 <!-- The path of the directory, relative the $outdir parameter,
    to hold the graphics in the result HTML package. Should not have
    a leading "/". 
  -->  
  <xsl:param name="imagesOutputDir" select="'images'" as="xs:string"/>
  <!-- The path of the directory, relative the $outdir parameter,
    to hold the topics in the HTML package. Should not have
    a leading "/". 
  -->  
  <xsl:param name="topicsOutputDir" select="'topics'" as="xs:string"/>

  <!-- The path of the directory, relative the $outdir parameter,
    to hold the CSS files in the HTML package. Should not have
    a leading "/". 
  -->  
  <xsl:param name="cssOutputDir" select="'css'" as="xs:string"/>
  
  <xsl:param name="debug" select="'false'" as="xs:string"/>
  
  <xsl:param name="rawPlatformString" select="'unknown'" as="xs:string"/><!-- As provided by Ant -->
  
  <xsl:param name="titleOnlyTopicClassSpec" select="'- topic/topic '" as="xs:string"/>

  <xsl:param name="titleOnlyTopicTitleClassSpec" select="'- topic/title '" as="xs:string"/>
  
  <!-- The strategy to use when constructing output files. Default is "as-authored", meaning
       reflect the directory structure of the topics as authored relative to the root map,
       possibly as reworked by earlier Toolkit steps.
    -->       
  <xsl:param name="fileOrganizationStrategy" as="xs:string" select="'as-authored'"/>
  
  
  <!-- Maxminum depth of the generated ToC -->
  <xsl:param name="maxTocDepth" as="xs:string" select="'5'"/>
  
  <!-- Include back-of-the-book-index if any index entries in source 
  
       For now default to no since index generation is still under development.
  -->  
  <xsl:param name="generateIndex" as="xs:string" select="'no'"/>
  <xsl:variable name="generateIndexBoolean" 
    select="matches($generateIndex, 'yes|true|on|1', 'i')"
  />
  
  <!-- Generate the glossary dynamically using all glossary entry
       topics included in the map.
    -->
  <xsl:param name="generateGlossary" as="xs:string" select="'no'"/>
  <xsl:variable name="generateGlossaryBoolean" 
    select="matches($generateGlossary, 'yes|true|on|1', 'i')"
  />
  
  
  <!-- value for @class on <body> of the generated static TOC HTML document -->
  <xsl:param name="staticTocBodyOutputclass" select="''" as="xs:string"/>
  
  <xsl:param name="contenttarget" select="'contentwin'"/>
  
  <xsl:param name="generateDynamicToc" select="'true'"/>
  <xsl:param name="generateDynamicTocBoolean" select="matches($generateDynamicToc, 'yes|true|on|1', 'i')"/>
  
  <xsl:param name="generateFrameset" select="'true'"/>
  <xsl:param name="generateFramesetBoolean" select="matches($generateFrameset, 'yes|true|on|1', 'i')"/>
  
  <xsl:param name="generateStaticToc" select="'false'"/>
  <xsl:param name="generateStaticTocBoolean" select="matches($generateStaticToc, 'yes|true|on|1', 'i')"/>

  <!-- NOTE: MathJax parameters are defined in the math-d2html.xsl module. -->
  
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:message> 
      ==========================================
      Plugin version: ^version^ - build ^buildnumber^ at ^timestamp^
      
      HTML2 Parameters:
      
      + cssOutputDir       = "<xsl:sequence select="$cssOutputDir"/>"
      + fileOrganizationStrategy = "<xsl:sequence select="$fileOrganizationStrategy"/>"  
      + generateDynamicToc = "<xsl:sequence select="$generateDynamicToc"/>"
      + generateGlossary   = "<xsl:sequence select="$generateGlossary"/>"
      + generateFrameset   = "<xsl:sequence select="$generateFrameset"/>"
      + generateIndex      = "<xsl:sequence select="$generateIndex"/>
      + generateStaticToc  = "<xsl:sequence select="$generateStaticToc"/>"
      + imagesOutputDir    = "<xsl:sequence select="$imagesOutputDir"/>"
      + inputFileNameParam = "<xsl:sequence select="$inputFileNameParam"/>"
      + outdir             = "<xsl:sequence select="$outdir"/>"
      + OUTEXT             = "<xsl:sequence select="$OUTEXT"/>"
      + tempdir            = "<xsl:sequence select="$tempdir"/>"
      + titleOnlyTopicClassSpec = "<xsl:sequence select="$titleOnlyTopicClassSpec"/>"
      + titleOnlyTopicTitleClassSpec = "<xsl:sequence select="$titleOnlyTopicTitleClassSpec"/>"
      + topicsOutputDir    = "<xsl:sequence select="$topicsOutputDir"/>"

      DITA2HTML parameters:
      
      + CSS             = "<xsl:sequence select="$CSS"/>"
      + CSSPATH         = "<xsl:sequence select="$CSSPATH"/>"
      + DITAEXT         = "<xsl:sequence select="$DITAEXT"/>"
      + FILEDIR         = "<xsl:sequence select="$FILEDIR"/>"
      + KEYREF-FILE     = "<xsl:sequence select="$KEYREF-FILE"/>"
      + OUTPUTDIR       = "<xsl:sequence select="$OUTPUTDIR"/>"
      + PATH2PROJ       = "<xsl:sequence select="$PATH2PROJ"/>"
      + WORKDIR         = "<xsl:sequence select="$WORKDIR"/>"
      
      + debug           = "<xsl:sequence select="$debug"/>"

      Global Variables:
      
      + cssOutputPath    = "<xsl:sequence select="$cssOutputPath"/>"
      + topicsOutputPath = "<xsl:sequence select="$topicsOutputPath"/>"
      + imagesOutputPath = "<xsl:sequence select="$imagesOutputPath"/>"
      + platform         = "<xsl:sequence select="$platform"/>"
      + debugBoolean     = "<xsl:sequence select="$debugBoolean"/>"
    </xsl:message>      
    <xsl:next-match />  
    <xsl:message>  
      ==========================================
    </xsl:message>
  </xsl:template>
  
  <xsl:template mode="report-parameters" match="text()"/><!-- Suppress text in this mode -->
  
  
  <xsl:output method="xml" name="indented-xml"
    indent="yes"
  />
  
  <xsl:variable name="maxTocDepthInt" select="xs:integer($maxTocDepth)" as="xs:integer"/>
  
  
  <xsl:variable name="platform" as="xs:string"
    select="
    if (starts-with($rawPlatformString, 'Win') or 
        starts-with($rawPlatformString, 'Win'))
       then 'windows'
       else 'nx'
    "
  />
  
  <xsl:variable name="debugBinary" select="$debug = 'true'" as="xs:boolean"/>
  
  <xsl:variable name="topicsOutputPath">
      <xsl:choose>
        <xsl:when test="$topicsOutputDir != ''">
          <xsl:sequence select="concat($outdir, $topicsOutputDir)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$outdir"/>
        </xsl:otherwise>
      </xsl:choose>    
  </xsl:variable>

  <xsl:variable name="imagesOutputPath">
      <xsl:choose>
        <xsl:when test="$imagesOutputDir != ''">
          <xsl:sequence select="concat($outdir, 
            if (ends-with($outdir, '/')) then '' else '/', 
            $imagesOutputDir)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$outdir"/>
        </xsl:otherwise>
      </xsl:choose>    
  </xsl:variable>  
  
  <xsl:variable name="cssOutputPath">
      <xsl:choose>
        <xsl:when test="$cssOutputDir != ''">
          <xsl:sequence select="concat($outdir, $cssOutputDir)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$outdir"/>
        </xsl:otherwise>
      </xsl:choose>    
  </xsl:variable>  
  
  
  <xsl:param name="PUBDATE" select="''" />
  <xsl:param name="RSSLINK" select="'http://www.example.org/'" />  
  
  <xsl:param name="TTL" select="0" />
  <xsl:param name="MANAGINGEDITOR" select="''" />
  <xsl:param name="WEBMASTER" select="''" />

  <xsl:param name="TRANSTYPE" select="'rss'" />      
  <xsl:param name="mathJaxInclude" select="'false'"/>
  <xsl:param name="mathJaxIncludeBoolean" 
    select="matches($mathJaxInclude, 'yes|true|on|1', 'i')"
    as="xs:boolean"
  />
  
  <xsl:param name="mathJaxUseCDNLink" select="'false'"/>
  <xsl:param name="mathJaxUseCDNLinkBoolean" select="false()" as="xs:boolean"/><!-- For EPUB, can't use remote version -->
  
  <xsl:param name="mathJaxUseLocalLink" select="'false'"/>
  <xsl:param name="mathJaxUseLocalLinkBoolean" 
    select="$mathJaxIncludeBoolean"  
    as="xs:boolean"
  />
  
  <!-- FIXME: Parameterize the location of the JavaScript directory -->
  <xsl:param name="mathJaxLocalJavascriptUri" select="'js/mathjax/MathJax.js'"/>
  


	<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="no"/>


  <xsl:template match="/">

    <xsl:message> + [INFO] Using DITA for Publishers rss transformation type</xsl:message>
    <xsl:apply-templates>
      <xsl:with-param name="rootMapDocUrl" select="document-uri(.)" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="/*[df:class(., 'map/map')]">

    <xsl:apply-templates select="." mode="report-parameters"/>

    <xsl:variable name="uniqueTopicRefs" as="element()*" select="df:getUniqueTopicrefs(.)"/>

    <xsl:variable name="chunkRootTopicrefs" as="element()*"
      select="//*[df:class(.,'map/topicref')][@processing-role = 'normal']"
    />

    <xsl:message> + [DEBUG] chunkRootTopicrefs=
      <xsl:sequence select="$chunkRootTopicrefs"/>
    </xsl:message>

    <xsl:variable name="graphicMap" as="element()">
      <xsl:apply-templates select="." mode="generate-graphic-map">
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:message> + [INFO] Collecting data for index generation, enumeration, etc....</xsl:message>

    <xsl:variable name="collected-data" as="element()">
      <xsl:call-template name="mapdriven:collect-data"/>
    </xsl:variable>

    <xsl:if test="true() or $debugBoolean">
      <xsl:message> + [DEBUG] Writing file <xsl:sequence select="relpath:newFile($outdir, 'collected-data.xml')"/>...</xsl:message>
      <xsl:result-document href="{relpath:newFile($outdir, 'collected-data.xml')}"
        format="indented-xml"
        >
        <xsl:sequence select="$collected-data"/>
      </xsl:result-document>
    </xsl:if>
    
	<xsl:apply-templates select="." mode="generate-root-pages">
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
    </xsl:apply-templates>
    
  </xsl:template>

 

</xsl:stylesheet>
