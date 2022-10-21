<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.user_mng.*, acar.car_office.*, acar.coolmsg.*, acar.car_sche.*, acar.car_mst.*, acar.estimate_mng.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();


	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag4 = true;
	int count = 0;
	
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
	
	//차종변수
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");		
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("전기차담당"));
	
	
	
	//특판계약번호 중복체크
	count = cod.checkComConNo(com_con_no);
	
	
	if(count == 0){
	
		//제조사 배정관리-----------------------------------------------------------------------------------------
	
		CarPurDocListBean cpd_bean = new CarPurDocListBean();
	
			
		cpd_bean.setRent_mng_id	(rent_mng_id);
		cpd_bean.setRent_l_cd		(rent_l_cd);
		cpd_bean.setCom_con_no	(request.getParameter("com_con_no")	==null?"":request.getParameter("com_con_no"));	
		cpd_bean.setCar_nm			(request.getParameter("car_nm")		==null?"":request.getParameter("car_nm"));	
		cpd_bean.setOpt					(request.getParameter("opt")		==null?"":request.getParameter("opt"));	
		cpd_bean.setColo				(request.getParameter("colo")		==null?"":request.getParameter("colo"));	
		cpd_bean.setPurc_gu			(request.getParameter("purc_gu")	==null?"":request.getParameter("purc_gu"));	
		cpd_bean.setAuto				(request.getParameter("auto")		==null?"":request.getParameter("auto"));		
		cpd_bean.setCar_c_amt		(request.getParameter("car_c_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_c_amt")));	
		cpd_bean.setCar_f_amt		(request.getParameter("car_f_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_f_amt")));
		cpd_bean.setDc_amt			(request.getParameter("dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("dc_amt")));
		cpd_bean.setAdd_dc_amt	(request.getParameter("add_dc_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("add_dc_amt")));
		cpd_bean.setCar_d_amt		(request.getParameter("car_d_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_d_amt")));
		cpd_bean.setCar_g_amt		(request.getParameter("car_g_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("car_g_amt")));
		cpd_bean.setCons_amt		(request.getParameter("cons_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("cons_amt")));
		cpd_bean.setDlv_st			(request.getParameter("dlv_st")		==null?"":request.getParameter("dlv_st"));
		
		cpd_bean.setDlv_est_dt	(request.getParameter("dlv_est_dt")	==null?"":request.getParameter("dlv_est_dt"));	
		cpd_bean.setDlv_ext			(request.getParameter("dlv_ext")	==null?"":request.getParameter("dlv_ext"));	
		cpd_bean.setDlv_mng_id	(request.getParameter("dlv_mng_id")	==null?"":request.getParameter("dlv_mng_id"));	
		cpd_bean.setUdt_st			(request.getParameter("udt_st")		==null?"":request.getParameter("udt_st"));	
		cpd_bean.setUdt_firm		(request.getParameter("udt_firm")	==null?"":request.getParameter("udt_firm"));	
		cpd_bean.setUdt_addr		(request.getParameter("udt_addr")	==null?"":request.getParameter("udt_addr"));		
		cpd_bean.setUdt_mng_id	(request.getParameter("udt_mng_id")	==null?"":request.getParameter("udt_mng_id"));	
		cpd_bean.setUdt_mng_nm	(request.getParameter("udt_mng_nm")	==null?"":request.getParameter("udt_mng_nm"));	
		cpd_bean.setUdt_mng_tel	(request.getParameter("udt_mng_tel")	==null?"":request.getParameter("udt_mng_tel"));	
		cpd_bean.setReg_id			(user_id);
		cpd_bean.setUse_yn			("Y");
		cpd_bean.setCar_comp_id	(request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id"));	
		cpd_bean.setStock_yn		(request.getParameter("stock_yn")	==null?"":request.getParameter("stock_yn"));	
		cpd_bean.setBigo				(request.getParameter("bigo")		==null?"":request.getParameter("bigo"));	
		cpd_bean.setStock_st		(request.getParameter("stock_st")	==null?"":request.getParameter("stock_st"));	
		cpd_bean.setCar_off_id	(request.getParameter("car_off_id")	==null?"":request.getParameter("car_off_id"));	
		cpd_bean.setOrder_car		(request.getParameter("order_car")	==null?"N":request.getParameter("order_car"));	
		
		if(cpd_bean.getDlv_st().equals("2")){
			cpd_bean.setDlv_con_dt		(cpd_bean.getDlv_est_dt());	
			if(cpd_bean.getDlv_con_dt().equals("")){
				cpd_bean.setDlv_con_dt	(AddUtil.getDate());
			}
		}
		
		
		
	
			
		flag1 = cod.insertCarPurCom(cpd_bean);
		
		
		
		if(cpd_bean.getCar_comp_id().equals("0001") && client.getClient_st().equals("1") && pur.getPur_com_firm().equals("")){
			pur.setPur_com_firm(client.getFirm_nm());	
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
	
				

			
		//쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
		String sub 	= "계출관리 계약번호등록";
		String cont 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] 계출관리 계약번호("+cpd_bean.getCom_con_no()+")가 등록되었습니다.";
		String url 	= "/fms2/pur_com/lc_rent_c.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|com_con_no="+cpd_bean.getCom_con_no();
		String m_url = "/fms2/pur_com/lc_rent_frame.jsp'";
		if(cpd_bean.getDlv_st().equals("2")){
			sub 	= "계출관리 계약번호등록 & 자동차납품 출고배정";
			cont 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] ("+cpd_bean.getCom_con_no()+") 출고배정 ("+cpd_bean.getDlv_con_dt()+") ";			
		}else{
			if(cpd_bean.getDlv_st().equals("1") && !cpd_bean.getDlv_est_dt().equals("")){
				sub 	= "계출관리 계약번호등록 & 자동차납품 출고예정";
				cont 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] ("+cpd_bean.getCom_con_no()+") 출고예정 ("+cpd_bean.getDlv_est_dt()+") ";
			}
		}
	
	
	
		UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
		
						
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
				"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	  				
					
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		//신차 전기차는 전기차관련담당자(함윤원)에게 메시지 발송
		if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("3")){
			xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		}		
		//신차 수소차는 전기차관련담당자(함윤원)에게 메시지 발송
		if(base.getCar_gu().equals("1") && ej_bean.getJg_g_7().equals("4")){
			xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
		}		
		
		xml_data += "    <SENDER></SENDER>"+
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
		
		
		//계약담당자에게 문자발송
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		String sendphone 	= sender_bean.getUser_m_tel();
		String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
		String destphone 	= target_bean.getUser_m_tel();
		String destname 	= target_bean.getUser_nm();
		String msg_cont		= cont;
			
		//에이전트 실의뢰자한테 요청
		if(target_bean.getDept_id().equals("1000") && !base.getAgent_emp_id().equals("")){
			CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
			destname 	= a_coe_bean.getEmp_nm();
			destphone = a_coe_bean.getEmp_m_tel();
		}
			
		
		at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
		
		//주문차확인메시지 발송
		if(cpd_bean.getOrder_car().equals("Y")){
			
			msg_cont 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" ] ("+cpd_bean.getCom_con_no()+") 주문차입니다. 다시 한 번 확인요청 바랍니다. 확정시 협력업체관리-자체출고관리-예정현황 세부페이지에서 [고객확인처리]를 클릭하십시오.";
			
			
			at_db.sendMessage(1009, "0", msg_cont, destphone, "02-392-4243", null,  base.getRent_l_cd(), ck_acar_id );
		}
		
	}

	%>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
</form>
<script language='javascript'>
<%	if(count == 0){%>

		<%if(!flag1){%>
			alert('계출관리 계약번호등록 에러입니다.\n\n확인하십시오');		
		<%}else{%>
			var fm = document.form1;	
			fm.action = 'lc_rent_frame.jsp';
			fm.target = 'd_content';
			fm.submit();
		<%}%>

<%	}else{%>
			alert('이미 등록된 특판계약번호입니다.\n\n확인하십시오.');
<%	}%>

</script>
</body>
</html>