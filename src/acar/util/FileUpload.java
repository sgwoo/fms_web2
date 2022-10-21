package acar.util;

import java.io.*;
import java.util.*;
import javax.servlet.*;

public class FileUpload
{
	private final String uploadPath ;
	private final int bufSize = 1024 ;
    private File f;
	private String delim;
	private String filename;
    private String realName;
	private String filename2;
    private String realName2;
	private String filenm;
	private String file_full_name;
	private String file_type;
	private String file_type2;
	private BufferedInputStream in ;
	private Hashtable paramTable ;
	private Hashtable parameters = new Hashtable();  // name - value
	
	public FileUpload(String path, InputStream input) throws IOException
	{
		uploadPath = path ;
		paramTable = new Hashtable() ;
		in = new BufferedInputStream(input) ;

		try {
			parse() ;
		} catch(IOException e) {
			throw e ;
		}
	}
	public String readLine() throws IOException
	{
		byte[] buffer = new byte[bufSize] ;
		int count = 0 ;
		int rByte ;

		try {
			if( (rByte = in.read()) == -1) return null ;
			while( rByte != '\n' ) {
				buffer[count++] = (byte)rByte ;
				if(count == buffer.length - 1) return new String(buffer, 0, buffer.length) ;
				if(rByte == -1) break ;
				rByte = in.read() ;
			}
		} catch(IOException e) {
			throw e ;
		}

		if(count > 0) return new String(buffer, 0, count) ;
		else return "" ;
	}
	
	public String readDelimeter() throws IOException
	{
		byte[] buffer = new byte[64] ;
		int count = 0 ;
		int rByte ;

		try {
			if( (rByte = in.read()) == -1) return null ;
			while( rByte != '\n' ) {
				buffer[count++] = (byte)rByte ;
				if(count == buffer.length - 1) return new String(buffer, 0, buffer.length) ;
				if(rByte == -1) break ;
				rByte = in.read() ;
			}
		} catch(IOException e) {
			throw e ;
		}

		if(count > 0) return new String(buffer, 0, count) ;
		else return "" ;
	}
	public String getDelimeter()
	{
		return delim ;
	}
	public String getFilename()
	{
		return filename ;
	}
	public String getFilename2()
	{
		return filename2 ;
	}	
	public String getFileFullName()
	{
		return file_full_name ;
	}
	public String getFile_type()
	{
		return file_type ;
	}	
	public String getFile_type2()
	{
		return file_type2 ;
	}	
	public String getRealName()
	{
		return realName ;
	}
	public long getFileSize()
	{
        if ((f==null)||(f.length()==0)) return 0;
		else return f.length();
	}
	
  
	public String getParameter(String param)
	{
		return (String)(paramTable.get(param)) ;
	}
	
  public String [] getParameterValues(String name){
        Collection values = null;
        try {
            values = (Collection)parameters.get(name);
            if(values == null) return null;
        }catch (Exception e) {
            return null;
        }
        return (String [])values.toArray(new String [0]);
  }
	
		
	private void parse() throws IOException
	{
		String line = null ;

		try {
			
			
			delim = readLine().trim() ;
			line = readLine().trim() ;	
			
			if( (line.indexOf("filename")) != -1 )
				processUploading(line) ;
			else
				parseValue(line) ;
							
			while( (line = readLine()) != null ) {
				line = line.trim() ;
		
				if( line.equals(delim) ) {
					line = readLine().trim() ;
					if( (line.indexOf("filename")) != -1 )				
                    			     processUploading(line);                    		             
                                             else
					      parseValue(line) ;
				}
			}
		} catch(IOException e) {
			throw e ;
		}
	}
	private void processUploading(String line) throws IOException
	{
		if( parseFilename(line) ) {
			f = new File(uploadPath, filenm) ;
			FileOutputStream fout = null ;
			BufferedOutputStream out = null ;

			try { /* FileOutputStream 생성 */
				fout = new FileOutputStream(f) ;
				out = new BufferedOutputStream(fout) ;
			} catch(IOException e) {
				throw e ;
			}

			try {
				byte[] buffer = new byte[bufSize] ;
				int currentBufSize = bufSize ;
				int count = 0, bufferResizingCount = 0 ;
				int rByte ;
				readLine() ;
				readLine() ;

				while( (rByte = in.read()) != -1 ) {
					buffer[count++] = (byte)rByte ;

					if(count == buffer.length) {
						if(bufferResizingCount < 5) {
							byte[] tempArray = new byte[currentBufSize * 2] ;
							System.arraycopy(buffer, 0, tempArray, 0, currentBufSize) ;
							currentBufSize *= 2 ;
							buffer = tempArray ;
						}
						else {
							out.write(buffer, 0, count) ;
							out.flush() ;
							count = 0 ;
							currentBufSize = bufSize ;
							buffer = new byte[bufSize] ;
							bufferResizingCount = 0 ;
						}
					}
					if(rByte == '\n') {
						in.mark(70) ;
						String temp = readDelimeter() ;
						in.reset() ;
						if( (temp.indexOf(delim)) != -1 ) {
							out.write(buffer, 0, count - 2) ;
							out.flush() ;
							out.close() ;
							return ;
						}
						else {
							out.write(buffer, 0, count) ;
							out.flush() ;
							count = 0 ;
							bufferResizingCount = 0 ;
							currentBufSize = bufSize ;
							buffer = new byte[bufSize] ;
						} // end of if
					} // end of if
				} // end of while
			} catch(IOException e) {
				System.out.println("[processUploading]"+e);
				throw e ;
			}
		}
	}
	private boolean parseFilename(String line)
	{
		if( line.indexOf("filename=\"\"") == -1 ) { // 전송된 파일이 있는 경우
			String token = null ;
			StringTokenizer st = new StringTokenizer(line, "\"\\/") ;
			while(st.hasMoreTokens()) token = st.nextToken() ;
			realName = token ;
             
            //   		System.out.println("line=" + line );

			if(line.indexOf("filename2") != -1){ //스캔
				file_type2 = realName.substring(realName.indexOf("."));//(ex:.pdf)
	         			filename2		= Long.toString(System.currentTimeMillis());
				filenm			= filename2+""+file_type2;
			//	System.out.println("filename2=" + filenm );
//				filenm = filename2+".gif";
//				file_type = ".gif";
			}else{ //약도
				file_type = realName.substring(realName.indexOf("."));//(ex:.pdf)
	          		filename		= Long.toString(System.currentTimeMillis());
				filenm			= filename+""+file_type;
			//	System.out.println("filename=" + filenm );
			}
			file_full_name	= filenm;
			return true ;
		}
		else { // 전송된 파일이 없는 경우
			return false ;
		}
	}
	private void parseValue(String line) throws IOException
	{
		String param = null, value = null ;

		try {
			StringTokenizer st = new StringTokenizer(line, "\"") ;
			while(st.hasMoreTokens()) param = st.nextToken() ;
			readLine() ;
			String tempLine ;
			value = readLine() ;
			while(true) {
				in.mark(512) ;
				tempLine = readLine() ;
				if( (tempLine.indexOf(delim)) != -1 ) {
					in.reset() ;
					break ;
				}
				value += "\n" + tempLine ;
			}

			if(param != null) paramTable.put(param, value.trim()) ;
			if(param != null) setValue(param, value.trim());
		} catch(IOException e) {
			throw e ;
		}
	}
	
	private void setValue(String key, String value){
        Collection collection = null;
        try{
            collection = (Collection)parameters.get(key);
            if(collection == null)
                collection = new ArrayList();
        }catch(Exception _e){
        }
        collection.add(value);
        parameters.put(key, collection);
  }


} //End of class