<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocBn2" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>대차료 청구 보험사 레이블 출력화면</title>
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
	font-size: 14;
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
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
<!--<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.meadroid.com/scriptx/smsx.cab#Version=6,2,433,14">-->
<!--<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/ScriptX.cab" >-->
</object>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	
	
	String doc_id = "";
	
		
	String vid[] = request.getParameterValues("ch_l_cd");
	String vid_num="";
	
	int vid_size = vid.length;
	
	for(int i=0;i < vid_size;i+=2){
		vid_num 	= vid[i];
		doc_id 		= vid[i].substring(0,12);
		
		FineDocBn = FineDocDb.getFineDoc(doc_id);
%>
<table width=100% border=0 cellspacing=0 cellpadding=0>   
  <tr>
		<td width="30%" align="center" valign="top">

			<table width="100%" height="" border=0 cellpadding=0 cellspacing=1 >
        <tr valign="middle">
          <td height="50" colspan="3" align="center" class="style14"><%=FineDocBn.getGov_addr()%></td>
        </tr>
        <tr valign="middle">
          <td height="40" colspan="3" align="center" class="style14"><%=FineDocBn.getGov_nm()%>&nbsp;<%=FineDocBn.getMng_dept()%>&nbsp;<%=FineDocBn.getMng_nm()%></td>
        </tr>
        <tr valign="middle">
          <td width="80%"  height="50" colspan="2" align="right" class="style14"><%=FineDocBn.getGov_zip()%>&nbsp;</td>
          <td width="" >&nbsp;</td>																	
			  </tr>
      </table>
    </td>
<%
	if(i+1 < vid_size){
		vid_num 	= vid[i+1];
		doc_id 		= vid[i+1].substring(0,12);
		FineDocBn2 = FineDocDb.getFineDoc(doc_id);
%>    
		<td width="30%" align="center" valign="top">
		  <table width="100%" height="" border=0 cellpadding=0 cellspacing=1 >
				<tr valign="middle">
          <td height="50" colspan="3" align="center" class="style14"><%=FineDocBn2.getGov_addr()%></td>
        </tr>
        <tr valign="middle">
          <td height="40" colspan="3" align="center" class="style14"><%=FineDocBn2.getGov_nm()%>&nbsp;<%=FineDocBn2.getMng_dept()%>&nbsp;<%=FineDocBn2.getMng_nm()%></td>
        </tr>
        <tr valign="middle">
          <td width="80%"  height="50" colspan="2" align="right" class="style14"><%=FineDocBn2.getGov_zip()%>&nbsp;</td>
          <td width="" >&nbsp;</td>
		    </tr>
      </table>
    </td>
<%}else{%>
		<td width="30%" align="center" valign="top">
		  <table width="100%" height="" border=0 cellpadding=0 cellspacing=1 >
				<tr valign="middle">
          <td height="50" colspan="3" align="center" class="style14">&nbsp;</td>
        </tr>
        <tr valign="middle">
          <td height="40" colspan="3" align="center" class="style14">&nbsp;</td>
        </tr>
        <tr valign="middle">
          <td width="80%"  height="50" colspan="2" align="right" class="style14">&nbsp;</td>
          <td width="" >&nbsp;</td>
		    </tr>
      </table>
    </td>
<%}%>
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
factory.printing.topMargin = 14.0; //상단여백    
factory.printing.bottomMargin = 14.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>