/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaMapBosMember;
import net.sourceforge.dita4publishers.api.ditabos.DitaTopicBosMember;
import net.sourceforge.dita4publishers.impl.dita.AddressingException;
import net.sourceforge.dita4publishers.util.DitaUtil;

import org.apache.commons.logging.Log;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;


/**
 * Base for DITA BOS visitors that do pointer rewriting.
 */
public abstract class PointerRewritingBosVisitorBase extends DitaBosVisitorBase {


	/**
	 * @param log
	 */
	public PointerRewritingBosVisitorBase(Log log) {
		super(log);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosVisitor#visit(com.reallysi.tools.dita.DitaMapBosMember)
	 */
	public void visit(DitaMapBosMember bosMember) throws BosException {
		visit((DitaBosMemberImpl)bosMember);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosVisitor#visit(com.reallysi.tools.dita.DitaTopicBosMember)
	 */
	public void visit(DitaTopicBosMember bosMember) throws BosException {
		visit((DitaBosMemberImpl)bosMember);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosVisitor#visit(com.reallysi.tools.dita.DitaTopicBosMember)
	 */
	public void visit(BosMember bosMember) throws BosException {
		log.debug("Nothing to do for non-DITA BOS member " + bosMember);
	}

	/** 
	 * Handles DITA BOS members in order to do pointer rewriting.
	 * By default calls rewriteLocalUris(), which must be implemented
	 * by subclasses. Can override this method to add different
	 * business logic (such as handling pointers to external or
	 * peer resources, rewriting key references, updating content
	 * in a CMS, etc.).
	 */
	public void visit(DitaBosMember bosMember) throws BosException {
		try {
			if (rewriteLocalUris(bosMember)) {						
				// Do whatever needs to be done to react to pointer
				// rewriting, such as updating content within a CMS
				// or writing new files
			}
		} catch (AddressingException e) {
			throw new BosException("Addressing exception rewriting URIs: " + e.getMessage(), e);
		}
	}

	/* 
	 * Iterates over all direct URI references to local-scope resources in the member and
	 * rewrites them as necessary.
	 */
	public boolean rewriteLocalUris(DitaBosMember member) throws BosException, AddressingException {
		// Find all pointers and then look up our dependencies by those values
		log.debug("Rewriting local URIs for BOS member " + member + "...");
		NodeList nl;
		try {
			nl = (NodeList) DitaUtil.allHrefsAndConrefs.evaluate(member.getElement(), XPathConstants.NODESET);
		} catch (XPathExpressionException e) {
			throw new BosException("Unexpected exception evaluating XPath expression \"" + DitaUtil.allHrefsAndConrefs, e);
		}
		boolean contentModified = false;
		if (nl.getLength() > 0) {
			// Get local pointer to the DOM so we can mutate it.
			for (int i = 0; i < nl.getLength(); i++) {
				Element ref = (Element)nl.item(i);
				if (ref.hasAttribute("href") && DitaUtil.isLocalScope(ref));
					String href = ref.getAttribute("href");
					BosMember depMember = member.getDependency(href);
					if (depMember == null) {
						log.warn("rewriteUris(): Local reference with href value \"" + href + "\" failed to result in a dependency lookup. This indicates an unresolvable local resource reference.");
						continue;
					}
					
					String newHref = constructNewHref(member, depMember, ref);
					ref.setAttribute("href", newHref);
					contentModified = true;
					log.debug("Rewriting pointer \"" + href + "\" to \"" + newHref + "\"");
						
			}
		}
		return contentModified;
	}

	/**
	 * @param member 
	 * @param depMember 
	 * @param ref
	 * @return
	 * @throws AddressingException 
	 */
	protected abstract String constructNewHref(DitaBosMember member, BosMember depMember, Element ref) throws BosException, AddressingException;


}
