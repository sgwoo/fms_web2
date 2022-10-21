<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.credit.*, acar.client.*, acar.fee.*,  acar.user_mng.*, acar.cls.*,  acar.cont.*, tax.*, acar.bill_mng.*"%>
<%@ page import="acar.asset.*"%>
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
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	String firm_nm = request.getParameter("firm_nm")==null?"":	request.getParameter("firm_nm");
	 	
	int	flag = 0;
	int	count = 0;
	String s_flag = "";
	
	String from_page 	= "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
				
	AssetDatabase ass_db = AssetDatabase.getInstance();
	
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
	
	//���Կɼ� ����� 
	String m_client_id 	= request.getParameter("m_client_id")==null?"":request.getParameter("m_client_id");

	String sui_nm 	= request.getParameter("sui_nm")==null?"":request.getParameter("sui_nm");
	String ssn 	= request.getParameter("ssn")==null?"":request.getParameter("ssn");
	String enp_no 	= request.getParameter("enp_no")==null?"":request.getParameter("enp_no");
//	String bus_cdt 	= request.getParameter("bus_cdt")==null?"":request.getParameter("bus_cdt"); //����
//	String bus_itm 	= request.getParameter("bus_itm")==null?"":request.getParameter("bus_itm"); //����
		
   //��������					
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
	//��������
	cls_st = "8";
	 
	from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	
	//������ �Ա�
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
		//���Կɼ��� (sui)
	String m_sui_dt = request.getParameter("m_sui_dt")==null?"":request.getParameter("m_sui_dt");
		
	String real_date = "";
	
	real_date = cls.getCls_dt();	
	
	
	if ( !m_sui_dt.equals("") ) {
		 real_date = m_sui_dt;	
	} else {
		if ( !opt_ip_dt1.equals("") ) {	    	    	
				if ( !cls.getCls_dt().equals(opt_ip_dt1) ) {
				//   real_date = opt_ip_dt1;
				    real_date = cls.getCls_dt();
				} else {
				   real_date = cls.getCls_dt();
				}		   		
		}		
	}
	
				
	//���:������
	ContBaseBean base 	= a_db.getContBaseAll(rent_mng_id, rent_l_cd);
	client_id = base.getClient_id();
	
	if(base.getTax_type().equals("2")){//����
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
	
	//�뿩����
	ContFeeBean fee = a_db.getContFee(rent_mng_id, rent_l_cd, "1");
	tax_branch = fee.getBr_id()==""?br_id:fee.getBr_id();
	
	//�ŷ�ó����
	ClientBean client = al_db.getNewClient(client_id);
	
	String ven_type = "";
	String s_idno = "";
	
	String client_st = client.getClient_st(); //2:����
	
	String i_ssn = "";
	i_ssn = client.getSsn1() + client.getSsn2();
		
	String i_enp_no = client.getEnp_no1() + client.getEnp_no2()+ client.getEnp_no3();
	if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
		
	String i_addr 		= client.getO_addr();
	String i_sta 		= client.getBus_cdt();
	String i_item 		= client.getBus_itm();
	String i_ven_code	= client.getVen_code(); //��༭���� �ŷ�ó
		
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
	
	//����  ���Կɼ� 
	ClientBean mclient = al_db.getNewClient(m_client_id);
	
	String m_ven_type = "";
	String m_s_idno = "";
	
	String m_client_st = mclient.getClient_st(); //2:����
	
	String foreigner=  mclient.getNationality();
	
	String m_i_ssn = "";
	m_i_ssn = mclient.getSsn1() + mclient.getSsn2();
		
	String m_i_enp_no = mclient.getEnp_no1() + mclient.getEnp_no2()+ mclient.getEnp_no3();
	if(mclient.getEnp_no1().equals("")) m_i_enp_no = mclient.getSsn1() + mclient.getSsn2();
		
	String m_i_addr 		= mclient.getO_addr();
	String m_i_sta 		= mclient.getBus_cdt();
	String m_i_item 		= mclient.getBus_itm();
	String m_i_ven_code	= mclient.getVen_code(); //���Կɼ�
		
	if(m_i_ven_code.equals("")) m_i_ven_code = neoe_db.getVenCode(m_i_ssn, m_i_enp_no);
		
	Hashtable mvendor = neoe_db.getVendorCase(m_i_ven_code);
	
	//�׿��� ���ݰ�꼭
	
	if(m_client_st.equals("2")){
			m_ven_type = "1";
			m_s_idno   =	m_i_ssn;
	}else{
			m_ven_type = "0";
			m_s_idno   =	m_i_enp_no;
	}	
				
	//���ݰ�꼭 ������� - �Ű���꼭 ���� ����
	int sold_cnt = 0;
	
	sold_cnt  = ac_db.getCarSoldCnt(car_mng_id);
//	System.out.println("���Կɼ� ���� ��꼭 ���� - " + sold_cnt);
		
	String tax_no = "";
	int data_no =0;
	String row_id = "";
  	int tax_cnt = 0;
  	
  	int line =0;
	int amt_10800 = 0;
	int jangbu_amt = 0;
	String doc_cont = "";
	
	//�ڻ� �Ű� ���
	s_flag =  ass_db.call_sp_insert_assetmove2_off(real_date.substring(0,4), real_date.substring(5,7), car_mng_id, user_id );
	System.out.println("�ڻ�Ű� ���=" + car_no + "|"+ s_flag);
		
	//�ڻ� ����	   
	Hashtable h_asset = ass_db.getAssetSaleList(car_mng_id);
		
	String  car_use =  String.valueOf(h_asset.get("CAR_USE")) ;   // 1:����, 2:��Ʈ		 
	int  sale_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SALE_AMT")))  ;   //�Ű���		 
	String  assch_date =  String.valueOf(h_asset.get("ASSCH_DATE")) ;   //�Ű���
	    int  get_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GET_AMT")))  ;   //���ʰ�
	    int  book_dr =  AddUtil.parseInt(String.valueOf(h_asset.get("BOOK_DR")))  ;   //����߰�
	    int  jun_reser =  AddUtil.parseInt(String.valueOf(h_asset.get("JUN_RESER")))  ;   //���⴩��󰢾�
	    int  dep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("DEP_AMT")))  ;   //���󰢾�
	    int  gdep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GDEP_AMT")))  ;   //���ź����� 
	    
	    int  sup_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SUP_AMT")))  ;   //���ް�
	    
	    jangbu_amt =    get_amt  + book_dr   - jun_reser - dep_amt - gdep_amt  ;  //��ΰ���  
	       
	    amt_10800 = sale_amt + 	jun_reser + dep_amt  +  gdep_amt - get_amt  - book_dr - ( sale_amt - sup_amt); 		
  	
  	String item_id = "";
  	String reg_code = "";	
//  	String ven_code = "";

	//������ �Ű���꼭�� ������ �ȵȰ�� ó��
        if (     sold_cnt  < 1) {

	    //�ڻ�Ű� ���ݰ�꼭 
	//	tax_no = IssueDb.getTaxNoNext(real_date);
			
		//����� item_id ��������
			
		//[1�ܰ�] �ŷ����� ����Ʈ ����		
		TaxItemListBean til_bean = new TaxItemListBean();			
//		til_bean.setItem_id(item_id);
		til_bean.setItem_seq(1);
		til_bean.setItem_g("�����Ű����");
		til_bean.setItem_car_no(car_no);
		til_bean.setItem_car_nm(car_nm);
		til_bean.setItem_supply(sup_amt);
		til_bean.setItem_value(sale_amt - sup_amt );
		til_bean.setRent_l_cd(rent_l_cd);
		til_bean.setCar_mng_id(car_mng_id);
	 	til_bean.setGubun("6");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
		til_bean.setReg_id(user_id);
	//	til_bean.setReg_code(reg_code);
				
		til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 2:����
		til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			
		//����� item_id ��������
		item_id = IssueDb.getItemIdNext(real_date);
			//	out.println("item_id="+item_id+"<br><br>");
		  		
				//�����ڵ� ��������
		reg_code  = Long.toString(System.currentTimeMillis());
			//	out.println("�����ڵ�="+reg_code+"<br>");
		
		til_bean.setItem_id(item_id);
		til_bean.setReg_code(reg_code);
		
		if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
			    		
		//[2�ܰ�] �ŷ����� ����
		Vector vt = IssueDb.getTaxItemListSusi(reg_code);
		int vt_size = vt.size();
	//	out.println("�ŷ����� ����="+vt_size+"<br><br>");
		
		for(int j=0;j < vt_size;j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
			TaxItemBean ti_bean = new TaxItemBean();
			ti_bean.setClient_id(m_client_id);
			ti_bean.setSeq("");
			ti_bean.setItem_dt(real_date);
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
		
		if (tax_branch.equals("")) tax_branch = br_id;
		
		for(int i=0;i < vt_size2;i++){
			Hashtable ht_t = (Hashtable)vt2.elementAt(i);
					
			tax.TaxBean t_bean = new tax.TaxBean();			
					
			t_bean.setClient_id(m_client_id);  	
			t_bean.setTax_dt(real_date);
			
			t_bean.setUnity_chk("0");//���տ���0=����,1=����
			t_bean.setRent_l_cd(rent_l_cd);
			t_bean.setFee_tm("");
			t_bean.setCar_mng_id(car_mng_id);
			t_bean.setBranch_g(tax_branch);
			t_bean.setTax_g("�����Ű����");
			t_bean.setTax_supply(sup_amt);
			t_bean.setTax_value(sale_amt - sup_amt);
			t_bean.setTax_id(m_client_id);
			t_bean.setItem_id(item_id);
			t_bean.setTax_bigo("�����Ű� - " + car_no );			
			
				//20090701���� ����ڴ�������			
			if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
				//�������
				Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
				t_bean.setTax_bigo(" "+t_bean.getTax_bigo());
	//				t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
				t_bean.setBranch_g("S1");
				t_bean.setBranch_g2(tax_branch);
				t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //���ڼ��ݰ�꼭 �ǹ����� ���� ����
			} 
			
			t_bean.setSeq("");  
		//	t_bean.setTax_no(tax_no);
			t_bean.setCar_no(car_no);
			t_bean.setCar_nm(car_nm);
			t_bean.setTax_st("O");
			t_bean.setTax_type("1");  //������ ����
			t_bean.setReg_id(user_id);
			t_bean.setGubun("6");
			t_bean.setPubForm("R");
			    					
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
			}else {
				t_bean.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
			}						
			
			//--�ܱ���
			 if(foreigner.equals("2") ) {
			      		 t_bean.setReccoregnotype("03");     //�ܱ���
			                    t_bean.setRecCoRegNo("9999999999999");	
			                    t_bean.setTax_bigo(t_bean.getTax_bigo() +" "+  String.valueOf(ht_t.get("RECCOREGNO")) );	       
			  };
			
			  //insert ������ ��갪 ���ϱ�  
			tax_no = IssueDb.getTaxNoNext(real_date);
			t_bean.setTax_no(tax_no);
			 
			if(!IssueDb.insertTax(t_bean)) flag += 1;  
			
			if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1;
		}
		    		
		//���ڼ��ݰ�꼭 ����
		   		
		//����-������
	//	Hashtable br1 = c_db.getBranch("S1");
	//	String resseq = IssueDb.getResSeqNext();
	//	if(!IssueDb.insertSaleEBillCase(resseq, tax_no, String.valueOf(br1.get("BR_ENT_NO")))) flag += 1;
	
		String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
		if (d_flag1.equals("1"))		flag += 1;
		
	}
	
	
	//�ڵ���ǥó����
	Vector vt_auto = new Vector();

 //-----------------������ �ݾ� ���� ------------------------	
	
	int opt_ip_amt = 0;
	
//	opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  -  AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
  		
	  
 	//������ - ���ԿɼǱݾ� 	

	doc_cont = "���Կɼ� ������" + "-" + car_no + " " + firm_nm;
 		
	line++;
				
	Hashtable ht2_1 = new Hashtable();
		
	ht2_1.put("WRITE_DATE", 	real_date);//row_id	
	ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
	ht2_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
	ht2_1.put("CD_PC",  	node_code);  //ȸ�����*
	ht2_1.put("CD_WDEPT",  dept_code);  //�μ�
	ht2_1.put("NO_DOCU",  	"");  //row_id�� ����
	ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht2_1.put("CD_COMPANY",  "1000");  
	ht2_1.put("ID_WRITE", insert_id);   
	ht2_1.put("CD_DOCU",  "11");  
	
	ht2_1.put("DT_ACCT",real_date); 
	ht2_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht2_1.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
	ht2_1.put("CD_ACCT",  "25900");   //������
	ht2_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("opt_amt")) ));									
	ht2_1.put("TP_GUBUN",	"3");  //1:�Ա� 2:��� 3:��ü	
	ht2_1.put("CD_PARTNER",	i_ven_code); //�ŷ�ó    - A06
		
	ht2_1.put("DT_START", real_date) ;  	//�߻�����			
	ht2_1.put("CD_BIZAREA",	"");   //�ͼӻ����	
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
	
	vt_auto.add(ht2_1);  
	 
   //-----------------�ڻ� �� ���� ------------------------
   		  
 // ���� / �뿩�������
 
	if (cls_st.equals("1") ) {
		 doc_cont = "��ุ�� - " + car_no + " " + firm_nm;
	} else if (cls_st.equals("8") ) {
		 doc_cont = "���Կɼ� - " + car_no + " " + firm_nm;
	} else {
		 doc_cont = "�ߵ����� - " + car_no + " " + firm_nm;
	} 
	
	line++;
	
	Hashtable ht3 = new Hashtable();
	
	ht3.put("WRITE_DATE", 		real_date);//row_id				
	ht3.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
	ht3.put("CD_PC",  	node_code);  //ȸ�����
	ht3.put("CD_WDEPT",  dept_code);  //�μ�
	ht3.put("NO_DOCU",  	"");  //�̰��� '0' 
	ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht3.put("CD_COMPANY",  "1000");  
	ht3.put("ID_WRITE", insert_id);   
	ht3.put("CD_DOCU",  "11");  
	
	ht3.put("DT_ACCT", 	real_date);
	ht3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht3.put("TP_DRCR",   "2");   // �뺯:2 , ����:1	
	
	if ( car_use.equals("2") ) { //��Ʈ�̸�
		ht3.put("CD_ACCT",  	"21700");    //�뿩�������
	} else {
		ht3.put("CD_ACCT",  	"21900");  //�����������
	}	
	
	ht3.put("AMT",   	String.valueOf( get_amt + book_dr )); //���ʰ���	
	ht3.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	ht3.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
							
	ht3.put("DT_START",  "");  	//�߻�����										 
	ht3.put("CD_BIZAREA",		"");   //�ͼӻ����	
	ht3.put("CD_DEPT",		"");   //�μ�								 
	ht3.put("CD_CC",			"");   //�ڽ�Ʈ����		
	ht3.put("CD_PJT",			"");   //������Ʈ�ڵ�		
	ht3.put("CD_CARD",		"");   //�ſ�ī��		 	
	ht3.put("CD_EMPLOY",		"");   //���									 		 
	ht3.put("NO_DEPOSIT",	"");  //�����ݰ���
	ht3.put("CD_BANK",		"");  //�������	
	ht3.put("NO_ITEM",		"");  //item	  
	
			// �ΰ�������
	ht3.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
	ht3.put("AM_ADDTAX",	"" );	 //����
	ht3.put("TP_TAX",	"");  //����(����) :11
	ht3.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	  	 

	ht3.put("NM_NOTE", doc_cont);  // ����				
	
	vt_auto.add(ht3);  // �뿩/������� ����
 
  //�ΰ��� ������
		
	line++;
	
	Hashtable ht4 = new Hashtable();
	
	ht4.put("WRITE_DATE", 	real_date); //row_id							
	ht4.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht4.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
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
	ht4.put("CD_ACCT",  	"25500");  //�ΰ���������					
	ht4.put("AMT",   	String.valueOf( sale_amt - sup_amt) );							
	ht4.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	ht4.put("CD_PARTNER",	m_i_ven_code);  //���� ���Կɼ� �ŷ�ó
								
	ht4.put("DT_START", real_date);  	//�߻����� - �ΰ���										 
	ht4.put("CD_BIZAREA",		"S101");   //�ͼӻ����	
	ht4.put("CD_DEPT",		"");   //�μ�								 
	ht4.put("CD_CC",			"");   //�ڽ�Ʈ����		
	ht4.put("CD_PJT",			"");   //������Ʈ�ڵ�		
	ht4.put("CD_CARD",		"");   //�ſ�ī��		 	
	ht4.put("CD_EMPLOY",		"");   //���									 		 
	ht4.put("NO_DEPOSIT",	"");  //�����ݰ���
	ht4.put("CD_BANK",		"");  //�������	
	ht4.put("NO_ITEM",		"");  //item	 	  	 
		
// �ΰ�������
	ht4.put("AM_TAXSTD",		String.valueOf(sup_amt));
	ht4.put("AM_ADDTAX",	 	String.valueOf(sale_amt - sup_amt) );	 //�Ű��� - ���ް�
	ht4.put("TP_TAX",	"11");  //����(����) :11
	if(m_ven_type.equals("1")){
		ht4.put("NO_COMPANY",   "8888888888"); //������ ��� ����ڵ�Ϲ�ȣ�� 8888888888
	} else {
		ht4.put("NO_COMPANY",   m_s_idno); //����ڵ�Ϲ�ȣ
	}								
	ht4.put("NM_NOTE", doc_cont);  // ����	
							
	vt_auto.add(ht4);  // �ΰ���	
 	 	 
 	// ������ ����� - ����/ �뿩�������
 	if (cls_st.equals("1") ) {
		 doc_cont = "��ุ�� �����󰢴����- " + car_no + " " + firm_nm;
	} else if (cls_st.equals("8") ) {
		 doc_cont = "���Կɼ� �����󰢴���� - " + car_no + " " + firm_nm;
	} else {
		 doc_cont = "�ߵ����� �����󰢴���� - " + car_no + " " + firm_nm;
	} 
	
	line++;
	
	Hashtable ht6 = new Hashtable();
	
	ht6.put("WRITE_DATE", 		real_date);//row_id				
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
	ht6.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
	
	if ( car_use.equals("2") ) { //��Ʈ�̸�
		ht6.put("CD_ACCT",  	"21800");    //�뿩������� ������ �����
	} else {
		ht6.put("CD_ACCT",  	"22000");  //����������� ������ �����
	}	
	
	ht6.put("AMT",   String.valueOf( jun_reser + dep_amt ));
	ht6.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	ht6.put("CD_PARTNER",	""); //�ŷ�ó    - A06
							
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
				
	vt_auto.add(ht6);  // ������ �����
 
   //������������ �ִ� ��� - ģȯ���������ؼ�
   
   	if ( gdep_amt  > 0 ) {
    	 
    		// ģȯ���� ������  - ����/ �뿩�������
	 	if (cls_st.equals("1") ) {
			 doc_cont = "��ุ�� ģȯ���������� - " + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "���Կɼ� ģȯ���������� - " + car_no + " " + firm_nm;
		} else {
			 doc_cont = "�ߵ����� ģȯ���������� - " + car_no + " " + firm_nm;
		} 
	 
	 	line++;
		
		Hashtable ht6_1 = new Hashtable();
		
		ht6_1.put("WRITE_DATE", 		real_date);//row_id				
		ht6_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht6_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht6_1.put("CD_PC",  	node_code);  //ȸ�����
		ht6_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht6_1.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht6_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht6_1.put("CD_COMPANY",  "1000");  
		ht6_1.put("ID_WRITE", insert_id);   
		ht6_1.put("CD_DOCU",  "11");  
		
		ht6_1.put("DT_ACCT", 	real_date);
		ht6_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht6_1.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
		
	//	ht6_1.put("CD_ACCT",  	"21810");    //�뿩������� ���������� 
		//	 ����� ��Ʈ�ۿ� ��� ������ �ϳ� - 20170112 
		if ( car_use.equals("2") ) { //��Ʈ�̸�
			ht6_1.put("CD_ACCT",  	"21810");    //�뿩������� ���������� 
		} else {
			ht6_1.put("CD_ACCT",  	"22010");  //����������� ������ �����
		}	
			
		ht6_1.put("AMT",   String.valueOf( gdep_amt ));
		ht6_1.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	    ht6_1.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
								
		ht6_1.put("DT_START",  "");  	//�߻�����										 
		ht6_1.put("CD_BIZAREA",		"");   //�ͼӻ����	
		ht6_1.put("CD_DEPT",		"");   //�μ�								 
		ht6_1.put("CD_CC",			"");   //�ڽ�Ʈ����		
		ht6_1.put("CD_PJT",			"");   //������Ʈ�ڵ�		
		ht6_1.put("CD_CARD",		"");   //�ſ�ī��		 	
		ht6_1.put("CD_EMPLOY",		"");   //���									 		 
		ht6_1.put("NO_DEPOSIT",	"");  //�����ݰ���
		ht6_1.put("CD_BANK",		"");  //�������	
		ht6_1.put("NO_ITEM",		"");  //item	  
		
				// �ΰ�������
		ht6_1.put("AM_TAXSTD",	"");  //����ǥ�ؾ�
		ht6_1.put("AM_ADDTAX",	"" );	 //����
		ht6_1.put("TP_TAX",	"");  //����(����) :11
		ht6_1.put("NO_COMPANY",	""); //����ڵ�Ϲ�ȣ	  	 
	
		ht6_1.put("NM_NOTE", doc_cont);  // ����				
					
		vt_auto.add(ht6_1);  // ���������� 
	
	}
  
  	 	//ó������ 	
  /*
   	if ( amt_10800  > 0 ) {
	 // �뿩/�������� ó������  
	 	if (cls_st.equals("1") ) {
			 doc_cont = "��ุ�� ó������ - " + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "���Կɼ� ó������ - " + car_no + " " + firm_nm;
		} else {
			 doc_cont = "�ߵ����� ó������ - " + car_no + " " + firm_nm;
		} 
		
		line++;
		
		Hashtable ht7 = new Hashtable();
							
		ht7.put("WRITE_DATE", 		real_date);//row_id				
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
		ht7.put("TP_DRCR",   "2");   // �뺯:2 , ����:1	
		
		if ( car_use.equals("2") ) { //��Ʈ�̸�
			ht7.put("CD_ACCT",  	"41300");    //�뿩������� ó������
		} else {
			ht7.put("CD_ACCT",  	"41500");  //����������� ó������
		}	
		
		ht7.put("AMT",   String.valueOf( amt_10800 ));		 	
		ht7.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht7.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
								
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
		
		vt_auto.add(ht7);  // ó������ / �ս�
  }
 
  	 //ó�мս� 	
   	if ( amt_10800 < 0 ) {
	 // �뿩/�������� �ս�
	 	if (cls_st.equals("1") ) {
			 doc_cont = "��ุ�� ó�мս� - " + car_no + " " + firm_nm;
		} else if (cls_st.equals("8") ) {
			 doc_cont = "���Կɼ� ó�мս� - " + car_no + " " + firm_nm;
		} else {
			 doc_cont = "�ߵ����� ó�мս� - " + car_no + " " + firm_nm;
		} 
		
		line++;
		
		Hashtable ht8 = new Hashtable();
						
		ht8.put("WRITE_DATE", 		real_date);//row_id				
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
		ht8.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
		
		if (car_use.equals("2") ) { //��Ʈ�̸�
			ht8.put("CD_ACCT",  	"45300");   //�뿩������� ó�мս�
		} else {
			ht8.put("CD_ACCT",  	"45400");  //����������� ó�мս�
		}	
		
		ht8.put("AMT",      String.valueOf( amt_10800 * (-1) ));	
		ht8.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
		ht8.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
								
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
						
		vt_auto.add(ht8);  // ó������ / �ս�
  }  
  */
  
        // �뿩/��������  �Ű���   
	line++;
	 doc_cont = "���Կɼ� ó�м���  - " + car_no + " " + firm_nm;
		 
	Hashtable ht7 = new Hashtable();
	
	ht7.put("WRITE_DATE", 		real_date);//row_id				
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
	ht7.put("TP_DRCR",   "2");   // �뺯:2 , ����:1	
	
	if (car_use.equals("2") ) { //��Ʈ�̸�
		ht7.put("CD_ACCT",  	"41310");    //�뿩�������
	} else {
		ht7.put("CD_ACCT",  	"41510");  //�����������
	}	
	
	ht7.put("AMT",   String.valueOf( sup_amt ));		 	//�����   
	ht7.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	ht7.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
							
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
		
	vt_auto.add(ht7);  // ����� 
	
		
	// ��ΰ�
	line++;
	 doc_cont = "���Կɼ� ó�п���  - " + car_no + " " + firm_nm;
	
	Hashtable ht8 = new Hashtable();
		
	ht8.put("WRITE_DATE", 		real_date);//row_id				
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
	ht8.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
	
	if (car_use.equals("2") ) { //��Ʈ�̸�
		ht8.put("CD_ACCT",  	"45310");    //�뿩�������
	} else {
		ht8.put("CD_ACCT",  	"45410");  //�����������
	}	
		
	ht8.put("AMT",   String.valueOf( jangbu_amt ));		
	ht8.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
	ht8.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
							
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
			
	vt_auto.add(ht8);  // ó������ / �ս�
	
  if ( vt_auto.size() > 0){
	row_id = neoe_db.insertSetAutoDocu(real_date, vt_auto);
  }
      
    //ȸ��ó�� 
  if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "Y")) flag += 1;  
  
  // cls_cont cls_dt�� ���Կɼ��Ϸ� ����
  
     //ȸ��ó�� 
  if(!ac_db.updateClsContDt(rent_mng_id, rent_l_cd, real_date )) flag += 1;  

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
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
