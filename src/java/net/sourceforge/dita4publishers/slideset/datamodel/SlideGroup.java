package net.sourceforge.dita4publishers.slideset.datamodel;

import org.w3c.dom.Element;

/**
 * A group of slides.
 * The slide group may have a title (e.g., as for PowerPoint titles).
 *
 */
public class SlideGroup extends SlideContainingItem implements TitledSlidesItem {


    private SlideTitle title;

    public SlideGroup(
            Element dataSourceElem) {
        super(
                dataSourceElem);
    }

    public void setTitle(SlideTitle title) {
        this.title = title;
        title.setParent(this);
    }

    @Override
    public
            SlideTitle getTitle() {
        return this.title;
    }

}
