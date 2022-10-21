<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//전표생성
function make_autodocu(s_year, s_mon, s_kd, t_wd){
		
	var fm = document.form1;
		
	if ( s_kd== '3' && t_wd != ""  ) {
	}
	else {
	    alert("전표를 생성할 수 없습니다. !!!");
		return;
	}  
		
	if(!confirm('자동전표를 생성하시겠습니까?')){	return;	}
						
	fm.target = "i_no";
	fm.action = "cus_samt_reg_autodoc_a.jsp?s_year=" + s_year+ "&s_mon=" + s_mon+ "&s_kd=" + s_kd+ "&t_wd=" + t_wd;
	fm.submit();  

}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
		
	String acct_dt =  AddUtil.getDate();	
	
%>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='acct' value='<%=acct%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>협력업체 > <span class=style5>정비비정산관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
	    <td class='line'>
    	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		<tr>
    		  <td width='22%' class='title'>전표생성일</td>
    		  <td>
                  <input type="text" name="acct_dt" value="<%=acct_dt%>" size="10" class=text >
    		  </td>
    		</tr>
    	  </table>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  

  <tr>
	<td>	
	<a href="javascript:make_autodocu('<%=s_year%>', '<%=s_mon%>', '<%=s_kd%>', '<%=t_wd%>');"><img src=../images/center/button_jpss.gif align=absmiddle border=0></a>
	
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
