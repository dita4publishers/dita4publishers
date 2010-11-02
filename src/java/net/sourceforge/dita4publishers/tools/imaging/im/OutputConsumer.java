package net.sourceforge.dita4publishers.tools.imaging.im;

import java.io.InputStream;
import java.io.IOException;

/**
 * This interface defines an OutputConsumer. An OutputConsumer reads
 * output from a process' stdout.
 */

public interface OutputConsumer 
{

  /**
   * The OutputConsumer must read the output of a process from the given
   * InputStream.
   */
  public void consumeOutput(
    InputStream pInputStream) 
      throws IOException;
  
}
