/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.api.bos;


import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * A BOS member that is an XML document represented as a W3C DOM.
 */
public interface XmlBosMember extends BosMember {

	/* (non-Javadoc)
	 * @see com.reallysi.tools.dita.BosMember#rewritePointers()
	 */
	public abstract void rewritePointers() throws BosException;

	/**
	 * @return The element that is the root element of the member. Is is usually,
	 * but not necessarily, the document element of the member's associated
	 * document.
	 * @throws BosException 
	 */
	public abstract Element getElement() throws BosException;

	/**
	 * @return The Document that contains the member's element. This is normally, but not
	 * necessary, the document of which the element is the root.
	 */
	public abstract Document getDocument();
	
	/**
	 * Set the member's document. Sets the document to which the member is associated.
	 * Sets or resets the member's element to the document's document element.
	 * @param doc
	 * @return
	 * @throws BosException
	 */
	public Document setDocument(Document doc) throws BosException;


	/**
	 * Sets the member's associated XML element to the specified element.
	 * Set's the member's associated document the element's owning document.
	 * @param element
	 * @return
	 * @throws BosException
	 */
	public Element setElement(Element element) throws BosException;

}