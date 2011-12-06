package net.sourceforge.dita4publishers.util.conversion;


/**
 * Represents a set of conversion options.
 *
 */
public interface ConversionConfig {

	String getStringParameter(String paramName) throws Exception;

	String getId();

	ConversionConfigValueMap getValueMapParameter(String paramName) throws Exception;
	

}
