<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
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
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String agent_doc_st	= request.getParameter("agent_doc_st")==null?"":request.getParameter("agent_doc_st");
	
	boolean flag1 = true;
	boolean flag2 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	String user_id6 = "";
		
	//영업수당정보 commi-------------------------------------------------------------------------------------------
		
	//commi
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "7");
	
	int dif_amt_o = emp1.getDif_amt();
	int dif_amt_n = request.getParameter("d_amt")==null? 0:Util.parseDigit(request.getParameter("d_amt"));
	
	if(dif_amt_o>dif_amt_n || dif_amt_o<dif_amt_n){
	
		emp1.setCommi		(request.getParameter("commi")			==null? 0:Util.parseDigit(request.getParameter("commi")));
		emp1.setInc_amt		(request.getParameter("inc_amt")		==null? 0:Util.parseDigit(request.getParameter("inc_amt")));
		emp1.setRes_amt		(request.getParameter("res_amt")		==null? 0:Util.parseDigit(request.getParameter("res_amt")));
		emp1.setTot_amt		(request.getParameter("c_amt")			==null? 0:Util.parseDigit(request.getParameter("c_amt")));
		emp1.setDif_amt		(request.getParameter("d_amt")			==null? 0:Util.parseDigit(request.getParameter("d_amt")));
		emp1.setAdd_amt1	(request.getParameter("add_amt1")		==null? 0:Util.parseDigit(request.getParameter("add_amt1")));
		emp1.setAdd_amt2	(request.getParameter("add_amt2")		==null? 0:Util.parseDigit(request.getParameter("add_amt2")));
		emp1.setAdd_amt3	(request.getParameter("add_amt3")		==null? 0:Util.parseDigit(request.getParameter("add_amt3")));
		emp1.setVat_amt		(request.getParameter("vat_amt")		==null? 0:Util.parseDigit(request.getParameter("vat_amt")));
		emp1.setVat_per		(request.getParameter("vat_per")		==null?"":request.getParameter("vat_per"));
		
		//=====[commi] update=====
		flag1 = a_db.updateCommiNew(emp1);
		out.println("영업수당정보 수정<br>");
	}
	
	//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	
	String doc_step = doc.getDoc_step();
	
	if(doc_step.equals("")){
		doc_step = "2";
	}
	
	//총무팀장 결재이면 문서 결재 완료
	if(doc_bit.equals("8")) doc_step = "3";
	
	if(doc_bit.equals("7")){
		if(user_bean.getBr_nm().equals("본사") || user_bean.getBr_nm().equals("강남지점") || user_bean.getBr_nm().equals("인천지점") || user_bean.getBr_nm().equals("수원지점") || user_bean.getBr_nm().equals("강서지점") || user_bean.getBr_nm().equals("구로지점") || user_bean.getBr_nm().equals("광화문지점") || user_bean.getBr_nm().equals("송파지점")){
		
		}else{
			doc_step = "3";
		}
	}
	
	if(!mode.equals("msg")){
		flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		out.println("문서처리전 결재<br>");
	}
	
	if(doc_bit.equals("7")){
		if(user_bean.getBr_nm().equals("본사") || user_bean.getBr_nm().equals("강남지점") || user_bean.getBr_nm().equals("인천지점") || user_bean.getBr_nm().equals("수원지점") || user_bean.getBr_nm().equals("강서지점") || user_bean.getBr_nm().equals("구로지점") || user_bean.getBr_nm().equals("광화문지점") || user_bean.getBr_nm().equals("송파지점")){
		
		}else{
			doc_bit = "8";
		}
	}
	
	//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sub 		= "승계업무수당 결재 요청";
	String cont 		= "["+firm_nm+"] 승계업무수당 지출을 요청합니다.";
	String url 		= "/fms2/commi/suc_commi_doc_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
	String m_url  ="/fms2/commi/suc_commi_doc_frame.jsp";
	String target_id = "";
	
	if(doc_bit.equals("1")){
		target_id = doc.getUser_id6();
	}
	if(doc_bit.equals("2"))	target_id = doc.getUser_id6();
	if(doc_bit.equals("3"))	target_id = doc.getUser_id6();
	if(doc_bit.equals("6"))	target_id = doc.getUser_id7();
	if(doc_bit.equals("7"))	target_id = doc.getUser_id8();
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	
	if(doc_bit.equals("8")){
				
		target_id = nm_db.getWorkAuthUser("영업수당회계관리자");
				
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);
		
		if(!cs_bean2.getWork_id().equals("")) target_id = cs_bean2.getWork_id();
		
		sub 	= "승계업무수당 결재 완결";
		cont 	= "기안자["+user_bean.getUser_nm()+" : "+firm_nm+" ] - 승계업무수당 지출을 결재 완결하니 출금 집행하세요";
	}
	
	
	

	
	//사용자 정보 조회
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
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
	
	flag2 = cm_db.insertCoolMsg(msg);
	System.out.println("쿨메신저(승계업무수당결재)"+firm_nm+":"+sender_bean.getUser_nm()+"----------------------->"+target_bean.getUser_nm());
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
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
  <input type='hidden' name='mode'	 			value='<%=mode%>'>     
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action = 'suc_commi_doc_u.jsp';
	fm.target = 'd_content';
	fm.submit();
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>