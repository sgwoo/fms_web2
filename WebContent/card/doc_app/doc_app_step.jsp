<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
		
		
	out.println("ī����ǥ �ڵ���ǥ �����ϱ� 1�ܰ�"+"<br><br>");
	
	
	//�����
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
   int flag = 0;
	int seq = 0;

	String vid[] = request.getParameterValues("ch_l_cd");
	String vid_num="";
	String ch_buy_id="";
	String ch_cardno="";
	int vid_size = vid.length;
	out.println("���ðǼ�="+vid_size+"<br><br>");

	out.println("====================================<br>");

	//[1�ܰ�] ������ ��ǥ ��ȸ

	for(int i=0;i < vid_size;i++){
		vid_num 	= vid[i];
		ch_buy_id 		= vid_num.substring(0,6);
		ch_cardno 		= vid_num.substring(6);
				
//		System.out.println(i+")ī���ȣ="+ch_cardno+",��ǥ��ȣ="+ch_buy_id);
		
	//	out.println("ī���ȣ="+ch_cardno+"<br>");
	//	out.println("��ǥ��ȣ="+ch_buy_id+"<br>");
		
			//ī������
	 CardDocBean cd_bean = CardDb.getCardDoc(ch_cardno, ch_buy_id);
	 	 
	 String acct_code 	= cd_bean.getAcct_code();
	String acct_code_g 	= cd_bean.getAcct_code_g();
	String acct_code_g2 = cd_bean.getAcct_code_g2();
	String acct_cont 	= cd_bean.getAcct_cont()==null?"":cd_bean.getAcct_cont();

	String item_name	= cd_bean.getItem_name();
	String doc_acct_cont = "";
			
	if(!item_name.equals("") && cd_bean.getItem_name().indexOf("(")!=-1){
		item_name 	= cd_bean.getItem_name().substring(0, cd_bean.getItem_name().indexOf("("));
	}
			
	String user_su 		= cd_bean.getUser_su();
	String user_cont	= cd_bean.getUser_cont();

		//�����Ļ���
		if(acct_code.equals("00001")){
			if(acct_code_g.equals("1")      && acct_code_g2.equals("1"))	doc_acct_cont = "���Ĵ�:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("2"))	doc_acct_cont = "�߽Ĵ�:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("3"))	doc_acct_cont = "���Ĵ�:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("4"))	doc_acct_cont = "ȸ����ü����:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("5"))	doc_acct_cont = "�μ����������:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("6"))	doc_acct_cont = "�μ���������ȸ��:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("15"))	doc_acct_cont = "�系��ȣȸ:"+acct_cont;
			else if(acct_code_g.equals("15") )								doc_acct_cont = "������:"+acct_cont;
			else if(acct_code_g.equals("30") )								doc_acct_cont = "�����ް�:"+acct_cont;
			else 							 								doc_acct_cont = acct_cont;

		//����������
		}else if(acct_code.equals("00004")){
			if(acct_code_g.equals("13"))			doc_acct_cont = "���ָ�";
			else if(acct_code_g.equals("4"))		doc_acct_cont = "����";
			else if(acct_code_g.equals("5"))		doc_acct_cont = "LPG";
			else if(acct_code_g.equals("27"))		doc_acct_cont = "����������";	//���������� �߰�
			
			if(acct_code_g2.equals("11"))			doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("12"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("13"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			
				
		//���������
		}else if(acct_code.equals("00005")){
			
			if(acct_code_g.equals("6"))				doc_acct_cont = "�Ϲ�����:"+acct_cont;
			else if(acct_code_g.equals("7"))		doc_acct_cont = "�ڵ����˻�:"+acct_cont;
			else if(acct_code_g.equals("18"))		doc_acct_cont = "��ȣ�Ǵ��:"+acct_cont;		
			else if(acct_code_g.equals("21"))		doc_acct_cont = "�縮������:"+acct_cont;	
			else if(acct_code_g.equals("22"))		doc_acct_cont = acct_cont;	
							
		//��������
		}else if(acct_code.equals("00006")){
		
			doc_acct_cont = acct_cont;			
		
		//�������
		}else if(acct_code.equals("00003")){
		
			//�����
			if(acct_code_g.equals("9"))				doc_acct_cont = "�����:"+acct_cont;
			//�����
			else if(acct_code_g.equals("12"))		doc_acct_cont = "��Ÿ�����:"+acct_cont;
			//�����н�
			else if(acct_code_g.equals("20"))		doc_acct_cont = "�����н�:"+acct_cont;
				//�����н�
			else if(acct_code_g.equals("32"))		doc_acct_cont = "��������:"+acct_cont;
		
		//�����
		}else if(acct_code.equals("00002")){
		
			//�Ĵ�
			if(acct_code_g.equals("11"))			doc_acct_cont = "�Ĵ�:"+acct_cont;
			//������
			else if(acct_code_g.equals("12"))		doc_acct_cont = "������:"+acct_cont;
			//��Ÿ
			else if(acct_code_g.equals("14"))		doc_acct_cont = acct_cont;
		
		//��ź�
		}else if(acct_code.equals("00009")){
													doc_acct_cont = "��ź�:"+acct_cont;
		
		//�뿩�������
		}else if(acct_code.equals("00016")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "������ϼ�:"+acct_cont;
		
		//�����������
		}else if(acct_code.equals("00017")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "������ϼ�:"+acct_cont;
		
		}else{
		
			doc_acct_cont = acct_cont;
		
		}

		if(!user_cont.equals("")) 		doc_acct_cont = doc_acct_cont+" "+user_cont;
		if(!user_su.equals("")) 		doc_acct_cont = doc_acct_cont+"("+user_su+"��)";
			 
		
	   if(cd_bean.getAcct_cont().equals("")){
    	 if(!CardDb.updateCardDoc(ch_cardno, ch_buy_id, doc_acct_cont) ) flag += 1;	
	  }
			
		//�ڵ���ǥ ���ν��� ȣ��----------------------------------------------------------------------------
		//int flag4 = 0;
	   System.out.println(" �ڵ���ǥ ���ν��� ��� "+sender_bean.getUser_nm()+" "+ch_cardno+" "+ch_buy_id + " <br>"  );
		String  d_flag1 =  neoe_db.call_sp_card_account(sender_bean.getUser_nm(), "", ch_cardno, ch_buy_id);			
					
	}
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'doc_app_frame.jsp';
		fm.target = "d_content";
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
<a href="javascript:go_step()">�Ϸ�</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("�ڵ���ǥ �ۼ��� ������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("���������� �����Ͽ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
