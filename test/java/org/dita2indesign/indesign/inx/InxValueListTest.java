package org.dita2indesign.indesign.inx;

import java.util.List;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;

import org.dita2indesign.indesign.inx.InxValueListTest;
import org.dita2indesign.indesign.inx.model.InxBoolean;
import org.dita2indesign.indesign.inx.model.InxDouble;
import org.dita2indesign.indesign.inx.model.InxHelper;
import org.dita2indesign.indesign.inx.model.InxLong32;
import org.dita2indesign.indesign.inx.model.InxRecordList;
import org.dita2indesign.indesign.inx.model.InxValue;
import org.dita2indesign.indesign.inx.model.InxValueList;
import org.dita2indesign.indesign.inx.model.Path;


/**
 * Test ability to read an INX file.
 */
public class InxValueListTest extends TestCase
{

	Logger logger = Logger.getLogger(this.getClass());

	public static Test suite() {
		TestSuite suite = new TestSuite(InxValueListTest.class);
		return suite;
	}
	
	public void testDecodeRawValueToList() throws Throwable {
		String iGeo = "x_19_l_1_l_4_l_2_D_36_D_-360_l_2_D_36_D_-175.2_l_2_D_309.8181818181818_D_-175.2_l_2_D_309.8181818181818_D_-360_b_f_D_36_D_360_D_309.8181818181818_D_-175.2_D_1_D_0_D_0_D_1_D_0_D_0";
		String smallList = "x_5_l_1_l_4_l_2_D_36_D_-360";
		
		List<InxValue> list;
		
		list = InxHelper.decodeRawValueToList(smallList);
		assertNotNull(list);
		assertEquals("Expected 5 items", 5, list.size());
		
		InxValue value;
		
		value = list.get(0);
		assertTrue("Expected InxLong32", value instanceof InxLong32);
		assertEquals(new Long(1), value.getValue());
		
		value = list.get(4);
		assertTrue("Expected InxDouble", value instanceof InxDouble);
		assertEquals(new Double(-360.0), value.getValue());

		list = InxHelper.decodeRawValueToList(iGeo);
		assertNotNull(list);
		assertEquals("Expected 25 items", 25, list.size());
		
		value = list.get(14);
		assertTrue("Expected InxBoolean, got " + value.getClass().getSimpleName(), value instanceof InxBoolean);
		assertEquals(new Boolean(false), value.getValue());
		
	}
	
	public void testPathPointTypeSeven() throws Exception {
		String rawIGeoValue  = "x_3e_l_1_l_7_l_0_D_-36.85400000000004_D_5.492999999999995_D_-36.85400000000004_D_5.492999999999995_D_-36.85400000000004_D_5.492999999999995_l_0_D_-35.14599999999996_D_-38.25_D_-35.14599999999996_D_-38.25_D_-35.14599999999996_D_-38.25_l_0_D_36.85400000000004_D_-38.25_D_36.85400000000004_D_-38.25_D_36.85400000000004_D_-38.25_l_0_D_36.85400000000004_D_6.75_D_36.85400000000004_D_6.75_D_36.85400000000004_D_6.75_l_0_D_0.8540000000000418_D_38.25_D_0.8540000000000418_D_38.25_D_0.8540000000000418_D_38.25_l_0_D_-36.85400000000004_D_5.492999999999995_D_-36.85400000000004_D_5.492999999999995_D_-36.85400000000004_D_5.492999999999995_l_0_D_-36.85400000000004_D_5.492999999999995_D_-36.85400000000004_D_5.492999999999995_D_-36.85400000000004_D_5.492999999999995_b_f_D_-36.85400000000004_D_-38.25_D_36.85400000000004_D_38.25_D_1_D_0_D_0_D_1_D_485.14599999999984_D_-317.25";
		List<InxValue> values = InxHelper.decodeRawValueToList(rawIGeoValue);
		int itemCursor = 1;
		// Item 0: number of paths
		// Item 1: Start of path, gives number of points in path
		Path path = new Path();
		itemCursor = path.loadData(values, itemCursor);

	}
	
	public void testNestedLists() throws Exception {
		InxValue value;
		int size;
		InxValueList valueList;
		InxValue item;

		String rawList4 = "x_a_c_kIndexGroup~sep~Symbol_k_kIndexGroup~sep~Symbol_k__b_f_x_4_k__k__k_kIndexSection~sep~Symbol_l_100_k_IDX~sep~Basic_k_kIndexGroup~sep~Alphabet_k__b_f_x_68_k_A_k__k_kIndexSection~sep~A_l_100_k_B_k__k_kIndexSection~sep~B_l_100_k_C_k__k_kIndexSection~sep~C_l_100_k_D_k__k_kIndexSection~sep~D_l_100_k_E_k__k_kIndexSection~sep~E_l_100_k_F_k__k_kIndexSection~sep~F_l_100_k_G_k__k_kIndexSection~sep~G_l_100_k_H_k__k_kIndexSection~sep~H_l_100_k_I_k__k_kIndexSection~sep~I_l_100_k_J_k__k_kIndexSection~sep~J_l_100_k_K_k__k_kIndexSection~sep~K_l_100_k_L_k__k_kIndexSection~sep~L_l_100_k_M_k__k_kIndexSection~sep~M_l_100_k_N_k__k_kIndexSection~sep~N_l_100_k_O_k__k_kIndexSection~sep~O_l_100_k_P_k__k_kIndexSection~sep~P_l_100_k_Q_k__k_kIndexSection~sep~Q_l_100_k_R_k__k_kIndexSection~sep~R_l_100_k_S_k__k_kIndexSection~sep~S_l_100_k_T_k__k_kIndexSection~sep~T_l_100_k_U_k__k_kIndexSection~sep~U_l_100_k_V_k__k_kIndexSection~sep~V_l_100_k_W_k__k_kIndexSection~sep~W_l_100_k_X_k__k_kIndexSection~sep~X_l_100_k_Y_k__k_kIndexSection~sep~Y_l_100_k_Z_k__k_kIndexSection~sep~Z_l_100";
		String rawList5 = "x_1_z_4_7473616c_e_left_74736163_k_._74736c64_k__706f736d_U_10.080000000000002"; // Nested record list
		// Raw list 4:
		/*
		x_a_
		0  c_kIndexGroup~sep~Symbol
		1  k_kIndexGroup~sep~Symbol
		2  k_
		3  b_f
		4  x_4
		     k__
		     k__
		     k_kIndexSection~sep~Symbol
		     l_100
		5  k_IDX~sep~Basic
		6  k_kIndexGroup~sep~Alphabet
		7  k_
		8  b_f_
		9  x_68_k_A_k__k_kIndexSection~sep~A_l_100_k_B_k__k_kIndexSection~sep~B_l_100_k_C_k__k_kIndexSection~sep~C_l_100_k_D_k__k_kIndexSection~sep~D_l_100_k_E_k__k_kIndexSection~sep~E_l_100_k_F_k__k_kIndexSection~sep~F_l_100_k_G_k__k_kIndexSection~sep~G_l_100_k_H_k__k_kIndexSection~sep~H_l_100_k_I_k__k_kIndexSection~sep~I_l_100_k_J_k__k_kIndexSection~sep~J_l_100_k_K_k__k_kIndexSection~sep~K_l_100_k_L_k__k_kIndexSection~sep~L_l_100_k_M_k__k_kIndexSection~sep~M_l_100_k_N_k__k_kIndexSection~sep~N_l_100_k_O_k__k_kIndexSection~sep~O_l_100_k_P_k__k_kIndexSection~sep~P_l_100_k_Q_k__k_kIndexSection~sep~Q_l_100_k_R_k__k_kIndexSection~sep~R_l_100_k_S_k__k_kIndexSection~sep~S_l_100_k_T_k__k_kIndexSection~sep~T_l_100_k_U_k__k_kIndexSection~sep~U_l_100_k_V_k__k_kIndexSection~sep~V_l_100_k_W_k__k_kIndexSection~sep~W_l_100_k_X_k__k_kIndexSection~sep~X_l_100_k_Y_k__k_kIndexSection~sep~Y_l_100_k_Z_k__k_kIndexSection~sep~Z_l_100";
		 */

		value = InxHelper.newValue(rawList4);
		assertNotNull(value);
		assertTrue(value instanceof InxValueList);
		valueList = (InxValueList)value;
		
		size = valueList.size();
		assertEquals(10, size);
		item = valueList.get(9);
		assertTrue(item instanceof InxValueList);
		InxValueList list = (InxValueList)item;
		assertEquals(104,list.size());
		item = list.get(7);
		assertEquals(0x100, ((InxLong32)item).getValue().longValue());

		// Record list test
		value = InxHelper.newValue(rawList5);
		assertNotNull(value);
		assertTrue(value instanceof InxValueList);
		valueList = (InxValueList)value;
		
		size = valueList.size();
		assertEquals(1, size);
		InxRecordList recList = (InxRecordList)valueList.get(0);
        assertEquals(4, recList.size());
	}
	
	public void testNewValue() throws Exception {
		String rawList1 = "rx_2_D_72_D_72";
		String rawList2 = "x_2_D_72_D_72";
		String rawList3 = "x_f_l_0_D_0_D_0_D_155_D_182_D_1_D_0_D_0_D_1_D_-77.5_D_-91_D_0_D_0_D_155_D_182";
		
		InxValue value;
		int size;
		InxValueList valueList;
		InxValue item;
		
		value = InxHelper.newValue(rawList1);
		assertNotNull(value);
		assertTrue(value instanceof InxValueList);
		valueList = (InxValueList)value;
		
		size = valueList.size();
		assertEquals(2, size);

		item = valueList.get(0);
		assertNotNull(item);
		assertTrue(item instanceof InxDouble);

		item = valueList.get(1);
		assertNotNull(item);
		assertTrue(item instanceof InxDouble);
		
		value = InxHelper.newValue(rawList2);
		assertNotNull(value);
		assertTrue(value instanceof InxValueList);
		
		// Raw list 3:
		value = InxHelper.newValue(rawList3);
		assertNotNull(value);
		assertTrue(value instanceof InxValueList);
		valueList = (InxValueList)value;
		
		size = valueList.size();
		assertEquals(15, size);
		
		item = valueList.get(14);
		double d = ((InxDouble)item).getValue();
		assertEquals(182.0,d);

	}
  
}
