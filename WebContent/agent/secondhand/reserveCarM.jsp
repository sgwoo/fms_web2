<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*" %>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function regReserveCar(gubun){
		fm = document.form1;
		if(fm.memo.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
		fm.gubun.value = gubun;			
		if(!confirm("수정 하시겠습니까?"))	return;
		fm.action = "reserveCarM_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량예약 메모수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td width="20%" class=title>진행상황</td>
                    <td width="80%">&nbsp;
                      <%	if(situation.equals("0"))		out.print("상담중");
        			else if(situation.equals("2"))		out.print("계약확정");  %>
      		    </td>
                </tr>
                <tr> 
                    <td class=title>메모</td>
                    <td >&nbsp;<textarea name="memo" cols="48" rows="6" style="IME-MODE:ACTIVE"><%=memo%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>  
        <td>* 메모에 고객명과 고객연락처를 꼭 입력하십시오.
	    </td>	
    </tr>	
    <tr>  
        <td align="right">
	    <a href="javascript:regReserveCar('memo');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
	    </td>	
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
