<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:d2r="urn:names:dtd2rng"
  exclude-result-prefixes="xs relpath d2r"
  version="2.0">
  <!-- =====================================================
       Utility transform to generate DITA RNG moduels from
       DTD modules.
       
       Uses analyze-string to do regular expression parsing of
       DTD files. Depends on the use of DITA code formatting
       conventions
       
       The input to the transform is an XML file that references
       each DTD module file to be processed:
       
       <modules>
         <include href="someModule.mod"/>
        </modules>
        
        The root element type does not matter.
       
       ======================================================= -->
  
  <xsl:import href="relpath_util.xsl"/>
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:variable name="doDebug" as="xs:boolean" select="false()"/>
    
    <generation-log>
     <time><xsl:sequence select="current-dateTime()"/></time>
     <input><xsl:sequence select="document-uri(.)"/></input>      
    
    <xsl:apply-templates select="/*/include">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>
    </generation-log>
  </xsl:template>
  
  <xsl:template match="include[@href]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:variable name="href" as="xs:string" select="@href"/>
    <xsl:variable name="baseName" select="relpath:getNamePart($href)"/>
    
    <xsl:variable name="dtdModuleURI" as="xs:string"
      select="string(resolve-uri($href, base-uri(.)))"
    />
    
    <xsl:variable name="resultURI" as="xs:string"
      select="relpath:newFile(relpath:newFile(relpath:getParent(relpath:getParent($dtdModuleURI)), 'rng'), 
                              concat($baseName, '.rng'))"
    />
    
    <xsl:variable name="dtdText" select="unparsed-text($dtdModuleURI)" as="xs:string?"/>
    <!-- Skip any XML declaration since we never want it -->
    <xsl:variable name="startPos" as="xs:integer"
      select="if (starts-with($dtdText, '&lt;?xml'))
                 then 2
                 else 1"
    />
    <xsl:variable name="dtdLines" as="xs:string*" 
      select="for $l in tokenize($dtdText, '\n')[position() ge $startPos] return replace($l, '&#x0d;', '')"/>
    
    <include>
      <source><xsl:sequence select="$dtdModuleURI"/></source>
      <generatedFile><xsl:sequence select="$resultURI"/></generatedFile>
      <xsl:result-document href="{$resultURI}">
        <grammar 
          xmlns="http://relaxng.org/ns/structure/1.0"
          xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
          datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
          <xsl:call-template name="makeModuleDesc">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            <xsl:with-param name="dtdText" as="xs:string" select="$dtdText"/>
            <xsl:with-param name="dtdLines" as="xs:string*" select="$dtdLines"/>
          </xsl:call-template>          
        </grammar>
      </xsl:result-document>
    </include>
    
    
  </xsl:template>
  
  <xsl:template name="makeModuleDesc">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="dtdText" as="xs:string"/>
    <xsl:param name="dtdLines" as="xs:string*"/>
    
    <xsl:variable name="moduleTitle" as="xs:string"
      select="normalize-space($dtdLines[2])"
    />
    
    <moduleDesc xmlns="http://dita.oasis-open.org/architecture/2005/">
      <moduleTitle><xsl:value-of select="$moduleTitle"/></moduleTitle>
      <headerComment xml:space="preserve">
<xsl:sequence select="d2r:getBlockComment($dtdLines)"/>
</headerComment>
      <moduleMetadata>
        <moduleType>elementdomain</moduleType>
        <moduleShortName>equation-d</moduleShortName>
        <modulePublicIds>
          <dtdMod></dtdMod>
          <dtdEnt></dtdEnt>
          <xsdMod></xsdMod>
          <rncMod></rncMod>
          <rngMod></rngMod>
        </modulePublicIds>
        <domainsContribution></domainsContribution>
      </moduleMetadata>
    </moduleDesc>
    
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="text()"/>

  <!-- Get the block comment that starts in the first line of the
       input string.
       
    -->
  <xsl:function name="d2r:getBlockComment" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:sequence select="d2r:getBlockComment($lines, false())"/>
  </xsl:function>
  
  <!-- Get the block comment that starts in the first line of the
       input string.
       
    -->
  <xsl:function name="d2r:getBlockComment" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:getBlockComment(): Starting, lines[1]:
<xsl:sequence select="$lines[1]"/></xsl:message>
    </xsl:if>
    
    <!-- Account for the original comment open delimiter so horizontal indent is preserved in result -->
    <xsl:variable name="firstLine" select="concat('    ', substring-after($lines[1], '&lt;!--'))"/>
    <xsl:variable name="result" as="xs:string*"
      select="($firstLine, d2r:getLinesUntilMatch($lines[position() gt 1], '\s?--&gt;$', $doDebug))"
    />
    <xsl:sequence select="string-join($result, '&#x0a;')"/>
  </xsl:function>
  
  <xsl:function name="d2r:getLinesUntilMatch" as="xs:string*">
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="regex" as="xs:string"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
        
    <xsl:variable name="result" as="xs:string*"
      select="d2r:getLinesUntilMatch((), $lines, $regex, $doDebug)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <!-- Gets lines until a line matches the regular expression or
       the lines are exhausted.
       
       Last line is the text before the match.
       
    -->
  <xsl:function name="d2r:getLinesUntilMatch" as="xs:string*">
    <xsl:param name="resultLines" as="xs:string*"/>
    <xsl:param name="lines" as="xs:string*"/>
    <xsl:param name="regex" as="xs:string"/>
    <xsl:param name="doDebug" as="xs:boolean"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:getLinesUntilMatch(): Starting, regex="<xsl:value-of select="$regex"/>", 
        lines[1]:
/<xsl:sequence select="$lines[1]"/>/</xsl:message>
    </xsl:if>
        
    <xsl:variable name="beforeMatch" as="xs:string?"
      select="if (matches($lines[1], $regex))
                 then tokenize($lines[1], $regex)[1]
                 else ()
      "
    />
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] d2r:getLinesUntilMatch(): beforeMatch="<xsl:value-of select="$beforeMatch"/>"</xsl:message>
    </xsl:if>
    

    <xsl:variable name="result" as="xs:string*"
      select="if (empty($lines) or matches($lines[1], $regex))
                 then ($resultLines, $beforeMatch)
                 else d2r:getLinesUntilMatch(($resultLines, $lines[1]),
                                             $lines[position() gt 1], 
                                             $regex, 
                                             $doDebug)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
</xsl:stylesheet>