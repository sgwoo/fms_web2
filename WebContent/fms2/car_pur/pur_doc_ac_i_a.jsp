<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.tint.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.client.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//중고차딜러
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "5");
	//중고차판매처
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(base.getBus_id());
%>


<%
	//4. 출고정보 car_pur--------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	pur.setTrf_amt1		(request.getParameter("car_f_amt").equals("")			?0:AddUtil.parseDigit(request.getParameter("car_f_amt")));
	pur.setTrf_amt2		(request.getParameter("commi_c_amt").equals("")		?0:AddUtil.parseDigit(request.getParameter("commi_c_amt")));
	pur.setTrf_amt3		(request.getParameter("storage_c_amt").equals("")	?0:AddUtil.parseDigit(request.getParameter("storage_c_amt")));
	pur.setPur_est_dt	(request.getParameter("pur_est_dt")	==null?"":request.getParameter("pur_est_dt"));
	pur.setCon_est_dt	(request.getParameter("con_est_dt")	==null?"":request.getParameter("con_est_dt"));
	pur.setEst_car_no	(request.getParameter("est_car_no")	==null?"":request.getParameter("est_car_no"));
	pur.setCar_num		(request.getParameter("car_num")	==null?"":request.getParameter("car_num"));	
	pur.setCon_bank		(request.getParameter("con_bank")	==null?"":request.getParameter("con_bank"));
	pur.setCon_acc_no	(request.getParameter("con_acc_no")	==null?"":request.getParameter("con_acc_no"));
	pur.setCon_acc_nm	(request.getParameter("con_acc_nm")	==null?"":request.getParameter("con_acc_nm"));
	pur.setCon_amt_cont	(request.getParameter("con_amt_cont")	==null?"":request.getParameter("con_amt_cont"));
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	

	emp1.setEmp_bank	(request.getParameter("emp_bank")	==null?"":request.getParameter("emp_bank"));
	emp1.setEmp_acc_no(request.getParameter("emp_acc_no")	==null?"":request.getParameter("emp_acc_no"));
	emp1.setEmp_acc_nm(request.getParameter("emp_acc_nm")	==null?"":request.getParameter("emp_acc_nm"));
	
	if(!emp1.getRent_mng_id().equals("")){
		//=====[commi] update=====
		flag9 = a_db.updateCommiNew(emp1);
	}
	
	
	//5. 차량기본정보 car_etc-----------------------------------------------------------------------------------------------
	
	//car_etc
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String reg_est_dt 	= request.getParameter("reg_est_dt")==null?"":request.getParameter("reg_est_dt");
	String reg_est_h 	= request.getParameter("reg_est_h")==null?"":request.getParameter("reg_est_h");
	
	car.setReg_est_dt	(reg_est_dt+reg_est_h);
	car.setCar_ext		(request.getParameter("car_ext")	==null?"":request.getParameter("car_ext"));
	
	//=====[car_etc] update=====
	flag5 = a_db.updateContCarNew(car);
	
	
	//6. 문서처리전 등록-------------------------------------------------------------------------------------------
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 		= "차량대금 지출 품의";
	String cont 	= "[중고차] 차량대금 지출을 요청합니다.";
	
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st("4");
	doc.setDoc_id(rent_l_cd);
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc("");
	doc.setUser_nm1("기안자");
	doc.setUser_nm2("지점장");
	doc.setUser_nm3("출고관리자");
	doc.setUser_nm4("회계관리자");
	doc.setUser_nm5("총무과장");
	doc.setUser_id1(user_id);
	doc.setDoc_bit("1");
	
	System.out.println("쿨메신저(차량대금기안)-----------------------"+br_id);
	
	String user_id2 = "XXXXXX";
	String user_id3 = nm_db.getWorkAuthUser("출고관리자");
	String user_id4 = "XXXXXX";
	String user_id5 = nm_db.getWorkAuthUser("대출관리자");
	
	doc.setUser_id2(user_id2);
	doc.setUser_id3(user_id3);
	doc.setUser_id4(user_id4);
	doc.setUser_id5(user_id5);
	doc.setDoc_step("1");//기안
	doc.setDoc_bit("2");
	
	//=====[doc_settle] insert=====
	flag6 = d_db.insertDocSettle(doc);
	//out.println("문서처리전 수정<br>");
	
	
	//7. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String url 		= "/fms2/car_pur/pur_doc_ac_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
	String m_url  = "/fms2/car_pur/pur_doc_ac_frame.jsp";	
	String target_id = doc.getUser_id3();
		
	CarScheBean cs_bean6 = csd.getCarScheTodayBean(target_id);
	if(!cs_bean6.getUser_id().equals("")){
		if(cs_bean6.getWork_id().equals("")){
			target_id = nm_db.getWorkAuthUser("출고관리자");	//출고관리자
		}else{
			target_id = cs_bean6.getWork_id(); 					//업무대체자
		}
	}
	
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
  				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
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
	
	flag7 = cm_db.insertCoolMsg(msg);	
	System.out.println("쿨메신저(중고차 차량대금기안)"+firm_nm+"-----------------------"+target_bean.getUser_nm());
	%>
<script language='javascript'>
<%		if(!flag4){	%>	alert('출고정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
<%		if(!flag5){	%>	alert('차량정보 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
<%		if(!flag6){	%>	alert('문서품의서 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag7){	%>	alert('쿨메신저 등록 에러입니다.\n\n확인하십시오');				<%		}	%>		
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
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'pur_doc_ac_u.jsp';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>