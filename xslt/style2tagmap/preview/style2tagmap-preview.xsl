<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:s2t="urn:public:/dita4publishers.org/namespaces/word2dita/style2tagmap"
      xmlns:RSUITE="http://www.reallysi.com"
      exclude-result-prefixes="xs"
      version="2.0">

  <xsl:param name="rsuite.sessionkey" as="xs:string" select="'unset'"/>
  <xsl:param name="rsuite.serverurl" as="xs:string" select="'urn:unset:/dev/null'"/>
  

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:apply-templates select="*/s2t:title" mode="head"/></title>
        <link href="/rsuite/rest/v1/content/alias/style2tagmap-preview.css?skey={$rsuite.sessionkey}"
          REL="stylesheet" TYPE="text/css" />
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="RSUITE:*"/>
  
  <xsl:template match="s2t:title" mode="head">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="s2t:style2tagmap">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="s2t:title">
    <h1><xsl:apply-templates/></h1>
  </xsl:template>
  
  <xsl:template match="s2t:documentation">
    <div class="documentation">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="s2t:styles">
    <div class="outputs">
      <h2>Output Definitions</h2>
      <table class="outputs" border="1">
        <thead>
          <tr>
            <th>Output Name</th>
            <th>Public ID</th>
            <th>System ID</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="s2t:output"/>        
        </tbody>        
      </table>
    </div>
    <div class="styles">
      <h2>Style Definitions</h2>
      <xsl:apply-templates select="s2t:style"/>
    </div>
  </xsl:template>
  
  <xsl:template match="s2t:output">
    <tr>
      <td class="outputName"><xsl:value-of select="@name"/></td>
      <td class="outputPubid"><xsl:value-of select="@doctype-public"/></td>
      <td class="outputSystem"><xsl:value-of select="@doctype-system"/></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="s2t:style">
    <div class="style">
      <h3><xsl:value-of select="@styleId"/></h3>
      <div class="style-details">
        <table class="style-details" border="1">
          <tbody>
            <xsl:apply-templates select="@*">
              <xsl:sort select="name(.)"/>
            </xsl:apply-templates>
          </tbody>          
        </table>
      </div>
    </div>
  </xsl:template>
  
  <xsl:template match="s2t:style/@*">
    <tr>
      <td class="styleAttName"><xsl:sequence select="name(.)"/></td>
      <td class="styleAttValue"><xsl:sequence select="string(.)"/></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
