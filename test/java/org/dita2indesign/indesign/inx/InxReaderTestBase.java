/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.List;

import junit.framework.TestCase;

import org.dita2indesign.indesign.inx.InxReaderTests;
import org.dita2indesign.indesign.inx.model.Rectangle;

/**
 *
 */
public abstract class InxReaderTestBase extends TestCase {

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

	protected String iGeo = "x_19_l_1_l_4_l_2_D_36_D_-360_l_2_D_36_D_-175.2_l_2_D_309.8181818181818_D_-175.2_l_2_D_309.8181818181818_D_-360_b_f_D_36_D_360_D_309.8181818181818_D_-175.2_D_1_D_0_D_0_D_1_D_0_D_0";
	protected String iGeoGBB = "x_1D_l_1_l_4_l_2_D_36_D_-360_l_2_D_36_D_-175.2_l_2_D_309.8181818181818_D_-175.2_l_2_D_309.8181818181818_D_-360_b_f_D_36_D_360_D_309.8181818181818_D_-175.2_D_1_D_2_D_3_D_4_D_5_D_6_D_36_D_360_D_309.8181818181818_D_-175.2";
	protected static final URL inxData = InxReaderTests.class.getResource("/resources/idd_cs3_test_01.inx");
	protected static final URL inxData2 = InxReaderTests.class.getResource("/resources/BB_Template_1.inx");
	protected static final URL geoTest = InxReaderTests.class.getResource("/resources/geometry-test.inx");
	protected static final URL linkTest = InxReaderTests.class.getResource("/resources/link_test_01.inx");
	protected static final URL ddgTemplate = InxReaderTests.class.getResource("/resources/ddgTemplate-LP.inx");
	protected static URI incopyArticle01 = null;
	
	static {
		try {
			incopyArticle01 = InxReaderTests.class.getResource("/resources/incopy_article_01.incx").toURI();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 
	 */
	public InxReaderTestBase() {
		super();
	}

	/**
	 * @param name
	 */
	public InxReaderTestBase(String name) {
		super(name);
	}

	/**
	 * @param recs
	 * @param allRecs
	 */
	protected void getAllRecs(List<Rectangle> recs, List<Rectangle> allRecs) {
		for (Rectangle rec : recs) {
			allRecs.add(rec);
			List<Rectangle> subRecs = rec.getRectangles();
			getAllRecs(subRecs, allRecs);
		}
		
	}

	public void setUp() throws Exception {
		assertNotNull(inxData);
		assertNotNull(inxData2);
		assertNotNull(geoTest);
		assertNotNull(linkTest);
		
	}

}