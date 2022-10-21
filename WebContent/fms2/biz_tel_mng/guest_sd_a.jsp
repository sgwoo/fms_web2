<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.common.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ page import="acar.estimate_mng.*, acar.coolmsg.*, acar.car_sche.*" %>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String est_id			= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String est_nm = request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
	String etc = request.getParameter("etc")==null?"":request.getParameter("etc");
	String est_st  = request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String est_agnt  = request.getParameter("est_agnt")==null?"":request.getParameter("est_agnt");
	String est_tel  = request.getParameter("est_tel")==null?"":request.getParameter("est_tel");
	String acar_id 		= request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	boolean flag6 = true;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	u_bean = umd.getUsersBean(user_id);
	
//System.out.println(cmd);	
	if(cmd.equals("one")){
		//����� �μ��� ���� �ش� ���� �޼��� �ޱ�
		String code_area = "";
	
		// �������� �޼��� �ޱ� ��û�� ���� ī��Ʈ
		Vector users = c_db.getUserList("", "", "MESSAGE1","Y"); 
		int user_size = users.size();
		
		// ��޽��� �˶� ���----------------------------------------------------------------------------------------

		String sub 		= "������û�� ���";
		String cont 	= "������û - "+u_bean.getBr_nm()+" - "+etc+" �� ���� ������û�� ��ϵǾ����ϴ�.";


		String url 		= "/fms2/guest_sd/guest_frame.jsp";
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";


		// �޴»�� ���̵� �˻��ؼ� �ݺ����ִ� �κ�

		if(user_size > 0){
			for(int i = 0 ; i < user_size ; i++){
				Hashtable user = (Hashtable)users.elementAt(i);
				xml_data += "    <TARGET>"+user.get("ID")+"</TARGET>";
			}
		}

		//�������
		xml_data += "    <SENDER>"+u_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
					"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";

		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		flag6 = cm_db.insertCoolMsg(msg);
		//System.out.println("(�����)-----------------------"+u_bean.getUser_nm());

		
		bean.setEst_id	(e_db.getNextEst_id_G("G"));//������û������ȣ ����
		bean.setEst_st	("3");
		bean.setEst_nm	(est_nm);
		bean.setEst_tel	(est_tel);
		bean.setEst_agnt(est_agnt);
		bean.setReg_id 	(user_id);
		bean.setEtc		(etc);

		count = e_db.insertEstiGst(bean);
	
	}else if(cmd.equals("two")){
	
		// �������� �޼��� �ޱ� ��û�� ���� ī��Ʈ
		Vector users = c_db.getUserList("", "", "MESSAGE","Y"); 
		int user_size = users.size();
		
		// ��޽��� �˶� ���----------------------------------------------------------------------------------------

		String sub 		= "������û�� ���";
		String cont 	= "������û - "+u_bean.getBr_nm()+" - "+etc+" �� ���� ������û�� ��ϵǾ����ϴ�.";


		String url 		= "/fms2/guest_sd/guest_frame.jsp";
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";


		// �޴»�� ���̵� �˻��ؼ� �ݺ����ִ� �κ�

		if(user_size > 0){
			for(int i = 0 ; i < user_size ; i++){
				Hashtable user = (Hashtable)users.elementAt(i);
				xml_data += "    <TARGET>"+user.get("ID")+"</TARGET>";
			}
		}

		//�������
		xml_data += "    <SENDER>"+u_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
					"    <FLDTYPE>1</FLDTYPE>"+
					"  </ALERTMSG>"+
					"</COOLMSG>";

		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		flag6 = cm_db.insertCoolMsg(msg);
		//System.out.println("(�����)-----------------------"+u_bean.getUser_nm());

	}
	


%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="POST" enctype="">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(cmd.equals("one")){
		if(count==1){%>
			alert("��û�Ǿ����ϴ�.");
			fm.action="guest_frame.jsp";  //���ΰ�ħ
			parent.window.close();
<%		}
	}else{%>
	alert("�����߻�!");
<%	}%>
//-->
</script>
</body>
</html>
