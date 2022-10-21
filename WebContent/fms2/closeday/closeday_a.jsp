<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.closeday.*" %>
<%@ page import="acar.schedule.*, acar.res_search.*, acar.user_mng.*, acar.coolmsg.*, acar.doc_settle.*" %>
<jsp:useBean id="cd_bean" class="acar.closeday.CloseDayBean" scope="page"/>
<jsp:useBean id="doc" scope="page" class="acar.doc_settle.DocSettleBean"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
	
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String dept_id 	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	String start_year = request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_mon = request.getParameter("start_mon")==null?"":request.getParameter("start_mon");
	String start_day = request.getParameter("start_day")==null?"":request.getParameter("start_day");
	
	String closeday = request.getParameter("closeday")==null?"":request.getParameter("closeday");	
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");

	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");

	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
	
	String target_id1 	= "";
	String yday = start_year+""+start_mon+""+start_day;
	
	
	int count = 0;
	
	CloseDayDatabase cd_db = CloseDayDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
	if(cmd.equals("i")){	

			cd_bean.setUser_id		(user_id);
			cd_bean.setCloseday		(yday);
			cd_bean.setContent		(content);
									
			doc_no = cd_db.InputCloseDay(cd_bean);
					
			//1. ����ó���� ���-------------------------------------------------------------------------------------------
			
			String sub 		= "������ ȸ������� ���� �߽Ĵ� ��û";
			String cont 	= "["+sender_bean.getUser_nm()+"]���� ������ �߻��� ������ ���Ͽ� �߽Ĵ븦 ��û �Ͽ����ϴ�. Ȯ�ιٶ��ϴ�.";			
		
			doc.setDoc_st("23");//������ �߽Ĵ� ��û
			doc.setDoc_id(doc_no);
			doc.setSub(sub);
			doc.setCont(cont);
			doc.setEtc("");
			doc.setUser_nm1("�߽Ĵ��û");
			doc.setUser_nm2("����������");
			
			doc.setUser_id1(user_id);  //��û��
			doc.setUser_id2("000026");  //����������

	
			doc.setDoc_bit("1");//���Ŵܰ�
			doc.setDoc_step("1");//���
				
				
		//=====[doc_settle] insert=====
			flag1 = d_db.insertDocSettle(doc);
				
				
		//����ó���� ��� ��	
		
		
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
				
					//����� ���� ��ȸ
			String target_id = "000026";
				
			target_id = doc.getUser_id2();
				
			UsersBean target_bean 	= umd.getUsersBean(target_id);
		
			String url 		= "/fms2/closeday/closeday_c.jsp?user_id="+user_id+"|doc_no="+doc_no;
			String m_url  = "";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				//"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
							"<URL></URL>";
			
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
			
				flag6 = cm_db.insertCoolMsg(msg);
						
			System.out.println("��޽���(�߽Ĵ��û)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
			
		// �޽��� ��
					
	}else if(cmd.equals("u")){	
			
	}
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name='closeday' value='<%=closeday%>'>
<input type='hidden' name='content' value='<%=content%>'>


</form>
<script language="JavaScript">
<!--
	var fm = document.form1;

<% if(cmd.equals("i")){	
	if(!doc_no.equals("")){
%>
		alert("���������� ��ϵǾ����ϴ�.");
		fm.action='./closeday_frame.jsp';
		fm.target='d_content';
		top.window.close();
		fm.submit();					
<%}
	}else if(cmd.equals("u")){	
 		if(count==1){
%>
		alert("���������� �����Ǿ����ϴ�.");
		fm.action='./closeday_frame.jsp';
		fm.target='d_content';
		top.window.close();
		fm.submit();					
<%}
	}
else { %>
	alert("�����Դϴ�!!!!!!!!!!!!!!!");
<%}%>
//-->
</script>
</body>

</html>