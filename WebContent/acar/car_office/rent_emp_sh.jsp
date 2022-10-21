<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String g_fm	 	= request.getParameter("g_fm")==null?"1":request.getParameter("g_fm");
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String sort 	= request.getParameter("sort")==null?gubun2:request.getParameter("sort");
	
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();

	CarCompBean cc_r [] = umd.getCarCompAll();
	
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
function SearchRentCond()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchRentCond();
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

	//디스플레이 타입
	function cng_input(){
		var fm = document.RentCondSearchForm;
		if(fm.gubun3.options[fm.gubun3.selectedIndex].value != ''){
			td_user.style.display 	= '';
		}else{
			td_user.style.display 	= 'none';
		}
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body leftmargin="15">

<form action="./rent_emp_sc.jsp" name="form1" method="POST" target="c_foot">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 영업사원관리 > <span class=style5>영업사원별계약현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>
			            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g.gif align=absmiddle>
            			 &nbsp;<select name="gubun2">
            			 	<option value="" <% if(gubun2.equals("")) out.print("selected"); %>>전체</option>
                            <option value="1" <% if(gubun2.equals("1")) out.print("selected"); %>>영업담당</option>			
                            <option value="2" <% if(gubun2.equals("2")) out.print("selected"); %>>출고담당</option>		
            			  </select>&nbsp;&nbsp;&nbsp;&nbsp;					
			            <img src=/acar/images/center/arrow_sss.gif align=absmiddle>
                        &nbsp;<select name="gubun3">
                        <option value="">전체</option>
                <%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
        if(cc_bean.getNm().equals("에이전트")) continue;
%>
                        <option value="<%= cc_bean.getCode() %>" <% if(gubun3.equals(cc_bean.getCode())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                <%}%>
                         </select>
        			&nbsp;&nbsp;&nbsp;
        			영업사원 이름 
        			: &nbsp;
        				<input type="text" name="gubun_nm" size="10" value="" class="text">
        			&nbsp;&nbsp;&nbsp;
        			  <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                      당일 
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      당월 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      누계
                      <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
                      조회기간
        			  &nbsp;&nbsp;
        				<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
                      ~ 
                      <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
        			  
        			  &nbsp;<a href="javascript:SearchRentCond()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>