package net.sourceforge.dita4publishers.tools.dxp;

import java.util.zip.ZipEntry;

/**
 * Instances of classes that implement this interface are used to filter 
 * files during the zipping/unzipping process.  These instances are used to 
 * filter files in the unzip method of the MultithreadedUnzippingController 
 * class.
 */

public interface ZipFileFilter
{

  /**
   * Tests if a specified file should be included when exploding an archive.
   * <p>
   * This method may be called multiple times for the same entry path
   * as the MultithreadUnzippingController makes two passes over
   * the zip file.  The filter should return the same result for a given
   * entry path, otherwise behaviour is undefined.
   * 
   * @param entry the information about the zip entry
   * @return true if and only if the name should be included when exploding
   *              the archive; false otherwise.
   */
  public boolean accept(
    ZipEntry entry);
  
  
}