<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %> 


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	
	 int base_year = Integer.parseInt(sysdate.substring(0,4))-1;
	 
%>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="/include/common.js"></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script>
	function Search(){
		var fm = document.form1;
		if(fm.t_wd.value || fm.base_year.value ){
			if(fm.s_kd.value == '2'){
				window.open("about:blank", "SEARCH", "left=600, top=50, width=600, height=600, scrollbars=yes");
				fm.action = "ins_emp_search.jsp";		
				fm.target = "SEARCH";
				fm.submit();		
			}else{
				fm.action="ins_emp_sc.jsp";
				fm.target="c_foot";		
				fm.submit();
			}
		}else{
			alert("검색어를 입력하시기 바랍니다.");
			return;
		}
		
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
	
	function gubun2Change(val){
		 if(val == '완료'){
			var fm = document.form1;
			fm.gubun3.value = '기간';
			skdChange(fm.gubun3.value);
		} 
	}
	
	function skdChange(val){
		 if(val == '기간'){
			var date = new Date();
            date.setDate(1);
			var fm = document.form1;
			fm.st_dt.value = getFormatDate(date);
			fm.end_dt.value = getFormatDate(new Date());
		} 
	}
	
	function getFormatDate(date){
		var year = date.getFullYear();                 
		var month = (1 + date.getMonth());             
		month = month >= 10 ? month : '0' + month;     
		var day = date.getDate();                      
		day = day >= 10 ? day : '0' + day;             
		return  year + '' + month + '' + day;
	}
	
	
	
</script>
</head>

<body>
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 ><span class=style5>고객피보험산출요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
</table>
<div class="search-area" >
	<%-- &nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> 기준연도 </label>
	<input type="text" name="base_year" size="10"  value="<%=base_year%>" class="text" maxlength="4">
	&nbsp;&nbsp; --%>
	<label><i class="fa fa-check-circle"></i> 검색조건 </label>
	<select id="s_kd" name="s_kd" class="select"  align=absmiddle style="width:100px;">
		<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>고객</option>
		<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>차량번호</option>
		<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>사업자번호</option>
	</select>
	&nbsp;
	<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	&nbsp;&nbsp;
	<input type="button" class="button" value="검색" onclick="Search()"/>
	</div>

</form>
</body>
</html>