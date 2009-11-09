/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinition;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;


/**
 * Mock implementation of a working DITA key space.
 */
public class InMemoryDitaKeySpace implements DitaKeySpace {

	private static Log log = LogFactory.getLog(InMemoryDitaKeySpace.class);

	private Set<DitaKeyDefinition> effectiveKeyDefinitions = new TreeSet<DitaKeyDefinition>();
	private List<DitaKeyDefinition> allKeyDefinitions  = new ArrayList<DitaKeyDefinition>();
	private Map<String, DitaKeyDefinition> effectiveKeyDefMap = new HashMap<String, DitaKeyDefinition>();
	private Map<String, List<DitaKeyDefinition>> allKeyDefsMap = new HashMap<String, List<DitaKeyDefinition>>();
	private DitaKeyDefinitionContext context;

	private Document rootMap = null;

	private KeyAccessOptions keyAccessOptions = new KeyAccessOptions();


	/**
	 * @param keydefContext
	 * @throws Exception 
	 */
	public InMemoryDitaKeySpace(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		log.info("InMemoryDitaKeySpace(): Constructing...");
		this.keyAccessOptions = keyAccessOptions;
		this.context.setKeyAccessOptions(keyAccessOptions);
		this.context = keydefContext;
		loadKeyDefinitions();
		log.info("InMemoryDitaKeySpace(): Constructor done.");
	}

	/**
	 * @param keydefContext
	 */
	public InMemoryDitaKeySpace(DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		log.info("InMemoryDitaKeySpace(): Constructing...");
		this.keyAccessOptions = keydefContext.getKeyAccessOptions();
		this.context = keydefContext;
		loadKeyDefinitions();
		log.info("InMemoryDitaKeySpace(): Constructor done.");
	}

	/**
	 * @throws DitaApiException 
	 * 
	 */
	private void loadKeyDefinitions() throws DitaApiException {
		log.info("loadKeyDefinitions(): Starting...");

		Element mapElem = rootMap.getDocumentElement();
		NodeList keydefElems = DitaUtil.getKeyDefinitions(mapElem);
		log.info("loadKeyDefinitions(): Found " + keydefElems.getLength() + " key definition elements.");
		try {
			for (int i = 0; i < keydefElems.getLength(); i++) {
				Element keydefElem = (Element)keydefElems.item(i);
				log.debug("loadKeyDefinitions(): handling keydef for keys \"" + keydefElem.getAttribute(DitaUtil.DITA_KEYREF_ATTNAME));
				
				String str = keydefElem.getAttribute(DitaUtil.DITA_KEYS_ATTNAME);
				for (String key : str.split("\\s+")) {
					log.debug("loadKeyDefinitions(): Handling key \"" + key + "\"");
					DitaKeyDefinition keydef = new DitaKeyDefinitionImpl(rootMap, key, keydefElem);
					log.debug("loadKeyDefinitions(): Created new keydef for key \"" + key + "\"");
					// Only first keydef for a given key in document order is effective.
					if (!this.effectiveKeyDefinitions.contains(keydef)) {
						this.effectiveKeyDefinitions.add(keydef);
						this.effectiveKeyDefMap.put(key, keydef);
						log.debug("loadKeyDefinitions(): Key is effective, adding to effective key definitions");
					}
					this.allKeyDefinitions.add(keydef);
					if (!this.allKeyDefsMap.containsKey(key)) {
						log.debug("loadKeyDefinitions(): Creating new allKeyDefMap entry for key \"" + key + "\"");
						this.allKeyDefsMap.put(key, new ArrayList<DitaKeyDefinition>());
					} else {
						log.debug("loadKeyDefinitions(): Found existing allKeyDefMap entry for key \"" + key + "\"");
					}
					log.debug("loadKeyDefinitions(): Adding keydef for key \"" + key + "\" to allKeyDefMap entry.");
					this.allKeyDefsMap.get(key).add(keydef);

				}
			}
		} catch (DitaApiException e) {
			e.printStackTrace();
		}
		log.info("loadKeyDefinitions(): Done.");
		
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#getKeys()
	 */
	public Set<String> getKeys(KeyAccessOptions keyAccessOptions) throws DitaApiException {
		return this.effectiveKeyDefMap.keySet();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#getKeyDefinitions()
	 */
	public Set<DitaKeyDefinition> getEffectiveKeyDefinitions(KeyAccessOptions keyAccessOptions) {
		return this.effectiveKeyDefinitions;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#size()
	 */
	public long size() {
		return this.effectiveKeyDefMap.size();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#getRootMap()
	 */
	public Document getRootMap(KeyAccessOptions keyAccessOptions) throws DitaApiException {
		if (rootMap == null) {
			rootMap = getRootMapFromContext(keyAccessOptions, this.context);
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
		String rootMapId = this.context.getRootMapId();
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#getKeyDefinition(com.reallysi.rsuite.api.User, java.lang.String)
	 */
	public DitaKeyDefinition getKeyDefinition(KeyAccessOptions keyAccessOptions, String key)
			throws DitaApiException {
		return this.effectiveKeyDefMap.get(key);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#getAllKeyDefinitions(com.reallysi.rsuite.api.User)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions)
			throws DitaApiException {
		return this.allKeyDefinitions;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeySpace#getAllKeyDefinitions(com.reallysi.rsuite.api.User, java.lang.String)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions, String key)
			throws DitaApiException {
		return this.allKeyDefsMap.get(key);
	}


}
