/**
 * Copyright (c) 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use 
 * this file except in compliance with the License. You may obtain a copy of the License at     
 * http://www.apache.org/licenses/LICENSE-2.0 
 *  Unless required by applicable law or agreed to in writing, software distributed under 
 *  the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 *  either express or implied. See the License for the specific language governing 
 *  permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.imaging;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import net.sourceforge.dita4publishers.tools.imaging.im.ConvertCmd;
import net.sourceforge.dita4publishers.tools.imaging.im.IMException;
import net.sourceforge.dita4publishers.tools.imaging.im.IMOperation;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


public class ImageConveterTest
  extends TestCase
{
  public static Test suite() 
  {
    TestSuite suite = new TestSuite(ImageConveterTest.class);
    return suite; 
  }


	
private static final Log log = LogFactory.getLog(ImageConveterTest.class);
private URL coverGraphicFullRes;
private File imageMagicHomeDir = null;

  public void setUp() throws Exception {
		
	  coverGraphicFullRes = this.getClass().getResource("resources/cover-graphic-full-res.jpg");
	  assertNotNull("Failed to find cover-graphic-full-res.jpg resource", coverGraphicFullRes);
	  imageMagicHomeDir = new File("/apps");

  }

  /**
   * Tests use of the converter to downsample an image to a lower resolution.
 * @throws Exception 
   */
  public void testDownsampleImage() throws IOException, InterruptedException, Exception {
	  log.debug("Testing downsampling");
	  IMOperation op = new IMOperation();
	    op.addImage((new File(coverGraphicFullRes.toURI())).getAbsolutePath());
	    op.resize(600);
	    op.addImage("myimage-small.jpg");
	    ConvertCmd convert = new ConvertCmd();
	    convert.run(op);
  }
  
  
}
