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
import net.sourceforge.dita4publishers.impl.dita.InMemoryDitaLinkManagementService;
import net.sourceforge.dita4publishers.impl.ditabos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaUtil;
import net.sourceforge.dita4publishers.impl.ditabos.DomUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;


public class DitaLinkManagementServiceTest
  extends TestCase
{
  public static Test suite() 
  {
    TestSuite suite = new TestSuite(DitaLinkManagementServiceTest.class);
    return suite; 
  }

  String key01 = "key-01"; // Declared twice, only first is effective, href to topic-01
  String key02 = "key-02"; // href to topic-02
  String key03 = "key-03"; // Declared on same topicref as key-04
  String key04 = "key-04"; // Declared on same topicref as key-03
  String key05 = "key-05"; // Uses keyref to key-02, no href.
  String key06 = "key-06"; // Uses keyref to key-02, no href.
  String key07 = "key-07"; // Defined in submap 01.
  int keyCount = 7;

	URL catalogManagerProperties = getClass().getResource("/resources/CatalogManager.properties");
	URL rootMapUrl = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/link_test_01.ditamap");
	URL topic01Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_01.xml");
	URL topic03Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_03.xml");
	private InMemoryDitaLinkManagementService dlmService;
	Document rootMap = null;
	
	
	private static final Log log = LogFactory.getLog(DitaLinkManagementServiceTest.class);

  public void setUp() throws Exception {
		
	assertNotNull(catalogManagerProperties);
	Properties catProps = new Properties();
	catProps.load(catalogManagerProperties.openStream());
	String catalog = catProps.getProperty("catalogs");
	assertNotNull(catalog);
	String[] catalogs = {catalog};
	assertNotNull(rootMapUrl);
	Map<URI, Document> domCache = new HashMap<URI, Document>();
	BosConstructionOptions bosOptions = new BosConstructionOptions(log, domCache);
	bosOptions.setCatalogs(catalogs);
	dlmService = new InMemoryDitaLinkManagementService(bosOptions);
	// Load rootMap document
	rootMap = DomUtil.getDomForUri(new URI(rootMapUrl.toExternalForm()), bosOptions);
	assertNotNull(rootMap);
}

  
  public void testDitaKeyrefApi() throws Exception {

	  
	  // get DOM for the rootMap.
	  
	  Element resourceElement = null;
	  URI resourceUri = null;


	  DitaKeySpace keySpace; 

	  // Map document contains 6 topicrefs, of which 5 define keys.
	  
	  // Test management of key space registry and handling of out-of-date
	  // key spaces.
	  
	  KeyAccessOptions keyAccessOptions = new KeyAccessOptions();
	  
	  
	  DitaKeyDefinitionContext keydefContext = dlmService.registerRootMap(rootMap);
	  assertNotNull(keydefContext);
	  DitaKeyDefinitionContext candKeydefContext = dlmService.getKeyDefinitionContext(rootMap);
	  assertEquals(keydefContext, candKeydefContext);
	  
	  keySpace = dlmService.getKeySpace(keyAccessOptions, keydefContext);
	  assertNotNull(keySpace);
	  assertEquals(rootMap.getDocumentURI(), keySpace.getRootMap(keyAccessOptions).getDocumentURI());
	  
	  dlmService.unRegisterKeySpace(keydefContext);
	  keySpace = dlmService.getKeySpace(keyAccessOptions, keydefContext);
	  assertNull("Expected a null key space", keySpace);
	  
	  keydefContext = dlmService.registerRootMap(rootMap);
	  assertNotNull(keydefContext);
	  
	  dlmService.markKeySpaceOutOfDate(keydefContext);
	  assertNotNull(keydefContext);
	  assertTrue(keydefContext.isOutOfDate());
	  
	  // Test operations on keys and key definitions:
	  
	  Set<String> keys = dlmService.getKeys(keyAccessOptions, keydefContext);
	  
	  assertNotNull(keys);
	  assertEquals(keyCount, keys.size());
	  
	  keySpace = dlmService.getKeySpace(keyAccessOptions, keydefContext);
	  assertNotNull(keySpace);
	  assertEquals(keyCount, keySpace.size());
	  
	  Document candDoc = keySpace.getRootMap(keyAccessOptions);
	  assertEquals(candDoc.getDocumentURI(), rootMap.getDocumentURI());
	  
	  // Get all key definitions in the repository:
	  Set<DitaKeyDefinition> keyDefSet = dlmService.getEffectiveKeyDefinitions(keyAccessOptions, keydefContext);
	  List<DitaKeyDefinition> keyDefList = null;
	  assertNotNull("keydefs is null", keyDefSet);
	  assertEquals(keyCount, keyDefSet.size());

	  // Get effective key definition for a key in a context: 
	  DitaKeyDefinition keyDef = dlmService.getKeyDefinition(keyAccessOptions, keydefContext, key01);
	  assertNotNull("keyDef is null", keyDef);
	  String rootMapId = keyDef.getBaseUri().toURL().toExternalForm();
	  assertNotNull(rootMapId);
	  assertEquals(rootMap.getDocumentURI(), rootMapId);
	  
	  // Get all the effective key definitions  in the repository for a key:

	  keyDefSet = dlmService.getEffectiveKeyDefinitionsForKey(keyAccessOptions, key01);
	  assertNotNull("Effective keyDefs for key01 are null", keyDefSet);
	  assertEquals(1, keyDefSet.size());
	  
	  // Get all the key definitions (effective or not) in the repository for a key:
	  
	  keyDefList = dlmService.getAllKeyDefinitionsForKey(keyAccessOptions, key01);
	  assertNotNull("All keyDefs for key01 are null", keyDefList);
	  assertEquals(5, keyDefList.size());
	  
	  // Get the effective definition for a key in a specific context:
	  
	  keyDef = dlmService.getKeyDefinition(keyAccessOptions, keydefContext, key01);
	  assertNotNull(keyDef);
	  assertEquals(key01, keyDef.getKey());
	  
	  // Get key definitions based on filtering spec:
	  
	  KeyAccessOptions kaoNotWindows = new KeyAccessOptions();
	  kaoNotWindows.addExclusion("platform", "windows");
	  
	  KeyAccessOptions kaoNotOsx = new KeyAccessOptions();
	  kaoNotOsx.addExclusion("platform", "osx");
	  
	  KeyAccessOptions kaoNotOsxOrWin = new KeyAccessOptions();
	  kaoNotOsxOrWin.addExclusion("platform", "osx");
	  kaoNotOsxOrWin.addExclusion("platform", "windows");
	  
	  DitaKeyDefinition keyDefOsx = dlmService.getKeyDefinition(kaoNotWindows, keydefContext, key01);
	  assertNotNull(keyDefOsx);
	  assertEquals(keyDefOsx, keyDef); // Should be same because OSX keydef is first in map.
	  
	  assertTrue(keyDefOsx.getDitaPropsSpec().equals(keyDef.getDitaPropsSpec()));
	  
	  DitaKeyDefinition keyDefWindows = dlmService.getKeyDefinition(kaoNotOsx, keydefContext, key01);
	  assertFalse(keyDefOsx.equals(keyDefWindows));
	  assertFalse(keyDefOsx.getDitaPropsSpec().equals(keyDefWindows.getDitaPropsSpec()));
	  
 	  // Get all the key definitions for a key in a specific context:
	  
	  keyDefList = dlmService.getAllKeyDefinitionsForKey(keyAccessOptions, keydefContext, key01);
	  assertNotNull(keyDefList);
	  assertEquals(5, keyDefList.size());
	  
	  DitaResource res; 
	  DitaElementResource elemRes;
	  URL resUrl;
	  
	  res = dlmService.getResource(keyAccessOptions, keydefContext, key01);
	  assertNotNull(res);
	  
	  assertTrue("Expected an element resource", res instanceof DitaElementResource);
	  elemRes = (DitaElementResource)res;
	  
	  Element resElem = elemRes.getElement();
	  assertNotNull("Resource element is null from element resource", resElem);

	  resUrl = res.getUrl();
	  assertNotNull("Resource URL is null", resUrl);

	  res = dlmService.getResource(keyAccessOptions, keydefContext, key02);
	  assertNotNull(res);
	  
	  assertFalse("Expected non-Element resource", res instanceof DitaElementResource);
	  resUrl = res.getUrl();
	  assertNotNull(resUrl);

	  // Check if key is defined:
	  
	  assertTrue(dlmService.isKeyDefined(key01));
	  assertTrue(dlmService.isKeyDefined(key01, keydefContext));
	  assertFalse(dlmService.isKeyDefined("not-a-key"));
	  assertFalse(dlmService.isKeyDefined("not-a-key", keydefContext));

}
  
  public void testIdTargetManagementApi() throws Exception {
	  
	  // There are three modes for getting lists of potential target
	  // elements with IDs: domain-wide, CA-scoped, and map-scoped.

	  List<DitaIdTarget> targets;
	  DitaIdTarget target;
	  DitaClass ditaClass;
	  List<String> typeList;

	  KeyAccessOptions keyAccessOptions = new KeyAccessOptions();

	  // Domain (repository)-wide:
	  
	  targets = dlmService.getIdTargets(keyAccessOptions);
	  assertNotNull(targets);
	  assertEquals(10, targets.size()); // FIXME: Actual count will depend on test data yet to be fleshed out.

	  target = targets.get(0);
	  assertNotNull(target.getId());
	  assertNotNull((String)target.getTagName());
	  assertNotNull((Document)target.getDocument());

	  assertTrue(target.isTopic());
	  assertFalse(target.isTopicComponent());
	  assertFalse(target.isMapComponent());
	  
	  ditaClass = target.getDitaClass(); 
	  assertNotNull(ditaClass);
	  assertNotNull(ditaClass.getClassValue());
	  assertNotNull(ditaClass.getBaseType());
	  assertNotNull((String)ditaClass.getLastType());
	  typeList = ditaClass.getTypes();
	  assertNotNull(typeList);
	  assertEquals(ditaClass.getBaseType(), typeList.get(0));
	  assertEquals(ditaClass.getLastType(), typeList.get(typeList.size() - 1));
	  
	  assertFalse(ditaClass.isDomainType());
	  assertTrue(ditaClass.isStructuralType());
	  
	  assertTrue(ditaClass.isType(dlmService.DITA_TYPE_TOPIC));
	  assertFalse(ditaClass.isType(dlmService.DITA_TYPE_MAP));
	  
	  assertTrue(ditaClass.isType("topic/topic"));
	  assertFalse(ditaClass.isType("map/map"));
	  
	  // Now get a single target by ID and topic:
	  
	  Document topicMo = target.getDocument();
	  String topicId = "topic-01";
	  String elemId = "elem-01";
	  	  
	  target = dlmService.getIdTarget(keyAccessOptions, topicMo, topicId, elemId);
	  assertNotNull(target);
	  
	  // Map-scoped:
	  
	  DitaKeyDefinitionContext keydefContext = dlmService.registerRootMap(rootMap);
	  assertNotNull(keydefContext);
	  
}

  
  public void testKeyWhereUsed() throws Exception {
	  // get DOM for the rootMap.
	  
	  DitaKeySpace keySpace; 

	  // Map document contains 6 topicrefs, of which 5 define keys.
	  
	  // Test management of key space registry and handling of out-of-date
	  // key spaces.
	  
	  KeyAccessOptions keyAccessOptions = new KeyAccessOptions();
	  
	  
	  DitaKeyDefinitionContext keydefContext = dlmService.registerRootMap(rootMap);
	  assertNotNull(keydefContext);
	  DitaKeyDefinitionContext candKeydefContext = dlmService.getKeyDefinitionContext(rootMap);
	  assertEquals(keydefContext, candKeydefContext);
	  
	  keySpace = dlmService.getKeySpace(keyAccessOptions, keydefContext);
	  assertNotNull(keySpace);
	  assertEquals(rootMap.getDocumentURI(), keySpace.getRootMap(keyAccessOptions).getDocumentURI());

	  // Key references:
	  
	  DitaReference ref;
	  List<DitaReference> refs;
	  Document topic01 = null;
	  
	  refs = dlmService.getKeyWhereUsed(keyAccessOptions, key01);
	  assertNotNull(refs);
	  assertEquals(2, refs.size());
	  
	  
	  refs = dlmService.getKeyWhereUsed(keyAccessOptions, key01, keydefContext);
	  assertNotNull(refs);
	  assertEquals(2, refs.size());
	  
	  // Key references limited via filter:
	  
	  DitaResultSetFilter filter;
	  filter = new DitaFilterByType("topic/keyword");
	  refs = dlmService.getKeyWhereUsed(keyAccessOptions, key01, filter);
	  assertNotNull(refs);
	  assertEquals(1, refs.size());
	  refs = dlmService.getKeyWhereUsed(keyAccessOptions, key01, filter, topic01);
	  assertNotNull(refs);
	  assertEquals(1, refs.size());
	  
	  ref = refs.get(0);
	  assertNotNull(ref);
	  
	  assertEquals(true, ref.isDitaElement());
	  assertEquals(false, ref.isTopicRef());
	  Element elem;
	  
	  elem = ref.getElement();
	  assertNotNull(elem);
	  assertTrue(elem.hasAttribute("class"));
	  assertTrue(elem.getAttribute("class").contentEquals(" topic/keyword")); // Note: no trailing slash to work around ML 3.2 bug
	  
	  
	  // FIXME: Need more tests for the detailed properties of key definitions and 
	  // resources, e.g., navigation titles, titles, etc.
	  
	  // Where-used for elements with IDs:
	  
	  DitaElementResource potentialTarget;
	  
	  List<Document> usedBy;
	  
	  Document targetTopic = null;
	  // FIXME: construct doc from  topic01Url

	  // Target is a topic that is the root element of its containing MO:
	  potentialTarget = dlmService.constructDitaElementResource(targetTopic);
	  assertNotNull(potentialTarget);
	  assertNotNull(potentialTarget.getElement());
	  assertTrue(DitaUtil.isDitaTopic(potentialTarget.getElement()));
	  
	  // Get direct uses anywhere in the repository:
	  usedBy = dlmService.getWhereUsed(keyAccessOptions, potentialTarget);
	  assertNotNull(usedBy);
	  assertEquals(1, usedBy.size());
	  
	  // Get direct uses within a context:
	  
	  usedBy = dlmService.getWhereUsed(keyAccessOptions, potentialTarget, keydefContext);
	  assertNotNull(usedBy);
	  assertEquals(1, usedBy.size());
	  
	  usedBy = dlmService.getWhereUsedByKey(keyAccessOptions, potentialTarget, keydefContext);
	  assertNotNull(usedBy);

  
	  // Get the key definitions that point to the specified target:
	  
	  List<DitaKeyDefinition> keyBindings;
	  keyBindings = dlmService.getKeyBindings(keyAccessOptions, potentialTarget);
	  assertNotNull(keyBindings);
	  
	  keyBindings = dlmService.getKeyBindings(keyAccessOptions, potentialTarget, keydefContext);
	  assertNotNull(keyBindings);
	  
}
  
}
