<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%!
  public String[] mobileTags = { "cellphone",
                                  "iemobile",
                                  "midp",
                                  "mini",
                                  "mmp",
                                  "mobile",
                                  "nokia",
                                  "pda",
                                  "phone",
                                  "pocket",
                                  "ppc",
                                  "psp",
                                  "symbian",
                                  "up.browser",
                                  "up.link",
                                  "wap",
                                  "android",
                                  "iPhone",                                                           
                                  "windows ce" };
  
  public Boolean isMobile( String browserInfo )
  {
    for ( int n=0; n<mobileTags.length; n++ )
    {
      if ( browserInfo.toLowerCase().contains( mobileTags[n].toLowerCase() ) )
      {
        return true;
      }
    }
    return false;
  }
%>

<%
	Enumeration e;	
	e = request.getHeaderNames();

  	String bInfo = request.getHeader( "user-agent" );
    
%>
<html>
<body>
<script language="JavaScript">
<!--

<% if ( isMobile( bInfo ) ) { %>
	location.href="http://fms1.amazoncar.co.kr/smart/index.jsp";
<% } else { %>
 	alert("�ش� ������������ �������� �ʽ��ϴ�.");
 	location.href="http://www.amazoncar.co.kr";
<% } %>

//-->
</script>
</body>
</html>

