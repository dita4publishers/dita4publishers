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
  xmlns:dita-ot-pdf="http://net.sf.dita-ot/transforms/pdf"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df local dita-ot-pdf"
  version="2.0">

  <!--================================
    
      Process topics
      
      (Code taken from commons.xsl in the
      base PDF transform).
      
      These templates do all handling of
      topic elements. Selection of topics
      that should act as top-level topics
      (parts, chapters, appendixes, etc.)
      is done using the dita-ot-pdf:determineTopicType()
      function. Other topics are processed either
      by topic type or by normal context-based
      selection, either using ancestor topic
      types or not.
      
      ================================-->
  <xsl:template match="
    *[df:class(., 'topic/topic') and
      dita-ot-pdf:determineTopicType(.) = 
             ('topicPart', 'topicChapter', 'topicAppendix', 'topicPreface', 'topicNotices')]">
    
    <!-- Generate the FO within a page sequence
         for a top-level topic.
         
         Note that the page sequence is constructed
         separately and that there is not necessarily
         a one-to-one mappin from topics to
         page sequences.
         
    -->
    
    <!-- Capture the topic type so we don't have to recalculate it where it can be 
         passed as a parameter.
      -->
    <xsl:variable name="topicType" select="dita-ot-pdf:determineTopicType(.)" as="xs:string"/>
    
    <xsl:if test="false()">
      <xsl:variable name="topicref" select="dita-ot-pdf:getTopicrefForTopic(.)" as="element()?"/>
      
      <xsl:message> + [DEBUG] top-level topic processing: tagname="<xsl:sequence select="name(.)"/>", id="<xsl:sequence select="string(@id)"/>", topicType="<xsl:sequence select="$topicType"/>", topicrefType="<xsl:sequence 
        select="if ($topicref) then name($topicref) else 'No topicref for topic'"/>"</xsl:message>
    </xsl:if>
    
    <fo:block xsl:use-attribute-sets="topic">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setTopicPageBreak">
        <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
      </xsl:call-template>
      <xsl:apply-templates select="." mode="setTopicMarkers">
        <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]">
        <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
      </xsl:apply-templates>

        <!-- Generate the chapter opener stuff: -->
      <xsl:call-template name="insertChapterFirstpageStaticContent">
        <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
      </xsl:call-template>
      

      <fo:block xsl:use-attribute-sets="topic.title">
          <!-- added by William on 2009-07-02 for indexterm bug:2815485 start-->
          <xsl:call-template name="pullPrologIndexTerms"/>
          <!-- added by William on 2009-07-02 for indexterm bug:2815485 end-->
          
          <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
              <xsl:call-template name="getTitle">
                <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
              </xsl:call-template>
          </xsl:for-each>
      </fo:block>

      <xsl:choose>
        <xsl:when test="$chapterLayout='BASIC'">
            <fo:block>
              <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                                                 contains(@class, ' topic/prolog '))]"/>                
              <xsl:call-template name="buildRelationships">
                <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
              </xsl:call-template>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="createMiniToc">
             <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="*[contains(@class,' topic/topic ')]">
         <xsl:with-param name="topicType" as="xs:string" select="$topicType" tunnel="yes"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="insertChapterFirstpageStaticContent">
    <xsl:param name="type" required="no" select="'unused'"/>
    <xsl:param name="topicType" tunnel="yes" as="xs:string"/>
    
    <xsl:if test="false()">
      <xsl:message>+ [DEBUG] insertChapterFirstpageStaticContent: context is <xsl:sequence 
          select="concat(name(..), '/', name(.), ', id=', @id)"/></xsl:message>
    </xsl:if>    
    <fo:block>
      <xsl:attribute name="id">
        <xsl:call-template name="generate-toc-id"/>
      </xsl:attribute>
    
      <xsl:apply-templates select="." mode="insertFirstPageStaticContent"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template mode="setTopicMarkers" match="*[df:class(., 'topic/topic')]">
    <fo:marker marker-class-name="current-topic-number">
      <xsl:number format="1"/>
    </fo:marker>
    <fo:marker marker-class-name="current-header">
      <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
         <xsl:call-template name="getTitle"/>
      </xsl:for-each>
    </fo:marker>
  </xsl:template>
  
  <xsl:template name="setTopicPageBreak">
    <xsl:apply-templates mode="setTopicPageBreak" select="."/>
  </xsl:template>
  
  <xsl:template mode="setTopicPageBreak" match="*[df:class(., 'topic/topic')]">
    <xsl:param name="topicType" tunnel="yes" as="xs:string" 
      select="dita-ot-pdf:determineTopicType(.)"
    />
    
    <xsl:choose>
      <xsl:when test="
        ($topicType = ('topicChapter', 'topicPart', 'topicAppendix')) or
         not(ancestor::*[df:class(., 'topic/topic')])
        ">
        <xsl:attribute name="break-before" select="'odd-page'"/>        
      </xsl:when>
      <xsl:otherwise>
        <!-- No page break -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Override of same template from base commons.xsl.
    
       This override removes the generation of fo:page-sequence
       
  -->
  <xsl:template match="*[contains(@class, ' topic/topic ')]" priority="0">
<!--    <xsl:message>+ [DEBUG] #default: default topic handling for topic <xsl:sequence select="concat(name(.), ', id=', @id, ', type=', dita-ot-pdf:determineTopicType(.))"/></xsl:message>-->
     
    <xsl:call-template name="processTopic"/>
         
  </xsl:template>

</xsl:stylesheet>
