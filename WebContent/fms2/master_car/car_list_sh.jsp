<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
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

function ChangeDT(arg)
{
	var theForm = document.CarRegSearchForm;
	if(arg=="st_dt")
	{
	theForm.st_dt.value = ChangeDate(theForm.st_dt.value);
	}else if(arg=="end_dt"){
	theForm.end_dt.value = ChangeDate(theForm.end_dt.value);
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 긴급출동관리 > <span class=style5>마스타자동차의뢰</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>	
	<form action="./car_list_sc.jsp" name="CarRegSearchForm" method="POST" target="c_foot">
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
            		<td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
            		  <select name="s_kd">
                       	  	 	 	 	
                		<option value="2" >기간</option>
                	  </select>&nbsp;&nbsp;
					  <input type='text' size='11' name='st_dt' class='text'   value='<%=st_dt%>' onBlur="javascript:ChangeDT('st_dt')">
                      ~ 
            		  <input type='text' size='11' name='end_dt' class='text'   value='<%=end_dt%>' onBlur="javascript:ChangeDT('end_dt')">
					 <b> 발생분 등록/매각/검사의뢰 차량 </b> 리스트 
            	  <td><a href="javascript:SearchCarReg()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
				</tr>
            </table>
        </td>
    </tr>
</form>
</table>
</body>
</html>
