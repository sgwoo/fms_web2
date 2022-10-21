<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.car_office.*, acar.client.*, acar.car_mst.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
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
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String trf_st 	= request.getParameter("trf_st")==null?"":request.getParameter("trf_st");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	String vid[] 	= request.getParameterValues("ch_cd");
	String vid_num 	= "";
	String rent_mng_id 	= "";
	String rent_l_cd = "";
	String gubun = "";
	
	int vid_size = vid.length;
	
	for(int i=0;i < vid_size;i++){
		
		vid_num = vid[i];
		
		rent_mng_id = vid_num.substring(0,6);
		rent_l_cd 	= vid_num.substring(6,19);
		gubun 		= vid_num.substring(19);
		
		out.println("<br>");
		out.println(rent_mng_id+"<br>");
		out.println(rent_l_cd+"<br>");
		out.println(gubun+"<br>");
		
		
		
		//1. 출고정보 수정--------------------------------------------------------------------------------------------
		
		//car_pur
		ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
		
		String pur_pay_dt  = request.getParameter("pur_pay_dt")	==null?"":request.getParameter("pur_pay_dt");
		if(gubun.equals("1"))	pur.setTrf_pay_dt1	(pur_pay_dt);
		if(gubun.equals("2"))	pur.setTrf_pay_dt2	(pur_pay_dt);
		if(gubun.equals("3"))	pur.setTrf_pay_dt3	(pur_pay_dt);
		if(gubun.equals("4"))	pur.setTrf_pay_dt4	(pur_pay_dt);
		
		int cnt1 = 0;
		int cnt2 = 0;
		
		cnt1 = pur.getJan_amt();
		
//		if(pur.getTrf_amt1() >0) 	cnt1++;
//		if(pur.getTrf_amt2() >0) 	cnt1++;
//		if(pur.getTrf_amt3() >0) 	cnt1++;
//		if(pur.getTrf_amt4() >0) 	cnt1++;
		if(!pur.getTrf_pay_dt1().equals("") && pur.getTrf_amt1() >0) 	cnt2 = cnt2 + pur.getTrf_amt1();
		if(!pur.getTrf_pay_dt2().equals("") && pur.getTrf_amt2() >0) 	cnt2 = cnt2 + pur.getTrf_amt2();
		if(!pur.getTrf_pay_dt3().equals("") && pur.getTrf_amt3() >0) 	cnt2 = cnt2 + pur.getTrf_amt3();
		if(!pur.getTrf_pay_dt4().equals("") && pur.getTrf_amt4() >0) 	cnt2 = cnt2 + pur.getTrf_amt4();
		
		if(cnt1==cnt2) 			pur.setPur_pay_dt	(pur_pay_dt);
		
		//=====[CAR_PUR] update=====
		flag1 = a_db.updateContPur(pur);
		
		
		if(cnt1==cnt2){
			//commi
			CommiBean emp2 		= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
			//영업사원
			coe_bean 			= cod.getCarOffEmpBean(emp2.getEmp_id());
			//계약기본정보
			ContBaseBean base 	= a_db.getCont(rent_mng_id, rent_l_cd);
			//고객정보
			ClientBean client 	= al_db.getNewClient(base.getClient_id());
			//차량기본정보
			ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
			//자동차기본정보
			CarMstBean cm_bean 	= cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
			
			
			//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
			String url 		= "";
			String sub 		= "차량대금 지급";
			String cont 	= "[차량대금지급]"+client.getFirm_nm()+" "+c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG");
			String target_id = base.getBus_id();
			
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			
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
			
			if(base.getBrch_id().equals("S1") || base.getBrch_id().equals("S2") || base.getBrch_id().equals("I1") || base.getBrch_id().equals("K1") || base.getBrch_id().equals("K2") || base.getBrch_id().equals("K3") || base.getBrch_id().equals("S3") || base.getBrch_id().equals("S4") || base.getBrch_id().equals("S5") || base.getBrch_id().equals("S6")){
				target_id = nm_db.getWorkAuthUser("영업수당회계관리자");
				target_bean = umd.getUsersBean(target_id);
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			}else if(base.getBrch_id().equals("B1") || base.getBrch_id().equals("N1") || base.getBrch_id().equals("G1") || base.getBrch_id().equals("U1")){
				target_id = nm_db.getWorkAuthUser("부산출납");
				target_bean = umd.getUsersBean(target_id);
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			}else if(base.getBrch_id().equals("D1") || base.getBrch_id().equals("J1")){
				target_id = nm_db.getWorkAuthUser("대전출납");
				target_bean = umd.getUsersBean(target_id);
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			}
			
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
			
			//flag2 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저(차량대금지급)"+client.getFirm_nm()+"-----------------------"+target_bean.getUser_nm());
			
			
			//3. SMS 문자 발송------------------------------------------------------------
			
			target_id 		= base.getBus_id();
			target_bean 	= umd.getUsersBean(target_id);
			
			String sendphone 	= sender_bean.getHot_tel();
			String sendname 	= "(주)아마존카";
			String destphone 	= target_bean.getUser_m_tel();
			String destname 	= target_bean.getUser_nm();
			
			/*
			//최초영업자
			IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont);
			
			if(car.getCar_ext().equals("1") || car.getCar_ext().equals("2") || car.getCar_ext().equals("6") || car.getCar_ext().equals("7")){
				target_id = nm_db.getWorkAuthUser("차량등록자");
				CarScheBean cr_cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cr_cs_bean.getUser_id().equals("") && !cr_cs_bean.getWork_id().equals("")) target_id = cr_cs_bean.getWork_id();
				target_bean 	= umd.getUsersBean(target_id);
				destphone 		= target_bean.getUser_m_tel();
				destname 		= target_bean.getUser_nm();
				//차량등록자
				IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont+" "+emp2.getCar_off_nm());
			}else if(car.getCar_ext().equals("3") || car.getCar_ext().equals("4")){
				target_id = nm_db.getWorkAuthUser("부산차량등록자");
				CarScheBean cr_cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cr_cs_bean.getUser_id().equals("") && !cr_cs_bean.getWork_id().equals("")) target_id = cr_cs_bean.getWork_id();
				target_bean 	= umd.getUsersBean(target_id);
				destphone 		= target_bean.getUser_m_tel();
				destname 		= target_bean.getUser_nm();
				//차량등록자
				IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont+" "+emp2.getCar_off_nm());
			}
			
			if(!coe_bean.getEmp_m_tel().equals("")){
				destphone 	= coe_bean.getEmp_m_tel();
				destname 	= coe_bean.getEmp_nm();
				//영업사원
				IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", cont+" -아마존카-");
				
				out.println(cont+"<br>");
			}
			*/
		}else{
			//commi
			CommiBean emp2 		= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
			//영업사원
			coe_bean 			= cod.getCarOffEmpBean(emp2.getEmp_id());
			//계약기본정보
			ContBaseBean base 	= a_db.getCont(rent_mng_id, rent_l_cd);
			//고객정보
			ClientBean client 	= al_db.getNewClient(base.getClient_id());
			//차량기본정보
			ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
			//자동차기본정보
			CarMstBean cm_bean 	= cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
			
			cnt1 = 0;
			cnt2 = 0;
			
			if(!pur.getTrf_st1().equals("1") && pur.getTrf_amt1() >0 && pur.getTrf_pay_dt1().equals("")) 	cnt2 = cnt2 + pur.getTrf_amt1();
			if(!pur.getTrf_st2().equals("1") && pur.getTrf_amt2() >0 && pur.getTrf_pay_dt2().equals("")) 	cnt2 = cnt2 + pur.getTrf_amt2();
			if(!pur.getTrf_st3().equals("1") && pur.getTrf_amt3() >0 && pur.getTrf_pay_dt3().equals("")) 	cnt2 = cnt2 + pur.getTrf_amt3();
			if(!pur.getTrf_st4().equals("1") && pur.getTrf_amt4() >0 && pur.getTrf_pay_dt4().equals("")) 	cnt2 = cnt2 + pur.getTrf_amt4();
			
			if(cnt2 >0){
				//일부납부일때 영선씨한테 메세지
				//3. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
				String url 		= "";
				String sub 		= "차량대금 지급요청-현금";
				String cont 	= "[차량대금지급요청-현금]"+client.getFirm_nm()+" "+c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG");
				
				String target_id = nm_db.getWorkAuthUser("영업수당회계관리자");
				
				UsersBean target_bean 	= umd.getUsersBean(target_id);
				
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
				
				//flag2 = cm_db.insertCoolMsg(msg);
				System.out.println("쿨메신저(차량대금현금지급요청)"+client.getFirm_nm()+"-----------------------"+target_bean.getUser_nm());
			}
		}
		//out.println("-----------------");
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
<%		if(!flag2){	%>	alert('수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
//	fm.submit();
	window.close();
	opener.location.reload();
</script>
</body>
</html>