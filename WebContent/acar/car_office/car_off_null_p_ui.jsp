<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.cont.*, acar.doc_settle.*" %>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="coh_bean" class="acar.car_office.CarOffEdhBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String emp_nm = request.getParameter("emp_nm")==null?"":request.getParameter("emp_nm");
	String emp_ssn = request.getParameter("emp_ssn")==null?"":request.getParameter("emp_ssn");
	String emp_m_tel = request.getParameter("emp_m_tel")==null?"":request.getParameter("emp_m_tel");
	String emp_pos = request.getParameter("emp_pos")==null?"":request.getParameter("emp_pos");
	String emp_email = request.getParameter("emp_email")==null?"":request.getParameter("emp_email");
	String emp_bank = request.getParameter("emp_bank")==null?"":request.getParameter("emp_bank");
	String emp_bank_cd = request.getParameter("emp_bank_cd")==null?"":request.getParameter("emp_bank_cd");
	String emp_acc_no = request.getParameter("emp_acc_no")==null?"":request.getParameter("emp_acc_no");
	String emp_acc_nm = request.getParameter("emp_acc_nm")==null?"":request.getParameter("emp_acc_nm");
	String emp_post = request.getParameter("emp_post")==null?"":request.getParameter("emp_post");
	String emp_addr = request.getParameter("emp_addr")==null?"":request.getParameter("emp_addr");
	String etc = request.getParameter("etc")==null?"":request.getParameter("etc");
	String reg_dt = AddUtil.ChangeString(AddUtil.getDate());
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String upd_dt = request.getParameter("upd_dt")==null?"":AddUtil.ChangeString(request.getParameter("upd_dt"));
	String upd_id = request.getParameter("upd_id")==null?"":request.getParameter("upd_id");
	String emp_h_tel = request.getParameter("emp_h_tel")==null?"":request.getParameter("emp_h_tel");
	String emp_sex = request.getParameter("emp_sex")==null?"":request.getParameter("emp_sex");
	String use_yn = request.getParameter("use_yn")==null?"":request.getParameter("use_yn");
	String sms_denial_rsn = request.getParameter("sms_denial_rsn")==null?"":request.getParameter("sms_denial_rsn");	
	String fraud_care = request.getParameter("fraud_care")==null?"":request.getParameter("fraud_care");	
	//담당자이력관리
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String cng_dt = request.getParameter("cng_dt")==null?"":AddUtil.ChangeString(request.getParameter("cng_dt"));
	String cng_rsn2 = request.getParameter("cng_rsn2")==null?"":request.getParameter("cng_rsn2"); 
	String commi_eq = request.getParameter("commi_eq")==null?"N":request.getParameter("commi_eq"); 
		
    	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
    	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	int count = 0;
	boolean flag1 = true;

	coe_bean.setCar_off_id(car_off_id);
	coe_bean.setCust_st(cust_st);
	coe_bean.setEmp_nm(emp_nm);
	coe_bean.setEmp_ssn(emp_ssn);
	coe_bean.setEmp_m_tel(emp_m_tel);
	coe_bean.setEmp_pos(emp_pos);
	coe_bean.setEmp_email(emp_email.trim());
	coe_bean.setEmp_bank(emp_bank);	
	coe_bean.setEmp_acc_no(emp_acc_no);
	coe_bean.setEmp_acc_nm(emp_acc_nm);
	coe_bean.setEmp_post(emp_post);
	coe_bean.setEmp_addr(emp_addr);
	coe_bean.setEmp_id(emp_id);
	coe_bean.setEtc(etc);
	coe_bean.setReg_dt(reg_dt);
	coe_bean.setReg_id(reg_id);
	coe_bean.setUpd_dt(upd_dt);
	coe_bean.setUpd_id(upd_id);
	coe_bean.setEmp_h_tel(emp_h_tel);
	coe_bean.setEmp_sex(emp_sex);
	coe_bean.setUse_yn(use_yn);
	coe_bean.setSms_denial_rsn(sms_denial_rsn);
	coe_bean.setFraud_care(fraud_care);
	//담당자 이력관리
	coh_bean.setEmp_id(emp_id);
	coh_bean.setDamdang_id(damdang_id);
	coh_bean.setCng_dt(cng_dt);
	coh_bean.setCng_rsn(cng_rsn2);	//검색조건(car_off_p_sh)에서 cng_rsn으로 해서 수정화면에 중복발생하여 에러나서 2로 함.
	
	coe_bean.setBank_cd(emp_bank_cd);
	if(!coe_bean.getBank_cd().equals("")){
		coe_bean.setEmp_bank		(c_db.getNameById(coe_bean.getBank_cd(), "BANK"));
		emp_bank = coe_bean.getEmp_bank();
	}
	

	if(cmd.equals("i")){
		coh_bean.setReg_id(reg_id);
		coh_bean.setReg_dt(reg_dt);
		emp_id = umd.insertCarOffEmp(coe_bean, coh_bean);
	}else if(cmd.equals("u")){
		coh_bean.setReg_id(upd_id);
		coh_bean.setReg_dt(upd_dt);	
		emp_id = umd.updateCarOffEmp(coe_bean, coh_bean);
		
		//영업수당문서 동기화
		if(!emp_acc_no.equals("") && commi_eq.equals("Y")){
			
			//영업수당문서 결재중
			Vector vt = d_db.getCommiDocList("9", emp_id, "1");
			int vt_size = vt.size();
			
			
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				CommiBean emp1 	= a_db.getCommi(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), "1");
				emp1.setEmp_bank		(emp_bank);
				emp1.setBank_cd			(emp_bank_cd);
				emp1.setEmp_acc_no	(emp_acc_no);
				emp1.setEmp_acc_nm	(emp_acc_nm);
				//=====[commi] update=====
				flag1 = a_db.updateCommiNew(emp1);
				System.out.println("[문서결재중]영업사원관리-영업수당정보 계좌변경 수정:"+emp_nm+" "+String.valueOf(ht.get("RENT_L_CD")));
			}
			
			//영업수당문서 결재완료후 지급대기중
			Vector vt2 = a_db.getCommiPayList("9", emp_id, "N", "2", "", "");
			int vt_size2 = vt2.size();
			
			for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);
				CommiBean emp1 	= a_db.getCommi(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), "1");
				emp1.setEmp_bank		(emp_bank);
				emp1.setBank_cd			(emp_bank_cd);
				emp1.setEmp_acc_no	(emp_acc_no);
				emp1.setEmp_acc_nm	(emp_acc_nm);
				//=====[commi] update=====
				flag1 = a_db.updateCommiNew(emp1);
				System.out.println("[문서결재완료]영업사원관리-영업수당정보 계좌변경 수정:"+emp_nm+" "+String.valueOf(ht.get("RENT_L_CD")));
			}
			
		}
	}

%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
<%if(cmd.equals("u")){%>
	alert("정상적으로 수정되었습니다.");
<%}else{%>
	alert("정상적으로 등록되었습니다.");
<%}%> 
parent.location.href = "./car_office_p_s.jsp?auth_rw=<%= auth_rw %>&emp_id=<%= emp_id %>&gubun=<%= gubun %>&gu_nm=<%= gu_nm %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>";  
//-->
</script>
</body>
</html>
