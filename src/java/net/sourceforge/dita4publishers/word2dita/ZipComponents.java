/**
 * 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.io.IOException;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.util.DomUtil;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

/**
 * A set of ZipComponents allowing in-memory read and write to
 * a Zip file.
 */
public class ZipComponents {
	
	Map<String, ZipComponent> zipComponents = new HashMap<String, ZipComponent>();
	private ZipFile zipFile; // Original Zip file read to initialize the ZipComponents

	/**
	 * @param zipFile
	 */
	public ZipComponents(ZipFile zipFile) {
		this.zipFile = zipFile;
		loadZipComponents(zipFile, zipComponents);
	}

	/**
	 * @param zipFile
	 * @param zipComponents
	 */
	public void loadZipComponents(ZipFile zipFile,
			Map<String, ZipComponent> zipComponents) {
		Enumeration<? extends ZipEntry> entries = zipFile.entries();
		while (entries.hasMoreElements()) {
			ZipEntry entry = entries.nextElement();
			ZipComponent comp = new ZipComponent(zipFile, entry);
			zipComponents.put(entry.getName(), comp);
		}
		
	}

	/**
	 * @param componentName
	 * @return
	 */
	public ZipComponent getEntry(String componentName) {
		ZipComponent comp = zipComponents.get(componentName);
		if (comp == null && componentName.startsWith("/")) {
			// Strip leading "/" to accommodate DOCX naming conventions. 
			comp = zipComponents.get(componentName.substring(1));
		}
		return comp;
	}

	/**
	 * @param bosOptions
	 * @param zipComponent
	 * @return
	 * @throws Exception 
	 */
	public Document getDomForZipComponent(BosConstructionOptions bosOptions,
			ZipComponent zipComponent) throws Exception {
		if (zipComponent == null) {
			throw new IOException("ZIP component is null");
		}
		Document doc = zipComponent.getDom();
		if (doc == null) {
			InputSource source = new InputSource(zipComponent.getInputStream());
			source.setSystemId(zipComponent.getName());
			
			doc = DomUtil.getDomForSource(source, bosOptions, false, false);
			zipComponent.setDom(doc);
		}
		return doc;
	}

	/**
	 * @param bosOptions
	 * @param documentXmlPath
	 * @return
	 * @throws Exception 
	 */
	public Document getDomForZipComponent(BosConstructionOptions bosOptions,
			String documentXmlPath) throws Exception {
		ZipComponent zipComponent = getEntry(documentXmlPath);			
		return getDomForZipComponent(bosOptions, zipComponent);
	}

	/**
	 * @param componentName
	 * @return
	 */
	public ZipComponent createZipComponent(String componentName) {
		ZipComponent comp = new ZipComponent(this.zipFile, componentName);
		this.zipComponents.put(componentName, comp);
		return comp;
	}

	/**
	 * @param componentName
	 * @param dom
	 * @throws Exception 
	 */
	public void createZipComponent(String componentName, Document dom) throws Exception {
		ZipComponent comp = createZipComponent(componentName);
		comp.setDom(dom);
	}

	/**
	 * @return
	 */
	public Collection<ZipComponent> getComponents() {
		return this.zipComponents.values();
	}

  


}
