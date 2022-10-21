<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.memo.*, acar.coolmsg.*, acar.user_mng.*, tax.*, acar.car_sche.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<!-- ���ڹ߼� ���� �бⰡ ���� ../acar/memo/memo_send_mini_a.jsp �ҽ� ������� ���� �ۼ�.(20180717)-->
<!-- ����������� �������� ���� ������ �� ����ڿ��� �޽����߼� -->

<html>
<head><title>FMS</title></head>
<body>
<%
	String title 			= request.getParameter("title")==null?"":request.getParameter("title");
	String content 			= request.getParameter("content")==null?"":request.getParameter("content");
	String rece_id 			= request.getParameter("rece_id")==null?"":request.getParameter("rece_id");
	String send_id 			= request.getParameter("send_id")==null?"":request.getParameter("send_id");
	String send_phone 		= request.getParameter("send_phone")==null?"":request.getParameter("send_phone");
	String add_user_yn 		= request.getParameter("add_user_yn")==null?"":request.getParameter("add_user_yn");
	String send_st 			= request.getParameter("send_st")==null?"":request.getParameter("send_st");
	
	String agent_emp_nm 	= request.getParameter("agent_emp_nm")==null?"":request.getParameter("agent_emp_nm");
	String agent_emp_m_tel 	= request.getParameter("agent_emp_m_tel")==null?"":request.getParameter("agent_emp_m_tel");
		
	String flag = "";
	boolean flag3 = true;
	boolean flag_arrival_dt = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//����� ���� ��ȸ
	UsersBean target_bean 	= umd.getUsersBean(rece_id);
	UsersBean sender_bean 	= umd.getUsersBean(send_id);
	
	//���ں�����
	content = content + " -"+sender_bean.getUser_nm()+"-";
	int i_msglen = AddUtil.lengthb(content);
	String msg_type = "0";
	
	//80�̻��̸� �幮��
	if(i_msglen>80) msg_type = "5";
	
	if(send_phone.equals("")){
		send_phone = sender_bean.getUser_m_tel();
		if(!sender_bean.getHot_tel().equals("")){
			send_phone = sender_bean.getHot_tel();
		}
	}
	
	//������Ʈ ��������ڰ� ������ ���������
	if(!agent_emp_nm.equals("") && !agent_emp_m_tel.equals("")){
		
		at_db.sendMessage(1009, "0", content, agent_emp_m_tel, send_phone, null, agent_emp_nm, send_id);
	//���ʿ�����	
	}else{
			
		at_db.sendMessage(1009, "0", content, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), send_id);
	}
	
	//�޽���������(������Ʈ ����� ��� ������Ʈ ��������ڿ��� �޽���)(���ڼ۽Ŵ�󿡰� �޽����� �����°� �ƴ�!)
	if(!send_st.equals("1")){
		String title2 = "����������� �������� ���ڹ߼�";
		String content2 = title + " &lt;br&gt; &lt;br&gt; " + content;
		content2 += " &lt;br&gt; &lt;br&gt; ---------------------------------------- &lt;br&gt; &lt;br&gt; " +
				    "��� ����� ���� " + agent_emp_nm + " �� ���� ���ڸ� �߼��Ͽ����ϴ�. &lt;br&gt; &lt;br&gt; "+
				    "������ �����Ͻñ� �ٶ��ϴ�.";
		
		String xml_data = "";
			
		xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	 					"    <BACKIMG>4</BACKIMG>"+
	 					"    <MSGTYPE>104</MSGTYPE>"+
	 					"    <SUB>"+title2+"</SUB>"+
	  				"    <CONT>"+content2+"</CONT>"+
						"    <URL></URL>";
		xml_data += "    <TARGET>"+sender_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
	 					"    <MSGICON>10</MSGICON>"+
	 					"    <MSGSAVE>1</MSGSAVE>"+
	 					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	 					"  </ALERTMSG>"+
	 					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag3 = cm_db.insertCoolMsg(msg);
		
		if(!flag3){
			flag = "error";
		}
	}

%>
<script language='javascript'>
<%	if(flag.equals("error")){%>		
		alert('�����߻�!');
		parent.location='about:blank';
<%	}else if(flag_arrival_dt == false){%>		
		alert('�����ð� ��� ����!');
		parent.location='about:blank';
<%	}else{%>
	<!--	alert('ó���߽��ϴ�.'); -->
		parent.window.close();
<%	}%>
</script>
</body>
</html>
