<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>최고서발송대장 레이블 출력화면</title>
<script>
<!--


//-->
</script>


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
</object>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소

	
	
	
	String doc_id = "";
	
	String vid[] = request.getParameterValues("ch_l_cd");
	String vid2[] = request.getParameterValues("ch_doc_id");
	String vid3[] = request.getParameterValues("ch_cnt");
	String vid_num="";

	int vid_size = vid.length;

	
	for(int i=0;i < vid_size;i+=2){
		//1번칸
		vid_num 	= vid[i];
		doc_id 		= vid2[AddUtil.parseInt(vid_num)];
		FineDocBean fine = FineDocDb.getFineDoc(doc_id);
		
		
%>
<table width=100% border=0 cellspacing=0 cellpadding=0 style="padding-left:150px;">   
  <tr>
		<td width="30%" align="center" valign="top">

 	<table width="100%" height="" border=0 cellpadding=0 cellspacing=1 >
	    <tr valign="bottom">
	        <td width="80%"  height="50" colspan="2"  class="style14">(<%=fine.getGov_zip()%>)</td>
	    </tr>
        <tr valign="bottom">
	        <td height="50" colspan="3" class="style14"><%=fine.getGov_addr()%></td>
        </tr>
        <tr valign="middle">
          <td height="40" colspan="3" class="style14">
          	<%=fine.getGov_nm()%>&nbsp;<%=fine.getMng_dept()%>
          <!-- 	<input type="text" value="귀하" class="style14" style="border:0px;width:50px;"> -->
           		귀하
          </td>
        </tr>
        <tr valign="middle">
          <td width="" >&nbsp;</td>																	
			  </tr>
      </table>  
      
      <%--  	<table width="100%" height="" border=0 cellpadding=0 cellspacing=1 >
        <tr valign="bottom">
          <td height="50" colspan="3" align="center" class="style14"><%=fine.getGov_addr()%></td>
        </tr>
        <tr valign="middle">
          <td height="40" colspan="3" align="center" class="style14"><%=fine.getGov_nm()%>&nbsp;<%=fine.getMng_dept()%></td>
        </tr>
        <tr valign="middle">
          <td width="80%"  height="50" colspan="2" align="right" valign="top" class="style14"><%=fine.getGov_zip()%>&nbsp;</td>
          <td width="" >&nbsp;</td>																	
			  </tr>
      </table>  --%>
    </td>
<%	//2번칸
		if(i+1 < vid_size){
			vid_num 	= vid[i+1];
			doc_id 		= vid2[AddUtil.parseInt(vid_num)];
			fine = FineDocDb.getFineDoc(doc_id);
%>    
		<td width="30%" align="center" valign="top">
		  <table width="100%" height="" border=0 cellpadding=0 cellspacing=1 >
	    <tr valign="bottom">
	        <td width="80%"  height="50" colspan="2"  class="style14">(<%=fine.getGov_zip()%>)</td>
	    </tr>
        <tr valign="bottom">
	        <td height="50" colspan="3" class="style14"><%=fine.getGov_addr()%></td>
        </tr>
        <tr valign="middle">
          <td height="40" colspan="3" class="style14">
          	<%=fine.getGov_nm()%>&nbsp;<%=fine.getMng_dept()%>
          	<!-- <input type="text" value="귀하" class="style14" style="border:0px;width:50px;"> -->
          	귀하
          </td>
        </tr>
        <tr valign="middle">
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
      <table width="100%" height="" border=0 cellpadding=0 cellspacing=1 >
	    <tr valign="bottom">
	        <td width="80%"  height="50" colspan="2"  class="style14">&nbsp;</td>
	    </tr>
        <tr valign="bottom">
	        <td height="50" colspan="3" class="style14">&nbsp;</td>
        </tr>
        <tr valign="middle">
          <td height="40" colspan="3" class="style14">
          </td>
        </tr>
        <tr valign="middle">
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
factory.printing.bottomMargin = 16.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>