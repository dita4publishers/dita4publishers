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
      
      xmlns:local="urn:local-functions"
      
      xmlns:saxon="http://saxon.sf.net/"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      
      exclude-result-prefixes="a pic xs mv mo ve o r m v w10 w wne wp local relpath saxon"
      version="2.0">
  
  <!--==========================================
      MS Office 2007 Office Open XML to generic
      XML transform.
      
      Copyright (c) 2009, 2010 DITA For Publishers
      
      This transform is a generic transform that produces a simplified
      form of generic XML from Office Open XML.
      
      The input to this transform is the document.xml file within a DOCX
      package.
      
      Originally developed by Really Strategies, Inc.
      
      =========================================== -->

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>
  
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:desc>
      <xd:p>The absolute URL of the directory that contains the media objects extracted
      from the DOCX package. The presumption is that some process has copied the media/
      directory from the DOCX package to an appropriate location relative to where
      the DITA XML will be generated.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:key name="formats" match="stylemap:output" use="@name"/>
  <xsl:key name="styleMaps" match="stylemap:style" use="@styleId"/>
  <xsl:key name="relsById" match="rels:Relationship" use="@Id"/>
  
  <xsl:variable name="styleMapDoc" as="document-node()"
    select="document($styleMapUri)"
  />
  
  <xsl:variable name="imageRelType" select="'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image'"
    as="xs:string"
  />
  
  <xsl:template match="/" name="processDocumentXml">
    <xsl:message> + [INFO] styleMap=<xsl:sequence select="document-uri($styleMapDoc)"/></xsl:message>
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
  </xsl:template>
  
  <xsl:template match="w:document">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:body">
    <body>
      <xsl:apply-templates/>
    </body>
  </xsl:template>
  
  <xsl:template match="w:p">
    <xsl:param name="mapUnstyledParasTo" select="'p'" tunnel="yes"/>
    
    <xsl:variable name="specifiedStyleId" as="xs:string"
      select="string(./w:pPr/w:pStyle/@w:val)"
    />
    
    <xsl:variable name="styleId"
      as="xs:string"
      select="
      local:getParaStyle(., $mapUnstyledParasTo)
      "
    />
    
    <xsl:variable name="styleMap" as="element()?"
      select="key('styleMaps', $styleId, $styleMapDoc)[1]"
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
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$specifiedStyleId = ''">
              <xsl:variable name="contentString" as="xs:string"
                select="if (string-length(normalize-space(.)) > 60)
                then concat(substring(normalize-space(.),1, 60), '...')
                else normalize-space(.)
                "
              />
              <xsl:message> - [WARNING: Unstyled non-empty paragraph with content "<xsl:sequence select="$contentString"/>"</xsl:message>              
            </xsl:when>
            <xsl:otherwise>
              <xsl:message> - [WARNING: No style mapping for paragraph with style ID "<xsl:sequence select="$styleId"/>"</xsl:message>
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
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] match on w:p: structureType = "<xsl:sequence select="string($styleData/@structureType)"/>"</xsl:message>
    </xsl:if>
    <xsl:if test="string($styleData/@structureType) != 'skip'">
      <xsl:if test="$debugBoolean">
        <xsl:message> + [DEBUG] match on w:p: Paragraph not skipped, calling handlePara. p=<xsl:sequence select="substring(string(./w:r[1]), 0, 40)"/></xsl:message>
      </xsl:if>
      <xsl:call-template name="handlePara">
        <xsl:with-param name="styleId" select="$styleId" as="xs:string"/>
        <xsl:with-param name="styleData" select="$styleData" as="element()"/>
      </xsl:call-template>  
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="handlePara">
    <xsl:param name="styleId" as="xs:string"/>
    <xsl:param name="styleData" as="element()"/>
    <p style="{$styleId}" wordLocation="{saxon:path()}">
      <xsl:for-each select="$styleData/@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:if test="not($styleData/@topicZone)">
        <xsl:attribute name="topicZone" select="'body'"/>
      </xsl:if>
      <xsl:if test="$debugBoolean">        
        <xsl:message> + [DEBUG] handlePara: p="<xsl:sequence select="substring(normalize-space(.), 1, 40)"/>"</xsl:message>
      </xsl:if>
      <!-- FIXME: This code is not doing anything specific with smartTag elements, just
                  processing their children. Doing something intelligent with smartTags
                  would require additional logic.
        -->
      <xsl:for-each-group select="w:r | w:hyperlink | w:smartTag/w:r" group-adjacent="name(.)">
        <xsl:choose>
          <xsl:when test="current-group()[1][self::w:hyperlink]">
            <!-- FIXME: This is a hack. Correct processing of hyperlinks needs to be
              much more sophisticated. This code is essentially ignoring the link aspect
              of the hyperlink.
            -->
            <xsl:for-each select="current-group()">
              <xsl:call-template name="handleRunSequence">
                <xsl:with-param name="runSequence" select="w:r"/>
              </xsl:call-template>              
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="current-group()[1][self::w:r]">
            <xsl:for-each-group select="current-group()" group-adjacent="local:getRunStyle(.)">
              <xsl:call-template name="handleRunSequence">
                <xsl:with-param name="runSequence" select="current-group()"/>
              </xsl:call-template>
            </xsl:for-each-group>            
          </xsl:when>
          <xsl:when test="current-group()[1][self::w:smartTag]">
            <xsl:if test="$debugBoolean">
              <xsl:message> + [DEBUG] *** got a w:smartTag. current-group=<xsl:sequence select="current-group()"/></xsl:message>
            </xsl:if>     
            <xsl:for-each select="current-group()">
              <xsl:call-template name="handleRunSequence">
                <xsl:with-param name="runSequence" select="w:r"/>
              </xsl:call-template>              
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes"> - [ERROR] handlePara(): Unhandled element type <xsl:sequence select="name(.)"/></xsl:message>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:for-each-group>
    </p>
    
  </xsl:template>
  <xsl:template name="handleRunSequence">
    <xsl:param name="runSequence" as="element()*"/>
    <xsl:variable name="runStyle" select="local:getRunStyle($runSequence[1])" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$runStyle = ''">
        <xsl:apply-templates select="$runSequence"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="runStyleMap" as="element()?"
          select="key('styleMaps', $runStyle, $styleMapDoc)[1]"
        />
        <xsl:if test="not($runStyleMap)">
          <xsl:message> - [WARNING: No style mapping for character run with style ID "<xsl:sequence select="$runStyle"/>"</xsl:message>              
        </xsl:if>
        <xsl:variable name="runTagName"
          as="xs:string"
          select="if ($runSequence[1][self::w:hyperlink])
          then 'hyperlink'
          else 'run'
          "
        />
        <xsl:element name="{$runTagName}">
          <xsl:attribute name="style" select="$runStyle"/>
          <xsl:if test="$runStyleMap">
            <xsl:for-each select="$runStyleMap/@*">
              <xsl:copy/>
            </xsl:for-each>
          </xsl:if>
          <xsl:apply-templates select="$runSequence"/></xsl:element>
      </xsl:otherwise>
    </xsl:choose>        
    
  </xsl:template>
  
  <xsl:template match="w:r">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:smartTag">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:hyperlink">
    <xsl:param name="relsDoc" as="document-node()?" tunnel="yes"/>
    
    <xsl:variable name="runStyle" select="local:getHyperlinkStyle(.)" as="xs:string"/>
    <xsl:variable name="runStyleMap" as="element()?"
      select="key('styleMaps', $runStyle, $styleMapDoc)[1]"
    />
    <xsl:variable name="runStyleData" as="element()">
      <xsl:choose>
        <xsl:when test="$runStyleMap">
          <xsl:sequence select="$runStyleMap"/>
        </xsl:when>
        <xsl:otherwise>
          <stylemap:style styleId="Hyperlink"
            structureType="hyperlink"
            tagName="xref"
          />          
          
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>
    <xsl:variable name="rel" as="element()?"
      select="key('relsById', @r:id, $relsDoc)"
    />
    <xsl:if test="not($rel)"></xsl:if>
    <xsl:variable name="href" as="xs:string"
      select="
         if ($rel)
         then string($rel/@Target)
         else 'urn:unknown-target'
      "  
    />
    <xsl:variable name="scope" as="xs:string"
      select="
        if ($rel/@TargetMode)
        then lower-case($rel/@TargetMode)
        else 'external'
      "
    />
    
    <hyperlink href="{$href}" scope="{$scope}"
      >
      <xsl:for-each select="$runStyleData/@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates select="w:r[1]"/>
      <xsl:if test="count(w:r) > 1">
        <xsl:call-template name="handleRunSequence">
          <xsl:with-param name="runSequence" select="w:r[position() > 1]"/>
        </xsl:call-template>
      </xsl:if>
    </hyperlink>
  </xsl:template>
  
  <xsl:template match="text()"/>
  
  <xsl:template match="w:t">
    <!-- NOTE: this has to be value-of. If you use select, you get spaces
               between the w:t text values.
      -->
    <xsl:value-of select="string(.)"/>
  </xsl:template>

  <xsl:template match="w:tbl">
    <xsl:variable name="styleData" as="element()">
      <stylemap:style styleId="table"
        structureType="block"
        tagName="table"
        topicZone="body"
      />                
    </xsl:variable>
    <table>
      <xsl:for-each select="$styleData/@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates select="w:tblPr/*"/>
      <xsl:if test="w:tblGrid">
        <cols>
          <xsl:for-each select="w:tblGrid/w:gridCol">
            <col width="{@w:w}"/>
          </xsl:for-each>
        </cols>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::w:tblPr)]"/>
    </table>
  </xsl:template>
  
  <xsl:template match="w:tr">
    <tr>
      <xsl:apply-templates select="w:trPr/*|w:tblPrEx/*"/>
      <xsl:apply-templates select="*[name()!='w:trPr' and name()!='w:tblPrEx']"/>
    </tr>
  </xsl:template>
  
  <xsl:template match="w:tc">
    <td>
<!--      <xsl:apply-templates select="w:tcPr/*"/>-->
      <xsl:apply-templates select="*[not(self::w:tcPr)]">
        <xsl:with-param name="mapUnstyledParasTo" select="'entry'" tunnel="yes"/>
      </xsl:apply-templates>
    </td>
  </xsl:template>
  
  <xsl:template match="w:tab">
    <xsl:if test="not($filterTabsBoolean)">
      <tab/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="w:cr | w:br">
    <xsl:if test="not($filterBrBoolean)">
      <break/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="w:fldSimple">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="w:drawing">
    <!-- If there is a pic:blipFill then if there is an a:blip,
         chase down the relationship to get the name of
         the actual embedded grahpic.
    -->
    <xsl:apply-templates select=".//pic:blipFill"/>
  </xsl:template>

  <xsl:template match="w:pict">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="v:shape">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="pic:blipFill">
    <xsl:apply-templates select=".//a:blip"/>
  </xsl:template>
  
  <xsl:template match="a:blip">
    <xsl:param name="relsDoc" tunnel="yes" as="document-node()?"/>
    <xsl:variable name="imageUri" select="local:getImageReferenceUri($relsDoc, @r:embed)" as="xs:string"/>
    <image src="{$imageUri}"/>
  </xsl:template>
  
  <xsl:template match="v:imagedata">
    <xsl:param name="relsDoc" tunnel="yes" as="document-node()?"/>
    <xsl:variable name="imageUri" select="local:getImageReferenceUri($relsDoc, @r:id)" as="xs:string"/>
    <image src="{$imageUri}"/>
  </xsl:template>
  
  <xsl:function name="local:getImageReferenceUri" as="xs:string">
    <xsl:param name="relsDoc" as="document-node()?"/>
    <xsl:param name="relId" as="xs:string"/>
 
    <xsl:variable name="rel" as="element()?"
      select="key('relsById', $relId, $relsDoc)"
    />
    <xsl:variable name="target" select="string($rel/@Target)" as="xs:string"/>
    <xsl:variable name="imageFilename" as="xs:string"
      select="relpath:getName($target)"
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
                       w:sectPr |
                       w:instrText |
                       w:softHyphen |
                       w:tblW |
                       w:tblBorders |
                       w:tblLook |
                       w:tblGrid |
                       w:lastRenderedPageBreak |
                       w:fldChar |
                       v:shapetype
                       "
  />
  
  <xsl:function name="local:getRunStyle" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="
      if ($context/w:rPr/w:rStyle) 
          then string($context/w:rPr/w:rStyle/@w:val)
          else ''
    "/>
  </xsl:function>
  
  <xsl:function name="local:getHyperlinkStyle" as="xs:string">
    <!-- Hyperlinks don't have a directly-associated style but 
         should contain at least one text run. So we use
         the first text run as the hyperlink style to determine
         the hyperlink style.
      -->
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="
      if ($context/w:r[1]/w:rPr/w:rStyle) 
      then string($context/w:r[1]/w:rPr/w:rStyle/@w:val)
      else ''
      "/>
  </xsl:function>
  
  <xsl:function name="local:getParaStyle" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="mapUnstyledParasTo" as="xs:string"/>
    <xsl:sequence select="
      if ($context/w:pPr/w:pStyle) 
         then string($context/w:pPr/w:pStyle/@w:val)
         else $mapUnstyledParasTo
      "/>
  </xsl:function>
  
  <xsl:template match="w:*" priority="-0.5">
    <xsl:message> - [WARNING] wordml2simple: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="*" priority="-1">
    <xsl:message> - [WARNING] wordml2simple: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>

</xsl:stylesheet>
