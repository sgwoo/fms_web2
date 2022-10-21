<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*, acar.offls_sui.*"%>
<%@ page import="java.io.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	/* multipart/form-data �� FileUpload��ü ���� */ 
	FileUpload file = new FileUpload("C:\\Inetpub\\wwwroot\\data\\sui\\", request.getInputStream());
	String suifile = file.getFilename()==null?"":file.getFilename();
	String lpgfile = file.getFilename2()==null?"":file.getFilename2();

	//�絵���� ��ĵ���� ����
	String old_suifile = file.getParameter("s_suifile");
	String new_suifile = suifile;
	if(!new_suifile.equals("")){
		if(!old_suifile.equals("") && !new_suifile.equals("")){
			File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\sui\\"+old_suifile+".pdf");
			drop_file.delete();
		}
	}else{
		suifile = old_suifile;
	}
	//�絵���� ��ĵ���� ����
	String s_suifile_del = file.getParameter("s_suifile_del")==null?"":file.getParameter("s_suifile_del");
	if(s_suifile_del.equals("1")){
		File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\"+old_suifile+".gif");
		drop_file.delete();
		suifile = "";
	}
	
	//LPG����μ�ø ��ĵ���� ����
	String old_lpgfile = file.getParameter("s_lpgfile");
	String new_lpgfile = lpgfile;
	if(!new_lpgfile.equals("")){
		if(!old_lpgfile.equals("") && !new_lpgfile.equals("")){
			File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\sui\\"+old_lpgfile+".pdf");
			drop_file.delete();
		}
	}else{
		lpgfile = old_lpgfile;
	}
	//LPG����μ�ø ��ĵ���� ����
	String s_lpgfile_del = file.getParameter("s_lpgfile_del")==null?"":file.getParameter("s_lpgfile_del");
	if(s_lpgfile_del.equals("1")){
		File drop_file = new File("C:\\Inetpub\\wwwroot\\data\\"+old_lpgfile+".gif");
		drop_file.delete();
		lpgfile = "";
	}

	String auth_rw = file.getParameter("auth_rw");
	String car_mng_id = file.getParameter("car_mng_id");
	String gubun = file.getParameter("gubun");
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
//	SuiBean sui = new SuiBean();
	SuiBean sui = olsD.getSui(car_mng_id);
	sui.setCar_mng_id(car_mng_id);
	sui.setSui_nm(file.getParameter("sui_nm"));
	sui.setSsn(file.getParameter("ssn1")+file.getParameter("ssn2"));
	sui.setRelation(file.getParameter("relation"));
	sui.setH_tel(file.getParameter("h_tel"));
	sui.setM_tel(file.getParameter("m_tel"));
	sui.setCont_dt(AddUtil.ChangeString(file.getParameter("cont_dt")));
	sui.setH_addr(file.getParameter("h_addr"));
	sui.setH_zip(file.getParameter("h_zip"));
	sui.setD_addr(file.getParameter("d_addr"));
	sui.setD_zip(file.getParameter("d_zip"));
	sui.setCar_nm(file.getParameter("car_nm"));
	sui.setCar_relation(file.getParameter("car_relation"));
	sui.setCar_addr(file.getParameter("car_addr"));
	sui.setCar_zip(file.getParameter("car_zip"));
	sui.setCar_ssn(file.getParameter("car_ssn1")+file.getParameter("car_ssn2"));
	sui.setCar_h_tel(file.getParameter("car_h_tel"));
	sui.setCar_m_tel(file.getParameter("car_m_tel"));
	sui.setEtc(file.getParameter("etc"));
	sui.setSuifile(suifile);
	sui.setLpgfile(lpgfile);
	sui.setAss_st_dt(AddUtil.ChangeString(file.getParameter("ass_st_dt")));
	sui.setAss_ed_dt(AddUtil.ChangeString(file.getParameter("ass_ed_dt")));
	sui.setAss_st_km(AddUtil.parseDigit3(file.getParameter("ass_st_km")));
	sui.setAss_ed_km(AddUtil.parseDigit3(file.getParameter("ass_ed_km")));
	sui.setAss_wrt(file.getParameter("ass_wrt"));
	sui.setMm_pr(AddUtil.parseDigit(file.getParameter("mm_pr")));
	sui.setCont_pr(AddUtil.parseDigit(file.getParameter("cont_pr")));
	sui.setJan_pr(AddUtil.parseDigit(file.getParameter("jan_pr")));
	sui.setModify_id(user_id);
	sui.setCont_pr_dt(AddUtil.ChangeString(file.getParameter("cont_pr_dt")==null?"":file.getParameter("cont_pr_dt")));
	sui.setJan_pr_dt(AddUtil.ChangeString(file.getParameter("jan_pr_dt")==null?"":file.getParameter("jan_pr_dt")));

	int result = 0;
	if(gubun.equals("u")){
		result = olsD.upSui(sui);
	}else if(gubun.equals("i")){
		result = olsD.inSui(sui);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result > 0){
	if(gubun.equals("i")){%>
		alert("��ϵǾ����ϴ�.");
	<%}else if(gubun.equals("u")){%>
		alert("�����Ǿ����ϴ�.");
	<%}%>
	parent.location.href = "/acar/off_ls_cmplt/off_ls_cmplt_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	location.href = "/acar/off_ls_cmplt/off_ls_cmplt_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}%>
//-->
</script>
</body>
</html>
