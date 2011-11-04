/**
 * 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.util.Iterator;

import javax.xml.namespace.NamespaceContext;

/**
 *
 */
public class DocxNamespaceContext implements NamespaceContext {
	

	/* (non-Javadoc)
	 * @see javax.xml.namespace.NamespaceContext#getNamespaceURI(java.lang.String)
	 */
	@Override
	public String getNamespaceURI(String prefix) {
		return DocxConstants.nsByPrefix.get(prefix);
	}

	/* (non-Javadoc)
	 * @see javax.xml.namespace.NamespaceContext#getPrefix(java.lang.String)
	 */
	@Override
	public String getPrefix(String nsUri) {
		return DocxConstants.prefixByUri.get(nsUri);
	}

	/* (non-Javadoc)
	 * @see javax.xml.namespace.NamespaceContext#getPrefixes(java.lang.String)
	 */
	@Override
	public Iterator getPrefixes(String arg0) {
		return DocxConstants.nsByPrefix.keySet().iterator();
	}

}
