/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools;

import java.io.File;
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

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.common.MapBosProcessorOptions;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpHelper;
import net.sourceforge.dita4publishers.tools.dxp.DitaDxpOptions;
import net.sourceforge.dita4publishers.util.DomUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;


public class DitaDxpHelperTest
  extends TestCase
{
  public static Test suite() 
  {
    TestSuite suite = new TestSuite(DitaDxpHelperTest.class);
    return suite; 
  }


	URL catalogManagerProperties = getClass().getResource("/resources/CatalogManager.properties");
	URL rootMapUrl = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/link_test_01.ditamap");
	URL topic01Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_01.xml");
	URL topic03Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_03.xml");
	Document rootMap = null;
	BosConstructionOptions bosOptions = null;
	private DitaBoundedObjectSet mapBos;
	
	private static final Log log = LogFactory.getLog(DitaDxpHelperTest.class);

  public void setUp() throws Exception {
		
	assertNotNull(catalogManagerProperties);
	Properties catProps = new Properties();
	catProps.load(catalogManagerProperties.openStream());
	String catalog = catProps.getProperty("catalogs");
	assertNotNull(catalog);
	String[] catalogs = {catalog};
	assertNotNull(rootMapUrl);
	Map<URI, Document> domCache = new HashMap<URI, Document>();
	bosOptions = new BosConstructionOptions(log, domCache);
	bosOptions.setCatalogs(catalogs);
	rootMap = DomUtil.getDomForUri(new URI(rootMapUrl.toExternalForm()), bosOptions);
	assertNotNull(rootMap);
	mapBos = DitaBosHelper.calculateMapBos(bosOptions,log, rootMap);

}

  
  public void xtestExtractMapExtractAll() throws Exception {
	  DitaDxpOptions options = new DitaDxpOptions();
	  File outputZipFile = File.createTempFile("textZipMapBos", ".dxp");
	  DitaDxpHelper.zipMapBos(mapBos, outputZipFile, options);

	  File temp = File.createTempFile("textExtractMap", "");
	  File outDir = new File(temp.getParentFile(), temp.getName() + "dir");

	  outDir.mkdirs();
	  DitaDxpHelper.unpackDxpPackage(outputZipFile, outDir, options);
	  log.info("output directory is \"" + outDir.getAbsolutePath() + "\"");
  }
  
  public void testExtractMapExtractMap() throws Exception {
	  DitaDxpOptions options = new DitaDxpOptions();
	  options.setUnzipAll(false);
	  File outputZipFile = File.createTempFile("textZipMapBos", ".dxp");
	  DitaDxpHelper.zipMapBos(mapBos, outputZipFile, options);

	  File temp = File.createTempFile("textExtractMap", "");
	  File outDir = new File(temp.getParentFile(), temp.getName() + "dir");

	  outDir.mkdirs();
	  DitaDxpHelper.unpackDxpPackage(outputZipFile, outDir, options);
	  log.info("output directory is \"" + outDir.getAbsolutePath() + "\"");
  }
  
  public void xtestZipMapBos() throws Exception {
	  MapBosProcessorOptions options = new DitaDxpOptions();
	  File outputZipFile = File.createTempFile("textZipMapBos", ".dxp");
	  DitaDxpHelper.zipMapBos(mapBos, outputZipFile, options);
	  assertTrue("DXP file doesn't exist", outputZipFile.exists());
	  ZipFile zipFile = new ZipFile(outputZipFile);
	  List<ZipEntry> entries = new ArrayList<ZipEntry>();
	  
	  Enumeration<? extends ZipEntry> enumer = zipFile.entries();
	  while (enumer.hasMoreElements()) {
		entries.add(enumer.nextElement());  
	  }
	  
	  assertEquals(11, entries.size());
	  
	  // Put more checks here.
	  
	  outputZipFile.deleteOnExit();
  }
  
  
}
