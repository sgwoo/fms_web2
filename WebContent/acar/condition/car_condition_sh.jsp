<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="cdb" scope="page" class="acar.con_car.CarDatabase"/>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String save_dt = cdb.existSave_dt();
%>
<%
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
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
<%if(save_dt.equals("")){%>
	function save(){
		if(!confirm('���� ��¥�� �����Ͻð����ϱ�?')) return;
		var fm = document.form1;
		fm.target = "i_no";
		fm.action = "car_condition_save.jsp";
		fm.submit();
	}
<%}else{%>
	function save(){
		alert("���� ��¥�� �̹� ������ �Ǿ����ϴ�.");
	}
<%}%>
//-->
</script>
</head>
<body>
<form name='form1' method='post' action='/acar/condition/car_condition_sc.jsp' target='c_body'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>������Ȳ(���Ǻ��뿩�Һη�)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border='0' cellspacing='0' cellpadding='0' width='100%'>
            	<tr>
            		<td width=''>
            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gsjg.gif align=absmiddle> 
            			&nbsp;<select name='s_kd' onChange='javascript:cng_input()'>
            				<option value='0'>��ü</option>
            				<option value='1'>��ȣ</option>
            				<option value='2'>����ȣ</option>
            				<option value='3'>������ȣ</option>
            			</select>
            		</td>
					<td id='td_input' align='left'>
						<input type='text' name='t_wd' size='15' class='text' value='' onKeyDown='javascript:enter()'>
						<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
					</td>
					<td align='right'><%if(auth_rw.equals("6")){%>
					<a href="javascript:save();"><img src=../images/center/button_dimg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;
					<%}%></td>
				</tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>