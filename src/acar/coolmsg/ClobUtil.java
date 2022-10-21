package acar.coolmsg;

import java.io.*;


public class ClobUtil{


	public static String getClobOutput(Reader input) throws IOException,Exception{
		return getClobOutput(input, 4096);
	}

	public static String getClobOutput(Reader input, int buffer_size) throws IOException,Exception{

		if(input != null){
			try{
				StringBuffer output = new StringBuffer();
				char[] buffer = new char[buffer_size];
				int byteRead;

				while((byteRead=input.read(buffer, 0, buffer_size)) != -1){
					output.append(buffer, 0, byteRead);
				}
				input.close();
				return output.toString();
			}catch(Exception e){
				throw new Exception("getClobOutput() Fail !!");
			}
		}else{
			return "";
		}
	}


	public static void writeClob(Writer writer, String str) throws IOException,Exception{
		writeClob(writer, str, 4096);
	}

	public static void writeClob(Writer writer, String str, int buffer_size) throws IOException,Exception{
		try{
			Reader src = new CharArrayReader(str.toCharArray());
			char[] buffer = new char[buffer_size];
			int read = 0;
			while( (read = src.read(buffer, 0, buffer_size)) != -1){
				writer.write(buffer, 0, read); // write clob.
			}
			src.close();
			writer.close();
		}catch(Exception ex){// Trap SQL and IO errors
			throw new Exception("writeClob() Fail !!");	// runtime ¿¡·¯½Ã È­¸é¿¡ ÂïÈû.
		}
	}

}

