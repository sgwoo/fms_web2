<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.pay_mng.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	
	
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String value00[] = request.getParameterValues("value00");//����
	String value01[] = request.getParameterValues("value01");//���࿩��
	String value02[] = request.getParameterValues("value02");//��������
	String value03[] = request.getParameterValues("value03");//���ݽð�
	String value04[] = request.getParameterValues("value04");//���ݱ���
	String value05[] = request.getParameterValues("value05");//���ݴܰ�
	String value06[] = request.getParameterValues("value06");//�ڰ�������
	String value07[] = request.getParameterValues("value07");//�ڰ��¹�ȣ
	String value08[] = request.getParameterValues("value08");//���������
	String value09[] = request.getParameterValues("value09");//����¹�ȣ
	String value10[] = request.getParameterValues("value10");//��������
	String value11[] = request.getParameterValues("value11");//�����Ƿھ�
	String value12[] = request.getParameterValues("value12");//���ݾ�
	String value13[] = request.getParameterValues("value13");//������
	String value14[] = request.getParameterValues("value14");//���Ұ����ܾ�(��ü��)
	String value15[] = request.getParameterValues("value15");//�������޽���
	
	String result[]  = new String[value00.length];
	String payseq[]  = new String[value00.length];
	
	int flag = 0;
	int seq = 0;
	String reqseq		= "";
	String a_bank_nm="";
	int a_index_nm =0;
	String bank_nm="";
	int index_nm =0;
	String search_code  = Long.toString(System.currentTimeMillis());
	String bank_n="";
	
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		PayMngBean bean = new PayMngBean();
		
		bean.setReqseq		("");
		bean.setReg_id		(user_id);
		bean.setReg_st		("A");
		bean.setP_way		("5");
		bean.setOff_nm		("(��)�Ƹ���ī");
		bean.setVen_name		("(��)�Ƹ���ī");
		bean.setAmt			(value12[i]==null?0:AddUtil.parseDigit4(value12[i]));
		
		//bank_nm
		if(value08[i]==null){
		
		}else{
			
			bank_nm=value08[i];
			index_nm = bank_nm.indexOf("(");
			if(index_nm>0){
				bank_nm = bank_nm.substring(0,index_nm);
			}
			if(bank_nm.equals("SC")){
				bank_nm = "����";
			}else if(bank_nm.equals("����")){
				bank_nm = "NH����";
			}
			Hashtable bank_ht = ps_db.getBankCode("", bank_nm);
			if(String.valueOf(bank_ht.get("NM")).equals("null")){
			}else{
				bean.setBank_nm(String.valueOf(bank_ht.get("NM")).replace("����",""));
			}
		}
			
			
		
		bean.setBank_no	(value09[i]==null?"":value09[i]);
		
		//a_bank_nm
		if(value06[i]==null){
		
		}else{
			
			a_bank_nm=value06[i];
			a_index_nm = a_bank_nm.indexOf("(");
			if(a_index_nm>0){
				a_bank_nm = a_bank_nm.substring(0,a_index_nm);
			}
			if(a_bank_nm.equals("SC")){
				a_bank_nm = "����";
			}else if(a_bank_nm.equals("����")){
				a_bank_nm = "NH����";
			}
			Hashtable bank_ht2 = ps_db.getBankCode("", a_bank_nm);
			if(String.valueOf(bank_ht2.get("NM")).equals("null")){
				if(a_bank_nm.equals("��Ƽ")){
					bean.setA_bank_nm("��Ƽ");
				}
			}else{
				bean.setA_bank_nm(String.valueOf(bank_ht2.get("NM")).replace("����",""));
			}
		}
		
		if(value07[i]==null){
		
		}else{
			
			Hashtable bank_ht3 = ps_db.getBankBarNum(AddUtil.replace(value07[i],"-",""));
				bean.setA_bank_no(String.valueOf(bank_ht3.get("DEPOSIT_NO")));
				bank_n =String.valueOf(bank_ht3.get("DEPOSIT_NO"));
		}
		
		
		bean.setP_est_dt	(value02[i]==null?"":value02[i]);
		bean.setP_step  ("4");
		bean.setBank_acc_nm		("(��)�Ƹ���ī");
		bean.setCommi(value13[i]==null?0:AddUtil.parseInt(value13[i]));
		
		//out.println("value09[i]="+value09[i]);
		//out.println("bank_no="+bean.getBank_no());
		//out.println("value07[i]="+value07[i]);
		//out.println("a_bank_no="+bean.getA_bank_no());
		
		reqseq = pm_db.insertPay2(bean);
		
		payseq[i] = reqseq;
		
		out.println("<br>");
		
		if(!reqseq.equals("")){
			PayMngBean bean2 	= new PayMngBean();
				
			bean2.setReqseq			(reqseq);
			bean2.setI_seq			(1);
			bean2.setP_gubun		("60");
			bean2.setP_st2			("�ڱ�����");
			bean2.setP_st3			("������ü");
			bean2.setR_est_dt		(value02[i]==null?"":value02[i]);
			bean2.setI_amt			(value12[i]==null?0:AddUtil.parseDigit4(value12[i]));
			bean2.setI_s_amt		(value12[i]==null?0:AddUtil.parseDigit4(value12[i]));
			bean2.setAcct_code	("10300");
			String p_cont1 = "";
			p_cont1 = bank_n;
			String p_cont2 = "";
			p_cont2 = value09[i]==null?"":value09[i];
			bean2.setP_cont			("�ڱ�����("+a_bank_nm+p_cont1+"->"+bank_nm+p_cont2+")");
		
			if(!pm_db.insertPayItem2(bean2)) flag += 1;
		}
		reqseq="";
}
	
	
	if(1==1) return;
	
	
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'pay_excel_reg_bank_step3.jsp';
		fm.submit();
	}
//-->
</script>
</HEAD>
<BODY>
<p>���� ���� �о� ���� ����ϱ�
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='from_page' value='/fms2/pay_mng/pay_excel_reg_bank_step2.jsp'>
<input type='hidden' name='search_code' value='<%=search_code%>'>
<%for(int i=start_row ; i <= value_line ; i++){%>
<input type='hidden' name='payseq' value='<%=payseq[i]%>'>
<%}%>
	<%for(int i=start_row ; i <= value_line ; i++){%>
<%=payseq[i]%><br>
<%}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--	
<%	if(flag==1){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
	alert("����Ͽ����ϴ�.");
<%	}%>	
//-->
</SCRIPT>
</BODY>
</HTML>