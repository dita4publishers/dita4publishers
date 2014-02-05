<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic exsl"
    version="2.0">

    <!-- Override of base preface.xsl -->

     <xsl:template name="processTopicPreface">
                 <fo:block 
                   xsl:use-attribute-sets="
                   topic 
                   topic-first-block-frontmatterTopic
                   ">
                     <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                         <fo:marker marker-class-name="current-topic-number">
                             <xsl:number format="1"/>
                         </fo:marker>
                         <fo:marker marker-class-name="current-header">
                             <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                 <xsl:call-template name="getTitle"/>
                             </xsl:for-each>
                         </fo:marker>
                     </xsl:if>

                     <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

                     <xsl:call-template name="insertChapterFirstpageStaticContent">
                         <xsl:with-param name="type" select="'preface'"/>
                     </xsl:call-template>

                     <fo:block xsl:use-attribute-sets="topic.title">
                         <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                             <xsl:call-template name="getTitle"/>
                         </xsl:for-each>
                     </fo:block>

                     <!--<xsl:call-template name="createMiniToc"/>-->

                     <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
                 </fo:block>


    </xsl:template>

</xsl:stylesheet>