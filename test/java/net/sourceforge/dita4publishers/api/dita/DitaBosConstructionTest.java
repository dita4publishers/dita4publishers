/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.net.URI;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.bos.BosReportOptions;
import net.sourceforge.dita4publishers.api.bos.DependencyType;
import net.sourceforge.dita4publishers.api.ditabos.Constants;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.dita.DitavalSpecImpl;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.mapreporter.TextDitaBosReporter;
import net.sourceforge.dita4publishers.util.DomUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;


public class DitaBosConstructionTest
  extends TestCase
{
  public static Test suite() 
  {
    TestSuite suite = new TestSuite(DitaBosConstructionTest.class);
    return suite; 
  }


	URL catalogManagerProperties = getClass().getResource("/resources/CatalogManager.properties");
	URL rootMapUrl = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/link_test_01.ditamap");
	URL topic01Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_01.xml");
	URL topic03Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_03.xml");
	Document rootMap = null;
	BosConstructionOptions bosOptions = null;
	
	private static final Log log = LogFactory.getLog(DitaBosConstructionTest.class);

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
}

  
  public void testDitaBosConstruction() throws Exception {
	  DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapBos(bosOptions,log, rootMap);
	  assertNotNull(mapBos);
	  // mapBos.reportBos(log);
	  assertEquals(9, mapBos.size());

	  BosMember memberTopic03 = null;
	  BosMember memberTopic04 = null;
	  for (BosMember cand : mapBos.getMembers()) {
		  if (cand.getFileName().equals("topic_03.xml")) {
			  memberTopic03 = cand;
		  }
		  if (cand.getFileName().equals("topic_04.xml")) {
			  memberTopic04 = cand;
		  }
	  }
	  assertNotNull(memberTopic03);
	  assertNotNull(memberTopic04);
	  Set<BosMember> deps = memberTopic03.getDependenciesOfType(Constants.IMAGE_DEPENDENCY);
	  assertNotNull(deps);
	  assertEquals(1,deps.size());
	  BosMember dep = deps.iterator().next();
	  assertEquals("file:/Users/ekimber/workspace/dita4publishers/build/resources/xml_data/docs/dita/link_test_01/images/image_01.jpg", dep.getKey());
	  Set<DependencyType> depTypes = memberTopic03.getDependencyTypes();
	  assertNotNull(depTypes);
	  assertEquals(1,depTypes.size());
	  assertTrue(depTypes.contains(Constants.IMAGE_DEPENDENCY));
	  
	  depTypes = memberTopic03.getDependencyTypes(dep.getKey());
	  assertNotNull(depTypes);
	  assertTrue(depTypes.contains(Constants.IMAGE_DEPENDENCY));
	  
	  Map <String, ? extends BosMember> depMap = memberTopic04.getDependencies();
	  assertEquals("Expected 2 dependencies", 2, depMap.size());
	  
	  depTypes = memberTopic04.getDependencyTypes();
	  assertEquals("Expected 2 dependency types", 2, depTypes.size());
	  assertTrue("Expected xref dep type", depTypes.contains(Constants.XREF_DEPENDENCY));
	  assertTrue("Expected image dep type", depTypes.contains(Constants.IMAGE_DEPENDENCY));
	  
	  
	  DitaBosReporter reporter = new TextDitaBosReporter();
	  reporter.setPrintStream(System.out);
	  reporter.report(mapBos, new BosReportOptions());
  }
  
  public void testDitaMapTreeConstruction() throws Exception {
	  DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapTree(bosOptions,log, rootMap);
	  assertNotNull(mapBos);
	  // mapBos.reportBos(log);
	  assertEquals(2, mapBos.size());
	  
	  DitaKeySpace keySpace = mapBos.getKeySpace();
	  assertEquals(7, keySpace.size());
	  
  }
  
  public void testDitaKeySpaceConstrution() throws Exception {
	  DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapTree(bosOptions,log, rootMap);
	  assertNotNull(mapBos);
	  // mapBos.reportBos(log);
	  assertEquals(2, mapBos.size());
	  
	  DitaKeySpace keySpace = mapBos.getKeySpace();
	  assertEquals(7, keySpace.size());
	  
	  KeyAccessOptions keyAccessOptions = new KeyAccessOptions();
	  
	  Set<DitaKeyDefinition> effectiveKeyDefs = keySpace.getEffectiveKeyDefinitions(keyAccessOptions);
	  assertNotNull(effectiveKeyDefs);
	  assertEquals(7, effectiveKeyDefs.size());
	  
	  List<DitaKeyDefinition> allKeyDefs = keySpace.getAllKeyDefinitions(keyAccessOptions);
	  assertNotNull(allKeyDefs);
	  assertEquals(11, allKeyDefs.size());
	  
	  DitaKeyDefinition keyDef = keySpace.getKeyDefinition(keyAccessOptions, "key-02");
	  assertNotNull(keyDef);
	  assertEquals(DitaFormat.HTML, keyDef.getFormat());
	  
	  keyDef = keySpace.getKeyDefinition(keyAccessOptions, "key-06");
	  assertNotNull(keyDef);
	  assertEquals(DitaFormat.JPG, keyDef.getFormat());
	  
  }
  
  public void testDitaKeySpaceFiltering() throws Exception {
	  DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapTree(bosOptions,log, rootMap);
	  assertNotNull(mapBos);
	  // mapBos.reportBos(log);
	  assertEquals(2, mapBos.size());
	  
	  DitaKeySpace keySpace = mapBos.getKeySpace();
	  assertEquals(7, keySpace.size());
	  
	  KeyAccessOptions keyAccessOptions = new KeyAccessOptions();
	  DitavalSpec ditavalSpec = new DitavalSpecImpl();
	  ditavalSpec.addExclusion("platform", "windows");
	  keyAccessOptions.setDitavalSpec(ditavalSpec);
	  
	  Set<DitaKeyDefinition> effectiveKeyDefs = keySpace.getEffectiveKeyDefinitions(keyAccessOptions);
	  assertNotNull(effectiveKeyDefs);
	  assertEquals(7, effectiveKeyDefs.size());
	  
	  List<DitaKeyDefinition> allKeyDefs = keySpace.getAllKeyDefinitions(keyAccessOptions);
	  assertNotNull(allKeyDefs);
	  assertEquals(10, allKeyDefs.size());
	  
  }
  
  
}
