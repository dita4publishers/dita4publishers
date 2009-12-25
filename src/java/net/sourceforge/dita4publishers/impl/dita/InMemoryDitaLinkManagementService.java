/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.api.dita.DitaElementResource;
import net.sourceforge.dita4publishers.api.dita.DitaFormat;
import net.sourceforge.dita4publishers.api.dita.DitaIdTarget;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinition;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.DitaLinkManagementService;
import net.sourceforge.dita4publishers.api.dita.DitaReference;
import net.sourceforge.dita4publishers.api.dita.DitaResource;
import net.sourceforge.dita4publishers.api.dita.DitaResultSetFilter;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.impl.ditabos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.impl.ditabos.DitaUtil;
import net.sourceforge.dita4publishers.impl.ditabos.DomUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;


/**
 *
 */
public class InMemoryDitaLinkManagementService implements DitaLinkManagementService {

	private static Log log = LogFactory.getLog(InMemoryDitaLinkManagementService.class);

	private Map<DitaKeyDefinitionContext, DitaKeySpace> keyspaceCache = new HashMap<DitaKeyDefinitionContext, DitaKeySpace>();
	private Map<String, DitaKeyDefinitionContext> contexts = new HashMap<String, DitaKeyDefinitionContext>();

	private List<DitaIdTarget> idTargetList = new ArrayList<DitaIdTarget>();

	private KeyAccessOptions defaultKeyAccessOptions = new KeyAccessOptions();

	private BosConstructionOptions bosOptions = null;

	/**
	 * @param bosOptions
	 */
	public InMemoryDitaLinkManagementService(BosConstructionOptions bosOptions) {
		this.bosOptions = bosOptions; // Provides DOM cache, other options.
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeys(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.ManagedObject)
	 */
	public Set<String> getKeys(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		log.info("getKeys(): Getting key space...");
		DitaKeySpace keySpace = getKeySpace(keyAccessOptions, keydefContext);
		log.info("getKeys(): Returning keys");
		return keySpace.getKeys(keyAccessOptions);
	}

	/**
	 * @param user
	 * @param rootMap
	 * @return
	 * @throws DitaApiException 
	 */
	private DitaKeySpace calculateKeySpaceForMap(DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		((KeyDefinitionContextImpl)keydefContext).setOutOfDate();
		Document rootMap = getDomForContext(keydefContext);
		DitaBoundedObjectSet mapBos = null;
		try {
			mapBos = DitaBosHelper.calculateMapTree(bosOptions,log, rootMap);
		} catch (Exception e) {
			throw new DitaApiException("Exception construction map tree and key space: " + e.getMessage(), e);
		}
		DitaKeySpace keySpace = mapBos.getKeySpace();
		keyspaceCache.put(keydefContext, keySpace);
		((KeyDefinitionContextImpl)keydefContext).setUpToDate();
		return keySpace;
	}

	/**
	 * @param keydefContext
	 * @return
	 * @throws DitaApiException 
	 */
	private Document getDomForContext(DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		String mapUri = keydefContext.getRootMapId();
		Document dom = null;
		if (this.bosOptions.getDomCache().containsKey(mapUri))
			return this.bosOptions.getDomCache().get(mapUri);
		
		try {
			dom = DomUtil.getDomForUri(new URI(mapUri), this.bosOptions);
		} catch (Exception e) {
			throw new DitaApiException("Exception constructing DOM for root map \"" + mapUri + "\"", e);
		}
		return dom;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyDefinition(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.ManagedObject, java.lang.String)
	 */
	public DitaKeyDefinition getKeyDefinition(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext,
			String key) throws DitaApiException {
		DitaKeySpace keySpace = getKeySpace(keyAccessOptions, keydefContext);
		return keySpace.getKeyDefinition(keyAccessOptions, key);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeySpace(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.ManagedObject)
	 */
	public DitaKeySpace getKeySpace(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		DitaKeySpace keySpace = null;
		if (isRegistered(keydefContext)) {
			if (keyspaceCache.containsKey(keydefContext)) {
				log.info("getKeySpace(): Getting key space from cache.");
				checkOutOfDateAndUpdateAsNeeded(keydefContext);
				keySpace = keyspaceCache.get(keydefContext);
			} else {		
				log.info("getKeySpace(): No keyspace in cache, calculating key space...");
				keySpace = calculateKeySpaceForMap(keydefContext);
			}
		} else {
			log.info("Key space for map [" + keydefContext.getRootMapId() + "] is not registered.");
		}
		return keySpace;
		
	}

	/**
	 * @param keydefContext
	 * @throws DitaApiException 
	 */
	private void checkOutOfDateAndUpdateAsNeeded(
			DitaKeyDefinitionContext keydefContext) throws DitaApiException {	
		if (keydefContext.isOutOfDate()) {
			log.info("Key space for map [" + keydefContext.getRootMapId() + "] is out of date, reloading...");
			calculateKeySpaceForMap(keydefContext);
		}
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyDefinitions(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.ManagedObject)
	 */
	public Set<DitaKeyDefinition> getEffectiveKeyDefinitions(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		DitaKeySpace keySpace = getKeySpace(keyAccessOptions, keydefContext);
		return keySpace.getEffectiveKeyDefinitions(keyAccessOptions);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getResource(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.ManagedObject, java.lang.String)
	 */
	public DitaResource getResource(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext,
			String key) throws DitaApiException {
		return resolveKeyToResource(keyAccessOptions, keydefContext, key);
	}

	/**
	 * @param user
	 * @param rootMap
	 * @param key
	 * @return
	 */
	private DitaResource resolveKeyToResource(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext, String key) throws DitaApiException {
		return resolveKeyToResource(keyAccessOptions, keydefContext, key, new ArrayList<DitaKeyDefinition>());
	}

	/**
	 * @param user
	 * @param keydefContext
	 * @param key
	 * @param seenKeyDefs
	 * @return
	 * @throws DitaApiException 
	 */
	private DitaResource resolveKeyToResource(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext, String key,
			List<DitaKeyDefinition> seenKeyDefs) throws DitaApiException {
		DitaKeyDefinition keyDef = getKeyDefinition(keyAccessOptions, keydefContext, key);
		if (seenKeyDefs.contains(keyDef)) {
			Document rootMap = getRootMapForContext(keyAccessOptions, keydefContext);
			throw new DitaApiException( "Circular reference to key \"" + key + 
					"\" in key space defined by map " + rootMap.getDocumentURI() + "], initial" +
							"key definition defines the key: \"" + seenKeyDefs.get(0).getKey());
		}
		String keyref = keyDef.getKeyref();
		DitaResource res = null;
		if (keyref != null) {
			if (keyref.equals(key)) {
				Document rootMap = getRootMapForContext(keyAccessOptions, keydefContext);
				throw new DitaApiException( "Key definition refers to itself: key \"" + key + 
						"\" in key space defined by map " + rootMap.getDocumentURI());
			}
			res = resolveKeyToResource(keyAccessOptions, keydefContext, keyref, seenKeyDefs);
		}
		
		if (res != null) return res;
		
		String href = keyDef.getHref();
		if (href != null) 
			return resolveHrefToResource(keyAccessOptions, keyDef, href);
		
		// If we get here, no keyref or href, look for linktext subelement.
		
		Element elem = null;
		
		return new DitaElementResourceImpl(elem);
	}

	/**
	 * @param user
	 * @param keydefContext
	 * @return
	 * @throws DitaApiException 
	 */
	private Document getRootMapForContext(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		String moId = keydefContext.getRootMapId();
		throw new NotImplementedException();
	}

	/**
	 * @param user
	 * @param keyDef
	 * @param href
	 * @return
	 * @throws DitaApiException 
	 */
	private DitaResource resolveHrefToResource(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinition keyDef, String href) throws DitaApiException {
		URL resUrl = keyDef.getAbsoluteUrl();
		DitaFormat format = keyDef.getFormat();
		switch (format) {
		case DITA:
		case DITAMAP:
			Element elem = resolveUriToElement(keyAccessOptions, resUrl);
			return new DitaElementResourceImpl(resUrl, elem);
		case HTML:
		case NONDITA:
			return new DitaResourceImpl(resUrl);
		default:
			throw new DitaApiException( "Uexpected value " + format + " for DitaFormat enumeration.");
		}
		
	}

	/**
	 * @param keyAccessOptions Options that control access to resources.
	 * @param resUrl Absolute URL of the target resource.
	 * @return Root element of the target resource (topic or map).
	 */
	private Element resolveUriToElement(KeyAccessOptions keyAccessOptions, URL resUrl) throws DitaApiException {
		Element result = null;
		Document doc = null;
		String urlString = resUrl.toExternalForm();
		String resUrlString = null;
		if (urlString.contains("#")) {
			resUrlString = urlString.substring(0, urlString.indexOf("#"));
		} else {
			resUrlString = urlString;
		}

		try {
			InputSource src = new InputSource(resUrl.openStream());
			src.setSystemId(resUrlString);
			doc = DomUtil.getDomForSource(src, bosOptions, false);
		} catch (Exception e) {
			throw new DitaApiException( "Exception contructing DOM from URL " + resUrl + ": " + e.getMessage(), e);
		}
		
		if (urlString.contains("#")) {
			String fragId = urlString.split("#")[1];
			result = DitaUtil.resolveDitaFragmentId(doc, fragId);
		} else {
			result = DitaUtil.getImplicitElementFromDoc(doc);
		}
		
		return result;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyWhereUsed(com.reallysi.rsuite.api.keyAccessOptions, java.lang.String)
	 */
	public List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key)  throws DitaApiException {
		return new ArrayList<DitaReference>();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyWhereUsed(com.reallysi.rsuite.api.keyAccessOptions, java.lang.String, com.reallysi.rsuite.api.ManagedObject)
	 */
	public List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key,
			DitaKeyDefinitionContext keydefContext)  throws DitaApiException{
		return new ArrayList<DitaReference>();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyWhereUsed(com.reallysi.rsuite.api.keyAccessOptions, java.lang.String, java.lang.String)
	 */
	public List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key,
			DitaResultSetFilter filter)  throws DitaApiException{
		return new ArrayList<DitaReference>();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyWhereUsed(com.reallysi.rsuite.api.keyAccessOptions, java.lang.String, java.lang.String, com.reallysi.rsuite.api.ManagedObject)
	 */
	public List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key,
			DitaResultSetFilter filter, DitaKeyDefinitionContext keydefContext)  throws DitaApiException {
		return new ArrayList<DitaReference>();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyDefinitionContext(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public DitaKeyDefinitionContext getKeyDefinitionContext(Document rootMap) throws DitaApiException {
		if (rootMap == null)
			return null;
		if (!this.contexts .containsKey(rootMap.getDocumentURI())) {
			DitaKeyDefinitionContext context = new KeyDefinitionContextImpl(rootMap);
			this.contexts.put(rootMap.getDocumentURI(), context);
		}
		return this.contexts.get(rootMap.getDocumentURI());
		
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyWhereUsed(com.reallysi.rsuite.api.keyAccessOptions, java.lang.String, com.reallysi.rsuite.api.dita.DitaResultSetFilter, com.reallysi.rsuite.api.ManagedObject)
	 */
	public List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key,
			DitaResultSetFilter filter, Document topic01)
			throws DitaApiException {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getAllKeyDefinitions(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		DitaKeySpace keySpace = this.keyspaceCache.get(keydefContext);
		return keySpace.getAllKeyDefinitions(keyAccessOptions);
	}
	
	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyDefinitionsForKey(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext, java.lang.String)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitionsForKey(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext, String key) throws DitaApiException {
		DitaKeySpace keySpace = this.keyspaceCache.get(keydefContext);
		return keySpace.getAllKeyDefinitions(keyAccessOptions, key);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyDefinitionsForKey(com.reallysi.rsuite.api.keyAccessOptions, java.lang.String)
	 */
	public List<DitaKeyDefinition> getAllKeyDefinitionsForKey(KeyAccessOptions keyAccessOptions,
			String key) throws DitaApiException {
		List<DitaKeyDefinition> keyDefs = new ArrayList<DitaKeyDefinition>();
		this.updateKeyspaceCache();
		for (DitaKeyDefinitionContext kdContext : this.keyspaceCache.keySet()) {
			DitaKeySpace keySpace = this.keyspaceCache.get(kdContext);
			List<DitaKeyDefinition> keyDefSet = keySpace.getAllKeyDefinitions(keyAccessOptions, key); 
			keyDefs.addAll(keyDefSet);
		}
		return keyDefs;
	}
	
	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getEffectiveKeyDefinitionsForKey(com.reallysi.rsuite.api.keyAccessOptions, java.lang.String)
	 */
	public Set<DitaKeyDefinition> getEffectiveKeyDefinitionsForKey(KeyAccessOptions keyAccessOptions,
			String key) throws DitaApiException {
		Set<DitaKeyDefinition> keyDefs = new TreeSet<DitaKeyDefinition>();
		this.updateKeyspaceCache();
		for (DitaKeyDefinitionContext kdContext : this.keyspaceCache.keySet()) {
			DitaKeySpace keySpace = this.keyspaceCache.get(kdContext);
			keyDefs.add(keySpace.getKeyDefinition(keyAccessOptions, key));
		}
		return keyDefs;
	}


	/**
	 * Finds all root DITA maps in the repository and processes them
	 * as key spaces.
	 */
	private void updateKeyspaceCache() {
		// NOP in this mock implementation.
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#isKeyDefined(java.lang.String)
	 */
	public boolean isKeyDefined(String key) throws DitaApiException {
		return isKeyDefined(new KeyAccessOptions(), key);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#isKeyDefined(java.lang.String)
	 */
	public boolean isKeyDefined(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException {
		for (DitaKeySpace keySpace : this.keyspaceCache.values()) {
			if (keySpace.definesKey(keyAccessOptions, key)) {
				return true;
			}
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#isKeyDefined(java.lang.String, com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public boolean isKeyDefined(String key,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		return isKeyDefined(keydefContext.getKeyAccessOptions(), key, keydefContext);
	}
	
	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaLinkManagementService#isKeyDefined(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions, java.lang.String, net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext)
	 */
	public boolean isKeyDefined(KeyAccessOptions keyAccessOptions, String key,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException {
		DitaKeySpace keySpace = getKeySpace(keyAccessOptions, keydefContext);
		if (keySpace != null) {
			return keySpace.definesKey(keyAccessOptions, key);
		}
		return false;	
	}



	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#constructDitaElementResource(com.reallysi.rsuite.api.ManagedObject)
	 */
	public DitaElementResource constructDitaElementResource(Document resourceDoc)
			throws DitaApiException {
		return new DitaElementResourceImpl(resourceDoc);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getWhereUsed(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.service.impl.DitaElementResource)
	 */
	public List<Document> getWhereUsed(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget) {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getWhereUsed(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.service.impl.DitaElementResource, com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public List<Document> getWhereUsed(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget,
			DitaKeyDefinitionContext keydefContext) {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyBindings(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.service.impl.DitaElementResource)
	 */
	public List<DitaKeyDefinition> getKeyBindings(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget) {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getKeyBindings(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.dita.DitaResource, com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public List<DitaKeyDefinition> getKeyBindings(KeyAccessOptions keyAccessOptions,
			DitaResource potentialTarget, DitaKeyDefinitionContext keydefContext) {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getWhereUsedByKey(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.service.impl.DitaElementResource, com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public List<Document> getWhereUsedByKey(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget,
			DitaKeyDefinitionContext keydefContext) {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#markKeySpaceOutOfDate(com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public void markKeySpaceOutOfDate(DitaKeyDefinitionContext keydefContext)
			throws DitaApiException {
		((KeyDefinitionContextImpl)keydefContext).setOutOfDate();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#registerRootMap(com.reallysi.rsuite.api.ManagedObject)
	 */
	public DitaKeyDefinitionContext registerRootMap(Document rootMap)
			throws DitaApiException {
		if (!this.isRegistered(rootMap)) {
			DitaKeyDefinitionContext context = this.getKeyDefinitionContext(rootMap);
 			log.info("registerRootMap(): Key space not registered, loading...");
			this.calculateKeySpaceForMap(context);
			return context;
		} else {
			log.info("registerRootMap(): Key space already registered.");
		}
		return null;
	}

	/**
	 * @param rootMap
	 * @return
	 */
	public boolean isRegistered(Document rootMap)  throws DitaApiException {
		if (rootMap == null)
			return false;
		String docURI = rootMap.getDocumentURI();
		if (docURI == null || "".equals(docURI))
			log.warn("isRegistered(): rootMap has null or empty document URI.");
		return this.contexts.containsKey(rootMap.getDocumentURI());
	}

	/**
	 * @param rootMap
	 * @return
	 * @throws DitaApiException 
	 */
	public boolean isRegistered(DitaKeyDefinitionContext context) throws DitaApiException {
		return this.contexts.containsKey(context.getRootMapId());
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#unRegisterKeySpace(com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext)
	 */
	public void unRegisterKeySpace(DitaKeyDefinitionContext keydefContext)
			throws DitaApiException {
		log.info("unRegisterKeySpace(): Unregistering key space " + keydefContext);
		this.keyspaceCache.remove(keydefContext);
		this.contexts.remove(keydefContext.getRootMapId());
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#unRegisterRootMap(com.reallysi.rsuite.api.ManagedObject)
	 */
	public void unRegisterRootMap(Document rootMap) throws DitaApiException {
		DitaKeyDefinitionContext context = this.getKeyDefinitionContext(rootMap);
		if (this.keyspaceCache.containsKey(context)) {
			log.info("unRegisterRootMap(): Key space registered, removing...");
			this.keyspaceCache.remove(context);
			this.contexts.remove(rootMap.getDocumentURI());
		} else {
			log.info("registerRootMap(): Key space for root map not found.");
		}
		
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getIdTargets(com.reallysi.rsuite.api.User)
	 */
	public List<DitaIdTarget> getIdTargets(KeyAccessOptions keyAccessOptions) {
		return this.idTargetList ;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.service.DitaLinkManagementService#getIdTarget(com.reallysi.rsuite.api.keyAccessOptions, com.reallysi.rsuite.api.ManagedObject, java.lang.String, java.lang.String)
	 */
	public DitaIdTarget getIdTarget(KeyAccessOptions keyAccessOptions, Document targetDoc,
			String topicId, String elemId) {
		Element targetElem = null; // FIXME: Find the actual element.
		return new DitaIdTargetImpl(targetDoc, targetElem);
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaLinkManagementService#registerRootMap(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions, org.w3c.dom.Document)
	 */
	public DitaKeyDefinitionContext registerRootMap(
			KeyAccessOptions keyAccessOptions, Document rootMap)
			throws DitaApiException {
		throw new NotImplementedException();
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaLinkManagementService#setDefaultKeyAccessOptions(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public void setDefaultKeyAccessOptions(KeyAccessOptions keyAccessOptions)
			throws DitaApiException {
		// FIXME: If old options specify filtered key spaces and the new
		//        options specify unfiltered key spaces, could either throw
		//        an exception or reconstruct all the spaces. Probably the former.
		this.defaultKeyAccessOptions = keyAccessOptions;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaLinkManagementService#getDefaultKeyAccessOptions()
	 */
	public KeyAccessOptions getDefaultKeyAccessOptions()
			throws DitaApiException {
		return this.defaultKeyAccessOptions;
	}


}
