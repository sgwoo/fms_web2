<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
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
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String off_nm 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	
	String msg_send_bit 	= request.getParameter("msg_send_bit")==null?"":request.getParameter("msg_send_bit");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	DocSettleBean doc = new DocSettleBean();
	
	if(doc_no.equals("") && doc_bit.equals("1")){
	
		//0. Ź��
		String cons_no [] = request.getParameterValues("cons_no");
				
		int size = request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
		
		String req_code = Long.toString(System.currentTimeMillis());
		
		for(int i = 0 ; i < size ; i++){
			
			//1. Ź���Ƿ� ����-------------------------------------------------------------------------------------------
						
			//=====[consignment] update=====
			flag1 = cs_db.updateConsignmentPurReqCode(cons_no[i], req_dt, req_code);
						
		}
		
		//1. ����ó���� ���-------------------------------------------------------------------------------------------
		
		String sub 		= "���Ź�۷�û��";
		String cont 		= "[���Ź�۾�ü: "+off_nm+", û������: "+req_dt+"] Ź�۷�û�� ���縦 ��û�մϴ�.";
		String target_id 	= "";
		
		doc.setDoc_st	("34");//Ź�۷�û��
		doc.setDoc_id	(req_code);
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	("");
		doc.setUser_nm1	("Ź�۰�����");
		doc.setUser_nm2	("�ѹ�����");
		doc.setUser_id1	(user_id);
		doc.setUser_id2	("000004");//�ѹ�����		
		doc.setDoc_bit	("1");
		doc.setDoc_step	("2");
		

		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		//out.println("����ó���� ���<br>");
		
		
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/cons_pur/consp_doc_frame.jsp?gubun1=3|gubun2=1";
		String m_url  = "/fms2/cons_pur/consp_doc_frame.jsp";
		target_id = doc.getUser_id2();
		
		if(doc.getDoc_step().equals("3")){
			url 		= "/fms2/cons_pur/consp_doc_frame.jsp?gubun1=3|gubun2=2";
			sub 		= "���Ź�۷� ���� �ϰ�";
			cont 		= "[���Ź�۾�ü: "+off_nm+", û������: "+req_dt+"] Ź�۷� ������ ���� �ϰ��ϴ� ��� �����ϼ���";
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
		
		flag2 = cm_db.insertCoolMsg(msg);		
		System.out.println("��޽���(Ź�۹�������)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());		
	}
	
	if(!doc_no.equals("") && doc_bit.equals("2")){
		
		//2. ����ó���� ����ó��-------------------------------------------------------------------------------------------
		
		doc = d_db.getDocSettle(doc_no);
		
		String doc_step = "3";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
		out.println("����ó���� ����<br>");
		
		
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/cons_pur/consp_doc_frame.jsp?gubun1=3|gubun2=2";
		String sub 		= "���Ź�۷� ���� �ϰ�";
		String cont 		= "[���Ź�۾�ü: "+off_nm+", û������: "+req_dt+"] Ź�۷� ������ ���� �ϰ��ϴ� ��� �����ϼ���";
		String target_id 	= nm_db.getWorkAuthUser("��������ȸ�������");
		String m_url  = "/fms2/cons_pur/consp_doc_frame.jsp";
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getWork_id().equals("")) 	target_id = cs_bean.getWork_id();
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
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
		
		flag2 = cm_db.insertCoolMsg(msg);
	}
	
	
	
	if(msg_send_bit.equals("2")){
	
		doc = d_db.getDocSettle(doc_no);
		
		String sub 	= "���Ź�۷�û��";
		String cont 	= "[���Ź�۾�ü: "+off_nm+", û������: "+req_dt+"] Ź�۷�û�� ���縦 ��û�մϴ�.";
		String target_id = "";
		
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		
		String url = "/fms2/cons_pur/consp_doc_frame.jsp?gubun1=3|gubun2=1";
		String m_url = "/fms2/cons_pur/consp_doc_frame.jsp";
		UsersBean target_bean 	= umd.getUsersBean(doc.getUser_id2());
		sender_bean 		= umd.getUsersBean(doc.getUser_id1());
		
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
		
		flag2 = cm_db.insertCoolMsg(msg);		
		System.out.println("��޽���(Ź�۹�������)"+doc.getDoc_id()+"-----------------------"+target_bean.getUser_nm());		
	}
	%>
<script language='javascript'>
<%if(!flag1){%>	
	//alert('Ź�� ���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');					
<%}%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name="mode" 	value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
//	fm.submit();
	
	alert("���������� ó���Ǿ����ϴ�.");
	parent.opener.location.reload();
	parent.window.close();	
	
//	window.close();
//	opener.location.reload();
</script>
</body>
</html>