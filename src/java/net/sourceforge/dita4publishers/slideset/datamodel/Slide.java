package net.sourceforge.dita4publishers.slideset.datamodel;

import net.sourceforge.dita4publishers.slideset.visitors.SlideBody;

import org.w3c.dom.Element;

/**
 * A single slide.
 * 
 */
public class Slide extends SlideItem implements
        TitledSlidesItem {

    private Element bodyNode;
    private Element notesNode;
    private SlideBody body;
    private net.sourceforge.dita4publishers.slideset.datamodel.SlideNotes notes;
    private SlideTitle title;

    public
            Element getBodyNode() {
        return bodyNode;
    }

    public
            Element getNotesNode() {
        return notesNode;
    }

    public Slide(Element dataSourceElem) {
        super(dataSourceElem);
    }

    /**
     * Sets the XML element that contains the body content of the slide.
     * 
     * @param bodyNode Element that contains the body content.
     */
    public
            void setBodyNode(
                    Element bodyNode) {
        if (bodyNode != null) {
            this.body = new SlideBody(bodyNode);
            body.setParent(this);
        }
    }

    /**
     * Sets the XML element that contains the notes for the slide.
     * 
     * @param notesNode Element that contains the notes content.
     */
    public
            void setNotesNode(
                    Element notesNode) {
        if (notesNode != null) {
            notes = new SlideNotes(notesNode);
            notes.setParent(this);
        }
    }

    public
            SlideBody getBody() {
        return this.body;
    }

    public
            SlideNotes getNotes() {
        return this.notes;
    }

    public
            void
            setBody(
                    SlideBody body) {
        this.body = body;
        if (body != null)
            this.body.setParent(this);
        
    }

    public
            void
            setNotes(
                    SlideNotes notes) {
        this.notes = notes;
        if (notes != null)
            this.notes.setParent(this);
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
