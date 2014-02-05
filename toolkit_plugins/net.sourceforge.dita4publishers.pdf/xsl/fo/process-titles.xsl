<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs xd"
  version="2.0">

  <!-- Templates for handling titles. 
    
       Overrides mode getTitle
       
    -->
  <xsl:template
    match="*"
    mode="getTitle">
    <xsl:param name="pubRegion" as="xs:string" tunnel="yes" select="'not-set'"/>
<!--    <xsl:message>+ [DEBUG] Mode getTitle: "*": pubRegion="<xsl:sequence select="$pubRegion"/>"</xsl:message>-->
    <xsl:choose>
      <xsl:when
        test="@spectitle">
        <xsl:variable
          name="spectitleValue"
          as="xs:string"
          select="string(@spectitle)"/>
        <xsl:variable
          name="resolvedVariable">
          <xsl:call-template
            name="insertVariable">
            <xsl:with-param
              name="theVariableID"
              select="$spectitleValue"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:sequence
          select="if (not(normalize-space($resolvedVariable))) 
          then $spectitleValue
          else $resolvedVariable"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Enumeration mode handles generating numbers for
             numbered elements, such as topics, figures,
             tables, etc.
        -->
<!--        <xsl:message>+ [DEBUG] getTitle: applying templates to <xsl:sequence select="concat(name(..), '/', name(..), '/', name(.), '[id=',string(../@id), ']' )"/> in mode enumeration...</xsl:message>-->
        <xsl:apply-templates select="."  mode="enumeration"/>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
