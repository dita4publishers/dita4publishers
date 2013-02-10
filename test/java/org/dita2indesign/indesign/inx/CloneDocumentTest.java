/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;

import org.dita2indesign.indesign.inx.CloneDocumentTest;
import org.dita2indesign.indesign.inx.InxReaderTestBase;
import org.dita2indesign.indesign.inx.model.InDesignDocument;

/**
 *
 */
public class CloneDocumentTest extends InxReaderTestBase {
	Logger logger = Logger.getLogger(CloneDocumentTest.class);

	public static Test suite() {
		TestSuite suite = new TestSuite(CloneDocumentTest.class);
		return suite;
	}
	
	public void setUp() throws Exception {
		super.setUp();
	}
	
	public void testCloneDocument() throws Exception {
		InDesignDocument doc = new InDesignDocument();
		doc.load(inxData2);
		
		logger.debug("*******************************************************************");
		logger.debug("Loading cloned data into new document");

		InDesignDocument cloned = new InDesignDocument(doc, true);
		assertEquals("Expected two master spreads", 3, cloned.getMasterSpreads().size());
		assertEquals("Expected zero body spreads", 0, cloned.getSpreads().size());
		
	}



}
