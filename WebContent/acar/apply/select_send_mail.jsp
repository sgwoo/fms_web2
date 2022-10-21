<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	int    est_size 	= request.getParameter("est_size")==null?0:AddUtil.parseInt(request.getParameter("est_size"));
	
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");
	
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	
	String content_st 	= request.getParameter("content_st")==null?"":request.getParameter("content_st");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");

	//[���νſ����� ��ȸ����] ÷�� ����
	String file_add_yn1 	= request.getParameter("file_add_yn1")	==null?"":request.getParameter("file_add_yn1");

		//[����ڵ����] ÷�� ����
	String file_add_yn2 	= request.getParameter("file_add_yn2")	==null?"":request.getParameter("file_add_yn2");
	
	if(String.valueOf(request.getParameterValues("est_id")).equals("") || String.valueOf(request.getParameterValues("est_id")).equals("null")){
		out.println("���õ� ������ �����ϴ�.");
		return;
	}	
			
	String vid[] = request.getParameterValues("est_id");
	int vid_size = vid.length;
	
	int count = 0;
	
	System.out.println("�������ϰ����Ϲ߼� : mail_addr="+mail_addr);
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
//	�������·�ó�� �̸��Ͽ� ���������̺� �����ְ� ��ũ�Ŵ� ������� �Ѵ�.
	
	String pack_id  = Long.toString(System.currentTimeMillis());
	
	for(int i=0; i < vid_size; i++){
		String est_id = vid[i];
		
		EstiPackBean ep_bean = new EstiPackBean();
		ep_bean.setPack_id	(pack_id);
		ep_bean.setSeq		(i+1);
		ep_bean.setEst_id	(est_id);
		ep_bean.setEst_table	("estimate");
		ep_bean.setPack_st	("1");//1-����
		ep_bean.setReg_id	(user_id);
		ep_bean.setMemo		(memo);
		
		count = e_db.insertEstiPack(ep_bean);
	}
	
	//�������Ϻ�����
	
	EstimateBean e_bean = new EstimateBean();
	
	if(vid_size==1){
		String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
		e_bean = e_db.getEstimateCase(est_id);
	}else{
		if(vid_size>0){
			String est_id = vid[0];
			e_bean = e_db.getEstimateCase(est_id);
		}
	}
	
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	
	String user_email = "";
	
//	if(user_bean.getUser_email().equals("")){
//		user_email = user_bean.getUser_email();
//	}
	
//	if(user_email.equals("")){
		user_email = "sales@amazoncar.co.kr";
//	}
	
	if(replyto_st.equals("1")){
			replyto = "\"�Ƹ���ī\"<sales@amazoncar.co.kr>";
	}else if(replyto_st.equals("2")){
		if(!user_id.equals("")){
			replyto = "\"�Ƹ���ī "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
		}else{
			replyto = "\"�Ƹ���ī\"<sales@amazoncar.co.kr>";
		}
	}else if(replyto_st.equals("3")){
		if(!replyto.equals("")){
			if(!user_id.equals("")){
				replyto = "\"�Ƹ���ī "+user_bean.getUser_nm()+"\"<"+replyto+">";
			}else{
				replyto = "\"�Ƹ���ī\"<"+replyto+">";
			}
		}else{
			replyto = "\"�Ƹ���ī\"<sales@amazoncar.co.kr>";
		}
	}
	
	DmailBean d_bean = new DmailBean();
	d_bean.setSubject			("[�Ƹ���ī] "+e_bean.getEst_nm()+" ���� ���뿩 �������Դϴ�.");
	d_bean.setSql				("SSV:"+mail_addr.trim()); 
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			(replyto);
	d_bean.setMailto			("\""+e_bean.getEst_nm()+"\"<"+mail_addr.trim()+">");
	d_bean.setReplyto			("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"�Ƹ���ī\"<return@amazoncar.co.kr>");
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				(pack_id);
	d_bean.setRname				("mail");
	d_bean.setMtype       		(0);
	d_bean.setU_idx       		(1);//admin����
	d_bean.setG_idx				(1);//admin����
	d_bean.setMsgflag     		(0);
	d_bean.setContent			("http://fms1.amazoncar.co.kr/acar/apply/select_esti_email.jsp?pack_id="+pack_id+"&user_id="+user_id+"&content_st="+content_st+"&from_page="+from_page);	//&est_nm="+e_bean.getEst_nm()+"
	
	//[���νſ����� ��ȸ����] ÷��
	if(file_add_yn1.equals("Y")){
		d_bean.setEncoding			(3); //����÷��
		d_bean.setAtc_set			(1);
	}

	boolean flag = e_db.insertDEmail(d_bean, "+0.003", "+7");
	

	//[���νſ����� ��ȸ����] ÷��
	if(file_add_yn1.equals("Y")){
														
		String add_fileinfo 	= "���νſ����� ��ȸ���Ǽ�.pdf";
		String add_content 	= "https://fms3.amazoncar.co.kr/doc/amazoncar_bus_doc.pdf";
						
		flag = e_db.insertDEmailEnc3(d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content);
			
	}
	//[����ڵ����] ÷��
		if(file_add_yn2.equals("Y")){
														
			String add_fileinfo 	= "�Ƹ���ī ����ڵ����.pdf";
			String add_content 	= "https://fms3.amazoncar.co.kr/doc/amazoncar_new.pdf";
						
			flag = e_db.insertDEmailEnc3(d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content);
			
		}

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



