<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xs m"
  >
  <!-- Formatting domain elements to XSL-FO -->
  
  <!-- Default width to use for tabs -->
  <xsl:param name="tabWidth" select="'1pc'" as="xs:string"/>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/br ')]" priority="10"
    mode="#default getTitle"
    >
    <br/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/tab ')]" priority="10"
    mode="#default getTitle">
    <span class="tab">&#x09;</span>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-formatting-d/art ')]" priority="10"
    mode="#default getTitle">
    <xsl:apply-templates select="*[not(contains(@class, ' d4p-formatting-d/art_title '))]"/>
  </xsl:template>
  
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
  
  <xsl:template match="m:math">
    <xsl:param name="blockOrInline" as="xs:string" tunnel="yes" select="'inline'"/>
    <math xmlns="http://www.w3.org/1998/Math/MathML"      
      >
      <xsl:if test="$blockOrInline = 'block'">
        <xsl:attribute name="display" select="'block'"/>
      </xsl:if>
      <xsl:apply-templates mode="math-ml"/>
    </math>
  </xsl:template>
  
  <!-- ==============================================
       MathML 
       
       As of 12/2011, the current Firefox and Safari 5.1+
       browsers support embedded MathML natively.
       
       Chrome does not have it turned on but it's built into
       Webkit (as used by Safari).
       
       Opera does not currently support MathML 
       
       IE Requires the MathPlayer plugin and XHTML with 
       the doctype 
       
       DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN"
       "http://www.w3.org/Math/DTD/mathml2/xhtml-math11-f.dtd"
       
       And XHTML namespace on the <html> element:
       
       <html xmlns="http://www.w3.org/1999/xhtml"
       
       ============================================== -->
  
  <!-- FIXME: Need to provide both MathML output and alternative plain-text
       output for accessability.
    -->
  
  <xsl:template mode="math-ml" match="*" xmlns="http://www.w3.org/1998/Math/MathML">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="math-ml" match="@*">
    <xsl:sequence select="."/>
  </xsl:template>
  
</xsl:stylesheet>
