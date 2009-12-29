/**
 * Copyright (c) 2009 DITA2InDesign project (dita2indesign.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;


import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

 public class DataUtil {

	/**
	 * 
	 */
	public static final String XSD_SCHEMA_NAMESPACE = "http://www.w3.org/2001/XMLSchema";
	public static final int SCHEMA_FORMAT_UNKNOWN = 0;
	public static final int SCHEMA_FORMAT_DTD = 1;
	public static final int SCHEMA_FORMAT_DITA_DTD = 2;
	public static final int SCHEMA_FORMAT_XSD = 3;
	public static final int SCHEMA_FORMAT_RELAXNG = 4;
	
	// FIXME: Need to hook up client-side logging.
	// static Logger logger = Logger.getLogger(DataUtil.class);


 private static Map<Character, Integer> hexMap;
 private static char[] hexCharsLC =
   {
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c',
      'd', 'e', 'f'
   };
 private static char[] hexCharsUC =
   {
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C',
      'D', 'E', 'F'
   };

 static
   {
      hexMap = new HashMap<Character, Integer>();
      for( int index = 0; index < hexCharsLC.length; index++ )
      {
         hexMap.put( new Character( hexCharsLC[ index ] ),
                     new Integer( index ) );
         if( hexCharsLC[ index ] != hexCharsUC[ index ] )
            hexMap.put( new Character( hexCharsUC[ index ] ),
                        new Integer( index ) );
      }
   }

 public static String stripAngleBrackets(String toStrip)
  {
    return toStrip.substring(1, toStrip.length()-1);
  }

  public static byte[] hexToBytes(String hexString){

      byte[] result = new byte[ hexString.length() / 2 ];
      char[] chars = hexString.toCharArray();
    int byteIndex = 0;
      int firstHalf;
      int secondHalf;

      for( int i = 0; i < chars.length; i +=2 )
      {
         firstHalf = getIntForHexChar( chars[ i ] );
         secondHalf = getIntForHexChar( chars[ i + 1 ] );
         result[ byteIndex++ ] = (byte) ( ( firstHalf << 4 ) | secondHalf );
      }

      return result;
   }


    public static String echoStartTag(Element elem) {
        String resultStr = "<" + elem.getTagName();
        String attstr = "";
        NamedNodeMap atts = elem.getAttributes();
        for (int j = 0; j < atts.getLength(); j++) {
            Attr att = (Attr)(atts.item(j));
            // FIXME: doesn't account for '"' within attribute value.
            attstr = attstr + " " + att.getNodeName() + "=\"" + att.getNodeValue() + "\"";
        }
        resultStr = resultStr + attstr + ">";
        return resultStr;
    }

    public static String echoEndTag(Element elem) {
        return "</" + elem.getTagName() + ">";
    }

    /**
     * Returns element that exhibits the specified attribute, walking up
     * the element hierarchy.
     * 
     * @param startNode The node to check first. It's ancestors will be interogated until 
     * the attribute is found or the root is reached.
     * @param attName The name of the attribute to find.
     * @return Returns the element or null if not found.
     * @throws I18nServiceError
     */
    public static Element getAttHolder(Element startNode, String attName) {
       Node attHolderNode = startNode;
       while ((attHolderNode.getNodeType() != Node.DOCUMENT_NODE) &&
               (!((Element)attHolderNode).hasAttribute(attName))) {
           attHolderNode = attHolderNode.getParentNode();
       }
       if (attHolderNode.getNodeType() == Node.DOCUMENT_NODE) {
           return null;
       } else {
           return (Element)attHolderNode;
       }
    }

    /**
      * Returns the first element node within the children of the specified element.
      *
      * @param elemNode The element whose first element child is to be returned.
      */
     public static Element getFirstElementChild(Element elemNode) {
         NodeList nl = elemNode.getChildNodes();
         for (int i = 0; i < nl.getLength(); i++) {
             Node cand = nl.item(i);
             if (cand.getNodeType() == Node.ELEMENT_NODE) {
                 return (Element)cand;
             }
         }
         return null;
     }

      /**
       * Returns true if the input element has element children.
       * 
       * @param elemNode
       * 
       */
      public static boolean hasElementChildren(Element elemNode) {
          NodeList nl = elemNode.getChildNodes();
          for (int i = 0; i < nl.getLength(); i++) {
              Node cand = nl.item(i);
              if (cand.getNodeType() == Node.ELEMENT_NODE) {
                  return true;
              }
          }
          return false;
      }

     /**
      * Returns the string content of an element (e.g., xsl:value-of() except
      * that the markup of subelements is included in the string).
      * @param elem Element to get the value of.
      */
    public static String getElementContent(Element elem) {
        String resultStr = "";
        if (elem != null) {
	        NodeList childs = elem.getChildNodes();
	        for (int i = 0; i < childs.getLength(); i++) {
	            Node child = childs.item(i);
	            if (child.getNodeType() == Node.ELEMENT_NODE) {
	                resultStr = resultStr + echoStartTag((Element)child);
	                resultStr = resultStr + getElementContent((Element)child);
	                resultStr = resultStr + echoEndTag((Element)child);
	            } else if (child.getNodeType() == Node.TEXT_NODE) {
	                resultStr = resultStr + ((Text)child).getData();
	            } // Else: ignore other node types
	        }
		}
        return resultStr;
    }

    /**
     * Exactly like value-of()
     * @param elem
     * @return Concatenation of all descendant text nodes.
     */
	public static String getStringValueOfElement(Element elem) {
		StringBuffer buf = new StringBuffer();
		NodeList nodes = elem.getChildNodes();
		for (int i = 0; i < nodes.getLength(); i++) {
			Node node = nodes.item(i);
			switch (node.getNodeType()) {
			case Node.TEXT_NODE:
				buf.append(((Text)node).getData());
				break;
			case Node.ELEMENT_NODE:
				buf.append(getStringValueOfElement((Element)node));
				break;
			default:
				// Ignore the node
			}
			
		}
		return buf.toString();
	}
    

    
   /**
    * Returns the language code associated with the specified element.
    * 
    * @param elemNode The whose language value is to be returned.
    * @param defaultLangCode The default language code to return if
    * there is no explicit language code.
    */
   public static String getElementLanguage(Element elemNode, 
                                           String defaultLangCode) {
       String langCode = defaultLangCode;
       if (elemNode.hasAttribute("language")) {
           langCode = elemNode.getAttribute("language");
       } else if (elemNode.hasAttribute("lang")) {
           langCode = elemNode.getAttribute("lang");
       } else if (elemNode.hasAttributeNS("xml", "lang")) {
           langCode = elemNode.getAttributeNS("xml", "lang");
       }
       return langCode;
   }

    /**
     * Returns the element with the specified tag name.
     *
     * Throws an exception if element not found or if more than one found.
     */
    public static Element getElement(Element parentElem, String tagName) throws DataUtilException {
        NodeList nl = parentElem.getElementsByTagName(tagName);
        if (nl.getLength() == 0) {
            throw new DataUtilException("No " + tagName + " element found");
        }
        if (nl.getLength() > 1) {
            throw new DataUtilException("Found more than one " + tagName + " elements");
        }
        Element result = (Element)nl.item(0);
        return result;
    }


    public static int getIntForHexChar( char hexChar )
    {
       return ( hexMap.get( new Character( hexChar ) ) ).intValue();
    }
   
    public static String escapeUnicodeString(String inString) {
        int l = inString.length();
        byte[] bytes = new byte[l];
        try {
            bytes = inString.getBytes("UTF16");
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        String outString = "";
        byte zeroByte = new Byte("0").byteValue();
        byte lastByte = new Byte("127").byteValue();
        for (int i = 2; i < bytes.length; i = i + 2) {
            if ((bytes[i] == zeroByte) &&
                (bytes[i+1] <= lastByte)) {

                    try {
                        String newString = new String(bytes, i + 1, 1);
                        outString = outString + newString;
                    } catch (Exception e) {
                        System.err.println("escapeUnicodeString(): " + e.getMessage());
                    }
            } else {
                outString = outString + "\\u";
                outString = outString + byteToHex(bytes[i]) + byteToHex(bytes[i+1]);
            }
        }
        return outString;
    }

   static public String byteToHex(byte b) {
      // Returns hex String representation of byte b
      char hexDigit[] = {
         '0', '1', '2', '3', '4', '5', '6', '7',
         '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
      };
      char[] array = { hexDigit[(b >> 4) & 0x0f], hexDigit[b & 0x0f] };
      return new String(array);
   }

    static public String charToHex(char c) {
        // Returns hex String representation of char c
        byte hi = (byte) (c >>> 8);
        byte lo = (byte) (c & 0xff);
        return byteToHex(hi) + byteToHex(lo);
    }

    /**
     * Given the path to a file in the specified encoding, returns a single string
     * with the contents of that file.
     *
     * @param filePath The local path to the file
     *
     * @param encoding The encoding name: UTF8, UTF16, etc.
     */
    static public String readUnicodeFile(String filePath, String encoding)
            throws DataUtilException {
        // This code copied directly from the Java tutorial
        StringBuffer buffer = new StringBuffer();
        try {
            FileInputStream fis = new FileInputStream(filePath);
            InputStreamReader isr = new InputStreamReader(fis, encoding);
            Reader in = new BufferedReader(isr);
            int ch;
            while ((ch = in.read()) > -1) {
                    buffer.append((char)ch);
            }
            in.close();
            return buffer.toString();
        } catch (IOException e) {
            throw new DataUtilException("IOException: " +
                    e.getMessage() + " for file '" + filePath + "'", e);
        }
   }

   static public void writeUnicodeFile(String outString, String filePath, String encoding)
                                             throws DataUtilException {
        try {
            FileOutputStream fos = new FileOutputStream(filePath);
            Writer out = new OutputStreamWriter(fos, encoding);
            out.write(outString);
            out.close();
        } catch (IOException e) {
            throw new DataUtilException("writeUnicodeFile: " + e.getMessage() +
                                              " for file '" + filePath + "'", e);
        }
   }

   static public void writeCollationRulesForLocale(Locale locale,
                                                   String outFilePath)
                                    throws DataUtilException{
        String sortRules = null;
        java.text.RuleBasedCollator col = (java.text.RuleBasedCollator)java.text.Collator.getInstance(locale);
        sortRules = col.getRules();
        DataUtil.writeUnicodeFile(sortRules, outFilePath, "UTF8");
   }

	/**
	 * @param memberFile
	 * @return
	 */
	public static String getMimeTypeForFile(File memberFile) {
		URL fileUrl;
		String mimeType = "";
		try {
			fileUrl = memberFile.toURL();
			URLConnection c = fileUrl.openConnection();
			mimeType = c.getContentType();			
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	    return mimeType;
	}

    /**
     * @param line
     * @return
     */
    public static String escapeXmlMarkup(String line) {
        StringBuffer buf = new StringBuffer();
        for (int i = 0; i < line.length(); i++) {
        	char c = line.charAt(i);
        	switch (c) {
        		case '<':
        			buf.append("&lt;");
        			break;
				case '>':
					buf.append("&gt;");
					break;
        		case '&':
        			buf.append("&amp;");
        			break;
        		default:
        			buf.append(c);
        	}
        }
        return buf.toString();
    }

    /**
     * @param path
     * @return
     */
    public static Vector<String> tokenizePath(String path) {
		path = path.replace('\\', '/');
		StringTokenizer tokenizer = new StringTokenizer(path, "/");
		Vector<String> tokens = new Vector<String>();
		while (tokenizer.hasMoreTokens()) {
			tokens.addElement(tokenizer.nextToken());
		}
        return tokens;
    }

    /**
     * @param inFile
     * @return
     */
    public static long getCharacterCount(File inFile, String charSetName) {
    	long count = 0;
		FileInputStream fis = null;
    	try {
			fis = new FileInputStream(inFile);
			InputStreamReader isr = new InputStreamReader(fis, charSetName);
            int bufsize = 1024;
            char[] chars = new char[bufsize];
            BufferedReader br = new BufferedReader(isr, bufsize);
            int cnt = br.read(chars, 0, bufsize);
            while (cnt >= 0) {
            	count += cnt;
				cnt = br.read(chars, 0, bufsize);
            }
        } catch (FileNotFoundException e) {
            //logger.debug(e);
        } catch (IOException e) {
			//logger.debug(e);
        } finally {
        	try {
                fis.close();
            } catch (IOException e) {
				//logger.debug(e);
            }
        }
        return count;
    }

    /**
     * Returns the last token of a tokenized file path.
     * @return
     */
    public static String lastPathToken(String path) {
    	Vector<String> tokens = tokenizePath(path);
    	return tokens.elementAt(tokens.size() - 1);
    }
    
    public static List<Element> getElementChildren(Element elem) {
        List<Element> childs = new Vector<Element>();
        NodeList nl = elem.getChildNodes();
        for (int i = 0; i < nl.getLength(); i ++) {
            Node node = nl.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                childs.add((Element)node);
            }
        }
        return childs;
    }

    public static Iterator<Element> getElementChildrenIterator(Element elem) {
        return getElementChildren(elem).iterator();
    }

	public static Element getElementDescendant(Element elem, String ns_uri, String tagName) {
		NodeList nl = elem.getChildNodes();
        for (int i = 0; i < nl.getLength(); i ++) {
            Node node = nl.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                if ((node.getNamespaceURI() == null || node.getNamespaceURI().equals(ns_uri)) &&
                     node.getLocalName().equals(tagName)) {
                	return (Element)node;
                } else {
                	Element cand = getElementDescendant((Element)node, ns_uri, tagName);
                	if (cand != null) return cand;
                }                
            }
        }
        return null;
	}

	/**
	 * Get the first child with the specified name in the specified namespace.
	 * @param elem Parent to get the child of
	 * @param namespaceUri Namespace URI. Cannot be null (use getElement() to get no-namespace elements)
	 * @param localName Local part of tagname.
	 * @return First element with specified name or null
	 */
	public static Element getElementNS(Element elem, String namespaceUri, String localName) {
		NodeList nl = elem.getChildNodes();
        for (int i = 0; i < nl.getLength(); i ++) {
            Node node = nl.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                if ((node.getNamespaceURI() != null && node.getNamespaceURI().equals(namespaceUri)) &&
                    node.getLocalName().equals(localName)) {
                	return (Element)node;
                }              
            }
        }
		return null;
	}

	
}
