/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
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
