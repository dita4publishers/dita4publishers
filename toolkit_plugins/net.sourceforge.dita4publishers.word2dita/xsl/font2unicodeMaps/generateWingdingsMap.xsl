<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  
  <xsl:output method="xml" 
    indent="yes"
  />
  
  <xsl:template match="/">
    <Font2UnicodeMap sourceFont="Wingdings">
      <xsl:comment> See http://www.alanwood.net/demos/wingdings.html </xsl:comment>
      <xsl:apply-templates/>
    </Font2UnicodeMap>
  </xsl:template>
  
  <xsl:template match="table">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tr">
    <!--
   <tr valign="top">
    <td class="big">&#8216;<font face="Wingdings"><span style="color:#c0c0c0; background-color:#c0c0c0;">&#32;</span></font>&#8217;</td>
    <td align="center">32</td>
    <td align="center">0x20</td>
    <td>space</td>
    <td class="big">&#8216;<span style="color:#c0c0c0; background-color:#c0c0c0;">&#32;</span>&#8217;</td>
    <td>32</td>
    <td>U+0020</td>
    <td>Space</td>
    <td>Basic Latin</td>
  </tr>

      -->
    <xsl:variable name="origCodePoint" 
      select="translate(string(td[3]), '0x', '00')" as="xs:string"/>
    <xsl:variable name="unicodeCodePoint" 
      select="translate(string(td[7]), 'U+', '')" as="xs:string"/>
    <xsl:variable name="charName" select="string(td[8])" as="xs:string"/>
    <codePointMapping
      origCodePoint="{$origCodePoint}"
      unicodeCodePoint="{if ($unicodeCodePoint = '') then '003F' else $unicodeCodePoint}"
      characterName="{if ($charName = '') then '#No Unicode Equivalent' else $charName}"
   />

  </xsl:template>
  
</xsl:stylesheet>