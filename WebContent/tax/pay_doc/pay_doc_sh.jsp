<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7'){ //담당자
			fm.t_wd1.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}
		fm.action="pay_doc_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
		
//-->
</script>

</head>
<body>
<form action="" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서 > <span class=style5>
						입금표보관함</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>   	

    <tr> 
      <td>&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" align=absmiddle>&nbsp; 
        <select name="gubun1" >
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>발행일자&nbsp;</option>
        </select>	
		    <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">		  
      </td>
      <td></td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td width="40%"><table width="100%" cellspacing=0 border="0" cellpadding="0">
        <tr>
          <td width="170">&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp; 
              <select name="s_kd" onChange='javascript:cng_input()'>
                <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
                <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>사업자번호</option>
              </select>
          </td>
          <td align='left'>
		  <input type="text" name="t_wd1" size="12" value="<%=t_wd1%>" class="text" onKeyDown="javasript:enter()">
      OR
        <input type="text" name="t_wd2" size="12" value="<%=t_wd2%>" class="text" onKeyDown="javasript:enter()"></td>          
        </tr>
      </table></td>
      <td width="40%"><img src="/acar/images/center/arrow_jr.gif" align=absmiddle>&nbsp;
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>사업자번호</option>
          <option value="5" <%if(sort.equals("5")){%> selected <%}%>>발행일자</option>
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search()'>
        오름차순 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search()'>
        내림차순 </td>
      <td><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>
