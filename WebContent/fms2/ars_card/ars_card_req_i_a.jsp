<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,java.net.*,acar.util.*"%>
<%@ page import="acar.ars_card.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String mail_dyr_ggr = request.getParameter("mail_dyr_ggr")==null?"":request.getParameter("mail_dyr_ggr");	
	String mail_etc_ycr = request.getParameter("mail_etc_ycr")==null?"":request.getParameter("mail_etc_ycr");	
	String mail_dyr_bgs = request.getParameter("mail_dyr_bgs")==null?"":request.getParameter("mail_dyr_bgs");	
	String mail_etc_gtr = request.getParameter("mail_etc_gtr")==null?"":request.getParameter("mail_etc_gtr");	
	String mail_etc_hap = request.getParameter("mail_etc_hap")==null?"":request.getParameter("mail_etc_hap");	
	String mail_dyr_hap = request.getParameter("mail_dyr_hap")==null?"":request.getParameter("mail_dyr_hap");	
	String settle_mny = request.getParameter("settle_mny")==null?"":request.getParameter("settle_mny");	
	String card_fee = request.getParameter("card_fee")==null?"":request.getParameter("card_fee");	
	String kj_ggr = request.getParameter("kj_ggr")==null?"":request.getParameter("kj_ggr");	
	String kj_bgs = request.getParameter("kj_bgs")==null?"":request.getParameter("kj_bgs");	
	String good_mny = request.getParameter("good_mny")==null?"":request.getParameter("good_mny");	
	String buyr_name = request.getParameter("buyr_name")==null?"":request.getParameter("buyr_name");	
	String buyr_mail = request.getParameter("buyr_mail")==null?"":request.getParameter("buyr_mail");	
	String card_per = request.getParameter("card_per")==null?"":request.getParameter("card_per");
	String m_card_fee = request.getParameter("m_card_fee")==null?"":request.getParameter("m_card_fee");
	String bus_nm = request.getParameter("bus_nm")==null?"":request.getParameter("bus_nm");
	
	String mail_check = request.getParameter("mail_check")==null?"":request.getParameter("mail_check");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag6 = true;
	int flag = 0;
	
	String ars_code = "";
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String mng_user_id = nm_db.getWorkAuthUser("법인카드관리자");
	UsersBean mnger_bean 	= umd.getUsersBean(mng_user_id);
	


	System.out.println(rent_l_cd+" Ars Card 결제요청 : "+request.getParameter("good_mny"));
	
	
	
	ArsCardBean ars = new ArsCardBean();
		
	ars.setClient_id	(client_id);
	ars.setBuyr_name 	(request.getParameter("buyr_name")==null?"":request.getParameter("buyr_name"));
	ars.setBuyr_tel2 	(request.getParameter("buyr_tel2")==null?"":request.getParameter("buyr_tel2"));
	ars.setBuyr_mail 	(request.getParameter("buyr_mail")==null?"":request.getParameter("buyr_mail"));
	ars.setGood_name 	(request.getParameter("good_name")==null?"":request.getParameter("good_name"));
	ars.setGood_cont 	(request.getParameter("msg")==null?"":request.getParameter("msg"));
	ars.setGood_mny		(request.getParameter("good_mny")==null?0:AddUtil.parseDigit(request.getParameter("good_mny")));
	ars.setCard_kind 	(request.getParameter("card_kind")==null?"":request.getParameter("card_kind"));
	ars.setCard_no 		(request.getParameter("card_no")==null?"":request.getParameter("card_no"));
	ars.setCard_y_mm 	(request.getParameter("card_y_mm")==null?"":request.getParameter("card_y_mm"));
	ars.setCard_y_yy 	(request.getParameter("card_y_yy")==null?"":request.getParameter("card_y_yy"));
	ars.setQuota	 	(request.getParameter("quota")==null?"":request.getParameter("quota"));
	ars.setReg_id		(ck_acar_id);
	ars.setSettle_mny	(request.getParameter("settle_mny")==null?0:AddUtil.parseDigit(request.getParameter("settle_mny")));
	ars.setCard_fee		(request.getParameter("card_fee")==null?0:AddUtil.parseDigit(request.getParameter("card_fee")));
	
	ars.setExempt_yn 	(request.getParameter("exempt_yn")==null?"":request.getParameter("exempt_yn"));
	ars.setExempt_cau 	(request.getParameter("exempt_cau")==null?"":request.getParameter("exempt_cau"));
	ars.setArs_content 	(request.getParameter("ars_content")==null?"":request.getParameter("ars_content"));
	ars.setCard_per 	(request.getParameter("card_per")==null?"":request.getParameter("card_per"));
	ars.setApp_st	 	(request.getParameter("app_st")==null?"":request.getParameter("app_st"));
	ars.setArs_step		("1");
	
	ars.setSettle_mny_1	(request.getParameter("mail_dyr_hap")==null?0:AddUtil.parseDigit(request.getParameter("mail_dyr_hap")));
	ars.setSettle_mny_2	(request.getParameter("mail_etc_hap")==null?0:AddUtil.parseDigit(request.getParameter("mail_etc_hap")));
	ars.setM_card_fee	(request.getParameter("m_card_fee")==null?0:AddUtil.parseDigit(request.getParameter("m_card_fee")));
		
	ars.setArs_content	("http://fms1.amazoncar.co.kr/mailing/off_doc/select_ars_email_docs.jsp?user_id="+user_id+"&est_nm="+URLEncoder.encode(buyr_name, "EUC-KR")+"&memo="+URLEncoder.encode(request.getParameter("msg"), "EUC-KR")+"&mail_dyr_ggr="+mail_dyr_ggr+"&mail_etc_ycr="+mail_etc_ycr+"&mail_dyr_bgs="+mail_dyr_bgs+"&mail_etc_gtr="+mail_etc_gtr+"&mail_etc_hap="+mail_etc_hap+"&mail_dyr_hap="+mail_dyr_hap+"&settle_mny="+settle_mny+"&card_fee="+card_fee+"&kj_ggr="+kj_ggr+"&kj_bgs="+kj_bgs+"&good_mny="+good_mny+"&card_per="+card_per);
	
	ars.setBus_nm		(bus_nm);
	ars.setMng_nm		(mnger_bean.getUser_nm());
	
	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	
	
	if(bus_nm.equals("")){
		ars.setBus_nm		(sender_bean.getUser_nm());
	}
		
	ars_code = ar_db.insertArsCard(ars);
	
	
	
	
	if(sender_bean.getLoan_st().equals("")) {
		sender_bean 	= umd.getUserNmBean(bus_nm);
	}	
	
	//이노페이에서 처리

	//수수료면제
	if(!ars_code.equals("") && ars.getExempt_yn().equals("Y")){
		
		//6. 문서처리전 등록-------------------------------------------------------------------------------------------
		
		String sub 		= "신용카드결재 수수료 면제";
		String cont 	= "["+ars.getBuyr_name()+"] 신용카드결재청구 수수료면제건입니다. 결재바랍니다.";
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("35");
		doc.setDoc_id(ars_code);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("기안자");
		doc.setUser_nm2("팀장");
		doc.setUser_nm3("총무팀장");
		doc.setUser_nm4("대표이사");		
		doc.setUser_id1(ck_acar_id);
		
		String user_id2 = "";
		if(sender_bean.getDept_id().equals("0001")  ) {  
			user_id2 = "000028";								
		}else if( sender_bean.getDept_id().equals("0002") || sender_bean.getDept_id().equals("0014")  || sender_bean.getDept_id().equals("0015")  ) { //고객지원
			user_id2 = "000026";
		}else if(sender_bean.getDept_id().equals("0013") ||sender_bean.getDept_id().equals("0009") ||sender_bean.getDept_id().equals("0012")  ||sender_bean.getDept_id().equals("0017")   ||sender_bean.getDept_id().equals("0018") ) { //수원
			if( sender_bean.getLoan_st().equals("1") ){ //관리
				user_id2 = "000026";
			}else { //영업
				user_id2 = "000028";
			}						
		}else if( sender_bean.getDept_id().equals("0007") ||  sender_bean.getDept_id().equals("0016")   ) {
			user_id2 = "000053";
		}else if(sender_bean.getDept_id().equals("0008")) {
			user_id2 = "000052";
		}else if(sender_bean.getDept_id().equals("0010")) {
			user_id2 = "000219"; //류선
		}else if(sender_bean.getDept_id().equals("0011")) {
			user_id2 = "000054";
		}else{
			user_id2 = "XXXXXX";
		}
				
		String user_id3 = nm_db.getWorkAuthUser("본사총무팀장");
		String user_id4 = "XXXXXX";		
		
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		
		if(!user_id2.equals("XXXXXX") && !cs_bean2.getUser_id().equals("")){
			if(!cs_bean2.getWork_id().equals("")){
				user_id2 = cs_bean2.getWork_id();
			}
		}
		if(!cs_bean3.getUser_id().equals("")){
			if(!cs_bean3.getWork_id().equals("")){
				user_id3 = cs_bean3.getWork_id();
			}
		}
		
		doc.setUser_id2(user_id2);
		doc.setUser_id3(user_id3);
		doc.setUser_id4(user_id4);		
		
		//=====[doc_settle] insert=====
		doc.setDoc_step("0");
		doc.setDoc_bit("0");
		flag6 = d_db.insertDocSettle2(doc);
	
	}
	
	
	if(ars.getApp_st().equals("1")){

		//카드결제담당자에게 전달
		String target_id = nm_db.getWorkAuthUser("법인카드관리자");
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);	
		
		if(!cs_bean.getUser_id().equals("")){
			if(cs_bean.getTitle().equals("오전반휴")){
				//등록시간이 오전(12시전)이라면 대체자
				if(AddUtil.getTimeAM().equals("오전")){
					target_id = nm_db.getWorkAuthUser("연장/승계담당자");	
				}								
			}else if(cs_bean.getTitle().equals("오후반휴")){
				//등록시간이 오후(12시이후)라면 대체자
				if(AddUtil.getTimeAM().equals("오후")){				
					target_id = nm_db.getWorkAuthUser("연장/승계담당자");	
				}
			}else{//연차
				target_id = nm_db.getWorkAuthUser("연장/승계담당자");
			}
		}	
		
			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		
		
		String sub 	= "";
		String cont 	= "";

		sub 	= "ARS카드결제요청";
		cont 	= "[ "+request.getParameter("buyr_name")+" ] ARS카드 결제요청 합니다.";
		
		
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
							"    <BACKIMG>4</BACKIMG>"+
							"    <MSGTYPE>104</MSGTYPE>"+
	  						"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
	 						"    <URL></URL>";
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
				
		flag1 = cm_db.insertCoolMsg(msg);
		
				
	}
%>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name="client_id" value="<%=client_id%>">
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name="ars_code" value="<%=ars_code%>">
  
<input type="hidden" name="mail_dyr_ggr" value="<%= mail_dyr_ggr %>">
<input type="hidden" name="mail_etc_ycr" value="<%= mail_etc_ycr %>">
<input type="hidden" name="mail_dyr_bgs" value="<%= mail_dyr_bgs %>">
<input type="hidden" name="mail_etc_gtr" value="<%= mail_etc_gtr %>">
<input type="hidden" name="mail_etc_hap" value="<%= mail_etc_hap %>">
<input type="hidden" name="mail_dyr_hap" value="<%= mail_dyr_hap %>">
<input type="hidden" name="settle_mny" value="<%= settle_mny %>">
<input type="hidden" name="card_fee" value="<%= card_fee %>">
<input type="hidden" name="m_card_fee" value="<%= m_card_fee %>">
<input type="hidden" name="kj_ggr" value="<%= kj_ggr %>">
<input type="hidden" name="kj_bgs" value="<%= kj_bgs %>">
<input type="hidden" name="good_mny" value="<%= good_mny %>">
<input type="hidden" name="card_per" value="<%= card_per %>">  
<input type="hidden" name="mail_addr" value="<%= buyr_mail %>">
<input type="hidden" name="est_nm" value="<%= buyr_name %>">
  
</form>
<script language='javascript'>
	var fm = document.form1;
	
	//선택메일발송
	/*
	function select_email(){
		var fm =document.form1;	
		fm.action = "select_send_mail_docs.jsp";
		fm.submit();	
	}
	*/

	
<%	if(ars_code.equals("")){%>
		alert('등록 에러입니다.\n\n확인하십시오');
<%	}else{%>		
		//alert('등록되었습니다. \n\n카드결재담당자가 업무처리후 통보할 예정입니다.');
		alert('등록되었습니다.');
		
		<%if(mail_check.equals("Y")){%>
		//select_email();
		<%}%>
<%	}%>

		
	fm.action = 'ars_card_req_c.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>