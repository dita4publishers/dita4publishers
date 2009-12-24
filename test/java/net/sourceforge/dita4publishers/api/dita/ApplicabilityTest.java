package net.sourceforge.dita4publishers.api.dita;

import java.net.URI;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import net.sourceforge.dita4publishers.impl.dita.DitavalSpecImpl;
import net.sourceforge.dita4publishers.impl.ditabos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaUtil;
import net.sourceforge.dita4publishers.impl.ditabos.DomUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;


public class ApplicabilityTest
  extends TestCase
{
  public static Test suite() 
  {
    TestSuite suite = new TestSuite(ApplicabilityTest.class);
    return suite; 
  }


	URL catalogManagerProperties = getClass().getResource("/resources/CatalogManager.properties");
	URL rootMapUrl = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/link_test_01.ditamap");
	URL topic01Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_01.xml");
	URL topic03Url = getClass().getResource("/resources/xml_data/docs/dita/link_test_01/topics/topic_03.xml");
	Document rootMap = null;
	BosConstructionOptions bosOptions = null;
	
	private static final Log log = LogFactory.getLog(ApplicabilityTest.class);

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

  public void testDitavalSpec() throws Exception {
	  DitavalSpec ditavalSpec = new DitavalSpecImpl();
	  
	  assertFalse(ditavalSpec.isExcluded("someprop", "anyvalue"));

	  ditavalSpec.addExclusion(null, null); // Default for any property/value pair
	  ditavalSpec.addExclusion("prop1", null); // Default for any value of property "prop1"
	  ditavalSpec.addInclusion("prop1", "value1"); // Default for any value of property "prop1"
	  ditavalSpec.addInclusion("prop2", null); // Default for any value of property "prop1"
	  ditavalSpec.addExclusion("prop2", "value1");
	  
	  assertTrue(ditavalSpec.isExcluded("someprop", "anyvalue"));
	  assertTrue(ditavalSpec.isExcluded("prop1", "anyvalue"));
	  assertFalse(ditavalSpec.isExcluded("prop1", "value1"));
	  assertFalse(ditavalSpec.isExcluded("prop2", "mostvalues"));
	  assertTrue(ditavalSpec.isExcluded("prop2", "value1"));
  }
  
  public void testDitaPropsSpec() throws Exception {
	  DitaPropsSpec propsSpec;
	  propsSpec = new DitaPropsSpec();
	  propsSpec.addPropValue("prop1", "value1");
	  propsSpec.addPropValue("prop1", "value2");
	  propsSpec.addPropValue("prop2", "value3");
	  Set<String> propNames = propsSpec.getProperties();
	  assertNotNull(propNames);
	  assertEquals(2, propNames.size());
	  assertTrue(propNames.contains("prop1"));
	  assertTrue(propNames.contains("prop2"));
	  
	  Set<String> values = propsSpec.getPropertyValues("prop1");
	  assertNotNull(values);
	  assertEquals(2, values.size());
	  assertTrue(values.contains("value1"));
	  assertTrue(values.contains("value2"));
	  
	  values = propsSpec.getPropertyValues("prop2");
	  assertTrue(values.contains("value3"));
	  
	  DitaPropsSpec propsSpec2 = new DitaPropsSpec();
	  DitaPropsSpec propsSpec3 = new DitaPropsSpec();
	  
	  assertFalse(propsSpec.equals(propsSpec2));
	  assertTrue(propsSpec2.equals(propsSpec3));
  }
  
  public void testParsePropsAtts() throws Exception {
	  Element elem;
	  DitaPropsSpec propsSpec;
	  DitaPropsSpec propsSpec2;
	  DitavalSpec ditavalSpec = new DitavalSpecImpl();

	  Element docElem = rootMap.getDocumentElement();
	  elem = (Element)docElem.getElementsByTagName("topicref").item(0);
	  
	  
	  propsSpec = DitaUtil.constructPropsSpec(elem);
	  assertNotNull(propsSpec);
	  propsSpec2 = DitaUtil.constructPropsSpec(elem);
	  
	  assertTrue(propsSpec.equals(propsSpec2));
	  
	  // Uses generalized form of props attribute: 
	  elem = (Element)docElem.getElementsByTagName("topicref").item(1);
	  
	  propsSpec2 = DitaUtil.constructPropsSpec(elem);
	  assertNotNull(propsSpec2.getProperties());
	  assertNotNull(propsSpec2.getPropertyValues("platform"));
	  
	  assertFalse(propsSpec.equals(propsSpec2));
	  assertTrue(propsSpec2.getPropertyValues("platform").contains("windows"));
	  assertFalse(propsSpec2.getPropertyValues("platform").contains("osx"));
  }

  
}
