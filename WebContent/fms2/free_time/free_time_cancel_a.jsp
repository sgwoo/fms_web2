<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.free_time.*,  acar.car_sche.*, acar.coolmsg.*, acar.doc_settle.*"%>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="fc_bean" class="acar.free_time.Free_CancelBean" scope="page"/>
<jsp:useBean id="ft_bean" class="acar.free_time.Free_timeBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<%@ include file="/acar/cookies.jsp" %>
<%
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //�Ƿ���
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String doc_no 			= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String cancel_tit 	= request.getParameter("cancel_tit")==null?"":request.getParameter("cancel_tit");
	String cancel_cmt 	= request.getParameter("cancel_cmt")==null?"":request.getParameter("cancel_cmt");
	String cancel_dt 	= request.getParameter("cancel_dt")==null?"":request.getParameter("cancel_dt");
			
	
	String cancel 	= request.getParameter("cancel")==null?"":request.getParameter("cancel");
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String start_date = request.getParameter("start_date")==null?"":request.getParameter("start_date");
	String end_date = request.getParameter("end_date")==null?"":request.getParameter("end_date");
	
	int count = 0;
	
	int count2 = 0;
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
    boolean flag = true;
	   
	String target_id1 	= "";

	String target_id 	= "";
	String sender_id 	= "";
		
	String login_id 	= request.getParameter("login_id")==null?ck_acar_id:request.getParameter("login_id");	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(user_id);
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
			
			//����ǰ��
	DocSettleBean doc = new DocSettleBean();

	doc = d_db.getDocSettleOver_time("22", doc_no);
		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	if(sender_bean.getDept_id().equals("0001")  ) {  		// 
			target_id1 = "000028";						// Ÿ���� 000028 (������ ����-������)
	
	}else if( sender_bean.getDept_id().equals("0020")   ) { //���� ��ȹ
			target_id1 = "000005";	
		
	}else if( sender_bean.getDept_id().equals("0002") ||   sender_bean.getDept_id().equals("0014")  || sender_bean.getDept_id().equals("0015")  ) { //������
			target_id1 = "000026";
						
	}else if(sender_bean.getDept_id().equals("0013") ||sender_bean.getDept_id().equals("0009") ||sender_bean.getDept_id().equals("0012")  ||sender_bean.getDept_id().equals("0017")   ||sender_bean.getDept_id().equals("0018")  ) { //����
			if( sender_bean.getLoan_st().equals("1")){ //����
				target_id1 = "000026";
			}else { //����
				target_id1 = "000028";
			}
						
	}else if(sender_bean.getDept_id().equals("0003")) {
			target_id1 = "000004";
					
	}else if(sender_bean.getDept_id().equals("0005")) {
			target_id1 = "000237";
				
	}else if( sender_bean.getDept_id().equals("0007") ||  sender_bean.getDept_id().equals("0016")   ) {
			if(sender_bean.getUser_id().equals("000053")){
				target_id1 = "000004";
			}else{
				target_id1 = "000053";
			}
			
	}else if(sender_bean.getDept_id().equals("0008")) {
			if(sender_bean.getUser_id().equals("000052")){
				target_id1 = "000004";
			}else{
				target_id1 = "000052";
			}
	}else if(sender_bean.getDept_id().equals("0010")) {//�������� �� �ڿ������� , ����ȣ���� ������ �ѹ�����
			if(sender_bean.getUser_id().equals("000219")){
				target_id1 = "000004";
			}else{
				target_id1 = "000219";
			}
	}else if(sender_bean.getDept_id().equals("0011")) {		//�뱸���� ����Ź�븮, ����Ź�븮 ������ �ѹ�����
			if(sender_bean.getUser_id().equals("000054")){
				target_id1 = "000004";
			}else{
				target_id1 = "000054";
			}
	}
			
	
	CarScheBean cs_bean2 = c_sd.getCarScheTodayBean(target_id1);  	
					
			//������� ������ ���� skip 
	if(!cs_bean2.getWork_id().equals("")) target_id1 = "XXXXXX"; //����		
		

	if(cmd.equals("i")){
	
		fc_bean.setDoc_no(doc_no);
		fc_bean.setUser_id(user_id);
		fc_bean.setCancel_dt(cancel_dt);
		fc_bean.setCancel_tit(cancel_tit);
		fc_bean.setCancel_cmt(cancel_cmt);

		if (target_id1.equals("XXXXXX")) {
				fc_bean.setCm_check("Y");	//���忬����	
		}
			
		count = fsd.InsertCancelFree(fc_bean);

		ft_bean.setCancel(cancel);
		ft_bean.setUser_id(user_id);
		ft_bean.setDoc_no(doc_no);
		
		count2 = fsd.UpdateCancel(ft_bean);
		
		
		
		
//1. ����ó���� ���-------------------------------------------------------------------------------------------					
		
		String sub 		= "������� ��û ��� �ȳ�";
		String cont 	= "["+sender_bean.getUser_nm()+"]���� �ް� ��ҽ�û�� ���縦 ��û�մϴ�.";
						
		doc.setDoc_st("22");//������ҽ�û
		doc.setDoc_id(doc_no);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("�������");
		doc.setUser_nm2("�μ�����");		
		
		doc.setUser_id1(user_id);
		doc.setUser_id2(target_id1);		

		if (target_id1.equals("XXXXXX")) {
				doc.setDoc_bit("2");//���� skip
				doc.setDoc_step("3");//���			
		} else {
				doc.setDoc_bit("1");//���Ŵܰ�
				doc.setDoc_step("1");//���		
		}			
				
//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
						
		//����ó���� ��� ��	
		if (target_id1.equals("XXXXXX")) { //���忬���� ���� skip
		//	count2 = fsd.Cancel_free(user_id, start_date, end_date);  //���� ����						
			flag =  fsd.UpdateCancel_freetime(doc_no, user_id);
				
				
		}	
		
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
				
		//����� ���� ��ȸ				
		target_id = doc.getUser_id2();
			
		if (!target_id.equals("XXXXXX")) {	
			UsersBean target_bean 	= umd.getUsersBean(target_id);
		
			String url 		= "/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
	//		String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
			String m_url = "/fms2/free_time/free_time_frame.jsp";
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
			
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
			
			System.out.println("��޽���(������� ��û)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no );		
			
		    // �޽��� ��		
		}
		
			
		//��ü�ٹ�����
		Hashtable ht3= fsd.getFree_work(user_id, doc_no);
		
		if (!String.valueOf(ht3.get("W_ID")).equals("")) {	
			//������ü������ ������� �ȳ�
			UsersBean target_bean 	= umd.getUsersBean(String.valueOf(ht3.get("WORK_ID")));
	
			sub 		= "�ް����� ��� �ȳ�";
			cont 	= "["+sender_bean.getUser_nm()+"]���� �ް��� ��ҵǾ� ��ü�ٹ���("+target_bean.getUser_nm()+") ������ �ڵ���ҵǾ����ϴ�.";	
			String xml_data = "";
								
			xml_data = "";	
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL></URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>"; //�޴»��
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+	//�������
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
		}
		
		
		
	}else if(cmd.equals("c")){ //���� ����
		
	
	//	count2 = fsd.Cancel_free(user_id, start_date, end_date,);  //���� ����		
	
		flag =  fsd.UpdateCancel_freetime(doc_no, user_id);
		
		count = fsd.UpdateCancel_check(doc_no, user_id);
		
		
	//2. ����ó���� ����ó��-------------------------------------------------------------------------------------------
		
		login_id = doc.getUser_id2();
					
		flag1 = d_db.updateDocSettleOt2(doc_no, "2", "3", login_id, "22");			
		
		//3. ��޽��� �˶� ���----------------------------------------------------------------------------------------

	    target_id = doc.getUser_id1();			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		sender_id = doc.getUser_id2();			
		UsersBean sender_bean1 	= umd.getUsersBean(sender_id);
						
						
		String sub 		= "�ް� ��� ���� �ȳ�";
// 		String cont 	= "["+target_bean.getUser_nm()+"]���� �ް� ��ҽ�û���� ���簡 �Ϸ�Ǿ����ϴ�. Ȯ�ιٶ��ϴ�.";
		String cont 	= "["+target_bean.getUser_nm()+"]���� �ް� ��ҿ�û�� ����Ǿ����ϴ�.";
	//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
		String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
		String xml_data = "";
		String m_url = "/fms2/free_time/free_time_frame.jsp";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
	
		//�޴»��
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
		//�������
		xml_data += "    <SENDER>"+sender_bean1.getId()+"</SENDER>"+	
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
	
		System.out.println("(�ް���û��� ��� �ȳ�)----------------------- "+sender_bean1.getUser_nm() + "->" +target_bean.getUser_nm() + ":" + doc_no);
		
		
		
	
	// �޽��� ��

	
	}else if(cmd.equals("s_cm")){ //����� -> ������ �޼��� ������
			
		
	    target_id = doc.getUser_id2();			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		sender_id = doc.getUser_id1();			
		UsersBean sender_bean2 	= umd.getUsersBean(sender_id);
			
	//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		String sub 		= "������� ��û ��� �ȳ�";
		String cont 	= "["+sender_bean2.getUser_nm()+"]���� �ް� ��ҽ�û�� ���縦 ��û�մϴ�.";
	
		String url 		= "/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"&doc_no="+doc_no;
	//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_cancel_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"&doc_no="+doc_no;
		String m_url = "/fms2/free_time/free_time_frame.jsp";
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	
	
		//�޴»�� // �޴»�� ���̵� �˻��ؼ� �ݺ����ִ� �κ�
			
		
			//�޴»��
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
		//�������
		xml_data += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+	
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
			
		System.out.println("(������� ��û��)-----------------------"+sender_bean2.getUser_nm() + "->" +target_bean.getUser_nm() + " " + doc_no);
		count = 1;
		
	// �޽��� ��	
			
	}	
%>


<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<% if(cmd.equals("i")){
		if(count==1){
%>
		alert("���������� ��� ��û�Ǿ����ϴ�.");
		fm.action='free_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();					
				
<%	}

}else if(cmd.equals("c")){
		if(count2==1){
%>
		alert("����Ǿ����ϴ�.");
		fm.action='free_time_frame.jsp?s_width=<%=s_width%>&s_height=<%=s_height%>';
		fm.target='d_content';
		top.window.close();
		fm.submit();
				
<%	}
	
}else if(cmd.equals("s_cm")){
		if(count==1){
%>
		alert("�޼��� ������ �Ǿ����ϴ�.");
		fm.action='free_time_frame.jsp';
		fm.target='d_content';
		top.window.close();
		fm.submit();	
						
<%	}
}
%>
//-->
</script>

</body>
</html>