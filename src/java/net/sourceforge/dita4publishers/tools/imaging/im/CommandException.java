package net.sourceforge.dita4publishers.tools.imaging.im;

import java.util.ArrayList;
import java.util.List;

/**
 * This class wraps exceptions during image-attribute retrieval.
 */

public class CommandException 
  extends IMException
{

  /**
   * 
   */
  private static final long serialVersionUID = 1L;

  /**
   * The stderr-output of the command.
   */

  private ArrayList<String> iErrorText = new ArrayList<String>();


  /**
   */
  public CommandException()
  {
    super();
  }


  /**
   */
  public CommandException(String pMessage)
  {
    super(pMessage);
  }


  /**
   */
  public CommandException(String pMessage, Throwable pCause)
  {
    super(pMessage, pCause);
  }


  /**
   */
  public CommandException(Throwable pCause)
  {
    super(pCause);
  }


  /**
   * Return the error-text object.
   */
  public List<String> getErrorText()
  {
    return iErrorText;
  }
  
  /**
   * Return the error-text object.
   */
  public String getMessage()
  {
    StringBuilder buf = new StringBuilder();
    for (String msg: iErrorText)
      buf.append(msg).append("\n");
    return buf.toString();
  }



  /**
   * Set the error text of this exception.
   * 
   * @param pErrorText
   */
  public void setErrorText(
    ArrayList<String> pErrorText)
  {
    iErrorText = pErrorText;
  }
  
}
