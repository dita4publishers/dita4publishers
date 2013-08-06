package net.sourceforge.dita4publishers.slideset.visitors;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import net.sourceforge.dita4publishers.slideset.datamodel.Div;
import net.sourceforge.dita4publishers.slideset.datamodel.Image;
import net.sourceforge.dita4publishers.slideset.datamodel.ListItem;
import net.sourceforge.dita4publishers.slideset.datamodel.ListSlideItem;
import net.sourceforge.dita4publishers.slideset.datamodel.OrderedList;
import net.sourceforge.dita4publishers.slideset.datamodel.Para;
import net.sourceforge.dita4publishers.slideset.datamodel.SimpleSlideSet;
import net.sourceforge.dita4publishers.slideset.datamodel.Slide;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideGroup;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideItem;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideNotes;
import net.sourceforge.dita4publishers.slideset.datamodel.StyleDefinition;
import net.sourceforge.dita4publishers.slideset.datamodel.StyleType;
import net.sourceforge.dita4publishers.slideset.datamodel.TextRun;
import net.sourceforge.dita4publishers.slideset.datamodel.TitledSlidesItem;
import net.sourceforge.dita4publishers.slideset.datamodel.UnorderedList;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.xslf.usermodel.ListAutoNumber;
import org.apache.poi.xslf.usermodel.SlideLayout;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFNotes;
import org.apache.poi.xslf.usermodel.XSLFPictureData;
import org.apache.poi.xslf.usermodel.XSLFPictureShape;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.apache.poi.xslf.usermodel.XSLFSlideLayout;
import org.apache.poi.xslf.usermodel.XSLFSlideMaster;
import org.apache.poi.xslf.usermodel.XSLFTextParagraph;
import org.apache.poi.xslf.usermodel.XSLFTextRun;
import org.apache.poi.xslf.usermodel.XSLFTextShape;
import org.xml.sax.SAXException;


/**
 * Uses the Apache POI libraries to generate PPTX from a simple slide set.
 * <p>NOTE: For now, not trying to implement a pure Visitor pattern, so this 
 * is a "visitor" in the more notional sense of separating processing from
 * composite object details.
 */
public class PPTXGeneratingSlideSetVisitor extends SlideSetVisitorBase {
    
    private static Log log = LogFactory.getLog(PPTXGeneratingSlideSetVisitor.class);

    /**
     * Gets the PowerPoint object set on the visitor. This is the 
     * object that will reflect any modifications made by the visitor
     * as it does it's visiting. 
     * @return The PPTX object the visitor is operating on.
     */
    public XMLSlideShow getPptx() {
        return ppt;
    }

    private XMLSlideShow ppt;
    private InputStream basePptxStream;

    /**
     * Creates a new visitor ready to do its work.
     * 
     * @param basePresentationStream The base PPTX slide show to which the slides will be
     *        added.
     * @throws IOException
     */
    public PPTXGeneratingSlideSetVisitor(
            InputStream basePresentationStream) throws Exception {
        this.basePptxStream = basePresentationStream;
        this.ppt = new XMLSlideShow(
                basePresentationStream);
    }
    
    @Override
    public void generatePresentation(InputStream slideSetXmlStream) throws ParserConfigurationException,
            IOException, SAXException, SlideSetException {
        super.generatePresentation(slideSetXmlStream);
        // The superclass triggers construction of the SimpleSlideSet objects
        // If we get here we must have a good slide set.
        SimpleSlideSet slideSet = this.getSlideSet();
        for (TitledSlidesItem item : slideSet.getSlides()) {
            if (item instanceof SlideGroup) {
                constructSection((SlideGroup)item);
            } else {
                constructSlide((Slide)item);
            }
        }
        
    }

    private void constructSlide(Slide slide) {
        XSLFSlideMaster defaultMaster = ppt.getSlideMasters()[0];
        
        SlideLayout layoutType = SlideLayout.TITLE_AND_CONTENT; // Default
        SlideItem title = slide.getTitle();
        SlideBody body = slide.getBody();
        SlideNotes notes = slide.getNotes();
        if (title != null && body == null) {
            layoutType = SlideLayout.TITLE_ONLY;
        } 
        if (title == null && body != null) {
            layoutType = SlideLayout.TEXT;
        }
        
        XSLFSlideLayout layout = defaultMaster.getLayout(layoutType);
        XSLFSlide xslfSlide = ppt.createSlide(layout);
        if (title != null) {
            XSLFTextShape pptxTitle = xslfSlide.getPlaceholder(0);
            // FIXME: This is a quick hack just to get some output.
            // FIXME: Want to construct objects for subcomponents, e.g. paragraphs,
            // text runs, etc.
            pptxTitle.setText(title.getTextContent());
            log.info("Creating slide \"" + title.getTextContent() + "\"...");
        }

        // Body:
        
        if (body != null) {
            XSLFTextShape pptxBody = xslfSlide.getPlaceholder(
                    (title == null ? 0 : 1));
            pptxBody.clearText(); // Get rid of any placeholders. Not sure this is really appropriate.
            renderBodyComponents(
                    xslfSlide,
                    body.getChildren(), 
                    pptxBody, 
                    0);
        }
        // Notes:
        
        if (notes != null) {
            XSLFNotes pptxNotes = xslfSlide.getNotes();
            if (pptxNotes == null) {
                // log.warn("constructSlide(): xslfSlide.getNotes() returned null");
                return;
            }
            // FIXME: Figure out how to create notes.
            renderNotes(xslfSlide, notes, pptxNotes);
        }
    }

    private
            void
            renderNotes(
                    XSLFSlide xslfSlide, 
                    SlideNotes notes,
                    XSLFNotes pptxNotes) {
        XSLFTextShape noteText = pptxNotes.getPlaceholder(0); // I think this is reliable
        for (SlideItem item : notes.getChildren()) {
            renderBodyComponent(
                    xslfSlide,
                    noteText, 
                    item, 
                    0);
        }
    }

    /**
     * Render the slide items that occur in the slide body or a body-like
     * container (e.g., Div). In this context, TextRun is ignored because
     * the only possible text runs are white space.
     * @param xslfSlide The slide we are constructing. Need this
     * to do things like add graphics. 
     * @param children
     * @param pptxBody
     * @param nestLevel
     */
    private
            void
            renderBodyComponents(
                    XSLFSlide xslfSlide, 
                    List<SlideItem> children,
                    XSLFTextShape pptxBody,
                    int nestLevel) {
        for (SlideItem  item : children) {
            if (item instanceof TextRun) continue; // Should never happen if Slide has been correctly constructed.
            renderBodyComponent(
                    xslfSlide,
                    pptxBody,
                    item, 
                    nestLevel);            
        }
    }

    /**
     * Render block-level items. For body components,
     * should not have any TextRuns, as all TextRuns
     * should be wrapped in a Para or equivalent.
     * @param xslfSlide The slide we are constructing. Need this
     * to do things like add graphics. 
     * @param pptxBody
     * @param item
     * @param nestLevel
     */
    protected
            void
            renderBodyComponent(
                    XSLFSlide xslfSlide, 
                    XSLFTextShape pptxBody,
                    SlideItem item, 
                    int nestLevel) {
        if (item instanceof Para) {
            renderPara(xslfSlide, (Para)item, pptxBody, nestLevel);
        } else if (item instanceof ListSlideItem) {
            renderList(xslfSlide, (ListSlideItem)item, pptxBody, nestLevel);
        } else if (item instanceof Image) {
            renderImage(xslfSlide, (Image)item, pptxBody, nestLevel);
        } else if (item instanceof Div) {
            // Nothing special to do for Div now, but it could have styles
            // associated or create a new text frame or something.
            renderBodyComponents(xslfSlide, item.getChildren(), pptxBody, nestLevel);
        } else if (item instanceof TextRun) {
            // Silently ignore;
        } else {
            log.warn("renderBodyComponent(): Unhandled SlideItem type " + item.getClass().getSimpleName());
        }
    }

 
    /**
     * Render an image to the slide
     * @param xslfSlide 
     * @param item The Image item to render
     * @param pptxBody The container to hold the image
     * @param nestLevel Level of nesting within the body (as for lists).
     */
    private
            void
            renderImage(
                    XSLFSlide xslfSlide, 
                    Image item,
                    XSLFTextShape pptxBody,        
                    int nestLevel) {
        
        URL imageUrl = item.getImageUrl();
        byte[] pictureData;
        try {
            pictureData = IOUtils.toByteArray(imageUrl.openStream());
        } catch (IOException e) {
            log.error("renderImage(): I/O Exception reading image URL \"" + imageUrl.toExternalForm() + "\": " + e.getMessage());
            return;
        }
        int pictureType = XSLFPictureData.PICTURE_TYPE_PNG; // Pick a default
        String ext = FilenameUtils.getExtension(imageUrl.toExternalForm()).toLowerCase();
        if ("png".equals(ext)) {
            pictureType = XSLFPictureData.PICTURE_TYPE_PNG;
        } else if ("gif".equals(ext)) {
            pictureType = XSLFPictureData.PICTURE_TYPE_GIF;
        } else if ("jpg".equals(ext) || "jpeg".equals(ext)) {
            pictureType = XSLFPictureData.PICTURE_TYPE_JPEG;
        } else if ("bmp".equals(ext)) {
            pictureType = XSLFPictureData.PICTURE_TYPE_BMP;
        } else {
            log.warn("renderImage(): Unrecognized image extension \"" + ext + "\" for URL " + imageUrl.toExternalForm());
        }

        int idx = ppt.addPicture(pictureData, pictureType);
        // This line causes slide creation to fail on any content added
        // after the image is added. If there is no slide content,
        // the PPTX file is still reported as incorrect by PowerPoint and
        // repair is required.
        XSLFPictureShape pic = xslfSlide.createPicture(idx);
    }

    /**
     * Renders lists (ul, ol, etc.)
     * @param list
     * @param pptxBody
     */
    private
            void
            renderList(
                    XSLFSlide xslfSlide, 
                    ListSlideItem list,
                    XSLFTextShape pptxBody, 
                    int nestLevel) {
        boolean isBullet = list instanceof UnorderedList;
        // Each list item results in a new paragraph with appropriate style
        for (SlideItem item : list.getChildren()) {
            if (item instanceof ListItem) {
                XSLFTextParagraph pptxP = pptxBody.addNewTextParagraph();
                if (isBullet) {
                    pptxP.setBullet(isBullet);
                }
                pptxP.setLevel(nestLevel);

                // FIXME: This is the default, will need to use styles
                // to get more control over numbering and bullet details.
                if (list instanceof OrderedList) {
                    ListAutoNumber numberScheme = ListAutoNumber.ARABIC_PERIOD;
                    switch (nestLevel) {
                    case 1:
                        numberScheme = ListAutoNumber.ALPHA_UC_PERIOD;
                        pptxP.addNewTextRun().setText(" "); // Add a space after the period
                        break;
                    case 2:
                        numberScheme = ListAutoNumber.ALPHA_LC_PERIOD;
                        pptxP.addNewTextRun().setText(" "); // Add a space after the period
                        break;
                    case 3:
                        numberScheme = ListAutoNumber.ROMAN_LC_PERIOD;
                        pptxP.addNewTextRun().setText(" "); // Add a space after the period
                        break;
                    }
                    pptxP.setBulletAutoNumber(numberScheme, 1);
                    
                }
                for (SlideItem child : item.getChildren()) {
                    if (child instanceof TextRun) {
                        renderTextRun(xslfSlide, (SlideItem)child, pptxP);
                    } else {
                        renderBodyComponent(xslfSlide, pptxBody, child, nestLevel + 1);
                    }
                }
                
            } else if (item instanceof ListSlideItem) {
                renderList(xslfSlide, (ListSlideItem)item, pptxBody, nestLevel + 1);
            } else {
                renderBodyComponent(xslfSlide, pptxBody, item, nestLevel + 1);
            }
        }
        
    }

    /**
     * Render a paragraph
     * @param para Paragraph to render.
     * @param pptxBody
     */
    private
            void
            renderPara(
                    XSLFSlide xslfSlide, 
                    Para para,
                    XSLFTextShape pptxBody,
                    int nestLevel) {
        XSLFTextParagraph pptxP = pptxBody.addNewTextParagraph();
        pptxP.setBullet(false); // Paragraphs are not bulleted.
        pptxP.setLevel(nestLevel);
        renderTextRuns(xslfSlide, para.getChildren(),
                pptxP);
    }

    protected
            void
            renderTextRuns(
                    XSLFSlide xslfSlide, 
                    List<SlideItem> textRuns,
                    XSLFTextParagraph pptxPara) {
        for (SlideItem item : textRuns) {
            if (item instanceof TextRun) {
                renderTextRun(xslfSlide, (SlideItem)item, pptxPara);
            } else {
                log.warn("renderTextRuns(): Unhandled SlideItem " + item.getClass().getSimpleName());
            }
        }
    }

    /**
     * Create a text run in the specified text run containing
     * component.
     * @param item Text run to be rendered.
     * @param pptxPara PPTX component to contain the text run.
     */
    private
            void
            renderTextRun(
                    XSLFSlide xslfSlide, 
                    SlideItem item,
                    XSLFTextParagraph pptxPara) {
        XSLFTextRun pptxTextRun = pptxPara.addNewTextRun();
        pptxTextRun.setText(item.getTextContent());
        if (item.getStyleName() != null) {
            StyleDefinition cStyle = getStyle(StyleType.CHARACTER, item.getStyleName());
            if (cStyle == null) {
                handleBuiltinInlineStyles(item, pptxTextRun);
            }
        }
    }

    private
    StyleDefinition getStyle(StyleType styleType, String styleName) {
        StyleDefinition style = getSlideSet().getStyle(styleType, styleName);
        return style;
    }

    /**
     * Handles the "magic" style names that are used if there is no style mapping.
     * @param item 
     * @param pptxTextRun The text run to handle.
     */
    private
            void
            handleBuiltinInlineStyles(
                    SlideItem item, 
                    XSLFTextRun pptxTextRun) {
        String styleName = item.getStyleName();
        if ("i".equals(styleName) || "italic".equals(styleName)) {
            pptxTextRun.setItalic(true);
        } else if ("b".equals(styleName) || "bold".equals(styleName)) {
            pptxTextRun.setBold(true);
        } else if ("u".equals(styleName) || "underline".equals(styleName)) {
            pptxTextRun.setUnderline(true);
        } else if ("linethrough".equals(styleName)) {
            pptxTextRun.setStrikethrough(true);
        }
        
    }

    /**
     * Constructs a new PowerPoint section
     * @param group
     */
    private void constructSection(SlideGroup group) {
        // FIXME: implement.
    }

}
