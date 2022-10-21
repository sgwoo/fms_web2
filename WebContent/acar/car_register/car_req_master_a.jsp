<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id"); //�����
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd"); //����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");  //gubun:ag :���ɿ���� �ӽð˻� -  �ѹ��� �Ƿ�
	
	String m1_chk = request.getParameter("m1_chk")==null?"":request.getParameter("m1_chk");
	String m1_content = request.getParameter("m1_content")==null?"":request.getParameter("m1_content");
	
	boolean flag1 = true;
	
	String m1_no= "";
	
	int count = 1;
	
	int result = 0;
	
	count = rs_db.updateCarReqMaster1(c_id, m1_chk);
	
	String off_nm = "�����ڵ���";
	String off_id = "007410"; //�����ڵ��� setting  005591 -> 007410,  �λ� - �ϵ�����Ź�� 008411
	
	if ( m1_chk.equals("5")) {	
		off_id = "008411";      //�ϵ�����Ź��
		//off_nm = "�ϵ�����Ź�۹���";
		off_nm = "������Ƽ�ڸ���";
	} 
		
	//1. �ڵ����˻� ���----------------------------------------------------------------------------------------	
			
	CarMaintReqBean cons = new CarMaintReqBean();
				
	cons.setMng_id			(mng_id);
	cons.setCar_mng_id		(c_id);
	cons.setRent_l_cd		(l_cd);
	cons.setM1_chk			(m1_chk);
	cons.setM1_content		(m1_content);
	cons.setOff_id			(off_id);
	cons.setOff_nm			(off_nm);
	cons.setGubun			(gubun);
		
	m1_no = rs_db.insertCarMaintReq(cons);
	
	if(m1_no.equals("")){
		result++;
	}
		
	
%>
<script language='javascript'>
<%	if(result  == 0){%>
		alert('���������� ó���Ǿ����ϴ�');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
</script>
</body>
</html>
