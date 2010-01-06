/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.dxp;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.bos.BosVisitor;
import net.sourceforge.dita4publishers.api.bos.BoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosVisitorBase;
import net.sourceforge.dita4publishers.impl.dita.AddressingUtil;
import net.sourceforge.dita4publishers.impl.ditabos.DitaMapBosMemberImpl;
import net.sourceforge.dita4publishers.impl.ditabos.UriToUriPointerRewritingBosVisitor;

import org.apache.commons.logging.LogFactory;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;

/**
 * Determines the appropriate relative paths for the BOS members
 * as they should be stored within a DXP package.
 * <p>A DXP package must have either exactly one map in the root
 * directory of the package or a DXP manifest map. If there is no
 * manifest then all dependencies must be stored in directories
 * below the root. If the files are already organized this way,
 * then their original organization can be preserved, otherwise
 * they have to reorganized and pointers rewritten.</p>
 * <p>Pointer rewriting is done in the in-memory DOMs held by the
 * BOS members.</p>
 */
public class DxpFileOrganizingBosVisitor extends BosVisitorBase implements
		BosVisitor {
	
	private DxpOptions options = new DxpOptions();
	private BosMember rootMap;
	private URI rootMapUri;
	private boolean rewriteRequired;
	private URI baseUri;

	/**
	 * Construct a new visitor using default options and log.
	 */
	public DxpFileOrganizingBosVisitor() {
		super();
		log = LogFactory.getLog(BosVisitorBase.class);
	}

	/**
	 * Construct a new visitor with explicit DXP options and default log.
	 * @param options
	 */
	public DxpFileOrganizingBosVisitor(DxpOptions options) {
		super();
		log = LogFactory.getLog(BosVisitorBase.class);
		this.options = options;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.ditabos.BosVisitor#visit(net.sourceforge.dita4publishers.api.ditabos.BosMember)
	 */
	public void visit(BosMember bosMember) throws BosException {

	}
	
	public DxpOptions getOptions() {
		return this.options;
	}
	
	public void setOptions(DxpOptions options) {
		this.options = options;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosVisitor#visit(com.reallysi.tools.dita.BoundedObjectSet)
	 */
	public void visit(BoundedObjectSet bos)
			throws BosException {
		// If there is a root map, then everything is
		// handled relative to it and there may not be a need
		// for a manifest, otherwise we need to generate 
		// a manifest map or reorganize the files to put
		// everything below the root map.
		
		BosMember rootMember = bos.getRoot();
		if (rootMember != null && rootMember instanceof DitaMapBosMemberImpl) {
			this.rootMap = rootMember;
		} else {
			this.rootMap = constructDxpManifestMap(bos);
		}
		
		this.rootMapUri = rootMap.getEffectiveUri();
		try {
			this.baseUri = AddressingUtil.getParent(rootMapUri);
		} catch (URISyntaxException e) {
			throw new BosException("URI syntax exception calculating base URI for root map: " + e.getMessage());
		} catch (MalformedURLException e) {
			throw new BosException("MalformedURLException calculating base URI for root map: " + e.getMessage());
		} catch (IOException e) {
			throw new BosException("IOException calculating base URI for root map: " + e.getMessage());
		}
		
		this.rewriteRequired = false;
		
		for (BosMember member : bos.getMembers()) {
			if (member.equals(rootMap))
				continue;
			URI memberUri = member.getEffectiveUri();
			URI memberBase = null;
			try {
				memberBase = AddressingUtil.getParent(memberUri);
			} catch (URISyntaxException e) {
				throw new BosException("URI syntax exception: " + e.getMessage() + " getting base URI for member " + member);
			} catch (MalformedURLException e) {
				throw new BosException("MalformedURLException: " + e.getMessage() + " getting base URI for member " + member);
			} catch (IOException e) {
				throw new BosException("IOException: " + e.getMessage() + " getting base URI for member " + member);
			}
			URI relativeUri = baseUri.relativize(memberUri);
			boolean isAbsolute = relativeUri.isAbsolute();
			if (isAbsolute || relativeUri.toString().startsWith("..") ||
					relativeUri.toString().startsWith("/") ||
					memberBase.equals(baseUri)) {
				// URI is not below the root map, need to rewrite it.
				rewriteRequired = true;
				try {
					URL newUrl = new URL(baseUri.toURL(), "dependencies/" + member.getFileName());
					member.setEffectiveUri(newUrl.toURI());
				} catch (MalformedURLException e) {
					throw new BosException("Malformed URL exception: " + e.getMessage() + " constructing new URL for member " + member);
				} catch (URISyntaxException e) {
					throw new BosException("URI syntax exception: " + e.getMessage() + " constructing new URI for member " + member);
				}
			}
		}
		
		if (rewriteRequired) {
			UriToUriPointerRewritingBosVisitor rewritingVisitor = new UriToUriPointerRewritingBosVisitor();  
			rewritingVisitor.visit(bos);
		}
 		
	}

	/**
	 * Constructs a DXP manifest map with initial topicrefs to all the BOS members.
	 * @param bos
	 * @return
	 */
	private BosMember constructDxpManifestMap(BoundedObjectSet bos) {
		throw new NotImplementedException();
	}

}
