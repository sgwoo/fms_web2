<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.credit.*, acar.insur.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*,acar.offls_sui.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="sui_db" scope="page" class="acar.offls_sui.Offls_suiDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st"); //�����뿩 
	
	String from_page 	= "";
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String reg_id 	= request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");	
	String cool 	= request.getParameter("cool")==null?"":request.getParameter("cool");	 //����Ʈ�ΰ�� �޼��� ������ üũ
	int   fdft_amt2 =   request.getParameter("fdft_amt2")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt2"));	 //����Ʈ�ΰ�� �޼��� ������ üũ 
	String rt	= request.getParameter("rt")==null?"":request.getParameter("rt");	 //real time
			
	String rt_s = "";
	if (rt.equals("Y")) {
		rt_s = " [���] ";
	}
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int result = 0;
	
	int flag =0;
	
	String doc_step  = "";
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();

				
		//�����Ƿ�����
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
		
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {  //����Ʈ������ ���
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}

	
	int cnt = 0;
	cnt = ac_db.countDocSettleCls(rent_l_cd);
	
	//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	//���������� 
	ContCarBean car	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String car_origin 	= car.getCar_origin();
	
	
	//���� ���翩��
	String sub = "";
	String cont = "";
	//1. ����ó���� ����ó��-------------------------------------------------------------------------------------------
	//
	if (doc_bit.equals("1")) {  //����ó���� ���
	
	//	System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no + ": rent_l_cd = " + rent_l_cd);
	
		//doc_settle�� ����	
		//2. ����ó���� ���-------------------------------------------------------------------------------------------
		
		if ( cls_st.equals("8")) {
			sub 		= "���Կɼ��Ƿ�";
			cont 	= "[����ȣ:"+rent_l_cd+"] ���Կɼ� �Ƿ� �մϴ�.";
		} else if ( cls_st.equals("7")) {
			sub 		= "���������(����)�Ƿ�";
			cont 	= "[����ȣ:"+rent_l_cd+"] ���������(����) �Ƿ� �մϴ�.";
		} else if ( cls_st.equals("10")) {
			sub 		= "����������(�縮��)�Ƿ�";
			cont 	= "[����ȣ:"+rent_l_cd+"] ����������(�縮��) �Ƿ� �մϴ�.";	
		} else if ( cls_st.equals("14")) {
			sub 		= "����Ʈ���� ȸ��ó���Ƿ�";
			cont 	= "[����ȣ:"+rent_l_cd+"] ����Ʈ ȸ��ó�� �Ƿ� �մϴ�.";	
		
		} else {
			sub 		= "������������Ƿ�";
			cont 	= "[����ȣ:"+rent_l_cd+"] �������� �Ƿ� �մϴ�.";		
		}	
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st("11");//���������Ƿ� (�ߵ�����, ��ุ��, ���Կɼ�, ���������(����))
		doc.setDoc_id(rent_l_cd);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc("");
		doc.setUser_nm1("�����");
		doc.setUser_nm2("����������");
		doc.setUser_nm3("ȸ������"); //ä�Ǿ����� ���� ó�� -  ����Ʈ�ΰ��� ������� ȸ��ó����.
		doc.setUser_nm4("ä�Ǵ����");  //��� - 20091201
		doc.setUser_nm5("�ѹ�����");
		
		doc.setUser_id1(reg_id);
		
		String user_id2 = "";
		String user_id3 = "";
		String user_id4 = "";
		String user_id5 = "";
			
		doc.setDoc_bit("1");//����1�ܰ�
		doc.setDoc_step("1");//���		
	
		user_id2 = "000026";//����:000026, ���� 000006   �λ�:000053 ����:000052 , �뱸: 000054    ����:000020
		user_id3 = nm_db.getWorkAuthUser("����������"); 	
		
		// ����Ʈ�� ��� 
		 if ( cls_st.equals("14") ) {   //����Ʈ�ΰ��	
			user_id3 =  nm_db.getWorkAuthUser("���ݰ�꼭�����"); 			
		 }
		
		user_id4 = nm_db.getWorkAuthUser("ä�ǰ�����"); 
		user_id5 =  "000004";   // nm_db.getWorkAuthUser("�����ѹ�����");  // �ѹ�����:000004 ��������:000005
	//	user_id5 =  "000048";   // nm_db.getWorkAuthUser("�����ѹ�����");  // �ѹ�����:000004 ��������:000005
				
		//���������(����), ����������(�縮��)		
		if ( cls_st.equals("7") ) {
			doc.setUser_nm2("��������");
			user_id2 = "000028"; 	
		} else if (  cls_st.equals("10") ) {
				doc.setUser_nm2("����������");
				user_id2 = "000026"; 					
		} else {  //�λ�,�뱸�� ���翡��  		
			if(br_id.equals("B1") || br_id.equals("U1")){
				doc.setUser_nm2("������");
				user_id2 = "000053"; //000053(������)
			} else if(br_id.equals("G1")){
				doc.setUser_nm2("������");
				user_id2 = "000054"; //000054(����Ź)
			} else if(br_id.equals("J1")){
				doc.setUser_nm2("������");
				user_id2 = "000219"; //000118(�̼���)		000219(����)
			}else if(br_id.equals("D1")){
				doc.setUser_nm2("������"); 
				user_id2 = "000052"; //000052(�ڿ���)
			}	
		}	
			    	  	
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);  		
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(user_id4);
		CarScheBean cs_bean5 = csd.getCarScheTodayBean(user_id5);
			
		//�����忬�� -> ����������, ������, �������忬�� -> ȸ������ڷ� 		
		if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("8") ) {
			if(!cs_bean2.getWork_id().equals("") ) {
			   if ( user_id2.equals("000052")  || user_id2.equals("000053") || user_id2.equals("000054") || user_id2.equals("000020") ) {
					user_id2 = "000026";
				} else {
					user_id2 = "XXXXXX"; //����
				}	
			}		
		}
		
				
		if ( cls_st.equals("7") || cls_st.equals("10") ) {
			if(!cs_bean2.getWork_id().equals("")) user_id2 = "XXXXXX"; //����
		}

	
		if(!cs_bean3.getWork_id().equals("")) user_id3 =  cs_bean3.getWork_id();    // cs_bean3.getWork_id();
		if(!cs_bean4.getWork_id().equals("")) user_id4 =  cs_bean4.getWork_id(); //ä�ǰ�����
	//	if(!cs_bean5.getWork_id().equals("")) user_id5 =  cs_bean5.getWork_id(); //�ѹ�����
		if(!cs_bean5.getWork_id().equals("")) user_id5 = "000048"; //�ѹ�����	
		 
		 if ( cls_st.equals("14")  )    {   //����Ʈ �ΰ��			 			 	
			user_id2 = "XXXXXX"; 	 //����		
			user_id4 = "XXXXXX"; 	 //����
			user_id5 = "XXXXXX"; 	 //����	
		}	
		 	
		 if ( car_st.equals("5")  )    {   // �����뿩 �ΰ��			 			 	
			user_id2 = "000026"; 			
			user_id4 = "XXXXXX"; 	 //����
			user_id5 = "XXXXXX"; 	 //����	
		}	
		 	
		//���������(����), ����������(�縮��)	 
		if ( cls_st.equals("7")  ||  cls_st.equals("10") ) {
		  user_id5 = "XXXXXX"; 	 //����	
		  if (!user_id2.equals("XXXXXX") ){ //�������� �ƴϸ� 
			  if ( fdft_amt2   == 0 ) {  //������� ���ٸ�  �ѹ��������� 
			    	user_id3 = "XXXXXX"; 	 //����	
			    //	user_id5 = "XXXXXX"; 	 //����	
			  }	 
		  }		  
		}  	
	
		
		// ������ �Ǵ� ���������� �ִٸ� �ѹ����� 
		if ( cls_st.equals("1")  ||  cls_st.equals("2") ) {
			
			 if ( !car_origin.equals("2") ) { 
			   if ( fdft_amt2  <= 0 ) {  //����ä���� �ְ� ��������  �ƴϸ�   �ѹ��������� 
				    	user_id5 = "XXXXXX"; 	 //����
			   }	 				  
			 }  
		}  	
		
		doc.setUser_id2(user_id2);//����/������
		doc.setUser_id3(user_id3);//ȸ�������
		doc.setUser_id4(user_id4);//ä�ǰ�����
		doc.setUser_id5(user_id5);//�ѹ�����
					 				
		//=====[doc_settle] insert=====
		if (cnt < 1 ) {
			flag1 = d_db.insertDocSettle(doc);
		}		
	
		//3. ��޽��� �˶� ���----------------------------------------------------------------------------------------
			
		UsersBean sender_bean 	= umd.getUsersBean(reg_id);
		
			//����� ���� ��ȸ
		String target_id = "";
			   
		target_id = doc.getUser_id2();
		
		if (target_id.equals("XXXXXX")) {
		   			target_id = doc.getUser_id3();
		}	
		
			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		String url 		= "/fms2/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		
		 if ( cls_st.equals("14")) {
			 url 		= "/fms2/cls_cont/lc_cls_rm_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		}
			
	//	System.out.println("from_page 1=" + from_page);	
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
		
		
		//�޴»��
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		if ( cls_st.equals("8")) {
			xml_data += "    <TARGET>2013002</TARGET>";  //���Կɼ��� ��� �߰� - ������
		}
		
//		xml_data += "    <TARGET>2006007</TARGET>";
		
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
		
		
		//sender&target�� ���� ���� �޼��� �Ȱ�.
		if ( cls_st.equals("8")) {
			flag2 = cm_db.insertCoolMsg(msg);		
		} else {   
			if(  !target_bean.getId().equals(sender_bean.getId())  ){
				
				 if ( !cls_st.equals("14") ) {
					flag2 = cm_db.insertCoolMsg(msg);
				} else {
				     	 if ( cool.equals("Y")  ||  fdft_amt2 != 0 ) {
								flag2 = cm_db.insertCoolMsg(msg);
						 }	
				}
		   }			
	  }	
	  	 
		if ( cls_st.equals("8")) {
			System.out.println("��޽���(���Կɼ��Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		} else if ( cls_st.equals("7")) {
			System.out.println("��޽���(���������(����) �Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());		
		} else if ( cls_st.equals("10")) {
			System.out.println("��޽���(����������(�縮��) �Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());			
		} else if ( cls_st.equals("14")) {
			System.out.println("��޽���(����Ʈ ȸ��ó�� �Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());					
		} else {
			System.out.println("��޽���(���������Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		}				
		
		   
		//��������Ƿڼ���
		flag3 = ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "1", reg_id);  //��������Ƿ� 		
		
		//���� ���� skip
		if ( doc.getUser_id2().equals("XXXXXX") ) {
			doc = d_db.getDocSettleCommi("11", rent_l_cd);
			doc_no = doc.getDoc_no();
			flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");
		}
		
				//����������� �ƴ� ��츸 	
		if ( cls_st.equals("7") || cls_st.equals("10")  ) {
		
		} else {
		
			//���� �Ǻ������� ��� && 21���̸��� ���  20160901-������ ����ȳ� ��ü������� ���� ;
		// �����Ϸ� ������ �ƴ� �����û������ �������ڿ��� ���� 
			String ins_st = ai_db.getInsSt(base.getCar_mng_id());
			InsurBean ins  = ai_db.getIns(base.getCar_mng_id(), ins_st);
			Hashtable ins_info = ai_db.getInsClsCoolMsg(base.getCar_mng_id(),ins_st);
			
			//20170207 �Ű��̳� ���Կɼ��� ��쿡�� ���������� ��� �ȵǾ� ������  ���� �ٲٱ�
			String msgGubun = "�������";
			if( cls_st.equals("6") || cls_st.equals("8") ){
				//���������� ã��
				SuiBean sui = sui_db.getSui(base.getCar_mng_id());
				if(sui.getMigr_dt().equals("")){
					if( cls_st.equals("6")  ){ msgGubun = "�Ű�" ; }
					if( cls_st.equals("8")  ){ msgGubun = "���Կɼ�" ; }
				}
			}
	
		//	UsersBean sender_bean 	= umd.getUsersBean(reg_id);
									
			sub 		= "������� �������� ���� ���� ���";
			cont 	=  msgGubun+" ["+ ins_info.get("CAR_NO") + ","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			String  d_flag2 = "";
			//���躯���û ���ν��� ȣ��
			if ( !cls_st.equals("8")  ) {   //���Կɼ��� �ƴϸ� 	
				 d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "");	 
		   }		
				
			System.out.println("��޽���(�����û �������)"+ String.valueOf(ins_info.get("CAR_NO"))  +"---------------------"+rent_l_cd);		
		}			
				
	} else { //����������
		
	//	System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no +":user_id = " + user_id + ": rent_l_cd = " + rent_l_cd);
		
		DocSettleBean doc 		= d_db.getDocSettle(doc_no);
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
		
		//1. ����ó���� ����ó��-------------------------------------------------------------------------------------------
		
		//=====[doc_settle] update=====
		
		doc_step = "2";
			
		//�ѹ����� �����̸� ���� ���� �Ϸ�
		if(doc_bit.equals("5"))	doc_step = "3";  
		
		 if ( doc_bit.equals("9") ) {   //���������� skip	 (user2 ����skip)	
			flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");		
		}	
					
		if(!mode.equals("msg")){		
			//	System.out.println(" doc_sanction update doc_bit = " + doc_bit + ": doc_no = :" + doc_no +":user_id = " + user_id + ": rent_l_cd = " + rent_l_cd);	
				flag1 = d_db.updateDocSettleCls(doc_no, user_id, doc_bit, doc_step);			
			//	out.println("����ó���� ����<br>");				
		}
		
		if ( cls_st.equals("14")   ) {  //����Ʈ�� �ٷ� ����Ϸ�
			doc_bit = "5";  
			doc_step = "3";  
			flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; // ����Ʈ ����Ϸ�
		//	flag1 = d_db.updateDocSettleDocBit(doc_no,  doc_bit);				
		}
		
		/* -����/�������� ���� ������ - 20200520
		if(doc_bit.equals("2")) {			
			if ( cls_st.equals("7") || cls_st.equals("10")  ) { //���������, ���������� 
			  if ( fdft_amt2   == 0 ) {  //������� ���ٸ�  �ѹ���������  - ���� skip ( 20200519)
			       doc_bit = "3"; 	
				   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; // �����뿩��  ����Ϸ�				   
				   //�ݾ�Ȯ������					
				   if(!ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", user_id))	flag += 1;	
			  }	
			}  	
		}
		*/		
		
		//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------		
		if ( cls_st.equals("8")) {		
			sub 		= rt_s + " ���Կɼ� �����û";
			cont 	= rt_s +  " [����ȣ:"+rent_l_cd+"] ���Կɼ� �����û �մϴ�.";	
		} else if ( cls_st.equals("7")) {		
			sub 		= rt_s + " ���������(����) �����û";
			cont 	= rt_s + " [����ȣ:"+rent_l_cd+"] ���������(����) �����û �մϴ�.";		
		} else if ( cls_st.equals("10")) {		
			sub 		= rt_s + " ����������(�縮��) �����û";
			cont 	= rt_s + " [����ȣ:"+rent_l_cd+"] ����������(�縮��) �����û �մϴ�.";		
		} else if ( cls_st.equals("14")) {		
			sub 		= "����Ʈ ȸ��ó�� �����û";
			cont 	= "[����ȣ:"+rent_l_cd+"] ����Ʈȸ��ó�� �����û �մϴ�.";			
		} else {
			sub 		= rt_s + " ����������� �����û";
			cont 	= rt_s + " [����ȣ:"+rent_l_cd+"] �������� �����û �մϴ�.";	
		}	
		String url 		=  "";
		
		if (doc_bit.equals("2") || doc_bit.equals("3") ||  doc_bit.equals("4")  ) {
			 url = 	"/fms2/cls_cont/lc_cls_u1.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;	
		}else  { 	
			if ( cls_st.equals("8")) {
		 		 url 	= "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
		 	} else if ( cls_st.equals("14")) {
		 		 url 	= "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	 
		 	} else {
		 		 url 	= "/fms2/cls_cont/lc_cls_d_frame.jsp";
		 	}	 
		}	 
			 
		
		String target_id = "";
					
		if(doc_bit.equals("2") )	target_id = doc.getUser_id3();
				
		if ( cls_st.equals("8") || cls_st.equals("7") || cls_st.equals("10")  ) {		 //ȸ������ڿ� ä�ǰ����ڰ� ���� 20110530  -20120119����
			if(doc_bit.equals("3"))	target_id = doc.getUser_id5();		
		} else {
			if(doc_bit.equals("3"))	target_id = doc.getUser_id4();
		}
		
		if(doc_bit.equals("3")) {
		  if ( car_st.equals("5")  ) {  //�����뿩�� ���  ����Ϸ�
			   flag1 = d_db.updateDocSettleDocDt( doc_no, "4","2") ; // ä��	
		       doc_bit = "5";  
			   doc_step = "3";  
			   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit, doc_step) ; // �����뿩��  ����Ϸ�
		  }	
		  
		  //��������� , ���������� ó�� 		  
		  if ( cls_st.equals("7") || cls_st.equals("10")  ) { //���������, ���������� 
				   doc_bit = "5";  
				   doc_step = "3"; 
				   flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; // �����뿩��  ����Ϸ�				   
				   //�ݾ�Ȯ������					
				   if(!ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", user_id))	flag += 1;	
		  }	
		}
						
		if(doc_bit.equals("4"))	target_id = doc.getUser_id5(); 
		
		if(doc_bit.equals("4")) {
			  if ( cls_st.equals("1") || cls_st.equals("2")  ) {  //�ߵ��ؾ�, ��ุ��
				   if ( target_id.equals("XXXXXX")) {
				    	doc_bit = "5";  
					    doc_step = "3";  
					    flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; //  ����Ϸ�
			  	   } 
			  }		
		}
				
		if(doc_bit.equals("5"))	target_id = doc.getUser_id3();  //ȸ������ڿ��� �˸� (ȸ��ó��) 
				
		if(doc_bit.equals("5")){
					
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
	
			
			if ( cls_st.equals("8")) {		
				sub 	= "���Կɼ� ���� �ϰ�";
				cont 	=  "[����ȣ:"+rent_l_cd+"] ���Կɼ� ���� �ϰ��ϴ� ȸ��ó�� �����ϼ���.";
			} else if ( cls_st.equals("7")) {		
				sub 	= "���������(����) ���� �ϰ�";
				cont 	=  "[����ȣ:"+rent_l_cd+"] ���������(����) ���� �ϰ��ϴ� ȸ��ó�� �����ϼ���.";
			} else if ( cls_st.equals("10")) {		
				sub 	= "����������(�縮��) ���� �ϰ�";
				cont 	=  "[����ȣ:"+rent_l_cd+"] ����������(�縮��) ���� �ϰ��ϴ� ȸ��ó�� �����ϼ���.";	
			} else if ( cls_st.equals("14")) {		
				sub 	= "����Ʈ  ���� �ϰ�";
				cont 	=  "[����ȣ:"+rent_l_cd+"] ����Ʈ ���� ���� �ϰ��ϴ� ȸ��ó�� �����ϼ���.";						
			} else {
				sub 	= "����������� ���� �ϰ�";
				cont 	= "[����ȣ:"+rent_l_cd+"] ����������� ���� �ϰ��ϴ� ȸ��ó�� �����ϼ���.";
			}	
				
			//����Ʈ�ΰ�� ����???		
			 if ( cls_st.equals("14") ) {	 			
				url = 	"/fms2/cls_cont/lc_cls_rm_u3.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
			} else {
				url = 	"/fms2/cls_cont/lc_cls_u3.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;			
			}	
		}
		
						
	//	System.out.println("from_page 2=" + from_page);	
						
		//����� ���� ��ȸ
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"    <BACKIMG>4</BACKIMG>"+
	  				"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
	 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+from_page+"</URL>";
		
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	//	if ( cls_st.equals("8")  && doc_bit.equals("3") ) {	 	
	//		xml_data += "    <TARGET>2006007</TARGET>";
	//	}	 	
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
		
		flag2 = cm_db.insertCoolMsg(msg);
		
		if (doc_bit.equals("5")) {
			if ( cls_st.equals("8")) {	
				System.out.println("��޽���(���Կɼ�ȸ��ó���Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
			} else if ( cls_st.equals("7")) {	
				System.out.println("��޽���(���������(����) ȸ��ó���Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
			} else if ( cls_st.equals("10")) {	
				System.out.println("��޽���(����������(�縮��) ȸ��ó���Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());		
			} else if ( cls_st.equals("14")) {	
				System.out.println("��޽���(����Ʈ ���� ȸ��ó���Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());			
			} else {
				System.out.println("��޽���(��������ȸ��ó���Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
			}	
		} else {
			if ( cls_st.equals("8")) {	
		    	System.out.println("��޽���(���Կɼ��Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		    } else if ( cls_st.equals("7")) {	
		    	System.out.println("��޽���(���������(����)�Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
		     } else if ( cls_st.equals("10")) {	
		    	System.out.println("��޽���(����������(�縮��)�Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
		      } else if ( cls_st.equals("14")) {	
		    	System.out.println("��޽���(����Ʈ���� ȸ��ó���Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());			
		    } else {
		    	System.out.println("��޽���(���������Ƿ�)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
		    }	
		}
						
		
	//	System.out.println(xml_data);
	}	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='mode'	 			value='<%=mode%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action ='<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');		
<%	}	%>
</script>
<body>
</body>
</html>