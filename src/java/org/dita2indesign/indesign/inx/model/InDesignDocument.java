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
	static final String PROP_SELF = "Self";

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

	private static final Map<String, Class<? extends InDesignObject>> tagToObjectClassMap = new HashMap<String, Class<? extends InDesignObject>>();

	private static final Map<String, Class<? extends InDesignComponent>> tagToComponentClassMap = new HashMap<String, Class<? extends InDesignComponent>>();

	static {
		// FIXME: Fill out this mapping
		tagToObjectClassMap.put(CLNK_TAGNAME, Link.class);
		tagToObjectClassMap.put(CFLO_TAGNAME, Story.class);
		tagToObjectClassMap.put(PAGE_TAGNAME, Page.class);
		tagToObjectClassMap.put(CREC_TAGNAME, Rectangle.class);
		tagToObjectClassMap.put(TXTF_TAGNAME, TextFrame.class);
		
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
		// Now make sure there is a spread as a document must have at least one spread.
		this.newSpread(this.getMasterSpreads().get(0).getName());
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

	/* (non-Javadoc)
	 * @see org.dita2indesign.indesign.inx.model.AbstractInDesignObject#loadObject(org.dita2indesign.indesign.inx.model.InDesignObject)
	 */
	@Override
	public void loadObject(InDesignObject sourceObj) throws Exception {
		super.loadObject(sourceObj);
		// FIXME: Handle case for documents with no XML data source. 
	}

	public void load(Element docElem) throws Exception {
		this.setDataSource(docElem);
		this.dataSource = docElem.getOwnerDocument();
		Iterator<Element> elemIter = DataUtil.getElementChildrenIterator(docElem);
		while (elemIter.hasNext()) {
			Element child = elemIter.next();
//			logger.debug(" + Element: " + child.getNodeName());
			if (child.getNodeName().equals(CFLO_TAGNAME)) {
				logger.debug(" + Creating new Story...");
				this.newStory(child);
			} else if (child.getNodeName().equals(DOCP_TAGNAME)) {
				logger.debug(" + Getting document preferences...");
				this.newDocumentPreferences(child);
			} else if (child.getNodeName().equals(MSPR_TAGNAME)) {
				logger.debug(" + Creating new Master Spread...");
				this.newMasterSpread(child);
			} else if (child.getNodeName().equals(SPRD_TAGNAME)) {
				logger.debug(" + Creating new Spread...");
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
	private DocumentPreferences newDocumentPreferences(Element child) throws Exception {
		DocumentPreferences prefs = (DocumentPreferences) newObject(DocumentPreferences.class, child);
		this.addChild(prefs);
		this.docPrefs = prefs;
		return prefs;
	}

	/**
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	private MasterSpread newMasterSpread(Element child) throws Exception {
		MasterSpread obj = (MasterSpread) newObject(MasterSpread.class, child);
		this.addChild(obj);
		obj.loadObject(child, this.masterSpreads.size());
		this.objectsById.put(obj.getId(), obj);
		this.masterSpreads.put(obj.getPName(), obj);
		return obj;
	}

	/**
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	private InDesignComponent newSpread(Element child) throws Exception {
		Spread obj = (Spread) newObject(Spread.class, child);
		this.addChild(obj);
		this.spreads.add(obj);
		// The spreadIndex parameter is zero-index 
		// for spread in list of spreads.
		obj.loadObject(child, this.spreads.size() - 1);
		return obj;
	}

	/**
	 * Constructs a new component, which may be an InDesignComponent or an InDesignObject.
	 * @param child
	 * @return
	 * @throws Exception 
	 */
	public InDesignComponent newInDesignComponent(Element child) throws Exception {
		// logger.debug("newInDesignObject(): Creating new object from <" + child.getNodeName() + ">...");
		if (child.hasAttribute(PROP_SELF)) {
			Class<? extends InDesignObject> objectClass = tagToObjectClassMap.get(child.getNodeName());
			if (objectClass == null)
				objectClass = InDesignObject.class;
			return newObject(objectClass, child);
		} else {
			Class<? extends InDesignComponent> objectClass = tagToComponentClassMap.get(child.getNodeName());
			if (objectClass == null)
				objectClass = InDesignComponent.class;
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
		this.stories.add(story);
		return story;
	}

	/**
	 * @param string
	 * @return
	 */
	public InDesignComponent getObject(String id) {
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
	 * Calculates the vertical distance between spreads. This information is not in
	 * the INX file (as far as I can tell), so it has to be calculated by getting pages
	 * from two adjacent spreads and calculating the pasteboard-coordinate-space distance
	 * between them.
	 * @return
	 */
	public double getSpreadOffset() {
		logger.debug("getSpreadOffset(): Starting, this.spreads.size=" + this.spreads.size());
		if (this.spreads.size() < 2)
			return 0.0;
		Page page1 = getSpread(0).getFirstPage();
		Page page2 = getSpread(1).getFirstPage();
		double p1Top = page1.getBoundingBox().getTop();
		double p2Top = page2.getBoundingBox().getTop();
		double offset = p2Top - p1Top;
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
		MasterSpread masterSpread = this.getMasterSpread(masterSpreadName);
		newSpread.setMasterSpread(masterSpread);
		this.spreads.add(newSpread);
		// It does not appear to matter where spreads are in the inx document.
		// Or at least it seems to work if they are at the end of the INX document.
		this.addChild(newSpread);
		return newSpread;
	}

	/**
     * @param masterSpreadName
     * @return
     * @throws Exception 
     */
    public Spread addSpread(String masterSpreadName) throws Exception {
        Spread spread = new Spread();
        assignIdAndRegister(spread);
        spread.setParent(this);
        
        // Get the corresponding master spread, clone its data source,
        // and use that to load the spread.
        
        MasterSpread  masterSpread = this.getMasterSpread(masterSpreadName);
        Element spreadDataSource =this.dataSource.createElement("sprd");
        spreadDataSource.setAttribute("Self", "rc_" + spread.getId());
        spreadDataSource.setAttribute("pmas", "o_" + masterSpread.getId());
        spreadDataSource.setAttribute("PagC", "l_" + masterSpread.getLongProperty("PagC"));
        
        this.spreads.add(spread);
        spread.setDataSource(spreadDataSource);
        spread.setTransformationMatrix(this.spreads.size() - 1);
        spread.setMasterSpread(masterSpread);
        this.addChild(spread);
        
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
		return (Page)newObject(Page.class, dataSource);
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
	 */
	public boolean isFacingPages() {
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
	 * Unconditionally clone an InDesign Object.
	 * @param sourceObj
	 * @return The clone of the object.
	 * @throws Exception 
	 */
	public InDesignObject clone(InDesignObject sourceObj) throws Exception {
		logger.debug("Cloning object " + sourceObj.getClass().getSimpleName() + " [" + sourceObj.getId() + "]...");
		InDesignObject clone = sourceObj.getClass().newInstance();
		assignIdAndRegister(clone);
		// Now remember that we've cloned this source object so we can not 
		// clone it again if we don't want to:
		Map<String, InDesignObject> cloneMap = getCloneMapForDoc(sourceObj.getDocument());
		cloneMap.put(sourceObj.getId(), clone);
		clone.loadObject(sourceObj);
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
	private InDesignObject newObject(Class<? extends AbstractInDesignObject> clazz, Element dataSource) throws Exception {
		InDesignObject obj = (InDesignObject) clazz.newInstance();
		obj.setDocument(this);
		obj.loadObject(dataSource);
		this.registerObject(obj);
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
			// As far as I can tell the children of InDesignDocument are only objects. WEK
			InDesignObject obj = (InDesignObject)comp;
			Element dataSource = obj.getDataSourceElement();
			String dsName = "{No data source element}";
			if (dataSource != null)
				dsName = dataSource.getNodeName();
			report.append("[").append(obj.getId())
			  .append("] ")
			  .append(obj.getClass().getSimpleName())
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
	public InDesignObject cloneIfNew(InDesignObject sourceObj) throws Exception {
		return cloneIfNew(sourceObj, (InDesignComponent)null);
	}

	/**
	 * Clones an object only if it hasn't been already cloned. Returns
	 * the clone.
	 * @param sourceObj
	 * @return The clone of the source object.
	 * @throws Exception 
	 */
	public InDesignObject cloneIfNew(InDesignObject sourceObj, InDesignComponent targetParent) throws Exception {
		Map<String, InDesignObject> cloneMap = getCloneMapForDoc(sourceObj.getDocument());
		if (cloneMap.containsKey(sourceObj.getId()))
			return cloneMap.get(sourceObj.getId());
		InDesignObject clone = this.clone(sourceObj);
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
	public Link addLink(Link link) {
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
	 */
	private Story newStory(TextFrame frame, Link link) {
		Story story = new Story();
		assignIdAndRegister(story);
		story.addChild(link);
		this.addChild(story);
		this.stories.add(story);
		
		frame.setParentStory(story);
		
		return story;
	}
	
	/**
     * Construct a new Story that is associated with the specified
     * text frame,
     * @param frame Text frame to which the story is associated.
     * @return
     */
    private Story newStory(TextFrame frame) {
        Story story = new Story();
        assignIdAndRegister(story);
        this.addChild(story);
        this.stories.add(story);
        
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


}
