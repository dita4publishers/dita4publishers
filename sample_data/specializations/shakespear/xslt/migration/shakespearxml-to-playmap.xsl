<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      version="2.0">
  
  <!-- Migration utility to create play maps and topics from 
       Jon Bosak's XML Shakespear documents.
  -->
 
  <xsl:output
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/shakespear/dtd/playmap"
    doctype-system="playmap.dtd"
    indent="yes"
  />
  
  <xsl:output name="personae"
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/shakespear/dtd/personae"
    doctype-system="personae.dtd"
    indent="yes"
  />
  
  <xsl:output name="act"
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/shakespear/dtd/act"
    doctype-system="act.dtd"
    indent="yes"
  />
  
  <xsl:output name="prologue"
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/shakespear/dtd/prologue"
    doctype-system="prologue.dtd"
  />
  
  <xsl:output name="epilogue"
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/shakespear/dtd/epilogue"
    doctype-system="epilogue.dtd"
  />
  
  <xsl:output name="scene"
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/shakespear/dtd/scene"
    doctype-system="scene.dtd"
  />
  
  <xsl:output name="induct"
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/shakespear/dtd/induct"
    doctype-system="induct.dtd"
  />
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="PLAY">
    <playmap>
      <xsl:apply-templates select="TITLE"/>
      <playmeta>      
        <playmetadata>
        <xsl:apply-templates select="SCNDESCR"/>
      </playmetadata>
      </playmeta>
      <xsl:apply-templates select="PERSONAE"/>
      <xsl:apply-templates select="PROLOGUE | INDUCT">
        <xsl:with-param name="actPrefix" as="xs:string" select="''" tunnel="yes"/>        
      </xsl:apply-templates>
      <acts>
        <xsl:apply-templates select="ACT"/>
      </acts>
      <xsl:apply-templates select="EPILOGUE">
        <xsl:with-param name="actPrefix" as="xs:string" select="''" tunnel="yes"/>        
      </xsl:apply-templates>
    </playmap>
  </xsl:template>
  
  <xsl:template match="PLAY/SCNDESCR">
    <scene-description><xsl:apply-templates/></scene-description>
  </xsl:template>
  
  <xsl:template match="PERSONAE">
    <xsl:variable name="resultUrl" select="'topics/personae.xml'" as="xs:string"/>
    <personae href="{$resultUrl}"/>
    <xsl:result-document href="{$resultUrl}" format="personae">
      <personae id="personae">
        <xsl:apply-templates select="TITLE"/>
        <personae-body>
          <xsl:apply-templates select="PERSONA | PGROUP"/>
        </personae-body>
      </personae>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="PLAY/EPILOGUE">
    <xsl:variable name="resultUrl" select="'topics/epilogue.xml'" as="xs:string"/>
    <epilogue href="{$resultUrl}"/>
    <xsl:result-document href="{$resultUrl}" format="epilogue">
      <xsl:call-template name="handle-epilog"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="ACT/EPILOGUE" name="handle-epilog">
    <xsl:param name="actPrefix" tunnel="yes" as="xs:string"/>
    <epilogue id="{concat($actPrefix, 'epilog')}">
        <xsl:apply-templates select="TITLE"/>
        <epilogue-body>
          <xsl:apply-templates select="*[not(self::TITLE)]"/>
        </epilogue-body>
      </epilogue>
  </xsl:template>
  
  <xsl:template match="PLAY/PROLOGUE">
    <xsl:variable name="resultUrl" select="'topics/prologue.xml'" as="xs:string"/>
    <prologue href="{$resultUrl}"/>
    <xsl:result-document href="{$resultUrl}" format="prologue">
      <xsl:call-template name="handle-prologue"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="ACT/PROLOGUE" name="handle-prologue">
    <xsl:param name="actPrefix" tunnel="yes" as="xs:string"/>
    <prologue id="{concat($actPrefix, 'prologue')}">
      <xsl:apply-templates select="TITLE"/>
      <prologue-body>
        <xsl:apply-templates select="*[not(self::TITLE)]"/>
      </prologue-body>
    </prologue>
  </xsl:template>
  
  <xsl:template match="PLAY/INDUCT">
    <xsl:variable name="resultUrl" select="'topics/induct.xml'" as="xs:string"/>
    <induct href="{$resultUrl}"/>
    <xsl:result-document href="{$resultUrl}" format="induct">
      <xsl:call-template name="handle-induct"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="ACT/INDUCT" name="handle-induct">
    <xsl:param name="actPrefix" tunnel="yes" as="xs:string"/>
    <induct id="{concat($actPrefix, 'induct')}">
      <xsl:apply-templates select="TITLE"/>
      <induct-body>
        <xsl:apply-templates select="*[not(self::TITLE)]"/>
      </induct-body>
    </induct>
  </xsl:template>
  
  <xsl:template match="ACT">
    <xsl:variable name="actNumber" select="count(preceding-sibling::ACT) + 1" as="xs:integer"/>
    <xsl:variable name="actId" select="concat('act-', $actNumber)" as="xs:string"/>
    <xsl:variable name="resultUrl" select="concat('topics/',$actId,'.xml')" as="xs:string"/>
    <act href="{$resultUrl}"/>
    <xsl:result-document href="{$resultUrl}" format="act">
      <act id="{$actId}">
        <xsl:apply-templates select="*">
          <xsl:with-param name="actPrefix" as="xs:string" select="concat('act-', $actNumber, '-')" tunnel="yes"/>
        </xsl:apply-templates>
      </act>
    </xsl:result-document>
  </xsl:template>
  
  
  <xsl:template match="PGROUP | 
                       PERSONA | 
                       GRPDESCR | 
                       SPEECH |
                       SPEAKER |
                       STAGEDIR |
                       SUBHEAD |
                       LINE |
                       TITLE">
    <xsl:element name="{lower-case(name(.))}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="SCENE">
    <xsl:param name="actPrefix" tunnel="yes" as="xs:string"/>
    <xsl:variable name="sceneNumber" select="count(preceding-sibling::SCENE) + 1"/>
    <xsl:variable name="sceneId" select="concat($actPrefix, 'scene-', $sceneNumber)" as="xs:string"/>
    <scene id="{$sceneId}">
      <xsl:apply-templates select="TITLE"/>
      <scene-body>
        <xsl:apply-templates select="*[not(self::TITLE)]"/>
      </scene-body>
    </scene>
  </xsl:template>
  
  <xsl:template match="*" priority="-1">
    <xsl:message> + [WARNING] Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
</xsl:stylesheet>
