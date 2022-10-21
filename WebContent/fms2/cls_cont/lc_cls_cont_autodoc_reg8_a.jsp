<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.credit.*, acar.client.*, acar.fee.*,  acar.user_mng.*, acar.cls.*,  acar.cont.*, tax.*, acar.bill_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
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
		
	//������ �Ա���
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
		
	//���Կɼ��� (sui)
//	String m_sui_dt = request.getParameter("m_sui_dt")==null?"":request.getParameter("m_sui_dt");
	
	String real_date = "";
	int opt_ip_amt = 0;  
	 
		//�����Ƿ�����
	ClsEtcBean clse = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String ext_st = clse.getExt_st();  //���Կɼ� ���Աݾ� ȯ�ҿ���
		
   //��������					
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
		
	cls_st = "8";
	
	real_date = cls.getCls_dt();
			
	from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	
	
//	if ( !m_sui_dt.equals("") ) {
//		 real_date = m_sui_dt;	
//	} else {
		if ( !opt_ip_dt1.equals("") ) {	    	    	
				if ( !cls.getCls_dt().equals(opt_ip_dt1) ) {
				//   real_date = opt_ip_dt1;
				   real_date = cls.getCls_dt();
				} else {
				   real_date = cls.getCls_dt();
				}		   		
		}		
//	}
			
	//���:������
	ContBaseBean base 	= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	client_id = base.getClient_id();
	
	if(base.getTax_type().equals("2")){//����
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	
	//��Ÿ��� ���񺸻�
	int fuel_cnt = 0;
//	fuel_cnt= ac_db.getFuelCnt(rent_l_cd, "Y");	
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "Y" );	
	
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
    if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "Y"); 	
	   	return_remark = (String)return1.get("REMARK");
    }
    
    
	//�뿩����
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?"S1":fee.getBr_id();
	
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
	
	//������ �ŷ����� ���� ����
	String tax_item_id_tm = ac_db.getMaxFeeTaxItemTm(rent_l_cd);
		
	//������ �ŷ����� ������� - ���������
	Hashtable item_tax = ac_db.getLastFeeTaxItemItemId(rent_l_cd, tax_item_id_tm);
	
	//�ŷ����� ����Ʈ ��ȸ
	Vector tils	            = IssueDb.getTaxItemScdListCase(String.valueOf(item_tax.get("ITEM_ID")));
	int til_size            = tils.size();
	
	//������ �ŷ������� N���� ����
	if(til_size==1){//�Ǻ��϶�
		if ( String.valueOf(item_tax.get("USE_YN")).equals("Y") ) {
			if ( String.valueOf(item_tax.get("TAX_NO")).equals("") ) {
				if(!ac_db.updateTaxItemUseYn(String.valueOf(item_tax.get("ITEM_ID")) ) ) flag += 1;
			}		
		}			
	}		
	
		//������ ���ݰ�꼭
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
		
	//���ݰ�꼭 ������� - ���������
	Hashtable l_tax = ac_db.getLastFeeTaxDt(rent_l_cd, fee_tm);
	
	//������ ��꼭 ���೯¥ + 1 
	String item_dt2_p = "";
	
	//item_dt2_p = String.valueOf(item_tax.get("ITEM_DT1")); //�ŷ������� ������
	
	//���� �Ǵ� �ߵ����� fm.ifee_s_amt.value != '0' 
	
	item_dt2_p = c_db.addDay(String.valueOf(l_tax.get("ITEM_DT2")), 1);   //��꼭 �������� + 1
		
	//���Աݵ� ��å�� �� ��꼭 �̹����
	//��å�� ��û���� ���� ����ó�� ���� ����
	int car_ja_no_amt = ac_db.getClsEtcCarNoAmt(rent_mng_id, rent_l_cd);
			
	//���ݰ�꼭 �ۼ� �� �׿��� �ܻ����� ó��
	//String tax_j_hap[] = request.getParameterValues("tax_j_hap"); //����ݾ� (�ܾ�)
	String tax_r_g[] = request.getParameterValues("tax_r_g");
 	String tax_r_supply[] = request.getParameterValues("tax_rr_supply");
	String tax_r_value[] = request.getParameterValues("tax_rr_value");
	String tax_bigo[] = request.getParameterValues("tax_r_bigo");
 
	int tax_size = tax_r_g.length;
	String tax_no = "";
	String row_id = "";
	String row_id_t = "";
	
	int data_no =0;
	int data_no_t =0;
  	int tax_cnt = 0;
  	
  	//���ݰ�꼭 ����
  	int  a1_s_amt = 0;  //�ܿ����ô뿩��
    int  a1_v_amt = 0;
    int  a2_s_amt = 0;  //�ܿ������� 
    int  a2_v_amt = 0;
    int  a3_s_amt = 0;  //��Ҵ뿩��
    int  a3_v_amt = 0;
    int  a4_s_amt = 0;  //�̳��뿩��
    int  a4_v_amt = 0;
    int  a5_s_amt = 0;  //���������
    int  a5_v_amt = 0;
    int  a6_s_amt = 0;  //ȸ�����ֺ��
    int  a6_v_amt = 0;
    int  a7_s_amt = 0;  //ȸ���δ���
    int  a7_v_amt = 0;
    int  a8_s_amt = 0;  //���ع��
    int  a8_v_amt = 0;
    int  a9_s_amt = 0;  //�ʰ� �����߰��뿩�� - ��꼭 �ʼ�
    int  a9_v_amt = 0;
  	
  	String item_id = "";
  	String reg_code = "";	
  	String ven_code = "";

	int cls_fee =  0;
	
	for(int ii = 0; ii<tax_size; ii++){
		
		String tax_r_chk = request.getParameter("tax_r_chk"+ii)==null?"N":	request.getParameter("tax_r_chk"+ii);
		
		if(tax_r_chk.equals("Y")){				
			if ( tax_r_g[ii].equals("���� ��� �뿩��") ) {
			    	cls_fee++;
	        }
	        if ( tax_r_g[ii].equals("���� �̳� �뿩��")  ||  tax_r_g[ii].equals("���� �뿩��")  ) {
			    	cls_fee++;
	        }	
		}
	
	}
	
	for(int i = 0; i<tax_size; i++){ 
	
		String tax_r_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
		out.println(tax_r_chk);
		if(tax_r_chk.equals("Y") && AddUtil.parseDigit(tax_r_supply[i]) != 0 ){  //�ݾ��� 0���� ũ��???

			out.println("����"+i+"=<br><br>");
	 //   		tax_no = IssueDb.getTaxNoNext(real_date);
	   // 		out.println("tax_no="+tax_no+"<br>");
	    		out.println("tax_dt="+real_date+"<br>");
	    		out.println("tax_r_g="+tax_r_g[i]+"<br>");
	    		out.println("tax_r_supply="+tax_r_supply[i]+"<br>");
    		
			//����� item_id ��������
	//		item_id = IssueDb.getItemIdNext(real_date);
	//		out.println("item_id="+item_id+"<br><br>");
			    		
    		//�����ڵ� ��������
	//		reg_code  = Long.toString(System.currentTimeMillis());
	//		out.println("�����ڵ�="+reg_code+"<br>");
    		
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
			
			til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 2:����
			til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			
			if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
	    			til_bean.setItem_dt1( String.valueOf(l_tax.get("ITEM_DT1"))  );   //���Ⱓ
	    			til_bean.setItem_dt2( String.valueOf(l_tax.get("ITEM_DT2"))  );   //    
    			}    		   			
    		
    			//���ô뿩�� ����	- �������������� �뿩�Ⱓ���� ���� ���� ������.    		  	
		    	if ( tax_r_g[i].equals("���� �̳� �뿩��") ||    tax_r_g[i].equals("���� �뿩��")  ) {
		    	 	 	if ( AddUtil.parseDigit(request.getParameter("ifee_s_amt")) > 0 ) {
		    	 	 	
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
				ti_bean.setItem_dt(real_date);
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
	    	
	//    	if (tax_branch.equals("")) tax_branch = br_id;
	    	if (tax_branch.equals("")) tax_branch = "S1";   //br_id
	    		
	    	for(int k=0;k < vt_size2;k++){
				Hashtable ht_t = (Hashtable)vt2.elementAt(k);
							
				tax.TaxBean t_bean = new tax.TaxBean();						
				t_bean.setClient_id(client_id); 
				
			//	if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
	    		//		t_bean.setTax_dt( String.valueOf(l_tax.get("TAX_DT"))  );   //���̳ʽ� ��꼭 ������
	    		//	} else {
	    			t_bean.setTax_dt(real_date);
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
				t_bean.setRecCoName		(String.valueOf(ht_t.get("RECCONAME2")));
				t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
				t_bean.setRecCoAddr		(String.valueOf(ht_t.get("RECCOADDR")));
				t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
				t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2"))); 
    				
					//���ڼ��ݰ�꼭 �ǹ����� ���� ����	
				//���޹޴��ڰ� �����϶��� �������� ó��
				if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
						t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
						t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
						t_bean.setReccoregnotype("02");//����ڱ���-�ֹε�Ϲ�ȣ
				}else {
						t_bean.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
				}			
				
				// ���̳ʽ� ��꼭�� ��� ���� ��� 
				if ( tax_r_g[i].equals("���� ���ô뿩�� ȯ��")) {
					t_bean.setDoctype("02");   //���ް��������� ó��
				}else if ( tax_r_g[i].equals("���� ������ ȯ��")) {
	    				t_bean.setDoctype("02");   //���ް��������� ó��
	    			}else if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
	    		   //������Ҵ뿩�Ḹ �ִ� ���� ���,�̳��뿩�ᰡ ���� �ִ� ��� ó���� Ʋ�� :
			    		   if ( cls_fee == 1 ) {
			    			  t_bean.setDoctype("02");  //���ް��������� ó��
			    			  t_bean.setTax_bigo	( String.valueOf(l_tax.get("TAX_DT"))+"(���� ���ݰ�꼭 �ۼ���)");
			    		   } else if ( cls_fee == 2 ) {
			    		   	  t_bean.setDoctype("04");  //��������� ó��
			    		   }	     
	    			}													
				
				//--�ܱ���
			          if(foreigner.equals("2") ) {
			         		 t_bean.setReccoregnotype("03");     //�ܱ���
			                    t_bean.setRecCoRegNo("9999999999999");	
			                    t_bean.setTax_bigo(t_bean.getTax_bigo() +" "+  String.valueOf(ht_t.get("RECCOREGNO")) );	       
			          };
			          		
			      	tax_no = IssueDb.getTaxNoNext(real_date);
		    		out.println("tax_no="+tax_no+"<br>");
		    		
		    	    t_bean.setTax_no(tax_no);
		    		  
	    			if(!IssueDb.insertTax(t_bean)) flag += 1; 
	    			
	    			if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1; 
	    			
    			
    					// ���ݰ�꼭 ����� ���ް� �� �ΰ��� ����
		    		if ( tax_r_g[i].equals("���� ��� �뿩��") ) {
		    		   a3_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
		    		   a3_v_amt = AddUtil.parseDigit(tax_r_value[i]);
		    		}else if ( tax_r_g[i].equals("���� �̳� �뿩��")  || tax_r_g[i].equals("���� �뿩��")  ) {
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
		    		}else if ( tax_r_g[i].equals("���� �ʰ������߰��뿩��") || tax_r_g[i].equals("���� �ʰ�����뿩��") ) {
				       a9_s_amt = AddUtil.parseDigit(tax_r_supply[i]);
				       a9_v_amt = AddUtil.parseDigit(tax_r_value[i]);    	      	
		    		}    		
    		
	    		}	
    		    	  
    		    		
    		    //���ڼ��ݰ�꼭 ����
    		   		
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
	
	//�ڵ���ǥó����
	Vector vt_m_auto = new Vector();
	Vector vt_auto = new Vector();
			
	int line =0;
	int amt_10800 = 0;
	int amt_25900 = 0;
	String doc_cont = "";	
	
	// ��������� ��� ��������ǥ �߻��� (��꼭 �����Ϸ� )
	
	//���ݰ�꼭 ��Ұ� - ���� ���̳ʽ� (���ݰ�꼭 �������� ��ǥ�������̾�� ��)
	
   if ( a3_s_amt < 0 ) {
 
 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
 	  	if (cls_st.equals("1") ) {
				 doc_cont = "��ุ�� �뿩��" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "���Կɼ� �뿩��" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "�ߵ����� �뿩��" + "-" + car_no + " " + firm_nm;
		}		 
							
		line++;
					
		Hashtable ht7 = new Hashtable();						
				
		ht7.put("WRITE_DATE", 	real_date); //row_id							
		ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht7.put("CD_PC",  	node_code);  //ȸ�����
		ht7.put("CD_WDEPT",  dept_code);  //�μ�
		ht7.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht7.put("CD_COMPANY",  "1000");  
		ht7.put("ID_WRITE", insert_id);   
		ht7.put("CD_DOCU",  "11");  
		
		ht7.put("DT_ACCT", 	real_date); 
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
		
		ht7_1.put("WRITE_DATE", 	real_date); //row_id							
		ht7_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht7_1.put("CD_PC",  node_code);  //ȸ�����
		ht7_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht7_1.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht7_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht7_1.put("CD_COMPANY",  "1000");  
		ht7_1.put("ID_WRITE", insert_id);   
		ht7_1.put("CD_DOCU",  "11");  
		
		ht7_1.put("DT_ACCT", 	real_date); 
		ht7_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht7_1.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
		
		if ( base.getCar_st().equals("1") ) { //��Ʈ�̸�
				ht7_1.put("CD_ACCT",  	"41200");  //�뿩�������
		} else {
				ht7_1.put("CD_ACCT",  	"41700");  //�����������
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
			
		ht7_2.put("WRITE_DATE", 	real_date); //row_id							
		ht7_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
		ht7_2.put("CD_PC",  node_code);  //ȸ�����
		ht7_2.put("CD_WDEPT",  dept_code);  //�μ�
		ht7_2.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht7_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht7_2.put("CD_COMPANY",  "1000");  
		ht7_2.put("ID_WRITE", insert_id);   
		ht7_2.put("CD_DOCU",  "11");  
		
		ht7_2.put("DT_ACCT", 	real_date); 
		ht7_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht7_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
		ht7_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
		ht7_2.put("AMT",   		String.valueOf( a3_v_amt) );						
		ht7_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht7_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
									
		ht7_2.put("DT_START",  real_date);  	//�߻����� - �ΰ���										 
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
			
   	//������ - ������ 	
   	if ( AddUtil.parseDigit(request.getParameter("grt_amt"))  > 0 ) {
  
		if (cls_st.equals("1") ) {
				 doc_cont = "��ุ�� ������" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "���Կɼ� ������" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "�ߵ����� ������" + "-" + car_no + " " + firm_nm;
		}		 
			
		line++;
					
		Hashtable ht2_1 = new Hashtable();
		
		ht2_1.put("WRITE_DATE", 	real_date); //row_id							
		ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht2_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht2_1.put("CD_PC",  	node_code);  //ȸ�����
		ht2_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht2_1.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht2_1.put("CD_COMPANY",  "1000");  
		ht2_1.put("ID_WRITE", insert_id);   
		ht2_1.put("CD_DOCU",  "11");  
		
		ht2_1.put("DT_ACCT", 	real_date); 
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
   	  
   	  	if (cls_st.equals("1") ) {
				 doc_cont = "��ุ�� ���ô뿩��" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "���Կɼ� ���ô뿩��" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "�ߵ����� ���ô뿩��" + "-" + car_no + " " + firm_nm;
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
			
/*	������		
		line++;
					
		Hashtable ht2_2 = new Hashtable();
		
		ht2_2.put("WRITE_DATE", 	real_date); //row_id							
		ht2_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht2_2.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht2_2.put("CD_PC",  	node_code);  //ȸ�����
		ht2_2.put("CD_WDEPT",  dept_code);  //�μ�
		ht2_2.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht2_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht2_2.put("CD_COMPANY",  "1000");  
		ht2_2.put("ID_WRITE", insert_id);   
		ht2_2.put("CD_DOCU",  "11");  
		
		ht2_2.put("DT_ACCT", 	real_date); 
		ht2_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht2_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
		
		if ( base.getCar_st().equals("1") ) { //��Ʈ�̸�
			ht2_2.put("CD_ACCT",  	"41200");  //�ܿ����ô뿩��
		} else {
			ht2_2.put("CD_ACCT",  	"41700");   //�ܿ����ô뿩��
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
					
		ht3_2.put("WRITE_DATE", 	real_date); //row_id							
		ht3_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht3_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
		ht3_2.put("CD_PC",  node_code);  //ȸ�����
		ht3_2.put("CD_WDEPT",  dept_code);  //�μ�
		ht3_2.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht3_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht3_2.put("CD_COMPANY",  "1000");  
		ht3_2.put("ID_WRITE", insert_id);   
		ht3_2.put("CD_DOCU",  "11");  
		
		ht3_2.put("DT_ACCT", 	real_date); 
		ht3_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht3_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
		ht3_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
		ht3_2.put("AMT",   		String.valueOf( a1_v_amt) );							
		ht3_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht3_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
									
		ht3_2.put("DT_START",  real_date);  	//�߻����� - �ΰ���										 
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
   	  
   	   	if (cls_st.equals("1") ) {
				 doc_cont = "��ุ�� ������" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "���Կɼ� ������" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "�ߵ����� ������" + "-" + car_no + " " + firm_nm;
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
		ht3_4.put("CD_ACCT",  	"10800");  //�ܻ�����	
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

/* ������ - 20140101			
		line++;
					
		Hashtable ht2_3 = new Hashtable();
			
		ht2_3.put("WRITE_DATE", 	real_date); //row_id							
		ht2_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht2_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht2_3.put("CD_PC",  	node_code);  //ȸ�����
		ht2_3.put("CD_WDEPT",  dept_code);  //�μ�
		ht2_3.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht2_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht2_3.put("CD_COMPANY",  "1000");  
		ht2_3.put("ID_WRITE", insert_id);   
		ht2_3.put("CD_DOCU",  "11");  
		
		ht2_3.put("DT_ACCT", 	real_date); 
		ht2_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht2_3.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
		
		if ( base.getCar_st().equals("1") ) { //��Ʈ�̸�
			ht2_3.put("CD_ACCT",  	"41200");  //�ܿ�������
		} else {
			ht2_3.put("CD_ACCT",  	"41700");  //�ܿ�������
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
			
		ht3_3.put("WRITE_DATE", 	real_date); //row_id							
		ht3_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht3_3.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
		ht3_3.put("CD_PC",  node_code);  //ȸ�����
		ht3_3.put("CD_WDEPT",  dept_code);  //�μ�
		ht3_3.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht3_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht3_3.put("CD_COMPANY",  "1000");  
		ht3_3.put("ID_WRITE", insert_id);   
		ht3_3.put("CD_DOCU",  "11");  
		
		ht3_3.put("DT_ACCT", 	real_date); 
		ht3_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht3_3.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
		ht3_3.put("CD_ACCT",  		"25500");  //�ΰ���������					
		ht3_3.put("AMT",   		String.valueOf( a2_v_amt) );								
		ht3_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht3_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
									
		ht3_3.put("DT_START", real_date);  	//�߻����� - �ΰ���										 
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
       
   //-----------------�̳��ݾ� ���� ------------------------
	  		  
	 // ���·� ��� -  �̼���
   if ( AddUtil.parseDigit(request.getParameter("fine_amt_2")) > 0 ) {
	 
		if (cls_st.equals("1") ) {
			 doc_cont = "��ุ�� ���·�" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "���Կɼ� ���·�" + "-" + car_no + " " + firm_nm;
		} else {
			 doc_cont = "�ߵ����� ���·�" + "-" + car_no + " " + firm_nm;
		} 
		
		line++;
		
		Hashtable ht4 = new Hashtable();
		
		ht4.put("WRITE_DATE", 	real_date); //row_id							
		ht4.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht4.put("CD_PC",  	node_code);  //ȸ�����
		ht4.put("CD_WDEPT",  dept_code);  //�μ�
		ht4.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht4.put("CD_COMPANY",  "1000");  
		ht4.put("ID_WRITE", insert_id);   
		ht4.put("CD_DOCU",  "11");  
		
		ht4.put("DT_ACCT", 	real_date); 
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
 	   
 	   if (cls_st.equals("1") ) {
			 doc_cont = "��ุ�� ��å��" + "-" + car_no + " " + firm_nm;
	   } else if (cls_st.equals("8") ) {
			 doc_cont = "���Կɼ� ��å��" + "-" + car_no + " " + firm_nm;
	   } else {
			 doc_cont = "�ߵ����� ��å��" + "-" + car_no + " " + firm_nm;
	   }		 
		
 	   if ( amt_10800 > 0) {  //�ܻ������� �ִ� ��츸 
	 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
	 	  
			line++;
						
			Hashtable ht5_1 = new Hashtable();
			
			ht5_1.put("WRITE_DATE", 	real_date); //row_id							
			ht5_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht5_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht5_1.put("CD_PC",  	node_code);  //ȸ�����
			ht5_1.put("CD_WDEPT",  dept_code);  //�μ�
			ht5_1.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht5_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht5_1.put("CD_COMPANY",  "1000");  
			ht5_1.put("ID_WRITE", insert_id);   
			ht5_1.put("CD_DOCU",  "11");  
			
			ht5_1.put("DT_ACCT", 	real_date); 
			ht5_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		//	ht5_1.put("TP_DRCR",   "2");   // �뺯:2 , ����:1		
		//	ht5_1.put("CD_ACCT",  	"91800");  ////�������ظ�å��	
		//	ht5_1.put("AMT",   String.valueOf( amt_10800) );	
	
			ht5_1.put("TP_DRCR",   "1");   // �뺯:2 , ����:1		
			ht5_1.put("CD_ACCT",  	"45510");  ////�������ظ�å��	-> �������������(45510) - 20211116 ȸ����� ���� 
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
							
			ht5.put("WRITE_DATE", 	real_date); //row_id							
			ht5.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht5.put("CD_PC",  	node_code);  //ȸ�����
			ht5.put("CD_WDEPT",  dept_code);  //�μ�
			ht5.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht5.put("CD_COMPANY",  "1000");  
			ht5.put("ID_WRITE", insert_id);   
			ht5.put("CD_DOCU",  "11");  
			
			ht5.put("DT_ACCT", 	real_date); 
			ht5.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		//	ht5.put("TP_DRCR",   "2");   // �뺯:2 , ����:1		
		//	ht5.put("CD_ACCT",  	"91800");  //�������ظ�å��
		//	ht5.put("AMT",  	String.valueOf( car_ja_no_amt ));	
			
			ht5.put("TP_DRCR",   "1");   // �뺯:2 , ����:1		
			ht5.put("CD_ACCT",  	"45510");  //�������ظ�å��
			ht5.put("AMT",  	String.valueOf( car_ja_no_amt *(-1) ));	
			
			
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
 	
 		if (cls_st.equals("1") ) {
			 doc_cont = "��ุ�� ��ü��" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "���Կɼ� ��ü��" + "-" + car_no + " " + firm_nm;
		} else {
			 doc_cont = "�ߵ����� ��ü��" + "-" + car_no + " " + firm_nm;
		}		
		
		line++;
			 				   		
   		Hashtable ht6 = new Hashtable();
   		
   		ht6.put("WRITE_DATE", 	real_date); //row_id							
		ht6.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht6.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht6.put("CD_PC",  	node_code);  //ȸ�����
		ht6.put("CD_WDEPT",  dept_code);  //�μ�
		ht6.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht6.put("CD_COMPANY",  "1000");  
		ht6.put("ID_WRITE", insert_id);   
		ht6.put("CD_DOCU",  "11");  
		
		ht6.put("DT_ACCT", 	real_date); 
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
 	  	if (cls_st.equals("1") ) {
				 doc_cont = "��ุ�� �뿩��" + "-" + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
				 doc_cont = "���Կɼ� �뿩��" + "-" + car_no + " " + firm_nm;
		} else {
				 doc_cont = "�ߵ����� �뿩��" + "-" + car_no + " " + firm_nm;
		}		 
		
		if ( AddUtil.parseDigit(request.getParameter("dfee_amt_2"))  < 1 ) { 	 //�ܻ����� �߰�
			
				line++;
						
				Hashtable ht8_3 = new Hashtable();
				
				ht8_3.put("WRITE_DATE", 	real_date); //row_id							
				ht8_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht8_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht8_3.put("CD_PC",  	node_code);  //ȸ�����
				ht8_3.put("CD_WDEPT",  dept_code);  //�μ�
				ht8_3.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht8_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht8_3.put("CD_COMPANY",  "1000");  
				ht8_3.put("ID_WRITE", insert_id);   
				ht8_3.put("CD_DOCU",  "11");  
				
				ht8_3.put("DT_ACCT", 	real_date); 
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
		
		ht8_1.put("WRITE_DATE", 	real_date); //row_id							
		ht8_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht8_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht8_1.put("CD_PC",  	node_code);  //ȸ�����
		ht8_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht8_1.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht8_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht8_1.put("CD_COMPANY",  "1000");  
		ht8_1.put("ID_WRITE", insert_id);   
		ht8_1.put("CD_DOCU",  "11");  
		
		ht8_1.put("DT_ACCT", 	real_date); 
		ht8_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht8_1.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
		
		if ( base.getCar_st().equals("1") ) { //��Ʈ�̸�
				ht8_1.put("CD_ACCT",  	"41200");  //�뿩�������
		} else {
				ht8_1.put("CD_ACCT",  	"41700");  //�����������
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
		
		ht8_2.put("WRITE_DATE", 	real_date); //row_id							
		ht8_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht8_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
		ht8_2.put("CD_PC",  	node_code);  //ȸ�����
		ht8_2.put("CD_WDEPT",  dept_code);  //�μ�
		ht8_2.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht8_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht8_2.put("CD_COMPANY",  "1000");  
		ht8_2.put("ID_WRITE", insert_id);   
		ht8_2.put("CD_DOCU",  "11");  
		
		ht8_2.put("DT_ACCT", 	real_date); 
		ht8_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht8_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
		ht8_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
		ht8_2.put("AMT",   		String.valueOf( a4_v_amt) );								
		ht8_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht8_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
									
		ht8_2.put("DT_START",  real_date);  	//�߻����� - �ΰ���										 
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
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "��ุ�� �뿩��" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "���Կɼ� �뿩��" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "�ߵ����� �뿩��" + "-" + car_no + " " + firm_nm;
			}		 
				
			line++;
						
			Hashtable ht8 = new Hashtable();
				
			ht8.put("WRITE_DATE", 	real_date); //row_id							
			ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht8.put("CD_PC",  	node_code);  //ȸ�����
			ht8.put("CD_WDEPT",  dept_code);  //�μ�
			ht8.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht8.put("CD_COMPANY",  "1000");  
			ht8.put("ID_WRITE", insert_id);   
			ht8.put("CD_DOCU",  "11");  
			
			ht8.put("DT_ACCT", 	real_date); 
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
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "��ุ�� �뿩��" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "���Կɼ� �뿩��" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "�ߵ����� �뿩��" + "-" + car_no + " " + firm_nm;
			}		 
				
			line++;
						
			Hashtable ht8_5 = new Hashtable();
				
			ht8_5.put("WRITE_DATE", 	real_date); //row_id							
			ht8_5.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_5.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht8_5.put("CD_PC",  node_code);  //ȸ�����
			ht8_5.put("CD_WDEPT",  dept_code);  //�μ�
			ht8_5.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht8_5.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht8_5.put("CD_COMPANY",  "1000");  
			ht8_5.put("ID_WRITE", insert_id);   
			ht8_5.put("CD_DOCU",  "11");  
			
			ht8_5.put("DT_ACCT", 	real_date); 
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
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "��ุ�� �뿩��" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "���Կɼ� �뿩��" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "�ߵ����� �뿩��" + "-" + car_no + " " + firm_nm;
			}		 
								
			line++;
						
			Hashtable ht8_7 = new Hashtable();
			
			ht8_7.put("WRITE_DATE", 	real_date); //row_id							
			ht8_7.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht8_7.put("CD_PC",  node_code);  //ȸ�����
			ht8_7.put("CD_WDEPT",  dept_code);  //�μ�
			ht8_7.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht8_7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht8_7.put("CD_COMPANY",  "1000");  
			ht8_7.put("ID_WRITE", insert_id);   
			ht8_7.put("CD_DOCU",  "11");  
			
			ht8_7.put("DT_ACCT", 	real_date); 
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
    
   
  //����������ġ - ��Ÿ�� ���񺸻� 
  if ( AddUtil.parseDigit(request.getParameter("etc3_amt_2"))  < 0 ) {	 
  		
				if (cls_st.equals("8") ) {
					 doc_cont = "���Կɼ� ���񺸻�" + "-" + car_no + " " + firm_nm;
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
				ht16_3.put("CD_ACCT", 	"25900");  //������
				ht16_3.put("AMT",    		 	String.valueOf( AddUtil.parseDigit(request.getParameter("etc3_amt_2")) * (-1)     )    );				
				ht16_3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü		
				
		//		ht16_3.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06 - �ݶ����ص� Ư�� case 
				
				if (  return_remark.equals("��Ÿ��") ) {
					   ht16_3.put("CD_PARTNER",	"000048"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322) 
				 } else if (  return_remark.equals("����") ) {
					   ht16_3.put("CD_PARTNER",	"995591"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
				 } else if (  return_remark.equals("ȥ��") ) {  //ȥ�ٴ� ���ԿɼǸ� 
					   ht16_3.put("CD_PARTNER",	"996528"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
				 } else if (  return_remark.equals("����") ) {
					   ht16_3.put("CD_PARTNER",	"996322"); //�ŷ�ó    - A06  //�����ڵ���(000048) ȥ��(996528) ����(995591) , ����(996322)
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
 
    
    
   // ��Ÿ���ع��� ���� ��꼭 ����� ó�� 
 /*
  if ( a8_s_amt > 0 ) {
	 
	 	//  ��Ʈ(����)��������� ���� �ΰ���ó�� 
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "��ุ�� ���ع���" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "���Կɼ� ���ع���" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "�ߵ����� ���ع���" + "-" + car_no + " " + firm_nm;
			}		 
				
			if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  < 1 ) { 	  //�ܻ����� �߰�
			
				line++;
						
				Hashtable ht15_3 = new Hashtable();
				
				ht15_3.put("WRITE_DATE", 	real_date); //row_id							
				ht15_3.put("ROW_NO",  	String.valueOf(line)); //row_no							
				ht15_3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
				ht15_3.put("CD_PC",  	node_code);  //ȸ�����
				ht15_3.put("CD_WDEPT",  dept_code);  //�μ�
				ht15_3.put("NO_DOCU",  	"");  //�̰��� '0' 
				ht15_3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
				ht15_3.put("CD_COMPANY",  "1000");  
				ht15_3.put("ID_WRITE", insert_id);   
				ht15_3.put("CD_DOCU",  "11");  
				
				ht15_3.put("DT_ACCT", 	real_date); 
				ht15_3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
				ht15_3.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
				ht15_3.put("CD_ACCT",  "10800");   // �ܻ����� 
		//		ht15_3.put("CD_ACCT",  "91800");   //��å��  
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
			
			ht15.put("WRITE_DATE", 	real_date); //row_id							
			ht15.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht15.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht15.put("CD_PC",  	node_code);  //ȸ�����
			ht15.put("CD_WDEPT",  dept_code);  //�μ�
			ht15.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht15.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht15.put("CD_COMPANY",  "1000");  
			ht15.put("ID_WRITE", insert_id);   
			ht15.put("CD_DOCU",  "11");  
			
			ht15.put("DT_ACCT", 	real_date); 
			ht15.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht15.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			
			if ( base.getCar_st().equals("1") ) { //��Ʈ�̸�
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
			
			ht15_2.put("WRITE_DATE", 	real_date); //row_id							
			ht15_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht15_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
			ht15_2.put("CD_PC",  	node_code);  //ȸ�����
			ht15_2.put("CD_WDEPT",  dept_code);  //�μ�
			ht15_2.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht15_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht15_2.put("CD_COMPANY",  "1000");  
			ht15_2.put("ID_WRITE", insert_id);   
			ht15_2.put("CD_DOCU",  "11");  
			
			ht15_2.put("DT_ACCT", 	real_date); 
			ht15_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht15_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
			ht15_2.put("CD_ACCT",  	"25500");  //�ΰ���������					
			ht15_2.put("AMT",   	String.valueOf( a8_v_amt) );						
			ht15_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht15_2.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht15_2.put("DT_START", real_date);  	//�߻����� - �ΰ���										 
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
			 	  	if (cls_st.equals("1") ) {
							 doc_cont = "��ุ�� ���ع���" + "-" + car_no + " " + firm_nm;
					} else if (cls_st.equals("8") ) {
							 doc_cont = "���Կɼ� ���ع���" + "-" + car_no + " " + firm_nm;
					} else {
							 doc_cont = "�ߵ����� ���ع���" + "-" + car_no + " " + firm_nm;
					}		 
						
					line++;
								
					Hashtable ht15_4 = new Hashtable();
						
					ht15_4.put("WRITE_DATE", 	real_date); //row_id							
					ht15_4.put("ROW_NO",  	String.valueOf(line)); //row_no							
					ht15_4.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
					ht15_4.put("CD_PC",  	node_code);  //ȸ�����
					ht15_4.put("CD_WDEPT",  dept_code);  //�μ�
					ht15_4.put("NO_DOCU",  	"");  //�̰��� '0' 
					ht15_4.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
					ht15_4.put("CD_COMPANY",  "1000");  
					ht15_4.put("ID_WRITE", insert_id);   
					ht15_4.put("CD_DOCU",  "11");  
					
					ht15_4.put("DT_ACCT", 	real_date); 
					ht15_4.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
					ht15_4.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
					ht15_4.put("CD_ACCT",  "10800");   // 
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
	 if ( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))  > 0 ) {	 	 	 	 	   
	 	// ���ݰ�꼭 ������� ������ �κ��� �������ظ�å������
	 	  	if (cls_st.equals("1") ) {
					 doc_cont = "��ุ�� ���ع���" + "-" + car_no + " " + firm_nm;
			} else if (cls_st.equals("8") ) {
					 doc_cont = "���Կɼ� ���ع���" + "-" + car_no + " " + firm_nm;
			} else {
					 doc_cont = "�ߵ����� ���ع���" + "-" + car_no + " " + firm_nm;
			}		 
				
			line++;
						
			Hashtable ht16 = new Hashtable();
			
			ht16.put("WRITE_DATE", 	real_date); //row_id							
			ht16.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht16.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht16.put("CD_PC",  	node_code);  //ȸ�����
			ht16.put("CD_WDEPT",  dept_code);  //�μ�
			ht16.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht16.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht16.put("CD_COMPANY",  "1000");  
			ht16.put("ID_WRITE", insert_id);   
			ht16.put("CD_DOCU",  "11");  
			
			ht16.put("DT_ACCT", 	real_date); 
			ht16.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			//ht16.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			//ht16.put("CD_ACCT",   	"91800");  //�������ظ�å��
			//ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2"))) );		
			
			ht16.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
			ht16.put("CD_ACCT",   	"45510");  //�������ظ�å��
			ht16.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("etc4_amt_2")) * (-1)  ) );		
			
			
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
 // }	  
        
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
			
			if ( base.getCar_st().equals("1") ||  base.getCar_st().equals("4")  ) { //��Ʈ�̸�
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
  	
  	  // ��Ÿ���ع��� ���� ��꼭 �̸� ������� ���� ���� - �̶��� �ܻ����� 
	 if ( clse.getTax_chk4().equals("Y")) {
  		 
  		 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {
			 
		 	   amt_10800 = AddUtil.parseDigit(request.getParameter("over_amt_2")) + AddUtil.parseDigit(request.getParameter("over_amt_2_v"));
		 	   
		 	   if ( amt_10800 != 0) {  //�ܻ������� �ִ� ��츸 
			 	// ���ݰ�꼭 ������� ������ �κ��� �ܻ���������
			 		if (cls_st.equals("7") ) {
						 doc_cont = "���������(����) �ʰ� �����߰��뿩��" + "-" + rent_l_cd + " " + firm_nm;
					} else {		 
					 	    doc_cont =  cls.getCls_st()  + " �ʰ� �����߰��뿩��" + "-" + car_no + " " + firm_nm;
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
  
     } else { //�������� �����̸�
  
		 if ( AddUtil.parseDigit(request.getParameter("over_amt_2"))  > 0 ) {	 	 	 	 	   
		 	// ���ݰ�꼭 ������� ������ �κ��� �������ظ�å������
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
				
				if ( base.getCar_st().equals("1") ||  base.getCar_st().equals("4")  ) { //��Ʈ�̸�
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
	 }	   

 }					
 
   //���Կɼ��� ��쿡�� �ش�
  
  //���Կɼ� �������
  if ( AddUtil.parseDigit(request.getParameter("opt_amt"))  > 0 ) {
 	 	
 	 	//���ԿɼǱݾ� - ���뿹�� �ݾ� (�̹� ������ ó����)
 	 	
 	 	amt_25900 = AddUtil.parseDigit(request.getParameter("opt_amt")) - AddUtil.parseDigit(request.getParameter("opt_ip_amt1")) - AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) ; 
 	 	
 	 	 //0 �̻��� ���
 	 	if ( amt_25900 > 0 ) {
 	 		
			doc_cont = "���Կɼ� �������Դ��" + "-" + car_no + " " + firm_nm;
				
			line++;
				 				   		
	   		Hashtable ht23 = new Hashtable();
	   		
	   		ht23.put("WRITE_DATE", 	real_date); //row_id							
			ht23.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht23.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht23.put("CD_PC",  	node_code);  //ȸ�����
			ht23.put("CD_WDEPT",  dept_code);  //�μ�
			ht23.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht23.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht23.put("CD_COMPANY",  "1000");  
			ht23.put("ID_WRITE", insert_id);   
			ht23.put("CD_DOCU",  "11");  
			
			ht23.put("DT_ACCT", 	real_date); 
			ht23.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht23.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			ht23.put("CD_ACCT",  	"25900");  //������
			ht23.put("AMT",    	String.valueOf( amt_25900 ));						
			ht23.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht23.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht23.put("DT_START",  real_date); 	//�߻�����										 
			ht23.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht23.put("CD_DEPT",		"");   //�μ�								 
			ht23.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht23.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht23.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht23.put("CD_EMPLOY",		"");   //���									 		 
			ht23.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht23.put("CD_BANK",		"");  //�������	
			ht23.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht23.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht23.put("AM_ADDTAX",	"" );	 //����
			ht23.put("TP_TAX",	"");  //����(����) :11
			ht23.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht23.put("NM_NOTE", doc_cont);  // ����	
							
			vt_auto.add(ht23);  // �������
		}	
 	
 		 //�������� ���� ���� 
 	 	if ( amt_25900 < 0 ) {
 	 		
			doc_cont = "���Կɼ� �������Դ��" + "-" + car_no + " " + firm_nm;
				
			line++;
				 				   		
	   		Hashtable ht23 = new Hashtable();
	   		
	   		ht23.put("WRITE_DATE", 	real_date); //row_id							
			ht23.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht23.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht23.put("CD_PC",  	node_code);  //ȸ�����
			ht23.put("CD_WDEPT",  dept_code);  //�μ�
			ht23.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht23.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht23.put("CD_COMPANY",  "1000");  
			ht23.put("ID_WRITE", insert_id);   
			ht23.put("CD_DOCU",  "11");  
			
			ht23.put("DT_ACCT", 	real_date); 
			ht23.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht23.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
			ht23.put("CD_ACCT",  	"25900");  //������
			ht23.put("AMT",    String.valueOf( amt_25900 * (-1) ));				
			ht23.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht23.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht23.put("DT_START",  real_date); 	//�߻�����										 
			ht23.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht23.put("CD_DEPT",		"");   //�μ�								 
			ht23.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht23.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht23.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht23.put("CD_EMPLOY",		"");   //���									 		 
			ht23.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht23.put("CD_BANK",		"");  //�������	
			ht23.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht23.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht23.put("AM_ADDTAX",	"" );	 //����
			ht23.put("TP_TAX",	"");  //����(����) :11
			ht23.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht23.put("NM_NOTE", doc_cont);  // ����	
							
			vt_auto.add(ht23);  // �������
		}	 
  
  } 		
  		  
		  
  //���Կɼ� ��Ϻ��
  if ( AddUtil.parseDigit(request.getParameter("sui_d_amt"))  > 0 ) {
 	
	    doc_cont = "���Կɼ� ������Ϻ��" + "-" + car_no + " " + firm_nm;
	
		line++;
			 				   		
   		Hashtable ht23_1 = new Hashtable();
   		   			
   		ht23_1.put("WRITE_DATE", 	real_date); //row_id							
		ht23_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht23_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht23_1.put("CD_PC",  	node_code);  //ȸ�����
		ht23_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht23_1.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht23_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht23_1.put("CD_COMPANY",  "1000");  
		ht23_1.put("ID_WRITE", insert_id);   
		ht23_1.put("CD_DOCU",  "11");  
		
		ht23_1.put("DT_ACCT", 	real_date); 
		ht23_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht23_1.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
		ht23_1.put("CD_ACCT",  	"25700");  //������
		ht23_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("sui_d_amt"))) );							
		ht23_1.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht23_1.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
									
		ht23_1.put("DT_START",  ""); 	//�߻�����										 
		ht23_1.put("CD_BIZAREA",		"");   //�ͼӻ����	
		ht23_1.put("CD_DEPT",		"");   //�μ�								 
		ht23_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
		ht23_1.put("CD_PJT",			"");   //������Ʈ�ڵ�		
		ht23_1.put("CD_CARD",		"");   //�ſ�ī��		 	
		ht23_1.put("CD_EMPLOY",		"");   //���									 		 
		ht23_1.put("NO_DEPOSIT",	"");  //�����ݰ���
		ht23_1.put("CD_BANK",		"");  //�������	
		ht23_1.put("NO_ITEM",		"");  //item	  	 
		
			// �ΰ�������
		ht23_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
		ht23_1.put("AM_ADDTAX",	"" );	 //����
		ht23_1.put("TP_TAX",	"");  //����(����) :11
		ht23_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
				
		ht23_1.put("NM_NOTE", doc_cont);  // ����	
								
		vt_auto.add(ht23_1);  // ������Ϻ��
  } 		
		
  //��Ÿ ������ ���������� �ϴ�///
     //������ ������ �ݾ� : 		
 // opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  - AddUtil.parseDigit(request.getParameter("fdft_amt1_2")) - AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
  
   opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  -  AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
    
   System.out.println("���Կɼ� ���� =" +opt_ip_amt);
  
   if ( ext_st.equals("1") ) { //��ȯ��
     	if ( opt_ip_amt > 0 ) {  //������
    	
    	    doc_cont = "���Կɼ� ���Աݺ� ��ȯ��" + "-" + car_no + " " + firm_nm;
		
			line++;
				 				   		
	   		Hashtable ht27 = new Hashtable();
	   		
	   		ht27.put("WRITE_DATE", 	real_date); //row_id							
			ht27.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht27.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht27.put("CD_PC",  	node_code);  //ȸ�����
			ht27.put("CD_WDEPT",  dept_code);  //�μ�
			ht27.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht27.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht27.put("CD_COMPANY",  "1000");  
			ht27.put("ID_WRITE", insert_id);   
			ht27.put("CD_DOCU",  "11");  
			
			ht27.put("DT_ACCT", 	real_date); 
			ht27.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht27.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			ht27.put("CD_ACCT",   	"25300");  //�����ޱ�
			ht27.put("AMT",    	String.valueOf( opt_ip_amt ) );						
			ht27.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht27.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
										
			ht27.put("DT_START",  "");  	//�߻�����										 
			ht27.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht27.put("CD_DEPT",		"");   //�μ�								 
			ht27.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht27.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht27.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht27.put("CD_EMPLOY",		"");   //���									 		 
			ht27.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht27.put("CD_BANK",		"");  //�������	
			ht27.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht27.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht27.put("AM_ADDTAX",	"" );	 //����
			ht27.put("TP_TAX",	"");  //����(����) :11
			ht27.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht27.put("NM_NOTE", doc_cont);  // ����	
									
			vt_auto.add(ht27);  // ȯ�ұ�
	  }		
   
   } else {
	  if ( opt_ip_amt > 0 ) {  //������
	   	
	 	    doc_cont = "���Կɼ� �������Դ��" + "-" + car_no + " " + firm_nm;
		
			line++;
				 				   		
	   		Hashtable ht24 = new Hashtable();
	   		
	   		ht24.put("WRITE_DATE", 	real_date); //row_id							
			ht24.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht24.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht24.put("CD_PC",  	node_code);  //ȸ�����
			ht24.put("CD_WDEPT",  dept_code);  //�μ�
			ht24.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht24.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht24.put("CD_COMPANY",  "1000");  
			ht24.put("ID_WRITE", insert_id);   
			ht24.put("CD_DOCU",  "11");  
			
			ht24.put("DT_ACCT", 	real_date); 
			ht24.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht24.put("TP_DRCR",   "2");   // �뺯:2 , ����:1
			ht24.put("CD_ACCT",   		"93000");  //������
			ht24.put("AMT",    		String.valueOf( opt_ip_amt ) );					
			ht24.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht24.put("CD_PARTNER",	"000131");//�ŷ�ó    - A06
										
			ht24.put("DT_START",  "");  	//�߻�����										 
			ht24.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht24.put("CD_DEPT",		"");   //�μ�								 
			ht24.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht24.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht24.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht24.put("CD_EMPLOY",		"");   //���									 		 
			ht24.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht24.put("CD_BANK",		"");  //�������	
			ht24.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht24.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht24.put("AM_ADDTAX",	"" );	 //����
			ht24.put("TP_TAX",	"");  //����(����) :11
			ht24.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht24.put("NM_NOTE", doc_cont);  // ����	
							
			vt_auto.add(ht24);  // �������
	  } 		
	  
	   if ( opt_ip_amt < 0 ) {  //��ս�
	 	 			
			doc_cont = "���Կɼ� �������Դ��" + "-" + car_no + " " + firm_nm;
				
			line++;
				 				   		
	   		Hashtable ht25 = new Hashtable();
	   		
	   		ht25.put("WRITE_DATE", 	real_date); //row_id							
			ht25.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht25.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
			ht25.put("CD_PC",  	node_code);  //ȸ�����
			ht25.put("CD_WDEPT",  dept_code);  //�μ�
			ht25.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht25.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht25.put("CD_COMPANY",  "1000");  
			ht25.put("ID_WRITE", insert_id);   
			ht25.put("CD_DOCU",  "11");  
			
			ht25.put("DT_ACCT", 	real_date); 
			ht25.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht25.put("TP_DRCR",   "1");   // �뺯:2 , ����:1
			ht25.put("CD_ACCT",   	"96000");  //��ս�
			ht25.put("AMT",    		String.valueOf( opt_ip_amt*(-1) ) );	;					
			ht25.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht25.put("CD_PARTNER",	"000131");//�ŷ�ó    - A06
										
			ht25.put("DT_START",  "");  	//�߻�����										 
			ht25.put("CD_BIZAREA",		"");   //�ͼӻ����	
			ht25.put("CD_DEPT",		"");   //�μ�								 
			ht25.put("CD_CC",			"");   //�ڽ�Ʈ����		
			ht25.put("CD_PJT",			"");   //������Ʈ�ڵ�		
			ht25.put("CD_CARD",		"");   //�ſ�ī��		 	
			ht25.put("CD_EMPLOY",		"");   //���									 		 
			ht25.put("NO_DEPOSIT",	"");  //�����ݰ���
			ht25.put("CD_BANK",		"");  //�������	
			ht25.put("NO_ITEM",		"");  //item	  	 
			
				// �ΰ�������
			ht25.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
			ht25.put("AM_ADDTAX",	"" );	 //����
			ht25.put("TP_TAX",	"");  //����(����) :11
			ht25.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ
					
			ht25.put("NM_NOTE", doc_cont);  // ����	
										
			vt_auto.add(ht25);  // �������
	  } 			
  }
	
  if ( vt_m_auto.size() > 0){
	row_id_t = neoe_db.insertSetAutoDocu(real_date, vt_m_auto);
  }	
    
  if ( vt_auto.size() > 0){
	row_id = neoe_db.insertSetAutoDocu(real_date, vt_auto);
  }
  
      //ȸ��ó�� 
  if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "1")) flag += 1;  

  //���Կɼ� ��ȯ���� ��� scd_ext�� ���
  if ( ext_st.equals("1")  &&  opt_ip_amt > 0 ) {  //���Կɼ� ��ȯ��
  	if(!ac_db.insertScdExtCls8(rent_mng_id, rent_l_cd, opt_ip_amt, real_date,  user_id)) flag += 1;  
  }
   
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
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
