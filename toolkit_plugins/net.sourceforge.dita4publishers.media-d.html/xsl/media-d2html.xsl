<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xs m"
  >
  <!-- Media domain elements to HTML -->
  
  <xsl:template match="*[contains(@class, ' d4p-media-d/d4p_video ')]">
    
    <video controls="controls">
      <xsl:sequence select="@id, @width, @height"/>
      <xsl:apply-templates 
        select="*[contains(@class, ' d4p-media-d/d4p_video_poster ')],
        *[contains(@class, ' d4p-media-d/d4p_video_source ')],
        *[contains(@class, ' topic/desc ')]"/>
    </video>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' d4p-media-d/d4p_video ')]/*[contains(@class, ' topic/desc ')]"
    priority="10"
    >
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-media-d/d4p_video_source ')]">
    <source src="{@value}" type="{@type}"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' d4p-media-d/d4p_video_poster ')]">
    <xsl:attribute name="poster" select="string(@value)"/>
  </xsl:template>
  
</xsl:stylesheet>
