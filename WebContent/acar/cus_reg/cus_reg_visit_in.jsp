<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*, acar.common.*" %>
<jsp:useBean id="cvBn" class="acar.cus_reg.Cycle_vstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");

	CusReg_Database cr_db = CusReg_Database.getInstance();	
	Cycle_vstBean[] cvBns = cr_db.getCycle_vstList(client_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
-->
</script>	
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%for(int i=0; i<cvBns.length; i++){
				cvBn = cvBns[i];%>
                <tr> 
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=4% align='center'><%= i+1 %></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=11% align="center"><%=AddUtil.ChangeDate2(cvBn.getVst_est_dt())%></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=11% align="center"><%=AddUtil.ChangeDate2(cvBn.getVst_dt())%></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=10% align="center"><%= c_db.getNameById(cvBn.getVisiter(),"USER") %></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=12% align="center"><%if(cvBn.getVst_pur().equals("1")){%>��ȸ�湮
          																												<% }else if(cvBn.getVst_pur().equals("2")){%>�ڵ�������
        																												<% }else if(cvBn.getVst_pur().equals("3")){%>�����
        																												<% }else if(cvBn.getVst_pur().equals("4")){%>��ü
        																												<% }else if(cvBn.getVst_pur().equals("5")){%>������Ǻ���
        																												<% }else if(cvBn.getVst_pur().equals("6")){%>��Ÿ
        																												<% } %></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=11% align="center"><%=cvBn.getSangdamja()%></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=25%>&nbsp;<%=Util.subData(cvBn.getVst_cont(),20)%></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=8% align="center"><a href="javascript:MM_openBrWindow('vst_reg.jsp?client_id=<%= client_id %>&seq=<%= cvBn.getSeq() %>','popwin_vst_reg','scrollbars=yes,status=no,resizable=no,width=850,height=350,top=50,left=50')">
        		  <% if(cvBn.getVst_title().equals("")){ %><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0><% }else{ %><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0><% } %></a></td>
                  <td <% if(cvBn.getVst_dt().equals("")){ %> <% }else{ %>class="is"<% } %> width=8% align="center"><a href="javascript:parent.deleteScdVst('<%= cvBn.getSeq() %>')"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a></td>
                </tr>
        <%}%>
        <% if(cvBns.length == 0) { %>
                <tr> 
                <td colspan="9" align='center'>�ش� �ŷ�ó �湮 �������� �����ϴ�.</td>
                </tr>
        <%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
