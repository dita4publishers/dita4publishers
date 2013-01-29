<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  exclude-result-prefixes="xs xd df relpath mapdriven"
  version="2.0">
  <!-- ================================================
       Subject Scheme to Navigation Map
       
       Generates a navigation map that mirrors the structure
       of a subject scheme map.
       
       The resulting map can be used to produce navigable output
       from the subject scheme map, at a minimum, a table of
       contents if there are no topics bound to the subjects.
       
       The input is a DITA map that contains or is entirely 
       one or more subjects defined using the DITA 1.2
       Subject Scheme elements.
       
       Copyright (c) DITA for Publishers, 2013
       ================================================= -->
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xsl:output 
    doctype-public="-//OASIS//DTD DITA Map//EN"
    doctype-system="map.dtd"
    method="xml"
    indent="yes"
   />
  
 <xsl:template match="/">
   <!-- FIXME: Figure out how to reflect any title from the input map. -->
   <map>
     <title>Generated Subject Scheme Navigation Map</title>
     <mapref href="{document-uri(.)}" />
     <topicref>
       <topicmeta>
         <navtitle>Generated Subject Scheme Navigation Map</navtitle>
       </topicmeta>
       <xsl:apply-templates/>
     </topicref>
   </map>
 </xsl:template> 
  
  <xsl:template match="*[df:class(., 'map/map')]">
    <xsl:apply-templates  select="*[df:class(., 'map/topicref')]"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'subjectScheme/subjectdef')][@keys]">
    <!-- Use the first or only key of the subject. Not sure how or if
         to handle multiple keys. One option would be to generate one
         topicref per key.
      -->
    <xsl:variable name="key" as="xs:string?" select="tokenize(@keys, ' ')[1]"/>
    <topicref keyref="{$key}">
      <xsl:choose>
        <xsl:when test="*[df:class(., 'map/topicmeta')]">
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]" mode="copy-element">
            <xsl:with-param name="key" select="$key" as="xs:string?" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <topicmeta>
            <navtitle>Subject [<xsl:sequence select="$key"/>]</navtitle>
          </topicmeta>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[df:class(., 'map/topicref')]"/>
    </topicref>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'subjectScheme/subjectdef')][not(@keys)]">
    <!-- Subject reference, does not define it's own subject -->
    <!-- Use the first or only key of the subject. Not sure how or if
         to handle multiple keys. One option would be to generate one
         topicref per key.
      -->
    <xsl:variable name="keyref" as="xs:string?" select="@keyref"/>
    <topicref keyref="{$keyref}">
      <xsl:choose>
        <xsl:when test="*[df:class(., 'map/topicmeta')]">
          <xsl:apply-templates select="*[df:class(., 'map/topicmeta')]" mode="copy-element">
            <xsl:with-param name="key" select="$keyref" as="xs:string?" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <topicmeta>
            <navtitle>Subject reference to subject [<xsl:sequence select="$keyref"/>]</navtitle>
          </topicmeta>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*[df:class(., 'map/topicref')]"/>
    </topicref>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'subjectScheme/defaultSubject')]">
    <!-- Use the first or only key of the subject. Not sure how or if
         to handle multiple keys. One option would be to generate one
         topicref per key.
      -->
    <xsl:variable name="keyref" as="xs:string?" select="@keyref"/>
    <topicref keyref="{$keyref}">
      <topicmeta>
        <navtitle>Default: [<xsl:sequence select="$keyref"/>]</navtitle>
      </topicmeta>
    </topicref>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'subjectScheme/enumerationdef')]">
    <topicref>
      <topicmeta>
        <navtitle>
          <xsl:text>Enumeration Definition: </xsl:text>
          <xsl:apply-templates mode="enumdef-details" select="."/></navtitle>
      </topicmeta>
      <xsl:apply-templates select="*[df:class(., 'map/topicref')]"/>
    </topicref>    
  </xsl:template>
  
  <xsl:template mode="enumdef-details" match="*[df:class(., 'subjectScheme/enumerationdef')]">    
    <xsl:apply-templates select="*[df:class(., 'subjectScheme/attributedef')]" mode="#current"/>
    <xsl:choose>
      <xsl:when test="*[df:class(., 'subjectScheme/elementdef')]">
        <xsl:apply-templates select="*[df:class(., 'subjectScheme/elementdef')]" mode="#current"/>    
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> on all element types.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="enumdef-details" match="*[df:class(., 'subjectScheme/attributedef')]">
    <xsl:text>For attribute "</xsl:text>
    <xsl:sequence select="string(@name)"/>
    <xsl:text>"</xsl:text>
  </xsl:template>
  
  <xsl:template mode="enumdef-details" match="*[df:class(., 'subjectScheme/elementdef')]">
    <xsl:text> on element "</xsl:text>
    <xsl:sequence select="string(@name)"/>
    <xsl:text>"</xsl:text>
  </xsl:template>
  
  <xsl:template mode="copy-element" match="*">
    <!-- NOTE: dita-support-lib provides template for handling text() in 
         copy-element mode.
      -->
    <xsl:message> + [DEBUG] copy-element: catch-all handling element <xsl:sequence select="concat(name(..), '/', name(.))"/></xsl:message>
    <xsl:element name="{name(.)}">
      <xsl:apply-templates mode="#current" select="@*,node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="copy-element" match="*[df:class(., 'topic/navtitle')]" priority="10">
    <xsl:param name="key" as="xs:string?" tunnel="yes"/>
    <xsl:message> + [DEBUG] map/navtitle in mode copy-element.</xsl:message>

    <xsl:element name="{name(.)}">
      <xsl:text>Subject [</xsl:text><xsl:sequence select="$key"/><xsl:text>] </xsl:text>
      <xsl:apply-templates mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="copy-element" match="@class" priority="10">
    <!-- Suppress -->
  </xsl:template>
  
  <xsl:template mode="copy-element" match="@* | processing-instruction() | comment()">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref')]" priority="-1">
    <!-- Default handling for topicrefs. Just handle child topicrefs -->
    <xsl:apply-templates select="* except *[df:class(., 'map/topicmeta')]">
      <!-- Any non-subject topicref needs to reset the key tunnel parameter -->
      <xsl:with-param name="key" select="()" as="xs:string?" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  
</xsl:stylesheet>