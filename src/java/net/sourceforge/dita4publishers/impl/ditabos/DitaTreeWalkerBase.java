/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.File;
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

import net.sourceforge.dita4publishers.api.ditabos.AddressingException;
import net.sourceforge.dita4publishers.api.ditabos.BosException;
import net.sourceforge.dita4publishers.api.ditabos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.BoundedObjectSet;
import net.sourceforge.dita4publishers.api.ditabos.DitaTreeWalker;
import net.sourceforge.dita4publishers.api.ditabos.NonXmlBosMember;
import net.sourceforge.dita4publishers.api.ditabos.XmlBosMember;

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
	 * @param failOnAddressResolutionFailure 
	 * @param bosConstructionOptions 
	 * @throws BosException 
	 */
	public DitaTreeWalkerBase(Log log,
			DitaKeySpace keySpace, boolean failOnAddressResolutionFailure, BosConstructionOptions bosConstructionOptions) throws BosException {
		super(log, failOnAddressResolutionFailure, bosConstructionOptions);
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
		walkTopicGetDependencies(bos, xmlBosMember);
	}

	/**
	 * @param bos
	 * @param member
	 * @throws BosException 
	 */
	protected void walkMapGetDependencies(BoundedObjectSet bos, XmlBosMember member)
			throws BosException {
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
					File targetFile = null;
					
					// For now, only consider local resources. 
					if (!DitaUtil.isLocalScope(topicref))
						continue;
					
					// If there is a key reference, attempt to resolve it,
					// then fall back to href, if any.
					String href = null;
					
					try {
						if (DitaUtil.targetIsADitaFormat(topicref)) {
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
								targetFile = resolveKeyrefToFile(topicref.getAttribute("keyref"));
							}
							if (targetFile == null && topicref.hasAttribute("href")) {
								href = topicref.getAttribute("href");
								// Don't bother resolving pointers to the same doc.
								// We don't record dependencies on ourself.
								if (!href.startsWith("#"))
									targetFile = AddressingUtil.resolveHrefToFile(topicref, href, this.failOnAddressResolutionFailure);
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
					if (targetFile != null) {
						childMember = bos.constructBosMember(member, targetFile);
					}
					if (childMember != null) {
						bos.addMember(member, childMember);
						newMembers.add((BosMember)childMember);
						if (href != null)
							member.registerDependency(href, childMember);
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
	 */
	protected void walkMemberGetDependencies(BoundedObjectSet bos, BosMember member)
			throws BosException {
				if (!(member instanceof XmlBosMember)) {
					// Nothing to do for now. At some point should be able
					// to delegate to walker for non-XML objects.
				} else {
					Element elem = ((XmlBosMember)member).getElement();
					this.walkedMembers.add(member);
					if (DitaUtil.isDitaMap(elem)) {
						walkMapGetDependencies(bos, (XmlBosMember)member);
					} else if (DitaUtil.isDitaTopic(elem)) {
						walkTopicGetDependencies(bos, (XmlBosMember)member);
					} else {
						log.warn("XML Managed object of type \"" + elem.getTagName() + "\" is not recognized as a map or topic. Not examining for dependencies");
					}
				}
				
			}

	/**
	 * @param bos
	 * @param member
	 * @throws BosException 
	 */
	private void walkTopicGetDependencies(BoundedObjectSet bos, XmlBosMember member)
			throws BosException {
				log.info("walkTopicGetDependencies(): handling topic " + member + "...");
				Set<BosMember> newMembers = new HashSet<BosMember>(); 
				log.info("walkTopicGetDependencies():   getting conref dependencies...");
			
				findConrefDependencies(bos, member, newMembers);
				log.info("walkTopicGetDependencies():   getting link dependencies...");
				findLinkDependencies(bos, member, newMembers);

				findObjectDependencies(bos, member, newMembers);

				// Now walk the new members:
				
				log.info("walkTopicGetDependencies(): Found " + newMembers.size() + " new members.");
				
				for (BosMember newMember : newMembers) {
					if (!walkedMembers.contains(newMember))
						log.info("walkTopicGetDependencies(): walking unwalked dependency member " + member + "...");
						walkMemberGetDependencies(bos, newMember);
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
		
		log.info("findObjectDependencies(): Found " + objects.getLength() + " topic/object elements");

		for (int i = 0;i < objects.getLength(); i++) {
			Element objectElem = (Element)objects.item(i);
			File targetFile = null;
			
			// If there is a key reference, attempt to resolve it,
			// then fall back to href, if any.
			String href = null;
			try {
				if (objectElem.hasAttribute("data")) {
					log.info("findObjectDependencies(): resolving reference to data \"" + objectElem.getAttribute("data") + "\"...");
					href = objectElem.getAttribute("data");
					// FIXME: This assumes that the @data value will be a relative URL. In fact, it could be relative
					//        to the value of the @codebase attribute if specified.
					targetFile = AddressingUtil.resolveObjectDataToFile(objectElem, this.failOnAddressResolutionFailure);
				}
			} catch (AddressingException e) {
				if (this.failOnAddressResolutionFailure) {
					throw new BosException("Failed to resolve @data \"" + objectElem.getAttribute("data") + "\" to a resource", e);
				}
			}
			
			if (targetFile == null)
				continue;

			BosMember childMember = null;
			if (targetFile != null) {
				log.info("findObjectDependencies(): Got file \"" + targetFile.getAbsolutePath() + "\"");
				childMember = bos.constructBosMember((BosMember)member, targetFile);
			}
			bos.addMember(member, childMember);
			newMembers.add(childMember);
			if (href != null)
				member.registerDependency(href, childMember);
		}

	}

	/**
	 * @param bos
	 * @param member
	 * @param newMembers
	 * @throws BosException 
	 */
	protected void findLinkDependencies(BoundedObjectSet bos, XmlBosMember member, Set<BosMember> newMembers)
			throws BosException {
				NodeList links;
				try {
					links = (NodeList)DitaUtil.allHrefsAndKeyrefs.evaluate(member.getElement(), XPathConstants.NODESET);
				} catch (XPathExpressionException e) {
					throw new BosException("Unexcepted exception evaluating xpath " + DitaUtil.allTopicrefs);
				}
				
				log.info("findLinkDependencies(): Found " + links.getLength() + " href- or keyref-using elements");
				
				for (int i = 0;i < links.getLength(); i++) {
					Element link = (Element)links.item(i);
					Document targetDoc = null;
					File targetFile = null;
					
					// If there is a key reference, attempt to resolve it,
					// then fall back to href, if any.
					String href = null;
					try {
						if (link.hasAttribute("keyref")) {
							log.info("findLinkDependencies(): resolving reference to key \"" + link.getAttribute("keyref") + "\"...");
							if (!DitaUtil.targetIsADitaFormat(link) || DitaUtil.isDitaType(link, "topic/image")) {
								targetFile = resolveKeyrefToFile(link.getAttribute("keyref"));
							} else {
								targetDoc = resolveKeyrefToDoc(link.getAttribute("keyref"));
							}
						}
						if (targetFile == null && targetDoc == null && link.hasAttribute("href")) {
							log.info("findLinkDependencies(): resolving reference to href \"" + link.getAttribute("href") + "\"...");
							href = link.getAttribute("href");
							if (DitaUtil.isDitaType(link, "topic/image")) {
								targetFile = AddressingUtil.resolveHrefToFile(link, link.getAttribute("href"), this.failOnAddressResolutionFailure);
							} else if (!DitaUtil.targetIsADitaFormat(link) && 
									   DitaUtil.isLocalOrPeerScope(link)) {
										targetFile = AddressingUtil.resolveHrefToFile(link, link.getAttribute("href"), this.failOnAddressResolutionFailure);
							} else {
								// If we get here, isn't an image reference and is presumably a DITA format resource.
								// Don't bother with links within the same XML document.
								if (!href.startsWith("#") && DitaUtil.isLocalOrPeerScope(link)) 
									targetDoc = AddressingUtil.resolveHrefToDoc(link, link.getAttribute("href"), bosConstructionOptions, this.failOnAddressResolutionFailure);
								
							}
						}
					} catch (AddressingException e) {
						if (this.failOnAddressResolutionFailure) {
							throw new BosException("Failed to resolve href \"" + link.getAttribute("href") + "\" to a managed object", e);
						}
					}
					
					if (targetDoc == null && targetFile == null)
						continue;

					BosMember childMember = null;
					if (targetDoc != null) {		
						log.info("findLinkDependencies(): Got document \"" + targetDoc.getDocumentURI() + "\"");
						childMember = bos.constructBosMember(member, targetDoc);
					} else if (targetFile != null) {
						log.info("findLinkDependencies(): Got file \"" + targetFile.getAbsolutePath() + "\"");
						childMember = bos.constructBosMember((BosMember)member, targetFile);
					}
					bos.addMember(member, childMember);
					newMembers.add(childMember);
					// Key references don't need to be rewritten so we only care if an href was used to resolve the dependency
					if (href != null)
						member.registerDependency(href, childMember);
				}
				
			}


	private void findConrefDependencies(BoundedObjectSet bos, XmlBosMember member, Set<BosMember> newMembers)
			throws BosException {
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
					
					if (targetDoc != null) {		
						BosMember childMember = bos.constructBosMember(member, targetDoc);
						bos.addMember(member, childMember);
						newMembers.add(childMember);
						if (href != null)
							member.registerDependency(href, childMember);
					}
				}
			}

	/**
	 * @param key
	 * @return Document to which key 
	 * @throws BosException 
	 */
	private Document resolveKeyrefToDoc(String key) throws BosException {
		try {
			return keySpace.resolveKeyToDocument(key);
		} catch (AddressingException e) {
			if (this.failOnAddressResolutionFailure) {
				throw new BosException("Failed to resolve key reference to key \"" + key + "\": " + e.getMessage());
			}
		}
		return null;
	}
	
	/**
	 * @param key
	 * @return
	 * @throws BosException 
	 */
	private File resolveKeyrefToFile(String key) throws BosException {
		try {
			return keySpace.resolveKeyToFile(key);
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
	 */
	protected void walkMapCalcMapTree(BoundedObjectSet bos, XmlBosMember currentMember, Document mapDoc,
			int level) throws BosException {
				String levelSpacer = getLevelSpacer(level);
				
				log.info("walkMap(): " + levelSpacer + "Walking map  " + mapDoc.getDocumentURI() + "...");
			
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
						log.info("walkMap(): " + levelSpacer + "  handling map reference to href \"" + href + "\"...");
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
			
				log.info("walkMap(): " + levelSpacer + "  Found " + childMaps.size() + " child maps.");
			
				// Now we have a list of the child maps in document order by reference.
				// Iterate over them to update the key space:
				
				if (childMaps.size() > 0) {
					log.info("walkMap(): " + levelSpacer + "  Adding key definitions from child maps...");
					
					for (Document childMap : childMaps) {
						keySpace.addKeyDefinitions(childMap.getDocumentElement());
					}
					
					// Now walk each of the maps to process the next level in the map hierarchy:
					
					log.info("walkMap(): " + levelSpacer + "  Walking child maps...");
					for (Document childMapDoc : childMaps) {
						XmlBosMember childMember = bos.constructBosMember(currentMember, childMapDoc);
						bos.addMember(currentMember, childMember);
						walkMapCalcMapTree(bos, childMember, childMapDoc, level + 1);
					}
					log.info("walkMap(): " + levelSpacer + "  Done walking child maps");
				}
				
			}


	public void walk(BoundedObjectSet bos, Document mapDoc) throws BosException {
		URI mapUri;
		try {
			String mapUriStr = mapDoc.getDocumentURI();
			if (mapUriStr == null || "".equals(mapUriStr))
				throw new BosException("Map document has a null or empty document URI property. Cannot continue.");
			mapUri = new URI(mapUriStr);
		} catch (URISyntaxException e) {
			throw new BosException("Failed to construct URI from document URI \"" + mapDoc.getDocumentURI() + "\": " + e.getMessage());
		}
		log.info("walk(): Walking document " + mapUri.toString() + "...");
		// Add this map's keys to the key space.
		
		XmlBosMember member = bos.constructBosMember((BosMember)null, mapDoc);
		Element elem = mapDoc.getDocumentElement();
	
		bos.setRootMember(member);
	
		// NOTE: if input is a map, then walking the map
		// will populate the key namespace before processing
		// any topics, so that key references can be resolved.
		// If the input is a topic, then the key space must have
		// already been populated if there are any key references
		// to be resolved.
		
		
		if (DitaUtil.isDitaMap(elem)) {
			log.info("walk(): Adding root map's keys to key space...");
			keySpace.addKeyDefinitions(elem);
			
			// Walk the map to determine the tree of maps and calculate
			// the key space rooted at the starting map:
			log.info("walk(): Walking the map to calculate the map tree...");
			walkMapCalcMapTree(bos, member, mapDoc, 1);
			log.info("walk(): Map tree calculated.");
			
			// At this point, we have a set of map BOS members and a populated key space;
			// Iterate over the maps to find all non-map dependencies (topics, images,
			// objects, xref targets, and link targets):
	
			log.info("walk(): Calculating map dependencies for map " + member.getKey() + "...");
			Collection<BosMember> mapMembers = bos.getMembers();
			Iterator<BosMember> iter = mapMembers.iterator();
			while (iter.hasNext()) {
				BosMember mapMember = iter.next();
				walkMapGetDependencies(bos, (XmlBosMember)mapMember);
			}
			log.info("walk(): Map dependencies calculated.");
			
		} else if (DitaUtil.isDitaTopic(elem)) {
			log.info("walk(): Calculating topic dependencies for topic " + member.getKey() + "...");
			walkTopic(bos, (XmlBosMember)member, 1);
			log.info("walk(): Topic dependencies calculated.");
		} else {
			// Not a map or topic, delegate walking:
			walkNonDitaResource(bos, (NonXmlBosMember)member, 1);
		}
		
	}

	public void walk(BoundedObjectSet bos) throws BosException {
		if (this.getRootObject() == null)
			throw new BosException("Root object no set, cannot continue.");
		walk(bos, (Document) this.getRootObject());
	}


}
