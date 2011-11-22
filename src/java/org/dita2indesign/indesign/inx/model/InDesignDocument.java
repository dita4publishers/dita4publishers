/**
 * Copyright (c) 2007 Really Strategies, Inc.
 */
package org.dita2indesign.indesign.inx.model;

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;

import org.apache.log4j.Logger;
import org.dita2indesign.indesign.inx.model.Link.LinkType;
import org.dita2indesign.indesign.inx.visitors.InDesignDocumentVisitor;
import org.dita2indesign.util.DataUtil;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;


/**
 * Represents a complete InDesign document.
 */
public class InDesignDocument extends InDesignObject {

	/**
	 * 
	 */
	public static final double SPREAD_TO_PAGE_PADDING = 144.0;

	/**
	 * 
	 */
	public static final double SPREAD_TO_SPREAD_GAP = 36.0;

	/**
	 * 
	 */
	public static final String CFLO_TAGNAME = "cflo";

	/**
	 * 
	 */
	public static final String DOCP_TAGNAME = "docp";

	/**
	 * 
	 */
	public static final String MSPR_TAGNAME = "mspr";

	private static Logger logger = Logger.getLogger(InDesignDocument.class);

	/**
	 * 
	 */
	public static final String SPRD_TAGNAME = "sprd";

	private URL dataSourceUrl;

	protected List<Story> stories = new ArrayList<Story>();

	private Map<String, InDesignObject> objectsById = new HashMap<String, InDesignObject>();

	private Map<String, MasterSpread> masterSpreads = new HashMap<String, MasterSpread>();

	private List<Spread> spreads = new ArrayList<Spread>();

	private DocumentPreferences docPrefs;

	private Document dataSource;

	private Map<InDesignDocument, Map<String, InDesignObject>> clonedObjectMaps = 
		new HashMap<InDesignDocument, Map<String, InDesignObject>>();

	private List<Link> links = new ArrayList<Link>();

	private Map<String, ParagraphStyle> pstylesByName = new HashMap<String, ParagraphStyle>();
	private Map<String, CharacterStyle> cstylesByName = new HashMap<String, CharacterStyle>();
//	private Map<String, InDesignObject> ostylesByName = new HashMap<String, InDesignObject>();
//	private Map<String, InDesignObject> tstylesByName = new HashMap<String, InDesignObject>();


	/**
	 * 
	 */
	public static final String TAG_KEY_LABEL = "Label";

	/**
	 * 
	 */
	public static final String PROP_PNAM = "pnam";

	/**
	 * 
	 */
	public static final String PROP_SELF = "Self";

	/**
	 * 
	 */
	public static final String PROP_NTXF = "ntxf";

	public static final String PROP_NMBS = "nmbs";

	public static final String PROP_NPFX = "npfx";

	public static final String PROP_PAGC = "PagC";

	public static final String PROP_IGEO = "IGeo";

	public static final String PROP_PGSD = "PgSd";

	public static final String PROP_PBND = "pbnd";

	public static final String PROP_PTAG = "ptag";

	public static final String PROP_PBIN = "pbin";

	public static final String CLNK_TAGNAME = "clnk";

	public static final String PAGE_TAGNAME = "page";

	public static final String CREC_TAGNAME = "crec";

	public static final String TXTF_TAGNAME = "txtf";

	public static final String TXSR_TAGNAME = "txsr";
	
	public static final String PCNT_TAGNAME = "pcnt";

	public static final String IMAG_TAGNAME = "imag";

	public static final String PROP_LNKI = "LnkI";

	public static final String PROP_STRP = "strp";

	public static final String PROP_LTXF = "ltxf";

	public static final String PROP_FTXF = "ftxf";

	public static final String PROP_PTXF = "ptxf";

	public static final String PROP_OVRL = "ovrl";

	public static final String PROP_PMAS = "pmas";

	private static final Map<String, Class<? extends InDesignObject>> tagToObjectClassMap = new HashMap<String, Class<? extends InDesignObject>>();

	private static final Map<String, Class<? extends InDesignComponent>> tagToComponentClassMap = new HashMap<String, Class<? extends InDesignComponent>>();

	public static final String PROP_PRST = "prst";

	public static final String PROP_CRST = "crst";

	public static final String PSTY_TAGNAME = "psty";

	public static final String CSTY_TAGNAME = "csty";



	static {
		// Tags to Objects:
		tagToObjectClassMap.put(CLNK_TAGNAME, Link.class);
		tagToObjectClassMap.put(CFLO_TAGNAME, Story.class);
		tagToObjectClassMap.put(PAGE_TAGNAME, Page.class);
		tagToObjectClassMap.put(CREC_TAGNAME, Rectangle.class);
		tagToObjectClassMap.put(TXTF_TAGNAME, TextFrame.class);
		tagToObjectClassMap.put(CSTY_TAGNAME, CharacterStyle.class);
		tagToObjectClassMap.put(PSTY_TAGNAME, ParagraphStyle.class);
		
		// Tags to Components:
		tagToComponentClassMap.put(TXSR_TAGNAME, TextStyleRange.class);
		tagToComponentClassMap.put(PCNT_TAGNAME, TextContents.class);
	}

	/**
	 * @param inxData
	 */
	public InDesignDocument() {
		super();
	}

	/**
	 * Construct a new document by cloning an existing document,
	 * copying only the master spreads. Note that this is different
	 * from a generic loadObject(InDesignObject) operation (as for InDesignObject), which 
	 * is a full copy.
	 * @param inddDoc
	 * @throws Exception 
	 */
	public InDesignDocument(InDesignDocument inddDoc) throws Exception {
		// Clone the document and do not remove spreads
		this(inddDoc, false);
	}

	/**
	 * Construct a new document by cloning an existing document,
	 * copying only the master spreads. Note that this is different
	 * from a generic loadObject(InDesignObject) operation (as for InDesignObject), which 
	 * is a full copy.
	 * @param inddDoc
	 * @throws Exception 
	 */
	public InDesignDocument(InDesignDocument inddDoc, boolean removeSpreads) throws Exception {
		Document cloneSourceDoc = inddDoc.getDataSource();
		if (cloneSourceDoc == null)
			throw new Exception("Got null data source from input InDesign document.");
		this.dataSource = (Document)cloneSourceDoc.cloneNode(true);
		logger.debug("InDesignDocument(inddDoc): setting dataSource to " + dataSource);
		Element clonedDataSource = this.dataSource.getDocumentElement();
		if (removeSpreads) {
		// Now delete the components that hold actual content, namely spreads and stories:
			for (Element spread : DataUtil.getElementChildren(clonedDataSource, null, SPRD_TAGNAME)) {
				clonedDataSource.removeChild(spread);
			}			
			// FIXME: For stories, we only want to delete stories that are associated with frames on
			// normal spreads, not master spreads. So for now just leaving them in.
//			for (Element story : DataUtil.getElementChildren(clonedDataSource, null, CFLO_TAGNAME)) {
//				clonedDataSource.removeChild(story);
//			}
		}
		this.load(clonedDataSource);
		this.spreads.clear(); // Just to make sure
		// Now make sure there is a spread as a document must have at least one spread.
		Spread spread = this.newSpread(this.getMasterSpreads().get(0).getName());
		spread.addPage(1);
	}

	/**
	 * @param templateUrl
	 * @throws Exception 
	 */
	public InDesignDocument(URL templateUrl) throws Exception {
		this.load(templateUrl);
	}

	/**
	 * @param inxSource
	 * @throws Exception 
	 */
	public InDesignDocument(InputSource inxSource) throws Exception {
		this.load(inxSource);
	}
	
	public void addChild(InDesignComponent comp) throws Exception {
		super.addChild(comp);
		if (comp instanceof Story) {
			this.stories.add((Story)comp);
			// FIXME: Need to do some more refactoring in order to be able to do 
			// this processing at this point.
//		} else if (comp instanceof MasterSpread) {
//			MasterSpread masterSpread = (MasterSpread)comp;
//			this.masterSpreads.put(masterSpread.getPName(), masterSpread);
//		} else if (comp instanceof Spread) {
//			this.spreads.add((Spread)comp);
		} else if (comp instanceof ParagraphStyle) {
			this.pstylesByName.put(comp.getPName(), (ParagraphStyle)comp);
		} else if (comp instanceof CharacterStyle) {
			this.cstylesByName.put(comp.getPName(), (CharacterStyle)comp);
		} else if (comp instanceof DocumentPreferences) {
			this.docPrefs = (DocumentPreferences)comp;

		}
	}


	/**
	 * @return
	 */
	public Document getDataSource() {
		return this.dataSource;
	}

	/**
	 * @return
	 */
	public Iterator<Story> getStoryIterator() {
		return stories.iterator();
	}

	/**
	 * @throws Exception 
	 * 
	 */
	public void load(URL dataSource) throws Exception {
		this.dataSourceUrl = dataSource;
		logger.debug("load(): + Loading data source=\"" + dataSource.toExternalForm());
		InputSource source = new InputSource(dataSource.openStream());
		load(source);
	}
	
	/**
	 * Gets the data source URL for the document, if any.
	 * @return The URL of the data source from which the document was constructed. May be null.
	 */
	public URL getDataSourceUrl() {
		return this.dataSourceUrl;
	}
	
	public void load(InputSource source) throws Exception {
		DocumentBuilder builder = DataUtil.constructNonValidatingDocumentBuilder();
		Document dom = builder.parse(source);
		Element docElem = dom.getDocumentElement();
		if (docElem == null) {
			throw new IOException("No root element for input document " + source.getSystemId());
		}
		load(docElem);
		logger.debug("load(): Setting dataSource to " + dom);
		this.dataSource = dom;
	}

	public void load(Element docElem) throws Exception {
		this.dataSource = docElem.getOwnerDocument();
		Iterator<Element> elemIter = DataUtil.getElementChildrenIterator(docElem);
		while (elemIter.hasNext()) {
			Element child = elemIter.next();
			logger.debug("load(): Element: " + child.getNodeName());
			if (child.getNodeName().equals(CFLO_TAGNAME)) {
				logger.debug("load(): Creating new Story...");
				this.newStory(child);
			} else if (child.getNodeName().equals(DOCP_TAGNAME)) {
				logger.debug("load(): Getting document preferences...");
				this.newDocumentPreferences(child);
			} else if (child.getNodeName().equals(MSPR_TAGNAME)) {
				logger.debug("load(): Creating new Master Spread...");
				this.newMasterSpread(child);
			} else if (child.getNodeName().equals(SPRD_TAGNAME)) {
				logger.debug("load(): Creating new Spread...");
				this.newSpread(child);
			} else {
				logger.debug(" + Creating new unhandled child " + child.getNodeName() + "...");
				InDesignComponent comp = this.newInDesignComponent(child);
				this.addChild(comp);
			}
		}
	}
	
	/**
	 * @param child
	 * @throws Exception 
	 */
	private void newSpread(Element child) throws Exception {
		newSpread(Spread.class, child);
	}

	/**
	 * @param child
	 * @throws Exception 
	 */
	private DocumentPreferences newDocumentPreferences(Element child) throws Exception {
		DocumentPreferences prefs = (DocumentPreferences) newComponent(DocumentPreferences.class, child);
		this.addChild(prefs);
		// this.docPrefs = prefs;
		return prefs;
	}

	/**
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	private MasterSpread newMasterSpread(Element child) throws Exception {
		MasterSpread obj = (MasterSpread) newSpread(MasterSpread.class, child);
		obj.postLoad();
		this.masterSpreads.put(obj.getPName(), obj);
		return obj;
	}

	/**
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	private Spread newSpread(Class<? extends Spread> clazz, Element child) throws Exception {
		Spread obj = (Spread) newObject(clazz, child);
		this.addChild(obj);
		// The spreadIndex parameter is zero-index 
		// for spread in list of spreads.
		obj.setSpreadIndex(spreads.size());
		if (!(obj instanceof MasterSpread)) {
			this.spreads.add(obj);
		}
		obj.postLoad();
		return obj;
	}

	/**
	 * Constructs a new component, which may be an InDesignComponent or an InDesignObject.
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	public InDesignComponent newInDesignComponent(Element child) throws Exception {
		logger.debug("newInDesignObject(): Creating new object or component from <" + child.getNodeName() + ">...");
		if (child.hasAttribute(PROP_SELF)) {
			Class<? extends InDesignObject> objectClass = tagToObjectClassMap.get(child.getNodeName());
			if (objectClass == null)
				objectClass = DefaultInDesignObject.class;
			InDesignObject newObject = (InDesignObject)newObject(objectClass, child);
			logger.debug("newInDesignObject():   New object has ID [" + newObject.getId() + "]");
			return newObject;
		} else {
			Class<? extends InDesignComponent> objectClass = tagToComponentClassMap.get(child.getNodeName());
			if (objectClass == null)
				objectClass = DefaultInDesignComponent.class;
			return newComponent(objectClass, child);
			
		}
		
	}


	/**
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	public Story newStory(Element child) throws Exception {
		Story story = (Story) newObject(Story.class, child);
		this.addChild(story);
		return story;
	}

	/**
	 * @param string
	 * @return
	 */
	public InDesignObject getObject(String id) {
		return this.objectsById.get(id);
	}

	/**
	 * @return
	 */
	public Set<String> getPageMasterNames() {
		return this.masterSpreads.keySet();
	}

	/**
	 * @param pageMasterName
	 * @return
	 */
	public MasterSpread getMasterSpread(String pageMasterName) {
		if (this.masterSpreads.containsKey(pageMasterName))
			return this.masterSpreads.get(pageMasterName);
		return null;
	}

	/**
	 * Register a new object with the document so it can maintain
	 * a master index of objects by ID.
	 * @param object
	 */
	public void registerObject(InDesignObject object) {
		String id = object.getId();
		if (id == null || this.objectsById.containsKey(id)) {
			id = assignObjectId();
			object.setId(id);
		}
		this.objectsById.put(object.getId(), object);
		object.setDocument(this);
	}

	/**
	 * @return
	 */
	public List<Spread> getSpreads() {
		return this.spreads;
	}

	/**
	 * @return
	 */
	public DocumentPreferences getDocumentPreferences() {
		return this.docPrefs;
	}

	/**
	 * @param i
	 * @return
	 */
	public Spread getSpread(int i) {
		if (i >= this.spreads.size())
			return null;
		return this.spreads.get(i);
	}

	/**
	 * 
	 * @return
	 * @throws Exception 
	 */
	public double getSpreadOffset() throws Exception {
		logger.debug("getSpreadOffset(): Starting, this.spreads.size=" + this.spreads.size());
		if (this.spreads.size() < 2) {
			return 0.0;
		}
		// Spread geometry is page-height + 144pt (72pt gap above and below page). 
		// There is a 36pt gap between spreads.
		double pageHeight = this.getDocumentPreferences().getPageHeight();
		double spreadHeight = pageHeight + SPREAD_TO_PAGE_PADDING;
		int spreadCount = this.spreads.size() - 1; // Offset for first spread is always 0
		double offset = (spreadHeight * spreadCount) + (SPREAD_TO_SPREAD_GAP * spreadCount); 
		logger.debug("getSpreadOffset(): Returning " + offset);
		return offset;
	}

	/**
	 * @return
	 */
	public List<MasterSpread> getMasterSpreads() {
		return new ArrayList<MasterSpread>(this.masterSpreads.values());
	}

	/**
	 * @param masterSpreadName
	 * @return
	 * @throws Exception 
	 */
	public Spread newSpread(String masterSpreadName) throws Exception {
		Spread newSpread = new Spread();
		assignIdAndRegister(newSpread);
		newSpread.setParent(this);
		newSpread.setSpreadIndex(this.spreads.size());
		this.spreads.add(newSpread);
		MasterSpread masterSpread = this.getMasterSpread(masterSpreadName);
		if (masterSpread == null) {
			logger.info("Master spread \"" + masterSpreadName + "\" not found. Master spreads: ");
			for (String key : this.masterSpreads.keySet()) {
				logger.info(" \"" + key + "\"");
			}
			throw new Exception("Failed to find master spread \"" + masterSpreadName + "\"");
		}
		newSpread.setTransformationMatrix(this.spreads.size());
		// Note that masters apply to pages, not spreads.
		for (Page page : newSpread.getPages()) {
			page.setAppliedMaster(masterSpread);
		}
		
		this.addChild(newSpread);
		return newSpread;
	}

	/**
	 * Create a new spread that reflects the 
     * @param masterSpreadName
     * @return
     * @throws Exception 
     */
    public Spread addSpread(String masterSpreadName) throws Exception {
    	Spread spread = newSpread(masterSpreadName);
        
        // Get the corresponding master spread, clone its data source,
        // and use that to load the spread.
        
        MasterSpread  masterSpread = this.getMasterSpread(masterSpreadName);
        
        spread.setTransformationMatrix(this.spreads.size());
        
        return spread;
    }
    
	/**
	 * @param newObject
	 */
	protected void assignIdAndRegister(InDesignObject newObject) {
		newObject.setId(this.assignObjectId());
		registerObject(newObject);
	}
	
	/**
	 * @param dataSource
	 * @return
	 * @throws Exception 
	 */
	public Page newPage(Element dataSource) throws Exception {
		Page page = (Page)newObject(Page.class, dataSource);
		page.postLoad();
		return page;
	}

	/**
	 * @return
	 * @throws Exception 
	 */
	public Page newPage() throws Exception {
		return (Page)newObject(Page.class, null);
	}




	/**
	 * @return
	 */
	String assignObjectId() {
		return "obj" + (this.objectsById.size() + 100);
	}

	/**
	 * @return
	 * @throws Exception 
	 */
	public boolean isFacingPages() throws Exception {
		return this.docPrefs.isFacingPages();
	}

	/**
	 * @return New rectangle
	 * @throws Exception 
	 */
	public Rectangle newRectangle() throws Exception {
		Rectangle rect = new Rectangle();
		assignIdAndRegister(rect);
		return rect;
	}

	/**
	 * @return New rectangle
	 * @throws Exception 
	 */
	public ParagraphStyle newParagraphStyle() throws Exception {
		ParagraphStyle obj = new ParagraphStyle();
		assignIdAndRegister(obj);
		return obj;
	}

	/**
	 * Unconditionally clone an InDesign Object.
	 * @param sourceObj
	 * @return The clone of the object.
	 * @throws Exception 
	 */
	public InDesignComponent clone(InDesignComponent sourceComp) throws Exception {
		if (sourceComp instanceof InDesignObject) {
			return clone((InDesignObject)sourceComp);
		}

		logger.debug("Cloning component " + sourceComp.getClass().getSimpleName());
		InDesignComponent clone = sourceComp.getClass().newInstance();
		clone.setDocument(this);
		clone.loadComponent(sourceComp);
		return clone;
	}

	/**
	 * Unconditionally clone an InDesign Object.
	 * @param sourceObj
	 * @return The clone of the object.
	 * @throws Exception 
	 */
	public InDesignComponent clone(InDesignObject sourceObj) throws Exception {
		logger.debug("Cloning object " + sourceObj.getClass().getSimpleName() + " [" + sourceObj.getId() + "]...");
		InDesignObject clone = sourceObj.getClass().newInstance();
		assignIdAndRegister(clone);
		// Now remember that we've cloned this source object so we can not 
		// clone it again if we don't want to:
		Map<String, InDesignObject> cloneMap = getCloneMapForDoc(sourceObj.getDocument());
		cloneMap.put(sourceObj.getId(), clone);
		clone.loadObject(sourceObj, clone.getId());
		return clone;
	}

	/**
	 * @param document
	 * @return
	 */
	private Map<String, InDesignObject> getCloneMapForDoc(
			InDesignDocument document) {
		if (!this.clonedObjectMaps.containsKey(document))
			this.clonedObjectMaps.put(document, new HashMap<String, InDesignObject>());
		return this.clonedObjectMaps.get(document);
	}

	/**
	 * @return
	 */
	public String reportObjectsById() {
		StringBuilder report = new StringBuilder("Objects By ID:\n");
		for (Map.Entry<String, InDesignObject> entry : this.objectsById.entrySet()) {
			report.append("[").append(entry.getKey()).append("] ").append(entry.getValue().getClass().getSimpleName()).append("\n");
		}
		return report.toString();
	}

	/**
	 * @param dataSource
	 * @return
	 * @throws Exception 
	 */
	public Rectangle newRectangle(Element dataSource) throws Exception {
		return (Rectangle)newObject(Rectangle.class, dataSource);
	}

	/**
	 * @param dataSource
	 * @return
	 * @throws Exception 
	 */
	public TextFrame newFrame(Element dataSource) throws Exception {
		return (TextFrame)newObject(TextFrame.class, dataSource);
	}

	/**
	 * @param dataSource
	 * @return
	 */
	public Group newGroup(Element dataSource) throws Exception {
		return (Group)newObject(Group.class, dataSource);
	}

	/**
	 * @param class1
	 * @param dataSource
	 * @return
	 * @throws Exception 
	 * @throws InstantiationException 
	 */
	private InDesignComponent newObject(Class<? extends InDesignObject> clazz, Element dataSource) throws Exception {
		logger.debug("newObject(): Creating new " + clazz.getSimpleName() + "...");
		InDesignObject obj = (InDesignObject) clazz.newInstance();
		obj.setDocument(this);
		if (dataSource != null) {
			logger.debug("newObject():   From element " + dataSource.getNodeName() + "...");
			obj.loadObject(dataSource);
			String selfValue = dataSource.getAttribute(PROP_SELF);
			if (selfValue != null && !"".equals(selfValue.trim())) {
				String id = InxHelper.decodeRawValueToSingleString(selfValue);
				obj.setId(id);
				this.registerObject(obj);
			} else {
				assignIdAndRegister(obj);
			}
			
		} else {
			assignIdAndRegister(obj);
		}
		logger.debug("newObject(): New object has ID [" + obj.getId() + "]");
		return obj;
	}
	
	/**
	 * @param objectClass
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	private InDesignComponent newComponent(
			Class<? extends InDesignComponent> clazz, Element child) throws InstantiationException, Exception {
		InDesignComponent comp = (InDesignComponent) clazz.newInstance();
		comp.setDocument(this);
		comp.loadComponent(child);
		return comp;
	}


	
	/**
	 * @param visitor
	 * @throws Exception 
	 */
	public void accept(InDesignDocumentVisitor visitor) throws Exception {
		visitor.visit(this);
	}

	/**
	 * @return
	 */
	public String reportChildObjects() {
		StringBuilder report = new StringBuilder("Child Objects::\n");
		for (InDesignComponent comp : this.getChildren()) {
			String dsName = comp.getInxTagName();
			if (comp instanceof InDesignObject) {
				InDesignObject obj = (InDesignObject)comp;
				report.append("[").append(obj.getId())
				  .append("] ");
			}
			report
			  .append(comp.getClass().getSimpleName())
			  .append(", <")
			  .append(dsName)
			  .append(">")
			  .append("\n");
		}
		return report.toString();
	}

	/**
	 * Clones an object only if it hasn't been already cloned. Returns
	 * the clone.
	 * @param sourceObj
	 * @return The clone of the source object.
	 * @throws Exception 
	 */
	public InDesignComponent cloneIfNew(InDesignObject sourceObj) throws Exception {
		return cloneIfNew(sourceObj, (InDesignComponent)null);
	}

	/**
	 * Clones an object only if it hasn't been already cloned. Returns
	 * the clone.
	 * @param sourceObj
	 * @return The clone of the source object.
	 * @throws Exception 
	 */
	public InDesignComponent cloneIfNew(InDesignObject sourceObj, InDesignComponent targetParent) throws Exception {
		Map<String, InDesignObject> cloneMap = getCloneMapForDoc(sourceObj.getDocument());
		if (cloneMap.containsKey(sourceObj.getId()))
			return cloneMap.get(sourceObj.getId());
		InDesignComponent clone = this.clone(sourceObj);
		if (targetParent != null)
			targetParent.addChild(clone);
		return clone;
	}

	/**
	 * @return
	 */
	public List<Link> getLinks() {
		return this.links;
	}

	/**
	 * Adds or updates a Link in the link map. 
	 * @param link
	 * @return the link that was added
	 */
	public InDesignComponent addLink(Link link) {
		this.links.add(link);
		return link;
	}

	/**
	 * Construct a new link.
	 * @return
	 */
	public Link newLink() {
		Link link = new Link();
		assignIdAndRegister(link);
		this.links.add(link);
		return link;
	}

	/**
	 * Create a new text frame with the specified link placed
	 * as its content. This results in a new story, which holds
	 * the link and to which the text frame is associated.
	 * @param link Link to place in the frame.
	 * @return
	 * @throws Exception 
	 */
	public TextFrame newTextFrame(Link link) throws Exception {
		TextFrame frame = new TextFrame();
		assignIdAndRegister(frame);
		// Create the story that is the parent of the frame and contains
		// the link:
		this.newStory(frame, link);		
		return frame;
	}
	
	/**
     * Create a new text frame. This results in a new story, which 
     * the text frame is associated.
     * @return
     * @throws Exception 
     */
    public TextFrame newTextFrame() throws Exception {
        TextFrame frame = new TextFrame();
        assignIdAndRegister(frame);
        this.newStory(frame);
        return frame;
    }

	/**
	 * Construct a new Story that is associated with the specified
	 * text frame and which contains the specified link as its
	 * placed content.
	 * @param frame Text frame to which the story is associated.
	 * @param link Link containing the content for the story.
	 * @return
	 * @throws Exception 
	 */
	private Story newStory(TextFrame frame, Link link) throws Exception {
		Story story = new Story();
		assignIdAndRegister(story);
		story.addChild(link);
		this.addChild(story);
		
		frame.setParentStory(story);
		
		return story;
	}
	
	/**
     * Construct a new Story that is associated with the specified
     * text frame,
     * @param frame Text frame to which the story is associated.
     * @return
	 * @throws Exception 
     */
    private Story newStory(TextFrame frame) throws Exception {
        Story story = new Story();
        assignIdAndRegister(story);
        this.addChild(story);
        
        frame.setParentStory(story);
        
        return story;
    }

	/**
	 * @param link
	 * @return
	 * @throws Exception 
	 */
	public Rectangle newRectangle(Link link) throws Exception {
		if (link.getLinkType() == LinkType.INCOPY) {
			throw new Exception("Cannot link to an InCopy article from a graphic rectangle");
		}
		Rectangle rect = newRectangle();
		
		return rect;
	}

	/**
	 * @return
	 * @throws Exception 
	 */
	public Image newImage() throws Exception {
		Image image = new Image();
		assignIdAndRegister(image);
		return image;
	}

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.InDesignComponent#updatePropertyMap()
	 */
	@Override
	public void updatePropertyMap() throws Exception {
		InxObjectList storyList = new InxObjectList(this.stories);
		this.setProperty("stls", storyList);
	}

	/**
	 * Import a story from one document (e.g., an InCopy article) into this document,
	 * updating style references as necessary.
	 * @param incxStory The story to be imported.
	 * @return The imported story object.
	 * @throws Exception 
	 */
	public Story importStory(Story incxStory) throws Exception {
		
		Map<String, ParagraphStyle> paraStyleMap = new HashMap<String, ParagraphStyle>();
		
		Story newStory = new Story();
		this.assignIdAndRegister(newStory);
		
		Iterator<TextStyleRange> iter = incxStory.getTextStyleRangeIterator();
		
		while (iter.hasNext()) {
			TextStyleRange incomingTxsr = iter.next();
			TextStyleRange txsr = (TextStyleRange)this.clone(incomingTxsr);

			InDesignObject incomingStyle = incomingTxsr.getParagraphStyle(); 
			if (incomingStyle == null) {
				throw new Exception("Failed to get object for referenced paragraph style ID [" + txsr.getObjectReferenceProperty(PROP_PRST) + "]");
			}
			String styleName = incomingStyle.getPName();
			ParagraphStyle targetPStyle = this.getParagraphStyle(styleName);
			if (targetPStyle == null) {
				targetPStyle = (ParagraphStyle)this.clone(incomingStyle);
				this.addParagraphStyle(targetPStyle);
			}
			txsr.setObjectReferenceProperty(PROP_PRST, targetPStyle);

			incomingStyle = incomingTxsr.getCharacterStyle(); 
			if (incomingStyle == null) {
				logger.warn("Failed to get object for referenced character style ID [" + txsr.getObjectReferenceProperty(PROP_PRST) + "]");
			} else {
				styleName = incomingStyle.getPName();
				CharacterStyle targetCStyle = this.getCharacterStyle(styleName);
				if (targetCStyle == null) {
					targetCStyle = (CharacterStyle)this.clone(incomingStyle);
					this.addCharacterStyle(targetCStyle);
				}
				txsr.setObjectReferenceProperty(PROP_CRST, targetCStyle);
			}
			
			newStory.addChild(txsr);

		}
		this.addChild(newStory);
		return newStory;
	}

	/**
	 * Add a paragraph style to the document.
	 * @param styleObject
	 * @throws Exception 
	 */
	public ParagraphStyle addParagraphStyle(ParagraphStyle styleObject) throws Exception {
		this.pstylesByName.put(styleObject.getPName(), styleObject);
		return styleObject;
	}

	/**
	 * Add a character style to the document.
	 * @param styleObject
	 * @throws Exception 
	 */
	public CharacterStyle addCharacterStyle(CharacterStyle styleObject) throws Exception {
		this.cstylesByName.put(styleObject.getPName(), styleObject);
		return styleObject;
	}

	/**
	 * @param styleName
	 * @return
	 */
	public ParagraphStyle getParagraphStyle(String styleName) throws Exception {
		ParagraphStyle style = null;
		if (this.pstylesByName.containsKey(styleName)) {
			style = this.pstylesByName.get(styleName);
		}
		return style;
	}

	/**
	 * @param styleName
	 * @return
	 */
	public CharacterStyle getCharacterStyle(String styleName) throws Exception {
		CharacterStyle style = null;
		if (this.cstylesByName.containsKey(styleName)) {
			style = this.cstylesByName.get(styleName);
		}
		return style;
	}

	public static void updateThreadsForOverriddenFrames(
			Page masterPage,
			Map<Rectangle, Rectangle> masterToOverride) 
					throws Exception,
			InDesignDocumentException {
		
		List<TextFrame> firstThreadFrames = new ArrayList<TextFrame>();
		for (Rectangle masterRect : masterToOverride.keySet()) {
			if (masterRect instanceof TextFrame) {
				TextFrame masterFrame = (TextFrame)masterRect;
				masterFrame = masterFrame.getFirstFrameInThread();
				if (masterFrame != null) {
					if (!firstThreadFrames.contains(masterFrame)) {
						firstThreadFrames.add(masterFrame);
					}
				}
			}
		}
		
		// Now we have a list of the first frames of all the threads
		// in the master that have been overridden.
		
		// Now rework any threading in the cloned frames:
		
		for (TextFrame firstMaster : firstThreadFrames) {
			TextFrame nextMaster = firstMaster.getNextInThread();
			TextFrame nextOverride = null;
			TextFrame prevOverride = (TextFrame)masterToOverride.get(firstMaster);
			if (prevOverride == null) {
				throw new InDesignDocumentException("First thread in page master \"" + ((MasterSpread)firstMaster.getParent()).getName() + "\" was not overridden.");
			}
			while (nextMaster != null) {
				nextOverride = (TextFrame)masterToOverride.get(nextMaster);
				if (nextOverride == null) {
					throw new InDesignDocumentException("Frame [" + nextMaster.getId() + "] in thread in page master \"" + ((MasterSpread)firstMaster.getParent()).getName() + "\" was not overridden.");
				}
				prevOverride.setNextInThread(nextOverride);
				nextOverride.setPreviousInThread(prevOverride);
				prevOverride = nextOverride;
				nextMaster = nextMaster.getNextInThread();
			}
			prevOverride.setNextInThread(null); // Make sure we end the thread.
		}
	}


}
