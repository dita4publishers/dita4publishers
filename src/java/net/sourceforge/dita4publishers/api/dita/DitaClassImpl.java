/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.api.dita;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import net.sourceforge.dita4publishers.impl.dita.DitaClassSpecificationException;
import net.sourceforge.dita4publishers.impl.dita.DitaException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 *
 */
public class DitaClassImpl implements DitaClass {

	private String classSpec;
	private boolean isDomainType;
	private boolean isStructuralType;
	private List<String> typeList = new ArrayList<String>();
	
	private static Log log = LogFactory.getLog(DitaClassImpl.class);


	/**
	 * @param classSpec
	 * @throws DitaException 
	 */
	public DitaClassImpl(String classSpec) throws DitaException {
		if (classSpec == null || classSpec.trim().equals(""))
			throw new DitaClassSpecificationException("Null or empty class specification.");
		this.classSpec = classSpec;
		StringTokenizer tokens = new StringTokenizer(classSpec, " ");
		String token = tokens.nextToken();
		this.isDomainType = false;
		this.isStructuralType = false;
		if (token.equals("+"))
			this.isDomainType = true;
		else if (token.equals("-"))
			this.isStructuralType = true;
		else 
			throw new DitaClassSpecificationException("First token of class specification \"" + classSpec + " is not '+' or '-'");
		if (!tokens.hasMoreTokens())
			throw new DitaClassSpecificationException("Class specification missing required first token following +/-: \"" + classSpec + "\"");
		
		while (tokens.hasMoreTokens()) {
			token = tokens.nextToken();
			typeList.add(token);
		}
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#getBaseType()
	 */
	public String getBaseType() {
		return this.typeList.get(0);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#getClassValue()
	 */
	public String getClassValue() {
		return this.classSpec;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#getLastType()
	 */
	public String getLastType() {
		return this.typeList.get(typeList.size() - 1);
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#getTypes()
	 */
	public List<String> getTypes() {
		return typeList;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#isDomainType()
	 */
	public boolean isDomainType() {
		return isDomainType;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#isStructuralType()
	 */
	public boolean isStructuralType() {
		return isStructuralType;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#isType(com.reallysi.rsuite.api.dita.DitaClass)
	 * @return True if this type is a the same as or specialization of the candidate type.
	 */
	public boolean isType(DitaClass candType) {

		List<String> candTypes = candType.getTypes();
		// Cannot be a specialization of the
        // candidate type if it is more specialized than we are:
		if (candTypes.size() > this.typeList.size())
			return false; 
		
		for (int i=0; i < candTypes.size() && i < typeList.size(); i++) {
			if (!typeList.get(i).equals(candTypes.get(i)))
				return false;
		}
		return true;
	}

	/* (non-Javadoc)
	 * @see com.reallysi.rsuite.api.dita.DitaClass#isType(java.lang.String)
	 */
	public boolean isType(String typeSpec) {
		return this.typeList.contains(typeSpec);
	}

}
