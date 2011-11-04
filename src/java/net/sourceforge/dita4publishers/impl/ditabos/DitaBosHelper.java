/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.api.ditabos.DitaTreeWalker;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.dita.InMemoryDitaKeySpace;
import net.sourceforge.dita4publishers.impl.dita.KeyDefinitionContextImpl;
import net.sourceforge.dita4publishers.util.DitaUtil;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * Provides DITA BOS construction support and business logic. 
 */
public class DitaBosHelper {
	

	/**
	 * Constructs a full DITA BOS from the specified root map using the specified BOS construction options.
	 * @param bosOptions
	 * @param log 
	 * @param rootMap
	 * @return
	 * @throws Exception 
	 */
	public static DitaBoundedObjectSet calculateMapBos(
			BosConstructionOptions bosOptions, Log log, Document rootMap) throws Exception {

		Map<URI, Document> domCache = bosOptions.getDomCache();
		
		if (domCache == null) {
			domCache = new HashMap<URI, Document>();
			bosOptions.setDomCache(domCache);
		}
		
		DitaBoundedObjectSet bos = new DitaBoundedObjectSetImpl(bosOptions);
		
		if (!bosOptions.isQuiet())
			log.info("calculateMapBos(): Starting map BOS calculation...");
		
		Element elem = rootMap.getDocumentElement();
		if (!DitaUtil.isDitaMap(elem) && !DitaUtil.isDitaTopic(elem)) {
			throw new DitaBosHelperException("Input root map " + rootMap.getDocumentURI() + " does not appear to be a DITA map or topic.");
		}
		
		DitaKeySpace keySpace;
		try {
			DitaKeyDefinitionContext keyDefContext = new KeyDefinitionContextImpl(rootMap);
			keySpace = new InMemoryDitaKeySpace(keyDefContext, rootMap, bosOptions);
		} catch (DitaApiException e) {
			throw new BosException("DITA API Exception: " + e.getMessage(), e);
		}
		
		DitaTreeWalker walker = new DitaDomTreeWalker(log, keySpace, bosOptions);
		walker.setRootObject(rootMap);
		walker.walk(bos);
		
		if (!bosOptions.isQuiet())
			log.info("calculateMapBos(): Returning BOS. BOS has " + bos.size() + " members.");
		return bos;
	}

	/**
	 * Constructs just the map tree part of a DITA bounded object set.
	 * @param bosOptions
	 * @param log
	 * @param rootMap
	 * @return
	 * @throws Exception 
	 */
	public static DitaBoundedObjectSet calculateMapTree(
			BosConstructionOptions bosOptions, Log log, Document rootMap) throws Exception {
		bosOptions.setMapTreeOnly(true);
		DitaBoundedObjectSet bos = calculateMapBos(bosOptions, log, rootMap);
		return bos;
	}

}
