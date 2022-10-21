<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//String ref_dt1 = Util.getDate();
	//String ref_dt2 = Util.getDate();
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");	
	
	BranchBean br_r [] = umd.getBranchAll();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
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
	if(theForm.dt.value == '3' && (theForm.ref_dt1.value == '' || theForm.ref_dt1.value == '')){
		alert('기간을 입력하십시오.');
		return;
	}
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>등록현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<form action="./reg_cond_sc.jsp" name="RegCondSearchForm" method="POST" target="c_foot">
	<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width=100%>
            	<tr>
            		<td width=470>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            			<input type="radio" name="dt" value="1"> 당일
            			<input type="radio" name="dt" value="2" checked> 당월
						<input type="radio" name="dt" value="4" > 전월
            			<input type="radio" name="dt" value="3"> 조회기간
            		    &nbsp;
            			<input type="text" name="ref_dt1" size="11" value="<%//=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')"> ~
            			<input type="text" name="ref_dt2" size="11" value="<%//=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">  			  
            		</td>
            		<td>
            		<input type="checkbox" name="gubun" value="Y"> 중고차포함
            		&nbsp;&nbsp;&nbsp;
            		<img src=../images/center/arrow_jj.gif align=absmiddle>&nbsp;
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
						&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jr.gif align=absmiddle>&nbsp;
                      <select name="sort" >
                        <option value="1" <%if(sort.equals("1"))%>selected<%%>>등록일</option>
                        <option value="2" <%if(sort.equals("2"))%>selected<%%>>차량번호</option>                   
                        <option value="3" <%if(sort.equals("3"))%>selected<%%>>출고영업소</option>
                      </select>
                      &nbsp;&nbsp;&nbsp;            		
            		<a href="javascript:SearchRegCond()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
            	</tr>
            </table>
        </td>
    </tr>
</form>

</table>
</body>
</html>