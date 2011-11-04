/**
 * 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.xml.transform.Result;
import javax.xml.transform.stream.StreamResult;

import net.sourceforge.dita4publishers.util.DomUtil;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.w3c.dom.Document;

/**
 * Represents a component of a Zip file, either a directory or file. Captures
 * any new content and whether or not the component has been modified
 * since read.
 */
public class ZipComponent {

	private boolean modified = false;
	private ZipFile zipFile = null;
	private ZipEntry entry = null;
	private byte[] data = null;
	private ByteArrayOutputStream outputStream;
	private String name;
	private Document dom = null;
	private boolean isDirectory = false;

	/**
	 * @param zipFile
	 * @param entry
	 */
	public ZipComponent(ZipFile zipFile, ZipEntry entry) {
		this.zipFile = zipFile;
		this.entry = entry;
		this.isDirectory = entry.isDirectory();
		this.name = entry.getName();
		this.modified = false;
	}

	/**
	 * @param zipFile
	 * @param componentName
	 */
	public ZipComponent(ZipFile zipFile, String componentName) {
		this.zipFile = zipFile;
		this.name = componentName;
	}

	/**
	 * @return
	 * @throws IOException 
	 */
	public InputStream getInputStream() throws IOException {
		if (!this.modified && this.entry != null) {
			return zipFile.getInputStream(this.entry);
		}
		return new ByteArrayInputStream(this.data);
	}

	/**
	 * @return
	 */
	public String getName() {
		return this.name;
	}

	/**
	 * @return
	 */
	public OutputStream getOutputStream() {
		if (this.outputStream == null) {
			this.outputStream = new ByteArrayOutputStream();
		}
		return outputStream;
	}

	/**
	 * @throws IOException 
	 * 
	 */
	public void close() throws IOException {
		if (this.outputStream != null) {
			this.outputStream.close();
			this.data = this.outputStream.toByteArray();
			this.modified = true;
		}
		
	}

	/**
	 * @param dom
	 * @throws Exception 
	 */
	public void setDom(Document dom) throws Exception {
		this.dom = dom;
		this.outputStream = new ByteArrayOutputStream();
		Result result = new StreamResult(this.outputStream);
		DomUtil.serializeToResult(dom, "utf-8", result);
		this.close();
	}

	/**
	 * @return
	 */
	public Document getDom() {
		return this.dom;
	}

	/**
	 * @return
	 */
	public boolean isDirectory() {
		return this.isDirectory;
	}

	/**
	 * @return
	 */
	public boolean isModified() {
		return this.modified;
	}

}
