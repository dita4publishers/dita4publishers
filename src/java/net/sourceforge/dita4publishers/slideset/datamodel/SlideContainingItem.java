package net.sourceforge.dita4publishers.slideset.datamodel;

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Element;

public class SlideContainingItem extends SlideItem implements SlideContainer {

    private List<SlideItem> children = new ArrayList<SlideItem>();

    public SlideContainingItem(
            Element dataSourceElem) {
        super(
                dataSourceElem);
    }

    @Override
    public void add(SlideGroup slideGroup) {
        this.children.add(slideGroup);
    }

    @Override
    public void add(Slide slide) {
        this.children.add(slide);
    }

    
}
