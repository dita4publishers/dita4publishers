package net.sourceforge.dita4publishers.tools.imaging.im;

/**
 * This class models the command-line of ImageMagick. It extends the class IMOps
 * and adds some utility-methods (like appendVertically()) not found in
 * ImageMagick, mainly for ease of use. Subclasses of IMOperation implement more
 * specific operations (e.g. ChannelMixer).
 */
public class IMOperation extends IMOps
{

  /**
   * Constructor.
   */

  public IMOperation()
  {
  }

  
  /**
   * Open a sub-operation (add a opening parenthesis).
   */
  public IMOperation openOperation()
  {
    return (IMOperation) addRawArgs("(");
  }

  
  /**
   * Close a sub-operation (add a closing parenthesis).
   */
  public IMOperation closeOperation()
  {
    return (IMOperation) addRawArgs(")");
  }

  
  /**
   * Add a IMOperation as a suboperation.
   */
  public IMOperation addSubOperation(
    Operation pSubOperation)
  {
    openOperation();
    addRawArgs(pSubOperation.getCmdArgs());
    return closeOperation();
  }

  
  /**
   * Append images horizontally (same as +append)
   */
  public IMOperation appendHorizontally()
  {
    p_append();
    return this;
  }

  
  /**
   * Append images vertically (same as -append)
   */
  public IMOperation appendVertically()
  {
    append();
    return this;
  }
  
}
