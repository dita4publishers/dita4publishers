/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.dita;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;

import org.w3c.dom.Document;

/**
 *
 */
public class KeyDefinitionContextImpl implements DitaKeyDefinitionContext {

	private String rootMapId;
	private boolean outOfDate = true; // Out of date until loaded.
	private KeyAccessOptions keyAccessOptions = new KeyAccessOptions();

	/**
	 * @param rootMap
	 */
	public KeyDefinitionContextImpl(Document rootMap) throws DitaApiException {
		this.rootMapId = rootMap.getDocumentURI();
	}
	
	public String getRootMapId() throws DitaApiException {
		return this.rootMapId;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaKeyDefinitionContext#isOutOfDate()
	 */
	public boolean isOutOfDate() throws DitaApiException {
		return this.outOfDate;
	}
	
	public void setOutOfDate(boolean outOfDate) throws DitaApiException {
		this.outOfDate = outOfDate;
	}
	
	public void setUpToDate()  throws DitaApiException {
		this.outOfDate = false;
	}

	/**
	 * @throws DitaApiException 
	 * 
	 */
	public void setOutOfDate() throws DitaApiException {
		this.setOutOfDate(true);
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext#getKeyAccessOptions(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public KeyAccessOptions getKeyAccessOptions() {
		return this.keyAccessOptions;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaKeyDefinitionContext#setKeyAccessOptions(net.sourceforge.dita4publishers.api.dita.KeyAccessOptions)
	 */
	public void setKeyAccessOptions(KeyAccessOptions keyAccessOptions) {
		this.keyAccessOptions = keyAccessOptions;
	}

}
