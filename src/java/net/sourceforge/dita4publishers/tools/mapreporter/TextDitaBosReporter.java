/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.tools.mapreporter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.ditabos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.BosReportOptions;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter;
import net.sourceforge.dita4publishers.api.ditabos.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.impl.dita.ReporterBase;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

/**
 * Generates a textual BOS report
 */
public class TextDitaBosReporter extends ReporterBase implements DitaBosReporter {

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
		outStream.println("---------------------------------------------------------------------");
		String indent = "";
		outStream.println("BOS report for BOS \"" + mapBos.getRoot().getKey() + "\"");
		this.reportedMembers = new ArrayList<BosMember>();
		BosMember member = mapBos.getRoot();
		reportBosMember(indent, member);
		outStream.println();
		outStream.println(" Total members: " + mapBos.size());
		outStream.println("---------------------------------------------------------------------");
		
	}

	private void reportBosMember(String indent, BosMember member) {
		outStream.println();
		outStream.println(indent + "+ " + member.toString());
		Collection<BosMember> childs = member.getChildren();
		if (childs.size() > 0) {
			outStream.println();
			outStream.println(indent + "  + Children:");
			// Only report children on first encounter:
			if (!this.reportedMembers.contains(member)) {
				this.reportedMembers.add(member);
				for (BosMember child : member.getChildren()) {
					reportBosMember(indent + "    ", child);
				}
			}
		}
		Collection<BosMember> deps = member.getDependencies().values();
		if (deps.size() > 0) {
			outStream.println();
			outStream.println(indent + "  + Dependencies:");
			for (BosMember dep : deps) {
				if (!childs.contains(dep)) {
					outStream.println(indent + "    -> " + dep);
				}
			}
		} else {
			outStream.println();
			outStream.println(indent + "  + No dependencies.");
		}
		
	}


}
