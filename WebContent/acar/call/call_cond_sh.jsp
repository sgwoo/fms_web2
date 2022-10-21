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
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");

	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String g_fm = "1";
	

	/*수정문안끝*/
	
	
	
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
<style type=text/css>

<!--

.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>콜센터 > <span class=style5>콜현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="./call_cond_sc.jsp" name="RentCondSearchForm" method="POST" target="c_foot">
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td width="253">&nbsp;&nbsp; <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
                    전월
                    <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
                    당월 
                    <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                    당해 
                   <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                    조회기간 </td>
                    <td width=130><img src=../images/center/arrow_g.gif>&nbsp; 
                        <select name="gubun2">
                            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>계약일</option>
                            <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>대여개시일</option>
                            <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>콜등록일</option>
                        </select></td>
                    <td width="157"> <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
                     ~ 
                    <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
                    </td>
                    <td width=145>&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif>&nbsp;
                     <select name="s_kd" >
				          <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
				          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>계약번호</option>
				          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>상호</option>
				           <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>영업사원</option>
				             <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>등록자</option>
				    
				     </select>
                    </td> 
                    <td  width="157"> 
              			<input type="text" name="t_wd" size="21" value="<%=t_wd%>" class="text" onKeyDown="javasript:EnterDown()">
            		</td>
                    <td width="68">&nbsp;<a href="javascript:SearchRentCond()"><img src="../images/center/button_search.gif" align="absmiddle" border="0"></a></td>
                </tr>
               
            </table>
        </td>
    </tr>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	    
</form>

</table>
</body>
</html>