<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id		= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	int o_fee_amt		= request.getParameter("o_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("o_fee_amt"));
	String r_fee_est_dt = request.getParameter("r_fee_est_dt")==null?"":request.getParameter("r_fee_est_dt");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	String cng_st 	= request.getParameter("cng_st")	==null?"":request.getParameter("cng_st");
	String cng_dt 	= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_s_dt = request.getParameter("cng_s_dt")	==null?"":request.getParameter("cng_s_dt");
	String cng_e_dt = request.getParameter("cng_e_dt")	==null?"":request.getParameter("cng_e_dt");
	String cng_etc 	= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	
	
	//보험정보
	ins = ins_db.getInsCase(c_id, ins_st);
	
	
	String doc_no 		= "";
	String ch_before 	= "";
	String ch_after 	= "";
	String reg_code  	= Long.toString(System.currentTimeMillis());
	
	//처리상태
	int flag = 0;
	boolean m_flag2 = true;
	
	
	String u_chk[] 					= request.getParameterValues("u_chk");	
	String age_scp_nm[] 				= request.getParameterValues("age_scp_nm");
	String vins_gcp_kd_nm[] 			= request.getParameterValues("vins_gcp_kd_nm");
	String vins_bacdt_kd_nm[] 			= request.getParameterValues("vins_bacdt_kd_nm");
	String vins_bacdt_kc2_nm[] 			= request.getParameterValues("vins_bacdt_kc2_nm");
	//String vins_canoisr_yn_nm[] 			= request.getParameterValues("vins_canoisr_yn_nm");
	String vins_cacdt_car_amt_nm[] 			= request.getParameterValues("vins_cacdt_car_amt_nm");
	String vins_cacdt_mebase_amt_nm[] 		= request.getParameterValues("vins_cacdt_mebase_amt_nm");
	String vins_cacdt_me_amt_nm[] 			= request.getParameterValues("vins_cacdt_me_amt_nm");
	String vins_cacdt_memin_amt_nm[] 		= request.getParameterValues("vins_cacdt_memin_amt_nm");
	//String vins_spe_yn_nm[] 			= request.getParameterValues("vins_spe_yn_nm");
	String vins_con_f_nm[] 				= request.getParameterValues("vins_con_f_nm");
	String com_emp_yn_nm[] 				= request.getParameterValues("com_emp_yn_nm");
	String blackbox_yn_nm[] 			= request.getParameterValues("blackbox_yn_nm");
	String hook_yn_nm[] 				= request.getParameterValues("hook_yn_nm");
	
	out.println("선택항목수="+u_chk.length+"<br><br>");
	
	
	InsurChangeBean d_bean = new InsurChangeBean();
	d_bean.setIns_doc_no			(reg_code);
	d_bean.setCar_mng_id			(c_id);
	d_bean.setIns_st			(ins_st);
	d_bean.setCh_dt				(cng_dt);
	d_bean.setCh_etc			(cng_etc);
	d_bean.setUpdate_id			(user_id);
	d_bean.setRent_mng_id			(rent_mng_id);
	d_bean.setRent_l_cd			(rent_l_cd);
	d_bean.setRent_st			(rent_st);
	d_bean.setO_fee_amt			(o_fee_amt);
	d_bean.setN_fee_amt			(0);
	d_bean.setD_fee_amt			(0);
	d_bean.setDoc_st			("1");
	d_bean.setCh_st				(cng_st);
	d_bean.setCh_s_dt			(cng_s_dt);
	d_bean.setCh_e_dt			(cng_e_dt);
	d_bean.setR_fee_est_dt		(r_fee_est_dt);
	if(!ins_db.insertInsChangeDoc(d_bean)) flag += 1;
	
	for(int i=0;i < u_chk.length;i++){
	
		ch_before 	= "";
		ch_after 	= "";
		
		out.println("선택항목="+u_chk[i]+"<br><br>");
		
		InsurChangeBean bean = new InsurChangeBean();
		bean.setIns_doc_no		(reg_code);
		bean.setCar_mng_id		(c_id);
		bean.setIns_st			(ins_st);
		bean.setCh_tm			(String.valueOf(i));
		bean.setCh_dt			(cng_dt);
		bean.setCh_amt			(0);
		bean.setUpdate_id		(user_id);
		bean.setRent_mng_id		(rent_mng_id);
		bean.setRent_l_cd		(rent_l_cd);
		
		//연령범위
		if(u_chk[i].equals("1")){
			
			ch_before 	= age_scp_nm[0];
			ch_after 	= age_scp_nm[1];
			
			bean.setCh_item			("5");//연령변경
			
		//대물배상
		}else if(u_chk[i].equals("2")){
			
			ch_before 	= vins_gcp_kd_nm[0];
			ch_after 	= vins_gcp_kd_nm[1];
			
			bean.setCh_item			("1");//대물가입금액
			
		//자기신체사고(1인당사망/장해)
		}else if(u_chk[i].equals("3")){
			
			ch_before 	= vins_bacdt_kd_nm[0];
			ch_after 	= vins_bacdt_kd_nm[1];
			
			bean.setCh_item			("2");//자기신체사고가입금액(1인당사망/장해)
			
		//자기신체사고(1인당부상)
		}else if(u_chk[i].equals("4")){
						
			ch_before 	= vins_bacdt_kc2_nm[0];
			ch_after 	= vins_bacdt_kc2_nm[1];
			
			bean.setCh_item			("12");//자기신체사고가입금액(1인당부상)
			
		//무보험차상해
		//}else if(u_chk[i].equals("5")){						
		//	ch_before 	= vins_canoisr_yn_nm[0];
		//	ch_after 	= vins_canoisr_yn_nm[1];			
		//	bean.setCh_item			("3");//무보험차상해특약
			
		//자기차량손해
		}else if(u_chk[i].equals("6")){

			ch_before 	= vins_cacdt_car_amt_nm[0];
			ch_after 	= vins_cacdt_car_amt_nm[1];
			
			bean.setCh_item			("4");//자기차량손해가입금액
			
		//자기차량손해 자기부담금
		}else if(u_chk[i].equals("7")){
			
			ch_before 	= vins_cacdt_mebase_amt_nm[0]+"/"+vins_cacdt_me_amt_nm[0]+"/"+vins_cacdt_memin_amt_nm[0];
			ch_after 	= vins_cacdt_mebase_amt_nm[1]+"/"+vins_cacdt_me_amt_nm[1]+"/"+vins_cacdt_memin_amt_nm[1];
			
			bean.setCh_item			("9");//자기차량손해자기부담금
			
		//긴급출동 특약
		//}else if(u_chk[i].equals("8")){			
		//	ch_before 	= vins_spe_yn_nm[0];
		//	ch_after 	= vins_spe_yn_nm[1];			
		//	bean.setCh_item			("6");//애니카특약
			
		//임직원한전운전특약
		}else if(u_chk[i].equals("9")){
					
			ch_before 	= com_emp_yn_nm[0];
			ch_after 	= com_emp_yn_nm[1];
			
			bean.setCh_item			("14");//임직원한전운전특약
			
		//피보험자변경
		}else if(u_chk[i].equals("10")){
			
			ch_before 	= vins_con_f_nm[0];
			ch_after 	= vins_con_f_nm[1];
			
			bean.setCh_item			("15");//피보험자변경
			
		//보험갱신
		}else if(u_chk[i].equals("11")){
			String vins_renew 		= request.getParameter("vins_renew")==null?"":request.getParameter("vins_renew");
			
			ch_before 	= "";
			ch_after 	= vins_renew;
			
			bean.setCh_item			("16");//보험갱신
			
		//기타
		}else if(u_chk[i].equals("12")){
			String vins_etc 		= request.getParameter("vins_etc")==null?"":request.getParameter("vins_etc");
			
			ch_before 	= "";
			ch_after 	= vins_etc;
			
			bean.setCh_item			("13");//기타

		//블랙박스
		}else if(u_chk[i].equals("13")){
		
			ch_before 	= blackbox_yn_nm[0];
			ch_after 	= blackbox_yn_nm[1];
			
			bean.setCh_item			("17");//블랙박스

		//견인고리
		}else if(u_chk[i].equals("14")){
			
			ch_before 	= hook_yn_nm[0];
			ch_after 	= hook_yn_nm[1];
			
			bean.setCh_item			("18");//견인고리

			
		}
		
		
		
		bean.setCh_before		(ch_before);
		bean.setCh_after		(ch_after);
		
		
		
		if(!ins_db.insertInsChangeDocList(bean)) flag += 1;
		
		
		
	}
	
	
	//보험변경리스트
	Vector ins_cha = ins_db.getInsChangeDocList(reg_code);
	int ins_cha_size = ins_cha.size();
	
	if(ins_cha_size >0){
	
		int flag1 = 0;
		int flag2 = 0;
		int flag3 = 0;
		int flag4 = 0;
		boolean flag6 = true;
		boolean flag7 = true;
		int count1 = 0;
		int count2 = 0;
		int count3 = 0;
		
		
		//기안자
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		
		//문서기안
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		
		String sub 	= "보험계약사항 변경요청문서 품의";
		String cont 	= "["+firm_nm+"] 보험변경문서를 등록하였으니 결재바랍니다.";
		
		String user_id3 = nm_db.getWorkAuthUser("부산보험담당");
		String user_id2 = nm_db.getWorkAuthUser("본사영업부팀장"); //20140415 영업팀장 결재 빠짐
		
		String user_id4 = nm_db.getWorkAuthUser("세금계산서담당자"); //20151112 스케줄담당자 추가
		
		
		
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(user_id4);
		
		if(!cs_bean2.getWork_id().equals("")) user_id2 = cs_bean2.getWork_id();
		if(!cs_bean3.getWork_id().equals("")) user_id3 = cs_bean3.getWork_id();
		if(!cs_bean4.getWork_id().equals("")) user_id4 = cs_bean4.getWork_id();
		
		//대전,부산보험담당자 모두 휴가일때
		cs_bean3 = csd.getCarScheTodayBean(user_id3);
		if(!cs_bean3.getWork_id().equals("")) user_id3 = cs_bean3.getWork_id();
		
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st	("47");
		doc.setDoc_id	(reg_code);
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	(cng_etc);
		doc.setUser_nm1	("기안자");
		doc.setUser_nm2	("영업팀장");
		//doc.setUser_nm3("영업팀장");
		doc.setUser_nm3	("보험담당자");
		doc.setUser_nm4	("스케줄담당자");
		doc.setUser_nm5	("");
		doc.setUser_id1	(user_id);
		doc.setUser_id2	(user_id2);
		doc.setUser_id3	(user_id3);
		doc.setUser_id4	(user_id4);
		doc.setDoc_bit	("0");
		doc.setDoc_step	("0");//기안
		
		if(cng_st.equals("2")){
			doc.setDoc_step	("3");//견적
		}
		
		//=====[doc_settle] insert=====
		flag6 = d_db.insertDocSettle2(doc);
		
		doc = d_db.getDocSettleCommi("47", reg_code);
		
		doc_no = doc.getDoc_no();
		
		
		
		//반영일 경우 보험담당자에게 메시지를 보내라..
		if(cng_st.equals("1")){
		
			//쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
			
			String car_no		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
			sub 			= "보험계약사항 변경요청문서 등록";
			cont 			= "["+firm_nm+" "+car_no+"] 보험변경문서가 반영으로 등록되었습니다. 확인하여주십시오.";
			String target_id 	= user_id2;
			String url 		= "/fms2/insure/ins_doc_frame.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|c_id="+c_id+"|ins_st="+ins_st+"|ins_doc_no="+reg_code;
			String m_url = "/fms2/insure/ins_doc_frame.jsp";
			
			
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
  						"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
 						"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			
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
			
			//m_flag2 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저(보험변경문서결재)"+car_no+"-----------------------"+target_bean.getUser_nm());
		
		}
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 				value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">   
  <input type='hidden' name="car_mng_id"		value="<%=c_id%>">
  <input type='hidden' name="c_id" 					value="<%=c_id%>">
  <input type='hidden' name="ins_st"				value="<%=ins_st%>">
  <input type="hidden" name="doc_no" 				value="<%=doc_no%>">     
  <input type="hidden" name="ins_doc_no" 		value="<%=reg_code%>">     
  <input type="hidden" name="from_page" 		value="/fms2/insure/ins_doc_reg_c_a.jsp">
    
</form>
<script language='javascript'>
<%	if(flag > 0){%>

		alert("등록하지 않았습니다");
		
<%	}else{%>	


		<%if(cng_st.equals("2")){//견적%>	
		alert("등록되었습니다");
		<%}else{//반영%>
		alert("등록되었습니다\n\n보험변경요청서는 보험변경문서관리에서 해당 변경건 선택후 팝업창으로 띄울수 있습니다. 먼저 고객에게 팩스를 발송하십시오.\n\n명판 및 인감 날인된 것을 받아 문서 기안시 스캔하여 등록하여 주세요.");
		<%}%>
		
		var fm = document.form1;
		fm.target='d_content';
		fm.action='ins_doc_u.jsp';		
		fm.submit();	
		
<%	}%>
</script>
</body>
</html>