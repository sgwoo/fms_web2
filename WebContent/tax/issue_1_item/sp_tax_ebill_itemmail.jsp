<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase 		nm_db 	= MaMenuDatabase.getInstance();
	
	out.println("���ݰ�꼭 �����ϱ� 3�ܰ�"+"<br><br>");
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-��ü����,select���ù���
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-�ϰ�����,2-���չ���,3-��������
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":AddUtil.replace(request.getParameter("tax_out_dt"),"-","");//��������
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String mail_auto_yn = request.getParameter("mail_auto_yn")==null?"":request.getParameter("mail_auto_yn");//���Ϲ�����	
	
	out.println("reg_st  ="+reg_st+"<br>");
	out.println("reg_gu  ="+reg_gu+"<br>");
	out.println("tax_out_dt="+tax_out_dt+"<br>");
	out.println("reg_code="+reg_code+"<br><br>");
	
	int flag = 0;
	
	if(nm_db.getWorkAuthUser("������",user_id)) user_id = nm_db.getWorkAuthUser("���ݰ�꼭�����");


	
	
	
	//û���� ���Ϲ߼� (web�۾�)-----------------------------------------------------------
	
	
	Vector vt = IssueDb.getCP_TaxEbillItemMail(reg_code);
	int vt_size = vt.size();
	
	int m_flag = 0;
	
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject				(String.valueOf(ht.get("RECCONAME"))+"��, (��)�Ƹ���ī "+String.valueOf(ht.get("TAX_YEAR"))+"�� "+String.valueOf(ht.get("TAX_MON"))+"�� ���뿩�� �ŷ������Դϴ�.");
		d_bean.setSql					("SSV:"+String.valueOf(ht.get("AGNT_EMAIL")).trim());
		d_bean.setReject_slist_idx		(0);
		d_bean.setBlock_group_idx		(0);
		d_bean.setMailfrom				("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
		d_bean.setMailto				("\""+String.valueOf(ht.get("RECCONAME"))+"\"<"+String.valueOf(ht.get("AGNT_EMAIL")).trim()+">");
		d_bean.setReplyto				("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
		d_bean.setErrosto				("\"�Ƹ���ī\"<return@amazoncar.co.kr>");
		d_bean.setHtml					(1);
		d_bean.setEncoding				(0);
		d_bean.setCharset				("euc-kr");
		d_bean.setDuration_set			(1);
		d_bean.setClick_set				(0);
		d_bean.setSite_set				(0);
		d_bean.setAtc_set				(0);
		d_bean.setGubun					(reg_code);
		d_bean.setRname					("mail");
		d_bean.setMtype       			(0);
		d_bean.setU_idx       			(1);//admin����
		d_bean.setG_idx					(1);//admin����
		d_bean.setMsgflag     			(0);
		d_bean.setContent				("http://fms1.amazoncar.co.kr/mailing/tax_bill/bill_doc_simple2.jsp?gubun=1&item_reg_code="+reg_code+"&site_id="+String.valueOf(ht.get("SEQ"))+"&client_id="+String.valueOf(ht.get("CLIENT_ID")));
		if(!IssueDb.insertDEmail(d_bean, "", "")) m_flag += 1;
		
		if(m_flag == 0){
			//2. SMS ���-------------------------------
			if(!String.valueOf(ht.get("AGNT_M_TEL")).equals("")&&!String.valueOf(ht.get("AGNT_M_TEL")).equals("-")){
				String msg = String.valueOf(ht.get("AGNT_NM"))+"�� "+String.valueOf(ht.get("AGNT_EMAIL"))+"���� "+String.valueOf(ht.get("TAX_MON"))+"�� �ŷ����� ����-�Ƹ���ī-";
				IssueDb.insertsendMail("02-392-4243", "�Ƹ���ī", String.valueOf(ht.get("AGNT_M_TEL")), String.valueOf(ht.get("RECCONAME2")), String.valueOf(ht.get("TAX_MON")), "+0.10", msg);
			}
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.reg_gu.value == '2' && fm.tax_out_dt.value == ''){
			fm.action = '/tax/issue_2_item/issue_2_frame.jsp';
			fm.target = 'd_content';					
			alert("����߱�!!");
		}else{
			fm.action = 'issue_1_frame.jsp';
			fm.target = 'd_content';		
			alert("����߱�!!");
		}
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_st' 		value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='tax_out_dt' 	value='<%=tax_out_dt%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='tax_code' 	value='<%=reg_code%>'>
<a href="javascript:go_step()">3�ܰ�� ����</a>
<script language='javascript'>
<!--
<%	if(m_flag > 0){//�����߻�%>
		alert("�ŷ����� �̸��� �ۼ��� ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>		
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
