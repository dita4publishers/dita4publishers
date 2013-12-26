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
  <!-- from http://blog.morg.nl/2012/02/get-file-extention-in-xslt/ -->
  <xsl:template name="get-file-extension">
    <xsl:param name="path"/>
    <xsl:choose>
        <xsl:when test="contains($path, '/')">
            <xsl:call-template name="get-file-extension">
                <xsl:with-param name="path" select="substring-after($path, '/')"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($path, '.')">
            <xsl:call-template name="get-file-extension">
                <xsl:with-param name="path" select="substring-after($path, '.')"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$path"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

  

</xsl:stylesheet>
