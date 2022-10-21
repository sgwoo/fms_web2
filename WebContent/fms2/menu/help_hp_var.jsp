<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*,acar.user_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSikVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String brch = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//���� ����
	EstiDatabase e_db = EstiDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	EstiSikVarBean [] ea_r = e_db.getEstiSikVarList("hp_var");
	int size = ea_r.length;
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�����ϱ�
	function var_update(idx){
		var fm = document.form1;	
		fm.var_cd.value = fm.u_var_cd[idx].value;				
		fm.var_sik.value = fm.u_var_sik[idx].value;	
		fm.a_j.value = fm.u_a_j[idx].value;					
		if(!confirm('�����Ͻðڽ��ϱ�?'))	return;
		fm.target='i_no';
		fm.submit();		
	}			
	function indexReload(){
		opener.location.reload();
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="/fms2/menu/help_hp_var_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=brch%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type="hidden" name="cmd" value="u">
<input type="hidden" name="size" value="<%=size%>">
<input type="hidden" name="a_a" value="1">
<input type="hidden" name="seq" value="01">
<input type="hidden" name="var_cd" value="">
<input type="hidden" name="var_sik" value="">
<input type="hidden" name="a_j" value="">
<table border=0 cellspacing=0 cellpadding=0 width="600">
  <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Ȩ������ ���� ������� ���� </span></td>
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
        <td class=line>                    
            <table border="0" cellspacing="1" cellpadding="0" width="600">
                <tr> 
                    <td width="110" class=title>�����ڵ�</td>
                    <td width="220" class=title>������</td>
                    <td class=title width="160">������</td>
                    <td width="110" class=title>������¥</td>
                    <td width="110" class=title>ó��</td>
                </tr>
          <%
		  int cnt = -1;
		  for(int i=0; i<size; i++){
			bean = ea_r[i];
		
			String var_sik = bean.getVar_sik();
			cnt++;
			%>
                <tr> 
                    <input type="hidden" name="u_var_cd" value="<%=bean.getVar_cd()%>">
                    <td align=center><%=bean.getVar_cd()%></td>
                    <td align=center><%=bean.getVar_nm()%></td>
                    <td align=center><input type="text" name="u_var_sik" size="12" class="num" value="<%=var_sik%>"> </td>
                    <td align=center><input type="text" name="u_a_j" size="12" class="text" value="<%=bean.getA_j()%>">  </td>
                    <td align="center"> 
                      <%	if(  nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("�����������",ck_acar_id) ){%>
                      <a href="javascript:var_update(<%=cnt%>);"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a> 
                      <%	}%>
                    </td>
                </tr>
            <%}%>
            </table>
        </td>
    </tr>
    <tr>    	
        <td align="right"><a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif border=0></a></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>