/**
 * Copyright 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.io.File;
import java.net.URL;
import java.util.Properties;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;

public class DocxUpdaterTest
  extends TestCase
{
  // 2010-11-12T16:46:00Z

public static Test suite() 
  {
    TestSuite suite = new TestSuite(DocxUpdaterTest.class);
    return suite; 
  }

    public static String wNs = DocxConstants.nsByPrefix.get("w");
  
	URL catalogManagerProperties = getClass().getResource("/resources/CatalogManager.properties");
	URL topic_1_1Url = getClass().getResource("/resources/xml_data/docs/dita/word2dita/topic_1_1.dita");
	URL docxUrl = getClass().getResource("/resources/xml_data/docs/dita/word2dita/word2dita_single_doc_to_map_and_topics_01.docx");
	BosConstructionOptions bosOptions = null;
	
	public static final Log log = LogFactory.getLog(DocxUpdaterTest.class);

	String[] catalogs = new String[1];
	
	public void setUp() throws Exception {
		
		assertNotNull(catalogManagerProperties);
		Properties catProps = new Properties();
		catProps.load(catalogManagerProperties.openStream());
		String catalog = catProps.getProperty("catalogs");
		assertNotNull(catalog);
		catalogs[0] = catalog;
	}

	public void testParseWithXMLFormatLoggingXMLReader() throws Exception {
		File messageFile = File.createTempFile("DocxUpdaterTest-", ".xml");
		File docxFile = new File(docxUrl.toURI());
		File newDocxFile = File.createTempFile("docxupdater", ".docx");
		assertTrue("DOCX file does not exist", docxFile.exists());
		URL inputUrl = topic_1_1Url;

		Document logDoc;
		try {
			logDoc = Word2DitaValidationHelper.validateXml(messageFile, inputUrl, catalogs);
			Word2DitaValidationHelper.addValidationMessagesToDocxFile(docxFile, newDocxFile, logDoc);

			System.out.println("New zip file is: " + newDocxFile.getAbsolutePath());
		} catch (Exception e) {
			e.printStackTrace();
			fail(e.getMessage());
		}
		
	}


}
