<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.credit.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"5":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String job = request.getParameter("job")==null?"3":request.getParameter("job");
	
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
		
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	
	int   c_amt = request.getParameter("c_amt")==null?0:AddUtil.parseDigit(request.getParameter("c_amt"));  //��������
	int   ex_ip_amt = request.getParameter("ex_ip_amt")==null?0:AddUtil.parseDigit(request.getParameter("ex_ip_amt"));  //�߰��Աݾ�
	
	int   no_v_amt_1 = request.getParameter("no_v_amt_1")==null?0:AddUtil.parseDigit(request.getParameter("no_v_amt_1"));  //�ΰ��� Ȯ��
	int   fdft_amt1_1 = request.getParameter("fdft_amt1_1")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt1_1"));  //Ȯ���ݾ� ��
		
	int   no_v_amt_2 = request.getParameter("no_v_amt_2")==null?0:AddUtil.parseDigit(request.getParameter("no_v_amt_2"));  //�ΰ��� ���
	int   fdft_amt1_2 = request.getParameter("fdft_amt1_2")==null?0:AddUtil.parseDigit(request.getParameter("fdft_amt1_2"));  //��±ݾ� ��
	
	int   fdft_amt2 = fdft_amt1_1 - c_amt - ex_ip_amt;
			
	int   cls_s_amt 			= fdft_amt2 - no_v_amt_1;
	int   cls_v_amt 			= no_v_amt_1;
		
	String real_date = "";
	real_date = cls.getCls_dt();
	
	String ext_st = cls.getExt_st();  //���Կɼ� ���Աݾ� ȯ�ҿ���
	
	int opt_ip_amt = 0;  
  	opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  -  AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
    			
	int flag = 0;
	
	// �ش������� ������� Ȯ���Ұ� - 2022-04-22 
	
//	System.out.println( "c_amt = " +c_amt + ": ex_ip_amt = " + ex_ip_amt + ": no_v_amt = " +no_v_amt_1 + "| fdft_amt1 = "+ fdft_amt1_1 + "| fdft_amt2= " + fdft_amt2 );
//	System.out.println( "cls_s_amt = " + cls_s_amt + "| cls_v_amt = " + cls_v_amt);
	
	 //cls_cont ���� 
	if(!ac_db.updateClsContReJungsan(rent_mng_id, rent_l_cd, no_v_amt_1, fdft_amt1_1, fdft_amt2, cls_s_amt, cls_v_amt,  user_id))	flag += 1;

	
	//cls_etc ����			
  	if(!ac_db.updateClsEtcReJungsan(rent_mng_id, rent_l_cd, no_v_amt_1, fdft_amt1_1, fdft_amt2, cls_s_amt, cls_v_amt,  user_id))	flag += 1;

       //scd_ext ����
	if(!ac_db.updateScdExtReJungsan(rent_mng_id, rent_l_cd,  cls_s_amt, cls_v_amt,  user_id ))	flag += 1;	
	
	//�����Ƿڻ󼼳��� - ���ݾ� ���� 
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);		

	clss.setRent_mng_id(rent_mng_id);
	clss.setRent_l_cd(rent_l_cd);
	clss.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //���·� Ȯ���ݾ�
	clss.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //��å�� Ȯ���ݾ�
	clss.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //��ü�� Ȯ���ݾ�
	clss.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //����ȸ�����ֺ� Ȯ���ݾ�
	clss.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //����ȸ���δ�� Ȯ���ݾ�
	clss.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //�ߵ���������� Ȯ���ݾ�
	clss.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //�ߵ���������� Ȯ���ݾ�
	clss.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //������������ Ȯ���ݾ�
	clss.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //��Ÿ���ع��� Ȯ���ݾ�
	clss.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //�ΰ��� Ȯ���ݾ�
	clss.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//�հ� ���ʱݾ�
	
	clss.setFine_amt_2(request.getParameter("fine_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_2"))); //���·� ���ݾ�
	clss.setCar_ja_amt_2(request.getParameter("car_ja_amt_2")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_2"))); //��å�� ���ݾ�
	clss.setDly_amt_2(request.getParameter("dly_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_2")));   //��ü�� ���ݾ�
	clss.setEtc_amt_2(request.getParameter("etc_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2")));  //����ȸ�����ֺ� ���ݾ�
	clss.setEtc2_amt_2(request.getParameter("etc2_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2"))); //����ȸ���δ�� ���ݾ�
	clss.setDft_amt_2(request.getParameter("dft_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2")));   //�ߵ���������� ���ݾ�
	clss.setDfee_amt_2(request.getParameter("dfee_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2")));   //�̳��뿩�� ���ݾ�
	clss.setEtc3_amt_2(request.getParameter("etc3_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_2"))); //������������ ���ݾ�
	clss.setEtc4_amt_2(request.getParameter("etc4_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2"))); //��Ÿ���ع��� ���ݾ�
	clss.setNo_v_amt_2(request.getParameter("no_v_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_2")));   //�ΰ��� ���ݾ�
	clss.setFdft_amt1_2(request.getParameter("fdft_amt1_2")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_2")));//�հ� ���ݾ�
	clss.setDfee_amt_2_v(request.getParameter("dfee_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2_v")));   //�̳��뿩�� ���ݾ� vat
	clss.setDft_amt_2_v(request.getParameter("dft_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2_v")));   //����� ���ݾ� vat
	clss.setEtc_amt_2_v(request.getParameter("etc_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2_v")));   //���ֺ�� ���ݾ� vat
	clss.setEtc2_amt_2_v(request.getParameter("etc2_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2_v")));   //�δ��� ���ݾ� vat
	clss.setEtc4_amt_2_v(request.getParameter("etc4_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2_v")));   //���ع��� ���ݾ� vat
	
	clss.setUpd_id(user_id);		
		
	//�����Ƿڼ��곻�� ����	
	if(!ac_db.updateClsEtcSub(clss))	flag += 1;
	
	
	//�����Ƿ� ���ݰ�꼭���� 
	//���ݰ�꼭 �����Ƿڰ� ��� : �Ƿ��ߴ��� �������ݰ�꼭�� ����ȵ� �� ���� :��⿬ü�� ��� (���ݽ� ���ݰ�꼭 ����ó��)
	ClsEtcTaxBean ct = ac_db.getClsEtcTax(rent_mng_id, rent_l_cd, 1);
	ct.setRent_mng_id(rent_mng_id);
	ct.setRent_l_cd	(rent_l_cd);		
	ct.setSeq_no	(1);
	ct.setTax_r_chk0(request.getParameter("tax_r_chk0")==null?"N":request.getParameter("tax_r_chk0"));  //�ܿ����ô뿩��
	ct.setTax_r_chk1(request.getParameter("tax_r_chk1")==null?"N":request.getParameter("tax_r_chk1"));  //�ܿ�������
	ct.setTax_r_chk2(request.getParameter("tax_r_chk2")==null?"N":request.getParameter("tax_r_chk2"));  //��Ҵ뿩��
	ct.setTax_r_chk3(request.getParameter("tax_r_chk3")==null?"N":request.getParameter("tax_r_chk3"));  //�̳��뿩��
	ct.setTax_r_chk4(request.getParameter("tax_r_chk4")==null?"N":request.getParameter("tax_r_chk4"));  //���������
	ct.setTax_r_chk5(request.getParameter("tax_r_chk5")==null?"N":request.getParameter("tax_r_chk5"));  //ȸ�����ֺ��
	ct.setTax_r_chk6(request.getParameter("tax_r_chk6")==null?"N":request.getParameter("tax_r_chk6"));  //ȸ���δ���
	ct.setTax_r_chk7(request.getParameter("tax_r_chk7")==null?"N":request.getParameter("tax_r_chk7"));  //���ع���
	
	String tax_r_supply[] = request.getParameterValues("tax_r_supply"); // �ѹ��࿹����
    String tax_r_value[] = request.getParameterValues("tax_r_value");
 
    String tax_rr_supply[] = request.getParameterValues("tax_rr_supply"); // �����
    String tax_rr_value[] = request.getParameterValues("tax_rr_value");
    
    String tax_rr_hap[] = request.getParameterValues("tax_rr_hap");  //���������
    
	String tax_r_g[] = request.getParameterValues("tax_r_g");
	String tax_r_bigo[] = request.getParameterValues("tax_r_bigo");
	
	int tax_size = tax_r_g.length;
	for(int i = 0; i<tax_size; i++){
    	    
    	   	if (i == 0) {
    			ct.setRifee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ܿ����ô뿩�� ����
       	 		ct.setRifee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_rifee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�ܿ����ô뿩�� ����
       	 		ct.setR_rifee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 	//	ct.setRifee_s_amt(AddUtil.parseDigit(tax_rr_hap[i]));  //���� ������ ��꼭�ݾ�
       	 		ct.setRifee_etc(tax_r_g[i]);  //���� ������ ǰ��
   	 		} else if ( i == 1 ){
       	 		ct.setRfee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�ܿ������� ����
       	 		ct.setRfee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_rfee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�ܿ������� ����
       	 		ct.setR_rfee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 	//	ct.setRfee_s_amt(AddUtil.parseDigit(tax_rr_hap[i]));
       	 		ct.setRfee_etc(tax_r_g[i]);  //���� ������ ǰ��
       	 	} else if ( i == 2 ){
       	 		ct.setDfee_c_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //��Ҵ뿩�� ����
       	 		ct.setDfee_c_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_dfee_c_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //��Ҵ뿩�� ����
       	 		ct.setR_dfee_c_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 //		ct.setDfee_c_amt(AddUtil.parseDigit(tax_rr_hap[i]));
       	 		ct.setDfee_c_etc(tax_r_g[i]);  //���� ������ ǰ��	
       	 	} else if ( i == 3 ){
       	 		ct.setDfee_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�̳��뿩�� ����
       	 		ct.setDfee_amt_v(AddUtil.parseDigit(tax_r_value[i]));
       	 		ct.setR_dfee_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�̳��뿩�� ����
       	 		ct.setR_dfee_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
       	 	//	ct.setDfee_amt(AddUtil.parseDigit(tax_rr_hap[i]));
       	 		ct.setDfee_etc(tax_r_g[i]);  //���� ������ ǰ��
       	 	} else if ( i == 4 ){
       	 		ct.setDft_amt_s(AddUtil.parseDigit(tax_r_supply[i]));   //�ߵ���������� ����
       	 		ct.setDft_amt_v(AddUtil.parseDigit(tax_r_value[i]));       
       	 		ct.setR_dft_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));   //�ߵ���������� ����
       	 		ct.setR_dft_amt_v(AddUtil.parseDigit(tax_rr_value[i]));       
       	 //		ct.setDft_amt(AddUtil.parseDigit(tax_rr_hap[i]));       	
       	 		ct.setDft_etc(tax_r_g[i]);  //���� ������ ǰ��    		
       	 	} else if ( i == 5 ){
       	 		ct.setEtc_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //���ֺ�� ����
       	 		ct.setEtc_amt_v(AddUtil.parseDigit(tax_r_value[i])); 
       	 		ct.setR_etc_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //���ֺ�� ����
       	 		ct.setR_etc_amt_v(AddUtil.parseDigit(tax_rr_value[i])); 
       	 //		ct.setEtc_amt(AddUtil.parseDigit(tax_rr_hap[i]));      
       	 		ct.setEtc_etc(tax_r_g[i]);  //���� ������ ǰ��
       	 	} else if ( i == 6 ){
       	 		ct.setEtc2_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //�δ��� ����
       	 		ct.setEtc2_amt_v(AddUtil.parseDigit(tax_r_value[i]));     
       	 		ct.setR_etc2_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //�δ��� ����
       	 		ct.setR_etc2_amt_v(AddUtil.parseDigit(tax_rr_value[i]));     
       	 //		ct.setEtc2_amt(AddUtil.parseDigit(tax_rr_hap[i]));  
       	 		ct.setEtc2_etc(tax_r_g[i]);  //���� ������ ǰ��      	
       	 	} else if ( i == 7 ){
       	 		ct.setEtc4_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //���ع��� ����
       	 		ct.setEtc4_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
       	 		ct.setR_etc4_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //���ع��� ����
       	 		ct.setR_etc4_amt_v(AddUtil.parseDigit(tax_rr_value[i]));   
       	 	//	ct.setEtc4_amt(AddUtil.parseDigit(tax_rr_hap[i]));       
       	 		ct.setEtc4_etc(tax_r_g[i]);  //���� ������ ǰ��
       	 	}	
	}				
	
	if(!ac_db.updateClsEtcTax(ct))	flag += 1;	


%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='bit' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����.. %>
	
    alert('ó���Ǿ����ϴ�');				
	
//	fm.t_wd.value = fm.rent_l_cd.value;
 //   fm.action='/fms2/cls_cont/lc_cls_d_frame.jsp';
    fm.action='/fms2/cls_cont/lc_cls_u3.jsp';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>

