<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*" %>
<jsp:useBean id="cinfo_bean" class="acar.car_service.ContInfoBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
//System.out.println("c="+car_mng_id);
	CarServDatabase csd = CarServDatabase.getInstance();
	ServiceBean sb_r [] = csd.getServiceAll(car_mng_id);
	cinfo_bean = csd.getContInfo(rent_mng_id, rent_l_cd, car_mng_id);	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript">
<!--
	function LoadService(){
		var theForm = ServiceList.document.LoadServiceForm;
		theForm.submit();
	}
	
	function pop_excel(){
		var fm = ServiceList.document.LoadServiceForm;
		fm.target = "_blak";
		fm.action = "/acar/car_service/popup_excel.jsp";
		fm.submit();
	}
	function regService(){
		var theForm = document.form1;
		theForm.action = "jakup2.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>";
		theForm.target = 'd_content';	
		theForm.submit();
		//var SUBWIN="./cus0401_d_sc_carhis_reg.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>";
		//window.open(SUBWIN, "ServReg", "left=100, top=110, width=820, height=420, scrollbars=no");		
	}
	function regService_etc(){
		//var theForm = document.form1;
		//theForm.action = "cus0401_d_sc_carhis_reg2.jsp.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>";
		//theForm.target = 'd_content';	
		//theForm.submit();
		var SUBWIN="./cus0401_d_sc_carhis_reg2.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&serv_st=2";
		window.open(SUBWIN, "ServReg", "left=100, top=110, width=820, height=420, scrollbars=no");		
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
//-->
</script>
</head>

<body>
<form action="" name="form1" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����̷�</span></td>
    </tr>
      
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
                                <td width=5% class=title>����</td>
                                <td width=10% class=title>��������</td>
                                <td width=10% class=title>���񱸺�</td>
                                <td width=10% class=title>�����</td>
                                <td width=15% class=title>�����ü</td>
                                <td width=25% class=title>����ǰ��</td>
                                <td width=10% class=title>����Ÿ�</td>
                                <td width=10% class=title>�ݾ�</td>
                                <td width=5% class=title>����</td>
                            </tr>
                        </table>
                    </td>
                    <td width=17>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><iframe src="./cus0401_d_sc_carhis_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>&go_url=car_search" name="ServiceList" width="100%" height="200" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="auto"></iframe></td>
    </tr>
</table>
</form>
</body>
</html>
