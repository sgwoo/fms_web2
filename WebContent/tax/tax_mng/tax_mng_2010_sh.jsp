<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		if(fm.st_dt.value == ''){ alert('�Ⱓ�� �Է��Ͻʽÿ�.'); return;}
		if(fm.end_dt.value == ''){ alert('�Ⱓ�� �Է��Ͻʽÿ�.'); return;}
		fm.action="tax_mng_2010_sc.jsp";
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
<form action="./tax_mng_2010_sc.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan="3">
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ�꼭���� > <span class=style5>
						���ݰ�꼭������5����(2001��~)</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" class=h></td>
	</tr>  	    
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gggub.gif" align=absmiddle>&nbsp;
        <select name="gubun1" >
          <option value="1" <%if(gubun1.equals("1")){%> selected <%}%>>��������&nbsp;</option>
          <option value="2" <%if(gubun1.equals("2")){%> selected <%}%>>�ۼ�����&nbsp;</option>
        </select>
        &nbsp;&nbsp;
        <select name="gubun2" >
        	<%for(int i=2001; i<=AddUtil.parseInt(gubun3); i++){%>
          <option value="<%=i%>" <%if(gubun2.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
          <%}%>
        </select>	
        &nbsp;&nbsp;
		    <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text">
		    &nbsp;~&nbsp;
		    <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text">
		    (���ó⵵�̳�)
      </td>
      <td><img src="/acar/images/center/arrow_bhgb.gif" align=absmiddle>&nbsp; 
        <input type="radio" name="chk1" value="0" <%if(chk1.equals("0")){%> checked <%}%>>
        ��ü
        <input type="radio" name="chk1" value="1" <%if(chk1.equals("1")){%> checked <%}%>>
        ����
        <input type="radio" name="chk1" value="2" <%if(chk1.equals("2")){%> checked <%}%>>
        ����
        <input type="radio" name="chk1" value="3" <%if(chk1.equals("3")){%> checked <%}%>>
        ���</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td width="40%">
	    <table width="100%"  cellspacing=0 border="0" cellpadding="0">
          <tr>
            <td width="250">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp; 
              <select name="s_kd">
                <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>��ü</option>
                <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>���޹޴���</option>
                <option value="13" <%if(s_kd.equals("13")){%> selected <%}%>>����</option>				
                <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>����ȣ</option>
                <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>������ȣ</option>
                <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>����ڹ�ȣ</option>
                <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>�Ϸù�ȣ</option>
                <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>ǰ��/���</option>
                <option value="10" <%if(s_kd.equals("10")){%> selected <%}%>>�����̸���</option>
                <option value="12" <%if(s_kd.equals("12")){%> selected <%}%>>����û���ι�ȣ</option>
              </select>
          </td>
          <td>
		  <input type="text" name="t_wd1" size="12" value="<%=t_wd1%>" class="text" onKeyDown="javasript:enter()">
      OR
        <input type="text" name="t_wd2" size="12" value="<%=t_wd2%>" class="text" onKeyDown="javasript:enter()"></td>          
        </tr>
      </table>
	  </td>
      <td width="35%"><img src="/acar/images/center/arrow_jr.gif" align=absmiddle>&nbsp; 
        <select name="sort">
          <option value="1" <%if(sort.equals("1")){%> selected <%}%>>��ȣ</option>
          <option value="2" <%if(sort.equals("2")){%> selected <%}%>>������ȣ</option>
          <option value="3" <%if(sort.equals("3")){%> selected <%}%>>����ڹ�ȣ</option>
          <option value="4" <%if(sort.equals("4")){%> selected <%}%>>�Ϸù�ȣ</option>
          <option value="5" <%if(sort.equals("5")){%> selected <%}%>>��������</option>
          <option value="6" <%if(sort.equals("6")){%> selected <%}%>>�ۼ�����</option>
          <option value="7" <%if(sort.equals("7")){%> selected <%}%>>�������</option>
        </select>
        <input type='radio' name='asc' value='asc' <%if(asc.equals("asc")){%> checked <%}%> onClick='javascript:Search()'>
        �������� 
        <input type='radio' name='asc' value='desc' <%if(asc.equals("desc")){%> checked <%}%>onClick='javascript:Search()'>
        �������� </td>
      <td width="10%"><a href="javascript:Search()"><img src="/acar/images/center/button_search.gif" align="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
</body>
</html>
