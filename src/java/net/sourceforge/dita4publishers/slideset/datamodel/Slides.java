package net.sourceforge.dita4publishers.slideset.datamodel;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.w3c.dom.Element;

/**
 * List of slides and slide groups.
 * 
 */
public class Slides extends
        SlideSetComponentBase implements
        SlideContainer {

    private List<TitledSlidesItem> children = new ArrayList<TitledSlidesItem>();

    public Slides(Element dataSourceElem) {
        super(dataSourceElem);
    }

    @Override
    public
            void
            add(SlideGroup slideGroup) {
        this.children.add(slideGroup);
    }

    @Override
    public
            void
            add(Slide slide) {
        this.children.add(slide);
    }

    public
            Collection<? extends TitledSlidesItem>
            getItems() {
        return this.children;
    }

}
