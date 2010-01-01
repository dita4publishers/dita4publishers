/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.net.URI;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.bos.BosVisitor;
import net.sourceforge.dita4publishers.api.bos.NonXmlBosMember;
import net.sourceforge.dita4publishers.api.bos.XmlBosMember;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.bos.NonXmlBosMemberImpl;
import net.sourceforge.dita4publishers.impl.bos.XmlBosMemberImpl;
import net.sourceforge.dita4publishers.util.DitaUtil;

import org.apache.commons.logging.Log;
import org.w3c.dom.Document;
import org.w3c.dom.Element;


/**
 * Holds a set of DITA resources, e.g. all the dependencies
 * rooted at a given map.
 */
public class DitaBoundedObjectSetImpl implements DitaBoundedObjectSet {

	private BosMember root;
	private Map<String, BosMember> members = new HashMap<String, BosMember>();
	private Log log;
	private BosConstructionOptions bosOptions;
	private DitaKeySpace keySpace;

	/**
	 * @param bosOptions
	 */
	public DitaBoundedObjectSetImpl(BosConstructionOptions bosOptions) {
		this.bosOptions = bosOptions;
		this.log = bosOptions.getLog();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#getRoot()
	 */
	public BosMember getRoot() {
		return this.root;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#size()
	 */
	public long size() {
		return this.members.size();
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#setRootMember(com.reallysi.tools.dita.BosMember)
	 */
	public void setRootMember(BosMember member) {
		this.addMember(null, member);
		this.root = member;
		
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#addMember(com.reallysi.tools.dita.BosMember, com.reallysi.tools.dita.BosMember)
	 */
	public BosMember addMember(BosMember parentMember, BosMember member) {
		String memberKey = member.getKey();
		if (!this.members .containsKey(memberKey)) {
			this.members.put(memberKey, member);
		} else {
			member = getMember(member.getKey());		
		}
		if (parentMember != null)
			parentMember.addChild(member);
		return member;
	}

	/**
	 * @param key
	 * @return
	 */
	private BosMember getMember(String key) {
		return this.members.get(key);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#getMembers()
	 */
	public Collection<BosMember> getMembers() {
		Collection<BosMember> memberCol = new Vector<BosMember>();
		memberCol.addAll(this.members.values());
		return memberCol;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#accept(com.reallysi.tools.dita.BosVisitor)
	 */
	public void accept(BosVisitor visitor) throws BosException {
		visitor.visit(this);
		
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#getLog()
	 */
	public Log getLog() {
		return this.log;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#constructBosMember(com.reallysi.tools.dita.BosMember, org.w3c.dom.Document)
	 */
	public XmlBosMember constructBosMember(BosMember parentMember,
			Document doc) throws BosException {
		XmlBosMember newMember = null;
		Element elem =  doc.getDocumentElement();
		String key = doc.getDocumentURI();
		if (key == null || "".equals(key.trim())) {
			throw new BosException("Document has null or empty documentURI property. The documentURI must be set to use as the BOS member key.");
		}
		if (this.getMember(key) != null) {
			BosMember cand = this.getMember(key);
			if (!(cand instanceof XmlBosMember)) {
				throw new BosException("A BOS member with key \"" + key + "\" already exists and is not an XmlBosMember instance");
			}
			return (XmlBosMember)cand;
		}
		
		// FIXME: Integrate some sort of XML BOS member factory here.
		if (DitaUtil.isInDitaDocument(elem)) {
			if (DitaUtil.isDitaMap(elem)) {
				newMember = new DitaMapBosMemberImpl(this, doc);
			} else if (DitaUtil.isDitaTopic(elem)) {
				newMember = new DitaTopicBosMemberImpl(this, doc);
			} else if (DitaUtil.isDitaBase(elem)) {
				newMember = new DitaTopicBosMemberImpl(this, doc);
			} else {
				log.warn("constructBosMember(): Element \"" + elem.getLocalName() + "\" is in a DITA document but is neither a map nor a topic.");
				newMember = new DitaBosMemberImpl(this, doc);
			}
		} else {
			newMember = new XmlBosMemberImpl(this, doc);
		}
		return newMember;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#constructBosMember(com.reallysi.tools.dita.BosMember, java.io.File)
	 */
	public BosMember constructBosMember(BosMember member, URI targetUri) throws BosException {
		String key = targetUri.toString();
		if (this.getMember(key) != null) {
			BosMember cand = this.getMember(key);
			return cand;
		}
		NonXmlBosMember newMember = new NonXmlBosMemberImpl(this, targetUri);
		return newMember;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BoundedObjectSet#hasInvalidMembers()
	 */
	public boolean hasInvalidMembers() {
		return this.bosOptions.getInvalidDocuments().size() > 0;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet#getKeySpace()
	 */
	public DitaKeySpace getKeySpace() {
		return this.keySpace;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet#setKeySpace(net.sourceforge.dita4publishers.impl.ditabos.DitaKeySpace)
	 */
	public void setKeySpace(
			DitaKeySpace keySpace) {
		this.keySpace = keySpace;
	}

}
