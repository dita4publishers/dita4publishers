/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.File;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sourceforge.dita4publishers.api.ditabos.AddressingException;
import net.sourceforge.dita4publishers.api.ditabos.BosException;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;


/**
 * Maintains the set of effective key-to-resource bindings for a given 
 * compound map.
 */
public class DitaKeySpace {
	
	private Map<String, KeySpaceEntry> resourcesByKey = new HashMap<String, KeySpaceEntry>();
	private Log log;
	private BosConstructionOptions domOptions;

	/**
	 * @param log
	 * @param domOptions 
	 */
	public DitaKeySpace(BosConstructionOptions domOptions, Map<URI, Document> domCache) {
		this.log = domOptions.getLog();
		this.domOptions = domOptions;
	}

	/**
	 * @param log
	 * @param domOptions 
	 */
	public DitaKeySpace(BosConstructionOptions domOptions) {
		this.log = domOptions.getLog();
		this.domOptions = domOptions;
	}

	/**
	 * Processes a DITA map document to add any new keys to the key space
	 * @param mapElement
	 */
	public void addKeyDefinitions(Element mapElement) {
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
				if (!this.resourcesByKey.containsKey(key)) {
					log.info("addKeyDefinitions(): Adding entry for new key \"" + key + "\"");
					KeySpaceEntry entry = new KeySpaceEntry(key, keydef);
					this.resourcesByKey.put(key, entry);
				} else {
					log.info("addKeyDefinitions(): Skipping duplicate definition of key \"" + key + "\" for resource \"" + DitaUtil.getImmediateResourceForKeydef(keydef) + "\"");
				}
			}
		}
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
	 * @throws BosException 
	 */
	public Document resolveKeyToDocument(String key) throws AddressingException, BosException {
		if (key.contains("/")) {
			this.log.info("[WARNING] Key contained a '/' character. Callers should strip off element ID references before calling this method.");
			key = key.split("/")[0];
		}
		KeySpaceEntry kse = this.resourcesByKey.get(key);
		Object res = kse.getResource();
		if (res == null) {
			res = resolveKeyrefResource(kse);
		}
		Document result = null;
		if (res instanceof Document) {
			this.log.info("Found XML BOS Member for key \"" + key + "\", returning it");
			return (Document)res;
		}
		if (res == null || res instanceof UnresolvedResource) {
			this.log.info("Failed to resolve key \"" + key + "\" to a resource object");
		} else {
			this.log.info("Key \"" + key + "\" resolved to a non-XmlBosMember object: " + res.getClass().getSimpleName());
		}
		return result;
	}

	/**
	 * @param key
	 * @return
	 * @throws BosException 
	 * @throws AddressingException 
	 */
	public File resolveKeyToFile(String key) throws AddressingException, BosException {
		if (key.contains("/")) {
			this.log.info("[WARNING] Key contained a '/' character. Callers should strip off element ID references before calling this method.");
			key = key.split("/")[0];
		}
		KeySpaceEntry kse = this.resourcesByKey.get(key);
		if (kse == null) {
			this.log.warn("Key \"" + key + "\" not defined in key space.");
			return null;
		}
			
		Object res = kse.getResource();
		if (res == null) {
			res = resolveKeyrefResource(kse);
		}
		File result = null;
		if (res instanceof File) {
			this.log.info("Found non-XML BOS Member for key \"" + key + "\", returning it");
			result = (File)res;
		}
		if (res == null || res instanceof UnresolvedResource) {
			this.log.info("Failed to resolve key \"" + key + "\" to a resource object");
		} else {
			this.log.info("Key \"" + key + "\" resolved to a non-XmlBosMember object: " + res.getClass().getSimpleName());
		}
		return result;
	}


	/**
	 * @param kse
	 * @throws AddressingException 
	 * @throws BosException 
	 */
	private Object resolveKeyrefResource(KeySpaceEntry kse) throws AddressingException, BosException {
		Element keydef = kse.getKeyDef(); 
		if (keydef.hasAttribute("href")) {
			String format = keydef.getAttribute("format");
			if (format == null || "".equals(format)) {
				format = "dita";
			}
			String href = keydef.getAttribute("href");
			if (format.equals("dita") || format.equals("ditamap")) {
				// target should be a DITA map or topic document
				Document doc = AddressingUtil.resolveHrefToDoc(keydef, href, this.domOptions, false); 
				if (doc == null) {
					this.log.warn("Failed to resolve keyref \"" + kse.getKey() + "\" to a DITA resource with URL \"" + href  + "\"");
					kse.setResource(new UnresolvedResource());
				} else {
					kse.setResource(doc);
				}
			} else {
				File file = AddressingUtil.resolveHrefToFile(keydef, href, false);
				if (file == null) {
					this.log.warn("Failed to resolve keyref \"" + kse.getKey() + "\" to a non-DITA resource with URL \"" + href  + "\"");
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

}
