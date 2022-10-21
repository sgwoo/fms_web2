<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.credit.*, acar.client.*, acar.cls.*,  acar.cont.*, tax.*, acar.bill_mng.*"%>
<%@ page import="acar.user_mng.*, acar.fee.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
//	System.out.println("lc_cls_cont_autodoc user_id="+ user_id);
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	String firm_nm = request.getParameter("firm_nm")==null?"":	request.getParameter("firm_nm");
	 		
	String match 	= request.getParameter("match")==null?"":request.getParameter("match"); //�����Ī :Y
	 	
	int	flag = 0;
	int	count = 0;
	
	String from_page 	= "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	//�׿���
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 	= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String client_id 	= "";
	String site_id 		= "";

	String tax_supply = "";
	String tax_value = "";
	String tax_branch 	= "";
		
	String re_bank =  request.getParameter("re_bank")==null?"":	request.getParameter("re_bank");
	String re_acc_nm =  request.getParameter("re_acc_nm")==null?"":	request.getParameter("re_acc_nm");
	String re_acc_no =  request.getParameter("re_acc_no")==null?"":	request.getParameter("re_acc_no");
	String re_bank_nm = "";
		
	String r_tax_dt = request.getParameter("r_tax_dt")==null?"":request.getParameter("r_tax_dt");
	
	String use_e_dt	= request.getParameter("use_e_dt")==null?"":request.getParameter("use_e_dt"); // �뿩������ ������
	
	if (!re_bank.equals("")) re_bank_nm = c_db.getNameById( re_bank, "CMS_BNK");
		
   //��������					
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
   
	
	//��������
	if ( cls.getCls_st().equals("��ุ��") ) {
		cls_st = "1";
	} else	if ( cls.getCls_st().equals("�ߵ��ؾ�") ) {
		cls_st = "2";
	} else	if ( cls.getCls_st().equals("���Կɼ�") ) {
		cls_st = "8";
	} else	if ( cls.getCls_st().equals("����Ʈ����") ) {
		cls_st = "14";	
	} else	if ( cls.getCls_st().equals("���������(����)") ) {
		cls_st = "7";		
	} else	if ( cls.getCls_st().equals("����������(�縮��)") ) {
		cls_st = "10";		
	} 
	
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";		
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
		
	//���:������
	ContBaseBean base 	= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	client_id = base.getClient_id();
	
	if(base.getTax_type().equals("2")){//����
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
		
	
	String car_st = "1";
   if (base.getCar_st().equals("3")) {
   			car_st = "2";
   } else {
         car_st = "1";
   }
   	
	//�뿩����
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?br_id:fee.getBr_id();
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	String pp_chk ="";
	//�뿩����
	
	ContFeeBean fee1 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	pp_chk = fee1.getPp_chk();
			
	//�ŷ�ó����
	ClientBean client = al_db.getNewClient(client_id);
	
	String ven_type = "";
	String s_idno = "";
	
	String client_st = client.getClient_st(); //2:����
	
	String foreigner=  client.getNationality();
		
	String i_ssn = "";
	i_ssn = client.getSsn1() + client.getSsn2();
		
	String i_enp_no = client.getEnp_no1() + client.getEnp_no2()+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
		
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_ven_code	= client.getVen_code();
	
	if(base.getTax_type().equals("2")){//����	
		if(! base.getR_site().equals("")){
			//�ŷ�ó��������
			ClientSiteBean site = al_db.getClientSite(client_id, site_id);
			
			i_ven_code = site.getVen_code();
			if(!i_ven_code.equals("")){
							i_enp_no 		= site.getEnp_no();
							i_addr 			= site.getAddr();
							i_sta 			= site.getBus_cdt();
							i_item 			= site.getBus_itm();
							i_ven_code		= site.getVen_code();
							i_ssn 		    = "";								
			}	
		}
	}
	
		
	if(i_ven_code.equals("")) i_ven_code = neoe_db.getVenCode(i_ssn, i_enp_no);
		
	Hashtable vendor = neoe_db.getVendorCase(i_ven_code);
	
	//�׿��� ���ݰ�꼭
	if(base.getTax_type().equals("1")){ //����
		if(client_st.equals("2")){
				ven_type = "1";
				s_idno   =	i_ssn;
		}else{
				ven_type = "0";
				s_idno   =	i_enp_no;
		}
	}else{  //����
		if(i_enp_no.length() == 13){
				ven_type = "1";
				s_idno	 = i_enp_no;
		}else{
				ven_type = "0";
				s_idno   =	i_enp_no;
		}
	}
	
	
	//�����Ƿ�����
	ClsEtcBean clse = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	
	match= clse.getMatch(); //�����Ī �ٽ� Ȯ�� 
	
	//��Ÿ��� ���񺸻�
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "Y" );	
		
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
    if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "Y"); 	
	   	return_remark = (String)return1.get("REMARK");
    }
    	
	//������ �ŷ����� ���� ����
	String tax_item_id_tm = ac_db.getMaxFeeTaxItemTm(rent_l_cd);  // tm
		
	//������ �ŷ����� ������� - ���������
	Hashtable item_tax = ac_db.getLastFeeTaxItemItemId(rent_l_cd, tax_item_id_tm);
	
	
	//������ �ŷ������� N���� ����
	if(!match.equals("Y")){// 
		
		if ( String.valueOf(item_tax.get("USE_YN")).equals("Y") ) {
			if ( String.valueOf(item_tax.get("TAX_NO")).equals("") ) {
				if(!ac_db.updateTaxItemUseYn(String.valueOf(item_tax.get("ITEM_ID")) ) ) flag += 1;
			}		
		}
	
	}
		
		//������ ���ݰ�꼭
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
	if(!match.equals("Y")){// 
		 if(!ac_db.updateScdFeeCls4(rent_mng_id, rent_l_cd, fee_tm, user_id))	flag += 1;	//���� �յ��ΰ�� ��꼭 ����- bill_yn - 'N'ó�� - 20201230
	}
			
	//���ݰ�꼭 ������� - ���������
	Hashtable l_tax = ac_db.getLastFeeTaxDt(rent_l_cd, fee_tm);	
	
			//������ ��꼭 ���೯¥ + 1 
	String item_dt2_p = "";
//	item_dt2_p = c_db.addDay(String.valueOf(l_tax.get("ITEM_DT2")), 1);
	
	//���� �Ǵ� �ߵ����� fm.ifee_s_amt.value != '0' 
	if (  cls.getCls_st().equals("���������(����)")  || cls.getCls_st().equals("����������(�縮��)") ) {
	} else {
					if (  String.valueOf(l_tax.get("ITEM_DT2")).equals("") ||  String.valueOf(l_tax.get("ITEM_DT2")).equals("null") ) {
					} else {
						
						item_dt2_p = c_db.addDay(String.valueOf(l_tax.get("ITEM_DT2")), 1);   //��꼭 �������� + 1	
					}	
	}
		
					// ��ҷ� ���� ��� ó���� ���� - 20190502 ( ���̳ʽ� �ݾ��� ��� )		
	if (	 AddUtil.parseInt(String.valueOf(l_tax.get("ITEM_SUPPLY"))) < 0 ) {
			   		item_dt2_p = String.valueOf(item_tax.get("ITEM_DT1")); //�ŷ������� ������
	}
		
	//���ô뿩��, ������ ȯ���� �ִ� ���
		String tdt4 = "";
		tdt4	=	ac_db.getTaxGubunDt(rent_l_cd, "4"); //���ô뿩��
		
		String tdt3 = "";
		tdt3	=ac_db.getTaxGubunDt(rent_l_cd, "3"); //������
		
		//���Աݵ� ��å�� �� ��꼭 �̹����
		//��å�� ��û���� ���� ����ó�� ���� ����
		int car_ja_no_amt = ac_db.getClsEtcCarNoAmt(rent_mng_id, rent_l_cd);
				
		//���ݰ�꼭 �ۼ� �� �׿��� �ܻ����� ó��

		String tax_r_g[] = request.getParameterValues("tax_r_g");
	 	String tax_r_supply[] = request.getParameterValues("tax_rr_supply");
		String tax_r_value[] = request.getParameterValues("tax_rr_value");
		String tax_bigo[] = request.getParameterValues("tax_r_bigo");
	 
		int tax_size = tax_r_g.length;
		
		String tax_no = "";
		int data_no =0;
		int data_no_t =0;
	  	int tax_cnt = 0;
	  	String row_id_t = "";
	  	String row_id = "";
	  	
	  	//���ݰ�꼭 ����
	  	int  a1_s_amt = 0;  //�ܿ����ô뿩�� - ��꼭 �ʼ� 
	    int  a1_v_amt = 0;
	    int  a2_s_amt = 0;  //�ܿ������� - ��꼭 �ʼ�
	    int  a2_v_amt = 0;
	    int  a3_s_amt = 0;  //��Ҵ뿩�� - ��꼭 �ʼ�
	    int  a3_v_amt = 0;
	    int  a4_s_amt = 0;  //�̳��뿩�� - ��꼭 �ʼ�
	    int  a4_v_amt = 0;
	    int  a5_s_amt = 0;  //���������
	    int  a5_v_amt = 0;
	    int  a6_s_amt = 0;  //ȸ�����ֺ��
	    int  a6_v_amt = 0;
	    int  a7_s_amt = 0;  //ȸ���δ���
	    int  a7_v_amt = 0;
	    int  a8_s_amt = 0;  //���ع��
	    int  a8_v_amt = 0;
	    int  a9_s_amt = 0;  //�ʰ� �����߰��뿩�� - ��꼭 �ʼ�  - 202208  �ʰ����� ȯ���� ��꼭 ������ ������ �� ���� ( ���������� ����ϴ� ����̾����. �ܵ� ���̳ʽ��Ի꼭 ���� �Ұ� .. �ܻ����ݸ� ó��!!!)
	    int  a9_v_amt = 0;
	    
	    int i_tax_supply = 0;  //���չ���� ���ް�
		int i_tax_value = 0;  //���չ���� vat
	  	
	  	String item_id = "";
	  	String reg_code = "";	
	  	String ven_code = "";

		int cls_fee1 =  0;
		int cls_fee2 =  0;
		
		
		//  ��Ҵ뿩�ᰡ �־��� ��� 
		if (AddUtil.parseDigit(tax_r_supply[2]) != 0   ) {
		   cls_fee1++;
		}
			  
		for(int ii = 0; ii<tax_size; ii++){
			
			String tax_r_chk = request.getParameter("tax_r_chk"+ii)==null?"N":	request.getParameter("tax_r_chk"+ii);
			
			if(tax_r_chk.equals("Y")){				
				if ( tax_r_g[ii].equals("���� ��� �뿩��") ) {
				    	cls_fee1++;
			   }
			   if ( tax_r_g[ii].equals("���� �̳� �뿩��")  || tax_r_g[ii].equals("���� �뿩��")  ) {
					    	cls_fee2++;
			   }	
			}
			
		}
			
		String tax_reg_gu = request.getParameter("tax_reg_gu")==null?"":	request.getParameter("tax_reg_gu");
		
		if( tax_reg_gu.equals("Y")){// �׸� ���չ��� (1��)   	
				  		
	  	  		for(int i = 0; i<tax_size; i++){
		    			String tax_r_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
			
						if(tax_r_chk.equals("Y")){
	      	    			out.println("����"+i+"=<br><br>");
	            			i_tax_supply  = i_tax_supply + AddUtil.parseDigit(tax_r_supply[i]);
	            			i_tax_value   = i_tax_value + AddUtil.parseDigit(tax_r_value[i]);
	            		//	tax_cnt++;
	          			}
		    	}
		
	  	  		if(cls.getCls_dt().equals("")){
	  	  			cls.setCls_dt(cls_dt);
				}
		    	
		    	
		    	//����� item_id ��������	    
		    	item_id = IssueDb.getItemIdNext(cls.getCls_dt());	    	
			
				out.println("item_id="+item_id+"<br><br>");
				    		
	    		//�����ڵ� ��������
				reg_code  = Long.toString(System.currentTimeMillis());
				out.println("�����ڵ�="+reg_code+"<br>");
	    		
	    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
				TaxItemListBean til_bean = new TaxItemListBean();			
				til_bean.setItem_id(item_id);
				til_bean.setItem_seq(1);
				til_bean.setItem_g("���������");
				til_bean.setItem_car_no(car_no);
				til_bean.setItem_car_nm(car_nm);
				til_bean.setItem_supply(i_tax_supply);
				til_bean.setItem_value(i_tax_value);
				til_bean.setRent_l_cd(rent_l_cd);
				til_bean.setCar_mng_id(car_mng_id);
			 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
				til_bean.setReg_id(user_id);
				til_bean.setReg_code(reg_code);
			    til_bean.setCar_use(car_st); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 2:����
				til_bean.setItem_dt(cls.getCls_dt());  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
				
						
				if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
						    		
		    	//[2�ܰ�] �ŷ����� ����
		    	//Vector vt = IssueDb.getTaxItemList(reg_code); //����û������??
		    		
				Vector vt = IssueDb.getTaxItemListSusi(reg_code);
				int vt_size = vt.size();
				out.println("�ŷ����� ����="+vt_size+"<br><br>");
				
				for(int j=0;j < vt_size;j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					TaxItemBean ti_bean = new TaxItemBean();
					ti_bean.setClient_id(client_id);
					ti_bean.setSeq(site_id);
					ti_bean.setItem_dt(cls.getCls_dt());
					
					ti_bean.setTax_id("");
					ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
					ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"��");
					ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
					ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
					
					if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
				}
		
		    	//[3�ܰ�] ���ݰ�꼭 ����
		    	tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());	  
		    		
		    	Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
		    	
				int vt_size2 = vt2.size();
				out.println("���ݰ�꼭 ����="+vt_size2+"<br><br>");
				
			//	if (tax_branch.equals("")) tax_branch = br_id;
				if (tax_branch.equals("")) tax_branch = "S1";   //br_id
		    	
		    	for(int k=0;k < vt_size2;k++){
					Hashtable ht_t = (Hashtable)vt2.elementAt(k);
								
					tax.TaxBean t_bean = new tax.TaxBean();				
					t_bean.setClient_id(client_id);  
					t_bean.setTax_dt(cls.getCls_dt());	    
					
		      			
		      		t_bean.setUnity_chk("1");//���տ���0=����,1=����
					t_bean.setRent_l_cd(rent_l_cd);
					t_bean.setFee_tm("");
		    		t_bean.setCar_mng_id(car_mng_id);    		    	
		    		t_bean.setBranch_g(tax_branch);
		    		t_bean.setTax_g("���������");
		    		t_bean.setTax_supply(i_tax_supply);
		   	 		t_bean.setTax_value(i_tax_value);
		    		t_bean.setTax_id(client_id);
		    		t_bean.setItem_id(item_id);
		    		t_bean.setTax_bigo(request.getParameter("car_no")==null?"":	request.getParameter("car_no")+" ����");		
	    							
					//20090701���� ����ڴ�������			
					if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
						//�������
						Hashtable br2 = c_db.getBranch(tax_branch);
					//	Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
						t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
						t_bean.setBranch_g("S1");
						t_bean.setBranch_g2(tax_branch);
						t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //���ڼ��ݰ�꼭 �ǹ����� ���� ����
					}
	    		   		   	    		
			    		t_bean.setSeq(site_id);  
			    		t_bean.setTax_no(tax_no);
			    		t_bean.setCar_no(car_no);
			    		t_bean.setCar_nm(car_nm);
			    		t_bean.setTax_st("O");
			    		t_bean.setTax_type(base.getTax_type());  
			    		t_bean.setReg_id(user_id);
			    		t_bean.setGubun("15");
	    					
	    			//���޹޴������� : 20090608 �۾�
					t_bean.setRecTel			(String.valueOf(ht_t.get("RECTEL")));
					t_bean.setRecCoRegNo		(String.valueOf(ht_t.get("RECCOREGNO")));
					t_bean.setRecCoName			(String.valueOf(ht_t.get("RECCONAME2")));
					t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
					t_bean.setRecCoAddr			(String.valueOf(ht_t.get("RECCOADDR")));
					t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
					t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2")));    								
					
						//���ڼ��ݰ�꼭 �ǹ����� ���� ����	
					//���޹޴��ڰ� �����϶��� �������� ó��
					if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
						t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
						t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
						t_bean.setReccoregnotype("02");//����ڱ���-�ֹε�Ϲ�ȣ
					}else{
						t_bean.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
					}
					
					//--�ܱ���
				          if(foreigner.equals("2") ) {
				         		 t_bean.setReccoregnotype("03");     //�ܱ���
				                    t_bean.setRecCoRegNo("9999999999999");	
				                    t_bean.setTax_bigo(t_bean.getTax_bigo() +" "+  String.valueOf(ht_t.get("RECCOREGNO")) );	       
				          };

		    			if(!IssueDb.insertTax(t_bean)) flag += 1;  
		    			
		    			if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1;
		    	}

	    		//���ڼ��ݰ�꼭 ���� - �ǹ����� 2010
	       		
	    		//����-������
				Hashtable br1 = c_db.getBranch("S1");
		//		String resseq = IssueDb.getResSeqNext();
				
			//	if(!IssueDb.insertSaleEBillCase(resseq, tax_no, String.valueOf(br1.get("BR_ENT_NO")))) flag += 1;
									
				String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
				if (d_flag1.equals("1"))		flag += 1;					
	 
		} else {	
					
			for(int i = 0; i<tax_size; i++){ 		
			
				String tax_r_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
				out.println(tax_r_chk);
				if(tax_r_chk.equals("Y") && AddUtil.parseDigit(tax_r_supply[i]) != 0 ){  //�ݾ��� 0�� �ƴϸ�???
					out.println("����"+i+"=<br><br>");
				
			    //		tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
			    		
			  //  		out.println("tax_no="+tax_no+"<br>");
			    		out.println("tax_dt="+cls.getCls_dt()+"<br>");
			    		out.println("tax_r_g="+tax_r_g[i]+"<br>");
			    		out.println("tax_r_supply="+tax_r_supply[i]+"<br>");
			    		
						//����� item_id ��������
				//	item_id = IssueDb.getItemIdNext(cls.getCls_dt());
						
			//		out.println("item_id="+item_id+"<br><br>");
						    		
			    		//�����ڵ� ��������
			//			reg_code  = Long.toString(System.currentTimeMillis());
			//			out.println("�����ڵ�="+reg_code+"<br>");
			    		
			    		//[1�ܰ�] �ŷ����� ����Ʈ ����		
						TaxItemListBean til_bean = new TaxItemListBean();			
				//		til_bean.setItem_id(item_id);
						til_bean.setItem_seq(1);
						til_bean.setItem_g(tax_r_g[i]);
						til_bean.setItem_car_no(car_no);
						til_bean.setItem_car_nm(car_nm);
						til_bean.setItem_supply(AddUtil.parseDigit(tax_r_supply[i]));
						til_bean.setItem_value(AddUtil.parseDigit(tax_r_value[i]));
						til_bean.setRent_l_cd(rent_l_cd);
						til_bean.setCar_mng_id(car_mng_id);
					 	til_bean.setGubun("15");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
						til_bean.setReg_id(user_id);
				//		til_bean.setReg_code(reg_code);
						
						til_bean.setCar_use(car_st); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 2:����
					
						til_bean.setItem_dt(cls.getCls_dt());  //���ڼ��ݰ�꼭 �ǹ����� ���� ����
						
						if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
				    			til_bean.setItem_dt1(String.valueOf(l_tax.get("ITEM_DT1"))  );   //������ ��꼭�� ���Ⱓ
				    			til_bean.setItem_dt2(String.valueOf(l_tax.get("ITEM_DT2"))  );   //	    		
			    		}   		
		    		
		    					    		//���ô뿩�� ���� - �������������� �뿩�Ⱓ���� ���� ���� ������.        		  	
				      	if ( tax_r_g[i].equals("���� �̳� �뿩��") ||   tax_r_g[i].equals("���� �뿩��")  ) {
				    		       
				    		          //������Ҵ뿩��� �̳��뿩�ᰡ �ִ� ���� ��������꼭 ��
					    		 if ( cls_fee1 == 1 ) {				    		  					    		   	
					    		   	Hashtable l_tax1 = ac_db.getLastFeeTaxDt(rent_l_cd, Integer.toString(Integer.parseInt(fee_tm)  - 1));
					    		   	item_dt2_p = c_db.addDay(String.valueOf(l_tax1.get("ITEM_DT2")), 1);   //��꼭 �������� + 1				    		
					    		 }	     
					    		   			    				    		
				    	 	 	if ( AddUtil.parseDigit(request.getParameter("ifee_s_amt")) > 0 ) {
				    	 	 	  if ( AddUtil.parseDigit(request.getParameter("rifee_s_amt")) > 0 ) {  //�ܿ����ô뿩�ᰡ �����ִ� ��쿡 ���ؼ� 
				    	 	 	      if ( AddUtil.parseDigit(AddUtil.getReplace_dt(cls.getCls_dt()))  >  AddUtil.parseDigit(use_e_dt) ) {
				    	 	 	      		til_bean.setItem_dt1(item_dt2_p);   // ��������꼭 + 1 ���Ⱓ
				    					til_bean.setItem_dt2(use_e_dt );   // ��ĳ�� ������		    	 	 	      
				    	 	 	      } else {
				    	 	 	     	         til_bean.setItem_dt1(item_dt2_p);   // ��������꼭 + 1 ���Ⱓ
				    					til_bean.setItem_dt2(cls.getCls_dt() );  //������/	 	    	 	 	      
				    	 	 	      }	    	 	 	
				    	 	 	  }
				    	 	 	}else {
				    	  			til_bean.setItem_dt1(item_dt2_p);   //���Ⱓ
				    				til_bean.setItem_dt2(cls.getCls_dt() );   //	    	
				    			}	
				    	}	
		    			    
		    	 		//����� item_id �������� - ���������� ���� �������� �ɷ� ����- 20190121 (�ߺ� �߻� )  
						item_id = IssueDb.getItemIdNext(cls.getCls_dt());
							
						out.println("item_id="+item_id+"<br><br>");
						    		
			    		//�����ڵ� ��������
						reg_code  = Long.toString(System.currentTimeMillis());
						out.println("�����ڵ�="+reg_code+"<br>"); 
							  
						til_bean.setItem_id(item_id);
						til_bean.setReg_code(reg_code);  
									    		    			
						if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
						    		
				    	//[2�ܰ�] �ŷ����� ����
						Vector vt = IssueDb.getTaxItemListSusi(reg_code);
						int vt_size = vt.size();
						out.println("�ŷ����� ����="+vt_size+"<br><br>");
						
						for(int j=0;j < vt_size;j++){
							Hashtable ht = (Hashtable)vt.elementAt(j);
							TaxItemBean ti_bean = new TaxItemBean();
							ti_bean.setClient_id(client_id);
							ti_bean.setSeq(site_id);
							ti_bean.setItem_dt(cls.getCls_dt());
							
						//	if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
						//		ti_bean.setItem_dt(String.valueOf(l_tax.get("TAX_DT"))  );  //���ڼ��ݰ�꼭 �ǹ����� ���� ����
						//	}
							
							ti_bean.setTax_id("");
							ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
							ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"��");
							ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
							ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
							
							if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
						}
					
						 			  
					    	//[3�ܰ�] ���ݰ�꼭 ����
					    	Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
					    			    	
						int vt_size2 = vt2.size();
						out.println("���ݰ�꼭 ����="+vt_size2+"<br><br>");
					    	
					   	if (tax_branch.equals("")) tax_branch = "S1";   //br_id
					    		    	 
					   	for(int k=0;k < vt_size2;k++){
							Hashtable ht_t = (Hashtable)vt2.elementAt(k);
											
							tax.TaxBean t_bean = new tax.TaxBean();						
							t_bean.setClient_id(client_id); 
								
							//	if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
					    	//		t_bean.setTax_dt( String.valueOf(l_tax.get("TAX_DT"))  );   //���̳ʽ� ��꼭 ������
					    	//	} else {
					    			t_bean.setTax_dt(cls.getCls_dt());		    		
					    	//	}	
					    		
					      		t_bean.setUnity_chk("0");//���տ���0=����,1=����
							t_bean.setRent_l_cd(rent_l_cd);
							t_bean.setFee_tm("");
						    	t_bean.setCar_mng_id(car_mng_id);
							t_bean.setBranch_g(tax_branch);
					    		t_bean.setTax_g(tax_r_g[i]);
					    		t_bean.setTax_supply(AddUtil.parseDigit(tax_r_supply[i]));
					   	 	t_bean.setTax_value(AddUtil.parseDigit(tax_r_value[i]));
					    		t_bean.setTax_id(client_id);
					    		t_bean.setItem_id(item_id);
					    		t_bean.setTax_bigo(tax_bigo[i]);	
					    		
					    			//20090701���� ����ڴ�������			
							if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
									//�������
									Hashtable br2 = c_db.getBranch(tax_branch);
								//	Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
									t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
									t_bean.setBranch_g("S1");
									t_bean.setBranch_g2(tax_branch);
									t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //���ڼ��ݰ�꼭 �ǹ����� ���� ����
							}			    		
					    		
				    		t_bean.setSeq(site_id);  
				    	//	t_bean.setTax_no(tax_no);
				    		t_bean.setCar_no(car_no);
				    		t_bean.setCar_nm(car_nm);
				    		t_bean.setTax_st("O");
				    		t_bean.setTax_type(base.getTax_type());  
				    		t_bean.setReg_id(user_id);
				    		t_bean.setGubun("15");
				    		    					
				    			//���޹޴������� : 20090608 �۾�
							t_bean.setRecTel			(String.valueOf(ht_t.get("RECTEL")));
							t_bean.setRecCoRegNo		(String.valueOf(ht_t.get("RECCOREGNO")));
							t_bean.setRecCoName			(String.valueOf(ht_t.get("RECCONAME2")));
							t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
							t_bean.setRecCoAddr			(String.valueOf(ht_t.get("RECCOADDR")));
							t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
							t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2"))); 
				    				
										
				    			//���ڼ��ݰ�꼭 �ǹ����� ���� ����	
								//���޹޴��ڰ� �����϶��� �������� ó��
							if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
									t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
									t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
									t_bean.setReccoregnotype("02");//����ڱ���-�ֹε�Ϲ�ȣ
							}else{
									t_bean.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
							}									
								
								
								// ���̳ʽ� ��꼭�� ��� ���� ��� 
							if ( tax_r_g[i].equals("���� ���ô뿩�� ȯ��")) {
								   t_bean.setDoctype("02");   //���ް��������� ó��
								    t_bean.setTax_bigo	( tdt4+"(���� ���ݰ�꼭 �ۼ���)" + car_no);  
							}else if ( tax_r_g[i].equals("���� ������ ȯ��")) {
					    			   t_bean.setDoctype("02");   //���ް��������� ó��
					    			  t_bean.setTax_bigo	( tdt3+"(���� ���ݰ�꼭 �ۼ���)" + car_no);
								
					    		}else if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
					    		   //������Ҵ뿩�Ḹ �ִ� ���� ���,�̳��뿩�ᰡ ���� �ִ� ��� ó���� Ʋ�� :
						    		   if ( cls_fee2 == 1   ) {
						    		             t_bean.setDoctype("04");  //��������� ó��
						    		    } else {          
						    			  t_bean.setDoctype("02");  //���ް��������� ó��
						    			  t_bean.setTax_bigo	( String.valueOf(l_tax.get("TAX_DT"))+"(���� ���ݰ�꼭 �ۼ���)" + car_no);					    		 
						    		   }	     
					    		}										
								
								//--�ܱ���
						          if(foreigner.equals("2") ) {
						         		 t_bean.setReccoregnotype("03");     //�ܱ���
						                    t_bean.setRecCoRegNo("9999999999999");	
						                    t_bean.setTax_bigo(t_bean.getTax_bigo() +" "+  String.valueOf(ht_t.get("RECCOREGNO")) );	       
						          };
				          
						        /* ������ ��갪 �������� */   
						       	tax_no = IssueDb.getTaxNoNext(cls.getCls_dt());
				  		   		out.println("tax_no="+tax_no+"<br>");
				  		   		
				  		  	    t_bean.setTax_no(tax_no);
				  		  	
				    			if(!IssueDb.insertTax(t_bean)) flag += 1;  
				    			
				    			if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1;
				    			    						    			 
				    			 // ���ݰ�꼭 ����� ���ް� �� �ΰ��� ����				    			
					    		 if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
					    		   a3_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a3_v_amt = AddUtil.parseDigit(tax_r_value[i]);
					    		}else if ( tax_r_g[i].equals("���� �̳� �뿩��")   ||  tax_r_g[i].equals("���� �뿩��")      ) {
					    		   a4_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a4_v_amt = AddUtil.parseDigit(tax_r_value[i]);   
					    		}else if ( tax_r_g[i].equals("���� �����")) {
					    		   a5_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a5_v_amt = AddUtil.parseDigit(tax_r_value[i]);
					    		}else if ( tax_r_g[i].equals("���� ȸ�����ֺ��")) {
					    		   a6_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a6_v_amt = AddUtil.parseDigit(tax_r_value[i]);
					    		}else if ( tax_r_g[i].equals("���� ȸ���δ���")) {
					    		   a7_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a7_v_amt = AddUtil.parseDigit(tax_r_value[i]);
					    		}else if ( tax_r_g[i].equals("���� ���ع���")) {
					    		   a8_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a8_v_amt = AddUtil.parseDigit(tax_r_value[i]);    	
					    		}else if ( tax_r_g[i].equals("���� �ʰ������߰��뿩��") ||  tax_r_g[i].equals("���� �ʰ�����뿩��") ) {
					    		   a9_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
					    		   a9_v_amt = AddUtil.parseDigit(tax_r_value[i]);    	   
				    			}    			
		    			
		    			   			
			         }  ////�ݾ��� 0�� �ƴϸ�??? end for vt_size2  ���ݰ�꼭 ����
				
					   
					//���ڼ��ݰ�꼭 ���� - �ǹ����� 2010
					    		   		
			    		//����-������
					Hashtable br1 = c_db.getBranch("S1");
					   //	Hashtable br1 = c_db.getBranch(tax_branch);
			    //		String resseq = IssueDb.getResSeqNext();
			    		
					//	if(!IssueDb.insertSaleEBillCase(resseq, tax_no, String.valueOf(br1.get("BR_ENT_NO")))) flag += 1;
						
					String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
					if (d_flag1.equals("1"))		flag += 1;					
			    						
				//	tax_cnt++;
				}				
				    		
					   
			} 	//end for	

			    	 // ���ݰ�꼭 ����� ���ް� �� �ΰ��� ���� -  �������� ��� ������
			 if ( tax_r_g[0].equals("���� ���ô뿩�� ȯ��")) {
					   a1_s_amt = AddUtil.parseDigit(request.getParameter("rifee_s_amt"))*(-1) ; 
					   a1_v_amt = AddUtil.parseDigit(request.getParameter("rifee_amt_2_v")) ; 		  
			   }
			   if ( tax_r_g[1].equals("���� ������ ȯ��")) {
					   a2_s_amt = AddUtil.parseDigit(request.getParameter("rfee_s_amt"))*(-1) ; 
					   a2_v_amt = AddUtil.parseDigit(request.getParameter("rfee_amt_2_v")) ; 					    		   
			   } 		   	    		
			
		}	
			
		//�ڵ���ǥó����
		Vector vt_m_auto = new Vector();
		Vector vt_auto = new Vector();
				
		int line =0;
		int amt_10800 = 0;
		String doc_cont = "";
			
		
		 //���չ����� ���
	    if ( i_tax_supply > 0 ) {
		 
		 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
		 		 if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) ���������" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " ���������" + "-" + car_no + " " + firm_nm;
		 	      	}	  
		 	  						
				line++;
						
				Hashtable ht21_3 = new Hashtable();
				
				ht21_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht21_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht21_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht21_3.put("CD_PC",  	node_code);  //ȸ�����
				ht21_3.put("CD_WDEPT",  dept_code);  //�μ�
				ht21_3.put("NO_DOCU",  	"");  //row_id�� ���� 
				ht21_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht21_3.put("CD_COMPANY",  "1000");  
				ht21_3.put("ID_WRITE", insert_id);   
				ht21_3.put("CD_DOCU",  "11");  
				
				ht21_3.put("DT_ACCT", 	cls.getCls_dt()); 
				ht21_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht21_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
				ht21_3.put("CD_ACCT",  "10800");   // 
				ht21_3.put("AMT",    	String.valueOf( i_tax_supply + i_tax_value) );		
				ht21_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht21_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht21_3.put("DT_START",  "");  	//�߻�����										 
				ht21_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht21_3.put("CD_DEPT",		"");   //�μ�								 
				ht21_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht21_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht21_3.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht21_3.put("CD_EMPLOY",		"");   //���									 		 
				ht21_3.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht21_3.put("CD_BANK",		"");  //�������	
				ht21_3.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht21_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht21_3.put("AM_ADDTAX",	"" );	 //����
				ht21_3.put("TP_TAX",	"");  //����(����) :11
				ht21_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht21_3.put("NM_NOTE", doc_cont);  // ����									
									
				vt_auto.add(ht21_3);  //  �ܻ�����									
					
				line++;
							
				Hashtable ht21 = new Hashtable();
				
				ht21.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht21.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht21.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht21.put("CD_PC",  	node_code);  //ȸ�����
				ht21.put("CD_WDEPT",  dept_code);  //�μ�
				ht21.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht21.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht21.put("CD_COMPANY",  "1000");  
				ht21.put("ID_WRITE", insert_id);   
				ht21.put("CD_DOCU",  "11");  
				
				ht21.put("DT_ACCT", 	cls.getCls_dt()); 
				ht21.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht21.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				
				if ( car_st.equals("1")  ) { //��Ʈ�̸�
					ht21.put("CD_ACCT",  	"41200");  //��������� ����
				} else {
					ht21.put("CD_ACCT",  	"41700");  //��������� ����
				}	
				
				ht21.put("AMT",    String.valueOf( i_tax_supply ) );		
				ht21.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht21.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht21.put("DT_START",  "");  	//�߻�����										 
				ht21.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht21.put("CD_DEPT",		"");   //�μ�								 
				ht21.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht21.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht21.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht21.put("CD_EMPLOY",		"");   //���									 		 
				ht21.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht21.put("CD_BANK",		"");  //�������	
				ht21.put("NO_ITEM",		"");  //item	  
				
						// �ΰ�������
				ht21.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht21.put("AM_ADDTAX",	"" );	 //����
				ht21.put("TP_TAX",	"");  //����(����) :11
				ht21.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	  	 
			
				ht21.put("NM_NOTE", doc_cont);  // ����									
					
				vt_auto.add(ht21);  //  ���ް�
								
				line++;
				
				Hashtable ht21_2 = new Hashtable();
					
				ht21_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht21_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht21_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
				ht21_2.put("CD_PC",  	node_code);  //ȸ�����
				ht21_2.put("CD_WDEPT",  dept_code);  //�μ�
				ht21_2.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht21_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht21_2.put("CD_COMPANY",  "1000");  
				ht21_2.put("ID_WRITE", insert_id);   
				ht21_2.put("CD_DOCU",  "11");  
				
				ht21_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht21_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht21_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
				ht21_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
				ht21_2.put("AMT",   	String.valueOf( i_tax_value) );				
				ht21_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht21_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht21_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
				ht21_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
				ht21_2.put("CD_DEPT",		"");   //�μ�								 
				ht21_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht21_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht21_2.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht21_2.put("CD_EMPLOY",		"");   //���									 		 
				ht21_2.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht21_2.put("CD_BANK",		"");  //�������	
				ht21_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// �ΰ�������
				ht21_2.put("AM_TAXSTD",	String.valueOf(i_tax_supply));  //����ǥ�ؾ�
				ht21_2.put("AM_ADDTAX",	String.valueOf( i_tax_value) );	 //����
				ht21_2.put("TP_TAX",	"11");  //����(����) :11
				if(ven_type.equals("1")){ //����
					ht21_2.put("NO_COMPANY",	"8888888888"); // ���λ���ڵ�Ϲ�ȣ
				} else {
					ht21_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
				}								
				ht21_2.put("NM_NOTE", doc_cont);  // ����	
							
				vt_auto.add(ht21_2);  // �ΰ���	
						
	   } 
		
		// ��������� ��� ��������ǥ �߻��� (��꼭 �����Ϸ� )
		//���ݰ�꼭 ��Ұ� - ���� ���̳ʽ� (���ݰ�꼭 �������� ��ǥ�������̾�� ��)
		
	   if ( a3_s_amt < 0 ) {
	 
	 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
	 	 	if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) �뿩��" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " �뿩��" + "-" + car_no + " " + firm_nm;
		 	}	  
		     	 	  							
			line++;
						
			Hashtable ht7 = new Hashtable();
			
			ht7.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht7.put("CD_PC",  	node_code);  //ȸ�����
			ht7.put("CD_WDEPT",  dept_code);  //�μ�
			ht7.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht7.put("CD_COMPANY",  "1000");  
			ht7.put("ID_WRITE", insert_id);   
			ht7.put("CD_DOCU",  "11");  
			
			ht7.put("DT_ACCT", 	cls.getCls_dt()); 
			ht7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht7.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
			ht7.put("CD_ACCT",  "10800");   // 
			ht7.put("AMT",    	String.valueOf(a3_s_amt + a3_v_amt) );			
			ht7.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht7.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht7.put("DT_START",  "");  	//�߻�����										 
			ht7.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht7.put("CD_DEPT",		"");   //�μ�								 
			ht7.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht7.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht7.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht7.put("CD_EMPLOY",		"");   //���									 		 
			ht7.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht7.put("CD_BANK",		"");  //�������	
			ht7.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht7.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht7.put("AM_ADDTAX",	"" );	 //����
			ht7.put("TP_TAX",	"");  //����(����) :11
			ht7.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht7.put("NM_NOTE", doc_cont);  // ����									
								
			vt_m_auto.add(ht7);  //  �ܻ�����							
						
			line++;
						
			Hashtable ht7_1 = new Hashtable();
				
			ht7_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht7_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht7_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht7_1.put("CD_PC",  	node_code);  //ȸ�����
			ht7_1.put("CD_WDEPT",  dept_code);  //�μ�
			ht7_1.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht7_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht7_1.put("CD_COMPANY",  "1000");  
			ht7_1.put("ID_WRITE", insert_id);   
			ht7_1.put("CD_DOCU",  "11");  
			
			ht7_1.put("DT_ACCT", 	cls.getCls_dt()); 
			ht7_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht7_1.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			
			if ( car_st.equals("1")  ) { //��Ʈ�̸�
					ht7_1.put("CD_ACCT",  	"41200");  //��������� ����
			} else {
					ht7_1.put("CD_ACCT",  	"41700");  //��������� ����
			}	
			
			ht7_1.put("AMT",    	String.valueOf( a3_s_amt ));			
			ht7_1.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht7_1.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht7_1.put("DT_START",  "");  	//�߻�����										 
			ht7_1.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht7_1.put("CD_DEPT",		"");   //�μ�								 
			ht7_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht7_1.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht7_1.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht7_1.put("CD_EMPLOY",		"");   //���									 		 
			ht7_1.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht7_1.put("CD_BANK",		"");  //�������	
			ht7_1.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht7_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht7_1.put("AM_ADDTAX",	"" );	 //����
			ht7_1.put("TP_TAX",	"");  //����(����) :11
			ht7_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht7_1.put("NM_NOTE", doc_cont);  // ����									
							
			vt_m_auto.add(ht7_1);  //  ���ް�
			
			line++;
			
			Hashtable ht7_2 = new Hashtable();
			
			ht7_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht7_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht7_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
			ht7_2.put("CD_PC",  node_code);  //ȸ�����
			ht7_2.put("CD_WDEPT",  dept_code);  //�μ�
			ht7_2.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht7_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht7_2.put("CD_COMPANY",  "1000");  
			ht7_2.put("ID_WRITE", insert_id);   
			ht7_2.put("CD_DOCU",  "11");  
			
			ht7_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht7_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht7_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
			ht7_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
			ht7_2.put("AMT",   		String.valueOf( a3_v_amt) );						
			ht7_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht7_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht7_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
			ht7_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
			ht7_2.put("CD_DEPT",		"");   //�μ�								 
			ht7_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht7_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht7_2.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht7_2.put("CD_EMPLOY",		"");   //���									 		 
			ht7_2.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht7_2.put("CD_BANK",		"");  //�������	
			ht7_2.put("NO_ITEM",		"");  //item	 	  	 
				
		// �ΰ�������
			ht7_2.put("AM_TAXSTD",	 String.valueOf( a3_s_amt) );		 //����ǥ�ؾ�
			ht7_2.put("AM_ADDTAX",	String.valueOf( a3_v_amt) );		 //����
			ht7_2.put("TP_TAX",	"11");  //����(����) :11
			if(ven_type.equals("1")){ //����
				ht7_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
			} else {
				ht7_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
			}
											
			ht7_2.put("NM_NOTE", doc_cont);  // ����	
									
			vt_m_auto.add(ht7_2);  // �ΰ���	
				
			line =0;	
	 
	  }
	   	
		 //-----------------�����ݾ� ���� ------------------------	
	String jung_st = request.getParameter("jung_st")==null?"1":request.getParameter("jung_st");		 //�հ������ΰ�츸 ��ǥ
		
	   	//������ - ������ 	
	   	if ( AddUtil.parseDigit(request.getParameter("grt_amt"))  > 0 ) {
	  
	  		if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) ������" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " ������" + "-" + car_no + " " + firm_nm;
		 	}	
		 			
			line++;
						
			Hashtable ht2_1 = new Hashtable();
			
			ht2_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht2_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht2_1.put("CD_PC",  	node_code);  //ȸ�����
			ht2_1.put("CD_WDEPT",  dept_code);  //�μ�
			ht2_1.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht2_1.put("CD_COMPANY",  "1000");  
			ht2_1.put("ID_WRITE", insert_id);   
			ht2_1.put("CD_DOCU",  "11");  
			
			ht2_1.put("DT_ACCT", 	cls.getCls_dt()); 
			ht2_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht2_1.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
			ht2_1.put("CD_ACCT",  	"31100");  //���뿩������
			ht2_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("grt_amt") )  )  );	
			ht2_1.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht2_1.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht2_1.put("DT_START",  "");  	//�߻�����										 
			ht2_1.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht2_1.put("CD_DEPT",		"");   //�μ�								 
			ht2_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht2_1.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht2_1.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht2_1.put("CD_EMPLOY",		"");   //���									 		 
			ht2_1.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht2_1.put("CD_BANK",		"");  //�������	
			ht2_1.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht2_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht2_1.put("AM_ADDTAX",	"" );	 //����
			ht2_1.put("TP_TAX",	"");  //����(����) :11
			ht2_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht2_1.put("NM_NOTE", doc_cont);  // ����									
			
			vt_auto.add(ht2_1);  //
		} 	
		  
	      //������ - �ܿ����ô뿩�� 
	   	if ( AddUtil.parseDigit(request.getParameter("rifee_s_amt")) > 0 ) {
	   	  
	   	  	if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) ���ô뿩��" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " ���ô뿩��" + "-" + car_no + " " + firm_nm;
		 	}	
		 			
			line++;		
			//��꼭 ������ �ȵ� - ���ڰ�꼭 �������� ���ؼ� 20140101	
						
			Hashtable ht2_4 = new Hashtable();		
			ht2_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht2_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht2_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht2_4.put("CD_PC",  node_code);  //ȸ�����
			ht2_4.put("CD_WDEPT",  dept_code);  //�μ�
			ht2_4.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht2_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht2_4.put("CD_COMPANY",  "1000");  
			ht2_4.put("ID_WRITE", insert_id);   
			ht2_4.put("CD_DOCU",  "11");  
			
			ht2_4.put("DT_ACCT", 	cls.getCls_dt()); 
			ht2_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht2_4.put("TP_DRCR",   "2");   // �뺯:2 , ����:1		
			ht2_4.put("CD_ACCT",  	"10800");  //�ܻ�����	
			ht2_4.put("AMT",    	String.valueOf( a1_s_amt + a1_v_amt ));		
			ht2_4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht2_4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06	
											
			ht2_4.put("DT_START",  "");  	//�߻�����										 
			ht2_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht2_4.put("CD_DEPT",		"");   //�μ�								 
			ht2_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht2_4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht2_4.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht2_4.put("CD_EMPLOY",		"");   //���									 		 
			ht2_4.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht2_4.put("CD_BANK",		"");  //�������	
			ht2_4.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht2_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht2_4.put("AM_ADDTAX",	"" );	 //����
			ht2_4.put("TP_TAX",	"");  //����(����) :11
			ht2_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht2_4.put("NM_NOTE", doc_cont);  // ����		
						
			vt_auto.add(ht2_4);  //  �ܻ�����						
					
		/*	������ - 20140101	
		
			line++;				
			Hashtable ht2_2 = new Hashtable();
			
			ht2_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht2_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht2_2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht2_2.put("CD_PC",  node_code);  //ȸ�����
			ht2_2.put("CD_WDEPT",  dept_code);  //�μ�
			ht2_2.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht2_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht2_2.put("CD_COMPANY",  "1000");  
			ht2_2.put("ID_WRITE", insert_id);   
			ht2_2.put("CD_DOCU",  "11");  
			
			ht2_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht2_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht2_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			
			
			if ( car_st.equals("1")  ) { //��Ʈ�̸�
				ht2_2.put("CD_ACCT",  	"41200");  //��������� ����
			} else {
				ht2_2.put("CD_ACCT",  	"41700");  //��������� ����
			}	
			
			ht2_2.put("AMT",    String.valueOf( a1_s_amt ));			
			ht2_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht2_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht2_2.put("DT_START",  "");  	//�߻�����										 
			ht2_2.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht2_2.put("CD_DEPT",		"");   //�μ�								 
			ht2_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht2_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht2_2.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht2_2.put("CD_EMPLOY",		"");   //���									 		 
			ht2_2.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht2_2.put("CD_BANK",		"");  //�������	
			ht2_2.put("NO_ITEM",		"");  //item	  
			
					// �ΰ�������
			ht2_2.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht2_2.put("AM_ADDTAX",	"" );	 //����
			ht2_2.put("TP_TAX",	"");  //����(����) :11
			ht2_2.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	  	 
		
			ht2_2.put("NM_NOTE", doc_cont);  // ����									
			
			vt_auto.add(ht2_2);  //  ���ް�
			
			line++;
			
			Hashtable ht3_2 = new Hashtable();
			
			ht3_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht3_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht3_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
			ht3_2.put("CD_PC",  	node_code);  //ȸ�����
			ht3_2.put("CD_WDEPT",  dept_code);  //�μ�
			ht3_2.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht3_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht3_2.put("CD_COMPANY",  "1000");  
			ht3_2.put("ID_WRITE", insert_id);   
			ht3_2.put("CD_DOCU",  "11");  
			
			ht3_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht3_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht3_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
			ht3_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
			ht3_2.put("AMT",   		String.valueOf( a1_v_amt) );							
			ht3_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht3_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht3_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
			ht3_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
			ht3_2.put("CD_DEPT",		"");   //�μ�								 
			ht3_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht3_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht3_2.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht3_2.put("CD_EMPLOY",		"");   //���									 		 
			ht3_2.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht3_2.put("CD_BANK",		"");  //�������	
			ht3_2.put("NO_ITEM",		"");  //item	 	  	 
				
		// �ΰ�������
			ht3_2.put("AM_TAXSTD",	 String.valueOf( a1_s_amt) );		 //����ǥ�ؾ�
			ht3_2.put("AM_ADDTAX",	String.valueOf( a1_v_amt) );		 //����
			ht3_2.put("TP_TAX",	"11");  //����(����) :11
		
			if(ven_type.equals("1")){ //����
				ht3_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
			} else {
				ht3_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
			}								
			ht3_2.put("NM_NOTE", doc_cont);  // ����	
								
			vt_auto.add(ht3_2);  // �ΰ���	   
		*/
		
			
	    } 
	   	  
	   	  //������ - �ܿ������� 
	   if ( AddUtil.parseDigit(request.getParameter("rfee_s_amt")) > 0 ) {
	   	  
	   	  	if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) ������" + "-" + rent_l_cd + " " + firm_nm;
			} else {
				if (pp_chk.equals("0") ) {
					 doc_cont =  cls.getCls_st()  + " ������ �յ�" + "-" + car_no + " " + firm_nm;
				} else {
					 doc_cont =  cls.getCls_st()  + " ������" + "-" + car_no + " " + firm_nm;
				} 				
		 	}		  
				
			line++;		
			//��꼭 ������ �ȵ� - ���ڰ�꼭 �������� ���ؼ� 20140101	
						
			Hashtable ht3_4 = new Hashtable();		
			ht3_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht3_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht3_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht3_4.put("CD_PC",  node_code);  //ȸ�����
			ht3_4.put("CD_WDEPT",  dept_code);  //�μ�
			ht3_4.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht3_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht3_4.put("CD_COMPANY",  "1000");  
			ht3_4.put("ID_WRITE", insert_id);   
			ht3_4.put("CD_DOCU",  "11");  
			
			ht3_4.put("DT_ACCT", 	cls.getCls_dt()); 
			ht3_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht3_4.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			
			if (pp_chk.equals("0") ) {
				ht3_4.put("CD_ACCT",  "25900");   //������ - ������  �յ� 
			} else {
				ht3_4.put("CD_ACCT",  "10800");   //������ - �ܻ����� 
			}
						
		//	ht3_4.put("CD_ACCT",  	"10800");  //�ܻ�����	
			ht3_4.put("AMT",    	String.valueOf( a2_s_amt + a2_v_amt ));		
			ht3_4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht3_4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06	
											
			ht3_4.put("DT_START",  "");  	//�߻�����										 
			ht3_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht3_4.put("CD_DEPT",		"");   //�μ�								 
			ht3_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht3_4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht3_4.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht3_4.put("CD_EMPLOY",		"");   //���									 		 
			ht3_4.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht3_4.put("CD_BANK",		"");  //�������	
			ht3_4.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht3_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht3_4.put("AM_ADDTAX",	"" );	 //����
			ht3_4.put("TP_TAX",	"");  //����(����) :11
			ht3_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht3_4.put("NM_NOTE", doc_cont);  // ����		
						
			vt_auto.add(ht3_4);  //  �ܻ�����
				
	/*			
			line++;
						
			Hashtable ht2_3 = new Hashtable();
			
			ht2_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht2_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht2_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht2_3.put("CD_PC",  node_code);  //ȸ�����
			ht2_3.put("CD_WDEPT",  dept_code);  //�μ�
			ht2_3.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht2_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht2_3.put("CD_COMPANY",  "1000");  
			ht2_3.put("ID_WRITE", insert_id);   
			ht2_3.put("CD_DOCU",  "11");  
			
			ht2_3.put("DT_ACCT", 	cls.getCls_dt()); 
			ht2_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht2_3.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			
			if ( car_st.equals("1")  ) { //��Ʈ�̸�
				ht2_3.put("CD_ACCT",  	"41200");  //��������� ����
			} else {
				ht2_3.put("CD_ACCT",  	"41700");  //��������� ����
			}	
			
			ht2_3.put("AMT",    String.valueOf( a2_s_amt) );				
			ht2_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht2_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht2_3.put("DT_START",  "");  	//�߻�����										 
			ht2_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht2_3.put("CD_DEPT",		"");   //�μ�								 
			ht2_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht2_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht2_3.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht2_3.put("CD_EMPLOY",		"");   //���									 		 
			ht2_3.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht2_3.put("CD_BANK",		"");  //�������	
			ht2_3.put("NO_ITEM",		"");  //item	  
			
					// �ΰ�������
			ht2_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht2_3.put("AM_ADDTAX",	"" );	 //����
			ht2_3.put("TP_TAX",	"");  //����(����) :11
			ht2_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	  	 
		
			ht2_3.put("NM_NOTE", doc_cont);  // ����									
									
			vt_auto.add(ht2_3);  //
			
			line++;
			
			Hashtable ht3_3 = new Hashtable();
			
			ht3_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht3_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht3_3.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
			ht3_3.put("CD_PC",  node_code);  //ȸ�����
			ht3_3.put("CD_WDEPT",  dept_code);  //�μ�
			ht3_3.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht3_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht3_3.put("CD_COMPANY",  "1000");  
			ht3_3.put("ID_WRITE", insert_id);   
			ht3_3.put("CD_DOCU",  "11");  
			
			ht3_3.put("DT_ACCT", 	cls.getCls_dt()); 
			ht3_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht3_3.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
			ht3_3.put("CD_ACCT",  		"25500");  //�ΰ���������					
			ht3_3.put("AMT",   		String.valueOf( a2_v_amt) );								
			ht3_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht3_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht3_3.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
			ht3_3.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
			ht3_3.put("CD_DEPT",		"");   //�μ�								 
			ht3_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht3_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht3_3.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht3_3.put("CD_EMPLOY",		"");   //���									 		 
			ht3_3.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht3_3.put("CD_BANK",		"");  //�������	
			ht3_3.put("NO_ITEM",		"");  //item	 	  	 
				
		// �ΰ�������
			ht3_3.put("AM_TAXSTD",	 String.valueOf( a2_s_amt) );		 //����ǥ�ؾ�
			ht3_3.put("AM_ADDTAX",	String.valueOf( a2_v_amt) );		 //����
			ht3_3.put("TP_TAX",	"11");  //����(����) :11
			if(ven_type.equals("1")){ //����
				ht3_3.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
			} else {	
				ht3_3.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
			}								
			ht3_3.put("NM_NOTE", doc_cont);  // ����	
							
			vt_auto.add(ht3_3);  // �ΰ���		
	*/		
	   }
	   
	 	  int  ex_ip_amt 		= request.getParameter("ex_ip_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ex_ip_amt"));	//�߰��Աݾ� 	
	    
	   	//�߰��Ա� 	   
	         if ( ex_ip_amt > 0 ) {
	  		if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) �߰��Ա�" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " �߰��Ա�" + "-" + car_no + " " + firm_nm;
		 	}	
		 			
			line++;
						
			Hashtable ht3_5 = new Hashtable();
			
			ht3_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht3_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht3_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht3_5.put("CD_PC",  	node_code);  //ȸ�����
			ht3_5.put("CD_WDEPT",  dept_code);  //�μ�
			ht3_5.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht3_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht3_5.put("CD_COMPANY",  "1000");  
			ht3_5.put("ID_WRITE", insert_id);   
			ht3_5.put("CD_DOCU",  "11");  
			
			ht3_5.put("DT_ACCT", 	cls.getCls_dt()); 
			ht3_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht3_5.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
			ht3_5.put("CD_ACCT",  	"25900");  //������-> ������
			ht3_5.put("AMT",    	String.valueOf(ex_ip_amt )  );	
			ht3_5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht3_5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht3_5.put("DT_START",  "");  	//�߻�����										 
			ht3_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht3_5.put("CD_DEPT",		"");   //�μ�								 
			ht3_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht3_5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht3_5.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht3_5.put("CD_EMPLOY",		"");   //���									 		 
			ht3_5.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht3_5.put("CD_BANK",		"");  //�������	
			ht3_5.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht3_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht3_5.put("AM_ADDTAX",	"" );	 //����
			ht3_5.put("TP_TAX",	"");  //����(����) :11
			ht3_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht3_5.put("NM_NOTE", doc_cont);  // ����									
			
			vt_auto.add(ht3_5);  //
		} 	 
	      
	   //-----------------�̳��ݾ� ���� ------------------------
	// ���������� �ƴϸ�
	//if ( !jung_st.equals("2") ) {		  		  

		 // ���·� ��� -  �̼���
	   if ( AddUtil.parseDigit(request.getParameter("fine_amt_2")) > 0 ) {
		 	
		 	if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) ���·�" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " ���·�" + "-" + car_no + " " + firm_nm;
		 	}		 
		 					
			line++;
			
			Hashtable ht4 = new Hashtable();
			
			ht4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht4.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht4.put("CD_PC",  	node_code);  //ȸ�����
			ht4.put("CD_WDEPT",  dept_code);  //�μ�
			ht4.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht4.put("CD_COMPANY",  "1000");  
			ht4.put("ID_WRITE", insert_id);   
			ht4.put("CD_DOCU",  "11");  
			
			ht4.put("DT_ACCT", 	cls.getCls_dt()); 
			ht4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht4.put("TP_DRCR",   "2");   // �뺯:2 , ����:1		
			ht4.put("CD_ACCT",  	"12400");  //���·Ό����(27400) : , ���·�̼��� (12400)		
			ht4.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("fine_amt_2")) ));				
			ht4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06	
											
			ht4.put("DT_START",  "");  	//�߻�����										 
			ht4.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht4.put("CD_DEPT",		"");   //�μ�								 
			ht4.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht4.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht4.put("CD_EMPLOY",		"");   //���									 		 
			ht4.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht4.put("CD_BANK",		"");  //�������	
			ht4.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht4.put("AM_ADDTAX",	"" );	 //����
			ht4.put("TP_TAX",	"");  //����(����) :11
			ht4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht4.put("NM_NOTE", doc_cont);  // ����									
							
			vt_auto.add(ht4);  // ���·�	

	  }
	 	 
		 //�ڱ��������ظ�å�� ��� - ��å���� ���ݰ�꼭 ����� ���� �ܻ����ó��
	  if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) > 0 ) {
	 		
	 	   amt_10800 = AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) - car_ja_no_amt;
	 	   
	 	   if (cls_st.equals("7") ) {
					 doc_cont = "���������(����) ��å��" + "-" + rent_l_cd + " " + firm_nm;
		   } else {		 
		 	      		  doc_cont =  cls.getCls_st()  + " ��å��" + "-" + car_no + " " + firm_nm;
		   }	
				
	 	   if ( amt_10800 > 0) {  //�ܻ������� �ִ� ��츸 
		 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
		 	  
				line++;
							
				Hashtable ht5_1 = new Hashtable();
				
				ht5_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht5_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht5_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht5_1.put("CD_PC",  	node_code);  //ȸ�����
				ht5_1.put("CD_WDEPT",  dept_code);  //�μ�
				ht5_1.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht5_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht5_1.put("CD_COMPANY",  "1000");  
				ht5_1.put("ID_WRITE", insert_id);   
				ht5_1.put("CD_DOCU",  "11");  
				
				ht5_1.put("DT_ACCT", 	cls.getCls_dt()); 
				ht5_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			//	ht5_1.put("TP_DRCR",   "2");   // �뺯:2 , ����:1	
			//	ht5_1.put("CD_ACCT",  	"91800");  //��å�� 
			//	ht5_1.put("AMT",   String.valueOf( amt_10800) );	
				
				ht5_1.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
				ht5_1.put("CD_ACCT",  	"45510");  //��å�� - > �������������(45510)�� ó�� ->20211116���� 
				ht5_1.put("AMT",   String.valueOf( amt_10800 * (-1) ) );
				
				
				ht5_1.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht5_1.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06	
												
				ht5_1.put("DT_START",  "");  	//�߻�����										 
				ht5_1.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht5_1.put("CD_DEPT",		"");   //�μ�								 
				ht5_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht5_1.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht5_1.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht5_1.put("CD_EMPLOY",		"");   //���									 		 
				ht5_1.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht5_1.put("CD_BANK",		"");  //�������	
				ht5_1.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht5_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht5_1.put("AM_ADDTAX",	"" );	 //����
				ht5_1.put("TP_TAX",	"");  //����(����) :11
				ht5_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht5_1.put("NM_NOTE", doc_cont);  // ����									
								
				vt_auto.add(ht5_1);  //  �ܻ�����
			}	
			
			if ( car_ja_no_amt > 0) {  //�������ظ�å���� �ִ� ��츸 
		
				line++;
					 				   		
		   		Hashtable ht5 = new Hashtable();
		   		
		   		ht5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht5.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht5.put("CD_PC",  	node_code);  //ȸ�����
				ht5.put("CD_WDEPT",  dept_code);  //�μ�
				ht5.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht5.put("CD_COMPANY",  "1000");  
				ht5.put("ID_WRITE", insert_id);   
				ht5.put("CD_DOCU",  "11");  
				
				ht5.put("DT_ACCT", 	cls.getCls_dt()); 
				ht5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				
			//	ht5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1		
			//	ht5.put("CD_ACCT",  	"91800");  //�������ظ�å��
			//	ht5.put("AMT",  	String.valueOf( AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) ));		//�Աݾ����� ���� - 160422
				
				ht5.put("TP_DRCR",   "1");   // �뺯:2 , ����:1		
				ht5.put("CD_ACCT",  	"45510");  //�������ظ�å��
				ht5.put("AMT",  	String.valueOf( AddUtil.parseDigit(request.getParameter("car_ja_amt_2")) * (-1) ));		//�Աݾ����� ���� - 160422
				
					
			//	ht5.put("AMT",  	String.valueOf( car_ja_no_amt ));				
				ht5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06	
												
				ht5.put("DT_START",  "");  	//�߻�����										 
				ht5.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht5.put("CD_DEPT",		"");   //�μ�								 
				ht5.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht5.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht5.put("CD_EMPLOY",		"");   //���									 		 
				ht5.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht5.put("CD_BANK",		"");  //�������	
				ht5.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht5.put("AM_ADDTAX",	"" );	 //����
				ht5.put("TP_TAX",	"");  //����(����) :11
				ht5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht5.put("NM_NOTE", doc_cont);  // ����									
										
				vt_auto.add(ht5);  // ��å�� 
			}		
	  }
	 	 
	  //��ü�� ���
	  if ( AddUtil.parseDigit(request.getParameter("dly_amt_2"))  != 0 ) {
	  	
		  	if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) ��ü��" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
			 	      		  doc_cont =  cls.getCls_st()  + " ��ü��" + "-" + car_no + " " + firm_nm;
			}	
		 			
			line++;
				 				   		
	   		Hashtable ht6 = new Hashtable();
	   		
			ht6.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht6.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht6.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht6.put("CD_PC",  	node_code);  //ȸ�����
			ht6.put("CD_WDEPT",  dept_code);  //�μ�
			ht6.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht6.put("CD_COMPANY",  "1000");  
			ht6.put("ID_WRITE", insert_id);   
			ht6.put("CD_DOCU",  "11");  
			
			ht6.put("DT_ACCT", 	cls.getCls_dt()); 
			ht6.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht6.put("TP_DRCR",   "2");   // �뺯:2 , ����:1		
			ht6.put("CD_ACCT",  	"91300");  //��ü��
			ht6.put("AMT",  	String.valueOf( AddUtil.parseDigit(request.getParameter("dly_amt_2")) ));					
			ht6.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht6.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06	
											
			ht6.put("DT_START",  "");  	//�߻�����										 
			ht6.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht6.put("CD_DEPT",		"");   //�μ�								 
			ht6.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht6.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht6.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht6.put("CD_EMPLOY",		"");   //���									 		 
			ht6.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht6.put("CD_BANK",		"");  //�������	
			ht6.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht6.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht6.put("AM_ADDTAX",	"" );	 //����
			ht6.put("TP_TAX",	"");  //����(����) :11
			ht6.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht6.put("NM_NOTE", doc_cont);  // ����						
									
			vt_auto.add(ht6);  // ��ü�� 		 	
	  }  
	  
	 //�뿩�� ���� ��꼭 ����� ó�� 
	  if ( a4_s_amt > 0 ) {
	 
	 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
	 		if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) �뿩��" + "-" + rent_l_cd + " " + firm_nm;
			} else {		 
			 	      		  doc_cont =  cls.getCls_st()  + " �뿩��" + "-" + car_no + " " + firm_nm;
			}	
			
			if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  == 0 ) { 	 //��谡 ������ �ܻ����� �߰� 
				
					line++;
							
					Hashtable ht8_3 = new Hashtable();
					
					ht8_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht8_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht8_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht8_3.put("CD_PC",  node_code);  //ȸ�����
					ht8_3.put("CD_WDEPT",  dept_code);  //�μ�
					ht8_3.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht8_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht8_3.put("CD_COMPANY",  "1000");  
					ht8_3.put("ID_WRITE", insert_id);   
					ht8_3.put("CD_DOCU",  "11");  
					
					ht8_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht8_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht8_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1		
					ht8_3.put("CD_ACCT",  	"10800");  //�ܻ�����	
					ht8_3.put("AMT",    	String.valueOf( a4_s_amt + a4_v_amt ));		
					ht8_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht8_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06	
													
					ht8_3.put("DT_START",  "");  	//�߻�����										 
					ht8_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht8_3.put("CD_DEPT",		"");   //�μ�								 
					ht8_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht8_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht8_3.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht8_3.put("CD_EMPLOY",		"");   //���									 		 
					ht8_3.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht8_3.put("CD_BANK",		"");  //�������	
					ht8_3.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht8_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht8_3.put("AM_ADDTAX",	"" );	 //����
					ht8_3.put("TP_TAX",	"");  //����(����) :11
					ht8_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht8_3.put("NM_NOTE", doc_cont);  // ����		
								
					vt_auto.add(ht8_3);  //  �ܻ�����
							
			}		
			
			line++;
						
			Hashtable ht8_1 = new Hashtable();
			
			ht8_1.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht8_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht8_1.put("CD_PC",  	node_code);  //ȸ�����
			ht8_1.put("CD_WDEPT",  dept_code);  //�μ�
			ht8_1.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht8_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht8_1.put("CD_COMPANY",  "1000");  
			ht8_1.put("ID_WRITE", insert_id);   
			ht8_1.put("CD_DOCU",  "11");  
			
			ht8_1.put("DT_ACCT", 	cls.getCls_dt()); 
			ht8_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht8_1.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			
			if ( car_st.equals("1")  ) { //��Ʈ�̸�
					ht8_1.put("CD_ACCT",  	"41200");  //��������� ����
			} else {
					ht8_1.put("CD_ACCT",  	"41700");  //��������� ����
			}	
			
			ht8_1.put("AMT",    	String.valueOf( a4_s_amt ));					
			ht8_1.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht8_1.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht8_1.put("DT_START",  "");  	//�߻�����										 
			ht8_1.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht8_1.put("CD_DEPT",		"");   //�μ�								 
			ht8_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht8_1.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht8_1.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht8_1.put("CD_EMPLOY",		"");   //���									 		 
			ht8_1.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht8_1.put("CD_BANK",		"");  //�������	
			ht8_1.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht8_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht8_1.put("AM_ADDTAX",	"" );	 //����
			ht8_1.put("TP_TAX",	"");  //����(����) :11
			ht8_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht8_1.put("NM_NOTE", doc_cont);  // ����									
								
			vt_auto.add(ht8_1);  //  ���ް�
			
			line++;
			
			Hashtable ht8_2 = new Hashtable();
				
			ht8_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
			ht8_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
			ht8_2.put("CD_PC",  	node_code);  //ȸ�����
			ht8_2.put("CD_WDEPT",  dept_code);  //�μ�
			ht8_2.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht8_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht8_2.put("CD_COMPANY",  "1000");  
			ht8_2.put("ID_WRITE", insert_id);   
			ht8_2.put("CD_DOCU",  "11");  
			
			ht8_2.put("DT_ACCT", 	cls.getCls_dt()); 
			ht8_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht8_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
			ht8_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
			ht8_2.put("AMT",   		String.valueOf( a4_v_amt) );								
			ht8_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht8_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht8_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
			ht8_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
			ht8_2.put("CD_DEPT",		"");   //�μ�								 
			ht8_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht8_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht8_2.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht8_2.put("CD_EMPLOY",		"");   //���									 		 
			ht8_2.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht8_2.put("CD_BANK",		"");  //�������	
			ht8_2.put("NO_ITEM",		"");  //item	 	  	 
				
		// �ΰ�������
			ht8_2.put("AM_TAXSTD",	  String.valueOf( a4_s_amt) );		 //����ǥ�ؾ�
			ht8_2.put("AM_ADDTAX",	String.valueOf( a4_v_amt) );			 //����
			ht8_2.put("TP_TAX",	"11");  //����(����) :11
			if(ven_type.equals("1")){ //����
				ht8_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
			} else {
				ht8_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
			}								
			ht8_2.put("NM_NOTE", doc_cont);  // ����	
						
			vt_auto.add(ht8_2);  // �ΰ���	
			
	  }
	 	 	 
	  //�뿩�� �ܻ����� ��� - �ܻ�����, ����/��Ʈ ������� �����Ͽ� ó�� - �����ΰ��� �뺯�� ���̳ʽ��ݾ�
	  if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  < 0 ) {
	 	 		
	 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dfee_amt_2")) + AddUtil.parseDigit(request.getParameter("dfee_amt_2_v"))- a4_s_amt - a4_v_amt;
	 	   
	 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
		 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
			 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �뿩��" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " �뿩��" + "-" + car_no + " " + firm_nm;
				}	
				 	  			
				line++;
							
				Hashtable ht8 = new Hashtable();
					
				ht8.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht8.put("CD_PC",  	node_code);  //ȸ�����
				ht8.put("CD_WDEPT",  dept_code);  //�μ�
				ht8.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht8.put("CD_COMPANY",  "1000");  
				ht8.put("ID_WRITE", insert_id);   
				ht8.put("CD_DOCU",  "11");  
				
				ht8.put("DT_ACCT", 	cls.getCls_dt()); 
				ht8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht8.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				ht8.put("CD_ACCT",  "10800");   // 
				ht8.put("AMT",    	String.valueOf( amt_10800) );			
				ht8.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht8.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht8.put("DT_START",  "");  	//�߻�����										 
				ht8.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht8.put("CD_DEPT",		"");   //�μ�								 
				ht8.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht8.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht8.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht8.put("CD_EMPLOY",		"");   //���									 		 
				ht8.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht8.put("CD_BANK",		"");  //�������	
				ht8.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht8.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht8.put("AM_ADDTAX",	"" );	 //����
				ht8.put("TP_TAX",	"");  //����(����) :11
				ht8.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht8.put("NM_NOTE", doc_cont);  // ����									
								
				vt_auto.add(ht8);  //  �ܻ�����
			}	
			
	  } 
	    	 	 
	  //�뿩�� �ܻ����� �Ϻ� ��� - �ܻ�����, ����/��Ʈ ������� �����Ͽ� ó��  
	  if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  > 0 ) {
	 	 		
	 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dfee_amt_2")) + AddUtil.parseDigit(request.getParameter("dfee_amt_2_v"))- a4_s_amt - a4_v_amt;
	 	   	    
	 	   if ( amt_10800 >  0) {  //�ܻ������� �ִ� ��츸  - ��ü �ݾ� ��
		 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
			 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �뿩��" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " �뿩��" + "-" + car_no + " " + firm_nm;
				}	
		 	  					
				line++;
							
				Hashtable ht8_5 = new Hashtable();
				
				ht8_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht8_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht8_5.put("CD_PC",  	node_code);  //ȸ�����
				ht8_5.put("CD_WDEPT",  dept_code);  //�μ�
				ht8_5.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht8_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht8_5.put("CD_COMPANY",  "1000");  
				ht8_5.put("ID_WRITE", insert_id);   
				ht8_5.put("CD_DOCU",  "11");  
				
				ht8_5.put("DT_ACCT", 	cls.getCls_dt()); 
				ht8_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht8_5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				ht8_5.put("CD_ACCT",  "10800");   // 
				ht8_5.put("AMT",    	String.valueOf( amt_10800) );			
				ht8_5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht8_5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht8_5.put("DT_START",  "");  	//�߻�����										 
				ht8_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht8_5.put("CD_DEPT",		"");   //�μ�								 
				ht8_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht8_5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht8_5.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht8_5.put("CD_EMPLOY",		"");   //���									 		 
				ht8_5.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht8_5.put("CD_BANK",		"");  //�������	
				ht8_5.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht8_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht8_5.put("AM_ADDTAX",	"" );	 //����
				ht8_5.put("TP_TAX",	"");  //����(����) :11
				ht8_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht8_5.put("NM_NOTE", doc_cont);  // ����						
						
				vt_auto.add(ht8_5);  //  �ܻ�����
		   }		
	 	   	   
	 	   if ( amt_10800 < 0) {  //�ܻ������� �Ϻ� �󰢵� ��� 
		 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
			 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �뿩��" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " �뿩��" + "-" + car_no + " " + firm_nm;
				}	
					 	  			
				line++;
							
				Hashtable ht8_7 = new Hashtable();
				
				ht8_7.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht8_7.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8_7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht8_7.put("CD_PC",  node_code);  //ȸ�����
				ht8_7.put("CD_WDEPT",  dept_code);  //�μ�
				ht8_7.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht8_7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht8_7.put("CD_COMPANY",  "1000");  
				ht8_7.put("ID_WRITE", insert_id);   
				ht8_7.put("CD_DOCU",  "11");  
				
				ht8_7.put("DT_ACCT", 	cls.getCls_dt()); 
				ht8_7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht8_7.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
				ht8_7.put("CD_ACCT",  "10800");   // 
				ht8_7.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
				ht8_7.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht8_7.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht8_7.put("DT_START",  "");  	//�߻�����										 
				ht8_7.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht8_7.put("CD_DEPT",		"");   //�μ�								 
				ht8_7.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht8_7.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht8_7.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht8_7.put("CD_EMPLOY",		"");   //���									 		 
				ht8_7.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht8_7.put("CD_BANK",		"");  //�������	
				ht8_7.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht8_7.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht8_7.put("AM_ADDTAX",	"" );	 //����
				ht8_7.put("TP_TAX",	"");  //����(����) :11
				ht8_7.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht8_7.put("NM_NOTE", doc_cont);  // ����									
									
				vt_auto.add(ht8_7);  //  �ܻ����� - �̻��κ�
			}		
	  } 
	     	 
	//�ߵ���������� ���� ��꼭 ����� ó��   
	  if ( a5_s_amt > 0 ) {
		 
		 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
			 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ���������" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " ���������" + "-" + car_no + " " + firm_nm;
				}	
				 	  
				if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  < 1 ) { 	  //�ܻ����� �߰�
				
					line++;
							
					Hashtable ht9_3 = new Hashtable();
					
					ht9_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht9_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht9_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht9_3.put("CD_PC",  	node_code);  //ȸ�����
					ht9_3.put("CD_WDEPT",  dept_code);  //�μ�
					ht9_3.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht9_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht9_3.put("CD_COMPANY",  "1000");  
					ht9_3.put("ID_WRITE", insert_id);   
					ht9_3.put("CD_DOCU",  "11");  
					
					ht9_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht9_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht9_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht9_3.put("CD_ACCT",  "10800");   // 
					ht9_3.put("AMT",    		String.valueOf( a5_s_amt + a5_v_amt ));
					ht9_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht9_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht9_3.put("DT_START",  "");  	//�߻�����										 
					ht9_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht9_3.put("CD_DEPT",		"");   //�μ�								 
					ht9_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht9_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht9_3.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht9_3.put("CD_EMPLOY",		"");   //���									 		 
					ht9_3.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht9_3.put("CD_BANK",		"");  //�������	
					ht9_3.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht9_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht9_3.put("AM_ADDTAX",	"" );	 //����
					ht9_3.put("TP_TAX",	"");  //����(����) :11
					ht9_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht9_3.put("NM_NOTE", doc_cont);  // ����									
											
					vt_auto.add(ht9_3);  //  �ܻ�����						
				}	
				
				line++;
							
				Hashtable ht9 = new Hashtable();
					
				ht9.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht9.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht9.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht9.put("CD_PC",  	node_code);  //ȸ�����
				ht9.put("CD_WDEPT",  dept_code);  //�μ�
				ht9.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht9.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht9.put("CD_COMPANY",  "1000");  
				ht9.put("ID_WRITE", insert_id);   
				ht9.put("CD_DOCU",  "11");  
				
				ht9.put("DT_ACCT", 	cls.getCls_dt()); 
				ht9.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht9.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				
				if ( car_st.equals("1")  ) { //��Ʈ�̸�
						ht9.put("CD_ACCT",  	"41200");  //�����  //41200  41410
				} else {
						ht9.put("CD_ACCT",  	"41700");  //�����  //41700  41810
				}	
				
				ht9.put("AMT",    	String.valueOf( a5_s_amt ) );			
				ht9.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht9.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht9.put("DT_START",  "");  	//�߻�����										 
				ht9.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht9.put("CD_DEPT",		"");   //�μ�								 
				ht9.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht9.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht9.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht9.put("CD_EMPLOY",		"");   //���									 		 
				ht9.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht9.put("CD_BANK",		"");  //�������	
				ht9.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht9.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht9.put("AM_ADDTAX",	"" );	 //����
				ht9.put("TP_TAX",	"");  //����(����) :11
				ht9.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht9.put("NM_NOTE", doc_cont);  // ����									
									
				vt_auto.add(ht9);  //  ���ް�
				
				line++;
				
				Hashtable ht9_2 = new Hashtable();
					
				ht9_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht9_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht9_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
				ht9_2.put("CD_PC",  	node_code);  //ȸ�����
				ht9_2.put("CD_WDEPT",  dept_code);  //�μ�
				ht9_2.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht9_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht9_2.put("CD_COMPANY",  "1000");  
				ht9_2.put("ID_WRITE", insert_id);   
				ht9_2.put("CD_DOCU",  "11");  
				
				ht9_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht9_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht9_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
				ht9_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
				ht9_2.put("AMT",   		String.valueOf( a5_v_amt ) );								
				ht9_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht9_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht9_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
				ht9_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
				ht9_2.put("CD_DEPT",		"");   //�μ�								 
				ht9_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht9_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht9_2.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht9_2.put("CD_EMPLOY",		"");   //���									 		 
				ht9_2.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht9_2.put("CD_BANK",		"");  //�������	
				ht9_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// �ΰ�������
				ht9_2.put("AM_TAXSTD",	 String.valueOf( a5_s_amt) );		 //����ǥ�ؾ�
				ht9_2.put("AM_ADDTAX",	String.valueOf( a5_v_amt) );		 //����
				ht9_2.put("TP_TAX",	"11");  //����(����) :11
				if(ven_type.equals("1")){ //����
					ht9_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
				} else {
					ht9_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
				}									
				ht9_2.put("NM_NOTE", doc_cont);  // ����	
								
				vt_auto.add(ht9_2);  // �ΰ���					
						 	
				//��������� �Ϻ� ��� - �ܻ�����, ����/��Ʈ ������� �����Ͽ� ó�� 
			    if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dft_amt_2")) + AddUtil.parseDigit(request.getParameter("dft_amt_2_v"))- a5_s_amt - a5_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
				 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
				 	  	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ���������" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	  doc_cont =  cls.getCls_st()  + " ���������" + "-" + car_no + " " + firm_nm;
						}	
							
						line++;
									
						Hashtable ht9_4 = new Hashtable();
							
						ht9_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht9_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht9_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht9_4.put("CD_PC",  	node_code);  //ȸ�����
						ht9_4.put("CD_WDEPT",  dept_code);  //�μ�
						ht9_4.put("NO_DOCU",  	"");  //�̰��� '0' 
						ht9_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht9_4.put("CD_COMPANY",  "1000");  
						ht9_4.put("ID_WRITE", insert_id);   
						ht9_4.put("CD_DOCU",  "11");  
						
						ht9_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht9_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht9_4.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
						ht9_4.put("CD_ACCT",  "10800");   // 
						ht9_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));
						ht9_4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
						ht9_4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
													
						ht9_4.put("DT_START",  "");  	//�߻�����										 
						ht9_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht9_4.put("CD_DEPT",		"");   //�μ�								 
						ht9_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht9_4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht9_4.put("CD_CARD",		"");   //�ſ�ī��		 	
						ht9_4.put("CD_EMPLOY",		"");   //���									 		 
						ht9_4.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht9_4.put("CD_BANK",		"");  //�������	
						ht9_4.put("NO_ITEM",		"");  //item	  	 
						
							// �ΰ�������
						ht9_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht9_4.put("AM_ADDTAX",	"" );	 //����
						ht9_4.put("TP_TAX",	"");  //����(����) :11
						ht9_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
						ht9_4.put("NM_NOTE", doc_cont);  // ����									
												
						vt_auto.add(ht9_4);  //  �ܻ�����
					}	
							
			  }
		
		 // ���ݰ�꼭 ������ �ȵǾ��� ���
		 } else {
		 
		 	  // �������� ���� ��꼭 �̸� ������� ���� ���� - �̶��� �ܻ����� 
			 if ( clse.getTax_chk0().equals("Y")) {
		  		 
		  		 if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  > 0 ) {
					 
					 	   amt_10800 = AddUtil.parseDigit(request.getParameter("dft_amt_2")) + AddUtil.parseDigit(request.getParameter("dft_amt_2_v"));
					 	   
					 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
						 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
							 	if (cls_st.equals("7") ) {
									 doc_cont = "���������(����) ���������" + "-" + rent_l_cd + " " + firm_nm;
								} else {		 
								 	   doc_cont =  cls.getCls_st()  + " ���������" + "-" + car_no + " " + firm_nm;
								}	
						 							
								line++;
											
								Hashtable ht9_5 = new Hashtable();
								
								ht9_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
								ht9_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
								ht9_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
								ht9_5.put("CD_PC",  	node_code);  //ȸ�����
								ht9_5.put("CD_WDEPT",  dept_code);  //�μ�
								ht9_5.put("NO_DOCU",  	"");  //�̰��� '0' 
								ht9_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
								ht9_5.put("CD_COMPANY",  "1000");  
								ht9_5.put("ID_WRITE", insert_id);   
								ht9_5.put("CD_DOCU",  "11");  
								
								ht9_5.put("DT_ACCT", 	cls.getCls_dt()); 
								ht9_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
								ht9_5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
								ht9_5.put("CD_ACCT",  "10800");   // 
								ht9_5.put("AMT",    	String.valueOf( amt_10800) );					
								ht9_5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
								ht9_5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
															
								ht9_5.put("DT_START",  "");  	//�߻�����										 
								ht9_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
								ht9_5.put("CD_DEPT",		"");   //�μ�								 
								ht9_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
								ht9_5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
								ht9_5.put("CD_CARD",		"");   //�ſ�ī��		 	
								ht9_5.put("CD_EMPLOY",		"");   //���									 		 
								ht9_5.put("NO_DEPOSIT",	"");  //�����ݰ���
								ht9_5.put("CD_BANK",		"");  //�������	
								ht9_5.put("NO_ITEM",		"");  //item	  	 
								
									// �ΰ�������
								ht9_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
								ht9_5.put("AM_ADDTAX",	"" );	 //����
								ht9_5.put("TP_TAX",	"");  //����(����) :11
								ht9_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
										
								ht9_5.put("NM_NOTE", doc_cont);  // ����									
													
								vt_auto.add(ht9_5);  //  �ܻ�����
							}								
				  }	 		 	
		  
		     } else { //��å�� �����̸�
		 	 
				if ( AddUtil.parseDigit(request.getParameter("dft_amt_2"))  > 0 ) { 	 	 	 	   
			 	// ���ݰ�꼭 ������� ������ �κ��� ������������
				 	if (cls_st.equals("7") ) {
								 doc_cont = "���������(����) ���������" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	      		  doc_cont =  cls.getCls_st()  + " ���������" + "-" + car_no + " " + firm_nm;
					}	
						
					line++;
								
					Hashtable ht10 = new Hashtable();
					
					ht10.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht10.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht10.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht10.put("CD_PC",  	node_code);  //ȸ�����
					ht10.put("CD_WDEPT",  dept_code);  //�μ�
					ht10.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht10.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht10.put("CD_COMPANY",  "1000");  
					ht10.put("ID_WRITE", insert_id);   
					ht10.put("CD_DOCU",  "11");  
					
					ht10.put("DT_ACCT", 	cls.getCls_dt()); 
					ht10.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht10.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
					
					if ( car_st.equals("1")  ) { //��Ʈ�̸�
							ht10.put("CD_ACCT",  	"41400");  //��������
					} else {
							ht10.put("CD_ACCT",  	"41800");  //��������
					}	
					
					ht10.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("dft_amt_2")) ) );				
					ht10.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht10.put("CD_PARTNER",	"000131"); //�ŷ�ó    - �Ƹ���ī
												
					ht10.put("DT_START",  "");  	//�߻�����										 
					ht10.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht10.put("CD_DEPT",		"");   //�μ�								 
					ht10.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht10.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht10.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht10.put("CD_EMPLOY",		"");   //���									 		 
					ht10.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht10.put("CD_BANK",		"");  //�������	
					ht10.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht10.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht10.put("AM_ADDTAX",	"" );	 //����
					ht10.put("TP_TAX",	"");  //����(����) :11
					ht10.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht10.put("NM_NOTE", doc_cont);  // ����									
										
					vt_auto.add(ht10);  //  ���ް�			
			  }				 
		 
		 }
		 
	  } 	 	 

	  
	 /* 
	 if ( a6_s_amt > 0 ) {
		 
		 	//  ��Ʈ(����)��������� ���� �ΰ���ó��
		 		if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ����ȸ�����" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " ����ȸ�����" + "-" + car_no + " " + firm_nm;
				}	
			 	  			
				if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  < 1 ) { 	  //�ܻ����� �߰�
				
					line++;
							
					Hashtable ht11_3 = new Hashtable();
					
					ht11_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht11_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht11_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht11_3.put("CD_PC",  	node_code);  //ȸ�����
					ht11_3.put("CD_WDEPT",  dept_code);  //�μ�
					ht11_3.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht11_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht11_3.put("CD_COMPANY",  "1000");  
					ht11_3.put("ID_WRITE", insert_id);   
					ht11_3.put("CD_DOCU",  "11");  
					
					ht11_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht11_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht11_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht11_3.put("CD_ACCT",  "10800");   // 
					ht11_3.put("AMT",    	String.valueOf( a6_s_amt + a6_v_amt) );			
					ht11_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht11_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht11_3.put("DT_START",  "");  	//�߻�����										 
					ht11_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht11_3.put("CD_DEPT",		"");   //�μ�								 
					ht11_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht11_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht11_3.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht11_3.put("CD_EMPLOY",		"");   //���									 		 
					ht11_3.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht11_3.put("CD_BANK",		"");  //�������	
					ht11_3.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht11_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht11_3.put("AM_ADDTAX",	"" );	 //����
					ht11_3.put("TP_TAX",	"");  //����(����) :11
					ht11_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht11_3.put("NM_NOTE", doc_cont);  // ����					
													
					vt_auto.add(ht11_3);  //  �ܻ�����
							
				}	
					
				line++;
							
				Hashtable ht11 = new Hashtable();
					
				ht11.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht11.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht11.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht11.put("CD_PC",  	node_code);  //ȸ�����
				ht11.put("CD_WDEPT",  dept_code);  //�μ�
				ht11.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht11.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht11.put("CD_COMPANY",  "1000");  
				ht11.put("ID_WRITE", insert_id);   
				ht11.put("CD_DOCU",  "11");  
				
				ht11.put("DT_ACCT", 	cls.getCls_dt()); 
				ht11.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht11.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				
				if ( car_st.equals("1")  ) { //��Ʈ�̸�
						ht11.put("CD_ACCT",  	"41200");  //�������ֺ�� ����
				} else {
						ht11.put("CD_ACCT",  	"41700");  //�������ֺ�� ����
				}	
				
				ht11.put("AMT",    	String.valueOf( a6_s_amt ) );				
				ht11.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht11.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht11.put("DT_START",  "");  	//�߻�����										 
				ht11.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht11.put("CD_DEPT",		"");   //�μ�								 
				ht11.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht11.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht11.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht11.put("CD_EMPLOY",		"");   //���									 		 
				ht11.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht11.put("CD_BANK",		"");  //�������	
				ht11.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht11.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht11.put("AM_ADDTAX",	"" );	 //����
				ht11.put("TP_TAX",	"");  //����(����) :11
				ht11.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
				ht11.put("NM_NOTE", doc_cont);  // ����	
															
				vt_auto.add(ht11);  //  ���ް�
				
				line++;
				
				Hashtable ht11_2 = new Hashtable();
				
				ht11_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht11_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht11_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
				ht11_2.put("CD_PC",  	node_code);  //ȸ�����
				ht11_2.put("CD_WDEPT",  dept_code);  //�μ�
				ht11_2.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht11_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht11_2.put("CD_COMPANY",  "1000");  
				ht11_2.put("ID_WRITE", insert_id);   
				ht11_2.put("CD_DOCU",  "11");  
				
				ht11_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht11_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht11_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
				ht11_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
				ht11_2.put("AMT",   			String.valueOf( a6_v_amt) );						
				ht11_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht11_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht11_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
				ht11_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
				ht11_2.put("CD_DEPT",		"");   //�μ�								 
				ht11_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht11_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht11_2.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht11_2.put("CD_EMPLOY",		"");   //���									 		 
				ht11_2.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht11_2.put("CD_BANK",		"");  //�������	
				ht11_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// �ΰ�������
				ht11_2.put("AM_TAXSTD",	 String.valueOf( a6_s_amt) );		 //����ǥ�ؾ�
				ht11_2.put("AM_ADDTAX",	String.valueOf( a6_v_amt) );		 //����
				ht11_2.put("TP_TAX",	"11");  //����(����) :11
				if(ven_type.equals("1")){ //����
					ht11_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
				} else {
					ht11_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
				}	
												
				ht11_2.put("NM_NOTE", doc_cont);  // ����	
											
				vt_auto.add(ht11_2);  // �ΰ���				
			
				//����ȸ����� �Ϻ� ��� - �ܻ�����, ����/��Ʈ ������� �����Ͽ� ó�� 
			    if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc_amt_2")) + AddUtil.parseDigit(request.getParameter("etc_amt_2_v"))- a6_s_amt - a6_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
				 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
					 	if (cls_st.equals("7") ) {
								 doc_cont = "���������(����) ����ȸ�����" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	      	  doc_cont =  cls.getCls_st()  + " ����ȸ�����" + "-" + car_no + " " + firm_nm;
						}	
							 	  					
						line++;
									
						Hashtable ht11_4 = new Hashtable();
						
						ht11_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht11_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht11_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht11_4.put("CD_PC",  	node_code);  //ȸ�����
						ht11_4.put("CD_WDEPT",  dept_code);  //�μ�
						ht11_4.put("NO_DOCU",  	"");  //�̰��� '0' 
						ht11_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht11_4.put("CD_COMPANY",  "1000");  
						ht11_4.put("ID_WRITE", insert_id);   
						ht11_4.put("CD_DOCU",  "11");  
						
						ht11_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht11_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht11_4.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
						ht11_4.put("CD_ACCT",  "10800");   // 
						ht11_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
						ht11_4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
						ht11_4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
													
						ht11_4.put("DT_START",  "");  	//�߻�����										 
						ht11_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht11_4.put("CD_DEPT",		"");   //�μ�								 
						ht11_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht11_4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht11_4.put("CD_CARD",		"");   //�ſ�ī��		 	
						ht11_4.put("CD_EMPLOY",		"");   //���									 		 
						ht11_4.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht11_4.put("CD_BANK",		"");  //�������	
						ht11_4.put("NO_ITEM",		"");  //item	  	 
						
							// �ΰ�������
						ht11_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht11_4.put("AM_ADDTAX",	"" );	 //����
						ht11_4.put("TP_TAX",	"");  //����(����) :11
						ht11_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
						ht11_4.put("NM_NOTE", doc_cont);  // ����									
			
						vt_auto.add(ht11_4);  //  �ܻ�����
					}								
			  }
		 
		  // ���ݰ�꼭 ������ �ȵǾ��� ���
	  } else { */
	  			 	
		  	  // ����ȸ����� ���� ��꼭 �̸� ������� ���� ���� - �̶��� �ܻ����� 
			/* if ( clse.getTax_chk1().equals("Y")) {
		  		 
		  		 if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  > 0 ) {
					 
				 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc_amt_2")) + AddUtil.parseDigit(request.getParameter("etc_amt_2_v"));
				 	   
				 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
					 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
					 		if (cls_st.equals("7") ) {
								 doc_cont = "���������(����) ����ȸ�����" + "-" + rent_l_cd + " " + firm_nm;
							} else {		 
							      	  doc_cont =  cls.getCls_st()  + " ����ȸ�����" + "-" + car_no + " " + firm_nm;
							}	
					 	  															
							line++;
										
							Hashtable ht11_5 = new Hashtable();
							
							ht11_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
							ht11_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht11_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
							ht11_5.put("CD_PC",  	node_code);  //ȸ�����
							ht11_5.put("CD_WDEPT",  dept_code);  //�μ�
							ht11_5.put("NO_DOCU",  	"");  //�̰��� '0' 
							ht11_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht11_5.put("CD_COMPANY",  "1000");  
							ht11_5.put("ID_WRITE", insert_id);   
							ht11_5.put("CD_DOCU",  "11");  
							
							ht11_5.put("DT_ACCT", 	cls.getCls_dt()); 
							ht11_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
							ht11_5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
							ht11_5.put("CD_ACCT",  "10800");   // 
							ht11_5.put("AMT",    	String.valueOf( amt_10800) );		
							ht11_5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
							ht11_5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
														
							ht11_5.put("DT_START",  "");  	//�߻�����										 
							ht11_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
							ht11_5.put("CD_DEPT",		"");   //�μ�								 
							ht11_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht11_5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
							ht11_5.put("CD_CARD",		"");   //�ſ�ī��		 	
							ht11_5.put("CD_EMPLOY",		"");   //���									 		 
							ht11_5.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht11_5.put("CD_BANK",		"");  //�������	
							ht11_5.put("NO_ITEM",		"");  //item	  	 
							
								// �ΰ�������
							ht11_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
							ht11_5.put("AM_ADDTAX",	"" );	 //����
							ht11_5.put("TP_TAX",	"");  //����(����) :11
							ht11_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
									
							ht11_5.put("NM_NOTE", doc_cont);  // ����									
															
							vt_auto.add(ht11_5);  //  �ܻ�����
						}								
				  }	 		 	
		  
		     } else { //��å�� �����̸�
	         */
				if ( AddUtil.parseDigit(request.getParameter("etc_amt_2"))  > 0 ) { 	 	 	 	   
			 	// ���ݰ�꼭 ������� ������ �κ��� �������ظ�å������
			 		if (cls_st.equals("7") ) {
								 doc_cont = "���������(����) ����ȸ�����" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
						 	      	  doc_cont =  cls.getCls_st()  + " ����ȸ�����" + "-" + car_no + " " + firm_nm;
					}	
							 	  	
						
					line++;
								
					Hashtable ht12 = new Hashtable();
					
					ht12.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht12.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht12.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht12.put("CD_PC",  	node_code);  //ȸ�����
					ht12.put("CD_WDEPT",  dept_code);  //�μ�
					ht12.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht12.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht12.put("CD_COMPANY",  "1000");  
					ht12.put("ID_WRITE", insert_id);   
					ht12.put("CD_DOCU",  "11");  
					
					ht12.put("DT_ACCT", 	cls.getCls_dt()); 
					ht12.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					//ht12.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
					//ht12.put("CD_ACCT",   	"91800");  //�������ظ�å��
					//ht12.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc_amt_2"))) );	
					
					ht12.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht12.put("CD_ACCT",   	"45510");  //�������ظ�å��
					ht12.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc_amt_2"))*(-1)  ) );	
					
					
					ht12.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht12.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht12.put("DT_START",  "");  	//�߻�����										 
					ht12.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht12.put("CD_DEPT",		"");   //�μ�								 
					ht12.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht12.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht12.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht12.put("CD_EMPLOY",		"");   //���									 		 
					ht12.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht12.put("CD_BANK",		"");  //�������	
					ht12.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht12.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht12.put("AM_ADDTAX",	"" );	 //����
					ht12.put("TP_TAX",	"");  //����(����) :11
					ht12.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht12.put("NM_NOTE", doc_cont);  // ����	
											
					vt_auto.add(ht12);  //  ���ް�
				}
						
		//	 }		 	 	 
	 // } 
	 		 	 
	 // �����δ��� ���� ��꼭 ����� ó�� 
	 /* if ( a7_s_amt > 0 ) {
		 
		 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
		 		if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) �����δ���" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      	  doc_cont =  cls.getCls_st()  + " �����δ���" + "-" + car_no + " " + firm_nm;
				}	
		 	  				
				if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  < 1 ) { 	  //�ܻ����� �߰�
				
					line++;
							
					Hashtable ht13_3 = new Hashtable();
					
					ht13_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht13_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht13_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht13_3.put("CD_PC",  	node_code);  //ȸ�����
					ht13_3.put("CD_WDEPT",  dept_code);  //�μ�
					ht13_3.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht13_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht13_3.put("CD_COMPANY",  "1000");  
					ht13_3.put("ID_WRITE", insert_id);   
					ht13_3.put("CD_DOCU",  "11");  
					
					ht13_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht13_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht13_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht13_3.put("CD_ACCT",  "10800");  //�ܻ�����
					ht13_3.put("AMT",    	String.valueOf( a7_s_amt + a7_v_amt) );		
					ht13_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht13_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht13_3.put("DT_START",  "");  	//�߻�����										 
					ht13_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht13_3.put("CD_DEPT",		"");   //�μ�								 
					ht13_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht13_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht13_3.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht13_3.put("CD_EMPLOY",		"");   //���									 		 
					ht13_3.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht13_3.put("CD_BANK",		"");  //�������	
					ht13_3.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht13_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht13_3.put("AM_ADDTAX",	"" );	 //����
					ht13_3.put("TP_TAX",	"");  //����(����) :11
					ht13_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht13_3.put("NM_NOTE", doc_cont);  // ����	
												
					vt_auto.add(ht13_3);  //  �ܻ�����
							
				}	
					
				line++;
							
				Hashtable ht13 = new Hashtable();
				
				ht13.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht13.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht13.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht13.put("CD_PC",  	node_code);  //ȸ�����
				ht13.put("CD_WDEPT",  dept_code);  //�μ�
				ht13.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht13.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht13.put("CD_COMPANY",  "1000");  
				ht13.put("ID_WRITE", insert_id);   
				ht13.put("CD_DOCU",  "11");  
				
				ht13.put("DT_ACCT", 	cls.getCls_dt()); 
				ht13.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht13.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				
				if ( car_st.equals("1")  ) { //��Ʈ�̸�
						ht13.put("CD_ACCT",  	"41200");  //�����δ���
				} else {
						ht13.put("CD_ACCT",  	"41700");  //�����δ���
				}	
				
				ht13.put("AMT",    	String.valueOf( a7_s_amt ) );			
				ht13.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht13.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht13.put("DT_START",  "");  	//�߻�����										 
				ht13.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht13.put("CD_DEPT",		"");   //�μ�								 
				ht13.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht13.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht13.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht13.put("CD_EMPLOY",		"");   //���									 		 
				ht13.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht13.put("CD_BANK",		"");  //�������	
				ht13.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht13.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht13.put("AM_ADDTAX",	"" );	 //����
				ht13.put("TP_TAX",	"");  //����(����) :11
				ht13.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht13.put("NM_NOTE", doc_cont);  // ����	
							
				vt_auto.add(ht13);  //  ���ް�
				
				line++;
				
				Hashtable ht13_2 = new Hashtable();
				
				ht13_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht13_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht13_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
				ht13_2.put("CD_PC",  	node_code);  //ȸ�����
				ht13_2.put("CD_WDEPT",  dept_code);  //�μ�
				ht13_2.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht13_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht13_2.put("CD_COMPANY",  "1000");  
				ht13_2.put("ID_WRITE", insert_id);   
				ht13_2.put("CD_DOCU",  "11");  
				
				ht13_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht13_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht13_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
				ht13_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
				ht13_2.put("AMT",   		String.valueOf( a7_v_amt ));				
				ht13_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht13_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht13_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
				ht13_2.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
				ht13_2.put("CD_DEPT",		"");   //�μ�								 
				ht13_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht13_2.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht13_2.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht13_2.put("CD_EMPLOY",		"");   //���									 		 
				ht13_2.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht13_2.put("CD_BANK",		"");  //�������	
				ht13_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// �ΰ�������
				ht13_2.put("AM_TAXSTD",	 String.valueOf( a7_s_amt) );		 //����ǥ�ؾ�
				ht13_2.put("AM_ADDTAX",	String.valueOf( a7_v_amt) );		 //����
				ht13_2.put("TP_TAX",	"11");  //����(����) :11
				if(ven_type.equals("1")){ //����
					ht13_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
				} else {
					ht13_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
				}								
				ht13_2.put("NM_NOTE", doc_cont);  // ����			
							
				vt_auto.add(ht13_2);  // �ΰ���		
						
				//�����δ��� �Ϻ� ��� - �ܻ�����, ����/��Ʈ ������� �����Ͽ� ó�� 
			    if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc2_amt_2")) + AddUtil.parseDigit(request.getParameter("etc2_amt_2_v"))- a7_s_amt - a7_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
				 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
					 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �����δ���" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	   doc_cont =  cls.getCls_st()  + " �����δ���" + "-" + car_no + " " + firm_nm;
						}	
							 	  					
						line++;
									
						Hashtable ht13_4 = new Hashtable();

						ht13_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht13_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht13_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht13_4.put("CD_PC",  	node_code);  //ȸ�����
						ht13_4.put("CD_WDEPT",  dept_code);  //�μ�
						ht13_4.put("NO_DOCU",  	"");  //�̰��� '0' 
						ht13_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht13_4.put("CD_COMPANY",  "1000");  
						ht13_4.put("ID_WRITE", insert_id);   
						ht13_4.put("CD_DOCU",  "11");  
						
						ht13_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht13_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht13_4.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
						ht13_4.put("CD_ACCT",  "10800");   // 
						ht13_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
						ht13_4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
						ht13_4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
													
						ht13_4.put("DT_START",  "");  	//�߻�����										 
						ht13_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht13_4.put("CD_DEPT",		"");   //�μ�								 
						ht13_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht13_4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht13_4.put("CD_CARD",		"");   //�ſ�ī��		 	
						ht13_4.put("CD_EMPLOY",		"");   //���									 		 
						ht13_4.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht13_4.put("CD_BANK",		"");  //�������	
						ht13_4.put("NO_ITEM",		"");  //item	  	 
						
							// �ΰ�������
						ht13_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht13_4.put("AM_ADDTAX",	"" );	 //����
						ht13_4.put("TP_TAX",	"");  //����(����) :11
						ht13_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
						ht13_4.put("NM_NOTE", doc_cont);  // ����		
									
						vt_auto.add(ht13_4);  //  �ܻ�����
					}	
							
			  }			
		 
		 // ���ݰ�꼭 ������ �ȵǾ��� ���
	   } else {	*/
				 	
		  	  // �����δ��� ���� ��꼭 �̸� ������� ���� ���� - �̶��� �ܻ����� 
		/*	 if ( clse.getTax_chk2().equals("Y")) {
		  		 
		  		 if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  > 0 ) {
					 
				 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc2_amt_2")) + AddUtil.parseDigit(request.getParameter("etc2_amt_2_v"));
				 	   
				 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
					 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
						 	if (cls_st.equals("7") ) {
									 doc_cont = "���������(����) �����δ���" + "-" + rent_l_cd + " " + firm_nm;
							} else {		 
							 	      	  doc_cont =  cls.getCls_st()  + " �����δ���" + "-" + car_no + " " + firm_nm;
							}	
					 	  															
							line++;
										
							Hashtable ht13_5 = new Hashtable();
							
							ht13_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
							ht13_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
							ht13_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
							ht13_5.put("CD_PC",  	node_code);  //ȸ�����
							ht13_5.put("CD_WDEPT",  dept_code);  //�μ�
							ht13_5.put("NO_DOCU",  	"");  //�̰��� '0' 
							ht13_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
							ht13_5.put("CD_COMPANY",  "1000");  
							ht13_5.put("ID_WRITE", insert_id);   
							ht13_5.put("CD_DOCU",  "11");  
							
							ht13_5.put("DT_ACCT", 	cls.getCls_dt()); 
							ht13_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
							ht13_5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
							ht13_5.put("CD_ACCT",  "10800");   // 
							ht13_5.put("AMT",    	String.valueOf( amt_10800) );			
							ht13_5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
							ht13_5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
														
							ht13_5.put("DT_START",  "");  	//�߻�����										 
							ht13_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
							ht13_5.put("CD_DEPT",		"");   //�μ�								 
							ht13_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
							ht13_5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
							ht13_5.put("CD_CARD",		"");   //�ſ�ī��		 	
							ht13_5.put("CD_EMPLOY",		"");   //���									 		 
							ht13_5.put("NO_DEPOSIT",	"");  //�����ݰ���
							ht13_5.put("CD_BANK",		"");  //�������	
							ht13_5.put("NO_ITEM",		"");  //item	  	 
							
								// �ΰ�������
							ht13_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
							ht13_5.put("AM_ADDTAX",	"" );	 //����
							ht13_5.put("TP_TAX",	"");  //����(����) :11
							ht13_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
									
							ht13_5.put("NM_NOTE", doc_cont);  // ����							
														
							vt_auto.add(ht13_5);  //  �ܻ�����
						}								
				  }	 		 	
		  
		     } else { //��å�� �����̸�
		*/
				if ( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))  > 0 ) { 	 	 	 	   
			 	// ���ݰ�꼭 ������� ������ �κ��� �������ظ�å������
				 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �����δ���" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	      	  doc_cont =  cls.getCls_st()  + " �����δ���" + "-" + car_no + " " + firm_nm;
					}	
			 	  						
					line++;
								
					Hashtable ht14 = new Hashtable();
					
					ht14.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht14.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht14.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht14.put("CD_PC",  	node_code);  //ȸ�����
					ht14.put("CD_WDEPT",  dept_code);  //�μ�
					ht14.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht14.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht14.put("CD_COMPANY",  "1000");  
					ht14.put("ID_WRITE", insert_id);   
					ht14.put("CD_DOCU",  "11");  
					
					ht14.put("DT_ACCT", 	cls.getCls_dt()); 
					ht14.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					//ht14.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
					//ht14.put("CD_ACCT", 	"91800");  //�������ظ�å��
					//ht14.put("AMT",    		String.valueOf( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))) );		
					
					ht14.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht14.put("CD_ACCT", 	"45510");  //�������ظ�å��
					ht14.put("AMT",    		String.valueOf( AddUtil.parseDigit(request.getParameter("etc2_amt_2"))*(-1)  ) );		
					
					ht14.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht14.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht14.put("DT_START",  "");  	//�߻�����										 
					ht14.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht14.put("CD_DEPT",		"");   //�μ�								 
					ht14.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht14.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht14.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht14.put("CD_EMPLOY",		"");   //���									 		 
					ht14.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht14.put("CD_BANK",		"");  //�������	
					ht14.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht14.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht14.put("AM_ADDTAX",	"" );	 //����
					ht14.put("TP_TAX",	"");  //����(����) :11
					ht14.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht14.put("NM_NOTE", doc_cont);  // ����	
								
					vt_auto.add(ht14);  //  ���ް�					
			    }
			    	
		//     }	  
	//  }	
	  
	 	  
	  //����������ġ -���񺸻� 
	  if ( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))  < 0 ) {	 	 	 	 	   
			 	//  �������ظ�å������
				 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ������������" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	     doc_cont =  cls.getCls_st()  + " ���񺸻� " + "-" + car_no + " " + firm_nm;
					}				 							
					
					line++;
								
					Hashtable ht16_3 = new Hashtable();	
					
					ht16_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht16_3.put("CD_PC",  	node_code);  //ȸ�����
					ht16_3.put("CD_WDEPT",  dept_code);  //�μ�
					ht16_3.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht16_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht16_3.put("CD_COMPANY",  "1000");  
					ht16_3.put("ID_WRITE", insert_id);   
					ht16_3.put("CD_DOCU",  "11");  
				
				
					ht16_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht16_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
			//		ht16_3.put("CD_ACCT", 	"25900");  //������
					ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2")) * (-1)     )    );				
					ht16_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü	
				//	ht16_3.put("CD_PARTNER",	"000048"); //�ŷ�ó    - A06					
				/*
				   if (  return_remark.equals("��Ÿ��") ) {
					   ht16_3.put("CD_PARTNER",	"000048"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322) 
				   } else if (  return_remark.equals("����") ) {
					   ht16_3.put("CD_PARTNER",	"995591"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
				   } else if (  return_remark.equals("ȥ��") ) {  //ȥ�ٴ� ���ԿɼǸ� 
					   ht16_3.put("CD_PARTNER",	"996528"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
				   } else if (  return_remark.equals("����") ) {
					   ht16_3.put("CD_PARTNER",	"996322"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
				   } else {
					   ht16_3.put("CD_ACCT", 	"45510");  //�������ظ�å��
					   ht16_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
				   }*/
				
					if (  return_remark.equals("��Ÿ��") ) {
							ht16_3.put("CD_ACCT", 	"25900");  //������
						   ht16_3.put("CD_PARTNER",	"000048"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322) 
					 } else if (  return_remark.equals("����") ) {
							ht16_3.put("CD_ACCT", 	"25900");  //������ 
							 ht16_3.put("CD_PARTNER",	"995591"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
					 } else if (  return_remark.equals("ȥ��") ) {  //ȥ�ٴ� ���ԿɼǸ� 
							ht16_3.put("CD_ACCT", 	"25900");  //������  
						 	ht16_3.put("CD_PARTNER",	"996528"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
					 } else if (  return_remark.equals("����") ) {
							ht16_3.put("CD_ACCT", 	"25900");  //������ 
						 	ht16_3.put("CD_PARTNER",	"996322"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
					 } else{
						 ht16_3.put("CD_ACCT", 	"45510");  //�������ظ�å��
						 ht16_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06 
					 }
																					
					ht16_3.put("DT_START",  "");  	//�߻�����										 
					ht16_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht16_3.put("CD_DEPT",		"");   //�μ�								 
					ht16_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht16_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht16_3.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht16_3.put("CD_EMPLOY",		"");   //���									 		 
					ht16_3.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht16_3.put("CD_BANK",		"");  //�������	
					ht16_3.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht16_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht16_3.put("AM_ADDTAX",	"" );	 //����
					ht16_3.put("TP_TAX",	"");  //����(����) :11
					ht16_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht16_3.put("NM_NOTE", doc_cont);  // ����	
															
					vt_auto.add(ht16_3);  //  ���ް�
						
	 }
	 	   
	 //����������ġ 
	  if ( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))  > 0 ) {	 	 	 	 	   
			 	//  �������ظ�å������
				 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ������������" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	      	  doc_cont =  cls.getCls_st()  + " ������������" + "-" + car_no + " " + firm_nm;
					}				 							
					
					line++;
								
					Hashtable ht16_3 = new Hashtable();	
					
					ht16_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht16_3.put("CD_PC",  	node_code);  //ȸ�����
					ht16_3.put("CD_WDEPT",  dept_code);  //�μ�
					ht16_3.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht16_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht16_3.put("CD_COMPANY",  "1000");  
					ht16_3.put("ID_WRITE", insert_id);   
					ht16_3.put("CD_DOCU",  "11");  
					
					ht16_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				//	ht16_3.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				//	ht16_3.put("CD_ACCT", 	"91800");  //�������ظ�å��
				//	ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))) );	
					
					ht16_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht16_3.put("CD_ACCT", 	"45510");  //�������ظ�å��
					ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))*(-1) ) );	
					
					
					ht16_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht16_3.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
												
					ht16_3.put("DT_START",  "");  	//�߻�����										 
					ht16_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht16_3.put("CD_DEPT",		"");   //�μ�								 
					ht16_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht16_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht16_3.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht16_3.put("CD_EMPLOY",		"");   //���									 		 
					ht16_3.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht16_3.put("CD_BANK",		"");  //�������	
					ht16_3.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht16_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht16_3.put("AM_ADDTAX",	"" );	 //����
					ht16_3.put("TP_TAX",	"");  //����(����) :11
					ht16_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht16_3.put("NM_NOTE", doc_cont);  // ����	
															
					vt_auto.add(ht16_3);  //  ���ް�
						
	 }

	 // ��Ÿ���ع��� ���� ��꼭 ����� ó��  
	/*  if ( a8_s_amt > 0 ) {
		 
		 	//  ��Ʈ(����)��������� ���� �ΰ���ó��
		 	 	if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) ���ع���" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
					 	    doc_cont =  cls.getCls_st()  + " ���ع���" + "-" + car_no + " " + firm_nm;
				}		
						
				if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  < 1 ) { 	  //�ܻ����� �߰�
				
					line++;
							
					Hashtable ht15_3 = new Hashtable();
					
					ht15_3.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht15_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht15_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht15_3.put("CD_PC",  	node_code);  //ȸ�����
					ht15_3.put("CD_WDEPT",  dept_code);  //�μ�
					ht15_3.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht15_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht15_3.put("CD_COMPANY",  "1000");  
					ht15_3.put("ID_WRITE", insert_id);   
					ht15_3.put("CD_DOCU",  "11");  
					
					ht15_3.put("DT_ACCT", 	cls.getCls_dt()); 
					ht15_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					//ht15_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					//ht15_3.put("CD_ACCT",  "91800");   // �������ع��� 				
					//ht15_3.put("AMT",    	String.valueOf( a8_s_amt + a8_v_amt) );		
					
					ht15_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht15_3.put("CD_ACCT",  "91800");   // �������ع��� 				
					ht15_3.put("AMT",    	String.valueOf( a8_s_amt + a8_v_amt) );			
					
					
					ht15_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht15_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht15_3.put("DT_START",  "");  	//�߻�����										 
					ht15_3.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht15_3.put("CD_DEPT",		"");   //�μ�								 
					ht15_3.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht15_3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht15_3.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht15_3.put("CD_EMPLOY",		"");   //���									 		 
					ht15_3.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht15_3.put("CD_BANK",		"");  //�������	
					ht15_3.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht15_3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht15_3.put("AM_ADDTAX",	"" );	 //����
					ht15_3.put("TP_TAX",	"");  //����(����) :11
					ht15_3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht15_3.put("NM_NOTE", doc_cont);  // ����									
										
					vt_auto.add(ht15_3);  //  �ܻ�����
							
				}	
					
				line++;
							
				Hashtable ht15 = new Hashtable();
				
				ht15.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht15.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht15.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht15.put("CD_PC",  	node_code);  //ȸ�����
				ht15.put("CD_WDEPT",  dept_code);  //�μ�
				ht15.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht15.put("CD_COMPANY",  "1000");  
				ht15.put("ID_WRITE", insert_id);   
				ht15.put("CD_DOCU",  "11");  
				
				ht15.put("DT_ACCT", 	cls.getCls_dt()); 
				ht15.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht15.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				
				if ( car_st.equals("1")  ) { //��Ʈ�̸�
						ht15.put("CD_ACCT",  	"41200");  //���ع���
				} else {
						ht15.put("CD_ACCT",  	"41700");  //���ع���
				}	
				
				ht15.put("AMT",    String.valueOf( a8_s_amt ) );	
				ht15.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht15.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht15.put("DT_START",  "");  	//�߻�����										 
				ht15.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht15.put("CD_DEPT",		"");   //�μ�								 
				ht15.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht15.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht15.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht15.put("CD_EMPLOY",		"");   //���									 		 
				ht15.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht15.put("CD_BANK",		"");  //�������	
				ht15.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht15.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht15.put("AM_ADDTAX",	"" );	 //����
				ht15.put("TP_TAX",	"");  //����(����) :11
				ht15.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht15.put("NM_NOTE", doc_cont);  // ����									
									
				vt_auto.add(ht15);  //  ���ް�
				
				line++;
				
				Hashtable ht15_2 = new Hashtable();
					
				ht15_2.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht15_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht15_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
				ht15_2.put("CD_PC",  	node_code);  //ȸ�����
				ht15_2.put("CD_WDEPT",  dept_code);  //�μ�
				ht15_2.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht15_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht15_2.put("CD_COMPANY",  "1000");  
				ht15_2.put("ID_WRITE", insert_id);   
				ht15_2.put("CD_DOCU",  "11");  
				
				ht15_2.put("DT_ACCT", 	cls.getCls_dt()); 
				ht15_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht15_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
				ht15_2.put("CD_ACCT",  	"25500");  //�ΰ���������					
				ht15_2.put("AMT",   	String.valueOf( a8_v_amt) );						
				ht15_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht15_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht15_2.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
				ht15_2.put("CD_BIZAREA",	"S101");   //�ͼӻ����	
				ht15_2.put("CD_DEPT",		"");   //�μ�								 
				ht15_2.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht15_2.put("CD_PJT",		"");   //������Ʈ�ڵ�		
				ht15_2.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht15_2.put("CD_EMPLOY",	"");   //���									 		 
				ht15_2.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht15_2.put("CD_BANK",		"");  //�������	
				ht15_2.put("NO_ITEM",		"");  //item	 	  	 
					
			// �ΰ�������
				ht15_2.put("AM_TAXSTD",	 String.valueOf( a8_s_amt) );		 //����ǥ�ؾ�
				ht15_2.put("AM_ADDTAX",	String.valueOf( a8_v_amt) );		 //����
				ht15_2.put("TP_TAX",	"11");  //����(����) :11
				if(ven_type.equals("1")){ //����
					ht15_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
				} else {
					ht15_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
				}								
				ht15_2.put("NM_NOTE", doc_cont);  // ����			
							
				vt_auto.add(ht15_2);  // �ΰ���		
						
					//��Ÿ���ع��� �Ϻ� ��� - �ܻ�����, ����/��Ʈ ������� �����Ͽ� ó�� 
			    if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc4_amt_2")) + AddUtil.parseDigit(request.getParameter("etc4_amt_2_v"))- a8_s_amt - a8_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
				 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
					 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ���ع���" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
							 	    doc_cont =  cls.getCls_st()  + " ���ع���" + "-" + car_no + " " + firm_nm;
						}	
				 	  						
						line++;
									
						Hashtable ht15_4 = new Hashtable();
						
						ht15_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht15_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht15_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht15_4.put("CD_PC",  	node_code);  //ȸ�����
						ht15_4.put("CD_WDEPT",  dept_code);  //�μ�
						ht15_4.put("NO_DOCU",  	"");  //�̰��� '0' 
						ht15_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht15_4.put("CD_COMPANY",  "1000");  
						ht15_4.put("ID_WRITE", insert_id);   
						ht15_4.put("CD_DOCU",  "11");  
						
						ht15_4.put("DT_ACCT", 	cls.getCls_dt()); 
						ht15_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht15_4.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
				//		ht15_4.put("CD_ACCT",  "10800");   // 
						ht15_4.put("CD_ACCT",  "91800");   //
						ht15_4.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
						ht15_4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
						ht15_4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
													
						ht15_4.put("DT_START",  "");  	//�߻�����										 
						ht15_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht15_4.put("CD_DEPT",		"");   //�μ�								 
						ht15_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht15_4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht15_4.put("CD_CARD",		"");   //�ſ�ī��		 	
						ht15_4.put("CD_EMPLOY",		"");   //���									 		 
						ht15_4.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht15_4.put("CD_BANK",		"");  //�������	
						ht15_4.put("NO_ITEM",		"");  //item	  	 
						
							// �ΰ�������
						ht15_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht15_4.put("AM_ADDTAX",	"" );	 //����
						ht15_4.put("TP_TAX",	"");  //����(����) :11
						ht15_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
						ht15_4.put("NM_NOTE", doc_cont);  // ����									
											
						vt_auto.add(ht15_4);  //  �ܻ�����
					}	
							
			  }
		 
		 // ���ݰ�꼭 ������ �ȵǾ��� ���
	  } else {
	 */ 	
	  	  // ��Ÿ���ع��� ���� ��꼭 �̸� ������� ���� ���� - �̶��� �ܻ����� 
		/* if ( clse.getTax_chk3().equals("Y")) {
	  		 
	  		 if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {
				 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("etc4_amt_2")) + AddUtil.parseDigit(request.getParameter("etc4_amt_2_v"));
			 	   
			 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
				 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
				 		if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ���ع���" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	    doc_cont =  cls.getCls_st()  + " ���ع���" + "-" + car_no + " " + firm_nm;
						}	
				 	  	
														
						line++;
									
						Hashtable ht15_5 = new Hashtable();
				
						ht15_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht15_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht15_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht15_5.put("CD_PC",  	node_code);  //ȸ�����
						ht15_5.put("CD_WDEPT",  dept_code);  //�μ�
						ht15_5.put("NO_DOCU",  	"");  //�̰��� '0' 
						ht15_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht15_5.put("CD_COMPANY",  "1000");  
						ht15_5.put("ID_WRITE", insert_id);   
						ht15_5.put("CD_DOCU",  "11");  
						
						ht15_5.put("DT_ACCT", 	cls.getCls_dt()); 
						ht15_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht15_5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				//		ht15_5.put("CD_ACCT",  "10800");   // 
						ht15_5.put("CD_ACCT",  "91800");   // 
						ht15_5.put("AMT",    		String.valueOf( amt_10800) );			
						ht15_5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
						ht15_5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
													
						ht15_5.put("DT_START",  "");  	//�߻�����										 
						ht15_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht15_5.put("CD_DEPT",		"");   //�μ�								 
						ht15_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht15_5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht15_5.put("CD_CARD",		"");   //�ſ�ī��		 	
						ht15_5.put("CD_EMPLOY",		"");   //���									 		 
						ht15_5.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht15_5.put("CD_BANK",		"");  //�������	
						ht15_5.put("NO_ITEM",		"");  //item	  	 
						
							// �ΰ�������
						ht15_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht15_5.put("AM_ADDTAX",	"" );	 //����
						ht15_5.put("TP_TAX",	"");  //����(����) :11
						ht15_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
						ht15_5.put("NM_NOTE", doc_cont);  // ����	
													
						vt_auto.add(ht15_5);  //  �ܻ�����
					}								
			  }	 		 	
	  
	     } else { //��å�� �����̸�
	  */
			 if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {	 	 	 	 	   
			 	// ���ݰ�꼭 ������� ������ �κ��� �������ظ�å������
			 		if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) ���ع���" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
							    doc_cont =  cls.getCls_st()  + " ���ع���" + "-" + car_no + " " + firm_nm;
					}		 	  		
						
					line++;
								
					Hashtable ht16 = new Hashtable();		
					
					ht16.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht16.put("CD_PC",  	node_code);  //ȸ�����
					ht16.put("CD_WDEPT",  dept_code);  //�μ�
					ht16.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht16.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht16.put("CD_COMPANY",  "1000");  
					ht16.put("ID_WRITE", insert_id);   
					ht16.put("CD_DOCU",  "11");  
					
					ht16.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				//	ht16.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				//	ht16.put("CD_ACCT",   	"91800");  //�������ظ�å��
				//	ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))) );	
					
					ht16.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht16.put("CD_ACCT",   	"45510");  //�������ظ�å��
					ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))*(-1)  ) );	
					
					ht16.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht16.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht16.put("DT_START",  "");  	//�߻�����										 
					ht16.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht16.put("CD_DEPT",		"");   //�μ�								 
					ht16.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht16.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht16.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht16.put("CD_EMPLOY",		"");   //���									 		 
					ht16.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht16.put("CD_BANK",		"");  //�������	
					ht16.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht16.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht16.put("AM_ADDTAX",	"" );	 //����
					ht16.put("TP_TAX",	"");  //����(����) :11
					ht16.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht16.put("NM_NOTE", doc_cont);  // ����			
											
					vt_auto.add(ht16);  //  ���ް�
						
			  }
	//	 }	   
	//  }	
			      
	   //�ʰ����� �δ�� ��꼭 ����� ó��   
	  if ( a9_s_amt > 0 ) {
		 
		 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
			 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����)  �ʰ�����뿩��" + "-" + rent_l_cd + " " + firm_nm;
				} else {		 
				 	      		  doc_cont =  cls.getCls_st()  + " �ʰ�����뿩��" + "-" + car_no + " " + firm_nm;
				}	
				 	  
				if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  < 1 ) { 	  //�ܻ����� �߰�
				
					line++;
							
					Hashtable ht16_4 = new Hashtable();
					
					ht16_4.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht16_4.put("CD_PC",  	node_code);  //ȸ�����
					ht16_4.put("CD_WDEPT",  dept_code);  //�μ�
					ht16_4.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht16_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht16_4.put("CD_COMPANY",  "1000");  
					ht16_4.put("ID_WRITE", insert_id);   
					ht16_4.put("CD_DOCU",  "11");  
					
					ht16_4.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht16_4.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht16_4.put("CD_ACCT",  "10800");   // 
					ht16_4.put("AMT",    		String.valueOf( a9_s_amt + a9_v_amt ));
					ht16_4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht16_4.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht16_4.put("DT_START",  "");  	//�߻�����										 
					ht16_4.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht16_4.put("CD_DEPT",		"");   //�μ�								 
					ht16_4.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht16_4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht16_4.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht16_4.put("CD_EMPLOY",		"");   //���									 		 
					ht16_4.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht16_4.put("CD_BANK",		"");  //�������	
					ht16_4.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht16_4.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht16_4.put("AM_ADDTAX",	"" );	 //����
					ht16_4.put("TP_TAX",	"");  //����(����) :11
					ht16_4.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht16_4.put("NM_NOTE", doc_cont);  // ����									
											
					vt_auto.add(ht16_4);  //  �ܻ�����						
				}	
				
				line++;
							
				Hashtable ht16_5 = new Hashtable();
					
				ht16_5.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht16_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht16_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht16_5.put("CD_PC",  	node_code);  //ȸ�����
				ht16_5.put("CD_WDEPT",  dept_code);  //�μ�
				ht16_5.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht16_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht16_5.put("CD_COMPANY",  "1000");  
				ht16_5.put("ID_WRITE", insert_id);   
				ht16_5.put("CD_DOCU",  "11");  
				
				ht16_5.put("DT_ACCT", 	cls.getCls_dt()); 
				ht16_5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht16_5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				
				if ( car_st.equals("1")  ) { //��Ʈ�̸�
						ht16_5.put("CD_ACCT",  	"41200");  //�ʰ����� �δ��
				} else {
						ht16_5.put("CD_ACCT",  	"41700");  //�ʰ����� �δ��
				}	
				
				ht16_5.put("AMT",    	String.valueOf( a9_s_amt ) );			
				ht16_5.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht16_5.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht16_5.put("DT_START",  "");  	//�߻�����										 
				ht16_5.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht16_5.put("CD_DEPT",		"");   //�μ�								 
				ht16_5.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht16_5.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht16_5.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht16_5.put("CD_EMPLOY",		"");   //���									 		 
				ht16_5.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht16_5.put("CD_BANK",		"");  //�������	
				ht16_5.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht16_5.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht16_5.put("AM_ADDTAX",	"" );	 //����
				ht16_5.put("TP_TAX",	"");  //����(����) :11
				ht16_5.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht16_5.put("NM_NOTE", doc_cont);  // ����									
									
				vt_auto.add(ht16_5);  //  ���ް�
				
				line++;
				
				Hashtable ht16_6 = new Hashtable();
					
				ht16_6.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht16_6.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht16_6.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
				ht16_6.put("CD_PC",  	node_code);  //ȸ�����
				ht16_6.put("CD_WDEPT",  dept_code);  //�μ�
				ht16_6.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht16_6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht16_6.put("CD_COMPANY",  "1000");  
				ht16_6.put("ID_WRITE", insert_id);   
				ht16_6.put("CD_DOCU",  "11");  
				
				ht16_6.put("DT_ACCT", 	cls.getCls_dt()); 
				ht16_6.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht16_6.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
				ht16_6.put("CD_ACCT",  		"25500");  //�ΰ���������					
				ht16_6.put("AMT",   		String.valueOf( a9_v_amt ) );								
				ht16_6.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht16_6.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht16_6.put("DT_START", cls.getCls_dt());  	//�߻����� - �ΰ���										 
				ht16_6.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
				ht16_6.put("CD_DEPT",		"");   //�μ�								 
				ht16_6.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht16_6.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht16_6.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht16_6.put("CD_EMPLOY",		"");   //���									 		 
				ht16_6.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht16_6.put("CD_BANK",		"");  //�������	
				ht16_6.put("NO_ITEM",		"");  //item	 	  	 
					
			// �ΰ�������
				ht16_6.put("AM_TAXSTD",	 String.valueOf( a9_s_amt) );		 //����ǥ�ؾ�
				ht16_6.put("AM_ADDTAX",	String.valueOf( a9_v_amt) );		 //����
				ht16_6.put("TP_TAX",	"11");  //����(����) :11
				if(ven_type.equals("1")){ //����
					ht16_6.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
				} else {
					ht16_6.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
				}									
				ht16_6.put("NM_NOTE", doc_cont);  // ����	
								
				vt_auto.add(ht16_6);  // �ΰ���		
				
				
						//�ʰ�����δ�� �Ϻ� ��� - �ܻ�����, ����/��Ʈ ������� �����Ͽ� ó�� 
			    if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {
			 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"))- a9_s_amt - a9_v_amt;
			 	   
			 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
				 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
					 	if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �ʰ�����뿩��" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
							 	    doc_cont =  cls.getCls_st()  + " �ʰ�����뿩��" + "-" + car_no + " " + firm_nm;
						}	
				 	  						
						line++;
									
						Hashtable ht16_7 = new Hashtable();
						
						ht16_7.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht16_7.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht16_7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht16_7.put("CD_PC",  	node_code);  //ȸ�����
						ht16_7.put("CD_WDEPT",  dept_code);  //�μ�
						ht16_7.put("NO_DOCU",  	"");  //�̰��� '0' 
						ht16_7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht16_7.put("CD_COMPANY",  "1000");  
						ht16_7.put("ID_WRITE", insert_id);   
						ht16_7.put("CD_DOCU",  "11");  
						
						ht16_7.put("DT_ACCT", 	cls.getCls_dt()); 
						ht16_7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht16_7.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
						ht16_7.put("CD_ACCT",  "10800");   // 
						ht16_7.put("AMT",    	String.valueOf( amt_10800 * (-1) ));	
						ht16_7.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
						ht16_7.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
													
						ht16_7.put("DT_START",  "");  	//�߻�����										 
						ht16_7.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht16_7.put("CD_DEPT",		"");   //�μ�								 
						ht16_7.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht16_7.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht16_7.put("CD_CARD",		"");   //�ſ�ī��		 	
						ht16_7.put("CD_EMPLOY",		"");   //���									 		 
						ht16_7.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht16_7.put("CD_BANK",		"");  //�������	
						ht16_7.put("NO_ITEM",		"");  //item	  	 
						
							// �ΰ�������
						ht16_7.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht16_7.put("AM_ADDTAX",	"" );	 //����
						ht16_7.put("TP_TAX",	"");  //����(����) :11
						ht16_7.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
						ht16_7.put("NM_NOTE", doc_cont);  // ����									
											
						vt_auto.add(ht16_7);  //  �ܻ�����
				}	
							
			 }			
		 // ���ݰ�꼭 ������ �ȵǾ��� ���
	  } else {
	  	
	  	  // �ʰ����� ���� ��꼭 �̸� ������� ���� ���� - �̶��� �ܻ����� 
		 if ( clse.getTax_chk4().equals("Y")) {
	  		 
	  		 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {
				 
			 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"));
			 	   
			 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
				 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
				 		if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �ʰ�����뿩��" + "-" + rent_l_cd + " " + firm_nm;
						} else {		 
						 	    doc_cont =  cls.getCls_st()  + " �ʰ�����뿩��" + "-" + car_no + " " + firm_nm;
						}	
				 	  	
														
						line++;
									
						Hashtable ht16_8 = new Hashtable();
				
						ht16_8.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
						ht16_8.put("ROW_NO",  	String.valueOf(line)); //row_no							
						ht16_8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
						ht16_8.put("CD_PC",  	node_code);  //ȸ�����
						ht16_8.put("CD_WDEPT",  dept_code);  //�μ�
						ht16_8.put("NO_DOCU",  	"");  //�̰��� '0' 
						ht16_8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
						ht16_8.put("CD_COMPANY",  "1000");  
						ht16_8.put("ID_WRITE", insert_id);   
						ht16_8.put("CD_DOCU",  "11");  
						
						ht16_8.put("DT_ACCT", 	cls.getCls_dt()); 
						ht16_8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
						ht16_8.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
						ht16_8.put("CD_ACCT",  "10800");   // 
						ht16_8.put("AMT",    		String.valueOf( amt_10800) );			
						ht16_8.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
						ht16_8.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
													
						ht16_8.put("DT_START",  "");  	//�߻�����										 
						ht16_8.put("CD_BIZAREA",		"");   //�ͼӻ����	
						ht16_8.put("CD_DEPT",		"");   //�μ�								 
						ht16_8.put("CD_CC",			"");   //�ڽ�Ʈ����		
						ht16_8.put("CD_PJT",			"");   //������Ʈ�ڵ�		
						ht16_8.put("CD_CARD",		"");   //�ſ�ī��		 	
						ht16_8.put("CD_EMPLOY",		"");   //���									 		 
						ht16_8.put("NO_DEPOSIT",	"");  //�����ݰ���
						ht16_8.put("CD_BANK",		"");  //�������	
						ht16_8.put("NO_ITEM",		"");  //item	  	 
						
							// �ΰ�������
						ht16_8.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
						ht16_8.put("AM_ADDTAX",	"" );	 //����
						ht16_8.put("TP_TAX",	"");  //����(����) :11
						ht16_8.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
								
						ht16_8.put("NM_NOTE", doc_cont);  // ����	
													
						vt_auto.add(ht16_8);  //  �ܻ�����
					}								
			  }	 		 	
	  
	     } /* else { 
	    	 //�������� �����̸�
	  
			 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {	 	 	 	 	   
			 	// ���ݰ�꼭 ������� ������ �κ��� ������������
			 		if (cls_st.equals("7") ) {
							 doc_cont = "���������(����) �ʰ� �����߰��뿩��" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
							    doc_cont =  cls.getCls_st()  + " �ʰ� �����߰��뿩��" + "-" + car_no + " " + firm_nm;
					}		 	  		
						
					line++;
								
					Hashtable ht16_9 = new Hashtable();		
					
					ht16_9.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16_9.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16_9.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht16_9.put("CD_PC",  	node_code);  //ȸ�����
					ht16_9.put("CD_WDEPT",  dept_code);  //�μ�
					ht16_9.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht16_9.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht16_9.put("CD_COMPANY",  "1000");  
					ht16_9.put("ID_WRITE", insert_id);   
					ht16_9.put("CD_DOCU",  "11");  
					
					ht16_9.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16_9.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht16_9.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
					
					if ( car_st.equals("1")  ) { //��Ʈ�̸�
							ht16_9.put("CD_ACCT",  	"41400");  //��������
					} else {
							ht16_9.put("CD_ACCT",  	"41800");  //��������
					}	
											
					ht16_9.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("over_amt_2"))) );			
					ht16_9.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht16_9.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht16_9.put("DT_START",  "");  	//�߻�����										 
					ht16_9.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht16_9.put("CD_DEPT",		"");   //�μ�								 
					ht16_9.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht16_9.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht16_9.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht16_9.put("CD_EMPLOY",		"");   //���									 		 
					ht16_9.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht16_9.put("CD_BANK",		"");  //�������	
					ht16_9.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht16_9.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht16_9.put("AM_ADDTAX",	"" );	 //����
					ht16_9.put("TP_TAX",	"");  //����(����) :11
					ht16_9.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht16_9.put("NM_NOTE", doc_cont);  // ����			
											
					vt_auto.add(ht16_9);  //  ���ް�
						
			  } 
		 }	*/   

	 }					 	

	 // �ʰ����� - �� ȯ�Ұ� 	 - 20220822�߰�   
	 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  < 0 ) {
		 // �ʰ����� - �̶��� �ܻ����� 
  		 if ( clse.getTax_chk4().equals("Y")) { //�����Ƿڽ� �ʰ�������  tax_chk4 "Y"�� setting ( �������࿩�ο� ��� ����)
			 
		 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"));
		 	   
		 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
			 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
			 		if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) �ʰ�����뿩��" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	    doc_cont =  cls.getCls_st()  + " �ʰ�����뿩��" + "-" + car_no + " " + firm_nm;
					}	
			 	  	
													
					line++;
								
					Hashtable ht16_8 = new Hashtable();
			
					ht16_8.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
					ht16_8.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht16_8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht16_8.put("CD_PC",  	node_code);  //ȸ�����
					ht16_8.put("CD_WDEPT",  dept_code);  //�μ�
					ht16_8.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht16_8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht16_8.put("CD_COMPANY",  "1000");  
					ht16_8.put("ID_WRITE", insert_id);   
					ht16_8.put("CD_DOCU",  "11");  
					
					ht16_8.put("DT_ACCT", 	cls.getCls_dt()); 
					ht16_8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht16_8.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
					ht16_8.put("CD_ACCT",  "10800");   // 
					ht16_8.put("AMT",    		String.valueOf( amt_10800) );			
					ht16_8.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
					ht16_8.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
												
					ht16_8.put("DT_START",  "");  	//�߻�����										 
					ht16_8.put("CD_BIZAREA",		"");   //�ͼӻ����	
					ht16_8.put("CD_DEPT",		"");   //�μ�								 
					ht16_8.put("CD_CC",			"");   //�ڽ�Ʈ����		
					ht16_8.put("CD_PJT",			"");   //������Ʈ�ڵ�		
					ht16_8.put("CD_CARD",		"");   //�ſ�ī��		 	
					ht16_8.put("CD_EMPLOY",		"");   //���									 		 
					ht16_8.put("NO_DEPOSIT",	"");  //�����ݰ���
					ht16_8.put("CD_BANK",		"");  //�������	
					ht16_8.put("NO_ITEM",		"");  //item	  	 
					
						// �ΰ�������
					ht16_8.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
					ht16_8.put("AM_ADDTAX",	"" );	 //����
					ht16_8.put("TP_TAX",	"");  //����(����) :11
					ht16_8.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
							
					ht16_8.put("NM_NOTE", doc_cont);  // ����	
												
					vt_auto.add(ht16_8);  //  �ܻ�����
				}								
		  }	
	 }	 
	 	 
	 
	//} // jung_st = 1 �ΰ�쿡�� �ش�	  
	   	
	 if ( jung_st.equals("2")) {
	   //������ ������ �ݾ�
		  if ( AddUtil.parseDigit(request.getParameter("h5_amt"))  > 0 ) {
		 		 
		 		 if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) ȯ��" + "-" + rent_l_cd + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				} else {		 
						 doc_cont =  cls.getCls_st()  + " ȯ��" + "-" + car_no + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				}		
		 						
				line++;
					 				   		
		   		Hashtable ht17 = new Hashtable(); 		
		   		
				ht17.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht17.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht17.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht17.put("CD_PC",  	node_code);  //ȸ�����
				ht17.put("CD_WDEPT",  dept_code);  //�μ�
				ht17.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht17.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht17.put("CD_COMPANY",  "1000");  
				ht17.put("ID_WRITE", insert_id);   
				ht17.put("CD_DOCU",  "11");  
				
				ht17.put("DT_ACCT", 	cls.getCls_dt()); 
				ht17.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht17.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				ht17.put("CD_ACCT",   	"25300");  //�����ޱ�
				ht17.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("h5_amt")) ) );				
				ht17.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht17.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht17.put("DT_START",  "");  	//�߻�����										 
				ht17.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht17.put("CD_DEPT",		"");   //�μ�								 
				ht17.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht17.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht17.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht17.put("CD_EMPLOY",		"");   //���									 		 
				ht17.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht17.put("CD_BANK",		"");  //�������	
				ht17.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht17.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht17.put("AM_ADDTAX",	"" );	 //����
				ht17.put("TP_TAX",	"");  //����(����) :11
				ht17.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht17.put("NM_NOTE", doc_cont);  // ����				
									
				vt_auto.add(ht17);  // ��ȯ��	 	
		  } 
	 
	 } else {
	   	
		  //������ ������ �ݾ�
		  if ( AddUtil.parseDigit(request.getParameter("fdft_amt2"))  < 0 ) {
		 		 
		 		 if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) ȯ��" + "-" + rent_l_cd + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				} else {		 
						 doc_cont =  cls.getCls_st()  + " ȯ��" + "-" + car_no + " " + firm_nm + " " + re_bank_nm + "-" + re_acc_no + "-" + re_acc_nm;
				}		
		 						
				line++;
					 				   		
		   		Hashtable ht17 = new Hashtable(); 		
		   		
				ht17.put("WRITE_DATE", 	cls.getCls_dt()); //row_id							
				ht17.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht17.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht17.put("CD_PC",  	node_code);  //ȸ�����
				ht17.put("CD_WDEPT",  dept_code);  //�μ�
				ht17.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht17.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht17.put("CD_COMPANY",  "1000");  
				ht17.put("ID_WRITE", insert_id);   
				ht17.put("CD_DOCU",  "11");  
				
				ht17.put("DT_ACCT", 	cls.getCls_dt()); 
				ht17.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht17.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
				ht17.put("CD_ACCT",   	"25300");  //�����ޱ�
				ht17.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("fdft_amt2"))*(-1)  ) );				
				ht17.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
				ht17.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
											
				ht17.put("DT_START",  "");  	//�߻�����										 
				ht17.put("CD_BIZAREA",		"");   //�ͼӻ����	
				ht17.put("CD_DEPT",		"");   //�μ�								 
				ht17.put("CD_CC",			"");   //�ڽ�Ʈ����		
				ht17.put("CD_PJT",			"");   //������Ʈ�ڵ�		
				ht17.put("CD_CARD",		"");   //�ſ�ī��		 	
				ht17.put("CD_EMPLOY",		"");   //���									 		 
				ht17.put("NO_DEPOSIT",	"");  //�����ݰ���
				ht17.put("CD_BANK",		"");  //�������	
				ht17.put("NO_ITEM",		"");  //item	  	 
				
					// �ΰ�������
				ht17.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
				ht17.put("AM_ADDTAX",	"" );	 //����
				ht17.put("TP_TAX",	"");  //����(����) :11
				ht17.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
						
				ht17.put("NM_NOTE", doc_cont);  // ����				
									
				vt_auto.add(ht17);  // ��ȯ��	 	
		  } 

	}
	  
	  if ( vt_m_auto.size() > 0){
		row_id_t = neoe_db.insertSetAutoDocu(cls_dt, vt_m_auto);
	  }	
	  // ���밡 Ʋ���� ������ �ȵǸ� ��� Ʋ�ȴ��� �ľ� �Ұ� 
	  if ( vt_auto.size() > 0){
		row_id = neoe_db.insertSetAutoDocu(cls_dt, vt_auto);
	  }
	   
	  //ȸ��ó�� 
	  if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "Y")) flag += 1; 

		//����
		String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
		String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
		String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
		String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
		String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
		String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	 	
		
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
	<input type='hidden' name='cont_st' value=''>
	</form>

	<script language='javascript'>
		var fm = document.form1;

	<%	if(flag != 0){ 	//�������̺� ���� ����%>

		alert('��� �����߻�!');

	<%	}else{ 			//�������̺� ���� ����.. %>
		
	    alert('ó���Ǿ����ϴ�');				
		fm.s_kd.value = '2';
//		fm.t_wd.value = fm.rent_l_cd.value;
	    fm.action ='<%=from_page%>';
	    fm.target='d_content';		
	    fm.submit();
	<%	
		} %>
	</script>
	</body>
	</html>