package net.sourceforge.dita4publishers.slideset.visitors;


/**
 * Errors that are specific to the business logic for 
 * processing slide sets.
 *
 */
public class SlideSetException extends Exception {

    private static final long serialVersionUID = 1L;

    public SlideSetException(
            String msg) {
        super(msg);
    }

    public SlideSetException(
            String msg,
            Exception e) {
        super(msg, e);
    }

}
