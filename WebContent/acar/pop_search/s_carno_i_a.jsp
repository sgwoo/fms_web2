<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ca.*"%>
<jsp:useBean id="CaNoDb" class="acar.ca.CaNoDatabase" scope="page"/>
<jsp:useBean id="CaNoBn" class="acar.beans.CaNoBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�ڵ��� ��Ϲ�ȣ ����(CA_NO)
	CaNoBn.setCar_no_id		(request.getParameter("car_no_id"));
	CaNoBn.setCar_no		(request.getParameter("car_no"));
	CaNoBn.setInit_reg_dt	(Util.ChangeString(request.getParameter("init_reg_dt")));
	CaNoBn.setReg_ext		(request.getParameter("reg_ext"));
	CaNoBn.setBr_id			(request.getParameter("br_id"));
	//CaNoBn.setExp_dt		(request.getParameter("exp_dt"));		//������
	//CaNoBn.setExp_cau		(request.getParameter("exp_cau"));		//���һ���
	CaNoBn.setReg_id		(user_id); 

	//�ش� Bean ���.
	int result = CaNoDb.insertCaNo(CaNoBn);  

%>

<html>
<head>
<title></title>
</head>

<body>
<script language='javascript'>
<%	if(result > 0){	%>
		alert('������ȣ�� ��� �Ǿ����ϴ�.');
		parent.location.href = "./s_carno.jsp";
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');		
<%	}	%>
</script>
</body>
</html>
