package net.sourceforge.dita4publishers.slideset.datamodel;

import java.net.MalformedURLException;
import java.net.URL;

import org.w3c.dom.Element;

/**
 * A reference to a graphic of some sort.
 *
 */
public class Image extends SlideItem {

    private String imageUrlStr;
    private URL imageUrl;

    public Image(Element elem) {
        super(elem);
    }

    /**
     * Set the URL for the image. This should be an absolute URL
     * @param imageUrl
     * @throws MalformedURLException
     */
    public
            void setImageUrl(
                    String imageUrl) throws MalformedURLException {
        this.imageUrlStr = imageUrl;
        this.imageUrl = new URL(imageUrl);
    }

    /**
     * Get the URL for the image.
     * @return The image URL, or null if it has not been set.
     */
    public
            URL getImageUrl() {
        return this.imageUrl;
    }

}
