<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");	
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")		==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")		==null?"":request.getParameter("gubun3");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	String dt	= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
	function EnterDown()
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search()
	{
		var theForm = document.form1;
		theForm.target = "c_foot";
		theForm.submit();
	}
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="ref_dt1")
		{
			theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
		}else if(arg=="ref_dt2")
		{
			theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
		}
	}

//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>

<body>
<form name='form1' method='post' action='./off_ls_stat_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'> 
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �Ű����İ��� > <span class=style5>��ų�����Ȳ</span></span></td>
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
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
          ��� 
          <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
          ��ȸ�Ⱓ
          &nbsp;&nbsp;
          <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
          ~ 
          <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_g_gy.gif align=absmiddle>&nbsp;
		  <select name='gubun1'>
          <option value='' >��ü</option> 
          <option value='rt' <%if(gubun1.equals("rt")){%>selected<%}%>>��Ʈ</option>
          <option value='ls' <%if(gubun1.equals("ls")){%>selected<%}%>>����</option>
        </select>
		&nbsp;
          <a href="javascript:search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
      </td>
    </tr>
    <tr> 
      <td>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <img src=../images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <select name='gubun'>
          <option value='all' >��ü</option> 
          <option value='car_no'      <%if(gubun.equals("car_no")){	%>selected<%}%>>������ȣ</option>
          <option value='car_nm'      <%if(gubun.equals("car_nm")){	%>selected<%}%>>����</option>
          <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>���ʵ����</option>
          <option value='jg_code'     <%if(gubun.equals("jg_code")){	%>selected<%}%>>�����ڵ�</option>
        </select>       
        <input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javasript:EnterDown()">
      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      	<img src=../images/center/arrow_gmj.gif align=absmiddle> 
        <select name="s_au" >
          <option value=""       <%if(s_au.equals("")){		%> selected <%}%>>��ü</option>
			<option value="000502" <%if(s_au.equals("000502")){%> selected <%}%>>����۷κ�(��)-��ȭ</option>
			<option value="013011" <%if(s_au.equals("013011")){%> selected <%}%>>����۷κ�(��)-�д�</option>
			<option value="020385" <%if(s_au.equals("020385")){	%> selected <%}%>>�������̼�ī �ֽ�ȸ��</option>
			<option value="003226" <%if(s_au.equals("003226")){	%> selected <%}%>>�������</option>
			<option value="011723" <%if(s_au.equals("011723")){   %> selected <%}%>>�����ڵ������</option>
			<option value="013222" <%if(s_au.equals("013222")){   %> selected <%}%>>��ȭ����ũ �ֽ�ȸ��</option>
			<option value="022846" <%if(s_au.equals("022846")){%> selected <%}%>>�Ե���Ż(��)</option>
        </select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src=../images/center/arrow_cj.gif align=absmiddle>
        <select name="gubun2">
   		  <option value=""  <% if(gubun2.equals("")) out.print("selected"); %>>��ü</option>
		  <option value="8" <% if(gubun2.equals("8")) out.print("selected"); %>>�����¿�(LPG)</option>		  
		  <option value="5" <% if(gubun2.equals("5")) out.print("selected"); %>>�����¿�(LPG)</option>
		  <option value="4" <% if(gubun2.equals("4")) out.print("selected"); %>>�����¿�(LPG)</option>
		  <option value="9" <% if(gubun2.equals("9")) out.print("selected"); %>>��¿�</option>
		  <option value="3" <% if(gubun2.equals("3")) out.print("selected"); %>>�����¿�</option>
		  <option value="2" <% if(gubun2.equals("2")) out.print("selected"); %>>�����¿�</option>
		  <option value="1" <% if(gubun2.equals("1")) out.print("selected"); %>>�����¿�</option>
		  <option value="6" <% if(gubun2.equals("6")) out.print("selected"); %>>RV</option>																  		
		  <option value="10" <% if(gubun2.equals("10")) out.print("selected"); %>>����</option>																  		
		  <option value="7" <% if(gubun2.equals("7")) out.print("selected"); %>>ȭ��</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="radio" name="gubun3" value="" <%if(gubun3.equals(""))%>checked<%%>>��ü&nbsp;
		<input type="radio" name="gubun3" value="1" <%if(gubun3.equals("1"))%>checked<%%>>���ָ�&nbsp;
		<input type="radio" name="gubun3" value="2" <%if(gubun3.equals("2"))%>checked<%%>>����&nbsp;
		<input type="radio" name="gubun3" value="3" <%if(gubun3.equals("3"))%>checked<%%>>�Ϲݽ¿�LPG&nbsp;
		<input type="radio" name="gubun3" value="4" <%if(gubun3.equals("4"))%>checked<%%>>��Ÿ����LPG&nbsp;
    </tr>
  </table>
</form>
</body>
</html>