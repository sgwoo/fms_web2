<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.user_mng.*, acar.coolmsg.*, acar.doc_settle.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ page import="acar.schedule.*, acar.res_search.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ft_bean" class="acar.free_time.Free_timeBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	Free_timeDatabase ftd = Free_timeDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //�����Ƿ���
	String dept_id	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String br_id	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
		
//�ѹ����� ����	
	String cm_check = request.getParameter("cm_check")==null?"":request.getParameter("cm_check");
		
	int flag = 0;
			
	String  login_id = request.getParameter("login_id")==null?"":request.getParameter("login_id");  //�α��� id
	login_id = login.getCookieValue(request, "acar_id");
	
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	String target_id 	= "";
	String sender_id	= "";
	int count = 0;
	int count2 = 0;
	boolean flag6 = true;
	
	String req_id 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");

	String doc_st 	= request.getParameter("doc_st")==null?"21":request.getParameter("doc_st");
	String doc_step 	= request.getParameter("doc_step")==null?"":request.getParameter("doc_step");
	String user_id1 	= request.getParameter("user_id1")==null?"":request.getParameter("user_id1");
	String user_id2 	= request.getParameter("user_id2")==null?"":request.getParameter("user_id2");
	String user_id3 	= request.getParameter("user_id3")==null?"":request.getParameter("user_id3");
	String user_id4 	= request.getParameter("user_id4")==null?"":request.getParameter("user_id4");
	String user_id7 	= request.getParameter("user_id7")==null?"":request.getParameter("user_id7");
	String user_id8 	= request.getParameter("user_id8")==null?"":request.getParameter("user_id8");
	String user_id9 	= request.getParameter("user_id9")==null?"":request.getParameter("user_id9");
	String user_id10 	= request.getParameter("user_id10")==null?"":request.getParameter("user_id10");
	

	//����ǰ��
	DocSettleBean doc = new DocSettleBean();

	doc = d_db.getDocSettleOver_time("21", doc_no);	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	String sch_chk 	= request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String work_id 	= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	String sch_st 	= "";
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));	
		
	int use_days = 0;
	use_days = AddUtil.parseInt(rs_db.getDay(st_dt, end_dt));
	String dt = "";	

	if(cmd.equals("cm")){ // ���� ���
	
		ft_bean.setUser_id(user_id);
		ft_bean.setDoc_no(doc_no);
		ft_bean.setCm_check(cm_check);
		
		count = ftd.UpdateFreeCm_check(ft_bean);
			
		int user_su 	= request.getParameter("v3_size")==null?0:AddUtil.parseInt(request.getParameter("v3_size"));
		
		String value1[] = request.getParameterValues("free_dt");
		String value2[] = request.getParameterValues("ov_yn");
		String value3[] = request.getParameterValues("mt_yn");
	 
		int cnt = 0;
		
		if(user_su > 0){
			for(int i=0;i < user_su;i++){
				if(!value1[i].equals("")){
					FreetimeItemBean free_item = new FreetimeItemBean();
					free_item.setUser_id (user_id);
					free_item.setDoc_no	(doc_no);
					free_item.setFree_dt(value1[i]);
					free_item.setOv_yn(value2[i]);
					free_item.setMt_yn(value3[i]);
					
			//		System.out.println(" insa free_dt="+value1[i]+ ":ov_yn=" + value2[i] + ":mt_yn=" + value3[i] );
				  
					if(!ftd.updateFreeItem(free_item)) flag += 1;
					cnt ++;				
					
					
				}
			}
		}	
		
		//����� SCH_PRV�� ������ �ѱ�	
		for(int i=0;i < user_su;i++){
			if(!value1[i].equals("")){		
				ScheduleDatabase csd = ScheduleDatabase.getInstance();
				
				cs_bean.setStart_year	(value1[i].substring(0,4));
				cs_bean.setStart_mon	(value1[i].substring(5,7));
				cs_bean.setStart_day	(value1[i].substring(8,10));
				cs_bean.setUser_id		(user_id);
				cs_bean.setTitle		(title);
				cs_bean.setContent		(content);
				cs_bean.setSeq			(seq);
				cs_bean.setSch_kd		("2");
				cs_bean.setSch_st		(sch_st);
				cs_bean.setSch_chk		(sch_chk);
				cs_bean.setWork_id		(work_id);	
				cs_bean.setOv_yn		(value2[i]);
				cs_bean.setGj_ck		("Y");
				cs_bean.setDoc_no		(doc_no);
				
				count = csd.updateCarSche(cs_bean);
			}	
		}
	
	//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
	
	   	target_id = doc.getUser_id1();			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		sender_id = doc.getUser_id2();			
		UsersBean sender_bean 	= umd.getUsersBean(sender_id);
						
		String sub 		= "�ް� ��û ���� �ȳ�";
		String cont 	= "["+target_bean.getUser_nm()+"]���� �ް���û�� ����Ǿ����ϴ�.";
		String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
//		String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
		String xml_data = "";
		String m_url ="/fms2/free_time/free_time_frame.jsp";
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
	
		System.out.println("(�ް���û ��� �ȳ�)----------------------- "+sender_bean.getUser_nm() + "->" +target_bean.getUser_nm() + ":" + doc_no);
	
	// �޽��� ��
		
	//2. ����ó���� ����ó��-------------------------------------------------------------------------------------------
		
		flag1 = d_db.updateDocSettleOt2(doc_no, "7", "3", sender_id, "21");
				
	//	flag1 = d_db.updateDocSettleOt2(doc_no, "7", "3", login_id, "21");
		
		//������ ��� �ѹ����忡�� ����
		if ( user_id.equals("000005") || user_id.equals("000026") || user_id.equals("000028") || user_id.equals("000237")  ) {
		
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
	
			
		 	UsersBean target_bean1 	= umd.getUsersBean("000004");
					
			//�޴»��
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
		
			//�������
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+	
			 			"    <MSGICON>10</MSGICON>"+
		  				"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
		  				"</COOLMSG>";
		
			CdAlertBean msg1 = new CdAlertBean();
			msg1.setFlddata(xml_data);
			msg1.setFldtype("1");
		
			flag6 = cm_db.insertCoolMsg(msg1);
		
			System.out.println("(�ް���û ��� �ȳ�)����----------------------- "+sender_bean.getUser_nm() + "->" +target_bean1.getUser_nm() + ":" + doc_no);		
		
		}
		
		//����ް� �� ������ ��� �ѹ�����, ������ �ѹ����忡 �뺸, ����� �μ���
		if ( sch_chk.equals("4") ||  sch_chk.equals("8")||  sch_chk.equals("5")||  sch_chk.equals("9") ) {
		
				xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
				
				sender_id = doc.getUser_id1();			 			
				UsersBean sender_bean2 	= umd.getUsersBean(sender_id);
				
			 	UsersBean target_bean2 	= umd.getUsersBean("000004");
			 							
				//�޴»��
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			
				//�������
				xml_data += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+	
				 			"    <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
			
				CdAlertBean msg1 = new CdAlertBean();
				msg1.setFlddata(xml_data);
				msg1.setFldtype("1");
			
				flag6 = cm_db.insertCoolMsg(msg1);
			
				System.out.println("(�ް���û ��� �ȳ�) ���/����/����/����----------------------- "+sender_bean2.getUser_nm() + "->" +target_bean2.getUser_nm() + ":" + doc_no);		
								
		} 	
		
		count = 1;
		
	}else if(cmd.equals("d")){ //��û�� ����  -- ���糭���� ���� �Ұ�
		
		doc.setDoc_st("21");
		doc.setDoc_no(doc_no);
		flag2 = d_db.Free_deleteDocSettle("21", doc_no);
		
		count2 = ftd.Cancel_free(user_id, st_dt, end_dt, doc_no);  //���� ����
			
		ft_bean.setUser_id(user_id);
		ft_bean.setDoc_no(doc_no);
		count = ftd.Free_del(ft_bean);
		
		//������ü������ ���� ������ ��� �ȳ�
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		UsersBean target_bean 	= umd.getUsersBean(work_id);
	
		String sub 		= "�ް� ������ ��� �ȳ�";
		String cont 	= "["+sender_bean.getUser_nm()+"]���� �ް��� ��ҵǾ� ��ü�ٹ���("+target_bean.getUser_nm()+") ������ �ڵ���ҵǾ����ϴ�.";	
	
		String xml_data = "";
		
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
		
		count = 1;
					
		
	}else if(cmd.equals("s_cm")){ //����� -> ������ �޼��� ������
	//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
	
		sender_id = doc.getUser_id1();
		UsersBean sender_bean 	= umd.getUsersBean(sender_id);
	
		target_id = doc.getUser_id2();
		UsersBean target_bean 	= umd.getUsersBean(target_id);
	
		String sub 		= "�ް� ��û ��� �ȳ�";
		String cont 	= "["+sender_bean.getUser_nm()+"]���� �ް���û�� ���縦 ��û�մϴ�.";	
	
	
		String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
		String m_url ="/fms2/free_time/free_time_frame.jsp";
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
	
	//	System.out.println(xml_data);
		
		System.out.println("(�ޱ��û �����Ƿ�)-----------------------"+sender_bean.getUser_nm() + "->" +target_bean.getUser_nm() + " " + doc_no);
		count = 1;
		
	// �޽��� ��
	
	}else if(cmd.equals("s_mt")){ //����ó����� ����
	//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
	
		int user_su 	= request.getParameter("v3_size")==null?0:AddUtil.parseInt(request.getParameter("v3_size"));
		
		String value1[] = request.getParameterValues("free_dt");
		String value2[] = request.getParameterValues("ov_yn");
		String value3[] = request.getParameterValues("mt_yn");
	 
		int cnt = 0;
		
		if(user_su > 0){
			for(int i=0;i < user_su;i++){
				if(!value1[i].equals("")){
					FreetimeItemBean free_item = new FreetimeItemBean();
					free_item.setUser_id (user_id);
					free_item.setDoc_no	(doc_no);
					free_item.setFree_dt(value1[i]);
					free_item.setOv_yn(value2[i]);
					free_item.setMt_yn(value3[i]);
				  
				//    System.out.println(" team free_dt="+value1[i]+ ":ov_yn=" + value2[i] + ":mt_yn=" + value3[i] );
	
					if(!ftd.updateFreeItem(free_item)) flag += 1;
					cnt ++;				
					
					count = ftd.UpdSchPrvOv(user_id, value1[i],value2[i] );					
					
				}
			}
		}	
		
		count = 1;
		
	// �޽��� ��
	}else if(cmd.equals("iwol")){ //�����̿� ����
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		
			int user_su 	= request.getParameter("v3_size")==null?0:AddUtil.parseInt(request.getParameter("v3_size"));
			
			String value1[] = request.getParameterValues("free_dt");
			String value2[] = request.getParameterValues("iwol");	 
			int cnt = 0;
			
			if(user_su > 0){
				for(int i=0;i < user_su;i++){
					if(!value1[i].equals("")){
											
						count = ftd.UpdSchPrvIwol(user_id, value1[i],value2[i] );					
						
					}
				}
			}	
			
			count = 1;
			
		// �޽��� ��	
	}
%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>

<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<% if(cmd.equals("cm")){
	if(count==1){
	%>
	alert("����Ǿ����ϴ�.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("d")){
	if(count==1){
%>
	alert("���� �Ǿ����ϴ�.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();	
<%	}	
}else if(cmd.equals("s_cm")){
	if(count==1){
	%>
	alert("�޼��� ������ �Ǿ����ϴ�.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();	
						
<%	}

}else if(cmd.equals("s_mt")){
	if(count==1){
%>
	alert("����ó����� �����Ǿ����ϴ�.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();	

<%	}
	
}else if(cmd.equals("iwol")){
	if(count==1){
%>
	alert("�̿�ó�� �����Ǿ����ϴ�.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();	

<%	}
	
}
%>	
//-->
</script>
</body>
</html>
