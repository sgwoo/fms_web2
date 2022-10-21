<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.free_time.*, acar.res_search.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.schedule.* " %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String sch_chk 		= request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_mon 	= request.getParameter("start_mon")==null?"":request.getParameter("start_mon");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	String title 		= request.getParameter("title1")==null?"":request.getParameter("title1");
	String content 		= request.getParameter("content")==null?"":request.getParameter("content");
	String work_id 		= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	String ov_yn 		= request.getParameter("ov_yn")==null?"":request.getParameter("ov_yn");
	String sch_st 	= "";
	
	int count = 0;
	float f_remain = 0;
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
		
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String target_id1 	= "";
	
	int count = 0;
	float f_remain = 0;
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//�޴»�� �μ����� ��ȸ
	Vector users = c_db.getUserList(sender_bean.getDept_id(), "", "SCH_PRV","Y"); 
	int user_size = users.size();	
	
	CarScheBean cs_bean = new CarScheBean();
	
	//�������, �������� ���
	if(sch_chk.equals("1") || sch_chk.equals("2")){
						
		cs_bean.setStart_year	(start_year);
		cs_bean.setStart_mon	(AddUtil.addZero(start_mon));
		cs_bean.setStart_day	(AddUtil.addZero(start_day));
		cs_bean.setUser_id		(user_id);
		cs_bean.setSch_chk		(sch_chk);
		cs_bean.setTitle		(title);
		cs_bean.setContent		(content);
		cs_bean.setSch_kd		("2");//����
		cs_bean.setWork_id		(work_id);
		
		if(sender_bean.getLoan_st().equals("1")) 		cs_bean.setSch_st		("M");
		else if(sender_bean.getLoan_st().equals("2")) 	cs_bean.setSch_st		("B");
		else  											cs_bean.setSch_st		("G");
		
		count = c_sd.insertCarSche(cs_bean);
		
	//�ް����	
	}else{
		
		// 20181228 ���漱���� ��û
		// �Ŵ޼�, ����ö, ��ȫ��, ���, ���ֿ�, ��켮, ������, �̼���, ����Ź, ������, �ڿ��� ���� ���� �Ҽ��� �ƴҰ�� �ѹ������ ����
		if (sender_bean.getUser_id().equals("000051") || sender_bean.getUser_id().equals("000050") || 
			sender_bean.getUser_id().equals("000075") || sender_bean.getUser_id().equals("000011") || 
			sender_bean.getUser_id().equals("000010") || sender_bean.getUser_id().equals("000079") || 
			sender_bean.getUser_id().equals("000049") || sender_bean.getUser_id().equals("000219") || 
			sender_bean.getUser_id().equals("000054") || sender_bean.getUser_id().equals("000053") || 
			sender_bean.getUser_id().equals("000052")) {
			
			if (sender_bean.getDept_id().equals("0001")) {
				target_id1 = "000028";
			} else if (sender_bean.getDept_id().equals("0002")) {
				target_id1 = "000026";
			} else if (sender_bean.getDept_id().equals("0003")) {
				target_id1 = "000004";
			} else if (sender_bean.getDept_id().equals("0005")) {
				target_id1 = "000237";
			} else if (sender_bean.getDept_id().equals("0020")) {
				target_id1 = "000005";
			} else {
				target_id1 = "000004";
			}
			
		} else {		
			
			if(sender_bean.getDept_id().equals("0001")  ) {  		// �μ��ڵ尡 ������, ��������, ��õ
				target_id1 = "000028";						// Ÿ���� 000028 (������ ����-������)		
					
			}else if( sender_bean.getDept_id().equals("0020")   ) { //���� ��ȹ
				target_id1 = "000005";
							
			}else if( sender_bean.getDept_id().equals("0002") ||   sender_bean.getDept_id().equals("0014")  || sender_bean.getDept_id().equals("0015")  ) { //������
				target_id1 = "000026";
								
			}else if(sender_bean.getDept_id().equals("0013") ||sender_bean.getDept_id().equals("0009") ||sender_bean.getDept_id().equals("0012")  ||sender_bean.getDept_id().equals("0017")   ||sender_bean.getDept_id().equals("0018") ) { //����
				if( sender_bean.getLoan_st().equals("1") ){ //����
					target_id1 = "000026";
				}else { //����
					target_id1 = "000028";
				}
								
			}else if(sender_bean.getDept_id().equals("0003")) {
				target_id1 = "000004";
		
			}else if(sender_bean.getDept_id().equals("0005")) {  //it
				target_id1 = "000237";
		
			}else if( sender_bean.getDept_id().equals("0007") ||  sender_bean.getDept_id().equals("0016")   ) {
				/* if(sender_bean.getUser_id().equals("000053")){
					target_id1 = "000004";
				}else{
					target_id1 = "000053";
				} */
				target_id1 = "000053";
					
			}else if(sender_bean.getDept_id().equals("0008")) {
				/* if(sender_bean.getUser_id().equals("000052")){
					target_id1 = "000004";
				}else{
					target_id1 = "000052";
				} */
				target_id1 = "000052";
				
			}else if(sender_bean.getDept_id().equals("0010")) {//�������� �� �̼��� ->����, �̼��� ������ �ѹ����� 
				/* if(sender_bean.getUser_id().equals("000118")){
					target_id1 = "000052";
				}else{
					target_id1 = "000118";
				} */
				target_id1 = "000219";
						
			}else if(sender_bean.getDept_id().equals("0011")) {		//�뱸���� ����Ź�븮, ����Ź�븮 ������ �ѹ�����
				/* if(sender_bean.getUser_id().equals("000054")){
					target_id1 = "000004";
				}else{
					target_id1 = "000054";
				} */
				target_id1 = "000054";
				
			}
			
		}	
		
		CarScheBean cs_bean2 = c_sd.getCarScheTodayBean(target_id1);  	
		
		//������� ������ ���� skip 
		if(!cs_bean2.getWork_id().equals("")) target_id1 = "XXXXXX"; //����		
		title 		= request.getParameter("title1")==null?"":request.getParameter("title1");
		
		
		//���� �Ⱓ�� �ް�����ڸ� ������ü�ڷ� ������ �ٸ� �ް���ϰ��� �ִ��� üũ
			//	System.out.println("st_dt >> " + st_dt);
			//	System.out.println("end_dt >> " + end_dt);
			//	System.out.println("user_id >> " + user_id);
				Vector checkVt = fsd.getWork_idCheck(st_dt, end_dt, user_id);
				int checkVt_size = checkVt.size();
			//	System.out.println("checkVt_size >> " + checkVt_size);
				if(checkVt_size>0){
					System.out.println("��ü�ٹ��� ���� Ȯ��~~~~!!!!");
					String sub = "��ü�ٹ��� ���� Ȯ��";
					String cont = "#����# "+sender_bean.getUser_nm()+"���� ��û�� �ް� �Ⱓ���� ";					
					String xml_data = "";
					for(int i = 0; i < checkVt_size; i++){
						Hashtable ht = (Hashtable)checkVt.elementAt(i);
						
						String cont2 = cont+""+ ht.get("USER_NM") + "���� ��ü�ٹ��ڷ� ������ �Ⱓ�� ���ԵǾ� �ֽ��ϴ�.\n\n";
						
						cont2 += ht.get("USER_NM") + " (�ް��Ⱓ: "+ht.get("START_DATE")+" ~ "+ht.get("END_DATE")+") \n";
																		
						xml_data =  "<COOLMSG>"+
								"<ALERTMSG>"+
								"<BACKIMG>4</BACKIMG>"+
								"<MSGTYPE>104</MSGTYPE>"+
								"<SUB>"+sub+"</SUB>"+
								"<CONT>"+cont+"</CONT>"+
								"<URL></URL>"+
								"<TARGET>"+sender_bean.getId()+"</TARGET>"+
								"<SENDER></SENDER>"+	
								"    <MSGICON>10</MSGICON>"+
								"    <MSGSAVE>1</MSGSAVE>"+
								"    <LEAVEDMSG>1</LEAVEDMSG>"+
								"    <FLDTYPE>1</FLDTYPE>"+
								"  </ALERTMSG>"+
								"</COOLMSG>";
	
						CdAlertBean msg = new CdAlertBean();
						msg.setFlddata(xml_data);
						msg.setFldtype("1");
	
						boolean flag_check = cm_db.insertCoolMsg(msg);
					}
						
				}
		
				
		Free_timeBean ft_bean = new Free_timeBean();
		ft_bean.setUser_id		(user_id);
		ft_bean.setStart_date	(st_dt);
		ft_bean.setEnd_date		(end_dt);
		ft_bean.setSch_chk		(sch_chk);
		ft_bean.setTitle		(title);
		ft_bean.setContent		(content);
		ft_bean.setSch_kd		("2");
		ft_bean.setWork_id		(work_id);
		
		if(sender_bean.getLoan_st().equals("1")) 		ft_bean.setSch_st		("M");
		else if(sender_bean.getLoan_st().equals("2")) 	ft_bean.setSch_st		("B");
		else  											ft_bean.setSch_st		("G");
		
		if (target_id1.equals("XXXXXX")) {
			ft_bean.setCm_check("Y");	//���忬����	
		}
			
	  	if (  nm_db.getWorkAuthUser("�ܺΰ�����",user_id)   ) {   //�����ڴ� ������� 
	   			ft_bean.setCm_check("Y");	//���忬����	
		}
		
		String doc_no = fsd.InsertFree(ft_bean);  //doc_no�� free_time�� doc_no
		
		//�����ް��� ��� ps_box�� �ش� ���� ���� -20190515
		if (sch_chk.equals("9") ) {			
		 int t_cnt = fsd.tour_update(user_id, st_dt, end_dt );			
		}
				
		int use_days = 0;
		use_days = AddUtil.parseInt(rs_db.getDay(st_dt, end_dt));
		String dt = "";
		
		String save_dt = "";
		String s_remain = ""; 
		String due_dt = "";
		float use_cnt = 0;		
		float iw_cnt = 0;
		
		//�����ΰ�� �̿�ó��
		if (sch_chk.equals("3") ) {
			Hashtable  vmh  = fsd.getVacationMagam(user_id);
			
			save_dt =  String.valueOf(vmh.get("SAVE_DT")); 
			due_dt =  String.valueOf(vmh.get("DUE_DT")); 
			s_remain =  String.valueOf(vmh.get("REMAIN")); 
			
			if ( !due_dt.equals("") ) 		iw_cnt= fsd.getIwolUseCnt(user_id, save_dt , due_dt);  // �����Ⱓ�� ���� ���� �� sum 
			
			f_remain = AddUtil.parseFloat(s_remain) - iw_cnt ;  //�̿� ��������				
		}
		
		//free_time_item�� ������ �ѱ�	
		for(int i=0; i<use_days; i++){
			
			dt = rs_db.addDay(st_dt, i);
			
			String c_sysdate = "";
			
			c_sysdate = af_db.checkSunday(dt);
			if(!c_sysdate.equals(dt))	/* ����üũ�� ���ϵ� ��¥�� ������ ��¥�� �ٸ��ٸ� */
				continue;
			
			c_sysdate = af_db.checkHday(dt);
			if(!c_sysdate.equals(dt))	/* ����üũ�� ���ϵ� ��¥�� ������ ��¥�� �ٸ��ٸ� */
				continue;
			
			String setcount = "";
			if(title.equals("��������") || title.equals("��������") ){				
				setcount = "B1";	
				use_cnt = AddUtil.parseFloat("0.5");
			}else if(title.equals("���Ĺ���") || title.equals("���Ĺ���") ){
				setcount = "B2";	
				use_cnt = AddUtil.parseFloat("0.5");
			}else{
				setcount = "F";	
				use_cnt = 1;
			}
											
			flag1 = fsd.InsertFreeItem(doc_no, user_id, dt,setcount);
						
			//������Ͻ� �ٷ� sch_prv�� ��� 			
			ScheduleDatabase csd = ScheduleDatabase.getInstance();

			cs_bean.setStart_year	(dt.substring(0,4));
			cs_bean.setStart_mon	(dt.substring(4,6));
			cs_bean.setStart_day	(dt.substring(6,8));
			cs_bean.setUser_id(user_id);
			cs_bean.setTitle(title);
			cs_bean.setContent(content);
			cs_bean.setSch_kd("2");
			cs_bean.setSch_st(sch_st);
			cs_bean.setSch_chk(sch_chk);
			cs_bean.setWork_id(work_id);
			cs_bean.setDoc_no(doc_no);
			
			if (target_id1.equals("XXXXXX")) {
				cs_bean.setGj_ck("Y");  //���忬���� ���� skip
			} else {
				cs_bean.setGj_ck("N");  //������
			}
			
			cs_bean.setCount(setcount);
				
			if(title.equals("��������") || title.equals("��������")){			
				cs_bean.setContent(title);
			}else if(title.equals("���Ĺ���") || title.equals("���Ĺ���")){
				cs_bean.setContent(title);
			}else{
				cs_bean.setContent(content);
			}
			
//System.out.println("title: "+title);				
//System.out.println("cs_bean.setCount(: "+setcount);
			
//�̿�ǥ��
			cs_bean.setIwol	(""); //�⺻�� �ű� 
							
			if ( !due_dt.equals("")) { // �̿� �������� �ִٸ� 
				if (AddUtil.parseInt(dt) <= AddUtil.parseInt(due_dt) ) { //�̿������ϳ��� ����̶�� 
					 if ( f_remain > 0  ) {
						f_remain = f_remain - use_cnt; 						
						cs_bean.setIwol	("Y");
					 }
				}        					
			}        	
				
			count = csd.insertCarSche(cs_bean);		
		}
				
		//1. ����ó���� ���-------------------------------------------------------------------------------------------
		
		String sub 			= "�ް� ��û ��� �ȳ�";
		String cont 		= "["+sender_bean.getUser_nm()+"]���� �ް���û�� ���縦 ��û�մϴ�.";
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st	("21");//������û
		doc.setDoc_id	(doc_no);  //doc_id �� free_time�� doc_no
		doc.setSub		(sub);
		doc.setCont		(cont);
		doc.setEtc		("");
		doc.setUser_nm1	("��û��");
		doc.setUser_nm2	("�μ�����");
		doc.setUser_id1	(user_id);  	//��û��
		doc.setUser_id2	(target_id1);  	//������
		
		if (target_id1.equals("XXXXXX")) {
			doc.setDoc_bit("7");//���� skip
			doc.setDoc_step("3");//���			
		} else {
			doc.setDoc_bit("1");//���Ŵܰ�
			doc.setDoc_step("1");//���		
		}	
		
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
				
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
				
		//����� ���� ��ȸ
		String target_id = "";
				
		target_id = doc.getUser_id2();  //�μ�����
				
		if (!target_id.equals("XXXXXX")) {
					UsersBean target_bean 	= umd.getUsersBean(target_id);
				
			
					String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
				//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
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
		
			if (sch_chk.equals("9") ) {  //�����ް� Ȯ��  
				xml_data += "    <TARGET>2006007</TARGET>";
			}
		
			//������ �ڰ��ݸ��̸�  - �ڷγ� �ѽ��� 20220-311
			if (sch_chk.equals("7") && title.equals("�ڰ��ݸ�") ) {  // 
				xml_data += "    <TARGET>2010002</TARGET>";
				xml_data += "    <TARGET>2006007</TARGET>";
			}
			
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
			System.out.println("��޽��� smartphone(�ް���û)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no + target_bean.getUser_nm());
		
		}
		
		//������ü������ ���� ��Ͼȳ�
		if(!work_id.equals("")){
			
			UsersBean work_bean 	= umd.getUsersBean(work_id);
			
			sub 	= "������ü�� ��Ͼȳ�";
			cont 	= "["+sender_bean.getUser_nm()+"]���� �ް����� �Ⱓ ("+st_dt+"~"+end_dt+")�� "+work_bean.getUser_nm()+"���� ��ü�ٹ��ڷ� �����߽��ϴ�.";
			
			String xml_data = "";
			
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"<BACKIMG>4</BACKIMG>"+
		  				"<MSGTYPE>104</MSGTYPE>"+
		  				"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
		  				"<URL></URL>";
			
			//�޴»��
			xml_data += "    <TARGET>"+work_bean.getId()+"</TARGET>";
		
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
		}
		
		//�μ����� / ������ ����ġ �ش�μ������� �޼����� �˷��ֱ�.
		if (sender_bean.getId().equals("200002")||sender_bean.getId().equals("2000003")||sender_bean.getId().equals("2002010") ||sender_bean.getId().equals("2002011")||sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005")||sender_bean.getId().equals("2005006") ||sender_bean.getId().equals("2009006") ||sender_bean.getId().equals("2015001")) {//������ڰ� �ް���Ͻ� ���μ������� �޼��� ������.
				if(sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005")||sender_bean.getId().equals("2005006")||sender_bean.getId().equals("2009006")){
					sub 	= "������ �����ȳ�";
					cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() +"��  �ް��� ("+st_dt+"~"+end_dt+") ��û�߽��ϴ�.";				
				}else{
					sub 	= "�μ����� �����ȳ�";				
					cont 	= "["+sender_bean.getUser_nm()+"]������ �ް��� ("+st_dt+"~"+end_dt+") ��û�߽��ϴ�.";		
				}
				
				
				String url 	= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
				String m_url ="/fms2/free_time/free_time_frame.jsp";
				String xml_data = "";
					
					xml_data =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
				  				"<BACKIMG>4</BACKIMG>"+
				  				"<MSGTYPE>104</MSGTYPE>"+
				  				"<SUB>"+sub+"</SUB>"+
				  				"<CONT>"+cont+"</CONT>"+
				  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
				
					
					if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);
							xml_data += "    <TARGET>"+user.get("ID")+"</TARGET>";
						}
					}
				
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
					System.out.println("��޽���(���� �ް� ��û ���μ��������� ����.)-----------------------"+user_bean.getUser_nm() + "  " + doc_no);		
				// �޽��� ��
		 }
		
		if (sender_bean.getId().equals("2004005")) {//���¿���� �ް���û�� ���ֿ��븮���� ����
							
			sub 	= "���¿����� �����ȳ�";
			cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() + "��  �ް��� ("+st_dt+"~"+end_dt+")  ��û�߽��ϴ�.";		
			
						
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
		
			
				//�޴»��
			xml_data += "    <TARGET>2010003</TARGET>";
			
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
			System.out.println("��޽���(���¿���� �ް���û�� ���ֿ��븮���� ����.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
		// �޽��� ��
   		} 
		
		if (sender_bean.getId().equals("2010003")) {//���ֿ����� �ް���û�� ������������ ����
			
			sub 	= "���ֿ����� �����ȳ�";
			cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() + "�� �ް��� ("+st_dt+"~"+end_dt+")  ��û�߽��ϴ�.";		
			
						
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
			
				//�޴»��
			xml_data += "    <TARGET>2017009</TARGET>";
			
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
			System.out.println("��޽���(���¿���� �ް���û�� ���ֿ��븮���� ����.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
		// �޽��� ��
   		} 				
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
<%	if(count==1){%>
	alert("���������� ��ϵǾ����ϴ�.");
	parent.location.href = "/smart/main.jsp";
<%	}else{%>
	alert("�����߻�!!");
<%	}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
</body>
</html>