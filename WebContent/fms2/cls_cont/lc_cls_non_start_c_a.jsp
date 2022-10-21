<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.cls.*, acar.car_office.*, acar.ext.*,acar.fee.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
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
	String cls_st	 	= request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String old_rent_mng_id 	= request.getParameter("old_rent_mng_id")==null?"":request.getParameter("old_rent_mng_id");
	String old_rent_l_cd 	= request.getParameter("old_rent_l_cd")==null?"":request.getParameter("old_rent_l_cd");
	
	int    fee_size	 	= request.getParameter("fee_size")==null?0:AddUtil.parseInt(request.getParameter("fee_size"));
	int    fee_scd_size	= request.getParameter("fee_scd_size")==null?0:AddUtil.parseInt(request.getParameter("fee_scd_size"));
	String fee_tm	 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String con_cd3 		= request.getParameter("con_cd3")==null?"":request.getParameter("con_cd3");
	String con_cd4 		= request.getParameter("con_cd4")==null?"":request.getParameter("con_cd4");
	
	int    t_fee_amt 	= request.getParameter("t_fee_amt")		==null?0:AddUtil.parseDigit(request.getParameter("t_fee_amt"));
	int    t_fee_s_amt 	= request.getParameter("t_fee_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("t_fee_s_amt"));
	int    t_fee_v_amt 	= request.getParameter("t_fee_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("t_fee_v_amt"));
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int flag4 = 0;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag10 = true;
	boolean flag11 = true;
	boolean flag12 = true;
	int count = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();


	//원계약 해지처리-----------------------------------------------------------------------------------------------
	
	//cls_cont
	ClsBean cls = new ClsBean();
	
	cls.setRent_mng_id	(rent_mng_id);
	cls.setRent_l_cd	(rent_l_cd);
	cls.setTerm_yn		("Y");
	cls.setCls_st		(cls_st);
	cls.setCls_dt		(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
	cls.setCls_cau		(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));
	cls.setReg_id		(user_id);
	
	flag1 = as_db.insertCls2(cls);
	
	
	//출고전해지
	if(cls_st.equals("7")){
		flag2 = as_db.closeContNoRecon(rent_mng_id, rent_l_cd);
		
		//자체출고관리 정리 20220426
	 	String  d_flag3 = ec_db.call_sp_com_pre_cls_cont(rent_mng_id, rent_l_cd);
	}
	//개시전해지
	else if(cls_st.equals("10"))	flag2 = as_db.closeContRecon(rent_mng_id, rent_l_cd, "", "", "", cls.getCls_dt(), cls_st);
	
	if(!car_mng_id.equals("")){
		//등록차량 상태값 초기화
		flag9 = a_db.updateCarStatCng(car_mng_id);
	}
	
	
	//출고지연대차가 있으나 스케줄 미생성일때 처리
	ContTaechaBean taecha = a_db.getContTaechaCase(rent_mng_id, rent_l_cd);
	
	//기존대여스케줄 대여횟수 최대값
	int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);
	
	if(!taecha.getCar_mng_id().equals("")){
		if(AddUtil.parseInt(AddUtil.replace(taecha.getCar_rent_st(),"-","")) < AddUtil.parseInt(AddUtil.replace(cls.getCls_dt(),"-","")) && max_fee_tm == 0 ){
			FeeScdBean fee_scd = new FeeScdBean();
			fee_scd.setRent_mng_id				(rent_mng_id);
			fee_scd.setRent_l_cd				(rent_l_cd);
			fee_scd.setFee_tm					(String.valueOf(max_fee_tm+1));
			fee_scd.setRent_st					("1");							//출고지연대차
			fee_scd.setTm_st2					("2");							//2-출고지연
			fee_scd.setRent_seq					("1");							//분할청구일련번호
			fee_scd.setTm_st1					("0");							//0-월대여료 (1~잔액)
			fee_scd.setRc_yn					("0");							//0-미수금
			fee_scd.setUpdate_id				(user_id);
			fee_scd.setUse_s_dt					(taecha.getCar_rent_st());							//1회차 사용기간 시작일
			fee_scd.setUse_e_dt					(cls.getCls_dt());									//1회차 사용기간 종료일
			fee_scd.setFee_est_dt				(cls.getCls_dt());									//1회차 납입일
			
			//일수구하기
			int use_days 		= AddUtil.parseInt(rs_db.getDay(AddUtil.replace(taecha.getCar_rent_st(),"-",""), AddUtil.replace(cls.getCls_dt(),"-","")));
			//일할금액계산하기
			int fee_fst_s_amt		= 0;
			int fee_fst_v_amt		= 0;
			fee_fst_s_amt 	= t_fee_amt * use_days / 30;
			fee_fst_v_amt 	= fee_fst_s_amt*10/100;
			
			fee_scd.setFee_s_amt				(fee_fst_s_amt);								//1회차 대여료
			fee_scd.setFee_v_amt				(fee_fst_v_amt);								//1회차 대여료
			fee_scd.setR_fee_est_dt				(af_db.getValidDt(fee_scd.getFee_est_dt()));
			fee_scd.setReq_dt					(fee_scd.getFee_est_dt());
			fee_scd.setR_req_dt					(fee_scd.getReq_dt());
			fee_scd.setTax_out_dt				(fee_scd.getFee_est_dt());
			
			if(!af_db.insertFeeScd(fee_scd)) flag4 += 1;
			
			
			String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "개시전해지등록";
			String cont 	= "[ "+rent_l_cd+" "+firm_nm+" ] 확인바랍니다.";
			String target_id = nm_db.getWorkAuthUser("스케줄생성자");
			
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			//총무팀 스케줄담당자에게 알림
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data2 += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			System.out.println("쿨메신저("+rent_l_cd+" "+request.getParameter("firm_nm")+" [개시전해지] 출고지연대차스케줄생성)-----------------------"+target_bean.getUser_nm());
			
			flag12 = cm_db.insertCoolMsg(msg2);	
		}
	}
	
	
	//대여스케줄중 연체리스트
	Vector v_fee_scd = af_db.getFeeScdPrint(rent_l_cd, "");
	fee_scd_size = v_fee_scd.size();
	
	int fee_chk = 0;
	for(int i = 0 ; i < fee_scd_size ; i++){
  		FeeScdBean a_fee = (FeeScdBean)v_fee_scd.elementAt(i);
		if(a_fee.getRc_yn().equals("0")){
			fee_chk++;
		}
	}
	//fee_scd_size
	if(fee_chk>0 && fee_scd_size>0){
		String dly_chk[] 		= request.getParameterValues("dly_chk");
		String ht_rent_st[] 	= request.getParameterValues("ht_rent_st");
		String ht_rent_seq[] 	= request.getParameterValues("ht_rent_seq");
		String ht_fee_tm[] 		= request.getParameterValues("ht_fee_tm");
		String ht_tm_st1[] 		= request.getParameterValues("ht_tm_st1");
		String ht_tm_st2[] 		= request.getParameterValues("ht_tm_st2");
		
		for(int i=0;i < dly_chk.length;i++){
			
			String bill_yn = dly_chk[i] ==null?"Y":dly_chk[i];
			
			if(bill_yn.equals("N")){
				if(!ae_db.getCreditScd("scd_fee", rent_mng_id, rent_l_cd, ht_rent_st[i], ht_fee_tm[i], ht_tm_st1[i])) 	count = 1;
			}
		}
	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%		if(!flag1){	%>
		alert('계약 해지정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag2){	%>
		alert('해지처리 에러입니다.\n\n확인하십시오');
<%		}	%>		


	fm.action = 'lc_cls_non_start_frame.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>