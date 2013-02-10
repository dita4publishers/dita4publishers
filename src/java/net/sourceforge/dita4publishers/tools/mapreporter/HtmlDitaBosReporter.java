/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.tools.mapreporter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import net.sourceforge.dita4publishers.api.bos.BosMember;
import net.sourceforge.dita4publishers.api.bos.BosReportOptions;
import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.dita.ReporterBase;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

/**
 * Generates an HTML BOS report. Generates markup that goes in
 * an HTML body element.
 */
public class HtmlDitaBosReporter extends ReporterBase implements DitaBosReporter {

	private List<BosMember> reportedMembers = new ArrayList<BosMember>();

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter#report(net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet)
	 */
	public void report(DitaBoundedObjectSet mapBos, BosReportOptions reportOptions) throws DitaApiException {
		if (outStream == null)
			throw new DitaApiException("Output stream not set. Call setPrintStream().");
		if (reportOptions.isReportTypeTree()) {
			reportBosAsTree(mapBos);
		} else {
			reportBosAsSet(mapBos);
		}		
	}
	
	/**
	 * @param mapBos
	 */
	private void reportBosAsSet(DitaBoundedObjectSet mapBos) {
		throw new NotImplementedException();	
	}

	private void reportBosAsTree(DitaBoundedObjectSet mapBos) {
		outStream.println("<div class='bos-report'>");
		outStream.println("<h1>BOS report for BOS \"" + mapBos.getRoot().getKey() + "\"</h1>");
		outStream.println("<p>Total members: " + mapBos.size() + "</p>");
		this.reportedMembers = new ArrayList<BosMember>();
		BosMember member = mapBos.getRoot();
		outStream.println("<ul>");
		reportBosMember(member);
		outStream.println("</ul>");
		outStream.println("</div>");		
	}

	private void reportBosMember(BosMember member) {
		outStream.printf("<li>%s", member.toString());
		Collection<BosMember> childs = member.getChildren();
		if (childs.size() > 0) {
			outStream.println("<br/>Children:");
			outStream.println("<ul>");
			// Only report children on first encounter:
			if (!this.reportedMembers.contains(member)) {
				this.reportedMembers.add(member);
				for (BosMember child : member.getChildren()) {
					reportBosMember(child);
				}
			} else {
				outStream.printf("<li>%s</li>", member.toString());
			}
			outStream.println("</ul>");
		}
		Collection<? extends BosMember> deps = member.getDependencies().values();
		if (deps.size() > 0) {
			outStream.println("<br/>Dependencies:");
			outStream.println("<ul>");
			for (BosMember dep : deps) {
				if (!childs.contains(dep)) {
					outStream.printf("<li>%s</li>", dep);
				}
			}
			outStream.println("</ul>");
		} else {
			outStream.println();
			outStream.println("<br/>No dependencies.");
		}
		outStream.println("</li>");
	}


}
