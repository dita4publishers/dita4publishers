/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.impl.dita.AddressingException;
import net.sourceforge.dita4publishers.impl.dita.AddressingUtil;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Element;

/**
 * Rewrites URIs of pointers to reflect each BOS member's
 * URI.
 */
public class UriToUriPointerRewritingBosVisitor extends
		PointerRewritingBosVisitorBase {

	private static Log log = LogFactory.getLog(UriToUriPointerRewritingBosVisitor.class);

	/**
	 * @param log
	 */
	public UriToUriPointerRewritingBosVisitor(Log log) {
		super(log);
		UriToUriPointerRewritingBosVisitor.log = log;
	}

	/**
	 * 
	 */
	public UriToUriPointerRewritingBosVisitor() {
		super(log);
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.impl.ditabos.PointerRewritingBosVisitorBase#constructNewHref(net.sourceforge.dita4publishers.api.ditabos.XmlBosMember, org.w3c.dom.Element)
	 */
	@Override
	protected String constructNewHref(DitaBosMemberImpl member, BosMember depMember, Element ref)
			throws BosException, AddressingException {
		URI baseUri;
		try {
			baseUri = AddressingUtil.getParent(member.getEffectiveUri());
		} catch (URISyntaxException e) {
			throw new AddressingException("URI syntax exception getting parent of URI \"" + member.getEffectiveUri() + "\": " + e.getMessage());
		} catch (MalformedURLException e) {
			throw new AddressingException("MalformedURLException getting parent of URI \"" + member.getEffectiveUri() + "\": " + e.getMessage());
		} catch (IOException e) {
			throw new AddressingException("IOException getting parent of URI \"" + member.getEffectiveUri() + "\": " + e.getMessage());
		}
		URI depUri = depMember.getEffectiveUri();
		String newHref = AddressingUtil.getRelativePath(depUri, baseUri);		
		log.debug("New href=\"" + newHref + "\"");
		return newHref;
	}

	
}
