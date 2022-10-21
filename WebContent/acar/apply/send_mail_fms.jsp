<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, tax.*, acar.estimate_mng.*, acar.user_mng.*" %>

<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String est_id 		= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String reg_id 		= request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	String mail_st 		= request.getParameter("mail_st")==null?"":request.getParameter("mail_st");
	
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	String fee_opt_amt 	= request.getParameter("fee_opt_amt")==null?"0":request.getParameter("fee_opt_amt");
	String content_st 	= request.getParameter("content_st")==null?"":request.getParameter("content_st");
	
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");
	
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	
	String months 		= request.getParameter("months")	==null?"":request.getParameter("months");
	String days 		= request.getParameter("days")		==null?"":request.getParameter("days");
	String tot_rm 		= request.getParameter("tot_rm")	==null?"":request.getParameter("tot_rm");
	String tot_rm1 		= request.getParameter("tot_rm1")	==null?"":request.getParameter("tot_rm1");
	String per 		= request.getParameter("per")		==null?"":request.getParameter("per");
	String navi_yn 		= request.getParameter("navi_yn")	==null?"":request.getParameter("navi_yn");
	
	//[개인신용정보 조회동의] 첨부 여부
	String file_add_yn1 	= request.getParameter("file_add_yn1")	==null?"":request.getParameter("file_add_yn1");
	
	//[사업자등록증] 첨부 여부
	String file_add_yn2 	= request.getParameter("file_add_yn2")	==null?"":request.getParameter("file_add_yn2");
	
	
	
	System.out.println("견적서메일발송 : mail_addr="+mail_addr);
	System.out.println("est_id ="+est_id);
	System.out.println("from_page ="+from_page);
	System.out.println("content_st ="+content_st);
	System.out.println("reg_id ="+reg_id);
	System.out.println("acar_id ="+acar_id);
	
	//견적메일보내기
	EstiDatabase e_db = EstiDatabase.getInstance();
			
	
	//견적정보
	EstimateBean e_bean = new EstimateBean();
	
	String add_script_yn 		= "";
	
	
	if(from_page.equals("secondhand")||from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_t_frame.jsp")||from_page.equals("/fms2/lc_rent/lc_c_c_fee.jsp")||from_page.equals("/acar/estimate_mng/esti_mng_u.jsp")){
		e_bean = e_db.getEstimateCase(est_id);
	}else if(from_page.equals("main_car")){
		e_bean = e_db.getEstimateHpCase(est_id);
		add_script_yn 		= "Y";
	}else{
		e_bean = e_db.getEstimateShCase(est_id);
		add_script_yn 		= "Y";
	}
	
	if(e_bean.getReg_id().equals("") && !acar_id.equals("")) e_bean.setReg_id(acar_id);
	
	
	String pack_id = "";
	
	//선납과태료처럼 이메일에 견적서테이블 보여주고 링크거는 방식으로 한다.
	//if(!memo.equals("")){
	//if(content_st.equals("hp_fms") || content_st.equals("hp_renew") || content_st.equals("hp_renew_all") || !memo.equals("")){
		pack_id  = Long.toString(System.currentTimeMillis());
		EstiPackBean ep_bean = new EstiPackBean();
		ep_bean.setPack_id	(pack_id);
		ep_bean.setSeq		(1);
		ep_bean.setEst_id	(est_id);
		ep_bean.setEst_table	("estimate");
		ep_bean.setPack_st	("1");//1-메일
		ep_bean.setReg_id	(acar_id);
		ep_bean.setMemo		(memo);	
		
		if(content_st.equals("hp_renew")){
			ep_bean.setPack_st	("2");//1-메일
		}else if(content_st.equals("hp_renew_all")){
			ep_bean.setPack_st	("3");//1-메일
		}else if(content_st.equals("hp_comp_fms")){
			ep_bean.setPack_st	("5");//1-메일
		}	
		
		
		if(content_st.equals("hp")){
			ep_bean.setEst_table	("estimate_hp");		
		}
		
		if(content_st.equals("sh") || content_st.equals("sh_rm") || content_st.equals("sh_rm_new")){
			ep_bean.setEst_table	("estimate_sh");		
		}
		
		if(from_page.equals("secondhand") && content_st.equals("sh_rm_new")){
			ep_bean.setEst_table	("estimate");		
		}

		int count = e_db.insertEstiPack(ep_bean);		
		
	//}
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//사용자 정보 조회
	if(!acar_id.equals("")){
		user_bean 	= umd.getUsersBean(acar_id);
	}
	
	
	String user_email = "";
	
	user_email = "sales@amazoncar.co.kr";

	
	if(replyto_st.equals("1")){
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
	}else if(replyto_st.equals("2")){
		if(!acar_id.equals("")){
			replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
			if(!acar_id.equals("")){
				replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+replyto+">";
			}else{
				replyto = "\"아마존카\"<"+replyto+">";
			}
		}else{
			replyto = "\"아마존카\"<sales@amazoncar.co.kr>";
		}
	}
	
	DmailBean d_bean = new DmailBean();
	d_bean.setSubject			("[아마존카] "+e_bean.getEst_nm()+" 님의 장기대여 견적서입니다.");
	d_bean.setSql				("SSV:"+mail_addr.trim()); 
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			(replyto);
	d_bean.setMailto			("\""+e_bean.getEst_nm()+"\"<"+mail_addr.trim()+">");
	d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				(est_id);
	d_bean.setGubun2			(content_st);
	d_bean.setRname				("mail");
	d_bean.setMtype       		(0);
	d_bean.setU_idx       		(1);//admin계정
	d_bean.setG_idx				(1);//admin계정
	d_bean.setMsgflag     		(0);
	
	if(mail_st.equals("lpg")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/main_car_hp/esti_print.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
	}else{
		if(content_st.equals("sh")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/secondhand_hp/esti_print.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			add_script_yn 		= "Y";
		}else if(content_st.equals("sh_fms")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/secondhand_hp/esti_print_fms.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
		}else if(content_st.equals("sh_fms_ym")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/secondhand_hp/esti_print_fms_ym.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
		}else if(content_st.equals("sh_rm")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/secondhand_hp/esti_print_rm.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			d_bean.setSubject			("[아마존카] "+e_bean.getEst_nm()+" 님의 월렌트 견적서입니다.");
			add_script_yn 		= "Y";
		}else if(content_st.equals("sh_rm_new")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_rm_new_mail.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y&months="+months+"&days="+days+"&tot_rm="+tot_rm+"&tot_rm1="+tot_rm1+"&per="+per+"&navi_yn="+navi_yn);
			d_bean.setSubject			("[아마존카] "+e_bean.getEst_nm()+" 님의 월렌트 견적서입니다.");
			add_script_yn 		= "Y";
		}else if(content_st.equals("sh_rm_fms")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/secondhand_hp/esti_print_rm.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			d_bean.setSubject			("[아마존카] "+e_bean.getEst_nm()+" 님의 월렌트 견적서입니다.");
		}else if(content_st.equals("sh_rm_fms_new")){
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/secondhand_hp/esti_print_rm_new.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y&months="+months+"&days="+days+"&tot_rm="+tot_rm+"&tot_rm1="+tot_rm1+"&per="+per+"&navi_yn="+navi_yn);
			d_bean.setSubject			("[아마존카] "+e_bean.getEst_nm()+" 님의 월렌트 견적서입니다.");
		}else if(content_st.equals("hp_fms")){
			if(pack_id.equals("")){
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/main_car_hp/esti_print_fms.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			}else{//링크페이지
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/apply/select_esti_email.jsp?from_page="+from_page+"&content_st="+content_st+"&pack_id="+pack_id+"&user_id="+acar_id+"&est_nm="+e_bean.getEst_nm());
			}
		}else if(content_st.equals("hp_renew")){
			if(pack_id.equals("")){
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/main_car_hp/esti_print_renew.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			}else{//링크페이지
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/apply/select_esti_email.jsp?from_page="+from_page+"&content_st="+content_st+"&pack_id="+pack_id+"&user_id="+acar_id+"&est_nm="+e_bean.getEst_nm());
			}
		}else if(content_st.equals("hp_renew_all")){
			if(pack_id.equals("")){
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/main_car_hp/esti_print_renew_all.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			}else{//링크페이지
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/apply/select_esti_email.jsp?from_page="+from_page+"&content_st="+content_st+"&pack_id="+pack_id+"&user_id="+acar_id+"&est_nm="+e_bean.getEst_nm());
			}
		}else if(content_st.equals("hp_comp_fms")){
			if(pack_id.equals("")){
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/main_car_hp/esti_print_comp_fms.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			}else{//링크페이지
				d_bean.setContent		("http://fms1.amazoncar.co.kr/acar/apply/select_esti_email.jsp?from_page="+from_page+"&content_st="+content_st+"&pack_id="+pack_id+"&user_id="+acar_id+"&est_nm="+e_bean.getEst_nm());
			}
		}else{ //hp
			d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/main_car_hp/esti_print.jsp?from_page="+from_page+"&est_id="+est_id+"&acar_id="+acar_id+"&opt_chk="+opt_chk+"&fee_opt_amt="+fee_opt_amt+"&mail_yn=Y");
			add_script_yn 		= "Y";
		}
	}
	
	if(!pack_id.equals("")){
		d_bean.setContent				("http://fms1.amazoncar.co.kr/acar/apply/select_esti_email.jsp?from_page="+from_page+"&content_st="+content_st+"&pack_id="+pack_id+"&user_id="+acar_id);		//+"&est_nm="+e_bean.getEst_nm()
	}
	
	
	boolean flag = true;
	
	if(!est_id.equals("")){
	
		//[개인신용정보 조회동의] 첨부
		if(file_add_yn1.equals("Y")){
			d_bean.setEncoding			(3); //파일첨부
			d_bean.setAtc_set			(1);
		}
		
				
		flag = e_db.insertDEmail(d_bean, "", "+7");
		
		
		//[개인신용정보 조회동의] 첨부
		if(file_add_yn1.equals("Y")){
														
			String add_fileinfo 	= "개인신용정보 조회동의서.pdf";
			String add_content 	= "https://fms3.amazoncar.co.kr/doc/amazoncar_bus_doc.pdf";
						
			flag = e_db.insertDEmailEnc3(d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content);
			
		}
		//[개인신용정보 조회동의] 첨부
		if(file_add_yn2.equals("Y")){
														
			String add_fileinfo 	= "아마존카 사업자등록증.pdf";
			String add_content 	= "https://fms3.amazoncar.co.kr/doc/amazoncar_new.pdf";
						
			flag = e_db.insertDEmailEnc3(d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content);
			
		}
	
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%//if(!content_st.equals("sh_fms") && !content_st.equals("hp_fms")){%>

<%if(add_script_yn.equals("Y")){%>
<%}%>

</script>
</head>
<body>
<script language="JavaScript">
<!--
<%if(flag){%>
	alert("메일이 정상적으로 발송 되었습니다.");
	parent.window.close();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.window.close();				
<%}%>
//-->
</script>
</body>
</html>




