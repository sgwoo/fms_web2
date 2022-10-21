<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.credit.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String from_page 	= "";
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String reg_id 	= request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");	
	int   fdft_amt2 =   request.getParameter("fdft_amt2")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt2"));	 //����Ʈ�ΰ�� �޼��� ������ üũ 
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int result = 0;
	
	String doc_step  = "";
		
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
				
		//�����Ƿ�����
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
		
	//�����������
	from_page = "/agent/cls_cont/lc_cls_d_frame.jsp";	
	
		
	//���� ���翩��
	String sub = "";
	String cont = "";
	//1. ����ó���� ����ó��-------------------------------------------------------------------------------------------
	
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
		doc.setUser_nm3("ȸ������"); //ä�Ǿ����� ���� ó�� - Ȳȿ�� :20090922
		doc.setUser_nm4("ä�Ǵ����");  //��� - 20091201
		doc.setUser_nm5("�ѹ�����");
		
		doc.setUser_id1(reg_id);
		
		String user_id2 = "";
		String user_id3 = "";
		String user_id4 = "";
		String user_id5 = "";
			
		doc.setDoc_bit("1");//����1�ܰ�
		doc.setDoc_step("1");//���		
	
		user_id2 = "000026";//���� 000006   �λ�:000053 ����:000052
		user_id3 = nm_db.getWorkAuthUser("����������"); 	
		
		user_id4 = nm_db.getWorkAuthUser("ä�ǰ�����"); 	
		user_id5 =  "000004";   // nm_db.getWorkAuthUser("�����ѹ�����");  // �ѹ�����:000004 ��������:000005

				
		//���������(����), ����������(�縮��)		 --������Ʈ ���� 
		if ( cls_st.equals("7") ) {
			doc.setUser_nm2("��������");
			user_id2 = "000028"; 	
		} else if ( cls_st.equals("10") ) {
				doc.setUser_nm2("����������");
				user_id2 = "000026"; 		
		}	
			    	  	
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);  		
		CarScheBean cs_bean3 = csd.getCarScheTodayBean(user_id3);
		CarScheBean cs_bean4 = csd.getCarScheTodayBean(user_id4);
		CarScheBean cs_bean5 = csd.getCarScheTodayBean(user_id5);
			
		//�����忬�� -> ����������, ������, �������忬�� -> ȸ������ڷ� 		
		if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("8") ) {
			if(!cs_bean2.getWork_id().equals("") ) {
			   if ( user_id2.equals("000052")  || user_id2.equals("000053") ) {
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
		if(!cs_bean4.getWork_id().equals("")) user_id4 = cs_bean4.getWork_id(); //ä�ǰ�����
	//	if(!cs_bean5.getWork_id().equals("")) user_id5 = cs_bean5.getWork_id(); //�ѹ�����
		if(!cs_bean5.getWork_id().equals("")) user_id5 = "000048"; //�ѹ�����	
	
	
		if ( cls_st.equals("7")  ||  cls_st.equals("10") ) {
			  user_id5 = "XXXXXX"; 	 //����	
			  if (!user_id2.equals("XXXXXX") ){ //�������� �ƴϸ� 
				  if ( fdft_amt2   == 0 ) {  //������� ���ٸ�  �ѹ��������� 
				    	user_id3 = "XXXXXX"; 	 //����	
				    //	user_id5 = "XXXXXX"; 	 //����	
				  }	 
			  }		  
			}  	
		
		    	
		doc.setUser_id2(user_id2);//����/������
		doc.setUser_id3(user_id3);//ȸ�������
		doc.setUser_id4(user_id4);//ä�ǰ�����
		doc.setUser_id5(user_id5);//�ѹ�����
					 				
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
				
		//3. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		//������Ʈ�� ���忡�Դ� �޽����� ������ ����.	
		UsersBean sender_bean 	= umd.getUsersBean(reg_id);
		
			//����� ���� ��ȸ
		String target_id = "";
		   
		target_id = doc.getUser_id2();
		
		if (target_id.equals("XXXXXX")) {
			target_id = doc.getUser_id3();
		}	
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
	//	String url 		= "/agent/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		String url 		= "/fms2/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+doc_no+"|doc_bit="+doc_bit+"|mode="+mode;
		
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
					"<ALERTMSG>"+
					"    <BACKIMG>4</BACKIMG>"+
					"    <MSGTYPE>104</MSGTYPE>"+
					"    <SUB>"+sub+"</SUB>"+
					"    <CONT>"+cont+"</CONT>"+
					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
		//�޴»��
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	//	xml_data += "    <TARGET>2006007</TARGET>";  //������Ʈ ����������ΰ�� 
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
		if(!target_bean.getId().equals(sender_bean.getId())){
			
			flag2 = cm_db.insertCoolMsg(msg);			
		
			 if ( cls_st.equals("7")) {
				System.out.println("��޽���(���������(����) �Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());		
			} else if ( cls_st.equals("10")) {
				System.out.println("��޽���(����������(�縮��) �Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());					
			} else {
				System.out.println("��޽���(���������Ƿڿ�û)"+rent_l_cd+"---------------------"+target_bean.getUser_nm());
			}	
			
		}			
	
	   
		//��������Ƿڼ���
		flag3 = ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "1", reg_id);  //��������Ƿ� 
		
		//���� ���� skip
		if ( doc.getUser_id2().equals("XXXXXX") ) {
			doc = d_db.getDocSettleCommi("11", rent_l_cd);
			doc_no = doc.getDoc_no();
			flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");
		}
			
	}	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
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