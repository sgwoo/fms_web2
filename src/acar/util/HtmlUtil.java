package acar.util;

import java.util.*;
import java.io.*;

public class HtmlUtil{

    // OFFICE 운영자 테이블 색깔
    public static final String OFFICE_BG = "#757575"; // 테두리색
    public static final String OFFICE_TH = "#E7F19E";  // 타이틀 컬럼색
    public static final String OFFICE_TD = "#FFFFFF";  // 내용 컬럼색
    public static final String OFFICE_TP = "#F4FAD2";  // 상단(검색창 넣을때)
    
    // 학사행정 서비스 센터 테이블 색깔
    public static final String SERVICE_BG = "#757575"; // 테두리 색
    public static final String SERVICE_TH = "#E7F19E"; // 타이틀 컬럼색
    public static final String SERVICE_TD = "#E9EEE1"; // 내용 컬럼색

    /**
     * 엔터키 앞에 " > "를 붙혀 답변을 하는데 사용한다.<br>
     *
     * @ author : 김정태 
     * @ E-mail : jtkim@nicstech.com<br>
     *
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
    
    /** 페이지 바로가기 출력<br>
     * argument : 현재 페이지, 전체 페이지, 현재 페이지의 위치, URL, 테이블 크기, 기타 필요한 파라미터들 (ex: name=aaa&type=1)
     *
     * @ author : 김정태 
     * @ E-mail : jtkim@nicstech.com
     *
     */
    public synchronized static String doPageShortCut(int page, int all_page, int position, String url, String width, String parameter){
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
    			sb.append(" <a href=\"" +url+ "?page="+firstPage+"&position="+MAX_SHOW+"&"+parameter+"\"><img src=\"/image/button/button50.gif\" border=0></a>");
    		int nPosition = 0;
    		for(int i = 0; i	< all_page; i++){				
    			if(((i+1) > (page - position)) && nPosition < MAX_SHOW){
    				if(page != (i+1))
    					sb.append(" <a href=\"" +url+ "?page="+(i+1)+"&position="+(nPosition+1)+"&"+parameter+"\">"+(i+1)+"</a>");
    				else
    					sb.append(" <font color=red>"+(i+1)+"</font>");
    				nPosition ++;
    			}
    		}
    		if(after)
    			sb.append(" <a href=\"" +url+ "?page="+lastPage+"&position=1&"+parameter+"\"><img src=\"/image/button/button51.gif\" border=0></a>");
    	}
    	sb.append("</td></tr>\n</table>");
    	return sb.toString();
    }
    
    /**
     * 페이지 바로가기 출력<br>
     * :[ 다음 ] [이전] 이 필요없고 페이지 번호만 있으되 [전체 보기] 및 [페이지별 보기] 가 지원되는 하이퍼 링크. --_--;; <br>
     *
     * @ author : 김정태 
     * @ E-mail : jtkim@nicstech.com
     * 
     */
    public static String hrefPage(int page, int all_page, int maxRow, int allData, String url, String param, String width){
    	StringBuffer sb = new StringBuffer("");
    	sb.append("<table border=0 cellpadding=0 cellspacing=0 width="+width+">\n<tr><td align=center width=100%>\n");
    	if(all_page >1){			
    		for(int i = 0; i< all_page; i++){
        		if(page != (i+1))
        			sb.append(" <a href=\"").append(url).append("?page="+(i+1)+"&"+param+"\">"+(i+1)).append("</a>\n");
        		else
        			sb.append(" <font color=red>"+(i+1)).append("</font>\n");			
    		}
    		sb.append(" <a href=\"").append(url).append("?max="+allData+"&"+param+"\">[전체 보기]</a><br>\n");			
    	}else if(allData > maxRow){
    		sb.append("<br><a href=\"").append(url).append("?"+param+"\">[페이지별 보기]</a><br>\n");
    	}		
    	sb.append("</td></tr>\n</table>\n");
    	return sb.toString();
    }
    
    /**
     * 엔터값을 <BR> 테그로 변환하는 메소드 <br>
     * : 게시판의 내용 조회시 <pre> 테그를 사용하지 않았을때 문제점을 해결<br>
     *
     * @ author : 김정태 
     * @ E-mail : jtkim@nicstech.com
     * 
     */
    public static String htmlBR(String comment){
    	int length = comment.length();
    	StringBuffer buffer = new StringBuffer();
    	
    	for (int i = 0; i < length; ++i)
    	{
    		String comp = comment.substring(i, i+1);
    		// 기존 데이터를 마이그래이션 해 왔을때 엔터값을 검사하기 위해 수정하였음.
    		// cgi 로 데이터를 넣을때 : \n
    		// 자바로 데이터를 넣을때 :\r\n
    		if ("\r".compareTo(comp) == 0 || "\n".compareTo(comp) == 0)
    		{
    		    if("\r".compareTo(comp) == 0){
    			comp = comment.substring(++i, i+1);
    			if ("\n".compareTo(comp) == 0)
                            buffer.append("<BR>\r");
                    }else{
                        buffer.append("<BR>\r");
                    }
    		}
                buffer.append(comp);
    	}
    	return buffer.toString();
    }
    
    /**
     * java.net.URLEncoder.encode 로 변환하면 값이 바뀌므로  URL에서 한글을 엔코딩하기 위한 메소드<br>
     * URL 로 파라미터를 붙혀서 넘길때 사용하면 정확하게 값을 받을 수 있다. <br>
     * Commant : tomcat 을 사용하였을때 URL로 파라미터(한글)를 넘길때 문제가 발생하여 만들었던 메소드<br>
     *
     * @ author : 김정태 
     * @ E-mail : jtkim@nicstech.com
     * 
     */
    public static String encode(String str){
        String val = null;
        if(str != null)
            val = java.net.URLEncoder.encode(str);  
            
        return val;
    }
    
    /**
     * 게시판 리스트에서 마우스 오버시 내용을 보이게하는 스크립트에서 ' 와 " 문자가 들어가면 안되니깐 없애버리는 메소드.^^ <br>
     * : Statement 를 써서 쿼리문에 값을 붙혀서 넣을때 사용하면 유용할거 같음.(해보지 않았음) <br>
     *
     * @ author : 김정태 
     * @ E-mail : jtkim@nicstech.com
     * 
     */
    public static String replaceQuote(String str){
        String value = str.replace((char)39, '′');
        value = value.replace('"','″');
        return value;
    }
    
    /**
     * 자바스크립트로 찍을때 내용이 한줄로 나오게 하는 메소드.<br>
     * : 두줄로 넘어가면 자바스크립트 에러가 발생하기 때문에 이 문제를 해결 <br>
     * : 텍스트 길이를 적당한 크기만큼 리턴하게 함. <br>
     *
     * @ author : 김정태 
     * @ E-mail : jtkim@nicstech.com
     * 
     */    
    public static String rmEnter(String comment, int len){
    	int length = comment.length();
    	StringBuffer buffer = new StringBuffer();
    	
    	for (int i = 0; i < length; ++i)
    	{
    		String comp = comment.substring(i, i+1);
    		if ("\r".compareTo(comp) == 0 || "\n".compareTo(comp) == 0)
    		{
    			if(i < (length-1)){
        			comp = comment.substring(++i, i+1);
        			if ("\n".compareTo(comp) == 0)
        				buffer.append("<BR>");
                        }
    		}else{
    		        buffer.append(comp);
    		}
    		if(i == len) {
    		    buffer.append("....");
    		    break;  
                }
    	}
    	return buffer.toString();
    }
    
    public static void getSelectDate(javax.servlet.jsp.JspWriter jspwriter, String s) throws IOException{
        int i = 0;
        int j = 0;
        int k = 0;
        int l = 0;
        i = Integer.parseInt(Util.getDate(1));
        j = Integer.parseInt(Util.getDate(2));
        k = Integer.parseInt(Util.getDate(3));
        l = Util.getMonthDate(i, j);
        jspwriter.println("<select name=" + s + "_yr style=\"BACKGROUND-COLOR: #9DE1DD; BORDER-BOTTOM: black 1px solid; " + "BORDER-LEFT: black 1px solid; " + "BORDER-RIGHT: black 1px solid; " + "BORDER-TOP: black 1px solid; COLOR: black; " + "HEIGHT: 20px; color=#923932\">");
        for(int i1 = -2; i1 < 3; i1++)
        {
            String s1 = null;
            s1 = "<option value=" + (i + i1);
            if(i + i1 == i)
                s1 = s1 + " selected";
            s1 = s1 + ">" + (i + i1) + "</option>";
            jspwriter.println("\t" + s1);
        }

        jspwriter.println("</select><font size=2>년</font>");
        jspwriter.println("<select name=" + s + "_month style=\"BACKGROUND-COLOR: #9DE1DD; BORDER-BOTTOM: black 1px solid; " + "BORDER-LEFT: black 1px solid; " + "BORDER-RIGHT: black 1px solid; " + "BORDER-TOP: black 1px solid; COLOR: black; " + "HEIGHT: 20px; color=#923932\">");
        for(int j1 = 1; j1 < 13; j1++)
        {
            String s2 = null;
            s2 = "<option value=" + j1;
            if(j1 == j)
                s2 = s2 + " selected";
            s2 = s2 + ">" + j1 + "</option>";
            jspwriter.println("\t" + s2);
        }

        jspwriter.println("</select><font size=2>월</font>");
        jspwriter.println("<select name=" + s + "_day style=\"BACKGROUND-COLOR: #9DE1DD; BORDER-BOTTOM: black 1px solid; " + "BORDER-LEFT: black 1px solid; " + "BORDER-RIGHT: black 1px solid; " + "BORDER-TOP: black 1px solid; COLOR: black; " + "HEIGHT: 20px; color=#923932\">");
        for(int k1 = 1; k1 < l; k1++)
        {
            String s3 = null;
            s3 = "<option value=" + k1;
            if(k1 == k)
                s3 = s3 + " selected";
            s3 = s3 + ">" + k1 + "</option>";
            jspwriter.println("\t" + s3);
        }

        jspwriter.println("</select><font size=2>일</font>");
    }    
}