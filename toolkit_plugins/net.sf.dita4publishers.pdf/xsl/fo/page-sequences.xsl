<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:local="http://local/functions"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:dita-ot="http://net.sf.dita-ot"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df local"
  version="2.0">

  <!--================================
    
      Page sequence construction
      
      These templates manage the construction
      of the result FO page sequences from
      the merged map and topics.
      ================================-->

  <xsl:template name="constructNavTreePageSequences">
    <!-- Template to manage construction of the page sequences
         that reflect the navigation tree defined in the
         input map.
    -->
    <xsl:param name="frontCoverTopics"  as="element()*" select="()"/>
    <xsl:param name="backCoverTopics"  as="element()*" select="()"/>
    

    <xsl:apply-templates mode="constructNavTreePageSequences" select="/">
        <xsl:with-param name="frontCoverTopics" as="element()*" 
          select="$frontCoverTopics"
          tunnel="yes"
        />
        <xsl:with-param name="backCoverTopics" as="element()*" 
          select="$backCoverTopics"
          tunnel="yes"
        />
    </xsl:apply-templates>
  </xsl:template>
  

   <xsl:template mode="constructNavTreePageSequences" match="/">
    <xsl:param name="frontCoverTopics"  as="element()*" tunnel="yes"/>
    <xsl:param name="backCoverTopics"  as="element()*"  tunnel="yes"/>
     
    <!-- Store the original context for use later as a convenience: -->
    <xsl:variable name="mergedDoc" select="." as="node()"/>

     
     <!-- FIXME: Need a general way to handle book lists or automatic
          generation of the book lists when not specified.
       -->
    
    <!-- Get a flat list of all the top-level topics or topicrefs: -->
    <xsl:variable name="topLevelTopicsOrRefs" as="element()*">
      <xsl:apply-templates mode="getTopLevelTopicsOrRefs" select="/*/opentopic:map/*[contains(@class, ' map/topicref ')]"/>
    </xsl:variable>
     
    <xsl:if test="false()">
      <xsl:message>+ [DEBUG] constructNavTreePageSequences: topLevelTopicsOrRefs=<xsl:sequence 
        select="for $e in $topLevelTopicsOrRefs return concat(name($e), ' [id=', $e/@id, ']')"/></xsl:message>
    </xsl:if>
     
    <!-- Construct an XML structure that maps each topic or topicref to its semantic topic
         type. This map is then used to assign topics and topicrefs to specific page sequences. 
       -->
    <xsl:variable name="topicToTypeMap" as="element()*">
      <xsl:apply-templates mode="mapTopicsToType"
        select="$topLevelTopicsOrRefs except $frontCoverTopics | $backCoverTopics" 
      />
    </xsl:variable>
     
    <!-- Now we know what the topic type is for each top-level topic or topicref. 
      
         The challenge now is to group the topics into the major regions of the document:
         
         - frontmatter  - everything between the cover and the first body topic)
         - body         - The main content topics
         - appendixes   - Appendix chapters
         - backmatter   - Everything between body/appendixes and the back cover (if any)
         
         Usually the frontmatter has to be at least one page sequence in order to get
         lowercase roman page numbers.
         
         The body must be at least one page sequence to get arabic page numbers, but may
         be more page sequences, especially if folio-by-chapter numbering is used.
         
         The appendixes will need a different page sequence if they are numbered differently
         or if they have different page geometry.
         
         The backmatter sections usually require distinct page sequences because they will
         have different page designs (e.g., glossary vs. index vs. bibliography).
         
         In general, page breaks should be created using break-before on the initial blocks 
         generated from topics, not by creating new page sequences. However, some FO engines
         may benefit from having shorted page sequences (e.g., FOP), so it's not necessarily
         wrong to have each top-level topic or generated section start a new page sequence,
         but it's not a requirement either.
         
         We use a function, getPublicationRegion(), to return the publication region name
         and then use group-adjacent to construct new page sequences for each region. The
         getPublicationRegion() function uses the getPublicationRegion mode to map topics and
         topicrefs to their region. You can implement templates in that mode to determine
         how specific topics or topicrefs map to page sequences.
         
    -->
     
     <xsl:for-each-group select="$topicToTypeMap" group-adjacent="local:getPublicationRegion($mergedDoc, .)">
       <xsl:variable name="pubRegion" select="local:getPublicationRegion($mergedDoc, .)"/>
       <xsl:variable name="pageSequenceGenerator">
          <dita-ot:pageSequence pubRegion="{$pubRegion}">
           <xsl:for-each select="current-group()">
             <xsl:variable name="topicRefId" select="@topicId" as="xs:string"/>
             <xsl:variable name="topic" as="element()?"
               select="key('topicsById', $topicRefId, $mergedDoc)[1]"
             />
             <xsl:sequence select="$topic"/>
           </xsl:for-each>
         </dita-ot:pageSequence>
       </xsl:variable>       
       <xsl:apply-templates mode="constructPageSequence" select="$pageSequenceGenerator"/>       
     </xsl:for-each-group>    
   </xsl:template>
  
  <!-- ====================================
       Page sequence construction templates
       
       Because of the use of attribute sets and the fact that
       fo:page-sequence isn't that complicated, it's
       easiest to just repeat the literal page sequence
       construction rather than trying to parameterize
       it through a generic page sequence construction
       template.
       
       Implement templates in the mode constructPageSequence
       to implement custom pub region values or to
       otherwise customize how page sequences are constructed.
       ==================================== -->

  <xsl:template mode="constructPageSequence" match="dita-ot:pageSequence[@pubRegion = 'frontmatter']" priority="10">
    <fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="__force__page__count">
      <fo:flow flow-name="xsl-region-body">
        <xsl:apply-templates/><!-- Process the topics in normal mode. -->
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
  <!-- NOTE: the match is redundant but want to make it clear that the default pubRegion is body -->
  <xsl:template mode="constructPageSequence" match="dita-ot:pageSequence[@pubRegion = 'body'] | *">
    <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
      <fo:flow flow-name="xsl-region-body">
        <xsl:call-template name="startPageNumbering"/>
        <xsl:call-template name="insertBodyStaticContents"/>
        <xsl:for-each select="*">
          <xsl:call-template name="processTopLevelTopic"/>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
  <!-- ==========================================
       Topic type determining templates.
       
       ========================================== -->
  
  <xsl:template name="determineTopicType">
    <xsl:apply-templates mode="determineTopicType"/>
  </xsl:template>
  
  <xsl:template mode="mapTopicsToType" match="*[df:class(., 'topic/topic')]">
    <xsl:variable name="topicType">
      <!-- This template uses the mode determineTopicType to get the
           topic type for the topic. Implement templates in this mode
           to map topics to specific topic types.
        -->
      <xsl:call-template name="determineTopicType"/>
    </xsl:variable>
    <dita-ot:topicToTypeMapItem 
      topicType="{normalize-space($topicType)}" 
      topicId="{string(@id)}"
    />
  </xsl:template>
  
  <xsl:template match="*" mode="determineTopicType">
    <!-- This is an override of the same template in
          commons.xsl
    -->
    <xsl:variable name="topicrefType" as="xs:string?" select="@topicref-type"/>

    <xsl:variable name="result" as="xs:string"
      select="
    if ($topicrefType != '')
       then concat('topic', upper-case(substring($topicrefType, 1,1)), substring($topicrefType, 2))
       else 'topicSimple'
      "/>
    <xsl:sequence select="$result"/>
  </xsl:template>

  <xsl:template mode="constructNavTreePageSequences" match="*[df:class(., 'topic/topic')]">
    <xsl:apply-templates select="."/><!-- Apply normal mode processing -->
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="*[df:isTopicRef(.)]">
    <!-- Do list generation here -->
  </xsl:template>
  
  <!-- Bookmap list-generating topicrefs -->
  <xsl:template mode="getTopLevelTopicsOrRefs" 
    match="*[contains(@class, ' bookmap/toc ')] |
           *[contains(@class, ' bookmap/figurelist ')] |
           *[contains(@class, ' bookmap/tablelist ')] |
           *[contains(@class, ' bookmap/glossarylist ')] |
           *[contains(@class, ' bookmap/bibliolist ')] |
           *[contains(@class, ' bookmap/indexlist ')]
    " 
    priority="10">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template mode="getTopLevelTopicsOrRefs" match="*[df:isTopicGroup(.)]" priority="5">
    <xsl:apply-templates mode="#current" select="*[contains(@class, ' map/topicref ')]"/>
  </xsl:template>

  <xsl:template mode="getTopLevelTopicsOrRefs" match="*[df:isTopicRef(.)]">
    <xsl:variable name="topic" as="element()?"
      select="key('topicsById', string(@id))[1]"
    />
    <xsl:sequence select="$topic"/>
  </xsl:template>
  
  <!-- =========================================================
       Get Publication Region templates
       ========================================================= -->
  
  <xsl:template mode="getPublicationRegion" 
    match="*[ancestor::*[df:class(., 'bookmap/frontmatter')]]" 
    priority="10">
    <xsl:sequence select="'frontmatter'"/>
  </xsl:template>
  
  <xsl:template mode="getPublicationRegion" 
    match="*[ancestor::*[df:class(., 'bookmap/backmatter')]]" 
    priority="10">
    <xsl:sequence select="'backmatter'"/>
  </xsl:template>
  
  <xsl:template mode="getPublicationRegion" 
    match="*[ancestor::*[df:class(., 'bookmap/appendices')]] |
    *[df:class(., 'bookmap/appendix')]" 
    priority="10">
    <xsl:sequence select="'appendices'"/>
  </xsl:template>
  
  <xsl:template mode="getPublicationRegion" match="*">
    <xsl:sequence select="'body'"/>
  </xsl:template>
  
  <!-- =========================================================
       Local functions
       ========================================================= -->
  
  <xsl:function name="local:getPublicationRegion" as="xs:string">
    <xsl:param name="mergedDoc" as="node()"/>
    <xsl:param name="topicToTypeMapItem" as="element()"/>

    <xsl:variable name="elemToProcess" as="element()"
      select="(key('topicRefsById', $topicToTypeMapItem/@topicId, $mergedDoc), 
               key('topicsById', $topicToTypeMapItem/@topicId, $mergedDoc))[1]"
    />
    <xsl:variable name="result" as="xs:string">
      <xsl:apply-templates select="$elemToProcess" mode="getPublicationRegion"/>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
</xsl:stylesheet>
