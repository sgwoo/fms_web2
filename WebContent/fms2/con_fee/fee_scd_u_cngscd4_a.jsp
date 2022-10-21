<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*, acar.ext.*, tax.*, acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db"  scope="page" class="acar.cont.AddContDatabase" />
<jsp:useBean id="al_db"  scope="page" class="acar.client.AddClientDatabase" />
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	String cng_cau 	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	int idx 	= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String client_id 		= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String s_fee_est_dt 		= request.getParameter("s_fee_est_dt")==null?"":request.getParameter("s_fee_est_dt");
	
	
	String fee_tm 			= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tax_cng_yn 		= request.getParameter("tax_cng_yn")==null?"N":request.getParameter("tax_cng_yn");
	String rent_suc_dt 		= request.getParameter("rent_suc_dt")==null?"":request.getParameter("rent_suc_dt");
	String rent_suc_fee_tm_b_dt 	= request.getParameter("rent_suc_fee_tm_b_dt")==null?"":request.getParameter("rent_suc_fee_tm_b_dt");
	String cng_fee_tm		= fee_tm;
	
	//�°��İ��
	String rent_suc_m_id 		= request.getParameter("rent_suc_m_id")==null?"":request.getParameter("rent_suc_m_id");
	String rent_suc_l_cd 		= request.getParameter("rent_suc_l_cd")==null?"":request.getParameter("rent_suc_l_cd");
	
	String grt_suc_yn 		= request.getParameter("grt_suc_yn")==null?"":request.getParameter("grt_suc_yn");
	String pp_suc_yn 		= request.getParameter("pp_suc_yn")==null?"":request.getParameter("pp_suc_yn");
	String ifee_suc_yn 		= request.getParameter("ifee_suc_yn")==null?"":request.getParameter("ifee_suc_yn");
	
	int suc_pp_s_amt 		= request.getParameter("pp_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("pp_s_amt"));
	int suc_pp_v_amt 		= request.getParameter("pp_v_amt")==null? 0:AddUtil.parseDigit(request.getParameter("pp_v_amt"));
	int suc_ifee_s_amt 		= request.getParameter("ifee_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("ifee_s_amt"));
	int suc_ifee_v_amt 		= request.getParameter("ifee_v_amt")==null? 0:AddUtil.parseDigit(request.getParameter("ifee_v_amt"));
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	int flag = 0;
	int flag4 = 0;
	boolean flag2 = true;	
	boolean flag7 = true;
	boolean flag6 = true;
	
 	String o_fee_tm = fee_tm;
 	String etc1 = "";
 	String etc2 = "";
	
	
	
	//�°�� ���
	Hashtable cng_cont = af_db.getScdFeeCngContA(m_id, l_cd);
	
	
	//���⺻����
	ContBaseBean c_base = a_db.getCont(m_id, l_cd);
	//���°� Ȥ�� ���������϶� ����� ��������
	Hashtable begin = a_db.getContBeginning(m_id, c_base.getReg_dt());
	//������
	ClientBean client = al_db.getNewClient(c_base.getClient_id());
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	
	
	
	if(rent_suc_dt.equals("")){
		rent_suc_dt = String.valueOf(cng_cont.get("RENT_SUC_DT"));
	}
	
	
	//�뿩�� �̰�ó��-----------------------------------------------------------------------------------------------
	if(!fee_tm.equals("")){
	
		System.out.println("[�뿩���̰��� �뿩�ὺ���� ����]------------------------------------------");
		System.out.println("# �������="+l_cd);
		System.out.println("# �°���="+rent_suc_l_cd);
		System.out.println("# �°�����="+rent_suc_dt);
		System.out.println("# �°�ȸ��="+fee_tm);	
		System.out.println("# �°����ڰ��="+rent_suc_fee_tm_b_dt);	
	
		//���ڰ�� �ִ�.	
		if(!rent_suc_fee_tm_b_dt.equals("")){
		
			//�뿩�ὺ���� ��ȸ�� ����
			FeeScdBean fee_scd = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, "0"); //����ȸ��
			
			FeeScdBean fee_scd2 = fee_scd; //�ܾ�ȸ��
			
			FeeScdBean fee_scd3 = fee_scd; //��������ȸ��
			
			if(!fee_scd.getUse_s_dt().equals(AddUtil.replace(rent_suc_fee_tm_b_dt,"-","")) 
				&& AddUtil.parseInt(AddUtil.replace(rent_suc_fee_tm_b_dt,"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_s_dt(),"-",""))
				&& AddUtil.parseInt(AddUtil.replace(rent_suc_fee_tm_b_dt,"-","")) <= AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-",""))
			){
			
				System.out.println("# �°�ȸ���� �Ⱓ�� �°�������� ���ԵǾ� �ִ�.");	
				
				int a_fee_amt = fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt();
				//���ڰ�������������
				int int_fee_amt1 = 0;
				Hashtable dt_ht1 = af_db.getUseMonDay(c_db.addDay(rent_suc_fee_tm_b_dt, -1), fee_scd.getUse_s_dt());
				if( AddUtil.parseInt(String.valueOf(dt_ht1.get("U_MON"))) + AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) > 0 ){
					int max_fee_amt = ( a_fee_amt*AddUtil.parseInt(String.valueOf(dt_ht1.get("U_MON"))) ) + ( a_fee_amt/30*AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) );
					int_fee_amt1 = max_fee_amt;
					etc1 = "���Ұ�곻��:"+a_fee_amt+"��(���뿩��VAT����)*"+String.valueOf(dt_ht1.get("U_MON"))+"+"+a_fee_amt+"��/30*"+String.valueOf(dt_ht1.get("U_DAY"))+"��";
				}
				
				System.out.println("# ���ڰ������������� int_fee_amt1="+int_fee_amt1);	
				
				//���ڰ�����������
				int int_fee_amt2 = 0;
				Hashtable dt_ht2 = af_db.getUseMonDay(fee_scd.getUse_e_dt(), rent_suc_fee_tm_b_dt);
				if( AddUtil.parseInt(String.valueOf(dt_ht2.get("U_MON"))) + AddUtil.parseInt(String.valueOf(dt_ht2.get("U_DAY"))) > 0 ){
					int max_fee_amt = ( a_fee_amt*AddUtil.parseInt(String.valueOf(dt_ht2.get("U_MON"))) ) + ( a_fee_amt/30*AddUtil.parseInt(String.valueOf(dt_ht2.get("U_DAY"))) );
					int_fee_amt2 = max_fee_amt;
					etc2 = "���Ұ�곻��:"+a_fee_amt+"��(���뿩��VAT����)*"+String.valueOf(dt_ht2.get("U_MON"))+"+"+a_fee_amt+"��/30*"+String.valueOf(dt_ht2.get("U_DAY"))+"��";
				}
				
				System.out.println("# ���ڰ����������� int_fee_amt2="+int_fee_amt2);	
				
				//���Ѵ��϶� - �����Ѵ��ϼ��� ����
				Hashtable dt_ht0 = af_db.getUseMonDay(fee_scd.getUse_e_dt(), fee_scd.getUse_s_dt());
				int use_day2 = 30-AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY")));
				if( AddUtil.parseInt(String.valueOf(dt_ht0.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht0.get("U_DAY"))) ==0 ){
					if( AddUtil.parseInt(String.valueOf(dt_ht1.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) ==0 ){
						int_fee_amt1 = a_fee_amt;
						int_fee_amt2 = 0;
						etc1 = "";
						etc2 = "";
					}else if( AddUtil.parseInt(String.valueOf(dt_ht2.get("U_MON")))==1 && AddUtil.parseInt(String.valueOf(dt_ht2.get("U_DAY"))) ==0 ){
						int_fee_amt1 = 0;
						int_fee_amt2 = a_fee_amt;
						etc1 = "";
						etc2 = "";
					}else{
						int_fee_amt1 = ( a_fee_amt/30*AddUtil.parseInt(String.valueOf(dt_ht1.get("U_DAY"))) );
						int_fee_amt2 = ( a_fee_amt/30*use_day2 );
						etc1 = "���Ұ�곻��:"+a_fee_amt+"��(���뿩��VAT����)/30*"+String.valueOf(dt_ht1.get("U_DAY"))+"��";
						etc2 = "���Ұ�곻��:"+a_fee_amt+"��(���뿩��VAT����)/30*"+use_day2+"��";
					}
					
					System.out.println("# ���Ѵ��϶� - �����Ѵ��ϼ��� ���� int_fee_amt1="+int_fee_amt1);	
					System.out.println("# ���Ѵ��϶� - �����Ѵ��ϼ��� ���� int_fee_amt2="+int_fee_amt2);	
				}
				
				//�ܾ�Ȯ��
				int balance_amt = fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt()-fee_scd.getRc_amt();
				
				System.out.println("# �ܾ�Ȯ�� balance_amt="+balance_amt);	
				
				//�����Ա��̰ų� ���Ա��϶�, �ܾ��� �ִ� ���� ����
				if(balance_amt == 0 || balance_amt==(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt())){
														
					//����ȸ�� ���ڰ��������� ������ �ݾ׼���
					fee_scd.setUse_e_dt	(c_db.addDay(rent_suc_fee_tm_b_dt, -1));
					
					fee_scd.setFee_s_amt		(af_db.getSupAmt(int_fee_amt1));
					fee_scd.setFee_v_amt		(int_fee_amt1-fee_scd.getFee_s_amt());
					//fee_scd.setFee_s_amt	(int_fee_s_amt1);
					//fee_scd.setFee_v_amt	(int_fee_s_amt1*10/100);
					fee_scd.setEtc					(etc1);
					if(!af_db.updateFeeScd(fee_scd)) flag += 1;
					
					System.out.println("# ����ȸ�� ���ڰ��������� ������ �ݾ׼��� "+fee_scd.getRent_l_cd()+" int_fee_amt1="+int_fee_amt1);	
					
					
					//����� �ŷ����� ��꼭 �̹�������� ��� ����� �ŷ����� ��꼭�������ڵ� ���� �Ұ�..
					int chk_cnt1 = af_db.getTaxDtChk(l_cd, rent_st, rent_seq, fee_tm);
					String item_id = "";
		
					//��꼭 �̹������
					if(chk_cnt1 ==0){
						item_id = af_db.getTaxItemDtChk(l_cd, rent_st, rent_seq, fee_tm);
						if(!item_id.equals("")){
							//�ŷ����� ��ȸ
							TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
							//��꼭�����Ϻ���� ó��
							if(!ti_bean.getTax_est_dt().equals(AddUtil.replace(fee_scd.getTax_out_dt(),"-",""))){
								ti_bean.setTax_est_dt	(fee_scd.getTax_out_dt());
								if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
								System.out.println("�뿩�� ������ ������ �ŷ����� ��꼭�������� ����"+ l_cd +" "+fee_tm);
							}
							//���ް��׺���� ó��
							TaxItemListBean til_bean = IssueDb.getTaxItemListScdFeeCase(item_id, l_cd, fee_tm);
							if(til_bean.getItem_supply() > fee_scd.getFee_s_amt() || til_bean.getItem_supply() < fee_scd.getFee_s_amt()){
					
								til_bean.setItem_supply	(fee_scd.getFee_s_amt());
								til_bean.setItem_value	(fee_scd.getFee_v_amt());
								til_bean.setItem_dt1	(fee_scd.getUse_s_dt());
								til_bean.setItem_dt2	(fee_scd.getUse_e_dt());
					
								if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
								
								String reg_code = til_bean.getReg_code();
					
								//�ŷ����� ����Ʈ ��ȸ
								Vector tils	            	= IssueDb.getTaxItemListCase(item_id);
								int til_size           	 	= tils.size();
								int o_item_hap_num 		= ti_bean.getItem_hap_num();
								int n_item_hap_num 		= 0;
								for(int i = 0 ; i < til_size ; i++){
									TaxItemListBean til_bean2 = (TaxItemListBean)tils.elementAt(i);
									n_item_hap_num = n_item_hap_num + til_bean2.getItem_supply() + til_bean2.getItem_value();
								}
								ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(n_item_hap_num))+"��");
								ti_bean.setItem_hap_num(n_item_hap_num);
								if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
								System.out.println("�뿩�� ������ ������ �ŷ����� ���ް��� ����"+ l_cd +" "+fee_tm);
								
								//����� �ŷ����� �̸��� ��߼� : ���ν��� ȣ��
								String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("", sender_bean.getId(), reg_code, item_id, "", "", "");		
								
							}
						}
					}else{
						System.out.println("�뿩�� ������ �����Ǿ�����, ��꼭�� �̹� ������ ���� : "+ l_cd +" "+fee_tm);
			
						//�˶��޽���
						
						String sub 		= "�뿩�ὺ���� �����ȳ�";
						String cont 		= "[" + l_cd +" "+fee_tm+"ȸ��]  &lt;br&gt; &lt;br&gt; �뿩�� ������ �����Ǿ�����,  &lt;br&gt; &lt;br&gt; ��꼭�� �̹� ������ �����̴� Ȯ���Ͻñ� �ٶ��ϴ�.";
						String target_id 	= nm_db.getWorkAuthUser("���ݰ�꼭�����");
						boolean m_flag = true;
						
						CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
						if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
				
						//����� ���� ��ȸ
						UsersBean target_bean 	= umd.getUsersBean(target_id);
				
						String xml_data = "";
						xml_data =  "<COOLMSG>"+
			  						"<ALERTMSG>"+
  									"    <BACKIMG>4</BACKIMG>"+
			  						"    <MSGTYPE>104</MSGTYPE>"+
  									"    <SUB>"+sub+"</SUB>"+
			  						"    <CONT>"+cont+"</CONT>"+
 									"    <URL></URL>";
				
						xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				
						xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  									"    <MSGICON>10</MSGICON>"+
			  						"    <MSGSAVE>1</MSGSAVE>"+
			  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
  									"    <FLDTYPE>1</FLDTYPE>"+
			  						"  </ALERTMSG>"+
  									"</COOLMSG>";
				
						CdAlertBean msg = new CdAlertBean();
						msg.setFlddata(xml_data);
						msg.setFldtype("1");
				
						m_flag = cm_db.insertCoolMsg(msg);
					}
					
					
					
					//ȸ���ø�
					flag7 = af_db.updateFeeScdTmAddCase(fee_scd);
					
					System.out.println("# ȸ���ø�");	
					
					//����ȸ�� ���ڰ��������ĺ� ������ ����						
					if(flag7){ 
					
						//fee_tm = AddUtil.addZero2(AddUtil.parseInt(fee_tm)+1);
						String add_fee_tm = String.valueOf(AddUtil.parseInt(fee_tm)+1);
						//fee_tm = String.valueOf(AddUtil.parseInt(fee_tm)+1);
																		
						fee_scd2.setRent_l_cd	(rent_suc_l_cd);
						fee_scd2.setFee_tm			(add_fee_tm);
						fee_scd2.setUse_s_dt		(rent_suc_fee_tm_b_dt);
						fee_scd2.setUse_e_dt		(fee_scd3.getUse_e_dt());
						fee_scd.setFee_s_amt		(af_db.getSupAmt(int_fee_amt2));
						fee_scd.setFee_v_amt		(int_fee_amt2-fee_scd.getFee_s_amt());
						//fee_scd2.setFee_s_amt	(int_fee_s_amt2);
						//fee_scd2.setFee_v_amt	(int_fee_s_amt2*10/100);						
						fee_scd.setEtc					(etc2);
						if(!af_db.insertFeeScd(fee_scd2)) flag4 += 1;
						
						System.out.println("# ����ȸ�� ���ڰ��������ĺ� ������ ���� int_fee_amt2="+int_fee_amt2);	
						
						cng_fee_tm = add_fee_tm;
					}										
				}				
			}									
		}
			
			
		flag7 = a_db.updateScdFeeCng2(m_id, l_cd, cng_fee_tm, String.valueOf(cng_cont.get("RENT_L_CD")), "���°� �̰�");

		
		if(tax_cng_yn.equals("Y")){
			//����� ��꼭 ����ȣ ����
			flag7 = a_db.updateScdFeeTaxCng(m_id, l_cd, fee_tm, String.valueOf(cng_cont.get("RENT_L_CD")));
			System.out.println("[����� ��꼭 ����ȣ ����]------------------------------------------");
			System.out.println("# fee_tm="+fee_tm);
		}
		
		
		//�����̷� ���
		FeeScdCngBean cng = new FeeScdCngBean();
		cng.setRent_mng_id	(rent_suc_m_id);
		cng.setRent_l_cd	(rent_suc_l_cd);
		cng.setFee_tm		(o_fee_tm);
		cng.setAll_st		("Y");
		cng.setCng_id		(user_id);
		cng.setCng_cau		("���°� �뿩�ὺ���� "+cng_fee_tm+"ȸ������ ��� ȸ�� �̰�");
		if(!rent_suc_fee_tm_b_dt.equals("")){
			cng.setCng_cau(cng.getCng_cau()+", ���ڰ������� "+rent_suc_fee_tm_b_dt);
		}
		if(!af_db.insertFeeScdCng(cng)) flag += 1;
	}
	
	
	//������ �̰�ó��-------------------------------------------------------------------------------------------------
	
	
	//�°��� �뿩����
	ContFeeBean b_fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	//�°��� �뿩����
	ContFeeBean a_fee = a_db.getContFeeNew(rent_suc_m_id, rent_suc_l_cd, rent_st);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_suc_m_id, rent_suc_l_cd);
	cont_etc.setRent_suc_fee_tm_b_dt(request.getParameter("rent_suc_fee_tm_b_dt")==null?"":request.getParameter("rent_suc_fee_tm_b_dt"));
	flag2 = a_db.updateContEtc(cont_etc);
	
	
		//������ ������ ����
		
		
		//������
		ExtScdBean grt = ae_db.getAGrtScd(rent_suc_m_id, rent_suc_l_cd, rent_st, "0", "1");//���� ��� ���� ��ȸ
		int grt_gbn = 1;	//����
		if(grt == null || grt.getRent_l_cd().equals("")){
			grt_gbn = 0;	//�ű�
			grt = new ExtScdBean();
			grt.setRent_mng_id	(rent_suc_m_id);
			grt.setRent_l_cd	(rent_suc_l_cd);
			grt.setRent_st		(rent_st);
			grt.setRent_seq		("1");
			grt.setExt_id		("0");
			grt.setExt_st		("0");
			grt.setExt_tm		("1");
		}
		System.out.println("[�뿩���̰��� �����ݽ����� ����]------------------------------------------");
		System.out.println("# �°���="+rent_suc_l_cd);
		System.out.println("# �°�����="+rent_suc_dt);
		System.out.println("# �뿩��ȣ="+rent_st);
		
		System.out.println("[������]");
		System.out.println("# ����������="+grt_gbn);
		System.out.println("# �����ٱݾ�="+grt.getExt_s_amt());
		System.out.println("# �����ݾ�  ="+a_fee.getGrt_amt_s());
		System.out.println("# ó������  ="+grt_suc_yn);
		
		if(a_fee.getGrt_amt_s()>0){//grt.getExt_s_amt() == 0 && 
			//�ݾ� �����϶�(�� �뿩�� ���� �°谡 �ƴ�)
			if(grt_suc_yn.equals("1")){
				grt.setExt_s_amt	(a_fee.getGrt_amt_s());
				grt.setExt_v_amt	(0);
				grt.setExt_est_dt	(rent_suc_dt);
				grt.setExt_pay_amt	(0);
				grt.setExt_pay_dt	("");
				
				System.out.println("-�����ݺ���ó��-");
				System.out.println("�Աݿ����� ="+grt.getExt_est_dt());
				
			}else{//�°��϶� ����� ������ �״��
				ExtScdBean b_grt = ae_db.getAGrtScd(m_id, l_cd, rent_st, "0", "1");//���� ��� ���� ��ȸ
				if(!rent_st.equals("1") && b_grt.getExt_s_amt() ==0){
					b_grt = ae_db.getAGrtScd(m_id, l_cd, "1", "0", "1");//���� ��� ���� ��ȸ
				}
				grt.setExt_s_amt	(b_fee.getGrt_amt_s());
				grt.setExt_v_amt	(0);
				grt.setExt_est_dt	(rent_suc_dt);
				if(b_grt.getExt_pay_amt()>0){
					grt.setExt_pay_amt	(b_fee.getGrt_amt_s());
					grt.setExt_pay_dt	(rent_suc_dt);
				}	
				//�κн°��̸� ��ຸ�������� ó�� 20211227				
				if(a_fee.getGrt_amt_s() > b_fee.getGrt_amt_s() || a_fee.getGrt_amt_s() < b_fee.getGrt_amt_s()){
					grt.setExt_s_amt	(a_fee.getGrt_amt_s());
					if(b_grt.getExt_pay_amt()>0 && a_fee.getGrt_amt_s() <= b_fee.getGrt_amt_s()){
						grt.setExt_pay_amt	(a_fee.getGrt_amt_s());
					}					
				}
				System.out.println("-�����ݽ°�ó��-");
				System.out.println("�������ٱݾ�  	="+b_grt.getExt_s_amt());
				System.out.println("�������ٿ����� 	="+b_grt.getExt_est_dt());
				System.out.println("���������Աݾ� 	="+b_grt.getExt_pay_amt());
				System.out.println("���������Ա���	="+b_grt.getExt_pay_dt());
				System.out.println("�Աݿ����� 		="+grt.getExt_est_dt());
				
			}
			grt.setUpdate_id	(user_id);
			//=====[scd_pre] update=====
			if(grt_gbn == 1)	flag6 = ae_db.i_updateGrt(grt);
			else				flag6 = ae_db.insertGrt(grt);
			
			//�ܾ׹߻�
			if(b_fee.getGrt_amt_s() < a_fee.getGrt_amt_s()){
				grt.setExt_s_amt	(a_fee.getGrt_amt_s());
				flag6 = ae_db.updateGrt(grt);
			}
		}
		
		//������
		ExtScdBean pp = ae_db.getAGrtScd(rent_suc_m_id, rent_suc_l_cd, rent_st, "1", "1");//���� ��� ���� ��ȸ
		ExtScdBean o_pp = ae_db.getAGrtScd(m_id, l_cd, rent_st, "1", "1");//���� ��� ���� ��ȸ
		int pp_gbn = 1;		//����
		if(pp == null || pp.getRent_l_cd().equals("")){
			pp_gbn = 0;		//�ű�
			pp = new ExtScdBean();
			pp.setRent_mng_id	(rent_suc_m_id);
			pp.setRent_l_cd		(rent_suc_l_cd);
			pp.setRent_st		(rent_st);
			pp.setRent_seq		("1");
			pp.setExt_id		("0");
			pp.setExt_st		("1");
			pp.setExt_tm		("1");
		}
		System.out.println("[������]");
		System.out.println("�����ٱݾ�="+pp.getExt_s_amt());
		System.out.println("�����ݾ�  ="+a_fee.getPp_s_amt());
		System.out.println("ó������  ="+pp_suc_yn);
		
		if(a_fee.getPp_s_amt()>0){//pp.getExt_s_amt() == 0 && 
			//�ݾ� �����϶�(�� �뿩�� ���� �°谡 �ƴ�)
			if(pp_suc_yn.equals("1")){
//				pp.setExt_s_amt		(a_fee.getPp_s_amt());
//				pp.setExt_v_amt		(a_fee.getPp_v_amt());
//				pp.setExt_est_dt	(rent_suc_dt);
//				pp.setExt_pay_amt	(0);
//				pp.setExt_pay_dt	("");
				pp.setExt_s_amt		(b_fee.getPp_s_amt());
				pp.setExt_v_amt		(b_fee.getPp_v_amt());
				pp.setExt_pay_amt	(cont_etc.getPp_suc_o_amt()-cont_etc.getPp_suc_r_amt());
				pp.setExt_est_dt	(o_pp.getExt_est_dt());
				pp.setExt_pay_dt	(o_pp.getExt_pay_dt());
			}else{//�°��϶� ����� ������ �״��
				ExtScdBean b_pp = ae_db.getAGrtScd(m_id, l_cd, rent_st, "1", "1");//���� ��� ���� ��ȸ
				pp.setExt_s_amt		(b_fee.getPp_s_amt());
				pp.setExt_v_amt		(b_fee.getPp_v_amt());
				pp.setExt_est_dt	(rent_suc_dt);
				if(b_pp.getExt_s_amt()>0){
					pp.setExt_pay_amt	(b_fee.getPp_s_amt()+b_fee.getPp_v_amt());
					pp.setExt_pay_dt	(rent_suc_dt);
				}
			}
			pp.setUpdate_id	(user_id);
			System.out.println("�Աݿ����� ="+pp.getExt_est_dt());
			
			//=====[scd_pre] update=====
			if(pp_gbn == 1)		flag6 = ae_db.i_updateGrt(pp);
			else				flag6 = ae_db.insertGrt(pp);
			
			//�ܾ׹߻�
			if(b_fee.getPp_s_amt() < a_fee.getPp_s_amt()){
				pp.setExt_s_amt	(a_fee.getPp_s_amt());
				pp.setExt_v_amt	(a_fee.getPp_v_amt());
				flag6 = ae_db.updateGrt(pp);
			}else{
				//�ܾ׹߻�
				if(pp_suc_yn.equals("1")){
					pp.setExt_s_amt		(suc_pp_s_amt);
					pp.setExt_v_amt		(suc_pp_v_amt);
					pp.setExt_est_dt	(rent_suc_dt);
					pp.setExt_tm		("2");
					pp.setExt_pay_amt	(0);
					pp.setExt_pay_dt	("");
					flag6 = ae_db.insertGrt(pp);
					System.out.println("�ܾ׹߻� ="+pp.getExt_est_dt());
				}
			}
			
		}
		
		//���ô뿩��
		ExtScdBean ifee = ae_db.getAGrtScd(rent_suc_m_id, rent_suc_l_cd, rent_st, "2", "1");//���� ��� ���� ��ȸ
		ExtScdBean o_ifee = ae_db.getAGrtScd(m_id, l_cd, rent_st, "2", "1");//���� ��� ���� ��ȸ
		int ifee_gbn = 1;	//����
		if(ifee == null || ifee.getRent_l_cd().equals("")){
			ifee_gbn = 0;	//�ű�
			ifee = new ExtScdBean();
			ifee.setRent_mng_id	(rent_suc_m_id);
			ifee.setRent_l_cd	(rent_suc_l_cd);
			ifee.setRent_st		(rent_st);
			ifee.setRent_seq	("1");
			ifee.setExt_id		("0");
			ifee.setExt_st		("2");
			ifee.setExt_tm		("1");
		}
		System.out.println("[���ô뿩��]");
		System.out.println("�����ٱݾ�="+ifee.getExt_s_amt());
		System.out.println("�����ݾ�  ="+a_fee.getIfee_s_amt());
		System.out.println("ó������  ="+ifee_suc_yn);
		
		if(a_fee.getIfee_s_amt()>0){//ifee.getExt_s_amt() == 0 && 
			//�ݾ� �����϶�(�� �뿩�� ���� �°谡 �ƴ�)
			if(ifee_suc_yn.equals("1")){
//				ifee.setExt_s_amt	(a_fee.getIfee_s_amt());
//				ifee.setExt_v_amt	(a_fee.getIfee_v_amt());
//				ifee.setExt_est_dt	(rent_suc_dt);
//				ifee.setExt_pay_amt	(0);
//				ifee.setExt_pay_dt	("");
				ifee.setExt_s_amt	(b_fee.getIfee_s_amt());
				ifee.setExt_v_amt	(b_fee.getIfee_v_amt());
				ifee.setExt_pay_amt	(cont_etc.getIfee_suc_o_amt()-cont_etc.getIfee_suc_r_amt());
				ifee.setExt_est_dt	(o_ifee.getExt_est_dt());
				ifee.setExt_pay_dt	(o_ifee.getExt_pay_dt());
			}else{//�°��϶� ����� ������ �״��
				ExtScdBean b_ifee = ae_db.getAGrtScd(m_id, l_cd, rent_st, "2", "1");//���� ��� ���� ��ȸ
				ifee.setExt_s_amt	(b_fee.getIfee_s_amt());
				ifee.setExt_v_amt	(b_fee.getIfee_v_amt());
				ifee.setExt_est_dt	(rent_suc_dt);
				if(b_ifee.getExt_s_amt()>0){
					ifee.setExt_pay_amt	(b_fee.getIfee_s_amt()+b_fee.getIfee_v_amt());
					ifee.setExt_pay_dt	(rent_suc_dt);
				}
			}
			ifee.setUpdate_id	(user_id);
			System.out.println("�Աݿ����� ="+ifee.getExt_est_dt());
			
			//=====[scd_pre] update=====
			if(ifee_gbn == 1)	flag6 = ae_db.i_updateGrt(ifee);
			else				flag6 = ae_db.insertGrt(ifee);
			
			//�ܾ׹߻�
			if(b_fee.getIfee_s_amt() < a_fee.getIfee_s_amt()){
				ifee.setExt_s_amt	(a_fee.getIfee_s_amt());
				ifee.setExt_v_amt	(a_fee.getIfee_v_amt());
				flag6 = ae_db.updateGrt(ifee);
			}else{
				//�ܾ׹߻�
				if(ifee_suc_yn.equals("1")){
					ifee.setExt_s_amt	(suc_ifee_s_amt);
					ifee.setExt_v_amt	(suc_ifee_v_amt);
					ifee.setExt_est_dt	(rent_suc_dt);
					ifee.setExt_tm		("1");
					ifee.setExt_pay_amt	(0);
					ifee.setExt_pay_dt	("");
					flag6 = ae_db.insertGrt(ifee);
					System.out.println("�ܾ׹߻� ="+ifee.getExt_est_dt());
				}
			}
			
		}
		
		
		//�������ڿ��� ����Ȯ�� �޽��� �߼�
		String sub2 		= String.valueOf(begin.get("CLS_ST"))+" Ȯ��";
		String cont_b = "[ "+String.valueOf(begin.get("RENT_L_CD"))+" "+String.valueOf(begin.get("FIRM_NM"))+" -> "+l_cd+" "+client.getFirm_nm();
			
		if(client.getClient_st().equals("2")){
			cont_b = cont_b + " "+client.getSsn1()+" "+String.valueOf(base.get("CAR_NO"));
	  }else{
	  	cont_b = cont_b + " "+client.getEnp_no1()+"-"+client.getEnp_no2()+"-"+client.getEnp_no3()+" "+String.valueOf(base.get("CAR_NO"));
		}
			
		String cont2 		= cont_b + " ] "+String.valueOf(begin.get("CLS_ST"))+"�� ��ϵǰ� �뿩�ὺ���� �̰��� �Ǿ����ϴ�. ���� Ȯ�ιٶ��ϴ�.";
		String target_id2 	= nm_db.getWorkAuthUser("�λ꺸����");
		boolean m_flag2 = true;
						
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id2);
		if(!cs_bean2.getWork_id().equals("")) target_id2 = cs_bean2.getWork_id();
				
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
		xml_data2 += "   <TARGET>"+target_bean2.getId()+"</TARGET>";
		xml_data2 += "   <SENDER>"+sender_bean.getId()+"</SENDER>"+
								"    <MSGICON>10</MSGICON>"+
	  						"    <MSGSAVE>1</MSGSAVE>"+
		 						"    <LEAVEDMSG>1</LEAVEDMSG>"+
  							"    <FLDTYPE>1</FLDTYPE>"+
		 						"  </ALERTMSG>"+
  							"</COOLMSG>";
		
		CdAlertBean msg2 = new CdAlertBean();
		msg2.setFlddata(xml_data2);
		msg2.setFldtype("1");
			
		//20170221 �̻�� : ��Ͻ����� ��� ó���� ��
		//m_flag2 = cm_db.insertCoolMsg(msg2);
		
		
%>


<html>
<head><title>FMS</title></head>
<body style="font-size:12">
<form name='form1' method="POST">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='rent_seq' value='<%=rent_seq%>'>
<input type='hidden' name='cng_st' value='<%=cng_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='s_fee_est_dt' value='<%=s_fee_est_dt%>'>
</form>
<script language='javascript'>
<%	if(!flag7){%>
		alert("�������� ������� �ʾҽ��ϴ�");
<%	}else{		%>		
		alert("�������� ����Ǿ����ϴ�");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>
</body>
</html>
