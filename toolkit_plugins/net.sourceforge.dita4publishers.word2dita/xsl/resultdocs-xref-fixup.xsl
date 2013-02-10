<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="urn:local-functions"
  xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
  xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  
  exclude-result-prefixes="xs rsiwp stylemap local relpath xsi"
  version="2.0">
  
  <!--==========================================
      Word to DITA Transform: Result Docs XRef Fixup Mode
      
      Copyright (c) 2013, DITA For Publishers
      
      ========================================== -->
  
  <!-- We only care about finding non-topic, non-topicref elements with IDs that match the word location. --> 
  <xsl:key name="elementsByWordlocation" match="*[not(@isTopicref) and not(@isMap) and @id]" use="@xtrc"/>
        
  <xsl:template mode="resultdocs-xref-fixup" match="*">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>        
  
  <xsl:template mode="resultdocs-xref-fixup" 
    match="@* | 
           text() | 
           processing-instruction() | 
           comment()"
    >
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="@isTopic | @isTopicref | @isMap" mode="resultdocs-xref-fixup"/><!-- Filter out -->
  
  <xsl:template mode="resultdocs-xref-fixup" 
    match="@href[starts-with(., 'urn:wordlocation:')]" 
    priority="10">
    <xsl:variable name="refDoc" 
      as="element()"
      select="ancestor::rsiwp:result-document[1]" 
    />
    <xsl:variable name="wordLocation" as="xs:string" select="substring-after(., 'urn:wordlocation:')"/>
    <!-- There may be multiple elements with the same word location. Assume that the first one
         is the one we want. -->
    <xsl:variable name="target" select="key('elementsByWordlocation', $wordLocation, root(.))[1]"/>
    <xsl:choose>
      <xsl:when test="$target">
        <!-- Construct the fragment identifier and, if appropriate, the resource
             part of the URL.
             
             There will always be a fragment identifier to at least the target topic or,
             if the target is a non-topic element, to the topic and the element.
             
             There should only be a resource part if the target is in a different
             document from the reference.
             
             In some cases the target located by the word location may not have an ID.
             In that case, omit it from the fragment identifier.
          -->
        <xsl:variable name="fragmentIdentifier" as="xs:string">
          <xsl:choose>
            <xsl:when test="$target[@isTopic]">
              <xsl:sequence select="concat('#', string($target/@id))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="containingTopic" as="element()"
                select="$target/ancestor::*[@isTopic][1]"
              />
              <xsl:variable name="elementId" select="$target/@id" as="xs:string?"/>
              <xsl:sequence select="concat('#',$containingTopic/@id, 
                if ($elementId) 
                   then concat('/', $elementId) 
                   else '')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="targetDoc" 
          as="element()"
          select="$target/ancestor::rsiwp:result-document[1]" 
        />
        <xsl:variable name="resourcePart" as="xs:string">
          <xsl:choose>
            <xsl:when test="$targetDoc = $refDoc">
              <!-- Target is in same document as reference, only generate the fragment ID -->
              <xsl:sequence select="''"/>
            </xsl:when>
            <xsl:otherwise>              
              <xsl:sequence select="
                relpath:getRelativePath(
                  relpath:getParent($refDoc/@href),
                  $targetDoc/@href)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="newHref" as="xs:string"      
          >
          <xsl:sequence select="concat($resourcePart, $fragmentIdentifier)"/>
        </xsl:variable>
        <xsl:attribute name="href" select="$newHref"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> - [WARN] resultdocs-xref-fixup: Could not find element for word location "<xsl:sequence select="$wordLocation"/>"</xsl:message>
        <xsl:attribute name="href" select="concat('urn:error:Unresolvable reference to ', $wordLocation)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
        
</xsl:stylesheet>