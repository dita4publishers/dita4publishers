/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.ditabos;

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
		}
		URI depUri = depMember.getEffectiveUri();
		String newHref = AddressingUtil.getRelativePath(depUri, baseUri);		
		log.debug("New href=\"" + newHref + "\"");
		return newHref;
	}

	
}
