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
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="df xs relpath htmlutil xd"
  version="2.0"
>

  <!-- generate root pages -->
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-root-nav-page">
    <!-- Generate the root output page. By default this page contains the root
         navigation elements. The direct output of this template goes to the
         default output target of the XSLT transform.
    -->
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:param name="firstTopicUri" as="xs:string?" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

    <xsl:variable name="initialTopicUri"
      as="xs:string"
      select="
      if ($firstTopicUri != '')
       then $firstTopicUri
       else htmlutil:getInitialTopicrefUri($uniqueTopicRefs, $topicsOutputPath, $outdir, $rootMapDocUrl)
       "
    />


    <xsl:message> + [INFO] Generating index document <xsl:sequence select="$indexUri"/>...</xsl:message>

    <xsl:result-document href="{$indexUri}" format="html5">
      <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

      <xsl:apply-templates mode="generate-html5-page" select=".">
        <xsl:with-param name="resultUri" as="xs:string" select="$indexUri" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-content">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] Generating content...</xsl:message>

    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] ------------------------------- + [DEBUG] Unique topics: <xsl:for-each
          select="$uniqueTopicRefs"> + [DEBUG] <xsl:sequence select="name(.)"/>: generated id="<xsl:sequence
            select="generate-id(.)"/>", URI=<xsl:sequence select="document-uri(root(.))"/>
        </xsl:for-each> + [DEBUG] ------------------------------- </xsl:message>
    </xsl:if>
    <xsl:apply-templates select="$uniqueTopicRefs" mode="generate-content"/>
    <!--xsl:message> + [INFO] Generating title-only topics for topicheads...</xsl:message-->
    <!--xsl:apply-templates select=".//*[df:isTopicHead(.)]" mode="generate-content"/-->
    <xsl:message> + [INFO] Content generated.</xsl:message>
  </xsl:template>


  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-content">
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] Handling topicref to "<xsl:sequence select="string(@href)"/>" in mode
        generate-content</xsl:message>
    </xsl:if>

    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>

    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] generate-content: Failed to resolve topic reference to href "<xsl:sequence
            select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="topicResultUri" select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)"
          as="xs:string"/>
        <xsl:variable name="topicRelativeUri" select="htmlutil:getTopicResultUrl('', root($topic), $rootMapDocUrl)"
          as="xs:string"/>

        <xsl:variable name="tempTopic" as="document-node()">
        <xsl:document>
          <xsl:apply-templates select="$topic" mode="href-fixup">
            <xsl:with-param name="topicResultUri" select="$topicResultUri" tunnel="yes"/>
          </xsl:apply-templates>
     </xsl:document>
        </xsl:variable>

        <xsl:apply-templates select="$tempTopic" mode="#current">
          <xsl:with-param name="topicref" as="element()*" select="." tunnel="yes"/>
          <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>
          <xsl:with-param name="resultUri" select="$topicResultUri" tunnel="yes"/>
          <xsl:with-param name="topicRelativeUri" select="$topicRelativeUri" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--xsl:template match="*" mode="generate-content" priority="-1">
    <xsl:message> + [DEBUG] In catchall for generate-content, got
      <xsl:sequence select="."/></xsl:message>
  </xsl:template-->

  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-content">
    <!-- This template generates the output file for a referenced topic.
    -->
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <!-- The topicref that referenced the topic -->
    <xsl:param name="topicref" as="element()*" tunnel="yes"/>
    <!-- Enumerables structure: -->
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:param name="baseUri" as="xs:string" tunnel="yes"/>
    <!-- Result URI to which the document should be written. -->
    <xsl:param name="resultUri" as="xs:string" tunnel="yes"/>

    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="parentDocUri" select="relpath:getParent($resultUri)" as="xs:string"/>

    <xsl:variable name="parentPath" select="$outdir" as="xs:string"/>
    <!--xsl:variable name="parentPath" select="relpath:getParent($baseUri)" as="xs:string"/-->
    <xsl:variable name="relativePath" select="concat(relpath:getRelativePath($parentDocUri, $parentPath), '')"
      as="xs:string"/>

    <xsl:variable name="topic-title">
      <xsl:apply-templates select="." mode="nav-point-title"/>
    </xsl:variable>


    <!--xsl:message>docUri is: <xsl:value-of select="$docUri"/></xsl:message>
      <xsl:message>resultUri is: <xsl:value-of select="$resultUri"/></xsl:message>
       <xsl:message>map:  <xsl:value-of select="$baseUri"/></xsl:message>
      <xsl:message>parentPath is: <xsl:value-of select="$parentPath"/></xsl:message>
      <xsl:message>relativePath is: <xsl:value-of select="$relativePath"/></xsl:message>
    <xsl:message>topic-title is: <xsl:value-of select="$topic-title"/></xsl:message-->

    <xsl:message> + [INFO] Writing topic <xsl:sequence select="document-uri(root(.))"/> to HTML file "<xsl:sequence
        select="$resultUri"/>"...</xsl:message>


    <xsl:variable name="htmlNoNamespace" as="node()*">
      <xsl:apply-templates select="." mode="map-driven-content-processing">
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
        <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>


    <xsl:if test="true() and $debugBoolean">
      <xsl:result-document href="{concat($outdir, '/', 'htmlNoNamespace/', relpath:getName($resultUri))}"
      > </xsl:result-document>
    </xsl:if>

    <xsl:result-document format="html5" href="{$resultUri}">
      <xsl:apply-templates mode="generate-html5-page" select=".">
        <xsl:with-param name="relativePath" select="$relativePath" as="xs:string" tunnel="yes"/>
        <xsl:with-param name="topic-title" select="$topic-title" tunnel="yes"/>
        <xsl:with-param name="resultUri" as="xs:string" select="$resultUri" tunnel="yes"/>
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>

  <xsl:template mode="no-namespace-html-post-process" match="html">
    <!-- Default post-processing for HTML: just copy input back to the output -->
    <xsl:apply-templates select="." mode="html-identity-transform"/>
  </xsl:template>


  <xsl:template match="*[df:class(., 'topic/topic')]" priority="100" mode="map-driven-content-processing">
    <!-- This template is a general dispatch template that applies
      templates to the topicref in a distinct mode so processors
      can do topic output processing based on the topicref context
      if they want to. -->
    <xsl:param name="topicref" as="element()?" tunnel="yes"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:choose>
      <xsl:when test="$topicref">
        <xsl:apply-templates select="$topicref" mode="topicref-driven-content">
          <xsl:with-param name="topic" select="." as="element()?"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- Do default processing -->
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="topicref-driven-content" match="*[df:class(., 'map/topicref')]">
    <!-- Default topicref-driven content template. Simply applies normal processing
      in the default context to the topic parameter. -->
    <xsl:param name="topic" as="element()?"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] topicref-driven-content: topicref="<xsl:sequence select="name(.)"/>, class="<xsl:sequence
          select="string(@class)"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="topicref" select="." as="element()"/>
    <xsl:for-each select="$topic">
      <!-- Process the topic in the default mode, meaning the base Toolkit-provided
        HTML output processing.

        By providing the topicref as a tunneled parameter it makes it available
        to custom extensions to the base Toolkit processing.
      -->
      <xsl:apply-templates select=".">
        <xsl:with-param name="topicref" select="$topicref" as="element()?" tunnel="yes"/>
        <xsl:with-param name="collected-data" select="$collected-data" as="element()" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>

  <xsl:template
    match="
    *[df:class(., 'topic/body')]//*[df:class(., 'topic/indexterm')] |
    *[df:class(., 'topic/shortdesc')]//*[df:class(., 'topic/indexterm')] |
    *[df:class(., 'topic/abstract')]//*[df:class(., 'topic/indexterm')]
    "
    priority="10">
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] Found an index item in topic content: [<xsl:sequence select="string(.)"/>]</xsl:message>
    </xsl:if>
    <a id="{generate-id()}" class="indexterm-anchor"/>
  </xsl:template>

  <!-- NOTE: the body of this template is taken from the base dita2xhtmlImpl.xsl -->
  <xsl:template match="*[df:class(., 'topic/topic')]/*[df:class(., 'topic/title')]">
    <xsl:param name="topicref" select="()" as="element()?" tunnel="yes"/>
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:param name="headinglevel">
      <xsl:choose>
        <xsl:when test="count(ancestor::*[contains(@class,' topic/topic ')]) > 6">6</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count(ancestor::*[contains(@class,' topic/topic ')])"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:variable name="htmlClass" select="concat('topictitle', $headinglevel)" as="xs:string"/>
    <xsl:element name="h{$headinglevel}">
      <xsl:attribute name="class" select="$htmlClass"/>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$htmlClass" as="xs:string"/>
      </xsl:call-template>
      <xsl:apply-templates select="$topicref" mode="enumeration"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/topicmeta')]" priority="10"/>


</xsl:stylesheet>
