<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs"
  version="2.0">
  <!-- Pubmap to XSLFO extensions for DITA Open Toolkit's PDF2 transform. 
  
  -->
  
  
  <xsl:template match="*[contains(@class, ' pubmap-d/chapter ')]" mode="determineTopicType">
    <xsl:text>pubmapChapter</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/article ')]" mode="determineTopicType">
    <xsl:text>pubmapArticle</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/subsection ')]" mode="determineTopicType">
    <xsl:text>pubmapSubsection</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/sidebar ')]" mode="determineTopicType">
    <xsl:text>pubmapSidebar</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/page ')]" mode="determineTopicType">
    <xsl:text>pubmapPage</xsl:text>
  </xsl:template>
  
  
  <xsl:template match="*[contains(@class, ' topic/topic ')]">
    <!-- This is a copy of this template from commons.xsl, since there's
         currently no way to extend it.
         
      -->
    <xsl:variable name="topicType">
      <xsl:call-template name="determineTopicType"/>
    </xsl:variable>
    
    <xsl:choose>
      <!-- Pubmap stuff -->
      <xsl:when test="$topicType = 'pubmapChapter'">
        <xsl:call-template name="processPubmapChapter"/>
      </xsl:when>
      <!-- original stuff -->
      <xsl:when test="$topicType = 'topicChapter'">
        <xsl:call-template name="processTopicChapter"/>
      </xsl:when>
      <xsl:when test="$topicType = 'topicAppendix'">
        <xsl:call-template name="processTopicAppendix"/>
      </xsl:when>
      <xsl:when test="$topicType = 'topicPart'">
        <xsl:call-template name="processTopicPart"/>
      </xsl:when>
      <xsl:when test="$topicType = 'topicPreface'">
        <xsl:call-template name="processTopicPreface"/>
      </xsl:when>
      <xsl:when test="$topicType = 'topicNotices'">
        <!-- Suppressed in normal processing, since it goes at the beginning of the book. -->
        <!-- <xsl:call-template name="processTopicNotices"/> -->
      </xsl:when>
      <xsl:when test="$topicType = 'topicSimple'">
        <xsl:variable name="page-sequence-reference">
          <xsl:choose>
            <xsl:when test="$mapType = 'bookmap'">
              <xsl:value-of select="'body-sequence'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'ditamap-body-sequence'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="not(ancestor::*[contains(@class,' topic/topic ')])">
            <fo:page-sequence master-reference="{$page-sequence-reference}" xsl:use-attribute-sets="__force__page__count">
              <xsl:call-template name="insertBodyStaticContents"/>
              <fo:flow flow-name="xsl-region-body">
                <xsl:choose>
                  <xsl:when test="contains(@class,' concept/concept ')"><xsl:call-template name="processConcept"/></xsl:when>
                  <xsl:when test="contains(@class,' task/task ')"><xsl:call-template name="processTask"/></xsl:when>
                  <xsl:when test="contains(@class,' reference/reference ')"><xsl:call-template name="processReference"/></xsl:when>
                  <xsl:otherwise><xsl:call-template name="processTopic"/></xsl:otherwise>
                </xsl:choose>
              </fo:flow>
            </fo:page-sequence>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="contains(@class,' concept/concept ')"><xsl:call-template name="processConcept"/></xsl:when>
              <xsl:when test="contains(@class,' task/task ')"><xsl:call-template name="processTask"/></xsl:when>
              <xsl:when test="contains(@class,' reference/reference ')"><xsl:call-template name="processReference"/></xsl:when>
              <xsl:otherwise><xsl:call-template name="processTopic"/></xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!--BS: skipp abstract (copyright) from usual content. It will be processed from the front-matter-->
      <xsl:when test="$topicType = 'topicAbstract'"/>
      <xsl:otherwise>
        <xsl:call-template name="processUnknowTopic">
          <xsl:with-param name="topicType" select="$topicType"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="processPubmapChapter">
    <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
      <xsl:call-template name="startPageNumbering"/>
      <xsl:call-template name="insertBodyStaticContents"/>
      <fo:flow flow-name="xsl-region-body">
        <fo:block xsl:use-attribute-sets="topic">
          <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
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
          
          <xsl:call-template name="insertChapterFirstpageStaticContent">
            <xsl:with-param name="type" select="'chapter'"/>
          </xsl:call-template>      
          
          <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
          
          <fo:block xsl:use-attribute-sets="topic.title">
            <xsl:call-template name="pullPrologIndexTerms"/>
            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
              <xsl:call-template name="getTitle"/>
            </xsl:for-each>
          </fo:block>
          
          <fo:block>
            <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
              contains(@class, ' topic/prolog '))]"/>
            <xsl:call-template name="buildRelationships"/>
          </fo:block>
          
          <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
</xsl:stylesheet>
