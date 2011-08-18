<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:local="http://local/functions"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:dita-ot="http://net.sf.dita-ot"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df local"
  version="2.0">

  <!--================================
    
      commons.xsl overrides
      
      ================================-->
  <xsl:template name="processTopLevelTopic">
    <!-- Generate the FO within a page sequence
         for a top-level topic.
         
         Note that the page sequence is constructed
         separately and that there is not necessarily
         a one-to-one mappin from topics to
         page sequences.
         
     -->
    
    <fo:block xsl:use-attribute-sets="topic">
        <xsl:call-template name="commonattributes"/>
        <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
            <fo:marker marker-class-name="current-topic-number">
                <xsl:number format="1"/>
            </fo:marker>
            <fo:marker marker-class-name="current-header">
                <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                    <xsl:call-template name="getTitle"/>
                </xsl:for-each>
            </fo:marker>
        </xsl:if>

        <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

        <xsl:call-template name="insertChapterFirstpageStaticContent">
            <xsl:with-param name="type" select="'chapter'"/>
        </xsl:call-template>

        <fo:block xsl:use-attribute-sets="topic.title">
            <!-- added by William on 2009-07-02 for indexterm bug:2815485 start-->
            <xsl:call-template name="pullPrologIndexTerms"/>
            <!-- added by William on 2009-07-02 for indexterm bug:2815485 end-->
            
            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                <xsl:call-template name="getTitle"/>
            </xsl:for-each>
        </fo:block>

        <xsl:choose>
          <xsl:when test="$chapterLayout='BASIC'">
              <fo:block>
                <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                                                   contains(@class, ' topic/prolog '))]"/>
                <xsl:call-template name="buildRelationships"/>
              </fo:block>
          </xsl:when>
          <xsl:otherwise>
              <xsl:call-template name="createMiniToc"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
