<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st, s_type)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		fm.mode.value 	= work_st;
		fm.s_type.value = s_type;	
		
		fm.target = 'i_no';		
		fm.action = 'set_end_popup_a.jsp';
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
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
			
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int year =AddUtil.getDate2(1);

%>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='s_type' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>Master > <span class=style5>마감관리</span></span></td>
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
    		  <td width='22%' class='title'>등록 기준</td>
    		  <td>
                  &nbsp;<select name="s_year">
                    <%for(int i=2013; i<=year; i++){%>
                    <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                    <%}%>
                  </select>
              
                  <select name="s_month">
                     <option value="1" >1분기</option>
                     <option value="2" >2분기</option>
                     <option value="3" selected >3분기</option>
                     <option value="4" >4분기</option>
              
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
	<td>&nbsp;</td>
  </tr>
  
  <tr>
	<td>
	<% if (mode.equals("12")) { %> 영업캠페인지급 <% } %>
	<% if (mode.equals("13")) { %> 채권캠페인지급 <% } %>
	<% if (mode.equals("25")) { %> 비용(1군-정비)캠페인지급 <% } %>
	<% if (mode.equals("28")) { %> 비용(1군-사고)캠페인지급 <% } %>
	<% if (mode.equals("29")) { %> 비용(2군)캠페인지급 <% } %>
	<% if (mode.equals("30")) { %> 비용(1군)캠페인지급 <% } %>
	<% if (mode.equals("26")) { %> 제안캠페인지급 <% } %>	
	<% if (mode.equals("27")) { %> 관리대수분기마감 <% } %>		
	<a href="javascript:save('<%=mode%>', '1')"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a></td>
  </tr>
  
  <tr>
	<td>
	<% if (mode.equals("12")) { %> 영업캠페인실적 <% } %>
	<% if (mode.equals("13")) { %> 채권캠페인실적 <% } %>
	<% if (mode.equals("25")) { %> 비용(1군-정비)캠페인실적 <% } %>
	<% if (mode.equals("28")) { %> 비용(1군-사고)캠페인실적 <% } %>
	<% if (mode.equals("29")) { %> 비용(2군)캠페인실적 <% } %>
	<% if (mode.equals("30")) { %> 비용(1군)캠페인실적 <% } %>
	<% if (mode.equals("26")) { %> 제안캠페인실적 <% } %>	
	<a href="javascript:save('<%=mode%>', '2')"><% if (!mode.equals("27")) { %><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"><% } %></a></td>
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
