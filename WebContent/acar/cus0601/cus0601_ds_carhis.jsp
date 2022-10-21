<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--

//-->
</script>
</head>

<body>
<table width="820" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class="line" valign="bottom">
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td width=5% class=title>&nbsp;연번&nbsp;</td>
                                <td width=11% class=title>&nbsp;&nbsp;&nbsp;&nbsp;정비일자&nbsp;&nbsp;&nbsp;</td>
                                <td width=11% class=title>&nbsp;&nbsp;&nbsp;&nbsp;정비구분&nbsp;&nbsp;&nbsp;</td>
                                <td width=9% class=title>&nbsp;&nbsp;담당자&nbsp;&nbsp;</td>
                                <td width=21% class=title>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;정비업체&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td width=33% class=title>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;점검품목&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td width=10% class=title>&nbsp;&nbsp;주행거리&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td width=16>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan=2><iframe src="./cus0601_ds_carhis_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&off_id=<%=off_id%>" name="ServiceList" width="100%" height="450" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="auto"></iframe></td>
    </tr>
  </table>

</body>
</html>
