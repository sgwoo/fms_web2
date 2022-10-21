<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		fm.action = 'master_cms_print.jsp';
		fm.target='_self';
		fm.submit();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String adate = request.getParameter("adate")==null?"":request.getParameter("adate");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	//cms.member_user�� �������� ����Ÿ ��ȸ�ϱ�
	Vector vt = ai_db.getMemberCmsList(s_kd, t_wd);
	int vt_size = vt.size();
	
	int no_cnt = 0;
	
%>
<form name='form1' method='post'  >

<input type='hidden' name='sh_height' value='74'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td width='40' class='title'>����</td>
		  <td width='120' class='title'>��ȣ</td>
		  <td width='80' class='title'>������ȣ</td>
		  <td width='100' class='title'>����ȣ</td>
		    <td width='60' class='title'>����������</td>
		  <td width='50' class='title'>�����</td>
		  <td width='90' class='title'>����</td>
		  <td width='40' class='title'>�ڵ�</td>
		  <td width='90' class='title'>�������/�����</td>
		  <td width='90' class='title'>���¹�ȣ</td>
		  <td width='120' class='title'>������</td>		
		  <td width='70' class='title'>����ڵ�</td>
		  <td width='30' class='title'>ó��</td>
		   <td width='50' class='title'></td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			if ( ht.get("CMS_DEP_SSN").equals("") || ht.get("CMS_ACC_NO").equals("") ||  ht.get("CMS_BANK").equals("")  ||  ht.get("CMS_DEP_NM").equals("")  ) { 
			  no_cnt ++;
			} 
			
			%>
		<tr>
		  <td align="center" ><%=i+1%></td>
		  <td >&nbsp;<%=ht.get("FIRM_NM")%></td>
		  <td align="center" ><%=ht.get("CAR_NO")%></td>
		  <td align="center" ><%=ht.get("RENT_L_CD")%></td>
		  <td align="center" ><%=ht.get("CMS_START_DT")%></td>
		  <td align="center" ><%=ht.get("CMS_DAY")%></td>
		  <td align="center" ><%=ht.get("CMS_BANK")%></td>
		  <td align="center" ><%=ht.get("CMS_BK")%></td>
		   <td align="center" ><%=ht.get("CMS_DEP_SSN")%></td>
		  <td align="center" ><%=ht.get("CMS_ACC_NO")%></td>
		  <td align="left" ><%=ht.get("CMS_DEP_NM")%></td>
		  <td align="center" ><%=ht.get("ORG_CODE")%></td>
		  <td align="center" ><%=ht.get("CMS_STATUS")%></td>
		  <td align="center" ><%=ht.get("USER_NM")%></td>
		</tr>

<%}%>	
		
	  </table>
	</td>
  </tr>  
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.no_cnt.value = '<%=no_cnt%>';
//-->
</script>
</body>
</html>