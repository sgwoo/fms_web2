<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.coolmsg.*, acar.user_mng.*, acar.car_office.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="bean" class="acar.cont.ContGiInsBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")		==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String doc_no	 		= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 		= request.getParameter("mode")==null?"":request.getParameter("mode");	
	
	

	int chk = 0;
	int count = 0;
	boolean flag4 = true;
	boolean flag5 = true;
	
	
	//계약기본정보
	ContBaseBean base = ac_db.getCont(rent_mng_id, rent_l_cd);
		
	//차량기본정보 - 보증보험 가입여부
	ContCarBean car 	= ac_db.getContCar(rent_mng_id, rent_l_cd);
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
		
	//gua_ins
	ContGiInsBean gins 	= ac_db.getContGiInsNew(rent_mng_id, rent_l_cd, rent_st);
	
	String o_gi_dt = gins.getGi_dt();
	
	gins.setGi_st		(request.getParameter("gi_st")			==null?"":request.getParameter("gi_st"));

	if(gins.getGi_st().equals("0")){
		gins.setGi_reason	(request.getParameter("gi_reason")==null?"":request.getParameter("gi_reason"));
		gins.setGi_sac_id	(request.getParameter("gi_sac_id")==null?"":request.getParameter("gi_sac_id"));
		gins.setGi_jijum("");
		gins.setGi_amt(0);
		gins.setGi_fee(0);
		gins.setGi_month("");	//보증보험 가입개월 추가(2018.03.22)
	}else if(gins.getGi_st().equals("1")){
		gins.setGi_reason("");
		gins.setGi_sac_id("");
		gins.setGi_no		(request.getParameter("gi_no")==null?"":request.getParameter("gi_no"));
		gins.setGi_start_dt	(request.getParameter("gi_start_dt")==null?"":request.getParameter("gi_start_dt"));
		gins.setGi_end_dt	(request.getParameter("gi_end_dt")==null?"":request.getParameter("gi_end_dt"));
		gins.setGi_day		(request.getParameter("gi_day")==null?"":request.getParameter("gi_day"));
		gins.setGi_dt		(request.getParameter("gi_dt")==null?"":request.getParameter("gi_dt"));
		gins.setGi_jijum	(request.getParameter("gi_jijum")==null?"":request.getParameter("gi_jijum"));
		gins.setGi_amt		(request.getParameter("gi_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_amt")));
		gins.setGi_fee		(request.getParameter("gi_fee")	==null? 0:AddUtil.parseDigit(request.getParameter("gi_fee")));
		gins.setGi_month	(request.getParameter("gi_month")==null?"":request.getParameter("gi_month"));	//보증보험 가입개월 추가(2018.03.22)
		
		String n_gi_dt = gins.getGi_dt();
		
		//보증보험 가입완료 메시지 발송
		if(o_gi_dt.equals("") && !n_gi_dt.equals("") && n_gi_dt.length() > 7){
				
			String sub 		= "보증보험 가입완료";
			String cont 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" "+request.getParameter("car_nm")+"] 장기계약 보증보험 가입이 완료되었습니다. 확인바랍니다.";
			String target_id = base.getBus_id();
			
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
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
			
			flag5 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저("+rent_l_cd+" "+request.getParameter("firm_nm")+" 보증보험 가입완료)-----------------------"+target_bean.getUser_nm());
			
			//에이전트 실의뢰자한테
			if(target_bean.getDept_id().equals("1000")){
							
				UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
				String sendphone 	= sender_bean.getUser_m_tel();
				String sendname 	= "(주)아마존카 "+sender_bean.getUser_nm();
				String msg_cont		= cont;
				String destname 	= target_bean.getUser_m_tel();;
				String destphone 	= target_bean.getUser_nm();
				if(!base.getAgent_emp_id().equals("")){
					CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id());
					destphone = a_coe_bean.getEmp_m_tel();
					destname 	= a_coe_bean.getEmp_nm();
				}
		
				IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", msg_cont);
			}
			
		
		}
	}

	if(gins.getRent_mng_id().equals("")){
			//=====[gua_ins] insert=====
			gins.setRent_mng_id	(rent_mng_id);
			gins.setRent_l_cd	(rent_l_cd);
			gins.setRent_st		(rent_st);
			flag4 = ac_db.insertGiInsNew(gins);
	}else{
			//=====[gua_ins] update=====
			flag4 = ac_db.updateGiInsNew(gins);
	}
		
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="gur_ins_s_frame.jsp" name="form1" method="POST" >
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">   
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">   
  <input type="hidden" name="rent_st" value="<%=rent_st%>">     
  <input type="hidden" name="from_page2" value="<%=from_page2%>">   
  <input type="hidden" name="from_page" value="<%=from_page%>">   
  <input type="hidden" name="doc_no" value="<%=doc_no%>">   
  <input type="hidden" name="mode" value="<%=mode%>">     
</form>
<script>
<%	if(!flag4){	%>
		alert('이행보증보험 등록 에러입니다.\n\n확인하십시오');
<%	}else{	%>	

		var fm = document.form1;
		fm.target = "d_content";
		<%if(from_page2.equals("/fms2/car_pur/pur_doc_u.jsp")){%>
			fm.action = "/fms2/car_pur/pur_doc_u.jsp";
		<%}%>
		fm.submit();	
		parent.window.close();
<%	}%>	

</script>
</body>
</html>