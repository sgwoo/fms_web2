package acar.util;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import java.util.StringTokenizer ;
import java.util.Hashtable ;

public class File10Upload
{
	private final String uploadPath ;
	private final int bufSize = 1024 ;
    private File f;
	private String delim;
	private String filenm;
	private String realName;
	private String filename1;
	private String filename2;
	private String filename3;
	private String filename4;
	private String filename5;
	private String filename6;
	private String filename7;
	private String filename8;
	private String filename9;
	private String filename10;
	private String file_full_name1;
	private String file_full_name2;
	private String file_full_name3;
	private String file_full_name4;
	private String file_full_name5;
	private String file_full_name6;
	private String file_full_name7;
	private String file_full_name8;
	private String file_full_name9;
	private String file_full_name10;
	private String file_type1;
	private String file_type2;
	private String file_type3;
	private String file_type4;
	private String file_type5;
	private String file_type6;
	private String file_type7;
	private String file_type8;
	private String file_type9;
	private String file_type10;

	private BufferedInputStream in ;
	private Hashtable paramTable ;
	private Hashtable parameters = new Hashtable();  // name - value
	

	public File10Upload(String path, InputStream input) throws IOException
	{
		uploadPath = path ;
		paramTable = new Hashtable() ;
		in = new BufferedInputStream(input) ;
		try {
			parse();//필드읽기
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

	//값 가져가기
	public String getDelimeter()		{	return delim ;				}
	public String getRealName()			{	return realName;			}
	public String getFilename1()		{	return filename1;			}
	public String getFilename2()		{	return filename2;			}	
	public String getFilename3()		{	return filename3;			}
	public String getFilename4()		{	return filename4;			}	
	public String getFilename5()		{	return filename5;			}
	public String getFilename6()		{	return filename6;			}	
	public String getFilename7()		{	return filename7;			}
	public String getFilename8()		{	return filename8;			}	
	public String getFilename9()		{	return filename9;			}
	public String getFilename10()		{	return filename10;			}	
	public String getFiletype1()		{	return file_type1;			}
	public String getFiletype2()		{	return file_type2;			}
	public String getFiletype3()		{	return file_type3;			}
	public String getFiletype4()		{	return file_type4;			}
	public String getFiletype5()		{	return file_type5;			}
	public String getFiletype6()		{	return file_type6;			}
	public String getFiletype7()		{	return file_type7;			}
	public String getFiletype8()		{	return file_type8;			}
	public String getFiletype9()		{	return file_type9;			}
	public String getFiletype10()		{	return file_type10;			}
	public String getFilefullname1()	{	return file_full_name1;		}
	public String getFilefullname2()	{	return file_full_name2;		}
	public String getFilefullname3()	{	return file_full_name3;		}
	public String getFilefullname4()	{	return file_full_name4;		}
	public String getFilefullname5()	{	return file_full_name5;		}
	public String getFilefullname6()	{	return file_full_name6;		}
	public String getFilefullname7()	{	return file_full_name7;		}
	public String getFilefullname8()	{	return file_full_name8;		}
	public String getFilefullname9()	{	return file_full_name9;		}
	public String getFilefullname10()	{	return file_full_name10;	}

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

	//업로드 처리
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

	//업로드 파일 처리
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
	//파일이름 만들기
	private boolean parseFilename(String line)
	{
		if( line.indexOf("filename=\"\"") == -1 ) { // 전송된 파일이 있는 경우
			String token = null ;
			StringTokenizer st = new StringTokenizer(line, "\"\\/") ;
			while(st.hasMoreTokens()) token = st.nextToken() ;
			realName = token ;			
			//System.out.println(realName);
			String str = line.substring(line.indexOf("filename")+8,line.indexOf("filename")+10);
			if(str.substring(1,2).equals("\"")) str = str.substring(0,1);

			if(str.equals("10")){
	            filename10 = Long.toString(System.currentTimeMillis());
				file_type10 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename10+""+file_type10;
				file_full_name10 = filenm;
			}else if(str.equals("9")){
	            filename9 = Long.toString(System.currentTimeMillis());
				file_type9 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename9+""+file_type9;
				file_full_name9 = filenm;
			}else if(str.equals("8")){
	            filename8 = Long.toString(System.currentTimeMillis());
				file_type8 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename8+""+file_type8;
				file_full_name8 = filenm;
			}else if(str.equals("7")){
	            filename7 = Long.toString(System.currentTimeMillis());
				file_type7 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename7+""+file_type7;
				file_full_name7 = filenm;
			}else if(str.equals("6")){
	            filename6 = Long.toString(System.currentTimeMillis());
				file_type6 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename6+""+file_type6;
				file_full_name6 = filenm;
			}else if(str.equals("5")){
	            filename5 = Long.toString(System.currentTimeMillis());
				file_type5 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename5+""+file_type5;
				file_full_name5 = filenm;
			}else if(str.equals("4")){
	            filename4 = Long.toString(System.currentTimeMillis());
				file_type4 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename4+""+file_type4;
				file_full_name4 = filenm;
			}else if(str.equals("3")){
	            filename3 = Long.toString(System.currentTimeMillis());
				file_type3 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename3+""+file_type3;
				file_full_name3 = filenm;
			}else if(str.equals("2")){
	            filename2 = Long.toString(System.currentTimeMillis());
				file_type2 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename2+""+file_type2;
				file_full_name2 = filenm;
			}else{
	            filename1 = Long.toString(System.currentTimeMillis());
				file_type1 = realName.substring(realName.indexOf("."));//(ex:.pdf)
				filenm = filename1+""+file_type1;
				file_full_name1 = filenm;
			}
			return true ;
		}
		else { // 전송된 파일이 없는 경우
			return false ;
		}
	}

	//파일이 아닌 일반값 처리
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


}