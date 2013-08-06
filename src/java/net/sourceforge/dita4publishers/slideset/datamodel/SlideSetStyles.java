package net.sourceforge.dita4publishers.slideset.datamodel;

import java.util.HashMap;
import java.util.Map;

import org.w3c.dom.Element;

public class SlideSetStyles extends SlideSetComponentBase {


    /**
     * Styles by ID: All styles have a unique ID irrespective of type.
     */
    private Map<String, StyleDefinition> allStyles = new HashMap<String, StyleDefinition>();
    
    /**
     * Sets of styles by type, indexed by name. Each distinct type of style is 
     * a flat namespace by style name.
     */
    private Map<StyleType, Map<String, StyleDefinition>> styleSets = new HashMap<StyleType, Map<String,StyleDefinition>>();

    public SlideSetStyles(
            Element dataSourceElem) {
        super(
                dataSourceElem);
    }

    public void addStyle(StyleDefinition style) {
        this.allStyles.put(style.getId(), style);
        Map<String, StyleDefinition> styleSet = styleSets.get(style.getStyleType());
        if (styleSet == null) {
            styleSet = new HashMap<String, StyleDefinition>();
            styleSets.put(style.getStyleType(), styleSet);
        }
        styleSet.put(style.getName(), style);
        style.setParent(this);
    }

    public
            StyleDefinition
            getStyle(
                    StyleType styleType,
                    String styleName) {
        Map<String, StyleDefinition> styleSet = styleSets.get(styleType);
        if (styleSet != null) {
            return styleSet.get(styleName);
        }
        return null;
    }

}
