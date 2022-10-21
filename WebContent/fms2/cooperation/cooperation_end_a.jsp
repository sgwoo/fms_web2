<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.cooperation.*, acar.coolmsg.*, acar.im_email.*, tax.*, acar.cont.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>

<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	CooperationDatabase cp_db = CooperationDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	int seq 			= request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String out_content 	= request.getParameter("out_content")==null?"":request.getParameter("out_content");
	String title	 	= request.getParameter("title")==null?"":request.getParameter("title");
	String content 		= request.getParameter("content")==null?"":request.getParameter("content");
	String agnt_nm 		= request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm");
	String agnt_m_tel	= request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel");
	String agnt_email	= request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email");
	String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sender_id = "";
	String target_id = "";

	String sub 		= "";
	String cont 	= "";
	String url 		= "";
	String m_url 	= "";
	String xml_data 		= "";
	
	int count = 0;
	int flag = 0;
	boolean flag6 = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	cp_bean = cp_db.getCooperationBean(seq);
	
	cp_bean.setTitle		(title);
	cp_bean.setContent		(content);
	
	cp_bean.setOut_content	(out_content);
	cp_bean.setAgnt_nm		(agnt_nm);
	cp_bean.setAgnt_m_tel	(agnt_m_tel);
	cp_bean.setAgnt_email	(agnt_email);
	
	count = cp_db.updateOutdt(cp_bean);
			
	sender_id = cp_bean.getSub_id();
	target_id = cp_bean.getCom_id();
	
	//if(sender_id.equals("")) sender_id = cp_bean.getOut_id();//������(���������)�� ������ ������(�����μ���)���� �޼��� �߼�
	
	UsersBean sender_bean 	= umd.getUsersBean(sender_id);
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	if (from_page.equals("/fms2/cooperation/cooperation_n_sc.jsp")) {
		
		//title�� ����ȣ ����
		String l_cd = cp_bean.getTitle().substring(10,23);
		
		//������ ����ȣ�� ������� ��ȸ
		Hashtable cont2 = a_db.getContCase(l_cd);
		Hashtable cont3 = a_db.getContViewCase(String.valueOf(cont2.get("RENT_MNG_ID")), String.valueOf(cont2.get("RENT_L_CD")));
		
		//������
		String customer_name = String.valueOf(cont3.get("FIRM_NM"));
		String car_num = String.valueOf(cont3.get("CAR_NO"));
		String car_name = String.valueOf(cont3.get("CAR_NM"));
				
		//���ڼ��� : �� �����
		Hashtable sms = c_db.getDmailSms(String.valueOf(cont2.get("RENT_MNG_ID")), l_cd, "1");
		String s_destphone = String.valueOf(sms.get("TEL"))==null?"":String.valueOf(sms.get("TEL"));		
		
		UsersBean bus2_bean 	= umd.getUsersBean(String.valueOf(cont2.get("BUS_ID2")));
		String bus2_id = String.valueOf(cont2.get("BUS_ID2"));
		
		List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, bus2_bean.getUser_nm(), bus2_bean.getUser_m_tel());
		at_db.sendMessageReserve("acar0210", fieldList, s_destphone, bus2_bean.getUser_m_tel(), null , l_cd, bus2_id);
	}
	
		
	if (from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")) {
		sub 		= "FMS�������� ó���Ϸ�";
		cont 	= "["+sender_bean.getUser_nm()+"]���� ["+target_bean.getUser_nm()+"]�Բ��� ��û�Ͻ� '"+cp_bean.getTitle()+"'�� ���� FMS�������� ó���� �Ϸ��Ͽ����ϴ�. Ȯ�ιٶ��ϴ�.";
		url 		= "/fms2/cooperation/cooperation_it_frame.jsp";
		m_url  = "/fms2/cooperation/cooperation_it_frame.jsp";
		xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
//		flag6 = cm_db.insertCoolMsg(msg);
		
	} else {
	
		sub 		= "�������� ó���Ϸ� ���";
		cont 	= "["+sender_bean.getUser_nm()+"]���� ���������� ó���Ϸ� �ϼ̽��ϴ�. Ȯ�ιٶ��ϴ�.";
		url 		= "/fms2/cooperation/cooperation_frame.jsp";
			
		if ( from_page.equals("/fms2/cooperation/cooperation_p_sc.jsp") ) {
			 sub 		= "������湮���� ó���Ϸ� ���";
			 cont 	= "["+sender_bean.getUser_nm()+"]���� ���������� ó���Ϸ� �ϼ̽��ϴ�. Ȯ�ιٶ��ϴ�.";
			 url 		= "/fms2/cooperation/cooperation_p_frame.jsp";
		} 
		
		if(from_page.equals("/fms2/cooperation/cooperation_n_frame.jsp")){
			sub 		= "��������߱� �������� ó���Ϸ� ���";
			cont 		= ""+sender_bean.getUser_nm()+"���� ["+title+"] ���������� ó���Ϸ� �ϼ̽��ϴ�.";
			url 		= "/fms2/cooperation/cooperation_n_frame.jsp";
		}
		
		if(from_page.equals("lc_n_memo.jsp")){
			sub 		= "�����⼭�� �������� ó���Ϸ� ���";
			cont 		= ""+sender_bean.getUser_nm()+"���� ["+title+"] ���������� ó���Ϸ� �ϼ̽��ϴ�.";
			url 		= "";
		}
				
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  			//	"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	  				"<URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		if(!cp_bean.getTitle().equals("") && cp_bean.getTitle().contains("[�����ؽ�ƼĿ��߱޿�û]")){
			sub 		= "[�����ؽ�ƼĿ ��û] �������� ó���Ϸ� ���";
			cont 	= cp_bean.getTitle()+ " �����ؽ�ƼĿ ��û���� �߱�/�߼� �Ǿ����ϴ�.\n\n";
			cont 	+= cp_bean.getContent();
			url 		= "/fms2/cooperation/cooperation_frame.jsp";
			
			/*������ �϶��� �޼��� ����  */
				xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  			//	"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	  				"<URL></URL>";
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
				
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
				
				
			flag6 = cm_db.insertCoolMsg(msg);
		}
	}
	
	//����û�� ��� �Ϸ���� �߼�
	if(cp_bean.getReq_st().equals("2") && from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){
		
		if(!agnt_email.equals("")){
		
			//	1. d-mail ���-------------------------------
			
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(firm_nm+"��, �Ƹ���ī�� ��û�Ͻ� ������ �Ϸ�Ǿ����ϴ�.");
			d_bean.setSql				("SSV:"+agnt_email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
			d_bean.setMailto			("\""+firm_nm+"\"<"+agnt_email.trim()+">");
			d_bean.setReplyto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
			d_bean.setErrosto			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				(seq+"cooperation");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin����
			d_bean.setG_idx				(1);//admin����
			d_bean.setMsgflag     		(0);
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ask/re_ask.jsp?seq="+seq);
			d_bean.setGubun2			(cp_bean.getClient_id());
			if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
			
		}
		
		if(!agnt_m_tel.equals("")){
		
			String msg_body = firm_nm+"��, �Ƹ���ī�� ��û�Ͻ� ������ �Ϸ�Ǿ����ϴ�.";
			IssueDb.insertsendMail_V5_H("02-757-0802", "(��)�Ƹ���ī", agnt_m_tel, agnt_nm, "", "", "0", "", msg_body, "", cp_bean.getClient_id(), ck_acar_id, "4");
		}
	}
%>


<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_year' 	value='<%=s_year%>'>
  <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
  <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
  <input type='hidden' name='gubun1'	value='<%=gubun1%>'>    
  <input type='hidden' name='gubun2'	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3'	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4'	value='<%=gubun4%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  <input type='hidden' name='from_page' value='<%=from_page%>'>           
  <input type='hidden' name='seq' 		value='<%=seq%>'>             
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<%	if(count>0){%>
		alert("���������� ó���Ǿ����ϴ�.");		
		fm.action='cooperation_u.jsp';	
		fm.target='COOPERATION';
		fm.submit();	
		//parent.window.close();		
		
		<%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>
		fm.action = 'cooperation_c_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
		//parent.opener.location.href = "cooperation_c_sc.jsp";	
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_n_sc.jsp")){%>
		fm.action = 'cooperation_n_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
		//parent.opener.location.href = "cooperation_n_sc.jsp";	
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_p_sc.jsp")){%>
		fm.action = 'cooperation_p_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
		//parent.opener.location.href = "cooperation_n_sc.jsp";
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>
		fm.action = 'cooperation_it_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
		<%}else{%>
		fm.action = 'cooperation_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
		//parent.opener.location.href = "cooperation_sc.jsp";	
		<%}%>
		
<%	}else{%>
		alert("�����߻�!!");
<%	}%>
//-->
</script>

</body>
</html>