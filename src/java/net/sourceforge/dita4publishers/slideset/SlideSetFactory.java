package net.sourceforge.dita4publishers.slideset;

import java.io.InputStream;

import net.sourceforge.dita4publishers.slideset.datamodel.SimpleSlideSet;

public interface SlideSetFactory {

    SimpleSlideSet
            constructSlideSet(
                    InputStream slideSetXmlUrl) throws Exception;

}