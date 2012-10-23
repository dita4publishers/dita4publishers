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

       DITA Map to HTML5 Transformation

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
  
  <xsl:import href="../../net.sourceforge.dita4publishers.html2/xsl/map2html2Impl.xsl"/>

  <xsl:include href="map2html5Nav.xsl"/>
  <xsl:include href="map2html5NavTabbed.xsl"/>
  <xsl:include href="map2html5NavIco.xsl"/>
  <xsl:include href="map2html5Content.xsl"/>
  <xsl:include href="map2html5RootPages.xsl"/>
  <xsl:include href="map2html5Collection.xsl"/>
  
  <xsl:param name="dita-css" select="'css/topic-html5.css'" as="xs:string"/>
  <xsl:param name="TRANSTYPE" select="'html5'" />
  <xsl:param name="siteTheme" select="'theme-01'" />
  <xsl:param name="bodyClass" select="''" />
  <xsl:param name="CLASSNAVIGATION" select="'left'" />
  <xsl:param name="jsoptions" select="''" />
  <xsl:param name="JS" select="''" />
  <xsl:param name="CSSTHEME" select="''" />
  <xsl:param name="NAVIGATIONMARKUP" select="'default'" />
  <xsl:param name="JSONVARFILE" select="''" />

  <xsl:param name="IDMAINCONTAINER" select="'d4h5-main-container'" />
  <xsl:param name="CLASSMAINCONTAINER" select="''" />
  
  <xsl:param name="IDMAINCONTENT" select="'d4h5-main-content'" />   
  <xsl:param name="CLASSMAINCONTENT" select="''" />
  
  <xsl:param name="IDSECTIONCONTAINER" select="'d4h5-section-container'" />
  <xsl:param name="CLASSSECTIONCONTAINER" select="''" />     
  
  
  <xsl:param name="IDLOCALNAV" select="'local-navigation'" />
      
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
  
  <xsl:template name="report-parameters" match="*" mode="report-parameters">
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:message>
      ==========================================
      Plugin version: ^version^ - build ^buildnumber^ at ^timestamp^

      HTML5 Parameters:

      + CLASSMAINCONTAINER = "<xsl:sequence select="$CLASSMAINCONTAINER"/>"
      + CLASSNAVIGATION    = "<xsl:sequence select="$CLASSNAVIGATION"/>"
      + CLASSSECTIONCONTAINER= "<xsl:sequence select="$CLASSSECTIONCONTAINER"/>"
      + CSSTHEME           = "<xsl:sequence select="$CSSTHEME"/>"
      + IDMAINCONTAINER    = "<xsl:sequence select="$IDMAINCONTAINER"/>"
      + IDSECTIONCONTAINER = "<xsl:sequence select="$IDSECTIONCONTAINER"/>"
      + jsoptions          = "<xsl:sequence select="$jsoptions"/>"
      + JS                 = "<xsl:sequence select="$JS"/>"
      + JSONVARFILE        = "<xsl:sequence select="$JSONVARFILE"/>"
      + cssOutputDir       = "<xsl:sequence select="$cssOutputDir"/>"
      + fileOrganizationStrategy = "<xsl:sequence select="$fileOrganizationStrategy"/>"
      + generateGlossary   = "<xsl:sequence select="$generateGlossary"/>"
      + generateFrameset   = "<xsl:sequence select="$generateFrameset"/>"
      + generateIndex      = "<xsl:sequence select="$generateIndex"/>
      + generateStaticToc  = "<xsl:sequence select="$generateStaticToc"/>"
      + imagesOutputDir    = "<xsl:sequence select="$imagesOutputDir"/>"
      + inputFileNameParam = "<xsl:sequence select="$inputFileNameParam"/>"
      + mathJaxUseCDNLink  = "<xsl:sequence select="$mathJaxUseCDNLink"/>"
      + mathJaxUseLocalLink= "<xsl:sequence select="$mathJaxUseLocalLink"/>"
      + mathJaxLocalJavascriptUri= "<xsl:sequence select="$mathJaxLocalJavascriptUri"/>"
      + mathJaxConfigParam = "<xsl:sequence select="$mathJaxConfigParam"/>"
      + NAVIGATIONMARKUP   = "<xsl:sequence select="$NAVIGATIONMARKUP"/>"
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

      ==========================================
    </xsl:message>
    <xsl:apply-imports/>
  </xsl:template>



	<xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>


  <xsl:template match="/">

    <xsl:message> + [INFO] Using DITA for Publishers HTML5 transformation type</xsl:message>
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
    <xsl:result-document href="{relpath:newFile($outdir, 'graphicMap.xml')}" format="graphic-map">
      <xsl:sequence select="$graphicMap"/>
    </xsl:result-document>

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

    <!-- NOTE: By default, this mode puts its output in the main output file
         produced by the transform.
      -->

    <xsl:apply-templates select="." mode="generate-root-pages">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="generate-content">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="generate-index">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
    </xsl:apply-templates>
    <!--    <xsl:apply-templates select="." mode="generate-glossary">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
    </xsl:apply-templates>
-->    <xsl:apply-templates select="." mode="generate-graphic-copy-ant-script">
      <xsl:with-param name="graphicMap" as="element()" tunnel="yes" select="$graphicMap"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- This is an override of the same template from dita2htmlmpl.xsl. It 
       uses xtrf rather than $OUTPUTDIR to provide the location of the
       graphic as authored, not as output.
    -->
  <xsl:template match="*[contains(@class,' topic/image ')]/@scale">
    
    <xsl:variable name="xtrf" as="xs:string" select="../@xtrf"/>
    <xsl:variable name="baseUri" as="xs:string" 
      select="relpath:getParent($xtrf)"/>
    
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="not(contains(../@href,'://'))">
          <xsl:value-of select="java:getWidth($baseUri, string(../@origHref))"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="not(contains(../@href,'://'))">
          <xsl:value-of select="java:getHeight($baseUri, string(../@origHref))"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="not(../@width) and not(../@height)">
      <xsl:attribute name="height">
        <xsl:value-of select="floor(number($height) * number(.) div 100)"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:value-of select="floor(number($width) * number(.) div 100)"/>
      </xsl:attribute>
    </xsl:if>
     <xsl:attribute name="class" select="@align" />
  </xsl:template>
  
 

</xsl:stylesheet>
