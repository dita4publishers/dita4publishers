/**
 * 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.io.File;

import net.sourceforge.dita4publishers.tools.common.MapBosProcessorOptions;

/**
 * Options for controlling validation of DITA generated from Word 
 * documents.
 */
public class Word2DitaValidatorOptions extends MapBosProcessorOptions {

	private File originalWordFile;
	private File outputWordFile;
	/**
	 * @param originalWordFile
	 */
	public void setOriginalWordFile(File originalWordFile) {
		this.originalWordFile = originalWordFile;
	}

	/**
	 * @param outputWordFile
	 */
	public void setOutputWordFile(File outputWordFile) {
		this.outputWordFile = outputWordFile;
	}

}
