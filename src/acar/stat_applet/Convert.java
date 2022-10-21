package acar.stat_applet;

import java.util.*;
import java.text.SimpleDateFormat;
import java.net.InetAddress;

public class Convert
{

	public final static String ksc2ascii(String str) 
	{
		String rtnStr = null;
		if(str==null) str=" ";		
		try {
			byte[] b = str.getBytes("KSC5601");
			rtnStr = new String(b, "8859_1");
		}	catch(Exception e) {
			rtnStr = str;
			System.out.println(e.getMessage());
		}		
		return rtnStr;
	}

	public final static String ascii2ksc(String str) 
	{
		String rtnStr = null;
		if(str==null) str=" ";		
		try {
			byte[] b = str.getBytes("8859_1");
			rtnStr = new String(b, "KSC5601");
		} 	catch(Exception e) {
			rtnStr = str;
			System.out.println(e.getMessage());
		}		
		return rtnStr;
	}

	public static int getLength(String str)
	{
		byte[] strLen = str.getBytes();
		return strLen.length;
	}
	
	public static int isTelNum(String telNum) {
		if (telNum.length() > 11 || telNum.length() < 9) 
			return -20;

		if (telNum.substring(0, 3).equals("016") || telNum.substring(0, 3).equals("011") || telNum.substring(0, 3).equals("017") ||
			telNum.substring(0, 3).equals("018") || telNum.substring(0, 3).equals("019"))
			return 0;
			
		return -21;
	}
	
	public static String getDate()
	{
		Calendar cal = Calendar.getInstance(); 
		String year = getSizingZero(cal.get(Calendar.YEAR) + "", 4);
		String month = getSizingZero((cal.get(Calendar.MONTH) + 1)+ "", 2);
		String day = getSizingZero((cal.get(Calendar.DATE) ) + "", 2);
		return year + month + day;
	}

	public static String getKorDateString(String format)
	{
		TimeZone tz = TimeZone.getTimeZone("JST");
		tz.setDefault(tz);
		SimpleDateFormat formatter = new SimpleDateFormat (format, Locale.KOREA);
		java.util.Date now = new java.util.Date();
		return formatter.format(now);
	}

	public static String getSizingZero(String str, int len)
	{				
		for(int i = str.length(); i < len; i++)
		{
			str = "0" + str;
		}
		return str;
	}
	
	public static String getSizingSpace(String str, int len)
	{
		byte[] strLen = str.getBytes();
		StringBuffer sb = new StringBuffer(str);
		String   space     = " ";
		for(int i = strLen.length; i < len; i++)
		{
			sb.append(" ");
		}
		return sb.toString();
	}
	
	public static String makeLengthString(String str, int len)
	{
		byte[] strLen;
		String temp = "";
		String retStr = "";
		int maxlen = 0;		
		for(int i = 0; i < str.length(); i++)
		{
			temp = str.substring(i, i+1);
			strLen = temp.getBytes();
			maxlen += strLen.length;
			if (maxlen > len)
				break;
			else
				retStr += temp;
		}
		return retStr;
	}	
	
	public static String getCommaNum(String value) {
		String retValue = "";
		int position = 0;		
		if (value.equals(""))
			return value;
		for(int i = value.length() ; i > 0 ; i--) {
			retValue = value.substring(i-1, i) + retValue;
			position++;
			if ((position % 3) == 0)
				retValue = "," + retValue;
		}				
		if (retValue.substring(0, 1).equals(","))
			retValue = retValue.substring(1);				
		return retValue;
	}

	public static String delComma(String value) {
		value = value.replace(',', ' ');
		StringTokenizer st = new StringTokenizer(value);
		String ret = "";
	    while (st.hasMoreTokens()) {
	    	ret += st.nextToken();
	     } 	
		return ret;	
	}

	public static boolean isDate(int year, int month, int day) {
		month -= 1;
		Date today = new Date(year, month, day);
		int r_year = today.getYear();
		int r_month = today.getMonth();
		int r_day = today.getDate();
		if ((r_year != year) || (r_month != month) || (r_day != day))
			return false;
		else
			return true;
	}

	public static boolean isDate(String date) {
		if (date.length() != 10) {
			return false;
		}
		String yyyy = date.substring(0, 4);
		String mm = date.substring(5, 7);
		String dd = date.substring(8, 10);
		String su = "0123456789";		
		for (int i = 0 ; i < yyyy.length() ; i++)
			if (su.indexOf(yyyy.substring(i, i+1)) == -1)
					return false;
		for (int i = 0 ; i < mm.length() ; i++)
			if (su.indexOf(mm.substring(i, i+1)) == -1)
					return false;
		for (int i = 0 ; i < dd.length() ; i++)
			if (su.indexOf(dd.substring(i, i+1)) == -1)
					return false;
		boolean ret = isDate(Integer.parseInt(yyyy), Integer.parseInt(mm), Integer.parseInt(dd));
		if (!ret)
			return false;
		return true;
	}

	public static String firstFillZero(String str, int len) {
		byte[] strLen = str.getBytes();
		String zero_str = "";
		for(int i = strLen.length; i < len; i++)
		{
			zero_str += "0";
		}
		return zero_str + str;		
	}
	
	public static void main(String args[]) {
		System.out.println(makeLengthString(" ¿ì¸®", 2));		
	}
}
