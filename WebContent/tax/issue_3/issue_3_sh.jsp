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
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		fm.go_target.value = "d_content";
		<%if(!gubun1.equals("1")){%>
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		<%}%>
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=700,height=450,left=50,top=50');		
		<%if(gubun1.equals("7")){%>
		fm.action = "../pop_search/s_cont.jsp";		
		<%}else{%>
		fm.action = "../pop_search/s_client.jsp";		
		<%}%>		
		fm.target = "search_open";
		fm.submit();		
	}
	function Search(){
		var fm = document.form1;
		fm.action="issue_3_est<%=gubun1%>.jsp";
		fm.target="c_foot";		
		fm.submit();
	}	
//-->
</script>

</head>
<body onload="javascript:document.form1.t_wd.focus()">
<form action="" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">   
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_url" value="/tax/issue_3/issue_3_sc<%=gubun1%>.jsp">      
  <input type="hidden" name="go_target" value="">        
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 세금계산서발행 > 수시발행 > <span class=style5>
						<%if(gubun1.equals("1")){%>선수금<%}else if(gubun1.equals("2")){%>단기대여<%}else if(gubun1.equals("3")){%>매각<%}else if(gubun1.equals("4")){%>면책금<%}else if(gubun1.equals("5")){%>대차료<%}else if(gubun1.equals("6")){%>휴차료<%}else if(gubun1.equals("9")){%>대차료<%}else if(gubun1.equals("7")){%>해지정산금<%}%></span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>    	
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_search.gif" align=absmiddle>&nbsp; 
        <select name="s_kd">
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
      </select>
	  &nbsp;<input type="text" name="t_wd" size="20" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()" style='IME-MODE: active'>
	  
	  &nbsp;<a href="javascript:SearchopenBrWindow()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>
      </td>
      <td align="right">
      <%if(gubun1.equals("1")){%>
        <img src="/acar/images/center/arrow_g.gif" align=absmiddle>&nbsp;      
        <select name='gubun2'>
          <option value=''>전체</option>
          <option value='1'  <%if(gubun2.equals("1")){%>selected<%}%>> 선납금 </option>
          <option value='2'  <%if(gubun2.equals("2")){%>selected<%}%>> 개시대여료 </option>
          <option value='5'  <%if(gubun2.equals("5")){%>selected<%}%>> 승계수수료 </option>
        </select>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <%} %>
        <img src="/acar/images/center/arrow_yus.gif" align=absmiddle>&nbsp; 
        <select name='s_br'>
          <option value=''>전체</option>
          <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> <%= branch.get("BR_NM")%> </option>
          <%							}
						}		%>
        </select>     
        &nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>   
      &nbsp;&nbsp;&nbsp; </td>
    </tr>
  </table>
</form>
</body>
</html>