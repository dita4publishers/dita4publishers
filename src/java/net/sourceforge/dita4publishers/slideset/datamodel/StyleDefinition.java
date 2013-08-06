package net.sourceforge.dita4publishers.slideset.datamodel;

import org.w3c.dom.Element;

/**
 * Base type for a style definition
 *
 */
public abstract class StyleDefinition extends SlideSetComponentBase {

    private String id;
    private String name;
    protected StyleType styleType; 

    public StyleDefinition(
            Element dataSourceElem) {
        super(
                dataSourceElem);
    }

    /**
     * The ID that is unique across all styles of all types.
     * @return The style ID.
     */
    public String getId() {
        return this.id;
    }
    
    /**
     * The name of the style, unique within styles of the same type.
     * @return The style name.
     */
    public String getName() {
        return this.name;
    }

    /**
     * Set the unique ID (across all styles of all types)
     * @param id The ID value, e.g. "slideStyle::somename"
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * Set the style name, unique within the same style type.
     * @param name The name value, e.g. "myStyleName".
     */
    public void setName(String name) {        
        this.name = name;
    }

    public
            StyleType getStyleType() {
        return this.styleType;
    }

}
