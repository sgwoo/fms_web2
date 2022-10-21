<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.estimate_mng.* " %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.im_email.*"%>
<%@ page import="acar.coolmsg.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="IssueDb"   class="tax.IssueDatabase" 			scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          	scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<% 
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");	
	String content_st 	= request.getParameter("content_st")==null?"":request.getParameter("content_st");	
	String mail_code	 	= request.getParameter("mail_code")==null?"":request.getParameter("mail_code");
	
	String answer1	 	= request.getParameter("answer1")==null?"":request.getParameter("answer1");
	String answer2	 	= request.getParameter("answer2")==null?"":request.getParameter("answer2");
	String answer3	 	= request.getParameter("answer3")==null?"":request.getParameter("answer3");
	
	String gubun1	 	= "";
	String gubun2	 	= "";
	boolean flag = true;
	boolean flag2 = true;
			
	
	
	
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();			
	
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�ش�뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//�����
	UsersBean bus_user_bean = new UsersBean();
			
	//��������
	Hashtable ht = new Hashtable();
	


	if(content_st.equals("newcar_doc")){

		bus_user_bean = umd.getUsersBean(fee.getExt_agnt());
	
		gubun1 = rent_l_cd+""+rent_st;
		gubun2 = mail_code+"newcar_doc";
		
		System.out.println("�����༭ �亯���Ϲ߼�");

	}
	
	if(!gubun1.equals("")){
		ht =  ImEmailDb.getImDmailInfo("5", rent_l_cd+""+rent_st, mail_code+"newcar_doc");
	}
	
	
	System.out.println("rent_l_cd 	="+rent_l_cd);	
	System.out.println("rent_st 	="+rent_st);	
	System.out.println("content_st 	="+content_st);
	System.out.println("mail_code 	="+mail_code);	
	System.out.println("answer1 	="+answer1);	
	System.out.println("answer2 	="+answer2);
	System.out.println("answer3 	="+answer3);	
	
	
	if(!String.valueOf(ht.get("MAILTO")).equals("")){
	
		//�������� �߽��ڿ��� ���� �߼�		
		DmailBean d_bean = new DmailBean();
		d_bean.setSql				("SSV:"+String.valueOf(ht.get("V_MAILFROM")).trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			(String.valueOf(ht.get("MAILTO")));
		d_bean.setMailto			(String.valueOf(ht.get("MAILFROM")));
		d_bean.setReplyto			("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
		d_bean.setErrosto			("\"�Ƹ���ī\"<return@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(String.valueOf(ht.get("GUBUN")));
		d_bean.setGubun2			(String.valueOf(ht.get("GUBUN2"))+"_re");
		d_bean.setRname				("mail");
		d_bean.setMtype      		(0);
		d_bean.setU_idx      		(1);//admin����
		d_bean.setG_idx				(1);//admin����
		d_bean.setMsgflag     		(0);		
		d_bean.setV_mailfrom		(String.valueOf(ht.get("V_MAILTO")));	
		d_bean.setV_mailto			(String.valueOf(ht.get("V_MAILFROM")));		
					
		if(content_st.equals("newcar_doc")){
			d_bean.setSubject		("[�Ƹ���ī] "+client.getFirm_nm()+" ���� �ڵ����뿩�̿� ������ �亯�Դϴ�.");
			d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/renew_email_rec.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&mail_code="+mail_code+"&answer1="+answer1+"&answer2="+answer2+"&answer3="+answer3);
			d_bean.setV_content		("http://fms1.amazoncar.co.kr/mailing/rent/renew_email_rec.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&mail_code="+mail_code+"&answer1="+answer1+"&answer2="+answer2+"&answer3="+answer3);		
		}


		flag = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
	
	
		if(content_st.equals("newcar_doc")){
		
			//�����Ե� ���Ϲ߼�
			d_bean = new DmailBean();
			d_bean.setSubject			("[�Ƹ���ī] "+client.getFirm_nm()+" ���� �ڵ����뿩�̿� ������ �亯����Դϴ�.");
			d_bean.setSql				("SSV:"+String.valueOf(ht.get("V_MAILTO")).trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			(String.valueOf(ht.get("MAILFROM")));
			d_bean.setMailto			(String.valueOf(ht.get("MAILTO")));
			d_bean.setReplyto			("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
			d_bean.setErrosto			("\"�Ƹ���ī\"<return@amazoncar.co.kr>");			
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				(String.valueOf(ht.get("GUBUN")));
			d_bean.setGubun2			(String.valueOf(ht.get("GUBUN2"))+"_rec");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin����
			d_bean.setG_idx				(1);//admin����
			d_bean.setMsgflag     		(0);			
			d_bean.setV_mailfrom		(String.valueOf(ht.get("V_MAILFROM")));	
			d_bean.setV_mailto			(String.valueOf(ht.get("V_MAILTO")));		
					
			if(content_st.equals("newcar_doc")){
				d_bean.setContent		("http://fms1.amazoncar.co.kr/mailing/rent/renew_email_rec.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&mail_code="+mail_code+"&answer1="+answer1+"&answer2="+answer2+"&answer3="+answer3);
				d_bean.setV_content		("http://fms1.amazoncar.co.kr/mailing/rent/renew_email_rec.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&mail_code="+mail_code+"&answer1="+answer1+"&answer2="+answer2+"&answer3="+answer3);		
			}
		
			
			flag = ImEmailDb.insertDEmail(d_bean, "5", "", "+7");
		
			
			//���ڹ߼�

			String destphone 	= bus_user_bean.getUser_m_tel();
			String destname 	= "(��)�Ƹ���ī "+bus_user_bean.getUser_nm();
			String reg_id =  bus_user_bean.getUser_id();
			String sendphone 	= "02-392-4243";
			String sendname 	= "�Ƹ���ī";
			
				
			//String msg_cont		= client.getFirm_nm()+" ���� �ڵ����뿩�̿� �����༭ �亯������ �߼��Ͽ����ϴ�. Ȯ�ιٶ��ϴ�. - �Ƹ���ī-";
			String msg_cont		= destname+" ����ڴ��� ��� �� "+client.getFirm_nm()+"���� �ڵ����뿩�̿� �����༭ �亯������ �߼��Ͽ����ϴ�. Ȯ�� �� ó���ٶ��ϴ�. (��)�Ƹ���ī www.amazoncar.co.kr";
				
			String msg_type = "0";
			String msg_subject = "0";				
			int msg_len = 0;
			
			msg_len = AddUtil.lengthb(msg_cont);
		
			if(msg_len>80){
				msg_type = "5";
				msg_subject = "�����༭ �亯���Ϲ߼� �˸�";
			}
				
		/*		
			if(destphone.equals("") || destphone.equals("-") || destphone.equals("--")){
				
			}else{
				IssueDb.insertsendMail_V5_H(sendphone, sendname, destphone, destname, "", "", msg_type, msg_subject, msg_cont, rent_l_cd, "", "", "");
			}
*/

			// jjlim add alimtalk
			// acar49 �����༭ �亯���Ϲ߼� �˸�
			if (!destphone.equals("") && !destphone.equals("-") && !destphone.equals("--")) {
				String manager_name = bus_user_bean.getUser_nm();		// �Ŵ��� �̸�
				String customer_name = client.getFirm_nm();				// �� �̸�
				String etc1 = rent_l_cd;
				String etc2 =  reg_id;

				//acar0049 -> acar0083 -> acar0192 ��������
			//	List<String> fieldList = Arrays.asList(manager_name, customer_name);
			//	at_db.sendMessageReserve("acar0192", fieldList, destphone, sendphone, null , etc1,  etc2);
			//	alimTalkDatabase.sendMessage("acar0049", fieldList, destphone, sendphone);
				
				//��޽��� �޼��� ����------------------------^^^�˸��� ���x, ��޽����� ����(20190820)
				String sub 	= "�����༭ �亯���� �߼�";
				String cont 	= customer_name+ " ������ �����༭ ["+etc1+"] �� �亯������ �߼۵Ǿ����ϴ�. Ȯ���ϼ���.";
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"<BACKIMG>4</BACKIMG>"+
					"<MSGTYPE>104</MSGTYPE>"+
					"<SUB>"+sub+"</SUB>"+
					"<CONT>"+cont+"</CONT>"+
					"<URL></URL>";
				//�޴»��
				xml_data += "    <TARGET>"+bus_user_bean.getId()+"</TARGET>";
				//�������
				xml_data += "    <SENDER></SENDER>"+
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
			}
		}						
	}
	
	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">



</script>
</head>
<body>
<script language="JavaScript">
<!--
<%if(flag){%>
	alert("������ ���������� �߼� �Ǿ����ϴ�.");
	parent.window.close();
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	parent.window.close();				
<%}%>
//-->
</script>
</body>
</html>




