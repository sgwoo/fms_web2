<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
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
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
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
%>


<%
	//1. 용품관리 결재처리-------------------------------------------------------------------------------------------
	
	if(doc_bit.equals("")){
		TintBean tint 	= t_db.getTint(tint_no);
		
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
		tint.setNavi_est_amt	(request.getParameter("navi_est_amt")==null? 0:AddUtil.parseDigit(request.getParameter("navi_est_amt")));
		tint.setOther			(request.getParameter("sup_other")	==null?"":request.getParameter("sup_other"));
		tint.setEtc				(request.getParameter("sup_etc")	==null?"":request.getParameter("sup_etc"));
		tint.setSup_est_dt		(sup_est_dt+sup_est_h);
		tint.setSup_dt			(sup_dt+sup_h);
		tint.setTint_amt		(request.getParameter("tint_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tint_amt")));
		tint.setCleaner_amt		(request.getParameter("cleaner_amt")==null? 0:AddUtil.parseDigit(request.getParameter("cleaner_amt")));
		tint.setNavi_amt		(request.getParameter("navi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("navi_amt")));
		tint.setOther_amt		(request.getParameter("other_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("other_amt")));
		tint.setTot_amt			(request.getParameter("tot_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("tot_amt")));
		if(sup_off_id.length()>6){
			tint.setOff_id			(sup_off_id.substring(0,6));
			tint.setOff_nm			(sup_off_id.substring(6));
		}
		tint.setA_amt			(request.getParameter("a_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("a_amt")));
		tint.setE_amt			(request.getParameter("e_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("e_amt")));
		tint.setC_amt			(request.getParameter("c_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("c_amt")));
		tint.setE_sub_amt1		(request.getParameter("e_sub_amt1")	==null? 0:AddUtil.parseDigit(request.getParameter("e_sub_amt1")));
		tint.setE_sub_amt2		(request.getParameter("e_sub_amt2")	==null? 0:AddUtil.parseDigit(request.getParameter("e_sub_amt2")));
		tint.setC_sub_amt1		(request.getParameter("c_sub_amt1")	==null? 0:AddUtil.parseDigit(request.getParameter("c_sub_amt1")));
		tint.setC_sub_amt2		(request.getParameter("c_sub_amt2")	==null? 0:AddUtil.parseDigit(request.getParameter("c_sub_amt2")));
		
		tint.setA_tint_amt		(request.getParameter("a_tint_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("a_tint_amt")));
		tint.setA_cleaner_amt	(request.getParameter("a_cleaner_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("a_cleaner_amt")));
		tint.setA_navi_amt		(request.getParameter("a_navi_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("a_navi_amt")));
		tint.setA_other_amt		(request.getParameter("a_other_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("a_other_amt")));
		tint.setE_tint_amt		(request.getParameter("e_tint_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("e_tint_amt")));
		tint.setE_cleaner_amt	(request.getParameter("e_cleaner_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("e_cleaner_amt")));
		tint.setE_navi_amt		(request.getParameter("e_navi_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("e_navi_amt")));
		tint.setE_other_amt		(request.getParameter("e_other_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("e_other_amt")));
		tint.setC_tint_amt		(request.getParameter("c_tint_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("c_tint_amt")));
		tint.setC_cleaner_amt	(request.getParameter("c_cleaner_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("c_cleaner_amt")));
		tint.setC_navi_amt		(request.getParameter("c_navi_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("c_navi_amt")));
		tint.setC_other_amt		(request.getParameter("c_other_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("c_other_amt")));
		
		tint.setBlackbox_yn		(request.getParameter("blackbox_yn")	==null?"":request.getParameter("blackbox_yn"));
		tint.setBlackbox_nm		(request.getParameter("blackbox_nm")	==null?"":request.getParameter("blackbox_nm"));
		tint.setBlackbox_amt		(request.getParameter("blackbox_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("blackbox_amt")));
		
		if(AddUtil.parseInt(tint.getReg_dt()) < 20140801){
			tint.setA_amt		(tint.getTot_amt());
		}
		
		
		//=====[consignment] update=====
		flag1 = t_db.updateTint(tint);
		
	}else{
	
	
		TintBean tint 	= t_db.getTint(tint_no);
		
		int tot_amt = tint.getTot_amt();
		int sel_amt = tint.getA_amt()+tint.getE_amt()+tint.getC_amt();
		
		if(tot_amt != sel_amt){
			tint.setA_amt			(request.getParameter("a_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("a_amt")));
			tint.setE_amt			(request.getParameter("e_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("e_amt")));
			tint.setC_amt			(request.getParameter("c_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("c_amt")));
			tint.setE_sub_amt1		(request.getParameter("e_sub_amt1")		==null? 0:AddUtil.parseDigit(request.getParameter("e_sub_amt1")));
			tint.setE_sub_amt2		(request.getParameter("e_sub_amt2")		==null? 0:AddUtil.parseDigit(request.getParameter("e_sub_amt2")));
			tint.setC_sub_amt1		(request.getParameter("c_sub_amt1")		==null? 0:AddUtil.parseDigit(request.getParameter("c_sub_amt1")));
			tint.setC_sub_amt2		(request.getParameter("c_sub_amt2")		==null? 0:AddUtil.parseDigit(request.getParameter("c_sub_amt2")));
			tint.setA_tint_amt		(request.getParameter("a_tint_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("a_tint_amt")));
			tint.setA_cleaner_amt	(request.getParameter("a_cleaner_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("a_cleaner_amt")));
			tint.setA_navi_amt		(request.getParameter("a_navi_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("a_navi_amt")));
			tint.setA_other_amt		(request.getParameter("a_other_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("a_other_amt")));
			tint.setE_tint_amt		(request.getParameter("e_tint_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("e_tint_amt")));
			tint.setE_cleaner_amt	(request.getParameter("e_cleaner_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("e_cleaner_amt")));
			tint.setE_navi_amt		(request.getParameter("e_navi_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("e_navi_amt")));
			tint.setE_other_amt		(request.getParameter("e_other_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("e_other_amt")));
			tint.setC_tint_amt		(request.getParameter("c_tint_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("c_tint_amt")));
			tint.setC_cleaner_amt	(request.getParameter("c_cleaner_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("c_cleaner_amt")));
			tint.setC_navi_amt		(request.getParameter("c_navi_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("c_navi_amt")));
			tint.setC_other_amt		(request.getParameter("c_other_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("c_other_amt")));
			
			if(AddUtil.parseInt(tint.getReg_dt()) < 20140801){
				tint.setA_amt		(tint.getTot_amt());
			}
			
			//=====[consignment] update=====
			flag1 = t_db.updateTint(tint);
		}
		
		
		if(doc_bit.equals("5")){
		
			//1. 탁송의뢰 수신 처리 수정----------------------------------------------------------------------------------------	
			
			flag1 = t_db.updateTintConf(tint_no);
			
		}
		
		//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		
		DocSettleBean doc = d_db.getDocSettleCommi("6", tint_no);
		
		String doc_no 	= doc.getDoc_no();
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
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
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
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
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
	<%if(!doc_bit.equals("")){%>
	fm.action = '<%=from_page%>';
	<%}else{%>
	fm.action = 'tint_reg_step3.jsp';
	<%}%>
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>