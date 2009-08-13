/**
 * 
 * Sets up workflow-specific context menu items.
 * 
 * 
 */

import com.reallysi.rsuite.remote.api.*;

rsuite.login()



// -----------------------------------------------------------------------


//Set up context rules to show a workflow in the context menu


def rules;

println "Generate HTML Using Open Toolkit";

rules = new RSuiteMapList();
rules.add(new RSuiteMap((String[])["type", "exclude", "rule", "nodeType", "data", "ca,canode,folder"]));
rules.add(new RSuiteMap((String[])["type", "include", "rule", "elementType", "data", "map"]));
rsuite.setProcessDefinitionContextRules("DITA 2 XHTML", "Generate HTML Using Open Toolkit", rules);


println "Export DITA Map";

rules = new RSuiteMapList();
rules.add(new RSuiteMap((String[])["type", "exclude", "rule", "nodeType", "data", "ca,canode,folder"]));
rules.add(new RSuiteMap((String[])["type", "include", "rule", "elementType", "data", "map,playmap,pubmap,bookmap"]));
rsuite.setProcessDefinitionContextRules("Export DITA Map", "Export DITA Map", rules);
	
rsuite.logout();