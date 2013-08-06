package net.sourceforge.dita4publishers.slideset.datamodel;

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Document;

/**
 * Root for a simple set of slides.
 *
 */
public class SimpleSlideSet extends SlideSetComponentBase {

    private SlideSetProlog prolog;
    private SlideSetStyles styles;
    private Slides slides;

    public SimpleSlideSet(
            Document slideSetDoc) {
        super(slideSetDoc.getDocumentElement());
    }

    public void setProlog(SlideSetProlog prolog) {
        this.prolog = prolog;
        prolog.setParent(this);
    }

    public void setStyles(SlideSetStyles styles) {
        this.styles = styles;
    }

    public void setSlides(Slides slides) {
        this.slides = slides;
        slides.setParent(this);
    }

    /**
     * Get a copy of the slides list.
     * @return The list of slides. This is a copy of the internal list.
     */
    public List<TitledSlidesItem> getSlides() {
        List<TitledSlidesItem> resultList = new ArrayList<TitledSlidesItem>();
        resultList.addAll(this.slides.getItems());
        return resultList;
    }

    /**
     * Get the named style of the specified type.
     * @param styleType Style type
     * @param styleName The name of the style to get.
     * @return The style with the name within the set of styles of the specified type, or null
     * if either the style type is not defined or there is no style with the specified name.
     */
    public
            StyleDefinition
            getStyle(
                    StyleType styleType,
                    String styleName) {
        return this.styles.getStyle(styleType, styleName);
        
    }
    
    public SlideSetProlog getProlog() {
        return this.prolog;
    }

}
