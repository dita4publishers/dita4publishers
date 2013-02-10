/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx;

import java.io.File;
import java.util.Iterator;
import java.util.List;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.model.InDesignComponent;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.InDesignObject;
import org.dita2indesign.indesign.inx.model.InxHelper;
import org.dita2indesign.indesign.inx.model.MasterSpread;
import org.dita2indesign.indesign.inx.model.Page;
import org.dita2indesign.indesign.inx.model.PageSideOption;
import org.dita2indesign.indesign.inx.model.Rectangle;
import org.dita2indesign.indesign.inx.model.Spread;
import org.dita2indesign.indesign.inx.model.Story;
import org.dita2indesign.indesign.inx.model.TextFrame;
import org.dita2indesign.indesign.inx.model.TextStyleRange;
import org.dita2indesign.indesign.inx.model.TransformationMatix;
import org.dita2indesign.indesign.inx.writers.InxWriter;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 *
 */
public class ComplexPageCreationTest extends InxReaderTestBase {
	Logger logger = Logger.getLogger(ComplexPageCreationTest.class);
	private InDesignDocument inDesignDoc;

	public static Test suite() {
		TestSuite suite = new TestSuite(ComplexPageCreationTest.class);
		return suite;
	}
	
	public void setUp() throws Exception {
		super.setUp();
		inDesignDoc = new InDesignDocument();
		inDesignDoc.load(ddgTemplate);
		
		
	}
	
	public void testCreateNewComplexPage() throws Exception {
		String masterSpreadName = "B-Meditation";
		String INITIAL_FRAME_LABEL = "initialFrame";
		
	    MasterSpread masterSpread = inDesignDoc.getMasterSpread(masterSpreadName);
	    assertNotNull("Failed to find master spread", masterSpread);
	    
	    int overrideableFrameCount = 0;
	    for (TextFrame frame : masterSpread.getAllFrames()) {
	    	if (frame.isOverrideable()) overrideableFrameCount++;
	    }
	    System.out.println("Overrideable frame count; " + overrideableFrameCount);
	    
	    Spread spread = null;
	    Page page = null;
	    
        spread = inDesignDoc.getSpread(0);
    	page = spread.getOddPage();
    	assertNotNull("Didn't get a page", page);
    	
    	assertEquals(spread, page.getSpread());
    	
    	// See if we can delete the first page:
    	
    	assertEquals("Expected 1 pages", 1, spread.getPages().size());
    	spread.addPage(2);
    	assertEquals("Expected 2 pages", 2, spread.getPages().size());
    	page = spread.getEvenPage();
    	assertNotNull("Expected an even page", page);
    	spread.removePage(page);
    	assertEquals("Expected only 1 page", 1, spread.getPages().size());
    	page = spread.getEvenPage();
    	assertNull("Expected no even page", page);
    	page = spread.getOddPage();
    	assertNotNull("Expected an odd page");
    	
		List<Page> pages = spread.getPages();
		int pageIndex = pages.indexOf(page);
		
		assertEquals(0,pageIndex);
		
		InDesignObject obj = inDesignDoc.getObject("u226");
		assertNotNull(obj);
		
		// Check the page geometry:
		
		assertEquals(576.0, page.getWidth());
		assertEquals(783.0, page.getHeight());
		TransformationMatix matrix = page.getTransformationMatrix();
		assertEquals(0.0, matrix.getXTranslation()); // Odd pages have no horizontal translation.
		assertEquals(-391.5, matrix.getYTranslation()); // Spread origin is center of spread, so Y translate is -(H/2)
		
		page.setAppliedMaster(masterSpread);
		page.overrideMasterSpreadObjects();

		// Verify that overridden threaded frames do not still have the master spread as their 
		// parent spread:
		
		Spread master = page.getAppliedMaster();
		assertNotNull(master);
		spread = page.getSpread();
		for (TextFrame frame : page.getAllFrames()) {
			TextFrame next = frame.getNextInThread();

			while (next != null) {
				assertSame(spread, (Spread)next.getParent());
				assertNotSame(master, (Spread)next.getParent());
				TextFrame prev = frame.getPreviousInThread();
				if (prev != null) {
					assertSame(spread, (Spread)prev.getParent());
					assertNotSame(master, (Spread)prev.getParent());
					TextFrame first = frame.getFirstFrameInThread();
					assertSame(spread, (Spread)first.getParent());
					assertNotSame(master, (Spread)first.getParent());
					TextFrame last = frame.getLastFrameInThread();
					assertSame(spread, (Spread)last.getParent());
					assertNotSame(master, (Spread)last.getParent());
				}

				next = next.getNextInThread();
			}
		}
		
		
	    // Now look for a text frame with the label "initialFrame" or
	    // just get the first text frame in the list of frames.
	    String targetLabel = INITIAL_FRAME_LABEL + (page.getPageSide().equals(PageSideOption.LEFT_HAND)? "Even" : "Odd");
	    TextFrame frame = InxHelper.getFrameForLabel(spread, targetLabel);
	    assertNotNull("Did not find frame with label \"" + targetLabel + "\"", frame);
	    
	    assertTrue("Expected some children", frame.getChildren().size() > 0);
	    InDesignComponent wrapPrefs = null;
	    for (InDesignComponent child : frame.getChildren()) {
	    	if ("ctxw".equals(child.getInxTagName())) {
	    		wrapPrefs = child;
	    		break;
	    	}
	    }
	    
	    assertNotNull("Failed to find wrap preferences child.", wrapPrefs);

	    // Make the story
	    assertNotNull("Didn't get InCopy article resource", incopyArticle01);
	    Story incxStory = InxHelper.getStoryForIncxDoc(inDesignDoc, incopyArticle01);
	    int txsrCnt = 0;
	    Iterator<TextStyleRange> iter = incxStory.getTextStyleRangeIterator();
	    while (iter.hasNext()) {
	    	iter.next();
	    	txsrCnt++;	    	
	    }
	    assertTrue("Expected some text ranges", txsrCnt > 0);
	    assertNotNull("Failed to get story from InCopy aricle", incxStory);
        frame.setParentStory(incxStory);
        assertEquals("Story doesn't match", incxStory, frame.getParentStory());
        
		File inxFile = File.createTempFile("testWriteInxFile_", ".inx");
		System.err.println("Temp file: " + inxFile.getAbsolutePath());
		
		InxWriter writer = new InxWriter(inxFile);
		writer.write(inDesignDoc);
		assertTrue("File does not exist", inxFile.exists());
		assertTrue("File has no data", inxFile.length() > 0);

		// logger.info("inxXML=" + inxXml);
		assertTrue("File is not long enough", inxFile.length() > 1000);
		
		// Now load the file we just wrote and check it:
		
		Document inxDom = DataUtil.constructNonValidatingDocumentBuilder().parse(inxFile);
		assertNotNull("inxDom is null", inxDom);
		Element docElem = inxDom.getDocumentElement();
		assertNotNull("No document element", docElem);
		assertEquals("Expected <docu>", "docu", docElem.getNodeName());
		InDesignDocument newDoc = new InDesignDocument();
		
		newDoc.load(docElem);
		
		assertEquals("Expected one spread", 1, newDoc.getSpreads().size());
		int originalChildCount = spread.getRectangles().size();
 		spread = newDoc.getSpread(0);
		assertNotNull("Expected a spread", spread);
		//assertEquals("Child count does not match original", originalChildCount, spread.getChildren().size());
		//assertEquals("Frame count did not match", overrideableFrameCount, spread.getAllFrames().size());

		page = spread.getOddPage();
		assertNotNull("Expected a page", page);
		page.overrideMasterSpreadObjects();
		List<Rectangle> rects = page.getRectangles();
		assertNotNull(rects);
		//assertEquals("Overridden frames doesn't match expected count", overrideableFrameCount, rects.size());


	}
	

}
