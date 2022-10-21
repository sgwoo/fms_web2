<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	/*여기부터 수정문안*/
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String g_fm = "1";
	

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
	var theForm = document.RentCondSearchForm;
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
	var theForm = document.RentCondSearchForm;
	if(arg=="ref_dt1")
	{
		theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
		theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

	
	
	function cont_stat(){
		var fm = document.RentCondSearchForm;
		fm.action = "/fms2/condition/rent_cond_stat_frame.jsp";
		fm.target = "d_content";
		fm.submit();
	}
	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form action="./rent_cond_sc.jsp" name="RentCondSearchForm" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약현황</span></span></td>
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
            <table width=100% border=0 cellspacing=1>
                <tr> 
                    <td colspan='2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                      당일 
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      당월 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      조회기간 </td>
                    <td width=10%><img src=../images/center/arrow_g.gif align=absmiddle>&nbsp;
                        <select name="gubun2">
                            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>계약일</option>
                            <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>대여개시일</option>
                        </select></td>
                    <td width=18%>&nbsp;<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
                      ~ 
                      <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
                    </td>
                    <td width=10%>&nbsp;<a href="javascript:SearchRentCond()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
					<td align="right">&nbsp;<a href="/fms2/condition/rent_cond_stat_frame.jsp" target="d_content"><img src=../images/center/button_hh.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr> 
                    <td width=14%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_ddj.gif align=absmiddle>&nbsp;
                        <select name="gubun3">
                            <option value=""  <%if(gubun3.equals(""))%>selected<%%>>전체</option>
                            <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>최초영업자</option>
                            <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>영업담당자</option>
                            <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>관리담당자</option>
                        </select></td>
					<td width=13%><input type="text" class="text" name="gubun4" size="15" value="<%= gubun4 %>" align="absbottom"></td>	
                    <td><img src=../images/center/arrow_jr.gif align=absmiddle>&nbsp;
                        <select name="sort" onChange='javascript:SearchRentCond()'>
                            <option value="7" <%if(gubun3.equals("7"))%>selected<%%>>계약구분</option>
                            <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>계약일</option>
                            <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>대여개시일</option>
                            <option value="8" <%if(gubun3.equals("8"))%>selected<%%>>대여기간</option>				
                            <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>상호</option>
                            <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>최초영업자</option>
                            <option value="5" <%if(gubun3.equals("5"))%>selected<%%>>영업구분</option>				
                            <option value="6" <%if(gubun3.equals("6"))%>selected<%%>>영업사원</option>				
                        </select></td>
                    <td>&nbsp;</td>
					<td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	    
</table>
</form>
</body>
</html>