<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs local df e2s"
      version="2.0">
  
  <!-- Element-to-style mapper
    
    This module provides the base implementation for
    the "style-map" modes, which map elements in context
    to InDesign style names (paragraph, character, frame,
    object, table).
    
    Copyright (c) 2009, 2012 DITA to InDesign 
    
    NOTE: This material is intended to be donated to the RSI-sponsored
    DITA2InDesign open-source project.

<xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/incx_generation_util.xsl"/>
  -->
  
  <xsl:template match="/*[df:class(., 'topic/topic')]/*[df:class(., 'topic/title')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Topic Title 1'"/>
  </xsl:template>
  
  <xsl:template match="/*[df:class(., 'topic/topic')]/*[df:class(., 'topic/topic')]/*[df:class(., 'topic/title')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Topic Title 2'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/p')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Body Para'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/lq')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Long Quote Single Para'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/lq')]/*[df:class(., 'topic/p')]" priority="10" 
    mode="style-map-pstyle">
    <xsl:variable name="styleModifier"
      select="
      if (count(preceding-sibling::*[df:isBlock(.)]) = 0)
      then if (count(following-sibling::*) = 0)
      then ' Only'
      else ' First'
      else if (count(following-sibling::*) = 0)
      then ' Last'
      else ''
      "
      as="xs:string"
    />
    <xsl:sequence select="concat('Long Quote Para', $styleModifier)"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/shortdesc')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Short Description'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/ul')]/*[df:class(., 'topic/li')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'List Bullet'"/>
  </xsl:template>
  
  <xsl:template 
    match="*[df:class(., 'topic/ol')]/
    *[df:class(., 'topic/li')][count(preceding-sibling::*[df:class(.,'topic/li')]) = 0]"
    priority="10" 
    mode="style-map-pstyle"
    >
    <xsl:sequence select="'List Number First'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/dt')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'DL Term'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/dd')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'DL Definition'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/ol')]/*[df:class(., 'topic/li')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'List Number'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/fig')]/*[df:class(., 'topic/title')]" 
    mode="style-map-pstyle">
    <xsl:sequence select="'Figure Title'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/section')]" 
    mode="style-map-pstyle">
    <!-- FIXME: account for outputclass -->
    <xsl:sequence select="'Section Title'"/>
  </xsl:template>
    
  <xsl:template match="*" priority="-1" mode="style-map-pstyle">
    <xsl:sequence
      select="
      if (string(@outputclass) != '')
         then e2s:getPStyleForOutputClass(., string(@outputclass))
         else df:getBaseClass(.)
      "
    />
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/ph')]" 
    mode="style-map-cstyle" priority="0.75">
    <xsl:sequence select="'$ID/[No character style]'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/cite')]" 
    mode="style-map-cstyle">
    <xsl:sequence select="'italic'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/i')]" 
    mode="style-map-cstyle">
    <xsl:sequence select="'italic'"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/b')]" 
    mode="style-map-cstyle">
    <xsl:sequence select="'italic'"/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/b')]/*[df:class(., 'topic/i')] |
    *[df:class(., 'topic/i')]/*[df:class(., 'topic/b')]" 
    mode="style-map-cstyle">
    <xsl:sequence select="'bold-italic'"/>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/b')]/*[df:class(., 'topic/i')]/*[df:class(., 'topic/codeph')] |
    *[df:class(., 'topic/b')]/*[df:class(., 'topic/codeph')]/*[df:class(., 'topic/i')] |
    *[df:class(., 'topic/codeph')]/*[df:class(., 'topic/b')]/*[df:class(., 'topic/i')] |
    *[df:class(., 'topic/codeph')]/*[df:class(., 'topic/i')]/*[df:class(., 'topic/b')] |
    *[df:class(., 'topic/i')]/*[df:class(., 'topic/b')]/*[df:class(., 'topic/codeph')]
    " 
    mode="style-map-cstyle">
    <xsl:sequence select="'bold-italic-monospaced '"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/codeph')]" 
    mode="style-map-cstyle">
    <xsl:sequence select="'monospaced'"/>
  </xsl:template>
  
  <xsl:template match="*" priority="-1" mode="style-map-cstyle">
    <xsl:sequence
      select="
      if (string(@outputclass) != '')
        then e2s:getCStyleForOutputClass(., string(@outputclass))
        else df:getBaseClass(.)
      "
    />
  </xsl:template>
  
  <xsl:template match="*" priority="-1" mode="style-map-tstyle">
    <xsl:sequence
      select="
      if (string(@outputclass) != '')
      then e2s:getTStyleForOutputClass(.)
      else '[Basic Table]'
      "
    />
  </xsl:template>
  
  <xsl:function name="e2s:getPStyleForElement" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="articleType" as="xs:string"/>
    <xsl:apply-templates select="$context" mode="style-map-pstyle">
      <xsl:with-param name="articleType" as="xs:string" tunnel="yes" select="$articleType"/>
    </xsl:apply-templates>
  </xsl:function>  
  
  <xsl:function name="e2s:getCStyleForElement" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:choose>
      <xsl:when test="$context/@outputclass">
        <xsl:sequence select="e2s:getCStyleForOutputClass($context)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$context" mode="style-map-cstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  
  <xsl:function name="e2s:getTStyleForElement" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:apply-templates select="$context" mode="style-map-tstyle"/>
  </xsl:function>  
  
  <xsl:function name="e2s:getTStyleForOutputClass" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="e2s:getTStyleForOutputClass($context, string($context/@outputclass))"/>
  </xsl:function>  

  <xsl:function name="e2s:getTStyleForOutputClass" as="xs:string">
    <xsl:param name="context" as="element()"/><!-- Element that exhibits the outputclass value -->
    <xsl:param name="outputclass" as="xs:string"/><!-- The output class value. This is passed
      so this function can be used where the
      the "outputclass" is provided by means 
      other than an @outputclass attribute. -->
    <!-- Given an @outputclass value, maps it to an InDesign style.
      
      For now, this just returns the outputclass value, but this
      needs to be driven by a configuration file, ideally the
      same one used to map element types to styles.
    -->
    <xsl:sequence select="$outputclass"/>
  </xsl:function>  
  
  
  <xsl:function name="e2s:getPStyleForOutputClass" as="xs:string">
    <xsl:param name="context" as="element()"/><!-- Element that exhibits the outputclass value -->
    <xsl:param name="outputclass" as="xs:string"/><!-- The output class value. This is passed
      so this function can be used where the
      the "outputclass" is provided by means 
      other than an @outputclass attribute. -->
    <!-- Given an @outputclass value, maps it to an InDesign style.
      
      For now, this just returns the outputclass value, but this
      needs to be driven by a configuration file, ideally the
      same one used to map element types to styles.
    -->
    <xsl:sequence select="$outputclass"/>
  </xsl:function>  
  
  <xsl:function name="e2s:getCStyleForOutputClass" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="e2s:getCStyleForOutputClass($context, string($context/@outputclass))"/>
  </xsl:function>  
  
  <xsl:function name="e2s:getCStyleForOutputClass" as="xs:string">
    <xsl:param name="context" as="element()"/><!-- Element that exhibits the outputclass value -->
    <xsl:param name="outputclass" as="xs:string"/><!-- The output class value. This is passed
      so this function can be used where the
      the "outputclass" is provided by means 
      other than an @outputclass attribute. -->
    <!-- Given an @outputclass value, maps it to an InDesign style.
      
      For now, this just returns the outputclass value, but this
      needs to be driven by a configuration file, ideally the
      same one used to map element types to styles.
    -->
    <xsl:sequence select="$outputclass"/>
  </xsl:function>  
  
</xsl:stylesheet>
