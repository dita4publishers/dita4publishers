package net.sourceforge.dita4publishers.tools.imaging.im;

/**
 * Represents a dynamic operation
 *
 */

public interface DynamicOperation 
{


  /**
   * Resolve the DynamicOperation.
   */
  public Operation resolveOperation(
    Object... pImages)
      throws IMException;
}
