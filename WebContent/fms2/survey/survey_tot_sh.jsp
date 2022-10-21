<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
%>
<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
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

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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

<form name='form1' action='survey_tot_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
    	<td>
    	    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7 rowspan=2><img src="/acar/images/center/menu_bar_1.gif" width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/menu_bar_dot.gif" width=4 height=5 align=absmiddle>&nbsp;<span class=style1>콜센터 > <span class=style5>콜항목관리</span></span></td>
                    <td width=7 rowspan=2><img src="/acar/images/center/menu_bar_2.gif" width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
        <td>
            <table border=0 cellspacing=1 width=100%>
                <tr> 
					<td width="300">&nbsp;&nbsp;&nbsp;
						<input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>계약 &nbsp;&nbsp;&nbsp;
						<input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>순회정비&nbsp;&nbsp;&nbsp;
						<input type="radio" name="gubun1" value="3" <%if(gubun1.equals("3"))%>checked<%%>>사고처리
					</td>
					<td width="300">&nbsp;&nbsp;&nbsp;
						<select name="gubun2" onChange="">          
							<option value="" <%if(gubun2.equals(""))%>selected<%%>>계약타입</option>
							<option value="1" <%if(gubun2.equals("1"))%>selected<%%>>계약</option>
							<option value="2" <%if(gubun2.equals("2"))%>selected<%%>>순회정비</option>
							<option value="3" <%if(gubun2.equals("3"))%>selected<%%>>사고처리</option>
						</select>
					</td>
				</tr>
				<tr>
					<td width="300">&nbsp;&nbsp;&nbsp;
						<select name="gubun3" onChange="">          
							<option value="" <%if(gubun3.equals(""))%>selected<%%>>회차선택</option>
							<option value="1" <%if(gubun3.equals("1"))%>selected<%%>>1회차</option>
							<option value="2" <%if(gubun3.equals("2"))%>selected<%%>>2회차</option>
							<option value="3" <%if(gubun3.equals("3"))%>selected<%%>>3회차</option>
						</select>
					</td>
					<td width="300">&nbsp;&nbsp;&nbsp;
						<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
						~ 
						<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" > 
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
