package net.sourceforge.dita4publishers.slideset.datamodel;

import org.w3c.dom.Element;

/**
 * A container of other slide items, as for HTML div.
 *
 */
public class Div extends SlideItem {

    public Div() {
    }

    public Div(Element dataSourceElem) {
        super(dataSourceElem);
    }

}
