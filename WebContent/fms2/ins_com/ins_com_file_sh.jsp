<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	//�α���ID&������ID&����
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getXmlAuthRw(user_id, "07", "07", "01");
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sh_height 	= request.getParameter("sh_height")==null?"":request.getParameter("sh_height");

%>

<html>
<head>
<title>FMS</title>
<script>

	function search(){
		var fm = document.form1;
		
		if(fm.gubun3.value == '�Ⱓ') {
		 	if(fm.st_dt.value == '' && fm.t_wd.value == ''){
				alert('�Ⱓ��ȸ�� ��� �Ⱓ�̳� �˻����� �� �� �ϳ��� �Է��ϼž� �մϴ�'); return;	
		 	}
		} 
		
	 	if(fm.gubun3.value == '' && fm.t_wd.value == ''){
			alert('��ü��ȸ�� ��� �˻������� �ݵ�� �Է��ϼž� �մϴ�'); return;	
		} 
		
		fm.action = 'ins_com_file_sc.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	

</script>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin=15>
<form name='form1' action='' target='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<div class="navigation">
	<span class=style1>������� ></span><span class=style5>��������</span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> ����� </label>
	<select id="gubun1" name="gubun1"  class="select" style="width:130px;">
		<option value='' >��ü</option>		
		<option value='0038' <%if(gubun1.equals("0038")){%>selected<%}%>>��Ʈī��������</option>
		<option value='0008' <%if(gubun1.equals("0008")){%>selected<%}%>>DB���غ���</option>
		<option value='0007' <%if(gubun1.equals("0007")){%>selected<%}%>>�Ｚȭ��</option>
	</select>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> ���� </label>
	<select id="gubun2" name="gubun2" class="select" style="width:70px;">
		<option value='���' <%if(gubun2.equals("���")){%>selected<%}%>>���</option>
	</select>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> ���Ա��� </label>
	<select id="gubun4" name="gubun4" class="select" style="width:70px;">
		<option value='' selected>��ü</option>
		<option value='�ű�' >�ű�</option>
		<option value='����' >����</option>
		<option value='����' >����</option>
	</select>
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> �Ⱓ </label>
	<select id="gubun3" name="gubun3" class="select" style="width:70px;">
		<option value=''>��ü</option>
		<option value='����' <%if(gubun3.equals("����")){%>selected<%}%>>����</option>
		<option value='����' <%if(gubun3.equals("����")){%>selected<%}%>>����</option>
		<option value='�Ⱓ' <%if(gubun3.equals("�Ⱓ")){%>selected<%}%>>�Ⱓ</option>		
	</select>	
	<input type="text" name="st_dt" size="10"  value="<%=st_dt%>" class="text" >
  ~ 
  <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" >
	&nbsp;&nbsp;
	<label><i class="fa fa-check-circle"></i> �˻����� </label>
	<select id="s_kd" name="s_kd" class="select" style="width:100px;">
		<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>������ȣ</option>
		<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>���ǹ�ȣ</option>
		<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>����</option>
		<option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>��ȣ</option>
		<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>����ڹ�ȣ</option>
	</select>
	&nbsp;
	<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
	&nbsp;&nbsp;
	<input type="button" class="button" value="�˻�" onclick="search()"/>
</div>
</form>
</body>
</html>
