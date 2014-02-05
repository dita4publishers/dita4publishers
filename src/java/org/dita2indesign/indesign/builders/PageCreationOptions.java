package org.dita2indesign.indesign.builders;

/**
 * Bean to hold options that control addition of pages
 * to spreads.
 *
 */
public class PageCreationOptions {

	String pageMasterName = null;
    String startPage = "next";
    int pagesToAdd = 1;
	private boolean startNewMainThread = false; // By default, new pages add to current thread.
    
	public void setPageMasterName(String pageMasterName) {
		this.pageMasterName = pageMasterName;
	}

	public void setStartPage(String startPage) {
		this.startPage = startPage;
	}

	public void setPagesToAdd(int pagesToAdd) {
		this.pagesToAdd = pagesToAdd;
	}

	public String getPageMasterName() {
		return this.pageMasterName;
	}

	public String getStartPage() {
		return this.startPage;
	}

	public int getPagesToAdd() {
		return this.pagesToAdd;
	}

	public boolean startNewMainThread() {
		return this.startNewMainThread;
	}

	public void setStartNewMainThread(boolean startNewMainThread) {
		this.startNewMainThread = startNewMainThread;
	}

}
