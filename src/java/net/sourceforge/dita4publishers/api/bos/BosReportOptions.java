/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.bos;

import java.util.HashMap;
import java.util.Map;

/**
 * Options for controlling details of BOS reports
 */
public class BosReportOptions {
	
	/**
	 * 
	 */
	public static final String REPORT_TYPE_OPTION = "reportType";
	private static final String REPORT_TYPE_TREE = "tree";
	private static final String REPORT_TYPE_FLAT = "flat";

	public BosReportOptions() {
		setOption(REPORT_TYPE_OPTION, REPORT_TYPE_TREE);
	}

	private Map<String, String> options = new HashMap<String, String>();

	public void setOption(String name, String value) {
		this.options.put(name, value);
	}

	public void setMapTypeTree() {
		setOption(REPORT_TYPE_OPTION, REPORT_TYPE_TREE);
	}

	public void setMapTypeFlat() {
		setOption(REPORT_TYPE_OPTION, REPORT_TYPE_FLAT);
	}
	
	public boolean isReportTypeTree() {
		return REPORT_TYPE_TREE.equals(this.options.get(REPORT_TYPE_OPTION));
	}

	public boolean isReportTypeFlat() {
		return REPORT_TYPE_FLAT.equals(this.options.get(REPORT_TYPE_OPTION));
	}

}
