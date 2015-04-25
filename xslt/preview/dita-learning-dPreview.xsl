<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       Preview support for the DITA Learning and Training 
       learning domain (assessments). Handles both DITA 1.2 
       learning-d and DITA 1.3 learning2-d.
    
       =============================================================== -->
  
  <!-- Learning2 interactions are based on DITA 1.3 <div> element.
    
       Learning 1 interactions are based on <fig>
       
    -->
  
  <xsl:template match="*[df:class(., 'learningInteractionBase2-d/lcInteractionBase')]" priority="10">
    <div class="lcInteractionBase {name(.)}{if (@outputclass) then concat(' ', @outputclass) else ''}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learningInteractionBase2-d/lcInteractionLabel')]" priority="10">
    <p class="lcInteractionLabel {name(.)}{if (@outputclass) then concat(' ', @outputclass) else ''}"
      ><xsl:apply-templates
    /></p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learningInteractionBase2-d/lcQuestionBase')]" priority="10">
    <!-- Handle the case where the question is not wrapped in a paragraph -->
    <div class="lcQuestionBase {name(.)}{if (@outputclass) then concat(' ', @outputclass) else ''}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning2-d/lcAnswerOptionGroup2')]" priority="10">
    <div class="lcAnswerOptionGroup2 {name(.)}{if (@outputclass) then concat(' ', @outputclass) else ''}">
     <xsl:apply-templates/>  
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning2-d/lcAnswerOption2')]" priority="10">
    <p class="lcAnswerOption2{if (@outputclass) then concat(' ', @outputclass) else ''}
      {if (*[df:class(., 'learning-d/lcCorrectResponse')]) then ' correctResponse' else ''}
      ">
      <span class="answerOptionLabel"><xsl:number 
        count="*[df:class(., 'learning2-d/lcAnswerOption2')]" 
        format="A." 
        from="*[df:class(., 'learning2-d/lcAnswerOptionGroup2')]"/></span>
      <xsl:text>&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning2-d/lcAnswerContent2')]" priority="10">
    <!-- Normally answer content should be inline with the answer option label -->
    <span class="lcAnswerContent2{if (@outputclass) then concat(' ', @outputclass) else ''}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning2-d/lcFeedback2')]" priority="10">
    <xsl:variable name="tagname" as="xs:string"
      select="if (*[df:class(.,'topic/p')]) then 'div' else 'p'"
    />
    <div class="feedback">      
      <p class="feedback-label">Feedback:</p>
      <xsl:element name="{$tagname}">
        <xsl:attribute name="class" 
          select="concat(
          'lcFeedback2', 
          if (@outputclass) then concat(' ', @outputclass) else '')"/>
        <xsl:apply-templates/>
      </xsl:element>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
