<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

    String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
   
    String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
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
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
	    <td align='right' width=100%'>&nbsp;&nbsp;
    <% if ( nm_db.getWorkAuthUser("임원",ck_acar_id) ||  nm_db.getWorkAuthUser("전산팀",ck_acar_id)) {	%>	
	<a href="javascript:pop_excel_js('<%=dt%>','<%=ref_dt1%>', '<%=ref_dt2%>' );"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>
	<% }	%>
	    </td>
    </tr>	
    <tr>
     <td><font color=red>***</font>&nbsp;정산차액은 <font color=red>중식대포함</font>하여 본인이 사용가능한 한도내 잔액입니다.  복지비기준액은 유류대정산분을 반영한 금액입니다. 항상 예산범위를 지켜서 정산액이 (-)가 나오지 않도록 주의하세요. </td>
	<tr>
	
	</tr>
    <tr>
        <td><iframe src="card_jung_s2_all_in.jsp?auth_rw=<%=auth_rw%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&dept_id=<%=dept_id%>&br_id=<%=br_id%>&user_nm=<%=user_nm%>" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
     </tr>
    <tr>
        <td class=h></td>
    </tr>
<!--    	
    <tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td valign=top><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>중식대 정산</span></td>
                    <td valign=top><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>복지비 정산</span></td>
                </tr>
                <tr>
        
                    <td>
                    &nbsp;&nbsp;&nbsp;&nbsp;1. 기준금액 이하 지출 : 차액을 익월 급여에 포함하여 지급<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;2. 기준금액 이상 지출 : 차액을 익월 급여에서 공제       
                    </td>
                    <td>
                    &nbsp;&nbsp;&nbsp;&nbsp;1. 기준금액 이하 지출 : 차액을 년이월하여 관리 <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;2. 기준금액 이상 지출 : 차액을 익월분(1월분) 급여에서 공제                   
                    </td>
                   
                </tr>
            </table>
        </td>
    </tr>
-->     
</table>
 
 
</form>
</body>
</html>
