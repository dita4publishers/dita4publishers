/**
 * Copyright 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.word2dita;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import net.sourceforge.dita4publishers.api.bos.BosMemberValidationException;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.util.DomException;
import net.sourceforge.dita4publishers.util.DomUtil;
import net.sourceforge.dita4publishers.util.SaxUtil;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.ContentTypes;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.openxml4j.opc.PackagePartName;
import org.apache.poi.openxml4j.opc.PackagingURIHelper;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

public class DocxUpdaterTest
  extends TestCase
{
  /**
	 * 
	 */
	public static final String COMMENTS_CONTENT_TYPE = "application/vnd.openxmlformats-officedocument.wordprocessingml.comments+xml";

/**
	 * 
	 */
	public static final String COMMENTS_PARTNAME = "/word/comments.xml";

/**
	 * 
	 */
	public static final String COMMENT_REL_TYPE = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments";

/**
	 * 
	 */
	public static final String RELS_NS = "http://schemas.openxmlformats.org/package/2006/relationships";

/**
	 * 
	 */
	public static final String DOCUMENT_XML_RELS_PATH = "/word/_rels/document.xml.rels";
	// 2010-11-12T16:46:00Z
	public static SimpleDateFormat timestampFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH':'mm':'ssZ");

public static Test suite() 
  {
    TestSuite suite = new TestSuite(DocxUpdaterTest.class);
    return suite; 
  }

    public static String wNs = DocxConstants.nsByPrefix.get("w");
  
	URL catalogManagerProperties = getClass().getResource("/resources/CatalogManager.properties");
	URL topic_1_1Url = getClass().getResource("/resources/xml_data/docs/dita/word2dita/topic_1_1.dita");
	URL docxUrl = getClass().getResource("/resources/xml_data/docs/dita/word2dita/word2dita_single_doc_to_map_and_topics_01.docx");
	BosConstructionOptions bosOptions = null;
	
	public static final Log log = LogFactory.getLog(DocxUpdaterTest.class);

	String[] catalogs = new String[1];
	
	public void setUp() throws Exception {
		
		assertNotNull(catalogManagerProperties);
		Properties catProps = new Properties();
		catProps.load(catalogManagerProperties.openStream());
		String catalog = catProps.getProperty("catalogs");
		assertNotNull(catalog);
		catalogs[0] = catalog;
	}

	public void testParseWithXMLFormatLoggingXMLReader() throws Exception {
		File messageFile = File.createTempFile("DocxUpdaterTest-", ".xml");
		File docxFile = new File(docxUrl.toURI());
		File newDocxFile = File.createTempFile("docxupdater", ".docx");
		assertTrue("DOCX file does not exist", docxFile.exists());
		URL inputUrl = topic_1_1Url;

		Document logDoc = Word2DitaValidationHelper.validateXml(messageFile, inputUrl, catalogs);
		
		Word2DitaValidationHelper.addValidationMessagesToDocxFile(docxFile, newDocxFile, logDoc);

		System.out.println("New zip file is: " + newDocxFile.getAbsolutePath());
	}

	/**
	 * @param zipComponents
	 * @param bosOptions
	 * @throws Exception 
	 */
	public static void addCommentFileContentType(ZipComponents zipComponents,
			BosConstructionOptions bosOptions) throws Exception {

		/*
		 *   <Override
    PartName="/word/comments.xml"
    ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.comments+xml"/>

		 */
		
		ZipComponent comp = zipComponents.getEntry("[Content_Types].xml");
		Document doc = zipComponents.getDomForZipComponent(bosOptions, comp);
		Element docElem = doc.getDocumentElement();
		String contentTypesNs = "http://schemas.openxmlformats.org/package/2006/content-types";
		NodeList nl = docElem.getElementsByTagNameNS(contentTypesNs, "Override");
		boolean foundCommentType = false;
		for (int i =0; i < nl.getLength(); i++) {
			Element elem = (Element)nl.item(i);
			String partName = elem.getAttribute("PartName");
			if (COMMENTS_PARTNAME.equals(partName)) {
				foundCommentType = true;
				break;
			}
		}
		if (!foundCommentType) {
			Element elem = doc.createElementNS(contentTypesNs, "Override");
			elem.setAttribute("PartName", COMMENTS_PARTNAME);
			elem.setAttribute("ContentType", COMMENTS_CONTENT_TYPE);
			docElem.appendChild(elem);
            comp.setDom(doc);
		}
	}

	/**
	 * @param documentDom
	 * @param commentsDom
	 * @param docxZip
	 * @param zipFile
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws Exception
	 */
	public static void saveZipComponents(ZipComponents zipComponents, File zipFile) throws FileNotFoundException,
			IOException, Exception {
		ZipOutputStream zipOutStream = new ZipOutputStream(new FileOutputStream(zipFile));		
		for (ZipComponent comp : zipComponents.getComponents()) {
			ZipEntry newEntry = new ZipEntry(comp.getName());
			zipOutStream.putNextEntry(newEntry);
			if (comp.isDirectory()) {
				// Nothing to do.
			} else {
				// System.out.println(" + [DEBUG] saving component \"" + comp.getName() + "\"");
				if (comp.getName().endsWith("document.xml") || comp.getName().endsWith("document.xml.rels")) {
					// System.out.println("Handling a file of interest.");
				}
				InputStream inputStream = comp.getInputStream();
				IOUtils.copy(inputStream, zipOutStream);
				inputStream.close();
			}
		}		
		zipOutStream.close();
	}


}
