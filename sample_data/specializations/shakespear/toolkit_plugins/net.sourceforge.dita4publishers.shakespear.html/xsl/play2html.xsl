<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     HTML generation templates for the Shakespear play specializations..
     
     Copyright (c) 2009 W. DITA 4 Publishers
     
     =========================================================== -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="*[contains(@class, ' play-component/speech ')]" priority="10">
    <div style="display: block; margin-left: 0.5in" class="speech">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' topic/p ')][@outputclass = 'play-subtitle']" priority="10">
    <div style="display: block; text-align: center; font-weight: bold; 
                font-size: 16px; margin: 50px;" 
      class="{@outputclass}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' personae/pgroup ')]" priority="10">
    <div style="display: block; margin-left: 0.25in" class="pgroup">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' personae/grpdescr ')]" priority="10">
    <p style="font-style: italic;" class="pgroup"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' play-component/speaker ')]" priority="10">
    <p style="font-weight: bold; text-indent: -0.5in;" class="speaker"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' play-component/line ')]" priority="10">
    <xsl:apply-templates/><br/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' play-component/speech ')]/*[contains(@class, ' play-component/stagedir ')]" priority="11">
    <p><i>{<xsl:apply-templates/>}</i></p>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' play-component/stagedir ')]" priority="10">
    <i class="stagedir">{<xsl:apply-templates/>}</i>
  </xsl:template>
  
</xsl:stylesheet>
