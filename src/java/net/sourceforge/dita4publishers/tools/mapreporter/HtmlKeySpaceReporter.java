/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.tools.mapreporter;

import java.net.URI;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinition;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.DitaPropsSpec;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.api.dita.KeyByMapComparator;
import net.sourceforge.dita4publishers.api.dita.KeyReportOptions;
import net.sourceforge.dita4publishers.api.dita.KeySpaceReporter;
import net.sourceforge.dita4publishers.api.ditabos.AddressingException;
import net.sourceforge.dita4publishers.impl.dita.ReporterBase;

import org.w3c.dom.Document;

/**
 * Creates an HTML report of a key space. Generates markup
 * that goes within an HTML body element.
 */
public class HtmlKeySpaceReporter extends ReporterBase implements KeySpaceReporter {


	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.KeySpaceReporter#report(net.sourceforge.dita4publishers.api.dita.DitaKeySpace, net.sourceforge.dita4publishers.api.dita.KeyReportOptions)
	 */
	public void report(KeyAccessOptions keyAccessOptions, DitaKeySpace keySpace, KeyReportOptions reportOptions) throws DitaApiException {

		if (reportOptions.isOnlyEffectiveKeys()) {
			// Just report the effective keys:
			reportEffectiveKeys(keyAccessOptions, keySpace, reportOptions);
		} else {
			reportAllKeys(keyAccessOptions, keySpace, reportOptions);
		}
	}



	/**
	 * @param keyAccessOptions 
	 * @param keySpace 
	 * @param keyAccessOptions
	 * @param writer
	 * @param keyReportOptions
	 * @throws DitaApiException 
	 */
	private void reportAllKeys(KeyAccessOptions keyAccessOptions, DitaKeySpace keySpace, KeyReportOptions keyReportOptions) throws DitaApiException {
		outStream.println("<h1>All keys:</h1>");
		
		Map<String, List<? extends DitaKeyDefinition>> keyDefsByKey = new TreeMap<String, List<? extends DitaKeyDefinition>>();
		keyDefsByKey.putAll(keySpace.getAllKeyDefinitionsByKey(keyAccessOptions));
		outStream.println("<table border='1' width='100%' layout='auto'>");
		outStream.println("<thead>\n<th>Key</th>\n<th>Definitions</th></thead>");
		for (String key : keyDefsByKey.keySet()) {
			outStream.println("<tr>");
			outStream.printf("<td valign='top'>%s</td>", key);
			List<? extends DitaKeyDefinition> keyDefs = keyDefsByKey.get(key);
			int i = 0;
			outStream.println("<td>");
			outStream.println("<ol>");
			for (DitaKeyDefinition keyDef : keyDefs) {
				outStream.printf("<li>Defining map: %s\n", keyDef.getBaseUri());
				outStream.printf("<p>href: %s\n", (keyDef.getHref() != null?keyDef.getHref():"Not specified.") + "</p>");
				outStream.printf("<p>keyref: %s\n", (keyDef.getKeyref() != null?keyDef.getKeyref():"Not specified") + "</p>");
				DitaPropsSpec propsSpec = keyDef.getDitaPropsSpec();
				if (propsSpec != null && propsSpec.getProperties().size() > 0) {
					outStream.println("<p>Selection properties:<ul>");
					for (String property : propsSpec.getProperties()) {
						outStream.printf("<li>%s=%s\n", property, propsSpec.getPropertyValues(property) + "</li>");
					}
					outStream.println("</ul>");
				}
			}
			outStream.println("</ol>");
			outStream.println("</td>");
			outStream.println("</tr>");
		}
		outStream.println("</table>");
	}



	/**
	 * @param keyAccessOptions 
	 * @param keySpace 
	 * @param keyAccessOptions
	 * @param writer
	 * @param keyReportOptions
	 * @throws DitaApiException 
	 */
	private void reportEffectiveKeys(KeyAccessOptions keyAccessOptions, DitaKeySpace keySpace, KeyReportOptions keyReportOptions) throws DitaApiException {
		
		outStream.println("<body>");
		outStream.println("<h1>Effective keys:</h1>");
		
		Comparator<DitaKeyDefinition> comparator = null;
		if (keyReportOptions.isSortByMap()) {
			comparator = new KeyByMapComparator();
		}
		
		SortedSet<DitaKeyDefinition> keyDefs = new TreeSet<DitaKeyDefinition>(comparator);
		keyDefs.addAll(keySpace.getEffectiveKeyDefinitions(keyAccessOptions));
		outStream.println("<table border='1' width='100%' layout='auto'>");
		outStream.println("<thead>\n<th>Key</th>\n<th>Bound Resource</th><th>Defining Map</th></thead>");
		for (DitaKeyDefinition keyDef : keyDefs) 	{
			String boundResourceUri = getBoundResource(keyAccessOptions,
					keySpace, keyDef);
			outStream.println("<tr>");
			outStream.printf("<td>%s</td>\n<td>%s</td>\n<td>%s</td>\n", 
					keyDef.getKey(), 
					boundResourceUri, 
					keyDef.getBaseUri());
			outStream.println("</tr>");
		}
		outStream.println("</body>");

	}

	protected String getBoundResource(KeyAccessOptions keyAccessOptions,
			DitaKeySpace keySpace, DitaKeyDefinition keyDef)
			throws AddressingException, DitaApiException {
		String boundResourceUri = "{no bound resource}";
		Document doc = null;
		URI uri = null;
		doc = keySpace.resolveKeyToDocument(keyDef.getKey(), keyAccessOptions);
		if (doc == null) {
			uri = keySpace.resolveKeyToUri(keyDef.getKey(),keyAccessOptions);
			if (uri != null)
				boundResourceUri = uri.toString();
		} else {
			boundResourceUri = doc.getDocumentURI();
		}
		return boundResourceUri;
	}

}
