<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.coolmsg.*, acar.car_sche.* "%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	boolean flag1 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	

			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			String sub 		= "�ڵ�����ϿϷ�";
			String cont 	= "���� �ڵ�������� �Ϸ�Ǿ����ϴ�. Ȯ�ιٶ��ϴ�.";
			String target_id = nm_db.getWorkAuthUser("���纸����");
			
			
			CarScheBean cs_bean7 = csd.getCarScheTodayBean(target_id);
			if(!cs_bean7.getUser_id().equals("")){
				if(cs_bean7.getTitle().equals("��������")){
					//��Ͻð��� ����(12����)�̶�� ��ü��, �ƴϸ� ����
					target_id = nm_db.getWorkAuthUser("���纸����");
				}else if(cs_bean7.getTitle().equals("���Ĺ���")){
					//��Ͻð��� ����(12������)��� ��ü��, �ƴϸ� ����
					target_id = nm_db.getWorkAuthUser("��������");
				}else{//����
					target_id = nm_db.getWorkAuthUser("��������");
				}
			}
			
			//����� ���� ��ȸ
			UsersBean target_bean2 	= umd.getUsersBean(target_id);
			
			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
			xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			xml_data2 += "    <SENDER>"+umd.getSenderId(ck_acar_id)+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
			
			flag1 = cm_db.insertCoolMsg(msg2);
		
		
%>
<script language='javascript'>

<%	if(result>0){%>
		alert("ó������ �ʾҽ��ϴ�");
<%	}else{		%>		
		alert("ó���Ǿ����ϴ�");
<%	}			%>
</script>