<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"2":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
		
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchCarReg();
}
function SearchCarReg()
{
	var theForm = document.CarRegSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function ChangeFocus()
{
	var theForm = document.CarRegSearchForm;
	if(theForm.gubun.value=="init_reg_dt" || theForm.gubun.value=="car_end_dt")
	{
		nm.style.display = 'none';
		dt.style.display = '';
		theForm.ref_dt1.value = "";
		theForm.ref_dt2.value = "";
		theForm.ref_dt1.focus();
		if(theForm.gubun.value=="init_reg_dt") 	theForm.q_sort_nm[3].selected = true;
		if(theForm.gubun.value=="car_end_dt") 	theForm.q_sort_nm[4].selected = true;
		
	}else{
		nm.style.display = '';
		dt.style.display = 'none';
		theForm.gubun_nm.value = "";
		theForm.gubun_nm.focus();
	}
}
function ChangeDT(arg)
{
	var theForm = document.CarRegSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 협력업체관리 > <span class=style5>아마존카차량조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>	
	<form action="./amazoncar_list_sc.jsp" name="CarRegSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>	
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
            	<tr>
            		<td width=17%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
            			<select name="gubun" onChange="javascript:ChangeFocus()">
            				<option value="car_no" 		<%if(gubun.equals("car_no"))%> 		selected<%%>>차량번호</option>
            				<option value="car_nm" 		<%if(gubun.equals("car_nm"))%> 		selected<%%>>차명</option>
            				<option value="init_reg_dt" <%if(gubun.equals("init_reg_dt"))%> selected<%%>>등록일</option>
            				<option value="car_end_dt"  <%if(gubun.equals("car_end_dt"))%>  selected<%%>>차령만료일</option>							
            				<option value="car_ext" 	<%if(gubun.equals("car_ext"))%> 	selected<%%>>등록지역</option>
            				<option value="fuel_kd" 	<%if(gubun.equals("fuel_kd"))%> 	selected<%%>>연료</option>
            			</select>
            		</td>
            		<td id="nm" width=17% style="display:''"><input type="text" name="gubun_nm" size="22" value="<%=gubun_nm%>" class=text onKeydown="javascript:EnterDown()"></td>
            		<td id="dt" width="17%" style='display:none'><input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class=text onBlur="javascript:ChangeDT('ref_dt1')"> ~ <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class=text onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javascript:EnterDown()"></td>
					<td width=13%><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;
                    <select name="q_sort_nm">
                      <option value="car_no" 		<%if(q_sort_nm.equals("car_no"))%> 	selected<%%>>차량번호</option>
                      <option value="car_nm" 		<%if(q_sort_nm.equals("car_nm"))%> 	selected<%%>>차명</option>                      
                      <option value="init_reg_dt" <%if(q_sort_nm.equals("init_reg_dt"))%> selected<%%>>등록일</option>
                      <option value="car_end_dt"  <%if(q_sort_nm.equals("car_end_dt"))%> selected<%%>>차령만료일</option>
                      <option value="car_ext" 	<%if(q_sort_nm.equals("car_ext"))%> 	selected<%%>>등록지역</option>
                    </select></td>
            	  <td width=17%><input type="radio" name="q_sort" value=""     <%if(q_sort.equals(""))%> checked<%%>>
            	    오름차순
                      <input type="radio" name="q_sort" value="desc" <%if(q_sort.equals("desc"))%> checked<%%>>
                    내림차순</td>
            	  <td><a href="javascript:SearchCarReg()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
				</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>
