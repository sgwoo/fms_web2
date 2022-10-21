<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.net.*, acar.util.*, tax.*, acar.estimate_mng.*, acar.user_mng.*,acar.im_email.*" %>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<% 
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
	String view_amt = request.getParameter("view_amt")==null?"":request.getParameter("view_amt");
	String pay_way = request.getParameter("pay_way")==null?"":request.getParameter("pay_way");
	
	String view_good = request.getParameter("view_good")==null?"":request.getParameter("view_good");
	String view_tel = request.getParameter("view_tel")==null?"":request.getParameter("view_tel");
	String view_addr = request.getParameter("view_addr")==null?"":request.getParameter("view_addr");	
	
	String est_nm 		= request.getParameter("est_nm")==null?"��":request.getParameter("est_nm");	
	String mail_addr 	= request.getParameter("mail_addr")==null?"":request.getParameter("mail_addr");
	
	String replyto_st 	= request.getParameter("replyto_st")==null?"1":request.getParameter("replyto_st");
	String replyto 		= request.getParameter("replyto")==null?"":request.getParameter("replyto");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");
	
	String send_st 		= request.getParameter("send_st")==null?"1":request.getParameter("send_st");
		
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	
	String user_email = "";
	user_email = "sales@amazoncar.co.kr";
	
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
	d_bean.setSubject			("[�Ƹ���ī] "+est_nm+" �� �Ƹ���ī �����Դϴ�.");
	d_bean.setSql				("SSV:"+mail_addr.trim());
	d_bean.setReject_slist_idx	(0);
	d_bean.setBlock_group_idx	(0);
	d_bean.setMailfrom			(replyto);
	d_bean.setMailto			("\""+est_nm+"\"<"+mail_addr.trim()+">");
	d_bean.setReplyto			("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
	d_bean.setErrosto			("\"�Ƹ���ī\"<return@amazoncar.co.kr>");
	d_bean.setHtml				(1);
	d_bean.setEncoding			(0);
	d_bean.setCharset			("euc-kr");
	d_bean.setDuration_set		(1);
	d_bean.setClick_set			(0);
	d_bean.setSite_set			(0);
	d_bean.setAtc_set			(0);
	d_bean.setGubun				("docs");
	d_bean.setRname				("mail");
	d_bean.setMtype       		(0);
	d_bean.setU_idx       		(1);//admin����
	d_bean.setG_idx				(1);//admin����
	d_bean.setMsgflag     		(0);
	d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/off_doc/select_esti_email_rent_docs.jsp?est_nm="+URLEncoder.encode(est_nm, "EUC-KR")+"&var1="+user_id+"&var2="+rent_l_cd+"&var3="+type+"&var4="+rent_mng_id+"&var5="+client_id+"&var6="+rent_st+"&view_amt="+view_amt+"&pay_way="+pay_way+"&view_good="+view_good+"&view_tel="+view_tel+"&view_addr="+view_addr+"&memo="+URLEncoder.encode(memo, "EUC-KR"));

	boolean flag = true;
	
	//����
	flag = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");
		

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



