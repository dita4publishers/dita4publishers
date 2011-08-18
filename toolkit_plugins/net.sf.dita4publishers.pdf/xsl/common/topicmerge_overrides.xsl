<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
  Sourceforge.net. See the accompanying license.txt file for 
  applicable licenses.-->
<!-- (c) Copyright IBM Corporation 2011 All Rights Reserved. -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0"
  xmlns:exsl="http://exslt.org/common"
  xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
  extension-element-prefixes="exsl">

  <!-- Overrides to the topicmerge process to correct various problems.
  
-->

  <xsl:template
    match="*[contains(@class,' map/topicref ')]"
    mode="build-tree">
    <xsl:choose>
      <xsl:when
        test="not(normalize-space(@href) = '')">
        <xsl:apply-templates
          select="key('topic',@href)">
          <xsl:with-param
            name="parentId"
            select="generate-id()"/>
					<xsl:with-param name="topicrefType" select="name(.)"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when
        test="(normalize-space(@href) = '')" >
        <!-- WEK: Treat topic groups the same as topic heads -->
        <!-- NOTE: This reworks the original isNotTopicRef named
             template to use a separate mode. Topicrefs that are *not*
             topicrefs should return the value 'false', otherwise
             topicrefs are assumed to be topicrefs.
        -->
        <xsl:variable
          name="isTopicRef">
          <xsl:apply-templates
            select="."
            mode="isTopicRef"
          />          
        </xsl:variable>
        <xsl:if
          test="not(contains($isTopicRef,'false'))">
          <!-- WEK: Capture the topicref type on the generated topic is it's available
                    for later use in determining topic semantic type.
          -->
          <topic
            id="{generate-id()}"
            class="- topic/topic "
            >
            <!-- If topicref is specialized then capture it's type, otherwise don't bother
                 because it cannot impose any useful semantics on the topic type.
              -->
            <xsl:if test="name(.) != 'topicref' and name(.) != 'topichead' and name(.) != 'topicgroup'">
              <xsl:attribute name="topicref-type" select="name(.)"/>
            </xsl:if>
            <title
              class=" topic/title ">
              <xsl:choose>
                <xsl:when
                  test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                  <xsl:sequence
                    select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]/node()"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of
                    select="@navtitle"/>
                </xsl:otherwise>
              </xsl:choose>
            </title>
            <body
              class=" topic/body "/>
            <xsl:apply-templates
              mode="build-tree"/>
          </topic>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates
          mode="build-tree"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/topic ')] | dita-merge/dita">

      <xsl:param name="parentId"/>
      <xsl:param name="topicrefType"/>
    
      <xsl:variable name="idcount">
        <!--for-each is used to change context.  There's only one entry with a key of $parentId-->
        <xsl:for-each select="key('topicref',$parentId)">
          <xsl:value-of select="count(preceding::*[@href = current()/@href][not(ancestor::*[contains(@class, ' map/reltable ')])]) + count(ancestor::*[@href = current()/@href])"/>
        </xsl:for-each>
      </xsl:variable>
        <xsl:copy>
          <xsl:apply-templates select="@* except @id"/>
          <xsl:if test="$topicrefType != ''">
            <xsl:attribute name="topicref-type" select="$topicrefType"/>
          </xsl:if>
          <xsl:variable name="new_id">
              <xsl:choose>
                  <xsl:when test="number($idcount) &gt; 0">
                      <xsl:value-of select="concat(@id,'_ssol',$idcount)"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of select="@id"/>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:variable>
          <xsl:attribute name="id">
            <xsl:value-of select="$new_id"/>
          </xsl:attribute>
          <xsl:apply-templates>
              <xsl:with-param name="newid" select="$new_id"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="key('topicref',$parentId)/*" mode="build-tree"/>
        </xsl:copy>
    </xsl:template>

  <xsl:template mode="isTopicRef" priority="10"
    match="
  			*[contains(@class,' bookmap/abbrevlist ')] |
  			*[contains(@class,' bookmap/amendments ')] |			
  			*[contains(@class,' bookmap/bookabstract ')] |
  			*[contains(@class,' bookmap/booklist ')] |        
  			*[contains(@class,' bookmap/colophon ')] |
  			*[contains(@class,' bookmap/dedication ')] |
         *[contains(@class,' bookmap/figurelist ')] |
  			*[contains(@class,' bookmap/tablelist ')] |
  			*[contains(@class,' bookmap/trademarklist ')]
        "
    >
    <xsl:sequence select="'false'"/>
  </xsl:template>
  
  <xsl:template mode="isTopicRef" match="* | text()"/>
  
</xsl:stylesheet>
