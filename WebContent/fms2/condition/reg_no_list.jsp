<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.inside_bank.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지

	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
      
	
	String hidden_value = "";
				

	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd;

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈


%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;			
		fm.submit();
	}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
			
		
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='reg_no_list.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type='hidden' name='s_kd' value='1'>    

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="search-area">

  <tr> 
		<td colspan=6 style="height: 30px">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td class="navigation">&nbsp;<span class=style1>현황 및 통계 > 차량관리 > <span class=style5>미등록현황</span></span></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan=6  class=h></td>
	</tr>
		
	<tr>
		<td colspan=6  class=h></td>
	</tr>	

    <tr> 
        <td align=right>                               	     
		    &nbsp;<input type="button" class="button" value="검색" onclick="javascript:search();"> 
		   &nbsp; </td>		 
    
    </tr>
   
    <tr></tr><tr></tr><tr></tr>
    	
       
    <tr>
		<td colspan=6>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./reg_no_list_s.jsp<%=hidden_value%>" name="ii_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>