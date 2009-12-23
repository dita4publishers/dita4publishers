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
import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;
import net.sourceforge.dita4publishers.impl.ditabos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.impl.ditabos.DomUtil;

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
	  BoundedObjectSet mapBos = DitaBosHelper.calculateMapBos(bosOptions,log, rootMap);
	  assertNotNull(mapBos);
	  // mapBos.reportBos(log);
	  assertEquals(7, mapBos.size());
	  
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
	  assertEquals(9, allKeyDefs.size());
	  
  }
  
  
}
