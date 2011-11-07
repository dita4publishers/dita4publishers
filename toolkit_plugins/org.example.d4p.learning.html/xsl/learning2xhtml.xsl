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
<!--  FILE:      learning2xhtml.xsl                                -->
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

<xsl:import href="learning-d.xsl"></xsl:import>
<xsl:strip-space elements="*"/>

<!-- XHTML output with XML syntax -->
<xsl:output method="xml"
            encoding="utf-8"
            indent="yes"
            doctype-public=""
            doctype-system=""
/>
<!-- == REFERENCE UNIQUE SUBSTRUCTURES == -->

<xsl:template name="place-fig-lbl">
       <xsl:apply-templates select="./*[contains(@class,' topic/title ')]" mode="figtitle"/>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]" mode="figtitle">
 <h3><xsl:apply-templates/></h3>
</xsl:template>

<!-- == Does not output nested titles == -->

<!--
<xsl:template match="*[contains(@class,' learningContent/learningContent ')]/*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
</xsl:template> -->


<!-- == A quickie for lcTime, to get the text content to display == -->
<xsl:template match="*[contains(@class,' learningBase/lcTime ')]">
<p><xsl:apply-templates /></p>
</xsl:template>

<!-- == A quickie for lcTime, to get the text content to display == -->
<xsl:template match="*[contains(@class,' learningBase/lcTime ')]">
<p><xsl:apply-templates /></p>
</xsl:template>

<!-- == for learningAssessment topics, handle lcInteractions == -->
<xsl:template match="*[contains(@class,' learningBase/lcInteraction ')]">
<xsl:for-each select="*[contains(@class,' learning-d/lcTrueFalse ')]
     | *[contains(@class,' learning-d/lcSingleSelect ')]
     | *[contains(@class,' learning-d/lcMultipleSelect ')]
     | *[contains(@class,' learning-d/lcOpenQuestion ')]">
<!--
     | *[contains(@class,' learning-d/lcHotspot ')]
     | *[contains(@class,' learning-d/lcSequencing ')]
     | *[contains(@class,' learning-d/lcMatching ')]
-->

<h3>Question <xsl:value-of select="position()"/>. 
<xsl:apply-templates select="*[contains(@class,' topic/title ')]"/></h3>
  <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
</xsl:for-each>
</xsl:template>




</xsl:stylesheet>
