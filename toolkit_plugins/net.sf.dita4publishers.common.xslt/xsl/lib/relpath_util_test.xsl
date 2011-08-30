<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs relpath"
  >
  
  <xsl:include href="relpath_util.xsl"/>
  
<!-- Tests for the relpath_util functions
-->
  
    
  
  <xsl:template match="/">
    <xsl:call-template name="testUnencodeUrl"/>
    <xsl:call-template name="testEncodeUrl"/>
    <xsl:call-template name="testGetAbsolutePath"/>
    
    <xsl:call-template name="testGetRelativePath"/>
    
    <xsl:call-template name="testGetName"/>
    <xsl:call-template name="testGetParent"/>
    <xsl:call-template name="testNewFile"/>
    <xsl:call-template name="testGetNamePart"/>
    <xsl:call-template name="testGetExtension"/>

    <xsl:call-template name="testUrlToFile"/>    
  </xsl:template>
  
  <xsl:template name="testEncodeUrl">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>encodeUrl() Tests</title>
        <test>
          <source>/</source>
          <result>/</result>
        </test>
        <test>
          <source>/A B/C</source>
          <result>/A%20B/C</result>
        </test>
        <test>
          <source>/A[B]/D/foo.bar#e</source>
          <result>/A%5BB%5D/D/foo.bar#e</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testEncodeUrl"/>
  </xsl:template>
  
  <xsl:template name="testUnencodeUrl">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>UnencodeUrl() Tests</title>
         <test>
          <source>/A%20B/C</source>
          <result>/A B/C</result>
        </test>
        <test>
          <source>/A%5BB%5D/D/foo.bar#e</source>
          <result>/A[B]/D/foo.bar#e</result>
        </test>
        
        <test>
          <source>file:/D:/projects/%C3%A9%20X%20m%20l/samples/dita/garage/sequence.ditamap</source>
          <result>file:/D:/projects/é X m l/samples/dita/garage/sequence.ditamap</result>    
        </test>    
        <test>
          <source>/three/byte/unicode/%E6%97%A5/%E2%82%AC/%E6%97%A5%E6%9C%AC%E8%AA%9EAfter Unicode</source>
          <result>/three/byte/unicode/日/€/日本語After Unicode</result>    
        </test>    
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testUnencodeUrl"/>
  </xsl:template>
  
  <xsl:template name="testGetAbsolutePath">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>getAbsolutePath() Tests</title>
        <test>
          <source>/</source>
          <result>/</result>
        </test>
        <test>
          <source>/A</source>
          <result>/A</result>
        </test>
        <test>
          <source>/A/..</source>
          <result>/</result>
        </test>
        <test>
          <source>/A/./B</source>
          <result>/A/B</result>
        </test>
        <test>
          <source>/A/B/C/D/../../E</source>
          <result>/A/B/E</result>
        </test>
        <test>
          <source>/A/B/C/D/../../E/F</source>
          <result>/A/B/E/F</result>
        </test>
        <test>
          <source>file:///A/B/C</source>
          <result>file:///A/B/C</result>
        </test>
        <test>
          <source>./A/B/C/D/E.xml</source>
          <result>A/B/C/D/E.xml</result>
        </test>
        <test>
          <source>/A/B/</source>
          <result>/A/B</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testGetAbsolutePath"/>
  </xsl:template>
  
  <xsl:template name="testGetRelativePath">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>getRelativePath() Tests</title>
        <test>
          <source>/</source>
          <target>/A</target>
          <result>A</result>
        </test>
        <test>
          <source>/A</source>
          <target>/</target>
          <result>..</result>
        </test>
        <test>
          <source>/A</source>
          <target>/B</target>
          <result>../B</result>
        </test>
        <test>
          <source>/A</source>
          <target>/A/B</target>
          <result>B</result>
        </test>
        <test>
          <source>/A/B/C/D</source>
          <target>/A</target>
          <result>../../..</result>
        </test>
        <test>
          <source>/A/B/C/Z/Y</source>
          <target>/A/B/C/Y/Z</target>
          <result>../../Y/Z</result>
        </test>
        <test>
          <source>/A/B/C/D</source>
          <target>/A/E</target>
          <result>../../../E</result>
        </test>
        <test>
          <source>/A/B/C/D.xml</source>
          <target>/A/E</target>
          <result>../../E</result>
          <comment>This test should fail because there's no way for the XSLT
            to know that D.xml is a file and not a directory.
            The source parameter to relpath must be a directory path,
            not a filename.</comment>
        </test>
        <test>
          <source>/A/B</source>
          <target>/A/C/D</target>
          <result>../C/D</result>
        </test>
        <test>
          <source>/A/B/C</source>
          <target>/A/B/C/D/E</target>
          <result>D/E</result>
        </test>
        <test>
          <source>file:///A/B/C</source>
          <target>http://A/B/C/D/E</target>
          <result>http://A/B/C/D/E</result>
        </test>
        <test>
          <source>file://A/B/C</source>
          <target>file://A/B/C/D/E.xml</target>
          <result>D/E.xml</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testGetRelativePath"/>
  </xsl:template>
  
  <xsl:template match="test_data" mode="#all">
    <test_results>
      <xsl:apply-templates mode="#current"/>
    </test_results>
  </xsl:template>
  
  <xsl:template name="testGetName">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>getName() Tests</title>
        <test>
          <source>/</source>
          <result></result>
        </test>
        <test>
          <source>/A</source>
          <result>A</result>
        </test>
        <test>
          <source>/A/B</source>
          <result>B</result>
        </test>
        <test>
          <source>/A/B/C/D</source>
          <result>D</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testGetName"/>
  </xsl:template>
  
  <xsl:template name="testGetParent">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>getParent() Tests</title>
        <test>
          <source>/</source>
          <result></result>
        </test>
        <test>
          <source>/A</source>
          <result></result>
        </test>
        <test>
          <source>/A/B</source>
          <result>/A</result>
        </test>
        <test>
          <source>/A/B/C/D</source>
          <result>/A/B/C</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testGetParent"/>
  </xsl:template>
  
  <xsl:template name="testNewFile">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>newFile() Tests</title>
        <test>
          <parent>/</parent>
          <child>A</child>
          <result>/A</result>
        </test>
        <test>
          <parent>/A/B</parent>
          <child>C</child>
          <result>/A/B/C</result>
        </test>
        <test>
          <parent>/A/B</parent>
          <child>file://C</child>
          <result>file://C</result>
        </test>
        <test>
          <parent>/A/B</parent>
          <child>/C</child>
          <result>/C</result>
        </test>
        <test>
          <parent>/A/B</parent>
          <child>../C</child>
          <result>/A/C</result>
        </test>
        <test>
          <parent>/A/B</parent>
          <child>./C</child>
          <result>/A/B/C</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testNewFile"/>
  </xsl:template>
  
  <xsl:template name="testGetNamePart">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>getNamePart() Tests</title>
        <test>
          <source>/</source>
          <result></result>
        </test>
        <test>
          <source>/A/B</source>
          <result>B</result>
        </test>
        <test>
          <source>/A/B/C.xml</source>
          <result>C</result>
        </test>
        <test>
          <source>/A/B/thisisalongname.foo</source>
          <result>thisisalongname</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testGetNamePart"/>
  </xsl:template>
  
  <xsl:template name="testGetExtension">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>getExtension() Tests</title>
        <test>
          <source>/</source>
          <result></result>
        </test>
        <test>
          <source>/A/B</source>
          <result></result>
        </test>
        <test>
          <source>/A/B/C.xml</source>
          <result>xml</result>
        </test>
        <test>
          <source>/A/B/thisisalongname.foo</source>
          <result>foo</result>
        </test>
        <test>
          <source>/A/B/CCCC.</source>
          <result></result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testGetExtension"/>
  </xsl:template>
  
  <xsl:template name="testUrlToFile">
    <xsl:variable name="testData" as="element()">
      <test_data>
        <title>toFile() Tests</title>
        <test>
          <url>foo/bar</url>
          <platform>windows</platform>
          <result>foo\bar</result>
        </test>
        <test>
          <url>file:/c:/foo/bar</url>
          <platform>windows</platform>
          <result>c:\foo\bar</result>
        </test>
        <test>
          <url>file:///c:/foo/bar</url>
          <platform>windows</platform>
          <result>c:\foo\bar</result>
        </test>
        <test>
          <url>url:/foo/bar</url>
          <platform>windows</platform>
          <result>{cannot convert absolute URL to file path}</result>
        </test>
        <test>
          <url>file:/foo/bar</url>
          <platform>nx</platform>
          <result>/foo/bar</result>
        </test>
        <test>
          <url>file:///foo/bar</url>
          <platform>nx</platform>
          <result>/foo/bar</result>
        </test>
        <test>
          <url>foo/bar</url>
          <platform>nx</platform>
          <result>foo/bar</result>
        </test>
        <test>
          <url>file:/D:/projects/%C3%A9%20X%20m%20l/samples/dita/garage/sequence.ditamap</url>
          <platform>windows</platform>
          <result>D:\projects\é X m l\samples\dita\garage\sequence.ditamap</result>
        </test>
      </test_data>
    </xsl:variable>
    <xsl:apply-templates select="$testData" mode="testUrlToFile"/>
  </xsl:template>
  
  <xsl:template match="title" mode="#all">
    <xsl:text>&#x0a;</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&#x0a;&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testGetExtension">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:getExtension(string(source))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testGetNamePart">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:getNamePart(string(source))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testGetName">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:getName(string(source))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testGetParent">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:getParent(string(source))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testGetAbsolutePath">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:getAbsolutePath(string(source))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testGetRelativePath">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:text>      target: "</xsl:text><xsl:value-of select="target"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:getRelativePath(string(source), string(target))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template match="test" mode="testEncodeUrl">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:text>      target: "</xsl:text><xsl:value-of select="target"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:encodeUri(string(source))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testUnencodeUrl">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      source: "</xsl:text><xsl:value-of select="source"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:text>      target: "</xsl:text><xsl:value-of select="target"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:unencodeUri(string(source))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="test" mode="testNewFile">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <xsl:text>      parent: "</xsl:text><xsl:value-of select="parent"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:text>      child: "</xsl:text><xsl:value-of select="child"/><xsl:text>"&#x0a;</xsl:text>
    <xsl:variable name="cand" select="relpath:newFile(string(parent), string(child))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template match="test" mode="testUrlToFile">
    <xsl:text>Test Case: </xsl:text><xsl:number count="test" format="[1]"/><xsl:text>&#x0a;</xsl:text>
    <!-- <xsl:message> + [DEBUG] test=<xsl:sequence select="."/></xsl:message> -->
    <xsl:variable name="cand" select="relpath:toFile(string(url), string(platform))" as="xs:string"/>
    <xsl:variable name="pass" select="$cand = string(result)" as="xs:boolean"/>
    <xsl:text>      result: "</xsl:text><xsl:value-of select="$cand"/><xsl:text>", pass: </xsl:text><xsl:value-of select="$pass"/><xsl:text>&#x0a;</xsl:text>
    <xsl:if test="not($pass)">
      <xsl:text>      expected result: "</xsl:text><xsl:value-of select="result"/><xsl:text>"&#x0a;</xsl:text>
    </xsl:if>
    <xsl:copy-of select="comment"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
