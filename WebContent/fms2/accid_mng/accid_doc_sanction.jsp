<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.accid.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//@ author : JHM - ���ó�������������
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");//��������ȣ
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");//����ȣ
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");//�ڵ���������ȣ
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String settle_st 	= request.getParameter("settle_st")==null?"":request.getParameter("settle_st");
	String pre_doc 	= request.getParameter("pre_doc")==null?"":request.getParameter("pre_doc");  //����Ȯ����  ����� ���縦 �ؾ��Ҷ� 
	
	String asset_st 	= request.getParameter("asset_st")==null?"":request.getParameter("asset_st");  //��������
	
	if(user_id.equals("") && c_id.equals("")){
		System.out.println("����� ó�� ������");
		return;
	}
		
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	int result = 0;
	int count = 0;
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	
	AccidentBean accid = as_db.getAccidentBean(c_id, accid_id);
	accid.setSettle_dt	(request.getParameter("settle_dt")==null?"":request.getParameter("settle_dt"));//ó���Ϸ�����
	accid.setSettle_id	(request.getParameter("settle_id")==null?"":request.getParameter("settle_id"));//ó���Ϸ������
	accid.setSettle_cont	(request.getParameter("settle_cont")==null?"":request.getParameter("settle_cont"));//ó������
	accid.setAsset_st	(request.getParameter("asset_st")==null?"":request.getParameter("asset_st"));//����ó������

	if ( doc_bit.equals("1") ) { //����϶��� 
		accid.setUpdate_dt	(AddUtil.getDate());
		accid.setUpdate_id	(user_id);//������
	}
	accid.setPre_doc (pre_doc);//����Ȯ����  ����� ���縦 �ؾ��Ҷ� 
		
	DocSettleBean doc 		= d_db.getDocSettle(doc_no);
	
	if(doc.getDoc_id().equals("")){
		doc = d_db.getDocSettleCommi("45", c_id+""+accid_id);
		doc_no = doc.getDoc_no();
	}
	
	if(doc_no.equals("")){
	
		String sub 	= "���ó������";
		String cont 	= sub;
		
		doc.setDoc_st	("45");
		doc.setDoc_id	(car_mng_id+""+accid_id);
		doc.setSub	(sub);
		doc.setCont	(cont);
		doc.setEtc	("");
		doc.setUser_nm1	("�����");
		doc.setUser_nm2	("����������");
		doc.setUser_nm3	("");
		doc.setUser_nm4	("");
		doc.setUser_id1	("");
		doc.setUser_id2	("");
		doc.setUser_id3	("");
		doc.setDoc_bit	("1");//���Ŵܰ�
		doc.setDoc_step	("1");//���
		
		//������ ������
		
		String user_id2 = "";
		user_id2 = nm_db.getWorkAuthUser("�����������");		
		
		if(sender_bean.getBr_id().equals("B1")){
			doc.setUser_nm2("������");
			user_id2 = nm_db.getWorkAuthUser("�λ�������");
		}else if(sender_bean.getBr_id().equals("U1")){
			doc.setUser_nm2("������");
			user_id2 = nm_db.getWorkAuthUser("�λ�������");
		}else if(sender_bean.getBr_id().equals("D1")){
			doc.setUser_nm2("������"); 
			user_id2 = nm_db.getWorkAuthUser("����������");
		}else if(sender_bean.getBr_id().equals("G1")){
			doc.setUser_nm2("������"); 
			user_id2 = nm_db.getWorkAuthUser("�뱸������");
		}else if(sender_bean.getBr_id().equals("J1")){
			doc.setUser_nm2("������"); 
			user_id2 = nm_db.getWorkAuthUser("����������");
		}
			
		doc.setUser_id2(user_id2);//����/������	
				
		//=====[doc_settle] insert=====
		flag1 = d_db.insertDocSettle(doc);
		
		DocSettleBean doc2 = d_db.getDocSettleCommi("45", car_mng_id+""+accid_id);
		doc.setDoc_no(doc2.getDoc_no());
		
		doc_no = doc2.getDoc_no();
		
		if(!settle_st.equals("1")){
			accid.setSettle_st("0");//����ó��
		}
	}
	
	String doc_step = "2";
	
	if(doc_bit.equals("2")){
		doc_step = "3";
		
		accid.setSettle_st("1");//����ó��
	}
	
	flag1 = d_db.updateDocSettle(doc_no, user_id, doc_bit, doc_step);
	//out.println("����ó���� ����<br>");
	
	count = as_db.updateAccident(accid);
	
	
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			//String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
			String sub 		= "���ó������ ����";
			String cont 	= "[ "+request.getParameter("car_no")+" "+AddUtil.ChangeDate3(accid.getAccid_dt())+" ]  &lt;br&gt; &lt;br&gt; ���ó�������մϴ�. ���縦 ��û�մϴ�.";
			String target_id = doc.getUser_id2();
			String url 		= "/fms2/accid_mng/accid_result_c.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|car_mng_id="+car_mng_id+"|accid_id="+accid_id+"|doc_no="+doc_no+"|gubun1="+gubun1+"|s_kd="+s_kd+"|t_wd="+t_wd;
			String m_url  ="/fms2/accid_mng/accid_result_frame.jsp";
			if(doc_bit.equals("2")){
				sub 		= "���ó����������Ϸ�";
				cont 		= "[ "+request.getParameter("car_no")+" "+AddUtil.ChangeDate3(accid.getAccid_dt())+" ]  &lt;br&gt; &lt;br&gt; ���ó������ �����Ͽ����ϴ�.";
				target_id 	= doc.getUser_id1();
			}
			
			//����� ���� ��ȸ
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		//   20130709 ���� - ����� ��û
		//	if(doc_bit.equals("2")){
		//		xml_data += "    <TARGET>2000002</TARGET>";
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
			
			flag4 = cm_db.insertCoolMsg(msg);
			System.out.println("��޽���("+cont+")-----------------------"+target_bean.getUser_nm());
			//System.out.println(xml_data);	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>

<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="rent_mng_id" value='<%=rent_mng_id%>'>
<input type='hidden' name="rent_l_cd" value='<%=rent_l_cd%>'>
<input type='hidden' name="car_mng_id" value='<%=car_mng_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
<input type='hidden' name="cmd" value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  		
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	<%	if(go_url.equals("")){	%>		
	fm.action = 'accid_result_c.jsp';
	<%	}else{%>
	fm.action = '<%=go_url%>';	
	<%	}%>
	fm.target = 'd_content';
	fm.submit();
	
	parent.self.window.close();
	
<%	}else{	%>
		alert('�����ͺ��̽� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');		
<%	}	%>
</script>
<body>
</body>
</html>