<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String tint_no 	= request.getParameter("tint_no")==null?"":request.getParameter("tint_no");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);	
%>


<%
	//1. 용품관리 결재처리-------------------------------------------------------------------------------------------
	
	TintBean tint 	= t_db.getTint(tint_no);
	
	String o_sup_est_dt = tint.getSup_est_dt();
		
	if(o_sup_est_dt.length()==10){
		o_sup_est_dt = o_sup_est_dt.substring(0,8);
	}	
	
	String sup_off_id 	= request.getParameter("sup_off_id")==null?"":request.getParameter("sup_off_id");
	String sup_est_dt 	= request.getParameter("sup_est_dt")==null?"":request.getParameter("sup_est_dt");
	String sup_est_h 	= request.getParameter("sup_est_h")	==null?"":request.getParameter("sup_est_h");
	String sup_dt 		= request.getParameter("sup_dt")==null?"":request.getParameter("sup_dt");
	String sup_h 		= request.getParameter("sup_h")	==null?"":request.getParameter("sup_h");
	
	tint.setFilm_st			(request.getParameter("film_st")	==null?"":request.getParameter("film_st"));
	tint.setSun_per			(request.getParameter("sun_per")	==null? 0:AddUtil.parseDigit(request.getParameter("sun_per")));
	tint.setCleaner_st		(request.getParameter("cleaner_st")	==null?"":request.getParameter("cleaner_st"));
	tint.setCleaner_add		(request.getParameter("cleaner_add")==null?"":request.getParameter("cleaner_add"));
	tint.setNavi_nm			(request.getParameter("navi_nm")	==null?"":request.getParameter("navi_nm"));
	tint.setNavi_est_amt		(request.getParameter("navi_est_amt")==null? 0:AddUtil.parseDigit(request.getParameter("navi_est_amt")));
	tint.setOther			(request.getParameter("sup_other")	==null?"":request.getParameter("sup_other"));
	tint.setEtc			(request.getParameter("sup_etc")	==null?"":request.getParameter("sup_etc"));
	tint.setSup_est_dt		(sup_est_dt+sup_est_h);
	tint.setSup_dt			(sup_dt+sup_h);
	tint.setTint_amt		(request.getParameter("tint_amt")==null? 0:AddUtil.parseDigit(request.getParameter("tint_amt")));
	tint.setCleaner_amt		(request.getParameter("cleaner_amt")==null? 0:AddUtil.parseDigit(request.getParameter("cleaner_amt")));
	tint.setNavi_amt		(request.getParameter("navi_amt")==null? 0:AddUtil.parseDigit(request.getParameter("navi_amt")));
	tint.setOther_amt		(request.getParameter("other_amt")==null? 0:AddUtil.parseDigit(request.getParameter("other_amt")));
	tint.setTot_amt			(request.getParameter("tot_amt")==null? 0:AddUtil.parseDigit(request.getParameter("tot_amt")));
	tint.setEtc			(request.getParameter("sup_etc")	==null?"":request.getParameter("sup_etc"));

	tint.setBlackbox_yn		(request.getParameter("blackbox_yn")	==null?"":request.getParameter("blackbox_yn"));
	tint.setBlackbox_nm		(request.getParameter("blackbox_nm")	==null?"":request.getParameter("blackbox_nm"));
	tint.setBlackbox_amt		(request.getParameter("blackbox_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("blackbox_amt")));
	
	if(sup_off_id.length()>6){
			tint.setOff_id			(sup_off_id.substring(0,6));
			tint.setOff_nm			(sup_off_id.substring(6));
	}
	
	//=====[consignment] update=====
	flag1 = t_db.updateTint(tint);
	
	
	String n_sup_est_dt = sup_est_dt;
		
		//작업요청일시 변경시 안내문자 발송
		if(tint.getOff_id().equals("002849") && tint.getTint_cau().equals("1") && !AddUtil.replace(n_sup_est_dt,"-","").equals(AddUtil.replace(o_sup_est_dt,"-",""))){
					
	
			UsersBean target_bean2 	= umd.getUsersBean("000103");						
		
			String sms_content = "[작업요청일 변경안내] 계출번호:"+pur.getRpt_no()+", 상호:"+request.getParameter("firm_nm")+", 차명:"+request.getParameter("car_nm")+", 변경작업요청일:"+n_sup_est_dt+" -아마존카-";
					
			int i_msglen = AddUtil.lengthb(sms_content);
		
			String msg_type = "0";
		
			//80이상이면 장문자
			if(i_msglen>80) msg_type = "5";
					
			String send_phone = sender_bean.getUser_m_tel();
			
			if(!sender_bean.getHot_tel().equals("")){
				send_phone = sender_bean.getHot_tel();
			}
					
		
			IssueDb.insertsendMail_V5_H(send_phone, sender_bean.getUser_nm(), target_bean2.getUser_m_tel(), target_bean2.getUser_nm(), "", "", msg_type, "[작업요청일 변경안내]", sms_content, "", "", ck_acar_id, "tint_est");
					
		}	
			
	
	//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	
	if(mode.equals("settle")){
		DocSettleBean doc = d_db.getDocSettleCommi("6", tint_no);
		
		String doc_no 	= doc.getDoc_no();
		String doc_bit	= "3";
		String doc_step = "2";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
//		out.println("문서처리전 결재<br>");
	}
	
	
	//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	/*
	String sub 		= "[탁송번호:"+tint_no+"] 탁송의뢰 수신";
	String cont 	= driver_cont;
	String url 		= "/fms2/tint/tint_reg_step3.jsp?tint_no="+tint_no;
	
	
	UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id4());
	
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
	
	flag3 = cm_db.insertCoolMsg(msg);
//	out.println("쿨메신저 수정<br>");
//	System.out.println("쿨메신저(탁송의뢰수신)"+tint_no+"-----------------------"+target_bean.getUser_nm());
	
	//4. SMS 문자 발송------------------------------------------------------------
	if(!target_bean.getUser_m_tel().equals("")){
		String sendphone 	= sender_bean.getHot_tel();
		String sendname 	= "(주)아마존카";
		String destphone 	= target_bean.getUser_m_tel();
		String destname 	= target_bean.getUser_nm();
		IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont);
	}
	*/
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('탁송 수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
<%		if(!flag2){	%>	alert('문서품의서 결제 에러입니다.\n\n확인하십시오');			<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">  
  <input type='hidden' name='tint_no' 			value='<%=tint_no%>'>    
</form>
<script language='javascript'>
	var fm = document.form1;	
	<%if(mode.equals("settle")){%>
	fm.action = 'tint_i_frame.jsp';
	<%}else{%>
	fm.action = 'tint_reg_step2.jsp';
	<%}%>
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>