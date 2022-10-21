// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   Thumbnail.java

package moveAttachedInfo;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

public class Thumbnail
{

    public Thumbnail()
    {
    }

    public static String createThumb(String orgName, String destName, int width, int height)
        throws IOException
    {
        File orgFile = new File(orgName);
        File destFile = new File(destName);
        return createThumb(orgFile, destFile, width, height);
    }

    public static String createThumb(File orgFile, File destFile, int width, int height)
        throws IOException
    {
        Image srcImg = null;
        String suffix = orgFile.getName().substring(orgFile.getName().lastIndexOf('.') + 1).toLowerCase();
        File dir = new File(destFile.getPath());
        if(!dir.isDirectory())
            dir.mkdirs();
            
        if (suffix.equals("bmp") || suffix.equals("png") || suffix.equals("gif")) {
				srcImg = ImageIO.read(orgFile);
		  } else {
				srcImg = new ImageIcon(orgFile.toString()).getImage();
		  }
            
        int srcWidth = srcImg.getWidth(null);
        int srcHeight = srcImg.getHeight(null);
        int destWidth = -1;
        int destHeight = -1;
        if(width < 0) {
            destWidth = srcWidth;
        }else  if(width > 0) {
            destWidth = width;
        }
            
        if(height < 0) {
            destHeight = srcHeight;
        } else  if(height > 0) {
            destHeight = height;
        }
            
        Image imgTarget = srcImg.getScaledInstance(destWidth, destHeight, 4);
        int pixels[] = new int[destWidth * destHeight];
        PixelGrabber pg = new PixelGrabber(imgTarget, 0, 0, destWidth, destHeight, pixels, 0, destWidth);              

        try
        {
            pg.grabPixels();
        }
        catch(InterruptedException e)
        {
            throw new IOException(e.getMessage());
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        
        BufferedImage destImg = new BufferedImage(destWidth, destHeight, 1);
        destImg.setRGB(0, 0, destWidth, destHeight, pixels, 0, destWidth);
        ImageIO.write(destImg, "jpg", destFile);
        return destFile.getName();
    }
}
