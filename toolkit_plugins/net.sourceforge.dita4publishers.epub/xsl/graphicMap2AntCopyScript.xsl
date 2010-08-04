<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:gmap="http://dita4publishers/namespaces/graphic-input-to-output-map"
  exclude-result-prefixes="xd df xs relpath gmap"
  version="2.0">
  
  <xsl:import href="lib/relpath_util.xsl"/>
  
  <xsl:template match="/" mode="generate-graphic-copy-ant-script">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-graphic-copy-ant-script">
    <xsl:param name="graphicMap" as="element()" tunnel="yes"/>
    
    <xsl:variable name="resultUri" 
      select="relpath:newFile($outdir, 'copy-graphics.xml')" 
      as="xs:string"/>
    
    <xsl:message> + [INFO] Generating Ant graphic copying script as file "<xsl:sequence select="$resultUri"/>"...</xsl:message>
    
    <xsl:result-document format="opf" href="{$resultUri}">
      <xsl:apply-templates select="$graphicMap" mode="#current"/>
    </xsl:result-document>  
    <xsl:message> + [INFO] Ant graphic copying script generation done.</xsl:message>
  </xsl:template>
  
  <xsl:template match="gmap:graphic-map" mode="generate-graphic-copy-ant-script">
    <project name="graphics-copy" default="copy-graphics">
      <target name="copy-graphics">
        <xsl:for-each-group 
          select="gmap:graphic-map-item" 
          group-by="relpath:getParent(string(./@ouput-url))">
          <xsl:variable name="outputDir" select="relpath:toFile(relpath:getParent(string(./@ouput-url)), $platform)"/>
          <copy todir="{relpath:toFile($imagesOutputPath, $platform)}">
            <xsl:for-each-group select="current-group()" 
              group-by="relpath:getParent(string(./@input-url))">
              <xsl:variable name="sourceDir" 
                select="relpath:toFile(relpath:getParent(string(./@input-url)), $platform)"/>
              <fileset dir="{$sourceDir}">
                <xsl:apply-templates select="current-group()" mode="#current">
                  <xsl:with-param name="dir" select="$sourceDir" as="xs:string" tunnel="yes"/>
                </xsl:apply-templates>
              </fileset>
            </xsl:for-each-group>
          </copy>
        </xsl:for-each-group>
      </target>
    </project>
  </xsl:template>
  
  <xsl:template match="gmap:graphic-map-item" mode="generate-graphic-copy-ant-script">
    <xsl:param name="dir" tunnel="yes"/><!-- Directory containing the graphic -->
    <!--
      <gmap:graphic-map-item 
        input-url="file:/Users/ekimber/workspace/dita4publishers/sample_data/epub-test/covers/images/1407-02.jpg"
        output-url="file:/Users/ekimber/workspace/dita4publishers/sample_data/epub-test/epub/images/1407-02.jpg"/>
    -->
    <include name="{relpath:getName(@input-url)}"/>
  </xsl:template>
  
</xsl:stylesheet>
