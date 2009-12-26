/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.dita;

import java.io.PrintStream;
import java.net.URI;
import java.util.Comparator;
import java.util.SortedSet;
import java.util.TreeSet;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaKeyDefinition;
import net.sourceforge.dita4publishers.api.dita.DitaKeySpace;
import net.sourceforge.dita4publishers.api.dita.KeyAccessOptions;
import net.sourceforge.dita4publishers.api.dita.KeyByMapComparator;
import net.sourceforge.dita4publishers.api.dita.KeyReportOptions;
import net.sourceforge.dita4publishers.api.dita.KeySpaceReporter;

import org.w3c.dom.Document;

/**
 * Creates a text report of a key space.
 */
public class TextKeySpaceReporter implements KeySpaceReporter {

	private PrintStream outStream;

	/**
	 * @param outStream
	 */
	public TextKeySpaceReporter(PrintStream outStream) {
		this.outStream = outStream;
	}

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
		
		Comparator<DitaKeyDefinition> comparator = null;
		if (keyReportOptions.isSortByMap()) {
			comparator = new KeyByMapComparator();
		}
		
		SortedSet<DitaKeyDefinition> keyDefs = new TreeSet<DitaKeyDefinition>(comparator);
		keyDefs.addAll(keySpace.getAllKeyDefinitions(keyAccessOptions));
		for (DitaKeyDefinition keyDef : keyDefs) 	{
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
			
			outStream.printf(" + %s\n\tBound resource: %s\n\tDefining map:   %s\n", 
					keyDef.getKey(), 
					boundResourceUri, 
					keyDef.getBaseUri());
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
			
			outStream.printf(" + %s\n\tBound resource: %s\n\tDefining map:   %s\n", 
					keyDef.getKey(), 
					boundResourceUri, 
					keyDef.getBaseUri());
		}
	}

}
