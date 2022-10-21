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
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
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
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String app_st 		= request.getParameter("app_st")==null?"":request.getParameter("app_st");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int flag = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	


	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	//수정
	if(cng_item.equals("u")){

		ars.setBuyr_name 	(request.getParameter("buyr_name")	==null?"":request.getParameter("buyr_name"));
		ars.setBuyr_tel2 	(request.getParameter("buyr_tel2")	==null?"":request.getParameter("buyr_tel2"));
		ars.setBuyr_mail 	(request.getParameter("buyr_mail")	==null?"":request.getParameter("buyr_mail"));
		ars.setGood_name 	(request.getParameter("good_name")	==null?"":request.getParameter("good_name"));
		ars.setGood_cont 	(request.getParameter("msg")		==null?"":request.getParameter("msg"));
		ars.setGood_mny		(request.getParameter("good_mny")	==null?0:AddUtil.parseDigit(request.getParameter("good_mny")));
		ars.setCard_kind 	(request.getParameter("card_kind")	==null?"":request.getParameter("card_kind"));
		ars.setCard_no 		(request.getParameter("card_no")	==null?"":request.getParameter("card_no"));
		ars.setCard_y_mm 	(request.getParameter("card_y_mm")	==null?"":request.getParameter("card_y_mm"));
		ars.setCard_y_yy 	(request.getParameter("card_y_yy")	==null?"":request.getParameter("card_y_yy"));
		ars.setQuota	 	(request.getParameter("quota")		==null?"":request.getParameter("quota"));		
		ars.setSettle_mny	(request.getParameter("settle_mny")	==null?0:AddUtil.parseDigit(request.getParameter("settle_mny")));
		ars.setCard_fee		(request.getParameter("card_fee")	==null?0:AddUtil.parseDigit(request.getParameter("card_fee")));
		
		flag1 = ar_db.updateArsCard(ars);
	
	//완료처리
	}else if(cng_item.equals("app")){
	
		ars.setApp_id	 	(ck_acar_id);
		flag1 = ar_db.updateArsCardApp(ars);
	
	
	
		//요청자에게 전달
		String target_id = ars.getReg_id();
			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("입금담당"));
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	
		String sub 	= "";
		String cont 	= "";

		sub 	= "ARS카드결제완료";
		cont 	= "[ "+ars.getBuyr_name()+" "+ars.getGood_mny()+"원 ] ARS카드 결제완료되었습니다.";
		

	
	
		
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
			
			
		if(app_st.equals("1")){
			flag1 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저( "+request.getParameter("buyr_name")+" ARS카드결제완료) "+sender_bean.getUser_nm()+"-----------------------"+target_bean.getUser_nm());
		}else{
			System.out.println(request.getParameter("buyr_name")+" ARS카드결제완료 "+sender_bean.getUser_nm());
		}
		
	//입금처리요청
	}else if(cng_item.equals("msg")){
	
		UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("입금담당"));
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 	= "";
		String cont 	= "";

		sub 	= "ARS카드결제";
		cont 	= "[ "+ars.getBuyr_name()+" "+ars.getGood_mny()+"원 ] ARS카드 결제되었습니다. 입금처리하십시오.";
	
		CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_bean2.getUser_id());
		if(!cs_bean7.getUser_id().equals("")){
			target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("출금담당"));
		}
				
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
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
			
		flag1 = cm_db.insertCoolMsg(msg);
	}
%>
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
  <input type='hidden' name='ars_code' 	value='<%=ars_code%>'>
  
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%	if(!flag1){%>
		alert('등록 에러입니다.\n\n확인하십시오');
<%	}%>	

	<%if(cng_item.equals("u")){%>	
	fm.action = 'ars_req_c.jsp';	
	<%}else{%>
	fm.action = 'ars_card_frame.jsp';	
	<%}%>
	
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>