<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*,  acar.ext.*, acar.user_mng.*, acar.client.*, acar.car_register.*, acar.car_mst.*,acar.memo.*"%>
<%@ page import="acar.coolmsg.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String with_reg  	= request.getParameter("with_reg")==null?"N":request.getParameter("with_reg");
	
	String old_value  	= request.getParameter("old_value")==null?"":request.getParameter("old_value");
	String new_value  	= request.getParameter("new_value")==null?"":request.getParameter("new_value");
	String cng_cau  	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	String rent_st  	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String c_st  		= request.getParameter("c_st")==null?"1":request.getParameter("c_st");
	int    s_amt		= request.getParameter("s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("s_amt"));
	int    v_amt		= request.getParameter("v_amt")==null? 0:AddUtil.parseDigit(request.getParameter("v_amt"));
	int    cng_size		= request.getParameter("cng_size")==null? 0:AddUtil.parseDigit(request.getParameter("cng_size"));
	String cmd	  	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	boolean flag = true;
	boolean flag2 = true;
	boolean flag3 = true;
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	LcRentCngHBean bean = new LcRentCngHBean();
	
	bean.setRent_mng_id	(rent_mng_id);
	bean.setRent_l_cd	(rent_l_cd);
	bean.setCng_item	(cng_item);
	bean.setOld_value	(old_value);
	bean.setNew_value	(new_value);
	bean.setCng_cau		(cng_cau);
	bean.setCng_id		(ck_acar_id);
	bean.setRent_st		(rent_st);
	bean.setS_amt		(s_amt);
	bean.setV_amt		(v_amt);
	
	if(bean.getCng_item().equals("mng_br_id")||bean.getCng_item().equals("est_area")){
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}
	}
	
	
	
	flag = a_db.updateLcRentCngH(bean);


	//관리구분 변경	
	if(bean.getCng_item().equals("rent_way")){
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		if(new_value.equals("1")){
			cont_etc.setMain_yn		("Y");
			cont_etc.setMa_dae_yn	("Y");
		}else{
			cont_etc.setMain_yn		("");
			cont_etc.setMa_dae_yn	("");
		}	
		flag2 = a_db.updateContEtc(cont_etc);
	}
	
	//차량이용지역 구군 변경	
	if(bean.getCng_item().equals("est_area")){
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
			
		bean.setCng_item	("county");
		bean.setOld_value	(cont_etc.getCounty());
		bean.setNew_value	(request.getParameter("county")==null?"":request.getParameter("county"));
		
		flag = a_db.updateLcRentCngH(bean);
	}
	
	
	
	//영업담당자 변경시 관리담당자에 동일인으로 등록
	if(cng_item.equals("bus_id2") && with_reg.equals("Y")){
	
		bean.setCng_item	("mng_id");
		bean.setOld_value	(old_value);
		bean.setNew_value	(new_value);
		bean.setCng_cau		(cng_cau);
		bean.setCng_id		(ck_acar_id);
		
		flag = a_db.updateLcRentCngH(bean);
	}
	
	//영업담당자 변경시 관리담당자에 동일인으로 체크안되어 있고 관리담당자가 없으면 동일처리 
	if(cng_item.equals("bus_id2") && with_reg.equals("N")){
	
		//계약기본정보
		ContBaseBean cont_base = a_db.getCont(rent_mng_id, rent_l_cd);
		
		if(cont_base.getMng_id().equals("")){
			bean.setCng_item	("mng_id");
			bean.setOld_value	(old_value);
			bean.setNew_value	(new_value);
			bean.setCng_cau		(cng_cau);
			bean.setCng_id		(ck_acar_id);
			
			flag = a_db.updateLcRentCngH(bean);
		}
	}
	
	
	if(flag){
		
		String cool_msg_yn = "N";
		int old_amt = 0;
		int new_amt = s_amt+v_amt;
		
		if(cng_item.equals("grt_amt")){
			//보증금 table에 update 해준다
			ExtScdBean grt = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, rent_st, "0", "1");
			old_amt = grt.getExt_s_amt()+grt.getExt_v_amt();
			grt.setExt_s_amt			(s_amt);
			grt.setExt_v_amt			(0);
			//=====[scd_pre] update=====
			flag2 = ae_db.updateGrt(grt);
			
			if(cmd.equals("입금선수금 수정")){
				cool_msg_yn = "Y";
			}

		}else if(cng_item.equals("pp_amt")){
			//선납금 table에 update 해준다.
			ExtScdBean pp = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, rent_st, "1", "1");
			old_amt = pp.getExt_s_amt()+pp.getExt_v_amt();
			pp.setExt_s_amt			(s_amt);
			pp.setExt_v_amt			(v_amt);
			//=====[scd_pre] update=====
			flag2 = ae_db.updateGrt(pp);
			
			if(cmd.equals("입금선수금 수정") || cmd.equals("매월균등발행 입금선수금 수정")){
				cool_msg_yn = "Y";
			}
			
		}else if(cng_item.equals("ifee_amt")){
			//개시대여료 table에 update 해준다
			ExtScdBean ifee = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, rent_st, "2", "1");
			old_amt = ifee.getExt_s_amt()+ifee.getExt_v_amt();
			ifee.setExt_s_amt		(s_amt);
			ifee.setExt_v_amt		(v_amt);
			flag2 = ae_db.updateGrt(ifee);
			
			if(cmd.equals("입금선수금 수정")){
				cool_msg_yn = "Y";
			}
		}
		//입금선수금 수정시 메시지 발송 20210423
		if(cool_msg_yn.equals("Y")){
			//계약기본정보
			ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
			//고객정보
			ClientBean client = al_db.getNewClient(base.getClient_id());
			
			String firm_nm	= client.getFirm_nm();
			String sub 		= "입금 선수금 변동";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" : "+cng_cau+" ]  &lt;br&gt; &lt;br&gt; 장기계약의";
			if(cng_item.equals("grt_amt")){
				cont = cont + " 보증금이 ";
			}else if(cng_item.equals("pp_amt")){
				if(cmd.equals("매월균등발행 입금선수금 수정")){
					cont = cont + " 매월균등발행 선납금이 ";	
				}else{
					cont = cont + " 선납금이 ";
				}
			}else if(cng_item.equals("ifee_amt")){
				cont = cont + " 개시대여료가 ";
			}
			cont = cont + " "+AddUtil.parseDecimal(old_amt)+"원에서 "+AddUtil.parseDecimal(new_amt)+"원으로 변경되었습니다.  &lt;br&gt; &lt;br&gt; 선수금스케줄 및 계산서 확인바랍니다.";
			
			String target_id = nm_db.getWorkAuthUser("스케줄생성자");
			String target_id2 = nm_db.getWorkAuthUser("입금담당");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
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
			
		}
	}
	
	
	//영업담당자 배정시 문자발송->20090824 메모로 전환
	if(cng_item.equals("bus_id2") && !old_value.equals(new_value) && !new_value.equals("000026") && !new_value.equals("000005") && !new_value.equals("000144") && !new_value.equals("000053")){
		
		UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
		UsersBean target_bean 	= umd.getUsersBean(new_value);
		
		
		if(!target_bean.getUser_m_tel().equals("")){
			//계약기본정보
			ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
			//고객정보
			ClientBean client = al_db.getNewClient(base.getClient_id());
			//차량등록정보
			CarRegDatabase crd = CarRegDatabase.getInstance();
			if(!base.getCar_mng_id().equals("")){
				cr_bean = crd.getCarRegBean(base.getCar_mng_id());
			}
			//차량기본정보
			ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
			//자동차기본정보
			AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
			CarMstBean cm_bean 	= cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
			//신차대여정보
			ContFeeBean fee 	= a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
			
			
			String sendphone 	= sender_bean.getUser_m_tel();
			String sendname 	= sender_bean.getUser_nm();
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			String cont 		= "[영업담당자배정] "+client.getFirm_nm()+" : "+cr_bean.getCar_no()+" "+c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG");
			if(base.getCar_mng_id().equals("")){
				cont = cont + " "+rent_l_cd;
			}
			if(base.getCar_st().equals("1")) cont += " 렌트";
			if(base.getCar_st().equals("3")) cont += " 리스";
			if(fee.getRent_way().equals("1")) cont += " 일반식";
			if(fee.getRent_way().equals("3")) cont += " 기본식";
			
			
			
			
			//담당자에게 메모로 알리기:20090824
			MemoBean memo_bn = new MemoBean();
			memo_bn.setSend_id	(ck_acar_id);
			memo_bn.setRece_id	(target_bean.getUser_id());
			memo_bn.setTitle	(cont);
			memo_bn.setContent	(cont);
			if(!memo_db.sendMemo(memo_bn)){
			}
			
			//System.out.println(cont);
			
			//계약 담당자 변경 관련 문자 -해지건은 제외
			Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
			
			String s_destphone = "";
			s_destphone = String.valueOf(sms.get("TEL"));
			
			String s_destname = "";
			s_destname = String.valueOf(sms.get("NM"));
			
			String cont_sms 	= cr_bean.getCar_no() + " 차량 담당자는 " + target_bean.getUser_nm() + ", 연락처는 "+ target_bean.getUser_m_tel() + " 입니다. (주)아마존카"; 
			
			int i_msglen = AddUtil.lengthb(cont_sms);
		
			String msg_type = "0";
		
			//80이상이면 장문자
			if(i_msglen>80) msg_type = "5";
		
				
			if(!s_destphone.equals("") && !s_destphone.equals("null") ){
							
				//신차대여개시 처리시 발송하므로, 그외에 담당자가 재배정된 경우에만 보냄 : 20100716
				if(!fee.getRent_start_dt().equals("")){

					IssueDb.insertsendMail_V5_H("02-392-4242", "(주)아마존카", s_destphone, s_destname, "", "", msg_type, "(주)아마존카 담당자", cont_sms, "", "", ck_acar_id, "lc_user");
				
					
				}
			}			
							
		}
	}
	
	if(cng_item.equals("est_area")){ 
			// 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			//계약기본정보
			ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
			//고객정보
			ClientBean client = al_db.getNewClient(base.getClient_id());
			
			String firm_nm	= client.getFirm_nm();
			String sub 		= "차량이용지역 변동";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" : "+cng_cau+" ] 장기계약의 차량이용지역이 변동하였습니다. 확인바랍니다.";
			String target_id = nm_db.getWorkAuthUser("본사관리팀장");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
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
			
			flag3 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저[차량이용지역 변동]--"+rent_l_cd+"---------------------");
	}
	
	if(cng_item.equals("car_st") && !old_value.equals("5") && new_value.equals("5") ){ 
			// 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			//계약기본정보
			ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
			//고객정보
			ClientBean client = al_db.getNewClient(base.getClient_id());
			
			String firm_nm	= client.getFirm_nm();
			String sub 		= "용도구분 변동";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" : "+cng_cau+" ] 장기계약의 용도구분이 변동하였습니다.  &lt;br&gt; &lt;br&gt; 직원업무차량입니다.  &lt;br&gt; &lt;br&gt; 급여공제금액 확인바랍니다.";
			String target_id = nm_db.getWorkAuthUser("스케줄생성자");
			String target_id2 = nm_db.getWorkAuthUser("스케줄변경담당자");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
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
			System.out.println("쿨메신저[용도구분(업무대여) 변동]--"+rent_l_cd+"---------------------");
			
	}	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+ck_acar_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page+"&c_st="+c_st;
%>
<script language='javascript'>
<%	if(!flag){  %>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>
		alert("처리되었습니다");
		
		<%if(cmd.equals("입금선수금 수정") || cmd.equals("매월균등발행 입금선수금 수정")){%>
		parent.opener.location.href = "lc_b_s_12.jsp<%=valus%>";
		<%}else{%>		
		<%	if(from_page.equals("/acar/cus_pre/cus_pre_sc_cng.jsp")){
	 		valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
						"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
						"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
						"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page+"&c_st="+c_st;
		%>
		parent.opener.location.href = "/acar/cus_pre/cus_pre_sc_cng.jsp<%=valus%>";
		<%	}else if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp")){%>
		
		<%	}else if(from_page.equals("/fms2/lc_rent/lc_b_frame.jsp")){%>
		parent.opener.parent.location.href = "lc_b_frame.jsp<%=valus%>";
		<%	}else if(from_page.equals("/fms2/lc_rent/lc_rm_frame.jsp")){%>
		parent.opener.parent.location.href = "lc_rm_frame.jsp<%=valus%>";
		<%	}else if(from_page.equals("/fms2/lc_rent/lc_b_s_cont.jsp")){%>
		parent.opener.parent.location.href = "lc_b_s_cont.jsp<%=valus%>";
		<%	}else{%>		
		parent.opener.parent.location.href = "lc_c_frame.jsp<%=valus%>";
		<%	}%>
		<%}%>
		parent.window.close();
		
<%	}			%>
</script>