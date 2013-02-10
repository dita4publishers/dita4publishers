package net.sourceforge.dita4publishers.tools.dxp;

import java.io.File;
import java.util.zip.ZipEntry;

public interface ZipListener
{
  
  /**
   * 
   */
  public void directoryCreated(
    ZipEntry entry, 
    File dir,
    String relativePath);

  
  /**
   * 
   */
  public void fileCreated(
    ZipEntry entry, 
    File file);
  
  
}
