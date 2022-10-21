<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*, acar.common.*, acar.bill_mng.*,  acar.client.*, tax.*,   acar.user_mng.*"%>
<jsp:useBean id="su_bean" class="acar.offls_actn.Offls_sui_etcBean" scope="page"/>
<jsp:useBean id="bean" class="acar.asset.AssetMoveBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");	
	
	String assch_date= request.getParameter("assch_date")==null?"":request.getParameter("assch_date");
	String assch_type= request.getParameter("assch_type")==null?"":request.getParameter("assch_type");
	String assch_rmk= request.getParameter("assch_rmk")==null?"":request.getParameter("assch_rmk");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String bill_doc_yn 	= request.getParameter("bill_doc_yn")==null?"":request.getParameter("bill_doc_yn");
			
	int s_cnt = 0;
	String s_flag = "";
	int	flag2 = 0;
	int	flag3 = 0;

	AssetDatabase as_db = AssetDatabase.getInstance();
	
	//��ǥ����
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
					
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	String reg_ym = AddUtil.getDate(5);
	
	//�׿���
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
		
	bean.setAsset_code	(asset_code);
	bean.setAssch_date	(assch_date);
	bean.setAssch_type	(assch_type);
	bean.setAssch_rmk	(assch_rmk);
	bean.setCap_amt	(0);//
	bean.setSale_quant	(1); //
	bean.setSale_amt	(request.getParameter("sale_amt")==null?0:AddUtil.parseDigit(request.getParameter("sale_amt"))); //�Ű�/��� �ݾ�
	bean.setSh_car_amt	(request.getParameter("sh_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("sh_car_amt"))); //�Ű�/���� �ܰ�
	bean.setS_sup_amt	(request.getParameter("s_sup_amt")==null?0:AddUtil.parseDigit(request.getParameter("s_sup_amt"))); //�Ű�/���ð��ް�
	bean.setClient_id2	(client_id); //���޹޴��� 
				
	s_cnt = as_db.insertAssetMove(bean);
	System.out.println("�Ű�����=" + s_cnt); 
		
	// �Ű�/����� ���  �Ű�/��� ó�� 
	if (assch_type.equals("3")) { 
	
	 	 s_flag =  as_db.call_sp_insert_assetmove1(asset_code, s_cnt, user_id );
		 System.out.println(asset_code + "|" + assch_date + "|" + assch_type  ); 
		 
		//�����ΰ�� ����� ���� ����	- �������� ��Ͽ��� Ʋ����   assch_date.substr(0,6) 
		 if ( assch_rmk.equals("����") && !assch_date.substring(0,6).equals(reg_ym) ) {
			 flag3 = as_db.updateAssetMove(asset_code);
		 }	
	} 
	
	//�ڵ���ǥó����
	Vector vt_auto = new Vector();
	
	int opt_ip_amt = 0;
	int line =0;
	String doc_cont = "";
	int amt_10800 = 0;

	String tax_no = "";
	String row_id = "";	
	String ven_code2 = "";
	String client_st = "";
	
	String ven_type = "";
	String s_idno = "";
	
	AssetMaBean ass_bean =  as_db.getAssetMa(asset_code);
	
	String car_mng_id = ass_bean.getCar_mng_id();
	
	//�ڻ� ����	   
	Hashtable h_asset = as_db.getAssetSaleList(car_mng_id);
		
	String  car_use =  String.valueOf(h_asset.get("CAR_USE")) ;   // 1:����, 2:��Ʈ		 		 
	int  sale_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SALE_AMT")))  ;   //�Ű���		 
	int  get_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GET_AMT")))  ;   //���ʰ�
	int  book_dr =  AddUtil.parseInt(String.valueOf(h_asset.get("BOOK_DR")))  ;   //����߰�
	int  jun_reser =  AddUtil.parseInt(String.valueOf(h_asset.get("JUN_RESER")))  ;   //���⴩��󰢾�
	int  dep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("DEP_AMT")))  ;   //���󰢾�
	int  gdep_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("GDEP_AMT")))  ;   //���������� 
	int  sup_amt =  AddUtil.parseInt(String.valueOf(h_asset.get("SUP_AMT")))  ;   //���ް� (������ �ΰ����� ����.)
   int jangbu_amt = 0;
   
	if ( !client_id.equals("") && bill_doc_yn.equals("1")  ) {	    
	 	amt_10800 = sale_amt + 	jun_reser + dep_amt + gdep_amt  - get_amt  - book_dr - ( sale_amt - sup_amt); 		
 	} else {
 	      amt_10800 = sale_amt + jun_reser + dep_amt  + gdep_amt - get_amt  - book_dr ; 	      	
 	}
 	
   jangbu_amt = 	get_amt  +  book_dr - jun_reser - dep_amt  - gdep_amt;
         
	if ( !client_id.equals("") && bill_doc_yn.equals("1")  ) {
	//�ڵ����ŸŻ�
		ClientBean client = al_db.getNewClient(client_id);
					
		 su_bean  = as_db.getInfoSale1(car_mng_id);
		 		 
		 client_st = client.getClient_st(); //2:����
		 ven_code2 = client.getVen_code(); //�ŸŻ�
		
		String i_ssn = "";
		i_ssn = client.getSsn1() + client.getSsn2();
		
		String i_enp_no = client.getEnp_no1() + client.getEnp_no2()+ client.getEnp_no3();
		if(client.getEnp_no1().equals("")) i_enp_no = client.getSsn1() + client.getSsn2();
		
		if(ven_code2.equals("")){
			if(client_st.equals("2"))	ven_code2 = neoe_db.getVenCode(i_ssn,i_enp_no);
			if(!client_st.equals("2"))	ven_code2 = neoe_db.getVenCode2(i_ssn,i_enp_no);
		}
		
		if(client_st.equals("2")){
			ven_type = "1";  //�ֹι�ȣ
			s_idno   =	i_ssn;
		}else{
			ven_type = "0";  //�����
			s_idno   =	i_enp_no;
		}
				
		  	
	  	String item_id = "";
	  	String reg_code = "";	
	  	
	  	String tax_supply = "";
		String tax_value = "";
		String tax_branch 	= "";	
	
	    //�ڻ�Ű� ���ݰ�꼭 
		tax_no = IssueDb.getTaxNoNext(assch_date);
	
		//����� item_id ��������
		item_id = IssueDb.getItemIdNext(assch_date);
	//	out.println("item_id="+item_id+"<br><br>");
	    		
		//�����ڵ� ��������
		reg_code  = Long.toString(System.currentTimeMillis());
	//	out.println("�����ڵ�="+reg_code+"<br>");
	
		//[1�ܰ�] �ŷ����� ����Ʈ ����		
		TaxItemListBean til_bean = new TaxItemListBean();			
		til_bean.setItem_id(item_id);
		til_bean.setItem_seq(1);
		til_bean.setItem_g("�����������");
		til_bean.setItem_car_no(su_bean.getCar_no());
		til_bean.setItem_car_nm(su_bean.getCar_nm());
		til_bean.setItem_supply(sup_amt);
		til_bean.setItem_value(sale_amt - sup_amt );
		til_bean.setRent_l_cd("");
		til_bean.setCar_mng_id(car_mng_id);
	 	til_bean.setGubun("6");   //��������� ���õ� �� :gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 �����, 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 15:��������
		til_bean.setReg_id(user_id);
		til_bean.setReg_code(reg_code);				
		til_bean.setCar_use(""); //���ڼ��ݰ�꼭 �ǹ����� ���� ����  
		til_bean.setItem_dt(assch_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
				
		if(!IssueDb.insertTaxItemList(til_bean)) flag2 += 1;
			    		
		//[2�ܰ�] �ŷ����� ����
		Vector vt = IssueDb.getTaxItemListSusi(reg_code);
		int vt_size = vt.size();
	//	out.println("�ŷ����� ����="+vt_size+"<br><br>");
		
		for(int j=0;j < vt_size;j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
			TaxItemBean ti_bean = new TaxItemBean();
			ti_bean.setClient_id(su_bean.getClient_id());
			ti_bean.setSeq("");
			ti_bean.setItem_dt(assch_date);
			ti_bean.setTax_id("");
			ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
			ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"��");
			ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
			ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
			
			if(!IssueDb.insertTaxItem(ti_bean)) flag2 += 1;
		}

		//[3�ܰ�] ���ݰ�꼭 ����		
		Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
				    	
		int vt_size2 = vt2.size();
	//	out.println("���ݰ�꼭 ����="+vt_size2+"<br><br>");
		
		if (tax_branch.equals("")) tax_branch = br_id;
		
		for(int i=0;i < vt_size2;i++){
			Hashtable ht_t = (Hashtable)vt2.elementAt(i);
					
			tax.TaxBean t_bean = new tax.TaxBean();			
					
			t_bean.setClient_id(su_bean.getClient_id());  	
			t_bean.setTax_dt(assch_date);
			
			t_bean.setUnity_chk("0");//���տ���0=����,1=����
			t_bean.setRent_l_cd("");
			t_bean.setFee_tm("");
			t_bean.setCar_mng_id(car_mng_id);
			t_bean.setBranch_g(tax_branch);
			t_bean.setTax_g("�����������");
			t_bean.setTax_supply(sup_amt);
			t_bean.setTax_value(sale_amt - sup_amt);
			t_bean.setTax_id(su_bean.getClient_id());
			t_bean.setItem_id(item_id);
			t_bean.setTax_bigo("�������� - " + su_bean.getCar_no() );			
			
				//20090701���� ����ڴ�������			
			if(!t_bean.getBranch_g().equals("S1") && AddUtil.parseInt(AddUtil.replace(t_bean.getTax_dt(),"-","")) > 20090631){
				//�������
				Hashtable br2 = c_db.getBranch(t_bean.getBranch_g());
				t_bean.setTax_bigo(String.valueOf(br2.get("BR_NM"))+" "+t_bean.getTax_bigo());
				t_bean.setBranch_g("S1");
				t_bean.setBranch_g2(tax_branch);
				t_bean.setTaxregno(String.valueOf(br2.get("TAXREGNO")));	 //���ڼ��ݰ�꼭 �ǹ����� ���� ����
			} 
			
			t_bean.setSeq("");  
			t_bean.setTax_no(tax_no);
			t_bean.setCar_no(su_bean.getCar_no());
			t_bean.setCar_nm(su_bean.getCar_nm());
			t_bean.setTax_st("O");
			t_bean.setTax_type("1");  //������ ����
			t_bean.setReg_id(user_id);
			t_bean.setGubun("6");
			    					
			//���޹޴������� : 20090608 �۾�
			t_bean.setRecTel			(String.valueOf(ht_t.get("RECTEL")));
			t_bean.setRecCoRegNo		(String.valueOf(ht_t.get("RECCOREGNO")));
			t_bean.setRecCoName			(String.valueOf(ht_t.get("RECCONAME2")));
			t_bean.setRecCoCeo			(String.valueOf(ht_t.get("RECCOCEO2")));
			t_bean.setRecCoAddr			(String.valueOf(ht_t.get("RECCOADDR")));
			t_bean.setRecCoBizType		(String.valueOf(ht_t.get("RECCOBIZTYPE2")));
			t_bean.setRecCoBizSub		(String.valueOf(ht_t.get("RECCOBIZSUB2"))); 
							
			//���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			//���޹޴��ڰ� �����϶��� ������ ����� ó��
			if(String.valueOf(ht_t.get("RECCOREGNO")).length() == 13){
				t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht_t.get("RECCOREGNO")));
				t_bean.setRecCoSsn	(String.valueOf(ht_t.get("RECCOREGNO")));
				t_bean.setReccoregnotype("02");//����ڱ���-�ֹε�Ϲ�ȣ
			}else {
				t_bean.setReccoregnotype("01");//����ڱ���-����ڵ�Ϲ�ȣ
			}						
			
			if(!IssueDb.insertTax(t_bean)) flag2 += 1;  
			
			if(!IssueDb.updateTaxAutodocu(tax_no)) flag2 += 1;
		}
	    		
		//���ڼ��ݰ�꼭 ����	
		String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
		if (d_flag1.equals("1"))		flag2 += 1;
	
	} //��꼭 ������̸�
		    	
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
//	String node_code = String.valueOf(per.get("NODE_CODE"));
	String node_code ="S101";  //�׿��� iu ������ ȸ�����:S101	
			
	 //-----------------������ �ݾ� ���� ------------------------	
		  
 	//���� 	
	doc_cont = "����" + "-" + car_no  ;
 		
	line++;
				
	Hashtable ht2_1 = new Hashtable();
	
	ht2_1.put("WRITE_DATE", 	assch_date);//row_id	
	ht2_1.put("ROW_NO",  	String.valueOf(line)); //row_no		
	ht2_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� * ,  no_docu || no_doline
	ht2_1.put("CD_PC",  	node_code);  //ȸ�����*
	ht2_1.put("CD_WDEPT",  dept_code);  //�μ�
	ht2_1.put("NO_DOCU",  	"");  //row_id�� ����
	ht2_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht2_1.put("CD_COMPANY",  "1000");  
	ht2_1.put("ID_WRITE", insert_id);   
	ht2_1.put("CD_DOCU",  "11");  
	
	ht2_1.put("DT_ACCT",assch_date); 
	ht2_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht2_1.put("TP_DRCR",  "1");   // �뺯:2 , ����:1
	ht2_1.put("CD_ACCT",  "25900");   //������
	ht2_1.put("AMT",    	String.valueOf( AddUtil.parseDigit(request.getParameter("sale_amt")) ));										
	ht2_1.put("TP_GUBUN",	"3");  //1:�Ա� 2:��� 3:��ü	
	ht2_1.put("CD_PARTNER",	"000131"); //�ŷ�ó    - A06
		
	ht2_1.put("DT_START", assch_date) ;  	//�߻�����			
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
	line++;
	
	Hashtable ht3 = new Hashtable();
		
	ht3.put("WRITE_DATE", 		assch_date);//row_id				
	ht3.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht3.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
	ht3.put("CD_PC",  	node_code);  //ȸ�����
	ht3.put("CD_WDEPT",  dept_code);  //�μ�
	ht3.put("NO_DOCU",  	"");  //�̰��� '0' 
	ht3.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht3.put("CD_COMPANY",  "1000");  
	ht3.put("ID_WRITE", insert_id);   
	ht3.put("CD_DOCU",  "11");  
	
	ht3.put("DT_ACCT", 	assch_date);
	ht3.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht3.put("TP_DRCR",   "2");   // �뺯:2 , ����:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //��Ʈ�̸�
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
	
	//���� ��꼭 ������ ���
	if ( !client_id.equals("") && bill_doc_yn.equals("1")  ) { 
	
			line++;
		
			Hashtable ht8_2 = new Hashtable();
				
			ht8_2.put("WRITE_DATE", 	assch_date); //row_id							
			ht8_2.put("ROW_NO",  	String.valueOf(line)); //row_no							
			ht8_2.put("NO_TAX",  	"");  //�ΰ��� �ܴ̿� * row_id || row_no
			ht8_2.put("CD_PC",  	node_code);  //ȸ�����
			ht8_2.put("CD_WDEPT",  dept_code);  //�μ�
			ht8_2.put("NO_DOCU",  	"");  //�̰��� '0' 
			ht8_2.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
			ht8_2.put("CD_COMPANY",  "1000");  
			ht8_2.put("ID_WRITE", insert_id);   
			ht8_2.put("CD_DOCU",  "11");  
			
			ht8_2.put("DT_ACCT", 	assch_date); 
			ht8_2.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
			ht8_2.put("TP_DRCR",   "2");   // �뺯:2 , ����:1			
			ht8_2.put("CD_ACCT",  		"25500");  //�ΰ���������					
			ht8_2.put("AMT",   		String.valueOf( sale_amt - sup_amt ) );								
			ht8_2.put("TP_GUBUN", "3");  //1:�Ա� 2:��� 3:��ü							
			ht8_2.put("CD_PARTNER",	ven_code2); //�ŷ�ó    - A06
										
			ht8_2.put("DT_START", assch_date);  	//�߻����� - �ΰ���										 
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
			ht8_2.put("AM_TAXSTD",	  String.valueOf( sup_amt) );		 //����ǥ�ؾ�
			ht8_2.put("AM_ADDTAX",	String.valueOf( sale_amt - sup_amt ) );			 //����
			ht8_2.put("TP_TAX",	"11");  //����(����) :11
			if(ven_type.equals("1")){ //����
				ht8_2.put("NO_COMPANY",	"8888888888"); //����ڵ�Ϲ�ȣ
			} else {
				ht8_2.put("NO_COMPANY",	s_idno); //����ڵ�Ϲ�ȣ
			}								
			ht8_2.put("NM_NOTE", doc_cont);  // ����	
						
			vt_auto.add(ht8_2);  // �ΰ���				  
			  
	}		  
      	 	 
 	// ������ ����� - ����/ �뿩������� 	 	
	line++;
	
	Hashtable ht6 = new Hashtable();
	
	ht6.put("WRITE_DATE", 		assch_date);//row_id				
	ht6.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht6.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
	ht6.put("CD_PC",  	node_code);  //ȸ�����
	ht6.put("CD_WDEPT",  dept_code);  //�μ�
	ht6.put("NO_DOCU",  	"");  //�̰��� '0' 
	ht6.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht6.put("CD_COMPANY",  "1000");  
	ht6.put("ID_WRITE", insert_id);   
	ht6.put("CD_DOCU",  "11");  
	
	ht6.put("DT_ACCT", 	assch_date);
	ht6.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht6.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //��Ʈ�̸�
		ht6.put("CD_ACCT",  	"21800");    //�뿩�������
	} else {
		ht6.put("CD_ACCT",  	"22000");  //�����������
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
      	 
	 	line++;
		
		Hashtable ht6_1 = new Hashtable();
					
		ht6_1.put("WRITE_DATE", 		assch_date);//row_id				
		ht6_1.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht6_1.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht6_1.put("CD_PC",  	node_code);  //ȸ�����
		ht6_1.put("CD_WDEPT",  dept_code);  //�μ�
		ht6_1.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht6_1.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht6_1.put("CD_COMPANY",  "1000");  
		ht6_1.put("ID_WRITE", insert_id);   
		ht6_1.put("CD_DOCU",  "11");  
	
			
		ht6_1.put("DT_ACCT", 	assch_date);
		ht6_1.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht6_1.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
		
		ht6_1.put("CD_ACCT",  	"21810");    //�뿩������� ���������� 
		
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
	  
         //2016�� ȸ��ó�� ���� 
            
 	 	//ó������ 	
/* 	 	
   	if ( amt_10800  > 0 ) {
   	
	 // �뿩/�������� ó������  
		line++;
		
		Hashtable ht7 = new Hashtable();
			
		ht7.put("WRITE_DATE", 		assch_date);//row_id				
		ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht7.put("CD_PC",  	node_code);  //ȸ�����
		ht7.put("CD_WDEPT",  dept_code);  //�μ�
		ht7.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht7.put("CD_COMPANY",  "1000");  
		ht7.put("ID_WRITE", insert_id);   
		ht7.put("CD_DOCU",  "11");  
		
		ht7.put("DT_ACCT", 	assch_date);
		ht7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht7.put("TP_DRCR",   "2");   // �뺯:2 , ����:1	
		
		if ( ass_bean.getCar_use().equals("2") ) { //��Ʈ�̸�
			ht7.put("CD_ACCT",  	"41300");    //�뿩�������
		} else {
			ht7.put("CD_ACCT",  	"41500");  //�����������
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
		line++;
		
		Hashtable ht8 = new Hashtable();
		
		ht8.put("WRITE_DATE", 		assch_date);//row_id				
		ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
		ht8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
		ht8.put("CD_PC",  	node_code);  //ȸ�����
		ht8.put("CD_WDEPT",  dept_code);  //�μ�
		ht8.put("NO_DOCU",  	"");  //�̰��� '0' 
		ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
		ht8.put("CD_COMPANY",  "1000");  
		ht8.put("ID_WRITE", insert_id);   
		ht8.put("CD_DOCU",  "11");  
		
		ht8.put("DT_ACCT", 	assch_date);
		ht8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
		ht8.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
		
		if ( ass_bean.getCar_use().equals("2") ) { //��Ʈ�̸�
			ht8.put("CD_ACCT",  	"45300");    //�뿩�������
		} else {
			ht8.put("CD_ACCT",  	"45400");  //�����������
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
	
	Hashtable ht7 = new Hashtable();
		
	ht7.put("WRITE_DATE", 		assch_date);//row_id				
	ht7.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht7.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
	ht7.put("CD_PC",  	node_code);  //ȸ�����
	ht7.put("CD_WDEPT",  dept_code);  //�μ�
	ht7.put("NO_DOCU",  	"");  //�̰��� '0' 
	ht7.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht7.put("CD_COMPANY",  "1000");  
	ht7.put("ID_WRITE", insert_id);   
	ht7.put("CD_DOCU",  "11");  
	
	ht7.put("DT_ACCT", 	assch_date);
	ht7.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht7.put("TP_DRCR",   "2");   // �뺯:2 , ����:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //��Ʈ�̸�
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
	
	vt_auto.add(ht7);  // ó������ / �ս�
	
		
	// ��ΰ�
	line++;
	
	Hashtable ht8 = new Hashtable();
	
	ht8.put("WRITE_DATE", 		assch_date);//row_id				
	ht8.put("ROW_NO",  	String.valueOf(line)); //row_no							
	ht8.put("NO_TAX",  	"*");  //�ΰ��� �ܴ̿� *
	ht8.put("CD_PC",  	node_code);  //ȸ�����
	ht8.put("CD_WDEPT",  dept_code);  //�μ�
	ht8.put("NO_DOCU",  	"");  //�̰��� '0' 
	ht8.put("NO_DOLINE",  String.valueOf(line)); //row_no  : �̰��� ���???
	ht8.put("CD_COMPANY",  "1000");  
	ht8.put("ID_WRITE", insert_id);   
	ht8.put("CD_DOCU",  "11");  
	
	ht8.put("DT_ACCT", 	assch_date);
	ht8.put("ST_DOCU",  "1");  //�̰�:1, ����:2  
	ht8.put("TP_DRCR",   "1");   // �뺯:2 , ����:1	
	
	if ( ass_bean.getCar_use().equals("2") ) { //��Ʈ�̸�
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
		row_id = neoe_db.insertSetAutoDocu(assch_date, vt_auto);
	  }
 	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){	
	<%	if( s_flag.equals("0")){%>
 	  			alert("���������� ó��(��ǥ����)�Ǿ����ϴ�.");
	 	  		var theForm = document.form1;
	 	  		theForm.target='d_content';
  				theForm.submit();
	<%	}else {%>
 	  			alert("���� ����!");
	<% } %>
   
   }
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./asset_s_frame.jsp" name="form1" method="post">
<input type="hidden" name="cmd" valaue="nd">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="asset_code" value="<%=asset_code%>">
</form>
</body>
</html>
