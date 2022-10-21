<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchs(); //영업소 리스트 조회
	int brch_size = branches.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="issue_stop_sc.jsp";
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
<body onload="javascript:document.form1.end_dt.focus()">
<form action="" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_url" value="/tax/scd_mng/scd_mng_sc.jsp">      
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > <span class=style5>
						발행중지스케줄</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	

    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_bhyji.gif" align=absmiddle>&nbsp; 
        <input type="text" name="st_dt" size="4" value="<%=st_dt%>" class="text">년
		<input type="text" name="end_dt" size="2" value="<%=end_dt%>" class="text" onKeyDown="javasript:enter()">월
	    &nbsp;&nbsp;
		<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
      </td>
      <td align="right"><img src="/acar/images/center/arrow_yus.gif" align=absmiddle>&nbsp; 
        <select name='s_br' onChange='javascript:Search();'>
          <option value=''>전체</option>
          <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> <%= branch.get("BR_NM")%> </option>
          <%							}
						}		%>
        </select>
		   &nbsp;&nbsp;&nbsp; 
	  </td>	  
    </tr>	
  </table>
</form>
</body>
</html>
