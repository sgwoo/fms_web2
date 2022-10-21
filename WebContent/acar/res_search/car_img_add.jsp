<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.car_register.*"%>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
%>

<html>
<head>
<title><%=car_no%> 차량사진 올리기</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
</head>
<body leftmargin="15">
<form name='form1' action='car_img_add_a.jsp' method='post'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > <span class=style5>차량사진관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align='right'><a href='javascript:close();'><img src=../images/center/button_close.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>	
    <tr> 
      <td><iframe src="./car_img_add_in.jsp?c_id=<%=c_id%>&idx=5" name="inner5"  width="100%" height="85" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 ></td>
    </tr>				
    <tr> 
      <td><iframe src="./car_img_add_in.jsp?c_id=<%=c_id%>&idx=1" name="inner1"  width="100%" height="85" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 ></td>
    </tr>
    <tr> 
      <td><iframe src="./car_img_add_in.jsp?c_id=<%=c_id%>&idx=3" name="inner3"  width="100%" height="85" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 ></td>
    </tr>
    <tr> 
      <td><iframe src="./car_img_add_in.jsp?c_id=<%=c_id%>&idx=4" name="inner4"  width="100%" height="85" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 ></td>
    </tr>
    <tr> 
      <td><iframe src="./car_img_add_in.jsp?c_id=<%=c_id%>&idx=2" name="inner2"  width="100%" height="85" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 ></td>
    </tr>
    <tr> 
      <td><iframe src="./car_img_add_in.jsp?c_id=<%=c_id%>&idx=6" name="inner6"  width="100%" height="85" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 ></td>
    </tr>
  </table>
</form>
</body>
</html>