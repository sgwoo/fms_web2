/*
 * @ Util.java
 *
 * TYPE : ���� Ŭ���� (com)
 *
 * ���� : Util Class
 *
 * ����
 *    - static method�� Util.mehtod()�� ȣ���Ѵ�.
 *    - ��Ÿ �޼ҵ�� ��ü������ �����Ѵ�.
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
     * @author : ������
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
     * @author : ������
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
     * @author : ������
     * @e-mail : jtkim@nicstech.com
	 * return  : null�� ���, ""�� return
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
     * @author : ������
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
     * ���糯¥�� ������ �������� ����� ���� <br>
     *
     * @author : ������
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
     * ���糯¥�� YYYY-MM-DD �������� ����� ���� <br>
     *
     * @author : ������
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
     * �Է¹��� Date ������Ʈ�� YYYY-MM-DD ������ String ���� ����� ���� <br>
     *
     * @author : ������
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
     * �Է¹��� Date ������Ʈ�� Ư���� ���� ������ String ���� ����� ���� <br>
     *
     * ��) dateToString(new Date(), "MMM d,  yyyy")<br>
     *
     * @author : ������
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
     * �Է¹��� String������Ʈ�� Ư���� ���� ������ Date ������ ����� ���� <br>
     *
     * ��) stringToDate("2001-06-01", "yyyy-'-'MM'-'dd")<br>
     *
     * @author : ������
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
     * ���糯¥�� YYYY-MM-DD HH:MM:SS �������� ����� ���� <br>
     *
     * @author : ������
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
     * ���糯¥�� YYYY-MM-DD HH:MM:SS �������� ����� ���� <br>
     *
     * @author : ������
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
     * ���� ��¥�� Ÿ�Կ� ���� ��, ��,�� ���� ���� <br>
     *
     * @author : ������
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
     * Encode URL -> Decode URL : jdk 1.x ���������� java.net.URLDecoder Ŭ������ �������� �ʱ� ������<br>
     *  jdk1.x ���� URL ���ڵ��� ���. <br>
     *
     * @author : ������
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
     * ��Ʈ���� int�� ��ȯ. NumberFormatException, NullPointerException �� �˻��ϱ� ����, Exception �߻��� 0 ����
     *
     * @author : ������
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
     * ��Ʈ���� int�� ��ȯ. NumberFormatException, NullPointerException �� �˻��ϱ� ����, Exception �߻��� 0 ����
     *
     * @author : ������
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
     * ��Ʈ���� int�� ��ȯ. NumberFormatException, NullPointerException �� �˻��ϱ� ����, Exception �߻��� 0 ����
     *
     * @author : ������
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
     * ��Ʈ���� int�� ��ȯ. NumberFormatException, NullPointerException�� �˻��ϱ� ����, Exception �߻��� default value ����<br>
     *
     * @author : ������
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
     * �Ķ������ ���� "" �϶� null �� �����ϰԲ� �ϴ� �޼ҵ�<br>
     * URL���� �Ķ���͸� ������ name ���� �����ϸ� "" �� �Ѿ�� �� �ֱ� ������ null ���� �˻��Ҷ� ���.<br>
     *
     * @author : ������
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
     * ��¥���� ��, ��, �Ϸ� ������ �����ϴ� �޼ҵ�<br>
     *
     * @author : ������
     * @e-mail : jtkim@nicstech.com
     */
    public static String parseDate(String date, int type){
    	String parse = "";
    	if(date != null && date.length() == 8){
    		switch(type){
    			case 1: //��
    				parse = date.substring(0, 4);
    				break; 
    			case 2: //��
    				parse = date.substring(4, 6);
    				break;
    			default: //��
    				parse = date.substring(6, 8);
    				break;
    		}
    	}
    	return parse;
    }
    
    /**
     * &nbsp -> ""
     *
     * @author : ������
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
     * null -> "" �� ��ȯ�ϴ� �޼ҵ�<br>
     * : ������ ������ ������ ���̽��� ���� ���� ���� null�̸� ���� ���� null�� ���Ƿ� �̰��� ��ȯ�ϴ� �޼ҵ� <br>
     * : ������ ������ null ���� ���� ���� setting �Ҷ� ����ϸ� ������ �޼ҵ�. <br>
     *
     * @author : ������
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
     * : HTML���� ���̺��� ���� "" �� ���� ���̺��� �����Ƿ�(netscape) ���鹮��(&nbsp;)�� ��ġ�ϴ� �޼ҵ�<br>
     *
     * @author : ������
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
     * Object ���� String ���� ��ȯ<br>
     * : Object �� null �϶� NullpointerException �� �˻��ϱ� ���ؼ� ���.<br>
     * : ResultSet ���κ��� getObject()�� ���� ����������� String���� ��ȯ�Ҷ� ����ϸ� ������ �޼ҵ�.<br>
     *
     * @author : ������
     * @E-mail : sim11@miraenet.com
     */
    public static String toString(Object obj){
        String str = "";
    	if(obj != null)
    	    str = obj.toString();
    	return str;
    }
    
    /**
     * ��ü �����ͼ��� �������������� ����ؿ��� ���� Method.<br>
     * : �Խ��� ��� ���� ��� �� ������ ���� �ִ��� ����Ҷ� ����ϸ� ������ �޼ҵ�<br>
     *
     * @author : ������
     * @e-mail : jtkim@nicstech.com
     */    
    public static int getPageCount(int token, int allPage){
    	int lastPage =(int)(((allPage-1)/token)+1);	
    	return lastPage;
    }
	
    /**
     * �������� ��ȣ�� �ֱ����� ��ȣ�� ����ؿ��� Method <br>
     * : �Խ��� ��� ���� ��� �������� �������� ��ȣ�� ����� �ִ� �޼ҵ�. <br>
     *
     * @author : ������
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
     * ���� ��ŭ ���鹮�ڸ� ������ �����ϴ� �޼ҵ�<br>
     * �亯���� Depth ó�� �ϴµ� ����ϸ� �����Ҳ� ����.<br>
     *
     * @author : ������ 
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
     * ���ڿ��� ���� null �̰ų� ""�̸� default ���� �����ϴ� �޼ҵ�<br>
     *
     * @author : ������ 
     * @e-mail : jtkim@nicstech.com
     */
    public static String getString(String line, String def){
        if(line == null || line.equals(""))
            return def;
        return line;  
    } 
         
    /**
     * ��������  Ư�� �Ⱓ�� �����ִ��� �˻��ϴ� �޼ҵ�<br>
     * : argument : ������(yyyy-mm-dd), ������(yyyy-mm-dd)
     *     
     * @author : ������ 
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
    * ���ݵ��� ���� 3�ڸ� ���� comma(,)�� �и��Ͽ� ����<br>
    *     
    * @author : ������ 
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
    * ���ݵ��� ���� 3�ڸ� ���� comma(,)�� �и��Ͽ� ����<br>
    *     
    * @author : ������ 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(Object unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        double unFormat1 = Util.parseInt(toString(unFormat));
        String format = df.format(unFormat1);
        return format;
    }
    /**
    * ���ݵ��� ���� 3�ڸ� ���� comma(,)�� �и��Ͽ� ����<br>
    *     
    * @author : ������ 
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
    * ���ݵ��� ���� 3�ڸ� ���� comma(,)�� �и��Ͽ� ����<br>
    *     
    * @author : ������ 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(int unFormat){
        DecimalFormat df = new DecimalFormat("###,###.##");
        String format = df.format(unFormat);
        return format;
    }
    /**
    * ���ݵ��� ���� 3�ڸ� ���� comma(,)�� �и��Ͽ� ����<br>
    *     
    * @author : ������ 
    * @e-mail : jtkim@nicstech.com 
    */        
    public static String parseDecimal(double unFormat, String foramt){
        DecimalFormat df = new DecimalFormat(foramt);
        String format = df.format(unFormat);
        return format;
    }
    /**
     * �߰� - �̹ο�(2002. 3. 21)
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
     * �߰� - Yongsoon Kwon(2005. 10. 12)
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
    * ��ȭ����(comma)�� ���ڿ��� �Ϲ� ������������ ����
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
    * Object �� �����Ͽ� �ִ� �޼ҵ�<br>
    * �Ϲ������� java.lang.Object.clone() �޼ҵ带 ����Ͽ� Object�� �����ϸ� Object���� �ִ� Primitive type�� ������ Object <br>
    * field���� ������ �Ǵ� ���� �ƴ϶� ���� Object�� reference�� ���� �ȴ�.<br>
    * �׷��� �� Method�� ����ϸ� �� field�� ������ Object�� ���� ����(clone)�Ͽ� �ش�.<br>
    * java.lang.reflect API �� ����Ͽ���. <br>
    *     
    * @author : ������ 
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
    * ������ Servlet ������ PrintWriter �� �־ ���� ������� �� �� �־����� <br>
    * JSP ���� ó�� PrintWriter�� ������ ������� ���� �ϱ� ���Ͽ� �޼����� ���ڿ��� ����� �����ϰ� �Ͽ���.<br>
    *
    * @author : ������ 
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
     * Ư�� ���ڿ��� �ٸ� ���ڿ��� ��ü�ϴ� �޼ҵ�<br>
     * : ���ڿ� �˻��� �˻�� ������ �ְų� ... �ױ׸� HTML ���ڷ� �ٲٴµ� ����ϸ� �����Ұ� ����.<br>
     *
     * @author : ������ 
     * @e-mail : jtkim@nicstech.com 
     * @ ���� ���� : JAVA Servlet Programming(Oreilly) 
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
     * �Է¹��� �����ּҰ� �����ּ� ���信 �´��� �˻��ϴ� �޼ҵ� <br>
     *
     * @author : ������ 
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
     * ���ڿ��� substring�Ҷ� ���ڿ� ���̸� �Ѿ ��� "" �������ϴ� �޼ҵ�
     *
     * @author : ������ 
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
    * ','�� �и��Ǿ� �ִ� ���ڿ��� �и��Ͽ� Return
    * List���� �ϰ� ������ ID���� �ϰ��� �޾ƿͼ� Parsing...
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
     * ���ڿ��� �߶� ����
     *
     *
     * @author : ������ 
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
     * ���ڿ��� �߶� �����ϵ� �������ڿ��� �����ش�
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
     * Ư�� ��¥�� 'YYYY/MM/DD' �������� return<br>
     *
     *
     * @author : ������ 
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
     * ���� check Method...
     * : ���ذ� ���������� check�Ͽ� booelan���� return;
     *
     * @author : ������ 
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
     * �� ���� ������ ���� return
     * �ش� ���� ���������� return. ���� check�� �ش� ���� return
     *
     * @author : ������ 
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
	 * �� �ڸ� ���ڿ� �տ� '0'�� �ٿ� String���� return�ϴ� �޼ҵ�<br>
	 * : argument : str, int
	 *     
	 * @author : ������ 
         * @e-mail : jtkim@nicstech.com 
	 */

	public static String addZero(String str) {

		return (Integer.toString(Integer.parseInt(str) + 100)).substring(1,3);
	}

	public static String addZero2(int num) {

		return (Integer.toString(num + 100)).substring(1,3);
	}

	/**
	 * �����ȣ �˻�(���̸��� �Ʊ͸�Ʈ�� ������ ���ͷ� ��ȯ)
	 * : argument ���̸�

	 *@author : �̵�ȣ
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
//                  �Ʒ� �޼ҵ��� ������� ���ð� �ٸ� ��ƿ��Ƽ Ŭ������ ���� �ϼ���. <������>
//
//=========================================================================================================
//=========================================================================================================
//

    
    /** ������ �ٷΰ��� ���<br>
     * argument : ���� ������, ��ü ������, ���� �������� ��ġ, URL, ���̺� ũ��
     */
     // ���� !!!!!!  ==> HtmlUtility Ŭ������ �޼ҵ带 ����ϼ���..
    public synchronized static String doPageShortCut(int page, int all_page, int position, String url, String width){
            StringBuffer sb = new StringBuffer("");
    	sb.append("<table border=0 cellpadding=0 cellspacing=0 width="+width+">\n<tr><td align=center width=100%>");
    	// �������� ��ȣ�� ��� �������� ����
    	final int MAX_SHOW = 5;
    	if(all_page >1){
    		boolean before = page > MAX_SHOW; // [����] �������� �ִ��� �˻�
    		boolean after = ((MAX_SHOW - position) + page) < all_page; // [����] �������� �ִ��� �˻�
    		int firstPage = 1; // [����]�� ������ ��ȣ
    		int lastPage = page + (MAX_SHOW - position) + 1; //[����]�� ������ ��ȣ
    		if((page - position) >= MAX_SHOW)
    			firstPage = page - position;
    		if(before)
    			sb.append(" <a href=\"" +url+ "?page="+firstPage+"&position="+MAX_SHOW+"\">[����]</a>");
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
    			sb.append(" <a href=\"" +url+ "?page="+lastPage+"&position=1\">[����]</a>");
    	}
    	sb.append("</td></tr>\n</table>");
    	return sb.toString();
    }
    
     /**
     * PreparedStatment �� �����͸� ���ε��� null ���� ���� ��� null�� ���ε��ϴ� �޼ҵ�
     */
     // ���� !!!!!!  ==> HtmlUtility Ŭ������ �޼ҵ带 ����ϼ���..
    public static synchronized void setBinding(java.sql.PreparedStatement pstmt, Object value, int columnIndex, int sqlType) throws java.sql.SQLException{
        if(value == null || value.toString().equals("")){
            pstmt.setNull(columnIndex, sqlType);
        }else{
            pstmt.setObject(columnIndex, value);
        }
    }
    
       // Long Raw �� �Է��ϱ�
    // ���� !!!!!!  ==> HtmlUtility Ŭ������ �޼ҵ带 ����ϼ���..
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
    
        // Long Raw �� �޾ƿ���
    // ���� !!!!!!  ==> HtmlUtility Ŭ������ �޼ҵ带 ����ϼ���..
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
	
    // Long Raw �� �޾ƿ���
    // ���� !!!!!!  ==> HtmlUtility Ŭ������ �޼ҵ带 ����ϼ���..
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
      <���� !!!!!: HtmlUtility Ŭ������ �ִ� �޼ҵ带 ����ϼ���.!!>
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
      <���� !!!!!: HtmlUtility Ŭ������ �ִ� �޼ҵ带 ����ϼ���.!!>
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
    ����Ű �տ� ">"�� ���� �亯�� �ϴµ� ����Ѵ�.
    <���� !!!!!: HtmlUtility Ŭ������ �ִ� �޼ҵ带 ����ϼ���.!!>
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
       ��¥
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
			Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8)+' '+unFormat.substring(8,10)+'��';
			return Format;
		}else if(unFormat.length() == 12){
			Format = unFormat.substring(0,4)+'-'+unFormat.substring(4,6)+'-'+unFormat.substring(6,8)+' '+unFormat.substring(8,10)+'��'+unFormat.substring(10,12)+'��';
			return Format;
		}else{
			return unFormat;
		}
	}	

    /**
     * ��޴� ������ �����´�.
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
			//���ڿ��� �������� Ȯ��
			return false;
		}
		
		for(int i = 0; i<str.length(); i++){
			check = str.charAt(i);
			if( check < 48 || check > 58)
			{
				//�ش� char���� ���ڰ� �ƴ� ���
				return false;
			}
			
		}		
		return true;
	}
}
