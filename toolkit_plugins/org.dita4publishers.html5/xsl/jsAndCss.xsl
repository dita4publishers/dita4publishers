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
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="df xs relpath htmlutil xd dc"
  version="2.0">
  <!-- =============================================================

    DITA Map to HTML5 Transformation

    Root output page (navigation/index) generation. This transform
    manages generation of the root page for the generated HTML.
    It calls the processing to generate navigation structures used
    in the root page (e.g., dynamic and static ToCs).

    Copyright (c) 2012 DITA For Publishers

    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.

    This transform requires XSLT 2.
    ================================================================= -->

  <!-- used to generate the css links -->
  <xsl:template match="*" mode="generate-css-js">
    <xsl:call-template name="d4p-variables"/>
    <xsl:apply-templates select="." mode="generate-d4p-css-js"/>
  </xsl:template>

  <!-- this template is used to add compressed or none-compressed javascripts links -->
  <xsl:template match="*" mode="generate-d4p-css-js">
    <xsl:choose>
      <xsl:when test="$DBG='yes'">
        <xsl:apply-templates select="$HTML5THEMECONFIGDOC/html5/tag" mode="generate-d4p-uncompressed-css"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$HTML5THEMECONFIGDOC/html5/tag" mode="generate-d4p-compressed-css"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tag[count(source/file) &gt; 0 ][output = 'no']" mode="generate-d4p-uncompressed-css" />

  <!-- This template render ons script element per script element declared in the theme config.xml -->
  <xsl:template match="tag[count(source/file) &gt; 0 ][output != 'no']" mode="generate-d4p-uncompressed-css">

    <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes"/>

    <xsl:variable name="attributes">
      <xsl:for-each select="attributes/*">
        <xsl:if test="name(.) != 'href'">
          <attribute name="{name(.)}" value="{.}"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="name">
      <xsl:call-template name="theme-get-tag-name">
        <xsl:with-param name="name" select="name" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:for-each select="./source/file">

      <xsl:variable name="extension">
        <xsl:call-template name="get-file-extension">
          <xsl:with-param name="path" select="@path"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:element name="{$name}">

        <xsl:for-each select="$attributes/*">
          <xsl:attribute name="{@name}" select="@value"/>
        </xsl:for-each>

        <xsl:if test="$extension = 'css'">
          <xsl:attribute name="href" select="relpath:assets-uri($relativePath, @path)" />
        </xsl:if>

        <xsl:if test="$extension = 'js'">
          <xsl:attribute name="src" select="relpath:assets-uri($relativePath, @path)" />
        </xsl:if>

      </xsl:element>
      <xsl:value-of select="$newline"/>
    </xsl:for-each>

  </xsl:template>

  <!-- This template render ons script element per script element declared in the theme config.xml -->
  <xsl:template match="tag[count(source/file) = 0 ][output != 'no']" mode="generate-d4p-uncompressed-css">

    <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes"/>

    <xsl:variable name="attributes">
      <xsl:for-each select="attributes/*">
        <attribute name="{name(.)}" value="{.}"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="extension">
      <xsl:choose>

        <xsl:when test="attributes/href">
          <xsl:call-template name="get-file-extension">
            <xsl:with-param name="path" select="attributes/href"/>
          </xsl:call-template>
        </xsl:when>

        <xsl:when test="attributes/src">
          <xsl:call-template name="get-file-extension">
          <xsl:with-param name="path" select="attributes/src"/>
          </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
          <xsl:call-template name="get-file-extension">
          <xsl:with-param name="path" select="filemane"/>
          </xsl:call-template>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="name">
      <xsl:call-template name="theme-get-tag-name">
          <xsl:with-param name="name" select="name" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:element name="{$name}">
      <xsl:for-each select="$attributes/*">
        <xsl:attribute name="{@name}" select="@value"/>
      </xsl:for-each>

      <xsl:value-of select="value" />
    </xsl:element>
  </xsl:template>


  <xsl:template match="tag[output != 'no']" mode="generate-d4p-compressed-css">
    <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes"/>

    <xsl:variable name="extension">
      <xsl:call-template name="get-file-extension">
        <xsl:with-param name="path" select="filename"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="name">
        <xsl:call-template name="theme-get-tag-name">
          <xsl:with-param name="name" select="name" />
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="dir">
      <xsl:choose>
        <xsl:when test="$extension = 'css'">css</xsl:when>
        <xsl:when test="$extension = 'js'">js</xsl:when>
        <xsl:otherwise>unknown</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="{$name}">

      <xsl:for-each select="attributes/*">
        <xsl:attribute name="{name(.)}" select="."/>
      </xsl:for-each>

      <xsl:if test="not(attributes/href) and $extension = 'css'">
        <xsl:attribute name="href" select="relpath:fixRelativePath($relativePath, concat($HTML5THEMEDIR, '/', $siteTheme, '/', $extension, '/', filename))" />
      </xsl:if>

      <xsl:if test="not(attributes/src) and $extension = 'js'">
        <xsl:attribute name="src" select="relpath:fixRelativePath($relativePath, concat($HTML5THEMEDIR, '/', $siteTheme, '/', $extension, '/', filename))" />
      </xsl:if>

      <xsl:value-of select="value" />

    </xsl:element>
    <xsl:value-of select="$newline"/>


  </xsl:template>

  <xsl:template match="*" mode="generate-d4p-compressed-css"/>

  <xsl:template name="theme-get-tag-name">
    <xsl:param name="name" />
    <xsl:choose>
      <xsl:when test="$name = 'link'">link</xsl:when>
      <xsl:when test="$name = 'script'">script</xsl:when>
      <xsl:otherwise>meta</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="d4p-variables">
  <xsl:param name="relativePath" tunnel="yes" as="xs:string*"/>
    <script type="text/javascript">
      <xsl:text>
        var d4p = {};
        d4p.relativePath = '</xsl:text><xsl:value-of select="$relativePath" /><xsl:text>';</xsl:text>
      <xsl:if test="$DBG='yes'">
        <xsl:text>
          d4p.dev = true;
        </xsl:text>
      </xsl:if>
    </script>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:function name="relpath:assets-uri" as="xs:string">
    <xsl:param name="relativePath" as="xs:string*"/>
    <xsl:param name="path" as="xs:string*"/>

    <xsl:variable name="pathwithdir">
      <xsl:choose>
        <xsl:when test="$HTTPABSOLUTEURI != ''">
          <xsl:value-of select="concat($HTTPABSOLUTEURI, $HTML5THEMEDIR, '/', $path)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="relpath:fixRelativePath($relativePath, concat($HTML5THEMEDIR, '/', $path))" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:sequence select="$pathwithdir"/>
  </xsl:function>

</xsl:stylesheet>
