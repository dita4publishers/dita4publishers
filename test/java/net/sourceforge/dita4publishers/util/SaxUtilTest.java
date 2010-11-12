/**
 * Copyright 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.util;

import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.xml.transform.stream.StreamResult;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import net.sf.saxon.event.TEXTEmitter;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpHelper;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpOptions;
import net.sourceforge.dita4publishers.util.DomUtil;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;


public class SaxUtilTest
  extends TestCase
{
  public static Test suite() 
  {
    TestSuite suite = new TestSuite(SaxUtilTest.class);
    return suite; 
  }


	URL catalogManagerProperties = getClass().getResource("/resources/CatalogManager.properties");
	URL rootMapUrl = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/link_test_01.ditamap");
	URL topic01Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_01.xml");
	URL topic03Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_03.xml");
	URL topic_1_1Url = getClass().getResource("/resources/xml_data/docs/dita/word2dita/topic_1_1.dita");
	Document rootMap = null;
	BosConstructionOptions bosOptions = null;
	
	private static final Log log = LogFactory.getLog(SaxUtilTest.class);

	String[] catalogs = new String[1];
	
	public void setUp() throws Exception {
		
		assertNotNull(catalogManagerProperties);
		Properties catProps = new Properties();
		catProps.load(catalogManagerProperties.openStream());
		String catalog = catProps.getProperty("catalogs");
		assertNotNull(catalog);
		catalogs[0] = catalog;
		assertNotNull(rootMapUrl);
	}

  
	public void testParseWithXMLFormatLoggingXMLReader() throws Exception {
		Document logDoc = DomUtil.getNewDom();
		XMLReader reader = SaxUtil.getXMLFormatLoggingXMLReader(log, logDoc, true, catalogs);
		assertNotNull(reader);
		// System.err.println(IOUtils.toString(topic_1_1Url.openStream(), "utf-8"));
		
		InputSource source = new InputSource(topic_1_1Url.openStream());
		reader.parse(source);
		assertNotNull(logDoc.getDocumentElement());
		InputStream inStream = DomUtil.serializeToInputStream(logDoc, "utf-8");
		String messages = IOUtils.toString(inStream, "utf-8");
		System.out.println(messages);
	    
		
	}
}
