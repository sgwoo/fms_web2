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
<title>거래명세서 보관함</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="item_mng_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	function list_print(){
		fm = document.form1;
		window.open("about:blank",'list_print','scrollbars=yes,status=no,resizable=yes,width=1000,height=600,left=50,top=50');
		fm.target = "list_print";
		fm.action = "include_all_doc_print.jsp";
		fm.submit();
	}
//-->
</script>

</head>
<body>
<form action="./client_mng_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서 > <span class=style5>
						거래명세서보관함</span></span></td>
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
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>거래일자&nbsp;</option>
          <option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>작성일자&nbsp;</option>		  
        </select>	
		    <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">		  
      </td>
      <td><img src="/acar/images/center/arrow_yus.gif" align=absmiddle>&nbsp; 
	  	  <%//if(br_id.equals("S1")){%>
        <select name='s_br' onChange='javascript:Search();'>
          <option value=''>전체</option>
          <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> <%= branch.get("BR_NM")%> </option>
          <%							}
						}		%>
        </select>
		    <%//}else{%>
		    <!--
		    <%=c_db.getNameById(br_id,"BRCH")%>
			  <input type="hidden" name="s_br" value="<%=br_id%>">
			  -->
		    <%//}%>			
		    &nbsp;&nbsp;&nbsp; </td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td width="40%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp; 
        <select name="s_kd">
          <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>계약번호</option>
          <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>차량번호</option>
          <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>사업자번호</option>
          <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>일련번호</option>
          <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>거래구분</option>
        </select>
	      <input type="text" name="t_wd1" size="12" value="<%=t_wd1%>" class="text" onKeyDown="javasript:enter()">
	      OR
	  	  <input type="text" name="t_wd2" size="12" value="<%=t_wd2%>" class="text" onKeyDown="javasript:enter()">
      </td>
      <td width="40%"><img src="/acar/images/center/arrow_jr.gif" align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp; 
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(sort.equals("2")){%> selected <%}%>>차량번호</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>사업자번호</option>
          <option value="4" <%if(sort.equals("4")){%> selected <%}%>>일련번호</option>
          <option value="5" <%if(sort.equals("5")){%> selected <%}%>>견적일자</option>
          <option value="6" <%if(sort.equals("6")){%> selected <%}%>>작성일자</option>
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search()'>
        오름차순 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search()'>
        내림차순 </td>
      <td width="10%" align="right"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;<a href="javascript:list_print()"><img src="/acar/images/center/button_print.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
