package net.sourceforge.dita4publishers.slideset.visitors;

import org.w3c.dom.Element;

import net.sourceforge.dita4publishers.slideset.datamodel.SlideItem;

/**
 * Represents the body of the slide.
 *
 */
public class SlideBody extends
        SlideItem {

    public SlideBody(Element dataSourceElem) {
        super(dataSourceElem);        
    }

}
