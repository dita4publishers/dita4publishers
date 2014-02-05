<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic"
    version="2.0">

   <!-- Overrides of front-matter.xsl -->
  
    <xsl:template name="createTitlePage">
      <fo:block xsl:use-attribute-sets="__frontmatter">
          <!-- set the title -->
          <fo:block xsl:use-attribute-sets="__frontmatter__title">
              <xsl:choose>
                  <xsl:when test="//*[contains(@class,' bkinfo/bkinfo ')][1]">
                      <xsl:apply-templates select="//*[contains(@class,' bkinfo/bkinfo ')][1]/*[contains(@class,' topic/title ')]/node()"/>
                  </xsl:when>
                  <xsl:when test="//*[contains(@class, ' map/map ')]/@title">
                      <xsl:value-of select="//*[contains(@class, ' map/map ')]/@title"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"/>
                  </xsl:otherwise>
              </xsl:choose>
          </fo:block>

          <!-- set the subtitle -->
          <xsl:apply-templates select="//*[contains(@class,' bkinfo/bkinfo ')][1]/*[contains(@class,' bkinfo/bktitlealts ')]/*[contains(@class,' bkinfo/bksubtitle ')]"/>

          <fo:block xsl:use-attribute-sets="__frontmatter__owner">
              <xsl:choose>
                  <xsl:when test="//*[contains(@class,' bkinfo/bkowner ')]">
                      <xsl:apply-templates select="//*[contains(@class,' bkinfo/bkowner ')]"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:apply-templates select="$map/*[contains(@class, ' map/topicmeta ')]"/>
                  </xsl:otherwise>
              </xsl:choose>
          </fo:block>

      </fo:block>
    </xsl:template>

    <xsl:template name="createCopyrightPage">
      <xsl:call-template name="processCopyrigth"/>
    </xsl:template>

</xsl:stylesheet>