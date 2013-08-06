package net.sourceforge.dita4publishers.slideset.datamodel;

/**
 * The base interface for all slide set components.
 * A component may have a parent.
 *
 */
public interface SlideSetComponent {

    SlideSetComponent getParent();
    
    /**
     * Get the raw text content, as for DOM nodes.
     * 
     * @return The text content of the data source element, including the text
     *         of any descendant elements.
     */
    String getTextContent();
    
}