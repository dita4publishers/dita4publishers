DITA for Publishers Journals PDF Customization plugin

This plugin is a sample PDF customization that produces
a typical 2-column "journal" layout. You can use it directly
or copy it as a base for your own journal-type customization.

If you copy it, change the following things:

1. Rename build_d4pjournals_template.xml to reflect your project,
   e.g., build_myjournals_template.xml
   
2. Change the plugin ID in the plugin.xml file to a name you own,
   e.g., "com.example.journals.pdf"
   
3. Change "d4pjournals" to your transtype name (e.g., "myjournals") everywhere it
   occurs in build_myjournals_template.xml and plugin.xml
   
4. In build_myjournals_template.xml, change "net.sourceforge.dita4publishers.journals.pdf"
   to your plugin's ID (e.g., to "com.example.journals.pdf")
   
In general, make sure that all references to the D4P-specific stuff are changed
to reflect your new plugin.

   