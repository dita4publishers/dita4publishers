package net.sourceforge.dita4publishers.tools.imaging.im;

import java.io.IOException;
import java.io.OutputStream;

/**
   This interface defines an InputProvider. An InputProvider supplies
   input for a process.
*/

public interface InputProvider 
{

  /**
   *The InputProvider must write the input to the given OutputStream.
   */
  public void provideInput(
    OutputStream pOutputStream) 
      throws IOException;
}
