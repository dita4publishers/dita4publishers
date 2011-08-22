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
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df local dita-ot"
  version="2.0">

  <!--================================
    
      commons.xsl overrides
      
      ================================-->
  <xsl:template name="processTopLevelTopic">
    <xsl:param name="topicType" as="xs:string" tunnel="yes"/>
    
    <!-- Generate the FO within a page sequence
         for a top-level topic.
         
         Note that the page sequence is constructed
         separately and that there is not necessarily
         a one-to-one mappin from topics to
         page sequences.
         
     -->
    <xsl:variable name="topicref" select="dita-ot:getTopicrefForTopic(.)" as="element()?"/>
    <xsl:message> + [DEBUG] processTopLevelTopic: tagname="<xsl:sequence select="name(.)"/>", id="<xsl:sequence select="string(@id)"/>", topicType="<xsl:sequence select="$topicType"/>", topicrefType="<xsl:sequence 
      select="if ($topicref) then name($topicref) else 'No topicref for topic'"/>"</xsl:message>
    
    <fo:block xsl:use-attribute-sets="topic">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setTopicPageBreak"/>
      <xsl:apply-templates select="." mode="setTopicMarkers"/>

      <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

        <!-- Generate the chapter opener stuff: -->
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
    <xsl:param name="topicType" tunnel="yes"/>
    <xsl:param name="pubRegion" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="contains($topicType, 'topicChapter') or
        contains($topicType, 'topicPart') or
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
  <xsl:template match="*[contains(@class, ' topic/topic ')]">
    <xsl:param name="topicType" as="xs:string" tunnel="yes"/>
    <xsl:variable name="ancestorTopicType" select="$topicType"/>
    <xsl:variable name="myTopicType">
        <xsl:call-template name="determineTopicType"/>
    </xsl:variable>
    
<!--    <xsl:message>+ [DEBUG] commons.xsl: topic/topic: ancestorTopicType="<xsl:sequence select="$ancestorTopicType"/>"</xsl:message>-->
<!--    <xsl:message>+ [DEBUG] commons.xsl: topic/topic:       myTopicType="<xsl:sequence select="$myTopicType"/>"</xsl:message>-->

      <xsl:choose>
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
          <xsl:choose>
            <xsl:when test="contains(@class,' concept/concept ')">
              <xsl:call-template name="processConcept"/>
            </xsl:when>
            <xsl:when test="contains(@class,' task/task ')">
              <xsl:call-template name="processTask"/>
            </xsl:when>
            <xsl:when test="contains(@class,' reference/reference ')">
              <xsl:call-template name="processReference"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="processTopic"/>                    
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

    <!--  Bookmap Chapter processing  -->
    <xsl:template name="processTopicChapter">
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

    <!--  Bookmap Appendix processing  -->
    <xsl:template name="processTopicAppendix">
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
              <xsl:with-param name="type" select="'appendix'"/>
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
            <xsl:when test="$appendixLayout='BASIC'">
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

    <!--  Bookmap Part processing  -->
    <xsl:template name="processTopicPart">
        <fo:block xsl:use-attribute-sets="topic">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                <fo:marker marker-class-name="current-topic-number">
                    <xsl:number format="I"/>
                </fo:marker>
                <fo:marker marker-class-name="current-header">
                    <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                        <xsl:call-template name="getTitle"/>
                    </xsl:for-each>
                </fo:marker>
            </xsl:if>

            <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

            <xsl:call-template name="insertChapterFirstpageStaticContent">
                <xsl:with-param name="type" select="'part'"/>
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
              <xsl:when test="$partLayout='BASIC'">
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

<!--                    <xsl:apply-templates select="*[not(contains(@class, ' topic/topic '))]"/>-->

            <xsl:for-each select="*[contains(@class,' topic/topic ')]">
                <xsl:variable name="topicType">
                    <xsl:call-template name="determineTopicType"/>
                </xsl:variable>
                <xsl:if test="$topicType = 'topicSimple'">
                    <xsl:apply-templates select="."/>
                </xsl:if>
            </xsl:for-each>
        </fo:block>
        <xsl:for-each select="*[contains(@class,' topic/topic ')]">
            <xsl:variable name="topicType">
                <xsl:call-template name="determineTopicType"/>
            </xsl:variable>
            <xsl:if test="not($topicType = 'topicSimple')">
                <xsl:apply-templates select="."/>
            </xsl:if>
        </xsl:for-each>
  </xsl:template>

  <xsl:template name="processTopicNotices">
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
            <xsl:with-param name="type" select="'notices'"/>
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
          <xsl:when test="$noticesLayout='BASIC'">
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
  
  <xsl:template match="*" mode="processUnknowTopic">
    <!-- NOTE: this is an override from commons_1.0.xsl -->
    <xsl:param name="topicType"/>
    <xsl:choose>
        <xsl:when test="$topicType = 'topicTocList'">
            <xsl:call-template name="processTocList"/>
        </xsl:when>
        <xsl:when test="$topicType = 'topicIndexList'">
            <xsl:call-template name="processIndexList"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="processTopic"/>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--=================================================
      Generic functions specific to the PDF processing
      ================================================= -->
  
  <xsl:function name="dita-ot:getTopicrefForTopic" as="element()?">
    <xsl:param name="topicElem" as="element()"/>
    
    <xsl:variable name="topicrefId" as="xs:string"
      select="string($topicElem/@id)" 
    />
<!--    <xsl:message>+ [DEBUG] dita-ot:getTopicrefForTopic(): topicrefId="<xsl:sequence select="$topicrefId"/></xsl:message>-->
    
    <xsl:variable name="topicref" as="element()?"
      select="key('topicRefsById', $topicrefId, root($mergedDoc))"
    />
<!--    <xsl:message>+ [DEBUG] dita-ot:getTopicrefForTopic(): topicref="<xsl:sequence select="name($topicref)"/></xsl:message>-->
    <xsl:sequence select="$topicref"/>
  </xsl:function>

</xsl:stylesheet>
