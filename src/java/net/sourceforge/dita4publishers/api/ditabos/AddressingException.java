

package net.sourceforge.dita4publishers.api.ditabos;

/**
 * @author eliot
 *
 */

public class AddressingException extends Exception {

	private static final long serialVersionUID = 1L;

	public AddressingException(String msg) {
		super(msg);
	}

	public AddressingException(String msg, Throwable e) {
		super(msg, e);
	}

}

