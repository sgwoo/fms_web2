<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.common.*" %>
<%@ page import="acar.schedule.*, acar.res_search.*, acar.user_mng.*, acar.coolmsg.*,  acar.car_sche.*, acar.doc_settle.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="ft_bean" class="acar.free_time.Free_timeBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%	
	
	String ck_acar_id = request.getParameter("ck_acar_id")==null?"":request.getParameter("ck_acar_id");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
		
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //���������
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String title 	= request.getParameter("title1")==null?"":request.getParameter("title1");
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	String sch_chk 	= request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String work_id 	= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	String sch_kd 	= request.getParameter("sch_kd")==null?"":request.getParameter("sch_kd");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String sch_st 	= "";
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
	
	String target_id1 	= "";

	int count = 0;
	float f_remain = 0;
	
	Free_timeDatabase fsd = Free_timeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase c_sd = CarSchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
	Vector users = c_db.getUserList(sender_bean.getDept_id(), "", "SCH_PRV","Y"); 
	int user_size = users.size();
	
	// 20181228 ���漱���� ��û
	// �Ŵ޼�, ����ö, ��ȫ��, ���, ���ֿ�, ��켮, ������, ����, ����Ź, ������, �ڿ��� ���� ���� �Ҽ��� �ƴҰ�� �ѹ������ ����
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
			
		}else if(sender_bean.getDept_id().equals("0010")) {//�������� �� ���� , ���� ������ �ѹ�����
			/* if(sender_bean.getUser_id().equals("000118")){
				target_id1 = "000052";
			}else{
				target_id1 = "000118";
			} */
			target_id1 = "000219"; //����
					
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
					
	if(cmd.equals("i")){
		
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
						"<CONT>"+cont2+"</CONT>"+
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
			
			ft_bean.setUser_id		(user_id);
			ft_bean.setStart_date	(st_dt);
			ft_bean.setEnd_date		(end_dt);
			ft_bean.setTitle		(title);
			ft_bean.setContent		(content);
			ft_bean.setReg_dt		(reg_dt); 
			ft_bean.setSch_kd		("2");
			ft_bean.setSch_st		(sch_st);
			ft_bean.setSch_chk		(sch_chk);
			ft_bean.setWork_id		(work_id);
		
			
			if (target_id1.equals("XXXXXX")) {
				ft_bean.setCm_check("Y");	//���忬����	
			}
				
		   if (  nm_db.getWorkAuthUser("�ܺΰ�����",user_id)   ) {   //�����ڴ� ������� 
		   			ft_bean.setCm_check("Y");	//���忬����	
			}
			
			doc_no = fsd.InsertFree(ft_bean);  //doc_no�� free_time�� doc_no	
			
			
			//�����ް��� ��� ps_box�� �ش� ���� ���� -20190515
			if (sch_chk.equals("9") ) {
				//
			 int t_cnt = fsd.tour_update(user_id, st_dt, end_dt );
				
			}
				
			int use_days = 0;
			use_days = AddUtil.parseInt(rs_db.getDay(st_dt, end_dt));						
			String dt = "";
			String ov_yn = "";
			
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
				
				if(!dt.equals("20171002")){ //2017-10-02�� �ӽð����Ϸ� ����ó���Ѵ�.
					String c_sysdate = "";
					c_sysdate = af_db.checkSunday(dt);
					if(!c_sysdate.equals(dt))	/* ����üũ�� ���ϵ� ��¥�� ������ ��¥�� �ٸ��ٸ� */
						continue;
					
					c_sysdate = af_db.checkHday(dt);
					if(!c_sysdate.equals(dt))	/* ����üũ�� ���ϵ� ��¥�� ������ ��¥�� �ٸ��ٸ� */
						continue;
				}
				
				String setcount = "";
				if(title.equals("��������") || title.equals("��������") ){				
					setcount = "B1";	
					use_cnt = AddUtil.parseFloat("0.5");
				}else if(title.equals("���Ĺ���") || title.equals("���Ĺ���")){
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
				cs_bean.setUser_id		(user_id);
				cs_bean.setTitle		(title);
				cs_bean.setContent		(content);
				cs_bean.setSch_kd		("2");
				cs_bean.setSch_st		(sch_st);
				cs_bean.setSch_chk		(sch_chk);
				cs_bean.setWork_id		(work_id);
				cs_bean.setDoc_no		(doc_no);
				cs_bean.setCount		(setcount);
				
				if (target_id1.equals("XXXXXX")) {
					cs_bean.setGj_ck("Y");  //���忬���� ���� skip
				} else {
					cs_bean.setGj_ck("N");  //������
				}
				
				if(title.equals("��������") || title.equals("��������")){			
					cs_bean.setContent(title);
				}else if(title.equals("���Ĺ���") || title.equals("���Ĺ���")){
					cs_bean.setContent(title);
				}
								
				//�̿�ǥ��
				cs_bean.setIwol	(""); //�⺻�� �ű� 
								
				if ( !due_dt.equals("")) { // �̿� �������� �ִٸ� 
					if (AddUtil.parseInt(dt) <= AddUtil.parseInt(due_dt) ) { //�̿������ϳ��� ����̶�� 
						 if ( f_remain > 0  ) {
							f_remain = f_remain - use_cnt; 	//0.5 -1 
							 if ( f_remain >= 0  ) {
								cs_bean.setIwol	("Y");
							 }
						 }
					}        					
				}        	
				
				count = csd.insertCarSche(cs_bean);			
			}	 
					
			//1. ����ó���� ���-------------------------------------------------------------------------------------------
			
			String sub 		= "�ް� ��û ��� �ȳ�";
			String cont 	= "["+sender_bean.getUser_nm()+"] ���� �ް���û�� ���縦 ��û�մϴ�.";			
															
			DocSettleBean doc = new DocSettleBean();
			doc.setDoc_st("21");//�ް���û
			doc.setDoc_id(doc_no);  //doc_id �� free_time�� doc_no
			doc.setSub(sub);
			doc.setCont(cont);
			doc.setEtc("");
			doc.setUser_nm1("��û��");
			doc.setUser_nm2("�μ�����");				
			
			doc.setUser_id1(user_id);  //��û��
			doc.setUser_id2(target_id1);  //������	
	
			if (target_id1.equals("XXXXXX")) {
				doc.setDoc_bit("7");//���� skip
				doc.setDoc_step("3");//���			
			} else {
				doc.setDoc_bit("1");//���Ŵܰ�
				doc.setDoc_step("1");//���		
			}			
			
			//=====[doc_settle] insert=====
			flag1 = d_db.insertDocSettle(doc);				
				
			//����ó���� ��� ��				
		
			//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
				
			//����� ���� ��ȸ
			String target_id = "";
				
			target_id = doc.getUser_id2();  //�μ�����
				
			if (!target_id.equals("XXXXXX")) {
					UsersBean target_bean 	= umd.getUsersBean(target_id);
			
					String url 		= "/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
					String m_url 	= "/fms2/free_time/free_time_frame.jsp";
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
								
					System.out.println("��޽���(�ް���û)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no + " " +target_bean.getUser_nm());		
					
					// �޽��� ��				
				
				//�μ����� ���� �н��ص�, �ѹ����忡�� �뺸 
				//����ް� �� ������ ��� �ѹ�����, ������ �ѹ����忡 �뺸, ����� �μ���
				/*
				if ( sch_chk.equals("4") ||  sch_chk.equals("8")||  sch_chk.equals("5")||  sch_chk.equals("9") ) {
				
						xml_data =  "<COOLMSG>"+
								"<ALERTMSG>"+
								"<BACKIMG>4</BACKIMG>"+
								"<MSGTYPE>104</MSGTYPE>"+
								"<SUB>"+sub+"</SUB>"+
								"<CONT>"+cont+"</CONT>"+
								"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
				
						
						String sender_id = doc.getUser_id1();			 			
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
										
				}*/ 		
		
		   }
			
			//������ü������ ���� ��Ͼȳ�
			if(!work_id.equals("")){
				
				UsersBean work_bean 	= umd.getUsersBean(work_id);
				
				sub 	= "������ü�� ��Ͼȳ�";
				cont 	= "["+sender_bean.getUser_nm()+"]����  �ް����� �Ⱓ ("+st_dt+"~"+end_dt+")�� "+work_bean.getUser_nm()+"���� ��ü�ٹ��ڷ� �����߽��ϴ�.";
				
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
						
		   if (sender_bean.getId().equals("2000002")||sender_bean.getId().equals("2000003")||sender_bean.getId().equals("2002010") ||sender_bean.getId().equals("2002011")||sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005")||sender_bean.getId().equals("2005006")||sender_bean.getId().equals("2013011")||sender_bean.getId().equals("2015001")) {//������ڰ� �ް���Ͻ� ���μ������� �޼��� ������.
				if(sender_bean.getId().equals("2005004")||sender_bean.getId().equals("2005005") ||sender_bean.getId().equals("2005006")||sender_bean.getId().equals("2013011") ){
					sub 	= "������ �����ȳ�";
					cont 	= "["+sender_bean.getUser_nm()+"]"+ sender_bean.getUser_pos() +"��  �ް��� ("+st_dt+"~"+end_dt+") ��û�߽��ϴ�.";			
				}else{
					sub 	= "�μ����� �����ȳ�";
					cont 	= "["+sender_bean.getUser_nm()+"]������ �ް��� ("+st_dt+"~"+end_dt+") ��û�߽��ϴ�.";		
				}
												
				//	String url 		= "http://fms1.amazoncar.co.kr/fms2/free_time/free_time_c.jsp?s_width="+s_width+"|s_height="+s_height+"|user_id="+user_id+"|doc_no="+doc_no;
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
					//xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					
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
					System.out.println("��޽���(���� �ް� ��û ���μ��������� ����.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
				// �޽��� ��
		   }
		   
		if (sender_bean.getId().equals("2004005")) {//���¿����� �ް���û�� ���ֿ����忡�� ����
	
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
					System.out.println("��޽���(���¿����� �ް���û�� ���ֿ����忡�� ����.)-----------------------"+sender_bean.getUser_nm() + "  " + doc_no);		
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
		// �޽��� ��
       } 		
					
	}else if(cmd.equals("u")){	
			
			ft_bean.setUser_id		(user_id);
			ft_bean.setDoc_no		(doc_no);
			ft_bean.setStart_date	(st_dt);
			ft_bean.setEnd_date		(end_dt);
			ft_bean.setTitle		(title);
			ft_bean.setContent		(content);
			ft_bean.setReg_dt		(reg_dt); 
			ft_bean.setSch_kd		("2");
			ft_bean.setSch_st		(sch_st);
			ft_bean.setSch_chk		(sch_chk);
			ft_bean.setWork_id		(work_id);

			count = fsd.UpdateFree(ft_bean);			
	}
%>
<html>
<head>
<title>FMS</title>

</head>
<script language="JavaScript">
<!--
	function go_parent(){
		var fm = document.form1;
		fm.action = "./free_time_frame.jsp";
		fm.target = "d_content";
		
		<%if(go_url.equals("homework_sh.jsp")){%>
		<%}else{%>
		fm.submit();
		<%}%>
	}

	function go_parent_list(){
		var fm = document.form1;
		fm.action = "./free_time_frame.jsp";
		fm.target='d_content';
		<%if(go_url.equals("homework_sh.jsp")){%>
		<%}else{%>
		fm.submit();
		<%}%>
	}

//-->
</script>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name='start_date' value='<%=st_dt%>'>
<input type='hidden' name='end_date' value='<%=end_dt%>'>
<input type='hidden' name='title' value='<%=title%>'>
<input type='hidden' name='content' value='<%=content%>'>
<input type='hidden' name='sch_kd' value='<%=sch_kd%>'>
<input type='hidden' name='sch_st' value='<%=sch_st%>'>
<input type='hidden' name='sch_chk' value='<%=sch_chk%>'>
<input type='hidden' name='work_id' value='<%=work_id%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

</form>
<script language="JavaScript">
<!--
	var fm = document.form1;

<% if(cmd.equals("i")){	
	if(!doc_no.equals("")){
%>
		alert("���������� ��ϵǾ����ϴ�.");
		go_parent_list();
		parent.close();	
<%}
	}else if(cmd.equals("u")){	
 		if(count==1){
%>
		alert("���������� �����Ǿ����ϴ�.");
		go_parent_list();
		parent.close();					
<%}
	}
else { %>
	alert("�����Դϴ�!!!!!!!!!!!!!!!");
<%}%>
//-->
</script>
</body>

</html>
