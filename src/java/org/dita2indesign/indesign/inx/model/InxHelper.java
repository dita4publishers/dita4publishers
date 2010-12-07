/**
 * Copyright 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.  n nLicensed under the Apache License, Version 2.0 (the "License"); nyou may not use this file except in compliance with the License. nYou may obtain a copy of the License at n n   http://www.apache.org/licenses/LICENSE-2.0 n nUnless required by applicable law or agreed to in writing, software ndistributed under the License is distributed on an "AS IS" BASIS, nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. nSee the License for the specific language governing permissions and nlimitations under the License.   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package org.dita2indesign.indesign.inx.model;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * Provides utility methods for dealing with the messy details of INX markup.
 */
public class InxHelper {

	static Logger logger = Logger.getLogger(InxHelper.class);

	/**
	 * Given a value that should contain a single string or enum key, return the string.
	 * @param rawValue
	 * @return
	 */
	public static String decodeRawValueToSingleString(String rawValue) throws Exception {
		String[] values = getSingleValue(rawValue);
//		logger.debug("values[].length=" + values.length);
		String dataType = values[0];
		if (dataType.startsWith("r"))
			dataType = dataType.substring(1);
		if ("c".equals(dataType) || 
			 "e".equals(dataType)|| 
			 "k".equals(dataType)
		   )
			return values[1].replace("~sep~", " ");
		throw new Exception("Data type is not 'c' (character), 'e' (enum) or 'k' (string key), found '" + values[0] + "'");
	}

	private static String[] getSingleValue(String rawValue) throws Exception {
		if (!rawValue.contains("_"))
			throw new Exception("Raw value \"" + rawValue + "\" does not appear to be an INX raw value, expected '_'");
//		logger.debug("getSingleValue(): raw value=\"" + rawValue + "\"");
		String[] tokens = rawValue.split("_"); // Should be two tokens
		if (tokens.length > 2)
			throw new Exception("Expected two items in tokenzied raw value, got " + tokens.length);
		if (tokens.length == 1) {
			// Means value was like "c_", which is valid and indicates and empty string.
			String[] newTokens = new String[2];
			newTokens[0] = tokens[0];
			newTokens[1] = "";
			tokens = newTokens;
		}
		return tokens;
	}

	/**
	 * @param rawValue
	 * @return
	 * @throws Exception 
	 */
	public static long decodeRawValueToSingleLong(String rawValue) throws Exception {
		String[] values = getSingleValue(rawValue);
		if ("l".equals(values[0]))
			return Long.parseLong(values[1]);
		throw new Exception("Data type is not 'l' (long), found '" + values[0] + "'");
	}

	/**
	 * @param rawValue
	 * @return
	 * @throws Exception 
	 */
	public static double decodeRawValueToSingleDouble(String rawValue) throws Exception {
		String[] values = getSingleValue(rawValue);
		if ("D".equals(values[0]) || "U".equals(values[0]))
			return Double.parseDouble(values[1]);
		throw new Exception("Data type is not 'D' (double) or 'U' (units [points]), found '" + values[0] + "'");
	}

	/**
	 * @param rawValue
	 * @return
	 * @throws Exception 
	 */
	public static String decodeRawValueToSingleObjectId(String rawValue) throws Exception {
		String[] values = getSingleValue(rawValue);
		if (values[0].equals("o") && values[1].equals("n"))
			return null; // Reference to a null object
		String typeCode = values[0].substring(0);
		if (values[0].startsWith("r"))
			typeCode = values[0].substring(1);
		if ("c".equals(typeCode) | "o".equals(typeCode))
			return values[1];
		throw new Exception("Data type is not 'c' or 'o' (object ID), found '" + values[0] + "'");
	}

	/**
	 * @param rawValue
	 * @return
	 * @throws Exception 
	 */
	public static List<InxValue> decodeRawValueToList(String rawValue) throws Exception {
		List<InxValue> values = new ArrayList<InxValue>();
		String[] parts = rawValue.split("_");
		String typeCode = parts[0];
		if (typeCode.startsWith("r"))
			typeCode = typeCode.substring(1);
		if (!"x".equals(typeCode) )
			throw new InDesignDocumentException("Expected type of \"x\", got \"" + typeCode + "\"");
		String countHex = parts[1];
		long itemCount = Integer.parseInt(countHex, 16);
		int i = 2;
		while (i < (parts.length - 1)) {
			InxValue value = newValue(parts[i], parts[i+1]);
			values.add(value);
			i += 2;
		}
		if (values.size() != itemCount)
			throw new InDesignDocumentException("Expected " + itemCount + " items in list but got " + values.size());
		return values;
	}

	/**
	 * Takes a raw value string as held in an INX attribute, including any leading type code,
	 * and decodes it into a new value. The result value may be a value list.
	 * @param rawValue The raw value to be decoded.
	 * @return an InxValue instance representing the fully decoded value.
	 * @throws Exception 
	 */
	public static InxValue newValue(String rawValue) throws Exception {
		int p = rawValue.indexOf("_");
		if (p > 2) 
			throw new RuntimeException("rawValue does not appear to start with a type code: \"" + rawValue + "\".");
		String typeCode = rawValue.substring(0,p);
		String valueStr = rawValue.substring(p+1);
		char t = typeCode.charAt(0);
		if (t == 'r') t = typeCode.charAt(1); // Read-only value.
		switch (t) {
		case 'b':
			return new InxBoolean(valueStr);
		case 's':
			return new InxInteger(valueStr);
		case 'l':
			return new InxLong32(valueStr);
		case 'L':
			return new InxLong64(valueStr);
		case 'D':
			return new InxDouble(valueStr);
		case 'U':
			return new InxUnit(valueStr);
		case 'c':
		case 'k': // Enumeration value, but for our purposes, treat as a string.
			return new InxString(valueStr);
		case 'e': // Enumeration value, but for our purposes, treat as a string.
			return new InxEnumeration(valueStr);
		case 'T':
			return new InxDate(valueStr);
		case 'o':
			return new InxObjectRef(valueStr);
		case 'x':
			return new InxValueList(valueStr);
		case 'y': // Object list. Just a list of object references
			return new InxObjectList(valueStr);
		case 'z': // filename
			return new InxRecordList(valueStr);
		case 'f': // filename
			return new InxFile(valueStr);
		case 'm': // filename
			return new InxStream(valueStr);
		default:
			throw new InDesignDocumentException("Unhandled value type \"" + typeCode + "\"");
		}
	}


	/**
	 * @param typeCode The one or two-letter data type indicator for a value.
	 * @param rawValue The raw value.
	 * @return
	 * @throws Exception 
	 */
	public static InxValue newValue(String typeCode, String rawValue) throws Exception {
		if (rawValue == null)
			rawValue = "";
		return newValue(typeCode + "_" + rawValue);
	}

	/**
	 * Decodes a value that is a list of lists of string pairs representing a map of name/value pairs.
	 * @param rawValue
	 * @return
	 * @throws Exception 
	 */
	public static InxStringMap decodeRawValueToStringMap(String rawValue) throws Exception {
		// FIXME: For now just hacking this. Really need to implement value parsing so it's
		//        completely generalized.
		//
		// Typical value:
		//
		// x_2_x_2_c_Key1_c_Value1_x_2_c_Key2_c_Value2
		// 0 1 2 3 4 5    6 7      8 9 0 1    2 3
		//
		String[] parts = rawValue.split("_");
		String typeCode = parts[0];
		if (typeCode.startsWith("r"))
			typeCode = typeCode.substring(1);
		if (!"x".equals(typeCode) )
			throw new InDesignDocumentException("Expected type of \"x\", got \"" + typeCode + "\"");

		
		InxStringMap resultMap = new InxStringMap();
				
		int i = 4; // Point to first value of first list item
		
		while (i < (parts.length - 3)) {
			// FIXME: Not bothering to sanity check the type codes at the moment. This is already a quick hack.
			i++; // Type code
			String key = parts[i++];
			i++; // Type code
			String value = parts[i++];
			resultMap.put(key, value);
			// Skip type code and length of next pair
			i += 2;
			
		}
//		if (values.size() != itemCount)
//			throw new InDesignDocumentException("Expected " + itemCount + " items in list but got " + values.size());
		return resultMap;
		
	}

	/**
	 * @param rawValue
	 * @return
	 * @throws Exception 
	 */
	public static boolean decodeRawValueToBoolean(String rawValue) throws Exception {
		String[] values = getSingleValue(rawValue);
		if ("b".equals(values[0]))
			return values[1].equals("t");
		throw new Exception("Data type is not 'b' (boolean), found '" + values[0] + "'");
	}

	/**
	 * Given a Geometry object, encodes it as an IGeo string value.
	 * @param geometry
	 * @return
	 */
	public static String encodeGeometry(Geometry geometry) {
		List<InxValue> values = new ArrayList<InxValue>();
		// First the paths:
		values.add(new InxLong64(geometry.getPaths().size()));
		for (Path path : geometry.getPaths()) {
			values.add(new InxLong64(path.getPoints().size()));
			for (PathPoint point : path.getPoints()) {
				values.add(new InxLong64(2)); // Point type 2 is a corner point
				values.add(new InxDouble(point.getX()));
				values.add(new InxDouble(point.getY()));
			}
			values.add(new InxBoolean(false));
		}
		// Next geometric bounds (left, top, right, bottom:
		values.add(new InxDouble(geometry.getBoundingBox().getLeft()));
		values.add(new InxDouble(geometry.getBoundingBox().getTop()));
		values.add(new InxDouble(geometry.getBoundingBox().getRight()));
		values.add(new InxDouble(geometry.getBoundingBox().getBottom()));

		// Now the transformation matrix:
		values.addAll(geometry.getTransformationMatrix().getMatrixValues());
		
		// Now the graphic bounds, if any:
		if (geometry.getGraphicBoundingBox() != null) {
			values.add(new InxDouble(geometry.getGraphicBoundingBox().getLeft()));
			values.add(new InxDouble(geometry.getGraphicBoundingBox().getTop()));
			values.add(new InxDouble(geometry.getGraphicBoundingBox().getRight()));
			values.add(new InxDouble(geometry.getGraphicBoundingBox().getBottom()));
			
		}
		
		return encodeValueList(values);
	}

	/**
	 * Given a list of InxValue objects, encodes it as a single string.
	 * @param values
	 * @return
	 */
	public static String encodeValueList(List<InxValue> values) {
		StringBuilder value = new StringBuilder();
		value.append("x_").append(Integer.toHexString(values.size()));
		for (InxValue v : values) {
			value.append("_");
			value.append(v.toEncodedString());
		}
		return value.toString();
	}

	/**
	 * @param string
	 * @return
	 */
	public static String encodeString(String string) {
		String str = (string == null)?"":string;
		return "c_" + str.replace("_", "~sep~");
	}

	/**
	 * @param long32
	 * @return
	 */
	public static String encode32BitLong(long long32) {
		return "l_" + Long.toHexString(long32);
	}

	/**
	 * @param enumName
	 * @return
	 */
	public static String encodeEnumeration(String enumName) {
		return "k_" + enumName;
	}

	/**
	 * @param long64
	 * @return
	 */
	public static String encode64BitLong(long long64) {
		String hexString = Long.toHexString(long64);
		String highPart = "0";
		String lowPart = "0";
		if (hexString.length() > 8) {
			int lowStart = hexString.length() - 8;
			highPart = hexString.substring(0, lowStart - 1);
			lowPart = hexString.substring(lowStart);
		} else {
			lowPart = hexString;
		}
		return "L_" + highPart + "~" + lowPart;
	}

	/**
	 * @param date
	 * @return
	 */
	public static String encodeTime(Date date) {
		StringBuilder result = new StringBuilder("T_");
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int month = cal.get(Calendar.MONTH) + 1;
		int year = cal.get(Calendar.YEAR);
		int day = cal.get(Calendar.DAY_OF_MONTH);
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int minute = cal.get(Calendar.MINUTE);
		int second = cal.get(Calendar.SECOND);
		//yyyy-MM-DD'T'kk:mm:ss
		result.append(year)
		.append("-")
		.append((month < 10)?"0":"")
		.append(month)
		.append("-")
		.append((day < 10)?"0":"")
		.append(day)
		.append("T")
		.append((hour < 10)?"0":"")
		.append(hour)
		.append(":")
		.append((minute < 10)?"0":"")
		.append(minute)
		.append(":")
		.append((second < 10)?"0":"")
		.append(second);
		return result.toString();
	}

	/**
	 * @param linkNeeded
	 * @return
	 */
	public static String encodeBoolean(boolean bool) {
		if (bool)
			return "b_t";
		return "b_f";
	}

	/**
	 * Finds the first text frame within a spread with the specified label.
	 * @param spread Spread to look in for the text frame.
	 * @param targetLabel The label to look for.
	 * @return Text frame with the label, or null if the text frame is not found.
	 */
	public static TextFrame getFrameForLabel(Spread spread, String targetLabel) {
		TextFrame frame = null;
	    for (TextFrame candFrame : spread.getAllFrames()) {
	    	String label = candFrame.getLabel();
	    	if (targetLabel.equals(label)) {
	    		frame = candFrame;
	    		break;
	    	}
	    }
		return frame;
	}


	/**
	 * @param inDesignDoc
	 * @param incxFile
	 * @return
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 * @throws Exception
	 */
	public static Story getStoryForIncxDoc(InDesignDocument inDesignDoc, File incxFile)
			throws ParserConfigurationException, SAXException, IOException,
			Exception {
		return getStoryForIncxDoc(inDesignDoc, incxFile.toURI());
	}


	/**
	 * Given the URI of an INCX (InCopy) article, parses it and returns the first story
	 * in the document.
	 * @param inDesignDoc
	 * @param incxFile
	 * @return
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 * @throws Exception
	 */
	public static Story getStoryForIncxDoc(InDesignDocument inDesignDoc, URI incxResource)
			throws ParserConfigurationException, SAXException, IOException,
			Exception {
		InputSource incxSource = new InputSource(incxResource.toURL().openStream());
		incxSource.setSystemId(incxResource.toString());
		InDesignDocument articleDoc = new InDesignDocument(incxSource);
		Story incxStory = articleDoc.getStoryIterator().next();
        Story importedStory = inDesignDoc.importStory(incxStory);
		return importedStory;
	}
	

}
