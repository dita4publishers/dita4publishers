/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.TreeSet;

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinition;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.DitaPropsSpec;
import net.sourceforge.dita4publishers.api.dita.DitavalSpec;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.api.ditabos.AddressingException;
import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.impl.ditabos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.UnresolvedResource;
import net.sourceforge.dita4publishers.util.DitaUtil;
import net.sourceforge.dita4publishers.util.DomUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;


/**
 * Maintains the set of effective key-to-resource bindings for a given 
 * compound map.
 */
public class InMemoryDitaKeySpace implements DitaKeySpace {

	private static Log log = LogFactory.getLog(InMemoryDitaKeySpace.class);
	
	private BosConstructionOptions bosOptions;

	/**
	 * All key definitions in the order they are encountered in the map tree.
	 */
	private List<DitaKeyDefinition> allKeyDefinitions = new ArrayList<DitaKeyDefinition>();
	
	/**
	 * All key definitions indexed by key name.
	 */
	private Map<String, List<DitaKeyDefinition>> allKeyDefinitionsByKey = new HashMap<String, List<DitaKeyDefinition>>();

	KeyAccessOptions defaultKeyAccessOptions = new KeyAccessOptions();
	private Document rootMap;
	
	private DitaKeyDefinitionContext keydefContext = null;


	/**
	 * The key space can only be constructed either in the process of constructing a 
	 * map tree or from a previously-constructed map tree.
	 * @param keydefContext Key definition context
	 * @param rootMap Root map document from which to construct the key space.
	 * @param bosOptions BOS construction options.
	 * @throws Exception 
	 */
	public InMemoryDitaKeySpace(DitaKeyDefinitionContext keydefContext, Document rootMap, BosConstructionOptions bosOptions) throws DitaApiException {
		this.keydefContext = keydefContext;
		this.rootMap = rootMap;
		this.bosOptions = bosOptions;
	}



	/**
	 * Processes a DITA map document to add any new keys to the key space
	 * @param mapElement
	 * @throws DitaApiException 
	 */
	public void addKeyDefinitions(Element mapElement) throws DitaApiException {
		NodeList keydefs = null;
		try {
			keydefs = (NodeList)DitaUtil.allKeyDefs.evaluate(mapElement, XPathConstants.NODESET);
		} catch (XPathExpressionException e) {
			throw new RuntimeException("Unexpected exception evaluating XPath expression \"" + DitaUtil.ALL_KEYDEFS_XPATH + "\"");
		}
		
		log.debug("addKeyDefinitions(): Found " + keydefs.getLength() + " key-defining topicrefs in the map");
		for (int i = 0; i < keydefs.getLength(); i++) {
			Element keydef = (Element)keydefs.item(i);
			String keydefStr = keydef.getAttribute("keys");
			StringTokenizer tokenizer = new StringTokenizer(keydefStr, " ");
			while (tokenizer.hasMoreTokens()) {
				String key = tokenizer.nextToken();
				registerKeyDefinition(mapElement, keydef, key);
			}
		}
	}

	protected void registerKeyDefinition(Element mapElement, Element keydefElem,
			String key) throws DitaApiException {
		DitaKeyDefinition keyDef = new DitaKeyDefinitionImpl(mapElement.getOwnerDocument(), key, keydefElem);
		List<DitaKeyDefinition> keyDefs = allKeyDefinitionsByKey.get(key);
		if (keyDefs == null) {
			keyDefs = new ArrayList<DitaKeyDefinition>();
			allKeyDefinitionsByKey.put(key, keyDefs);
		}
		keyDefs.add(keyDef);
		allKeyDefinitions.add(keyDef);
	}

	/**
	 * Resolve the specified key to its ultimate resource and return the 
	 * the document that contains the resource. This may be the document
	 * that contains the original key definition if the key definition
	 * resolves to a linktext subelement of the key definition itself.
	 * @param key
	 * @return the resource's document.
	 * @throws AddressingException if the key cannot be resolved a resource.
	 * @throws DitaApiException 
	 * @throws BosException 
	 */
	public Document resolveKeyToDocument(String key,
			KeyAccessOptions keyAccessOptions) throws AddressingException,
			DitaApiException {
		// FIXME: Use key access options to use applicable key definition.
		if (key.contains("/")) {
			log.info("[WARNING] Key contained a '/' character. Callers should strip off element ID references before calling this method.");
			key = key.split("/")[0];
		}

		Document result = null;
		
		DitaKeyDefinition keyDef = this.getKeyDefinition(keyAccessOptions, key);
		
		if (keyDef == null) {
			log.debug("Failed to resolve key \"" + key + "\" to a resource object");
			return result;
		}
		
		Object res = keyDef.getResource();
		if (res == null) {
			res = resolveKeyrefResource(keyDef);
		}
		if (res instanceof Document) {
			log.debug("Found XML BOS Member for key \"" + key + "\", returning it");
			return (Document)res;
		}
		if (res == null || res instanceof UnresolvedResource) {
			log.debug("Failed to resolve key \"" + key + "\" to a resource object");
		} else {
			log.debug("Key \"" + key + "\" resolved to a non-XmlBosMember object: " + res.getClass().getSimpleName());
		}
		return result;
	}
	
	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#resolveKeyToDocument(java.lang.String, net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public Document resolveKeyToDocument(String key) throws AddressingException, DitaApiException {
		return resolveKeyToDocument(key, this.defaultKeyAccessOptions);
	}


	
	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#resolveKeyToFile(java.lang.String, net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public URI resolveKeyToFile(String key) throws DitaApiException {
	  return resolveKeyToUri(key, this.defaultKeyAccessOptions);
	}



	/**
	 * @param key
	 * @return
	 * @throws DitaApiException 
	 * @throws DitaApiException 
	 */
	public URI resolveKeyToUri(String key, KeyAccessOptions keyAccessOptions) throws DitaApiException {
		if (key.contains("/")) {
			log.info("[WARNING] Key contained a '/' character. Callers should strip off element ID references before calling this method.");
			key = key.split("/")[0];
		}
		DitaKeyDefinition keyDef = this.getKeyDefinition(keyAccessOptions, key);
		if (keyDef == null) {
			log.warn("Key \"" + key + "\" not defined in key space.");
			return null;
		}
			
		Object res = keyDef.getResource();
		if (res == null) {
			res = resolveKeyrefResource(keyDef);
		}
		URI result = null;
		if (res instanceof URI) {
			log.debug("Found non-XML BOS Member for key \"" + key + "\", returning it");
			result = (URI)res;
			
		}
		if (res == null || res instanceof UnresolvedResource) {
			log.debug("Failed to resolve key \"" + key + "\" to a resource object");
		} else {
			log.debug("Key \"" + key + "\" resolved to an object: " + res.getClass().getSimpleName());
		}
		return result;
	}


	/**
	 * @param keyDef
	 * @throws AddressingException 
	 * @throws BosException 
	 */
	private Object resolveKeyrefResource(DitaKeyDefinition keyDef) throws AddressingException {
		Element keydefElem = keyDef.getKeyDefElem(); 
		if (keydefElem.hasAttribute("href")) {
			String format = keydefElem.getAttribute("format");
			if (format == null || "".equals(format)) {
				format = "dita";
			}
			String href = keydefElem.getAttribute("href");
			if (format.equals("dita") || format.equals("ditamap")) {
				// target should be a DITA map or topic document
				Document doc = AddressingUtil.resolveHrefToDoc(keydefElem, href, this.bosOptions, false); 
				if (doc == null) {
					log.warn("Failed to resolve keyref \"" + keyDef.getKey() + "\" to a DITA resource with URL \"" + href  + "\"");
					keyDef.setResource(new UnresolvedResource());
				} else {
					keyDef.setResource(doc);
				}
			} else {
				URI uri = AddressingUtil.resolveHrefToUri(keydefElem, href, false);
				if (uri == null) {
					log.warn("Failed to resolve keyref \"" + keyDef.getKey() + "\" to a non-DITA resource with URL \"" + href  + "\"");
					keyDef.setResource(new UnresolvedResource());
				} else {
					keyDef.setResource(uri);
				}
			}
		} else {
			// If no HREF, then the keydef is the resource.
			keyDef.setResource(keydefElem);
		}
		return keyDef.getResource();
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getAllKeyDefinitions(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitions(
			KeyAccessOptions keyAccessOptions) throws DitaApiException {
		List<DitaKeyDefinition> resultList = new ArrayList<DitaKeyDefinition>();
		DitavalSpec ditavalSpec = keyAccessOptions.getDitavalSpec();
		if (ditavalSpec == null) {
			resultList.addAll(allKeyDefinitions);
			return resultList;
		}
		for (DitaKeyDefinition keyDef : this.allKeyDefinitions) {
			if (this.isApplicable(keyDef, keyAccessOptions))
				resultList.add(keyDef);
		}
		return resultList;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getAllKeyDefinitions(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions, java.lang.String)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitions(
			KeyAccessOptions keyAccessOptions, String key)
			throws DitaApiException {
		List<DitaKeyDefinition> keyDefs = this.allKeyDefinitionsByKey.get(key);
		if (keyDefs == null)
			keyDefs = new ArrayList<DitaKeyDefinition>();
		return keyDefs;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getEffectiveKeyDefinitions(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public Set<DitaKeyDefinition> getEffectiveKeyDefinitions(
			KeyAccessOptions keyAccessOptions) throws DitaApiException {
		Set<DitaKeyDefinition> resultSet = new TreeSet<DitaKeyDefinition>();
		// For each key, get the first key definition for which access is allowed.
		for (String key : allKeyDefinitionsByKey.keySet()) {
			List<DitaKeyDefinition> keyDefs = allKeyDefinitionsByKey.get(key);
			for (DitaKeyDefinition keyDef : keyDefs) {
				if (isApplicable(keyDef, keyAccessOptions)) {
					resultSet.add(keyDef);
					break;
				}
			}
		}
		return resultSet;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getKeyDefinition(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions, java.lang.String)
	 */
	public DitaKeyDefinition getKeyDefinition(
			KeyAccessOptions keyAccessOptions, String key)
			throws DitaApiException {
		List<DitaKeyDefinition> keyDefs = this.allKeyDefinitionsByKey.get(key);
		DitaKeyDefinition keyDef = null;
		if (keyDefs == null)
			return keyDef;
		if (keyDefs.size() == 1)
			return keyDefs.get(0);
		for (DitaKeyDefinition cand : keyDefs) {
			if (isApplicable(cand, keyAccessOptions)) {
				keyDef = cand;
				break;
			}
		}
		return keyDef;
	}

	/**
	 * @param keyDef
	 * @param keyAccessOptions
	 * @return
	 */
	private boolean isApplicable(DitaKeyDefinition keyDef,
			KeyAccessOptions keyAccessOptions) {
		DitavalSpec ditavalSpec = keyAccessOptions.getDitavalSpec();
		if (ditavalSpec == null)
			return true;
		DitaPropsSpec propsSpec = keyDef.getDitaPropsSpec();
		for (String propName : propsSpec.getProperties()) {
			for (String value : propsSpec.getPropertyValues(propName))
			if (ditavalSpec.isExcluded(propName, value))
				return false;
		}
 		return true;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getKeys(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public Set<String> getKeys(KeyAccessOptions keyAccessOptions)
			throws DitaApiException {
		Set<DitaKeyDefinition> keyDefs = getEffectiveKeyDefinitions(keyAccessOptions);
		Set<String> keys = new HashSet<String>();
		for (DitaKeyDefinition keyDef : keyDefs)
			keys.add(keyDef.getKey());
		return keys;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#getRootMap()
	 */
	public Document getRootMap(KeyAccessOptions keyAccessOptions) throws DitaApiException {
		if (rootMap == null) {
			rootMap = getRootMapFromContext(keyAccessOptions, this.keydefContext);
		}
		return this.rootMap;
	}
	
	/**
	 * @param context
	 * @return
	 * @throws DitaApiException 
	 */
	private Document getRootMapFromContext(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext context) throws DitaApiException {
		String rootMapId = this.keydefContext.getRootMapId();
		Document dom;
		try {
			dom = DomUtil.getDomForUri(new URI(rootMapId), this.bosOptions);
		} catch (Exception e) {
			throw new DitaApiException("Failed to construct map from URI \"" + rootMapId + "\": " + e.getMessage(), e);
		}
		return dom;
	}


	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#size()
	 */
	public long size() throws DitaApiException {
		return this.getEffectiveKeyDefinitions(this.defaultKeyAccessOptions).size();
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#size(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public long size(KeyAccessOptions keyAccessOptions) throws DitaApiException {
		throw new NotImplementedException();
	}



	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#definesKey(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions, java.lang.String)
	 */
	public boolean definesKey(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException {
		if (this.allKeyDefinitionsByKey.containsKey(key)) {
			if (keyAccessOptions.getDitavalSpec() == null)
				return true; // Can't be conditional
			else {
				return this.getAllKeyDefinitions(keyAccessOptions, key).size() > 0;
			}
		}
		return false;
	}



	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getAllKeyDefinitionsByKey(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public Map<? extends String, List<? extends DitaKeyDefinition>> getAllKeyDefinitionsByKey(
			KeyAccessOptions keyAccessOptions) throws DitaApiException {
		Map<String, List<? extends DitaKeyDefinition>> resultMap = new HashMap<String, List<? extends DitaKeyDefinition>>();
		for (String key : this.allKeyDefinitionsByKey.keySet()) {
			List<? extends DitaKeyDefinition> list = this.getAllKeyDefinitions(keyAccessOptions, key);
			resultMap.put(key,list);
		}
		return resultMap;
	}



}
