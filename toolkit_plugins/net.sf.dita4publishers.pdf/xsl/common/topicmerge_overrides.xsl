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
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when
        test="(normalize-space(@href) = '')" >
        <!-- WEK: Treat topic groups the same as topic heads -->
        <!-- WEK: FIXME: this is bogus, should be using template
                  matches to distinguish topicrefs semantically.
          -->
        <xsl:variable
          name="isNotTopicRef">
          <xsl:call-template
            name="isNotTopicRef">
            <xsl:with-param
              name="class"
              select="@class"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if
          test="contains($isNotTopicRef,'false')">
          <!-- WEK: Capture the topicref type on the generated topic is it's available
                    for later use in determining topic semantic type.
            -->
          <topic
            id="{generate-id()}"
            class="- topic/topic "
            topicref-type="{name(.)}"
            >
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

</xsl:stylesheet>
