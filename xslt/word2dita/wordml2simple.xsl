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
      
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:/dita4publishers.org/namespaces/word2dita/style2tagmap"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      
      exclude-result-prefixes="a pic xs mv mo ve o r m v w10 w wne wp local"
      version="2.0">
  
  <!--==========================================
      MS Office 2007 Office Open XML to generic
      XML transform.
      
      Copyright (c) 2009 DITA For Publishers
      
      This transform is a generic transform that produces a simplified
      form of generic XML from Office Open XML.
      
      The input to this transform is the document.xml file within a DOCX
      package.
      
      Originally developed by Really Strategies, Inc.
      
      =========================================== -->
  
  <xsl:param name="styleMapUri" as="xs:string"/>
  
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
      <xsl:message terminate="yes"> + [ERROR] Input document must be a w:document document.</xsl:message>
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
        <xsl:otherwise>
          <xsl:message> + [WARNING: No style mapping for paragraph with style ID "<xsl:sequence select="$styleId"/>"</xsl:message>
          <stylemap:style styleId="copy"
            structureType="block"
            tagName="p"
            topicZone="body"
          />          
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:if test="$styleData/@structureType = 'listItem'"></xsl:if>
    <xsl:if test="$styleData/@structureType != 'skip'">
      <xsl:call-template name="handlePara">
        <xsl:with-param name="styleId" select="$styleId"/>
        <xsl:with-param name="styleData" select="$styleData"/>
      </xsl:call-template>  
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="handlePara">
    <xsl:param name="styleId"/>
    <xsl:param name="styleData"/>
    <p style="{$styleId}">
      <xsl:for-each select="$styleData/@*">
        <xsl:copy/>
      </xsl:for-each>
      <!--      <xsl:message> + [DEBUG] p="<xsl:sequence select="substring(normalize-space(.), 1, 40)"/>"</xsl:message>-->
      <xsl:for-each-group select="w:r | w:hyperlink" group-adjacent="name(.)">
        <xsl:choose>
          <xsl:when test="current-group()[1][self::w:hyperlink]">
            <!-- Hyperlinks may contain multiple runs with different styles, so need
                 to handle each link separately.
            -->
            <xsl:apply-templates select="current-group()"/>
          </xsl:when>
          <xsl:when test="current-group()[1][self::w:r]">
            <xsl:for-each-group select="current-group()" group-by="local:getRunStyle(.)">
              <xsl:call-template name="handleRunSequence">
                <xsl:with-param name="runSequence" select="current-group()"/>
              </xsl:call-template>
            </xsl:for-each-group>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="yes"> + [ERROR] handlePara(): Unhandled element type <xsl:sequence select="name(.)"/></xsl:message>
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
        <xsl:apply-templates select="current-group()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="runStyleMap" as="element()?"
          select="key('styleMaps', $runStyle, $styleMapDoc)[1]"
        />
        <xsl:if test="not($runStyleMap)">
          <xsl:message> + [WARNING: No style mapping for character run with style ID "<xsl:sequence select="$runStyle"/>"</xsl:message>              
        </xsl:if>
        <xsl:variable name="runTagName"
          as="xs:string"
          select="if (current-group()[1][self::w:hyperlink])
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
          <xsl:apply-templates select="current-group()"/></xsl:element>
      </xsl:otherwise>
    </xsl:choose>        
    
  </xsl:template>
  
  <xsl:template match="w:r">
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
    <tab/>
  </xsl:template>
  
  <xsl:template match="w:cr | w:br">
    <break/>
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
  
  <xsl:template match="pic:blipFill">
    <xsl:apply-templates select=".//a:blip"/>
  </xsl:template>
  
  <xsl:template match="a:blip">
    <xsl:param name="relsDoc" tunnel="yes" as="document-node()?"/>
    <xsl:variable name="rel" as="element()?"
      select="key('relsById', @r:embed, $relsDoc)"
    />
    <xsl:choose>
      <xsl:when test="$rel and string($rel/@Type) = $imageRelType">
        <image src="{$rel/@Target}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [WARNING] a:blip: Failed to find Relationship of type Image for relationship ID "<xsl:sequence select="@r:embed"/>"</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
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
                       w:fldChar
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
    <xsl:message> + [WARNING] wordml2simple: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="*" priority="-1">
    <xsl:message> + [WARNING] wordml2simple: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>

</xsl:stylesheet>
