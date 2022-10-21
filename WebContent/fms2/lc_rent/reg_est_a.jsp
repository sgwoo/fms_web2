<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cont.*, tax.*, acar.coolmsg.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">

<%
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//납품관리 수정 처리 페이지
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
	String dlv_est_h 	= request.getParameter("dlv_est_h")==null?"":request.getParameter("dlv_est_h");
	String reg_est_dt 	= request.getParameter("reg_est_dt")==null?"":request.getParameter("reg_est_dt");
	String reg_est_h 	= request.getParameter("reg_est_h")==null?"":request.getParameter("reg_est_h");
	String rent_est_dt 	= request.getParameter("rent_est_dt")==null?"":request.getParameter("rent_est_dt");
	String rent_est_h 	= request.getParameter("rent_est_h")==null?"":request.getParameter("rent_est_h");
	
	String udt_est_dt 	= request.getParameter("udt_est_dt")==null?"":request.getParameter("udt_est_dt");
	String con_est_dt 	= request.getParameter("con_est_dt")==null?"":request.getParameter("con_est_dt");
	
	String o_dlv_est_dt 	= request.getParameter("o_dlv_est_dt")==null?"":request.getParameter("o_dlv_est_dt");
	String o_udt_est_dt 	= request.getParameter("o_udt_est_dt")==null?"":request.getParameter("o_udt_est_dt");
	String o_reg_est_dt 	= request.getParameter("o_reg_est_dt")==null?"":request.getParameter("o_reg_est_dt");
	String o_rent_est_dt 	= request.getParameter("o_rent_est_dt")==null?"":request.getParameter("o_rent_est_dt");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String tint_cnt 	= request.getParameter("tint_cnt")==null?"0":request.getParameter("tint_cnt");
	String query = "";
	int flag = 0;
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	if (!tint_cnt.equals("0")) {
	
		String sup_est_dt[] 	= request.getParameterValues("sup_est_dt");
		String sup_est_h[] 		= request.getParameterValues("sup_est_h");
		String tint_no[] 			= request.getParameterValues("tint_no");
	
		int tint_size = tint_no.length;
	
		for (int i = 0; i < tint_size; i++) {
			//용품설치의뢰일시
			query = " UPDATE car_tint SET sup_est_dt=replace('"+sup_est_dt[i]+sup_est_h[i]+"', '-', '') WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and tint_no='"+tint_no[i]+"'";
			flag = a_db.updateEstDt(query);
		}
	}
	
	//출고예정일시, 인수일자
	query = " UPDATE car_pur SET dlv_est_dt=replace('"+dlv_est_dt+dlv_est_h+"', '-', ''), udt_est_dt=replace('"+udt_est_dt+"', '-', '') WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
	flag = a_db.updateEstDt(query);
	
	//등록예정일시
	query = " UPDATE car_etc SET reg_est_dt =replace('"+reg_est_dt+reg_est_h+"', '-', '')   WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"'";
	flag = a_db.updateEstDt(query);
	
	//납품예정일시
	query = " UPDATE fee     SET rent_est_dt=replace('"+rent_est_dt+rent_est_h+"', '-', '') WHERE rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and rent_st='1'";
	flag = a_db.updateEstDt(query);

	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);

	//예정일정보
	Hashtable est = a_db.getRentEst(m_id, l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(m_id, l_cd);	

	//등록예정일시 변경일 경우 본사인수시-아마존탁송에 변경안내문자 발송
	if (pur.getUdt_st().equals("1") && !AddUtil.replace(reg_est_dt, "-", "").equals(AddUtil.replace(o_reg_est_dt, "-", ""))) {
	
		UsersBean target_bean = umd.getUsersBean(nm_db.getWorkAuthUser("차량등록자"));						
	
		String sms_content = "[등록예정일 변경안내]  &lt;br&gt; &lt;br&gt; 계출번호:"+pur.getRpt_no()+",  &lt;br&gt; &lt;br&gt; 상호:"+String.valueOf(est.get("FIRM_NM"))+",  &lt;br&gt; &lt;br&gt; 차명:"+String.valueOf(est.get("CAR_NM"))+",  &lt;br&gt; &lt;br&gt; 희망차량번호:"+pur.getEst_car_no()+",  &lt;br&gt; &lt;br&gt; 변경등록예정일자:"+reg_est_dt+"  &lt;br&gt; &lt;br&gt; -아마존카-";
				
		int i_msglen = AddUtil.lengthb(sms_content);
	
		String msg_type = "0";
	
		//80이상이면 장문자
		if (i_msglen>80) msg_type = "5";
				
		String send_phone = sender_bean.getUser_m_tel();
		
		if (!sender_bean.getHot_tel().equals("")) {
			send_phone = sender_bean.getHot_tel();
		}

		//at_db.sendMessage(1009, "0",  sms_content, target_bean.getUser_m_tel(), send_phone, null, l_cd, ck_acar_id);
		
		//List<String> fieldList = Arrays.asList(pur.getRpt_no(), String.valueOf(est.get("FIRM_NM")), String.valueOf(est.get("CAR_NM")), pur.getEst_car_no(), reg_est_dt);
		//at_db.sendMessageReserve("acar0248", fieldList, target_bean.getUser_m_tel(), send_phone, null, l_cd, ck_acar_id);
		
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>등록예정일 변경안내</SUB>"+
	  				"    <CONT>"+sms_content+"</CONT>"+
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
		
		boolean flag3 = true;
		flag3 = cm_db.insertCoolMsg(msg);
		
	}
	
	//대전,대구 인수지는 차량등록예정일이 넣을때 보험담당자에게 메시지를 보낸다.
	if ((pur.getUdt_st().equals("3") || pur.getUdt_st().equals("5")) && !AddUtil.replace(reg_est_dt,"-","").equals(AddUtil.replace(o_reg_est_dt, "-", ""))) {
		//메시지발송 프로시저 호출
		String  d_flag2 = ec_db.call_sp_message_send("msg", "대전,대구인수지 차량등록예정일 보험담당자 통보", m_id, l_cd, ck_acar_id);
	}	
	
	//System.out.println("o_dlv_est_dt="+o_dlv_est_dt);
	//System.out.println("dlv_est_dt="+dlv_est_dt);
	
	//출고예정일 변경시
	if (pur.getOne_self().equals("Y") && !o_dlv_est_dt.equals("") && !o_dlv_est_dt.equals(dlv_est_dt)) {
		//최초영업자가 수정시 : 출고담당자에게 메시지 발송
		if (base.getBus_id().equals(ck_acar_id)) {
			//메시지발송 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_message_send("msg", "납품준비상황 출고예정일("+o_dlv_est_dt+"->"+dlv_est_dt+") 변경 : 최초영업자", m_id, l_cd, ck_acar_id);
		//최초영업자 아닌 자가 수정시 : 최초영업자에게 메시지 발송
		} else {
			//메시지발송 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_message_send("msg", "납품준비상황 출고예정일("+o_dlv_est_dt+"->"+dlv_est_dt+") 변경 : "+sender_bean.getUser_nm(), m_id, l_cd, ck_acar_id);
		}
	}

%>
<script language='javascript'>
<%if (flag == 0) {%>
	alert("처리되지 않았습니다");
	location='about:blank';
<%} else {%>
	alert("처리되었습니다");
	parent.location='reg_est.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>';
	<%if(mode.equals("board")){%>
	//parent.window.close();
	//parent.opener.location.reload();
	<%}%>
<%}%>
</script>
