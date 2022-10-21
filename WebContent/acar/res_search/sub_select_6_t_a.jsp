<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.cont.* "%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" 	scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="cm_db" 	scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String cust_id 	= request.getParameter("cust_id")==null?"":request.getParameter("cust_id");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//대여정보-------------------------------------------------------------------------------------------
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	fee.setPrv_dlv_yn		(request.getParameter("prv_dlv_yn")		==null?"":request.getParameter("prv_dlv_yn"));
	fee.setPrv_mon_yn		(request.getParameter("prv_mon_yn")		==null?"":request.getParameter("prv_mon_yn"));
	//=====[fee] update=====
	flag1 = a_db.updateContFeeNew(fee);
	
	
	//출고지연대차-------------------------------------------------------------------------------------------
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	String tae_car_mng_id = request.getParameter("tae_car_mng_id")	==null?"":request.getParameter("tae_car_mng_id");
	
	
	System.out.println("##지연대차 반차처리시 계약-출고지연대차 등록!! ");
	System.out.println("tae_car_mng_id="+tae_car_mng_id);
	
	
//	if(!tae_car_mng_id.equals("") && fee.getPrv_dlv_yn().equals("Y")){
		taecha.setCar_mng_id	(tae_car_mng_id);
		taecha.setCar_no		(request.getParameter("tae_car_no")		==null?"":request.getParameter("tae_car_no"));
		taecha.setCar_nm		(request.getParameter("tae_car_nm")		==null?"":request.getParameter("tae_car_nm"));
		taecha.setCar_id		(request.getParameter("tae_car_id")		==null?"":request.getParameter("tae_car_id"));
		taecha.setCar_seq		(request.getParameter("tae_car_seq")	==null?"":request.getParameter("tae_car_seq"));
		taecha.setCar_rent_st	(request.getParameter("tae_car_rent_st")==null?"":request.getParameter("tae_car_rent_st"));
		taecha.setCar_rent_et	(request.getParameter("tae_car_rent_et")==null?"":request.getParameter("tae_car_rent_et"));
		taecha.setRent_fee		(request.getParameter("tae_rent_fee")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee")));
		taecha.setReq_st		(request.getParameter("tae_req_st")		==null?"":request.getParameter("tae_req_st"));
		taecha.setTae_st		(request.getParameter("tae_tae_st")		==null?"":request.getParameter("tae_tae_st"));
		taecha.setTae_sac_id	(request.getParameter("tae_sac_id")		==null?"":request.getParameter("tae_sac_id"));
		taecha.setRent_s_cd		(request.getParameter("tae_s_cd")		==null?"":request.getParameter("tae_s_cd"));
		taecha.setRent_fee_st	(request.getParameter("tae_rent_fee_st")	==null?"":request.getParameter("tae_rent_fee_st"));
		taecha.setRent_fee_cls	(request.getParameter("tae_rent_fee_cls")	==null?"0":AddUtil.parseDigit3(request.getParameter("tae_rent_fee_cls")));
		

		
		if(taecha.getRent_mng_id().equals("")){
			taecha.setRent_mng_id	(rent_mng_id);
			taecha.setRent_l_cd		(rent_l_cd);
			//=====[gua_ins] insert=====
			flag2 = a_db.insertTaechaNew(taecha);
		}else{
			//=====[gua_ins] update=====
			flag2 = a_db.updateTaechaNew(taecha);
		}
		
		int tae_rent_fee_s = request.getParameter("tae_rent_fee_s")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_fee_s"));
		int tae_rent_fee_v = request.getParameter("tae_rent_fee_v")	==null?0:AddUtil.parseDigit(request.getParameter("tae_rent_fee_v"));
		
		ContFeeBean fee_add = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
		if( tae_rent_fee_s>0){
			if(AddUtil.parseDigit(taecha.getRent_fee()) > fee_add.getFee_s_amt()+fee_add.getFee_v_amt() || AddUtil.parseDigit(taecha.getRent_fee()) < fee_add.getFee_s_amt()+fee_add.getFee_v_amt() ){
				boolean flag30 = a_db.updateContFeeAddFeeAmt(rent_mng_id, rent_l_cd, "t", tae_rent_fee_s, tae_rent_fee_v);
			}
		}
		
		//if(!tae_car_mng_id.equals("") && !taecha.getRent_s_cd().equals("")){
			RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
			
//			if(!rc_bean.getSub_l_cd().equals("")){
				rc_bean.setSub_l_cd		(rent_l_cd);
				int rs_count = 1;
				rs_count = rs_db.updateRentCont(rc_bean);
//			}
			
		//}
//	}

				//20210101 이후 출고전대차 월대여료가 있고, 신차해지요금정삼이 견적서에 표기되어 있지 않음인 경우 권용식과장한테 메시지 발송
				if(taecha.getRent_fee_cls().equals("0") && AddUtil.parseInt(taecha.getRent_fee()) >0  && AddUtil.parseInt(AddUtil.replace(taecha.getCar_rent_st(),"-","")) >= 20210101){
					
					//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
					
					String sub 		= "출고전대차 신차해지시요금정산"; 
					String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 장기계약 출고전대차 신차해지시요금정산이 견적서에 표기되어 있지않음으로 선택되어 있습니다. 확인바랍니다.";					
					String target_id = nm_db.getWorkAuthUser("엑셀견적관리자");
					
					//사용자 정보 조회
					UsersBean target_bean 	= umd.getUsersBean(target_id);
					UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
					
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
					
					//boolean flag3 = cm_db.insertCoolMsg(msg);											
				}
%>

<script language='javascript'>

	alert('등록되었습니다.');
	opener.location.reload();
	self.window.close();
	
</script>
</body>
</html>