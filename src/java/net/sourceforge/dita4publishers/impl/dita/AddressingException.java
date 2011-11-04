

package net.sourceforge.dita4publishers.impl.dita;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;

/**
 * @author eliot
 *
 */

public class AddressingException extends DitaApiException {

	private static final long serialVersionUID = 1L;

	public AddressingException(String msg) {
		super(msg);
	}

	public AddressingException(String msg, Throwable e) {
		super(msg, e);
	}

}

