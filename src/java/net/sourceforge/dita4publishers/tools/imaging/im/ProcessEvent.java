package net.sourceforge.dita4publishers.tools.imaging.im;

/**
 * This class wraps return-code and Exceptions of a terminated process.
 */

public class ProcessEvent
{

  /**
   * The return-code of the process. Note that this field is only valid, if no
   * exception occurred.
   */
  private int iReturnCode = Integer.MIN_VALUE;

  /**
   * If this field is not null, the process ended with this exception.
   */
  private Exception iException = null;

  /**
   * Default constructor.
   */
  public ProcessEvent()
  {
  }
  

  /**
   * @param pReturnCode
   *          the iReturnCode to set
   */
  public void setReturnCode(
    int pReturnCode)
  {
    iReturnCode = pReturnCode;
  }
  

  /**
   * @return the iReturnCode
   */
  public int getReturnCode()
  {
    return iReturnCode;
  }
  

  /**
   * @param pException
   *          the iException to set
   */
  public void setException(
    Exception pException)
  {
    iException = pException;
  }
  

  /**
   * @return the iException
   */
  public Exception getException()
  {
    return iException;
  }
  
}
