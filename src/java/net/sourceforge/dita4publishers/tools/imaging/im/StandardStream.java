package net.sourceforge.dita4publishers.tools.imaging.im;

/**
 * This class is a container for objects logically wrapping stdin, stdout and
 * stderr.
 */
public class StandardStream
{

  /**
   * InputProvider wrapping System.in.
   */
  public static final InputProvider STDIN = new Pipe(System.in, null);


  /**
   * OutputConsumer wrapping System.out.
   */
  public static final OutputConsumer STDOUT = new Pipe(null, System.out);


  /**
   * ErrorConsumer wrapping System.err.
   */
  public static final ErrorConsumer STDERR = new Pipe(null, System.err);


  /**
   * Private Constructor. Since this is just a container for predefined objects,
   * there is no need to instantiate this class.
   */
  private StandardStream()
  {
  }
}
