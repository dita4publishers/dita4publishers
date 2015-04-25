<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
        DITA for Publishers Formatting Domain Support    
       =============================================================== -->
  
<!--  <xsl:import href="../lib/dita-support-lib.xsl"/>
-->
  <xsl:template match="tab | *[df:class(., 'd4p-formatting-d/tab')]">
    <span class="tab">&#xa0;</span>
  </xsl:template>
  
  <xsl:template match="br | *[contains(@class, ' d4p-formatting-d/br ')]" priority="10"
    mode="#default getTitle"
    >
    <br/>
  </xsl:template>
  
  <xsl:template match="dropcap | *[contains(@class, ' d4p-formatting-d/dropcap ')]" priority="10"
    mode="#default getTitle">
    <span class="dropcap {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="sc | *[contains(@class, ' d4p-formatting-d/sc ')]" priority="10"
    mode="#default getTitle">
    <span class="sc {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="b-i | *[contains(@class, ' d4p-formatting-d/b-i ')]" priority="10"
    mode="#default getTitle">
    <b><span class="sc {@outputclass}"><xsl:apply-templates/></span></b>
  </xsl:template>
  
  <xsl:template match="b-sc | *[contains(@class, ' d4p-formatting-d/b-sc ')]" priority="10"
    mode="#default getTitle">
    <b><i><xsl:apply-templates/></i></b>
  </xsl:template>
  
  <xsl:template match="line-through | *[contains(@class, ' d4p-formatting-d/line-through ')]" priority="10"
    mode="#default getTitle">
    <span style="text-decoration: line-through; {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="roman | *[contains(@class, ' d4p-formatting-d/roman ')]" priority="10"
    mode="#default getTitle">
    <span style="font-weight: normal; font-style: normal;" class="roman {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  
  
  <xsl:template match="art | *[contains(@class, ' d4p-formatting-d/art ')]" priority="10"
    mode="#default getTitle">
    <xsl:apply-templates select="*[not(contains(@class, ' d4p-formatting-d/art_title '))]"/>
  </xsl:template>
  
  <xsl:template match="art-ph | *[contains(@class, ' d4p-formatting-d/art-ph ')]" priority="10"
    mode="#default getTitle">
    <xsl:apply-templates select="*[not(contains(@class, ' d4p-formatting-d/art_title '))]"/>
  </xsl:template>
  
  <!-- NOTE: these formatting-domain math-related elements have been superceded
       by the d4p Math domain. These are here for backward compatibility.
    -->
  <xsl:template match="eqn-inline | *[contains(@class, ' d4p-formatting-d/eqn-inline ')]">
    <span class="eqn-inline {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="eqn-block | *[contains(@class, ' d4p-formatting-d/eqn-block ')]">
    <div class="eqn-block {@outputclass}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="d4pMathML | *[contains(@class, ' d4p-formatting-d/d4pMathML ')]">
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>
