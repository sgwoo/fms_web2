<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	if(mode.equals("guar")){
		
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//관리지점,영업대리인
		cont_etc.setGuar_end_st	(request.getParameter("guar_end_st")	==null?"":request.getParameter("guar_end_st"));
		cont_etc.setGuar_est_dt	(request.getParameter("guar_est_dt")==null?"":request.getParameter("guar_est_dt"));
		cont_etc.setGuar_etc	(request.getParameter("guar_etc")==null?"":request.getParameter("guar_etc"));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
		
	}else{
	
		//4. 영업수당정보 commi-------------------------------------------------------------------------------------------
		
		//commi
		CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
		
		int old_dlv_con_commi = emp1.getDlv_con_commi();
		
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
		emp1.setAdd_st1		(request.getParameter("add_st1")		==null?"":request.getParameter("add_st1"));
		emp1.setAdd_st2		(request.getParameter("add_st2")		==null?"":request.getParameter("add_st2"));
		emp1.setAdd_st3		(request.getParameter("add_st3")		==null?"":request.getParameter("add_st3"));
		emp1.setComm_r_rt	(request.getParameter("comm_r_rt")		==null? 0:AddUtil.parseFloat(request.getParameter("comm_r_rt")));
		emp1.setCommi_car_amt(request.getParameter("commi_car_amt")==null? 0:AddUtil.parseDigit(request.getParameter("commi_car_amt")));
		emp1.setDlv_con_commi	(request.getParameter("dlv_con_commi")		==null? 0:Util.parseDigit(request.getParameter("dlv_con_commi")));
		emp1.setDlv_tns_commi	(request.getParameter("dlv_tns_commi")		==null? 0:Util.parseDigit(request.getParameter("dlv_tns_commi")));
		emp1.setAgent_commi	(request.getParameter("agent_commi")		==null? 0:Util.parseDigit(request.getParameter("agent_commi")));
		emp1.setBank_cd		(request.getParameter("emp_bank_cd")	==null?"":request.getParameter("emp_bank_cd"));
		
		if(!emp1.getBank_cd().equals("")){
			emp1.setEmp_bank		(c_db.getNameById(emp1.getBank_cd(), "BANK"));
		}
		
		int new_dlv_con_commi = emp1.getDlv_con_commi();
		
		//영업사원정보 car_off_emp-------------------------------------------------------------------------------------
		coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
		
		String emp_email 	= request.getParameter("emp_email")==null?"":request.getParameter("emp_email");
		String emp_m_tel 	= request.getParameter("emp_m_tel")==null?"":request.getParameter("emp_m_tel");
		
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && !coe_bean.getEmp_email().equals(emp_email)) result = cod.updateCarOffEmpMail(emp1.getEmp_id(), emp_email);
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && !coe_bean.getEmp_m_tel().equals(emp_m_tel)) result = cod.updateCarOffEmp(emp1.getEmp_id(), emp_m_tel);
		
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getEmp_ssn1().equals("") && !emp1.getRec_ssn().equals("")) 		result = cod.updateCarOffEmp(emp1.getEmp_id(), "3", emp1.getRec_ssn(), "");
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getEmp_addr().equals("") && !emp1.getRec_addr().equals("")) 		result = cod.updateCarOffEmp(emp1.getEmp_id(), "4", emp1.getRec_zip(), emp1.getRec_addr());
		if(coe_bean.getEmp_nm().equals(emp1.getEmp_acc_nm()) && coe_bean.getCust_st().equals("") && !emp1.getRec_incom_st().equals("")) 	result = cod.updateCarOffEmp(emp1.getEmp_id(), "5", emp1.getRec_incom_st(), "");
		
		String s_file_name1	= request.getParameter("s_file_name1")==null?"":request.getParameter("s_file_name1");
		String s_file_name2	= request.getParameter("s_file_name2")==null?"":request.getParameter("s_file_name2");
		String s_file_gubun1	= request.getParameter("s_file_gubun1")==null?"":request.getParameter("s_file_gubun1");
		String s_file_gubun2	= request.getParameter("s_file_gubun2")==null?"":request.getParameter("s_file_gubun2");
		
		//=====[commi] update=====
		flag1 = a_db.updateCommiNew(emp1);
		out.println("영업수당정보 수정<br>");
		
		//출고보전수당이 새로 생겼다면 정팀장님 결재가 추가되어야 한다.		
		if(old_dlv_con_commi == 0 && new_dlv_con_commi >0){
		
			//문서품의
			DocSettleBean doc = d_db.getDocSettle(doc_no);
			
			
			if(!doc.getDoc_step().equals("3")){
			
				String user_id3 = nm_db.getWorkAuthUser("본사영업부팀장");//영업팀장없음
			
				flag5 = d_db.updateDocSettleUserCng(doc_no, "3", user_id3);
			
				String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");	
				String sub 	= "지급수수료 지출 품의";
				String cont 	= "["+firm_nm+"] 지급수수료 지출을 요청합니다.";						
				String url 		= "/fms2/commi/commi_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
						
				//사용자 정보 조회 - 영업수당은 팀장. 지점장 결재 제외
				String target_id = user_id3;
			
				UsersBean target_bean 	= umd.getUsersBean(target_id);
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
  					"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
				//받는사람
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
				//보낸사람
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
				System.out.println("쿨메신저(영업수당기안)"+firm_nm+"-----------------------"+target_bean.getUser_nm());
							
			}	
		}
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('영업수당정보 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag2){	%>	alert('연대보증  에러입니다.\n\n확인하십시오');					<%		}	%>		
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
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
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