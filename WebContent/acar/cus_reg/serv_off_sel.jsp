<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	ServOffDatabase sod = ServOffDatabase.getInstance();
	String page_gubun = request.getParameter("h_page_gubun")==null?"":request.getParameter("h_page_gubun");

	if(page_gubun.equals("NEW")){ //�űԵ���� ��
		so_bean.setCar_comp_id(request.getParameter("car_comp_id"));
		so_bean.setOff_nm(request.getParameter("off_nm"));
		so_bean.setOff_st(request.getParameter("off_st"));
		so_bean.setOwn_nm(request.getParameter("own_nm"));
		so_bean.setEnt_no(request.getParameter("t_ent_no1")+request.getParameter("t_ent_no2")+request.getParameter("t_ent_no3"));
		so_bean.setOff_sta(request.getParameter("off_sta"));
		so_bean.setOff_item(request.getParameter("off_item"));
		so_bean.setOff_tel(request.getParameter("off_tel"));
		so_bean.setOff_fax(request.getParameter("off_fax"));
		so_bean.setHomepage(request.getParameter("homepage"));
		so_bean.setOff_post(request.getParameter("t_zip"));
		so_bean.setOff_addr(request.getParameter("t_addr"));
		so_bean.setBank(request.getParameter("bank"));
		so_bean.setAcc_no(request.getParameter("acc_no"));
		so_bean.setAcc_nm(request.getParameter("acc_nm"));
		so_bean.setNote(request.getParameter("note"));
	
		so_bean = sod.insServOff(so_bean);	//off_id�� �߰��� �ǵ�����.

	}else if(page_gubun.equals("EXT")){ // �˻���� ������ �����ü�� ������ ȭ������ �����ش�
		String off_id = request.getParameter("off_id");
		so_bean = sod.getServOff(off_id);
	}
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">
<script language='javascript'>
<%if(so_bean != null){ //����
	if(page_gubun.equals("NEW")){	%>
		alert('���������� ��ϵǾ����ϴ�');
<%	}
//System.out.println("off_id="+so_bean.getOff_id());
	%>
	var fm = parent.opener.form1;
	fm.off_id.value = <%= "'"+so_bean.getOff_id()+"'" %>;
	fm.off_nm.value = <%= "'"+so_bean.getOff_nm()+"'" %>;
	//fm.ent_no.value = <%= "'"+so_bean.getEnt_no()+"'"%>;
	//fm.own_nm.value = <%= "'"+so_bean.getOwn_nm()+"'" %>;
	//fm.off_st.value = <%= "'"+so_bean.getOff_st()+"��'" %>;
	//fm.off_addr.value = <%= "'"+so_bean.getOff_addr()+"'" %>;
	//fm.off_tel.value = <%= "'"+so_bean.getOff_tel()+"'" %>;
	//fm.off_fax.value = <%= "'"+so_bean.getOff_fax()+"'" %>;
	//parent.opener.regService("u");
<%}else{ //����
	if(page_gubun.equals("NEW")){	%>
		alert('��ϵ��� �ʾҽ��ϴ�');
<%	}
}%>
parent.close();
</script>
</body>
</html>