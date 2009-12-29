/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.util;

import java.util.Calendar;
import java.util.Date;

/**
 * Trivial utility for capturing and reporting timing information.
 */
public class TimingUtils {

	public static String reportElapsedTime(Date startTime) {
		long elapsedTime = Calendar.getInstance().getTime().getTime() - startTime.getTime();
		if (elapsedTime < 500) {
			return elapsedTime + " milliseconds";
		} else if (elapsedTime < 60000) {
			return (elapsedTime/1000.0) + " seconds";
		} else {
			return (elapsedTime/60000) + " minutes";
		}
	}

	/**
	 * @return
	 */
	public static Date getNowTime() {
		return Calendar.getInstance().getTime();
	}
	

}
