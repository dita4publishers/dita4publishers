package net.sourceforge.dita4publishers.tools.imaging;

import java.io.IOException;

import net.sourceforge.dita4publishers.tools.imaging.im.ConvertCmd;
import net.sourceforge.dita4publishers.tools.imaging.im.IMException;
import net.sourceforge.dita4publishers.tools.imaging.im.IMOperation;


/**
 * Shows how to run the image converter.
 */
public class Converter
{

  
  
  
  public void run() 
    throws IOException, InterruptedException, IMException
  {
    IMOperation op = new IMOperation();
    op.addImage("myimage.jpg");
    op.resize(120,160);
    op.addImage("myimage-small.jpg");
    ConvertCmd convert = new ConvertCmd();
    convert.run(op);

  }
}
