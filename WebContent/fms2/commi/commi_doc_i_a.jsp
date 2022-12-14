<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String agent_doc_st	= request.getParameter("agent_doc_st")==null?"":request.getParameter("agent_doc_st");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	//1. ???????????? fee-----------------------------------------------------------------------------------------
	
	String pp_st		 	= request.getParameter("pp_st")==null?"":request.getParameter("pp_st");
	if(!pp_st.equals("????")){
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		String old_pp_est_dt 	= fee.getPp_est_dt();
		String old_pp_etc 		= fee.getPp_etc();
		String new_pp_est_dt	= request.getParameter("pp_est_dt")==null?"":request.getParameter("pp_est_dt");
		String new_pp_etc		= request.getParameter("pp_etc")==null?"":request.getParameter("pp_etc");
		String old_pp 			= old_pp_est_dt+old_pp_etc;
		String new_pp 			= AddUtil.replace(new_pp_est_dt,"-","")+new_pp_etc;
		if(!old_pp.equals(new_pp)){
			fee.setPp_est_dt	(new_pp_est_dt);
			fee.setPp_etc		(new_pp_etc);
			//=====[fee] update=====
			flag1 = a_db.updateContFeeNew(fee);
		}
	}


	//2. ???????????? gua_ins--------------------------------------------------------------------------------------
	
	String gi_st		 	= request.getParameter("gi_st")==null?"":request.getParameter("gi_st");
	if(!gi_st.equals("????")){
		ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
		String old_gi_est_dt 	= gins.getGi_est_dt();
		String old_gi_etc 		= gins.getGi_etc();
		String new_gi_est_dt	= request.getParameter("gi_est_dt")==null?"":request.getParameter("gi_est_dt");
		String new_gi_etc		= request.getParameter("gi_etc")==null?"":request.getParameter("gi_etc");
		String old_gi 			= old_gi_est_dt+old_gi_etc;
		String new_gi 			= AddUtil.replace(new_gi_est_dt,"-","")+new_gi_etc;
		if(!old_gi.equals(new_gi)){
			gins.setGi_est_dt	(new_gi_est_dt);
			gins.setGi_etc		(new_gi_etc);
			//=====[gua_ins] update=====
			flag2 = a_db.updateGiInsNew(gins);
		}
	}


	//4. ???????????? commi-------------------------------------------------------------------------------------------
	
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	emp1.setCommi		(request.getParameter("commi")			==null? 0:Util.parseDigit(request.getParameter("commi")));
	emp1.setInc_amt		(request.getParameter("inc_amt")		==null? 0:Util.parseDigit(request.getParameter("inc_amt")));
	emp1.setRes_amt		(request.getParameter("res_amt")		==null? 0:Util.parseDigit(request.getParameter("res_amt")));
	emp1.setTot_amt		(request.getParameter("c_amt")			==null? 0:Util.parseDigit(request.getParameter("c_amt")));
	emp1.setDif_amt		(request.getParameter("d_amt")			==null? 0:Util.parseDigit(request.getParameter("d_amt")));
	emp1.setAdd_amt1	(request.getParameter("add_amt1")		==null? 0:Util.parseDigit(request.getParameter("add_amt1")));
	emp1.setAdd_amt2	(request.getParameter("add_amt2")		==null? 0:Util.parseDigit(request.getParameter("add_amt2")));
	emp1.setAdd_amt3	(request.getParameter("add_amt3")		==null? 0:Util.parseDigit(request.getParameter("add_amt3")));
	emp1.setAdd_cau1	(request.getParameter("add_cau1")		==null?"":request.getParameter("add_cau1"));
	emp1.setAdd_cau2	(request.getParameter("add_cau2")		==null?"":request.getParameter("add_cau2"));
	emp1.setAdd_cau3	(request.getParameter("add_cau3")		==null?"":request.getParameter("add_cau3"));
	emp1.setInc_per		(request.getParameter("inc_per")		==null?"":request.getParameter("inc_per"));
	emp1.setRes_per		(request.getParameter("res_per")		==null?"":request.getParameter("res_per"));
	emp1.setTot_per		(request.getParameter("tot_per")		==null?"":request.getParameter("tot_per"));
	emp1.setEmp_acc_nm	(request.getParameter("emp_acc_nm")		==null?"":request.getParameter("emp_acc_nm"));
	emp1.setRel		(request.getParameter("rel")			==null?"":request.getParameter("rel"));
	emp1.setRec_incom_yn	(request.getParameter("rec_incom_yn")		==null?"":request.getParameter("rec_incom_yn"));
	emp1.setRec_incom_st	(request.getParameter("rec_incom_st")		==null?"":request.getParameter("rec_incom_st"));
	emp1.setEmp_bank	(request.getParameter("emp_bank")		==null?"":request.getParameter("emp_bank"));
	emp1.setEmp_acc_no	(request.getParameter("emp_acc_no")		==null?"":request.getParameter("emp_acc_no"));
	emp1.setRec_ssn		(request.getParameter("rec_ssn")		==null?"":request.getParameter("rec_ssn"));
	emp1.setRec_zip		(request.getParameter("t_zip")			==null?"":request.getParameter("t_zip"));
	emp1.setRec_addr	(request.getParameter("t_addr")			==null?"":request.getParameter("t_addr"));
	emp1.setReq_dt		(AddUtil.getDate());
	emp1.setReq_id		(user_id);
	emp1.setAdd_st1		(request.getParameter("add_st1")		==null?"":request.getParameter("add_st1"));
	emp1.setAdd_st2		(request.getParameter("add_st2")		==null?"":request.getParameter("add_st2"));
	emp1.setAdd_st3		(request.getParameter("add_st3")		==null?"":request.getParameter("add_st3"));
	emp1.setComm_r_rt	(request.getParameter("comm_r_rt")		==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
	emp1.setCommi_car_amt	(request.getParameter("commi_car_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
	emp1.setDlv_con_commi	(request.getParameter("dlv_con_commi")		==null? 0:Util.parseDigit(request.getParameter("dlv_con_commi")));
	emp1.setDlv_tns_commi	(request.getParameter("dlv_tns_commi")		==null? 0:Util.parseDigit(request.getParameter("dlv_tns_commi")));
	emp1.setAgent_commi	(request.getParameter("agent_commi")		==null? 0:Util.parseDigit(request.getParameter("agent_commi")));
	emp1.setVat_amt		(request.getParameter("vat_amt")		==null? 0:Util.parseDigit(request.getParameter("vat_amt")));
	emp1.setVat_per		(request.getParameter("vat_per")		==null?"":request.getParameter("vat_per"));
	emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
	if(!emp1.getBank_cd().equals("")){
		emp1.setEmp_bank		(c_db.getNameById(emp1.getBank_cd(), "BANK"));
	}
	
	
	//???????????? car_off_emp-------------------------------------------------------------------------------------
	
	coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	String emp_email 	= request.getParameter("emp_email")==null?"":request.getParameter("emp_email");
	String emp_m_tel 	= request.getParameter("emp_m_tel")==null?"":request.getParameter("emp_m_tel");
	
	if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && !coe_bean.getEmp_email().equals(emp_email)) result = cod.updateCarOffEmpMail(emp1.getEmp_id(), emp_email);
	if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && !coe_bean.getEmp_m_tel().equals(emp_m_tel)) result = cod.updateCarOffEmp(emp1.getEmp_id(), emp_m_tel);
	
	if(!agent_doc_st.equals("2")){
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getEmp_ssn1().equals("") && !emp1.getRec_ssn().equals("")) 		result = cod.updateCarOffEmp(emp1.getEmp_id(), "3", emp1.getRec_ssn(), "");
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getEmp_addr().equals("") && !emp1.getRec_addr().equals("")) 		result = cod.updateCarOffEmp(emp1.getEmp_id(), "4", emp1.getRec_zip(), emp1.getRec_addr());
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getCust_st().equals("") && !emp1.getRec_incom_st().equals("")) 	result = cod.updateCarOffEmp(emp1.getEmp_id(), "5", emp1.getRec_incom_st(), "");
	}
	
	//=====[commi] update=====
	flag4 = a_db.updateCommiNew(emp1);


	//5. ?????????? ????-------------------------------------------------------------------------------------------
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 	= "?????????? ???? ????";
	String cont 	= "["+firm_nm+"] ?????????? ?????? ??????????.";
	
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st("1");//????????????????
	doc.setDoc_id(rent_l_cd);
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc("");
	doc.setUser_nm1("??????");
	doc.setUser_nm2("??????");
	doc.setUser_nm3("????????");
	doc.setUser_nm4("????????");
	doc.setUser_nm6("??????????");
	doc.setUser_nm7("??????????");
	doc.setUser_nm8("????????");	
	doc.setUser_nm9("????????");
	doc.setUser_id1(user_id);
	
	
	String user_id2 = "";
	String user_id3 = "";
	String user_id6 = "";
	String user_id7 = "";
	String user_id8 = "";
	
	doc.setDoc_step("2");//????
	
	user_id2 = "XXXXXX";//??????????
	user_id3 = "XXXXXX";//????????????

	doc.setDoc_bit("5");//????2???? - ??????, ???????? ????
	
		
	if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){
		user_id6 = nm_db.getWorkAuthUser("????????????");
		user_id7 = nm_db.getWorkAuthUser("??????????");
		user_id8 = nm_db.getWorkAuthUser("????????????");		
	}else{
		doc.setUser_nm8("??????");
		user_id8 = "XXXXXX";//??????-????

		if(br_id.equals("B1")||br_id.equals("U1")){
			user_id6 = nm_db.getWorkAuthUser("????????????????");
			user_id7 = nm_db.getWorkAuthUser("??????????");
		}else if(br_id.equals("G1")){
			user_id6 = nm_db.getWorkAuthUser("????????????????");
			user_id7 = nm_db.getWorkAuthUser("??????????");
		}else if(br_id.equals("D1")){
			user_id6 = nm_db.getWorkAuthUser("????????????????");
			user_id7 = nm_db.getWorkAuthUser("??????????");
		}else if(br_id.equals("J1")){
			user_id6 = nm_db.getWorkAuthUser("????????????????");
			user_id7 = nm_db.getWorkAuthUser("??????????");
		}
	}
	
	
	CarScheBean cs_bean6 = csd.getCarScheTodayBean(user_id6);
	CarScheBean cs_bean7 = csd.getCarScheTodayBean(user_id7);
	CarScheBean cs_bean8 = csd.getCarScheTodayBean(user_id8);

	if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){
		if(!cs_bean6.getUser_id().equals("")) 	user_id6 = cs_bean6.getWork_id();
		if(!cs_bean7.getUser_id().equals("")) 	user_id7 = cs_bean7.getWork_id();
		//???????? ?????? ??????????
		if(!cs_bean8.getUser_id().equals("")) 	user_id8 = nm_db.getWorkAuthUser("????????????????????");
	}
	if(br_id.equals("B1")){
		if(!cs_bean6.getUser_id().equals("")) 	user_id6 = cs_bean6.getWork_id();
		if(!cs_bean7.getUser_id().equals("") && user_id7.equals(nm_db.getWorkAuthUser("??????????"))) 		user_id7 = nm_db.getWorkAuthUser("??????????");
	}
	if(br_id.equals("G1")){
		if(!cs_bean6.getUser_id().equals("")) 	user_id6 = cs_bean6.getWork_id();
		if(!cs_bean7.getUser_id().equals("") && user_id7.equals(nm_db.getWorkAuthUser("??????????"))) 		user_id7 = nm_db.getWorkAuthUser("??????????");
	}
	if(br_id.equals("D1")){
		if(!cs_bean6.getUser_id().equals("")) 	user_id6 = cs_bean6.getWork_id();
		if(!cs_bean7.getUser_id().equals("") && user_id7.equals(nm_db.getWorkAuthUser("??????????"))) 		user_id7 = nm_db.getWorkAuthUser("??????????");
	}
	if(br_id.equals("J1")){
		if(!cs_bean6.getUser_id().equals("")) 	user_id6 = cs_bean6.getWork_id();
		if(!cs_bean7.getUser_id().equals("") && user_id7.equals(nm_db.getWorkAuthUser("??????????"))) 		user_id7 = nm_db.getWorkAuthUser("??????????");
	}	
	
	if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){
	}else{
		//???? ?????? ?????? ?????? ???????? ????????	
		if(!cs_bean7.getUser_id().equals("")){
			user_id7 = nm_db.getWorkAuthUser("??????????");
			user_id8 = nm_db.getWorkAuthUser("????????????");
			cs_bean8 = csd.getCarScheTodayBean(user_id8);
			//???????? ?????? ??????????
			if(!cs_bean8.getUser_id().equals("")) 	user_id8 = nm_db.getWorkAuthUser("????????????????????");
		}
	}
	
	doc.setUser_id2(user_id2);//??????????
	doc.setUser_id3(user_id3);//????????
	doc.setUser_id4(nm_db.getWorkAuthUser("????????"));//????????
	doc.setUser_id6(user_id6);//??????????
	doc.setUser_id7(user_id7);//??????????
	doc.setUser_id8(user_id8);//????????
	doc.setUser_id9(nm_db.getWorkAuthUser("????????"));//????????
	
	//????????
	DocSettleBean doc_chk = d_db.getDocSettleCommi("1", rent_l_cd);
	
	if(doc_chk.getDoc_no().equals("")){
		flag5 = d_db.insertDocSettle(doc);
	}	
		


	//6. ???????? ???? ????----------------------------------------------------------------------------------------
	
	String url 		= "/fms2/commi/commi_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
	String m_url  = "/fms2/commi/commi_doc_frame.jsp";
	//?????? ???? ???? - ?????????? ????. ?????? ???? ????
	String target_id = "";
	target_id = doc.getUser_id6(); //???????????? ????
	

	
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
  				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
	//????????
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
	//????????
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
	
	flag6 = cm_db.insertCoolMsg(msg);
	
	//20150526 ?????????? ??????,???? ????????	
	//???????? ????	
	String  d_flag1 =  ad_db.call_sp_commi_scanfile_syn(rent_mng_id, rent_l_cd, user_id);
		
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('?????? ???????? ???? ??????????.\n\n????????????');		<%		}	%>		
<%		if(!flag2){	%>	alert('?????? ???????? ???? ??????????.\n\n????????????');		<%		}	%>		
<%		if(!flag3){	%>	alert('???????? ???????? ???? ??????????.\n\n????????????');		<%		}	%>		
<%		if(!flag4){	%>	alert('???????????? ???? ??????????.\n\n????????????');			<%		}	%>		
<%		if(!flag5){	%>	alert('?????????? ???? ??????????.\n\n????????????');			<%		}	%>		
<%		if(!flag6){	%>	alert('???????? ???? ??????????.\n\n????????????');			<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">
  <input type='hidden' name='gubun1'  			value='<%=gubun1%>'>    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'commi_doc_u.jsp';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>