<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] pre = request.getParameterValues("pr");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	

	int result = olpD.setOffls_pre(pre);
			
	
	//�縮������ ����ϱ�
		
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String car_mng_id = "";
	
	for(int i=0 ; i<pre.length ; i++){
		car_mng_id = pre[i]==null?"":pre[i];
		
		//�ֱ� Ȩ������ ����뿩��
		Hashtable hp = oh_db.getSecondhandCase_20090901("", "", car_mng_id);
		
		//������ ������ ������ ������.
		if(!String.valueOf(hp.get("UPLOAD_DT")).equals(AddUtil.getDate(4))){
			//�縮�� ���
			String  d_flag1 =  e_db.call_sp_esti_reg_sh(car_mng_id);
		}
	
	}	
	
	
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >= 1){%>
	alert("��ϵǾ����ϴ�.\n�������� �Ű����� �ڵ��� ��Ȳ���� Ȯ���Ͻñ� �ٶ��ϴ�.");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//parent.parent.location.href = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//parent.c_foot.inner.location.href = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}%>
//-->
</script>
</body>
</html>
