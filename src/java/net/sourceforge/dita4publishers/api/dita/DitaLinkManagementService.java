/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.List;
import java.util.Set;

import net.sourceforge.dita4publishers.impl.dita.DitaClassImpl;

import org.w3c.dom.Document;


/**
 * Service for managing knowledge about DITA key definitions
 * and actual and potential link targets within DITA data
 * (that is, any element that has an ID within a DITA document).
 * <p>In DITA, a "key" is a name token that is bound, directly
 * or indirectly, to a resource. Keys are defined on topicref-type
 * elements within DITA maps. Keys are referenced from elements in
 * maps or topics. Within a given map a given key has at most one
 * binding. It is not an error for a given key to be declared
 * multiple times within a given map tree--the first key definition
 * in a breadth-first traversal of the tree map is the effective
 * binding. The set of keys thus determined is the map's <i>key space</i>,
 * that is, a name space of unique keys with bindings to resources.</p>
 * <p>This means, in particular, that keys cannot be resolved
 * unambiguously without establishing a root map, which then
 * defines the map tree from which the effective key binding
 * is determined.</p>
 * <p>The design intent of the API is that the service only knows
 * about key spaces that have been explicitly registered to the 
 * service, meaning that the service is not, itself responsible
 * for determining the set of available maps, but that some other
 * agent does that, whether it's the repository itself (say via
 * an insert or update event handler) or system users who manually
 * identify specific maps as root maps.</p>
 * <p>Because keys are defined via topicrefs they can be bound to
 * any resource addressable by or definable by a topicref. These are:
 * <ul>
 * <li>DITA topics (meaning an XML element of class "topic/topic")</li>
 * <li>DITA maps (meaning an XML element of class "map/map")</li>
 * <li>Subelements of the topicref itself as determined by the
 * element making the reference.</li>
 * <li>A non-DITA resource of any type, represented by its URI.</li>
 * </ul>
 * <p>Note that topicrefs cannot directly address elements that are
 * not topics or maps. However, xref and link elements can 
 * address elements within topics by specifying a key/elementID pair,
 * analogous to the topicid/elementId pair used in DITA fragment identifiers.
 * Thus, while keys cannot be used to directly address elements, they
 * may be involved in the addressing of elements.</p>
 */
public interface DitaLinkManagementService  {

	/**
	 * Standard or well-known DITA element classes:
	 */
	public static final DitaClass DITA_TYPE_TOPIC = new DitaClassImpl("- topic/topic ");
	public static final DitaClass DITA_TYPE_MAP = new DitaClassImpl("- map/map ");
	public static final DitaClass DITA_TYPE_TOPICREF = new DitaClassImpl("- map/topicref ");

	/**
	 * Returns a list of the keys in the key space established
	 * by the specified root map.
	 * @param keyAccessOptions Options that govern the key retrieval,
	 * such as applicable conditions, authentication tokens, type filters,
	 * etc.
	 * @param keydefContext The key definition context that represents
	 * the key space.
	 * @return List, possibly empty, of strings, one for each unique
	 * key in the key space.
	 * @throws DitaApiException 
	 */
	Set<String> getKeys(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Returns the key definition for the specified key within the specified root map's
	 * key space.
	 * @param keyAccessOptions
	 * @param keydefContext
	 * @param key
	 * @return Key definition or null if key is not defined.
	 */
	DitaKeyDefinition getKeyDefinition(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext,
			String key) throws DitaApiException;

	/**
	 * Returns the key space represented by the specified root map.
	 * @param keyAccessOptions
	 * @param keydefContext
	 * @return The key space. The key space may be empty.
	 */
	DitaKeySpace getKeySpace(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Returns the set of effective key definitions that establish the keys in the 
	 * key space.
	 * @param keyAccessOptions
	 * @param keydefContext
	 * @return Set, possibly empty, of key definitions.
	 */
	Set<DitaKeyDefinition> getEffectiveKeyDefinitions(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Returns the list of all key definitions, effective or not, in the 
	 * key space.
	 * @param keyAccessOptions
	 * @param context
	 * @return Set, possibly empty, of key definitions.
	 */
	List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Looks up the resource for the specified key in the key space
	 * established by the specified root map.
	 * @param keyAccessOptions
	 * @param context
	 * @param key Key to get the resource for.
	 * @return The resource object or null if the key is not defined.
	 * @see getKeyDefinition
	 */
	DitaResource getResource(KeyAccessOptions keyAccessOptions, DitaKeyDefinitionContext keydefContext, String key)  throws DitaApiException;

	/**
	 * Returns the list of references to the specified key. This is a repository
	 * global lookup.
	 * @param keyAccessOptions
	 * @param key
	 * @return List, possibly empty, references that specify a
	 * reference to the key.
	 */
	List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;

	/**
	 * Returns the list of references to the specified key within the
	 * scope of the specified document. If the document
	 * is a DITA map, the context is the map tree rooted at the map. 
	 * If the document is a DITA topic, the context is the topic
	 * tree rooted at the topic. If the context is not a DITA document,
	 * the list result is implementation-dependent (in that extensions
	 * may implement DITA key reference behavior for non-DITA content).
	 * @param keyAccessOptions
	 * @param key
	 * @param context document that defines the scope of the 
	 * result set.
	 * @return List, possibly, empty of references to the specified
	 * key within the specified use context.
	 */
	List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key,
			DitaKeyDefinitionContext context) throws DitaApiException;

	/**
	 * Returns the list of references of the specified type to the
	 * specified key. This is a repository global lookup.
	 * @param keyAccessOptions
	 * @param key
	 * @param filter
	 * @return
	 */
	List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key,
			DitaResultSetFilter filter) throws DitaApiException;

	/**
	 * Returns the list of references of the specified type to the
	 * specified key. This is a repository-global lookup.
	 * @param keyAccessOptions
	 * @param key
	 * @param type The element type name or DITA class token of the
	 * type to return. Bare element type names match exactly against
	 * the element type of the reference. DITA class tokens 
	 * ({module}/{tagname}) match all elements that have the specified
	 * DITA type in their specialization hierarchy.
	 * @param context document that defines the scope of the 
	 * result set.
	 * @param context 
	 * @return The list, possibly empty, of references of the specified
	 * type within the specified context.
	 * @see getKeyWhereUsed(
	 */
	List<DitaReference> getKeyWhereUsed(KeyAccessOptions keyAccessOptions, String key,
			DitaResultSetFilter filter, Document topic01) throws DitaApiException;

	/**
	 * Gets a key definition context instance for the specified
	 * registered map document. 
	 * @param keyAccessOptions
	 * @param keydefContext
	 * @return The context or null if the root map document is not registered.
	 * @throws DitaApiException 
	 */
	DitaKeyDefinitionContext getKeyDefinitionContext(Document rootMap) throws DitaApiException;

	/**
	 * Gets all the key definitions for a given key anywhere in the repository.
	 * @param keyAccessOptions
	 * @param keydefContext
	 * @param key
	 * @return The list, possibly empty, of the key definitions for the key in the specified context.
	 */
	List<DitaKeyDefinition> getAllKeyDefinitionsForKey(KeyAccessOptions keyAccessOptions,
			DitaKeyDefinitionContext keydefContext, String key) throws DitaApiException;

	/**
	 * Gets all the key definitions for a given key in all key definition contexts.
	 * @param keyAccessOptions
	 * @param key
	 * @return The list, possibly empty, of the key definitions for the key.
	 */
	List<DitaKeyDefinition> getAllKeyDefinitionsForKey(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;

	/**
	 * Gets all the effective key definitions in all key definition contexts for a given key.
	 * @param keyAccessOptions
	 * @param key
	 * @return Set of effective key definitions for the specified key.
	 * @throws DitaApiException 
	 */
	Set<DitaKeyDefinition> getEffectiveKeyDefinitionsForKey(KeyAccessOptions keyAccessOptions,
			String key) throws DitaApiException;

	/**
	 * Checks to see if the specified key is defined anywhere in the repository.
	 * @param key
	 * @return True if any key definition in the repository defines the key.
	 */
	boolean isKeyDefined(String key) throws DitaApiException;

	/**
	 * Checks to see if the specified key is defined anywhere in the repository as
	 * determined by the key access options.
	 * @param key 
	 * @param keyAccessOptions
	 * @return True if any key definition in the repository defines the key.
	 */
	boolean isKeyDefined(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;

	/**
	 * Checks to see if the specified key is defined in the key definition
	 * context.
	 * @param key
	 * @param keydefContext
	 * @return True if the key is defined within the key definition context.
	 */
	boolean isKeyDefined(String key, DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Checks to see if the specified key is defined in the key definition
	 * context.
	 * @param keyAccessOptions
	 * @param key
	 * @param keydefContext
	 * @return True if the key is defined within the key definition context.
	 */
	boolean isKeyDefined(KeyAccessOptions keyAccessOptions, String key, DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * @param mo XML document that has as its root a DITA map or topic
	 * element.
	 * @return DitaElementResource reflecting the root map or topic of the MO.
	 */
	DitaElementResource constructDitaElementResource(Document mo) throws DitaApiException;

	/**
	 * Determines the set of documents within which the specified
	 * target is used by direct reference.
	 * @param keyAccessOptions
	 * @param potentialTarget
	 * @return List, possibly empty, of documents that contain elements
	 * that address the target by direct URI (rather than by key).
	 */
	List<Document> getWhereUsed(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget) throws DitaApiException;

	/**
	 * Determines the set of documents, with the map context, within which the specified
	 * target is used by direct reference. The map context establishes the effective bounded
	 * object set of local scope DITA document dependencies (maps and topics). 
	 * @param keyAccessOptions
	 * @param potentialTarget
	 * @param keydefContext
	 * @return
	 */
	List<Document> getWhereUsed(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Determines the set of documents within which the potential
	 * target is referenced by key within the specified key definition
	 * context.
	 * @param keyAccessOptions
	 * @param potentialTarget
	 * @param keydefContext
	 * @return
	 */
	List<Document> getWhereUsedByKey(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Determines the set of key definitions that directly
	 * resolve to the specified target. Note that this 
	 * operation cannot determine indirect key bindings
	 * because there is no key definition context.
	 * @param keyAccessOptions
	 * @param potentialTarget
	 * @return
	 */
	List<DitaKeyDefinition> getKeyBindings(KeyAccessOptions keyAccessOptions,
			DitaElementResource potentialTarget) throws DitaApiException;

	/**
	 * Determines the set of key definitions that
	 * directly or indirectly resolve to the specified
	 * resource.
	 * @param keyAccessOptions
	 * @param potentialTarget Resource that is the potential target. May 
	 * be a DITA element resource or a non-DITA resource.
	 * @param keydefContext
	 * @return
	 */
	List<DitaKeyDefinition> getKeyBindings(KeyAccessOptions keyAccessOptions,
			DitaResource potentialTarget,
			DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * Registers a root DITA map to the service.
	 * @param rootMap Map that establishes a new key space.
	 * @return The context object for the registered key space.
	 */
	DitaKeyDefinitionContext registerRootMap(Document rootMap) throws DitaApiException;

	/**
	 * Registers a root DITA map to the service.
	 * @param keyAccessOptions Key access options to use in constructing the key space.
	 * @param rootMap Map that establishes a new key space.
	 * @return The context object for the registered key space.
	 */
	DitaKeyDefinitionContext registerRootMap(KeyAccessOptions keyAccessOptions, Document rootMap) throws DitaApiException;

	
	/**
	 * Sets the default key access options used for key space construction and access.
	 * @param keyAccessOptions
	 * @throws DitaApiException
	 */
	void setDefaultKeyAccessOptions(KeyAccessOptions keyAccessOptions) throws DitaApiException;
	
	/**
	 * Gets the default key access options used for key space construction and access.
	 * @throws DitaApiException
	 * @return KeyAccessOptions
	 */
	KeyAccessOptions getDefaultKeyAccessOptions() throws DitaApiException;

	/**
	 * Removes a root DITA map from the service.
	 * @param rootMap Map from which the key space was originally constructed.
	 * 
	 */
	void unRegisterRootMap(Document rootMap) throws DitaApiException;

	/**
	 * Removes a key space from the service.
	 * @param keydefContext The key definition context for the key space to
	 * be removed.
	 */
	void unRegisterKeySpace(DitaKeyDefinitionContext keydefContext) throws DitaApiException;
	
	/**
	 * Informs the service that the underlying data from which the keyspace was constructed
	 * has been modified. The service is then expected to update its internal indexes or
	 * caches as needed.
	 * @param keydefContext The key definition context for the key space that is out of date.
	 * @throws DitaApiException
	 */
	void markKeySpaceOutOfDate(DitaKeyDefinitionContext keydefContext) throws DitaApiException;

	/**
	 * @param context
	 * @return
	 */
	boolean isRegistered(Document rootMap)  throws DitaApiException;

	/**
	 * @param context
	 * @return
	 * @throws DitaApiException 
	 */
	boolean isRegistered(DitaKeyDefinitionContext context) throws DitaApiException;

	/**
	 * Returns a list of all elements with IDs that could be the target of
	 * a DITA link of any type (conref, xref, link).
	 * @param KeyAccessOptions keyAccessOptions requesting the list. List is filtered based on user's access 
	 * rights to the MOs from which the list is constructed.
	 * @return List, possibly empty, of target elements. Note that because DITA requires
	 * topic elements to have IDs, this list will only be empty if there are no DITA
	 * topics in the repository.
	 */
	List<DitaIdTarget> getIdTargets(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/**
	 * Returns a DitaIdTarget for the specified element within the specified
	 * topic within the specified MO (topic may be the MO element). 
	 * @param keyAccessOptions
	 * @param containingDoc Document that contains (or is) the target topic
	 * @param topicId ID of the topic that contains the target element.
	 * @param elemId ID of the element whose immediate parent topic is the
	 * specified topic. 
	 * @return DitaIdTarget for the specified element or null, if no element
	 * with the specified ID exists in the specified topic.
	 */
	DitaIdTarget getIdTarget(KeyAccessOptions keyAccessOptions, Document containingDoc, String topicId,
			String elemId) throws DitaApiException;


}
