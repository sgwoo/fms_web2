<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/smart/cookies.jsp" %>

<%
	String nm = request.getParameter("nm")==null?"":request.getParameter("nm");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	int count = 0;
	
	Vector vt = new Vector();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	vt 		= c_db.getUserSearchList("", gubun3, "", "Y");//String br_id, String dept_id, String t_wd, String use_yn
	int vt_size = vt.size();
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	te = parent.<%=nm%>;

<%	if(vt_size > 0){%>

	te.length = <%= vt_size+1 %>;
	te.options[0].value = '';
	te.options[0].text = '����';

<%		if(vt_size > 0){
			for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
				
	te.options[<%=i+1%>].value = '<%=ht.get("USER_ID")%>';
	te.options[<%=i+1%>].text = '<%=ht.get("USER_NM")%>';
<%				}
			if(gubun3.equals("0004")){ // ��ü������ ���� �ӿ� ���� �� ���� �ӿ��� �Ⱥ���, ��ä�� ����Ե� �Բ� ������. 2021.07.22
%>
				te.length = 5;
				te.options[3].value	= '000004';
				te.options[3].text		= '�Ⱥ���';
				te.options[4].value 	= '000005';
				te.options[4].text 		= '��ä��';
<%
			}
		}
	}else{	%>
	
	te.length = 1;
	te.options[0].value = '';
	te.options[0].text = '����';

<%	}	%>
//-->
</script>
</head>
<body>
</body>
</html>
