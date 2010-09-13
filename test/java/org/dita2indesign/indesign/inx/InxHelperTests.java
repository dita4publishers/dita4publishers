package org.dita2indesign.indesign.inx;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.apache.log4j.Logger;

import org.dita2indesign.indesign.inx.InxHelperTests;
import org.dita2indesign.indesign.inx.model.InxBoolean;
import org.dita2indesign.indesign.inx.model.InxDate;
import org.dita2indesign.indesign.inx.model.InxDouble;
import org.dita2indesign.indesign.inx.model.InxFile;
import org.dita2indesign.indesign.inx.model.InxHelper;
import org.dita2indesign.indesign.inx.model.InxLong32;
import org.dita2indesign.indesign.inx.model.InxLong64;
import org.dita2indesign.indesign.inx.model.InxString;
import org.dita2indesign.indesign.inx.model.InxValue;
import org.dita2indesign.indesign.inx.model.InxValueList;


/**
 * Test ability to read an INX file.
 */
public class InxHelperTests extends TestCase
{

	Logger logger = Logger.getLogger(this.getClass());

	public static Test suite() {
		TestSuite suite = new TestSuite(InxHelperTests.class);
		return suite;
	}
	
	public void testDecodeRawValues() throws Throwable {
		String singleString = "c_string";
		String singleStringWithSpaces = "c_part1~sep~part2";
		String singleLong = "l_1";
		
		String cand;
		
		cand = InxHelper.decodeRawValueToSingleString(singleString);
		assertEquals("string", cand);
		
		cand = InxHelper.decodeRawValueToSingleString(singleStringWithSpaces);
		assertEquals("part1 part2", cand);
		
		long candL;
		candL = InxHelper.decodeRawValueToSingleLong(singleLong);
		assertEquals(1L, candL);
		
	}
	
	public void testDecodeRawValueToStringMap() throws Throwable {
		String mapData = "x_2_x_2_c_Key1_c_Value1_x_2_c_Key2_c_Value2";
		Map<String, String> map;
		
		map = InxHelper.decodeRawValueToStringMap(mapData);
		assertNotNull("Got a null result map", map);
		assertEquals(("Expected 2 entries, got " + map.size()), 2, map.size());
		
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
	
	public void testInxString() {
		String rawValue = "1234~sep~6789";
		InxString inxString = new InxString(rawValue);
		assertEquals("1234_6789", inxString.getValue());
		
		inxString = new InxString("");
		assertEquals("", inxString.getValue());
	}
	
	public void testInxLong32() {
		String rawValue = "7fffff";
		InxLong32 inxLong;
		long value;
		String encodedValue;
		
		inxLong = new InxLong32(rawValue);
		value = inxLong.getValue();
		assertEquals(0x7fffff, value);
		encodedValue = inxLong.toEncodedString();
		assertEquals("l_" + rawValue, encodedValue);
	}
	
	public void testInxFile() {
		String rawValue = "c:\\windows\\filename.foo";
		InxFile inxFile;
		
		inxFile = new InxFile(rawValue);
		String value = inxFile.getValue();
		assertEquals(rawValue, value);
		assertEquals("f_" + rawValue, inxFile.toEncodedString());
	}
	
	public void testInxLong64() {
		String rawValue = "7fffff00000000";
		InxLong64 inxLong = new InxLong64(rawValue);
		long value = ((Long)inxLong.getValue()).longValue();
		long cand = Long.parseLong("7fffff00000000", 16);
		assertEquals(cand, value);
		String encodedValue;
		encodedValue = inxLong.toEncodedString();
		// FIXME: need to work out how to re-encode big
		// Longs. Not sure these actually occur in InDesign docs.
		assertEquals("l_" + rawValue, encodedValue);
		
		
		cand = Long.parseLong("AAAAA", 16);
		inxLong = new InxLong64("0~AAAAA");
		value = ((Long)inxLong.getValue()).longValue();
		assertEquals(cand, value);
		
		cand = Long.parseLong("BB000AAAAA", 16);
		inxLong = new InxLong64("BB~AAAAA");
		value = ((Long)inxLong.getValue()).longValue();
		assertEquals(cand, value);
		
	}
	
	public void testInxDate() throws Exception {
		String rawDate1 = "T_2008-09-04T12:02:13";
		String rawDate2 = "2008-09-04T12:02:13";
		Calendar cal = Calendar.getInstance();
		cal.set(2008, 8, 4, 12, 2, 13);
		Date targetDate = cal.getTime();
//		System.err.println("targetDate=" + targetDate);
		InxDate inxDate = new InxDate(rawDate1);
		Date value = (Date) inxDate.getValue();
		assertNotNull(value);
//		System.err.println("value=" + value);
		String encodedValue = InxHelper.encodeTime(value);
		assertEquals(rawDate1, encodedValue);
		
		// Can handle both really raw value ("T_*") or
		// value part (no leading "T_"):
		inxDate = new InxDate(rawDate2);
		value = (Date) inxDate.getValue();
		assertNotNull(value);
//		System.err.println("value=" + value);
		encodedValue = InxHelper.encodeTime(value);
		assertEquals("T_" + rawDate2, encodedValue);
		
		
	}
	
	public void testSimpleDateFormat() throws Exception {
		// Sanity check test to validate how SimpleDateFormat works
		Calendar cal = Calendar.getInstance();
		cal.set(2008, 8, 4, 12, 2, 13);
		Date targetDate = cal.getTime();
//		System.err.println("targetDate=" + targetDate);

		String dateStr = "2008-09-04T12:02:13";
//        				 "2008-09-04T12:02:13"
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		Date date = df.parse(dateStr);
//		System.err.println("testSimpleDateFormat(): date=" + date);
		assertEquals(targetDate.getYear(), date.getYear());
		assertEquals(targetDate.getMonth(), date.getMonth());
		assertEquals(targetDate.getDay(), date.getDay());
		assertEquals(targetDate.getHours(), date.getHours());
		assertEquals(targetDate.getMinutes(), date.getMinutes());
		assertEquals(targetDate.getSeconds(), date.getSeconds());
	}
	
	public void testNewValue() throws Exception {
		String rawList1 = "rx_2_D_72_D_72";
		String rawList2 = "x_2_D_72_D_72";
		String rawList3 = "x_f_l_0_D_0_D_0_D_155_D_182_D_1_D_0_D_0_D_1_D_-77.5_D_-91_D_0_D_0_D_155_D_182";
		String rawList4 = "x_a_c_kIndexGroup~sep~Symbol_k_kIndexGroup~sep~Symbol_k__b_f_x_4_k__k__k_kIndexSection~sep~Symbol_l_100_k_IDX~sep~Basic_k_kIndexGroup~sep~Alphabet_k__b_f_x_68_k_A_k__k_kIndexSection~sep~A_l_100_k_B_k__k_kIndexSection~sep~B_l_100_k_C_k__k_kIndexSection~sep~C_l_100_k_D_k__k_kIndexSection~sep~D_l_100_k_E_k__k_kIndexSection~sep~E_l_100_k_F_k__k_kIndexSection~sep~F_l_100_k_G_k__k_kIndexSection~sep~G_l_100_k_H_k__k_kIndexSection~sep~H_l_100_k_I_k__k_kIndexSection~sep~I_l_100_k_J_k__k_kIndexSection~sep~J_l_100_k_K_k__k_kIndexSection~sep~K_l_100_k_L_k__k_kIndexSection~sep~L_l_100_k_M_k__k_kIndexSection~sep~M_l_100_k_N_k__k_kIndexSection~sep~N_l_100_k_O_k__k_kIndexSection~sep~O_l_100_k_P_k__k_kIndexSection~sep~P_l_100_k_Q_k__k_kIndexSection~sep~Q_l_100_k_R_k__k_kIndexSection~sep~R_l_100_k_S_k__k_kIndexSection~sep~S_l_100_k_T_k__k_kIndexSection~sep~T_l_100_k_U_k__k_kIndexSection~sep~U_l_100_k_V_k__k_kIndexSection~sep~V_l_100_k_W_k__k_kIndexSection~sep~W_l_100_k_X_k__k_kIndexSection~sep~X_l_100_k_Y_k__k_kIndexSection~sep~Y_l_100_k_Z_k__k_kIndexSection~sep~Z_l_100";
		
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
		
	}
  
}
