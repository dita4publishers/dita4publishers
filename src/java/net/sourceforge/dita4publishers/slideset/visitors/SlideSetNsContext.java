package net.sourceforge.dita4publishers.slideset.visitors;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.namespace.NamespaceContext;

public class SlideSetNsContext implements NamespaceContext {

    public static final String NS_NAME_SIMPLESLIDESET = "urn:ns:dita4publishers.org:doctypes:simpleslideset";
    public static Map<String, String> nsUrisByPrefix = new HashMap<String, String>();
    public static Map<String, String> nsPrefixesByUri = new HashMap<String, String>();
    static {
        nsUrisByPrefix.put(
                "sld",
                NS_NAME_SIMPLESLIDESET);
        nsPrefixesByUri.put(
                NS_NAME_SIMPLESLIDESET, 
                "sld"
                );
    }

    @Override
    public String getNamespaceURI(String prefix) {
        return nsUrisByPrefix.get(prefix);
    }

    @Override
    public String getPrefix(String uri) {
        return nsPrefixesByUri.get(uri);
    }

    @SuppressWarnings("rawtypes")
    @Override
    public Iterator getPrefixes(String arg0) {
        return nsUrisByPrefix.keySet().iterator();
    }
}
