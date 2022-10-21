<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_register.*, acar.client.*, acar.cont.*, acar.coolmsg.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_user	= request.getParameter("doc_user")==null?"":request.getParameter("doc_user");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	boolean flag = true;
	
	
	
	// 쿨메신저 알람 등록----------------------------------------------------------------------------------------
	
	String url 		= "";
	String sub 		= "결재요청";
	String cont 	= "결재바랍니다.";
	String rent_m_id= "";
	String rent_l_cd= "";
	String firm_nm	= "";
	String m_url  ="";
	
	Hashtable ht = d_db.getCont(doc.getDoc_id());
	
	ClientBean client = al_db.getNewClient(String.valueOf(ht.get("CLIENT_ID")));
	
	if(!String.valueOf(ht.get("RENT_MNG_ID")).equals("null")){
		rent_m_id 	= String.valueOf(ht.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(ht.get("RENT_L_CD"));
		firm_nm 	= client.getFirm_nm();
	}
	
	if(doc.getDoc_st().equals("1")){					//영업수당
	 	url		= "/fms2/commi/commi_doc_u.jsp?rent_mng_id="+rent_m_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
		sub		= "영업수당 결재요청";
		cont 	= "["+firm_nm+"] 영업수당 결재바랍니다.";
		m_url = "/fms2/commi/commi_doc_frame.jsp";
	}else if(doc.getDoc_st().equals("2")){				//탁송의뢰
		url 	= "/fms2/consignment/cons_reg_step3.jsp?cons_no="+doc.getDoc_id();
		sub		= "탁송의뢰 결재요청";
		cont 	= "탁송의뢰 결재바랍니다.";
		m_url = "/fms2/consignment_new/cons_rec_frame.jsp";
	}else if(doc.getDoc_st().equals("3")){				//탁송료
		url 	= "/fms2/consignment/cons_req_doc_frame.jsp";
		sub		= "탁송정산 결재요청";
		cont 	= "탁송정산 결재바랍니다.";
		m_url = "/fms2/consignment_new/cons_req_doc_frame.jsp";
	}else if(doc.getDoc_st().equals("4")){				//차량출고
	 	url		= "/fms2/car_pur/pur_doc_u.jsp?rent_mng_id="+rent_m_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
		sub		= "차량대금 지출 품의";
		cont 	= "["+firm_nm+"] 차량대금 지출을 요청합니다.";
		m_url = "/fms2/cons_pur/consp_mng_frame.jsp";
	}else if(doc.getDoc_st().equals("5")){				//차량대금
		url 	= "/fms2/car_pur/pur_pay_frame.jsp";
		sub		= "차량대금 결재요청";
		cont 	= "차량대금 결재바랍니다.";
		m_url = "/fms2/car_pur/pur_pay_frame.jsp";
	}else if(doc.getDoc_st().equals("6")){				//용품의뢰	
		url 	= "/fms2/tint/tint_reg_step3.jsp?tint_no="+doc.getDoc_id();
		sub		= "용품의뢰 결재요청";
		cont 	= "용품의뢰 결재바랍니다.";
		m_url ="/fms2/car_tint/tint_d_frame.jsp";
	}else if(doc.getDoc_st().equals("7")){				//용품대금
		url 	= "/fms2/tint/tint_d_frame.jsp";
		sub		= "용품정산 결재요청";
		cont 	= "용품정산 결재바랍니다.";
		m_url = "/fms2/car_tint/tint_d_frame.jsp";
	}else if(doc.getDoc_st().equals("8")){				//특근신청
		url 	= "/fms2/over_time/over_time_frame.jsp";
		sub		= "특근신청 결재요청";
		cont 	= "특근신청 결재바랍니다.";
		m_url = "/fms2/over_time/over_time_frame.jsp";
	}else if(doc.getDoc_st().equals("11")){				//해지정산
		url 	= "/fms2/cls_cont/lc_cls_d_frame.jsp";
		sub		= "용품정산 결재요청";
		cont 	= "용품정산 결재바랍니다.";
		m_url = "/fms2/cls_cont/lc_cls_d_frame.jsp";
	}else if(doc.getDoc_st().equals("21")){				//연차신청
		url 	= "/fms2/free_time/free_time_frame.jsp";
		sub		= "연차신청 결재요청";
		cont 	= "연차신청 결재바랍니다.";
		m_url = "/fms2/free_time/free_time_frame.jsp";
	}else if(doc.getDoc_st().equals("22")){				//연차취소
		url 	= "/fms2/free_time/free_time_frame.jsp";
		sub		= "연차취소 결재요청";
		cont 	= "연차취소 결재바랍니다.";
		m_url = "/fms2/free_time/free_time_frame.jsp";
	}else if(doc.getDoc_st().equals("31")){				//출금원장
		url 	= "/fms2/pay_mng/pay_d_frame.jsp";
		sub		= "출금원장 결재요청";
		cont 	= "출금원장 결재바랍니다.";
		m_url = "/fms2/pay_mng/pay_d_frame.jsp";
	}else if(doc.getDoc_st().equals("32")){				//송금요청
		url 	= "/fms2/pay_mng/pay_a_frame.jsp";
		sub		= "송금요청 결재요청";
		cont 	= "송금요청 결재바랍니다.";
		m_url = "/fms2/pay_mng/pay_a_frame.jsp";
	}
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	UsersBean target_bean 	= umd.getUsersBean(doc_user);
	
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
	
	flag = cm_db.insertCoolMsg(msg);
	System.out.println("쿨메신저_전자결재_재요청("+sub+")"+doc.getDoc_no()+" : "+sender_bean.getUser_nm()+" -> "+target_bean.getUser_nm());
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<script language='javascript'>
<%	if(!flag){	%>		
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		parent.window.close();
		parent.opener.location.reload();
<%	}			%>
</script>