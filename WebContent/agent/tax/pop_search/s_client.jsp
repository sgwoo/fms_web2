<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String app_yn 	= request.getParameter("app_yn")==null?"":request.getParameter("app_yn");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String go_target = request.getParameter("go_target")==null?"":request.getParameter("go_target");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.action='./s_client.jsp';
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	function select(client_id){		
		var fm = document.form1;
		<%if(!go_url.equals("")){%>
		if(fm.go_target.value == 'd_content'){
			opener.parent.location.href = "<%=go_url%><%=hidden_value%>&client_id="+client_id+"&app_yn=<%=app_yn%>";		
		}else{
			opener.parent.c_foot.location.href = "<%=go_url%><%=hidden_value%>&client_id="+client_id;
		}
		<%}else{%>
//		opener.parent.c_foot.location.href = "";
		<%}%>
		this.close();
	}
//-->
</script>
</head>

<body leftmargin="15" topmargin="10" onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' action='' method='post'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='type' value='<%=type%>'>
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
 <input type='hidden' name='go_target' value='<%=go_target%>'>  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> <span class=style5>
						고객 조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	  	
    
    <tr> 
      <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    <select name='s_kd'>
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>대표자</option>		  		  
        </select>
		<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
		<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
      </td>
      <td align='right'>&nbsp;
	  </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="30">연번</td>
            <td class='title' width="70">구분</td>
            <td class='title' width="180">상호</td>
            <td class='title' width="100">대표자</td>
            <td class='title' width="120">사업자등록번호</td>
            <td class='title' width="100">연락처</td>
          </tr>
        </table>
	  </td>
      <td width=17>&nbsp;</td>		
    </tr>
    <tr> 
      <td colspan="2"><iframe src="./s_client_in.jsp?s_br=<%=s_br%>&type=<%=type%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="inner" width="100%" height="250" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>	
    <tr> 
      <td colspan="2" align="center">
      	<a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
      	</td>
    </tr>	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
