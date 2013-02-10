<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xs m"
  >
  <!-- Formatting domain elements to HTML output -->
  
  <!-- Default width to use for tabs -->
  <xsl:param name="tabWidth" select="'1pc'" as="xs:string"/>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/br ')]" priority="10"
    mode="#default getTitle"
    >
    <br/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/tab ')]" priority="10"
    mode="#default getTitle">
    <span class="tab {@outputclass}">&#x09;</span>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/dropcap ')]" priority="10"
    mode="#default getTitle">
    <span class="dropcap {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/sc ')]" priority="10"
    mode="#default getTitle">
    <span class="sc {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/b-i ')]" priority="10"
    mode="#default getTitle">
    <b><span class="sc {@outputclass}"><xsl:apply-templates/></span></b>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/b-sc ')]" priority="10"
    mode="#default getTitle">
    <b><i><xsl:apply-templates/></i></b>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/line-through ')]" priority="10"
    mode="#default getTitle">
    <span style="text-decoration: line-through; {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/roman ')]" priority="10"
    mode="#default getTitle">
    <span style="font-weight: normal; font-style: normal;" class="roman {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/art ')]" priority="10"
    mode="#default getTitle">
    <xsl:apply-templates select="*[not(contains(@class, ' d4p-formatting-d/art_title '))]"/>
  </xsl:template>
  
  <!-- NOTE: these formatting-domain math-related elements have been superceded
       by the d4p Math domain. These are here for backward compatibility.
    -->
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/eqn-inline ')]">
    <span class="eqn-inline {@outputclass}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/eqn-block ')]">
    <div class="eqn-block {@outputclass}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/d4pMathML ')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  
</xsl:stylesheet>
