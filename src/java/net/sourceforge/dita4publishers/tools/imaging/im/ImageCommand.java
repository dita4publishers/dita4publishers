package net.sourceforge.dita4publishers.tools.imaging.im;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.ListIterator;

import javax.imageio.ImageIO;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 * This class implements the processing of image operations. It replaces
 * place-holders within the argument-stack and passes all arguments to the
 * generic run-method of ProcessStarter.
 */
public class ImageCommand 
  extends ProcessStarter 
  implements ErrorConsumer
{
  private static Log log = LogFactory.getLog(ImageCommand.class);
  
  /**
   * The command (plus initial arguments) to execute.
   */
  private LinkedList<String> iCommands;

  /**
   * List of stderr-output.
   */
  private ArrayList<String> iErrorText;


  /**
   * List of temporary files (input).
   */

  private LinkedList<String> iTmpFiles;


  /**
   * Temporary output file.
   */

  private String iTmpOutputFile;


  /**
   * Constructor.
   */
  public ImageCommand()
  {
    super();
    iCommands = new LinkedList<String>();
    iTmpFiles = new LinkedList<String>();
    setOutputConsumer(StandardStream.STDOUT);
    setErrorConsumer(this);
  }

   /**
   * Constructor setting the commands.
   */
  public ImageCommand(String... pCommands)
  {
    this();
    setCommand(pCommands);
  }


  /**
   * Set the command.
   */
  public void setCommand(
    String... pCommands)
  {
    for (String cmd : pCommands)
    {
      iCommands.add(cmd);
    }
  }
  
  /**
   * 
   * @param imageMagicHomeDir
   * @param command
   * @return
   */
  protected String getCommandForImageMagickBin(
    File imageMagicHomeDir,
    String command)
  {
    File binDir = new File(imageMagicHomeDir, "bin"); 
    File commandFile = new File(binDir, command);
    return commandFile.getAbsolutePath();
  }


  /**
   * Execute the command (replace given placeholders).
   * 
   * @throws IM4JavaException
   */
  public void run(
    Operation pOperation,
    Object... images)
      throws IOException, InterruptedException, IMException
  {

    // prepare list of arguments
    LinkedList<String> args = new LinkedList<String>(pOperation.getCmdArgs());
    args.addAll(0, iCommands);
    resolveImages(args, images);
    resolveDynamicOperations(pOperation, args, images);

    int rc = run(args);
    
    removeTmpFiles();
    
    if (rc > 0)
    {
      CommandException ce = new CommandException();
      ce.setErrorText(iErrorText);
      throw ce;
    }
  }


  /**
   * Resolve images passed as arguments.
   */
  private void resolveImages(
    LinkedList<String> pArgs,
    Object... pImages)
      throws IOException
  {
    ListIterator<String> argIterator = pArgs.listIterator();
    int i = 0;
    for (Object obj : pImages)
    {
      // find the next placeholder
      while (argIterator.hasNext())
      {
        if (argIterator.next().equals(Operation.IMG_PLACEHOLDER))
        {
          break;
        }
      }
      if (obj instanceof String)
      {
        argIterator.set((String) obj);
      }
      else if (obj instanceof BufferedImage)
      {
        if (i < pImages.length)
        {
          // write BufferedImage to temporary file
          // and replace the placeholder with the temporary file
          String tmpFile = convert2TmpFile((BufferedImage) obj);
          argIterator.set(tmpFile);
          iTmpFiles.add(tmpFile);
        }
        else
        {
          // special case: BufferedImage is last image, so just create name
          iTmpOutputFile = getTmpFile();
          argIterator.set(iTmpOutputFile);
        }
      }
      else
      {
        throw new IllegalArgumentException(obj.getClass().getName()
            + " is an unsupported image-type");
      }
      i++;
    }
  }


  /**
   * Resolve DynamicOperations.
   * 
   * @throws IM4JavaException
   */
  private void resolveDynamicOperations(
    Operation pOp,
    LinkedList<String> pArgs,
    Object... pImages)
      throws IMException
  {
    ListIterator<String> argIterator = pArgs.listIterator();
    ListIterator<DynamicOperation> dynOps = pOp.getDynamicOperations()
        .listIterator();

    // iterate over all DynamicOperations
    while (dynOps.hasNext())
    {
      DynamicOperation dynOp = dynOps.next();
      Operation op = dynOp.resolveOperation(pImages);

      // find the next placeholder
      while (argIterator.hasNext())
      {
        if (argIterator.next().equals(Operation.DOP_PLACEHOLDER))
        {
          break;
        }
      }

      if (op == null)
      {
        // no operation
        argIterator.remove();
      }
      else
      {
        List<String> args = dynOp.resolveOperation(pImages).getCmdArgs();
        if (args == null)
        {
          // empty operation, remove placeholder
          argIterator.remove();
        }
        else
        {
          // remove placeholder and add replacement
          argIterator.remove();
          for (String arg : args)
          {
            argIterator.add(arg);
          }
        }
      }
    } // while (dynOps.hasNext())
  }


  /**
   * This method just saves the stderr-output into an internal field.
   * 
   * @see org.im4java.process.ErrorConsumer#consumeError(java.io.InputStream)
   */
  public void consumeError(
    InputStream pInputStream)
      throws IOException
  {
    InputStreamReader esr = new InputStreamReader(pInputStream);
    BufferedReader reader = new BufferedReader(esr);
    String line;
    if (iErrorText == null)
    {
      iErrorText = new ArrayList<String>();
    }
    while ((line = reader.readLine()) != null)
    {
      iErrorText.add(line);
    }
    reader.close();
    esr.close();
  }


  /**
   * Create a temporary file.
   */
  private String getTmpFile()
      throws IOException
  {
    File tmpFile = File.createTempFile("im4java-", ".png");
    tmpFile.deleteOnExit();
    return tmpFile.getAbsolutePath();
  }


  /**
   * Write a BufferedImage to a temporary file.
   */
  private String convert2TmpFile(
    BufferedImage pBufferedImage)
      throws IOException
  {
    String tmpFile = getTmpFile();
    ImageIO.write(pBufferedImage, "PNG", new File(tmpFile));
    return tmpFile;
  }


  /**
   * Remove all temporary files.
   */
  private void removeTmpFiles()
  {
    try
    {
      for (String file : iTmpFiles)
      {
        (new File(file)).delete();
      }
    }
    catch (Exception e)
    {
      // ignore, since if we can't delete the file, we can't do anything about
      // it
    }
  }
  
}
