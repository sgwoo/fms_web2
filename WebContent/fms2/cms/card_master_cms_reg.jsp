<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function saveCms()
	{
		var fm = document.form1;
		
		if(fm.adate.value == ""){ alert("신청일자를 확인하십시오."); return; }					
		
		if(toInt(fm.no_cnt.value) > 0){ alert("데이타를 확인하십시오."); return; }			
		
		if(confirm('해당 카드CMS고객데이타를 생성하시겠습니까?'))
		{		
			fm.target = 'i_no';
			
		//	fm.action='http://cms.amazoncar.co.kr:8080/acar/admin/card_master_cms_reg_a.jsp';
			fm.action='card_master_cms_reg_a.jsp';
			fm.submit();
		}
	}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈	

%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='no_cnt' >

<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1"></span>
</div>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	
	<tr>
		<td class=h></td>
	</tr>  	
  
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
	   	<tr><td class=line2></td></tr>
		<tr>
		  <td width='13%' class='title'>신청일자</td>		  
		  <td width='87%' >&nbsp;
			  <input type="text" name="adate" value="<%=AddUtil.getDate()%>" size="12" maxlength='12' class='default' onBlur='javascript:this.value=ChangeDate(this.value)'>
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
  <% if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
  	
  <tr>
	<td align='right'><a href="javascript:saveCms()"><img src=/acar/images/center/button_reg.gif border=0></a></td>
  </tr>
  <% } %>
  <tr>
	<td><hr></td>
  </tr>
  <tr> 
 	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>생성내역조회</span></td>
  </tr>  
 
 
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%> 
		  <tr>
			<td>
			  <iframe src="card_master_cms_print.jsp" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
			</td>
		  </tr>
		</table>
	  </td>
  </tr>

</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>