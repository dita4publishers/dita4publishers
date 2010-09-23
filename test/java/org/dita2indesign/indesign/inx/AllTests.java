/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx;

import junit.framework.Test;
import junit.framework.TestSuite;

import org.dita2indesign.util.DataUtilTests;

import org.dita2indesign.indesign.inx.DocumentObjectCreationTests;
import org.dita2indesign.indesign.inx.FrameToPageAssignmentTest;
import org.dita2indesign.indesign.inx.InxHelperTests;
import org.dita2indesign.indesign.inx.InxReaderTests;
import org.dita2indesign.indesign.inx.InxValueListTest;
import org.dita2indesign.indesign.inx.LinkObjectTests;

/**
 * All utility tests
 */
public class AllTests extends TestSuite {
	public AllTests (java.lang.String testName) {
		super(testName);
	}

	public static void main(String[] args) {
		junit.textui.TestRunner.run(suite());
	}
	
	public static Test suite() {
		TestSuite suite = new TestSuite();
		suite.setName("All INX Utility Tests");
		
		suite.addTest(DataUtilTests.suite());
		suite.addTest(InxValueListTest.suite());
		suite.addTest(InxHelperTests.suite());
		suite.addTest(InxReaderTests.suite());
		suite.addTest(FrameToPageAssignmentTest.suite());
		suite.addTest(ComplexPageCreationTest.suite());
		suite.addTest(DocumentObjectCreationTests.suite());
		suite.addTest(LinkObjectTests.suite());
		
		return suite;
	}
	

	

}
