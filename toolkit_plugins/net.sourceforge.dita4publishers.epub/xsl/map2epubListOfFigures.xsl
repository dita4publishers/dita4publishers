<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms" xmlns:local="urn:functions:local"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:enum="http://dita4publishers.org/enumerables"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms enum"
  version="2.0">
  
  <xsl:key name="elementsById" match="*[@id]" use="@id"/>
  <xsl:key name="elementsByXtrc" match="*[@xtrc]" use="@xtrc"/>
  
  <xsl:template match="/" mode="generate-list-of-figures-html-toc">
    <xsl:message> + [DEBUG] / in mode generate-list-of-figures-html-toc</xsl:message>
    <xsl:apply-templates mode="#current"/>
  </xsl:template> 
  
  <xsl:template match="*[df:class(., 'map/map')]" 
    mode="generate-list-of-figures-html-toc">
    <xsl:param name="collected-data" as="element()*" tunnel="yes"/>
    <xsl:message> + [DEBUG] map/map in mode generate-list-of-figures-html-toc</xsl:message>
    <xsl:for-each select="$collected-data/enum:enumerables//*[df:class(., 'topic/fig')][enum:title]">
      <xsl:message> + [DEBUG]  fig: origId=<xsl:sequence select="string(@origId)"/>, title="<xsl:sequence select="enum:title"/>"</xsl:message>
    </xsl:for-each>
    <xsl:apply-templates mode="#current"
      select="$collected-data/enum:enumerables//*[df:class(., 'topic/fig')][enum:title]"/>
  </xsl:template>
  
  <xsl:template mode="generate-list-of-figures-html-toc" 
                match="*[df:class(., 'topic/fig')]">
    <xsl:message> + [DEBUG] topic/fig in mode generate-list-of-figures-html-toc</xsl:message>
    <xsl:variable name="sourceUri" as="xs:string" select="@docUri"/>
    <xsl:variable name="rootTopic" select="document($sourceUri)" as="document-node()?"/>
    <xsl:variable name="targetUri"
      select="htmlutil:getTopicResultUrl($outdir, $rootTopic)" as="xs:string"/>
    <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
      as="xs:string"/>
    <xsl:message> + [DEBUG] origId="<xsl:sequence select="string(@origId)"/>"</xsl:message>
    <xsl:variable name="enumeratedElement" 
      select="key('elementsByXtrc', string(@xtrc), root($rootTopic))" 
      as="element()?"/>
    <xsl:message> + [DEBUG] enumeratedElement=<xsl:sequence select="$enumeratedElement"/></xsl:message>      
    <xsl:variable name="containingTopic" as="element()"
      select="df:getContainingTopic($enumeratedElement)"
    />
    <li class="html-toc-entry html-toc-entry_1">
      <!-- FIXME: Here we're replicating ID construction logic implemented elsewhere in the Toolkit.
           This is of course fragile. -->
      <span class="html-toc-entry-text html-toc-entry-text_1"
        ><a href="{$relativeUri}{if (@origId) 
          then concat('#', $containingTopic/@id, '__', @origId) 
          else concat('#', df:generate-dita-id($enumeratedElement))}"
          target="{$contenttarget}"
          ><xsl:apply-templates 
            select="$enumeratedElement/*[df:class(., 'topic/title')]" 
            mode="#current"/></a></span>
    </li>    
  </xsl:template>
  
  
  <xsl:template match="*" mode="generate-list-of-figures-html-toc" priority="-1">
    <xsl:message> + [DEBUG] Fallback in mode generate-list-of-figures-html-toc: <xsl:sequence select="concat(name(..), '/', @class)"/> in mode generate-list-of-figures-html-toc</xsl:message>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-list-of-figures-html-toc" match="text()"/>
  
  <xsl:template mode="generate-list-of-figures-html-toc" match="*[df:class(., 'topic/title')]">
    <xsl:message> + [DEBUG] topic/title in mode generate-list-of-figures-html-toc</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>