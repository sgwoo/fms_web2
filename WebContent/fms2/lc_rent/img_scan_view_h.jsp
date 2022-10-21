<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//이미지파일 보기
	
	String vid[] = request.getParameterValues("img_url");
	int vid_size = vid.length;
	
	
	
	String img_url = "";
	
	double img_width 	= 2100*0.378;
	double img_height 	= 2970*0.378;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>

<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
<!--<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" viewastext codebase="http://www.meadroid.com/scriptx/smsx.cab#Version=6,3,435,20">-->
</object>

<%	for(int i=0;i < vid_size;i++){
		img_url 	= vid[i];
		if(!img_url.equals("")){%>
<img src=<%=img_url%> width=<%=img_width%> height=<%=img_height%>>
<%		}
	}%>

</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header 		= ""; //폐이지상단 인쇄
factory.printing.footer 		= ""; //폐이지하단 인쇄
factory.printing.portrait 		= true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin 	= 0; //좌측여백   
factory.printing.rightMargin 	= 0; //우측여백
factory.printing.topMargin 		= 0; //상단여백    
factory.printing.bottomMargin 	= 0; //하단여백
factory.printing.Print(false, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>