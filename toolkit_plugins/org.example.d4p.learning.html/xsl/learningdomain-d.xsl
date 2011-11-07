<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.imsglobal.org/xsd/imscp_v1p1" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:lommd="http://ltsc.ieee.org/xsd/LOM" 
  xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3" 
  xmlns:imsss="http://www.imsglobal.org/xsd/imsss" 
  xmlns:adlseq="http://www.adlnet.org/xsd/adlseq_v1p3" 
  xmlns:adlnav="http://www.adlnet.org/xsd/adlnav_v1p3" 
>

<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
/>

<!-- learning metadata domain: 
lcLom  or lcMapLom( lomStructure  | lomCoverage | lomAggregationLevel | lomTechRequirement| lomInstallationRemarks | 
lomOtherPlatformRequirements | lomInteractivityType | lomLearningResourceType | lomInteractivityLevel |
lomSemanticDensity | lomIntendedUserRole | lomContext | lomTypicalAgeRange |    | lomDifficulty |
lomTypicalLearningTime )
-->
<xsl:template match="*[contains(@class,' learning-d/lcLom ')]" name="topic.learning-d.lcLom">
<metadata>
 <lommd:lom>
   <xsl:apply-templates/>
 </lommd:lom>
</metadata>
</xsl:template>

<xsl:template match="*[contains(@class,' learningmap-d/lcMapLom ')]" mode="lcLom">
<metadata>
 <lommd:lom>
   <xsl:apply-templates mode="lcLom"/>
 </lommd:lom>
</metadata>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomStructure ')]" name="topic.learning-d.lomStructure"  mode="lcLom">
   <lommd:general><lommd:structure><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:structure></lommd:general>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomCoverage ')]" name="topic.learning-d.lomCoverage" mode="lcLom">
   <lommd:general><lommd:coverage><lommd:string language="en">
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:coverage></lommd:general>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomAggregationLevel ')]" name="topic.learning-d.lomAggregationLevel" mode="lcLom">
   <lommd:general><lommd:aggregationLevel><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:aggregationLevel></lommd:general>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomTechRequirement ')]" name="topic.learning-d.lomTechRequirement" mode="lcLom">
   <lommd:technical><lommd:requirement><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:requirement></lommd:technical>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomInstallationRemarks ')]" name="topic.learning-d.lomInstallationRemarks" mode="lcLom">
   <lommd:technical><lommd:installationRemarks><lommd:string language="en">
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:installationRemarks></lommd:technical>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/')]" name="topic.learning-d.lomOtherPlatformRequirements" mode="lcLom">
   <lommd:technical><lommd:OtherPlatformRequirements><lommd:string language="en">
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:OtherPlatformRequirements></lommd:technical>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomInteractivityType ')]" name="topic.learning-d.lomInteractivityType" mode="lcLom">
   <lommd:educational><lommd:InteractivityType><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:InteractivityType></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomLearningResourceType ')]" name="topic.learning-d.lomLearningResourceType" mode="lcLom">
   <lommd:educational><lommd:LearningResourceType><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:LearningResourceType></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomInteractivityLevel ')]" name="topic.learning-d.lomInteractivityLevel" mode="lcLom">
   <lommd:educational><lommd:InteractivityLevel><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:InteractivityLevel></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomSemanticDensity ')]" name="topic.learning-d.lomSemanticDensity" mode="lcLom">
   <lommd:educational><lommd:SemanticDensity><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:SemanticDensity></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomIntendedUserRole ')]" name="topic.learning-d.lomIntendedUserRole" mode="lcLom">
   <lommd:educational><lommd:IntendedUserRole><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:IntendedUserRole></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomContext ')]" name="topic.learning-d.lomContext" mode="lcLom">
   <lommd:educational><lommd:Context><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:Context></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomTypicalAgeRange ')]" name="topic.learning-d.lomTypicalAgeRange" mode="lcLom">
   <lommd:educational><lommd:TypicalAgeRange><lommd:string language="en">
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:TypicalAgeRange></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomDifficulty ')]" name="topic.learning-d.lomDifficulty" mode="lcLom">
   <lommd:educational><lommd:Difficulty><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:Difficulty></lommd:educational>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomTypicalLearningTime ')]" name="topic.learning-d.lomTypicalLearningTime" mode="lcLom">
   <lommd:educational><lommd:TypicalLearningTime><lommd:string language="en">
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:TypicalLearningTime></lommd:educational>
</xsl:template>

<xsl:template match="text()" mode="lcLom"/>

</xsl:stylesheet>
