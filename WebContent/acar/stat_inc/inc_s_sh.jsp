<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function search(){
		var fm = document.form1;
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }
		fm.target = "c_foot";
		fm.submit()
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}

/*
function BlankGubun()
{
	var theForm = document.IncSearchForm;
	theForm.gubun_nm.value = "";
	theForm.gubun_nm.focus();
}
function ChangeDT(arg)
{
	var theForm = document.IncSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}*/
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<form action="./inc_s_sc.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>수금스케줄</span></span></td>
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
	        <table border=0 cellspacing=0 cellpadding=0 width=100%>
                <tr>
                    <td width=65>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g.gif align=absmiddle></td>
                    <td width=90>
                        <select name="gubun1">
                          <option value=""  <%if(gubun1.equals("")){%>selected<%}%>>전체</option>
                          <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>대여료</option>
                          <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>선수금</option>
                          <option value="3" <%if(gubun1.equals("3")){%>selected<%}%>>과태료</option>
                          <option value="4" <%if(gubun1.equals("4")){%>selected<%}%>>면책금</option>
                          <option value="5" <%if(gubun1.equals("5")){%>selected<%}%>>휴/대차료</option>
                          <option value="6" <%if(gubun1.equals("6")){%>selected<%}%>>해지정산</option>
                        </select>
           		    </td>
                    <td width=180>
                        <input type="radio" name="gubun3" value="" <% if(gubun3.equals("")) out.println("checked");%>>전체
                        <input type="radio" name="gubun3" value="1" <% if(gubun3.equals("1")) out.println("checked");%>>수금
                        <input type="radio" name="gubun3" value="2" <% if(gubun3.equals("2")) out.println("checked");%>>미수금
                    </td>
                    <td width=100>
                        <input type='radio' name="gubun2" value="2" <% if(gubun2.equals("2")) out.println("checked");%>>당일
            			<input type='radio' name="gubun2" value="4" <% if(gubun2.equals("4")) out.println("checked");%>>기간
                    </td>
                    <td width=170>
                        <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text"> ~
                        <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" onKeydown="javasript:enter()">            
                    </td>
        		    <td><a href="javascript:search()"><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>
                </tr>
            </table>			
	    </td>
    </tr>
</table>
</form>
</body>
</html>
