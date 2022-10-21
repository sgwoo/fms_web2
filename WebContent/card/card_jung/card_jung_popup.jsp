<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		fm.work_st.value = work_st;
		fm.target = 'i_no';
		fm.action = 'card_jung_reg_a.jsp';
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
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int year =AddUtil.getDate2(1);

%>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>복리후생비관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td></td></tr>
	<tr><td class=line2></td></tr>
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td width='25%' class='title'>정산 기준</td>
		  <td width="75%">
              &nbsp;&nbsp;<select name="s_year">
                <%for(int i=2021; i<=year; i++){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                <%}%>
              </select>
              <select name="s_month">
                <%for(int i=1; i<=12; i++){%>
                   <option value="<%=i%>" <%if(s_month == i){%>selected<%}%>><%=i%>월</option>
                <%}%>
              </select>
    
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>  
  <tr>
	<td align=right><a href="javascript:save('card_jung')"><img src=/acar/images/center/button_jungs_br.gif align=absmiddle border=0></a>&nbsp;</td>
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
