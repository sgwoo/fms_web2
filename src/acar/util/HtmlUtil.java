package acar.util;

import java.util.*;
import java.io.*;

public class HtmlUtil{

    // OFFICE ��� ���̺� ����
    public static final String OFFICE_BG = "#757575"; // �׵θ���
    public static final String OFFICE_TH = "#E7F19E";  // Ÿ��Ʋ �÷���
    public static final String OFFICE_TD = "#FFFFFF";  // ���� �÷���
    public static final String OFFICE_TP = "#F4FAD2";  // ���(�˻�â ������)
    
    // �л����� ���� ���� ���̺� ����
    public static final String SERVICE_BG = "#757575"; // �׵θ� ��
    public static final String SERVICE_TH = "#E7F19E"; // Ÿ��Ʋ �÷���
    public static final String SERVICE_TD = "#E9EEE1"; // ���� �÷���

    /**
     * ����Ű �տ� " > "�� ���� �亯�� �ϴµ� ����Ѵ�.<br>
     *
     * @ author : ������ 
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
    
    /** ������ �ٷΰ��� ���<br>
     * argument : ���� ������, ��ü ������, ���� �������� ��ġ, URL, ���̺� ũ��, ��Ÿ �ʿ��� �Ķ���͵� (ex: name=aaa&type=1)
     *
     * @ author : ������ 
     * @ E-mail : jtkim@nicstech.com
     *
     */
    public synchronized static String doPageShortCut(int page, int all_page, int position, String url, String width, String parameter){
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
     * ������ �ٷΰ��� ���<br>
     * :[ ���� ] [����] �� �ʿ���� ������ ��ȣ�� ������ [��ü ����] �� [�������� ����] �� �����Ǵ� ������ ��ũ. --_--;; <br>
     *
     * @ author : ������ 
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
    		sb.append(" <a href=\"").append(url).append("?max="+allData+"&"+param+"\">[��ü ����]</a><br>\n");			
    	}else if(allData > maxRow){
    		sb.append("<br><a href=\"").append(url).append("?"+param+"\">[�������� ����]</a><br>\n");
    	}		
    	sb.append("</td></tr>\n</table>\n");
    	return sb.toString();
    }
    
    /**
     * ���Ͱ��� <BR> �ױ׷� ��ȯ�ϴ� �޼ҵ� <br>
     * : �Խ����� ���� ��ȸ�� <pre> �ױ׸� ������� �ʾ����� �������� �ذ�<br>
     *
     * @ author : ������ 
     * @ E-mail : jtkim@nicstech.com
     * 
     */
    public static String htmlBR(String comment){
    	int length = comment.length();
    	StringBuffer buffer = new StringBuffer();
    	
    	for (int i = 0; i < length; ++i)
    	{
    		String comp = comment.substring(i, i+1);
    		// ���� �����͸� ���̱׷��̼� �� ������ ���Ͱ��� �˻��ϱ� ���� �����Ͽ���.
    		// cgi �� �����͸� ������ : \n
    		// �ڹٷ� �����͸� ������ :\r\n
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
     * java.net.URLEncoder.encode �� ��ȯ�ϸ� ���� �ٲ�Ƿ�  URL���� �ѱ��� ���ڵ��ϱ� ���� �޼ҵ�<br>
     * URL �� �Ķ���͸� ������ �ѱ涧 ����ϸ� ��Ȯ�ϰ� ���� ���� �� �ִ�. <br>
     * Commant : tomcat �� ����Ͽ����� URL�� �Ķ����(�ѱ�)�� �ѱ涧 ������ �߻��Ͽ� ������� �޼ҵ�<br>
     *
     * @ author : ������ 
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
     * �Խ��� ����Ʈ���� ���콺 ������ ������ ���̰��ϴ� ��ũ��Ʈ���� ' �� " ���ڰ� ���� �ȵǴϱ� ���ֹ����� �޼ҵ�.^^ <br>
     * : Statement �� �Ἥ �������� ���� ������ ������ ����ϸ� �����Ұ� ����.(�غ��� �ʾ���) <br>
     *
     * @ author : ������ 
     * @ E-mail : jtkim@nicstech.com
     * 
     */
    public static String replaceQuote(String str){
        String value = str.replace((char)39, '��');
        value = value.replace('"','��');
        return value;
    }
    
    /**
     * �ڹٽ�ũ��Ʈ�� ������ ������ ���ٷ� ������ �ϴ� �޼ҵ�.<br>
     * : ���ٷ� �Ѿ�� �ڹٽ�ũ��Ʈ ������ �߻��ϱ� ������ �� ������ �ذ� <br>
     * : �ؽ�Ʈ ���̸� ������ ũ�⸸ŭ �����ϰ� ��. <br>
     *
     * @ author : ������ 
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

        jspwriter.println("</select><font size=2>��</font>");
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

        jspwriter.println("</select><font size=2>��</font>");
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

        jspwriter.println("</select><font size=2>��</font>");
    }    
}