<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"3":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");

	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String actn 	= request.getParameter("actn")==null?"":request.getParameter("actn");
	
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 자동차관리 > <span class=style5>차령만료예정현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<form action="./register_end_sc.jsp" name="CarRegSearchForm" method="POST">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>	
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1 cellpadding=0>
            	<tr>
            		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;</td>
            		<td>
            			<select name="st">
            				<option value="2" <%if(st.equals("2"))%> selected<%%>> 등록차량</option>
	            		</select>
            		</td>
            		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jhgb.gif align=absmiddle>&nbsp;</td>
            		<td>
            			<select name="gubun">
            				<option value="car_end_dt"  <%if(gubun.equals("car_end_dt"))%>  selected<%%>>차령만료일</option>							
            			</select>
            		</td>
            		<td id="nm" style='display:none'><input type="text" name="gubun_nm" size="10" value="<%=gubun_nm%>" class=text onKeydown="javascript:EnterDown()"></td>
            		<td id="dt" style="display:''">&nbsp;<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class=text onBlur="javascript:ChangeDT('ref_dt1')"> ~ <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class=text onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javascript:EnterDown()"></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;</td>
            		<td>
            			<select name="q_sort_nm">
            				<option value="firm_nm" 	<%if(q_sort_nm.equals("firm_nm"))%> 	selected<%%>>상호</option>
            				<option value="car_no" 		<%if(q_sort_nm.equals("car_no"))%> 	selected<%%>>차량번호</option>
            				<option value="dlv_dt" 		<%if(q_sort_nm.equals("dlv_dt"))%> 	selected<%%>>출고일</option>
            				<option value="init_reg_dt" <%if(q_sort_nm.equals("init_reg_dt"))%> selected<%%>>등록일</option>
            				<option value="car_end_dt"  <%if(q_sort_nm.equals("car_end_dt"))%> selected<%%>>차령만료일</option>
            			</select>
            		</td>
					<td>
            			&nbsp;<input type="radio" name="q_sort" value=""     <%if(q_sort.equals(""))%> checked<%%>> 오름차순
            			<input type="radio" name="q_sort" value="desc" <%if(q_sort.equals("desc"))%> checked<%%>> 내림차순
            		</td>
            	</tr>
            	<tr>
            		<td colspan="9">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	            		<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>
						<select name='s_kd'>
							<option value='1' selected>차량번호</option>
							<option value='2' >담당자</option>
							<option value='3' >지역</option>
							<option value='4' >처리예정일</option>
						</select>
						<input type='text' name='t_wd' size='20' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>&nbsp;&nbsp;&nbsp;

						<img src=/acar/images/center/arrow_jj.gif align=absmiddle>
						<select name='brid'>
							<option value=""<%if(brid.equals(""))%>selected<%%>>전체</option>
							<option value="1"<%if(brid.equals("1"))%>selected<%%>>본사</option>
							<option value="3"<%if(brid.equals("3"))%>selected<%%>>부산</option>
							<option value="4"<%if(brid.equals("4"))%>selected<%%>>대전</option>
							<option value="5"<%if(brid.equals("5"))%>selected<%%>>광주</option>
							<option value="6"<%if(brid.equals("6"))%>selected<%%>>대구</option>
				        </select>
				       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[경매현황]
				        <select name='actn'>
							<option value=""<%if(actn.equals(""))%>selected<%%>>전체</option>
							<option value="3"<%if(actn.equals("3"))%>selected<%%>>경매장</option>
							<option value="5"<%if(actn.equals("5"))%>selected<%%>>낙찰</option>	
							<option value="6"<%if(actn.equals("6"))%>selected<%%>>경매장/낙찰 제외</option>							
				        </select>
				        
				        <a href="javascript:SearchCarReg()"><img src=/acar/images/center/button_search.gif align="absmiddle" border="0"></a>
			        </td>
            	</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>
