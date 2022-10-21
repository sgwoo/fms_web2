<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.*, acar.estimate_mng.* "%>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSikVarBean" scope="page"/>
<%@ include file="/acct/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");

	
	
	
	//��������
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstiSikVarBean [] ea_r = e_db.getEstiSikVarList("acct");
	int size = ea_r.length;
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ϱ�
	function save(){
		var fm = document.form1;
		var size = toInt(fm.size.value);
		for(i=0; i<size; i++){
			if(fm.var_sik[i].value == ''){ alert("�������� Ȯ���Ͻʽÿ�."); fm.var_sik[i].focus(); return; }
		}	
		if(confirm('���� �Ͻðڽ��ϱ�?')){		
			fm.target='i_no';
			fm.action = "var_mng_a.jsp";	
			fm.submit();		
		}
	}			
	
	
	//�ʱ�ȭ�鰡��
	function f_init()
	{
		var fm = document.form1;
		fm.target = "_self";
		fm.action = "var_mng.jsp";	
		fm.submit();
	}	
//-->
</script>
</head>

<body leftmargin="15">
<form name="form1" method="post" action="">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type="hidden" name="size" value="<%=size%>">
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acct/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > Master > <span class=style5>��������</span></span></td>
            <td width=7><img src=/acct/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>  
    <tr>
      <td class=line>                    
        <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <tr> 
            <td width="5%" class=title>No.</td>
            <td width="20%" class=title>�����ڵ�</td>
            <td width="35%" class=title>������</td>
            <td width="40%" class=title>������</td>
          </tr>
          <%	int cnt = -1;
		for(int i=0; i<size; i++){
			bean = ea_r[i];
			String var_sik = bean.getVar_sik();
			if(bean.getVar_cd().equals("acct_s_dt")||bean.getVar_cd().equals("acct_e_dt")) 		var_sik = AddUtil.ChangeDate2(var_sik);
			cnt++;
	  %>
          <input type="hidden" name="var_cd" value="<%=bean.getVar_cd()%>">	
          <tr>                     
            <td align=center><%=i+1%></td>
            <td align=center><%=bean.getVar_cd()%></td>
            <td align=center><%=bean.getVar_nm()%></td>
            <td align=center><input type="text" name="var_sik" size="15" class="text" value="<%=var_sik%>"></td>            
          </tr>
          <%}%>          
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>	       
    <tr>
      <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
          <a href="javascript:save();"><img src=/acct/images/center/button_modify.gif align=absmiddle border=0></a> 
        <%}%>
      </td>
    </tr>	       
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>