package net.sourceforge.dita4publishers.slideset.datamodel;

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Element;

public class SlideSetComponentBase implements SlideSetComponent {

    private Element dataSource;
    private SlideSetComponent parent;
    private List<SlideItem> children = new ArrayList<SlideItem>();

    public SlideSetComponentBase(
            Element dataSourceElem) {
        this.dataSource = dataSourceElem;
    }

    public SlideSetComponentBase() {
    }

    public Element getDataSource() {
        return dataSource;
    }

    public void setParent(SlideSetComponent parent) {
        this.parent = parent;
        
    }
    
    public SlideSetComponent getParent() {
        return this.parent;
    }

    public void addChildren(
                    List<SlideItem> childItems) {
        for (SlideItem child : childItems) {
            child.setParent(this);
            this.children.add(child);
        }
                    
    }
    
    public java.util.List<SlideItem> getChildren() {
        List<SlideItem> result = new ArrayList<SlideItem>();
        result.addAll(children);
        return result;
    }



    /**
     * Get the raw text content, as for DOM nodes.
     * 
     * @return The text content of the data source element, including the text
     *         of any descendant elements.
     */
    public
            String getTextContent() {
        StringBuilder buf = new StringBuilder();
        for (SlideItem item : getChildren()) {
            buf.append(item.getTextContent());
        }
        return buf.toString();
    }

}