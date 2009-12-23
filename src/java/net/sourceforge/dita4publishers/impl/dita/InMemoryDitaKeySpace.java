/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.io.File;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinition;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.api.ditabos.AddressingException;
import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.impl.ditabos.AddressingUtil;
import net.sourceforge.dita4publishers.impl.ditabos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaUtil;
import net.sourceforge.dita4publishers.impl.ditabos.DomUtil;
import net.sourceforge.dita4publishers.impl.ditabos.KeySpaceEntry;
import net.sourceforge.dita4publishers.impl.ditabos.UnresolvedResource;

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
	
	private Map<String, KeySpaceEntry> resourcesByKey = new HashMap<String, KeySpaceEntry>();
	private BosConstructionOptions bosOptions;
	private List<DitaKeyDefinition> allKeyDefinitions = new ArrayList<DitaKeyDefinition>();
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
		
		log.info("addKeyDefinitions(): Found " + keydefs.getLength() + " key-defining topicrefs in the map");
		for (int i = 0; i < keydefs.getLength(); i++) {
			Element keydef = (Element)keydefs.item(i);
			String keydefStr = keydef.getAttribute("keys");
			StringTokenizer tokenizer = new StringTokenizer(keydefStr, " ");
			while (tokenizer.hasMoreTokens()) {
				String key = tokenizer.nextToken();
				KeySpaceEntry entry = new KeySpaceEntry(key, keydef);
				registerKeyDefinition(mapElement, keydef, key);
				
				if (!this.resourcesByKey.containsKey(key)) {
					log.info("addKeyDefinitions(): Adding entry for new key \"" + key + "\"");
					this.resourcesByKey.put(key, entry);
				} else {
					log.info("addKeyDefinitions(): Skipping duplicate definition of key \"" + key + "\" for resource \"" + DitaUtil.getImmediateResourceForKeydef(keydef) + "\"");
				}
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
	 * @param key
	 * @return 
	 */
	public KeySpaceEntry getKeyDefinition(String key) {
		return this.resourcesByKey.get(key);
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
		KeySpaceEntry kse = this.resourcesByKey.get(key);
		Object res = kse.getResource();
		if (res == null) {
			res = resolveKeyrefResource(kse);
		}
		Document result = null;
		if (res instanceof Document) {
			log.info("Found XML BOS Member for key \"" + key + "\", returning it");
			return (Document)res;
		}
		if (res == null || res instanceof UnresolvedResource) {
			log.info("Failed to resolve key \"" + key + "\" to a resource object");
		} else {
			log.info("Key \"" + key + "\" resolved to a non-XmlBosMember object: " + res.getClass().getSimpleName());
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
	public File resolveKeyToFile(String key) throws AddressingException {
	  return resolveKeyToFile(key, this.defaultKeyAccessOptions);
	}



	/**
	 * @param key
	 * @return
	 * @throws AddressingException 
	 * @throws DitaApiException 
	 */
	public File resolveKeyToFile(String key, KeyAccessOptions keyAccessOptions) throws AddressingException {
		if (key.contains("/")) {
			log.info("[WARNING] Key contained a '/' character. Callers should strip off element ID references before calling this method.");
			key = key.split("/")[0];
		}
		KeySpaceEntry kse = this.resourcesByKey.get(key);
		if (kse == null) {
			log.warn("Key \"" + key + "\" not defined in key space.");
			return null;
		}
			
		Object res = kse.getResource();
		if (res == null) {
			res = resolveKeyrefResource(kse);
		}
		File result = null;
		if (res instanceof File) {
			log.info("Found non-XML BOS Member for key \"" + key + "\", returning it");
			result = (File)res;
		}
		if (res == null || res instanceof UnresolvedResource) {
			log.info("Failed to resolve key \"" + key + "\" to a resource object");
		} else {
			log.info("Key \"" + key + "\" resolved to a non-XmlBosMember object: " + res.getClass().getSimpleName());
		}
		return result;
	}


	/**
	 * @param kse
	 * @throws AddressingException 
	 * @throws BosException 
	 */
	private Object resolveKeyrefResource(KeySpaceEntry kse) throws AddressingException {
		Element keydef = kse.getKeyDef(); 
		if (keydef.hasAttribute("href")) {
			String format = keydef.getAttribute("format");
			if (format == null || "".equals(format)) {
				format = "dita";
			}
			String href = keydef.getAttribute("href");
			if (format.equals("dita") || format.equals("ditamap")) {
				// target should be a DITA map or topic document
				Document doc = AddressingUtil.resolveHrefToDoc(keydef, href, this.bosOptions, false); 
				if (doc == null) {
					log.warn("Failed to resolve keyref \"" + kse.getKey() + "\" to a DITA resource with URL \"" + href  + "\"");
					kse.setResource(new UnresolvedResource());
				} else {
					kse.setResource(doc);
				}
			} else {
				File file = AddressingUtil.resolveHrefToFile(keydef, href, false);
				if (file == null) {
					log.warn("Failed to resolve keyref \"" + kse.getKey() + "\" to a non-DITA resource with URL \"" + href  + "\"");
					kse.setResource(new UnresolvedResource());
				} else {
					kse.setResource(file);
				}
			}
		} else {
			// If no HREF, then the keydef's own document is the resource.
			kse.setResource(keydef.getOwnerDocument());
		}
		return kse.getResource();
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getAllKeyDefinitions(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitions(
			KeyAccessOptions keyAccessOptions) throws DitaApiException {
		// FIXME: Use the key access options to filter the set of key definitions
		// returned.
		return this.allKeyDefinitions ;
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
		Set<DitaKeyDefinition> resultList = new HashSet<DitaKeyDefinition>();
		// For each key, get the first key definition for which access is allowed.
		for (String key : allKeyDefinitionsByKey.keySet()) {
			List<DitaKeyDefinition> keyDefs = allKeyDefinitionsByKey.get(key);
			for (DitaKeyDefinition keyDef : keyDefs) {
				if (isApplicable(keyDef, keyAccessOptions)) {
					resultList.add(keyDef);
					break;
				}
			}
		}
		return resultList;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeySpace#getKeyDefinition(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions, java.lang.String)
	 */
	public DitaKeyDefinition getKeyDefinition(
			KeyAccessOptions keyAccessOptions, String key)
			throws DitaApiException {
		List<DitaKeyDefinition> keyDefs = this.allKeyDefinitionsByKey.get(key);
		if (keyDefs.size() == 1)
			return keyDefs.get(0);
		DitaKeyDefinition keyDef = null;
		for (DitaKeyDefinition cand : keyDefs) {
			if (isApplicable(cand, keyAccessOptions)) {
				keyDef = cand;
				break;
			}
		}
		return keyDef;
	}

	/**
	 * @param cand
	 * @param keyAccessOptions
	 * @return
	 */
	private boolean isApplicable(DitaKeyDefinition cand,
			KeyAccessOptions keyAccessOptions) {
		// FIXME: Apply filtering to the key definition to determine
		// if it is applicable.
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

}
