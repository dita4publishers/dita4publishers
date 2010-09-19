/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx;

import java.io.File;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;

import org.dita2indesign.indesign.inx.InxReaderTestBase;
import org.dita2indesign.indesign.inx.LinkObjectTests;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.Link;
import org.dita2indesign.indesign.inx.writers.InxWriter;

/**
 * Tests that focus on InDesign links
 */
public class LinkObjectTests extends InxReaderTestBase {
	Logger logger = Logger.getLogger(LinkObjectTests.class);
	private InDesignDocument doc;
	

	public static Test suite() {
		TestSuite suite = new TestSuite(LinkObjectTests.class);
		return suite;
	}
	
	public void setUp() throws Exception {
		super.setUp();
		doc = new InDesignDocument();
		doc.load(linkTest);
		
		
	}

	public void testLinksAreLoaded() {
		List<Link> links = doc.getLinks();
		assertNotNull("Expect non-null links object", links);
//		for (Link link : links) {
//			System.err.println(" Link: " + link.getId() + ", " + link.getName());
//		}
		assertEquals("Expected 6 links", 6, links.size());
		Link link;
		link = (Link)doc.getObject("u144");
		assertNotNull(link);
		assertEquals("Adobe Portable Document Format (PDF)", link.getLinkType());
		assertEquals("svg-test-01.ai", link.getWindowsFileName());
		assertTrue("Mac filename doesn't match name", link.getMacFileName().endsWith(link.getWindowsFileName()));
		Date date = link.getDate();
		assertNotNull(date);
		assertTrue(date.before(Calendar.getInstance().getTime()));
	}

	public void testLinksAreCloned() throws Exception {
		List<Link> links = doc.getLinks();
		assertNotNull("Expect non-null links object", links);
		assertEquals("Expected 6 links", 6, links.size());
//		for (Link link : links) {
//			System.err.println(" Link: " + link.getId() + ", " + link.getName());
//		}
		
		InDesignDocument clonedDoc = new InDesignDocument(doc, false);
		links = clonedDoc.getLinks();
//		for (Link link : links) {
//			System.err.println(" Link: " + link.getId() + ", " + link.getName());
//		}
		assertNotNull("Expect non-null links object", links);
		assertEquals("Expected 6 links", 6, links.size());
		
	}

	public void testLinkLabels() throws Exception {
		List<Link> links = doc.getLinks();
		assertNotNull("Expect non-null links object", links);
		Link link = links.get(0);
		link.insertLabel("moid", "1234");
		assertEquals("1234", link.extractLabel("moid"));
//		File inxFile = File.createTempFile("testLinkLabels_", ".inx");
		File inxFile = new File("/Users/ekimber/temp/testLinkLabels_20668.inx");
		System.err.println("inxFile=" + inxFile.getAbsolutePath());
		
		InxWriter writer = new InxWriter(inxFile);
		writer.write(doc);
		inxFile.deleteOnExit();

	}

}

