/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
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
