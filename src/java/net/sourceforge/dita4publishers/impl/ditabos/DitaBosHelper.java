/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;

import org.apache.commons.logging.Log;
import org.jbpm.graph.exe.ExecutionContext;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * Provides RSuite-specific DITA processing support. 
 */
public class DitaBosHelper {
	

	/**
	 * @param context
	 * @param log 
	 * @param mo
	 * @return
	 */
	public static BoundedObjectSet calculateMapBos(
			ExecutionContext context, Log log, Document rootMap) throws DitaBosHelperException {

		// Walk the tree of pointers, adding unique MOs to the list:
		Map<URI, Document> domCache = new HashMap<URI, Document>();
		
		BosConstructionOptions domOptions = new BosConstructionOptions(log, domCache);

		BoundedObjectSet bos = new BoundedObjectSetImpl(domOptions);
		
		log.info("calculateMapBos(): Starting map BOS calculation...");
		
		Element elem = rootMap.getDocumentElement();
		if (!DitaUtil.isDitaMap(elem) && !DitaUtil.isDitaTopic(elem)) {
			throw new DitaBosHelperException("Input root map " + rootMap.getDocumentURI() + " does not appear to be a DITA map or topic.");
		}
		
		DitaKeySpace keySpace = new DitaKeySpace(domOptions);
		
//		DitaTreeWalker walker = new DitaMoTreeWalker(log, keySpace, domOptions);
//		walker.setRootObject(rootMap);
//		walker.walk(bos);
		
		log.info("calculateMapBos(): Returning BOS. BOS has " + bos.size() + " members.");
		return bos;
	}

	/**
	 * @param context
	 * @param log
	 * @param mapDoc
	 * @param bosConstructionOptions 
	 * @return
	 * @throws DitaBosHelperException 
	 */
	public static BoundedObjectSet calculateMapBos(
			ExecutionContext context, Log log, Document mapDoc, BosConstructionOptions bosConstructionOptions) throws DitaBosHelperException {
		BoundedObjectSet bos = new BoundedObjectSetImpl(bosConstructionOptions);
		
		log.info("calculateMapBos(): Starting map BOS calculation...");
		
		Element elem = mapDoc.getDocumentElement();
		if (!DitaUtil.isDitaMap(elem)) {
			throw new DitaBosHelperException("Input document " + mapDoc.getDocumentURI()  + " does not appear to be a DITA map.");
		}
		
		DitaKeySpace keySpace = new DitaKeySpace(bosConstructionOptions);
		
//		DitaTreeWalker walker = new DitaFileTreeWalker(context, log, keySpace, bosConstructionOptions);
//		walker.setRootObject(mapDoc);
//		walker.walk(bos);
		
		log.info("calculateMapBos(): Returning BOS. BOS has " + bos.size() + " members.");
		return bos;
		
	}
	


}
