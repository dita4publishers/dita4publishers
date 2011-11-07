<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
/>


<xsl:template name="replacestring">
<!-- turns ' into \', for use with the javascript alerts used for simple interactions -->
<xsl:param name="instring" />
<xsl:param name="findthis" />
<xsl:param name="replacethis" />
<xsl:choose>
<xsl:when test="contains($instring,$findthis)">
  <xsl:variable name="new-before-instring" select="concat(substring-before($instring,$findthis),$replacethis)" />
  <xsl:variable name="new-full-instring" select="concat($new-before-instring,
   substring-after($instring,$findthis))" />
  <xsl:call-template name="replacestring">
    <xsl:with-param name="instring" select="$new-full-instring"/>
    <xsl:with-param name="findthis" select="$findthis"/>
    <xsl:with-param name="replacethis" select="$replacethis"/>
  </xsl:call-template>  
</xsl:when>
<xsl:otherwise>
  <xsl:value-of select="$instring"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- == A quickie for instructor notes; s/b in a separate xsl for the domain == -->
<xsl:template match="*[contains(@class,' learning-d/lcInstructornote ')]">
  <div class="instructornote">
    <span class="tiptitle">Instructor note:</span><xsl:text> </xsl:text>
    <xsl:call-template name="revblock"/>
<!-- Need to get this working, but not now.
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'Instructor note'"/>
      </xsl:call-template>
      <xsl:call-template name="getString">
        <xsl:with-param name="stringName" select="'ColonSymbol'"/>
      </xsl:call-template>
    </span><xsl:text> </xsl:text>
    <xsl:call-template name="flagit"/>
    <xsl:call-template name="revblock"/>
-->
  </div>
</xsl:template>

<!--
<xsl:template match="*[contains(@class,' hi-d/b ')]" name="topic.hi-d.b">
  <xsl:variable name="flagrules">
    <xsl:call-template name="getrules"/>
  </xsl:variable>
 <strong>
  <xsl:call-template name="commonattributes"/>
  <xsl:call-template name="setidaname"/>
  <xsl:call-template name="flagcheck"/>
  <xsl:call-template name="revtext">
   <xsl:with-param name="flagrules" select="$flagrules"/>
  </xsl:call-template>
  </strong>
</xsl:template>
-->
<!--
<lcAnswerOption>
<lcAnswerContent>Modular architecture</lcAnswerContent>
<lcCorrectResponse/>
<lcFeedback>Good job. This is one of the correct options</lcFeedback>
</lcAnswerOption>
<li><a href="javascript: alert('Correct. Good job. This is one of the correct options');">
<p>Modular architecture</p></a>
</li>
-->

<xsl:template match="*[contains(@class,' learning-d/lcTrueFalse ')]">
<h3>Question <xsl:value-of select="position()"/>. 
<xsl:apply-templates select="*[contains(@class,' topic/title ')]"/></h3>
  <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcSingleSelect ')]">
<h3>Question <xsl:value-of select="position()"/>. 
<xsl:apply-templates select="*[contains(@class,' topic/title ')]"/></h3>
  <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcMultipleSelect ')]">
<h3>Question <xsl:value-of select="position()"/>. 
<xsl:apply-templates select="*[contains(@class,' topic/title ')]"/></h3>
  <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcOpenQuestion ')]">
<h3>
<xsl:if test="parent::*[contains(@class,' learningAssessment/lcInteraction ')]">
Question <xsl:value-of select="position()"/>. 
</xsl:if>
<xsl:apply-templates select="*[contains(@class,' topic/title ')]"/></h3>
<xsl:choose>
<xsl:when test="parent::*[contains(@class,' learningAssessment/lcInteraction ')]">
  <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
</xsl:when>
<xsl:otherwise>
<table border="1">
<tr><td>
  <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
</td></tr>
</table>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcHotSpot ')]">
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcMatching ')]">
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcSequencing ')]">
</xsl:template>


<xsl:template match="*[contains(@class,' learning-d/lcAnswerOptionGroup ')]">
<ul>
  <xsl:apply-templates/>
</ul>
</xsl:template>


<xsl:template match="*[contains(@class,' learning-d/lcAnswerOption ')]">
<xsl:variable name="isCorrectString">
<xsl:choose>
  <xsl:when test="*[contains(@class,' learning-d/lcCorrectResponse ')]">Correct.</xsl:when>
  <xsl:otherwise>Incorrect.</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="feedbackString">
  <xsl:apply-templates select="*[contains(@class,' learning-d/lcFeedback ')]"/>
</xsl:variable>
<xsl:variable name="cleanfeedbackString">
  <xsl:call-template name="replacestring">
    <xsl:with-param name="instring" select="$feedbackString"/>
    <xsl:with-param name="findthis">'</xsl:with-param>
    <xsl:with-param name="replacethis">\047</xsl:with-param>
  </xsl:call-template>  
</xsl:variable>
<li STYLE="font-size:28px" type="circle"><a href="javascript:alert('{$isCorrectString}');">
  <div STYLE="font-size:18px; font-family:sans-serif;">
  <xsl:apply-templates select="*[contains(@class,' learning-d/lcAnswerContent ')]"/>
   </div>
</a></li>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lcFeedback ')]">
  <xsl:apply-templates />
</xsl:template>


<xsl:template match="*[contains(@class,' learning-d/lcFeedbackCorrect ')]">
</xsl:template>
<xsl:template match="*[contains(@class,' learning-d/lcFeedbackIncorrect ')]">
</xsl:template>

</xsl:stylesheet>
