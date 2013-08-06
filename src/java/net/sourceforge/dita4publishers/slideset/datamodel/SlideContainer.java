package net.sourceforge.dita4publishers.slideset.datamodel;


public interface SlideContainer extends SlideSetComponent {
    
    /**
     * Add a slide group to the slide container's list
     * of slide items.
     * @param slideGroup The slide group to add
     */
    public void add(SlideGroup slideGroup);

    /**
     * Add a slide to the containers list of 
     * slide items.
     * @param slide The slide to add.
     */
    public void add(Slide slide);

}
