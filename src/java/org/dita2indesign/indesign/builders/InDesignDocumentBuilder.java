/**
 * Copyright (c) 2008 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.builders;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import net.sourceforge.dita4publishers.util.conversion.ConversionConfigValue;
import net.sourceforge.dita4publishers.util.conversion.ConversionConfigValueMap;
import net.sourceforge.dita4publishers.util.conversion.StringConfigValue;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.dita2indesign.indesign.inx.model.InDesignDocument;
import org.dita2indesign.indesign.inx.model.InxHelper;
import org.dita2indesign.indesign.inx.model.MasterSpread;
import org.dita2indesign.indesign.inx.model.Page;
import org.dita2indesign.indesign.inx.model.PageSideOption;
import org.dita2indesign.indesign.inx.model.Spread;
import org.dita2indesign.indesign.inx.model.Story;
import org.dita2indesign.indesign.inx.model.TextFrame;
import org.xml.sax.InputSource;


/**
 * Takes an RSuite content assembly representing a single publication issue as input
 * and generates a new InDesign document with links to the issue's articles placed
 * in placeholder frames.
 */
public class InDesignDocumentBuilder {
	
	public static final String CONFIG_PARAM_NEXT_MASTER = "nextMaster";
	public static final String CONFIG_PARAM_PAGES = "pages";
	public static final String CONFIG_PARAM_MASTER_NAME = "masterName";
	public static final String CONFIG_PARAM_START_PAGE = "startPage";
	public static final String CONFIG_PARAM_FIRST_MASTER = "firstMaster";
	/**
	 * 
	 */
	public static final String INITIAL_FRAME_LABEL = "initialFrame";
	private static   Log log = LogFactory.getLog(InDesignDocumentBuilder.class);
	public static final String NS_URI = "http://www.reallysi.com";
	private int _pageCtr = 0;
	
	/**
	 * @param context 
	 * @param gdTemplate
	 * @param gdIssueCa
	 */
	public InDesignDocumentBuilder() {
	}

	/**
	 * @param issueCaSource 
	 * @param inDesignTemplateSource 
	 * @param context 
	 * @return
	 */
	public InDesignDocument buildDocument(InputSource inDesignTemplateSource) throws Exception {
		if (log.isDebugEnabled())
			log.debug("buildDocument(): inDesignTemplateSource=\"" + inDesignTemplateSource.getSystemId() + "\"");
		// Load the template then clone it to make our starting doc.
		InDesignDocument template = new InDesignDocument(inDesignTemplateSource);

		InDesignDocument doc = new InDesignDocument(template, true);
		
		return doc;
	}
	
	public void addInCopyArticleToDoc(
			InDesignDocument inDesignDoc, 
			File incx, 
			ConversionConfigValueMap spreadConfig) throws Exception
	{
		throw new RuntimeException("Method not updated to latest INX library");
//	    String initialMasterName = spreadConfig.getStringValue(CONFIG_PARAM_FIRST_MASTER);
//	    
//	    if (initialMasterName == null) {
//	    	throw new Exception("No value for required configuration item \"" + CONFIG_PARAM_FIRST_MASTER + "\"");
//	    }
//
//	    MasterSpread masterSpread = inDesignDoc.getMasterSpread(initialMasterName);
//	    if (masterSpread == null)
//        {
//            throw new Exception("The masterSpread " + initialMasterName + " was not found in the template.");
//        }
//	    
//	    _pageCtr++; 
//	    
//	    boolean isEvenPage = (_pageCtr%2==0)?true:false;
//	    Spread spread;
//	    
//	    if (_pageCtr == 1)
//	    {
//	        spread = inDesignDoc.getSpread(0);
//	        // Make sure the first page is a right-hand page.
//	        Page page = spread.getPages().get(0); 
//	        page.setPageSide(PageSideOption.RIGHT_HAND);
//	        page.setAppliedMaster(masterSpread);
//	        page.overrideMasterSpreadObjects();
//	    }
//	    else
//	    {
//	    	// FIXME: If the first page to create
//	    	// is a right-hand page, then can
//	    	// create it in isolation, otherwise,
//	    	// have to create a two-page sequence
//	        int spreadNbr = _pageCtr/2;
//	        spread = inDesignDoc.getSpread(spreadNbr);
//            if (spread == null)
//            {
//                spread = inDesignDoc.addSpread(initialMasterName);
//            }
//	        Page page = spread.addPage(_pageCtr);
//	        page.setAppliedMaster(masterSpread);
//	        page.overrideMasterSpreadObjects();
//	    }
//	    
//	    // Read the incx file
//	    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
//	    DocumentBuilder db = dbf.newDocumentBuilder();
//	    Document doc = db.parse(incx);
//	    NodeList cflos = doc.getElementsByTagName("cflo");
//	    Element cflo = (Element) cflos.item(0);
//	    cflo.setAttribute("Self", "rc_UR-" + _pageCtr);
//	    
//	    
//	    // Make the frame
//	    TextFrame frame = makeDefaultTextFrame(inDesignDoc, isEvenPage);
//        
//        spread.addRectangle(frame);
//        
//	    // Make the story
//        Story incxStory = inDesignDoc.newStory(cflo);
//        frame.setParentStory(incxStory);
	}

	/**
	 * Adds an InCopy (INCX) article to the document. Overrides overrideable
	 * frames from the master page and then flows into the overridden frame, 
	 * starting with the frame labeled "initialFrame" or first overrideable
	 * frame, no initalFrame frame is found.
	 * @param context
	 * @param inDesignDoc
	 * @param incx
	 * @param spreadConfig
	 * @throws Exception
	 */
	public void addIncxArticleToDoc(
			InDesignDocument inDesignDoc, 
			File incx, 
			ConversionConfigValueMap spreadConfig) throws Exception
	{

	    // Make the story
		Story incxStory = null;
	    try {
			incxStory = InxHelper.getStoryForIncxDoc(inDesignDoc, incx);
		} catch (Exception e) {
			log.error("Exception from getStoryForIncxDoc: " + e.getMessage(), e);
			throw e;
		}
        
	    ConversionConfigValue value = spreadConfig.get(CONFIG_PARAM_FIRST_MASTER);
	    PageCreationOptions pageCreationOptions = 
	    		getPageCreationOptions(
	    				spreadConfig, 
	    				CONFIG_PARAM_FIRST_MASTER,
	    				value);
	    	    
	    // FIXME: Allow each topic type to configure whether or not it starts
	    // a new page sequence.
	    pageCreationOptions.setStartNewMainThread(true); 
	    List<TextFrame> frames = addPagesForPageMaster(inDesignDoc, pageCreationOptions);
	    TextFrame firstFrame = frames.get(0);
	    TextFrame lastFrame = frames.get(frames.size() - 1);
	    
	    value = spreadConfig.get(CONFIG_PARAM_NEXT_MASTER);
	    if (value != null) {
		    pageCreationOptions = 
		    		getPageCreationOptions(
		    				spreadConfig, 
		    				CONFIG_PARAM_FIRST_MASTER,
		    				value);
		    List<TextFrame> nextFrames = addPagesForPageMaster(inDesignDoc, pageCreationOptions);
		    lastFrame.setNextInThread(nextFrames.get(0));
	    }
	    
	    // Walk the thread and set the story on each member in the thread.
	    TextFrame frame = firstFrame;
	    while (frame != null) {
	    	frame.setParentStory(incxStory);
	    	frame = frame.getNextInThread();
	    }
	    
	}

	public List<TextFrame> addPagesForPageMaster(
			InDesignDocument inDesignDoc,
			PageCreationOptions pageCreationOptions) throws Exception,
			Exception {
		
		String initialMasterName = pageCreationOptions.getPageMasterName();
	    MasterSpread master = 
	    		inDesignDoc.
	    			getMasterSpread(initialMasterName);
	    if (master == null)
        {
            throw new Exception("The masterSpread " + pageCreationOptions.getPageMasterName() + " was not found in the template.");
        }
	    
	    _pageCtr++; // We will always add at least one page per page master. 
	    
	    boolean isEvenPage = (_pageCtr%2==0) ? true : false;
	    log.info("addIncxArticleToDoc(): _pageCtr=" + _pageCtr + ", isEvenPage=" + isEvenPage);

	    // If necessary, force to next page so page
	    // even/odd matches the "startPage" setting:

	    List<TextFrame> frames = new ArrayList<TextFrame>();
	    Spread spread;
	    Page page = null;
	    // Get the spread and page for the current page counter:
	    if (_pageCtr == 1) // First spread is a special case because the spread always exists 
	    	               // and we always get the odd page.
	    {
	    	spread = getSpreadForPageCtr(inDesignDoc, initialMasterName);
	        page = spread.getOddPage();
	    }
	    else
	    {
	    	// First get the spread for the initial page
	    	// counter, without regard for startPage value:
	        spread = getSpreadForPageCtr(inDesignDoc, initialMasterName);
	        page = spread.addPage(_pageCtr);
	        
	    }

	    // Now add a blank page if our start page is not the same
	    // as the page we have:
        if (("odd".equals(pageCreationOptions.getStartPage()) && isEvenPage) ||
	        	("even".equals(pageCreationOptions.getStartPage()) && !isEvenPage)) {
	        	_pageCtr++;
		        spread = getSpreadForPageCtr(inDesignDoc, initialMasterName);		        
		        page = spread.addPage(_pageCtr);
	    }
        page.setAppliedMaster(master);

        page.overrideMasterSpreadObjects();

	    TextFrame frame = getInitialTextFrame(initialMasterName, page);
	    frames.add(frame);
	    if (pageCreationOptions.startNewMainThread()) {
	    	// Unthread the frame we have from it's preceding thread member, if
	    	// any.
	    	TextFrame prevFrame = frame.getPreviousInThread();
	    	if (prevFrame != null) {
	    		frame.setPreviousInThread(null);
	    		prevFrame.setNextInThread(null);
	    	}
	    }
	   
	    // Add additional pages per the pagesToAdd value:
	    // Thread the frames across any added pages, adding
	    // the frames to the list to be returned.
	    
	    if (pageCreationOptions.getPagesToAdd() > 1) {
	    	List<Page> pages = new ArrayList<Page>();
		    log.info("Adding " + (pageCreationOptions.getPagesToAdd() - 1) + " additional pages...");
		    for (int i = 0; i < pageCreationOptions.getPagesToAdd(); i++) {
		    	_pageCtr++;
		    	log.info("  Adding page " + _pageCtr + "...");
		    	spread = getSpreadForPageCtr(inDesignDoc, master.getName());
		    	log.info("  Spread index=" + spread.getSpreadIndex());
		    	page = spread.addPage(_pageCtr);
		    	page.setAppliedMaster(master);
		    	pages.add(page);
	    	}
			
		    // Now override the overridable objects and thread
		    // text frames from page-to-page.
			for (Page newPage : pages) {
				newPage.setAppliedMaster(master);
				newPage.overrideMasterSpreadObjects();
			    frame = getInitialTextFrame(initialMasterName, newPage);
			    TextFrame prevFrame = frames.get(frames.size() - 1);
			    prevFrame.setNextInThread(frame);
			    frame.setPreviousInThread(prevFrame);
			    frames.add(frame);
			    if (!frame.getLastFrameInThread().equals(frame)) {
			    	frames.add(frame.getLastFrameInThread());
			    }
			}
	    }
		return frames;
	}

	public TextFrame getInitialTextFrame(
			String initialMasterName,
			Page page) throws Exception, Exception {
		// Now look for a text frame with the label "initialFrame" or
	    // just get the first text frame in the list of frames.
	    String targetLabel = INITIAL_FRAME_LABEL;
	    String targetLabel2 = INITIAL_FRAME_LABEL + (page.getPageSide().equals(PageSideOption.LEFT_HAND)? "Even" : "Odd");
	    TextFrame frame = getFrameForLabel(page, targetLabel);
	    if (frame == null) {
	    	frame = getFrameForLabel(page, targetLabel2);
	    }	    
	    if (frame == null) {
	    	log.info("Failed to find a frame named \"" + targetLabel + "\" or \"" + targetLabel2 + "\", using first overrideable text frame.");
	    	frame = getFirstFrame(page);
	    }	    
	    if (frame == null) {
	    	throw new Exception("Failed to find an overridable frame for page master \"" + initialMasterName + "\"");
	    }
		return frame;
	}

	public PageCreationOptions getPageCreationOptions(
			ConversionConfigValueMap spreadConfig, 
			String pageMasterOptionsName,
			ConversionConfigValue configValue)
			throws Exception {
		PageCreationOptions pageCreationOptions = new PageCreationOptions();
	    
	    if (configValue instanceof StringConfigValue) {
	    	String initialMasterName = spreadConfig.getStringValue(pageMasterOptionsName);
		    if (initialMasterName == null) {
		    	throw new Exception("No value for required configuration item \"" + pageMasterOptionsName + "\"");
		    }
		    pageCreationOptions.setPageMasterName(initialMasterName);
		    String temp = spreadConfig.getStringValue(CONFIG_PARAM_START_PAGE);
		    if (temp != null && !"".equals(temp.trim())) {
		    	pageCreationOptions.setStartPage(temp);
		    }

	    } else if (configValue instanceof ConversionConfigValueMap ) { 
	    	ConversionConfigValueMap map = (ConversionConfigValueMap)configValue;
	    	String initialMasterName = map.getStringValue(CONFIG_PARAM_MASTER_NAME);
		    if (initialMasterName == null) {
		    	throw new Exception("No value for required configuration item \"" + CONFIG_PARAM_MASTER_NAME + "\" for parameter " + pageMasterOptionsName) ;
		    }
		    pageCreationOptions.setPageMasterName(initialMasterName);
		    String temp = map.getStringValue(CONFIG_PARAM_START_PAGE);
		    if (temp != null && !"".equals(temp.trim())) {
		    	pageCreationOptions.setStartPage(temp);
		    }
		    temp = map.getStringValue(CONFIG_PARAM_PAGES);
		    if (temp != null && !"".equals(temp.trim())) {
		    	int pagesToAdd = 1;
		    	try {
		    		pagesToAdd = Integer.valueOf(temp).intValue();
		    	} catch (NumberFormatException e) {
		    		log.warn("Value \"" + temp + "\" for parameter \"" + CONFIG_PARAM_PAGES + "\" for property \"" + pageMasterOptionsName + "\" is not an integer.");
		    	}
		    	pageCreationOptions.setPagesToAdd(pagesToAdd);

		    }
	    } else {
	    	throw new Exception("Unrecognized value object \"" + configValue.getClass().getSimpleName() + "\"");
	    }
	    return pageCreationOptions;
	}

	/**
	 * Gets the spread for the specified page number.
	 * If the spread does not already exist, adds it to
	 * the InDesign document. Does not override any 
	 * overrideable options as that has to be done at the
	 * page or spread level depending on how pages are being
	 * added to the spread.
	 * @param inDesignDoc The document to get the spread from.
	 * @param pageMasterName The page master to use for the spread
	 * @return The spread.
	 * @throws Exception
	 */
	public Spread getSpreadForPageCtr(
			InDesignDocument inDesignDoc,
			String pageMasterName) throws Exception {
		Spread spread;		
		int spreadNbr = 0;
		if (_pageCtr > 1) {
			spreadNbr = (_pageCtr == 2 ? 1 : (_pageCtr/2)); // The 2nd page starts on the 2nd spread
		}
		log.info("addIncxArticleToDoc(): Spread number is " + spreadNbr);
		spread = inDesignDoc.getSpread(spreadNbr);
		if (spread == null)
		{
		    spread = inDesignDoc.addSpread(pageMasterName);
		}
		return spread;
	}

	/**
	 * Gets the first overridable frame from the page
	 * @param page
	 * @return First overrideable frame, or null if there is no overridable frame.
	 * @throws Exception
	 */
	private TextFrame getFirstFrame(Page page) throws Exception {
		TextFrame frame = null;
	    for (TextFrame candFrame : page.getAllFrames()) {
	    	if (candFrame.isOverrideable()) {
	    		return candFrame;
	    	}
	    }
		return frame;
	}

	/**
	 * @param page
	 * @param targetLabel
	 * @return
	 */
	public TextFrame getFrameForLabel(Page page, String targetLabel) {
		TextFrame frame = null;
	    for (TextFrame candFrame : page.getAllFrames()) {
	    	String label = candFrame.getLabel();
	    	if (targetLabel.equals(label)) {
	    		frame = candFrame;
	    		break;
	    	}
	    }
		return frame;
	}

	public void addArticleToBook(InDesignDocument inDesignDoc, File incx, String masterSpreadName) throws Exception
    {
		throw new RuntimeException("Method not updated to latest INX library");
//	    _pageCtr++; 
//
//        MasterSpread masterSpread = inDesignDoc.getMasterSpread(masterSpreadName);
//        if (masterSpread == null)
//        {
//            throw new Exception("The masterSpread " + masterSpreadName + " was not found in the template.");
//        }
//        
//        boolean evenPage = (_pageCtr%2==0)?true:false;
//        Spread spread;
//        if (_pageCtr == 1)
//        {
//            spread = inDesignDoc.getSpread(0);
//            Page page = spread.getPages().get(0);
//            page.setAppliedMaster(masterSpread);
//            page.overrideMasterSpreadObjects();
//        }
//        else // if (evenPage)
//        {
//            int spreadNbr = _pageCtr/2;
//            spread = inDesignDoc.getSpread(spreadNbr);
//            if (spread == null)
//            {
//                spread = inDesignDoc.addSpread(masterSpreadName);
//            }
//            Page page = spread.addPage(_pageCtr);
//            page.setAppliedMaster(masterSpread);            
//            page.overrideMasterSpreadObjects();
//        }
//        
//        // Read the incx file
//        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
//        DocumentBuilder db = dbf.newDocumentBuilder();
//        Document doc = db.parse(incx);
//        NodeList cflos = doc.getElementsByTagName("cflo");
//        Element cflo = (Element) cflos.item(0);
//        cflo.setAttribute("Self", "rc_UR-" + _pageCtr);
//        
//        
//        // Make the frame
//        TextFrame frame = inDesignDoc.newTextFrame();
//        
//        // Add the frame to the page
//        double xTranslate = evenPage?-414:0;
//        double yTranslate = 1;
//        if (_pageCtr == 1)
//        {
//            xTranslate = 1;
//        }
//        
//        double x1 = 36;  // This is the left margin
//        double x2 = 377;
//        double y1 = -235; // I don't understand this value at all
//        double y2 = 233;
//        
//        frame.getGeometry().getBoundingBox().setCorners(x1, y1, x2, y2);
//        frame.getGeometry().getTransformationMatrix().setXTranslation(xTranslate);
//        frame.getGeometry().getTransformationMatrix().setYTranslation(yTranslate);
//        
//        spread.addRectangle(frame);
//        
//        // Make the story
//        Story incxStory = inDesignDoc.newStory(cflo);
//        frame.setParentStory(incxStory);
    }
	
}
