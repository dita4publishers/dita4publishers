/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.xml.transform.URIResolver;

import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.util.GrammarPoolManager;

import org.apache.commons.logging.Log;
import org.apache.xerces.xni.grammars.XMLGrammarPool;
import org.w3c.dom.Document;

/**
 * Holds options used to configure DOM construction.
 */
public class BosConstructionOptions {

	private Log log;
	private StringBuilder report = new StringBuilder();
	private String[] catalogs = new String[0];
	private Map<URI, Document> domCache = new HashMap<URI, Document>();
	private Set<URI> invalidDocs  = new HashSet<URI>();
	private URIResolver uriResolver = null; // Use built-in resolver
	private boolean failOnAddressResolutionFailure = true;
	private boolean mapTreeOnly = false;
	private KeyAccessOptions keyAccessOptions = new KeyAccessOptions();
	private XMLGrammarPool grammarPool = GrammarPoolManager.getGrammarPool();

	/**
	 * @return the invalidDocs
	 */
	public Set<URI> getInvalidDocs() {
		return this.invalidDocs;
	}

	/**
	 * @param domCache the domCache to set
	 */
	public void setDomCache(Map<URI, Document> domCache) {
		this.domCache = domCache;
	}

	/**
	 * @param log
	 * @param reportBuilder
	 * @param catalogs 
	 */
	public BosConstructionOptions(Log log, StringBuilder reportBuilder, String[] catalogs) {
		this.log = log;
		this.report = reportBuilder;
		this.catalogs = catalogs;
	}

	/**
	 * @param log 
	 * @param domCache
	 */
	public BosConstructionOptions(Log log, Map<URI, Document> domCache) {
		this.log = log;
		this.domCache = domCache;		
	}

	/**
	 * @return the log
	 */
	public Log getLog() {
		return this.log;
	}

	/**
	 * @param log the log to set
	 */
	public void setLog(Log log) {
		this.log = log;
	}

	/**
	 * @return the report
	 */
	public StringBuilder getReport() {
		return this.report;
	}

	/**
	 * @param report the report to set
	 */
	public void setReport(StringBuilder report) {
		this.report = report;
	}

	/**
	 * @param catalogs the catalogs to set
	 */
	public void setCatalogs(String[] catalogs) {
		this.catalogs = catalogs;
	}

	/**
	 * @return the catalogs
	 */
	public String[] getCatalogs() {
		return catalogs;
	}

	/**
	 * @return
	 */
	public Map<URI, Document> getDomCache() {
		return this.domCache;
	}

	/**
	 * @param systemId
	 * @throws URISyntaxException 
	 */
	public void registerInvalidDocument(String systemId) throws URISyntaxException {
		this.invalidDocs.add(new URI(systemId));
	}

	/**
	 * @return
	 */
	public Set<URI> getInvalidDocuments() {
		return this.invalidDocs;
	}

	/**
	 * @return
	 */
	public String getReportString() {
		return this.report.toString();
	}

	/**
	 * @return
	 */
	public URIResolver getUriResolver() {
		return this.uriResolver;
	}

	/**
	 * @return
	 */
	public boolean getFailOnAddressResolutionFailure() {
		return this.failOnAddressResolutionFailure;
	}
	
	public void setFailOnAddressResolutionFailure(boolean failOnAddressResolutionFailure) {
		this.failOnAddressResolutionFailure = failOnAddressResolutionFailure;
	}

	/**
	 * @param b
	 */
	public void setMapTreeOnly(boolean mapTreeOnly) {
		this.mapTreeOnly = mapTreeOnly;
	}
	
	public boolean isMapTreeOnly() {
		return this.mapTreeOnly;
	}

	/**
	 * @return
	 */
	public KeyAccessOptions getKeyAccessOptions() {
		return this.keyAccessOptions ;
	}
	
	public void SetKeyAccessOptions(KeyAccessOptions keyAccessOptions) {
		this.keyAccessOptions = keyAccessOptions;
	}

	/**
	 * @return
	 */
	public XMLGrammarPool getGrammarPool() {
		return this.grammarPool;
	}

}
