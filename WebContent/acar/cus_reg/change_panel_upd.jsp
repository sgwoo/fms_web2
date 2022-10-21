<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ page import="acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_st = request.getParameter("serv_st")==null?"":request.getParameter("serv_st");	
	String checker = request.getParameter("checker")==null?"":request.getParameter("checker");
	String serv_dt = request.getParameter("serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("serv_dt"));
	String b_dist = request.getParameter("b_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("b_dist"));	
	String a_dist = request.getParameter("a_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("a_dist"));	
	String rep_cont = request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");	
	String chk_ids = "";
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");

	String cha_nm = request.getParameter("cha_nm")==null?"":request.getParameter("cha_nm");
	String off_nm = request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String user_id = ck_acar_id;
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	String doc_step  = "";
					
	ServInfoBean siBn = new ServInfoBean();
	siBn.setCar_mng_id(car_mng_id);
	siBn.setServ_id(serv_id);
	siBn.setRent_mng_id(rent_mng_id);
	siBn.setRent_l_cd(rent_l_cd);
	siBn.setServ_st(serv_st);
	siBn.setServ_dt(serv_dt);
	siBn.setChecker(checker);
//	siBn.setTot_dist(b_dist);	
	siBn.setTot_dist(a_dist);	
	siBn.setRep_cont(rep_cont);
	siBn.setReg_id(user_id);
	
	int result  =  0; 
	int result1  =  0; 
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	result = cr_db.updateService(siBn);	
	String add_cng = "," + serv_dt + "  " + "����� ��ȯ";
	//car_reg ����
	result1 = cr_db.updateCarDistCng(car_mng_id, add_cng, user_id);	
	//car_cha insert	
	result1 = cr_db.insertCarCha(car_mng_id, serv_id,  serv_dt, b_dist, a_dist, cha_nm, off_nm,rep_cont );
		
	System.out.println("����� ��ȯ)"+car_mng_id+"---------------------"+add_cng);	
	
	String car_no = cr_db.getServCarNo(car_mng_id);
		
	String sub = "";
	String cont = "";
				
	DocSettleBean doc = new DocSettleBean();
	
	sub 		= "����� ��ȯ ";	
	cont 	= sub;
	
	doc.setDoc_st	("41");
	doc.setDoc_id	(car_mng_id+""+serv_id);
	doc.setSub		(sub);
	doc.setCont		(cont);
	doc.setEtc		("");
	doc.setUser_nm1	("û��");
	doc.setUser_nm2	("Ȯ��");
	doc.setUser_nm3	("������");
	doc.setUser_nm4	("����");
	doc.setUser_id1	("");
	doc.setUser_id2	(user_id);
	doc.setUser_id3	("");

	doc.setDoc_bit	("1");//���Ŵܰ�
	doc.setDoc_step	("1");//���
	
	String user_id4 = "";
			
	doc.setDoc_bit("1");//����1�ܰ�
	doc.setDoc_step("1");//���		

	user_id4 = nm_db.getWorkAuthUser("�����������"); 	
		
	doc.setUser_id4(user_id4);//�����������
	//=====[doc_settle] insert=====
	flag1 = d_db.insertDocSettle(doc);
	
	
	DocSettleBean doc2 = d_db.getDocSettleCommi("41", car_mng_id+""+serv_id);
	doc.setDoc_no(doc2.getDoc_no());
				
	doc_no = doc2.getDoc_no();
			
	doc_bit = "2";  
	doc_step = "2";  
	flag1 = d_db.updateDocSettleDocDt( doc_no, doc_bit,doc_step) ; // ����Ϸ�
			
	//3. ��޽��� �˶� ���----------------------------------------------------------------------------------------		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
		//����� ���� ��ȸ
	String target_id = "";
		   
	target_id = doc.getUser_id4();
				
	UsersBean target_bean 	= umd.getUsersBean(target_id); 
		
	String url 		= "/acar/cus_reg/cus_reg_frame.jsp";
	
	sub 		= "����� ��ȯ ����";
	cont 	= "[ "+car_no+"  "+AddUtil.ChangeDate3(serv_dt)+" ] ����� ��ȯ ���縦 ��û�մϴ�.";		
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
		System.out.println("��޽���(����� ��ȯ �����û)"+car_no+"---------------------"+target_bean.getUser_nm());	
	}		
	   
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	alert(" ������ ��ϵǾ����ϴ�. ");
	parent.opener.location.reload();
	parent.window.close();
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");					
<%}%>
//-->
</script>
</body>
</html>
