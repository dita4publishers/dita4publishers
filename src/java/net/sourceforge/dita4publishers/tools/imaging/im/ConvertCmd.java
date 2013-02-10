package net.sourceforge.dita4publishers.tools.imaging.im;

import java.io.File;


/**
 *   This class wraps the IM command convert.
 */

public class ConvertCmd 
  extends ImageCommand 
{


  /**
   * 
   */
  public  ConvertCmd() 
  {
    super();
    setCommand("convert");
  }
  
  /**
   * 
   */
  public  ConvertCmd(File imageMagicHomeDir) 
  {
    super();
    setCommand(getCommandForImageMagickBin(imageMagicHomeDir, "convert"));
  }
  



}
