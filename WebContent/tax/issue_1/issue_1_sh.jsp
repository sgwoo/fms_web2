<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchs(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="issue_1_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
//-->
</script>

</head>
<body>
<form action="./issue_1_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ�꼭���� > �뿩�ᰳ��������� > <span class=style5>
						�����ۼ�</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>   	  	
    
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" align=absmiddle>&nbsp; 
        <select name="gubun1" >
          <option value="3" <%if(gubun1.equals("3")){%> selected <%}%>>��������</option>
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>���࿹����</option>
          <option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>�Աݿ�����</option>
        </select>	
		<input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		&nbsp;~&nbsp;
		<input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">		  
      </td>
      <td><img src="/acar/images/center/arrow_yus.gif" align=absmiddle>&nbsp; 
	  	  <%if(br_id.equals("S1")){%>
        <select name='s_br' onChange='javascript:Search();'>
          <option value=''>��ü</option>
          <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(s_br.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> <%= branch.get("BR_NM")%> </option>
          <%							}
						}		%>
        </select>
		  <%}else{%>
		    <%=c_db.getNameById(br_id,"BRCH")%>
			<input type="hidden" name="s_br" value="<%=br_id%>">
		  <%}%>			
		   &nbsp;&nbsp;&nbsp; </td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td width="45%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp; 
        <select name="s_kd" onChange="javascript:cng_input3()">
          <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>��ü</option>
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>����ȣ</option>
          <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>������ȣ</option>		  
      </select>&nbsp;&nbsp;&nbsp;
	  <input type="text" name="t_wd1" size="12" value="<%=t_wd1%>" class="text" onKeyDown="javasript:enter()">
	  OR
	  	<input type="text" name="t_wd2" size="12" value="<%=t_wd2%>" class="text" onKeyDown="javasript:enter()">
      </td>
      <td width="45%"><img src="/acar/images/center/arrow_jr.gif" align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp; 
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>��ȣ</option>
          <option value="2" <%if(sort.equals("2")){%> selected <%}%>>������ȣ</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>���࿹����</option>		  
          <option value="4" <%if(sort.equals("4")){%> selected <%}%>>�Աݿ�����</option>		  
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search(3)'>
        �������� 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search(3)'>
      �������� </td>
      <td width="10%" align="right">
      	<a href="javascript:Search();"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a>&nbsp;
      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
    </tr>
  </table>
</form>
</body>
</html>
