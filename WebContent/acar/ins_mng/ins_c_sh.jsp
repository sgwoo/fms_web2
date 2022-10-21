<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>  

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="ins_c_sc_in.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}
	
	//���÷��� Ÿ��(�˻�) - ��ȸ�Ⱓ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //����
			td_gubun2_1.style.display	= '';
			td_gubun2_2.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�Է�
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= '';
			fm.st_dt.value = '';
			fm.end_dt.value = '';
			fm.st_dt.focus();
		}else{
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= 'none';
		}
	}	
	
	//��ϻ��� ���÷���
	function change_type()
	{
		var fm = document.form1;
		drop_type();
		fm.gubun4.options[0] = new Option('��ü', '');		
		if(fm.gubun3.value == '1'){
			fm.gubun4.options[1] = new Option('����', '1');
			fm.gubun4.options[2] = new Option('�뵵����', '2');
		}else if(fm.gubun3.value == '2'){
			fm.gubun4.options[1] = new Option('����', '4');
			fm.gubun4.options[2] = new Option('�㺸����', '3');
		}else if(fm.gubun3.value == '3'){
			fm.gubun4.options[1] = new Option('R->L', '1');
			fm.gubun4.options[2] = new Option('L->R', '2');
			fm.gubun4.options[3] = new Option('�Ű�', '3');
			fm.gubun4.options[4] = new Option('����', '4');						
			fm.gubun4.options[5] = new Option('����', '5');			
		}else if(fm.gubun3.value == '5'){
			fm.gubun4.options[1] = new Option('����', '1');
			fm.gubun4.options[2] = new Option('����', '3');
			fm.gubun4.options[3] = new Option('�뵵����', '2');
		}else if(fm.gubun3.value == '6'){
			fm.gubun4.options[1] = new Option('�뵵����', '1');
			fm.gubun4.options[2] = new Option('�Ű�', '2');
		}
	}	
	function drop_type()
	{
		var fm = document.form1;
		var len = fm.gubun4.length;
		for(var i = 0 ; i < len ; i++){
			fm.gubun4.options[len-(i+1)] = null;
		}
	}			
	//�˻��ϱ�
	function ins_double(){
		window.open("ins_double.jsp", "double", "left=100, top=100, width=800, height=600, scrollbars=yes");
	}
	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<form action="./ins_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ������� > <span class=style5>���躯�濹����ȸ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
   
    
</table>
</form>
</body>
</html>