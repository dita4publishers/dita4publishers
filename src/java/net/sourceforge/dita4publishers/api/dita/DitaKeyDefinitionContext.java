/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;


/**
 * Represents a key definition context. This class
 * allows the Link Management Service to cache 
 * key definitions and resolutions reliably.
 */
public interface DitaKeyDefinitionContext {

	/**
	 * @return the Managed Object ID of the root map from
	 * which the context was constructed.
	 * @throws RSuiteException 
	 */
	String getRootMapId() throws DitaApiException;

	/**
	 * @return True if the key space has been marked as out of date and not yet
	 * updated by the server.
	 * @throws RSuiteException 
	 */
	boolean isOutOfDate() throws DitaApiException;

	/**
	 * @param keyAccessOptions
	 * @return The key access options set on the key key definition context.
	 */
	KeyAccessOptions getKeyAccessOptions();

	/**
	 * @param keyAccessOptions
	 */
	void setKeyAccessOptions(KeyAccessOptions keyAccessOptions);

}
