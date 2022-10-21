<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%

    String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
   
    String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
		
	int cnt = 3; //현황 출력 총수
	//int sh_height = cnt*sh_line_height;
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//리스트 엑셀 전환
function pop_excel(dt, ref_dt1, ref_dt2){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_card_excel.jsp?dt="+ dt + "&ref_dt1=" + ref_dt1+ "&ref_dt2=" + ref_dt2;
	fm.submit();
}	
//중식대만 정산
function pop_excel_js(dt, ref_dt1, ref_dt2){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_card_excel_js.jsp?dt="+ dt + "&ref_dt1=" + ref_dt1+ "&ref_dt2=" + ref_dt2;
	fm.submit();
}	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td align='center' width='100%'><font size='5'> </font></td>
    </tr>	
	
    <tr>
    	<td width='100%'>※ 특별비(장기근속포상금, 코로나19방역비 등)</td>    	
    </tr>
     <tr>
    	<td width='100%'>※ 팀장이상의 중식비, 팀장활동비는 정산제외</td>    	
    </tr>
    <tr>
    	<td width='100%' align=right>※ 기간 : <%=s_yy%>년 <%if(dt.equals("2")){%>1월 ~ 6월 까지<%}else if(dt.equals("5")){%>7월 ~ 12월 까지<%}else{%>1월 ~ 12월 까지 <%}%></td>
    </tr>
    <tr>
        <td><iframe src="jungsan_sc_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&dept_id=<%=dept_id%>&br_id=<%=br_id%>&user_nm=<%=user_nm%>&s_yy=<%=s_yy%>&sh_height=<%=sh_height%>" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
     </tr>
    <tr>
        <td class=h></td>
    </tr>
    
</table>
 
 
</form>
</body>
</html>
