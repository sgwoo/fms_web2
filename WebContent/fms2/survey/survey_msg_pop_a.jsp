<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.call.*, acar.util.*, acar.coolmsg.*, acar.client.*, acar.car_mst.*, acar.user_mng.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String memo = request.getParameter("memo")==null?"":request.getParameter("memo");
	
	boolean flag21 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	UsersBean sender_bean = umd.getUsersBean(user_id);
	CdAlertBean msg1 = new CdAlertBean();
			
	ContBaseBean base = a_db.getContBaseHi(m_id, l_cd);
	//�����������
	Hashtable car_fee 	= a_db.getCarRegFee(m_id, l_cd);	
	String car_no = (String)car_fee.get("CAR_NO");
		
	//������
	ClientBean client 		= al_db.getClient(base.getClient_id());

	String sub = "[��೻�� Ȯ��] ���";
	String cont 	= "[" + l_cd+ " " + client.getFirm_nm() + " " + car_no  + "] ���� �����Ͽ� " +memo+ " Ȯ�� �ٶ��ϴ�.";
	
	if (cmd.equals("cont")) {
		String url = "/fms2/survey/call_cond_frame.jsp";
	} else if (cmd.equals("accident")) {
		String url = "/fms2/survey/call_accident_s_frame.jsp";
	} else if (cmd.equals("service")) {
		String url = "/fms2/survey/call_car_service_frame.jsp";
	}
	
	String xml_data = "";	
	
	xml_data = "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";				 
	
	if (cmd.equals("cont")) {
		xml_data += "     <TARGET>2002011</TARGET>"; //��������
	} else {
		xml_data += "   <TARGET>2002010</TARGET>"; //����������
	}
	
//	xml_data += "     <TARGET>2000001</TARGET>"; //��ǥ�̻�
	
	xml_data += "     <SENDER>"+sender_bean.getId()+"</SENDER>"+
					"    <MSGICON>10</MSGICON>"+
					"    <MSGSAVE>1</MSGSAVE>"+
					"    <LEAVEDMSG>1</LEAVEDMSG>"+
					"    <FLDTYPE>1</FLDTYPE>"+
					"</ALERTMSG>"+
					"</COOLMSG>";
	
	msg1.setFlddata(xml_data);
	msg1.setFldtype("1");
	
	flag21 = cm_db.insertCoolMsg(msg1);
		
	//��ǥ�̻��� ��� ����/�� ���� ���� ��û  - 20191028 
	int i_msglen = AddUtil.lengthb(cont);
		
	String msg_type = "0";		
				//80�̻��̸� �幮��
	if(i_msglen>80) msg_type = "5";
				
	IssueDb.insertsendMail(sender_bean.getUser_m_tel(), sender_bean.getUser_nm(),  "01054758080", "��ǥ�̻�", "", "", cont);			
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript'>
	alert("���������� �߼۵Ǿ����ϴ�.");
	self.close();
</script>
</body>
</html>