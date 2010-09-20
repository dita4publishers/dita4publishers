package org.dita2indesign.indesign.inx;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.model.Box;
import org.dita2indesign.indesign.inx.model.DocumentPreferences;
import org.dita2indesign.indesign.inx.model.Geometry;
import org.dita2indesign.indesign.inx.model.InDesignComponent;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.MasterSpread;
import org.dita2indesign.indesign.inx.model.Page;
import org.dita2indesign.indesign.inx.model.PageSideOption;
import org.dita2indesign.indesign.inx.model.Path;
import org.dita2indesign.indesign.inx.model.PathPoint;
import org.dita2indesign.indesign.inx.model.Rectangle;
import org.dita2indesign.indesign.inx.model.Spread;
import org.dita2indesign.indesign.inx.model.Story;
import org.dita2indesign.indesign.inx.model.TextFrame;
import org.dita2indesign.indesign.inx.model.TextStyleRange;
import org.dita2indesign.indesign.inx.model.TransformationMatix;


/**
 * Test ability to read an INX file.
 */
public class InxReaderTests extends InxReaderTestBase
{
	Logger logger = Logger.getLogger(this.getClass());

	public static Test suite() {
		TestSuite suite = new TestSuite(InxReaderTests.class);
		return suite;
	}
	
	public void setUp() throws Exception {
		super.setUp();
	}
	
	public void testReadInx() throws Throwable {
		InDesignDocument doc = new InDesignDocument();
		doc.load(inxData);
		
		DocumentPreferences docPrefs;
		docPrefs = doc.getDocumentPreferences();
		assertNotNull(docPrefs);
		assertEquals("Unexpected page height value", 792.0, docPrefs.getPageHeight());
		assertEquals("Unexpected page width value", 612.0, docPrefs.getPageWidth());
		
		Iterator<Story> iter = doc.getStoryIterator();
		assertNotNull(iter);
		assertTrue(iter.hasNext());
		Story story = iter.next();
		assertNotNull(story.getId());
		assertEquals("ud6", story.getId());
		assertEquals(doc.getObject("ud6"), story);
		Iterator<TextStyleRange> trIter = story.getTextRunIterator();
		assertTrue(trIter.hasNext());
		int cnt = 0;
		InDesignComponent comp;
		TextStyleRange run;
		while (trIter.hasNext()) {
			comp = trIter.next();
			assertTrue(comp instanceof TextStyleRange);
			run = (TextStyleRange)comp;
			assertTrue(run.hasProperty("prst"));
			assertTrue(run.hasProperty("crst"));
			cnt++;
			if (cnt == 4) {
				String text = run.getText();
				assertTrue("Expected specific text for text run " + cnt + ", got \"" + text + "\"", text.startsWith(" 1866 was marked by a bizarre development"));
			}
		}
		assertEquals(7, cnt);
 	}
	
	/**
	 * Tests the ability to access the page masters and frames within those page
	 * masters.
	 * @throws Throwable
	 */
	public void testFrameProperities() throws Throwable {
		InDesignDocument doc = new InDesignDocument();
		Spread spread;
		List<TextFrame> frames;
		InDesignComponent frame;

		doc = new InDesignDocument();
		doc.load(geoTest);
		
		spread = doc.getSpreads().get(0);
		assertNotNull("Didn't find spreads[0]", spread);
		frames = spread.getAllFrames();
		assertNotNull("Got null list of frames", frames);
		assertTrue("Got empty list of frames, expected at least 8", frames.size() > 0);
		frame = frames.get(0);
		
		assertNotNull("No parent for frame", frame.getParent());
		assertEquals("Wrong parent for frame", spread, frame.getParent());
		String label = frame.getLabel();
		assertNotNull("Got null label", label);
 	}
	
	/**
	 * Tests the ability to access the page masters and frames within those page
	 * masters.
	 * @throws Throwable
	 */
	public void testPageProperities() throws Throwable {
		InDesignDocument doc = new InDesignDocument();
		MasterSpread master;
		Spread spread;
		Collection<Page> pages;
		Page page;
		List<TextFrame> frames;
		String masterName;
		
		masterName = "A-Master";
		doc.load(inxData);
		master = doc.getMasterSpread(masterName);
		assertNotNull(master);
		pages = master.getPages();
		// Document inxData uses facing pages, inxData2 does not.
		page = master.getEvenPage();
		assertNotNull(page);
		assertEquals("Page does not report left hand",
				PageSideOption.LEFT_HAND, page.getPageSide());
		page = master.getOddPage();
		assertNotNull(page);
		assertEquals("Page does not report right hand",
  					 PageSideOption.RIGHT_HAND, page.getPageSide());
		// geoTest has lots of frames on first spread
		doc = new InDesignDocument();
		doc.load(geoTest);
		
		spread = doc.getSpreads().get(0);
		assertNotNull("Didn't find spreads[0]", spread);
		frames = spread.getAllFrames();
		assertNotNull("Got null list of frames", frames);
		assertTrue("Got empty list of frames, expected at least 6", frames.size() > 0);
		page = spread.getOddPage();
		assertNotNull("Didn't get an odd page from the master spread", page);
		assertEquals("Page did not return expected parent", spread, page.getParent());

		frames = page.getAllFrames();
		assertNotNull("Got a null frame list from getAllFrames()", frames);
		assertTrue("No frames in frame list", frames.size() > 0);
		assertEquals("Expected 5 frames on page, found " + frames.size(), 5, frames.size());
		
	}
	
	public void testBoxOperations() throws Exception {
		
		// Values are left, top, right bottom, defining
		// the positions of the four sides.
		String boxData1 = "x_4_D_10_D_20_D_30_D_40";
		String boxData2 = "x_4_D_15_D_20_D_30_D_40";
		String boxData3 = "x_4_D_50_D_20_D_70_D_40";
		String boxData4 = "x_4_D_50_D_50_D_-70_D_-40";
		String boxData5 = "x_4_D_15_D_21_D_29_D_39";
		
		Box box1;
		Box box2;
		Box box3;
		Box box4;
		Box box5;
		
		box1 = new Box(boxData1);
		assertEquals(10.0, box1.getLeft());
		assertEquals(20.0, box1.getTop());
		assertEquals(30.0, box1.getRight());
		assertEquals(40.0, box1.getBottom());

		box2 = new Box(boxData2);
		box3 = new Box(boxData3);
		box4 = new Box(boxData4);
		box5 = new Box(boxData5);
		
		assertTrue("Box 2 should be reported as intersecting box 1", box2.intersects(box1));
		assertTrue("Box 1 should be reported as intersecting box 1", box1.intersects(box2));
		assertFalse("Box 3 should be reported as not intersecting box 1", box3.intersects(box1));
		assertFalse("Box 1 should be reported as not intersecting box 3", box1.intersects(box3));
		assertTrue("Box 4 should be reported as intersecting box 1", box4.intersects(box1));
		assertTrue("Box 1 should be reported as containing box 5", box1.contains(box5));
		
	}
	
	/**
	 * Tests the ability to access the page masters and frames within those page
	 * masters.
	 * @throws Throwable
	 */
	public void testGetPageMasterFrames() throws Throwable {
		InDesignDocument doc = new InDesignDocument();
		doc.load(inxData2);
		Set<String> masterNames = doc.getPageMasterNames();
		assertNotNull(masterNames);
		assertEquals(3, masterNames.size());
		Spread master;
		master = doc.getMasterSpread("LT-BB_Left");
		assertNotNull("Failed to find master frame", master);
		assertEquals("Name isn't as expected", "LT-BB_Left", master.getName());
		Collection<Page> pages;
		pages = master.getPages();
		assertNotNull(pages);
		assertEquals(1, pages.size());
		List<Rectangle> recs;
		List<Rectangle> allRecs = new ArrayList<Rectangle>();
		
		recs = master.getRectangles();
		assertNotNull(recs);
		getAllRecs(recs, allRecs);
		assertEquals(12, allRecs.size());
		
		Rectangle rect;
		rect = recs.get(0);
		Geometry geo;
		
		geo = rect.getGeometry();
		assertNotNull(geo);
		Box box;
		box = geo.getBoundingBox();
		assertNotNull(box);
		

	}
	
	public void testGeometry() throws Exception {
		Geometry geo = new Geometry(iGeo);
		// Expect one path
		List<Path> paths = geo.getPaths();
		assertNotNull(paths);
		assertEquals(1, paths.size());
		Path path = paths.get(0);
		assertNotNull(path);
		List<PathPoint> points = path.getPoints();
		assertNotNull(points);
		assertEquals(4, points.size());
		
		PathPoint point;
		
		// Data for four points:
		// l_2_D_36_D_-360_l_2_D_36_D_-175.2_l_2_D_309.8181818181818_D_-175.2_l_2_D_309.8181818181818_D_-360
		
		point = points.get(0);
		assertEquals(36.0, point.getX());
		assertEquals(-360.0, point.getY());
		
		point = points.get(1);
		assertEquals(36.0, point.getX());
		assertEquals(-175.2, point.getY());
		
		point = points.get(2);
		assertEquals(309.8181818181818, point.getX());
		assertEquals(-175.2, point.getY());
		
		point = points.get(3);
		assertEquals(309.8181818181818, point.getX());
		assertEquals(-360.0, point.getY());
		
		assertFalse(path.isOpen());
		
		Box box = geo.getBoundingBox();
		assertNotNull(box);
		
		assertEquals(36.0, box.getLeft());
		assertEquals(360.0, box.getTop());
		assertEquals(309.8181818181818, box.getRight());
		assertEquals(-175.2, box.getBottom());

		geo = new Geometry(iGeoGBB);
		TransformationMatix transformMatrix = geo.getTransformationMatrix();
		assertNotNull("Got a null transformation matrix", transformMatrix);
		assertEquals("Expected 5.0", 5.0, transformMatrix.getXTranslation());
		assertEquals("Expected 6.0", 6.0, transformMatrix.getYTranslation());
		
		box = geo.getGraphicBoundingBox();
		assertNotNull(box);
		assertEquals(36.0, box.getLeft());
		assertEquals(360.0, box.getTop());
		assertEquals(309.8181818181818, box.getRight());
		assertEquals(-175.2, box.getBottom());
		
		double[] values = {1,0,0,1,20,10};
		
		TransformationMatix matrix = new TransformationMatix(values);
		
		Box pbBox;
		pbBox = box.transform(matrix);
		assertNotNull(pbBox);
		assertEquals(56.0, pbBox.getLeft());
		assertEquals(370.0, pbBox.getTop());
		assertEquals(329.8181818181818, pbBox.getRight());
		assertEquals(-165.2, pbBox.getBottom());
		
	}
	
  
}
