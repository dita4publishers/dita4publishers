<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       HTML Preview for Publication Map Domain Elements
       
       
       =============================================================== -->
  
<!--  <xsl:import href="../lib/dita-support-lib.xsl"/>
-->

  <xsl:template match="*[df:class(., 'pubmap-d/pubtitle')]">
    <div class="{df:getHtmlClass(.)}" 
      style="border-before: blue solid 2pt;
      border-after: blue solid 1pt;
      ">
      <h1><xsl:apply-templates/></h1>      
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')]">
    <div class="{df:getHtmlClass(.)}"
      style="format: block;
      background-color: #F0F0F0;
      color: black;
      border: black solid 1pt;
      padding: 6pt;
      "
      >
      <h4>Publication Metadata</h4>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/publisherinformation')]/*[df:class(., 'pubmeta-d/organization')]" priority="10">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>Publisher: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/isbn')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>ISBN: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/isbn-10')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>ISBN-10: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/isbn-13')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>ISBN-13: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="*[df:class(., 'pubmeta-d/printlocation')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>Printed location: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/pubrights')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/publicense')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/copyrfirst')]">
    <xsl:text>Copyright (c) </xsl:text><xsl:apply-templates/><xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="
    *[df:class(., 'pubmeta-d/publisherinformation')] |
    *[df:class(., 'pubmeta-d/pubid')] |
    *[df:class(., 'pubmeta-d/organization')] |
    *[df:class(., 'pubmeta-d/pubowner')] 
    ">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmeta-d/locnumber')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>Library of Congress Control Number: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'pubmap-d/keydefs')]">
    <xsl:if test="*[df:class(.,'map/topicref')]">
      <div class="keydefs">
        <p><b>Key Definitions</b></p>
        <table class="keydefs">
          <thead>
            <tr>
              <hd><b>Keys</b></hd>
              <hd><b>Target/Value</b></hd>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select=".//*[df:class(., 'map/topicref')]" mode="keydefs">
              
            </xsl:apply-templates>
          </tbody>          
        </table>        
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="keydefs" match="*[df:class(., 'map/topicref') and @keys != '']">
    <tr>
      <td>
        <xsl:value-of select="@keys"/>
      </td>
      <td>
        <xsl:value-of select="@href | @keyref"/>
      </td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
