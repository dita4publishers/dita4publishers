/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import org.dita2indesign.indesign.inx.DocumentObjectCreationTests;
import org.dita2indesign.indesign.inx.InxReaderTestBase;
import org.dita2indesign.indesign.inx.model.Image;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.InDesignObject;
import org.dita2indesign.indesign.inx.model.InxUnit;
import org.dita2indesign.indesign.inx.model.Link;
import org.dita2indesign.indesign.inx.model.MasterSpread;
import org.dita2indesign.indesign.inx.model.Page;
import org.dita2indesign.indesign.inx.model.Rectangle;
import org.dita2indesign.indesign.inx.model.Spread;
import org.dita2indesign.indesign.inx.model.TextWrapPreferences;
import org.dita2indesign.indesign.inx.writers.InxWriter;
import org.dita2indesign.util.DataUtil;

/**
 *
 */
public class DocumentObjectCreationTests extends InxReaderTestBase {
	Logger logger = Logger.getLogger(DocumentObjectCreationTests.class);
	private InDesignDocument doc;
	private InDesignDocument cloned;

	public static String readFileToString(File inFile) throws Exception {
	    BufferedReader reader = new BufferedReader(new FileReader(inFile));
	    StringBuilder inString = new StringBuilder();
	    String line = reader.readLine();
	    while (line != null) {
	    	inString.append(line);
	    	line = reader.readLine();
	    }
	    String newXmlString = inString.toString();
	    return newXmlString;
	}

	public static Test suite() {
		TestSuite suite = new TestSuite(DocumentObjectCreationTests.class);
		return suite;
	}
	
	public void setUp() throws Exception {
		super.setUp();
		doc = new InDesignDocument();
		doc.load(inxData2);
		
		logger.info("------------------------------------------------------------------");
		logger.info("setUp(): Cloning InDesign document " + doc.getDataSource().getDocumentURI() + "...");
		cloned = new InDesignDocument(doc, true);
		logger.info("setUp(): Cloning complete.");
		logger.info("setUp(): child objects of cloned document: " + cloned.reportChildObjects());
		logger.info("------------------------------------------------------------------");
		assertEquals("Object IDs should be equal", doc.getId(), cloned.getId());
		assertEquals("Expected two master spreads", 3, cloned.getMasterSpreads().size());
//		assertEquals("Expected zero body spreads", 0, cloned.getSpreads().size());
		
	}
	
	public void testCreateSpreads() throws Exception {
	
		
		Spread newSpread;
		
		String masterSpreadName = "RT-BB Right";
		newSpread = cloned.newSpread(masterSpreadName);
		assertNotNull("New spread is null", newSpread);
		
		assertEquals("No parent for spread", cloned, newSpread.getParent());
		
		MasterSpread master = cloned.getMasterSpread(masterSpreadName);
		assertNotNull("Didn't get the master spread", master);
		assertEquals("Masters aren't equal", master, newSpread.getMasterSpread());
		assertEquals("Expected 1 page in master spread", 1, master.getPages().size());
		
		assertEquals("Expected no pages in new spread", 0, newSpread.getPages().size());
		
		Page newPage = newSpread.addPage(10);
		assertNotNull("Got a null new page", newPage);
	
		Rectangle rect;
		
		System.err.println("Objects in doc:" + doc.reportObjectsById());
		rect = (Rectangle)doc.getObject("u73c1");
		assertNotNull("Got null rectangle", rect);
		InDesignObject clonedObj = cloned.clone(rect);
		assertNotNull("Got null clone", clonedObj);
		Rectangle clonedRect = (Rectangle)clonedObj;
		assertTrue("IDs should not match", !rect.getId().equals(clonedRect.getId()));
		
		newSpread.addRectangle(clonedRect);
		
		assertTrue("Page does not contain rectangle", newPage.contains(clonedRect));
		
	}
	
	public void testWriteInxFile() throws Exception {
		// Create a new document with a page with a frame
		// copied from the template document:
		
		Spread newSpread;		
		String masterSpreadName = "RT-BB Right";
		newSpread = cloned.newSpread(masterSpreadName);
		MasterSpread master = cloned.getMasterSpread(masterSpreadName);
		Page newPage = newSpread.addPage(10);
	
		Rectangle rect;
		
		rect = (Rectangle)doc.getObject("u73c1");
		InDesignObject clonedObj = cloned.clone(rect);
		Rectangle clonedRect = (Rectangle)clonedObj;		
		newSpread.addRectangle(clonedRect);
		
		// Now serialize the cloned document to INX:
		
		File inxFile = File.createTempFile("testWriteInxFile_", ".inx");
		
		InxWriter writer = new InxWriter(inxFile);
		writer.write(cloned);
		assertTrue("File does not exist", inxFile.exists());
		assertTrue("File has no data", inxFile.length() > 0);
		String inxXml = readFileToString(inxFile);
		logger.info("inxXML=" + inxXml);
		assertTrue("File is not long enough", inxFile.length() > 1000);
		Document inxDom = DataUtil.constructNonValidatingDocumentBuilder().parse(inxFile);
		assertNotNull("inxDom is null", inxDom);
		Element docElem = inxDom.getDocumentElement();
		assertNotNull("No document element", docElem);
		assertEquals("Expected <docu>", "docu", docElem.getNodeName());
		
	}
	
	public void testCreateNewRectangle() throws Exception {
		Rectangle rect;
		
		rect = cloned.newRectangle();
		assertNotNull("Got null rectangle", rect);
		rect.setWidth(100.0);
		assertEquals("Width not correct", 100.0, rect.getGeometry().getWidth());
		rect.setHeight(200.0);
		assertEquals("Height not correct", 200.0, rect.getGeometry().getHeight());
		
	}
	
	public void testCreateNewImage() throws Exception {
		Image image = doc.newImage();
		assertNotNull("Got a null image", image);
		Link link = doc.newLink();
		String linkFn = "c:\\foo\\bar\\bar.jpg";
		link.setWindowsFileName(linkFn);
		image.setItemLink(link);
		assertEquals(link, image.getItemLink());
		TextWrapPreferences twPrefs = image.getTextWrapPreferences();
		assertNotNull("Null text wrap prefs", twPrefs);
		assertTrue("Values did not compare as equal", new InxUnit(0.0).equals(twPrefs.getTextWrapOffset().get(0)));
	}
	

}
