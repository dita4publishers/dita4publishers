<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:mv="urn:schemas-microsoft-com:mac:vml"
      xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
      xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
      xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
      xmlns:v="urn:schemas-microsoft-com:vml"
      xmlns:w10="urn:schemas-microsoft-com:office:word"
      xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
      xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
      xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
      xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
      xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
      xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
      xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart"
      
      xmlns:local="urn:local-functions"
      
      xmlns:saxon="http://saxon.sf.net/"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      
      exclude-result-prefixes="a c pic xs mv mo ve o r m v w10 w wne wp local relpath saxon"
      version="2.0">
  
  <!--==========================================
      MS Office 2007 Office Open XML to generic
      XML transform.
      
      Copyright (c) 2009, 2014 DITA For Publishers
      
      This transform is a generic transform that produces a simplified
      form of generic XML from Office Open XML.
      
      The input to this transform is the document.xml file within a DOCX
      package.
      
      Originally developed by Really Strategies, Inc.
      
      =========================================== -->
<!-- 
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
 -->
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>The absolute URL of the directory that contains the media objects extracted
      from the DOCX package. The presumption is that some process has copied the media/
      directory from the DOCX package to an appropriate location relative to where
      the DITA XML will be generated.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:key name="formats" match="stylemap:output" use="@name"/>
  <xsl:key name="styleMapsById" match="stylemap:style" use="@styleId"/>
  <xsl:key name="styleMapsByName" match="stylemap:style" use="lower-case(@styleName)"/>
  <xsl:key name="stylesById" match="w:style" use="@w:styleId"/>
  
  <xsl:variable name="styleMapDoc" as="document-node()"
    select="document($styleMapUri)"
  />
  
  <xsl:variable name="imageRelType" select="'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image'"
    as="xs:string"
  />
 
  <xsl:variable name="font2UnicodeMapsCollectionUri" as="xs:string"
      select="concat('font2unicodeMaps', '?', 
          'recurse=yes;',
          'select=*.xml'
          )" 
  />
 <!-- Unfortunately, the RSuite CMS system doesn't currently set the collection
      URI resolver and so attempts to resolve URIs relative to plugin-provided
      XSLTs will fail. See RSuite issue RCS-1802.
      
      Until that bug is fixed, will have to hard-code the set of available
      symbol maps.
      
   -->
<!--  <xsl:variable name="font2UnicodeMaps" as="document-node()*"
    select="collection(iri-to-uri($font2UnicodeMapsCollectionUri))"
  />
--> 
  <xsl:variable name="font2UnicodeMaps" as="document-node()*">
    <xsl:sequence select="document('font2unicodeMaps/font2UnicodeMapSymbol.xml')"/>  
    <xsl:sequence select="document('font2unicodeMaps/font2UnicodeMapWingdings.xml')"/>  
  </xsl:variable>
  
  <xsl:template match="/" name="processDocumentXml">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="stylesDoc" as="document-node()" tunnel="yes"/>

    <xsl:message> + [INFO] wordml2simple: Processing DOCX document.xml file to generate intermediate simpleML XML...</xsl:message>
    <xsl:message> + [INFO] styleMap=<xsl:sequence select="document-uri($styleMapDoc)"/></xsl:message>
    <xsl:message> + [INFO] Found <xsl:value-of select="count($font2UnicodeMaps)"/> font-to-Unicode maps</xsl:message>
    <xsl:if test="count($font2UnicodeMaps) > 0">
      <xsl:for-each select="$font2UnicodeMaps">
        <xsl:sort select="relpath:getName(document-uri(.))"/>
        <xsl:message> + [INFO]   - <xsl:value-of select="relpath:getName(document-uri(.))"/></xsl:message>
      </xsl:for-each>      
    </xsl:if>
    <xsl:if test="not(/w:document)">
      <xsl:message terminate="yes"> - [ERROR] Input document must be a w:document document.</xsl:message>
    </xsl:if>
    
    <xsl:variable name="relsDoc" as="document-node()?"
      select="document('../word/_rels/document.xml.rels', .)"
    />
    
    <document
      sourceDoc="{document-uri(.)}"
      >
      <xsl:apply-templates>
        <xsl:with-param name="relsDoc" select="$relsDoc" tunnel="yes" as="document-node()?"/>
      </xsl:apply-templates>
    </document>
    <xsl:message> + [INFO] wordml2simple: Intermediate simpleML document generated.</xsl:message>
  </xsl:template>
  
  <xsl:template match="w:document">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:body">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <body>
      <xsl:apply-templates/>
    </body>
  </xsl:template>
  
  <xsl:template match="w:p">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="mapUnstyledParasTo" select="'Normal'" tunnel="yes"/>
    <xsl:param name="stylesDoc" as="document-node()" tunnel="yes"/>
    
    <xsl:variable name="specifiedStyleId" as="xs:string"
      select="string(./w:pPr/w:pStyle/@w:val)"
    />
    
    <xsl:variable name="styleId"
      as="xs:string"
      select="
      local:getParaStyleId(., $mapUnstyledParasTo)
      "
    />

    <xsl:variable name="styleName" as="xs:string"
      select="local:lookupStyleName(., $stylesDoc, $styleId)"
    />
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] w:p: styleName="<xsl:sequence select="$styleName"/>"</xsl:message>
    </xsl:if>
    <!-- Mapping by name takes precedence over mapping by ID -->
    <xsl:variable name="styleMapByName" as="element()?"
      select="key('styleMapsByName', lower-case($styleName), $styleMapDoc)[1]"
    />
    <xsl:variable name="styleMapById" as="element()?"
      select="key('styleMapsById', $styleId, $styleMapDoc)[1]"
    />
    <xsl:variable name="styleMap" as="element()?"
      select="($styleMapByName, $styleMapById)[1]"
    />
    
    <xsl:variable name="styleData" as="element()">
      <xsl:choose>
        <xsl:when test="$styleMap">          
          <xsl:sequence select="$styleMap"/>
        </xsl:when>
        <xsl:when test="not($styleMap) and $specifiedStyleId = '' and normalize-space(.) = ''">
          <!-- Don't report unstyled and completely empty paragraphs. They will be 
          filtered out in later processing phases. -->
          <stylemap:style styleId="copy"
            structureType="block"
            tagName="p"
            topicZone="body"
          />          
        </xsl:when>
        <xsl:when test="$styleName = 'MTDisplayEquation'">
          <!-- This is MathML content that will be converted
               to MathML markup and put within a <mathml>
               element (specialization of <foreign>, new in 
               DITA 1.3). Default mapping is to wrap it in
               <equation-block> (also new in DITA 1.3).
            -->
          <stylemap:style styleId="MTDisplayEquation"
            structureType="block"
            tagName="equation-block"
            topicZone="body"
          />          
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$specifiedStyleId = ''">
              <xsl:variable name="contentString" as="xs:string"
                select="if (string-length(normalize-space(.)) > 60)
                then concat(substring(normalize-space(.),1, 60), '...')
                else normalize-space(.)
                "
              />
              <xsl:if test="$warnOnUnstyledParasBoolean">
                <xsl:message> - [WARNING: Unstyled non-empty paragraph with content "<xsl:sequence select="$contentString"/>"</xsl:message>              
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message> - [WARNING: No style mapping for paragraph with style "<xsl:sequence select="$styleName"/>" [<xsl:sequence select="$styleId"/>]</xsl:message>
            </xsl:otherwise>
          </xsl:choose>
          <stylemap:style styleId="copy"
            structureType="block"
            tagName="p"
            topicZone="body"
          />          
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] match on w:p: structureType = "<xsl:sequence select="string($styleData/@structureType)"/>"</xsl:message>
    </xsl:if>
<xsl:choose>    
  <xsl:when test="string($styleData/@structureType) = 'skip'">
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] skipping paragraph with @structureType "<xsl:value-of select="$styleData/@structureType"/>"</xsl:message>
    </xsl:if>
  </xsl:when><!-- Skip it -->
  <xsl:when test=".//w:drawing//c:chart">
    <xsl:choose>
      <xsl:when test="$chartsAsTablesBoolean">
        <xsl:apply-templates select=".//w:drawing"/><!-- Put chart tables at same level as paragraphs -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [INFO] chartsAsTables is false, ignoring <xsl:value-of select="string-join(.//w:drawing/*/wp:docPr/@name, ', ')"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
      <xsl:if test="$doDebug">
        <xsl:message> + [DEBUG] match on w:p: Paragraph not skipped, calling handlePara. p=<xsl:sequence select="substring(string(./w:r[1]), 0, 40)"/></xsl:message>
      </xsl:if>
      <xsl:call-template name="handlePara">
        <xsl:with-param name="styleId" select="$styleName" as="xs:string"/>
        <xsl:with-param name="styleData" select="$styleData" as="element()"/>
      </xsl:call-template>  
    </xsl:otherwise>
</xsl:choose>  
</xsl:template>
  
  <xsl:template name="handlePara">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="styleId" as="xs:string"/>
    <xsl:param name="styleData" as="element()"/>
    <p style="{$styleId}" wordLocation="{saxon:path()}">
      <xsl:for-each select="$styleData/@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:if test="not($styleData/@topicZone)">
        <xsl:attribute name="topicZone" select="'body'"/>
      </xsl:if>
      <xsl:if test="$doDebug">        
        <xsl:message> + [DEBUG] handlePara: p="<xsl:sequence select="substring(normalize-space(.), 1, 40)"/>"</xsl:message>
      </xsl:if>
      <!-- FIXME: This code is not doing anything specific with smartTag elements, just
                  processing their children. Doing something intelligent with smartTags
                  would require additional logic.
                  
                  WEK: Not sure why I've used this for-each-group logic, but I think it's because Word
                  doesn't require the elements specific to a given kind of thing to occur in sequence.
                  
                  But it seems like it ought to be possible to handle these elements using normal
                  apply-templates.
        -->
      <xsl:for-each-group 
        select="*" 
        group-adjacent="name(.)">
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] handlePara: current-group()[1]=<xsl:sequence select="current-group()[1]"/></xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="current-group()[1][self::w:r/w:endnoteReference]">
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] handlePara: handling w:r/w:endnoteReference</xsl:message>
            </xsl:if>
            <xsl:call-template name="handleEndNoteRef">
                <xsl:with-param name="runSequence" select="current-group()"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="current-group()[1][self::w:r[w:footnoteReference]]">
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] handlePara: handling w:r/w:footnoteReference</xsl:message>
            </xsl:if>
            <xsl:call-template name="handleFootNoteRef">
                <xsl:with-param name="runSequence" select="current-group()"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="current-group()[1][self::w:r]">
            <xsl:for-each-group select="current-group()" group-adjacent="local:getRunStyleId(.)">
              <xsl:call-template name="handleRunSequence">
                <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
                <xsl:with-param name="runSequence" select="current-group()"/>
              </xsl:call-template>
            </xsl:for-each-group>            
          </xsl:when>
          <xsl:when test="current-group()[1][self::w:smartTag]">
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] handlePara: *** got a w:smartTag. current-group=<xsl:sequence select="current-group()"/></xsl:message>
            </xsl:if>     
            <xsl:for-each select="current-group()">
              <xsl:call-template name="handleRunSequence">
                <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
                <xsl:with-param name="runSequence" select="w:r"/>
              </xsl:call-template>              
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="current-group()"/><!-- default, just handle normally -->
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:for-each-group>
    </p>
    
  </xsl:template>
  
  <xsl:template name="handleRunSequence">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="runSequence" as="element()*"/>
    <xsl:param name="stylesDoc" as="document-node()" tunnel="yes"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] handleRunSequence: runSequence=<xsl:sequence select="$runSequence"/></xsl:message>
    </xsl:if>

    <xsl:variable name="styleId" select="if ($runSequence[1]) then local:getRunStyleId($runSequence[1]) else ''" as="xs:string"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] handleRunSequence: styleId=<xsl:value-of select="$styleId"/></xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$styleId = ''">
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] handleRunSequence: No style ID, applying templates to run sequence...</xsl:message>
        </xsl:if>
        <xsl:apply-templates select="$runSequence"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] handleRunSequence: Got a style ID.</xsl:message>
        </xsl:if>
        <xsl:variable name="styleName" as="xs:string"
          select="local:lookupStyleName(., $stylesDoc, $styleId)"
        />
        <xsl:variable name="styleMapByName" as="element()?"
          select="key('styleMapsByName', lower-case($styleName), $styleMapDoc)[1]"
        />
        <xsl:variable name="styleMapById" as="element()?"
          select="key('styleMapsById', $styleId, $styleMapDoc)[1]"
        />
        <xsl:variable name="runStyleMap" as="element()?"
          select="($styleMapByName, $styleMapById)[1]"
        />
        
        <!-- 'MTConvertedEquation' is used for MathType-produced
              MathML content that is converted to MathML by a later
              process step.
          -->
        <xsl:choose>
          <xsl:when test="$styleName = 'MTConvertedEquation'">
            <stylemap:style styleId="MTConvertedEquation"
            structureType="ph"
            tagName="mathml"
          />          

          </xsl:when>
          <xsl:when test="not($runStyleMap)">
            <xsl:message> - [WARNING: No style mapping for character run with style "<xsl:sequence select="$styleName"/>" [<xsl:sequence select="$styleId"/>]</xsl:message>
          </xsl:when>
        </xsl:choose>
        <xsl:variable name="runTagName"
          as="xs:string"
          select="if ($runSequence[1][self::w:hyperlink])
          then 'hyperlink'
          else 'run'
          "
        />
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] handleRunSequence: runTagName="<xsl:value-of select="$runTagName"/>", generating result element...</xsl:message>
        </xsl:if>
        <xsl:element name="{$runTagName}">
          <xsl:attribute name="style" select="$styleId"/>
          <xsl:if test="$runStyleMap">
            <xsl:for-each select="$runStyleMap/@*">
              <xsl:copy/>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] handleRunSequence: Applying templates to run sequence...</xsl:message>
          </xsl:if>
          <xsl:apply-templates select="$runSequence">
            <xsl:with-param name="doDebug" as="xs:boolean" select="$doDebug"/>
          </xsl:apply-templates></xsl:element>
      </xsl:otherwise>
    </xsl:choose>        
    
  </xsl:template>
  
  <xsl:template name="handleFootNoteRef">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="runSequence" as="element()*"/>
    <!-- Get the footnote ID, try to find it in the footnotes.xml document,
         and generate a footnote element.
    -->
    <xsl:apply-templates select="$runSequence//w:footnoteReference"/>
  </xsl:template>
  
  <xsl:template name="handleEndNoteRef">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="runSequence" as="element()*"/>
    <!-- Get the footnote ID, try to find it in the footnotes.xml document,
         and generate a footnote element.
    -->
    <xsl:apply-templates select="$runSequence//w:endnoteReference"/>
  </xsl:template>
  
  <!-- Suppress runs that contain w:footnoteRef.
    
       These occur within footnotes and are not
       relevant to the DITA output.
    -->
  <xsl:template match="r:w[w:footnoteRef]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>    
  </xsl:template>
  
  <!-- Suppress runs that contain w:endnoteRef.
    
       These occur within endnotes and are not
       relevant to the DITA output.
    -->
  <xsl:template match="r:w[w:endnoteRef]" priority="5">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
  </xsl:template>
  
  
  <xsl:template match="w:footnoteReference">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] Handling w:footnoteReference...</xsl:message>
    </xsl:if>
    <xsl:variable name="footnotesDoc" as="document-node()?"
      select="document('footnotes.xml', .)"
    />
    <xsl:choose>
      <xsl:when test="not($footnotesDoc)">
        <xsl:message> + [WARN] Failed to find footnotes.xml file at </xsl:message>
        <fn>{Failed to find footnotes.xml file}</fn>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetId" as="xs:string"
          select="@w:id"
        />
        <fn><xsl:apply-templates
          select="$footnotesDoc/*/w:footnote[@w:id = $targetId]"
        /></fn>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="w:endnoteReference">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="endnotesDoc" as="document-node()?"
      select="document('endnotes.xml', .)"
    />
    <xsl:choose>
      <xsl:when test="not($endnotesDoc)">
        <xsl:message> + [WARN] Failed to find endnotes.xml file.</xsl:message>
        <fn>{Failed to find endnotes.xml file}</fn>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetId" as="xs:string"
          select="@w:id"
        />
        <fn><xsl:apply-templates
          select="$endnotesDoc/*/w:endnote[@w:id = $targetId]"
        /></fn>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="w:footnote | w:endnote">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates/><!-- FIXME: May need to be more selective here. -->
  </xsl:template>
  
  <xsl:template match="w:r">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates>
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="w:r[w:rPr/w:rFonts[@w:ascii]]" priority="10">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="fontFace" as="xs:string?"
      select="w:rPr/w:rFonts/@w:ascii"
    />

    <xsl:choose>
      <xsl:when test="$fontFace = ('Symbol', 'Wingdings')">
        <!-- Treat the content as for w:sym -->
        <xsl:variable name="text" as="xs:string"
          select="string(w:t)"
        />
        <xsl:for-each select="string-to-codepoints($text)">
          <xsl:variable name="codePoint" as="xs:string"
            select="local:int-to-hex(.)"
            />
          <xsl:sequence select="local:constructSymbolForCharcode(
            $codePoint, 
            $fontFace)"
          />
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$fontFace != ''">
        <xsl:if test="$doDebug">          
        <xsl:message> + [DEBUG] w:r[w:rPr/w:rFonts]: Value "<xsl:value-of select="$fontFace"/> for @w:ascii attribute.</xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [WARN] w:r[w:rPr/w:rFonts]: No value for @w:ascii on wrFonts element: <xsl:sequence select="w:rPr/w:rFonts"/></xsl:message>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:smartTag">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:bookmarkStart">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <bookmarkStart 
      name="{@w:name}" 
      id="{@w:id}"
    />
  </xsl:template>

  <xsl:template match="w:bookmarkEnd">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <bookmarkEnd 
      id="{@w:id}"
    />
  </xsl:template>
  
  
  <xsl:template match="w:hyperlink">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="relsDoc" as="document-node()?" tunnel="yes"/>
    
    <xsl:variable name="runStyle" select="local:getHyperlinkStyle(.)" as="xs:string"/>
    <xsl:variable name="styleMapByName" as="element()?"
      select="key('styleMapsByName', lower-case($runStyle), $styleMapDoc)[1]"
    />
    <xsl:variable name="styleMapById" as="element()?"
      select="key('styleMapsById', $runStyle, $styleMapDoc)[1]"
    />
    <xsl:variable name="runStyleMap" as="element()?"
      select="($styleMapByName, $styleMapById)[1]"
    />
    <xsl:variable name="runStyleData" as="element()">
      <xsl:choose>
        <xsl:when test="$runStyleMap">
          <xsl:sequence select="$runStyleMap"/>
        </xsl:when>
        <xsl:otherwise>
          <stylemap:style styleId="Hyperlink"
            structureType="xref"
            tagName="xref"
          />          
          
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>
    <xsl:variable name="rel" as="element()?"
      select="key('relsById', @r:id, $relsDoc)"
    />
    <!-- if there is to @Target, then the
         hyperlink is either to an external URI or
         to an internal bookmark
      -->
    <xsl:variable name="href" as="xs:string"
      select="
         if ($rel)
         then string($rel/@Target)
         else
          if (matches(@href, '^\w+:'))
             then @href
             else string(@w:anchor)
      "  
    />
    <hyperlink href="{$href}"
      >
      <xsl:for-each select="$runStyleData/@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:if test="$doDebug">
        <xsl:message> + [DEBUG] hyperlink: applying templates to first run...</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="w:r[1]"/>
      <xsl:if test="count(w:r) > 1">
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] hyperlink: More runs, calling handleRunSequence on grouped runs...</xsl:message>
        </xsl:if>
        <xsl:for-each-group select="w:r[position() > 1]" group-adjacent="local:getRunStyleId(.)">
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG] hyperlink: grouping key="<xsl:value-of select="current-grouping-key()"/>"</xsl:message>
          </xsl:if>
          <xsl:call-template name="handleRunSequence">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            <xsl:with-param name="runSequence" select="current-group()"/>
          </xsl:call-template>
        </xsl:for-each-group>            
      </xsl:if>
    </hyperlink>
  </xsl:template>
  
  <xsl:template match="text()">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
  </xsl:template>
  
  <xsl:template match="w:t">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- NOTE: this has to be value-of. If you use select, you get spaces
               between the w:t text values.
      -->
    <xsl:value-of select="string(.)"/>
  </xsl:template>

  <xsl:template match="w:tbl">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="styleData" as="element()">
      <stylemap:style styleId="table"
        structureType="block"
        tagName="table"
        topicZone="body"
      />                
    </xsl:variable>
    <!--  NOTE: width values are 1/20 of a point -->
    <table>
      <xsl:attribute name="frame" select="local:constructFrameValue(w:tblPr/w:tblBorders)"/>
      <xsl:attribute name="calculatedWidth" select="local:calculateTableActualWidth(w:tblGrid)"/>
      <!-- Construct rowsep and colsep values as appropriate: -->
      <xsl:apply-templates select="w:tblPr/w:tblBorders" mode="table-attributes"/>
      <xsl:for-each select="$styleData/@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates select="w:tblPr/*"/>
      <xsl:if test="w:tblGrid">
        <cols>
          <xsl:for-each select="w:tblGrid/w:gridCol">
            <xsl:variable name="widthValPoints" as="xs:string"
              select="
              if (string(number(@w:w)) = 'NaN') 
                 then @w:w 
                 else concat(format-number((number(@w:w) div 20), '######.00'), 'pt')"
            />
            <col colwidth="{$widthValPoints}"/>
          </xsl:for-each>
        </cols>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::w:tblPr)]"/>
    </table>
  </xsl:template>
  
  <xsl:template mode="table-attributes" match="w:tblBorders">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates select="w:insideH | w:insideV" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="table-attributes" match="w:insideH">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="value" as="xs:string" select="@w:val"/>
    <!-- NOTE: It looks like any value means there is a horizontal inside border,
         per the Office Open XML spec.
      -->
    <xsl:attribute name="rowsep" select="'1'"/>
  </xsl:template>
  
  <xsl:template mode="table-attributes" match="w:insideV">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="value" as="xs:string" select="@w:val"/>
    <!-- NOTE: It looks like any value means there is a vertical inside border,
         per the Office Open XML spec.
      -->
    <xsl:attribute name="colsep" select="'1'"/>
  </xsl:template>
  
  <xsl:function name="local:calculateTableCellHorizontalAlignment" as="xs:string?">
    <!-- Returns the appropriate value for the CALS @align attribute or nothing
         if the alignment is unspecified.
      -->
    <xsl:param name="tcElement" as="element(w:tc)"/>
    <xsl:variable name="jcValue" as="xs:string?"
      select="$tcElement/w:p/w:pPr/w:jc/@w:val"
     />
    <!-- See section 17.18.44 in the Office Open XML spec
         for details on the values.
      -->
    <xsl:variable name="wordJustificationValues" as="xs:string+"
      select="('left', 'center', 'right', 'both', 'end', 'distribute', 'numTab', 'start')"
    />
    <xsl:variable name="result" as="xs:string?"
      select=" if ($jcValue) 
      then ('left', 'center', 'right', 'justify', 'right', 'justify', 'char', 'left')[index-of($wordJustificationValues, $jcValue)]
      else ()"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:calculateTableCellVerticalAlignment" as="xs:string?">
    <!-- Returns the appropriate value for the CALS @valign attribute or nothing
         if the alignment is unspecified.
      -->
    <xsl:param name="tcElement" as="element(w:tc)"/>
    <xsl:variable name="valignValue" as="xs:string?"
      select="$tcElement/w:tcPr/w:vAlign/@w:val"
     />
    <!-- See section 17.18.101 ST_VerticalJc in the Office Open XML spec
         for details on the values.
      -->
    <xsl:variable name="wordJustificationValues" as="xs:string+"
      select="('bottom', 'center', 'top', 'both')"
    />
    <xsl:variable name="result" as="xs:string?"
      select="if ($valignValue)
      then ('bottom', 'middle', 'top', 'top')[index-of($wordJustificationValues, $valignValue)]
      else ()"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:calculateTableActualWidth" as="xs:string">
    <xsl:param name="tblGrid" as="element(w:tblGrid)?"/>
    <!--  NOTE: width values are 1/20 of a point -->
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="$tblGrid">
          <xsl:variable name="widthValues" 
            select="for $att in $tblGrid/w:gridCol/@w:w return number($att)"
            />
          <xsl:variable name="sum" 
            select="sum($widthValues)"
          />           
          <xsl:sequence select="string($sum div 20)"/><!-- Value in points -->          
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="'0'"/><!-- Width not calculatable -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:constructFrameValue" as="xs:string">
    <!-- Try to figure out the appropriate value for the DITA @frame
         attribute from the Word frame details.
      -->
    <xsl:param name="tblBorders" as="element(w:tblBorders)?"/>
    <xsl:variable name="result" as="xs:string">
    <xsl:choose>
      <xsl:when test="$tblBorders">
        <xsl:variable name="borderTop" as="xs:boolean" 
          select="$tblBorders/w:top/@w:val != 'nil'"/>
        <xsl:variable name="borderBottom" as="xs:boolean"
          select="$tblBorders/w:bottom/@w:val != 'nil'"/>
        <xsl:variable name="borderLeft" as="xs:boolean"
          select="$tblBorders/w:left/@w:val != 'nil'"/>
        <xsl:variable name="borderRight" as="xs:boolean"
          select="$tblBorders/w:right/@w:val != 'nil'"/>
        <xsl:choose>
          <xsl:when test="$borderTop and $borderBottom and $borderLeft and $borderRight">
            <xsl:sequence select="'all'"/>
          </xsl:when>
          <xsl:when test="$borderTop and $borderBottom and not($borderLeft and $borderRight)">
            <xsl:sequence select="'topbot'"/>
          </xsl:when>
          <xsl:when test="not($borderTop and $borderBottom) and $borderLeft and $borderRight">
            <xsl:sequence select="'sides'"/>
          </xsl:when>
          <xsl:when test="not($borderTop) and $borderBottom and not($borderLeft and $borderRight)">
            <xsl:sequence select="'bottom'"/>
          </xsl:when>
          <xsl:when test="$borderTop and not($borderBottom and $borderLeft and $borderRight)">
            <xsl:sequence select="'top'"/>
          </xsl:when>
          <xsl:when test="not($borderTop and $borderBottom and $borderLeft and $borderRight)">
            <xsl:sequence select="'none'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="'all'"/><!-- Assume all borders -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'all'"/>
      </xsl:otherwise>
    </xsl:choose>
      
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:template match="w:tr">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="tagName" as="xs:string"
      select="
      if (w:trPr/w:tblHeader) then 'thead' else 'tr'
      "
    />
    <xsl:element name="{$tagName}">
      <xsl:apply-templates select="w:trPr/*|w:tblPrEx/*"/>
      <xsl:apply-templates select="*[name()!='w:trPr' and name()!='w:tblPrEx']"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="w:tc">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- much of the code in this template comes from the OpenXMLWebViewer's DocX2Html.xslt transform:
            https://openxmlviewer.codeplex.com/
            which is licensed under the Microsoft Public License (Ms-PL)
            Major changes included only using the 50 lines or so relevant for our purposes and modifying as needed
            to interact with the rest of the word2dita transform, namely preserving paragraph and character styles
            -->
    <xsl:variable name="vmerge" select="w:tcPr[1]/w:vMerge[1]"/>
    <xsl:variable name="curCell" select="."/>
    <xsl:variable name="tblCount" select="count(ancestor::w:tbl)"/>
    <xsl:variable name="curCellInContext"
      select="ancestor::w:tr[1]/*[count($curCell|descendant-or-self::*)=count(descendant-or-self::*)]"/>
    <xsl:variable name="numCellsBefore"
      select="count($curCellInContext/preceding-sibling::*[descendant-or-self::*[name()='w:tc' and (count(ancestor::w:tbl)=$tblCount)]])"/>
    
    <xsl:variable name="horizontalAlignment" as="xs:string?"
      select="local:calculateTableCellHorizontalAlignment(.)"
    />
    <xsl:variable name="verticalAlignment" as="xs:string?"
      select="local:calculateTableCellVerticalAlignment(.)"
    />
    
    <xsl:if test="not($vmerge and not($vmerge/@w:val))">
      <td>
        <xsl:if test="$horizontalAlignment">
          <xsl:attribute name="align" select="$horizontalAlignment"/>
        </xsl:if>
        <xsl:if test="$verticalAlignment">
          <xsl:attribute name="valign" select="$verticalAlignment"/>
        </xsl:if>
        <xsl:for-each select="w:tcPr[1]/w:gridSpan[1]/@w:val">
          <xsl:attribute name="colspan">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:for-each>
        
        <xsl:variable name="rowspan">
          <xsl:choose>
            <xsl:when test="not($vmerge)">1</xsl:when>
            <xsl:otherwise>
              <xsl:variable name="myRow" select="ancestor::w:tr[1]"/>
              <xsl:variable name="myRowInContext"
                select="$myRow/ancestor::w:tbl[1]/*[count($myRow|descendant-or-self::*)=count(descendant-or-self::*)]"/>
              <xsl:variable name="belowCurCell"
                select="$myRowInContext/following-sibling::*//w:tc[count(ancestor::w:tbl)=$tblCount][$numCellsBefore + 1]"/>
              <xsl:variable name="NextRestart"
                select="($belowCurCell//w:tcPr/w:vMerge[@w:val='restart'])[1]"/>
              <xsl:variable name="NextRestartInContext"
                select="$NextRestart/ancestor::w:tbl[1]/*[count($NextRestart|descendant-or-self::*)=count(descendant-or-self::*)]"/>
              <xsl:variable name="mergesAboveMe"
                select="count($myRowInContext/preceding-sibling::*[(descendant-or-self::*[name()='w:tc'])[$numCellsBefore + 1][descendant-or-self::*[name()='w:vMerge']]])"/>
              <xsl:variable name="mergesAboveNextRestart"
                select="count($NextRestartInContext/preceding-sibling::*[(descendant-or-self::*[name()='w:tc'])[$numCellsBefore + 1][descendant-or-self::*[name()='w:vMerge']]])"/>
              
              <xsl:choose>
                <xsl:when test="$NextRestart">
                  <xsl:value-of select="$mergesAboveNextRestart - $mergesAboveMe"
                  />
                </xsl:when>
                <xsl:when test="$vmerge/@w:val">
                  <xsl:value-of
                    select="count($belowCurCell[descendant-or-self::*[name()='w:vMerge']]) + 1"
                  />
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="$vmerge">
          <xsl:attribute name="rowspan">
            <xsl:value-of select="$rowspan"/>
          </xsl:attribute>
        </xsl:if>
        <!--      <xsl:apply-templates select="w:tcPr/*"/>-->
        <xsl:apply-templates select="*[not(self::w:tcPr)]">
          <xsl:with-param name="mapUnstyledParasTo" select="'entry'" tunnel="yes"/>
        </xsl:apply-templates>
      </td>
    </xsl:if>
  </xsl:template>
    
  <xsl:template match="w:tab">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="not($filterTabsBoolean)">
      <tab/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="w:cr | w:br">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="not($filterBrBoolean)">
      <break/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="w:fldSimple">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:drawing">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- If there is a pic:blipFill then if there is an a:blip,
         chase down the relationship to get the name of
         the actual embedded grahpic.
    -->
    <!-- NOTE: the <pic:cNvPr
                      id="0"
                      name="2012-07-20 23.51.36.jpg"/> element
         may provide reliable knowledge of the original filename
         Or it may not. Not clear from the samples alone.
     -->
    <!-- See: http://en.wikipedia.org/wiki/English_Metric_Unit#DrawingML 
    
         The values in the DOCX data are "English Metric Units" which can
         be reliably converted to English or metric units.
         
         There are 360,000 EMUs/centimeter
    -->
    <xsl:variable name="xExtentStr" as="xs:string?" select=".//wp:extent/@cx"/>
    <xsl:variable name="yExtentStr" as="xs:string?" select=".//wp:extent/@cy"/>
    <xsl:variable name="xExtentEmu" as="xs:double" 
      select="if ($xExtentStr castable as xs:integer) then number($xExtentStr) else 1800000.0"/>
    <xsl:variable name="yExtentEmu" as="xs:double" 
      select="if ($yExtentStr castable as xs:integer) then number($yExtentStr) else 1800000.0"/>
    <!-- Width and height in mm -->
    <xsl:variable name="width" as="xs:string"
      select="concat(format-number($xExtentEmu div 36000, '#########.00'), 'mm')" 
    />
    <xsl:variable name="height" as="xs:string"
      select="concat(format-number($yExtentEmu div 36000, '#########.00'), 'mm')" 
    />
    <xsl:comment> &#x0a;==== drawing ===&#x0a;</xsl:comment>
    <xsl:apply-templates select=".//pic:blipFill | .//c:chart">
      <xsl:with-param name="width" select="$width" as="xs:string" tunnel="yes"/>
      <xsl:with-param name="height" select="$height" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="w:pict">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:sym">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:variable name="fontFace" as="xs:string?" 
      select="@w:font"
    />
    <xsl:choose>
      <xsl:when test="$fontFace != ''">
        <xsl:sequence select="local:constructSymbolForCharcode(
          string(@w:char), 
          $fontFace
          )"
        />
      </xsl:when>
      <xsl:otherwise>
        <rsiwp:symbol font="{$fontFace}"
          ><xsl:sequence select="string(@w:char)"/></rsiwp:symbol>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:function name="local:constructSymbolForCharcode" as="node()*">
    <xsl:param name="charCode" as="xs:string"/>
    <xsl:param name="fontFace" as="xs:string"/>
        <!-- See 17.3.3.30 sym (Symbol Character) in the Office Open XML Part 1 Doc:
      
         Characters with codes starting with "F" have had 0xF000 added to them
         to put them in the private use area.
      -->
    <xsl:variable name="nonPrivateCharCode" as="xs:string"
      select="if (starts-with($charCode, 'F')) then replace($charCode, 'F', '0') else $charCode"
    />
    <!-- getUnicodeForFont() will return the literal "?" character's code point if
         there is no mapping found for the symbol.
      -->
    <xsl:variable name="unicodeCodePoint" as="xs:string"
      select="local:getUnicodeForFont(string($fontFace), $nonPrivateCharCode)"
    />
    <xsl:variable name="codePoint" as="xs:integer"
      select="local:hex-to-char($unicodeCodePoint)"
    />
    <xsl:variable name="character" 
      select="codepoints-to-string($codePoint)" as="xs:string"/>
    <rsiwp:symbol font="{$fontFace}"
      ><xsl:sequence select="$character"/></rsiwp:symbol>

  </xsl:function>
  
  <xsl:template match="v:shape">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="pic:blipFill">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:apply-templates select=".//a:blip"/>
  </xsl:template>
  
  <xsl:template match="a:blip">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="relsDoc" tunnel="yes" as="document-node()?"/>    
    <!-- Width and height. The values should include the units indicator -->
    <xsl:param name="width" tunnel="yes" as="xs:string"/>
    <xsl:param name="height" tunnel="yes" as="xs:string"/>
    
    <xsl:variable name="imageUri" as="xs:string" 
      select="local:getImageReferenceUri($relsDoc, @r:embed, @r:link)" 
      />
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] a:blip: imageUri="<xsl:value-of select="$imageUri"/>"</xsl:message>
    </xsl:if>
    <image src="{$imageUri}" 
      width="{$width}"
      height="{$height}"
    />
  </xsl:template>
  
  <xsl:template match="v:imagedata">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="relsDoc" tunnel="yes" as="document-node()?"/>
    <!-- WEK: I can't determine from the ECMA-376 Part I doc if v:imagedata allows
         the @r:link attribute. 
    -->
    <xsl:variable name="imageUri" as="xs:string"
      select="local:getImageReferenceUri($relsDoc, @r:id, @r:link)" 
    />
    <image src="{$imageUri}"/>
  </xsl:template>
  
  <xsl:template match="c:chart">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="relsDoc" tunnel="yes" as="document-node()?"/>
    <!-- Width and height. The values should include the units indicator -->
    <xsl:param name="width" tunnel="yes" as="xs:string"/>
    <xsl:param name="height" tunnel="yes" as="xs:string"/>
    <!-- A chart. 
      
         There are various things we could do with charts. As of Dec 2013
         I haven't found any existing code that can translate a Word chart
         to SVG.
         
         The chart element points to the chart XML document, which then
         has a relationship to the Excel spreadsheet that contains
         the chart data.
         -->
    
    <xsl:variable name="rel" as="element()?"
      select="key('relsById', @r:id, $relsDoc)"
    />
    <!-- 
      In the $relsDoc, which is in the _rels/ directory: 
      
      <Relationship Id="rId8" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/chart" Target="charts/chart1.xml"/>
      
      -->
    <xsl:variable name="targetUri" as="xs:string" select="$rel/@Target"/>
    <xsl:variable name="chartDoc" as="document-node()"
      select="document($targetUri, root(.))"
    />
    <xsl:choose>
      <xsl:when test="not($chartDoc)">
        <xsl:message> - [WARN] Failed to resolve reference to chart document "<xsl:sequence select="$targetUri"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <!-- Chase down the chart data source and transform it into a table -->
        <xsl:choose>
          <xsl:when test="$chartDoc/*/c:externalData">
            <xsl:variable name="chartname" as="xs:string" 
              select="relpath:getNamePart(document-uri($chartDoc))"
            />
            <xsl:variable name="extDataId" as="xs:string" 
              select="$chartDoc/*/c:externalData/@r:id"/>
            <xsl:variable name="relsDocURI" as="xs:string"
              select="concat('../word/charts/_rels/', $chartname, '.xml.rels')"
            />
            <xsl:variable name="chartsRelsDoc" as="document-node()?"
              select="document($relsDocURI, .)"
            />
            <xsl:variable name="rel" as="element()?" 
              select="key('relsById', $extDataId, $chartsRelsDoc)"
            />
            <xsl:variable name="extDataRelativeUri" as="xs:string" 
              select="$rel/@Target"
            />
            <xsl:variable name="extDataAbsolutePath" as="xs:string"
              select="relpath:getAbsolutePath(
                         relpath:newFile(
                            relpath:getParent(document-uri($chartDoc)), 
                            $extDataRelativeUri))"
            />
            <xsl:variable name="extDataURI" as="xs:string"
              select="concat('zip:', $extDataAbsolutePath)"
            />
            <xsl:variable name="spreadsheetDocURI" as="xs:string"
              select="concat($extDataURI, '!', '/xl/worksheets/sheet1.xml')"
            />
            <xsl:variable name="spreadsheetDoc" as="document-node()?"
              select="document($spreadsheetDocURI)"
            />
            <xsl:choose>
              <xsl:when test="$spreadsheetDoc">
                <xsl:apply-templates select="$spreadsheetDoc" mode="spreadsheet-to-cals-table"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message> - [WARN] Failed to get spreadsheet document for chart element using URI "<xsl:sequence select="$spreadsheetDocURI"/>"</xsl:message>
              </xsl:otherwise>
            </xsl:choose>
            
          </xsl:when>
          <xsl:otherwise>
            <xsl:message> - [WARN] No c:externalData element for chart "<xsl:value-of select="$targetUri"/>"</xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  
    <!--==================================
      simpleWpDoc-fixup
      
      Mode for doing post-processing fixup on
      the simpleWP generated solely from
      the style-to-tag mapping.
      ================================== -->

  
  <xsl:template mode="simpleWpDoc-fixup" match="*">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-fixup" match="@* | text() | processing-instruction()">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:sequence select="."/>
  </xsl:template>
  

  <xsl:function name="local:getImageReferenceUri" as="xs:string">
    <xsl:param name="relsDoc" as="document-node()?"/>
    <xsl:param name="relId" as="xs:string"/>
    <xsl:param name="linkId" as="xs:string?"/><!-- ID of any external link to the image. -->
     
    <xsl:variable name="rel" as="element()?"
      select="key('relsById', $relId, $relsDoc)"
    />
    <xsl:variable name="linkRel" 
      select="
      if ($linkId) 
         then key('relsById', $linkId, $relsDoc) 
         else ()" 
      as="element()?"
    />
    <xsl:variable name="target"  as="xs:string"
      select="
      if ($useLinkedGraphicNamesBoolean and $linkRel) 
         then string($linkRel/@Target) 
         else string($rel/@Target)" 
    />
    <xsl:variable name="imageBasename" as="xs:string"
      select="relpath:getName($target)"
    />
    <xsl:variable name="imageFilename" as="xs:string"
      select="
      if ($imageFilenamePrefix)
         then concat($imageFilenamePrefix, $imageBasename)
         else $imageBasename"
    />

    <xsl:variable name="srcValue" as="xs:string"
      select="relpath:newFile($mediaDirUri, $imageFilename)"
    />
    <xsl:choose>
      <xsl:when test="$rel and string($rel/@Type) = $imageRelType">
        <xsl:sequence select="$srcValue"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> - [WARNING] getImageReferenceUri(): Failed to find Relationship of type Image for relationship ID "<xsl:sequence select="$relId"/>"</xsl:message>
        <xsl:sequence select="concat('unresolvedgraphic_id_', $relId)"></xsl:sequence>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:template match="w:proofErr |
                       w:pPr |
                       w:rPr |
                       w:cantSplit |
                       w:sectPr |
                       w:instrText |
                       w:softHyphen |
                       w:tblW |
                       w:tblBorders |
                       w:tblLook |
                       w:tblGrid |
                       w:tblInd |
                       w:tblStyle |
                       w:tblHeader |
                       w:trHeight |
                       w:lastRenderedPageBreak |
                       w:fldChar |
                       v:shapetype
                       "
  >
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
  </xsl:template>
  
  <xsl:function name="local:hex-to-char" as="xs:integer">
    <xsl:param name="in"/> <!-- e.g. 030C -->
    <xsl:sequence select="
      if (string-length($in) eq 1)
      then local:hex-digit-to-integer($in)
      else 16*local:hex-to-char(substring($in, 1, string-length($in)-1)) +
      local:hex-digit-to-integer(substring($in, string-length($in)))"/>
  </xsl:function>
  
  <xsl:function name="local:getUnicodeForFont" as="xs:string">
    <xsl:param name="fontName" as="xs:string"/>
    <xsl:param name="fontCodePoint" as="xs:string"/>
<!--    <xsl:message> + [DEBUG] getUnicodeForFont(): fontName="<xsl:value-of select="$fontName"/>"</xsl:message>
    <xsl:message> + [DEBUG] getUnicodeForFont(): fontCodePoint="<xsl:value-of select="$fontCodePoint"/>"</xsl:message>
-->    
    <xsl:variable name="fontCharMap" as="element()?"
      select="$font2UnicodeMaps/*[lower-case(@sourceFont) = lower-case($fontName)]"
    />

    <xsl:choose>
      <xsl:when test="not($fontCharMap)">
        <xsl:message> - [WARN] getUnicodeForFont(): No font-to-character map found for font "<xsl:value-of select="$fontName"/>"</xsl:message>
        <xsl:sequence select="'003F'"></xsl:sequence>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="unicodeCodePoint" as="xs:string">
          <xsl:variable name="codePointMapping" as="element()?"
            select="$fontCharMap/codePointMapping[@origCodePoint = $fontCodePoint]"
          />
         
          <xsl:variable name="unicodeCodePoint" select="$codePointMapping/@unicodeCodePoint" as="xs:string"/>
<!--          <xsl:message> + [DEBUG] getUnicodeForFont():   codePointMapping=<xsl:sequence select="$codePointMapping"/></xsl:message>     -->
<!--          <xsl:message> + [DEBUG] getUnicodeForFont():   unicodeCodePoint=<xsl:sequence select="$unicodeCodePoint"/></xsl:message>-->
          <xsl:sequence 
            select="$unicodeCodePoint"/>
        </xsl:variable>
        <xsl:sequence select="$unicodeCodePoint"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="local:hex-digit-to-integer" as="xs:integer">
    <xsl:param name="char"/>
    <xsl:sequence 
      select="string-length(substring-before('0123456789ABCDEF',
      $char))"/>
  </xsl:function>
  
  <xsl:function name="local:int-to-hex" as="xs:string">
   <xsl:param name="in" as="xs:integer"/>
   <xsl:sequence
     select="if ($in eq 0)
             then '0'
             else
               concat(if ($in gt 16)
                      then local:int-to-hex($in idiv 16)
                      else '',
                      substring('0123456789ABCDEF',
                                ($in mod 16) + 1, 1))"/>
  </xsl:function>
  
  <xsl:template match="w:*" priority="-0.5">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:message> - [WARNING] wordml2simple: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="*" priority="-1">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:message> - [WARNING] wordml2simple: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
</xsl:stylesheet>
