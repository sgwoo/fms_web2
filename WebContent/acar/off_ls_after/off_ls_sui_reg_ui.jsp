<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*, acar.offls_sui.*, acar.car_register.*, acar.user_mng.*, acar.coolmsg.*, acar.car_scrap.*, acar.common.*"%>
<%@ page import="java.io.*, acar.cont.* "%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	/* multipart/form-data �� FileUpload��ü ���� */ 
	/*
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
*/
	String auth_rw = request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun");
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
		
	cr_bean = crd.getCarRegBean(car_mng_id);
		
//	SuiBean sui = new SuiBean();
	SuiBean sui = olsD.getSui(car_mng_id);
	sui.setCar_mng_id(car_mng_id);
	sui.setSui_nm(request.getParameter("sui_nm"));
	sui.setSsn(request.getParameter("ssn1")+request.getParameter("ssn2"));
	sui.setRelation(request.getParameter("relation"));
	sui.setH_tel(request.getParameter("h_tel"));
	sui.setM_tel(request.getParameter("m_tel"));
	sui.setCont_dt(AddUtil.ChangeString(request.getParameter("cont_dt")));
	sui.setH_addr(request.getParameter("h_addr"));
	sui.setH_zip(request.getParameter("h_zip"));
	sui.setD_addr(request.getParameter("d_addr"));
	sui.setD_zip(request.getParameter("d_zip"));
	sui.setCar_nm(request.getParameter("car_nm"));
	sui.setCar_relation(request.getParameter("car_relation"));
	sui.setCar_addr(request.getParameter("car_addr"));
	sui.setCar_zip(request.getParameter("car_zip"));
	sui.setCar_ssn(request.getParameter("car_ssn1")+request.getParameter("car_ssn2"));
	sui.setCar_h_tel(request.getParameter("car_h_tel"));
	sui.setCar_m_tel(request.getParameter("car_m_tel"));
	sui.setEtc(request.getParameter("etc"));
	//sui.setSuifile(suifile);
	//sui.setLpgfile(lpgfile);
	sui.setAss_st_dt(AddUtil.ChangeString(request.getParameter("ass_st_dt")));
	sui.setAss_ed_dt(AddUtil.ChangeString(request.getParameter("ass_ed_dt")));
	sui.setAss_st_km(AddUtil.parseDigit3(request.getParameter("ass_st_km")));
	sui.setAss_ed_km(AddUtil.parseDigit3(request.getParameter("ass_ed_km")));
	sui.setAss_wrt(request.getParameter("ass_wrt"));
	sui.setMm_pr(AddUtil.parseDigit(request.getParameter("mm_pr")));
	sui.setCont_pr(AddUtil.parseDigit(request.getParameter("cont_pr")));
	sui.setJan_pr(AddUtil.parseDigit(request.getParameter("jan_pr")));
	sui.setModify_id(user_id);
	sui.setCont_pr_dt(AddUtil.ChangeString(request.getParameter("cont_pr_dt")==null?"":request.getParameter("cont_pr_dt")));
	sui.setJan_pr_dt(AddUtil.ChangeString(request.getParameter("jan_pr_dt")==null?"":request.getParameter("jan_pr_dt")));
	String o_migr_dt = sui.getMigr_dt();
	sui.setMigr_dt(AddUtil.ChangeString(request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt")));
	String n_migr_dt = sui.getMigr_dt();
	sui.setMigr_no(request.getParameter("migr_no")==null?"":request.getParameter("migr_no"));
	String enp_no1 = request.getParameter("enp_no1")==null?"":request.getParameter("enp_no1");
	String enp_no2 = request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2");
	String enp_no3 = request.getParameter("enp_no3")==null?"":request.getParameter("enp_no3");
	sui.setEnp_no(enp_no1+enp_no2+enp_no3);
	sui.setEmail(request.getParameter("email")==null?"":request.getParameter("email"));
	sui.setClient_id(request.getParameter("client_id")==null?"":request.getParameter("client_id"));

	int result = 0;
	if(gubun.equals("u")){
		result = olsD.upSui(sui);
	}else if(gubun.equals("i")){
		result = olsD.inSui(sui);
	}else if(gubun.equals("p")){
		result = olsD.upSui(sui);
		result = olsD.regCls_cont(sui);
		
		//��Ʈ������ȣ ������ �ѱ��-------------------------------
						
		if(cr_bean.getCar_use().equals("1")){
			String car_ext = c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext());
			if(sc_db.getScrapCheck(cr_bean.getCar_no())==0){
				int result2 = sc_db.car_scrap_i(cr_bean.getCar_no(), cr_bean.getCar_nm(), AddUtil.getDate(), car_ext);
			}
		}		
	}
	
	if(gubun.equals("i") || gubun.equals("u")){
		if(o_migr_dt.equals("") && !n_migr_dt.equals("")){
			//���躯���û ���ν��� ȣ��
			String  d_flag2 =  ec_db.call_sp_ins_cng_req("�Ű� ���������� ���", "", car_mng_id, "");
		}
	}
	
	// �����Է��� ��� �޽����� �޼��� ����
	if(gubun.equals("i")){
	
		// ���ǰ�� ���� �Է��� ȸ�����ڿ��� �޼��� ����------------------------------------------------------------------------------------------
		
		boolean flag2 = true;
		
		

		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		String sub 		= "���ǰ��  ȸ�� ó�� ���";
		String cont 	= "[������ȣ:"+cr_bean.getCar_no()+"] ���ǰ�� ȸ�� ó�� �ϼ���.";	
			
		String url 		= "/tax/issue_3/issue_3_frame3.jsp";	 
		
		String target_id =  nm_db.getWorkAuthUser("����������");

	//	String target_id = "000131";  //���ǰ�� ȸ�� �����		000092->000114 -> 000093 -> 000116 -> 000058	-> 000126 -> 000131
				
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
			
		System.out.println("��޽���(���ǰ���������)"+cr_bean.getCar_no()+"---------------------"+target_bean.getUser_nm());	
	}
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result > 0){
	if(gubun.equals("i")){%>
		alert("��ϵǾ����ϴ�.");
		parent.location.href = "/acar/off_ls_sui/off_ls_sui_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	<%}else if(gubun.equals("u")){%>
		alert("�����Ǿ����ϴ�.");
		parent.parent.location.href = "/acar/off_ls_sui/off_ls_sui_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
	<%}else if(gubun.equals("p")){%>
		alert("�Ű�ó���Ǿ����ϴ�.\n�ڵ���ó���İ������� Ȯ���Ͻñ� �ٶ��ϴ�.");
		parent.parent.parent.location.href = "/acar/off_ls_after/off_ls_after_frame.jsp?auth_rw=<%=auth_rw%>";
	<%}%>
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	location.href = "/acar/off_ls_sui/off_ls_sui_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}%>
//-->
</script>
</body>
</html>
