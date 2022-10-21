<%@page import="acar.beans.AttachedFile"%>
<%@page import="java.io.*, java.util.*"%>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<%

if( session != null ){

}else{
	out.println( "Session이 존재하지 않음." );
//	return;
}
//	 out.println(session); 
//	 out.println(session_user_id + "(" + session_user_nm + ")"); 
	
	


	//String attachedSeq = request.getParameter("SEQ");

	//if( attachedSeq == null ) attachedSeq = "0";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String param = request.getParameter("param");
    String params[] = param.split(",");
    int cnt = params.length;
   
	double img_width 	= 2100*0.378;
	double img_height 	= 2970*0.378; 
%>

<html>
<head>
<style type="text/css">
 @ page a4sheet {size: 22.0cm 29.7cm}
 .a4 {page: a4sheet; page-break-after: always;}
</style>
<title>FMS</title>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();"> 
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<%-- <img src="view_normal.jsp?SEQ=<%=attachedSeq %>" width=<%=img_width%> height=<%=img_height%> /> --%>

<% 
for(int i=0; i<params.length; i++){
	//세금계산서는 file_st가 10 이므로 content_seq에 %10을 명시.
	String content_seq = String.valueOf(params[i].substring(0,19)) + "%10";	
	String content_code = "LC_SCAN";
	String car_no = String.valueOf(params[i].substring(19));
	
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
	int size = attach_vt.size();
	if(size == 0){
		String l_cd = String.valueOf(params[i].substring(6,19));
%>
	<script type="text/javascript">
	$(document).ready(function(){
		var l_cd = '<%=l_cd%>';
		alert("계약번호 : "+ l_cd + "\n\n에는 세금계산서 스캔파일이 등록되지 않았습니다.\n\n해당 계약번호의 세금계산서는 제외하고 출력됩니다.");		
	});
	</script>
<% 
		
	}
	if(size > 0){
		Hashtable ht = (Hashtable)attach_vt.elementAt(0); 
		String file_name = String.valueOf(ht.get("FILE_NAME"));
		String seq = String.valueOf(ht.get("SEQ"));
	
	
%>
	<div class="a4">
		<div align="right" style="font-size: 20px; font-weight: bold; margin-right: 130px;">차량번호 &nbsp;&nbsp;:&nbsp;&nbsp; <%=car_no%></div>	
		<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=seq%>" width=1000 height=1300 />
		<br>
		<hr/>
	</div>
<%
	}
}
%> 
</body>
</html>
<script language="JavaScript" type="text/JavaScript">

function IE_Print() {
	factory.printing.header = ""; //폐이지상단 인쇄
	factory.printing.footer = ""; //폐이지하단 인쇄
	factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
// 	factory1.printing.leftMargin = 15.0; //좌측여백   
// 	factory1.printing.rightMargin = 0.0; //우측여백
// 	factory1.printing.topMargin = 17.0; //상단여백    
// 	factory1.printing.bottomMargin = 0.0; //하단여백
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function onprint(){
	
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}

/*function onprint(){
factory.printing.header 		= ""; //폐이지상단 인쇄
factory.printing.footer 		= ""; //폐이지하단 인쇄
factory.printing.portrait 		= true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin 	= 0; //좌측여백   
factory.printing.rightMargin 	= 0; //우측여백
factory.printing.topMargin 		= 0; //상단여백    
factory.printing.bottomMargin 	= 0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}*/
</script>