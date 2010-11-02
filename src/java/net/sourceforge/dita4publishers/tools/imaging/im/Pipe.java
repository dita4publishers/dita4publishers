package net.sourceforge.dita4publishers.tools.imaging.im;

import java.io.OutputStream;
import java.io.InputStream;
import java.io.IOException;

/**
 * This class implements a pipe. Useful for piping input to a process or piping
 * output/error from a process to other streams.
 * 
 * <p>
 * You can use the same Pipe-object for both ends of a process-pipeline. But you
 * cannot use the same Pipe-object as an OutputConsumer and ErrorConsumer at the
 * same time.
 * 
 */
public class Pipe 
  implements InputProvider, OutputConsumer, ErrorConsumer
{

  /**
   * Default buffer size of the pipe. Currently 64KB.
   */
  public static final int BUFFER_SIZE = 65536;

  /**
   * The source of data (i.e. this pipe will provide input for a process).
   */
  private InputStream iSource;


  /**
   * The sink for data (i.e. this pipe will consume output of a process).
   */
  private OutputStream iSink;


  /**
   * Constructor. At least one of the arguments should not be null.
   */
  public Pipe(InputStream pSource, OutputStream pSink)
  {
    iSource = pSource;
    iSink = pSink;
  }


  /**
   * The InputProvider must write the input to the given OutputStream.
   */
  public void provideInput(
    OutputStream pOutputStream)
      throws IOException
  {
    copyBytes(iSource, pOutputStream);
  }


  /**
   * The OutputConsumer must read the output of a process from the given
   * InputStream.
   */
  public void consumeOutput(
    InputStream pInputStream)
      throws IOException
  {
    if (iSink != null)
    {
      copyBytes(pInputStream, iSink);
    }
  }


  /**
   * The ErrorConsumer must read the error of a process from the given
   * InputStream.
   */
  public void consumeError(
    InputStream pInputStream)
      throws IOException
  {
    if (iSink != null)
    {
      copyBytes(pInputStream, iSink);
    }
  }


  /**
   * Copy bytes from an InputStream to an OutputStream.
   */
  private void copyBytes(
    InputStream pIs,
    OutputStream pOs)
      throws IOException
  {
    byte[] buffer = new byte[BUFFER_SIZE];
    while (true)
    {
      int byteCount = pIs.read(buffer);
      if (byteCount == -1)
      {
        break;
      }
      pOs.write(buffer, 0, byteCount);
    }
    pOs.flush();
  }
  
}
