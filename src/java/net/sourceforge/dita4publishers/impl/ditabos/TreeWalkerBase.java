/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.net.URI;
import java.util.Map;

import javax.xml.transform.URIResolver;
import javax.xml.xpath.XPathExpression;

import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.TreeWalker;

import org.apache.commons.logging.Log;
import org.jbpm.graph.exe.ExecutionContext;
import org.w3c.dom.Document;

/**
 * 
 */
public abstract class TreeWalkerBase implements TreeWalker {

	protected XPathExpression allTopicrefs;
	protected URIResolver uriResolver;
	protected ExecutionContext context;
	protected Log log;
	protected boolean failOnAddressResolutionFailure;
	protected Object rootObject;
	protected String[] catalogs;
	protected Map<URI, Document> domCache;
	protected BosConstructionOptions bosConstructionOptions;

	/**
	 * @param bosConstructionOptions 
	 * @throws BosException 
	 */
	public TreeWalkerBase(Log log, BosConstructionOptions bosConstructionOptions) throws BosException {
		this.log = log;
		this.failOnAddressResolutionFailure = bosConstructionOptions.getFailOnAddressResolutionFailure();
		this.bosConstructionOptions = bosConstructionOptions;
		this.catalogs = bosConstructionOptions.getCatalogs();
		this.domCache = bosConstructionOptions.getDomCache();

		setResolver(bosConstructionOptions.getUriResolver());
	}

	/**
	 * @param uriResolver
	 */
	public void setResolver(URIResolver uriResolver) {
		this.uriResolver = uriResolver;
	}

	/**
	 * @return
	 */
	public URIResolver getUriResolver() {
		return this.uriResolver;
	}

	public Object getRootObject() throws BosException {
		return this.rootObject;
	}

	/**
	 * @param level
	 * @return
	 */
	protected String getLevelSpacer(int level) {
		String result = "";
		for (int i = 0; i <= level; i++) {
			result += "  ";
		}
		return result;
	}
}