<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String jj_gub = "";
	String bs_gub = "";
	String asc = "";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function search()
{
	var theForm = document.from1;
	theForm.target = "c_foot";
	theForm.submit();
}
function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="ref_dt1")
		{
		theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
		}else if(arg=="ref_dt2"){
		theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
		}
	
	}	
//-->
</script>
</head>
<body>
<form action="closeday_sc.jsp" name="from1" method="POST" target="c_foot">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1> 인사관리 > 근태관리 > <span class=style5>연차시 업무관련 중식대 신청</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" class=h ></td>
	</tr>
	<tr>
		  <input type="hidden" name="gubun" value="" >
		<td width="30%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;
	      <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
	      당월 &nbsp;
	      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
	      월별 &nbsp;
			<select name="st_year">
				<%for(int i=2009; i<=year; i++){%>
				<option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
				<%}%>
			</select> 
			<select name="st_mon">
				<%for(int i=1; i<=12; i++){%>
				<option value="<%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>월</option>
				<%}%>
			</select>
		</td>
		<td width="30%">
			<input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
	      조회기간  <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
			~ 
			<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" >		
		</td>
		<td width="28%"><a href="javascript:search();"><img src="/acar/images/center/button_search.gif" border="0" align=absmiddle></a></td>
	</tr>
	<!--
	<tr>
		<td>재직구분 : <select name="jj_gub">
				<option value="1" selected >재직자</option>
				<option value="2" >퇴직자</option>
				<option value="3" >전체</option>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
		<td>
			부서구분 : <select name="bs_gub">
				<option value="1" selected >전체</option>
				<option value="2" >영업팀</option>
				<option value="3" >고객지원팀</option>
				<option value="4" >총무팀</option>
				<option value="5" >부산지점</option>
				<option value="6" >대전지점</option>
				<option value="7" >팀장이상</option>
				<option value="8" >입사일자</option>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
		<td>
			정렬구분 : <select name="asc">
			<option value="1" selected >입사일자순</option>
			<option value="2" >생년월일순</option>
			<option value="3" >성별순</option>
			<option value="4" >직급순</option>
			<option value="5" >성명순</option>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr> -->
</table>
</form>
</body>
</html>  