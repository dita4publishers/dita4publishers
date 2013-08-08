package net.sourceforge.dita4publishers.slideset;


import net.sourceforge.dita4publishers.slideset.ppt.TestPptHelper;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
    TestSlideSetFactory.class, 
    TestSlideSetTransformer.class,
    TestPptHelper.class})

public class AllSlidesetTests {
  //nothing
}