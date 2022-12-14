<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*,  acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
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
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id				= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd				= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String mode	 			= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	
	int last_fee_tm 	= request.getParameter("last_fee_tm")==null?0:AddUtil.parseInt(request.getParameter("last_fee_tm"));
	int add_tm 		= AddUtil.parseDigit(request.getParameter("add_tm"));
	
	int    fee_amt 		= request.getParameter("fee_amt")	==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
	int    fee_s_amt 	= request.getParameter("fee_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int    fee_v_amt 	= request.getParameter("fee_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
	int    f_fee_amt 	= request.getParameter("f_fee_amt")	==null?0:AddUtil.parseDigit(request.getParameter("f_fee_amt"));
	int    f_fee_s_amt 	= request.getParameter("f_fee_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("f_fee_s_amt"));
	int    f_fee_v_amt 	= request.getParameter("f_fee_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("f_fee_v_amt"));
	
	String rent_start_dt 	= request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt");
	String rent_end_dt 	= request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt");
	String f_use_start_dt 	= request.getParameter("f_use_start_dt")==null?"":request.getParameter("f_use_start_dt");		//1????????????
	String f_use_end_dt 	= request.getParameter("f_use_end_dt")	==null?"":request.getParameter("f_use_end_dt");			//1????????????
	String f_req_dt 	= request.getParameter("f_req_dt")	==null?"":request.getParameter("f_req_dt");			//1???? ??????????
	String f_tax_dt 	= request.getParameter("f_tax_dt")	==null?"":request.getParameter("f_tax_dt");			//1???? ????????
	String f_est_dt 	= request.getParameter("f_est_dt")	==null?"":request.getParameter("f_est_dt");			//1???? ????????
	String cng_cau	 	= request.getParameter("cng_cau")	==null?"":request.getParameter("cng_cau");			//1???? ?????? ??????
	int    u_mon	 	= request.getParameter("u_mon")		==null?0:AddUtil.parseDigit(request.getParameter("u_mon"));	//00????
	int    u_day	 	= request.getParameter("u_day")		==null?0:AddUtil.parseDigit(request.getParameter("u_day"));	//00????
	
	
	//?????????? ???????????? ???????? ???? ???? ????????????. 20110217
	//???? ?????? ???? ???? ?????? ?????? ???????? ???????? ?????? ???? ??????. 20110225
	String im_rent_end_dt 	=  c_db.addMonth(rent_start_dt, add_tm);
	im_rent_end_dt = c_db.addDay(im_rent_end_dt, -1);
	rent_end_dt = im_rent_end_dt;
	
	
	//????????
	int flag = 0;
	int flag1 = 0;
	int flag2 = 0;
	int flag3 = 0;
	int flag4 = 0;
	boolean flag6 = true;
	boolean flag7 = true;
	int count1 = 0;
	int count2 = 0;
	int count3 = 0;

	String r_use_end_dt = "";
	String req_fst_dt = "";


	//???????????? ???????? ?????? (???????????? ??????)
	if(last_fee_tm ==0){
		int max_fee_tm = a_db.getMax_fee_tm(m_id, l_cd);
		last_fee_tm = max_fee_tm;
	}
	
	
	out.println("?????????? : "+last_fee_tm+"<br>");
	out.println("???????? : "+add_tm+"<br>");
	

	//????????????
	Vector rtn = af_db.getFeeRtnList(m_id, l_cd, rent_st);
	int rtn_size = rtn.size();
	
	String rtn_yn = "N";
	
	if(rtn_size == 0){
		rtn_size = 1;
	}else{
		rtn_yn = "Y";
	}
	
	//?????????? 38??8084?? ???????? ???????? ?????????????? ???? ????
	if(l_cd.equals("S109HABR00011")){
		rtn_size = 1;
		rtn_yn = "N";
	}
	
	//???????????????????? ?????????? ????
	if(rtn_size==2){
		Hashtable ht1 = (Hashtable)rtn.elementAt(0);
		Hashtable ht2 = (Hashtable)rtn.elementAt(1);
		if(String.valueOf(ht1.get("CLIENT_ID")).equals(String.valueOf(ht2.get("CLIENT_ID")))){
			rtn_size = 1;
			rtn_yn = "N";
		}
	}
	
	//???????? ????
	FeeScdCngBean cng = new FeeScdCngBean();
	cng.setRent_mng_id	(m_id);
	cng.setRent_l_cd	(l_cd);
	cng.setFee_tm		(request.getParameter("last_fee_tm"));
	cng.setAll_st		("");
	cng.setGubun		("????????");
	cng.setB_value		(request.getParameter("last_fee_tm")+"????");
	cng.setA_value		(request.getParameter("add_tm"));
	cng.setCng_id		(user_id);
	cng.setCng_cau		("???????? ???? "+cng_cau);
	if(rtn_yn.equals("Y")){
		cng.setCng_cau		(cng.getCng_cau()+" (??????????)");
	}
	if(!af_db.insertFeeScdCng(cng)) flag += 1;
	
	
	//???????? ????
	FeeImBean im = new FeeImBean();
	im.setRent_mng_id	(m_id);
	im.setRent_l_cd		(l_cd);
	im.setRent_st		(rent_st);
	im.setAdd_tm		(request.getParameter("add_tm"));
	im.setRent_start_dt	(rent_start_dt);
	im.setRent_end_dt	(rent_end_dt);
	im.setF_use_start_dt(f_use_start_dt);
	im.setF_use_end_dt	(f_use_end_dt);
	im.setF_req_dt		(f_req_dt);
	im.setF_tax_dt		(f_tax_dt);
	im.setF_est_dt		(f_est_dt);
	im.setReg_id		(user_id);
	im.setFee_s_amt		(fee_s_amt);
	im.setFee_v_amt		(fee_v_amt);	
	
	String im_seq = af_db.insertFeeIm(im);
	
	//1???? ??????
	String f_use_s_dt 	= f_use_start_dt;
	//1???? ????????
	String f_use_e_dt 	= f_use_end_dt;
	//2???? ????????
	String t_use_s_dt 	= c_db.addDay(f_use_end_dt, 1);
	//???? ??????
	String use_e_dt 	= rent_end_dt;
	
	//?????????? ???? 1???? ??????????
	String r_use_e_dt 	= c_db.minusDay(c_db.addMonth(f_use_s_dt, 1), 1);
	int    use_days 	= 0;
	
	int fee_fst_s_amt = 0;
	int fee_fst_v_amt = 0;
	int tot_fee_s_amt = fee_s_amt*add_tm;
	int tot_fee_v_amt = fee_v_amt*add_tm;
	
	//1???? ???????? ????----------------------------------------------------------------------
	if(!AddUtil.replace(r_use_e_dt,"-","").equals(AddUtil.replace(f_use_e_dt,"-",""))){//1???? ???????????? ?????????? ????
		//??????????
		use_days 		= AddUtil.parseInt(rs_db.getDay(f_use_s_dt, f_use_e_dt));
		//????????????????
		fee_fst_s_amt 	= fee_s_amt * use_days / 30;
		fee_fst_v_amt 	= fee_fst_s_amt*10/100;
	}else{
		fee_fst_s_amt 	= fee_s_amt;
		fee_fst_v_amt 	= fee_v_amt;
	}
	fee_fst_s_amt 	= f_fee_s_amt;
	fee_fst_v_amt 	= f_fee_v_amt;
	
	
	
	
	Hashtable r_ht = new Hashtable();
	
	
	for(int s = 0 ; s < rtn_size ; s++){
		
		
		//?????????? ??????
		FeeScdBean l_fee_scd = af_db.getScdNew(m_id, l_cd, rent_st, String.valueOf(s+1), request.getParameter("last_fee_tm"), "0");
		
		
		if(rtn_yn.equals("Y")){
			r_ht = (Hashtable)rtn.elementAt(s);
		}
		
		count1 = 0;
		count3 = 0;
		r_use_end_dt = "";
		
		
		//?????? ????
		for(int i = last_fee_tm ; i < last_fee_tm+add_tm ; i++){
			
			FeeScdBean fee_scd = new FeeScdBean();
			
			fee_scd.setRent_mng_id		(m_id);
			fee_scd.setRent_l_cd		(l_cd);
			fee_scd.setRent_st		(rent_st);		// ????: ????/????
			fee_scd.setRent_seq		(String.valueOf(s+1));
			fee_scd.setFee_tm		(String.valueOf(i+1));
			fee_scd.setTm_st2		("3");			// ????: 0-?????????? (1-????????), 2-??????????????????, 3-??????????????
			fee_scd.setTm_st1		("0");			// ????: ????????(/????)
			fee_scd.setRc_yn		("0");			// default???? ?????? 
			fee_scd.setUpdate_id		(user_id);
			
			//1????---------------------------------------------------------------------------------------------
			if(i == last_fee_tm){
				fee_scd.setUse_s_dt		(f_use_s_dt);								//1???? ???????? ??????
				fee_scd.setUse_e_dt		(f_use_e_dt);								//1???? ???????? ??????
				fee_scd.setFee_est_dt		(f_est_dt);								//1???? ??????
				if(rtn_yn.equals("Y") && (l_fee_scd.getFee_s_amt()+l_fee_scd.getFee_v_amt())==AddUtil.parseInt(String.valueOf(r_ht.get("RTN_AMT"))) ){
					fee_scd.setFee_s_amt	(l_fee_scd.getFee_s_amt());						//1???? ??????
					fee_scd.setFee_v_amt	(l_fee_scd.getFee_v_amt());						//1???? ??????
				}else{
					fee_scd.setFee_s_amt	(fee_fst_s_amt);							//1???? ??????
					fee_scd.setFee_v_amt	(fee_fst_v_amt);							//1???? ??????
				}
				
			//2????????----------------------------------------------------------------------------------------
			}else{				
				//2???? ???????????? ?????? ???????? ????.
				fee_scd.setUse_s_dt		(c_db.addDay(r_use_end_dt, 1));
				fee_scd.setUse_e_dt		(c_db.addMonth(f_use_e_dt, count1));				
				fee_scd.setFee_est_dt		(c_db.addMonth(f_est_dt, count1));
				if(rtn_yn.equals("Y") && (l_fee_scd.getFee_s_amt()+l_fee_scd.getFee_v_amt())==AddUtil.parseInt(String.valueOf(r_ht.get("RTN_AMT"))) ){
					fee_scd.setFee_s_amt	(l_fee_scd.getFee_s_amt());						//1???? ??????
					fee_scd.setFee_v_amt	(l_fee_scd.getFee_v_amt());						//1???? ??????
				}else{
					fee_scd.setFee_s_amt	(fee_s_amt);								// 2?????????? ?????????? ????
					fee_scd.setFee_v_amt	(fee_v_amt);
				}
				count3++;
			}
			fee_scd.setReq_dt			(c_db.addMonth(f_req_dt, count1));
			fee_scd.setTax_out_dt			(c_db.addMonth(f_tax_dt, count1));
			fee_scd.setR_fee_est_dt			(af_db.getValidDt(fee_scd.getFee_est_dt()));
			fee_scd.setR_req_dt			(af_db.getValidDt(fee_scd.getReq_dt()));			
			fee_scd.setPay_cng_dt			(AddUtil.getDate());
			fee_scd.setPay_cng_cau			("????????"+rent_l_cd+""+rent_st+""+im_seq);
			fee_scd.setBill_yn			("I");
			
			if(!af_db.insertFeeScd(fee_scd)) flag += 1;
			
			r_use_end_dt 	= fee_scd.getUse_e_dt();
			tot_fee_s_amt 	= tot_fee_s_amt-fee_scd.getFee_s_amt();
			tot_fee_v_amt 	= tot_fee_v_amt-fee_scd.getFee_v_amt();
			count1++;
		}
	}
	
	
	
	
	
	//????????
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 	= "???????? ???? ????";
	String cont 	= "["+firm_nm+"] ?????????? ???????????? ????????????.";
	
	String user_id2 = nm_db.getWorkAuthUser("????????????");
	String user_id3 = nm_db.getWorkAuthUser("????/??????????");
	
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st	("15");
	doc.setDoc_id	(rent_l_cd+""+rent_st+""+im_seq);
	doc.setSub	(sub);
	doc.setCont	(cont);
	doc.setEtc	("");
	doc.setUser_nm1	("??????");
	doc.setUser_nm2	("????????");
	doc.setUser_nm3	("");
	doc.setUser_nm4	("");
	doc.setUser_nm5	("");
	doc.setUser_id1	(user_id);
	doc.setUser_id2	(user_id2);
	doc.setUser_id3	("");
	doc.setDoc_bit	("1");
	doc.setDoc_step	("1");//????
	
	//=====[doc_settle] insert=====
	flag6 = d_db.insertDocSettle(doc);
	//out.println("?????????? ????<br>");
	
	doc = d_db.getDocSettleCommi("15", rent_l_cd+""+rent_st+""+im_seq);
	String doc_no = doc.getDoc_no();
	
	
	//???????? ???? ????----------------------------------------------------------------------------------------
	
	//String url 		= "/fms2/lc_rent/lc_im_frame.jsp";
	String url 		= "/fms2/lc_rent/lc_im_doc_u.jsp?doc_no="+doc.getDoc_no()+"|rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
	String m_url = "/fms2/lc_rent/lc_im_frame.jsp";
	String target_id = doc.getUser_id2();
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
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
	
	flag7 = cm_db.insertCoolMsg(msg);
	
	//?????????????? ???????????????? ????	
	if(rtn_size>1){
		sub 		= "???????? ???????? ????";
		cont 		= "["+firm_nm+"] ?????????? ?????????? ???????????? ???????????? ????????????.";			
		user_id2 	= nm_db.getWorkAuthUser("????????????????");
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
		if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
				
		target_bean 	= umd.getUsersBean(user_id2);		
		xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
  				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>"+
			        "    <TARGET>"+target_bean.getId()+"</TARGET>"+
		    	        "    <SENDER>"+sender_bean.getId()+"</SENDER>"+	
  				"    <MSGICON>10</MSGICON>"+
  				"    <MSGSAVE>1</MSGSAVE>"+
  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
  				"    <FLDTYPE>1</FLDTYPE>"+
  				"  </ALERTMSG>"+
  				"</COOLMSG>";	
		msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");	
		flag7 = cm_db.insertCoolMsg(msg);					
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">   
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">      
</form>
<script language='javascript'>
<%	if(flag > 0){%>
		alert("???????? ??????????");
		//location='about:blank';
		
<%	}else{		%>		
		alert("??????????????");
		var fm = document.form1;
	<%	if(mode.equals("pop")){%>
				parent.opener.location.reload();
				window.close();
	<%	}else{%>
				fm.target='d_content';
				fm.action='lc_im_doc_u.jsp';
				fm.submit();
	<%	}%>		
//		parent.window.close();	
<%	}			%>
</script>
</body>
</html>
