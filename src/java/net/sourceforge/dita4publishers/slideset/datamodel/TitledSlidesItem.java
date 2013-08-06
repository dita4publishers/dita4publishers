package net.sourceforge.dita4publishers.slideset.datamodel;


public interface TitledSlidesItem
         {

    public void setTitle(SlideTitle title);

    /**
     * Gets the title object. May be null
     * @return The title object, or null if the object has no title.
     */
    public SlideTitle getTitle();
}