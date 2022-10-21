<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = "";
	String gubun = "";
	String gubun_nm = "";
	String st = "0";
	String dt = "1";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	
	if(request.getParameter("auth_rw") != null)	auth_rw= request.getParameter("auth_rw");
	if(request.getParameter("gubun") != null)	gubun= request.getParameter("gubun");
	if(request.getParameter("gubun_nm") != null)	gubun_nm= request.getParameter("gubun_nm");
	if(request.getParameter("st") != null)	st = request.getParameter("st");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>등록리스트</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchExp();
}
function SearchExp()
{
	var theForm = document.ExpSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function ChangeDT(arg)
{
	var theForm = document.ExpSearchForm;
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
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td colspan=3>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 영업비용관리 > <span class=style1><span class=style5>지출스케줄관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
<!-- 
구분 : 보험료, 할부금, 과태료/범칙금, 취득세
-->
<form action="./exp_s_sc.jsp" name="ExpSearchForm" method="post">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<tr>
		<td>
			<table border=0 cellspacing=1>
            	<tr>
            		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_g.gif align=absmiddle></td>
            		<td>
            			&nbsp;<select name="gubun">
            				<option value="">전체</option>
            				<option value="alt">할부금</option>
            				<option value="ins">보험금</option>
            				<option value="fine">과태료</option>
            				<option value="acq">취득세</option>

            			</select>
            			<script language="javascript">
            			document.ExpSearchForm.gubun.value = '<%=gubun%>';
            			</script>
            		</td>
            		<td>
            			<input type="radio" name="st" value="0" <% if(st.equals("0")||st.equals("")) out.print("checked"); %>> 전체
            			<input type="radio" name="st" value="1" <% if(st.equals("1")) out.println("checked"); %>> 지출
            			<input type="radio" name="st" value="2" <% if(st.equals("2")) out.println("checked"); %>> 미지출
            		</td>
            		
            		<td width=100>&nbsp;</td>
            		<td>
            			<input type='radio' name='dt' value="1" <% if(dt.equals("1")||dt.equals("")) out.print("checked"); %>>당일
						<input type='radio' name='dt' value="2" <% if(dt.equals("2")) out.println("checked"); %>>기간
            		</td>
            		<td>
            			&nbsp;<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')"> ~
            			<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
            			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
            		</td>
            		
            		<td>&nbsp;<a href="javascript:SearchExp()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
            	</tr>
            </table>
			
		</td>
	</tr>
</form>
</table>

</body>
</html>
