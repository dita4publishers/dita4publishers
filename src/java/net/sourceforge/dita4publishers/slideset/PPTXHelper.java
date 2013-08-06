package net.sourceforge.dita4publishers.slideset;

import java.util.regex.Pattern;

import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.openxml4j.opc.PackageRelationship;
import org.apache.poi.xslf.usermodel.XMLSlideShow;

/**
 * Helper class for working with PPTX documents using the POI libraries.
 * 
 */
public class PPTXHelper {

    public static
            void
            compressPackage(
                    XMLSlideShow pptx) throws Exception {
        OPCPackage pkg = pptx.getPackage();
        for (PackagePart mediaPart : pkg.getPartsByName(Pattern.compile("/ppt/media/.*?"))) {
            if (!isReferenced(
                    mediaPart,
                    pkg)) {
                System.out.println(mediaPart.getPartName()
                        + " is not referenced. removing.... ");
                pkg.removePart(mediaPart);
            }
        }
    }

    /**
     * Check if a package part is referenced by any other part in the OPC
     * package
     * 
     * @param mediaPart the part to check for references
     * @param pkg the package this parts belong to
     * @return whether mediaPart is referenced or not
     */
    public static
            boolean
            isReferenced(
                    PackagePart mediaPart,
                    OPCPackage pkg)
                    throws Exception {
        for (PackagePart part : pkg.getParts()) {
            if (part.isRelationshipPart())
                continue;

            for (PackageRelationship rel : part.getRelationships()) {
                if (mediaPart.getPartName()
                        .getURI()
                        .equals(
                                rel.getTargetURI())) {
                    // System.out.println("mediaPart[" + mediaPart.getPartName()
                    // + "] is referenced by " + part.getPartName());
                    return true;
                }
            }
        }
        return false;
    }

}
