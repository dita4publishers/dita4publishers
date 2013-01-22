<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  
  exclude-result-prefixes="xs df"
  >
  <!-- variables domain elements to HTML -->

  
  <xsl:template 
    match="*[df:class(., 'd4p-variables-d/d4p-variableref_text')] |
           *[df:class(., 'd4p-variables-d/d4p-variableref_keyword')]
    " priority="10">
    <xsl:param name="topicref" select="." as="element()?" tunnel="yes"/>
    <xsl:message> + [DEBUg] d4p-variableref: varname="<xsl:value-of select="normalize-space(.)"/>"</xsl:message>
<!--    <xsl:message> + [DEBUG] d4p-variableref: topicref=
      
      <xsl:sequence select="$topicref"/>
      
    </xsl:message>
-->    
    <xsl:if test="not($topicref)">
      <xsl:message> - [WARN] d4p-variables-domain: No $topicref parameter in context <xsl:sequence select="concat(name(..), '/', name(.))"/>.</xsl:message>
    </xsl:if>
    
    <xsl:variable name="variableName" select="normalize-space(.)" as="xs:string"/>
    <xsl:variable name="parentTopic" select="ancestor::*[df:class(., 'topic/topic')][1]" as="element()?"/>
    <xsl:variable name="prolog" select="$parentTopic/*[df:class(., 'topic/prolog')]" as="element()?"/>
    <!-- Resolution rules:
      
      1. Nearest definition that is a direct
         child of any ancestor element or in the prolog of an ancestor topic in the
         same XML document. First declaration among siblings in document order wins.
      2. Nearest definition in topicref tree ancestry.
      3. First definition in root map metadata.
      
      -->
    <xsl:variable name="localVardefs" as="element()*"
      select="
      ancestor::*/*[df:class(., 'd4p-variables-d/d4p-variable-definitions')]//*[df:class(., 'd4p-variables-d/d4p-variable-definition')][@name = $variableName] |
      ancestor::*[df:class(., 'topic/topic')]/*[df:class(., 'topic/prolog')]//*[df:class(., 'd4p-variables-d/d4p-variable-definition')][@name = $variableName]"
    />
    <xsl:message> + [DEBUG] $localVardefs=
      <xsl:sequence select="$localVardefs"/>
    </xsl:message>
    <!-- Get the nearest (last) member of this list -->
    <xsl:variable name="localVarDef" as="element()?"
      select="$localVardefs[last()]"
    />
    <xsl:variable name="varDef" as="element()?">
      <xsl:choose>
        <xsl:when test="count($localVarDef) = 0 and count($topicref) > 0">
          <!-- If we get here then it means the variable was not defined by the topicref
               or the topic, so look up the map hierarchy until you find a definition:
          -->
          <xsl:variable name="metadataAncestry" as="element()*"
            select="reverse($topicref/ancestor::*[df:class(., 'map/topicref') or df:class(., 'map/map')]/*[df:class(., 'map/topicmeta')])"
          />
          <xsl:variable name="variableDefs" as="element()*"
            select="
            for $metadata in $metadataAncestry
              return ($metadata//*[df:class(., 'd4p-variables-d/d4p-variable-definition')][@name = $variableName])[1]            
            "
          />
          <xsl:sequence 
            select="$variableDefs[1]"/>
        </xsl:when>        
        <xsl:otherwise>
          <xsl:sequence select="$localVarDef"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="count($varDef) = 1">
        <span class="{if (@outputclass != '') then @outputclass else 'd4p-variableref'}"
        >
          <xsl:choose>
            <xsl:when test="$varDef/@value">
              <xsl:sequence select="string($varDef/@value)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$varDef/node()"/>
            </xsl:otherwise>
          </xsl:choose>          
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [WARN] In topic "<xsl:sequence select="df:getNavtitleForTopic($parentTopic)"/>" [<xsl:sequence select="string($parentTopic/@id)"/>] <xsl:sequence select="name(.)"/>: No definition found for variable "<xsl:sequence select="$variableName"/>"</xsl:message>
        <!-- Apply default processing for this element -->
        <span class="d4p-unresolved-variable"><xsl:next-match/></span>        
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
</xsl:stylesheet>
