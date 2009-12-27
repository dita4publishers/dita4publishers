/**
 * Copyright (c) 2009 Really Strategies, Inc.
 */
package net.sourceforge.dita4publishers.impl.ditabos;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import net.sourceforge.dita4publishers.api.dita.DitaApiException;
import net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet;
import net.sourceforge.dita4publishers.api.ditabos.BosMember;
import net.sourceforge.dita4publishers.api.ditabos.BosReportOptions;
import net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter;

/**
 * Generates a textual BOS report
 */
public class TextDitaBosReporter implements DitaBosReporter {

	private PrintStream outStream = System.out;

	private List<BosMember> reportedMembers = new ArrayList<BosMember>();

	/**
	 * @param out
	 */
	public TextDitaBosReporter() {
	}

	/**
	 * @param out
	 */
	public TextDitaBosReporter(PrintStream out) {
		this.outStream = out;
	}

	/* (non-Javadoc)
	 * @see net.sourceforge.dita4publishers.api.ditabos.DitaBosReporter#report(net.sourceforge.dita4publishers.api.dita.DitaBoundedObjectSet)
	 */
	public void report(DitaBoundedObjectSet mapBos, BosReportOptions reportOptions) throws DitaApiException {
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
		// TODO Auto-generated method stub
		
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
