package net.sourceforge.dita4publishers.slideset.datamodel;

import org.w3c.dom.Element;

/**
 * Holds the style properties for a text run.
 *
 */
public class CharacterStyle extends StyleDefinition {
    

    public CharacterStyle(Element dataSourceElem) {
        super(dataSourceElem);
        this.styleType = StyleType.CHARACTER;
    }

}
