/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx;

import java.util.Collection;
import java.util.List;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;

import org.dita2indesign.indesign.inx.FrameToPageAssignmentTest;
import org.dita2indesign.indesign.inx.InxReaderTestBase;
import org.dita2indesign.indesign.inx.model.Geometry;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.Page;
import org.dita2indesign.indesign.inx.model.Rectangle;
import org.dita2indesign.indesign.inx.model.Spread;
import org.dita2indesign.indesign.inx.model.TextFrame;

/**
 *
 */
public class FrameToPageAssignmentTest extends InxReaderTestBase {
	Logger logger = Logger.getLogger(FrameToPageAssignmentTest.class);

	public static Test suite() {
		TestSuite suite = new TestSuite(FrameToPageAssignmentTest.class);
		return suite;
	}
	
	public void setUp() throws Exception {
		super.setUp();
	}
	
	/**
	 * Tests the correct assignment of frames to pages within a main body spread.
	 * @throws Throwable
	 */
	public void xtestAssignFramesToPages() throws Throwable {
		InDesignDocument doc = new InDesignDocument();
		doc.load(geoTest);
		Spread spread;
		Rectangle rect;
		Page page;
		Collection<Rectangle> rects;
		
		spread = doc.getSpreads().get(0);
		assertNotNull(spread);
		assertTrue("Expected some frames on spread", spread.getAllFrames().size() > 0);
		page = spread.getOddPage();
		assertNotNull("Didn't get an odd page", page);
		rects = page.getRectangles();
		assertEquals("Wrong number of frames on page", 6, rects.size());
		
		spread = doc.getSpreads().get(1);
		assertNotNull(spread);
		page = spread.getEvenPage();
		assertNotNull("Didn't get an even page", page);
		rects = page.getRectangles();
		assertEquals("Wrong number of frames on page", 6, rects.size());
		

	}

	/**
	 * Tests the correct assignment of frames to pages within a master
	 * spread.
	 * @throws Throwable
	 */
	public void testAssignFramesToMasterPages() throws Throwable {
		InDesignDocument doc = new InDesignDocument();
		doc.load(page2FrameTest);
		Spread master;
		Rectangle rect;
		Page page;
		
		
		master = doc.getMasterSpread("A-Master");
		assertNotNull(master);
		page = master.getEvenPage();
		assertNotNull(page);

		System.out.println(" ++++++ ");
		
		System.out.println("Master Spread geometry:");
		System.out.println(master.getGeometry());
		
		List<Rectangle> rects = page.getRectangles();
		
		assertEquals("Wrong number of frames on page", 4, rects.size());
		

	}





}
