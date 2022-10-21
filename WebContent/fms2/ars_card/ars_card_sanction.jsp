<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.* "%>
<%@ page import="acar.ars_card.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
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
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	
	
	//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
	
	//=====[doc_settle] update=====
	
	String doc_step = "2";
	
		
	if(doc_bit.equals("1")){
		 doc_step = "1";
		 doc.setDoc_bit("2");
	} 
		
	//총무팀장 결재이면 문서 결재 완료
	if(doc_bit.equals("3")) doc_step = "3";
	
	
	flag1 = d_db.updateDocSettle(doc_no, ck_acar_id, doc_bit, doc_step);
	
	
	
	//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
	
	String firm_nm	= request.getParameter("buyr_name")==null?"":request.getParameter("buyr_name");
	
	String sub 		= "신용카드결제 수수료면제 요청";
	String cont 	= "["+firm_nm+"] 신용카드 결제수수료 면제를 요청합니다.";
	String url 		= "/fms2/ars_card/ars_card_req_c.jsp?ars_code="+ars_code+"|doc_no="+doc_no;
	String target_id = "";
	String m_url = "/fms2/ars_card/ars_card_frame.jsp";
	
	//다음결재자 target_id
	
	if(doc_bit.equals("1"))	target_id = doc.getUser_id2();				
	if(doc_bit.equals("2"))	target_id = doc.getUser_id3();				
	if(doc_bit.equals("3"))	target_id = doc.getUser_id1();				

	if(doc_bit.equals("3")){
		cont 	= "["+firm_nm+"] 신용카드 결제수수료 면제요청이 결재되었습니다.  &lt;br&gt; &lt;br&gt; 신용카드결제청구서 이노페이 등록 처리하세요";
		if(ars.getApp_st().equals("1")){//ARS 수기결제(아마존카)->회계담당자가 등록처리    
			cont 	= "["+firm_nm+"] 신용카드 결제수수료 면제요청이 결재되었습니다.";
			//회계담당자 정보 조회
			UsersBean account_bean 	= umd.getUserNmBean(ars.getMng_nm());			
			target_id = account_bean.getUser_id();			
		}
	}
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
	if(!cs_bean.getUser_id().equals("")){
		if(!cs_bean.getWork_id().equals("")){
		 	target_id = cs_bean.getWork_id();
		}
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
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type="hidden" name="ars_code" 		    value="<%=ars_code%>">   
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action = 'ars_card_req_c.jsp';
	fm.target = 'd_content';
	fm.submit();
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>