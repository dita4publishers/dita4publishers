package net.sourceforge.dita4publishers.slideset;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.net.URL;
import java.util.List;

import net.sourceforge.dita4publishers.slideset.datamodel.ListItem;
import net.sourceforge.dita4publishers.slideset.datamodel.ListSlideItem;
import net.sourceforge.dita4publishers.slideset.datamodel.Para;
import net.sourceforge.dita4publishers.slideset.datamodel.SimpleSlideSet;
import net.sourceforge.dita4publishers.slideset.datamodel.Slide;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideItem;
import net.sourceforge.dita4publishers.slideset.datamodel.SlideTitle;
import net.sourceforge.dita4publishers.slideset.datamodel.TextRun;
import net.sourceforge.dita4publishers.slideset.datamodel.TitledSlidesItem;
import net.sourceforge.dita4publishers.slideset.visitors.SlideBody;

import org.junit.Test;

public class TestSlideSetFactory {

    @Test
    public
            void
            testConstructSlideSet() throws Exception {
        URL slideSetXmlUrl = this.getClass()
                .getClassLoader()
                .getResource(
                        "resources/slidesets/slideset-01.xml");
        assertNotNull(
                "Didn't find slideset XML file",
                slideSetXmlUrl);
        SlideSetFactory factory = SlideSetFactoryImpl.newInstance();
        assertNotNull(factory);
        SimpleSlideSet slideSet = factory.constructSlideSet(slideSetXmlUrl.openStream());
        assertNotNull(slideSet);
        
        List<TitledSlidesItem> slides = slideSet.getSlides();
        assertNotNull(slides);
        assertTrue("Expected some slides", slides.size() > 0);
        TitledSlidesItem slidesItem = slides.get(0);
        Slide slide = (Slide)slidesItem; // Item should be a Slide and not a SlideGroup
        SlideTitle title = slide.getTitle();
        assertNotNull(title);
        assertEquals(slide, title.getParent());
        List<SlideItem> children = title.getChildren();
        assertNotNull(children);
        assertTrue("Expected some children", children.size() > 0);
        SlideItem item = children.get(0);
        assertTrue("Expected a Para, got " + item.getClass().getSimpleName(), item instanceof Para);
        Para para = (Para)item;
        assertTrue("Expected some children", para.getChildren().size() > 0);
        item = para.getChildren().get(0);
        assertTrue("Expected a text run, got " + item.getClass().getSimpleName(), item instanceof TextRun);
        assertEquals(para, item.getParent());
        // First text run should have a style:
        assertEquals("i", ((SlideItem)item).getStyleName());
        assertEquals("Italic", ((SlideItem)item).getTextContent());
        
        SlideBody body = slide.getBody();
        item = body.getChildren().get(1); // Should be ul
        assertTrue("Expected a list, got " + item.getClass().getSimpleName(), item instanceof ListSlideItem);
        item = item.getChildren().get(0); // Should be list item.
        assertTrue("Expected a list item, got " + item.getClass().getSimpleName(), item instanceof ListItem);
        assertEquals(2, item.getChildren().size());
        item = item.getChildren().get(1); // Should TextRun with a style
        assertTrue("Expected a TextRun, got " + item.getClass().getSimpleName(), item instanceof TextRun);
        assertEquals("b", ((SlideItem)item).getStyleName());
       
        
        // It appears that slides may have null notes with no obvious way to 
        // create the notes container. Need to look into the POI API.
//        SlideNotes notes = slide.getNotes();
//        assertNotNull("Expected to have notes", notes);
        
        // Multi-slide file:
        
        slideSetXmlUrl = this.getClass()
                .getClassLoader()
                .getResource(
                        "resources/slidesets/slideset-02.xml");
        assertNotNull(
                "Didn't find slideset XML file",
                slideSetXmlUrl);
        
        slideSet = factory.constructSlideSet(slideSetXmlUrl.openStream());
        assertNotNull(slideSet);
        slides = slideSet.getSlides();
        assertNotNull(slides);
        assertEquals("Expected 2 slides", 2, slides.size());
        slide = (Slide)slides.get(1);
        assertEquals("Slide 2", slide.getTitle().getTextContent());
        
    }

}
