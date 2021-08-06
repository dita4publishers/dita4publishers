# DITA for Publishers 

Release 1.0.0RC28

Master project for the DITA for Publishers activity. This project includes the toolkit plugins and samples as git submodules.
See the wiki for details on how to set up new clones of this project.

**NOTE:** Issues for specific transformation types (EPUB, HTML5, etc.) are maintained in the project each transformation type. If you're not sure which project an issue applies to, feel free to submit the issue against the dita4publishers project.

## News

**5 Aug 2021 Release 1.0.0RC28**

Many updates. Tested against OT 3.6.1 (see release notes in user guide). Many Word2DITA issues resolved.

**24 April 2016**: EPUB3 implementation essentially complete with the addition of font embedding and obfuscation.

**7 Oct 2014**: EPUB3 implementation is under way. See the org.dita4publishers.epub project for details.

## Publishing the User Guide

The D4P User Guide is published via GitHub Pages through the separate repo dita4publishers.github.io.

To update the user guide do the following:

1. Using InDesign, update the cover graphic to reflect the latest release and copyright date (`docs/D4P Logo and User Guide Cover/D4P_UserGuide_cover Folder/D4P_UserGuide_cover.indd`)
1. Export new copies of cover-graphic.png (300PPI) and epub-cover-graphic.png (72PPI) to the `user_docs/d4p-users-guide/images` directory
1. Run the `html5-d4p-user-guide` ant target
1. Copy the generated HTML (`d4p-users-guide` from the `build/docs/html5` directory) to the dita4publishers.github.io repo on branch `main`. 
1. Commit updates to dita4publishers.github.io repo and push



