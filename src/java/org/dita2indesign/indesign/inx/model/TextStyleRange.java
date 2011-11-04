/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;

import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;


/**
 * Represents a range of text with specific formatting characteristics.
 */
public class TextStyleRange extends DefaultInDesignComponent {

	
	
	public TextStyleRange() throws Exception {
		super();
		setInxTagName("txsr");
	}

	/**
	 * Gets XML-syntax string of text content. PIs are in PI syntax, CDATA is 
	 * in CDATA marked section.
	 * @return
	 */
	public String getText() {
		StringBuilder text = new StringBuilder();
		for (InDesignComponent comp : this.getChildren()) {
			if (comp instanceof TextContents) {
				text.append(((TextContents)comp).getText());
			}
		}
		return text.toString();
	}

	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}

	/**
	 * @return
	 * @throws Exception 
	 */
	public ParagraphStyle getParagraphStyle() throws Exception {
		String styleId = this.getObjectReferenceProperty(InDesignDocument.PROP_PRST);
		ParagraphStyle style = null;
		if (styleId != null) {
			style = (ParagraphStyle)this.getDocument().getObject(styleId);
		}
		return style;
	}

	/**
	 * @return
	 * @throws Exception 
	 */
	public CharacterStyle getCharacterStyle() throws Exception {
		String styleId = this.getObjectReferenceProperty(InDesignDocument.PROP_CRST);
		CharacterStyle style = null;
		if (styleId != null) {
			style = (CharacterStyle)this.getDocument().getObject(styleId);
		}
		return style;
	}

}
