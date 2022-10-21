/*
 * @ Util.java
 *
 * TYPE : 공통 클래스 (com)
 *
 * 설명 : Util Class
 *
 * 사용법
 *    - static method는 Util.mehtod()로 호출한다.
 *    - 기타 메소드는 객체생성후 접근한다.
 */


package acar.util;

import java.util.*;
import java.io.*;
import java.sql.*;
import java.text.*;
import java.lang.*;
import acar.database.DBConnectionManager;

public class Util{

    public Util() {
    
    }
	
    /**
     * 8859_1 -> KSC5601 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static String toEN(String ko) 
    {
    	String new_str = null;		
    	try {		
    		if(ko != null ){
    			new_str=new String(ko.getBytes("KSC5601"),"8859_1");
    		}		
    	} catch(UnsupportedEncodingException e) { }			
    	return new_str;
    }

    /**
     * KSC5601 -> 8859_1 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static String toKSC(String en) 
    {
    	String new_str = null;		
    	try {
    		if(en != null){
    			new_str = new String (en.getBytes("8859_1"), "KSC5601");
    		}
    	} catch (UnsupportedEncodingException e) {}
    	return new_str;
    }

    /**
     * KSC5601 -> 8859_1 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
	 * return  : null일 경우, ""을 return
     */

    public static String toKSC2(String en) 
    {
    	String new_str = null;		
    	try {
    		if(en != null){
    			new_str = new String (en.getBytes("8859_1"), "KSC5601");
    		} else {
				new_str = "";
			}
    	} catch (UnsupportedEncodingException e) {}
    	return new_str;

	}
	
	public static int getLength(String str)
	{
		byte[] strLen = str.getBytes();
		return strLen.length;
	}
	
/*
    public static String[] toKSC2(String[] en) 
    {
    	String new_str[] = null;
		int str_size = 0;
    	try 
    	{
    		str_size = en.length;
    		for(int i = 0 ; i < str_size ; i++)
    		{
	    		if(en[i] != null)
	    		{
    				new_str[i] = new String (en[i].getBytes("8859_1"), "KSC5601");
    			} 
    			else 
    			{
					new_str[i] = "";
				}
			}
   		} 
   		catch (UnsupportedEncodingException e) {}
    	return new_str[];
	}
*/	
    /**
     * space -> &nbsp;  <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static String spaceToNBSP(String source) 
    {
    	StringBuffer sb = new StringBuffer(source);
    	StringBuffer result = new StringBuffer();
    	String ch = null;
    	for(int i=0; i<source.length(); i++) {
    	
    		if (Character.isSpaceChar(sb.charAt(i))) 
    			ch = "&nbsp;";
    		else 
    			ch = String.valueOf(sb.charAt(i));
    		
    		result.append(ch);
    	}
    	return result.toString();
    }
	
    /**
     * 현재날짜를 지정된 포맷으로 만들어 리턴 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static String dateFormat(String format)
    {
    	String date=null;
    	try
    	{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat(format);
    		date = sdf.format(d);
    	} catch(Exception kkkk) { }
    	return date;
    }
	
    /**
     * 현재날짜를 YYYY-MM-DD 형식으로 만들어 리턴 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static String getDate()
    {
    	String ch = null;
    	try
    	{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'MM'-'dd");
    		ch = sdf.format(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }

    /**
     * 입력받은 Date 오브젝트를 YYYY-MM-DD 형식의 String 으로 만들어 리턴 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static String dateToString(java.util.Date d)
    {
    	String ch = null;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'MM'-'dd");
            ch = sdf.format(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }
    
    /**
     * 입력받은 Date 오브젝트를 특정한 포멧 형식의 String 으로 만들어 리턴 <br>
     *
     * 예) dateToString(new Date(), "MMM d,  yyyy")<br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static String dateToString(java.util.Date d, String format)
    {
    	String ch = null;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            ch = sdf.format(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }    

    /**
     * 입력받은 String오브젝트를 특정한 포멧 형식의 Date 형으로 만들어 리턴 <br>
     *
     * 예) stringToDate("2001-06-01", "yyyy-'-'MM'-'dd")<br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static java.util.Date stringToDate(String d, String format)
    {
    	java.util.Date ch = null;
    	try
    	{
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            ch = sdf.parse(d);
    	} catch(Exception dfdf) { }
    	return ch;
    }         
     
    /**
     * 현재날짜를 YYYY-MM-DD HH:MM:SS 형식으로 만들어 리턴 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static String getTime(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'MM'-'dd'-'HH'-'mm'-'ss");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    }
    /**
     * 현재날짜를 YYYY-MM-DD HH:MM:SS 형식으로 만들어 리턴 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static String getLoginTime(){
    	String ch = null;
    	try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
    		ch = sdf.format(d);
    	}catch(Exception dfdf){}
    	return ch;
    } 
	
    /**
     * 현재 날짜를 타입에 따라 년, 월,일 만을 리턴 <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */  
    public static String getDate(int type)
    {
    	String ch = getDate();
    	String format = null;		
    	switch(type){
    		case 1:
    			format = ch.substring(0,4);
    			break;
    		case 2:
    			format = ch.substring(5,7);
    			break;
    		case 4:
    			format = ch.substring(0,4)+ch.substring(5,7)+ch.substring(8,10);
    			break;
    		default:
    			format = ch.substring(8,10);
    			break;
    	}
    	return format;
    }
	
    /**
     * Encode URL -> Decode URL : jdk 1.x 버전에서는 java.net.URLDecoder 클래스를 지원하지 않기 때문에<br>
     *  jdk1.x 에서 URL 디코딩시 사용. <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static String decodeURL(String s){
    	 
    	ByteArrayOutputStream out = new ByteArrayOutputStream(s.length());
    	for (int i = 0; i < s.length(); i++){  
    		int c = (int) s.charAt(i);
    		if ( c == '+') 
    			out.write(' ');
    		else if (c == '%'){  
    				int c1 = Character.digit(s.charAt(++i), 16);
    				int c2 = Character.digit(s.charAt(++i), 16);
    				out.write((char) (c1 * 16 + c2));
    		}else 
    			out.write(c);
    	}
    	return out.toString();
    }
	
    /**
     * 스트링을 int로 변환. NumberFormatException, NullPointerException 을 검사하기 위해, Exception 발생시 0 리턴
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static int parseInt(String str){
    	int parseInt = 0;
    	try{
    		parseInt = Integer.parseInt(str);
    	}catch(Exception nf){}
    	return parseInt;
    }
	
    /**
     * 스트링을 int로 변환. NumberFormatException, NullPointerException 을 검사하기 위해, Exception 발생시 0 리턴
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static float parseFloat(String str){
    	float parseFloat = 0.0f;
    	try{
    		parseFloat = Float.parseFloat(str);
    	}catch(Exception nf){}
    	return parseFloat;
    }
    
    /**
     * 스트링을 int로 변환. NumberFormatException, NullPointerException 을 검사하기 위해, Exception 발생시 0 리턴
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static long parseLong(String str){
    	long parseLong = 0L;
    	try{
    		parseLong = Long.parseLong(str);
    	}catch(Exception nf){}
    	return parseLong;
    }	
    /**
     * 스트링을 int로 변환. NumberFormatException, NullPointerException을 검사하기 위해, Exception 발생시 default value 리턴<br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static int parseInt(String str, int def){
    	int parseInt = 0;
    	try{
    		parseInt = Integer.parseInt(str);
    	}catch(Exception nf){parseInt = def;}
    	return parseInt;
    }

    /**
     * 파라미터의 값이 "" 일때 null 을 리턴하게끔 하는 메소드<br>
     * URL에서 파라미터를 받을때 name 값이 존재하면 "" 이 넘어올 수 있기 때문에 null 값을 검사할때 사용.<br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     *     
     */
    public static String checkNull(String key){
    	String value = key;
    	if(key == null || key.equals(""))
    		value = null;
    	return value;			
    }
	
    /**
     * 날짜형을 년, 월, 일로 나누어 리턴하는 메소드<br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */
    public static String parseDate(String date, int type){
    	String parse = "";
    	if(date != null && date.length() == 8){
    		switch(type){
    			case 1: //년
    				parse = date.substring(0, 4);
    				break; 
    			case 2: //월
    				parse = date.substring(4, 6);
    				break;
    			default: //일
    				parse = date.substring(6, 8);
    				break;
    		}
    	}
    	return parse;
    }
    
    /**
     * &nbsp -> ""
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */     
    public static String nbspToSpace(String nbsp){
    	String value = "";
    	if(nbsp != null && !nbsp.trim().equals("&nbsp;")){
    		value = nbsp;
    	}
    	return value;
    }
    
    /**
     * null -> "" 로 변환하는 메소드<br>
     * : 데이터 수정시 데이터 베이스로 부터 읽은 값이 null이면 수정 폼에 null이 들어가므로 이값을 변환하는 메소드 <br>
     * : 데이터 수정시 null 값을 수정 폼에 setting 할때 사용하면 유용한 메소드. <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */     
    public static String nullToString(String str){
    	String value = str;
    	if(str == null){
    		value = "";
    	}
    	return value;
    }
    
    /**
     * null or "" --> "&nbsp;" <br>
     * : HTML에서 테이블의 셀에 "" 이 들어가면 테이블이 깨지므로(netscape) 공백문자(&nbsp;)로 대치하는 메소드<br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */   
    public static String nullToNbsp(String str){
    	String value = str;
    	if(str == null || str.equals("")){
    		value = "&nbsp;";
    	}
    	return value;
    }
    
    /**
     * Object 형을 String 으로 변환<br>
     * : Object 가 null 일때 NullpointerException 을 검사하기 위해서 사용.<br>
     * : ResultSet 으로부터 getObject()로 값을 가져왔을경우 String으로 변환할때 사용하면 유용한 메소드.<br>
     *
     * @author : 김정태
     * @E-mail : sim11@miraenet.com
     */
    public static String toString(Object obj){
        String str = "";
    	if(obj != null)
    	    str = obj.toString();
    	return str;
    }
    
    /**
     * 전체 데이터수로 마지막페이지를 계산해오기 위한 Method.<br>
     * : 게시판 목록 같은 경우 몇 페이지 까지 있는지 계산할때 사용하면 유용한 메소드<br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */    
    public static int getPageCount(int token, int allPage){
    	int lastPage =(int)(((allPage-1)/token)+1);	
    	return lastPage;
    }
	
    /**
     * 데이터의 번호를 주기위해 번호를 계산해오는 Method <br>
     * : 게시판 목록 같은 경우 페이지별 데이터의 번호를 계산해 주는 메소드. <br>
     *
     * @author : 김정태
     * @e-mail : jtkim@nicstech.com
     */    
    public static int getDataNum(int token, int page, int allPage){
    	if(allPage<=token){
    		return allPage;
    	}
    	int num = allPage - (token*page) + token;	
    	return num;
    }
        
    /**
     * 숫자 만큼 공백문자를 붙혀서 리턴하는 메소드<br>
     * 답변에서 Depth 처리 하는데 사용하면 유용할꺼 같음.<br>
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com
     */
    public static String levelCount(int level){
        StringBuffer sb = new StringBuffer("");
        for(int i=0; i<level; i++){
            sb.append("&nbsp;&nbsp;");
        }
        return sb.toString();
    }
        
    /**
     * 문자열의 값이 null 이거나 ""이면 default 값을 리턴하는 메소드<br>
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com
     */
    public static String getString(String line, String def){
        if(line == null || line.equals(""))
            return def;
        return line;  
    } 
         
    /**
     * 현재일이  특정 기간에 속해있는지 검사하는 메소드<br>
     * : argument : 시작일(yyyy-mm-dd), 종료일(yyyy-mm-dd)
     *     
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
     */
    public static boolean betweenDate(String first, String second){
        boolean flag = false;
        java.util.Date start = null;
        java.util.Date end = null;
        java.util.Date current = null;
        
        DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.KOREA);
        
        try{			
            start = df.parse(first);
            end = df.parse(second);
            current = df.parse(getDate());
        }catch(Exception pe){
            return false;				
        }
        
        if((start.before(current) && end.after(current)) || start.equals(current) || end.equals(current)) 
            flag= true;
        
        return flag;
    }
        
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    *     
    * @author : 김정태 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(double unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        String format = df.format(unFormat);
        return format;
    }
    public static String parseDecimal2(double unFormat){
        DecimalFormat df = new DecimalFormat("###,###");
        String format = df.format(unFormat);
        return format;
    }
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    *     
    * @author : 김정태 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(Object unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        double unFormat1 = Util.parseInt(toString(unFormat));
        String format = df.format(unFormat1);
        return format;
    }
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    *     
    * @author : 김정태 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(String unFormat){
		if(!unFormat.equals("") || unFormat == "null"){
	        DecimalFormat df = new DecimalFormat("###,###.##");
 			double unFormat1 = Util.parseInt(unFormat);       
			String format = df.format(unFormat1);
	        return format;
		}else{
			return "0";
		}
    }
    
       public static String parseDecimal2(String unFormat){
		if(!unFormat.equals("") || unFormat == "null"){
	        DecimalFormat df = new DecimalFormat("###,###.##");
 			double unFormat1 = Util.parseLong(unFormat);       
			String format = df.format(unFormat1);
	        return format;
		}else{
			return "0";
		}
    }
    
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    *     
    * @author : 김정태 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(int unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        String format = df.format(unFormat);
        return format;
    }
    /**
    * 가격등의 값을 3자리 마다 comma(,)로 분리하여 리턴<br>
    *     
    * @author : 김정태 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(double unFormat, String foramt){
        DecimalFormat df = new DecimalFormat(foramt);
        String format = df.format(unFormat);
        return format;
    }
    /**
     * 추가 - 이민영(2002. 3. 21)
     */        
    public static String parseDecimalLong(String unFormat){
		if(!unFormat.equals("")){
			DecimalFormat df = new DecimalFormat("###,##0.##");
 			double unFormat1 = Double.parseDouble(unFormat);       
			String format = df.format(unFormat1);
	        return format;
		}else{
			return "0";
		}
	}    
    /**
     * 추가 - Yongsoon Kwon(2005. 10. 12)
     */        
    public static String parseDecimalLong(long unFormat){
		if(unFormat == 0){
			return Long.toString(unFormat);
		}else{
	        DecimalFormat df = new DecimalFormat("###,##0.##"); 			       
			String format = df.format(unFormat);
	        return format;
		}
    } 
    public static String parseDecimalLong2(long unFormat){
		if(unFormat == 0){
			return Long.toString(unFormat);
		}else{
	        DecimalFormat df = new DecimalFormat("##0.##"); 			       
			String format = df.format(unFormat);
	        return format;
		}
    }
	/**
    * 통화형식(comma)의 문자열을 일반 숫자형식으로 리턴
    */        
    public static int parseDigit(String format){
        int str_size = format.length();
        StringBuffer new_str = new StringBuffer();
        char[] old_str = format.toCharArray();
        for(int i = 0 ; i < str_size ; i++)
        {
        	if(old_str[i] != ',')
				new_str.append(old_str[i]);
        }
        return parseInt(new_str.toString());
    }
    
       public static Long parseDigitLong(String format){
        int str_size = format.length();
        StringBuffer new_str = new StringBuffer();
        char[] old_str = format.toCharArray();
        for(int i = 0 ; i < str_size ; i++)
        {
        	if(old_str[i] != ',')
				new_str.append(old_str[i]);
        }
        return parseLong(new_str.toString());
    }
    
    
    /**
    * Object 의 복제하여 주는 메소드<br>
    * 일반적으로 java.lang.Object.clone() 메소드를 사용하여 Object를 복제하면 Object내에 있는 Primitive type을 제외한 Object <br>
    * field들은 복제가 되는 것이 아니라 같은 Object의 reference를 갖게 된다.<br>
    * 그러나 이 Method를 사용하면 각 field의 동일한 Object를 새로 복제(clone)하여 준다.<br>
    * java.lang.reflect API 를 사용하였음. <br>
    *     
    * @author : 김정태 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static Object clone(Object object){
        Class c = object.getClass();
        Object newObject = null;
        try {
            newObject = c.newInstance();
        }catch(Exception e ){
            return null;
        }
        
        java.lang.reflect.Field[] field = c.getFields();
        for (int i=0 ; i<field.length; i++) {
            try {
                Object f = field[i].get(object);
                field[i].set(newObject, f);
            }catch(Exception e){}
        }
        return newObject;
    }
        
    /**
    * 디버깅시 Servlet 에서는 PrintWriter 를 넣어서 쉽게 디버깅을 할 수 있었지만 <br>
    * JSP 에서 처럼 PrintWriter가 없을때 디버깅을 쉽게 하기 위하여 메세지를 문자열로 만들어 리턴하게 하였음.<br>
    *
    * @author : 김정태 
    * @e-mail : jtkim@nicstech.com 
    */                
    public static String getStackTrace(Throwable e) {
        java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
        java.io.PrintWriter writer = new java.io.PrintWriter(bos);
        e.printStackTrace(writer);
        writer.flush();
        return bos.toString();
    }        

    /**
     * 특정 문자열을 다른 문자열로 대체하는 메소드<br>
     * : 문자열 검색시 검색어에 색깔을 넣거나 ... 테그를 HTML 문자로 바꾸는데 사용하면 유용할거 같음.<br>
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
     * @ 참고 문헌 : JAVA Servlet Programming(Oreilly) 
     */
    public static String replace(String line, String oldString, String newString){
        int index=0;
        while((index = line.indexOf(oldString, index)) >= 0){
        	line = line.substring(0, index) + newString + line.substring(index + oldString.length());
        	index += newString.length();
        }
        return line;
    }	
    
    /**
     * 입력받은 메일주소가 메일주소 포멧에 맞는지 검사하는 메소드 <br>
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
     * @date : 2001-04-17
     *
     */
    /*public static boolean isValidAddress(String usermail){
        if(usermail.indexOf("@") > 0){
            try{
                javax.mail.internet.InternetAddress.parse(usermail);
            }catch(Exception e){
                return false;
            }
        }else{
            return false;
        }
        return true;
    }*/
    
    /**
     * 문자열을 substring할때 문자열 길이를 넘어설 경우 "" 를리턴하는 메소드
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
     * @date : 2001-04-21
     *
     */
    public static String substring(String str, int start, int end){
        String val = null;
        try{
            val = str.substring(start, end);
        }catch(Exception e){
            return "";  
        }
        return val;
    }
        
    /**
    * ','로 분리되어 있는 문자열을 분리하여 Return
    * List에서 일괄 삭제시 ID값을 일괄로 받아와서 Parsing...
    * written by Blue.
    */
    
    public static String[] getItemArray(String src) {
    
        String[] retVal = null;
        if (src.length() == 0) return null;
        
        int nitem = 1;
        
        for (int i = 0; i < src.length(); i++)
        		if (src.charAt(i) == ',') nitem++;
        
        retVal = new String[nitem];
        
        int ep = 0;
        int sp = 0;
        
        for (int i = 0; i < nitem; i++) {
        	ep = src.indexOf(",", sp);
        	if (ep == -1) ep = src.length();
        	retVal[i] = new String(src.substring(sp, ep));
        	sp = ep + 1;
        }
        
        return retVal; 
    }
	
	/**
     * 문자열을 잘라서 리턴
     *
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
     * 
     */
    public static String subData(String data, int num) {

		String subData = "";
		if (data.length()>num)
		{
			subData =  data.substring(0,num) + "..";
		}else{
			subData = data;
		}

		return subData;
	}
    
    /**
     * 문자열을 잘라서 리턴하되 우측문자열을 보여준다
     * bhsim
     * 2018.02.06
     */
    public static String subRightData(String data, int num) {
    	
    	String subData = "..";
    	int dataLength = data.length();
    	if(dataLength > num){
    		subData += data.substring(num,dataLength);
    	}else {
    		subData = data;
    	}
    	
    	return subData;
    }
	
    /**
     * 특정 날짜를 'YYYY/MM/DD' 형식으로 return<br>
     *
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
     * 
     */
    public static String returnDate(String date) {

		String year = date.substring(0,4);
		String month = date.substring(4,6);
		String day = date.substring(6,8);

		return year + "/" + month + "/" + day;
	}
    
    /**
     * 윤년 check Method...
     * : 올해가 윤년인지를 check하여 booelan으로 return;
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
	 *
     */

	 public static boolean checkEmbolism(int year) {

		 int remain = 0;
		 int remain_1 = 0;
		 int remain_2 = 0;

		 remain = year % 4;
		 remain_1 = year % 100;
		 remain_2 = year % 400;

		 // the ramain is 0 when year is divided by 4;
		 if (remain == 0) {

			 // the ramain is 0 when year is divided by 100;
			 if (remain_1 == 0) {

			 	// the remain is 0 when year is divided by 400;
				if (remain_2 == 0) return true;
				else return false;

			 } else  return true;
		 }

		 return false;
	 }

    /**
     * 각 월의 마지막 일을 return
     * 해당 월의 마지막일을 return. 윤년 check후 해당 일을 return
     *
     * @author : 김정태 
     * @e-mail : jtkim@nicstech.com 
	 *
     */

	public static int getMonthDate(int year, int month) {

		int[] dateMonth = new int[12];

		dateMonth[0] = 31;
		dateMonth[1] = 28;
		dateMonth[2] = 31;
		dateMonth[3] = 30;
		dateMonth[4] = 31;
		dateMonth[5] = 30;
		dateMonth[6] = 31;
		dateMonth[7] = 31;
		dateMonth[8] = 30;
		dateMonth[9] = 31;
		dateMonth[10] = 30;
		dateMonth[11] = 31;

		if (Util.checkEmbolism(year)) dateMonth[1] = 29;

		return dateMonth[month - 1];
	}

	/**
	 * 한 자리 숫자에 앞에 '0'을 붙여 String으로 return하는 메소드<br>
	 * : argument : str, int
	 *     
	 * @author : 김정태 
         * @e-mail : jtkim@nicstech.com 
	 */

	public static String addZero(String str) {

		return (Integer.toString(Integer.parseInt(str) + 100)).substring(1,3);
	}

	public static String addZero2(int num) {

		return (Integer.toString(num + 100)).substring(1,3);
	}

	/**
	 * 우편번호 검색(동이름을 아귀먼트로 보내면 벡터로 반환)
	 * : argument 동이름

	 *@author : 이동호
		*@e-mail : dhlee@nicstech.com 
	********************************************************************************/
	public Vector getCommonResult(String dong) 
	{
		DBConnectionManager dbMgr = null;
		Connection conn = null;
		dbMgr = DBConnectionManager.getInstance();
		conn = dbMgr.getConnection("acar");
//		PreparedStatement pstmt = null;
		Statement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		try {
			String sql = "select rtrim(zip_code) as zip_code, rtrim(sido) as sido, rtrim(gugun) as gugun, rtrim(dong) as dong, rtrim(bunji) as bunji from zipcode where dong like '%"+dong+"%'";

		    pstmt = conn.createStatement();
	    	rs = pstmt.executeQuery(sql);
    		ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()) {
				Hashtable hash = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++) 
				{
					String columnName = rsmd.getColumnName(pos);
					String val = rs.getString(columnName);
					hash.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
					hash.put(columnName, (val)==null?"":val);
				}
				vt.add(hash);
			}
		} 
		catch (SQLException e) 
		{
	  		e.printStackTrace();
		} 
		finally 
		{
			if ( rs != null ) 
				try{rs.close();}
				catch(Exception e)
					{System.out.println("rs error");}
			if ( pstmt != null ) 
				try{pstmt.close();}
				catch(Exception e){System.out.println("stmt error");}
			if ( conn != null ) 
				try{dbMgr.freeConnection("acar", conn);}
				catch(Exception e){System.out.println("conn error");}
//			closeConnection();
			return vt;
		}
	}
//
//=========================================================================================================
//=========================================================================================================
//
//                  아래 메소들은 사용하지 마시고 다른 유틸리티 클래스를 참고 하세요. <김정태>
//
//=========================================================================================================
//=========================================================================================================
//

    
    /** 페이지 바로가기 출력<br>
     * argument : 현재 페이지, 전체 페이지, 현재 페이지의 위치, URL, 테이블 크기
     */
     // 주의 !!!!!!  ==> HtmlUtility 클래스의 메소드를 사용하세요..
    public synchronized static String doPageShortCut(int page, int all_page, int position, String url, String width){
            StringBuffer sb = new StringBuffer("");
    	sb.append("<table border=0 cellpadding=0 cellspacing=0 width="+width+">\n<tr><td align=center width=100%>");
    	// 페이지를 번호를 몇개씩 보여줄지 지정
    	final int MAX_SHOW = 5;
    	if(all_page >1){
    		boolean before = page > MAX_SHOW; // [이전] 페이지가 있는지 검사
    		boolean after = ((MAX_SHOW - position) + page) < all_page; // [다음] 페이지가 있는지 검사
    		int firstPage = 1; // [이전]의 페이지 번호
    		int lastPage = page + (MAX_SHOW - position) + 1; //[다음]의 페이지 번호
    		if((page - position) >= MAX_SHOW)
    			firstPage = page - position;
    		if(before)
    			sb.append(" <a href=\"" +url+ "?page="+firstPage+"&position="+MAX_SHOW+"\">[이전]</a>");
    		int nPosition = 0;
    		for(int i = 0; i	< all_page; i++){				
    			if(((i+1) > (page - position)) && nPosition < MAX_SHOW){
    				if(page != (i+1))
    					sb.append(" <a href=\"" +url+ "?page="+(i+1)+"&position="+(nPosition+1)+"\">"+(i+1)+"</a>");
    				else
    					sb.append(" <font color=red>"+(i+1)+"</font>");
    				nPosition ++;
    			}
    		}
    		if(after)
    			sb.append(" <a href=\"" +url+ "?page="+lastPage+"&position=1\">[다음]</a>");
    	}
    	sb.append("</td></tr>\n</table>");
    	return sb.toString();
    }
    
     /**
     * PreparedStatment 에 데이터를 바인딩시 null 값이 들어올 경우 null을 바인딩하는 메소드
     */
     // 주의 !!!!!!  ==> HtmlUtility 클래스의 메소드를 사용하세요..
    public static synchronized void setBinding(java.sql.PreparedStatement pstmt, Object value, int columnIndex, int sqlType) throws java.sql.SQLException{
        if(value == null || value.toString().equals("")){
            pstmt.setNull(columnIndex, sqlType);
        }else{
            pstmt.setObject(columnIndex, value);
        }
    }
    
       // Long Raw 값 입력하기
    // 주의 !!!!!!  ==> HtmlUtility 클래스의 메소드를 사용하세요..
    public synchronized static void setLongRaw(java.sql.PreparedStatement pstmt, int columnIndex, String text){
    	InputStream bis = null;
    	try{
    		bis = new ByteArrayInputStream(text.getBytes());
    		pstmt.setBinaryStream (columnIndex, bis, bis.available());
    		bis.close();
    	}catch(IOException ie){
    		try{
    			if(bis != null) bis.close();
    		}catch(IOException ignored){}
    	}catch(java.sql.SQLException se){}
    }
    
        // Long Raw 값 받아오기
    // 주의 !!!!!!  ==> HtmlUtility 클래스의 메소드를 사용하세요..
    public synchronized static String getLongRaw(java.sql.ResultSet rs, int columnIndex){
    	InputStream text_data = null;
    	StringBuffer str = new StringBuffer();
    	try{
    		text_data = rs.getBinaryStream(columnIndex);		
    		int c;
    		while ((c = text_data.read ())!= -1)
    			str.append((char)c);
    			
    		text_data.close();
    	}catch(IOException ie){
    		try{
    			if(text_data != null) text_data.close();
    		}catch(IOException ignored){}
    	}catch(java.sql.SQLException se){}
    	
    	return toKSC(str.toString());
    }
	
    // Long Raw 값 받아오기
    // 주의 !!!!!!  ==> HtmlUtility 클래스의 메소드를 사용하세요..
    public synchronized static String getLongRaw(java.sql.ResultSet rs, String columnName){
    	InputStream text_data = null;
    	StringBuffer str = new StringBuffer();
    	try{
    		text_data = rs.getBinaryStream(columnName);		
    		int c;
    		while ((c = text_data.read ())!= -1)
    			str.append((char)c);
    			
    		text_data.close();
    	}catch(IOException ie){
    		try{
    			if(text_data != null) text_data.close();
    		}catch(IOException ignored){}
    	}catch(java.sql.SQLException se){}
    	
    	return toKSC(str.toString());
    }
    
    
    /**
     * \n -> <BR>
      <주의 !!!!!: HtmlUtility 클래스에 있는 메소드를 사용하세요.!!>
     */
    public static String htmlBR(String comment){
    	int length = comment.length();
    	StringBuffer buffer = new StringBuffer();
    	
    	for (int i = 0; i < length; ++i)
    	{
    		String comp = comment.substring(i, i+1);
    		if ("\r".compareTo(comp) == 0)
    		{
    			comp = comment.substring(++i, i+1);
    			if ("\n".compareTo(comp) == 0)
    				buffer.append("<BR>\r");
    			else
    				buffer.append("\r");
    		}
    		buffer.append(comp);
    	}
    	return buffer.toString();
    }
	/**
     * \n -> \\r
      <주의 !!!!!: HtmlUtility 클래스에 있는 메소드를 사용하세요.!!>
     */
    public static String htmlR(String comment){
    	int length = comment.length();
    	StringBuffer buffer = new StringBuffer();
    	
    	for (int i = 0; i < length; ++i)
    	{
    		String comp = comment.substring(i, i+1);
    		if ("\r".compareTo(comp) == 0)
    		{
    			comp = comment.substring(++i, i+1);
    			if ("\n".compareTo(comp) == 0)
    				buffer.append("\\r");
    			else
    				buffer.append("\\r");
    		}
    		buffer.append(comp);
    	}
    	return buffer.toString();
    }
    /**
    엔터키 앞에 ">"를 붙혀 답변을 하는데 사용한다.
    <주의 !!!!!: HtmlUtility 클래스에 있는 메소드를 사용하세요.!!>
    */
    public static String addGT(String comment){
    	int length = comment.length();
    	StringBuffer buffer = new StringBuffer("> ");		
    	for (int i = 0; i < length; ++i)
    	{
    		String comp = comment.substring(i, i+1);
    		if ("\r".compareTo(comp) == 0)
    		{
    			comp = comment.substring(++i, i+1);
    			if ("\n".compareTo(comp) == 0)
    				buffer.append("\n> ");
    			else
    				buffer.append("\r");
    		}else{
    			buffer.append(comp);
    		}
    	}
    	return buffer.toString();
    }
    
    /*
       날짜
    */
    public static String ChangeDate2(String unFormat)
	{
		String Format = "";
		if(unFormat.length() == 8){
			Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8);
			return Format;
		}else if(unFormat.length() == 6){
			Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6);
			return Format;
		}else if(unFormat.length() == 10){
			Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8)+' '+unFormat.substring(8,10)+'시';
			return Format;
		}else if(unFormat.length() == 12){
			Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8)+' '+unFormat.substring(8,10)+'시'+unFormat.substring(10,12)+'분';
			return Format;
		}else{
			return unFormat;
		}
	}	

    /**
     * 대메뉴 정보를 가져온다.
     * @author Dev.ywkim
     * @since 2015. 04. 21
     * @param deptId
     * @return
     */
    public static HashMap<String, Object> getDepthMenuInfo(String deptId){
    	
    	HashMap<String, Object> map = new HashMap<String, Object>();
    	
    	if( deptId.trim().equals("1000") ){
    		map.put("menu", Webconst.path1_info.MENU_DEPTH_1_AGENT);
    		map.put("menuSearator", Webconst.path1_info.MENU_AGENT_SEPARATOR);
    	}else if(deptId.trim().equals("8888")){
    		map.put("menu", Webconst.path1_info.MENU_DEPTH_1_PARTNER);
    		map.put("menuSearator", Webconst.path1_info.MENU_PARTNER_SEPARATOR);    		
    	}else{
    		map.put("menu", Webconst.path1_info.MENU_DEPTH_1);
    		map.put("menuSearator", Webconst.path1_info.MENU_DEPTH_1_SEPARATOR);    		
    	}
    	
    	return map;
    }


    
    public static String convertMenuNM(String mn){
    	
    	int len = 0;
    	for(int j=0;j<mn.length();j++){
    		if(Character.getType(mn.charAt(j)) == 5){
    			len++;
    		}
    	}
    	
    	if( len > 10 ){
    		mn = "<span style='font-size: 11px'>" + mn + "</span>";
    	}
    	
    	return mn;
    }
        
    public  static boolean CheckNumber(String str){
		char check;
		
		if(str.equals(""))
		{
			//문자열이 공백인지 확인
			return false;
		}
		
		for(int i = 0; i<str.length(); i++){
			check = str.charAt(i);
			if( check < 48 || check > 58)
			{
				//해당 char값이 숫자가 아닐 경우
				return false;
			}
			
		}		
		return true;
	}
}
