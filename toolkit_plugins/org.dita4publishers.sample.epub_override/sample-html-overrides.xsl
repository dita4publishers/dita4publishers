<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- NOTE: This template is a copy of the same template from the base dita2xhtmlImpl.xsl
       transform.
       
    -->   
  <xsl:template match="*[contains(@class,' topic/body ')]" name="topic.body">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <div>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="setidaname"/>
      <xsl:call-template name="start-flagit">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>     
      </xsl:call-template>
      <xsl:call-template name="start-revflag">
        <xsl:with-param name="flagrules" select="$flagrules"/>  
      </xsl:call-template>
      <!-- here, you can generate a toc based on what's a child of body -->
      <!--xsl:call-template name="gen-sect-ptoc"/--><!-- Works; not always wanted, though; could add a param to enable it.-->
      
      <!-- Insert prev/next links. since they need to be scoped by who they're 'pooled' with, apply-templates in 'hierarchylink' mode to linkpools (or related-links itself) when they have children that have any of the following characteristics:
        - role=ancestor (used for breadcrumb)
        - role=next or role=previous (used for left-arrow and right-arrow before the breadcrumb)
        - importance=required AND no role, or role=sibling or role=friend or role=previous or role=cousin (to generate prerequisite links)
        - we can't just assume that links with importance=required are prerequisites, since a topic with eg role='next' might be required, while at the same time by definition not a prerequisite -->
      
      <!-- *** Override: Enable output of prolog contents into the start of the topic body -->
      <xsl:apply-templates select="preceding-sibling::*[contains(@class,' topic/prolog ')]" mode="topic-body"/>
      
      <!-- Added for DITA 1.1 "Shortdesc proposal" -->
      <!-- get the abstract para -->
      <xsl:apply-templates select="preceding-sibling::*[contains(@class,' topic/abstract ')]" mode="outofline"/>
      
      <!-- get the shortdesc para -->
      <xsl:apply-templates select="preceding-sibling::*[contains(@class,' topic/shortdesc ')]" mode="outofline"/>
      
      <!-- Insert pre-req links - after shortdesc - unless there is a prereq section about -->
      <xsl:apply-templates select="following-sibling::*[contains(@class,' topic/related-links ')]" mode="prereqs"/>
      
      <xsl:apply-templates/>
      <xsl:call-template name="end-revflag">
        <xsl:with-param name="flagrules" select="$flagrules"/>  
      </xsl:call-template>
      <xsl:call-template name="end-flagit">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param> 
      </xsl:call-template>
    </div><xsl:value-of select="$newline"/>
  </xsl:template>
  
  <xsl:template mode="topic-body" match="text()"/>
  
  <xsl:template mode="topic-body" match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="topic-body" match="*[contains(@class, ' topic/author ')]">
    <p class="{name(.)}"><xsl:apply-templates/></p>
  </xsl:template>  
</xsl:stylesheet>