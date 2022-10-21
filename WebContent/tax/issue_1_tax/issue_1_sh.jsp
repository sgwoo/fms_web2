<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>


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
		fm.action="issue_1_sc.jsp";
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
<form action="./issue_1_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="s_br" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > <span class=style5>
						대여료정기발행</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>   	  	    
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" align=absmiddle>&nbsp; 
        <select name="gubun1" >
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>발행예정일</option>
          <option value="3" <%if(gubun1.equals("3")){%> selected <%}%>>세금일자  </option>          
        </select>	
		    <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur='javscript:this.value = ChangeDate(this.value);'>
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur='javscript:this.value = ChangeDate(this.value);'>		  
      </td>      
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr> 
      <td width="45%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp; 
        <select name="s_kd" onChange="javascript:cng_input3()">
          <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>계약번호</option>
          <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>차량번호</option>		  		  
          <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>거래명세서번호</option>
		      <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>미청구건</option>
		      <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>중지건</option>
        </select>&nbsp;&nbsp;&nbsp;
	      <input type="text" name="t_wd1" size="12" value="<%=t_wd1%>" class="text" onKeyDown="javasript:enter()">
	      OR
	  	  <input type="text" name="t_wd2" size="12" value="<%=t_wd2%>" class="text" onKeyDown="javasript:enter()">
      </td>
      <td width="45%"><img src="/acar/images/center/arrow_jr.gif" align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp; 
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>발행예정일</option>		  
          <option value="4" <%if(sort.equals("4")){%> selected <%}%>>세금일자</option>		  
		      <option value="5" <%if(sort.equals("5")){%> selected <%}%>>거래명세서번호</option>		  
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search(3)'>
        오름차순 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search(3)'>
        내림차순 </td>
      <td width="10%" align="right">
      	<a href="javascript:Search();"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;
      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
    </tr>
</table>
</form>
</body>
</html>
