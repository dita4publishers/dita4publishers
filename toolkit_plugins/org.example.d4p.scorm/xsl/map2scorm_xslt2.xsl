<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.imsglobal.org/xsd/imscp_v1p1" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:lommd="http://ltsc.ieee.org/xsd/LOM" 
  xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3" 
  xmlns:imsss="http://www.imsglobal.org/xsd/imsss" 
  xmlns:adlseq="http://www.adlnet.org/xsd/adlseq_v1p3" 
  xmlns:adlnav="http://www.adlnet.org/xsd/adlnav_v1p3" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="urn:local-functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs local relpath"
  >

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
<xsl:output indent="yes" method="xml" 
 omit-xml-declaration="no"
 encoding="utf-8" 
/>

<xsl:param name="WORKDIR" select="''"/>
<xsl:param name="OUTEXT" select="'.html'"/>
<xsl:param name="DBG" select="no"/>
<xsl:param name="DITAEXT" select="'.dita'"/>
  
<xsl:variable name="work.dir">
  <xsl:choose>
    <xsl:when test="$WORKDIR and not($WORKDIR='')">
      <xsl:choose>
        <xsl:when test="not(substring($WORKDIR,string-length($WORKDIR))='/')and not(substring($WORKDIR,string-length($WORKDIR))='\')">
          <xsl:value-of select="translate($WORKDIR,
            '\/=+|?[]{}()!#$%^&amp;*__~`;:.,-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
            '//=+|?[]{}()!#$%^&amp;*__~`;:.,-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:text>/</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate($WORKDIR,
            '\/=+|?[]{}()!#$%^&amp;*__~`;:.,-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
            '//=+|?[]{}()!#$%^&amp;*__~`;:.,-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>  
</xsl:variable>


<!-- Define a newline character -->
<xsl:variable name="newline"><xsl:text>&#xA;</xsl:text></xsl:variable>

<!-- Define root variable -->
<xsl:template match="/">
  <xsl:message> + [DEBUG] map2scorm_xslt2: Processing root element...</xsl:message>
  <xsl:apply-templates/>
  <xsl:message> + [DEBUG] map2scorm_xslt2: Done.</xsl:message>
</xsl:template>

<xsl:template name="image-href-path">
<!-- To do: get proper paths for images - these are all relative to the topic file -->
<!-- Examples: -->        
<!-- (topicref) href="sece/sece_01_ov_overview_1.html" -->
<!-- (image) href="images/ov/ov1.swf" -->
<xsl:param name="topicref-href" as="xs:string"/>
<xsl:param name="image-href" />
<xsl:choose>
<xsl:when test="contains($topicref-href,'\')">
  <xsl:variable name="topicref-start-path" select="concat(substring-before($topicref-href,'\'),'/')" />
  <xsl:variable name="new-topicref-href" select="substring-after($topicref-href,'\')" />
  <xsl:variable name="new-image-href" select="concat($topicref-start-path,$image-href)" />
  <xsl:call-template name="image-href-path">
    <xsl:with-param name="topicref-href" select="$new-topicref-href"/>
    <xsl:with-param name="image-href" select="$new-image-href"/>
  </xsl:call-template>  
</xsl:when>
<xsl:otherwise>
  <file href="{$image-href}"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
  
<xsl:template match="*[contains(@class,' map/map ')]">
<xsl:variable name="map-title" select="@title"/>
<manifest xmlns="http://www.imsglobal.org/xsd/imscp_v1p1" 
  xmlns:lom="http://ltsc.ieee.org/xsd/LOM" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_v1p3" 
  xmlns:imsss="http://www.imsglobal.org/xsd/imsss" 
  xmlns:adlnav="http://www.adlnet.org/xsd/adlnav_v1p3" 
  identifier="manifest-id" 
  xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd 
  http://ltsc.ieee.org/xsd/LOM lom.xsd 
  http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd 
  http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd 
  http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd" 
  version="0.0">
  <metadata>
    <schema>ADL SCORM</schema>
    <schemaversion>2004 3rd Edition</schemaversion>
  </metadata>
  <organizations default="Course">
    <organization identifier="Course" structure="hierarchical">
         <title>
           <xsl:call-template name="getNavtitle"/>
         </title>
      <xsl:apply-templates mode="items"/>
     <imsss:sequencing>
       <imsss:controlMode 
         useCurrentAttemptProgressInfo="true" 
         useCurrentAttemptObjectiveInfo="true" 
         forwardOnly="false" 
         flow="true" 
         choiceExit="true" 
         choice="true"/>
     </imsss:sequencing>
   </organization>
  </organizations>
  <resources>
    <xsl:apply-templates mode="resources"/>
  </resources>
</manifest>
</xsl:template>

<!-- learningGroup items ======================================================================================================== -->
  <xsl:template match="*[contains(@class,' learningmap-d/learningGroup ')]" mode="items">
    <item isvisible="true">
      <xsl:attribute name="identifier" select="generate-id()"/>
      <title>
        <xsl:call-template name="getNavtitle"/>
      </title>
      <xsl:if test="@href and not(@href='')">
        <item>
          <xsl:attribute name="identifier" select="concat('grouphref_',generate-id())"/>
          <xsl:attribute name="identifierref" select="concat('res_',generate-id())"/>
          <title>
            <xsl:call-template name="getNavtitle"/>
          </title>
          <imsss:sequencing>
            <imsss:controlMode 
              useCurrentAttemptProgressInfo="true" 
              useCurrentAttemptObjectiveInfo="true" 
              forwardOnly="false" 
              flow="true" 
              choiceExit="true" 
              choice="true"/>
          </imsss:sequencing>
        </item>
      </xsl:if>
      <xsl:apply-templates mode="items"/>
      <!-- lcMapLom and lcLom metadata -->
      <xsl:apply-templates select="*[contains(@class,' learningmap-d/lcMapLom ')]" mode="lcLom"/>
      <imsss:sequencing>
        <imsss:controlMode 
          useCurrentAttemptProgressInfo="true" 
          useCurrentAttemptObjectiveInfo="true" 
          forwardOnly="false" 
          flow="true" 
          choiceExit="true" 
          choice="true"/>
      </imsss:sequencing>
    </item>
  </xsl:template>
  
  <!-- learningGroup resources ======================================================================================================== -->
  
  
  <xsl:template 
    match="*[contains(@class,' learningmap-d/learningGroup ')] | 
           *[contains(@class,' learningmap-d/learningObject ')] |
           *[contains(@class,' learningmap-d/learningPreAssessmentRef ')] | 
           *[contains(@class,' learningmap-d/learningOverviewRef ')] | 
           *[contains(@class,' learningmap-d/learningContentRef ')] | 
           *[contains(@class,' learningmap-d/learningPostAssessmentRef ')] | 
           *[contains(@class,' learningmap-d/learningSummaryRef ')]" 
    mode="resources">
    <xsl:if test="@href and not(@href='')">
      <xsl:variable name="effectiveUrl" select="local:getEffectiveResourceUrl(.)"/>
      <resource type="webcontent" adlcp:scormType="sco">
        <xsl:attribute name="identifier" select="concat('res_',generate-id())"/>
        <xsl:attribute name="href" select="$effectiveUrl"/>
        
        <file href="{$effectiveUrl}"/>
        
        <!-- get image and object references from topic files -->

        <xsl:message> + [DEBUG] resources mode: $effectiveUrl="<xsl:sequence select="$effectiveUrl"/>"</xsl:message>
        <xsl:variable name="topic-doc" select="document($effectiveUrl, .)"/>
        <xsl:variable name="the-filename" select="local:getFilename($effectiveUrl)" as="xs:string"/>
        <xsl:variable name="href-path" select="relpath:getParent($effectiveUrl)" as="xs:string"/>
        
<!--        <xsl:message> + [DEBUG] resources mode: topic-doc=<xsl:sequence select="$topic-doc"/></xsl:message>
-->        <xsl:for-each select="$topic-doc//*[contains(@class,' topic/image ')]">
          <xsl:message> + [DEBUG] resources mode: Got an image: <xsl:sequence select="string(@href)"/></xsl:message>
          <file href="{concat($href-path,@href)}"/>
        </xsl:for-each>
        <xsl:for-each select="$topic-doc//*[contains(@class,' topic/object ')]">
          <file href="{concat($href-path,@data)}"/>
        </xsl:for-each>

      <!-- standard set of files contained in this package -->
      <!-- would want to include these via a parameter or variable setting -->
      <file href="commonltr.css" />
      <file href="util/APIWrapper.js" />
      </resource>
    </xsl:if>
  <xsl:apply-templates mode="resources"/>
  </xsl:template>
  
  
  <!-- learningObject items ======================================================================================================== -->
  <xsl:template match="*[contains(@class,' learningmap-d/learningObject ')]" mode="items">
    <xsl:variable name="title" as="node()*">
      <xsl:call-template name="getNavtitle"/>      
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="count($title) > 0">
        <item isvisible="true">
          <xsl:attribute name="identifier" select="concat('lo_',generate-id())"/>
          <title>
            <xsl:call-template name="getNavtitle"/>
          </title>
          <xsl:if test="@href">
            <item>
              <xsl:attribute name="identifier" select="concat('lohref_',generate-id())"/>
              <xsl:attribute name="identifierref" select="concat('res_',generate-id())"/>
              <title>
              </title>
              <!-- lcMapLom and lcLom metadata -->
              <xsl:apply-templates select="*[contains(@class,' learningmap-d/lcMapLom ')]" mode="lcLom"/>
              <imsss:sequencing>
                <imsss:controlMode useCurrentAttemptProgressInfo="true" useCurrentAttemptObjectiveInfo="true" forwardOnly="false" flow="true" choiceExit="true" choice="true"/>
              </imsss:sequencing>
            </item>
          </xsl:if>
          <xsl:apply-templates mode="items"/>
          <imsss:sequencing>
            <imsss:controlMode 
              useCurrentAttemptProgressInfo="true" 
              useCurrentAttemptObjectiveInfo="true" 
              forwardOnly="false" 
              flow="true" 
              choiceExit="true" 
              choice="true"/>
          </imsss:sequencing>
        </item>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="items"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- other learningRef items ======================================================================================================== -->
  <xsl:template match="*[contains(@class,' learningmap-d/learningPreAssessmentRef ')]
    | *[contains(@class,' learningmap-d/learningOverviewRef ')]
    | *[contains(@class,' learningmap-d/learningContentRef ')]
    | *[contains(@class,' learningmap-d/learningSummaryRef ')]
    | *[contains(@class,' learningmap-d/learningPostAssessmentRef ')]" 
    mode="items">
    <item isvisible="true">
      <xsl:attribute name="identifier" select="generate-id()"/>
      <xsl:attribute name="identifierref" select="concat('res_',generate-id())"/>
      <title>
        <xsl:call-template name="getNavtitle"/>
      </title>
      <!-- lcMapLom and lcLom metadata -->
      <xsl:apply-templates select="*[contains(@class,' learningmap-d/lcMapLom ')]" mode="lcLom"/>
      <imsss:sequencing>
        <imsss:controlMode 
          choice="true" 
          choiceExit="true" 
          flow="true" 
          forwardOnly="false" 
          useCurrentAttemptObjectiveInfo="true" 
          useCurrentAttemptProgressInfo="true" />
      </imsss:sequencing>
    </item>
  </xsl:template>
  
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>Gets the navigation title for a topicref, if there is one.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template name="getNavtitle">
    <xsl:choose>
      <xsl:when test="*[contains(@class,' topic/title ')]">
        <!-- FIXME: This should really be an apply templates in a "text only" mode. -->
        <xsl:value-of select="*[contains(@class,' topic/title ')]"/>
      </xsl:when>
      <xsl:when test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
        <!-- FIXME: This should really be an apply templates in a "text only" mode. -->
        <xsl:value-of select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"/>
      </xsl:when>
      <xsl:when test="@navtitle">
        <xsl:value-of select="@navtitle"/>
      </xsl:when>
      <xsl:when test="self::*[contains(@class, ' learningmap-d/learningObject ')] and 
        ancestor::*[contains(@class, ' map/map ')]/*[contains(@class, ' topic/title ')]">
        <xsl:value-of select="ancestor::*[contains(@class, ' map/map ')]/*[contains(@class,' topic/title ')]"/>        
      </xsl:when>
      <xsl:otherwise>no title found</xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>


<xsl:template match="*[contains(@class,' map/reltable ')]"/>
<xsl:template match="*[contains(@class,' map/topicref ')]"/>
<xsl:template match="*[contains(@class,' map/topicmeta ')]"/>
  
<xsl:template match="*[contains(@class,' map/reltable ')]" mode="items"/>
<xsl:template match="*[contains(@class,' map/topicmeta ')]" mode="items"/>
<xsl:template match="*[contains(@class,' map/reltable ')]" mode="resources"/>
<xsl:template match="*[contains(@class,' map/topicmeta ')]" mode="resources"/>
<xsl:template match="*[contains(@class,' map/reltable ')]" mode="lcLom"/>
 <xsl:template match="
    *[contains(@class, ' topic/title ')]" 
    mode="resources items"/>

  <xsl:function name="local:getEffectiveResourceUrl" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:message> + [DEBUG] local:getEffectiveResourceUrl(): $work.dir="<xsl:sequence select="$work.dir"/>"</xsl:message>
    <xsl:variable name="resourceUrl">
      <xsl:choose>
        <xsl:when test="$context/@type='external' 
          or ($context/@scope='external' and not($context/@format)) 
          or not(not($context/@format) 
          or $context/@format='dita' 
          or $context/@format='DITA')">
          <xsl:value-of select="$context/@href"/>
        </xsl:when> 
        <!-- adding local JH: would this ever happen in a map? -->
        <xsl:when test="starts-with($context/@href,'#')">
          <xsl:value-of select="$context/@href"/></xsl:when>
        <xsl:when test="contains($context/@copy-to, $DITAEXT)">
          <xsl:value-of select="$work.dir"/>
          <xsl:value-of select="substring-before($context/@copy-to, $DITAEXT)"/>
          <xsl:value-of select="$OUTEXT"/>
        </xsl:when>
        <xsl:when test="contains($context/@href, $DITAEXT)">
          <xsl:value-of select="$work.dir"/> 
          <xsl:value-of select="substring-before($context/@href, $DITAEXT)"/>
          <xsl:value-of select="$OUTEXT"/>
          <xsl:value-of select="substring-after($context/@href, $DITAEXT)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> + [WARN] Fell through to otherwise clause.</xsl:message>
          <!--
            <xsl:value-of select="$work.dir"/><xsl:value-of select="@href"/>
            <xsl:call-template name="output-message">
            <xsl:with-param name="msgnum">006</xsl:with-param>
            <xsl:with-param name="msgsev">E</xsl:with-param>
            <xsl:with-param name="msgparams">%1=<xsl:value-of select="@href"/></xsl:with-param>
            </xsl:call-template>
          -->
        </xsl:otherwise>
      </xsl:choose>        
    </xsl:variable>
    <xsl:message> + [DEBUG] local:getEffectiveResourceUrl(): resourceUrl="<xsl:sequence select="$resourceUrl"/>"</xsl:message>
    
    <xsl:variable name="effectiveUrl" 
      select="if (contains($resourceUrl, '#'))
      then substring-before($resourceUrl, '#')
      else $resourceUrl
      "/>
    <xsl:message> + [DEBUG] local:getEffectiveResourceUrl(): effectiveUrl="<xsl:sequence select="$effectiveUrl"/>"</xsl:message>
    <xsl:sequence select="$effectiveUrl"/>
  </xsl:function>
  
  <xsl:function name="local:getFilename" as="xs:string">
    <xsl:param name="url" as="xs:string"/>
    <xsl:variable name="lastBit" select="relpath:getName($url)" as="xs:string"/>
    <xsl:sequence select="
      if (contains($lastBit, '#'))
      then substring-before($lastBit, '#')
      else $lastBit
      "
    />
  </xsl:function>
  
  
</xsl:stylesheet>
