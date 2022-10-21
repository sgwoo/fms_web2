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
				   real_date = opt_ip_dt1;
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
	
	
//	if(base.getTax_type().equals("2")){//����
	
//		if(! base.getR_site().equals("")){
			//�ŷ�ó��������
//			ClientSiteBean site = al_db.getClientSite(client_id, site_id);
//			i_enp_no 		= site.getEnp_no();
		
//			i_addr 			= site.getAddr();
//			i_sta 			= site.getBus_cdt();
//			i_item 			= site.getBus_itm();
//			i_ven_code		= site.getVen_code();
//			i_ssn 		    = "";
//		}
//	}
	
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
	
	String m_i_ssn = "";
	m_i_ssn = mclient.getSsn1() + mclient.getSsn2();
	
	String foreigner=  mclient.getNationality();
		
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
	
		//������ ���ݰ�꼭
	String fee_tm = ac_db.getMaxFeeTaxTm(rent_l_cd);
		
	//���ݰ�꼭 ������� - ���������
	Hashtable l_tax = ac_db.getLastFeeTaxDt(rent_l_cd, fee_tm);
	
	String tax_no = "";
	int data_no =0;
	int data_no_t =0;
  	int tax_cnt = 0;
  	
  	int line =0;
  	int jangbu_amt  = 0;
  	int amt_10800 = 0;
	String doc_cont = "";
	
	//�ڻ� �Ű� ���
//	s_flag =  ass_db.call_sp_insert_assetmove2_off(real_date.substring(0,4), real_date.substring(5,7), car_mng_id, user_id );
//	System.out.println("�ڻ�Ű� ���" + s_flag);

//	int opt_s_amt = request.getParameter("opt_s_amt")==null?0:AddUtil.parseInt(request.getParameter("opt_s_amt")); //���Կɼ� ���ް�
		
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
    
 //   if (opt_s_amt > 0) {
  //     if ( opt_s_amt <> sup_amt ) {
  //     		sup_amt =  opt_s_amt;       		
   //    }
    
  //  }
    
    jangbu_amt =    get_amt  + book_dr   - jun_reser - dep_amt - gdep_amt ;  //��ΰ���  
            
    amt_10800 = sale_amt + 	jun_reser + dep_amt + gdep_amt - get_amt  - book_dr - ( sale_amt - sup_amt); 		
  	
  	String item_id = "";
  	String reg_code = "";	
//  	String ven_code = "";


    //�ڻ�Ű� ���ݰ�꼭 
	tax_no = IssueDb.getTaxNoNext(real_date);

	
	//����� item_id ��������
	item_id = IssueDb.getItemIdNext(real_date);
	out.println("item_id="+item_id+"<br><br>");
	    		
	//�����ڵ� ��������
	reg_code  = Long.toString(System.currentTimeMillis());
	out.println("�����ڵ�="+reg_code+"<br>");
	
	//[1�ܰ�] �ŷ����� ����Ʈ ����		
	TaxItemListBean til_bean = new TaxItemListBean();			
	til_bean.setItem_id(item_id);
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
	til_bean.setReg_code(reg_code);
			
	til_bean.setCar_use(base.getCar_st()); //���ڼ��ݰ�꼭 �ǹ����� ���� ���� - 1:��Ʈ 2:����
	til_bean.setItem_dt(real_date);  //���ڼ��ݰ�꼭 �ǹ����� ���� ����	
			
	if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
		    		
	//[2�ܰ�] �ŷ����� ����
	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	out.println("�ŷ����� ����="+vt_size+"<br><br>");
	
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
		t_bean.setTax_id(client_id);
		t_bean.setItem_id(item_id);
		t_bean.setTax_bigo("�����Ű� - " + car_no );			
		
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
			          
			          
		if(!IssueDb.insertTax(t_bean)) flag += 1;  
		
		if(!IssueDb.updateTaxAutodocu(tax_no)) flag += 1;
	}
	    		
	//���ڼ��ݰ�꼭 ����

	String  d_flag1 =  IssueDb.call_sp_tax_ebill_cls(user_bean.getUser_nm(), reg_code);
	if (d_flag1.equals("1"))		flag += 1;


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
