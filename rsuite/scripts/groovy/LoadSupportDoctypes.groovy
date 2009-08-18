// Script to import and configure the doctypes for support documents (e.g., style-to-tag maps).
//
import com.reallysi.rsuite.admin.importer.*
import com.reallysi.rsuite.client.api.*

// -----------------------------------------------------------------------

def otHome = System.getenv("DITA_OT_HOME");
if (otHome == null) {
	println "Environment variable DITA_OT_HOME not set. Set to the directory";
	println "that contains your DITA Open Toolkit, e.g., the 'dita/DITA-OT' directory"
	println "under the OxygenXML frameworks/ directory."
	return;
}
def File otDir = new File(otHome);
def File catalogFile = new File(otDir, "catalog-dita.xml");
def catalog = catalogFile.getAbsolutePath();
println "catalog=\"" + catalog + "\"";
def projectDir = new File(scriptFile.absolutePath).parentFile.parentFile.parentFile.parentFile;
def doctypesDir = new File(projectDir, "doctypes");
def File xsltDir = new File(projectDir, "/xslt");
def File previewXslFile = new File(xsltDir, "preview/dita-preview.xsl");

def baseTopicTypeURI = "urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/";
def baseMapTypeURI = "urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/";


def loadAndConfigureTopicDtd(dtdFile, dtdPublicId, topicTypes, otherMoTypes, previewXslFile, catalog)
{
	def moDefList = [];
	topicTypes.each {
		moDefList.add(new ManagedObjectDefinition(['name' : it, 
		                                              'displayNameXPath': "*[contains(@class, ' topic/title')]", 
		                                              'versionable': 'true', 
		                                              'reusable': 'true']))
		
	}
	
	otherMoTypes.each { nameTitle ->
	moDefList.add(new ManagedObjectDefinition(['name' : nameTitle[0], 
                                               'displayNameXPath': nameTitle[1], 
                                               'versionable': 'true', 
                                               'reusable': 'true']))
	}
	
	loadAndConfigureDtd(dtdFile, dtdPublicId, moDefList, previewXslFile, catalog);
}

def loadAndConfigureMapDtd(dtdFile, dtdPublicId, mapType, previewXslFile, catalog)
{
    def moDefList = [];
    moDefList.add(new ManagedObjectDefinition(['name' : mapType, 
	   'displayNameXPath': 
		   "(if (*[contains(@class, ' topic/title')]) " +
              " then *[contains(@class, ' topic/title')] " +
              " else string(@title)", 
	   'versionable': 'true', 
	   'reusable': 'true']))
    
    loadAndConfigureDtd(dtdFile, dtdPublicId, moDefList, previewXslFile, catalog);
}

def loadAndConfigureDtd(dtdFile, dtdPublicId, moDefList, previewXslFile, catalog)
	{
    println " + [INFO] Importing DTD " + dtdFile.name + ", public ID \"" + dtdPublicId + "\"...";
    importer = importerFactory.generateImporter("DTD", new SchemaInputSource(dtdFile, dtdFile.name, dtdPublicId));
    importer.setCatalogNames((String[])[catalog])
    uuid = importer.importDtd()
    
	rsuite.setManagedObjectDefinitions(uuid, false, moDefList)
	if (previewXslFile != null && previewXslFile.exists()) {
		rsuite.loadStylesheetForSchema(uuid, previewXslFile)
	}
}



//Special cases:

println "Importing style2tagmap.xsd"
def schemaFile = new File(doctypesDir, "style2tagmap/xsd/style2tagmap.xsd") 
def importer = importerFactory.generateImporter("XMLSchema", new SchemaInputSource(schemaFile));
uuid = importer.execute()   
def moDefList = [];

def namespaceDecls = (String[])[ "s2t=" + "urn:public:/dita4publishers.org/namespaces/word2dita/style2tagmap"];

moDefList.add(new ManagedObjectDefinition(['name' : '{urn:public:/dita4publishers.org/namespaces/word2dita/style2tagmap}:style2tagmap', 
                                           'displayNameXPath': "s2t:title", 
                                           'versionable': 'true', 
                                           'reusable': 'true']))
rsuite.setManagedObjectDefinitions(uuid, false, namespaceDecls, moDefList);	

def tagmapPreviewXslFile = new File(xsltDir, "style2tagmap/preview/style2tagmap-preview.xsl")
if (tagmapPreviewXslFile != null && tagmapPreviewXslFile.exists()) {
    rsuite.loadStylesheetForSchema(uuid, tagmapPreviewXslFile)
}

// End of script