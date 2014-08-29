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

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:local="urn:functions:local"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="local xs df xsl relpath index-terms htmlutil"
  >


 <xsl:template match="*[df:class(., 'map/map')]" mode="generate-index">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="$generateIndexBoolean">
        <xsl:apply-templates select="$collected-data/index-terms:index-terms/index-terms:grouped-and-sorted" mode="#current"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-index-page">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:param name="index-content" tunnel="yes" />
    <xsl:variable name="pubTitle" as="xs:string*">
      <xsl:apply-templates select="*[df:class(., 'topic/title')] | @title" mode="pubtitle"/>
    </xsl:variable>


   <xsl:variable name="topic-content">
      <div id="index-page" class="page index">
        <h1>Index</h1>
        <div class="index-list two-columns">
          <xsl:sequence select="$index-content"/>
        </div>
      </div>
    </xsl:variable>


    <xsl:variable name="resultUri"
      select="relpath:newFile($outdir, concat('generated-index', $OUTEXT))"
      as="xs:string"/>

      <xsl:message> + [INFO] Generating index file "<xsl:sequence select="$resultUri"/>"...</xsl:message>

      <xsl:result-document
        href="{$resultUri}"
        format="html5"
        exclude-result-prefixes="index-terms"
      >
        <xsl:apply-templates mode="generate-html5-page" select=".">
         <xsl:with-param name="relativePath" select="''" as="xs:string" tunnel="yes"/>
         <xsl:with-param name="content" select="$topic-content" tunnel="yes"/>
         <xsl:with-param name="topic-title" select="'Index'" tunnel="yes"/>
         <xsl:with-param name="result-uri" select="$resultUri" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:result-document>

      <xsl:message> + [INFO] Index generation done.</xsl:message>

  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:index-group">
    <div class="index-group">
      <h2><xsl:apply-templates select="index-terms:label" mode="#current"/></h2>
      <xsl:apply-templates select="index-terms:sub-terms" mode="#current"/>
    </div>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:index-term">
    <li class="index-term" >
      <span class="label"><xsl:apply-templates select="index-terms:label" mode="#current"/></span>
      <xsl:apply-templates select="index-terms:targets" mode="#current"/>
      <xsl:apply-templates
        select="index-terms:sub-terms |
                index-terms:see-alsos |
                index-terms:sees"
        mode="#current"/>
    </li>
  </xsl:template>

  <xsl:template match="index-terms:see-alsos" mode="generate-index">
    <ul class="see-also">
      <li class="see-also">
        <span class="see-also-label">See also: </span>
        <xsl:apply-templates mode="#current"/>
      </li>
    </ul>
  </xsl:template>

  <xsl:template match="index-terms:sees" mode="generate-index">
    <ul class="see">
      <li class="see">
        <span class="see-label">See: </span>
        <xsl:apply-templates mode="#current"/>
      </li>
    </ul>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:see-also">
    <xsl:if test="preceding-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates  select="index-terms:label" mode="#current"/>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:see">
    <xsl:apply-templates  select="index-terms:label" mode="#current"/>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:original-markup">
    <!-- nothing to do -->
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:sub-terms">
    <xsl:if test="./*">
      <ul class="index-terms">
        <xsl:apply-templates mode="#current"/>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:targets">
    <span class="index-term-targets">
      <!-- For HTML we only want one entry in the generated index for each
           unique target topic.
        -->
      <xsl:for-each-group select="index-terms:target" group-by="@source-uri">
        <xsl:apply-templates mode="#current" select="current-group()[1]"/>
      </xsl:for-each-group>
    </span>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:target">
    <xsl:param name="rootMapDocUrl" tunnel="yes" as="xs:string"/>

    <xsl:if test="preceding-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:variable name="topic" select="document(relpath:getResourcePartOfUri(@source-uri))" as="document-node()"/>
    <xsl:variable name="targetUri" select="htmlutil:getTopicResultUrl($outdir, $topic, $rootMapDocUrl)"
      as="xs:string"/>
    <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)" as="xs:string"/>

    <a href="{$relativeUri}">
      <xsl:if test="$contenttarget != ''">
        <xsl:attribute name="target" select="$contenttarget"/>
      </xsl:if>
      <xsl:text> [</xsl:text>
      <xsl:apply-templates select="." mode="generate-index-term-link-text"/>
      <xsl:text>] </xsl:text>
    </a>
  </xsl:template>


  <xsl:template mode="generate-index-term-link-text" match="index-terms:target">
    <xsl:number count="index-terms:target" format="1"/>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:index-terms">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template mode="generate-index" match="index-terms:grouped-and-sorted">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="index-terms:label" mode="generate-index #default">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()" mode="generate-index" priority="-1"/>

</xsl:stylesheet>
