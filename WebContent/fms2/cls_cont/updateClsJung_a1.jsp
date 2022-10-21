<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
//	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String reg_id = request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	String from_page 	= "";
	int flag = 0;
	
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else 	if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
	
	//ä�ǰ���, ����ä���� ó���ǰ�/���û���
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	
	cls.setCls_st	(cls_st);
		
	cls.setUpd_id	(user_id);	
	
	cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
	cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
	cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
	cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
	cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
	cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
	cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
	cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
	cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
	cls.setNfee_amt(request.getParameter("nfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt"))); //�̳��뿩�� ���ʱݾ�
	cls.setEx_di_amt(request.getParameter("ex_di_amt")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt"))); //������ �뿩�� �ݾ� (���� �Ǵ� �ܾ�)
	cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //�뿩�� �Ѿ�
	cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //����մ뿩��
	cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //�ܿ��Ⱓ
	cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //�ܿ��Ⱓ
	cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //�ܿ��Ⱓ�Ѵ뿩��
	cls.setDft_int(request.getParameter("dft_int")==null?"":		request.getParameter("dft_int")); //�ߵ����� ������
	cls.setDft_int_1(request.getParameter("dft_int_1")==null?"":	request.getParameter("dft_int_1")); //�ߵ����� ������
	cls.setDft_amt(request.getParameter("dft_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt")));   //�ߵ���������� ���ʱݾ�
	cls.setCar_ja_amt(request.getParameter("car_ja_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt"))); //��å�� ���ʱݾ�
	cls.setDly_amt(request.getParameter("dly_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt")));   //��ü�� ���ʱݾ�
	cls.setEtc_amt(request.getParameter("etc_amt")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt")));  //����ȸ�����ֺ� ���ʱݾ�
	cls.setEtc2_amt(request.getParameter("etc2_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt"))); //����ȸ���δ�� ���ʱݾ�
	cls.setEtc3_amt(request.getParameter("etc3_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt"))); //������������ ���ʱݾ�
	cls.setEtc4_amt(request.getParameter("etc4_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt"))); //��Ÿ���ع��� ���ʱݾ�
	
	cls.setFine_amt(request.getParameter("fine_amt")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt"))); //���·� ���ʱݾ�
	cls.setNo_v_amt(request.getParameter("no_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt")));   //�ΰ��� ���ʱݾ�
	cls.setFdft_amt1(request.getParameter("fdft_amt1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1")));//�հ� ���ʱݾ�
	cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//�����Աݾ�
		
	cls.setDfee_amt(request.getParameter("dfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt")));   //������+�̳��뿩�� ���ʱݾ�			
	cls.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //���·� Ȯ���ݾ�
	cls.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //��å�� Ȯ���ݾ�
	cls.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //��ü�� Ȯ���ݾ�
	cls.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //����ȸ�����ֺ� Ȯ���ݾ�
	cls.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //����ȸ���δ�� Ȯ���ݾ�
	cls.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //�ߵ���������� Ȯ���ݾ�
	cls.setEx_di_amt_1(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1")));   //������ Ȯ���ݾ�
	cls.setNfee_amt_1(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1")));   //�뿩�� Ȯ���ݾ�
	cls.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //������������ Ȯ���ݾ�
	cls.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //��Ÿ���ع��� Ȯ���ݾ�

	cls.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //�ΰ��� Ȯ���ݾ�
	cls.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//�հ� ���ʱݾ�
	cls.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //������+�̳��뿩�� Ȯ���ݾ�
		
	cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //��������� ���ް�
	cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //��������� �ΰ���
	
	cls.setEst_amt(request.getParameter("est_amt")==null?0:				AddUtil.parseDigit(request.getParameter("est_amt")));	   //ä�Ǿ����ݾ� 
		
	//�߰��Աݾ��� ���� ��� - ���꼭 �ۼ�������

	
	if(cls_st.equals("8")){//���Կɼ��ΰ�� 
			cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt3")));//�����Աݾ�
				
	} 
	
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //�ʰ����� �����ݾ�
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //�ʰ����� Ȯ���ݾ�	
					
	//���ݰ�꼭 �����Ƿڰ� ��� : �Ƿ��ߴ��� �������ݰ�꼭�� ����ȵ� �� ���� :��⿬ü�� ��� (���ݽ� ���ݰ�꼭 ����ó��)
	cls.setTax_chk0(request.getParameter("tax_chk0")==null?"N":request.getParameter("tax_chk0"));  //�ߵ����������
	cls.setTax_chk1(request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"));  //�������ֺ��
	cls.setTax_chk2(request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"));  //�����δ���
	cls.setTax_chk3(request.getParameter("tax_chk3")==null?"N":request.getParameter("tax_chk3"));  //��Ÿ���ع���
	cls.setTax_chk4(request.getParameter("tax_chk4")==null?"N":request.getParameter("tax_chk4"));  //��Ÿ���ع���
		
	String tax_supply[] = request.getParameterValues("tax_supply");
 	   String tax_value[] = request.getParameterValues("tax_value");
	String tax_g[] = request.getParameterValues("tax_g");
	
	int tax_size = tax_g.length;
	for(int i = 0; i<tax_size; i++){
    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
			out.println(tax_chk);
  			if(tax_chk.equals("Y")){
    	       		
	        		if (i == 0) {
	        				cls.setDft_amt_s(AddUtil.parseDigit(tax_supply[i]));
		       	 		cls.setDft_amt_v(AddUtil.parseDigit(tax_value[i]));
	       	 		} else if ( i == 1 ){
		       	 		cls.setEtc_amt_s(AddUtil.parseDigit(tax_supply[i]));
		       	 		cls.setEtc_amt_v(AddUtil.parseDigit(tax_value[i]));
		       	 	} else if ( i == 2 ){
		       	 		cls.setEtc2_amt_s(AddUtil.parseDigit(tax_supply[i]));
		       	 		cls.setEtc2_amt_v(AddUtil.parseDigit(tax_value[i]));
		       	 	} else if ( i == 3 ){
		       	 		cls.setEtc4_amt_s(AddUtil.parseDigit(tax_supply[i]));
		       	 		cls.setEtc4_amt_v(AddUtil.parseDigit(tax_value[i]));       	
		       	 	} else if ( i == 4 ){
		       	 		cls.setOver_amt_s(AddUtil.parseDigit(tax_supply[i]));
		       	 		cls.setOver_amt_v(AddUtil.parseDigit(tax_value[i]));       		
		       	 	}	
   	
  		} else {
  			
  			if (i == 0) {
        				cls.setDft_amt_s(0);
	       	 		cls.setDft_amt_v(0);
       	 		} else if ( i == 1 ){
	       	 		cls.setEtc_amt_s(0);
	       	 		cls.setEtc_amt_v(0);
	       	 	} else if ( i == 2 ){
	       	 		cls.setEtc2_amt_s(0);
	       	 		cls.setEtc2_amt_v(0);
	       	 	} else if ( i == 3 ){
	       	 		cls.setEtc4_amt_s(0);
	       	 		cls.setEtc4_amt_v(0);       	
	       	 		} else if ( i == 4 ){
	       	 		cls.setOver_amt_s(0);
	       	 		cls.setOver_amt_v(0);       		
	       	 	}	  			
  			
  			}
	}				
		
			
	//boolean cr1_flag = ac_db.updateClsEtcJungSanTax(cls);
	
	int no_v_amt_1 = 0;
	no_v_amt_1 = request.getParameter("no_v_amt_1")==null?0:AddUtil.parseDigit(request.getParameter("no_v_amt_1"));
	
	int fdft_amt1_1 = 0;
	fdft_amt1_1 = request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1"));
	
//	int t_cnt = ac_db.updateClsEtcJungSanSubTax(rent_mng_id, rent_l_cd, no_v_amt_1, fdft_amt1_1 );
		
		//����������  - ���걸�� : 1-> �ջ����� , 2->��������
	String jung_st = request.getParameter("jung_st")==null?"":request.getParameter("jung_st");	
	String jung_st_chk = request.getParameter("jung_st_chk")==null?"":request.getParameter("jung_st_chk");	  //�̳���������ȭ�鿡�� 
	
	if (!cls_st.equals("14") ) {  //����Ʈ�� �ƴ� ��� 		

		if (  jung_st.equals("1") ||  jung_st.equals("2")  ) { 	
			//�������������
			ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);		
			cct.setRent_mng_id(rent_mng_id);
			cct.setRent_l_cd	(rent_l_cd);
			cct.setJung_st(request.getParameter("jung_st")==null?"":			request.getParameter("jung_st"));  //���걸��
			cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //�����ݾ�
			cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //�̳��Աݾ�
			cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //����ݾ�(�ջ������)
			cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //ȯ��
			cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //ȯ������ݾ�
			cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //û��
			cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //û������ݾ�
							
			cct.setH_st(request.getParameter("h_st")==null?"":			request.getParameter("h_st"));  //����
			cct.setH_ip_dt(request.getParameter("h_ip_dt")==null?"":		request.getParameter("h_ip_dt"));  //�Ա�����
			
			boolean cr2_flag = ac_db.updateClsContEtc(cct);		
			
		}						
	}
	
	if (cls_st.equals("14") ) {  //����Ʈ�ΰ�� 
	 //ī������簡 �������� ����Ǵ� ���
	   	if (  jung_st_chk.equals("1") ||  jung_st_chk.equals("2")  ) { 	
	   	     	if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_cont_etc"))	flag += 1; //����������	   	
	   	}	  
					//jung_st �� 3�� ��� : ī������, �����αݾ� ���, ī�� ������Ƿڷ� ó�� 
	   if (   jung_st_chk.equals("3")   ) { 
	
			   int cce_cnt =  ac_db.getCntClsContEtc	(rent_mng_id, rent_l_cd);		
			   
			   if ( cce_cnt  < 1) {
			 	  	ClsContEtcBean cct = new ClsContEtcBean();
					cct.setRent_mng_id(rent_mng_id);
					cct.setRent_l_cd	(rent_l_cd);
					cct.setJung_st("3");  //���걸��
					cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //�����ݾ�
					cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //�̳��Աݾ�
					cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //����ݾ�(�ջ������)
					cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //ȯ��
					cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //ȯ������ݾ�
					cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //û��
					cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //û������ݾ�						
					
					cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //ī�� ��Ұ��� - ����� ī�� ������							
				
					if(!ac_db.insertClsContEtc(cct))	flag += 1;
				} else {	
			   	   
					//�������������
					ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);		
					cct.setRent_mng_id(rent_mng_id);
					cct.setRent_l_cd	(rent_l_cd);
					cct.setJung_st("3");  //���걸��
					cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //�����ݾ�
					cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //�̳��Աݾ�
					cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //����ݾ�(�ջ������)
					cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //ȯ��
					cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //ȯ������ݾ� (ī���ΰ�� ��ұݾ�)
					cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //û��
					cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //û������ݾ� (ī���ΰ�� ������ ����αݾ�)							
					
					cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //ī�� ��Ұ��� - ����� ī�� ������					
					
					if(!ac_db.updateClsContEtc(cct))	flag += 1;
				}
		}
		
	}
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>
<script language='javascript'>
<%	if(!cr1_flag){  %>
		alert("ó������ �ʾҽ��ϴ�");
		location='about:blank';		
<%	}else{		%>
		alert("ó���Ǿ����ϴ�");
		parent.opener.location.href = "<%=from_page%><%=valus%>";
		parent.window.close();
<%	}			%>
</script>