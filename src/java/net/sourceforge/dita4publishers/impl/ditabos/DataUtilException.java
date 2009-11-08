/*--------------------------------------------------------------------------

    Copyright (c) 2004 W. Eliot Kimber. All rights reserved.

   

  ---------------------------------------------------------------------------*/

package net.sourceforge.dita4publishers.impl.ditabos;



public class DataUtilException extends Exception {


	private static final long serialVersionUID = 1L;



	public DataUtilException(Throwable e) {

    	super(e);

    }



    public DataUtilException(String msg, Throwable e) {

        super(msg, e);

    }



    public DataUtilException(String msg) {

        super(msg);

    }



}

