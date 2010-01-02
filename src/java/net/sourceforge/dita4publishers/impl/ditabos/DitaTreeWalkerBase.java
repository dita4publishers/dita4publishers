/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.bos.BoundedObjectSet;
import net.sourceforge.dita4publishers.api.bos.DependencyType;
import net.sourceforge.dita4publishers.api.bos.NonXmlBosMember;
import net.sourceforge.dita4publishers.api.bos.XmlBosMember;
import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.ditabos.ConrefDependency;
import net.sourceforge.dita4publishers.api.ditabos.Constants;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.api.ditabos.DitaTreeWalker;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.dita.AddressingException;
import net.sourceforge.dita4publishers.impl.dita.AddressingUtil;
import net.sourceforge.dita4publishers.util.DitaUtil;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;

/**
 * Base class for DITA tree walkers
 */
public abstract class DitaTreeWalkerBase extends TreeWalkerBase implements DitaTreeWalker {

	protected DitaKeySpace keySpace;
	/**
	 * Holds the list of BosMembers we've already walked to get their
	 * dependencies, so we don't walk the same member twice.
	 */
	private List<BosMember> walkedMembers = new ArrayList<BosMember>();
	/**
	 * @param keySpace
	 * @param bosConstructionOptions 
	 * @throws BosException 
	 */
	public DitaTreeWalkerBase(Log log,
			DitaKeySpace keySpace, BosConstructionOptions bosConstructionOptions) throws BosException {
		super(log, bosConstructionOptions);
		this.keySpace = keySpace;		
	}

	/**
	 * @param bos
	 * @param nonXmlBosMember
	 * @param level 
	 */
	protected void walkNonDitaResource(BoundedObjectSet bos, NonXmlBosMember nonXmlBosMember, int level) throws BosException {
		throw new NotImplementedException();
	}

	/**
	 * @param bos
	 * @param xmlBosMember
	 * @param level 
	 * @throws BosException 
	 */
	protected void walkTopic(BoundedObjectSet bos, XmlBosMember xmlBosMember, int level) throws BosException {
		try {
			walkTopicGetDependencies(bos, xmlBosMember);
		} catch (DitaApiException e) {
			throw new BosException("DITA API exception walking topic", e);
		}
	}

	/**
	 * @param bos
	 * @param member
	 * @throws BosException 
	 * @throws DitaApiException 
	 */
	protected void walkMapGetDependencies(BoundedObjectSet bos, DitaMapBosMemberImpl member)
			throws BosException, DitaApiException {
				NodeList topicrefs;
				try {
					topicrefs = (NodeList)DitaUtil.allTopicrefs.evaluate(member.getElement(), XPathConstants.NODESET);
				} catch (XPathExpressionException e) {
					throw new BosException("Unexcepted exception evaluating xpath " + DitaUtil.allTopicrefs);
				}
				
				Set<BosMember> newMembers = new HashSet<BosMember>(); 
				
				for (int i = 0;i < topicrefs.getLength(); i++) {
					Element topicref = (Element)topicrefs.item(i);
					Document targetDoc = null;
					URI targetUri = null;
					
					// For now, only consider local resources. 
					if (!DitaUtil.isLocalScope(topicref))
						continue;
					
					// If there is a key reference, attempt to resolve it,
					// then fall back to href, if any.
					String href = null;
					
					try {
						if (bosConstructionOptions.isMapTreeOnly()) {
							if (DitaUtil.targetIsADitaMap(topicref) && topicref.hasAttribute("href")) {
								href = topicref.getAttribute("href");
								// Don't bother resolving pointers to the same doc.
								// We don't record dependencies on ourself.
								if (!href.startsWith("#"))
									targetDoc = AddressingUtil.resolveHrefToDoc(topicref, href, bosConstructionOptions, this.failOnAddressResolutionFailure);								
							}
						} else if (DitaUtil.targetIsADitaFormat(topicref)) {
	 						if (topicref.hasAttribute("keyref")) {
								targetDoc = resolveKeyrefToDoc(topicref.getAttribute("keyref"));
							}
							if (targetDoc == null && topicref.hasAttribute("href")) {
								href = topicref.getAttribute("href");
								// Don't bother resolving pointers to the same doc.
								// We don't record dependencies on ourself.
								if (!href.startsWith("#"))
									targetDoc = AddressingUtil.resolveHrefToDoc(topicref, href, bosConstructionOptions, this.failOnAddressResolutionFailure);
							}
						} else {
							if (topicref.hasAttribute("keyref")) {
								targetUri = resolveKeyrefToUri(topicref.getAttribute("keyref"));
							}
							if (targetUri == null && topicref.hasAttribute("href")) {
								href = topicref.getAttribute("href");
								// Don't bother resolving pointers to the same doc.
								// We don't record dependencies on ourself.
								if (!href.startsWith("#"))
									targetUri = AddressingUtil.resolveHrefToUri(topicref, href, this.failOnAddressResolutionFailure);
							}
						}
					} catch (AddressingException e) {
						if (this.failOnAddressResolutionFailure) {
							throw new BosException("Failed to resolve href \"" + topicref.getAttribute("href") + "\" to a managed object", e);
						}
					}
					
					BosMember childMember = null;
					if (targetDoc != null) {								
						childMember = bos.constructBosMember(member, targetDoc);
					}
					if (targetUri != null) {
						childMember = bos.constructBosMember(member, targetUri);
					}
					if (childMember != null) {
						bos.addMember(member, childMember);
						newMembers.add((BosMember)childMember);
						if (href != null)
							member.registerDependency(href, childMember, Constants.TOPICREF_DEPENDENCY);
					}
				}
				
				// Now walk the new members:
				
				for (BosMember newMember : newMembers) {
					if (!walkedMembers.contains(newMember))
						walkMemberGetDependencies(bos, newMember);
				}
				
			}

	/**
	 * @param bos
	 * @param member
	 * @throws BosException 
	 * @throws DitaApiException 
	 */
	protected void walkMemberGetDependencies(BoundedObjectSet bos, BosMember member)
			throws BosException, DitaApiException {
				if (!(member instanceof XmlBosMember)) {
					// Nothing to do for now. At some point should be able
					// to delegate to walker for non-XML objects.
				} else {
					Element elem = ((XmlBosMember)member).getElement();
					this.walkedMembers.add(member);
					if (DitaUtil.isDitaMap(elem)) {
						walkMapGetDependencies(bos, (DitaMapBosMemberImpl)member);
					} else if (DitaUtil.isDitaTopic(elem) || DitaUtil.isDitaBase(elem)) {
						walkTopicGetDependencies(bos, (DitaTopicBosMemberImpl)member);
					} else {
						log.warn("XML Managed object of type \"" + elem.getTagName() + "\" is not recognized as a map or topic. Not examining for dependencies");
					}
				}
				
			}

	/**
	 * @param bos
	 * @param member
	 * @throws BosException 
	 * @throws DitaApiException 
	 */
	private void walkTopicGetDependencies(BoundedObjectSet bos, XmlBosMember member)
			throws BosException, DitaApiException {
				log.debug("walkTopicGetDependencies(): handling topic " + member + "...");
				Set<BosMember> newMembers = new HashSet<BosMember>(); 
				log.debug("walkTopicGetDependencies():   getting conref dependencies...");
			
				findConrefDependencies(bos, member, newMembers);
				log.debug("walkTopicGetDependencies():   getting link dependencies...");
				findLinkDependencies(bos, member, newMembers);

				findObjectDependencies(bos, member, newMembers);

				// Now walk the new members:
				
				log.debug("walkTopicGetDependencies(): Found " + newMembers.size() + " new members.");
				
				for (BosMember newMember : newMembers) {
					if (!walkedMembers.contains(newMember)) {
						log.debug("walkTopicGetDependencies(): walking unwalked dependency member " + member + "...");
						walkMemberGetDependencies(bos, newMember);
					}
				}
				
			}

	/**
	 * @param bos
	 * @param member
	 * @param newMembers
	 */
	private void findObjectDependencies(BoundedObjectSet bos,
			XmlBosMember member, Set<BosMember> newMembers) 
			throws BosException {
		NodeList objects;
		try {
			objects = (NodeList)DitaUtil.allObjects.evaluate(member.getElement(), XPathConstants.NODESET);
		} catch (XPathExpressionException e) {
			throw new BosException("Unexcepted exception evaluating xpath " + DitaUtil.allObjects);
		}
		
		log.debug("findObjectDependencies(): Found " + objects.getLength() + " topic/object elements");

		for (int i = 0;i < objects.getLength(); i++) {
			Element objectElem = (Element)objects.item(i);
			URI targetUri = null;
			
			// If there is a key reference, attempt to resolve it,
			// then fall back to href, if any.
			String href = null;
			try {
				if (objectElem.hasAttribute("data")) {
					log.debug("findObjectDependencies(): resolving reference to data \"" + objectElem.getAttribute("data") + "\"...");
					href = objectElem.getAttribute("data");
					// FIXME: This assumes that the @data value will be a relative URL. In fact, it could be relative
					//        to the value of the @codebase attribute if specified.
					targetUri = AddressingUtil.resolveObjectDataToUri(objectElem, this.failOnAddressResolutionFailure);
				}
			} catch (AddressingException e) {
				if (this.failOnAddressResolutionFailure) {
					throw new BosException("Failed to resolve @data \"" + objectElem.getAttribute("data") + "\" to a resource", e);
				}
			}
			
			if (targetUri == null)
				continue;

			BosMember childMember = null;
			if (targetUri != null) {
				log.debug("findObjectDependencies(): Got URI \"" + targetUri.toString() + "\"");
				childMember = bos.constructBosMember((BosMember)member, targetUri);
			}
			bos.addMember(member, childMember);
			newMembers.add(childMember);
			if (href != null)
				member.registerDependency(href, childMember, Constants.OBJECT_DEPENDENCY);
		}

	}

	/**
	 * @param bos
	 * @param member
	 * @param newMembers
	 * @throws BosException 
	 * @throws DitaApiException 
	 */
	protected void findLinkDependencies(BoundedObjectSet bos, XmlBosMember member, Set<BosMember> newMembers)
			throws BosException, DitaApiException {
				NodeList links;
				try {
					links = (NodeList)DitaUtil.allHrefsAndKeyrefs.evaluate(member.getElement(), XPathConstants.NODESET);
				} catch (XPathExpressionException e) {
					throw new BosException("Unexcepted exception evaluating xpath " + DitaUtil.allTopicrefs);
				}
				
				log.debug("findLinkDependencies(): Found " + links.getLength() + " href- or keyref-using elements");
				
				for (int i = 0;i < links.getLength(); i++) {
					Element link = (Element)links.item(i);
					Document targetDoc = null;
					URI targetUri = null;
					String dependencyKey = null; // Original href or keyref value
					
					// If there is a key reference, attempt to resolve it,
					// then fall back to href, if any.
					String href = null;
					DependencyType depType = Constants.LINK_DEPENDENCY;
					if (DitaUtil.isDitaType(link, "topic/image")) {
						depType = Constants.IMAGE_DEPENDENCY;
					} else if (DitaUtil.isDitaType(link, "topic/xref")) {
						depType = Constants.XREF_DEPENDENCY;
					}
					try {
						if (link.hasAttribute("keyref")) {
							log.debug("findLinkDependencies(): resolving reference to key \"" + link.getAttribute("keyref") + "\"...");
							if (!DitaUtil.targetIsADitaFormat(link) || DitaUtil.isDitaType(link, "topic/image")) {
								targetUri = resolveKeyrefToUri(link.getAttribute("keyref"));
							} else {
								targetDoc = resolveKeyrefToDoc(link.getAttribute("keyref"));
							}
						}
						if (targetUri == null && targetDoc == null && link.hasAttribute("href")) {
							log.debug("findLinkDependencies(): resolving reference to href \"" + link.getAttribute("href") + "\"...");
							href = link.getAttribute("href");
							dependencyKey = href;
							if (DitaUtil.isDitaType(link, "topic/image")) {
								targetUri = AddressingUtil.resolveHrefToUri(link, link.getAttribute("href"), this.failOnAddressResolutionFailure);
							} else if (!DitaUtil.targetIsADitaFormat(link) && 
									   DitaUtil.isLocalOrPeerScope(link)) {
										targetUri = AddressingUtil.resolveHrefToUri(link, link.getAttribute("href"), this.failOnAddressResolutionFailure);
							} else {
								// If we get here, isn't an image reference and is presumably a DITA format resource.
								// Don't bother with links within the same XML document.
								if (!href.startsWith("#") && DitaUtil.isLocalOrPeerScope(link)) {
									targetDoc = AddressingUtil.resolveHrefToDoc(link, link.getAttribute("href"), bosConstructionOptions, this.failOnAddressResolutionFailure);
								}
								
							}
						} else {
							dependencyKey = AddressingUtil.getKeyNameFromKeyref(link);
						}
					} catch (AddressingException e) {
						if (this.failOnAddressResolutionFailure) {
							throw new BosException("Failed to resolve href \"" + link.getAttribute("href") + "\" to a managed object", e);
						}
					}
					
					if (targetDoc == null && targetUri == null || targetDoc == member.getDocument())
						continue;

					BosMember childMember = null;
					if (targetDoc != null) {		
						log.debug("findLinkDependencies(): Got document \"" + targetDoc.getDocumentURI() + "\"");
						childMember = bos.constructBosMember(member, targetDoc);
					} else if (targetUri != null) {
						log.debug("findLinkDependencies(): Got URI \"" + targetUri.toString() + "\"");
						childMember = bos.constructBosMember((BosMember)member, targetUri);
					}
					newMembers.add(childMember);
					// Key references don't need to be rewritten so we only care if an href was used to resolve the dependency
					member.registerDependency(dependencyKey, childMember, depType);
				}
				
			}


	private void findConrefDependencies(BoundedObjectSet bos, XmlBosMember member, Set<BosMember> newMembers)
			throws BosException, DitaApiException {
				NodeList conrefs;
				try {
					conrefs = (NodeList)DitaUtil.allConrefs.evaluate(member.getElement(), XPathConstants.NODESET);
				} catch (XPathExpressionException e) {
					throw new BosException("Unexpected exception evaluating xpath " + DitaUtil.allTopicrefs);
				}
				
				
				for (int i = 0;i < conrefs.getLength(); i++) {
					Element conref = (Element)conrefs.item(i);
					Document targetDoc = null;
					
					// If there is a key reference, attempt to resolve it,
					// then fall back to href, if any.
					String href = null;
					try {
						if (conref.hasAttribute("conkeyref")) {
							targetDoc = resolveKeyrefToDoc(conref.getAttribute("conkeyref"));
						}
						if (targetDoc == null && conref.hasAttribute("conref")) {
							href = conref.getAttribute("conref");
							if (!href.startsWith("#"))
								targetDoc = AddressingUtil.resolveHrefToDoc(conref, href, bosConstructionOptions, this.failOnAddressResolutionFailure);
						}
					} catch (AddressingException e) {
						if (this.failOnAddressResolutionFailure) {
							throw new BosException("Failed to resolve href \"" + conref.getAttribute("conref") + "\" to a managed object", e);
						}
					}
					
					if (targetDoc != null && targetDoc != member.getDocument()) {		
						BosMember childMember = bos.constructBosMember(member, targetDoc);
						// bos.addMember(member, childMember);
						newMembers.add(childMember);
						if (href != null) {
							member.registerDependency(href, childMember, Constants.CONREF_DEPENDENCY);
							
						}
					}
				}
			}

	/**
	 * @param key
	 * @return Document to which key 
	 * @throws DitaApiException 
	 * @throws AddressingException 
	 * @throws BosException 
	 */
	private Document resolveKeyrefToDoc(String key) throws DitaApiException, AddressingException {
		try {
			return keySpace.resolveKeyToDocument(key, this.bosConstructionOptions.getKeyAccessOptions());
		} catch (AddressingException e) {
			if (this.failOnAddressResolutionFailure) {
				throw new AddressingException("Failed to resolve key reference to key \"" + key + "\": " + e.getMessage());
			}
		}
		return null;
	}
	
	/**
	 * @param key
	 * @return
	 * @throws DitaApiException 
	 */
	private URI resolveKeyrefToUri(String key) throws DitaApiException {
		try {
			return keySpace.resolveKeyToUri(key, this.bosConstructionOptions.getKeyAccessOptions());
		} catch (AddressingException e) {
			if (this.failOnAddressResolutionFailure) {
				throw new BosException("Failed to resolve key reference to key \"" + key + "\": " + e.getMessage());
			}
		}
		return null;
	}


	/**
	 * @param bos
	 * @param object
	 * @param elem
	 * @param level
	 * @throws BosException 
	 * @throws DitaApiException 
	 */
	protected void walkMapCalcMapTree(BoundedObjectSet bos, XmlBosMember currentMember, Document mapDoc,
			int level) throws BosException, DitaApiException {
				String levelSpacer = getLevelSpacer(level);
				
				log.debug("walkMap(): " + levelSpacer + "Walking map  " + mapDoc.getDocumentURI() + "...");
			
				Element mapRoot = mapDoc.getDocumentElement();
				
				NodeList resultNl;
				try {
					resultNl = (NodeList)DitaUtil.allTopicrefsWithHrefs.evaluate(mapRoot, XPathConstants.NODESET);
				} catch (XPathExpressionException e) {
					throw new BosException("XPath exception evaluating XPath against a DITA map managed object: " + e.getMessage(), e);
				}
				
				List<Document> childMaps = new ArrayList<Document>();
				
				for (int i = 0;i < resultNl.getLength(); i++) {
					Element topicRef = (Element)resultNl.item(i);
					if (DitaUtil.isMapReference(topicRef)) {
						String href = topicRef.getAttribute("href");
						log.debug("walkMap(): " + levelSpacer + "  handling map reference to href \"" + href + "\"...");
						Document targetDoc = null;
						try {
							targetDoc = AddressingUtil.resolveHrefToDoc(topicRef,href, bosConstructionOptions, this.failOnAddressResolutionFailure);
						} catch (Exception e) {
							throw new BosException("Exception resolving href: " + e.getMessage(), e);
						}
						if (targetDoc != null) {
							childMaps.add(targetDoc);
						} else {
							throw new BosException("Failed to resolve @href value \"" + href + "\" to a managed object from map " + mapDoc.getDocumentURI());
						}
					}
				}
			
				log.debug("walkMap(): " + levelSpacer + "  Found " + childMaps.size() + " child maps.");
			
				// Now we have a list of the child maps in document order by reference.
				// Iterate over them to update the key space:
				
				if (childMaps.size() > 0) {
					log.debug("walkMap(): " + levelSpacer + "  Adding key definitions from child maps...");
					
					for (Document childMap : childMaps) {
						keySpace.addKeyDefinitions(childMap.getDocumentElement());
					}
					
					// Now walk each of the maps to process the next level in the map hierarchy:
					
					log.debug("walkMap(): " + levelSpacer + "  Walking child maps...");
					for (Document childMapDoc : childMaps) {
						XmlBosMember childMember = bos.constructBosMember(currentMember, childMapDoc);
						bos.addMember(currentMember, childMember);
						walkMapCalcMapTree(bos, childMember, childMapDoc, level + 1);
					}
					log.debug("walkMap(): " + levelSpacer + "  Done walking child maps");
				}
				
			}


	public void walk(DitaBoundedObjectSet bos, Document mapDoc) throws BosException, DitaApiException {
		URI mapUri;
		try {
			String mapUriStr = mapDoc.getDocumentURI();
			if (mapUriStr == null || "".equals(mapUriStr))
				throw new BosException("Map document has a null or empty document URI property. Cannot continue.");
			mapUri = new URI(mapUriStr);
		} catch (URISyntaxException e) {
			throw new BosException("Failed to construct URI from document URI \"" + mapDoc.getDocumentURI() + "\": " + e.getMessage());
		}
		log.debug("walk(): Walking document " + mapUri.toString() + "...");
		// Add this map's keys to the key space.
		
		XmlBosMember member = bos.constructBosMember((BosMember)null, mapDoc);
		Element elem = mapDoc.getDocumentElement();
	
		bos.setRootMember(member);
		bos.setKeySpace(keySpace);
	
		// NOTE: if input is a map, then walking the map
		// will populate the key namespace before processing
		// any topics, so that key references can be resolved.
		// If the input is a topic, then the key space must have
		// already been populated if there are any key references
		// to be resolved.
		
		
		if (DitaUtil.isDitaMap(elem)) {
			log.debug("walk(): Adding root map's keys to key space...");
			keySpace.addKeyDefinitions(elem);
			
			// Walk the map to determine the tree of maps and calculate
			// the key space rooted at the starting map:
			log.debug("walk(): Walking the map to calculate the map tree...");
			walkMapCalcMapTree(bos, member, mapDoc, 1);
			log.debug("walk(): Map tree calculated.");
			
			// At this point, we have a set of map BOS members and a populated key space;
			// Iterate over the maps to find all non-map dependencies (topics, images,
			// objects, xref targets, and link targets):
	
			log.debug("walk(): Calculating map dependencies for map " + member.getKey() + "...");
			Collection<BosMember> mapMembers = bos.getMembers();
			Iterator<BosMember> iter = mapMembers.iterator();
			while (iter.hasNext()) {
				BosMember mapMember = iter.next();
				walkMapGetDependencies(bos, (DitaMapBosMemberImpl)mapMember);
			}
			log.debug("walk(): Map dependencies calculated.");
			
		} else if (DitaUtil.isDitaTopic(elem)) {
			log.debug("walk(): Calculating topic dependencies for topic " + member.getKey() + "...");
			walkTopic(bos, (XmlBosMember)member, 1);
			log.debug("walk(): Topic dependencies calculated.");
		} else {
			// Not a map or topic, delegate walking:
			walkNonDitaResource(bos, (NonXmlBosMember)member, 1);
		}
		
	}

	public void walk(DitaBoundedObjectSet bos) throws BosException, DitaApiException {
		if (this.getRootObject() == null)
			throw new BosException("Root object no set, cannot continue.");
		walk(bos, (Document) this.getRootObject());
	}

	public void walk(BoundedObjectSet bos) throws BosException {
		if (this.getRootObject() == null)
			throw new BosException("Root object no set, cannot continue.");
		if (!(bos instanceof DitaBoundedObjectSet))
			throw new BosException("BOS must be a DitaBoundedObjectSet");
		try {
			walk((DitaBoundedObjectSet)bos, (Document) this.getRootObject());
		} catch (DitaApiException e) {
			throw new BosException("DITA API exception: " + e.getMessage(), e);
		}
	}


}
