package acar.util;

import java.net.*;
import java.io.*;

public class WebMailUtil
{
	public static final String mailHost = "210.96.201.66";
	public static final int port = 80;
	static private WebMailUtil instance = null;

	private WebMailUtil()
	{
	}

	static synchronized public WebMailUtil getInstance() 
	{
		if (instance == null) 
		{
			instance = new WebMailUtil();
		}
		return instance;
	}
	
	public String getNewMailCount(String id)
	{
		String result = "0";
		try
		{
			Socket soMail = new Socket(mailHost, port);
			PrintWriter out = new PrintWriter(soMail.getOutputStream(), true);
			BufferedReader in = new BufferedReader(new InputStreamReader(soMail.getInputStream()));

			out.println("GET / HTTP/1.0");
			out.println("Connection: Keep-Alive");
			out.println("Progma: no-cache");
			out.println("Accept: */* ");
			out.println("Cookie: lang=kor; tnum=1; userid=" + id);
			out.println();
			
			String line;
			while ((line = in.readLine()) != null)
			{
				if(line.startsWith("alert"))
				{
					result = parseMailCount(line);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return result;
	}
	
	public String parseMailCount(String line)
	{
		int index = line.indexOf("Ελ");
		String newLine = line.substring(0, index);
		int lastSpace = newLine.lastIndexOf(" ");	
		String result = newLine.substring(lastSpace);
		return result;
	}
	
	public static void main(String args[])
	{
		WebMailUtil mt = new WebMailUtil();
	}

}