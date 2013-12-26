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
  
 <xsl:variable name="activeAudience" select="/map/topicmeta/data[@name='active-audience'][1]/@value"/>
   
     
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-audience-select">
    <xsl:param name="uniqueTopicRefs" as="element()*" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] Generating audience select </xsl:message>
    <span id="audience-widget">       
        <button class="audienceBtn">
          <span class="hidden"><xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'chooseAudience'"/>
                </xsl:call-template></span>
        </button>

    <ul id="audience-select">
        <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]" mode="generate-audience-select"/>
      </ul>
    </span>
   
  </xsl:template>
  
<xsl:template match="*" mode="generate-audience-select">
  <xsl:apply-templates select="*" mode="generate-audience-select"/>
  </xsl:template>

 <xsl:template match="*[contains(@class, ' topic/audience ')]" mode="generate-audience-select">
  <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes"/>
  <xsl:message> + [INFO] Generating audience <xsl:value-of select="@name" /> entry </xsl:message>
  <xsl:if test="@name != $activeAudience">
  <li>
    <a href="{concat($relativePath, $indexUri, '/../../', @name, '/')}" class="d4p-no-ajax">
      <xsl:value-of select="@othertype" />
      <!--span class="ligther"> <xsl:value-of select="upper-case(@name)" /></span-->
    </a>
  </li>
</xsl:if>
  </xsl:template>

</xsl:stylesheet>
