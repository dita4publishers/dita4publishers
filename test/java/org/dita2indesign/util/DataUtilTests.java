package org.dita2indesign.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.io.StringBufferInputStream;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;


/**
 * Test ability to read an INX file.
 */
public class DataUtilTests extends TestCase
{
	Logger logger = Logger.getLogger(this.getClass());

	public static Test suite() {
		TestSuite suite = new TestSuite(DataUtilTests.class);
		return suite;
	}
	
	public void setUp() throws Exception {
		super.setUp();
	}
	
	public void testSerializeDom() throws Exception {
		String xmlString = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
		                   "<doc><foo id=\"x\"><bar/><baz/></foo></doc>";
		InputStream inStream = new StringBufferInputStream(xmlString);
		Document dom = DataUtil.constructNonValidatingDocumentBuilder().parse(inStream);
		assertNotNull("DOM is null", dom);
		File resultFile = File.createTempFile("testSerializeDom_", ".xml");
		resultFile.deleteOnExit();
		DataUtil.serializeDomToFile(dom, resultFile);
		assertTrue("File does not exist", resultFile.exists());
		assertTrue("File has no data", resultFile.length() > 0);
	    BufferedReader reader = new BufferedReader(new FileReader(resultFile));
	    StringBuilder inString = new StringBuilder();
	    String line = reader.readLine();
	    while (line != null) {
	    	inString.append(line);
	    	line = reader.readLine();
	    }
	    String newXmlString = inString.toString();
	    logger.info("XML as serialized=" + newXmlString);
	    assertTrue("No XML declaration", newXmlString.startsWith("<?xml version=\"1.0\""));
	    
	}
  
}
