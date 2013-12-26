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
  
  
  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tm')]" mode="nav-point-title">
    <xsl:apply-templates mode="#current"/>
    <xsl:choose>
      <xsl:when test="@type = 'reg'">
        <xsl:text>[reg]</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'sm'">
        <xsl:text>[sm]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[tm]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
    <xsl:template mode="nav-point-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="navPointTitleString" select="df:getNavtitleForTopicref(.)"/>
    <xsl:value-of select="$navPointTitleString"/>
  </xsl:template>
  
  
  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- Per the 1.2 spec, topic group navtitles are always ignored -->
  </xsl:template>
  
    <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/body')]" priority="10">
    <!-- Suppress body from output -->
  </xsl:template>

    <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/shortdesc')]" priority="10">
    <!-- Suppress body from output -->
  </xsl:template>
  
  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/abstract')]" priority="10">
    <!-- Suppress body from output -->
  </xsl:template>
  
    <xsl:template mode="nav-point-title" match="concept/concept" priority="10">
    <!-- Suppress body from output -->
  </xsl:template>
  
  
  
<!--  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/title')]" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
-->
  
 </xsl:stylesheet>
