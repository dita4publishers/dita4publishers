

package net.sourceforge.dita4publishers.impl.ditabos;

public class DomException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public DomException(Throwable e) {

		super(e);

	}

	public DomException(String msg) {

		super(msg);

	}

	public DomException(String msg, Throwable e) {

		super(msg, e);

	}

}
