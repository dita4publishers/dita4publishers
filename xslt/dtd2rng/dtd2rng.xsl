<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs relpath"
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
    <xsl:variable name="dtdLines" as="xs:string*" 
      select="for $l in tokenize($dtdText, '\n') return replace($l, '&#x0d;', '')"/>
    
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
    
    <!-- Assumes that first line XML declaration, second is start of block comment.
      -->
    <xsl:variable name="moduleTitle" as="xs:string"
      select="normalize-space($dtdLines[3])"
    />
      
    
    
    <moduleDesc xmlns="http://dita.oasis-open.org/architecture/2005/">
      <moduleTitle><xsl:value-of select="$moduleTitle"/></moduleTitle>
      <headerComment xml:space="preserve">
</headerComment>
      <moduleMetadata>
        <moduleType>elementdomain</moduleType>
        <moduleShortName>equation-d</moduleShortName>
        <modulePublicIds>
          <dtdMod>-//OASIS//ELEMENTS DITA<var presep=" " name="ditaver"/> Equation Domain//EN</dtdMod>
          <dtdEnt>-//OASIS//ENTITIES DITA<var presep=" " name="ditaver"/> Equation Domain//EN</dtdEnt>
          <xsdMod>urn:oasis:names:tc:dita:xsd:equationDomain.xsd<var presep=":" name="ditaver"/></xsdMod>
          <rncMod>urn:oasis:names:tc:dita:rnc:equationDomain.rnc<var presep=":" name="ditaver"/></rncMod>
          <rngMod>urn:oasis:names:tc:dita:rng:equationDomain.rng<var presep=":" name="ditaver"/></rngMod>
        </modulePublicIds>
        <domainsContribution>(topic d4p_simpleEnumeration-d)</domainsContribution>
      </moduleMetadata>
    </moduleDesc>
    
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="text()"/>
  
</xsl:stylesheet>