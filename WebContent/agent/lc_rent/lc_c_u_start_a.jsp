<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.coolmsg.*, acar.user_mng.*, acar.doc_settle.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.car_sche.*, acar.car_register.*, acar.im_email.*, tax.*, acar.insur.*, acar.fee.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

<%@ include file="/agent/cookies.jsp" %>


<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
//	if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//����1,����0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	String reg_type 	= request.getParameter("reg_type")==null?"":request.getParameter("reg_type");
	
	int t_con_mon 		=  request.getParameter("con_mon")==null?0:AddUtil.parseInt(request.getParameter("con_mon"));	
	int pere_r_mth 		=  request.getParameter("pere_r_mth")==null?0:AddUtil.parseInt(request.getParameter("pere_r_mth"));
	
	String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");


	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	int flag4 = 0;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	
	int flag = 0;
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(car_st.equals("")) car_st = base.getCar_st();
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);	
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	UsersBean target_bean = new UsersBean();
	UsersBean bus_target_bean = new UsersBean();


	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(fee.getPp_s_amt()==0 && !fee.getPp_chk().equals(""))  fee.setPp_chk("");
	
%>


<%

	
	
		if(!car_st.equals("2")){
		
			fee.setRent_start_dt			(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
			fee.setRent_end_dt			(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
			fee.setFee_pay_tm			(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
			
			if(reg_type.equals("1")){
				fee.setFee_est_day		(request.getParameter("fee_est_day1")		==null?"":request.getParameter("fee_est_day1"));
				fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt1")	==null?"":request.getParameter("fee_pay_start_dt1"));
				fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt1")	==null?"":request.getParameter("fee_pay_end_dt1"));
				fee.setFee_fst_dt		(request.getParameter("fee_fst_dt1")		==null?"":request.getParameter("fee_fst_dt1"));
				fee.setFee_fst_amt		(request.getParameter("fee_fst_amt1").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt1")));
			}else if(reg_type.equals("2")){
				fee.setFee_est_day		(request.getParameter("fee_est_day3")		==null?"":request.getParameter("fee_est_day3"));
				fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt3")	==null?"":request.getParameter("fee_pay_start_dt3"));
				fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt3")	==null?"":request.getParameter("fee_pay_end_dt3"));
				fee.setFee_fst_dt		(request.getParameter("fee_fst_dt3")		==null?"":request.getParameter("fee_fst_dt3"));
				fee.setFee_fst_amt		(request.getParameter("fee_fst_amt3").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt3")));
			}else if(reg_type.equals("3")){			
				fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")	==null?"":request.getParameter("fee_pay_start_dt"));
				fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")		==null?"":request.getParameter("fee_pay_end_dt"));
			}
			fee.setBr_id		("S1");
		
		
		
		
			base.setRent_start_dt		(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
			base.setRent_end_dt		(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
		

		
		
			//�����ε���
			cont_etc.setCar_deli_dt		(request.getParameter("car_deli_dt")		==null?"":request.getParameter("car_deli_dt"));
			if(cont_etc.getRent_mng_id().equals("")){
				//=====[cont_etc] update=====
				cont_etc.setRent_mng_id	(rent_mng_id);
				cont_etc.setRent_l_cd	(rent_l_cd);
				flag3 = a_db.insertContEtc(cont_etc);
			}else{
				//=====[cont_etc] update=====
				flag3 = a_db.updateContEtc(cont_etc);
			}
		
		
			//20141014 �����Ī������ ��� �����뿩���ý� ��������Ÿ� �Է��Ѵ�.
			
			String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
			
			if(taecha_no.equals("")){
				taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
			}
					
			//�����������
			ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
			
			taecha.setCar_rent_dt	(fee.getFee_fst_dt());
			if(!a_db.updateTaecha(taecha)) flag += 1;
		
			ContFeeBean fee_add = a_db.getContFeeNewAdd(rent_mng_id, rent_l_cd, "t");
			if(!AddUtil.replace(taecha.getCar_rent_et(),"-","").equals(fee_add.getRent_end_dt()) || !AddUtil.replace(taecha.getCar_rent_st(),"-","").equals(fee_add.getRent_start_dt())){
				fee_add.setRent_start_dt	(taecha.getCar_rent_st());
				fee_add.setRent_end_dt		(taecha.getCar_rent_et());
				boolean taecha_flag = a_db.updateContFeeAdd(fee_add);
			}
			
			//fee_etc
			ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
			if(base.getCar_gu().equals("1") && base.getRent_st().equals("3") && taecha.getCar_mng_id().equals(base.getCar_mng_id())){
				fee_etc.setSh_km		(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));		
				//=====[fee_etc] update=====
				flag5 = a_db.updateFeeEtc(fee_etc);
			}
		
		

			
			//if(fee.getFee_s_amt()>0 && !fee.getFee_chk().equals("1") && !fee.getPp_chk().equals("0")  ){
			
				//�뿩�ὺ���ٻ��� ��������
				
	
				String sub 	= "�������� �� �����ٻ���";
				String cont 	= "["+firm_nm+" "+rent_l_cd+"] �������� �� �����ٻ����� ��û�Ͽ��� Ȯ�ιٶ��ϴ�.";
	
				DocSettleBean doc = new DocSettleBean();
				doc.setDoc_st	("16");
				doc.setDoc_id	(rent_l_cd);
				doc.setSub	(sub);
				doc.setCont	(cont);
				doc.setEtc	(request.getParameter("etc")			==null?"":request.getParameter("etc"));
				
				if(fee.getFee_chk().equals("0")){
					doc.setEtc	("�뿩���Ͻÿϳ�");
				}
				if(fee.getPp_chk().equals("0") ){
					doc.setEtc	(doc.getEtc()+" ������ �ſ��յ����");
				}
								
				doc.setUser_nm1	("�����");
				doc.setUser_nm2	("�����ٻ�����");
				doc.setUser_nm3	("�ѹ�����");
				doc.setUser_id1	(user_id);
				doc.setUser_id2	(nm_db.getWorkAuthUser("�����ٻ�����"));
				doc.setUser_id3	("XXXXXX");
				doc.setDoc_bit	("1");	
				doc.setDoc_step	("1");//���
							
				doc.setVar01	(reg_type);
				doc.setSeq	(1);
				doc.setVar02	(request.getParameter("fee_est_day1")		==null?"":request.getParameter("fee_est_day1"));
				doc.setVar03	(request.getParameter("fee_pay_start_dt1")	==null?"":request.getParameter("fee_pay_start_dt1"));
				doc.setVar04	(request.getParameter("fee_pay_end_dt1")	==null?"":request.getParameter("fee_pay_end_dt1"));
				doc.setVar05	(request.getParameter("fee_fst_dt1")		==null?"":request.getParameter("fee_fst_dt1"));
				doc.setVar06	(request.getParameter("fee_fst_amt1")		==null?"":request.getParameter("fee_fst_amt1"));
				doc.setVar07	(request.getParameter("fee_lst_dt1")		==null?"":request.getParameter("fee_lst_dt1"));
				doc.setVar08	(request.getParameter("fee_lst_amt1")		==null?"":request.getParameter("fee_lst_amt1"));
				doc.setVar09	(request.getParameter("fee_est_day2")		==null?"":request.getParameter("fee_est_day2"));
				doc.setVar10	(request.getParameter("fee_pay_start_dt2")	==null?"":request.getParameter("fee_pay_start_dt2"));
				doc.setVar11	(request.getParameter("fee_pay_end_dt2")	==null?"":request.getParameter("fee_pay_end_dt2"));
				doc.setVar12	(request.getParameter("fee_fst_dt2")		==null?"":request.getParameter("fee_fst_dt2"));
				doc.setVar13	(request.getParameter("fee_fst_amt2")		==null?"":request.getParameter("fee_fst_amt2"));
				doc.setVar14	(request.getParameter("fee_lst_dt2")		==null?"":request.getParameter("fee_lst_dt2"));
				doc.setVar15	(request.getParameter("fee_lst_amt2")		==null?"":request.getParameter("fee_lst_amt2"));
				doc.setVar16	(request.getParameter("fee_est_day3")		==null?"":request.getParameter("fee_est_day3"));
				doc.setVar17	(request.getParameter("fee_pay_start_dt3")	==null?"":request.getParameter("fee_pay_start_dt3"));
				doc.setVar18	(request.getParameter("fee_pay_end_dt3")	==null?"":request.getParameter("fee_pay_end_dt3"));
				doc.setVar19	(request.getParameter("fee_fst_dt3")		==null?"":request.getParameter("fee_fst_dt3"));
				doc.setVar20	(request.getParameter("fee_fst_amt3")		==null?"":request.getParameter("fee_fst_amt3"));
				doc.setVar21	(request.getParameter("fee_lst_dt3")		==null?"":request.getParameter("fee_lst_dt3"));
				doc.setVar22	(request.getParameter("fee_lst_amt3")		==null?"":request.getParameter("fee_lst_amt3"));
				
				
				br_id = sender_bean.getBr_id();
				
				if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){
					
				}else{
					doc.setUser_id2	(nm_db.getWorkAuthUser("�λ꽺���ٻ�����"));
				}
				
				
				//�����ٴ���� �ް�üũ
				CarScheBean cs_bean = csd.getCarScheTodayBean(doc.getUser_id2());
				
				if(!cs_bean.getUser_id().equals("")){
					if(cs_bean.getWork_id().equals("")){
						if(br_id.equals("S1")||br_id.equals("S2")||br_id.equals("I1")||br_id.equals("K3")||br_id.equals("S3")||br_id.equals("S4")||br_id.equals("S5")||br_id.equals("S6")){
							doc.setUser_id2	(nm_db.getWorkAuthUser("�λ꽺���ٻ�����"));						
						}else{
							doc.setUser_id2	(nm_db.getWorkAuthUser("�����ٻ�����"));							
						}
					}else{
						
						if(!cs_bean.getUser_id().equals("")){
							if(cs_bean.getTitle().equals("��������")){
								//��Ͻð��� ����(12����)�̶�� ��ü��
								if(AddUtil.getTimeAM().equals("����")){
								  doc.setUser_id2	(cs_bean.getWork_id()); //������ü��									
								}								
							}else if(cs_bean.getTitle().equals("���Ĺ���")){
								//��Ͻð��� ����(12������)��� ��ü��
								if(AddUtil.getTimeAM().equals("����")){				
								  doc.setUser_id2	(cs_bean.getWork_id()); //������ü��									
								}
							}else{//����
								doc.setUser_id2	(cs_bean.getWork_id()); //������ü�� 								
							}
						}	
																		
					}
				}				
			
			
			
				//���ڰ���̸鼭 ������ 1ȸ���������ڰ� ������ 1ȸ���������� ������ ��� ������� �ʿ�
				//if(reg_type.equals("2") && AddUtil.parseInt(AddUtil.replace(doc.getVar12(),"-","")) < AddUtil.parseInt(AddUtil.replace(doc.getVar19(),"-","")) ){
				//	doc.setUser_id3	(nm_db.getWorkAuthUser("�����ѹ�����"));				
				//}
			
			
				//=====[doc_settle] insert=====
				flag6 = d_db.insertDocSettle(doc);
			
			
				DocSettleBean o_doc = d_db.getDocSettleCommi("16", rent_l_cd);							
			
				doc.setDoc_no	(o_doc.getDoc_no());
			
				//=====[doc_settle_var] insert=====
				flag6 = d_db.insertDocSettleVar(doc);
			
			
			
				String url 		= "/fms2/lc_rent/lc_start_doc.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|doc_no="+o_doc.getDoc_no();
			
			
				target_bean 	= umd.getUsersBean(doc.getUser_id2());
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
  				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
				//�޴»��
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	
				//�������
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
	
				flag6 = cm_db.insertCoolMsg(msg);
				
				//20150616 �������� ����
				if(!reg_type.equals("3")){
				
					
			
					//�����뿩������ �뿩Ƚ�� �ִ밪
					int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);
					max_fee_tm = 0; //���������̶� �ʿ����.
					
					
					int fee_pay_tm = 0;
					
					if(pere_r_mth>0)		fee_pay_tm = t_con_mon - pere_r_mth;
					else 								fee_pay_tm = t_con_mon;	
					
		
					//1ȸ�� �ݾ�
					int f_fee_amt		= AddUtil.parseInt(AddUtil.replace(doc.getVar06(),",",""));
					//1ȸ�� ������
					String f_use_s_dt 	= fee.getRent_start_dt();
					//1ȸ�� ��������
					String f_use_e_dt 	= doc.getVar05();
					//������ȸ�� �ݾ�
					int l_fee_amt		= AddUtil.parseInt(AddUtil.replace(doc.getVar08(),",",""));
					//������ȸ�� ������
					String l_est_dt  	= doc.getVar07();
					//���ڰ�곻��
					String f_etc = request.getParameter("fee_fst_amt1_etc")==null?"":request.getParameter("fee_fst_amt1_etc");
					String l_etc = request.getParameter("fee_lst_amt1_etc")==null?"":request.getParameter("fee_lst_amt1_etc");
					
					if(reg_type.equals("2")){
						f_use_e_dt 	= doc.getVar19();
						f_fee_amt	= AddUtil.parseInt(AddUtil.replace(doc.getVar20(),",",""));
						l_fee_amt	= AddUtil.parseInt(AddUtil.replace(doc.getVar22(),",",""));						
						l_est_dt 	= doc.getVar21();
						f_etc = request.getParameter("fee_fst_amt3_etc")==null?"":request.getParameter("fee_fst_amt3_etc");
						l_etc = request.getParameter("fee_lst_amt3_etc")==null?"":request.getParameter("fee_lst_amt3_etc");
					}
					
					//2ȸ�� �ǽ�����
					String t_use_s_dt 	= c_db.addDay(f_use_e_dt, 1);
					
					//�������հ�					
					int r_t_fee_s_amt		= 0;
					int r_t_fee_v_amt		= 0;

					//�Ѵ뿩��
					int t_fee_amt			= (fee.getFee_s_amt()+fee.getFee_v_amt()) * fee_pay_tm;
					int t_fee_s_amt			= fee.getFee_s_amt() * fee_pay_tm;
					int t_fee_v_amt			= t_fee_amt - t_fee_s_amt;
					
					
					
					//���� ������
					String use_e_dt 	= c_db.addMonth(fee.getRent_start_dt(), fee_pay_tm);	
					
					
					
					String r_use_end_dt = "";
					String req_fst_dt = c_db.minusDay(f_use_e_dt, 15);
					int count1 = 0;
					
					
					
					//������ ����----------------------------------------------------------------------
		
					for(int i = max_fee_tm ; i < fee_pay_tm+max_fee_tm ; i++){
						
						FeeScdBean fee_scd = new FeeScdBean();
						fee_scd.setRent_mng_id		(rent_mng_id);
						fee_scd.setRent_l_cd		(rent_l_cd);
						fee_scd.setFee_tm		(String.valueOf(i+1));			
						fee_scd.setRent_st		("1");
						fee_scd.setTm_st2		("0");					//0-�Ϲݴ뿩�� (1-ȸ������)							
						fee_scd.setRent_seq		("1");					//����û���Ϸù�ȣ									
						fee_scd.setTm_st1		("0");					//0-���뿩�� (1~�ܾ�)						
						fee_scd.setUpdate_id		(user_id);
						
						//1ȸ��---------------------------------------------------------------------------------------------
						if(i == max_fee_tm){			
							fee_scd.setUse_s_dt	(f_use_s_dt);				//1ȸ�� ���Ⱓ ������
							fee_scd.setUse_e_dt	(f_use_e_dt);				//1ȸ�� ���Ⱓ ������
							fee_scd.setFee_est_dt	(fee_scd.getUse_e_dt());		//1ȸ�� ������				
							fee_scd.setFee_s_amt	(af_db.getSupAmt(f_fee_amt));		//1ȸ�� �뿩��							
							fee_scd.setFee_v_amt	(f_fee_amt-fee_scd.getFee_s_amt());				//1ȸ�� �뿩��
							fee_scd.setEtc				(f_etc);
							
						}else{						
							//2ȸ�� �Ⱓ�������� ��ȸ�� �������� �Ѵ�.
							fee_scd.setUse_s_dt	(c_db.addDay(r_use_end_dt, 1));				
							fee_scd.setUse_e_dt	(c_db.addMonth(f_use_e_dt, count1));
							fee_scd.setFee_est_dt	(fee_scd.getUse_e_dt());		//������				
							fee_scd.setFee_s_amt	(fee.getFee_s_amt());			//�뿩��
							fee_scd.setFee_v_amt	(fee.getFee_v_amt());			//�뿩��
							
							String s_cng_dt 	= AddUtil.replace(fee_scd.getFee_est_dt(),"-",""); 
							int i_cng_yy 		= AddUtil.parseInt(s_cng_dt.substring(0,4));
							int i_cng_mm 		= AddUtil.parseInt(s_cng_dt.substring(4,6));
							int i_cng_dd 		= AddUtil.parseInt(s_cng_dt.substring(6,8));							
							int i_max_dd 		= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
										
							if(fee.getFee_est_day().equals("99")){//����						
								fee_scd.setFee_est_dt			(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
							}else{
								if(AddUtil.parseInt(fee.getFee_est_day()) < i_cng_dd ){
									fee_scd.setFee_est_dt		(s_cng_dt.substring(0,6)+""+AddUtil.addZero(fee.getFee_est_day()));	
								}
							}								
							
							//������ȸ���̸�
							if(i == (fee_pay_tm+max_fee_tm-1)){						
								fee_scd.setUse_e_dt	(use_e_dt);					
								fee_scd.setFee_est_dt	(l_est_dt);			//������				
								fee_scd.setFee_s_amt	(t_fee_s_amt-r_t_fee_s_amt);
								fee_scd.setFee_v_amt	(t_fee_v_amt-r_t_fee_v_amt);
								fee_scd.setEtc				(l_etc);
							}
						
						}
						
						
						fee_scd.setTax_out_dt					(fee_scd.getFee_est_dt());
						fee_scd.setR_fee_est_dt					(af_db.getValidDt(fee_scd.getFee_est_dt()));
						fee_scd.setReq_dt					(c_db.addMonth(req_fst_dt, count1));
						fee_scd.setR_req_dt					(af_db.getValidDt(fee_scd.getReq_dt()));
						
						r_t_fee_s_amt 		= r_t_fee_s_amt + fee_scd.getFee_s_amt();
						r_t_fee_v_amt 		= r_t_fee_v_amt + fee_scd.getFee_v_amt();						
						
						//�ϼ�
						int max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(fee_scd.getUse_s_dt(), fee_scd.getUse_e_dt()));
						
						
						
						//������ȸ���̸�
						if(i > max_fee_tm && i == (fee_pay_tm+max_fee_tm-1)){


			
					
							if(fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
								fee_scd.setFee_est_dt			(fee_scd.getUse_e_dt());
								fee_scd.setTax_out_dt			(fee_scd.getUse_e_dt());
								fee_scd.setR_fee_est_dt			(af_db.getValidDt(fee_scd.getFee_est_dt()));
							}
				
							//20121101 �뿩������(���������Ⱓ������)���� �Աݿ������� �� �������� ����.   use_e_dt > fee_est_dt
							if(max_tm_add_l_use_days <= 40 ){
								if(fee.getIfee_s_amt()==0 && AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
									fee_scd.setFee_est_dt		(fee_scd.getUse_e_dt());
									fee_scd.setTax_out_dt		(fee_scd.getUse_e_dt());
									fee_scd.setR_fee_est_dt		(af_db.getValidDt(fee_scd.getFee_est_dt()));
								}
							}
				
							//if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
								if(max_tm_add_l_use_days > 15 ){								
									fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -15));
								}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
									fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -10));
								}else{
									fee_scd.setReq_dt		(c_db.addDay(fee_scd.getUse_e_dt(), -5));
								}
								fee_scd.setR_req_dt			(fee_scd.getReq_dt());
							//}
				
				
						}
			
						//�ŷ����� �������ڰ� ȸ���� �����Ϻ��� ������ ����.
						if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_s_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
							fee_scd.setReq_dt		(fee_scd.getUse_s_dt());
							fee_scd.setR_req_dt	(fee_scd.getReq_dt());
						}
			
			
						
			
						if(!af_db.insertFeeScdEst(fee_scd, o_doc.getDoc_no())) flag4 += 1;						
						
						
						
						//������ȸ�� ���Ⱓ�� 1���̻��϶� ������
						if(i == (fee_pay_tm+max_fee_tm-1) && max_tm_add_l_use_days > 40 ){
			
			
								FeeScdBean add_fee_scd = fee_scd;
																		
												
								int add_fee_s_amt = fee_scd.getFee_s_amt()-fee.getFee_s_amt();
								int add_fee_v_amt = fee_scd.getFee_v_amt()-fee.getFee_v_amt();
						
						
								//������ȸ�������� ��������-----------------------------------------------------
						
								//�Ⱓ�������� ��ȸ�� �������� �Ѵ�.
								fee_scd.setUse_s_dt			(c_db.addDay(r_use_end_dt, 1));
								fee_scd.setUse_e_dt			(c_db.addMonth(f_use_e_dt, count1));
								fee_scd.setFee_est_dt		(fee_scd.getUse_e_dt());		//������				
								fee_scd.setFee_s_amt		(fee.getFee_s_amt());
								fee_scd.setFee_v_amt		(fee.getFee_v_amt());
								
								String s_cng_dt 	= AddUtil.replace(fee_scd.getFee_est_dt(),"-",""); 
								int i_cng_yy 		= AddUtil.parseInt(s_cng_dt.substring(0,4));
								int i_cng_mm 		= AddUtil.parseInt(s_cng_dt.substring(4,6));
								int i_cng_dd 		= AddUtil.parseInt(s_cng_dt.substring(6,8));							
								int i_max_dd 		= AddUtil.getMonthDate(i_cng_yy, i_cng_mm);
										
								if(fee.getFee_est_day().equals("99")){//����						
									fee_scd.setFee_est_dt			(s_cng_dt.substring(0,6)+""+String.valueOf(i_max_dd));
								}else{
									if(AddUtil.parseInt(fee.getFee_est_day()) < i_cng_dd ){
										fee_scd.setFee_est_dt		(s_cng_dt.substring(0,6)+""+AddUtil.addZero(fee.getFee_est_day()));	
									}
								}		
								fee_scd.setTax_out_dt			(fee_scd.getFee_est_dt());
								fee_scd.setR_fee_est_dt		(af_db.getValidDt(fee_scd.getFee_est_dt()));
								fee_scd.setReq_dt					(c_db.addMonth(req_fst_dt, count1));
								fee_scd.setR_req_dt				(fee_scd.getReq_dt());
								
								//�ŷ����� �������ڰ� ȸ���� �����Ϻ��� ������ ����.
								if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_s_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(fee_scd.getReq_dt(),"-",""))){
									fee_scd.setReq_dt		(fee_scd.getUse_s_dt());
									fee_scd.setR_req_dt	(fee_scd.getReq_dt());
								}
								fee_scd.setEtc				("");
								
								
						
								if(!af_db.updateFeeScdEst(fee_scd)) flag4 += 1;
						
																					
											
								//������ȸ�� 1���̻�� �߰�����-----------------------------------------------------
						
								add_fee_scd.setFee_tm				(String.valueOf(i+2));
								add_fee_scd.setUse_s_dt			(c_db.addDay(fee_scd.getUse_e_dt(), 1));
								add_fee_scd.setUse_e_dt			(use_e_dt);
												
								add_fee_scd.setFee_est_dt		(add_fee_scd.getUse_e_dt());
								add_fee_scd.setTax_out_dt		(add_fee_scd.getFee_est_dt());
								add_fee_scd.setR_fee_est_dt		(af_db.getValidDt(add_fee_scd.getFee_est_dt()));
								add_fee_scd.setFee_s_amt		(add_fee_s_amt);
								add_fee_scd.setFee_v_amt		(add_fee_v_amt);
						
								add_fee_scd.setReq_dt				(c_db.addMonth(req_fst_dt, count1+1));
								add_fee_scd.setR_req_dt			(af_db.getValidDt(add_fee_scd.getReq_dt()));
								add_fee_scd.setEtc					(l_etc);
								
								max_tm_add_l_use_days = AddUtil.parseInt(rs_db.getDay(add_fee_scd.getUse_s_dt(), add_fee_scd.getUse_e_dt()));
								
								//if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_e_dt(),"-","")) < AddUtil.parseInt(AddUtil.replace(add_fee_scd.getReq_dt(),"-",""))){
									if(max_tm_add_l_use_days > 15 ){								
										add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -15));
									}else if(max_tm_add_l_use_days < 15 && max_tm_add_l_use_days > 10 ){		
										add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -10));
									}else{
										add_fee_scd.setReq_dt		(c_db.addDay(add_fee_scd.getUse_e_dt(), -5));
									}	
									add_fee_scd.setR_req_dt		(add_fee_scd.getReq_dt());
								//}

								//�ŷ����� �������ڰ� ȸ���� �����Ϻ��� ������ ����.
								if(AddUtil.parseInt(AddUtil.replace(add_fee_scd.getUse_s_dt(),"-","")) > AddUtil.parseInt(AddUtil.replace(add_fee_scd.getReq_dt(),"-",""))){
									add_fee_scd.setReq_dt		(add_fee_scd.getUse_s_dt());
									add_fee_scd.setR_req_dt	(add_fee_scd.getReq_dt());
								}

						
								if(!af_db.insertFeeScdEst(add_fee_scd, o_doc.getDoc_no())) flag4 += 1;
						
						
												
				
				
						}
						
						
						r_use_end_dt 		= fee_scd.getUse_e_dt();
						count1++;
						
						
						//out.println((i+1)+"ȸ�� �����ٻ���---------------");						
						//out.println("fee_scd.getFee_s_amt()	= "+fee_scd.getFee_s_amt());
						//out.println("fee_scd.getFee_v_amt()	= "+fee_scd.getFee_v_amt());
						//out.println("fee_scd.getUse_s_dt()	= "+fee_scd.getUse_s_dt());
						//out.println("fee_scd.getUse_e_dt()	= "+fee_scd.getUse_e_dt());
						//out.println("fee_scd.getFee_est_dt()	= "+fee_scd.getFee_est_dt());
						//out.println("fee_scd.getReq_dt()	= "+fee_scd.getReq_dt());
						//out.println("fee_scd.getTax_out_dt()	= "+fee_scd.getTax_out_dt());
						//out.println("------------------------------------<br>");
																					
					}																								
				
				}
								
				
			//}
			
			//=====[fee] update=====
			flag1 = a_db.updateContFeeNew(fee);

			//=====[cont] update=====
			flag2 = a_db.updateContBaseNew(base);
			
			
			
			//������ ��������� ���� ���� �߼��Ѵ�. : 20100716
				
		
			//��� ����� ���� ���� ����
			Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
		
			Hashtable cont_view = a_db.getContViewCase(rent_mng_id, rent_l_cd);
		
			target_bean 		= umd.getUsersBean(base.getBus_id2());
			bus_target_bean = umd.getUsersBean(base.getBus_id());			
	
			if(!rent_l_cd.equals("S214KK7R00045") && !base.getBus_id2().equals("000026") && !base.getBus_id2().equals("000005") && !base.getBus_id2().equals("000144")){//��������,��������,ä�Ǵ��
		
				
				if(!base.getCar_mng_id().equals("")){
					cr_bean = crd.getCarRegBean(base.getCar_mng_id());
				}
			
				String s_destphone = String.valueOf(sms.get("TEL"))==null?"":String.valueOf(sms.get("TEL"));
				String s_destname = String.valueOf(sms.get("NM"))==null?"":String.valueOf(sms.get("NM"));
				
				if(s_destphone.equals("null")) 	s_destphone = "";
				if(s_destname.equals("null")) 	s_destname = "";
			
				String ins_name = "";
				ins_name = ai_db.getInsComNm(base.getCar_mng_id() );
			
				String ins_tel ="";
				if ( ins_name.equals("�Ｚȭ��") ) {
			    		ins_tel = " 1588-5114 ";
				} else if  ( ins_name.equals("����ȭ��") || ins_name.equals("DB���غ���") ) {
			    		ins_tel = " 1588-0100 ";
			     	} else if  ( ins_name.equals("����ī��������") ) {	
			    		ins_tel = " 1661-7977 ";	
				}
			
				String cont_sms 	= String.valueOf(cont_view.get("FIRM_NM")) +" ���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�.\n\n�뿩�Ͻ� "+ cr_bean.getCar_no() + "������ �뿩��� �������� " + String.valueOf(cont_view.get("RENT_START_DT")) + " �̸�, ���� �ڵ������� ����ڴ� " + target_bean.getUser_nm() + ", "+ target_bean.getUser_m_tel() + " �Դϴ�.\n\n(��)�Ƹ���ī "; 
				
				String cont_sms1 	= String.valueOf(cont_view.get("FIRM_NM")) +" ���� �ȳ��Ͻʴϱ�, �Ƹ���ī�Դϴ�.\n\n������ �뿩 �ڵ��� ������ "+ ins_name + " "  + ins_tel + " �̸�,  ����⵿ ���񽺴� ����Ÿ����⵿ 1588-6688, SK��Ʈ���� 1670-5494 �Դϴ�. ��Ÿ �̿��� �����Ͻ� ������ ���� �ڵ������� ����� " + target_bean.getUser_nm() + "("+ target_bean.getUser_m_tel() + ")�� ��� �ٶ��ϴ�.\n\n(��)�Ƹ���ī "; 
						
									
				if(!s_destphone.equals("")){	
			
					//201411 �뿩������ +3�Ͽ� �����°����� �����Ѵ�.
					String msg_type 	= "5";
					String msg_subject 	= "�뿩���þȳ�";
					String req_time 	= AddUtil.getDate(4);
					String rqdate 		= "";									
					req_time 		= rs_db.addDay(req_time, 3);				
					req_time 		= AddUtil.replace(af_db.getValidDt(req_time),"-","")+"100101";																			
							
					msg_subject 	= "����� ����⵿�ȳ�";
					//������ ����⵿ ���ڸ޼���
			
					//�˸��� acar0044 �뿩���þȳ�
					String customer_name 	= String.valueOf(cont_view.get("FIRM_NM"));				// ���̸�
					String car_num 				= cr_bean.getCar_no();														// ������ȣ
					String contract_s_date= String.valueOf(cont_view.get("RENT_START_DT"));	// ��� ������
					String manager_name 	= target_bean.getUser_nm();												// ����� �̸�
					String manager_phone 	= target_bean.getUser_m_tel();										// ����� ��ȭ

					// ����� �̸�(����)
					String bus_manager_name = bus_target_bean.getUser_nm();
					// ����� ��ȭ(����)
					String bus_manager_phone = bus_target_bean.getUser_m_tel();
					
					// ���ռ��� �ȳ��� url
					String full_url = "http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id=" + rent_mng_id + "&l_cd=" + rent_l_cd + "&rent_st=";			
					String schedule_url = ShortenUrlGoogle.getShortenUrl(full_url);
					
					String etc1 = rent_l_cd;
					String etc2 = ck_acar_id;
					
					//acar0044 -> acar0081 (��������) -> acar0115 (��������) -> acar0141 (��������) -> acar0211 (��������)
					//List<String> fieldList = Arrays.asList(customer_name, car_num, contract_s_date, manager_name, manager_phone);
					List<String> fieldList = Arrays.asList(customer_name, car_num, contract_s_date, bus_manager_name, bus_manager_phone, manager_name, manager_phone, schedule_url);
					at_db.sendMessageReserve("acar0211", fieldList, s_destphone, manager_phone, req_time, etc1, etc2);
	
					//�˸��� acar0046 ����� ����⵿�ȳ�
					String customer_name2 = String.valueOf(cont_view.get("FIRM_NM"));				// ���̸�
					String insurance_name2= ins_name + " (" + ins_tel + ")";								// ����� �̸�
					String manager_name2 	= target_bean.getUser_nm();	                // ����� �̸�
					String manager_phone2 	= "("+ target_bean.getUser_m_tel() + ")";	// ����� ����ó
					String callbackNum = target_bean.getUser_m_tel();
					String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";								// ����⵿
					
					String marster_car_num = "1588-6688"; //������ �ڵ��� ����ó
					String sk_net_num = "1670-5494"; //sk��Ʈ���� ����ó
					
					String url_1 = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
					String sos_url = ShortenUrlGoogle.getShortenUrl(url_1);					
					
					//acar0046 -> acar0092 (��������) -> acar0113 (�ִ�ī����) -> acar0156 -> acar0231 (��������)
					/* List<String> fieldList2 = Arrays.asList(customer_name2, insurance_name2, sos_service_info, manager_name2, manager_phone2);
					at_db.sendMessageReserve("acar0113", fieldList2, s_destphone, callbackNum, req_time , etc1,  etc2); */
					List<String> fieldList2 = Arrays.asList(customer_name2, car_num, insurance_name2, marster_car_num, sk_net_num, manager_name2, manager_phone2, sos_url);
					at_db.sendMessageReserve("acar0231", fieldList2, s_destphone, callbackNum, req_time , etc1,  etc2);
					
				}
			}
			
			
				//�������� �̹��� ������Ʈ ���������ڿ��� �޽��� �߼�		
							
				//����ý��� �������� �̹����� Ȯ��
				Vector rs_conts = rs_db.getTarchaNoRegSearchList(base.getClient_id());
				int rs_cont_size = rs_conts.size();
				
				//����ý��� �������� �̹����� Ȯ�� : ��࿬����
				Vector rs_conts2 = rs_db.getTarchaNoRetSearchList(base.getRent_l_cd());
				int rs_cont_size2 = rs_conts2.size();					
				
				if(rs_cont_size+rs_cont_size2>0){
				
					UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����"));
					UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����2"));
					//UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����3"));
					
					String sub2 	= "�������� �� �����ٻ��� : �������� �̹���";
					String cont2 	= "["+firm_nm+" "+rent_l_cd+"]  &lt;br&gt; &lt;br&gt; �������� �� �����ٻ����� ��û�Ͽ����ϴ�.  &lt;br&gt; &lt;br&gt; �������� �̹����� ������ Ȯ���Ͻʽÿ�.";
					
					if(base.getBus_st().equals("7")){
						cont2 	= "["+firm_nm+" "+rent_l_cd+"]  &lt;br&gt; &lt;br&gt; �������� �� �����ٻ����� ��û�Ͽ����ϴ�.  &lt;br&gt; &lt;br&gt; ������Ʈ��� �������� �̹����� ������ Ȯ���Ͻʽÿ�.";
					}
					
					String xml_data2 = "";
					xml_data2 =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub2+"</SUB>"+
	  				"    <CONT>"+cont2+"</CONT>"+
 						"    <URL></URL>";
 							
					if(base.getBus_st().equals("7")){
						xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
						xml_data2 += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
						//xml_data2 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
					}else{
						target_bean2 	= umd.getUsersBean(base.getBus_id());
						xml_data2 += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					}
						
					xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
					CdAlertBean msg2 = new CdAlertBean();
					msg2.setFlddata(xml_data2);
					msg2.setFldtype("1");
					flag3 = cm_db.insertCoolMsg(msg2);
					
				}
			
			
		}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�뿩���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');			<%		}	%>		
<%		if(!flag2){	%>	alert('���⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
<%		if(!flag3){	%>	alert('����Ÿ���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
</script>




<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 			value="">
  <input type="hidden" name="c_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;		
	fm.rent_st.value = '1';
	fm.c_st.value = 'fee';
	fm.action = '/agent/lc_rent/lc_c_frame.jsp';	
	fm.target = 'd_content';
	fm.submit();
	

</script>
</body>
</html>