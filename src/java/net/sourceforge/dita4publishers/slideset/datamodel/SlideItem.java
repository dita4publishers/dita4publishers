package net.sourceforge.dita4publishers.slideset.datamodel;


import org.w3c.dom.Element;

/**
 * Common superclass for Slide and SlideGroup
 * 
 */
public abstract class SlideItem extends
        SlideSetComponentBase {

    private String styleName;

    public SlideItem() {
        super();
    }

    public SlideItem(Element dataSourceElem) {
        super(dataSourceElem);
    }

    public
            void setStyleName(
                    String styleName) {
        this.styleName = styleName;
    }

    /**
     * Gets the style name associated with the slide item.
     * @return The style name, or null if there is no style name
     * for the item.
     */
    public
            String getStyleName() {
                return this.styleName;
            }
    
}
