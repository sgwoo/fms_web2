<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="piod" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String[] pre = request.getParameterValues("pr");
	String c_id = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	for(int i=0; i<pre.length; i++){
		pre[i] = pre[i].substring(0,6);
		c_id = pre[i];
		
	
		int result2 = piod.parking_del2(c_id);
		int cnt3 = piod.updateParkIoGubun(c_id);// �Ű����� ����� io_gubun 3->'' �� ���� :20160905   
				
		int cnt = c_db.updateCons_dtNOT(c_id);//Ź������ �ʱ�ȭ
		int cnt2 = c_db.updateActn_idReset(c_id);//����� �ʱ�ȭ
		
	}

	int result = olyD.cancelOffls_pre(pre);
		
			
	String url = "off_ls_pre_frame.jsp";
	
	if(from_page.equals("/acar/off_lease/off_lease_frame.jsp")){
		url = from_page;
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
	alert("ó���Ǿ����ϴ�.\n�ش������� �������� ��Ȳȭ�鿡�� Ȯ���Ͻñ� �ٶ��ϴ�.");
	window.top.frames["d_content"].location = "<%=url%>?auth_rw=<%=auth_rw%>";
	//parent.parent.parent.d_content.location.href = "<%=url%>?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.top.frames["d_content"].location = "<%=url%>?auth_rw=<%=auth_rw%>";
	//parent.parent.parent.d_content.location.href = "<%=url%>?auth_rw=<%=auth_rw%>";
<%}%>
//-->
</script>
</body>
</html>

