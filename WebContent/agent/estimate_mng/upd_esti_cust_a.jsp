<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, tax.*, acar.user_mng.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String set_code = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String sms_yn = "";
	
	String u_nm 	= request.getParameter("u_nm")==null?"":request.getParameter("u_nm");
	String u_mt 	= request.getParameter("u_mt")==null?"":request.getParameter("u_mt");
	String u_ht 	= request.getParameter("u_ht")==null?"":request.getParameter("u_ht");
	
	String etc2 = ck_acar_id;
	
	if(cmd.equals("cls_per_cng")){
		String cng_est_id = request.getParameter("cng_est_id")==null?"":request.getParameter("cng_est_id");
		
		bean = e_db.getEstimateCase(cng_est_id);
		
		bean.setCls_per		(request.getParameter("cng_cls_per")==null?0:AddUtil.parseFloat(request.getParameter("cng_cls_per")));
		bean.setUpdate_id	(user_id);
		
		count = e_db.updateEstimate(bean);
		
	}else if(cmd.equals("result_sms")){
		
		bean = e_db.getEstimateCase(est_id);
		
		UsersBean user_bean = umd.getUsersBean(bean.getReg_id());
		
		String est_nm 		= request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
		String est_m_tel 	= request.getParameter("est_m_tel")==null?"":request.getParameter("est_m_tel");
		String est_email 	= request.getParameter("est_email")==null?"":request.getParameter("est_email");		
		String est_fax 	= request.getParameter("est_fax")==null?"":request.getParameter("est_fax");		
		String sms_cont1 	= request.getParameter("sms_cont1")==null?"":request.getParameter("sms_cont1");
		String sms_cont2 	= request.getParameter("sms_cont2")==null?"":request.getParameter("sms_cont2");
		String sms_cont3 	= request.getParameter("sms_cont3")==null?"":request.getParameter("sms_cont3");
		String sms_cont4 	= request.getParameter("sms_cont4")==null?"":request.getParameter("sms_cont4");
		String sms_cont5 	= request.getParameter("sms_cont5")==null?"":request.getParameter("sms_cont5");
		
		String msg = sms_cont1+" "+sms_cont2+" "+sms_cont3+" "+sms_cont4+" "+sms_cont5;
		String msg_type = "0";
		String msg_subject = "0";
		
		int msg_len = AddUtil.lengthb(msg);
		
		if(msg_len>80){
			msg_type = "5";
			msg_subject = "견적서 발송 알림";
		}
		
		if(est_m_tel.equals("")){
			sms_yn = "N";
		}else{
			
			//알림톡 acar0042 견적서 발송 알림
			String customer_name 	= est_nm;				// 고객이름
			String esti_send_way 	= sms_cont2;		// 견적서발송
			String manager_name 	= u_nm;					// 담당자 이름
			String manager_phone 	= u_mt;					// 담당자 전화
			if(sms_cont2.equals("팩스") && !est_fax.equals("")   && est_fax.length()   >6) 	esti_send_way = esti_send_way + "("+est_fax+")";
			if(sms_cont2.equals("메일") && !est_email.equals("") && est_email.length() >4) 	esti_send_way = esti_send_way + "("+est_email+")";
			//acar0042->acar0072
			List<String> fieldList = Arrays.asList(customer_name, esti_send_way, manager_name, manager_phone);
			at_db.sendMessageReserve("acar0072", fieldList, est_m_tel,  u_mt, null , "",  etc2);
		}
		
		count = 1;
	

	} else if (cmd.equals("result_select_sms_wap")) {
	
		String ch_mms_id[] 		= request.getParameterValues("ch_mms_id");
		String wap_msg_body[] 		= request.getParameterValues("wap_msg_body");
		String a_url[] 				= request.getParameterValues("a_url");		
		String a_gubun1s[] 				= request.getParameterValues("a_gubun1");
		String a_gubun2s[] 				= request.getParameterValues("a_gubun2");
		
		String est_nm 		= request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
		String est_m_tel 	= request.getParameter("est_m_tel")==null?"":request.getParameter("est_m_tel");				
		String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");		
		
		int dlv_car_amt = request.getParameter("dlv_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("dlv_car_amt"));
						
		String msg = "";
		
		UsersBean user_bean = umd.getUsersBean(damdang_id);

		for (int i = 0; i < ch_mms_id.length; i++) {
		
			msg = wap_msg_body[i];
			
			bean = e_db.getEstimateCase(ch_mms_id[i]);
			
			//조정대여료가 있다면
			if (bean.getCtr_s_amt() > 0) {
				bean.setFee_s_amt(bean.getCtr_s_amt());
				bean.setFee_v_amt(bean.getCtr_v_amt());
			}	
			
			String msg_type = "5";
			String msg_subject = "견적서 발송 알림";
		
			if (est_m_tel.equals("")) {
				sms_yn = "N";
			} else {
				
				//알림톡 acar0057 견적서 발송 알림
				String a_car_name 		= request.getParameter("a_car_name")==null?"":request.getParameter("a_car_name");					// 차량이름
				String a_car_amount 	= AddUtil.parseDecimal(bean.getO_1()+dlv_car_amt);								// 차량가격
				String a_gubun1 			= a_gubun1s[i];		// 구분1
				String a_gubun2 			= a_gubun2s[i];		// 구분2
				String a_month 			= bean.getA_b();		// 개월
				String a_gtr_amt			= AddUtil.parseDecimal(bean.getGtr_amt());		// 보증금
				String a_deposit_rate 	= String.valueOf(bean.getRg_8());		// 보증금율
				String a_distance 		= AddUtil.parseDecimal(bean.getAgree_dist());		// 약정주행거리
				String a_rent_fee 		= AddUtil.parseDecimal(bean.getFee_s_amt()+bean.getFee_v_amt());		// 월대여료
				//String a_esti_link 		= a_url[i];			// 견적서보기
				String a_esti_link 		= ShortenUrlGoogle.getShortenUrl(a_url[i]);			// 견적서보기
				String manager_name 	= u_nm;					// 담당자 이름
				String manager_phone 	= u_mt;
				
				//견적구분이 상품 이 아닌 경우, 통합된 내용의 문자 한건만 발송(20181004)
				if (a_gubun1.equals("") && a_gubun2.equals("")) {	
					/* 
					String at_cont      = "";
					at_cont += "고객님 안녕하십니까. 아마존카입니다.\n\n" +
					           "요청하신 견적은 다음과 같습니다.\n" +
							   "견적서 검토 중 궁금하신 내용은 언제든지 연락 주시면 성실히 답변드리겠습니다.\n" +
					           "감사합니다.\n\n" +
					           a_car_name + " " + a_car_amount + "원\n" +
					           "(견적서 보기 : " + a_esti_link + " )\n\n" +
							   "★ 담당자 : " + manager_name + " "+ manager_phone +"\n\n" +
							   "(주)아마존카 (www.amazoncar.co.kr)";
					at_db.sendMessage(1009, "0", at_cont, est_m_tel, u_mt, null, "", etc2);
					*/
					
					// 템플릿 생성 acar0144
					List<String> fieldList = Arrays.asList(a_car_name, a_car_amount, a_esti_link, manager_name, manager_phone);
					at_db.sendMessageReserve("acar0144", fieldList, est_m_tel, u_mt, null, "", etc2);
					
				} else {	//견적구분이 상품인 경우는 기존대로 처리VV
					// 담당자 전화
					//acar0064->acar0073->acar0223
					/* List<String> fieldList = Arrays.asList(a_car_name, a_car_amount, a_gubun1, a_gubun2, a_month, a_deposit_rate, a_distance, a_rent_fee, a_esti_link, manager_name, manager_phone);
					at_db.sendMessageReserve("acar0073", fieldList, est_m_tel,  u_mt, null , "",  etc2); */
					List<String> fieldList = Arrays.asList(a_car_name, a_car_amount, a_gubun1, a_gubun2, a_month, a_gtr_amt, a_deposit_rate, a_distance, a_rent_fee, a_esti_link, manager_name, manager_phone);
					at_db.sendMessageReserve("acar0223", fieldList, est_m_tel, u_mt, null, "", etc2);
				}	
			}
		}
		
		count = 1;					
			
	} else {
		
		bean = e_db.getEstimateCase(est_id);
		
		String o_doc_type = bean.getDoc_type();
		
		bean.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
		bean.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
		bean.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
		bean.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
		bean.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
		bean.setDoc_type	(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
		bean.setDir_pur_commi_yn	(request.getParameter("dir_pur_commi_yn")==null?"N":request.getParameter("dir_pur_commi_yn"));
		bean.setReg_id		(request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id"));
		bean.setEst_email	(request.getParameter("est_email")==null?"":request.getParameter("est_email").trim());
		bean.setCaroff_emp_yn	(request.getParameter("caroff_emp_yn")==null?"":request.getParameter("caroff_emp_yn"));
		bean.setPp_ment_yn(request.getParameter("pp_ment_yn")==null?"N":request.getParameter("pp_ment_yn"));
		
		if(!from_page.equals("esti_sh_mng_u.jsp")){
			bean.setMgr_nm		(request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm"));
			bean.setCompare_yn(request.getParameter("compare_yn")==null?"N":request.getParameter("compare_yn"));
			bean.setPp_ment_yn(request.getParameter("pp_ment_yn")==null?"N":request.getParameter("pp_ment_yn"));
		}
		
		bean.setGi_grade		(request.getParameter("gi_grade")==null?"":request.getParameter("gi_grade"));
		
		if(bean.getCaroff_emp_yn().equals("4")){
			bean.setDamdang_nm		(request.getParameter("damdang_nm")==null?"":request.getParameter("damdang_nm"));
			bean.setDamdang_m_tel	(request.getParameter("damdang_m_tel")==null?"":request.getParameter("damdang_m_tel"));
		}
		
		String n_doc_type = bean.getDoc_type();
		
		if(o_doc_type.equals("1") && !n_doc_type.equals("1") && bean.getCom_emp_yn().equals("Y")){
			bean.setCom_emp_yn("");
		}
		
		count = e_db.updateEstimate(bean);
		
		
		Vector vars = e_db.getABTypeEstIds(set_code, est_id);
		int size = vars.size();
		
		for(int i = 0 ; i < size ; i++){
			Hashtable var = (Hashtable)vars.elementAt(i);
			EstimateBean e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			
			e_bean2.setEst_nm			(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
			e_bean2.setEst_ssn		(request.getParameter("est_ssn")==null?"":request.getParameter("est_ssn"));
			e_bean2.setEst_tel		(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
			e_bean2.setEst_fax		(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
			e_bean2.setVali_type	(request.getParameter("vali_type")==null?"":request.getParameter("vali_type"));
			e_bean2.setDoc_type		(request.getParameter("doc_type")==null?"":request.getParameter("doc_type"));
			e_bean2.setReg_id			(request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id"));
			e_bean2.setEst_email	(request.getParameter("est_email")==null?"":request.getParameter("est_email").trim());
			e_bean2.setCaroff_emp_yn(request.getParameter("caroff_emp_yn")==null?"":request.getParameter("caroff_emp_yn"));
			if(!from_page.equals("esti_sh_mng_u.jsp")){
				e_bean2.setMgr_nm			(request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm"));
				e_bean2.setPp_ment_yn	(request.getParameter("pp_ment_yn")==null?"0":request.getParameter("pp_ment_yn"));
			}
			
			e_bean2.setGi_grade		(request.getParameter("gi_grade")==null?"":request.getParameter("gi_grade"));
			
			if(e_bean2.getCaroff_emp_yn().equals("4")){
				e_bean2.setDamdang_nm		(request.getParameter("damdang_nm")==null?"":request.getParameter("damdang_nm"));
				e_bean2.setDamdang_m_tel(request.getParameter("damdang_m_tel")==null?"":request.getParameter("damdang_m_tel"));
			}
			if(o_doc_type.equals("1") && !n_doc_type.equals("1") && e_bean2.getCom_emp_yn().equals("Y")){
				e_bean2.setCom_emp_yn("");
			}
			
			count = e_db.updateEstimate(e_bean2);
		}
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">  
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>">     
  <input type="hidden" name="est_id" value="<%=est_id%>">          
  <input type="hidden" name="set_code" value="<%=set_code%>">            
  <input type="hidden" name="a_e" value="<%=a_e%>">            
  <input type="hidden" name="cmd" value="u">
  <input type="hidden" name="e_page" value="u"> 
</form>
<script>
<%	if(count==1){%>
		<%if(sms_yn.equals("N")){%>
		alert("수신번호가 없습니다.");
		<%}else{%>
		alert("정상적으로 처리되었습니다.");
		<%}%>
		<%if(!from_page.equals("")){%>
		document.form1.action = "<%=from_page%>";
		<%}else{%>
		document.form1.action = "esti_mng_u.jsp";
		<%}%>		
		document.form1.target='d_content';
		document.form1.submit();
	
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

