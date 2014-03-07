<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="2.0">

  <!-- common attribute sets -->


    <xsl:attribute-set name="topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">15pt</xsl:attribute>
        <xsl:attribute name="space-before">12pt</xsl:attribute>
        <xsl:attribute name="space-after">5pt</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">12pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="abstract" use-attribute-sets="cnu">
    </xsl:attribute-set>
    
    <!-- added by cnu -->
     <xsl:attribute-set name="cnu">
   <xsl:attribute name="font-size"><xsl:value-of select="'1pt'"/></xsl:attribute>
   <xsl:attribute name="font-family">Sans</xsl:attribute>
    </xsl:attribute-set>
     
     <!-- end by cnu -->

</xsl:stylesheet>
