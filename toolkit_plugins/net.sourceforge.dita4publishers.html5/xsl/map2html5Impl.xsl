<?xml version="1.0" encoding="utf-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  exclude-result-prefixes="xs xd df relpath mapdriven index-terms java xsl mapdriven"
  xmlns:java="org.dita.dost.util.ImgUtils"
  version="2.0">


  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/reportParametersBase.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.mapdriven/xsl/dataCollection.xsl"/>

  <!-- Import the base HTML output generation transform. -->
  <xsl:import href="plugin:org.dita.xhtml:xsl/dita2xhtml.xsl"/>

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/graphicMap2AntCopyScript.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/map2graphicMap.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/topicHrefFixup.xsl"/>

  <!-- FIXME: This URL syntax is local to me: I hacked catalog-dita_template.xml
              to add this entry:

              <rewriteURI uriStartString="plugin:base-xsl:" rewritePrefix="xsl/"></rewriteURI>

        see https://github.com/dita-ot/dita-ot/issues/1405
    -->
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>

  <xsl:include href="../../net.sourceforge.dita4publishers.common.html/xsl/commonHtmlOverrides.xsl"/>
  <xsl:include href="../../net.sourceforge.dita4publishers.common.html/xsl/commonHtmlEnumeration.xsl"/>
  <xsl:include href="../../net.sourceforge.dita4publishers.common.html/xsl/commonHtmlBookmapEnumeration.xsl"/>

  <xsl:include href="map2html5Nav.xsl"/>
  <xsl:include href="map2html5NavTabbed.xsl"/>
  <xsl:include href="map2html5Content.xsl"/>
  <xsl:include href="map2html5Collection.xsl"/>
  <xsl:include href="map2html5Template.xsl"/>
  <xsl:include href="nav-point-title.xsl"/>
  <xsl:include href="commonHtmlExtensionSupport.xsl"/>
  <xsl:include href="jsAndCss.xsl"/>
  <xsl:include href="i18n.xsl"/>
  <xsl:include href="audience.xsl"/>
  <xsl:include href="map2html5Index.xsl"/>
  <xsl:include href="reltable.xsl"/>
  <xsl:include href="function.xsl"/>

  <xsl:variable name="include.roles" select="concat(' ', normalize-space($include.rellinks), ' ')"/>

  <xsl:param name="inputFileNameParam"/>

  <!-- Directory into which the generated output is put. -->
  <xsl:param name="outdir" select="./html5"/>

 <!--
    NOTE: Case of OUTEXT parameter matches case used in base HTML
    transformation type.
  -->
  <xsl:param name="OUTEXT" select="'.html'"/>
  <xsl:param name="tempdir" select="./temp"/>

 <!--
    The path of the directory, relative to the $outdir parameter,
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

  <xsl:param name="html5CSSPath" select="'css'" as="xs:string"/>

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
  <!-- -->

  <xsl:param name="dita-css" select="'css/topic-html5.css'" as="xs:string"/>
  <xsl:param name="TRANSTYPE" select="'html5'" />
  <xsl:param name="siteTheme" select="'theme-01'" />
  <xsl:param name="BODYCLASS" select="''" />
  <xsl:param name="CLASSNAVIGATION" select="'left'" />
  <xsl:param name="jsoptions" select="''" />
  <xsl:param name="JS" select="''" />
  <xsl:param name="CSSTHEME" select="''" />
  <xsl:param name="NAVIGATIONMARKUP" select="'default'" />
  <xsl:param name="JSONVARFILE" select="''" />
  <xsl:param name="HTML5D4PINIT" select="''" />

  <xsl:param name="HTML5THEMEDIR" select="'themes'" />
  <xsl:param name="HTML5THEMECONFIG" select="''" />

  <xsl:param name="IDMAINCONTAINER" select="'d4h5-main-container'" />
  <xsl:param name="CLASSMAINCONTAINER" select="''" />

  <xsl:param name="IDMAINCONTENT" select="'d4h5-main-content'" />
  <xsl:param name="CLASSMAINCONTENT" select="''" />

  <xsl:param name="IDSECTIONCONTAINER" select="'d4h5-section-container'" />
  <xsl:param name="CLASSSECTIONCONTAINER" select="''" />

  <xsl:param name="IDLOCALNAV" select="'home'" />

  <xsl:param name="GRIDPREFIX" select="'grid_'" />

  <xsl:param name="HTTPABSOLUTEURI" select="''" />
  <xsl:param name="OUTPUTDEFAULTNAVIGATION" select="true()" />

  <xsl:param name="mathJaxInclude" select="'false'"/>
  <xsl:param name="mathJaxIncludeBoolean" select="matches($mathJaxInclude, 'yes|true|on|1', 'i')" as="xs:boolean" />

  <xsl:param name="mathJaxUseCDNLink" select="'false'"/>
  <xsl:param name="mathJaxUseCDNLinkBoolean" select="false()" as="xs:boolean"/><!-- For EPUB, can't use remote version -->

  <xsl:param name="mathJaxUseLocalLink" select="'false'"/>
  <xsl:param name="mathJaxUseLocalLinkBoolean" select="$mathJaxIncludeBoolean" as="xs:boolean" />

  <!-- FIXME: Parameterize the location of the JavaScript directory -->
  <xsl:param name="mathJaxLocalJavascriptUri" select="'js/mathjax/MathJax.js'"/>

  <xsl:variable name="maxTocDepthInt" select="xs:integer($maxTocDepth)" as="xs:integer"/>

  <xsl:variable name="platform" as="xs:string"
    select="
    if (starts-with($rawPlatformString, 'Win') or
        starts-with($rawPlatformString, 'Win'))
       then 'windows'
       else 'nx'
    "
  />

  <xsl:variable name="debugBinary" 
    as="xs:boolean"
    select="matches($debug,  'true|yes|on|1', 'i')" 
  />

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

  <xsl:variable name="indexUri" select="concat('index', $OUTEXT)"/>
  <xsl:variable name="HTML5THEMECONFIGDOC" select="document($HTML5THEMECONFIG)" />

  <xsl:variable name="TEMPLATELANG">
   <xsl:apply-templates select="/map" mode="mapAttributes" />
  </xsl:variable>

  <xsl:template match="*" mode="mapAttributes" >
    <xsl:call-template name="getLowerCaseLang"/>
  </xsl:template>

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
      + FILTERFILE      = "<xsl:sequence select="$FILTERFILE"/>"
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
    <xsl:apply-templates select="." mode="extension-report-parameters"/>
    <xsl:message>
      ==========================================
    </xsl:message>
  </xsl:template>


  <!-- NOTE: For XSLT3 we'll be able to use the "html5" method value -->
  <xsl:output name="html5" method="html" indent="yes" encoding="utf-8" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:message> + [INFO] Using DITA for Publishers HTML5 transformation type</xsl:message>
    <xsl:apply-templates>
      <xsl:with-param name="rootMapDocUrl" select="document-uri(.)" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="/*[df:class(., 'map/map')]">

    <xsl:apply-templates select="." mode="report-parameters"/>

    <!-- this is intended to allow developper to add custom hook -->
    <xsl:apply-templates select="." mode="html5-impl" />

    <xsl:variable name="uniqueTopicRefs" as="element()*" select="df:getUniqueTopicrefs(.)"/>

    <xsl:variable name="chunkRootTopicrefs" as="element()*"
      select="//*[df:class(.,'map/topicref')][@processing-role = 'normal']"
    />

    <xsl:message> + [DEBUG] chunkRootTopicrefs=
      <xsl:sequence select="$chunkRootTopicrefs"/>
    </xsl:message>

    <!-- graphic map -->
    <xsl:variable name="graphicMap" as="element()">
      <xsl:apply-templates select="." mode="generate-graphic-map">
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:result-document href="{relpath:newFile($outdir, 'graphicMap.xml')}" format="graphic-map">
      <xsl:sequence select="$graphicMap"/>
    </xsl:result-document>

    <xsl:message> + [INFO] Collecting data for index generation, enumeration, etc....</xsl:message>

  <!-- collected data -->
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

    <xsl:variable name="documentation-title" as="xs:string">
        <xsl:apply-templates select="." mode="generate-root-page-header" />
    </xsl:variable>

    <xsl:variable name="audienceSelect">
      <xsl:apply-templates select="." mode="generate-audience-select">
        <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
        <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
        <xsl:with-param name="documentation-title" as="xs:string" select="$documentation-title" tunnel="yes"/>
        <xsl:with-param name="is-root" as="xs:boolean" select="true()" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="index-content">
        <xsl:apply-templates select="." mode="generate-index" >
         <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:variable name="has-index">
        <xsl:choose>
          <xsl:when test = "$index-content = ''">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="true()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

    <!-- NOTE: By default, this mode puts its output in the main output file
         produced by the transform.
    -->
    <xsl:variable name="navigation" as="element()*">
      <xsl:apply-templates select="." mode="choose-html5-nav-markup" >
        <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
        <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
        <xsl:with-param name="has-index" as="xs:boolean" select="$has-index" tunnel="yes" />
        <xsl:with-param name="documentation-title" select="$documentation-title" tunnel="yes"/>
        <xsl:with-param name="audienceSelect"  select="$audienceSelect" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>

    <!--xsl:apply-templates select="." mode="generate-root-pages">
        <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
        <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
        <xsl:with-param name="navigation" as="element()*" select="$navigation" tunnel="yes"/>
        <xsl:with-param name="documentation-title" select="$documentation-title" tunnel="yes"/>
        <xsl:with-param name="is-root" as="xs:boolean" select="true()" tunnel="yes"/>
        <xsl:with-param name="audienceSelect"  select="$audienceSelect" tunnel="yes"/>
    </xsl:apply-templates-->

    <xsl:apply-templates select="." mode="generate-content">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
      <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
      <xsl:with-param name="navigation" as="element()*" select="$navigation" tunnel="yes"/>
      <xsl:with-param name="baseUri" as="xs:string" select="@xtrf" tunnel="yes"/>
      <xsl:with-param name="documentation-title" select="$documentation-title" tunnel="yes"/>
      <xsl:with-param name="has-index" as="xs:boolean" select="$has-index" tunnel="yes" />
      <xsl:with-param name="is-root" as="xs:boolean" select="false()" tunnel="yes"/>
      <xsl:with-param name="audienceSelect"  select="$audienceSelect" tunnel="yes"/>
    </xsl:apply-templates>

    <!-- add index support -->

      <xsl:if test="$has-index">
        <xsl:apply-templates select="." mode="generate-index-page">
          <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
          <xsl:with-param name="uniqueTopicRefs" as="element()*" select="$uniqueTopicRefs" tunnel="yes"/>
          <xsl:with-param name="navigation" as="element()*" select="$navigation" tunnel="yes"/>
          <xsl:with-param name="baseUri" as="xs:string" select="@xtrf" tunnel="yes"/>
          <xsl:with-param name="documentation-title" select="$documentation-title" tunnel="yes"/>
          <xsl:with-param name="index-content" select="$index-content" tunnel="yes" />
          <xsl:with-param name="is-root" as="xs:boolean" select="false()" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:if>
    <!--xsl:apply-templates select="." mode="generate-glossary">
      <xsl:with-param name="collected-data" as="element()" select="$collected-data" tunnel="yes"/>
    </xsl:apply-templates-->

    <xsl:apply-templates select="." mode="generate-graphic-copy-ant-script">
      <xsl:with-param name="graphicMap" as="element()" tunnel="yes" select="$graphicMap"/>
    </xsl:apply-templates>
    
    <xsl:message> + [INFO] HTML5 generation complete.</xsl:message>

  </xsl:template>

  <xsl:template mode="generate-root-page-header" match="*[df:class(., 'map/map')]">
    <!-- hook for a user-XSL title prefix -->
    <xsl:call-template name="gen-user-panel-title-pfx"/>
    <xsl:apply-templates select="." mode="generate-map-title-tree" />
  </xsl:template>

  <xsl:template name="map-title" match="*" mode="generate-map-title-tree">
    <xsl:choose>
        <xsl:when test="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]">
          <xsl:apply-templates select="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')]" mode="generate-map-title" />
        </xsl:when>
        <xsl:when test="/*[contains(@class,' map/map ')]/@title">
          <xsl:value-of select="/*[contains(@class,' map/map ')]/@title" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''" />
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/title ')]" mode="generate-map-title">
    <xsl:sequence select="." />
  </xsl:template>

  <xsl:template mode="html5-impl" match="*" />

  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- Per the 1.2 spec, topic group navtitles are always ignored -->
  </xsl:template>

  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
  </xsl:template>

  <!-- Enumeration mode manages generating numbers from topicrefs -->
  <xsl:template match="* | text()" mode="enumeration">
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] enumeration: catch-all template. Element="<xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
