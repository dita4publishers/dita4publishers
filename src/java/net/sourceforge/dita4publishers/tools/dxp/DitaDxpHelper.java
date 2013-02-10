/**
 * Copyright 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.dxp;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import net.sourceforge.dita4publishers.api.bos.BosException;
import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.bos.BosVisitor;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.bos.BosConstructionOptions;
import net.sourceforge.dita4publishers.impl.dita.AddressingUtil;
import net.sourceforge.dita4publishers.impl.ditabos.DitaBosHelper;
import net.sourceforge.dita4publishers.tools.common.MapBosProcessorOptions;
import net.sourceforge.dita4publishers.util.DomUtil;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import sun.reflect.generics.reflectiveObjects.NotImplementedException;

/**
 * Helper class for working with DITA DXP packages.
 */
public class DitaDxpHelper {

	private static Log log = LogFactory.getLog(DitaDxpHelper.class);

	/**
	 * Given a DITA map bounded object set, zips it up into a DXP Zip package.
	 * @param mapBos
	 * @param outputZipFile
	 * @throws Exception 
	 */
	public static void zipMapBos(DitaBoundedObjectSet mapBos, File outputZipFile, MapBosProcessorOptions options) throws Exception {
		/*
		 *  Some potential complexities:
		 *  
		 *  - DXP package spec requires either a map manifest or that 
		 *  there be exactly one map at the root of the zip package. This 
		 *  means that the file structure of the BOS needs to be checked to
		 *  see if the files already conform to this structure and, if not,
		 *  they need to be reorganized and have pointers rewritten if a 
		 *  map manifest has not been requested.
		 *  
		 *  - If the file structure of the original data includes files not
		 *  below the root map, the file organization must be reworked whether
		 *  or not a map manifest has been requested.
		 *  
		 *  - Need to generate DXP map manifest if a manifest is requested.
		 *  
		 *  - If user has requested that the original file structure be 
		 *  remembered, a manifest must be generated.
		 */
		
		log.debug("Determining zip file organization...");
		
		BosVisitor visitor = new DxpFileOrganizingBosVisitor();
		visitor.visit(mapBos);
		
		if (!options.isQuiet())
			log.info("Creating DXP package \"" + outputZipFile.getAbsolutePath() + "\"...");
		OutputStream outStream = new FileOutputStream(outputZipFile);
		ZipOutputStream zipOutStream = new ZipOutputStream(outStream);
		
		ZipEntry entry = null;
		
		// At this point, URIs of all members should reflect their
		// storage location within the resulting DXP package. There
		// must also be a root map, either the original map
		// we started with or a DXP manifest map.
		
		URI rootMapUri = mapBos.getRoot().getEffectiveUri();
		URI baseUri = null;
		try {
			baseUri = AddressingUtil.getParent(rootMapUri);
		} catch (URISyntaxException e) {
			throw new BosException("URI syntax exception getting parent URI: " + e.getMessage());
		}
		
		Set<String> dirs = new HashSet<String>();

		if (!options.isQuiet())
			log.info("Constructing DXP package...");
		for (BosMember member : mapBos.getMembers()) {
			if (!options.isQuiet())
				log.info("Adding member " + member + " to zip...");
			URI relativeUri = baseUri.relativize(member.getEffectiveUri());
			File temp = new File(relativeUri.getPath());
			String parentPath = temp.getParent();
			if (parentPath != null && !"".equals(parentPath) && !parentPath.endsWith("/")) {
				parentPath += "/";
			}
			log.debug("parentPath=\"" + parentPath + "\"");
			if (!"".equals(parentPath) && parentPath != null && !dirs.contains(parentPath)) {
				entry = new ZipEntry(parentPath);
				zipOutStream.putNextEntry(entry);
				zipOutStream.closeEntry();				
				dirs.add(parentPath);
			}
			entry = new ZipEntry(relativeUri.getPath());			
			zipOutStream.putNextEntry(entry);
			IOUtils.copy(member.getInputStream(), zipOutStream);
			zipOutStream.closeEntry();
		}
		
		zipOutStream.close();
		if (!options.isQuiet())
			log.info("DXP package \"" + outputZipFile.getAbsolutePath() + "\" created.");
	}

	/**
	 * @param zipFile
	 * @param dxpOptions 
	 * @return
	 * @throws DitaDxpException 
	 */
	public static ZipEntry getDxpPackageRootMap(ZipFile zipFile, MapBosProcessorOptions dxpOptions) throws DitaDxpException {

		List<ZipEntry> candidateRootEntries = new ArrayList<ZipEntry>();
		List<ZipEntry> candidateDirs = new ArrayList<ZipEntry>();

		Enumeration<? extends ZipEntry> entries = zipFile.entries();
		while (entries.hasMoreElements()) {
			ZipEntry entry = entries.nextElement();
			File temp = new File(entry.getName());
			String parentPath = temp.getParent();
			if (entry.isDirectory()) {
				if (parentPath == null || "".equals(parentPath)) {
					candidateDirs.add(entry);
				}
			} else {
				if (entry.getName().equals("dita_dxp_manifest.ditamap")) {
					return entry;
				}
				if (entry.getName().endsWith(".ditamap")) {
					if (parentPath == null || "".equals(parentPath)) {
						candidateRootEntries.add(entry);
					}
				}
			}
		}
		
		// If we get here then we didn't find a manifest map, so look for
		// root map.

		// If exactly one map at the top level, must be the root map of the package.
		if (candidateRootEntries.size() == 1) {
			if (!dxpOptions.isQuiet())
				log.info("Using root map " + candidateRootEntries.get(0).getName());
			return candidateRootEntries.get(0);
		}
		
		
		// If there is more than one top-level dir, thank you for playing:
		
		if (candidateRootEntries.size() == 0 & candidateDirs.size() > 1) {
			throw new DitaDxpException("No manifest map, no map in root of package, and more than one top-level directory in package.");
		}
		
		// If there is exactly one root directory, look in it for exactly one map:
		if (candidateDirs.size() == 1) {
			String parentPath = candidateDirs.get(0).getName();
			entries = zipFile.entries();
			while (entries.hasMoreElements()) {
				ZipEntry entry = entries.nextElement();
				File temp = new File(entry.getName());
				String entryParent = temp.getParent();
				if (entryParent == null) 
					entryParent = "/";
				else
					entryParent += "/";
				if (parentPath.equals(entryParent) && entry.getName().endsWith(".ditamap")) {
					candidateRootEntries.add(entry);
				}
			}
			if (candidateRootEntries.size() == 1) {
				// Must be the root map
				if (!dxpOptions.isQuiet())
					log.info("Using root map " + candidateRootEntries.get(0).getName());
				return candidateRootEntries.get(0);
			}
			if (candidateRootEntries.size() > 1) {
				throw new DitaDxpException("No manifest map and found more than one map in the root directory of the package.");		
			}
		}
		
		// Should never get here:
		
		throw new DitaDxpException("Unable to find package manifest map or single root map in DXP package.");		
		
	}

	/**
	 * @param dxpFile
	 * @param outputDir
	 * @param dxpOptions
	 * @throws Exception 
	 */
	public static void unpackDxpPackage(File dxpFile, File outputDir,
			DitaDxpOptions dxpOptions) throws Exception {
		unpackDxpPackage(dxpFile, outputDir, dxpOptions, log);
	}

	/**
	 * @param dxpFile
	 * @param outputDir
	 * @param dxpOptions
	 * @throws Exception 
	 */
	public static void unpackDxpPackage(File dxpFile, File outputDir,
			DitaDxpOptions dxpOptions, Log log) throws Exception {
		ZipFile zipFile = new ZipFile(dxpFile);
		ZipEntry rootMapEntry = getDxpPackageRootMap(zipFile, dxpOptions);
		// rootMapEntry will have a value if we get this far.

		/**
		 * At this point could simply unpack the Zip file blindly or could build
		 * the map BOS from the root map by processing the Zip file entries and
		 * then only unpacking those that are actually used by the map. The latter
		 * case would be appropriate for packages that include multiple maps, for 
		 * example, when a set of peer root maps have been packaged together. 
		 * 
		 * For now, just blindly unpacking the whole zip.
		 */
		
		if (dxpOptions.isUnzipAll()) {
			MultithreadedUnzippingController controller = new MultithreadedUnzippingController(dxpOptions);
			if (!dxpOptions.isQuiet())
				log.info("Unzipping entire DXP package \"" + dxpFile.getAbsolutePath() + "\" to output directory \"" + outputDir + "\"...");
			controller.unzip(dxpFile, outputDir, true);
			if (!dxpOptions.isQuiet())
				log.info("Unzip complete");
		} else {
			List<String> mapIds = dxpOptions.getRootMaps();
			List<ZipEntry> mapEntries = new ArrayList<ZipEntry>();
			if (mapIds.size() == 0) {
				mapEntries.add(rootMapEntry);
			} else {
				mapEntries = getMapEntries(zipFile, mapIds);
			}
			for (ZipEntry mapEntry : mapEntries) {
				extractMap(zipFile, mapEntry, outputDir, dxpOptions);
			}
		}
		
	}

	/**
	 * Extracts only the local dependencies used from a map from a DXP package.
	 * @param zipFile
	 * @param mapEntry
	 * @param outputDir
	 * @param dxpOptions
	 * @throws Exception 
	 */
	private static void extractMap(ZipFile zipFile, ZipEntry mapEntry,
			File outputDir, MapBosProcessorOptions dxpOptions) throws Exception {
		Map<URI, Document> domCache = new HashMap<URI, Document>();
		
		if (!dxpOptions.isQuiet())
			log.info("Extracting map " + mapEntry.getName() + "...");

		BosConstructionOptions bosOptions = new BosConstructionOptions(log, domCache);
		
		InputSource source = new InputSource(zipFile.getInputStream(mapEntry));
		
		File dxpFile = new File(zipFile.getName());
		
		URL baseUri = new URL("jar:" + dxpFile.toURI().toURL().toExternalForm() + "!/");
		URL mapUrl = new URL(baseUri, mapEntry.getName());
		
		source.setSystemId(mapUrl.toExternalForm());
		
		Document rootMap = DomUtil.getDomForSource(source, bosOptions, false);
		DitaBoundedObjectSet mapBos = DitaBosHelper.calculateMapBos(bosOptions, log, rootMap);
		
		MapCopyingBosVisitor visitor = new MapCopyingBosVisitor(outputDir);
		visitor.visit(mapBos);
		if (!dxpOptions.isQuiet())
			log.info("Map extracted.");
	}

	/**
	 * Uses the map IDs and the DXP manifest map to get the
	 * Zip entries for the specified maps.
	 * @param zipFile DXP package file.
	 * @param mapIds List of IDs, as specified in a DXP manifest, of maps to process.
	 * @return
	 */
	public static List<ZipEntry> getMapEntries(ZipFile zipFile,
			List<String> mapIds) throws DitaDxpException {
		throw new NotImplementedException();
	}



}
