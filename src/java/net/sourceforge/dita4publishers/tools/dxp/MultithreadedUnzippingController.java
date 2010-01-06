package net.sourceforge.dita4publishers.tools.dxp;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 * A controller class that uses the Java Executor framework
 * to unzip files concurrently.
 *
 */
public class MultithreadedUnzippingController 
{
	
	private static Log log = LogFactory.getLog(MultithreadedUnzippingController.class);
	
	private ZipListener listener;
	private ZipFileFilter filter;
	private int maxThreads = 0;

	private DitaDxpOptions dxpOptions = new DitaDxpOptions();
	
	/**
	 * @param dxpOptions 
	 * 
	 */
	public MultithreadedUnzippingController(DitaDxpOptions dxpOptions)
	{
		this.dxpOptions = dxpOptions;
	}
	
  /**
   * 
   */
	public MultithreadedUnzippingController(
	  ZipListener listener)
	{
	  this.listener = listener;  
	}
	
  /**
   * 
   */
  public MultithreadedUnzippingController(
    ZipFileFilter filter)
  {
    this.filter = filter;  
  }

	
  /**
   * 
   */
  public MultithreadedUnzippingController(
    ZipListener listener,
    ZipFileFilter filter)
  {
    this.listener = listener;
    this.filter = filter;  
  }

	
  /**
   * 
   */
	public void setListenner(
	  ZipListener listener)
  {
    this.listener = listener;  
  }
	
  /**
   * 
   */
  public void setFilter(
    ZipFileFilter filter)
  {
    this.filter = filter;  
  }
  
  /**
   * Configure the max threads used by this controller.  If zero
   * or less, then the threading policy is essentially as many 
   * as needed, decided by Java' Executors class.
   * 
   */
  public void setMaxThreads(
    int maxThreads)
  {
    this.maxThreads = maxThreads;
  }
	
	/**
	 * Unzip the file into the output directory and return 
	 * @param maxThreads  if 0 then no limit
	 */
  public File unzip(
    File zipFile,
    File outputDir,
    boolean createSubDirectoryByName)
      throws IOException
  {
    File outputPath = null;

    if (outputDir == null)
      outputPath = zipFile.getParentFile();
    else
      outputPath = outputDir;

    if (createSubDirectoryByName)
    {
      outputPath = new File(outputPath, FilenameUtils.getBaseName(zipFile.getName()));  
    }
    
    outputPath.mkdirs();

    ZipFile zf = null;
    try
    {
      zf = new ZipFile(zipFile);
      
      // To fix issue COR-347 (intermittent failures to unzip), we iterate
      // through the ZIP entries and create all of the directories, before
      // we start the multi-threading executor to create the files.
      createDirectories(zf, outputPath);

      createFiles(zf, outputPath);
    }
    finally
    {
      if (zf != null)
      {
        try { zf.close(); }
        catch (Throwable t) {} // do nothing, we are trying to clean up
        zf = null;
      }
    }

    return outputPath;
  }
  
  
  /**
   * Iterate through the entries in the zip file and create the 
   * directory structure implied by the entries.  This method does
   * not use File.mkdirs.  Instead the patch components are broken 
   * out and directories created individually so that we can call 
   * the listener for each one.
   */
  private void createDirectories(
    ZipFile zf, 
    File outputPath)
  {
    Enumeration<ZipEntry> enu = (Enumeration<ZipEntry>) zf.entries(); 
    
    // We keep a set of paths already created so that we don't have
    // to call File.exists() (slow compared to checking set membership).
    Set<String> pathsCreated = new HashSet<String>();
    
    while(enu.hasMoreElements())
    {
      ZipEntry entry = enu.nextElement();
      
      if (filter != null && !filter.accept(entry))
        continue;
      
      if (entry.isDirectory())
      { 
        String normalizedName = FilenameUtils.separatorsToUnix(entry.getName());
        if (normalizedName.indexOf("/") == -1)
          continue;
        
        String[] pathComponents = normalizedName.split("/");
        
        StringBuilder relativePath = new StringBuilder();
        for (int i=0; i<pathComponents.length; i++)
        {
          if (i>0)
            relativePath.append("/");
          relativePath.append(pathComponents[i]);
          
          if (pathsCreated.contains(relativePath.toString()))
            continue;
          
          File dir = new File(outputPath, relativePath.toString());
          dir.mkdirs();
          pathsCreated.add(relativePath.toString());
          if (listener == null) {
            if(log.isDebugEnabled())
        	  log.debug("created folder: " + dir.getAbsolutePath());
          }
          else
            listener.directoryCreated(entry, dir, relativePath.toString());          
        }
      }
      else   // is a file entry
      { 
        String normalizedName = FilenameUtils.separatorsToUnix(entry.getName());
        if (normalizedName.indexOf("/") == -1)
          continue;
        
        String[] pathComponents = normalizedName.split("/");
        
        // We process length-1 components because we don't want to 
        // process the filename
        StringBuilder relativePath = new StringBuilder();
        for (int i=0; i<pathComponents.length-1; i++)
        {
          if (i>0)
            relativePath.append("/");
          relativePath.append(pathComponents[i]);
          
          if (pathsCreated.contains(relativePath.toString()))
            continue;
          
          File dir = new File(outputPath, relativePath.toString());
          dir.mkdirs();
          pathsCreated.add(relativePath.toString());
          if (listener == null) {
        	  if(log.isDebugEnabled())
        		  log.debug("created folder: "+dir.getAbsolutePath());  
          }
             
          else
            listener.directoryCreated(entry, dir, relativePath.toString());          
        }
      }
    }
  }
  
  
	/**
   * Iterate through the entries in the zip file and create the 
   * files for each entry.  Note that the skeleton directory 
   * structure is assumed to have already been created by 
   * createDirectories.
	 */
	private void createFiles(
	  ZipFile zf, 
	  File outputPath)
	{
	  Enumeration<ZipEntry> enu = (Enumeration<ZipEntry>) zf.entries(); 
	  
	  // Create an executor service with a thread pool
		ExecutorService es = maxThreads <= 0
      ? Executors.newCachedThreadPool()
      : Executors.newFixedThreadPool(maxThreads);
		
		// For every entry in the zip file, submit a "job" to be executed
		// by the executor service.  The executor service returns a Future
		// object which we can query later to get results.  And so we end up
		// with a list of Future objects, one for each zip entry.
		
		List<Future<Object>> futureCompletions = new ArrayList<Future<Object>>(10);
		while(enu.hasMoreElements())
		{
		  ZipEntry entry = enu.nextElement();
		  
      // The directory entries have already been processed so we can skip them here. 
      if (entry.isDirectory())
        continue;
      
      if (filter != null && !filter.accept(entry))
        continue;
		  
      if(!dxpOptions.isQuiet())
    	  log.info("Unzipping file \"" + entry.getName() + "...");

      futureCompletions.add(es.submit(new EntryUnzip(listener, zf, entry, outputPath)));
		}
		
		// Now collect the results by asking the executor service 
		
		int index =0;
		for(Future<Object> f: futureCompletions)
		{
			++index;
			try 
			{
				ZipEntry entry = (ZipEntry)f.get();
				if (log.isDebugEnabled())
			  	log.debug("completed Task["+index+"]: exploded "+entry.getName());
			} 
			catch (InterruptedException e) 
			{
				log.error("Error during unzip tasks :"+zf.getName(), e);
			}
			catch (ExecutionException e) 
			{
        log.error("Error during unzip tasks :"+zf.getName(), e);
			}
		}
		
		if (log.isDebugEnabled())
		  log.debug("All unzip tasks completed for "+zf.getName()+", shutting down ExecutorService");
		es.shutdown();
	}
	

	
  /**
   * A callable class used with the ExecutorService that
   * is just a deferred method to write out the file
   * for one zip entry	
   * 
   * See the createFiles method for the use of this class.
   *
   */
	private static class EntryUnzip implements Callable<Object>
  {
	  private ZipListener listener;
    private ZipEntry entry = null;
    private ZipFile zipFile = null;
    private File outputPath = null;

    public EntryUnzip(
      ZipListener listener,
      ZipFile zipFile, 
      ZipEntry entry, 
      File outputPath)
    {
      this.listener = listener;
      this.entry = entry;
      this.zipFile = zipFile;
      this.outputPath = outputPath;
    }

    public Object call()
      throws Exception
    {
      try
      {
        File file = new File(outputPath, entry.getName());
        
        try
        {
          file.createNewFile();
        }
        catch (IOException ioe)
        {
          log.error("unable to create file: "+file.getAbsolutePath()+": "+ioe.getMessage(), ioe);
          throw ioe;
        }
        OutputStream out = new FileOutputStream(file);
        InputStream in = zipFile.getInputStream(entry);
        
        try
        {
          copyInputStream(in, out);
          
          if (listener == null) {
        	  log.debug("created file: " + file.getAbsolutePath());
          }
          else
            listener.fileCreated(entry, file); 
        }
        finally
        {
          if (out != null)
          {
            try { out.flush(); out.close(); } 
            catch (Exception e) 
            {
              log.warn("unable to close file: "+ e.getMessage());
              // do nothing because we are trying to clean up
            } 
          }
        }
      }
      catch (IOException ioe)
      {
        log.error("unable to process entry: " + entry.getName(), ioe);
      }
      return entry;
    }

  }

	/**
	 * Copy the input stream to the output stream and then
	 * close the input stream.
	 */
	public static final void copyInputStream(
	  InputStream in, 
	  OutputStream out)
		throws IOException 
  {
		byte[] buffer = new byte[8 * 1024];
		int len;

		try
		{
		  while ((len = in.read(buffer)) >= 0)
			  out.write(buffer, 0, len);
		}
		finally 
		{
		  in.close();
		}
	}
	
	
}