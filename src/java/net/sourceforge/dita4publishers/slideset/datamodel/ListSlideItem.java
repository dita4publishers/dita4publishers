package net.sourceforge.dita4publishers.slideset.datamodel;

import org.w3c.dom.Element;

/**
 * Base type for lists of any type.
 *
 */
public abstract class ListSlideItem extends
        SlideItem {

    public ListSlideItem() {
        super();
    }

    public ListSlideItem(Element dataSourceElem) {
        super(dataSourceElem);
    }

}