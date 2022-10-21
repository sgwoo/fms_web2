<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="ins_b_sc_in.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}
	
	//디스플레이 타입(검색) - 조회기간 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //월별
			td_gubun2_1.style.display	= '';
			td_gubun2_2.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //입력
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= '';
			fm.st_dt.value = '';
			fm.end_dt.value = '';
			fm.st_dt.focus();
		}else{
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= 'none';
		}
	}	
	
	//등록사유 디스플레이
	function change_type()
	{
		var fm = document.form1;
		drop_type();
		fm.gubun4.options[0] = new Option('전체', '');		
		if(fm.gubun3.value == '1'){
			fm.gubun4.options[1] = new Option('신차', '1');
			fm.gubun4.options[2] = new Option('용도변경', '2');
		}else if(fm.gubun3.value == '2'){
			fm.gubun4.options[1] = new Option('만기', '4');
			fm.gubun4.options[2] = new Option('담보변경', '3');
		}else if(fm.gubun3.value == '3'){
			fm.gubun4.options[1] = new Option('R->L', '1');
			fm.gubun4.options[2] = new Option('L->R', '2');
			fm.gubun4.options[3] = new Option('매각', '3');
			fm.gubun4.options[4] = new Option('말소', '4');						
			fm.gubun4.options[5] = new Option('폐차', '5');			
		}else if(fm.gubun3.value == '5'){
			fm.gubun4.options[1] = new Option('신차', '1');
			fm.gubun4.options[2] = new Option('갱신', '3');
			fm.gubun4.options[3] = new Option('용도변경', '2');
		}else if(fm.gubun3.value == '6'){
			fm.gubun4.options[1] = new Option('용도변경', '1');
			fm.gubun4.options[2] = new Option('매각', '2');
		}
	}	
	function drop_type()
	{
		var fm = document.form1;
		var len = fm.gubun4.length;
		for(var i = 0 ; i < len ; i++){
			fm.gubun4.options[len-(i+1)] = null;
		}
	}			
	//검색하기
	function ins_double(){
		window.open("ins_double.jsp", "double", "left=100, top=100, width=800, height=600, scrollbars=yes");
	}
	
//-->
</script>
</head>
<body>
<%
String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
		
	
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<form action="./ins_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > <span class=style5>보험변경조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  <tr> 
      <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
			  			<input type="radio" name="dt" value="0" <%if(dt.equals("0"))%>checked<%%>>
              전일  
              <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
              당일 
              <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
              당월 
              <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
              당해 
              <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
              조회기간
			  &nbsp;&nbsp;
				<input type="text" name="st_dt" size="11" value="<%=st_dt%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
              ~ 
              <input type="text" name="end_dt" size="11" value="<%=end_dt%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
			  
			  &nbsp;&nbsp;&nbsp;<a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>	
	  
    </tr>  
</table>
</form>
</body>
</html>