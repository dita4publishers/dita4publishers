package net.sourceforge.dita4publishers.tools.imaging.im;



public class IMException 
  extends Exception 
{

  /**
   */
  private static final long serialVersionUID = 1L;


  /**
   *    
   */
  public IMException() 
  {
    super();
  }

  
  /**
   * 
   */
  public IMException(
    String pMessage) 
  {
    super(pMessage);
  }

  
  /**
   * 
   */
  public IMException(
    String pMessage, 
    Throwable pCause) 
  {
    super(pMessage,pCause);
  }

  
  /**
   * 
   */
  public IMException(
    Throwable pCause)
  {
    super(pCause);
  }

}
