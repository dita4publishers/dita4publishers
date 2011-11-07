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
   <lommd:general>
     <xsl:apply-templates mode="lcLom-general"/>
   </lommd:general>
   <lommd:technical>
     <xsl:apply-templates mode="lcLom-technical"/>
   </lommd:technical>
   <lommd:educational>
     <xsl:apply-templates mode="lcLom-educational"/>
   </lommd:educational>
 </lommd:lom>
</metadata>
</xsl:template>


<xsl:template match="*[contains(@class,' learning-d/lomStructure ')]" name="topic.learning-d.lomStructure"  mode="lcLom-general">
   <lommd:structure><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:structure>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomCoverage ')]" name="topic.learning-d.lomCoverage" mode="lcLom-general">
   <lommd:coverage><lommd:string language="en">
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:coverage>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomAggregationLevel ')]" name="topic.learning-d.lomAggregationLevel" mode="lcLom-general">
   <lommd:aggregationLevel><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:aggregationLevel>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomTechRequirement ')]" name="topic.learning-d.lomTechRequirement" mode="lcLom-technical">
   <lommd:requirement><lommd:orComposite><lommd:name><lommd:value>
     <xsl:choose>
       <xsl:when test="@value='netscapecommunicator'">netscape communicator</xsl:when>
       <xsl:when test="@value='ms-internetexplorer'">ms-internet explorer</xsl:when>
       <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
     </xsl:choose>
   </lommd:value></lommd:name></lommd:orComposite></lommd:requirement>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomInstallationRemarks ')]" name="topic.learning-d.lomInstallationRemarks" mode="lcLom-technical">
   <lommd:installationRemarks><lommd:string>
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:installationRemarks>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomOtherPlatformRequirements')]" name="topic.learning-d.lomOtherPlatformRequirements" mode="lcLom-technical">
   <lommd:otherPlatformRequirements><lommd:string>
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:otherPlatformRequirements>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomInteractivityType ')]" name="topic.learning-d.lomInteractivityType" mode="lcLom-educational">
   <lommd:interactivityType><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:interactivityType>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomLearningResourceType ')]" name="topic.learning-d.lomLearningResourceType" mode="lcLom-educational">
   <lommd:learningResourceType><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:learningResourceType>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomInteractivityLevel ')]" name="topic.learning-d.lomInteractivityLevel" mode="lcLom-educational">
   <lommd:interactivityLevel><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:interactivityLevel>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomSemanticDensity ')]" name="topic.learning-d.lomSemanticDensity" mode="lcLom-educational">
   <lommd:semanticDensity><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:semanticDensity>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomIntendedUserRole ')]" name="topic.learning-d.lomIntendedUserRole" mode="lcLom-educational">
   <lommd:intendedEndUserRole><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:intendedEndUserRole>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomContext ')]" name="topic.learning-d.lomContext" mode="lcLom-educational">
   <lommd:context><lommd:value>
     <xsl:value-of select="@value"/>
   </lommd:value></lommd:context>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomTypicalAgeRange ')]" name="topic.learning-d.lomTypicalAgeRange" mode="lcLom-educational">
   <lommd:typicalAgeRange><lommd:string language="en">
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:typicalAgeRange>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomDifficulty ')]" name="topic.learning-d.lomDifficulty" mode="lcLom-educational">
   <lommd:difficulty><lommd:value>
     <xsl:choose>
       <xsl:when test="@value='veryeasy'">very easy</xsl:when>
       <xsl:when test="@value='verydifficult'">very difficult</xsl:when>
       <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
     </xsl:choose>
   </lommd:value></lommd:difficulty>
</xsl:template>

<xsl:template match="*[contains(@class,' learning-d/lomTypicalLearningTime ')]" name="topic.learning-d.lomTypicalLearningTime" mode="lcLom-educational">
   <lommd:typicalLearningTime><lommd:description><lommd:string>
     <xsl:value-of select="@value"/>
   </lommd:string></lommd:description></lommd:typicalLearningTime>
</xsl:template>

<xsl:template match="text()" mode="lcLom"/>
<xsl:template match="text()" mode="lcLom-general"/>
<xsl:template match="text()" mode="lcLom-educational"/>
<xsl:template match="text()" mode="lcLom-technical"/>

</xsl:stylesheet>
