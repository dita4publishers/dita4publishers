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
    
      commons.xsl/commons_1.0.xs overrides
      
      Note: Topic processing moved
      to process-toplevel-topics.xsl.
      
      ================================-->
  
    <xsl:template mode="insertFirstPageStaticContent" match="*[dita-ot-pdf:determineTopicType(.) = 'topicChapter']">
      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
          <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Chapter with number'"/>
              <xsl:with-param name="theParameters">
                  <number>
                      <xsl:variable name="id" select="string(@id)" as="xs:string"/>
                      <xsl:variable name="chapterNumber">
                          <xsl:number format="1" value="count($map//*[contains(@class, ' bookmap/chapter ')]/*[@id = $id]/preceding-sibling::*) + 1"/>
                      </xsl:variable>
                      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                          <xsl:value-of select="$chapterNumber"/>
                      </fo:block>
                  </number>
              </xsl:with-param>
          </xsl:call-template>
      </fo:block>
    </xsl:template>

    <xsl:template mode="insertFirstPageStaticContent" match="*[dita-ot-pdf:determineTopicType(.) = 'topicAppendix']">
      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
          <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Appendix with number'"/>
              <xsl:with-param name="theParameters">
                  <number>
                      <xsl:variable name="id" select="@id"/>
                      <xsl:variable name="topicAppendixes">
                          <xsl:copy-of select="$map//*[contains(@class, ' bookmap/appendix ')]"/>
                      </xsl:variable>
                      <xsl:variable name="appendixNumber">
                          <xsl:number format="A" value="count($topicAppendixes/*[@id = $id]/preceding-sibling::*) + 1"/>
                      </xsl:variable>
                      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                          <xsl:value-of select="$appendixNumber"/>
                      </fo:block>
                  </number>
              </xsl:with-param>
          </xsl:call-template>
      </fo:block>
    </xsl:template>

    <xsl:template mode="insertFirstPageStaticContent" match="*[dita-ot-pdf:determineTopicType(.) = 'topicPart']">
      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
          <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Part with number'"/>
              <xsl:with-param name="theParameters">
                  <number>
                      <xsl:variable name="id" select="@id"/>
                      <xsl:variable name="topicParts">
                          <xsl:copy-of select="$map//*[contains(@class, ' bookmap/part ')]"/>
                      </xsl:variable>
                      <xsl:variable name="partNumber">
                          <xsl:number format="I" value="count($topicParts/*[@id = $id]/preceding-sibling::*) + 1"/>
                      </xsl:variable>
                      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                          <xsl:value-of select="$partNumber"/>
                      </fo:block>
                  </number>
              </xsl:with-param>
          </xsl:call-template>
      </fo:block>
    </xsl:template>

    <xsl:template mode="insertFirstPageStaticContent" match="*[dita-ot-pdf:determineTopicType(.) = 'topicPreface']">
      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
          <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Preface title'"/>
          </xsl:call-template>
      </fo:block>
    </xsl:template>

    <xsl:template mode="insertFirstPageStaticContent" match="*[dita-ot-pdf:determineTopicType(.) = 'topicNotices']">
      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
          <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Notices title'"/>
          </xsl:call-template>
      </fo:block>
    </xsl:template>

    <xsl:template mode="insertFirstPageStaticContent" match="*" priority="0">
      <xsl:message>+ [DEBUG] mode insertFirstPageStaticContent: catch-all template: <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
      <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
      </fo:block>
    </xsl:template>

  <!--=================================================
      Generic functions specific to the PDF processing
      ================================================= -->
  
  <xsl:function name="dita-ot-pdf:getTopicrefForTopic" as="element()?">
    <xsl:param name="topicElem" as="element()"/>
    
    <xsl:variable name="topicrefId" as="xs:string"
      select="string($topicElem/@id)" 
    />
<!--    <xsl:message>+ [DEBUG] dita-ot-pdf:getTopicrefForTopic(): topicrefId="<xsl:sequence select="$topicrefId"/></xsl:message>-->
    
    <xsl:variable name="topicref" as="element()?"
      select="key('topicRefsById', $topicrefId, root($mergedDoc))"
    />
<!--    <xsl:message>+ [DEBUG] dita-ot-pdf:getTopicrefForTopic(): topicref="<xsl:sequence select="name($topicref)"/></xsl:message>-->
    <xsl:sequence select="$topicref"/>
  </xsl:function>

</xsl:stylesheet>
