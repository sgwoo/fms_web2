<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*,  acar.user_mng.*,  acar.coolmsg.* , acar.insur.*, acar.car_sche.*,  acar.offls_sui.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.doc_settle.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="sui_db" scope="page" class="acar.offls_sui.Offls_suiDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	int flag = 0;	
	boolean flag2 = true;
	
	String from_page 	= "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
			//�����Ƿ�����
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
		
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}	

	//�����Ƿڻ��� - �����û�� ����� ��ȹ��� �Ǵ� ��������(������)
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_tax"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_sub"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_over"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "car_credit"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "car_reco"))	flag += 1;
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_cont_etc"))	flag += 1; //����������
	if(!r_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_car_exam"))	flag += 1;  //����� ����
	if(!r_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_car_gur"))	flag += 1;  //����� ���� //������
	if(!ac_db.deleteDocSettleCls(rent_l_cd))	flag += 1; //��ȹ���
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_add"))	flag += 1; //��ȹ���
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_detail"))	flag += 1; //��ȹ���
	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_etc_more"))	flag += 1; //��ȹ���
		
	//���� �����Ȱ� ������ ��� - cls_cont , scd_ext (�����). scd_dly(��ü��) , fine(���·�), scd_ext(��å��)   Ȯ���Ͽ� ó���� �� , - ������ ����Ǿ���.
			
		//���⺻����
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	
	String sub = "";
	String cont = "";
	
	//�������� ���� �뺸���� ��ȳ�.	
			//����������� �ƴ� ��츸 	
	if ( cls_st.equals("7") || cls_st.equals("10")    ) {
		
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
	
			UsersBean sender_bean 	= umd.getUsersBean("999999");
									
			sub 		= "������� �������� �� ������  ���� Ȯ�� ���";
			cont 	=  msgGubun+" ["+ ins_info.get("CAR_NO") + ","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			
			//���躯���û ���ν��� ȣ��
			String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "");
					
			String url 		= "/acar/ins_mng/ins_s_frame.jsp"; 
				
			String 			target_id = "";
			target_id = nm_db.getWorkAuthUser("����������");  //���� ������		000070->000193	
			
			CarScheBean cs_bean02 = csd.getCarScheTodayBean(target_id);  	
				
			if(!cs_bean02.getWork_id().equals("")) target_id = cs_bean02.getWork_id();
						
				//����� ���� ��ȸ
			UsersBean target_bean1 	= umd.getUsersBean(target_id);
				
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
				
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			  				"    <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
				
	//		CdAlertBean msg1 = new CdAlertBean();
	//		msg1.setFlddata(xml_data);
	//		msg1.setFldtype("1");
				
	//		flag2 = cm_db.insertCoolMsg(msg1);
	//		System.out.println(cont);	
			System.out.println("��޽���(���������� ������û �������)"+ String.valueOf(ins_info.get("CAR_NO"))  +"---------------------"+target_bean1.getUser_nm());		
	}			
		
	
//cls_cont�� ������..... 

   //�޼��� ���� -  cview.cd_message , cview.cd_alert  
    if ( cls_st.equals("8") || cls_st.equals("1")  || cls_st.equals("2")  ) {
	    if (cls_st.equals("8") ) {
	   		cont 	= " [����ȣ:"+rent_l_cd+"] ���Կɼ� �����û �մϴ�.";	 
	    } else if ( cls_st.equals("1")  || cls_st.equals("2") ) {
		   cont 	= " [����ȣ:"+rent_l_cd+"] �������� �����û �մϴ�.";	 
	    }
	    flag2 = cm_db.deleteCdMessage(cont);
	    System.out.println("��޽���(���������� ������û �޼�������)"+ cont +"---------------------");	
    } 

    //���Կɼ� ���� �� ������ ���  - 
     if ( cls_st.equals("8") && !cls.getTerm_yn().equals("0") ) {
    	     	 
    	 	Hashtable ht1 = ac_db.getClsInfo(rent_mng_id, rent_l_cd);
    	     		
    		UsersBean sender_bean 	= umd.getUsersBean(cls.getReg_id());
			
			sub 	= "���Կɼ� �������� �� ����� ��ҿ�û��  Ȯ�� ���";
		
			cont 	= "[����ȣ:"+rent_l_cd+"] ������: "+ cls.getCls_dt() + ", ������ȣ : " + ht1.get("CAR_NO")+ ", ��ȣ: " + ht1.get("FIRM_NM") + " ���Կɼ� ������ ����ڰ�  ��ҿ�û�� �Ƿ��Ͽ�����  Ȯ���ϼ���..";	
			
			String url = 	"/fms2/cls_cont/lc_cls_off_d_frame.jsp";
				
			String 		target_id = "";
			target_id = nm_db.getWorkAuthUser("���Կɼǰ�����");  //000197
												
				//����� ���� ��ȸ
			UsersBean target_bean1 	= umd.getUsersBean(target_id);
				
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";
				
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
				
			flag2 = cm_db.insertCoolMsg(msg1);	
			System.out.println("��޽���(���������� ���Կɼ� ��ҿ�û )"+ rent_l_cd +", ������ȣ : " + ht1.get("CAR_NO")+ " ---------------------"+target_bean1.getUser_nm());	    		     		 
     }		 
    
     // ������ ������ ����ڿ��� �޼��� ������  - 
     if (  !cls.getTerm_yn().equals("0") ) {
    	     	 
    	 	Hashtable ht2 = ac_db.getClsInfo(rent_mng_id, rent_l_cd);
    	   
    	 	UsersBean sender_bean 	= umd.getUsersBean("999999");
    				
			sub 	= " �������� �� ���� �ȳ�";
		
			cont 	= "[����ȣ:"+rent_l_cd+"] ������: "+ cls.getCls_dt() + ", ������ȣ : " + ht2.get("CAR_NO")+ ", ��ȣ: " + ht2.get("FIRM_NM") + " ����  ������  �����Ͽ�����  Ȯ���ϼ���..";	
			
			String url =  "";
			if (cls_st.equals("8")){
				url = 	"/fms2/cls_cont/lc_cls_off_d_frame.jsp";
			} else {
				url = 	"/fms2/cls_cont/lc_cls_d_frame.jsp";
			}
				
				//����� ���� ��ȸ
			UsersBean target_bean1 	= umd.getUsersBean(cls.getReg_id());			
				
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";
				
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
				
			flag2 = cm_db.insertCoolMsg(msg1);	
			System.out.println("��޽���(���������� ���� Ȯ�ο�û )"+ rent_l_cd +", ������ȣ : " + ht2.get("CAR_NO")+ " ---------------------"+target_bean1.getUser_nm());	    		     		 
     }		 
    
	//����
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');
   	fm.action ='<%=from_page%>';				
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
