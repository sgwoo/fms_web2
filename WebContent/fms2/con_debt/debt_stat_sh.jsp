<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "13", "01");
	
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	
	//int year =AddUtil.getDate2(1);
	int year =2022;

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

var delay = 2000;
var submitted = false;

function submitCheck() {

  if(submitted == true) { return; }

  document.form1.srch.value = '검색중';
  document.form1.srch.disabled = true;
  
  setTimeout ('search()', delay);
  
  submitted = true;
}

function submitInit() {

	  document.form1.srch.value = '검색';
	  document.form1.srch.disabled = false;
	   
	  submitted = false;
	}


  //검색하기
	function search(){
		var fm = document.form1;		
	
	//	var link = document.getElementById("submitLink");
	   
	//	var originFunc = link.getAttribute("href");
	//	link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");			
		
		fm.action = 'debt_stat_sc.jsp';
		fm.first.value = 'N';
		fm.target='c_foot';
		fm.submit();
		
	//	link.getAttribute('href',originFunc);
	}
		
	function enter(){
		var keyValue = event.keyCode;
	//	if (keyValue =='13') search();
	}	
	
	
//-->
</script>
</head>
<body leftmargin="15" >
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='work_st' value=''>
<input type='hidden' name='first'>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 자산관리 > <span class=style5>
						상각관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>

  <tr> 
     <td width="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_yd.gif" align=absmiddle >&nbsp;
              <select name="gubun1">
              	
                <%for(int i=2021; i<=year; i++){%>
                <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                <%}%>
              </select>              
			  &nbsp;&nbsp;	
	 
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="srch" value="검색" onclick="submitCheck();">  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="init" value="버튼초기화" onclick="submitInit();">  
     <!--  <a id="submitLink" href="javascript:search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>   -->    
      
      </td>

 </tr>
   
</form> 
</table>
</body>
</html>

