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
 * Creates a text report of a key space.
 */
public class TextKeySpaceReporter extends ReporterBase implements KeySpaceReporter {


	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.dita.KeySpaceReporter#report(net.sourceforge.dita4publishers.api.dita.DitaKeySpace, net.sourceforge.dita4publishers.api.dita.KeyReportOptions)
	 */
	public void report(KeyAccessOptions keyAccessOptions, DitaKeySpace keySpace, KeyReportOptions reportOptions) throws DitaApiException {

		outStream.println("---------------------------------------------------");
		outStream.println("Key report for keySpace " + keySpace.getRootMap(keyAccessOptions).getDocumentURI());
		outStream.println();
		if (reportOptions.isOnlyEffectiveKeys()) {
			// Just report the effective keys:
			reportEffectiveKeys(keyAccessOptions, keySpace, reportOptions);
		} else {
			reportAllKeys(keyAccessOptions, keySpace, reportOptions);
		}
		outStream.println("---------------------------------------------------");
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
		outStream.println(" All keys:\n");
		
		Map<String, List<? extends DitaKeyDefinition>> keyDefsByKey = new TreeMap<String, List<? extends DitaKeyDefinition>>();
		keyDefsByKey.putAll(keySpace.getAllKeyDefinitionsByKey(keyAccessOptions));
		for (String key : keyDefsByKey.keySet()) {
			outStream.println();
			outStream.printf(" + %s:\n", key);
			List<? extends DitaKeyDefinition> keyDefs = keyDefsByKey.get(key);
			int i = 0;
			for (DitaKeyDefinition keyDef : keyDefs) {
				outStream.println();
				outStream.printf("   [%2d] Defining map: %s\n", ++i, keyDef.getBaseUri());
				outStream.printf("        href:         %s\n", (keyDef.getHref() != null?keyDef.getHref():"Not specified."));
				outStream.printf("        keyref:       %s\n", (keyDef.getKeyref() != null?keyDef.getKeyref():"Not specified"));
				DitaPropsSpec propsSpec = keyDef.getDitaPropsSpec();
				if (propsSpec != null && propsSpec.getProperties().size() > 0) {
					outStream.println("        Selection properties:");
					for (String property : propsSpec.getProperties()) {
						outStream.printf("          + %s=%s\n", property, propsSpec.getPropertyValues(property));
					}
				}
			}
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
	private void reportEffectiveKeys(KeyAccessOptions keyAccessOptions, DitaKeySpace keySpace, KeyReportOptions keyReportOptions) throws DitaApiException {
		
		outStream.println(" Effective keys:\n");
		
		Comparator<DitaKeyDefinition> comparator = null;
		if (keyReportOptions.isSortByMap()) {
			comparator = new KeyByMapComparator();
		}
		
		SortedSet<DitaKeyDefinition> keyDefs = new TreeSet<DitaKeyDefinition>(comparator);
		keyDefs.addAll(keySpace.getEffectiveKeyDefinitions(keyAccessOptions));
		for (DitaKeyDefinition keyDef : keyDefs) 	{
			String boundResourceUri = getBoundResource(keyAccessOptions,
					keySpace, keyDef);
			
			outStream.printf(" + %s\n\tBound resource: %s\n\tDefining map:   %s\n", 
					keyDef.getKey(), 
					boundResourceUri, 
					keyDef.getBaseUri());
		}
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
