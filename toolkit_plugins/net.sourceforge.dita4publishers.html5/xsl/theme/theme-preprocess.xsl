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
  
  <xsl:include href="../function.xsl"/>
 
  <xsl:param name="html5dir" select="''" />
  <xsl:param name="html5sitetheme" select="''" />
  <xsl:param name="script" select="''" />
  <xsl:param name="outputdir" select="''" /> 
  <xsl:param name="themedir" select="''" /> 

  <xsl:output name="ant" method="xml" indent="yes"/>
   
  <xsl:template match="/">
      <xsl:apply-templates select="*" mode="tag-preprocess" />  
  </xsl:template>
  
  <xsl:template match="html5" mode="tag-preprocess">
    <project name="package" basedir="." default="packager.package">
       <xsl:comment>
          This file has been created by the Dita4Publishers Project.
          The html5 plugin is required in order to run this script.
       </xsl:comment>
       
       <import file="{concat($html5dir, '/', $script)}" />
       
        <target name="packager.package">     
          <package-prepare theme="{$html5sitetheme}" />        
          <xsl:apply-templates select="*" mode="#current" /> 
          <package-get theme="{$html5sitetheme}" dir="{concat('${basedir}', '/../')}" /> 
        </target>
        
    </project>
  </xsl:template>
  
  <xsl:template match="tag[count(source/file) &gt; 0]" mode="tag-preprocess">
      <xsl:variable name="filename" select="filename"/>
      <xsl:variable name="extension">
       <xsl:call-template name="get-file-extension">
         <xsl:with-param name="path" select="$filename" />
      </xsl:call-template>
      </xsl:variable>
      
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="$extension = 'js'">
          <xsl:value-of select="'js'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'css'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="filelist">
      <xsl:for-each select="source/file">
      
        <xsl:variable name="fileExtension">
          <xsl:call-template name="get-file-extension">
               <xsl:with-param name="path" select="@path" />
            </xsl:call-template>
        </xsl:variable>
          
        <xsl:choose>
            <xsl:when test="$extension = $fileExtension">
              <xsl:choose>
                <xsl:when test="position() = last()" >
                    <xsl:value-of select="@path"/>
                </xsl:when>
                 <xsl:otherwise>
                  <xsl:value-of select="concat(./@path, ',')"/>
                </xsl:otherwise>  
              </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message> + [WARNING]: <xsl:value-of select="@path" /> has not a valid extension</xsl:message>
          </xsl:otherwise>
        </xsl:choose>
          
      </xsl:for-each>
    </xsl:variable>  

  
    <package type="{$type}" theme="{$html5sitetheme}" filelist="{$filelist}" to="{substring-before($filename, concat('.', $extension))}" />
     
  </xsl:template>
  
  
  <xsl:template match="*"/>
  <xsl:template match="*"  mode="tag-preprocess"/>

</xsl:stylesheet>
