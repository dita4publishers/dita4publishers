/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.List;
import java.util.Set;

import org.w3c.dom.Document;

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
	 * @return List of keys in the key space.
	 * @throws DitaApiException 
	 */
	Set<String> getKeys(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/** 
	 * @return The number of keys in the key space. Note that the
	 * number of keys may be greater than the number of key definitions
	 * as a given key definition may define more than one key.
	 */
	long size() throws DitaApiException;

	/**
	 * 
	 * @return Set of key definitions that establish the key space.
	 */
	Set<DitaKeyDefinition> getEffectiveKeyDefinitions(KeyAccessOptions keyAccessOptions) throws DitaApiException;
	
	/**
	 * 
	 * @return Set of all key definitions, effective and not, in the key space.
	 */
	List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/**
	 * 
	 * @return Set of all key definitions, effective and not, for the specified key.
	 * @throws  
	 */
	List<DitaKeyDefinition> getAllKeyDefinitions(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;

	/**
	 * @return Root map that establishes the key space.
	 */
	Document getRootMap(KeyAccessOptions keyAccessOptions) throws DitaApiException;

	/**
	 * Gets the effective key definition for the specified key.
	 * @param user
	 * @param key
	 * @return The key definition, or null if the key is not defined.
	 */
	DitaKeyDefinition getKeyDefinition(KeyAccessOptions keyAccessOptions, String key) throws DitaApiException;


}
