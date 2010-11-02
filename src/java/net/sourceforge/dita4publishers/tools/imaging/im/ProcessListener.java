package net.sourceforge.dita4publishers.tools.imaging.im;

/**
 *  A ProcessListener is notified of events in the image manipulation process
 */

public interface ProcessListener 
{

  /**
   * This method is called at process startup.
   */
  public void processStarted(
    Process pProcess);

  /**
   * This method is called at normal or abnormal process termination.
   */
  public void processTerminated(
    ProcessEvent pEvent);
}
