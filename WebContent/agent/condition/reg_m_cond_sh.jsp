<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>
<%
//	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	
	BranchBean br_r [] = umd.getBranchAll();
	
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
	if (keyValue =='13') SearchRegCond();
}
function SearchRegCond()
{
	var theForm = document.RegCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function ChangeDT(arg)
{
	var theForm = document.RegCondSearchForm;
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
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 계출관리 > <span class=style5>미출고현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./reg_m_cond_sc.jsp" name="RegCondSearchForm" method="POST" target="c_foot">
    <tr>
        <td>
            <table border=0 cellspacing=1>
            	<tr>
            		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jj.gif align=absmiddle>&nbsp;
            			<select name="br_id">
            				<option value="">전체</a>
<%
    for(int i=0; i<br_r.length; i++){
        br_bean = br_r[i];
%>
            				<option value="<%= br_bean.getBr_id() %>">[<%= br_bean.getBr_id() %>] <%= br_bean.getBr_nm() %></option>
<%
	}
%>
            			</select>
            		</td>
            		
            		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
            			<select name="fn_id">
            				<option value="0"> 전체 </option>
            				<option value="1"> 상호 </option>
            				<option value="2"> 차종 </option>
            				<option value="3"> 제조사 </option>
            			</select>
                        <input type="text" name="find_u" width='200' value="">
                        &nbsp;<a href="javascript:SearchRegCond()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
            	</tr>
            </table>
        </td>
    </tr>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>     
</form>

</table>
</body>
</html>