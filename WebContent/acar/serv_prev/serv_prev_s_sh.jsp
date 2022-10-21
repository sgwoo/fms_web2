<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	String auth_rw = "";
	if(request.getParameter("auth_rw") != null)	auth_rw= request.getParameter("auth_rw");
	
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
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchMaint();
}
function SearchMaint()
{
	var theForm = document.MaintSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function ChangeFocus()
{
	var theForm = document.MaintSearchForm;
	if(theForm.gubun.value=="ref_dt")
	{
		nm.style.display = 'none';
		dt.style.display = '';
		theForm.ref_dt1.value = "";
		theForm.ref_dt2.value = "";
		theForm.ref_dt1.focus();
		
	}else{
		nm.style.display = '';
		dt.style.display = 'none';
		theForm.gubun_nm.value = "";
		theForm.gubun_nm.focus();
	}
}
function ChangeDT(arg)
{
	var theForm = document.MaintSearchForm;
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
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>예방정비스케쥴</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

	<form action="./serv_prev_s_sc.jsp" name="MaintSearchForm" method="POST" >
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
            		
            		<td><img src=/acar/images/center/arrow_sbjh.gif  align=absmiddle> &nbsp; </td>
            		<td>
            			<select name="gubun" onChange="jvascript:ChangeFocus()">
            				<option value="car_no">차량번호</option>
            				<option value="firm_nm">상호</option>
            				<option value="client_nm">고객명</option>
            			</select>
            		</td>
            		<td id="nm"><input type="text" name="gubun_nm" size="10" value="" class=text onKeydown="javasript:EnterDown()"></td>
            		<td id="dt" style='display:none'><input type="text" name="ref_dt1" size="11" value="" class=text onBlur="javascript:ChangeDT('ref_dt1')"> ~ <input type="text" name="ref_dt2" size="11" value="" class=text onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javascript:EnterDown()"></td>
					
            		<td><input type="hidden" name="auth_rw" value="<%=auth_rw%>"><a href="javascript:SearchMaint()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
            	</tr>
            </table>
        </td>
    </tr>
    <input type='hidden' name='sh_height' value='<%=sh_height%>'>
    </form>
</table>
</body>
</html>