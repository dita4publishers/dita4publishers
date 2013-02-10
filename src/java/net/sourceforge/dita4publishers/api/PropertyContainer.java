package net.sourceforge.dita4publishers.api;

import java.util.Map;

/**
 * An interface which represents a bean than can hold properties 
 * (name/value pairs).
 * 
 */
public interface PropertyContainer
{

  /**
   * Set a property (name/value pair) on this container.
   */
  public void setProperty(
    String key,
    Object value);

  /**
   * Return a property value for the specified key. Returns <em>null</em> if
   * key is not found.
   */
  public Object getPropertyValue(
    String key);

  /**
   * Return all of the properties set on this container. The Map is never 
   * null but may be empty.
   */
  public Map<String,Object> getPropertyMap();

}
