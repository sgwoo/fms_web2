<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.im_email.*, acar.cont.*, acar.client.*, acar.user_mng.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          	scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");	

	
	boolean flag = true;
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
		
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	
	
	//���Ÿ���	
	String user_email = "";
	
	//user_email = "sales@amazoncar.co.kr";

	user_email = user_bean.getUser_email();
	
	
	//ȸ�����
	if(replyto_st.equals("1")){
		replyto = "\"�Ƹ���ī\"<sales@amazoncar.co.kr>";
	//����ڵ�ϸ���
	}else if(replyto_st.equals("2")){
		replyto = "\"�Ƹ���ī "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
	//�����Է�
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
			replyto = "\"�Ƹ���ī\"<"+replyto+">";
		}else{
			replyto = "\"�Ƹ���ī\"<sales@amazoncar.co.kr>";
		}
	}	
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
		
	DmailBean d_bean = new DmailBean();
	d_bean.setSubject			("[�Ƹ���ī] "+client.getFirm_nm()+" �� ���� ���� �ڵ��� ���� ���� ��û�� �Դϴ�.");
	d_bean.setSql				("SSV:"+mail_addr);
	//d_bean.setSql				("SSV:yoonwon0611@hanmail.net");
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			("\"�Ƹ���ī\"<"+user_email.trim()+">");
	d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+mail_addr.trim()+">");
	//d_bean.setMailto			("\"�Ƹ���ī\"<yoonwon0611@hanmail.net>");
	d_bean.setReplyto			("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"�Ƹ���ī\"<return@amazoncar.co.kr>");	
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				(reg_code+"_insur");
	d_bean.setRname				("mail");
	d_bean.setMtype       		(0);
	d_bean.setU_idx       		(1);//admin����
	d_bean.setG_idx				(1);//admin����
	d_bean.setMsgflag     		(0);	
	d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/ins_task_docs.jsp?client_id="+base.getClient_id()+"&car_mng_id="+car_mng_id);
	d_bean.setEncoding			(3); //����÷��
	d_bean.setAtc_set			(1);
	
	String reg_code2  = Long.toString(System.currentTimeMillis());
	d_bean.setGubun2		(reg_code2);	
		
	flag = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");						

	
	String add_fileinfo 	= "������¿��� �պ�ó�� ���� �ȳ�.pdf";
	String add_content 	= "https://fms3.amazoncar.co.kr/doc/amazoncar_comemp_doc3.pdf";
										
	flag = ImEmailDb.insertDEmailEnc4(d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content);
	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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



