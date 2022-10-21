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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_user	= request.getParameter("doc_user")==null?"":request.getParameter("doc_user");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	boolean flag = true;
	
	
	
	// ��޽��� �˶� ���----------------------------------------------------------------------------------------
	
	String url 		= "";
	String sub 		= "�����û";
	String cont 	= "����ٶ��ϴ�.";
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
	
	if(doc.getDoc_st().equals("1")){					//��������
	 	url		= "/fms2/commi/commi_doc_u.jsp?rent_mng_id="+rent_m_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
		sub		= "�������� �����û";
		cont 	= "["+firm_nm+"] �������� ����ٶ��ϴ�.";
		m_url = "/fms2/commi/commi_doc_frame.jsp";
	}else if(doc.getDoc_st().equals("2")){				//Ź���Ƿ�
		url 	= "/fms2/consignment/cons_reg_step3.jsp?cons_no="+doc.getDoc_id();
		sub		= "Ź���Ƿ� �����û";
		cont 	= "Ź���Ƿ� ����ٶ��ϴ�.";
		m_url = "/fms2/consignment_new/cons_rec_frame.jsp";
	}else if(doc.getDoc_st().equals("3")){				//Ź�۷�
		url 	= "/fms2/consignment/cons_req_doc_frame.jsp";
		sub		= "Ź������ �����û";
		cont 	= "Ź������ ����ٶ��ϴ�.";
		m_url = "/fms2/consignment_new/cons_req_doc_frame.jsp";
	}else if(doc.getDoc_st().equals("4")){				//�������
	 	url		= "/fms2/car_pur/pur_doc_u.jsp?rent_mng_id="+rent_m_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no;
		sub		= "������� ���� ǰ��";
		cont 	= "["+firm_nm+"] ������� ������ ��û�մϴ�.";
		m_url = "/fms2/cons_pur/consp_mng_frame.jsp";
	}else if(doc.getDoc_st().equals("5")){				//�������
		url 	= "/fms2/car_pur/pur_pay_frame.jsp";
		sub		= "������� �����û";
		cont 	= "������� ����ٶ��ϴ�.";
		m_url = "/fms2/car_pur/pur_pay_frame.jsp";
	}else if(doc.getDoc_st().equals("6")){				//��ǰ�Ƿ�	
		url 	= "/fms2/tint/tint_reg_step3.jsp?tint_no="+doc.getDoc_id();
		sub		= "��ǰ�Ƿ� �����û";
		cont 	= "��ǰ�Ƿ� ����ٶ��ϴ�.";
		m_url ="/fms2/car_tint/tint_d_frame.jsp";
	}else if(doc.getDoc_st().equals("7")){				//��ǰ���
		url 	= "/fms2/tint/tint_d_frame.jsp";
		sub		= "��ǰ���� �����û";
		cont 	= "��ǰ���� ����ٶ��ϴ�.";
		m_url = "/fms2/car_tint/tint_d_frame.jsp";
	}else if(doc.getDoc_st().equals("8")){				//Ư�ٽ�û
		url 	= "/fms2/over_time/over_time_frame.jsp";
		sub		= "Ư�ٽ�û �����û";
		cont 	= "Ư�ٽ�û ����ٶ��ϴ�.";
		m_url = "/fms2/over_time/over_time_frame.jsp";
	}else if(doc.getDoc_st().equals("11")){				//��������
		url 	= "/fms2/cls_cont/lc_cls_d_frame.jsp";
		sub		= "��ǰ���� �����û";
		cont 	= "��ǰ���� ����ٶ��ϴ�.";
		m_url = "/fms2/cls_cont/lc_cls_d_frame.jsp";
	}else if(doc.getDoc_st().equals("21")){				//������û
		url 	= "/fms2/free_time/free_time_frame.jsp";
		sub		= "������û �����û";
		cont 	= "������û ����ٶ��ϴ�.";
		m_url = "/fms2/free_time/free_time_frame.jsp";
	}else if(doc.getDoc_st().equals("22")){				//�������
		url 	= "/fms2/free_time/free_time_frame.jsp";
		sub		= "������� �����û";
		cont 	= "������� ����ٶ��ϴ�.";
		m_url = "/fms2/free_time/free_time_frame.jsp";
	}else if(doc.getDoc_st().equals("31")){				//��ݿ���
		url 	= "/fms2/pay_mng/pay_d_frame.jsp";
		sub		= "��ݿ��� �����û";
		cont 	= "��ݿ��� ����ٶ��ϴ�.";
		m_url = "/fms2/pay_mng/pay_d_frame.jsp";
	}else if(doc.getDoc_st().equals("32")){				//�۱ݿ�û
		url 	= "/fms2/pay_mng/pay_a_frame.jsp";
		sub		= "�۱ݿ�û �����û";
		cont 	= "�۱ݿ�û ����ٶ��ϴ�.";
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
	
	//�޴»��
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
	//�������
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
	System.out.println("��޽���_���ڰ���_���û("+sub+")"+doc.getDoc_no()+" : "+sender_bean.getUser_nm()+" -> "+target_bean.getUser_nm());
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<script language='javascript'>
<%	if(!flag){	%>		
		alert("ó������ �ʾҽ��ϴ�");
		location='about:blank';		
<%	}else{		%>		
		alert("ó���Ǿ����ϴ�");
		parent.window.close();
		parent.opener.location.reload();
<%	}			%>
</script>