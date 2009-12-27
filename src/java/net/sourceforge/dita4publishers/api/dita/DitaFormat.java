/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

/**
 * Reflects the effective value of the format attribute
 * of topicref. The value for format is unbounded, so
 * this enum only reflects the common or important
 * values. The default value for format when unspecified
 * on a topicref, xref, or link is "dita".
 */
public enum DitaFormat {
	
	/**
	 * A DITA topic.
	 */
	DITA ("dita"),     
	
	/**
	 * A DITA map.
	 */
	DITAMAP ("ditamap"), 
	
	/**
	 * An HTML resource.
	 */
	HTML ("html"), 
	
	/**
	 * An JPEG resource.
	 */
	JPG ("jpg"), 
	
	/**
	 * A GIF resource.
	 */
	GIF ("gif"), 
	
	/**
	 * An SVG resource.
	 */
	SVG ("svg"), 
	
	/**
	 * An PDF resource.
	 */
	PDF ("pdf"), 
	
	/**
	 * Some other kind of resource.
	 */
	NONDITA ("non-dita");
	
	private String name;

	DitaFormat(String name ) {
		this.name = name;
	}
	
	public String toString() {
		return name;
	}
	
}
