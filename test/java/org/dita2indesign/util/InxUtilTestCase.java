/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.util;

import java.net.URL;

import junit.framework.TestCase;

/**
 *
 */
public abstract class InxUtilTestCase extends TestCase {

	protected final URL gdTemplate = this.getClass().getResource("/resources/templates/gas_daily-template.inx");
	protected final URL gdIssueCa = this.getClass().getResource("/resources/content-assemblies/gas_daily_20081212.xml");
	
	public void setUp() throws Exception {
		assertNotNull(gdTemplate);
		assertNotNull(gdIssueCa);

	}

}
