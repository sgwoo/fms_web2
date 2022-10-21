<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>



<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>레이블 출력화면</title>
<script language="JavaScript">
<!--


//-->
</script>

<!--<link rel="stylesheet" type="text/css" href="../../include/table_p.css">-->
<style type="text/css">
<!--
.style10 {
	font-size: 10;
	font-weight: bold;
}
.style12 {
	font-size: 12;
	font-weight: bold;
}
.style14 {
	font-size: 18;
	font-weight: bold;
}
.style16 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
<!--<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.meadroid.com/scriptx/smsx.cab#Version=6,2,433,14">-->
<!--<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/ScriptX.cab" >-->
</object>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소

	
		
	String m_id = "";
	String l_cd = "";
	String c_id = "";
	
	String vid[] = request.getParameterValues("ch_l_cd");
	String vid_num="";

	int vid_size = vid.length;
	
	for(int i=0;i < vid_size;i+=3){

		vid_num 	= vid[i];
		m_id 		= vid[i].substring(0,6);
		l_cd 		= vid[i].substring(6,19);
		c_id 		= vid[i].substring(19);

		Hashtable ht1 = af_db.sklist(m_id, l_cd, c_id);
	
%>
<table width=100% border=0 cellspacing=1 cellpadding=0>   
	<tr>
		<td width="33%" align="center" valign="middle" height=112>
			<table width="100%" border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td height="25" align="left" class="style14">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=ht1.get("CAR_DOC_NO")%></td>
				</tr>
				<tr>
					<td height="25" align="left" class="style16">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=ht1.get("CAR_NO")%></td>
				</tr>
				<tr>
					<td height="25" align="left" class="style12">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=ht1.get("FIRM_NM")%></td>
				</tr>
			</table>
		</td>   
		<td width="33%" align="center" valign="middle">
<%if(i+1 < vid_size){
		vid_num 	= vid[i+1];
		m_id 		= vid[i+1].substring(0,6);
		l_cd 		= vid[i+1].substring(6,19);
		c_id 		= vid[i+1].substring(19);
		Hashtable ht2 = new Hashtable();
		ht2 = af_db.sklist(m_id, l_cd, c_id);
%> 
			<table width="100%" border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td height="25" align="left" class="style14">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=ht2.get("CAR_DOC_NO")%></td>
				</tr>
				<tr>
					<td height="25" align="left" class="style16">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=ht2.get("CAR_NO")%></td>
				</tr>
				<tr>
					<td height="25" align="left" class="style12">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=ht2.get("FIRM_NM")%></td>
				</tr>
			</table>
<%}%>
		</td>

		<td width="33%" align="center" valign="middle">

<%	if(i+2 < vid_size){
		vid_num 	= vid[i+2];
		m_id 		= vid[i+2].substring(0,6);
		l_cd 		= vid[i+2].substring(6,19);
		c_id 		= vid[i+2].substring(19);
		Hashtable ht3 = new Hashtable();
		ht3 = af_db.sklist(m_id, l_cd, c_id);
%>    
			<table width="100%" border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td height="25" align="left" class="style14">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=ht3.get("CAR_DOC_NO")%></td>
				</tr>
				<tr>
					<td height="25" align="left" class="style16">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=ht3.get("CAR_NO")%></td>
				</tr>
				<tr>
					<td height="25" align="left" class="style12">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=ht3.get("FIRM_NM")%></td>
				</tr>
			</table>
<%}%>
		</td>

	
	</tr>
</table>
<%}%>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 5.0; //좌측여백   
factory.printing.rightMargin = 5.0; //우측여백
factory.printing.topMargin = 12.0; //상단여백    
factory.printing.bottomMargin = 10.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>