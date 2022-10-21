<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_cmplt.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="java.io.*"%>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	/* multipart/form-data �� FileUpload��ü ���� */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\data\\actn\\", request.getInputStream());
	String lpgfile = file.getFilename()==null?"":file.getFilename();

System.out.println("lpgfile="+lpgfile);

	//LPG����μ�ø ��ĵ���� ����
	String old_lpgfile = file.getParameter("s_lpgfile");
	String new_lpgfile = lpgfile;
	if(!new_lpgfile.equals("")){
		if(!old_lpgfile.equals("") && !new_lpgfile.equals("")){
			File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\actn\\"+old_lpgfile+".pdf");
			drop_file.delete();
		}
	}else{
		lpgfile = old_lpgfile;
	}
	//LPG����μ�ø ��ĵ���� ����
	String s_lpgfile_del = file.getParameter("s_lpgfile_del")==null?"":file.getParameter("s_lpgfile_del");
	if(s_lpgfile_del.equals("1")){
		File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\actn\\"+old_lpgfile+".gif");
		drop_file.delete();
		lpgfile = "";
	}

	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = file.getParameter("auth_rw");
	String car_mng_id = file.getParameter("car_mng_id");
	String gubun = file.getParameter("gubun");
	
	CmpltBean cmplt = new CmpltBean();
	cmplt.setCar_mng_id(car_mng_id);
	cmplt.setClient_id(file.getParameter("client_id"));
	cmplt.setMm_amt(AddUtil.parseDigit(file.getParameter("mm_amt")));
	cmplt.setIp_dt(AddUtil.ChangeString(file.getParameter("ip_dt")));
	cmplt.setConv_dt(AddUtil.ChangeString(file.getParameter("conv_dt")));
	cmplt.setChul_su(AddUtil.parseDigit(file.getParameter("chul_su")));
	cmplt.setNak_su(AddUtil.parseDigit(file.getParameter("nak_su")));
	cmplt.setTak_su(AddUtil.parseDigit(file.getParameter("tak_su")));
	cmplt.setLpgfile(lpgfile);

	int result = 0;
	if(gubun.equals("u")){
		result = olcD.upCmpltBean(cmplt);
	}else if(gubun.equals("i")){
		result = olcD.inCmpltBean(cmplt);
	}else if(gubun.equals("d")){
		//result = olcD.delCmpltBean(cmplt);
	}else if(gubun.equals("c")){
		//result = olcD.setInsur(ins);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){
	if(gubun.equals("i")){%>
		alert("��ϵǾ����ϴ�.");
	<%}else if(gubun.equals("u")){%>
		alert("�����Ǿ����ϴ�.");
	<%}%>
	parent.parent.reg_o.location.href = "off_ls_cmplt_reg_o.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
