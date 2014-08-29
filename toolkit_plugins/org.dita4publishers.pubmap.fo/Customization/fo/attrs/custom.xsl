<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">
  
  <xsl:attribute-set name="__fo__root">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="cover.title">
    <xsl:attribute name="space-before">2.5in</xsl:attribute>
    <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="cover.prepared-for">
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="cover.region-after">
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>
  
  
  <xsl:attribute-set name="topic.title">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="border-bottom">3pt solid grey</xsl:attribute>
    <xsl:attribute name="margin-top">0pc</xsl:attribute>
    <xsl:attribute name="margin-bottom">1.4pc</xsl:attribute>
    <xsl:attribute name="font-size">18pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="padding-top">1.4pc</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>
    
  <xsl:attribute-set name="topic.topic.title">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="border-bottom">1pt solid grey</xsl:attribute>
    <xsl:attribute name="space-before.optimum">14pt</xsl:attribute>
    <xsl:attribute name="margin-top">1pc</xsl:attribute>
    <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="padding-top">1pc</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="elementref.title">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="border-bottom">1pt solid grey</xsl:attribute>
    <xsl:attribute name="space-before.optimum">14pt</xsl:attribute>
    <xsl:attribute name="margin-top">1pc</xsl:attribute>
    <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="padding-top">1pc</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.title__content">
    <xsl:attribute name="border-left-width">0pt</xsl:attribute>
    <xsl:attribute name="border-right-width">0pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.title">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="margin-top">1pc</xsl:attribute>
    <xsl:attribute name="margin-bottom">2pt</xsl:attribute>
    <xsl:attribute name="font-size">13pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.title__content">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.topic.title">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="margin-top">10pt</xsl:attribute>
    <xsl:attribute name="margin-left">25pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.topic.title__content">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.topic.topic.title">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="margin-left">25pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.topic.topic.title__content">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title">
    <xsl:attribute name="font-family">Sans</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="margin-left">25pt</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title__content">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="sthead.stentry">
    <xsl:attribute name="padding">3pt 3pt 3pt 3pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="strow">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="sthead.stentry__content">
  </xsl:attribute-set>
  
  <!-- make shortdesc left margin same as the body paragraphs -->
  <xsl:attribute-set name="shortdesc" use-attribute-sets="p body__toplevel">
  </xsl:attribute-set>
  
</xsl:stylesheet>