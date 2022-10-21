<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 		= request.getParameter("st")==null?"3":request.getParameter("st");
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
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
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
	if(theForm.gubun.value=="dlv_dt" || theForm.gubun.value=="init_reg_dt" || theForm.gubun.value=="car_end_dt")
	{
		nm.style.display = 'none';
		dt.style.display = '';
		theForm.ref_dt1.value = "";
		theForm.ref_dt2.value = "";
		theForm.ref_dt1.focus();
		if(theForm.gubun.value=="dlv_dt") 		theForm.q_sort_nm[2].selected = true;
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 자동차관리 > <span class=style5>자동차관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>	
	<form action="./register_sc.jsp" name="CarRegSearchForm" method="POST" target="c_foot">
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
            		<td width=20%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;
            			<select name="st">
            				<option value="2" <%if(st.equals("2"))%> selected<%%>> 등록차량</option>
	            			<option value="3" <%if(st.equals("3"))%> selected<%%>> 미출고차량</option>
	            			<option value="1" <%if(st.equals("1"))%> selected<%%>> 미등록차량</option>
	            			<option value="4" <%if(st.equals("4"))%> selected<%%>> 매각차량</option>
	            			<option value="5" <%if(st.equals("5"))%> selected<%%>> 매입옵션</option>
	            			<option value="6" <%if(st.equals("6"))%> selected<%%>> 폐차</option>
	            			<option value="7" <%if(st.equals("7"))%> selected<%%>> 말소차량</option>							
	            		</select>
            		</td>
            		<td width=15%><img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
            			<select name="gubun" onChange="javascript:ChangeFocus()">
            				<option value="firm_nm" 	<%if(gubun.equals("firm_nm"))%> 	selected<%%>>상호</option>
            				<option value="client_nm" 	<%if(gubun.equals("client_nm"))%> 	selected<%%>>고객명</option>
            				<option value="car_no" 		<%if(gubun.equals("car_no"))%> 		selected<%%>>차량번호</option>
            				<option value="car_doc_no" 	<%if(gubun.equals("car_doc_no"))%> 	selected<%%>>차량관리번호</option>
            				<option value="car_nm" 		<%if(gubun.equals("car_nm"))%> 		selected<%%>>차명</option>
            				<option value="car_num" 	<%if(gubun.equals("car_num"))%> 	selected<%%>>차대번호</option>
            				<option value="dlv_dt" 		<%if(gubun.equals("dlv_dt"))%> 		selected<%%>>출고일</option>
            				<option value="init_reg_dt" <%if(gubun.equals("init_reg_dt"))%>	selected<%%>>등록일</option>
            				<option value="car_end_dt"  <%if(gubun.equals("car_end_dt"))%> 	selected<%%>>차령만료일</option>							
            				<option value="brch_id" 	<%if(gubun.equals("brch_id"))%> 	selected<%%>>영업소코드</option>
            				<option value="car_ext" 	<%if(gubun.equals("car_ext"))%> 	selected<%%>>등록지역</option>
            				<option value="rent_l_cd" 	<%if(gubun.equals("rent_l_cd"))%> 	selected<%%>>계약번호</option>
            				<option value="emp_nm" 		<%if(gubun.equals("emp_nm"))%> 		selected<%%>>출고영업소</option>
            				<option value="rpt_no" 		<%if(gubun.equals("rpt_no"))%> 		selected<%%>>계출번호</option>							
            				<option value="fuel_kd" 	<%if(gubun.equals("fuel_kd"))%> 	selected<%%>>연료</option>
            				<option value="gps" 		<%if(gubun.equals("gps"))%> 		selected<%%>>GPS장착</option>							
					<option value="bus_nm"		<%if(gubun.equals("bus_nm"))%> 		selected<%%>>최초영업자</option>														
            				<option value="bus_nm2"		<%if(gubun.equals("bus_nm2"))%> 	selected<%%>>영업담당자</option>														
            				<option value="mng_nm"		<%if(gubun.equals("mng_nm"))%> 		selected<%%>>관리담당자</option>
            				<option value="car_kd" 		<%if(gubun.equals("car_kd"))%> 		selected<%%>>차종분류</option>
            			</select>
            		</td>
            		<td id="nm" width="15%" style="display:<%if(gubun.equals("dlv_dt")||gubun.equals("init_reg_dt")||gubun.equals("car_end_dt")) {%>none<%}else{%>''<%}%>"><input type="text" name="gubun_nm" size="22" value="<%=gubun_nm%>" class=text onKeydown="javascript:EnterDown()"></td>
            		<td id="dt" width="25%" style="display:<%if(gubun.equals("dlv_dt")||gubun.equals("init_reg_dt")||gubun.equals("car_end_dt")) {%>''<%}else{%>none<%}%>"><input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class=text onBlur="javascript:ChangeDT('ref_dt1')"> ~ <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class=text onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javascript:EnterDown()"></td>
					<td>&nbsp;</td>
				</tr>
            	<tr>
            	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_sbjh.gif align=absmiddle>&nbsp;
            			<select name="gubun3">
            				<option value=""  <%if(gubun3.equals(""))%> selected<%%>> 전체</option>
	            			<option value="1" <%if(gubun3.equals("1"))%> selected<%%>> 렌트(영업용)</option>
	            			<option value="2" <%if(gubun3.equals("2"))%> selected<%%>> 리스(업무용)</option>
	            			<option value="3" <%if(gubun3.equals("3"))%> selected<%%>> 저공해차</option>
	            		</select></td>
            	  <td><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <select name="q_sort_nm">
                      <option value="firm_nm" 		<%if(q_sort_nm.equals("firm_nm"))%> 	selected<%%>>상호</option>
                      <option value="car_no" 		<%if(q_sort_nm.equals("car_no"))%> 	selected<%%>>차량번호</option>
                      <option value="car_doc_no" 	<%if(q_sort_nm.equals("car_doc_no"))%> 	selected<%%>>차량관리번호</option>
                      <option value="dlv_dt" 		<%if(q_sort_nm.equals("dlv_dt"))%> 	selected<%%>>출고일</option>
                      <option value="init_reg_dt" 	<%if(q_sort_nm.equals("init_reg_dt"))%> selected<%%>>등록일</option>
                      <option value="car_end_dt"  	<%if(q_sort_nm.equals("car_end_dt"))%> 	selected<%%>>차령만료일</option>
                      <option value="car_nm" 		<%if(q_sort_nm.equals("car_nm"))%> 	selected<%%>>차명</option>
                      <option value="emp_nm" 		<%if(q_sort_nm.equals("emp_nm"))%> 	selected<%%>>출고영업소</option>
                      <option value="car_ext" 		<%if(q_sort_nm.equals("car_ext"))%> 	selected<%%>>등록지역</option>                      
                    </select></td>
            	  <td><input type="radio" name="q_sort" value=""     <%if(q_sort.equals(""))%> checked<%%>>
            	    오름차순
                      <input type="radio" name="q_sort" value="desc" <%if(q_sort.equals("desc"))%> checked<%%>>
내림차순</td>
            	  <td>&nbsp;</td>
            	  <td><a href="javascript:SearchCarReg()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
           	  </tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>
