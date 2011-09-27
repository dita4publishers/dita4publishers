net.sf.dita4publishers.pdf Toolkit Plugin

Version 0.9.17

This plugin provides a custom transformation type that overrides and extends
the base PDF transform in a number of ways. It is an experiment in the design
and implementation of a new and improved PDF transform that is easier to 
customize and extend and that provides more out-of-the-box functionality.

Please see the documentation in the docs/ directory of the plugin. There is
HTML, PDF, and EPUB versions of the documentation.

To install, unpack the Zip file into your Toolkit's plugins/ directory so that 
you have these three new directories:

net.sf.dita4publishers.common.mapdriven
net.sf.dita4publishers.common.xslt
net.sf.dita4publishers.pdf

And run the integrator.xml Ant script from the command line, e.g., from your Toolkit's 
root directory on a command line:

c: \DITA-OT > startCmd
c: \DITA-OT > ant -f integrator.xml

The new transformation type is "pdf-d4p", specify that as the value of the
transtype Ant parameter when running the Toolkit.