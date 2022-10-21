<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.pay_mng.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	
	
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String value00[] = request.getParameterValues("value00");//�ŷ�����
	String value01[] = request.getParameterValues("value01");//�ŷ�ó����
	String value02[] = request.getParameterValues("value02");//�����
	String value03[] = request.getParameterValues("value03");//��������
	String value04[] = request.getParameterValues("value04");//�ݾ�
	String value05[] = request.getParameterValues("value05");//���ݰ�꼭����
	String value06[] = request.getParameterValues("value06");//���ݿ��������ι�ȣ
	String value07[] = request.getParameterValues("value07");//�����ޱݹ��࿩��
	String value08[] = request.getParameterValues("value08");//��ݹ��
	String value09[] = request.getParameterValues("value09");//�����
	String value10[] = request.getParameterValues("value10");//���¹�ȣ
	String value11[] = request.getParameterValues("value11");//�������
	String value12[] = request.getParameterValues("value12");//���ް�
	String value13[] = request.getParameterValues("value13");//�ΰ���
	String value14[] = request.getParameterValues("value14");//�հ�
	String value15[] = request.getParameterValues("value15");//���������ڵ�
	String value16[] = request.getParameterValues("value16");//��뱸��
	String value17[] = request.getParameterValues("value17");//�󼼱���1
	String value18[] = request.getParameterValues("value18");//�󼼱���2
	String value19[] = request.getParameterValues("value19");//����
	String value20[] = request.getParameterValues("value20");//�����ο���-> ����ݾ�1
	String value21[] = request.getParameterValues("value21");//����ݾ�2
	String value22[] = request.getParameterValues("value22");//����ݾ�3
	String value23[] = request.getParameterValues("value23");//����ݾ�4
	String value24[] = request.getParameterValues("value24");//����ݾ�5
	
	
	String result[]  = new String[value00.length];
	String payseq[]  = new String[value00.length];
	
	int flag = 0;
	int seq = 0;
	
	String reqseq		= "";
	
	
	String search_code  = Long.toString(System.currentTimeMillis());
	
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		PayMngBean bean = new PayMngBean();
		
		bean.setReqseq		("");
		bean.setP_est_dt	(value00[i]==null?"":value00[i]);
		bean.setReg_st		("D");
		bean.setP_gubun		("99");
		bean.setP_st1		("99");
		bean.setP_st2		("");
		bean.setP_st3		("");
		bean.setP_st4		("�������");
		bean.setP_cd1		("");
		bean.setP_cd2		("");
		bean.setP_cd3		("");
		bean.setOff_st		("other");
		
		
		String off_st 		= value01[i]==null?"":value01[i];
		if(off_st.equals("1")) 	bean.setOff_st		("user_id");
		
		UsersBean offer_bean = new UsersBean();
		
		if(off_st.equals("1")){	//�Ƹ���ī����
			
			String off_user_nm 	= value02[i]==null?"":value02[i];
			
			//������� ��ȸ
			offer_bean = umd.getUserNmBean(off_user_nm);
			bean.setOff_id		(offer_bean.getUser_id());
			bean.setOff_nm		(offer_bean.getUser_nm());
			bean.setVen_code	(offer_bean.getVen_code());
			bean.setVen_name	(offer_bean.getUser_nm());
			bean.setS_idno		(offer_bean.getUser_ssn());
			bean.setOff_tel		(offer_bean.getUser_m_tel());
			
		}else{					//�ŷ�ó
			
			bean.setOff_id		(value02[i]==null?"":value02[i]);
			
			//�׿����ŷ�ó ��ȸ
			Hashtable ven = neoe_db.getTradeCase(bean.getOff_id());
			bean.setOff_nm		(String.valueOf(ven.get("CUST_NAME")));
			bean.setVen_code	(String.valueOf(ven.get("CUST_CODE")));
			bean.setVen_name	(String.valueOf(ven.get("CUST_NAME")));
			bean.setS_idno		(String.valueOf(ven.get("S_IDNO")));
			bean.setOff_tel		(String.valueOf(ven.get("TEL_NO")));
			
		}
		
		bean.setVen_st			(value03[i]==null?"":value03[i]);
		bean.setAmt					(value04[i]==null?0:AddUtil.parseDigit4(value04[i]));
		bean.setTax_yn			(value05[i]==null?"":value05[i]);
		bean.setCash_acc_no	(value06[i]==null?"":value06[i]);
		bean.setAcct_code_st(value07[i]==null?"":value07[i]);
		bean.setP_way				(value08[i]==null?"":value08[i]);
		
		if(bean.getAcct_code_st().equals("2")) 	bean.setR_acct_code	("25300");//�����
		
		if(bean.getP_way().equals("1")) 	bean.setP_st3("����");
		if(bean.getP_way().equals("2")) 	bean.setP_st3("����ī��");
		if(bean.getP_way().equals("3")) 	bean.setP_st3("�ĺ�ī��");
		if(bean.getP_way().equals("4")) 	bean.setP_st3("�ڵ���ü");
		if(bean.getP_way().equals("5")){
			bean.setP_st3("������ü");
			
			bean.setBank_nm	(value09[i]==null?"":value09[i]);
			bean.setBank_no	(value10[i]==null?"":value10[i]);
			
			if(off_st.equals("1") && bean.getBank_no().equals("")){	//�Ƹ���ī����
				bean.setBank_nm	(offer_bean.getBank_nm());
				bean.setBank_no	(offer_bean.getBank_no());
			}
			
			if(!bean.getBank_nm().equals("")){
				Hashtable b_ht = ps_db.getBankCode("", bean.getBank_nm());
				if(String.valueOf(b_ht.get("CMS_BK")).equals("null")){
				}else{
					bean.setBank_cms_bk	(String.valueOf(b_ht.get("CMS_BK")));
					bean.setBank_id		(String.valueOf(b_ht.get("CMS_BK")));
				}
			}
			
			bean.setBank_acc_nm	(bean.getOff_nm());
			
			
		}
		if(bean.getP_way().equals("7")) 	bean.setP_st3("ī���Һ�");
		
		if(bean.getP_way().equals("4") || bean.getP_way().equals("5")){
			//������� 026	����	140-004-023871
			bean.setA_bank_id	("026");
			bean.setA_bank_nm	("����");
			bean.setA_bank_no	("140-004-023871");			
		}
		
		
		String buy_user_nm = value11[i]==null?"":value11[i];
		
		if(buy_user_nm.equals("")){
			if(off_st.equals("1")){
				bean.setBuy_user_id		(offer_bean.getUser_id());//�����
			}
		}else{
			UsersBean buyer_bean = umd.getUserNmBean(buy_user_nm);
			bean.setBuy_user_id		(buyer_bean.getUser_id());//�����
		}
		
		
		bean.setI_s_amt		(value12[i]==null?0:AddUtil.parseDigit4(value12[i]));
		bean.setI_v_amt		(value13[i]==null?0:AddUtil.parseDigit4(value13[i]));
		bean.setI_amt			(value14[i]==null?0:AddUtil.parseDigit4(value14[i]));
		
		if(bean.getI_s_amt() == 0){
			bean.setI_s_amt	(bean.getAmt());
		}
		
		if(bean.getI_amt() == 0){
			bean.setI_amt	(bean.getI_s_amt()+bean.getI_v_amt());
		}
		
		bean.setAcct_code		(value15[i]==null?"":value15[i]);
		bean.setCost_gubun	(value16[i]==null?"":value16[i]);
		bean.setAcct_code_g	(value17[i]==null?"":value17[i]);
		bean.setAcct_code_g2(value18[i]==null?"":value18[i]);
		bean.setP_cont			(value19[i]==null?"":value19[i]);
		
		
		
		
		if(!bean.getAcct_code().equals("")){
			//�׿����������� ��ȸ
			Hashtable acct = neoe_db.getAcctCodeNm(bean.getAcct_code());
			bean.setP_st2	(String.valueOf(acct.get("ACCT_NAME2")));
		}
		
		bean.setSub_amt1	(value20[i]==null?0:AddUtil.parseDigit4(value20[i]));
		bean.setSub_amt2	(value21[i]==null?0:AddUtil.parseDigit4(value21[i]));
		bean.setSub_amt3	(value22[i]==null?0:AddUtil.parseDigit4(value22[i]));
		bean.setSub_amt4	(value23[i]==null?0:AddUtil.parseDigit4(value23[i]));
		bean.setSub_amt5	(value24[i]==null?0:AddUtil.parseDigit4(value24[i]));
		bean.setSub_amt6	(0);
		bean.setM_amt			(0);
		bean.setP_step		("0");
		bean.setReg_id		(ck_acar_id);
		bean.setSearch_code	(search_code);
		
		//�ŷ����ڰ� ���� ���
		if(bean.getP_est_dt().equals("")) 		bean.setP_est_dt	(AddUtil.getDate());
		//���������� ���� ���
		if(bean.getVen_st().equals("")){
			if(off_st.equals("1")){
													bean.setVen_st		("0");
			}else{
				if(bean.getS_idno().equals("")){
													bean.setVen_st		("0");
				}else{
					if(bean.getI_v_amt()>0){
													bean.setVen_st		("1");
					}else{
													bean.setVen_st		("2");
					}
				}
			}
		}
		//���ݰ�꼭������ ���� ���
		if(bean.getTax_yn().equals("")) 		bean.setTax_yn		("N");
		//�����ޱݹ��࿩�ΰ� ���� ���
		if(bean.getAcct_code_st().equals("")) 	bean.setAcct_code_st("1");
		//��ݹ���� ���� ���
		if(bean.getP_way().equals("")){
			bean.setP_way	("1");
			bean.setP_st3	("����");
		}
		
		reqseq = pm_db.insertPaySearch(bean);
		
		payseq[i] = reqseq;
		
		out.println("<br>");
	}
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
		fm.action = 'pay_excel_reg_step3.jsp';
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
<input type='hidden' name='from_page' value='/fms2/pay_mng/pay_excel_reg_step2.jsp'>
<input type='hidden' name='search_code' value='<%=search_code%>'>
<%for(int i=start_row ; i <= value_line ; i++){%>
<input type='hidden' name='payseq' value='<%=payseq[i]%>'>

<%}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--	
<%	if(reqseq.equals("")){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		go_step();
<%	}%>	
//-->
</SCRIPT>
</BODY>
</HTML>