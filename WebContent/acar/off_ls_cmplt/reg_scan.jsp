<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	//��ĵ���� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String remove_seq	= request.getParameter("remove_seq")==null?"":request.getParameter("remove_seq");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/sui/"+theURL;
		window.open(theURL,winName,features);
	}
	//����ϱ�
	function save(){
		fm = document.form1;
		if(fm.filename2.value == ""){	alert("������ ������ �ּ���!");		fm.filename2.focus();	return;		}		
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/sui_etc_reg_scan_a.jsp";
//		fm.target = "i_no";
		fm.submit();
	}
	
	//�����ϱ�
	function remove(seq, st_nm){
		fm = document.form1;
		fm.remove_seq.value = seq;
		if(!confirm(st_nm+" ������ �����Ͻðڽ��ϱ�?"))		return;
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/sui_etc_reg_scan_a.jsp";
//		fm.target = "i_no";
		fm.submit();
	}	
	
	//�����ϱ�
	function remove2(){
		fm = document.form1;
//		fm.target = "i_no";
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/sui_etc_reg_scan_a.jsp";
		fm.submit();
	}	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">

  <input type='hidden' name="car_mng_id" 	value="<%=car_mng_id%>">
 
  <input type='hidden' name="remove_seq"	value="<%=remove_seq%>">
  <input type='hidden' name="seq" 			value="">
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>��ĵ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
              
                <tr>
                    <td class='title'>��ĵ����</td>
                    <td >&nbsp;
        			<input type="file" name="filename2" size="40">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        &nbsp;<a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
<%if(!remove_seq.equals("")){%>
<script language="JavaScript">
<!--	
	remove2();
//-->
</script>
<%}%>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
