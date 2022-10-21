<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.tint.*, acar.coolmsg.*, acar.car_sche.*, acar.consignment.*, acar.car_office.*, acar.client.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
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
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit		= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String mode			= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String fdcd_amt 	= request.getParameter("fdcd_amt")==null?"":request.getParameter("fdcd_amt");
	String fdcd_dt 		= request.getParameter("fdcd_dt")==null?"":request.getParameter("fdcd_dt");
	String fdcd_id 		= request.getParameter("fdcd_id")==null?"":request.getParameter("fdcd_id");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag9 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//영업소
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);	
	
%>


<%
	//4. 출고정보 car_pur--------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);

	String o_udt_st = pur.getUdt_st();
	String o_dlv_est_dt = AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")));
	String o_con_est_dt = pur.getCon_est_dt();
	
	String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
	String dlv_est_h 	= request.getParameter("dlv_est_h")==null?"":request.getParameter("dlv_est_h");
	
	pur.setDlv_brch		(request.getParameter("dlv_brch")	==null?"":request.getParameter("dlv_brch"));
	pur.setRpt_no		(request.getParameter("rpt_no")		==null?"":request.getParameter("rpt_no"));
	pur.setDlv_est_dt	(dlv_est_dt+dlv_est_h);
	pur.setCon_amt		(request.getParameter("con_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("con_amt")));
	pur.setTrf_amt1		(request.getParameter("trf_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt1")));
	pur.setTrf_amt2		(request.getParameter("trf_amt2").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt2")));
	pur.setTrf_amt3		(request.getParameter("trf_amt3").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt3")));
	pur.setTrf_amt4		(request.getParameter("trf_amt4").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt4")));
	//신규칼럼
	pur.setDlv_ext		(request.getParameter("dlv_ext")	==null?"":request.getParameter("dlv_ext"));
	pur.setUdt_st		(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));
	pur.setUdt_est_dt	(request.getParameter("udt_est_dt")	==null?"":request.getParameter("udt_est_dt"));
	pur.setCons_st		(request.getParameter("cons_st")	==null?"":request.getParameter("cons_st"));
	pur.setOff_id		(request.getParameter("off_id")		==null?"":request.getParameter("off_id"));
	pur.setOff_nm		(request.getParameter("off_nm")		==null?"":request.getParameter("off_nm"));
	pur.setCons_amt1	(request.getParameter("cons_amt1").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt1")));
	pur.setCons_amt2	(request.getParameter("cons_amt2").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt2")));
	pur.setJan_amt		(request.getParameter("jan_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("jan_amt")));
	pur.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
	pur.setCon_pay_dt	(request.getParameter("con_pay_dt")	==null?"":request.getParameter("con_pay_dt"));
	pur.setRent_ext		(request.getParameter("rent_ext")	==null?"":request.getParameter("rent_ext"));
	pur.setTrf_st1		(request.getParameter("trf_st1")	==null?"":request.getParameter("trf_st1"));
	pur.setTrf_st2		(request.getParameter("trf_st2")	==null?"":request.getParameter("trf_st2"));
	pur.setTrf_st3		(request.getParameter("trf_st3")	==null?"":request.getParameter("trf_st3"));
	pur.setTrf_st4		(request.getParameter("trf_st4")	==null?"":request.getParameter("trf_st4"));
	pur.setCard_kind1	(request.getParameter("card_kind1")	==null?"":request.getParameter("card_kind1"));
	pur.setCard_kind2	(request.getParameter("card_kind2")	==null?"":request.getParameter("card_kind2"));
	pur.setCard_kind3	(request.getParameter("card_kind3")	==null?"":request.getParameter("card_kind3"));
	pur.setCard_kind4	(request.getParameter("card_kind4")	==null?"":request.getParameter("card_kind4"));
	pur.setCardno1		(request.getParameter("cardno1")	==null?"":request.getParameter("cardno1"));
	pur.setCardno2		(request.getParameter("cardno2")	==null?"":request.getParameter("cardno2"));
	pur.setCardno3		(request.getParameter("cardno3")	==null?"":request.getParameter("cardno3"));
	pur.setCardno4		(request.getParameter("cardno4")	==null?"":request.getParameter("cardno4"));
	pur.setTrf_cont1	(request.getParameter("trf_cont1")	==null?"":request.getParameter("trf_cont1"));
	pur.setTrf_cont2	(request.getParameter("trf_cont2")	==null?"":request.getParameter("trf_cont2"));
	pur.setTrf_cont3	(request.getParameter("trf_cont3")	==null?"":request.getParameter("trf_cont3"));
	pur.setTrf_cont4	(request.getParameter("trf_cont4")	==null?"":request.getParameter("trf_cont4"));
	pur.setPur_est_dt	(request.getParameter("pur_est_dt")	==null?"":request.getParameter("pur_est_dt"));
	pur.setCar_num		(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));
	pur.setCon_amt_cont	(request.getParameter("con_amt_cont")	==null?"":request.getParameter("con_amt_cont"));
	pur.setAcc_st1		(request.getParameter("acc_st1")	==null?"":request.getParameter("acc_st1"));
	pur.setAcc_st2		(request.getParameter("acc_st2")	==null?"":request.getParameter("acc_st2"));
	pur.setAcc_st3		(request.getParameter("acc_st3")	==null?"":request.getParameter("acc_st3"));
	pur.setAcc_st4		(request.getParameter("acc_st4")	==null?"":request.getParameter("acc_st4"));
	pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
	pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
	pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
	pur.setAcq_cng_yn	(request.getParameter("acq_cng_yn")	==null?"":request.getParameter("acq_cng_yn"));
	pur.setCpt_cd		(request.getParameter("cpt_cd")		==null?"":request.getParameter("cpt_cd"));
	pur.setCom_tint		(request.getParameter("com_tint")	==null?"":request.getParameter("com_tint"));
	pur.setCom_film_st	(request.getParameter("com_film_st")	==null?"":request.getParameter("com_film_st"));
	
	pur.setTrf_st0		(request.getParameter("trf_st0")	==null?"":request.getParameter("trf_st0"));
	pur.setAcc_st0		(request.getParameter("acc_st0")	==null?"":request.getParameter("acc_st0"));
	
	pur.setTrf_st5		(request.getParameter("trf_st5")	==null?"":request.getParameter("trf_st5"));
	pur.setTrf_amt5		(request.getParameter("trf_amt5").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt5")));
	pur.setCard_kind5	(request.getParameter("card_kind5")	==null?"":request.getParameter("card_kind5"));
	pur.setCardno5		(request.getParameter("cardno5")	==null?"":request.getParameter("cardno5"));
	pur.setTrf_cont5	(request.getParameter("trf_cont5")	==null?"":request.getParameter("trf_cont5"));
	pur.setAcc_st5		(request.getParameter("acc_st5")	==null?"":request.getParameter("acc_st5"));
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	
		//출고예정일 변경시
		if(pur.getOne_self().equals("Y") && !o_dlv_est_dt.equals("") && !o_dlv_est_dt.equals(dlv_est_dt)){
			//최초영업자가 수정시 : 출고담당자에게 메시지 발송
			if(base.getBus_id().equals(user_id)){
				//메시지발송 프로시저 호출
				String  d_flag2 =  ec_db.call_sp_message_send("msg", "차량대금지급요청 출고예정일("+o_dlv_est_dt+"->"+dlv_est_dt+") 변경 : 최초영업자", rent_mng_id, rent_l_cd, user_id);
			//최초영업자 아닌 자가 수정시 : 최초영업자에게 메시지 발송
			}else{
				//메시지발송 프로시저 호출
				String  d_flag2 =  ec_db.call_sp_message_send("msg", "차량대금지급요청 출고예정일("+o_dlv_est_dt+"->"+dlv_est_dt+") 변경 : "+sender_bean.getUser_nm(), rent_mng_id, rent_l_cd, user_id);
			}
		}	
		
		String n_con_est_dt = pur.getCon_est_dt();
		
		//지급요청일 변경시 출고담당자/카드할부담당자 메시지 발송
		if (!o_con_est_dt.equals("") && !AddUtil.replace(o_con_est_dt,"-","").equals(AddUtil.replace(n_con_est_dt,"-","")) && AddUtil.parseInt(fdcd_amt) > 0) {
			
			if(AddUtil.parseInt(AddUtil.replace(n_con_est_dt,"-","")) < AddUtil.parseInt(AddUtil.replace(fdcd_dt,"-",""))){
											
				String sub2 			= "카드할부 지급요청일 변동";				
				String cont2 			= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" 문서번호:"+fdcd_id+"]  &lt;br&gt; &lt;br&gt; 카드할부건 승인일자("+fdcd_dt+")인데 지급요청일("+n_con_est_dt+")로 변경되었습니다. &lt;br&gt; &lt;br&gt;  확인바랍니다.";
				
				cont2 			= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" 문서번호:"+fdcd_id+"]  &lt;br&gt; &lt;br&gt; 카드할부건인데 승인일자("+fdcd_dt+")보다 지급요청일("+n_con_est_dt+")이 작습니다.  &lt;br&gt; &lt;br&gt; 확인바랍니다.";
				
				String url2   = "/fms2/car_pur/pur_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;			
				String m_url2 = "/fms2/car_pur/pur_doc_frame.jsp";
								
				String target_id2 	= nm_db.getWorkAuthUser("출고관리자");
							
				CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id2);
				if (!cs_bean7.getUser_id().equals("")) {
					target_id2 	= cs_bean7.getWork_id();
				}
				
				//사용자 정보 조회
				UsersBean target_bean2 = umd.getUsersBean(target_id2);
				
				String xml_data2 = "";
				xml_data2 =  "<COOLMSG>"+
			  					"<ALERTMSG>"+
	  							"    <BACKIMG>4</BACKIMG>"+
	  							"    <MSGTYPE>104</MSGTYPE>"+
	  							"    <SUB>"+sub2+"</SUB>"+
			  					"    <CONT>"+cont2+"</CONT>"+
	 							"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url2+"&m_url="+m_url2+"</URL>";
				xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
				
				xml_data2 += "    <TARGET>"+umd.getSenderId(nm_db.getWorkAuthUser("대출관리자"))+"</TARGET>";
				
				xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  							"    <MSGICON>10</MSGICON>"+
	  							"    <MSGSAVE>1</MSGSAVE>"+
	  							"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  					"    <FLDTYPE>1</FLDTYPE>"+
	  							"  </ALERTMSG>"+
	  							"</COOLMSG>";
				
				CdAlertBean msg2 = new CdAlertBean();
				msg2.setFlddata(xml_data2);
				msg2.setFldtype("1");
				
				flag5 = cm_db.insertCoolMsg(msg2);
				
				//지급수단1,2,3 초기화
				if (pur.getTrf_pay_dt1().equals("")) {
					
					pur.setTrf_st1		("");
					pur.setTrf_amt1		(0);
					pur.setCard_kind1	("");
					pur.setCardno1		("");
					pur.setTrf_cont1	("");
					pur.setAcc_st1		("");
					
					pur.setTrf_st2		("");
					pur.setTrf_amt2		(0);
					pur.setCard_kind2	("");
					pur.setCardno2		("");
					pur.setTrf_cont2	("");
					pur.setAcc_st2		("");
					
					pur.setTrf_st3		("");
					pur.setTrf_amt3		(0);
					pur.setCard_kind3	("");
					pur.setCardno3		("");
					pur.setTrf_cont3	("");
					pur.setAcc_st3		("");
					
					//=====[CAR_PUR] update=====
					flag4 = a_db.updateContPur(pur);
					
				}
			}			
		}
		
		String n_udt_st = pur.getUdt_st();
		
		
		//차량인수지 변경시 계약변경관리에게 메시지 발송
		if(!o_udt_st.equals("") && !o_udt_st.equals(n_udt_st)){
			if(base.getUse_yn().equals("Y")){
				
				//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
				
				String sub2 		= "장기계약 차량인수지 변동";
				String cont2 		= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ]  &lt;br&gt; &lt;br&gt; 장기계약의 차량인수지가 ("+c_db.getNameByIdCode("0035", "", o_udt_st)+" -> "+c_db.getNameByIdCode("0035", "", n_udt_st)+") 변동하였습니다.  &lt;br&gt; &lt;br&gt; 확인바랍니다.";
				String target_id2 	= nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
				
				
				CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id2);
				if(!cs_bean7.getUser_id().equals("")){
					if(cs_bean7.getTitle().equals("오전반휴")){
						//등록시간이 오전(12시전)이라면 대체자, 아니면 본인
						target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
					}else if(cs_bean7.getTitle().equals("오후반휴")){
						//등록시간이 오후(12시이후)라면 대체자, 아니면 본인
						target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
					}else{//연차
						target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
					}
				}
				
				//사용자 정보 조회
				UsersBean target_bean2 	= umd.getUsersBean(target_id2);
				
				String xml_data2 = "";
				xml_data2 =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
	  						"    <BACKIMG>4</BACKIMG>"+
	  						"    <MSGTYPE>104</MSGTYPE>"+
	  						"    <SUB>"+sub2+"</SUB>"+
			  				"    <CONT>"+cont2+"</CONT>"+
	 						"    <URL></URL>";
				xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
				xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  						"    <MSGICON>10</MSGICON>"+
	  						"    <MSGSAVE>1</MSGSAVE>"+
	  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
	  						"  </ALERTMSG>"+
	  						"</COOLMSG>";
				
				CdAlertBean msg2 = new CdAlertBean();
				msg2.setFlddata(xml_data2);
				msg2.setFldtype("1");
				
				flag5 = cm_db.insertCoolMsg(msg2);
				
			}
		}		
			
	
		//자체-배달탁송
		if(pur.getCons_st().equals("2") && !pur.getOff_id().equals("")){
			//기존 배달탁송 등록이 있는지 확인
			ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
		
			if(cons.getUdt_firm().equals("")){
				UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
				UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("부산지점장"));
				UsersBean udt_mng_bean_b2	= umd.getUsersBean(nm_db.getWorkAuthUser("부산주차장관리"));
				UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전지점장"));
				UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("대구지점장"));
				UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("광주지점장"));
					
				String udt_mng_id 	= "";
			  	String udt_mng_nm 	= "";
				String udt_mng_tel 	= "";
				String udt_firm 	= "";
				String udt_addr 	= "";
				
				if(pur.getUdt_st().equals("1")){
					udt_mng_id 	= udt_mng_bean_s.getUser_id();
					udt_mng_nm 	= udt_mng_bean_s.getDept_nm()+" "+udt_mng_bean_s.getUser_nm()+" "+udt_mng_bean_s.getUser_pos();  		
			  		udt_mng_tel 	= udt_mng_bean_s.getHot_tel();
				  	udt_firm 	= "영등포 영남주차장"; 
			  		udt_addr 	= "서울시 영등포구 영등포로 34길 9";   
			  	}else if(pur.getUdt_st().equals("2")){
				  	udt_mng_id 	= udt_mng_bean_b2.getUser_id();
			  		udt_mng_nm 	= udt_mng_bean_b2.getDept_nm()+" "+udt_mng_bean_b2.getUser_nm()+" "+udt_mng_bean_b2.getUser_pos(); 
				  	udt_mng_tel = udt_mng_bean_b2.getHot_tel();
				  	udt_firm 	= "조양골프연습장 주차장"; 
			  		udt_addr 	= "부산광역시 연제구 연산4동 585-1";
			  		//20210204 이사
			  		if(AddUtil.getDate2(4) >= 20210205){
			  			udt_firm 	= "스마일TS"; 
			  			udt_addr 	= "부산시 연제구 안연로7번나길 10(연산동 363-13번지)";
			  		}
			  	}else if(pur.getUdt_st().equals("3")){
				  	udt_mng_id 	= udt_mng_bean_d.getUser_id();
			  		udt_mng_nm 	= udt_mng_bean_d.getDept_nm()+" "+udt_mng_bean_d.getUser_nm()+" "+udt_mng_bean_d.getUser_pos(); 
				  	udt_mng_tel 	= udt_mng_bean_d.getHot_tel();
				  	udt_firm 	= "미성테크"; 
			  		udt_addr 	= "대전광역시 유성구 온천북로59번길 10(봉명동 690-3)";     	
			  	}else if(pur.getUdt_st().equals("5")){
				  	udt_mng_id 	= udt_mng_bean_g.getUser_id();
			  		udt_mng_nm 	= udt_mng_bean_g.getDept_nm()+" "+udt_mng_bean_g.getUser_nm()+" "+udt_mng_bean_g.getUser_pos(); 
				  	udt_mng_tel 	= udt_mng_bean_g.getHot_tel();
				  	udt_firm 	= "대구 썬팅집"; 
			  		udt_addr 	= "대구광역시 달서구 신당동 321-86";     	
			  	}else if(pur.getUdt_st().equals("6")){
			  		udt_mng_id 	= udt_mng_bean_j.getUser_id();
			  		udt_mng_nm 	= udt_mng_bean_j.getDept_nm()+" "+udt_mng_bean_j.getUser_nm()+" "+udt_mng_bean_j.getUser_pos(); 
				  	udt_mng_tel 	= udt_mng_bean_j.getHot_tel();
				  	udt_firm 	= "용용이자동차용품점"; 
			  		udt_addr 	= "광주광역시 광산구 상무대로 233 (송정동 1360)";     	
			  	}else if(pur.getUdt_st().equals("4")){
				  	udt_mng_id 	= client.getClient_id();
			  		udt_mng_nm 	= client.getCon_agnt_dept()+" "+client.getCon_agnt_nm()+" "+client.getCon_agnt_title();
				  	udt_mng_tel 	= client.getO_tel();
				  	udt_firm 	= client.getFirm_nm(); 
			  		udt_addr 	= client.getO_addr();     	
			  	}
				cons.setUdt_firm	(udt_firm);	
				cons.setUdt_addr	(udt_addr);		
				cons.setUdt_mng_id	(udt_mng_id);	
				cons.setUdt_mng_nm	(udt_mng_nm);	
				cons.setUdt_mng_tel	(udt_mng_tel);	
			}
			
			//신규입력이면
			if(cons.getRent_l_cd().equals("")){
		
				//탁송의뢰등록	
				String cons_no	 	= "";		
		
				cons.setRent_mng_id		(rent_mng_id);
				cons.setRent_l_cd		(rent_l_cd);
				cons.setReq_id			(base.getBus_id());
				cons.setReg_id			(user_id);
			
				//=====[consignment] insert=====
				cons_no = cs_db.insertConsignmentPur(cons);		
			}else{
				//=====[CONS_PUR] update=====
				flag4 = cs_db.updateConsignmentPur(cons);

				if(!o_udt_st.equals(n_udt_st)){
			
					ConsignmentBean cng_bean = new ConsignmentBean();
			
					int next_seq = cs_db.getConsPurCngNextSeq(cons.getCons_no());
			
					cng_bean.setCons_no		(cons.getCons_no());
					cng_bean.setSeq			(next_seq);			
					cng_bean.setCng_st		("1");			
					cng_bean.setReg_id		(user_id);
				
					//=====[CONS_PUR_CNT] insert=====				
					flag1 = cs_db.insertConsignmentPurCng(cng_bean);			
				}		
			}
		}else{
			if(pur.getCons_st().equals("1")){
			
				//기존 배달탁송 등록이 있는지 확인
				ConsignmentBean cons = cs_db.getConsignmentPur(rent_mng_id, rent_l_cd);
			
				//기존의뢰 있으면 취소
				if(!cons.getRent_l_cd().equals("") && cons.getDlv_dt().equals("")){
					//배달탁송취소
					flag1 = cs_db.updateConsignmentPurCancel(rent_mng_id, rent_l_cd, ck_acar_id);
				
					//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
							
					String sub2 		= "배달탁송 의뢰취소";
					String cont2 		= "[ "+rent_l_cd+" "+pur.getRpt_no()+" ] 배달탁송 의뢰취소합니다. 확인바랍니다.";
					String target_id2 	= "";
							
					if(pur.getOff_id().equals("007751")){
						target_id2 = "000187";
					}
					if(pur.getOff_id().equals("009026")){
						target_id2 = "000222";
					}
					if(pur.getOff_id().equals("009771")){
						target_id2 = "000240";
					}
					if(pur.getOff_id().equals("011372")){
						target_id2 = "000308";
					}
				
				
					if(!target_id2.equals("")){
					
						//사용자 정보 조회
						UsersBean target_bean2 	= umd.getUsersBean(target_id2);
					
						String xml_data2 = "";
						xml_data2 =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
	  						"    <BACKIMG>4</BACKIMG>"+
	  						"    <MSGTYPE>104</MSGTYPE>"+
	  						"    <SUB>"+sub2+"</SUB>"+
			  				"    <CONT>"+cont2+"</CONT>"+
	 						"    <URL></URL>";
						xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
						xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  						"    <MSGICON>10</MSGICON>"+
	  						"    <MSGSAVE>1</MSGSAVE>"+
	  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
	  						"  </ALERTMSG>"+
	  						"</COOLMSG>";
				
						CdAlertBean msg2 = new CdAlertBean();
						msg2.setFlddata(xml_data2);
						msg2.setFldtype("1");
					
						flag5 = cm_db.insertCoolMsg(msg2);
						
					}
				}		
			}
		}	
	
	//5. 차량기본정보 car_etc-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	int o_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	String o_reg_est_dt = car.getReg_est_dt();
		
	if(o_reg_est_dt.length()==10){
		o_reg_est_dt = o_reg_est_dt.substring(0,8);
	}
		
	String reg_est_dt 	= request.getParameter("reg_est_dt")==null?"":request.getParameter("reg_est_dt");
	String reg_est_h 	= request.getParameter("reg_est_h")==null?"":request.getParameter("reg_est_h");
	
	car.setReg_est_dt	(reg_est_dt+reg_est_h);
	car.setSd_cs_amt	(request.getParameter("sd_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cs_amt")));
	car.setSd_cv_amt	(request.getParameter("sd_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("sd_cv_amt")));
	car.setDc_cs_amt	(request.getParameter("dc_cs_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cs_amt")));
	car.setDc_cv_amt	(request.getParameter("dc_cv_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("dc_cv_amt")));
	car.setS_dc1_amt	(request.getParameter("s_dc1_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc1_amt")));
	car.setS_dc2_amt	(request.getParameter("s_dc2_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc2_amt")));
	car.setS_dc3_amt	(request.getParameter("s_dc3_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("s_dc3_amt")));
	car.setS_dc1_re		(request.getParameter("s_dc1_re")	==null?"":request.getParameter("s_dc1_re"));
	car.setS_dc2_re		(request.getParameter("s_dc2_re")	==null?"":request.getParameter("s_dc2_re"));
	car.setS_dc3_re		(request.getParameter("s_dc3_re")	==null?"":request.getParameter("s_dc3_re"));
	car.setS_dc1_yn		(request.getParameter("s_dc1_yn")	==null?"":request.getParameter("s_dc1_yn"));
	car.setS_dc2_yn		(request.getParameter("s_dc2_yn")	==null?"":request.getParameter("s_dc2_yn"));
	car.setS_dc3_yn		(request.getParameter("s_dc3_yn")	==null?"":request.getParameter("s_dc3_yn"));
	car.setS_dc1_re_etc	(request.getParameter("s_dc1_re_etc")	==null?"":request.getParameter("s_dc1_re_etc"));
	car.setS_dc2_re_etc	(request.getParameter("s_dc2_re_etc")	==null?"":request.getParameter("s_dc2_re_etc"));
	car.setS_dc3_re_etc	(request.getParameter("s_dc3_re_etc")	==null?"":request.getParameter("s_dc3_re_etc"));
	car.setS_dc1_per	(request.getParameter("s_dc1_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc1_per")));
	car.setS_dc2_per	(request.getParameter("s_dc2_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc2_per")));
	car.setS_dc3_per	(request.getParameter("s_dc3_per")	==null? 0:AddUtil.parseFloat(request.getParameter("s_dc3_per")));
	car.setCar_ext		(request.getParameter("car_ext")	==null?"":request.getParameter("car_ext"));
	
	//=====[car_etc] update=====
	flag5 = a_db.updateContCarNew(car);
	
	
	int n_car_amt = car.getCar_fs_amt()+car.getCar_fv_amt()+car.getDc_cs_amt()+car.getDc_cv_amt();
	
	if(!pur.getDlv_brch().equals("특판팀") && !pur.getDlv_brch().equals("법인판촉팀") && !pur.getDlv_brch().equals("법인판매팀") && !pur.getDlv_brch().equals("B2B사업운영팀") && (o_car_amt < n_car_amt || o_car_amt > n_car_amt)){
	
		//금액변동이 있었음->영업팀장에게 메시지 전달
		
			
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub2 		= "장기계약 차가변동";
			String cont2 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] 장기계약의 차량금액이 변동하였습니다. 확인바랍니다.";
			String target_id2 = nm_db.getWorkAuthUser("계약변경관리");//20130128 차종관리자->중고차가분석자 변동  20131205 중고차가분석자->계약변경관리
			
			
			CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id2);
			if(!cs_bean7.getUser_id().equals(""))	target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
			
			//사용자 정보 조회
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
		  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			if((o_car_amt-n_car_amt) > 10000 || (o_car_amt-n_car_amt) < -10000){
				flag5 = cm_db.insertCoolMsg(msg2);
			}
		
	}
	
	if((o_car_amt < n_car_amt || o_car_amt > n_car_amt) && emp1.getCommi_car_amt()>0){
		int commi_car_amt = car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt();
		if(AddUtil.parseInt(base.getRent_dt()) >= 20190701 ){
			commi_car_amt = commi_car_amt -car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
		}
		emp1.setCommi_car_amt(commi_car_amt);
		//=====[commi] update=====
		flag1 = a_db.updateCommiNew(emp1);	
	}	
	
	String n_reg_est_dt = reg_est_dt;
		
	//등록예정일 변경시 안내문자 발송
	if(pur.getUdt_st().equals("1") && !AddUtil.replace(n_reg_est_dt,"-","").equals(AddUtil.replace(o_reg_est_dt,"-",""))){

		UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("차량등록자"));

		String sms_content = "[등록예정일 변경안내] &lt;br&gt; &lt;br&gt;  계출번호:"+pur.getRpt_no()+",  &lt;br&gt; &lt;br&gt; 상호:"+request.getParameter("firm_nm")+",  &lt;br&gt; &lt;br&gt; 차명:"+request.getParameter("car_nm")+",  &lt;br&gt; &lt;br&gt; 변경등록예정일:"+n_reg_est_dt+"  &lt;br&gt; &lt;br&gt; -아마존카-";

		int i_msglen = AddUtil.lengthb(sms_content);

		String msg_type = "0";

		//80이상이면 장문자
		if(i_msglen>80) msg_type = "5";

		String send_phone = sender_bean.getUser_m_tel();
		
		if(!sender_bean.getHot_tel().equals("")){
			send_phone = sender_bean.getHot_tel();
		}

		//at_db.sendMessage(1009, "0",  sms_content, target_bean2.getUser_m_tel(), send_phone, null, rent_l_cd,  user_id);
		
		//List<String> fieldList = Arrays.asList(pur.getRpt_no(), request.getParameter("firm_nm"), request.getParameter("car_nm"), n_reg_est_dt);
		//at_db.sendMessageReserve("acar0247", fieldList, target_bean2.getUser_m_tel(), send_phone, null, rent_l_cd, user_id);
		
		String xml_data2 = "";
		xml_data2 =  "<COOLMSG>"+
	  						" <ALERTMSG>"+
 							"    <BACKIMG>4</BACKIMG>"+
 							"    <MSGTYPE>104</MSGTYPE>"+
 							"    <SUB>등록예정일 변경안내</SUB>"+
	  						"    <CONT>"+sms_content+"</CONT>"+
							"    <URL></URL>";
		xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
 							"    <MSGICON>10</MSGICON>"+
 							"    <MSGSAVE>1</MSGSAVE>"+
 							"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  						"    <FLDTYPE>1</FLDTYPE>"+
 							"  </ALERTMSG>"+
 							"</COOLMSG>";
		
		CdAlertBean msg2 = new CdAlertBean();
		msg2.setFlddata(xml_data2);
		msg2.setFldtype("1");
		
		flag5 = cm_db.insertCoolMsg(msg2);
		
	}			
	
	//1. 신차대여정보 fee-----------------------------------------------------------------------------------------
	
	String pp_st		= request.getParameter("pp_st")==null?"":request.getParameter("pp_st");
	String rent_est_dt 	= request.getParameter("rent_est_dt")==null?"":request.getParameter("rent_est_dt");
	String rent_est_h 	= request.getParameter("rent_est_h")==null?"":request.getParameter("rent_est_h");
	
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	fee.setRent_est_dt			(rent_est_dt+rent_est_h);
	if(pp_st.equals("미결")){
		fee.setPp_est_dt		(request.getParameter("pp_est_dt")==null?"":request.getParameter("pp_est_dt"));
		fee.setPp_etc			(request.getParameter("pp_etc")==null?"":request.getParameter("pp_etc"));
	}
	fee.setGrt_suc_yn			(request.getParameter("grt_suc_yn")==null?"":request.getParameter("grt_suc_yn"));
	//=====[fee] update=====
	flag1 = a_db.updateContFeeNew(fee);
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	int o_bc_b_t = fee_etc.getBc_b_t();
	fee_etc.setBc_b_t		(request.getParameter("bc_b_t")		==null? 0:AddUtil.parseDigit(request.getParameter("bc_b_t")));
	int n_bc_b_t = fee_etc.getBc_b_t();
	//=====[fee_etc] update=====
	flag1 = a_db.updateFeeEtc(fee_etc);
	
	if(o_bc_b_t < n_bc_b_t || o_bc_b_t > n_bc_b_t){
		//금액변동이 있었음->계약변경관리에게 메시지 전달
					
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub2 		= "장기계약 옵션사양 변동";
			String cont2 		= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] 장기계약의 옵션사양이 변동하였습니다. 확인바랍니다.";
			String target_id2 	= nm_db.getWorkAuthUser("계약변경관리");
						
			CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id2);
			if(!cs_bean7.getUser_id().equals(""))	target_id2 = nm_db.getWorkAuthUser("엑셀견적관리자");
			
			//사용자 정보 조회
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub2+"</SUB>"+
		  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			flag5 = cm_db.insertCoolMsg(msg2);
					
	}	
		
	
	//9. 계약기타정보 cont_etc-----------------------------------------------------------------------------------------------
		
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		//관리지점,영업대리인
		cont_etc.setGrt_suc_m_id	(request.getParameter("grt_suc_m_id")	==null?"":request.getParameter("grt_suc_m_id"));
		cont_etc.setGrt_suc_l_cd	(request.getParameter("grt_suc_l_cd")	==null?"":request.getParameter("grt_suc_l_cd"));
		cont_etc.setGrt_suc_c_no	(request.getParameter("grt_suc_c_no")	==null?"":request.getParameter("grt_suc_c_no"));
		cont_etc.setGrt_suc_o_amt	(request.getParameter("grt_suc_o_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_o_amt")));
		cont_etc.setGrt_suc_r_amt	(request.getParameter("grt_suc_r_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_r_amt")));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag9 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag9 = a_db.updateContEtc(cont_etc);
		}
	
	
	//8. 납품요청관리 tint------------------------------------------------------------------------------------------
	
	String tint_yn 	= request.getParameter("tint_yn")==null?"N":request.getParameter("tint_yn");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	
	TintBean tint 	= t_db.getTint(rent_mng_id, rent_l_cd, "1");

if(!tint.getTint_no().equals("")){
	
	if(tint_yn.equals("Y")){
	
		String o_sup_est_dt = tint.getSup_est_dt();
		
		if(o_sup_est_dt.length()==10){
			o_sup_est_dt = o_sup_est_dt.substring(0,8);
		}	
		
		String sup_off_id 	= request.getParameter("sup_off_id")==null?"":request.getParameter("sup_off_id");
		String sup_est_dt 	= request.getParameter("sup_est_dt")==null?"":request.getParameter("sup_est_dt");
		String sup_est_h 	= request.getParameter("sup_est_h")	==null?"":request.getParameter("sup_est_h");
		
		if(tint.getTint_st().equals(""))		tint.setTint_st("1");
		if(tint.getTint_cau().equals(""))		tint.setTint_cau("1");
		
		tint.setRent_mng_id		(rent_mng_id);
		tint.setRent_l_cd		(rent_l_cd);
		tint.setClient_id		(request.getParameter("client_id")	==null?"":request.getParameter("client_id"));
		tint.setCar_nm			(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));
		tint.setCar_num			(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));
		tint.setFilm_st			(request.getParameter("film_st")	==null?"":request.getParameter("film_st"));
		tint.setSun_per			(request.getParameter("sun_per")	==null? 0:AddUtil.parseDigit(request.getParameter("sun_per")));
		tint.setCleaner_st		(request.getParameter("cleaner_st")	==null?"":request.getParameter("cleaner_st"));
		tint.setCleaner_add		(request.getParameter("cleaner_add")	==null?"":request.getParameter("cleaner_add"));
		tint.setNavi_nm			(request.getParameter("navi_nm")	==null?"":request.getParameter("navi_nm"));
		tint.setNavi_est_amt		(request.getParameter("navi_est_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("navi_est_amt")));
		tint.setOther			(request.getParameter("sup_other")	==null?"":request.getParameter("sup_other"));
		tint.setEtc			(request.getParameter("sup_etc")	==null?"":request.getParameter("sup_etc"));
		tint.setBlackbox_yn		(request.getParameter("blackbox_yn")	==null?"":request.getParameter("blackbox_yn"));
		tint.setSup_est_dt		(sup_est_dt+sup_est_h);
		
		if(car_comp_id.equals("0001") || car_comp_id.equals("0002")){
			tint.setCleaner_st	("2");
		}
		
		if(sup_off_id.length()>6){
			tint.setOff_id			(sup_off_id.substring(0,6));
			tint.setOff_nm			(sup_off_id.substring(6));
		}else if(sup_off_id.length()==0){
			tint.setOff_id			("");
			tint.setOff_nm			("");
		}
		
		if(tint.getTint_no().equals("")){
			tint.setReg_id			(user_id);
			tint.setReg_dt			(AddUtil.getDate());
			//=====[consignment] insert=====
			String tint_no = t_db.insertTint(tint);
		}else{
			//=====[consignment] update=====
			flag2 = t_db.updateTint(tint);
		}
		
		if(tint.getBlackbox_yn().equals("3") || tint.getBlackbox_yn().equals("4")){
		
			TintBean  tint2 	= t_db.getTint(rent_mng_id, rent_l_cd, "2");
			
			tint2.setReg_id			(base.getBus_id());
			tint2.setReg_dt			(AddUtil.getDate());
			tint2.setSup_est_dt		(sup_est_dt+sup_est_h);
			tint2.setBlackbox_yn		(request.getParameter("blackbox_yn")	==null?"":request.getParameter("blackbox_yn"));			
			tint2.setOff_id			("002849");
			tint2.setOff_nm			("다옴방");				

			if(tint2.getRent_l_cd().equals("")){
			
				tint2.setTint_cau		("2"); //기안시에만..
				tint2.setRent_mng_id		(rent_mng_id);
				tint2.setRent_l_cd		(rent_l_cd);				
				
				//=====[tint] insert=====
				String tint_no = t_db.insertTint(tint2);
			}else{			
				//=====[tint] update=====
				flag2 = t_db.updateTint(tint2);			
			}
			
		}
		
		String n_sup_est_dt = sup_est_dt;
		
		//작업요청일시 변경시 안내문자 발송
		if(tint.getOff_id().equals("002849") && !AddUtil.replace(n_sup_est_dt,"-","").equals(AddUtil.replace(o_sup_est_dt,"-",""))){
					
	
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
					
		
		
			at_db.sendMessage(1009, "0",  sms_content, target_bean2.getUser_m_tel(), send_phone, null, rent_l_cd,  user_id);		
			
		}			
		
	}else{
		if(!tint.getTint_no().equals("")){
			//삭제
			flag2 = t_db.deleteTint(tint.getTint_no());
		}
	}
}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('선수금 미결사유 등록 에러입니다.\n\n확인하십시오');		<%		}	%>		
<%		if(!flag2){	%>	alert('납품 등록 에러입니다.\n\n확인하십시오');					<%		}	%>		
<%		if(!flag3){	%>	alert('연대보증 미결사유 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
<%		if(!flag5){	%>	alert('차량정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">   
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>        
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='mode'	 			value='<%=mode%>'>     
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'pur_doc_u.jsp';
	fm.target = 'd_content';	
	
	if(fm.from_page.value == '/agent/car_pur/pur_pay_frame.jsp'){
		fm.action = '<%=from_page%>';
		fm.target = 'd_content';
		parent.window.close();
	}
	
	fm.submit();
</script>
</body>
</html>