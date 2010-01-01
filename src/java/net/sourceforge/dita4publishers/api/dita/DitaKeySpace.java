/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.dita;

import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sourceforge.dita4publishers.impl.dita.AddressingException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * Represents a set of unique key-to-definition bindings.
 * <p>The key space does not itself do resolution of keys
 * to resources—that is managed by the link management
 * server. Thus the key space simply represents the
 * result of having established the effective set of
 * unique key definitions (and therefore keys) established
 * by a given root map.</p>
 */
public interface DitaKeySpace {

	/**
	 * @return List of keys in the key space, as determined by the key access options..
	 * @throws DitaApiException 
	 */
	Set<String> getKeys(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/** 
	 * @return The number of effective keys in the key space. Note that the
	 * number of keys may be greater than the number of key definitions
	 * as a given key definition may define more than one key.
	 * @throws DitaApiException
	 */
	long size() throws DitaApiException;

	/** 
	 * @return The number of effective keys in the key space as determined
	 * by the specified key access options. Note that the
	 * number of keys may be greater than the number of key definitions
	 * as a given key definition may define more than one key.
	 * @throws DitaApiException
	 */
	long size(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/**
	 * 
	 * @return Set, possibly empty, of key definitions that establish the key space, as determined by
	 * the specified key access options.
	 * @throws DitaApiException
	 */
	Set<DitaKeyDefinition> getEffectiveKeyDefinitions(KeyAccessOptions keyAccessOptions) throws DitaApiException;
	
	/**
	 * 
	 * @return Set, possibly empty, of all key definitions, effective and not, in the key space, as determined by
	 * the specified key access options.
	 * @throws DitaApiException
	 */
	List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/**
	 * 
	 * @return Set, possibly empty, of all key definitions, effective and not, for the specified key, as determined by
	 * the specified key access options.
	 * @throws DitaApiException
	 */
	List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;

	/**
	 * @return Root map that establishes the key space.
	 * @throws DitaApiException
	 */
	Document getRootMap(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/**
	 * Gets the effective key definition for the specified key, as determined by
	 * the specified key access options.
	 * @param keyAccessOptions
	 * @param key
	 * @return The key definition, or null if the key is not defined.
	 * @throws DitaApiException
	 */
	DitaKeyDefinition getKeyDefinition(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;

	/**
	 * Given a key, returns the DOM document the key is bound to, if any (keys may be bound
	 * to non-XML resources).
	 * @param key
	 * @return DOM or null, if the key is not bound or not bound an XML resource.
	 * @throws DitaApiException 
	 */
	Document resolveKeyToDocument(String key, KeyAccessOptions keyAccessOptions) throws AddressingException, DitaApiException;

	/**
	 * Given a key, returns the File to which the key is bound, if any.
	 * @param key
	 * @return File or null, if key is not bound.
	 * @throws DitaApiException 
	 */
	URI resolveKeyToUri(String key, KeyAccessOptions keyAccessOptions) throws AddressingException, DitaApiException;

	/**
	 * Adds key definitions from the specified document.
	 * @param mapElement Document element for a DITA map.
	 * @throws DitaApiException 
	 */
	void addKeyDefinitions(Element mapElement) throws DitaApiException;

	/**
	 * @param keyAccessOptions
	 * @param key
	 * @return True if the key is defined in the key space and the definition
	 * is applicable or visible per the key access options.
	 * @throws DitaApiException 
	 */
	boolean definesKey(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;

	/**
	 * Returns a map of key names to key definitions, where the key definitions
	 * are in occurrence order within the map tree.
	 * @param keyAccessOptions
	 * @return Map of key names to key definitions.
	 * @throws DitaApiException 
	 */
	Map<? extends String, List<? extends DitaKeyDefinition>> getAllKeyDefinitionsByKey(
			KeyAccessOptions keyAccessOptions) throws DitaApiException;

}
