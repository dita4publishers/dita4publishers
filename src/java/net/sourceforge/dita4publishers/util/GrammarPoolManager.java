/**
 * Copyright 2009, 2010 DITA for Publishers project (dita4publishers.sourceforge.net)  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at     http://www.apache.org/licenses/LICENSE-2.0  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 
 */
package net.sourceforge.dita4publishers.util;

import org.apache.xerces.util.XMLGrammarPoolImpl;
import org.apache.xerces.xni.grammars.XMLGrammarPool;

/**
 * Manages creation and access to a master Xerces grammar pool.
 * The grammar pool is managed as a ThreadLocal variable so it can
 * be used across Ant task invocations.
 */
public class GrammarPoolManager {
	
	public static XMLGrammarPool initializeGrammarPool() {
		XMLGrammarPool pool = null;
		try {
		    pool = new XMLGrammarPoolImpl();
		}
		catch (Exception e) {
			System.out.println("Failed to create Xerces grammar pool for caching DTDs and schemas");
		}
		grammarPool.set(pool);
		return pool;
	}

	private static ThreadLocal<XMLGrammarPool> grammarPool = new ThreadLocal<XMLGrammarPool>() {
		@SuppressWarnings("unused")
		protected synchronized XMLGrammarPool initialvalue() {
			XMLGrammarPool grammarPool = initializeGrammarPool();
			set(grammarPool);
			return grammarPool;
		}

		
	};
	
	

	/**
	 * @return 
	 * 
	 */
	public static XMLGrammarPool getGrammarPool() {
		XMLGrammarPool pool = grammarPool.get();
		if (pool == null)
			pool = initializeGrammarPool();
		return pool;
	}


}
