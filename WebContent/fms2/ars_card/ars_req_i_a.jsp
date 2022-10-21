<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.ars_card.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	out.println("미사용페이지입니다.");
	if(1==1)return;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int flag = 0;
	
	String ars_code = "";
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	


	System.out.println(rent_l_cd+" Ars Card 결제요청 : "+request.getParameter("good_mny"));
	
	
	
	ArsCardBean ars = new ArsCardBean();
		
	ars.setClient_id	(client_id);
	ars.setBuyr_name 	(request.getParameter("buyr_name")==null?"":request.getParameter("buyr_name"));
	ars.setBuyr_tel2 	(request.getParameter("buyr_tel2")==null?"":request.getParameter("buyr_tel2"));
	ars.setBuyr_mail 	(request.getParameter("buyr_mail")==null?"":request.getParameter("buyr_mail"));
	ars.setGood_name 	(request.getParameter("good_name")==null?"":request.getParameter("good_name"));
	ars.setGood_cont 	(request.getParameter("msg")==null?"":request.getParameter("msg"));
	ars.setGood_mny		(request.getParameter("good_mny")==null?0:AddUtil.parseDigit(request.getParameter("good_mny")));
	ars.setCard_kind 	(request.getParameter("card_kind")==null?"":request.getParameter("card_kind"));
	ars.setCard_no 		(request.getParameter("card_no")==null?"":request.getParameter("card_no"));
	ars.setCard_y_mm 	(request.getParameter("card_y_mm")==null?"":request.getParameter("card_y_mm"));
	ars.setCard_y_yy 	(request.getParameter("card_y_yy")==null?"":request.getParameter("card_y_yy"));
	ars.setQuota	 	(request.getParameter("quota")==null?"":request.getParameter("quota"));
	ars.setReg_id		(ck_acar_id);
	ars.setSettle_mny	(request.getParameter("settle_mny")==null?0:AddUtil.parseDigit(request.getParameter("settle_mny")));
	ars.setCard_fee		(request.getParameter("card_fee")==null?0:AddUtil.parseDigit(request.getParameter("card_fee")));
		
	ars_code = ar_db.insertArsCard(ars);
	
	
	
	//카드결제담당자에게 전달
	String target_id = nm_db.getWorkAuthUser("법인카드관리자");
	
	CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);	
	if(!cs_bean.getUser_id().equals("")){
		target_id = nm_db.getWorkAuthUser("연장/승계담당자");
	}
		
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	
	
	String sub 	= "";
	String cont 	= "";

	sub 	= "ARS카드결제요청";
	cont 	= "[ "+request.getParameter("buyr_name")+" ] ARS카드 결제요청 합니다.";
	
	
		
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
			
	flag1 = cm_db.insertCoolMsg(msg);
	
%>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name="client_id" value="<%=client_id%>">
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name="ars_code" value="<%=ars_code%>">
  
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%	if(ars_code.equals("")){%>
		alert('등록 에러입니다.\n\n확인하십시오');
<%	}else{%>		
		alert('등록되었습니다. \n\n카드결재담당자가 업무처리후 통보할 예정입니다.');
<%	}%>

	//fm.action = 'ars_req_frame.jsp';	
	fm.action = 'ars_req_c.jsp';
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>