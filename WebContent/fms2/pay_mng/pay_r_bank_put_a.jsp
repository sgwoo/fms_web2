<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.pay_mng.*, acar.inside_bank.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%	
	PayMngDatabase 			pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();	
	InsideBankDatabase 	ib_db 	= InsideBankDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	int ib_result = 0;
	int flag = 0;
	

	String vid[] 	= request.getParameterValues("ch_cd");
	String actseq 	= "";
	int act_modify = 0;
	
	int vid_size = vid.length;
	
	out.println("���ðǼ�="+vid_size+"<br><br>");
	
	
	for(int i=0;i < vid_size;i++){
		
		actseq = vid[i];
		
		act_modify = 0;
		
		//�۱ݿ���
		PayMngActBean act 	= pm_db.getPayAct(actseq);
		
		
		//�������� ����� ����϶��� ó����.
		if(!act.getA_bank_no().equals("140-004-023871")){
			out.println("continue �������� ����� ����϶��� ó����");
			continue;
		}
		
		
		//���ϰ��°� �ƴҶ�		
		if(act.getA_bank_no().equals(act.getBank_no())){
			out.println("continue ���ϰ��°� �ƴҶ�");
			continue;
		}
		
		
		//�۱ݼ����� ó��-���忡�� ó��
		Vector vt3 =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
		int vt_size3 = vt3.size();
		
				
		if(vt_size3==0){
			out.println("continue �۱ݼ����� ó��-���忡�� ó��");
			continue;
		}
		
		
		
		
		//1. ���࿬�����̺� ���-------------------------------------------------------------------------------------------
		
		IbBulkTranBean it = new IbBulkTranBean();
		
		it.setTran_dt							(act.getAct_dt());
		it.setGroup_nm        		(AddUtil.substringb(act.getOff_nm(),30));
		it.setTran_ji_acct_nb			(act.getA_bank_no());
		it.setTran_ip_bank_id 		(act.getBank_cms_bk());
		it.setTran_ip_acct_nb 		(act.getBank_no());
		it.setTran_remittee_nm		(AddUtil.substringb(act.getBank_acc_nm(),20));
		it.setTran_amt_req     		(String.valueOf((long)act.getAmt()));
		it.setTran_ji_naeyong 		("");
		it.setTran_ip_naeyong 		(AddUtil.substringb(act.getBank_memo(),14));
		it.setTran_cms_cd     		(act.getCms_code());
		it.setTran_memo       		(AddUtil.substringb(act.getOff_nm(),20));
		it.setUpche_key       		(actseq);
						
		//�������-�Ｚī���϶��� ī���ȣ�� CMS�ڵ忡 �־���.
		if(act.getOff_nm().equals("�Ｚ����(����)������") || act.getOff_nm().equals("�Ｚī��")){			
			Vector p_vt =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
			int p_vt_size = p_vt.size();			
			if(p_vt_size>0){
				for(int p = 0 ; p < 1 ; p++){
					Hashtable p_ht = (Hashtable)p_vt.elementAt(p);
					it.setTran_cms_cd		(String.valueOf(p_ht.get("CARD_NO")));
					it.setTran_cms_cd		(AddUtil.replace(it.getTran_cms_cd(),"-",""));
				}
			}
		}
		
		//�ڵ��������-�Ｚī���ϴ�� ī���ȣ�� CMS�ڵ忡 �־���.
		if(act.getOff_nm().equals("�Ｚȭ��")||act.getOff_nm().equals("����ȭ��")){			
			Vector p_vt =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
			int p_vt_size = p_vt.size();			
			if(p_vt_size>0){
				for(int p = 0 ; p < 1 ; p++){
					Hashtable p_ht = (Hashtable)p_vt.elementAt(p);
					it.setTran_cms_cd		(String.valueOf(p_ht.get("CARD_NO")));
					it.setTran_cms_cd		(AddUtil.replace(it.getTran_cms_cd(),"-",""));
				}
			}
		}
								
		//����� ������ �������� ����		
		act.setA_bank_cms_bk		("026");
		
		if(act.getBank_nm().equals("����")||act.getBank_nm().equals("��������")||act.getBank_nm().equals("����")||act.getBank_nm().equals("��������")||act.getBank_nm().equals("������������")){
			act.setBank_cms_bk		("026");
			it.setTran_ip_bank_id ("026");
		}else if(act.getBank_nm().equals("(��)����")||act.getBank_nm().equals("(��)��������")){
			act.setBank_cms_bk		("026");
			it.setTran_ip_bank_id ("026");
		}else if(act.getBank_nm().equals("(��)����")||act.getBank_nm().equals("(��)��������")){
			act.setBank_cms_bk		("021");
			it.setTran_ip_bank_id ("021");
		}
		
		if(act.getBank_nm().equals("�����߾�ȸ"))				act.setBank_nm		("NH����");
		if(act.getBank_nm().equals("������"))					act.setBank_nm		("NH����");
		if(act.getBank_nm().equals("NH��������"))				act.setBank_nm		("NH����");
		if(act.getBank_nm().equals("��Ƽ"))					act.setBank_nm		("�ѱ���Ƽ");
		if(act.getBank_nm().equals("��Ƽ"))					act.setBank_nm		("�ѱ���Ƽ");
		if(act.getBank_nm().equals("SC����"))					act.setBank_nm		("SC����");
		if(act.getBank_nm().equals("SC��������"))				act.setBank_nm		("SC����");
		if(act.getBank_nm().equals("���Ĵٵ���Ÿ��"))			act.setBank_nm		("SC����");
		if(act.getBank_nm().equals("�����߾�ȸ"))				act.setBank_nm		("����");		
		if(act.getBank_nm().equals("��������"))				act.setBank_nm		("�����߾�ȸ");
		if(act.getBank_nm().equals("����"))					act.setBank_nm		("�����߾�ȸ");
		if(act.getBank_nm().equals("�������ݰ���ȸ"))			act.setBank_nm		("�������ݰ�");
		if(act.getBank_nm().equals("�긲����"))				act.setBank_nm		("�긲�����߾�ȸ");
		if(act.getBank_nm().equals("���"))					act.setBank_nm		("KDB���");
		if(act.getBank_nm().equals("�������"))				act.setBank_nm		("KDB���");
		if(act.getBank_nm().equals("��ȯ"))					act.setBank_nm		("KEB�ϳ�");
		if(act.getBank_nm().equals("��ȯ����"))				act.setBank_nm		("KEB�ϳ�");
		if(act.getBank_nm().equals("���̹�ũ"))				act.setBank_nm		("K��ũ");
		if(act.getBank_nm().equals("�ϳ�"))					act.setBank_nm		("KEB�ϳ�");
		if(act.getBank_nm().equals("�ϳ�����"))				act.setBank_nm		("KEB�ϳ�");
		if(act.getBank_nm().equals("�������"))				act.setBank_nm		("IBK���");
		if(act.getBank_nm().equals("����������"))				act.setBank_nm		("��������");
		
		
		
		
		
		
		//������ü(����ó) �����ڵ�-code
		if(it.getTran_ip_bank_id().equals("")){
			Hashtable ht = ps_db.getBankCode("", act.getBank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				act.setBank_nm				(String.valueOf(ht.get("NM")));
				act.setBank_cms_bk		(String.valueOf(ht.get("CMS_BK")));				
				it.setTran_ip_bank_id (act.getBank_cms_bk());
				act_modify++;
			}
		}
				
		//out.print("act.getBank_nm()="+act.getBank_nm());
		//out.print("it.getTran_ip_bank_id()="+it.getTran_ip_bank_id()+"<br>");
		
		if(!act.getBank_nm().equals("") && !it.getTran_ip_bank_id().equals("")){
			if(act_modify >0){
				//�۱ݼ���
				if(!pm_db.updatePayActBK(act)) flag += 1; //pay_act / pay ó��
			}
						
			it.setTran_ip_acct_nb 		(act.getBank_no());
												
			if(!ib_db.insertIbBulkTran(it)) 	ib_result += 1;
		}
	}
	
	%>
	
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
	
<script language='javascript'>
<%		if(result>0){	%>	alert('�����Դϴ�.\n\nȮ���Ͻʽÿ�');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name="mode" 			value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>