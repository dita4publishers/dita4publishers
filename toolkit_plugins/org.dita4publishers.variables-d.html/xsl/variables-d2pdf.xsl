<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs df"
  >
  <!-- variables domain elements to PDF -->

  
  <xsl:template 
    match="*[df:class(., 'd4p-variables-d/d4p-variableref_text')] |
           *[df:class(., 'd4p-variables-d/d4p-variableref_keyword')]
    " priority="10">

    <xsl:message> + [DEBUg] d4p-variableref: varname="<xsl:value-of select="normalize-space(.)"/>"</xsl:message>
    <!--    <xsl:message> + [DEBUG] d4p-variableref: topicref=
      
      <xsl:sequence select="$topicref"/>
      
    </xsl:message>
-->    
    
    <!-- Find the topicref that pointed to the the topic (or an ancestor topic) that contains
         the reference. -->
    
    <xsl:variable name="topicref" as="element()?"
      select="()"
    />
    
    <xsl:if test="not($topicref)">
      <xsl:message> - [WARN] d4p-variables-domain: No $topicref parameter in context <xsl:sequence select="concat(name(..), '/', name(.))"/>.</xsl:message>
    </xsl:if>
    
    <xsl:variable name="parentTopic" select="ancestor::*[df:class(., 'topic/topic')][1]" as="element()?"/>
    
    <xsl:variable name="variableName" select="normalize-space(.)" as="xs:string"/>
    <!-- Resolution rules:
      
      1. Nearest definition that is a direct
         child of any ancestor element or in the prolog of an ancestor topic in the
         same XML document. First declaration among siblings in document order wins.
      2. Nearest definition in topicref tree ancestry.
      3. First definition in root map metadata.
      
      -->
    <!-- Get definitions in the refernce's containing XML document: -->
    <xsl:variable name="localVardefs" as="element()*"
      select="
      ancestor::*/*[df:class(., 'd4p-variables-d/d4p-variable-definitions')]//*[df:class(., 'd4p-variables-d/d4p-variable-definition')][@name = $variableName] |
      ancestor::*[df:class(., 'topic/topic')]/*[df:class(., 'topic/prolog')]//*[df:class(., 'd4p-variables-d/d4p-variable-definition')][@name = $variableName]"
    />
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] $localVardefs=
        <xsl:sequence select="for $vardef in $localVardefs return concat('name=', $vardef/@name)"/>
      </xsl:message>
    </xsl:if>    
    <!-- Get the nearest (last) member of this list -->
    <xsl:variable name="localVarDef" as="element()?"
      select="$localVardefs[last()]"
    />
    
    <!-- Now see if we found something or if we need to go to the topicrefs and map: -->
    <xsl:variable name="varDef" as="element()?">
      <xsl:choose>
        <xsl:when test="count($localVarDef) = 0 and count($topicref) > 0">
          <!-- No local definition and we have a topicref giving us access to the
               map tree. Look up the topicref hierarchy to find the nearest definition.
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
          <!-- No map tree, so use whatever we found locally, if anything -->
          <xsl:sequence select="$localVarDef"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="count($varDef) = 1">
        <fo:inline 
          use-attribute-sets="{if (@outputclass != '') 
                                  then concat('d4p:', @outputclass) 
                                  else 'd4p:variableref'}"
          >
          <xsl:choose>
            <xsl:when test="$varDef/@value">
              <xsl:sequence select="string($varDef/@value)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$varDef/node()"/>
            </xsl:otherwise>
          </xsl:choose>          
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [WARN] In topic "<xsl:sequence select="df:getNavtitleForTopic($parentTopic)"/>" [<xsl:sequence select="string($parentTopic/@id)"/>] <xsl:sequence select="name(.)"/>: No definition found for variable "<xsl:sequence select="$variableName"/>"</xsl:message>
        <!-- See if there is a fallback definition -->
        <xsl:variable name="localFallbackDefs" as="element()*"
          select="
          ancestor::*/*[df:class(., 'd4p-variables-d/d4p-variable-definitions')]//*[df:class(., 'd4p-variables-d/d4p-variable-definition')][@name = $variableName] |
          ancestor::*[df:class(., 'topic/topic')]/*[df:class(., 'topic/prolog')]//*[df:class(., 'd4p-variables-d/d4p-variable-definition-fallback')][@name = $variableName]"
        />
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] $localFallbackDefs=
            <xsl:sequence select="for $vardef in $localFallbackDefs return concat('name=', $vardef/@name)"/>
          </xsl:message>
        </xsl:if>    
        <!-- Get the nearest (last) member of this list -->
        <xsl:variable name="localFallbackDef" as="element()?"
          select="$localFallbackDefs[last()]"
        />
        <xsl:choose>
          <xsl:when test="count($localFallbackDef) = 1">
            <xsl:message> + [WARN] Using fallback value for variable "<xsl:sequence select="$variableName"/>"</xsl:message>
            <fo:inline 
              use-attribute-sets="{if (@outputclass != '') 
                                      then concat('d4p:', @outputclass) 
                                      else 'd4p:variableref'}"
              ><xsl:apply-templates select="$localFallbackDef/node()"/></fo:inline>
          </xsl:when>
          <xsl:otherwise>
            <!-- Apply default processing for this element -->
            <fo:inline use-attribute-sets="d4p:unresolved-variable"><xsl:next-match/></fo:inline>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>    
    
    
  </xsl:template>
  
</xsl:stylesheet>
