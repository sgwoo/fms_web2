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
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String result[]  = new String[value_line+10];
	String payseq[]  = new String[value_line+10];
	String value00[] = request.getParameterValues("value0");//�ŷ�����
	String value01[] = request.getParameterValues("value1");//�����
	String value02[] = request.getParameterValues("value2");//��������
	String value03[] = request.getParameterValues("value3");//�ݾ�
	String value04[] = request.getParameterValues("value4");//���ݰ�꼭����
	String value05[] = request.getParameterValues("value5");//���ݿ��������ι�ȣ
	String value06[] = request.getParameterValues("value6");//�����ޱݹ��࿩��
	String value07[] = request.getParameterValues("value7");//��ݹ��
	String value08[] = request.getParameterValues("value8");//�������
	String value09[] = request.getParameterValues("value9");//���ް�
	String value10[] = request.getParameterValues("value10");//�ΰ���
	String value11[] = request.getParameterValues("value11");//�հ�
	String value12[] = request.getParameterValues("value12");//���������ڵ�
	String value13[] = request.getParameterValues("value13");//��뱸��
	String value14[] = request.getParameterValues("value14");//�󼼱���1
	String value15[] = request.getParameterValues("value15");//�󼼱���2
	String value16[] = request.getParameterValues("value16");//����
	String value17[] = request.getParameterValues("value17");//�����ο���
	
	String user_nm0[] = request.getParameterValues("value18");//�����
	String user_pl0[] = request.getParameterValues("value19");//�ݾ�
	String user_nm1[] = request.getParameterValues("value20");//�����
	String user_pl1[] = request.getParameterValues("value21");//�ݾ�
	String user_nm2[] = request.getParameterValues("value22");//�����
	String user_pl2[] = request.getParameterValues("value23");//�ݾ�
	String user_nm3[] = request.getParameterValues("value24");//�����
	String user_pl3[] = request.getParameterValues("value25");//�ݾ�
	String user_nm4[] = request.getParameterValues("value26");//�����
	String user_pl4[] = request.getParameterValues("value27");//�ݾ�
	String user_nm5[] = request.getParameterValues("value28");//�����
	String user_pl5[] = request.getParameterValues("value29");//�ݾ�
	String user_nm6[] = request.getParameterValues("value30");//�����
	String user_pl6[] = request.getParameterValues("value31");//�ݾ�
	String user_nm7[] = request.getParameterValues("value32");//�����
	String user_pl7[] = request.getParameterValues("value33");//�ݾ�
	String user_nm8[] = request.getParameterValues("value34");//�����
	String user_pl8[] = request.getParameterValues("value35");//�ݾ�
	String user_nm9[] = request.getParameterValues("value36");//�����
	String user_pl9[] = request.getParameterValues("value37");//�ݾ�
	
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
		bean.setOff_st		("user_id");
		
		String off_user_nm = value01[i]==null?"":value01[i];
		
		//������� ��ȸ
		UsersBean offer_bean = umd.getUserNmBean(off_user_nm);
		bean.setOff_id		(value01[i]==null?"":value01[i]);
		bean.setOff_nm		(offer_bean.getUser_nm());
		bean.setVen_code	(offer_bean.getVen_code());
		bean.setVen_name	(offer_bean.getUser_nm());
		bean.setS_idno		(offer_bean.getUser_ssn());
		bean.setOff_tel		(offer_bean.getUser_m_tel());
		
		bean.setP_way		(value07[i]==null?"":value07[i]);
		bean.setAmt			(value03[i]==null?0:AddUtil.parseDigit4(value03[i]));
		bean.setVen_st		(value02[i]==null?"":value02[i]);
		bean.setTax_yn		(value04[i]==null?"":value04[i]);
		bean.setCash_acc_no	(value05[i]==null?"":value05[i]);
		bean.setAcct_code_st(value06[i]==null?"":value06[i]);
		
		if(bean.getAcct_code_st().equals("2")) 	bean.setR_acct_code	("25300");//�����
		
		if(bean.getP_way().equals("1")) 	bean.setP_st3("����");
		if(bean.getP_way().equals("2")) 	bean.setP_st3("����ī��");
		if(bean.getP_way().equals("3")) 	bean.setP_st3("�ĺ�ī��");
		if(bean.getP_way().equals("4")) 	bean.setP_st3("�ڵ���ü");
		if(bean.getP_way().equals("5")){
			bean.setP_st3("������ü");
			
			bean.setBank_nm	(offer_bean.getBank_nm());
			bean.setBank_no	(offer_bean.getBank_no());
			
			Hashtable b_ht = ps_db.getBankCode("", bean.getBank_nm());
			if(String.valueOf(b_ht.get("CMS_BK")).equals("null")){
			}else{
				bean.setBank_cms_bk	(String.valueOf(b_ht.get("CMS_BK")));
				bean.setBank_id		(String.valueOf(b_ht.get("CMS_BK")));
			}
		}
		if(bean.getP_way().equals("7")) 	bean.setP_st3("ī���Һ�");
		
		
		String buy_user_nm = value08[i]==null?"":value08[i];
		
		if(buy_user_nm.equals("")){
			bean.setBuy_user_id		(offer_bean.getUser_id());//�����
		}else{
			UsersBean buyer_bean = umd.getUserNmBean(buy_user_nm);
			bean.setBuy_user_id		(buyer_bean.getUser_id());//�����
		}
		
		
		bean.setI_s_amt			(value09[i]==null?0:AddUtil.parseDigit4(value09[i]));
		bean.setI_v_amt			(value10[i]==null?0:AddUtil.parseDigit4(value10[i]));
		bean.setI_amt				(value11[i]==null?0:AddUtil.parseDigit4(value11[i]));
		
		bean.setAcct_code		(value12[i]==null?"":value12[i]);
		bean.setCost_gubun	(value13[i]==null?"":value13[i]);
		bean.setAcct_code_g	(value14[i]==null?"":value14[i]);
		bean.setAcct_code_g2(value15[i]==null?"":value15[i]);
		bean.setP_cont			(value16[i]==null?"":value16[i]);
		bean.setUser_su			(value17[i]==null?"":value17[i]);
		
		if(!bean.getAcct_code().equals("")){
			//�׿����������� ��ȸ
			Hashtable acct = neoe_db.getAcctCodeNm(bean.getAcct_code());
			bean.setP_st2		(String.valueOf(acct.get("ACCT_NAME2")));
		}
		
		bean.setSub_amt1	(0);
		bean.setSub_amt2	(0);
		bean.setSub_amt3	(0);
		bean.setSub_amt4	(0);
		bean.setSub_amt5	(0);
		bean.setSub_amt6	(0);
		bean.setP_step		("0");
		bean.setReg_id		(ck_acar_id);
		bean.setSearch_code	(search_code);
		
		//�ŷ����ڰ� ���� ���
		if(bean.getP_est_dt().equals("")) 		bean.setP_est_dt	(AddUtil.getDate());
		//���������� ���� ���
		if(bean.getVen_st().equals("")){
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
		//���ݰ�꼭������ ���� ���
		if(bean.getTax_yn().equals("")) 		bean.setTax_yn		("N");
		//�����ޱݹ��࿩�ΰ� ���� ���
		if(bean.getAcct_code_st().equals("")) 	bean.setAcct_code_st("1");
		//��ݹ���� ���� ���
		if(bean.getP_way().equals("")) 			bean.setP_way		("1");
		
		
		payseq[i] = reqseq;
		
		out.println("<br>");
	}
	if(1==1)return;
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
		fm.target = '_self';
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
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<input type='hidden' name='from_page' value='/fms2/pay_mng/pay_excel_reg_step2_emp.jsp'>
<input type='hidden' name='search_code' value='<%=search_code%>'>
<%for(int i=start_row ; i <= value_line ; i++){%>
<input type='hidden' name='payseq' value='<%=payseq[i]%>'>
<input type='hidden' name='user_nm0' value='<%=user_nm0[i]%>'>
<input type='hidden' name='user_pl0' value='<%=user_pl0[i]%>'>
<input type='hidden' name='user_nm1' value='<%=user_nm1[i]%>'>
<input type='hidden' name='user_pl1' value='<%=user_pl1[i]%>'>
<input type='hidden' name='user_nm2' value='<%=user_nm2[i]%>'>
<input type='hidden' name='user_pl2' value='<%=user_pl2[i]%>'>
<input type='hidden' name='user_nm3' value='<%=user_nm3[i]%>'>
<input type='hidden' name='user_pl3' value='<%=user_pl3[i]%>'>
<input type='hidden' name='user_nm4' value='<%=user_nm4[i]%>'>
<input type='hidden' name='user_pl4' value='<%=user_pl4[i]%>'>
<input type='hidden' name='user_nm5' value='<%=user_nm5[i]%>'>
<input type='hidden' name='user_pl5' value='<%=user_pl5[i]%>'>
<input type='hidden' name='user_nm6' value='<%=user_nm6[i]%>'>
<input type='hidden' name='user_pl6' value='<%=user_pl6[i]%>'>
<input type='hidden' name='user_nm7' value='<%=user_nm7[i]%>'>
<input type='hidden' name='user_pl7' value='<%=user_pl7[i]%>'>
<input type='hidden' name='user_nm8' value='<%=user_nm8[i]%>'>
<input type='hidden' name='user_pl8' value='<%=user_pl8[i]%>'>
<input type='hidden' name='user_nm9' value='<%=user_nm9[i]%>'>
<input type='hidden' name='user_pl9' value='<%=user_pl9[i]%>'>
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