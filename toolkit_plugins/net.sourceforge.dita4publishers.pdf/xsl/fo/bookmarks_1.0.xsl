<?xml version='1.0'?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:exsl="http://exslt.org/common"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:exslf="http://exslt.org/functions"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
  extension-element-prefixes="exsl"
  exclude-result-prefixes="opentopic-index opentopic exslf opentopic-func ot-placeholder"
  version="2.0">

  <!-- 
     Override of base bookmark tree generation.
     
     -->

  <xsl:template
    name="createBookmarks">
    <xsl:variable
      name="bookmarks"
      as="node()*">
      <xsl:apply-templates
        select="/"
        mode="bookmark"/>
    </xsl:variable>

    <xsl:if
      test="$bookmarks">
      <fo:bookmark-tree>
        <xsl:call-template name="createTocPageBookmarkEntry"/>
        <xsl:sequence
          select="$bookmarks"/>
        <xsl:if
          test="//opentopic-index:index.groups//opentopic-index:index.entry">
          <xsl:choose>
            <xsl:when
              test="($ditaVersion &gt;= 1.1) and $map//*[contains(@class,' bookmap/indexlist ')][@href]"/>
            <xsl:when
              test="($ditaVersion &gt;= 1.1) and ($map//*[contains(@class,' bookmap/indexlist ')]
                        				or /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))])">
              <fo:bookmark
                internal-destination="{$id.index}">
                <fo:bookmark-title>
                  <xsl:call-template
                    name="insertVariable">
                    <xsl:with-param
                    name="theVariableID"
                    select="'Index'"/>
                  </xsl:call-template>
                </fo:bookmark-title>
              </fo:bookmark>
            </xsl:when>
            <xsl:when
              test="$ditaVersion &gt;= 1.1"/>
            <xsl:otherwise>
              <fo:bookmark
                internal-destination="{$id.index}">
                <fo:bookmark-title>
                  <xsl:call-template
                    name="insertVariable">
                    <xsl:with-param
                    name="theVariableID"
                    select="'Index'"/>
                  </xsl:call-template>
                </fo:bookmark-title>
              </fo:bookmark>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </fo:bookmark-tree>
    </xsl:if>
  </xsl:template>

  <xsl:template name="createTocPageBookmarkEntry">
    <!-- Generates a bookmark list entry for the ToC
         page when there is not a literal ToC-page-creating
         element in the map.
         
         Override this template to handle map types that
         have some way of indicating where the TOC page
         should go.
      -->
    <xsl:choose>
      <xsl:when
        test="($ditaVersion &gt;= 1.1) and $map//*[contains(@class,' bookmap/toc ')]">
        <!-- Create reference to ToC where it occurs.
          
             This is a change from the base, where the TOC reference is created where it
             occurs only if it points to a literal file. 
        -->
      </xsl:when>
      <xsl:when
        test="/*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
        <!-- Generate link to the automatically-generated TOC page -->
        <fo:bookmark
          internal-destination="{$id.toc}">
          <fo:bookmark-title>
            <xsl:call-template
              name="insertVariable">
              <xsl:with-param
                name="theVariableID"
                select="'Table of Contents'"/>
            </xsl:call-template>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:when>
      <xsl:when
        test="$ditaVersion &gt;= 1.1"/>
      <xsl:otherwise>
        <fo:bookmark
          internal-destination="{$id.toc}">
          <fo:bookmark-title>
            <xsl:call-template
              name="insertVariable">
              <xsl:with-param
                name="theVariableID"
                select="'Table of Contents'"/>
            </xsl:call-template>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="ot-placeholder:toc" mode="bookmark">
      <fo:bookmark internal-destination="{$id.toc}">
        <xsl:if test="$bookmarkStyle!='EXPANDED'">
          <xsl:attribute name="starting-state">hide</xsl:attribute>
        </xsl:if>
        <fo:bookmark-title>
          <xsl:call-template name="insertVariable">
            <xsl:with-param name="theVariableID" select="'Table of Contents'"/>
          </xsl:call-template>
        </fo:bookmark-title>
        
        <xsl:apply-templates mode="bookmark"/>
      </fo:bookmark>
  </xsl:template>
  
  

</xsl:stylesheet>
