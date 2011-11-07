<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA learning and training content 
     specialization working design. It is a work-in-progress by
     the OASIS DITA learning and training content specialization 
     sub-committee.-->
<!--             (C) Copyright OASIS Open 2007.                    -->
<!--             All Rights Reserved.                              -->
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  FILE:      learningAssessment2xhtml.xsl                                -->
<!--  VERSION:   0.1                                               -->
<!--  DATE:      June 2007                                         -->
<!--                                                               -->
<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Specialized processing for learning topic types   -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             June 2007                                         -->
<!--                                                               -->
<!--  UPDATES:                                                     -->
<!-- ============================================================= -->
<!-- 
     This file is used to override the DITA to XHTML transform. It
     overrides the generic fig element in order to remove the generated 
     Figure title text.
     All other elements fall back to normal topic processing. 
-->

<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- XHTML output with XML syntax -->
<xsl:output method="xml"
            encoding="utf-8"
            indent="yes"
            doctype-public=""
            doctype-system=""
            cdata-section-elements="q_text answer"
/>
<xsl:param name="OUTDIR" select="''"/>
<xsl:param name="RELTHING" select="''"/>


<!-- == REFERENCE UNIQUE SUBSTRUCTURES == -->

<xsl:template match="*[contains(@class,' learningAssessment/learningAssessment ')]">
<xsl:variable name="assess-title">
    <xsl:choose>
      <xsl:when test="*[contains(@class,' topic/title ')]">
        <xsl:value-of select="*[contains(@class,' topic/title ')]"/>
      </xsl:when>
      <xsl:when test="@title">
        <xsl:value-of select="@title"/>
      </xsl:when>
      <xsl:otherwise>
        no title found
      </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<quiz_with_banks>
  <quiz_properties randomize_answers="t" randomize_quesitons="t"/>
  <quiz_title><xsl:value-of select="$assess-title"/></quiz_title>
    <quiz_description>
      <xsl:choose>
      <xsl:when test="*[contains(@class,' topic/shortdesc ')]">
        <xsl:value-of select="*[contains(@class,' topic/shortdesc ')]"/>
      </xsl:when>
      <xsl:otherwise>No description available</xsl:otherwise>
      </xsl:choose>
    </quiz_description>
  <xsl:variable name="numquestions" 
   select="count(//*[contains(@class,' learning-d/lcTrueFalse ')] |
     //*[contains(@class,' learning-d/lcSingleSelect ')] |
     //*[contains(@class,' learning-d/lcMultipleSelect ')])"/>
  <question_bank randomize_questions="t">
    <xsl:attribute name="draw_size">
      <xsl:value-of select="$numquestions"/>
    </xsl:attribute>
    <title>
    <xsl:choose>
      <xsl:when test="*[contains(@class,' topic/title ')]">
        <xsl:value-of select="*[contains(@class,' topic/title ')]"/>
      </xsl:when>
      <xsl:when test="@title">
        <xsl:value-of select="@title"/>
      </xsl:when>
      <xsl:otherwise>
        no title found
      </xsl:otherwise>
    </xsl:choose>
    </title>
    <xsl:for-each select="//*[contains(@class,' learning-d/lcTrueFalse ')] |
     //*[contains(@class,' learning-d/lcSingleSelect ')] |
     //*[contains(@class,' learning-d/lcMultipleSelect ')]">
     <question_id><xsl:value-of select="generate-id()"/></question_id>
    </xsl:for-each>
  </question_bank>
  <questionpool>
    <xsl:for-each select="//*[contains(@class,' learning-d/lcTrueFalse ')] |
     //*[contains(@class,' learning-d/lcSingleSelect ')]">
     <question type="multiple_choice">
       <xsl:attribute name="qid"><xsl:value-of select="generate-id()"/></xsl:attribute>
       <q_text><xsl:apply-templates select="*[contains(@class,' learning-d/lcQuestion ')]/text()"/></q_text>
     <xsl:for-each select="*[contains(@class,' learning-d/lcAnswerOptionGroup ')]/*[contains(@class,' learning-d/lcAnswerOption ')]">
      <answer>
        <xsl:if test="*[contains(@class,' learning-d/lcCorrectResponse ')]">
         <xsl:attribute name="correct">t</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="*[contains(@class,' learning-d/lcAnswerContent ')]"/>
      </answer>
     </xsl:for-each>
     </question>
    </xsl:for-each>
  </questionpool>
  <objective local_id="{generate-id()}">
    <title><xsl:value-of select="$assess-title"/></title>
    <xsl:for-each select="//*[contains(@class,' learning-d/lcTrueFalse ')] |
     //*[contains(@class,' learning-d/lcSingleSelect ')]">
      <covered_by_question><xsl:value-of select="generate-id()"/></covered_by_question>
    </xsl:for-each>
    <passing_threshold>.7</passing_threshold>
  </objective>

</quiz_with_banks>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcAnswerContent ')]">
<xsl:apply-templates select="text() | 
   *[contains(@class,' topic/image ')]"/>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/image ')]"><xsl:text>&lt;img src='</xsl:text>
  <xsl:value-of select="@href"/><xsl:text>' /></xsl:text>
</xsl:template>

</xsl:stylesheet>
