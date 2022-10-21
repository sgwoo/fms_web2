<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.cls.*, tax.*, acar.bill_mng.*, acar.car_register.*, acar.car_scrap.*, acar.coolmsg.*, acar.user_mng.*"%>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	int flag = 0;
	
	ClsBean cls = new ClsBean();
	
	cls.setRent_mng_id(request.getParameter("m_id"));
	cls.setRent_l_cd(request.getParameter("l_cd"));
	cls.setTerm_yn("Y");
	cls.setCls_st(cls_st);
	cls.setCls_dt(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//��������
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//��������
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//��������
	cls.setPp_st(request.getParameter("pp_st")==null?"":	request.getParameter("pp_st"));
	cls.setCls_doc_yn(cls_doc_yn);
	cls.setReg_id(request.getParameter("user_id"));
	
	if(cls_st.equals("2")){//�ߵ�����
		if(cls_doc_yn.equals("Y")){
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
			cls.setNfee_amt(request.getParameter("nfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt")));
			cls.setDly_amt(request.getParameter("dly_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt")));
			cls.setEx_di_amt(request.getParameter("ex_di_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_di_amt")));
			cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt")));
			cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt")));
			cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));
			cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));
			cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt")));
			cls.setDft_int(request.getParameter("dft_int")==null?"":		request.getParameter("dft_int"));
			cls.setDft_amt(request.getParameter("dft_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt")));
			cls.setCar_ja_amt(request.getParameter("car_ja_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt")));
			cls.setNo_v_amt(request.getParameter("no_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt")));
			cls.setEtc_amt(request.getParameter("etc_amt")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt")));
			cls.setEtc2_amt(request.getParameter("etc2_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt")));
			cls.setEtc3_amt(request.getParameter("etc3_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt")));
			cls.setEtc4_amt(request.getParameter("etc4_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt")));
			cls.setEtc5_amt(request.getParameter("etc5_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc5_amt")));
			cls.setFine_amt(request.getParameter("fine_amt")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt")));
			cls.setFdft_amt1(request.getParameter("fdft_amt1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1")));
			cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));
			cls.setFdft_dc_amt(request.getParameter("fdft_dc_amt")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_dc_amt")));
			
  			//���ݰ�꼭 �ۼ�
    		String tax_g[] = request.getParameterValues("tax_g");
  	 	 	String tax_supply[] = request.getParameterValues("tax_supply");
    		String tax_value[] = request.getParameterValues("tax_value");
    		String tax_bigo[] = request.getParameterValues("tax_bigo");
 		  	String tax_reg_gu = request.getParameter("tax_reg_gu")==null?"":	request.getParameter("tax_reg_gu");
  	  		int tax_size = tax_g.length;
   			String tax_no = "";
			int data_no =0;
 		  	int tax_cnt = 0;
			

   			if(tax_reg_gu.equals("0")){//�׸񺰹���
	  	  		for(int i = 0; i<tax_size; i++){
  		    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
					out.println(tax_chk);
          			if(tax_chk.equals("Y")){
      	    			out.println("����"+i+"=<br><br>");
    		    		tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
		        		out.println("tax_no="+tax_no+"<br>");
		        		out.println("tax_dt="+cls.getCls_dt()+"<br>");
		        		out.println("tax_g="+tax_g[i]+"<br>");
		        		out.println("tax_supply="+tax_supply[i]+"<br>");
		        		
		        		tax.TaxBean t_bean = new tax.TaxBean();
		        		t_bean.setClient_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		        		t_bean.setTax_dt(cls.getCls_dt());
			      		t_bean.setUnity_chk("0");//���տ���0=����,1=����
    	    			t_bean.setRent_l_cd(request.getParameter("l_cd")==null?"":	request.getParameter("l_cd"));
	        			t_bean.setFee_tm("");
		        		t_bean.setCar_mng_id(request.getParameter("car_mng_id")==null?"":	request.getParameter("car_mng_id"));
        				t_bean.setBranch_g(request.getParameter("br_id")==null?"S1":	request.getParameter("br_id"));
		        		t_bean.setTax_g(tax_g[i]);
		        		t_bean.setTax_supply(AddUtil.parseDigit(tax_supply[i]));
		       	 		t_bean.setTax_value(AddUtil.parseDigit(tax_value[i]));
		        		t_bean.setTax_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		        		t_bean.setItem_id("");
 		        		t_bean.setTax_bigo(tax_bigo[i]);		
		        		t_bean.setSeq(request.getParameter("site_id")==null?"":	request.getParameter("site_id"));
		        		t_bean.setTax_no(tax_no);
		        		t_bean.setCar_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
		        		t_bean.setCar_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
		        		t_bean.setTax_st("O");
		        		t_bean.setTax_type(request.getParameter("tax_type")==null?"1":	request.getParameter("tax_type"));
		        		t_bean.setReg_id(request.getParameter("user_id"));
		        		t_bean.setGubun("5");
		        		if(!IssueDb.insertTax(t_bean)) flag += 1;
						


            			tax_cnt++;
          			}
		    	}
   			}else{//�����ƹ���
   		  		int i_tax_supply = 0;
   		  		int i_tax_value = 0;
	  	  		for(int i = 0; i<tax_size; i++){
  		    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
          			if(tax_chk.equals("Y")){
      	    			out.println("����"+i+"=<br><br>");
            			i_tax_supply  = i_tax_supply + AddUtil.parseDigit(tax_supply[i]);
            			i_tax_value   = i_tax_value + AddUtil.parseDigit(tax_value[i]);
            			tax_cnt++;
          			}
		    	}
 		    	tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
        		tax.TaxBean t_bean = new tax.TaxBean();
		    	t_bean.setClient_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		    	t_bean.setTax_dt(cls.getCls_dt());
			  	t_bean.setUnity_chk("0");//���տ���0=����,1=����
    	  		t_bean.setRent_l_cd(request.getParameter("l_cd")==null?"":	request.getParameter("l_cd"));
	      		t_bean.setFee_tm("1");
		    	t_bean.setCar_mng_id(request.getParameter("car_mng_id")==null?"":	request.getParameter("car_mng_id"));
        		t_bean.setBranch_g(request.getParameter("br_id")==null?"":	request.getParameter("br_id"));
        		if(tax_cnt > 1){
  		    		t_bean.setTax_g("�ߵ����� ����ݿ�"+tax_cnt+"��");
  		  		}else{
  		    		t_bean.setTax_g("�ߵ����� �����");
  		  		}
		    	t_bean.setTax_supply(i_tax_supply);
		    	t_bean.setTax_value(i_tax_value);
		   	 	t_bean.setTax_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		    	t_bean.setItem_id("");
 		    	t_bean.setTax_bigo(request.getParameter("car_no")==null?"":	request.getParameter("car_no")+" �ߵ�����");
		    	t_bean.setSeq(request.getParameter("site_id")==null?"":	request.getParameter("site_id"));
		    	t_bean.setTax_no(tax_no);
		    	t_bean.setCar_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
		    	t_bean.setCar_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
		    	t_bean.setTax_st("O");
		    	t_bean.setTax_type(request.getParameter("tax_type")==null?"":	request.getParameter("tax_type"));
		    	t_bean.setReg_id(request.getParameter("user_id"));
		    	if(!IssueDb.insertTax(t_bean)) flag += 1;
				

   			}
		}
//		if(1==1)return;
		cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("cls_s_amt")));
		cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("cls_v_amt")));
		cls.setCls_est_dt(request.getParameter("cls_est_dt")==null?"":	request.getParameter("cls_est_dt"));
		if(cls.getCls_st().equals("2") && cls.getCls_est_dt().equals(""))	cls.setCls_est_dt(cls.getCls_dt());
		cls.setExt_dt(request.getParameter("ext_dt")==null?"":			request.getParameter("ext_dt"));
		cls.setExt_id(request.getParameter("ext_id")==null?"":			request.getParameter("ext_id"));
		cls.setNo_dft_yn(request.getParameter("no_dft_yn")==null?"N":	request.getParameter("no_dft_yn"));
		cls.setNo_dft_cau(request.getParameter("no_dft_cau")==null?"":	request.getParameter("no_dft_cau"));
		
		//���⺻����
		ContBaseBean base = a_db.getCont(cls.getRent_mng_id(), cls.getRent_l_cd());
		
	}else if(cls_st.equals("3")){//�����Һ���
		cls.setP_brch_cd(request.getParameter("p_brch_cd")==null?"":	request.getParameter("p_brch_cd"));//���������ڵ�
		cls.setNew_brch_cd(request.getParameter("new_brch_cd")==null?"":request.getParameter("new_brch_cd"));//�űԿ������ڵ�
		cls.setTrf_dt(request.getParameter("trf_dt")==null?"":			request.getParameter("trf_dt"));//�̰�����
	}else if(cls_st.equals("8")){//���Կɼ�
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));
		cls.setOpt_dt(request.getParameter("opt_dt")==null?"":			request.getParameter("opt_dt"));
		cls.setOpt_mng(request.getParameter("opt_mng")==null?"":		request.getParameter("opt_mng"));
	} else if(cls_st.equals("1")){//��������
		if(cls_doc_yn.equals("Y")){
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
			cls.setNfee_amt(request.getParameter("nfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt")));
			cls.setDly_amt(request.getParameter("dly_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt")));
			cls.setEx_di_amt(request.getParameter("ex_di_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_di_amt")));
			cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt")));
			cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt")));
			cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));
			cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));
			cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt")));
			cls.setDft_int(request.getParameter("dft_int")==null?"":		request.getParameter("dft_int"));
			cls.setDft_amt(request.getParameter("dft_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt")));
			cls.setCar_ja_amt(request.getParameter("car_ja_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt")));
			cls.setNo_v_amt(request.getParameter("no_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt")));
			cls.setEtc_amt(request.getParameter("etc_amt")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt")));
			cls.setEtc2_amt(request.getParameter("etc2_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt")));
			cls.setEtc3_amt(request.getParameter("etc3_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt")));
			cls.setEtc4_amt(request.getParameter("etc4_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt")));
			cls.setEtc5_amt(request.getParameter("etc5_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc5_amt")));
			cls.setFine_amt(request.getParameter("fine_amt")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt")));
			cls.setFdft_amt1(request.getParameter("fdft_amt1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1")));
			cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));
			cls.setFdft_dc_amt(request.getParameter("fdft_dc_amt")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_dc_amt")));
			
  			//���ݰ�꼭 �ۼ�
    		String tax_g[] = request.getParameterValues("tax_g");
  	 	 	String tax_supply[] = request.getParameterValues("tax_supply");
    		String tax_value[] = request.getParameterValues("tax_value");
    		String tax_bigo[] = request.getParameterValues("tax_bigo");
 		  	String tax_reg_gu = request.getParameter("tax_reg_gu")==null?"":	request.getParameter("tax_reg_gu");
  	  		int tax_size = tax_g.length;
   			String tax_no = "";
			int data_no =0;
 		  	int tax_cnt = 0;
   			if(tax_reg_gu.equals("0")){//�׸񺰹���
	  	  		for(int i = 0; i<tax_size; i++){
  		    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
					out.println(tax_chk);
          			if(tax_chk.equals("Y")){
      	    			out.println("����"+i+"=<br><br>");
    		    		tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
		        		out.println("tax_no="+tax_no+"<br>");
		        		out.println("tax_dt="+cls.getCls_dt()+"<br>");
		        		out.println("tax_g="+tax_g[i]+"<br>");
		        		out.println("tax_supply="+tax_supply[i]+"<br>");
		        		
		        		tax.TaxBean t_bean = new tax.TaxBean();
		        		t_bean.setClient_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		        		t_bean.setTax_dt(cls.getCls_dt());
			      		t_bean.setUnity_chk("0");//���տ���0=����,1=����
    	    			t_bean.setRent_l_cd(request.getParameter("l_cd")==null?"":	request.getParameter("l_cd"));
	        			t_bean.setFee_tm("");
		        		t_bean.setCar_mng_id(request.getParameter("car_mng_id")==null?"":	request.getParameter("car_mng_id"));
        				t_bean.setBranch_g(request.getParameter("br_id")==null?"S1":	request.getParameter("br_id"));
		        		t_bean.setTax_g(tax_g[i]);
		        		t_bean.setTax_supply(AddUtil.parseDigit(tax_supply[i]));
		       	 		t_bean.setTax_value(AddUtil.parseDigit(tax_value[i]));
		        		t_bean.setTax_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		        		t_bean.setItem_id("");
 		        		t_bean.setTax_bigo(tax_bigo[i]);		
		        		t_bean.setSeq(request.getParameter("site_id")==null?"":	request.getParameter("site_id"));
		        		t_bean.setTax_no(tax_no);
		        		t_bean.setCar_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
		        		t_bean.setCar_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
		        		t_bean.setTax_st("O");
		        		t_bean.setTax_type(request.getParameter("tax_type")==null?"1":	request.getParameter("tax_type"));
		        		t_bean.setReg_id(request.getParameter("user_id"));
		        		t_bean.setGubun("5");
		        		if(!IssueDb.insertTax(t_bean)) flag += 1;
						

            			tax_cnt++;
          			}
		    	}
   			}else{//�����ƹ���
   		  		int i_tax_supply = 0;
   		  		int i_tax_value = 0;
	  	  		for(int i = 0; i<tax_size; i++){
  		    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
          			if(tax_chk.equals("Y")){
      	    			out.println("����"+i+"=<br><br>");
            			i_tax_supply  = i_tax_supply + AddUtil.parseDigit(tax_supply[i]);
            			i_tax_value   = i_tax_value + AddUtil.parseDigit(tax_value[i]);
            			tax_cnt++;
          			}
		    	}
 		    	tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
        		tax.TaxBean t_bean = new tax.TaxBean();
		    	t_bean.setClient_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		    	t_bean.setTax_dt(cls.getCls_dt());
			  	t_bean.setUnity_chk("0");//���տ���0=����,1=����
    	  		t_bean.setRent_l_cd(request.getParameter("l_cd")==null?"":	request.getParameter("l_cd"));
	      		t_bean.setFee_tm("1");
		    	t_bean.setCar_mng_id(request.getParameter("car_mng_id")==null?"":	request.getParameter("car_mng_id"));
        		t_bean.setBranch_g(request.getParameter("br_id")==null?"":	request.getParameter("br_id"));
        		if(tax_cnt > 1){
  		    		t_bean.setTax_g("���� ����ݿ�"+tax_cnt+"��");
  		  		}else{
  		    		t_bean.setTax_g("���� �����");
  		  		}
		    	t_bean.setTax_supply(i_tax_supply);
		    	t_bean.setTax_value(i_tax_value);
		   	 	t_bean.setTax_id(request.getParameter("client_id")==null?"":	request.getParameter("client_id"));
		    	t_bean.setItem_id("");
 		    	t_bean.setTax_bigo(request.getParameter("car_no")==null?"":	request.getParameter("car_no")+" ����");
		    	t_bean.setSeq(request.getParameter("site_id")==null?"":	request.getParameter("site_id"));
		    	t_bean.setTax_no(tax_no);
		    	t_bean.setCar_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
		    	t_bean.setCar_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
		    	t_bean.setTax_st("O");
		    	t_bean.setTax_type(request.getParameter("tax_type")==null?"":	request.getParameter("tax_type"));
		    	t_bean.setReg_id(request.getParameter("user_id"));
		    	if(!IssueDb.insertTax(t_bean)) flag += 1;
				

   			}
		}
//		if(1==1)return;
		cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("cls_s_amt")));
		cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("cls_v_amt")));
		cls.setCls_est_dt(request.getParameter("cls_est_dt")==null?"":	request.getParameter("cls_est_dt"));
		if(cls.getCls_st().equals("1") && cls.getCls_est_dt().equals(""))	cls.setCls_est_dt(cls.getCls_dt());
		cls.setExt_dt(request.getParameter("ext_dt")==null?"":			request.getParameter("ext_dt"));
		cls.setExt_id(request.getParameter("ext_id")==null?"":			request.getParameter("ext_id"));
		cls.setNo_dft_yn(request.getParameter("no_dft_yn")==null?"N":	request.getParameter("no_dft_yn"));
		cls.setNo_dft_cau(request.getParameter("no_dft_cau")==null?"":	request.getParameter("no_dft_cau"));
	
	}

	if(!as_db.insertCls2(cls))	flag += 1;
	// ���Կɼ� ��Ͻ� ����ִ� �������� �ִٸ� bill_yn�� 'N'
	
	
	
	
	
	
	
	//�����.�� �ؾ� ����
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	//��ü����Ʈ �̼��� ����
	String dly_count = request.getParameter("dly_count")==null?"":request.getParameter("dly_count");
	String dly_value = request.getParameter("dly_value")==null?"":request.getParameter("dly_value");
	//����
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='m_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 

</form>
<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//�������̺� ���� ����%>

	alert('��� �����߻�!');

<%	}else{ 			//�������̺� ���� ����..
		
		if(cls.getCls_st().equals("4") || cls.getCls_st().equals("5")){	//�������� or ����̰�	%>

			fm.action='../car_rent/con_reg_frame.jsp';
			fm.target='d_content';
			parent.window.close();
			fm.submit();			
			
<%		}else{				 											// �ߵ����� or ��ุ�� or �Ű� or �����Һ��� or ���Կɼ� or ����
			
			if(!as_db.closeCont(cls.getRent_mng_id(), cls.getRent_l_cd(), cls.getCls_st(), dly_count, dly_value, car_no, cls.getCls_dt())){	//����%>

				alert('�����߻�!');
				location='about:blank';

<%			}else{														//����
				
				//�����϶� ������ó��------------
				if(cls.getCls_st().equals("9")){	//����
					//���⺻����
					ContBaseBean base = a_db.getCont(cls.getRent_mng_id(), cls.getRent_l_cd());
					//��������
					cr_bean = crd.getCarRegBean(base.getCar_mng_id());
					
					//�������϶�
					if(cr_bean.getCar_use().equals("1")){//cr_bean.getCar_no().length() > 8 && 
						String car_ext = "";
						if(cr_bean.getCar_ext().equals("1")) car_ext = "����";
						if(cr_bean.getCar_ext().equals("2")) car_ext = "����";
						if(cr_bean.getCar_ext().equals("3")) car_ext = "�λ�";
						if(cr_bean.getCar_ext().equals("4")) car_ext = "����";
						if(cr_bean.getCar_ext().equals("5")) car_ext = "����";
						if(cr_bean.getCar_ext().equals("6")) car_ext = "��õ";
						if(cr_bean.getCar_ext().equals("7")) car_ext = "��õ";
						if(cr_bean.getCar_ext().equals("8")) car_ext = "����";
						if(sc_db.getScrapCheck(cr_bean.getCar_no())==0){
							int result2 = sc_db.car_scrap_i(cr_bean.getCar_no(), cr_bean.getCar_nm(), AddUtil.getDate(), car_ext);
						}
					}
					
					//������ �����Һ� ����ڿ��� �޽��� �߼�
					Hashtable end_car = a_db.getEndCarTaxRegSearch(cls.getRent_l_cd());
					if(!String.valueOf(end_car.get("RENT_L_CD")).equals("")){
						
						//��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
						String sub2 		= "����ó�� �ȳ�";
						String cont2 		= "[ "+cls.getRent_l_cd()+" "+cr_bean.getCar_no()+" ] ����ó���Ǿ����ϴ�. �����Һ� ���� ������û�Ͻʽÿ�.";
						String target_id2 	= nm_db.getWorkAuthUser("�����Һ񼼴��");
												
						//����� ���� ��ȸ
						UsersBean target_bean2 	= umd.getUsersBean(target_id2);
			
						String xml_data2 = "";
						xml_data2 =  "<COOLMSG>"+
		  							"<ALERTMSG>"+
			  						"    <BACKIMG>4</BACKIMG>"+
  									"    <MSGTYPE>104</MSGTYPE>"+
  									"    <SUB>"+sub2+"</SUB>"+
					  				"    <CONT>"+cont2+"</CONT>"+
 									"    <URL></URL>";
						xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
						xml_data2 += "    <SENDER></SENDER>"+
			  						"    <MSGICON>10</MSGICON>"+
  									"    <MSGSAVE>1</MSGSAVE>"+
			  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  							"    <FLDTYPE>1</FLDTYPE>"+
			  						"  </ALERTMSG>"+
  									"</COOLMSG>";
			
						CdAlertBean msg2 = new CdAlertBean();
						msg2.setFlddata(xml_data2);
						msg2.setFldtype("1");
			
						boolean flag5 = cm_db.insertCoolMsg(msg2);						
						
					}
					
					
				}
%>
				    alert('ó���Ǿ����ϴ�');
					/*
				    fm.mode.value = '1';
				    if(fm.cls_st.value == '1') fm.cont_st.value = '6';
				    if(fm.cls_st.value == '2') fm.cont_st.value = '7';
				    if(fm.cls_st.value == '3') fm.cont_st.value = '8';
				    if(fm.cls_st.value == '4') fm.cont_st.value = '9';
				    if(fm.cls_st.value == '5') fm.cont_st.value = '10';
				    if(fm.cls_st.value == '6') fm.cont_st.value = '11';
				    if(fm.cls_st.value == '7') fm.cont_st.value = '12';
				    if(fm.cls_st.value == '10') fm.cont_st.value = '30';
				    if(fm.cls_st.value == '8') fm.cont_st.value = '14';					
				    if(fm.cls_st.value == '9') fm.cont_st.value = '23';					
				    fm.s_kd.value = '1';
				    fm.t_wd.value = fm.l_cd.value;
				    fm.action='../car_rent/con_frame_s.jsp';		
					*/
					fm.s_kd.value = '2';
					fm.t_wd.value = fm.l_cd.value;
				    fm.action='/fms2/lc_rent/lc_s_frame.jsp';
				    fm.target='d_content';		
				    parent.window.close();		
				    fm.submit();
<%			}
		}
	}%>
</script>
</body>
</html>
