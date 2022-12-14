<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*,acar.accid.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id		 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd		 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String ins_st 		= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	String ch_item 		= request.getParameter("r_ch_item")==null?"":request.getParameter("r_ch_item");
	String doc_user_id1 = request.getParameter("doc_user_id1")==null?"":request.getParameter("doc_user_id1");
	String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_no		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ins_db = InsDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//20170203 ???????????? ????????
	//????????????
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//?????????? ?????????? ??????4???? ?????? ????????.
	if(base.getRent_start_dt().equals("")) base.setRent_start_dt(base.getRent_dt());
	
	//????????????
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");	
	
	String mon_term = c_db.getMons(AddUtil.getDate(), base.getRent_start_dt());
	
	//20170421 ???????? (??)???????? 2017-04-18 ~ 2020-04-18
	if((base.getCar_st().equals("1") || base.getCar_st().equals("3") || base.getCar_st().equals("5")) && AddUtil.parseInt(AddUtil.replace(f_fee.getRent_start_dt(),"-","")) >= 20170421){
		mon_term = c_db.getMons2(AddUtil.getDate(), base.getRent_start_dt());
	}
	
	int con_mon = AddUtil.parseInt(mon_term) ;	
	
	//????????
	Hashtable cont_info = as_db.getRentCase(m_id, l_cd);
	
	String ins_doc_no 	= request.getParameter("ins_doc_no")==null?"":request.getParameter("ins_doc_no");
	String doc_no 		= request.getParameter("doc_no")	==null?"":request.getParameter("doc_no");
	String cng_dt 		= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_etc 		= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	String ins_doc_st 	= request.getParameter("ins_doc_st")==null?"":request.getParameter("ins_doc_st");
	String reject_cau 	= request.getParameter("reject_cau")==null?"":request.getParameter("reject_cau");
	String doc_bit 		= request.getParameter("doc_bit")	==null?"":request.getParameter("doc_bit");
	String car_st 		= request.getParameter("car_st")	==null?"":request.getParameter("car_st");
	int o_fee_amt		= request.getParameter("o_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("o_fee_amt"));
	int n_fee_amt		= request.getParameter("n_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_fee_amt"));
	int d_fee_amt		= request.getParameter("d_fee_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("d_fee_amt"));
	
	
	//????????
	InsurChangeBean d_bean = ins_db.getInsChangeDoc(ins_doc_no);
	
	//??????????????
	Vector ins_cha = ins_db.getInsChangeDocList(ins_doc_no);
	int ins_cha_size = ins_cha.size();
	
	
	//????????
	int flag = 0;
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	
	//System.out.println("====??????????????????====");	
	//System.out.println("ins_doc_no="+d_bean.getIns_doc_no());
	//System.out.println("doc_bit="+doc_bit);
	
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	//?????????????? ???????????? ????????.
	if(doc_bit.equals("1") || doc_bit.equals("2") || doc_bit.equals("u")){
		
		String ch_before[] 						= request.getParameterValues("ch_before");
		String ch_after[] 						= request.getParameterValues("ch_after");
		
		//????????????????-------------------------------------------
		d_bean.setCh_dt				(cng_dt);
		d_bean.setCh_etc			(cng_etc);
		d_bean.setUpdate_id			(user_id);
		d_bean.setO_fee_amt			(o_fee_amt);
		d_bean.setN_fee_amt			(n_fee_amt);
		d_bean.setD_fee_amt			(d_fee_amt);
		d_bean.setO_opt_amt			(request.getParameter("o_opt_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("o_opt_amt")));
		d_bean.setN_opt_amt			(request.getParameter("n_opt_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_opt_amt")));
		d_bean.setO_cls_per			(request.getParameter("o_cls_per")==null? 0:AddUtil.parseFloat(request.getParameter("o_cls_per")));
		d_bean.setN_cls_per			(request.getParameter("n_cls_per")==null? 0:AddUtil.parseFloat(request.getParameter("n_cls_per")));
		d_bean.setO_rtn_run_amt		(request.getParameter("o_rtn_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_rtn_run_amt")));
		d_bean.setN_rtn_run_amt		(request.getParameter("n_rtn_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("n_rtn_run_amt")));
		d_bean.setO_over_run_amt	(request.getParameter("o_over_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_over_run_amt")));
		d_bean.setN_over_run_amt	(request.getParameter("n_over_run_amt")==null?0:AddUtil.parseDigit(request.getParameter("n_over_run_amt")));
		
		
		//???????????????????? ?????? ?????????? ?????? ????.(20180719)
		if(doc_bit.equals("1") && ch_item.equals("6")){	
			ins_doc_st = "Y";
			d_bean.setIns_doc_st		(ins_doc_st);
		}
		if(doc_bit.equals("2")){
			d_bean.setIns_doc_st		(ins_doc_st);
		}
		d_bean.setReject_cau		(reject_cau);
		
		if(!ins_db.updateInsChangeDoc(d_bean)) flag += 1;
		
		//System.out.println("d_bean.getD_fee_amt()="+d_bean.getD_fee_amt());
		
		for(int i = 0 ; i < ins_cha_size ; i++){
			InsurChangeBean bean = (InsurChangeBean)ins_cha.elementAt(i);
			bean.setCh_before		(ch_before[i]);
			bean.setCh_after		(ch_after[i]);
			if(!ins_db.updateInsChangeDocList(bean)) flag += 1;
		}
	}
	
	
	//1. ?????????? ????????-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	String doc_step = "2";

	//???????? ???????? ???? ???? ???? - ???????? ????
	if(doc_bit.equals("2") && ins_doc_st.equals("N")) doc_step = "3";
	
	//???????????? ???????? ???? ????
	if(doc_bit.equals("3")) doc_step = "3";
		
	if(doc_bit.equals("1")) doc_step = "1";

	
	if(doc_bit.equals("1") || doc_bit.equals("2") || doc_bit.equals("4") || doc_bit.equals("5") || ( con_mon<4 && doc_bit.equals("3")) ){
	
		flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		
		//???????????????????? ?????? ?????????? ?????? ????.(20180719)
		if(doc_bit.equals("1") && ch_item.equals("6")){	
			flag1 = d_db.updateDocSettle(doc_no, "XXXXXX", "2", "2");	
		}
		
		//2. ???????? ?????? ????------------------------------------------------------------------------------------------

			String sub 	= "?????????????? ???????????? ????????";
			String cont 	= "["+firm_nm+"] ?????????????? ?????? ??????????.";
			String target_id= "";
			String url 			= "/fms2/con_fee/fee_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|c_id="+c_id+"|ins_st="+ins_st+"|ins_doc_no="+ins_doc_no;
			String m_url ="/fms2/con_fee/fee_doc_frame.jsp";
			target_id = doc.getUser_id3();
			String ch_item_text = "";
			if(ch_item.equals("6")){	ch_item_text = "?????????????????? ????????"; }else{	ch_item_text = "???????????? ????";	}
			
			if(doc_bit.equals("1") && !ch_item.equals("6")){
				target_id = doc.getUser_id2();
			}
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
			
			//???????? ?????????? ???????????????? ????????????.
			if(doc_bit.equals("2")||(doc_bit.equals("1") && ch_item.equals("6"))){
				sub 		= "???????????? ???? ???????????? ????????";
				cont 		= "[ "+car_no+" "+rent_l_cd+" "+cont_info.get("FIRM_NM")+" ] "+ch_item_text+" ???????????? ?????? ??????????. ???????? "+Util.parseDecimal(d_bean.getO_fee_amt())+"?????? "+Util.parseDecimal(d_bean.getN_fee_amt())+"?????? ???? (?????????? "+Util.parseDecimal(d_bean.getD_fee_amt())+"??)";
				target_id 	= nm_db.getWorkAuthUser("????????????????");
				
				cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
			
				if(ins_doc_st.equals("N")){
					sub 		= "?????????????? ????";
					cont 		= "["+car_no+"] ???????????????? ???????? ????????. ?????????? ["+reject_cau+"] ??????.";
					target_id 	= doc.getUser_id1();
				}
			}
			
			//???????????? ?????????? ?????????????????????? ????????????.
			//???? ?????? ??????, ?????????????????????? ?????? ?????? ???? -???????????????? ????  (20200708) 
			if( con_mon<4 && doc_bit.equals("3")){	
				/* if(ch_item.equals("6")){	//?????? ???? ?????? ?????????? ???????????? ?????? ?????????? ??????????(???????????????????????? ??????????)(20180719)
					sub 		= "???????????????? ???? ????";
					cont		= "???????? [ "+car_no+" "+rent_l_cd+" "+cont_info.get("FIRM_NM")+" ] ?????? ???????????? ???? ??????????.";
					target_id   = doc_user_id1;
				}else{ */
					
				//?????????? ??????	
				sub 		= "???????????????? ????????";
				cont		= "???????? [ "+car_no+" "+rent_l_cd+" "+cont_info.get("FIRM_NM")+" ] ?????????? ???????? ??????????????????.";
				target_id   = doc_user_id1;
					
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
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
				
				flag2 = cm_db.insertCoolMsg(msg);
					
				
				// ???????????? ?????????? ??????(???????? ????)
				sub 		= "???????????? ???? ???????? ?????? ????";
				cont 		= "[ "+car_no+" "+rent_l_cd+" "+cont_info.get("FIRM_NM")+" ]  &lt;br&gt; &lt;br&gt; ???????? ?????? ??????????.  &lt;br&gt; &lt;br&gt; ?????????? ?????? ???? ?????? ????????.  &lt;br&gt; &lt;br&gt; ???????? "+Util.parseDecimal(d_bean.getO_fee_amt())+"?????? "+Util.parseDecimal(d_bean.getN_fee_amt())+"?????? ????  &lt;br&gt; &lt;br&gt; (?????????? "+Util.parseDecimal(d_bean.getD_fee_amt())+"??)";
				target_id 	= nm_db.getWorkAuthUser("????????????");
				
				cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
			//	}
			}
			
			//?????????????? ???? ???? ?????? ????????
			if(ch_item.equals("7") && ins_doc_st.equals("Y")){
				if(doc_bit.equals("2")){
					sub 		= "?????????????????? ???? ?????????? ????";
					cont 		= "[ "+car_no+" "+rent_l_cd+" "+cont_info.get("FIRM_NM")+" ]  &lt;br&gt; &lt;br&gt; ???????????????????? ??????????.  &lt;br&gt; &lt;br&gt; ?????? ?????? ????????????.";
					target_id = doc.getUser_id4();
				}else if(doc_bit.equals("4")){
					sub 		= "?????????????????? ????";
					cont 		= "[ "+car_no+" "+rent_l_cd+" "+cont_info.get("FIRM_NM")+" ]  &lt;br&gt; &lt;br&gt; ???????????????????? ??????????.  &lt;br&gt; &lt;br&gt; ???? ?? ????????????.";
					target_id = doc.getUser_id5();
				}
			}
			
			
			//???????? ???? ????----------------------------------------------------------------------------------------
			
			
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
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
			
			if(doc_bit.equals("3") && car_st.equals("2")){	
			}else{
				flag2 = cm_db.insertCoolMsg(msg);
				//System.out.println("????????(??????????????????)"+car_no+"-----------------------"+target_bean.getUser_nm());
			}
	}
	
	if(doc_bit.equals("3")){
		flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		
		//????????????
		if(ch_item.equals("8")){	
			String sResult = ins_db.call_sp_ins_cng_doc(ins_doc_no); 	
		}
		
		String cng_cau = "??????????????????-";
		
		String dist_cng_yn = "";
		int    dist_cng_value = 0;
		
		//????????????
		for(int i = 0 ; i < ins_cha_size ; i++){
			InsurChangeBean bean = (InsurChangeBean)ins_cha.elementAt(i);
			if(bean.getCh_item().equals("1")){       cng_cau = cng_cau + "???????? ";
			}else if(bean.getCh_item().equals("2")){ cng_cau = cng_cau + "?????????? ";
			}else if(bean.getCh_item().equals("3")){ cng_cau = cng_cau + "???? ";
			}else if(bean.getCh_item().equals("4")){ cng_cau = cng_cau + "?????????? ";
			}else if(bean.getCh_item().equals("5")){ cng_cau = cng_cau + "???????????????? ";
				dist_cng_yn = "Y";
				dist_cng_value = AddUtil.parseDigit(bean.getCh_after());
			}else if(bean.getCh_item().equals("6")){ cng_cau = cng_cau + "???????????????????? ";
			}else if(bean.getCh_item().equals("7")){ cng_cau = cng_cau + "?????????????????? ";
			}else if(bean.getCh_item().equals("8")){ cng_cau = cng_cau + "???????????? ";			
			}else if(bean.getCh_item().equals("9")){ cng_cau = cng_cau + "?????????? ";
			}
			
		}
			
		cng_cau = cng_cau + "-"+cng_etc;
		
		//????????,??????????,?????????????? ????????
		
		LcRentCngHBean lc_cng_bean = new LcRentCngHBean();
	
		lc_cng_bean.setRent_mng_id		(d_bean.getRent_mng_id());
		lc_cng_bean.setRent_l_cd		(d_bean.getRent_l_cd());
		lc_cng_bean.setCng_id			(ck_acar_id);
		lc_cng_bean.setRent_st			(d_bean.getRent_st());
		
		//fee
		ContFeeBean fee = a_db.getContFeeNew(d_bean.getRent_mng_id(), d_bean.getRent_l_cd(), d_bean.getRent_st());
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(d_bean.getRent_mng_id(), d_bean.getRent_l_cd(), d_bean.getRent_st());
		
		if(d_bean.getN_fee_amt() >0 && d_bean.getN_fee_amt()!=d_bean.getO_fee_amt()){
			lc_cng_bean.setCng_item		("fee_amt");
			lc_cng_bean.setOld_value	(String.valueOf(d_bean.getO_fee_amt()));
			lc_cng_bean.setNew_value	(String.valueOf(d_bean.getN_fee_amt()));
			lc_cng_bean.setCng_cau		(cng_cau);
			lc_cng_bean.setS_amt		(request.getParameter("n_fee_s_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_fee_s_amt")));
			lc_cng_bean.setV_amt		(request.getParameter("n_fee_v_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_fee_v_amt")));
	
			flag3 = a_db.updateLcRentCngH(lc_cng_bean);
			
			fee.setFee_s_amt			(request.getParameter("n_fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("n_fee_s_amt")));
			fee.setFee_v_amt			(request.getParameter("n_fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("n_fee_v_amt")));
			
			//=====[fee] update=====
			flag1 = a_db.updateContFeeNew(fee);
			
			for(int i = 0 ; i < ins_cha_size ; i++){
				InsurChangeBean bean = (InsurChangeBean)ins_cha.elementAt(i);
				if(i==0 && bean.getCh_item().equals("4")){
					//?????????? ??????
					//System.out.println("d_bean.getD_fee_amt():"+d_bean.getD_fee_amt());					
						int d_fee_amt_re = (int)Math.round(d_bean.getD_fee_amt()/1.1);
						int driver_add_amt = fee_etc.getDriver_add_amt()+d_fee_amt_re;
						//int d_fee_amt_v_re = d_bean.getD_fee_amt()-d_fee_amt_re ;
						int d_fee_amt_v_re = (int)Math.round(driver_add_amt*0.1);
						
						fee_etc.setDriver_add_amt	(driver_add_amt);
						fee_etc.setDriver_add_v_amt	(d_fee_amt_v_re);						
						if(driver_add_amt==0){
							fee_etc.setDriver_add_v_amt	(0);
						}
					   /*  System.out.println("d_fee_amt_re:"+d_bean.getD_fee_amt() );
					    System.out.println("d_fee_amt_re:"+d_fee_amt_re );
						System.out.println("d_fee_amt_v_re:"+d_fee_amt_v_re );   
						 */
						flag1 = a_db.updateFeeEtc(fee_etc);
						
				}
			}
			
			
		}
		if(d_bean.getN_opt_amt() >0 && d_bean.getN_opt_amt()!=d_bean.getO_opt_amt()){
			lc_cng_bean.setCng_item		("opt_amt");
			lc_cng_bean.setOld_value	(String.valueOf(d_bean.getO_opt_amt()));
			lc_cng_bean.setNew_value	(String.valueOf(d_bean.getN_opt_amt()));
			lc_cng_bean.setCng_cau		(cng_cau);
			lc_cng_bean.setS_amt		(request.getParameter("n_opt_s_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_opt_s_amt")));
			lc_cng_bean.setV_amt		(request.getParameter("n_opt_v_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_opt_v_amt")));
	
			flag3 = a_db.updateLcRentCngH(lc_cng_bean);
			
			fee.setOpt_s_amt			(request.getParameter("n_opt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("n_opt_s_amt")));
			fee.setOpt_v_amt			(request.getParameter("n_opt_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("n_opt_v_amt")));
			
			//=====[fee] update=====
			flag1 = a_db.updateContFeeNew(fee);
			
		}
		if(d_bean.getN_cls_per() >0 && d_bean.getN_cls_per()!=d_bean.getO_cls_per()){
			lc_cng_bean.setCng_item		("cls_per");
			lc_cng_bean.setOld_value	(String.valueOf(d_bean.getO_cls_per()));
			lc_cng_bean.setNew_value	(String.valueOf(d_bean.getN_cls_per()));
			lc_cng_bean.setCng_cau		(cng_cau);
			lc_cng_bean.setS_amt		(0);
			lc_cng_bean.setV_amt		(0);
	
			flag3 = a_db.updateLcRentCngH(lc_cng_bean);
			
			fee.setCls_r_per			(request.getParameter("n_cls_per")		==null? 0:AddUtil.parseFloat(request.getParameter("n_cls_per")));
			
			//=====[fee] update=====
			flag1 = a_db.updateContFeeNew(fee);
		}
		if((d_bean.getO_rtn_run_amt() >0 || d_bean.getN_rtn_run_amt() >0) && d_bean.getN_rtn_run_amt()!=d_bean.getO_rtn_run_amt()){
			lc_cng_bean.setCng_item		("rtn_run_amt");
			lc_cng_bean.setOld_value	(String.valueOf(d_bean.getO_rtn_run_amt()));
			lc_cng_bean.setNew_value	(String.valueOf(d_bean.getN_rtn_run_amt()));
			lc_cng_bean.setCng_cau		(cng_cau);
			lc_cng_bean.setS_amt		(request.getParameter("n_rtn_run_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_rtn_run_amt")));
			lc_cng_bean.setV_amt		(0);
	
			flag3 = a_db.updateLcRentCngH(lc_cng_bean);
			
			fee_etc.setRtn_run_amt		(request.getParameter("n_rtn_run_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("n_rtn_run_amt")));
			
			if(AddUtil.parseInt(base.getRent_dt()) > 20220414){
				if(d_bean.getN_rtn_run_amt() == 0){
					fee_etc.setRtn_run_amt_yn	("1"); //????????????????
				}else{
					fee_etc.setRtn_run_amt_yn	("0"); //??????????????
				}
			}	
			
			//=====[fee_etc] update=====
			flag1 = a_db.updateFeeEtc(fee_etc);						
		}
		if((d_bean.getO_over_run_amt() >0 || d_bean.getN_over_run_amt() >0) && d_bean.getN_over_run_amt()!=d_bean.getO_over_run_amt()){
			lc_cng_bean.setCng_item		("over_run_amt");
			lc_cng_bean.setOld_value	(String.valueOf(d_bean.getO_over_run_amt()));
			lc_cng_bean.setNew_value	(String.valueOf(d_bean.getN_over_run_amt()));
			lc_cng_bean.setCng_cau		(cng_cau);
			lc_cng_bean.setS_amt		(request.getParameter("n_over_run_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("n_over_run_amt")));
			lc_cng_bean.setV_amt		(0);
	
			flag3 = a_db.updateLcRentCngH(lc_cng_bean);
			
			fee_etc.setOver_run_amt		(request.getParameter("n_over_run_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("n_over_run_amt")));
			
			//=====[fee_etc] update=====
			flag1 = a_db.updateFeeEtc(fee_etc);						
		}
		
		//???????????? ????
		if(dist_cng_yn.equals("Y")){
			fee_etc.setAgree_dist		(dist_cng_value);
			//=====[fee_etc] update=====
			flag1 = a_db.updateFeeEtc(fee_etc);		
		}
	}
	
	if(doc_bit.equals("d")){
		if(!ins_db.deleteInsChangeDoc(d_bean)) flag += 1;
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 		value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 		value="<%=user_id%>">
  <input type="hidden" name="br_id" 		value="<%=br_id%>">    
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>  
  <input type='hidden' name='gubun1'	 	value='<%=gubun1%>'>    
  <input type="hidden" name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 	value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 		value="<%=rent_st%>">   
  <input type='hidden' name="c_id" 			value="<%=c_id%>">
  <input type='hidden' name="ins_st"		value="<%=ins_st%>">
  <input type="hidden" name="doc_no" 		value="<%=doc_no%>">       
  <input type="hidden" name="ins_doc_no"	value="<%=ins_doc_no%>">       
</form>
<script language='javascript'>
<%	if(!flag1){%>
		alert("???????? ??????????");
<%	}else{		%>		
		alert("??????????????");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='fee_doc_u.jsp';
		<%if(doc_bit.equals("d")){%>
		fm.action='fee_doc_reg_frame.jsp';
		<%}%>
		fm.submit();	
<%	}			%>
</script>
</body>
</html>