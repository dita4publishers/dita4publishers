<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     HTML generation templates for the pubmap DITA domain.
     
     Copyright (c) 2009 DITA For Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="*[contains(@class, ' d4p-formatting-d/art ')] | 
                       *[contains(@class, ' d4p-formatting-d/art-ph ')]">
    <xsl:apply-templates select="*[contains(@class, ' topic/image ')]"></xsl:apply-templates>
  </xsl:template>
  
</xsl:stylesheet>
