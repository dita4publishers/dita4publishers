package net.sourceforge.dita4publishers.slideset.datamodel;

import org.w3c.dom.Element;

/**
 * A single text sequence, possibly with associated style
 * attributes.
 *
 */
public class TextRun extends SlideItem {

    private String text = "";

    
    public TextRun(Element dataSourceElem) {
        super(dataSourceElem);
        this.text = dataSourceElem.getTextContent();
    }

    public TextRun(String textContent) {
        this.text = textContent;
    }
    
    @Override
    public String getTextContent() {
        return this.text;
    }

}
