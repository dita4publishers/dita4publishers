<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.1"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
  >
  
  <!-- Override of base createFrontMatter_1.0 -->
  
  <xsl:template match="*[contains(@class,' topic/data ') and @name = 'prepared_for']" mode="cover.page">
    <fo:block
      xsl:use-attribute-sets="cover.prepared-for"
      ><xsl:text>Prepared for </xsl:text><xsl:apply-templates/></fo:block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/data ') and @name = 'version']" mode="cover.page">
    <fo:block
      xsl:use-attribute-sets="cover.region-after"
      ><xsl:text>Version </xsl:text><xsl:apply-templates/></fo:block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/data ') and @name = 'release_status']" mode="cover.page">
    <fo:block
      xsl:use-attribute-sets="cover.region-after"
      ><xsl:text>Status: </xsl:text><xsl:apply-templates/></fo:block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/critdates ')]" mode="cover.page">
    <xsl:apply-templates mode="cover.page"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/critdates ')]/*[contains(@class,' topic/created ')]" mode="cover.page">
    <fo:block
      xsl:use-attribute-sets="cover.region-after"><xsl:text>Created: </xsl:text><xsl:value-of select="@date"/></fo:block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/critdates ')]/*[contains(@class,' topic/revised ')]" mode="cover.page">
    <fo:block
      xsl:use-attribute-sets="cover.region-after"><xsl:text>Revised: </xsl:text><xsl:value-of select="@modified"/></fo:block>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="cover.page">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="createFrontMatter_1.0">
    <xsl:if test="$map/*[contains(@class,' topic/title ')][1]">
      <fo:page-sequence master-reference="cover-pages" force-page-count="even">
        <fo:static-content flow-name="xsl-region-after">
          <xsl:apply-templates select="$map/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/critdates ')]" mode="cover.page"/>
          <xsl:apply-templates select="$map/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/data ') and @name = 'version']" mode="cover.page"/>
          <xsl:apply-templates select="$map/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/data ') and @name = 'release_status']" mode="cover.page"/>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <fo:block 
            xsl:use-attribute-sets="cover.title"
            >
            <xsl:apply-templates select="$map/*[contains(@class,' topic/title ')][1]" mode="cover.page"/>
          </fo:block>
          <xsl:apply-templates select="$map/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/data ') and @name = 'prepared_for']" mode="cover.page"/>
        </fo:flow>
      </fo:page-sequence>
    </xsl:if>
    
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/section ') and @spectitle != '']" priority="5">
    <fo:block xsl:use-attribute-sets="section" id="{@id}">
      <fo:block xsl:use-attribute-sets="section.title" id="{generate-id(.)}">
        <xsl:value-of select="@spectitle"/>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  
  

  
</xsl:stylesheet>