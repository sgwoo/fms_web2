<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*,  tax.*, acar.car_sche.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, acar.user_mng.*, acar.ext.*,   acar.res_search.*, acar.client.*, acar.cont.*,  acar.car_register.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="cr_bean" 	scope="page" class="acar.car_register.CarRegBean"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String client_id   = "";
	String site_id		= "";
	
	String serv_tax_url = request.getParameter("serv_tax_url")==null?"":request.getParameter("serv_tax_url");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarRegDatabase crd 			= CarRegDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	int flag = 0;	
	int count = 0;	
	boolean flag2 = true;
	boolean flag6 = true;
	
/*
	System.out.println("[������]====================");
	System.out.println("c_id="+c_id+"=================");
	System.out.println("accid_id="+accid_id+"=========");
	System.out.println("mode="+mode+"=================");
*/
	
	AccidentBean accid = as_db.getAccidentBean(c_id, accid_id);
	accid.setUpdate_dt(AddUtil.getDate());
	accid.setUpdate_id(user_id);//������
	
	if(mode.equals("0")){//��� ����
		accid.setAccid_st		(accid_st);
		accid.setAcc_dt			(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));//��������
		accid.setAcc_id			(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));//������
		accid.setSub_etc		(request.getParameter("sub_etc")==null?"":request.getParameter("sub_etc"));
		accid.setDam_type1		(request.getParameter("dam_type1")==null?"N":request.getParameter("dam_type1"));
		accid.setDam_type2		(request.getParameter("dam_type2")==null?"N":request.getParameter("dam_type2"));
		accid.setDam_type3		(request.getParameter("dam_type3")==null?"N":request.getParameter("dam_type3"));
		accid.setDam_type4		(request.getParameter("dam_type4")==null?"N":request.getParameter("dam_type4"));
		if(car_st.equals("2")){//������
			accid.setRent_s_cd	(request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd"));
			accid.setSub_rent_gu(request.getParameter("sub_rent_gu")==null?"":request.getParameter("sub_rent_gu"));
			accid.setSub_firm_nm(request.getParameter("sub_firm_nm")==null?"":request.getParameter("sub_firm_nm"));
			accid.setSub_rent_st(request.getParameter("sub_rent_st")==null?"":request.getParameter("sub_rent_st"));
			accid.setSub_rent_et(request.getParameter("sub_rent_et")==null?"":request.getParameter("sub_rent_et"));
			accid.setMemo		(request.getParameter("memo")==null?"":request.getParameter("memo"));
		}
		count = as_db.updateAccident(accid);
	}
	else if(mode.equals("1")){//����� ����
		String pre_cls = request.getParameter("pre_cls")==null?"N":request.getParameter("pre_cls");
		String h_accid_dt = request.getParameter("h_accid_dt")==null?"N":request.getParameter("h_accid_dt");
	
		accid.setAccid_type(request.getParameter("accid_type")==null?"":request.getParameter("accid_type"));//�������
		accid.setAccid_dt(request.getParameter("h_accid_dt")==null?"":request.getParameter("h_accid_dt"));//�������
		//if(!accid_st.equals("4")){//��������
			accid.setAccid_type_sub(request.getParameter("accid_type_sub")==null?"":request.getParameter("accid_type_sub"));//�������
			accid.setAccid_addr(request.getParameter("accid_addr")==null?"":request.getParameter("accid_addr"));//������
			accid.setAccid_cont(request.getParameter("accid_cont")==null?"":request.getParameter("accid_cont"));//������-��
			accid.setAccid_cont2(request.getParameter("accid_cont2")==null?"":request.getParameter("accid_cont2"));//������-���
			accid.setImp_fault_st(request.getParameter("imp_fault_st")==null?"":request.getParameter("imp_fault_st"));//�ߴ���ǿ���
			accid.setImp_fault_sub(request.getParameter("imp_fault_sub")==null?"":request.getParameter("imp_fault_sub"));//�ߴ���ǿ���-�󼼳���
			accid.setOur_fault_per(request.getParameter("our_fault_per")==null?0:AddUtil.parseDigit(request.getParameter("our_fault_per")));//���Ǻ���
		//}
		accid.setSpeed(request.getParameter("speed")==null?"":request.getParameter("speed"));//�ӵ�
		accid.setRoad_stat(request.getParameter("road_stat")==null?"1":request.getParameter("road_stat"));//���θ����
		accid.setRoad_stat2(request.getParameter("road_stat2")==null?"1":request.getParameter("road_stat2"));//���θ����
		accid.setWeather(request.getParameter("weather")==null?"1":request.getParameter("weather"));//����
		accid.setPre_cls(pre_cls);//������ ����ó�� ���� 
		
		count = as_db.updateAccident(accid);
		
		// ���������������ΰ�� �������忡�� �޼��� - 20190624		
		if ( pre_cls.equals("Y") && !accid.getSettle_st().equals("1") ) {
			
			  //����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
								
			String sub 	= "��� ���������� ����ó�� ���� ";
			String cont 	= "�� ��� ���������� ����ó�� ����  &lt;br&gt; &lt;br&gt; ����ȣ "+ l_cd+ " &lt;br&gt; &lt;br&gt;  ����Ͻ�:" + h_accid_dt ;  	
										
			String url 	=  "/acar/accid_mng/accid_s_frame.jsp";		 
				
			String target_id = nm_db.getWorkAuthUser("�����������");  
							
			//����� ���� ��ȸ
			UsersBean target_bean 	= umd.getUsersBean(target_id);
		
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	//		xml_data += "    <TARGET>2006007</TARGET>";
			
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
			
			flag2 = cm_db.insertCoolMsg(msg);
				
		}
						
		
	}
	else if(mode.equals("2")){//������ ����
//		if(gubun.equals("our")){
			accid.setOur_driver(request.getParameter("our_driver")==null?"":request.getParameter("our_driver"));
			accid.setOur_ssn(request.getParameter("our_ssn")==null?"":request.getParameter("our_ssn"));
			accid.setOur_lic_kd(request.getParameter("our_lic_kd")==null?"":request.getParameter("our_lic_kd"));
			accid.setOur_lic_no(request.getParameter("our_lic_no")==null?"":request.getParameter("our_lic_no"));
			accid.setOur_lic_dt(request.getParameter("our_lic_dt")==null?"":request.getParameter("our_lic_dt"));
			accid.setOur_car_nm(request.getParameter("our_car_nm")==null?"":request.getParameter("our_car_nm"));
			accid.setOur_tel(request.getParameter("our_tel")==null?"":request.getParameter("our_tel"));
			accid.setOur_tel2(request.getParameter("our_tel2")==null?"":request.getParameter("our_tel2"));
			accid.setOur_m_tel(request.getParameter("our_m_tel")==null?"":request.getParameter("our_m_tel"));
			accid.setOur_dam_st(request.getParameter("our_dam_st")==null?"":request.getParameter("our_dam_st"));
			accid.setOur_fault_per(request.getParameter("our_fault_per")==null?0:AddUtil.parseDigit(request.getParameter("our_fault_per")));//���Ǻ���
			accid.setOur_ins(request.getParameter("our_ins")==null?"":request.getParameter("our_ins"));
			accid.setOur_num(request.getParameter("our_num")==null?"":request.getParameter("our_num"));	
			accid.setHum_nm(request.getParameter("our_hum_nm")==null?"":request.getParameter("our_hum_nm"));
			accid.setHum_tel(request.getParameter("our_hum_tel")==null?"":request.getParameter("our_hum_tel"));
			accid.setMat_nm(request.getParameter("our_mat_nm")==null?"":request.getParameter("our_mat_nm"));
			accid.setMat_tel(request.getParameter("our_mat_tel")==null?"":request.getParameter("our_mat_tel"));
				
			
			count = as_db.updateAccident(accid);
//		}else if(gubun.equals("ot")){
		
			int size = request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
			int idx2 = request.getParameter("idx2")==null?0:AddUtil.parseInt(request.getParameter("idx2"));
			int no = 0;
			
			if(accid.getAccid_st().equals("1") || accid.getAccid_st().equals("2") || accid.getAccid_st().equals("3")){//����,�ֹ�
				String ot_seq_no[] = request.getParameterValues("seq_no");
				String ot_driver[] = request.getParameterValues("ot_driver");
				String ot_ssn[] = request.getParameterValues("ot_ssn");
				String ot_lic_no[] = request.getParameterValues("ot_lic_no");
				String ot_lic_kd[] = request.getParameterValues("ot_lic_kd");
				String ot_car_no[] = request.getParameterValues("ot_car_no");
				String ot_car_nm[] = request.getParameterValues("ot_car_nm");
				String ot_tel[] = request.getParameterValues("ot_tel");
//				String ot_tel2[] = request.getParameterValues("ot_tel2");
				String ot_m_tel[] = request.getParameterValues("ot_m_tel");
				String ot_dam_st[] = request.getParameterValues("ot_dam_st");
				String ot_ins[] = request.getParameterValues("ot_ins");
				String ot_num[] = request.getParameterValues("ot_num");
				String hum_nm[] = request.getParameterValues("ot_hum_nm");
				String hum_tel[] = request.getParameterValues("ot_hum_tel");
				String mat_nm[] = request.getParameterValues("ot_mat_nm");
				String mat_tel[] = request.getParameterValues("ot_mat_tel");
				String ot_fault_per[] = request.getParameterValues("ot_fault_per");
				
				int vid_size = ot_seq_no.length;
				if(cmd.equals("u")) 	vid_size = size;
				
				if(vid_size>0){
					for(int i=0;i < vid_size;i++){
						
						OtAccidBean oa_bean = as_db.getOtAccidBean(c_id, accid_id, ot_seq_no[i]);
						
						no = i;
						
						oa_bean.setOt_driver	(ot_driver[no]==null?"":ot_driver[no]);
						oa_bean.setOt_ssn		(ot_ssn[no]==null?"":ot_ssn[no]);
						oa_bean.setOt_lic_no	(ot_lic_no[no]==null?"":ot_lic_no[no]);
						oa_bean.setOt_lic_kd	(ot_lic_kd[no]==null?"":ot_lic_kd[no]);
						oa_bean.setOt_car_no	(ot_car_no[no]==null?"":ot_car_no[no]);
						oa_bean.setOt_car_nm	(ot_car_nm[no]==null?"":ot_car_nm[no]);
						oa_bean.setOt_tel		(ot_tel[no]==null?"":ot_tel[no]);
//						oa_bean.setOt_tel2		(ot_tel2[no]==null?"":ot_tel2[no]);
						oa_bean.setOt_m_tel		(ot_m_tel[no]==null?"":ot_m_tel[no]);
						oa_bean.setOt_dam_st	(ot_dam_st[no]==null?"":ot_dam_st[no]);
						oa_bean.setOt_ins		(ot_ins[no]==null?"":ot_ins[no]);
						oa_bean.setOt_num		(ot_num[no]==null?"":ot_num[no]);
						oa_bean.setHum_nm		(hum_nm[no]==null?"":hum_nm[no]);
						oa_bean.setHum_tel		(hum_tel[no]==null?"":hum_tel[no]);
						oa_bean.setMat_nm		(mat_nm[no]==null?"":mat_nm[no]);
						oa_bean.setMat_tel		(mat_tel[no]==null?"":mat_tel[no]);
						oa_bean.setOt_fault_per	(ot_fault_per[no]==null?0:AddUtil.parseDigit(ot_fault_per[no]));
						
						if(oa_bean.getCar_mng_id().equals("")){
							oa_bean.setCar_mng_id	(c_id);
							oa_bean.setAccid_id		(accid_id);
							oa_bean.setSeq_no		(AddUtil.parseDigit(ot_seq_no[no]));
							oa_bean.setReg_id		(user_id);
							count = as_db.insertOtAccid(oa_bean);
						}else{
							oa_bean.setUpdate_id	(user_id);
							count = as_db.updateOtAccid(oa_bean);
						}
					}
				}
			}
//		}
	}
	else if(mode.equals("3")){//����� ����
		
		accid.setOt_dam_st(request.getParameter("ot_dam_st")==null?"":request.getParameter("ot_dam_st"));
		accid.setOt_ins(request.getParameter("ot_ins")==null?"":request.getParameter("ot_ins"));
		accid.setOt_num(request.getParameter("ot_num")==null?"":request.getParameter("ot_num"));
		accid.setOne_nm(request.getParameter("one_nm")==null?"":request.getParameter("one_nm"));
		accid.setOne_tel(request.getParameter("one_tel")==null?"":request.getParameter("one_tel"));
		accid.setMy_nm(request.getParameter("my_nm")==null?"":request.getParameter("my_nm"));
		accid.setMy_tel(request.getParameter("my_tel")==null?"":request.getParameter("my_tel"));
		count = as_db.updateAccident(accid);
	}
	else if(mode.equals("4")){//������ ����
		accid.setOt_pol_st(request.getParameter("ot_pol_st")==null?"":request.getParameter("ot_pol_st"));
		accid.setOt_pol_sta(request.getParameter("ot_pol_sta")==null?"":request.getParameter("ot_pol_sta"));
		accid.setOt_pol_num(request.getParameter("ot_pol_num")==null?"":request.getParameter("ot_pol_num"));
		accid.setOt_pol_nm(request.getParameter("ot_pol_nm")==null?"":request.getParameter("ot_pol_nm"));
		accid.setOt_pol_tel(request.getParameter("ot_pol_tel")==null?"":request.getParameter("ot_pol_tel"));
		accid.setOt_pol_fax(request.getParameter("ot_pol_fax")==null?"":request.getParameter("ot_pol_fax"));
		count = as_db.updateAccident(accid);
	}
	else if(mode.equals("5")){//������� ����
		int size = request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
		int idx2 = request.getParameter("idx2")==null?0:AddUtil.parseInt(request.getParameter("idx2"));
		int no = 0;
		int ot_seq_no = 0;
		String seq_no[] = request.getParameterValues("seq_no");
		String nm[] = request.getParameterValues("o_nm");
		String sex[] = request.getParameterValues("o_sex");
		String hosp[] = request.getParameterValues("o_hosp");
		String hosp_tel[] = request.getParameterValues("o_hosp_tel");
		String tel[] = request.getParameterValues("o_tel");
		String age[] = request.getParameterValues("o_age");
		String relation[] = request.getParameterValues("o_relation");
		String diagnosis[] = request.getParameterValues("o_diagnosis");
		String one_accid_st[] = request.getParameterValues("o_accid_st");
		String wound_st[] = request.getParameterValues("o_wound_st");
		
		OneAccidBean oa_bean = new OneAccidBean();
		
		oa_bean.setCar_mng_id(c_id);
		oa_bean.setAccid_id(accid_id);
		if(cmd.equals("i") && size>0)			no = size;
		else if(cmd.equals("u") && idx2>0)		no = idx2;
		oa_bean.setSeq_no(no+1);
		oa_bean.setNm(nm[no]==null?"":nm[no]);
		oa_bean.setSex(sex[no]==null?"":sex[no]);
		oa_bean.setAge(age[no]==null?"":age[no]);
		oa_bean.setRelation(relation[no]==null?"":relation[no]);
		oa_bean.setTel(tel[no]==null?"":tel[no]);
		oa_bean.setHosp(hosp[no]==null?"":hosp[no]);
		oa_bean.setHosp_tel(hosp_tel[no]==null?"":hosp_tel[no]);
		oa_bean.setDiagnosis(diagnosis[no]==null?"":diagnosis[no]);
		oa_bean.setEtc("");
		oa_bean.setOne_accid_st(one_accid_st[no]==null?"":one_accid_st[no]);
		oa_bean.setWound_st(wound_st[no]==null?"":wound_st[no]);
		ot_seq_no = AddUtil.parseInt(one_accid_st[no])-1;
		oa_bean.setOt_seq_no(ot_seq_no);
		
		if(cmd.equals("i"))	count = as_db.insertOneAccid(oa_bean);
		else 				count = as_db.updateOneAccid(oa_bean);
	}
	else if(mode.equals("6")){//�������
		int size = request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
		int idx2 = request.getParameter("idx2")==null?0:AddUtil.parseInt(request.getParameter("idx2"));
		int no = 0;
		String seq_no[] = request.getParameterValues("seq_no");
		String serv_dt[] = request.getParameterValues("serv_dt");
		String off_nm[] = request.getParameterValues("off_nm");
		String off_tel[] = request.getParameterValues("off_tel");
		String off_fax[] = request.getParameterValues("off_fax");
		String serv_amt[] = request.getParameterValues("serv_amt");
		String serv_cont[] = request.getParameterValues("serv_cont");
//		String serv_nm[] = request.getParameterValues("serv_nm");
		
		no = idx2;
		
		OtAccidBean oa_bean = as_db.getOtAccidBean(c_id, accid_id, seq_no[no]);
		
		oa_bean.setServ_dt(serv_dt[no]==null?"":serv_dt[no]);
		oa_bean.setOff_nm(off_nm[no]==null?"":off_nm[no]);
		oa_bean.setOff_tel(off_tel[no]==null?"":off_tel[no]);
		oa_bean.setOff_fax(off_fax[no]==null?"":off_fax[no]);
		oa_bean.setServ_amt(serv_amt[no]==null?0:AddUtil.parseDigit(serv_amt[no]));
		oa_bean.setServ_cont(serv_cont[no]==null?"":serv_cont[no]);
//		oa_bean.setServ_nm(serv_cont[no]==null?"":serv_nm[no]);
		oa_bean.setReg_id(user_id);
		
		count = as_db.updateOtAccid(oa_bean);
		
	}
	else if(mode.equals("7")){//��å��
		int serv_flag = 0;
		
		String no_dft_yn = request.getParameter("no_dft_yn")==null?"":request.getParameter("no_dft_yn"); //��������
		String 	cust_req_dt =  request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"); //û������
		String 	sac_yn =  request.getParameter("sac_yn")==null?"":request.getParameter("sac_yn"); //�ݾ�Ȯ����û
		
		String 	fee_r_yn =  request.getParameter("fee_r_yn")==null?"":request.getParameter("fee_r_yn"); //�뿩�� ����Ͽ� �����û
		String 	cust_plan_dt =  request.getParameter("cust_plan_dt")==null?"":request.getParameter("cust_plan_dt"); //�Աݿ�����
			
		String 	bill_doc_yn = 	 request.getParameter("bill_doc_yn")==null?"":request.getParameter("bill_doc_yn"); //���ݰ�꼭 ���࿩�� 0:�̹���	, 3:�ŷ����� �̹���, 4: �ŷ��������� 		
		String 	saleebill_yn = 	 request.getParameter("saleebill_yn")==null?"":request.getParameter("saleebill_yn"); //�Ա�ǥ  ���࿩�� 0:�̹���			
					
		int cust_s_amt 	=  request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt")); //û�� ���ް�
		int cust_v_amt 	=  request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt")); //û�� �ΰ���
	
		int s_cnt = 0;
		s_cnt = a_csd.getService(c_id, accid_id, serv_id, "1");	 //��Ͽ���
		
		 //���:������
		ContBaseBean base 		= a_db.getContBaseAll(m_id, l_cd);
		
		if(cmd.equals("i") && s_cnt < 1 )	{  //��å�� ����
		    //car_mng_id �� ���� ��û�� ��å�� check - accid_id�� key�� �ƴ�.
		    serv_id=a_csd.getRealServId(c_id);	    
		    count = a_csd.insertService(c_id, accid_id, serv_id, m_id, l_cd, user_id );
		}	
			
		
		int c_amt = AddUtil.parseDigit(request.getParameter("cust_amt"));
		
		ServiceBean s_bean = a_csd.getService(c_id, accid_id, serv_id);
		
					
		// �⺻ + 15�� ->3�Ϸ� ���� (20211122)
		if (s_bean.getCust_plan_dt().equals("") ) {
			cust_plan_dt = a_csd.getCustPlanDt(cust_req_dt, 4);				
			System.out.println("��å�ݿ�������="+ l_cd+ ":" + cust_plan_dt);	
		} 		
		
		if (fee_r_yn.equals("Y") && s_bean.getCust_plan_dt().equals("") ) {  //�뿩�� ����Ͽ� ����	
			cust_plan_dt = a_csd.getCustPlanDt(cust_req_dt, c_id, m_id, l_cd,  accid_id);
			System.out.println("��å�ݴ뿩�ᳯ¥��û="+ l_cd+ ":" + cust_plan_dt);	
		}	
		
		if ( !cust_req_dt.equals("") && cust_plan_dt.equals("") ) {
			cust_plan_dt = cust_req_dt;  //û���Ϸ� 
		}
			
		int old_amt = s_bean.getCust_amt();
					
		s_bean.setCust_amt(request.getParameter("cust_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_amt")));
		s_bean.setCust_req_dt(request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"));
		if ( !cust_req_dt.equals("") && cust_plan_dt.equals("") ) {
			cust_plan_dt = cust_req_dt;  //û���Ϸ� 
		}		
		s_bean.setCust_plan_dt(cust_plan_dt); 
		s_bean.setCust_pay_dt(request.getParameter("cust_pay_dt")==null?"":request.getParameter("cust_pay_dt"));  //���������� �ԱݵȰ�� �Ա��ϸ� ������ �� ����.
		
		s_bean.setNo_dft_yn(no_dft_yn);//��������
		s_bean.setNo_dft_cau(request.getParameter("no_dft_cau")==null?"":request.getParameter("no_dft_cau"));//��������
		s_bean.setBill_doc_yn(bill_doc_yn);  //���ݰ�꼭 ���࿩�� 0:�̹���
		s_bean.setSaleebill_yn(saleebill_yn);  //�Ա�ǥ  ���࿩�� 0:�̹���
		s_bean.setBill_mon(request.getParameter("bill_mon")==null?"":request.getParameter("bill_mon"));		
		s_bean.setUpdate_id(user_id);//������
		s_bean.setUpdate_dt(AddUtil.getDate());//��������
		s_bean.setExt_amt(request.getParameter("ext_amt")==null?0:AddUtil.parseDigit(request.getParameter("ext_amt"))); //���Աݾ�
		s_bean.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_s_amt"))); //��������� ���Աݾ�
		s_bean.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_v_amt"))); //��������� ���Աݾ�
		s_bean.setCls_amt(request.getParameter("cls_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_amt"))); //��������� ���Աݾ�
		s_bean.setCust_s_amt(request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt"))); //û�� ���ް���
		s_bean.setCust_v_amt(request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt"))); //û�� �ΰ�����
		s_bean.setExt_cau(request.getParameter("ext_cau")==null?"":request.getParameter("ext_cau"));//���Աݳ���
		s_bean.setSac_yn(sac_yn);//
		s_bean.setPaid_st(request.getParameter("paid_st")==null?"":request.getParameter("paid_st"));  //û������  2:��Ÿ 
		s_bean.setPaid_type(request.getParameter("paid_type")==null?"":request.getParameter("paid_type"));  //���ݹ��    1:cms  2:������ 
		s_bean.setBus_id2(request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2"));  // ������� 
		s_bean.setAgnt_email(request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email"));  // 
				
		if ( sac_yn.equals("Y")  && s_bean.getSac_dt().equals("")  )  {  //�ݾ�Ȯ����û
				s_bean.setSac_dt(AddUtil.getDate());// �ű��̸鼭 ��å�� û���ݾ��� �ִ� ��� ��꼭������ �ȵǴ� ���ΰ��	- 20120906
		}
							
		if(!serv_id.equals("")){		
			count = a_csd.updateService(s_bean);
		}	
				
		// �ι���ī �������� ������ ��û���� ����
		if (  c_id.equals("005938") && accid_id.equals("014279") ) {
		
		} else {
		    //��å�� �ݾ� Ȯ�� ���� ����ڿ��� �޼��� ����  -> �ݾ� Ȯ�� �� ��꼭 ���� ���� Ȯ��  - ��꼭����ǿ� ���ؼ�20120906 - 20160309:�ѹ����� �ٷ� ��꼭 �����û
		      
			  			
			 //�ŷ����� �����û  - ��å�� û���ݾ��� �ִ� ��츸 ���� 
			 if (sac_yn.equals("Y") && cmd.equals("i")  &&  bill_doc_yn.equals("4") && c_amt > 0  ) {
			 				 	  
					 //�ڵ�������
						cr_bean = crd.getCarRegBean(c_id);						
						
						if(base.getTax_type().equals("2")){//����
							site_id = base.getR_site();
						}else{
							site_id = "";
						}
						
						client_id = base.getClient_id() ;
						 //�����ΰ��  
					    if ( !accid.getRent_s_cd().equals("") ) {
					    	   
					    	  
					    	 //�ܱ�������
					    		RentContBean rc_bean = rs_db.getRentContCase(accid.getRent_s_cd(), c_id);	
					    		//������
					    		RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());	
					    		
					    		client_id = rc_bean2.getCust_id();	
					    		System.out.println("����===" + accid.getRent_s_cd());
					    		System.out.println("client_id===" + rc_bean2.getCust_id());
					    }
							
						//�ŷ�ó����
						ClientBean client = al_db.getClient(client_id);
						ClientSiteBean site = null; 
						if(!site_id.equals("")){
							//�ŷ�ó��������
							site = al_db.getClientSite(client_id, site_id);
							if(site.getEnp_no().equals("")){
								site_id = "";
							}
						}
												
				//		int flag = 0;
						TaxItemListBean til_bean = new TaxItemListBean();
						
						//String item_id = "";
						String item_id = request.getParameter("item_id")==null?"":request.getParameter("item_id");
						String reg_code  = Long.toString(System.currentTimeMillis());								
																				
						//20161227 ���� tax_item ������ ��� 
						if(item_id.equals("") ){ //�ش������ ó�� ����� 
								//�����ڵ� ��������
							
							out.println("��å�� �����ڵ�="+reg_code+"<br>");
							
							//����� item_id ��������
							item_id = IssueDb.getItemIdNext(s_bean.getCust_req_dt());
							out.println("item_id="+item_id+"<br><br>");
														
							til_bean.setItem_id			(item_id);
							til_bean.setItem_seq		(1);
							til_bean.setItem_g			("��å��");
							til_bean.setItem_car_no	(cr_bean.getCar_no());
							til_bean.setItem_car_nm	(cr_bean.getCar_nm());
							til_bean.setItem_dt1		("");
							til_bean.setItem_dt2		("");
							til_bean.setItem_supply	(s_bean.getCust_amt());
							til_bean.setItem_value	(0);
							til_bean.setRent_l_cd		(l_cd);
							til_bean.setCar_mng_id	(c_id);
							til_bean.setTm					(serv_id);
							til_bean.setGubun				("7");
							til_bean.setReg_id			(s_bean.getBus_id2());
							til_bean.setReg_code		(reg_code);
							til_bean.setItem_dt			(s_bean.getCust_req_dt());
							til_bean.setCar_use		(cr_bean.getCar_use());
							til_bean.setEtc				(AddUtil.getDate3((accid.getAccid_dt()).substring(0,8))+" ���");
												
							if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
							//gubun = 1 �뿩��, 2 ������, 3 ������, 4 ���ô뿩��, 5 �����, 6 �����Ű����, 7 ��å�� , 8 ���·�, 9 self, 10 �������, 11 ������, 12 ������, 13 �����뿩 
												
							//20161226 ���Ϲ߼۱���߰�					
							String con_agnt_nm			= "";
							String con_agnt_email		= "";
							String con_agnt_m_tel		= "";
							String con_agnt_nm2			= "";
							String con_agnt_email2		= "";
							String con_agnt_m_tel2		= "";
							
							if(!site_id.equals("")){
								con_agnt_nm			= site.getAgnt_nm();
								con_agnt_email		= site.getAgnt_email();
								con_agnt_m_tel		= site.getAgnt_m_tel();
								con_agnt_nm2			= site.getAgnt_nm2();
								con_agnt_email2		= site.getAgnt_email2();
								con_agnt_m_tel2		= site.getAgnt_m_tel2();
							}else{
								con_agnt_nm			= client.getCon_agnt_nm();
								con_agnt_email		= client.getCon_agnt_email();
								con_agnt_m_tel		= client.getCon_agnt_m_tel();
								con_agnt_nm2			= client.getCon_agnt_nm2();
								con_agnt_email2		= client.getCon_agnt_email2();
								con_agnt_m_tel2		= client.getCon_agnt_m_tel2();
							}
													
							//[2�ܰ�] �ŷ����� ����
							Vector vt = IssueDb.getTaxItemListSusi(reg_code);
							int vt_size = vt.size();
							
							for(int i=0;i < vt_size;i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);
								TaxItemBean ti_bean = new TaxItemBean();
								ti_bean.setClient_id	(client_id);
								ti_bean.setSeq			(site_id);
								ti_bean.setItem_dt		(s_bean.getCust_req_dt());
								ti_bean.setTax_id		("");
								ti_bean.setItem_id		(String.valueOf(ht.get("ITEM_ID")));
								ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"��");
								ti_bean.setItem_hap_num	(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
								ti_bean.setItem_man		(String.valueOf(ht.get("ITEM_MAN")));
								ti_bean.setItem_dt		(String.valueOf(ht.get("ITEM_DT")));
								ti_bean.setTax_item_etc	("");
								
								if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
							}
						
								
							
							if(!item_id.equals("")){
								
								//���ν��� ȣ��
								int flag5 = 0;
								String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm, con_agnt_email, con_agnt_m_tel);
								if(!con_agnt_email2.equals("")){
									d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm2, con_agnt_email2, con_agnt_m_tel2);
								}	
								System.out.println("��å�� �ŷ����� = " + d_flag2);
								if (!d_flag2.equals("0")) flag5 = 1;
								System.out.println(" �ŷ����� ���� ���ν��� �ڵ����"+item_id + ","+ sender_bean.getUser_nm() +","+ con_agnt_nm + "," + con_agnt_email);
							}
							
							
				      }	//�ش�� �ŷ����� ���� 	
					
			}			
					// ��å�� ����� Ȯ��ó��
			if(!a_csd.updateServiceSac(c_id, serv_id))	flag += 1;			
				
			s_bean.setSac_dt(AddUtil.getDate());// �ű��̸鼭 ��å�� û���ݾ��� �ִ� ��� ��꼭������ �ȵǴ� ���ΰ��	- 20120906			
					
        }
     
		int cnt = 0;
		//��å�� ������ �ۼ� ����
		cnt = a_csd.getServiceScdExt(s_bean);
		if ( cnt < 1) {
		   if( !serv_id.equals("")  ){	
		   	  System.out.println("��å�� serv_id=" + serv_id + "^l_cd =" + l_cd  );
			   count = a_csd.insertServiceScdExt(s_bean);
		   }
		}					
			//�ݾ� ������ ��� - �Ա��� �ȵ� ��
		if(!serv_id.equals("") &&  s_bean.getCust_pay_dt().equals("")){
	//	if(!serv_id.equals("") && c_amt != old_amt && s_bean.getCust_pay_dt().equals("")){
			count = a_csd.getServiceScdExtAmt(s_bean);
		}	
			
		//������ ������ ���
		if (no_dft_yn.equals("Y")) {
			count = a_csd.updateServiceScdExt(s_bean);
		}

	//��å���� 0���� ������ ��� bill_yn = 'N' , ��å�� ������ ���� �ȵȰ�� ���� (���Աݺ� ��) -????
	//	if(!serv_id.equals("") && c_amt == 0 && no_dft_yn.equals("")){
		if(!serv_id.equals("") && c_amt == 0 ){
			count = a_csd.updateServiceScdExt(s_bean);
		}
		
		// �Ƹ���ī�� ��å�� û���Ǵ� ��� �����忡�� �޼��� - 20200626	- �����ΰ�� ����(20200923)	
		if ( cmd.equals("i") && c_amt > 0  && base.getClient_id().equals("000228") ) {
			if ( accid.getSub_rent_gu().equals("1") || accid.getSub_rent_gu().equals("2") || accid.getSub_rent_gu().equals("3") || accid.getSub_rent_gu().equals("9") || accid.getSub_rent_gu().equals("10") ) {  //������ �ƴϸ� 
			} else {
							
				//����ڿ��� �޼��� ����------------------------------------------------------------------------------------------							
									
				String sub 	= "��� - �Ƹ���ī�� ��å�� û�� ";
				String cont 	= "�� ��� - �Ƹ���ī�� ��å�� û���� Ȯ�ο�!!!  &lt;br&gt; &lt;br&gt;  ����ȣ "+ l_cd+ " &lt;br&gt; &lt;br&gt;  ����Ͻ�:" + accid.getAccid_dt() ;  	
											
				String url 	=  "/acar/accid_mng/accid_s_frame.jsp";		 
					
				String target_id = nm_db.getWorkAuthUser("�����������");  
								
				//����� ���� ��ȸ
				UsersBean target_bean 	= umd.getUsersBean(target_id);
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
				
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				xml_data += "    <TARGET>2006007</TARGET>";
				
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
				
				flag2 = cm_db.insertCoolMsg(msg);
			}
				
		}
							
	}
	
	else if(mode.equals("8")){//��/������
	
		String seq_no 	= request.getParameter("seq_no")==null?"1":request.getParameter("seq_no");//�������Ϸù�ȣ
		String vat_yn 	= request.getParameter("vat_yn")==null?"N":request.getParameter("vat_yn"); //�ΰ������Կ���
		int s_amt 	= request.getParameter("s_amt")==null?0:AddUtil.parseDigit(request.getParameter("s_amt"));//���ް�
		int v_amt 	= request.getParameter("v_amt")==null?0:AddUtil.parseDigit(request.getParameter("v_amt"));//�ΰ���
		
		MyAccidBean ma_bean 	= as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
		MyAccidBean old_ma_bean = as_db.getMyAccid(c_id, accid_id, AddUtil.parseInt(seq_no));
		
		
		ma_bean.setIns_req_gu	(request.getParameter("ins_req_gu")	==null?"":request.getParameter("ins_req_gu"));		//�뿩û�� ����(������/������)
		ma_bean.setIns_req_st	(request.getParameter("ins_req_st")	==null?"":request.getParameter("ins_req_st"));		//û�� ����(��û��/û��/�Ϸ�/�ְ�������)
		ma_bean.setIns_car_nm	(request.getParameter("ins_car_nm")	==null?"":request.getParameter("ins_car_nm"));		//�뿩û�� ����
		ma_bean.setIns_car_no	(request.getParameter("ins_car_no")	==null?"":request.getParameter("ins_car_no"));		//�뿩û�� ������ȣ
		ma_bean.setIns_day_amt	(request.getParameter("ins_day_amt")	==null?0:AddUtil.parseDigit(request.getParameter("ins_day_amt")));//�뿩û�� 1�ϱ��� �ݾ�
		ma_bean.setIns_use_st	(request.getParameter("ins_use_st")	==null?"":request.getParameter("ins_use_st"));		//�뿩������
		ma_bean.setIns_use_et	(request.getParameter("ins_use_et")	==null?"":request.getParameter("ins_use_et"));		//�뿩������
		ma_bean.setIns_use_day	(request.getParameter("ins_use_day")	==null?"":request.getParameter("ins_use_day"));		//�뿩�ϼ�
		ma_bean.setIns_req_amt	(request.getParameter("ins_req_amt")	==null?0:AddUtil.parseDigit(request.getParameter("ins_req_amt")));//�뿩û���ݾ�
		ma_bean.setIns_req_dt	(request.getParameter("ins_req_dt")	==null?"":request.getParameter("ins_req_dt"));		//�뿩û������
		ma_bean.setIns_pay_amt	(request.getParameter("ins_pay_amt")	==null?0:AddUtil.parseDigit(request.getParameter("ins_pay_amt")));//�뿩�Աݾ�
		ma_bean.setIns_pay_dt	(request.getParameter("ins_pay_dt")	==null?"":request.getParameter("ins_pay_dt"));		//�뿩�Ա�����
		ma_bean.setIns_nm	(request.getParameter("ins_nm")		==null?"":request.getParameter("ins_nm"));		//�뿩û�� ��������
		ma_bean.setIns_tel	(request.getParameter("ins_tel")	==null?"":request.getParameter("ins_tel"));		//�뿩û�� �������� ����ó
		ma_bean.setIns_tel2	(request.getParameter("ins_tel2")	==null?"":request.getParameter("ins_tel2"));		//�뿩û�� �������� ����ó2
		ma_bean.setIns_fax	(request.getParameter("ins_fax")	==null?"":request.getParameter("ins_fax"));		//�뿩û�� �������� �ѽ�
		ma_bean.setIns_com	(request.getParameter("ins_com")	==null?"":request.getParameter("ins_com"));		//�뿩û�� �����
		ma_bean.setIns_num	(request.getParameter("ins_num")	==null?"":request.getParameter("ins_num"));		//�����������ȣ
		ma_bean.setRe_reason	(request.getParameter("re_reason")	==null?"":request.getParameter("re_reason"));		//��/������ ��û�� ����
		ma_bean.setMc_s_amt	(request.getParameter("mc_s_amt")	==null?0:AddUtil.parseDigit(request.getParameter("mc_s_amt")));
		ma_bean.setMc_v_amt	(request.getParameter("mc_v_amt")	==null?0:AddUtil.parseDigit(request.getParameter("mc_v_amt")));
		ma_bean.setVat_yn	(vat_yn);
		ma_bean.setOt_fault_per	(request.getParameter("ot_fault_per")	==null?0:AddUtil.parseDigit(request.getParameter("ot_fault_per")));
		ma_bean.setPay_gu	(request.getParameter("pay_gu")		==null?"1":request.getParameter("pay_gu"));		//�뿩�Ա� ����(1������/2������)
		ma_bean.setBus_id2	(request.getParameter("bus_id2")	==null?"":request.getParameter("bus_id2"));  		// ������� 
		ma_bean.setIns_use_st	(request.getParameter("h_rent_start_dt")==null?"":request.getParameter("h_rent_start_dt"));	//�뿩������
		ma_bean.setIns_use_et	(request.getParameter("h_rent_end_dt")	==null?"":request.getParameter("h_rent_end_dt"));	//�뿩������
		ma_bean.setUse_hour	(request.getParameter("use_hour")	==null?"":request.getParameter("use_hour"));		//�̿�ð�
		ma_bean.setIns_com_id	(request.getParameter("ins_com_id")	==null?"":request.getParameter("ins_com_id"));		//�뿩û�� �����
		ma_bean.setIns_addr	(request.getParameter("t_addr")		==null?"":request.getParameter("t_addr"));		//�뿩û�� �������� �ּ�
		ma_bean.setIns_zip	(request.getParameter("t_zip")		==null?"":request.getParameter("t_zip"));		//�뿩û�� �������� �ּ�
		
		String app_doc4 	= request.getParameter("app_doc4")==null?"N":request.getParameter("app_doc4");	//÷�ι���
		String app_doc5 	= request.getParameter("app_doc5")==null?"N":request.getParameter("app_doc5");	//÷�ι���
		String app_doc6 	= request.getParameter("app_doc6")==null?"N":request.getParameter("app_doc6");	//÷�ι���
		String app_doc7 	= request.getParameter("app_doc7")==null?"N":request.getParameter("app_doc7");	//÷�ι���
		String app_doc8 	= request.getParameter("app_doc8")==null?"N":request.getParameter("app_doc8");	//÷�ι���
		String app_doc9 	= request.getParameter("app_doc9")==null?"N":request.getParameter("app_doc9");	//÷�ι���
		String app_doc10 	= request.getParameter("app_doc10")==null?"N":request.getParameter("app_doc10");//÷�ι���
		String app_doc11 	= request.getParameter("app_doc11")==null?"N":request.getParameter("app_doc11");//÷�ι���
		
		String app_docs = "^Y^Y^Y^"+app_doc4+"^"+app_doc5+"^"+app_doc6+"^"+app_doc7+"^"+app_doc8+"^"+app_doc9+"^"+app_doc10+"^"+app_doc11;
		
		ma_bean.setApp_docs		(app_docs);//�뿩û�� ÷�ι���
		
		if(!ma_bean.getIns_req_st().equals("3")){
			if(!ma_bean.getIns_req_st().equals("1") && !ma_bean.getIns_req_dt().equals("") && ma_bean.getIns_pay_dt().equals("")) 	ma_bean.setIns_req_st("1");
			if(!ma_bean.getIns_req_st().equals("2") && !ma_bean.getIns_req_dt().equals("") && !ma_bean.getIns_pay_dt().equals("")) 	ma_bean.setIns_req_st("2");
		}
		
		if(ma_bean.getAccid_id().equals("")){
			ma_bean.setCar_mng_id(c_id);
			ma_bean.setAccid_id(accid_id);
			ma_bean.setSeq_no(AddUtil.parseInt(seq_no));
			ma_bean.setReg_id(ck_acar_id);
			count = as_db.insertMyAccid(ma_bean);
			
			//�����ὺ���� ����
			if(ma_bean.getIns_req_amt() >0){
				//������
				ExtScdBean ext = new ExtScdBean();
				ext.setRent_mng_id	(accid.getRent_mng_id());
				ext.setRent_l_cd	(accid.getRent_l_cd());
				ext.setRent_st		("1");
				ext.setRent_seq		("1");
				ext.setExt_st		("6");
				ext.setExt_id		(ma_bean.getAccid_id()+""+ma_bean.getSeq_no());
				ext.setExt_tm		("1");
				ext.setExt_s_amt	(ma_bean.getMc_s_amt());
				ext.setExt_v_amt	(ma_bean.getMc_v_amt());
				ext.setExt_est_dt	(ma_bean.getIns_req_dt());
				ext.setExt_pay_amt	(0);
				ext.setExt_pay_dt	("");
				boolean ext_flag = ae_db.insertGrtEtc(ext);
			}
			
		}else{
			ma_bean.setUpdate_id(ck_acar_id);
			count = as_db.updateMyAccid(ma_bean);
			
			
			if(old_ma_bean.getIns_req_amt() > ma_bean.getIns_req_amt() || old_ma_bean.getIns_req_amt() < ma_bean.getIns_req_amt()){
			
				//������
				ExtScdBean ext = ae_db.getAGrtScd(accid.getRent_mng_id(), accid.getRent_l_cd(), "1", "6", "1", ma_bean.getAccid_id()+""+ma_bean.getSeq_no());//���� ��� ���� ��ȸ
				
				int ext_gbn = 1;	//����
				if(ext == null || ext.getRent_l_cd().equals("")){
					ext_gbn = 0;	//�ű�
					ext = new ExtScdBean();
					ext.setRent_mng_id	(accid.getRent_mng_id());
					ext.setRent_l_cd	(accid.getRent_l_cd());
					ext.setRent_st		("1");
					ext.setRent_seq		("1");
					ext.setExt_st		("6");
					ext.setExt_id		(ma_bean.getAccid_id()+""+ma_bean.getSeq_no());
					ext.setExt_tm		("1");
					ext.setExt_s_amt	(ma_bean.getMc_s_amt());
					ext.setExt_v_amt	(ma_bean.getMc_v_amt());
					ext.setExt_est_dt	(ma_bean.getIns_req_dt());
					ext.setExt_pay_amt	(0);
					ext.setExt_pay_dt	("");
					boolean ext_flag = ae_db.insertGrtEtc(ext);
				}else{														
					//���Աݻ����϶��� �������� �����Ѵ�.
					if(ext.getExt_pay_amt()==0){
						ext.setExt_s_amt	(ma_bean.getMc_s_amt());
						ext.setExt_v_amt	(ma_bean.getMc_v_amt());
						if(!AddUtil.replace(old_ma_bean.getIns_req_dt(),"-","").equals(ext.getExt_est_dt())){				
							ext.setExt_est_dt	(ma_bean.getIns_req_dt());
						}
						boolean ext_flag = ae_db.i_updateGrtEct(ext);
					}					
				}				
			}
		}
		
		
		//û���� ����� ������ ����
	
		//û�������� ��ȸ
		TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(c_id, accid_id);
		if(!ti.getCar_mng_id().equals("") && ti.getItem_value()!=ma_bean.getMc_v_amt()){// && (ti.getItem_supply()+ti.getItem_value()) != ma_bean.getIns_req_amt()
			//�ŷ����� ��ȸ
			TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(ti.getItem_id());
			ti_bean.setItem_dt		(ma_bean.getIns_req_dt());
			ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(String.valueOf(ma_bean.getIns_req_amt()))+"��");
			ti_bean.setItem_hap_num	(ma_bean.getIns_req_amt());
			if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
			
			//�ŷ����� ����Ʈ ��ȸ
			TaxItemListBean til_bean = IssueDb.getTaxItemListCase(ti.getItem_id(), "1");
			til_bean.setItem_car_no	(ma_bean.getIns_car_no());
			til_bean.setItem_car_nm	(ma_bean.getIns_car_nm());
			til_bean.setItem_dt1	(ma_bean.getIns_use_st());
			til_bean.setItem_dt2	(ma_bean.getIns_use_et());
			if(AddUtil.replace(ma_bean.getIns_use_st(),"-","").length() > 8){
				til_bean.setItem_dt1	(AddUtil.replace(ma_bean.getIns_use_st(),"-","").substring(0,8));
			}
			if(AddUtil.replace(ma_bean.getIns_use_et(),"-","").length() > 8){
				til_bean.setItem_dt2	(AddUtil.replace(ma_bean.getIns_use_et(),"-","").substring(0,8));
			}
			if(vat_yn.equals("Y")){
				til_bean.setItem_supply	(ma_bean.getMc_s_amt());
				til_bean.setItem_value	(ma_bean.getMc_v_amt());
			}else{
				til_bean.setItem_supply	(ma_bean.getIns_req_amt());
				til_bean.setItem_value	(0);
			}
			if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;
		}
	
	}
	else if(mode.equals("9")){//����ó����� ����
		accid.setHum_amt(request.getParameter("hum_amt")==null?0:AddUtil.parseDigit(request.getParameter("hum_amt")));
		accid.setHum_nm(request.getParameter("hum_nm"));
		accid.setHum_tel(request.getParameter("hum_tel"));
		accid.setMat_amt(request.getParameter("mat_amt")==null?0:AddUtil.parseDigit(request.getParameter("mat_amt")));
		accid.setMat_nm(request.getParameter("mat_nm"));
		accid.setMat_tel(request.getParameter("mat_tel"));
		accid.setOne_amt(request.getParameter("one_amt")==null?0:AddUtil.parseDigit(request.getParameter("one_amt")));
		accid.setOne_nm(request.getParameter("one_nm"));
		accid.setOne_tel(request.getParameter("one_tel"));
		accid.setMy_amt(request.getParameter("my_amt")==null?0:AddUtil.parseDigit(request.getParameter("my_amt")));
		accid.setMy_nm(request.getParameter("my_nm"));
		accid.setMy_tel(request.getParameter("my_tel"));
		accid.setEx_tot_amt(request.getParameter("ex_tot_amt")==null?0:AddUtil.parseDigit(request.getParameter("ex_tot_amt")));
		accid.setTot_amt(request.getParameter("tot_amt")==null?0:AddUtil.parseDigit(request.getParameter("tot_amt")));
		accid.setHum_end_dt(request.getParameter("hum_end_dt")==null?"":request.getParameter("hum_end_dt"));
		accid.setMat_end_dt(request.getParameter("mat_end_dt")==null?"":request.getParameter("mat_end_dt"));
		accid.setOne_end_dt(request.getParameter("one_end_dt")==null?"":request.getParameter("one_end_dt"));
		accid.setMy_end_dt(request.getParameter("my_end_dt")==null?"":request.getParameter("my_end_dt"));
		
		
		count = as_db.updateAccident(accid);
		
		if(accid.getAccid_st().equals("1") || accid.getAccid_st().equals("3")){//����,�ֹ�,������
			//�������û�� ����
			String seq_no[] = request.getParameterValues("seq_no");
			String amor_req_amt[] = request.getParameterValues("amor_req_amt");
			String amor_req_dt[] = request.getParameterValues("amor_req_dt");
			String amor_req_id[] = request.getParameterValues("amor_req_id");
			String amor_pay_amt[] = request.getParameterValues("amor_pay_amt");
			String amor_pay_dt[] = request.getParameterValues("amor_pay_dt");
			String amor_st[] = request.getParameterValues("amor_st");
			String amor_type[] = request.getParameterValues("amor_type");
			String ot_ins[] = request.getParameterValues("ot_ins");
			String mat_nm[] = request.getParameterValues("ot_mat_nm");
			String mat_tel[] = request.getParameterValues("ot_mat_tel");
			String ot_fault_per[] = request.getParameterValues("ot_fault_per");
			
			for(int i=0;i < seq_no.length;i++){
				OtAccidBean oa_bean = as_db.getOtAccidBean(c_id, accid_id, seq_no[i]);
				oa_bean.setAmor_pay_amt	(amor_pay_amt[i]==null? 0:AddUtil.parseDigit(amor_pay_amt[i]));
				oa_bean.setAmor_pay_dt	(amor_pay_dt[i] ==null?"":amor_pay_dt[i]);
				oa_bean.setAmor_req_amt	(amor_req_amt[i]==null? 0:AddUtil.parseDigit(amor_req_amt[i]));
				oa_bean.setAmor_req_dt	(amor_req_dt[i] ==null?"":amor_req_dt[i]);
				oa_bean.setAmor_req_id	(amor_req_id[i] ==null?"":amor_req_id[i]);
				oa_bean.setAmor_type		(amor_type[i] 	==null?"":amor_type[i]);
				oa_bean.setAmor_st		(amor_st[i] 	==null?"":amor_st[i]);
				oa_bean.setOt_ins		(ot_ins[i] 		==null?"":ot_ins[i]);
				oa_bean.setMat_nm		(mat_nm[i] 		==null?"":mat_nm[i]);
				oa_bean.setMat_tel		(mat_tel[i] 	==null?"":mat_tel[i]);
				if(!oa_bean.getAmor_st().equals("Y") && oa_bean.getAmor_req_amt() >0){
					oa_bean.setAmor_st("Y");
				}
				 //�Ա�ó���ڴ� ���� 
				//if(accid.getSettle_st().equals("1") && !ck_acar_id.equals("000128") && !ck_acar_id.equals("000212") && !ck_acar_id.equals("000096") && !nm_db.getWorkAuthUser("������",ck_acar_id) ){//��������϶��� �������ϰ� ����..
			//	}else{
					count = as_db.updateOtAccid(oa_bean);
				//}
			}
		}
	}
	else if(mode.equals("10")){//��������
		String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
		count = as_db.deletePicAccid(c_id, accid_id, seq);
	}
	else if(mode.equals("13")){//���ó�� ����
		accid.setSettle_st(request.getParameter("settle_st")==null?"":request.getParameter("settle_st"));//ó������
		accid.setSettle_dt(request.getParameter("settle_dt")==null?"":request.getParameter("settle_dt"));//ó���Ϸ�����
		accid.setSettle_id(request.getParameter("settle_id")==null?"":request.getParameter("settle_id"));//ó���Ϸ������
		accid.setSettle_cont(request.getParameter("settle_cont")==null?"":request.getParameter("settle_cont"));//ó������
		accid.setSettle_note(request.getParameter("settle_note")==null?"":request.getParameter("settle_note"));//��������
		accid.setSettle_st1(request.getParameter("settle_st1")==null?"":request.getParameter("settle_st1"));//ó������
		accid.setSettle_dt1(request.getParameter("settle_dt1")==null?"":request.getParameter("settle_dt1"));//ó���Ϸ�����
		accid.setSettle_id1(request.getParameter("settle_id1")==null?"":request.getParameter("settle_id1"));//ó���Ϸ������
		accid.setSettle_st2(request.getParameter("settle_st2")==null?"":request.getParameter("settle_st2"));//ó������
		accid.setSettle_dt2(request.getParameter("settle_dt2")==null?"":request.getParameter("settle_dt2"));//ó���Ϸ�����
		accid.setSettle_id2(request.getParameter("settle_id2")==null?"":request.getParameter("settle_id2"));//ó���Ϸ������
		accid.setSettle_st3(request.getParameter("settle_st3")==null?"":request.getParameter("settle_st3"));//ó������
		accid.setSettle_dt3(request.getParameter("settle_dt3")==null?"":request.getParameter("settle_dt3"));//ó���Ϸ�����
		accid.setSettle_id3(request.getParameter("settle_id3")==null?"":request.getParameter("settle_id3"));//ó���Ϸ������
		accid.setSettle_st4(request.getParameter("settle_st4")==null?"":request.getParameter("settle_st4"));//ó������
		accid.setSettle_dt4(request.getParameter("settle_dt4")==null?"":request.getParameter("settle_dt4"));//ó���Ϸ�����
		accid.setSettle_id4(request.getParameter("settle_id4")==null?"":request.getParameter("settle_id4"));//ó���Ϸ������
		accid.setSettle_st5(request.getParameter("settle_st5")==null?"":request.getParameter("settle_st5"));//ó������
		accid.setSettle_dt5(request.getParameter("settle_dt5")==null?"":request.getParameter("settle_dt5"));//ó���Ϸ�����
		accid.setSettle_id5(request.getParameter("settle_id5")==null?"":request.getParameter("settle_id5"));//ó���Ϸ������
		accid.setAsset_st(request.getParameter("asset_st")==null?"":request.getParameter("asset_st"));//�������� 
		count = as_db.updateAccident(accid);
	}
	else if(mode.equals("14")){//�Ҽ� ����
						
		AccidSuitBean as_bean 	= as_db.getAccidSuitBean(c_id, accid_id);
		
		as_bean.setReq_dt	(request.getParameter("req_dt")	==null?"":request.getParameter("req_dt"));		//����� ��û��
		as_bean.setReq_id	(request.getParameter("req_id")	==null?"":request.getParameter("req_id"));		//��û��
		as_bean.setReq_rem	(request.getParameter("req_rem")	==null?"":request.getParameter("req_rem"));	//��û����
		
		as_bean.setSuit_type	(request.getParameter("suit_type")	==null?"":request.getParameter("suit_type"));		//�Ҽ�Ÿ��
		as_bean.setSuit_dt	(request.getParameter("suit_dt")	==null?"":request.getParameter("suit_dt"));		//������(�Ҽ���) 
		as_bean.setSuit_no	(request.getParameter("suit_no")	==null?"":request.getParameter("suit_no"));		//������ȣ
		as_bean.setMean_dt	(request.getParameter("mean_dt")	==null?"":request.getParameter("mean_dt"));		//�ǰ����� 
		as_bean.setOur_fault_per	(request.getParameter("our_fault_per")	==null?0:AddUtil.parseDigit(request.getParameter("our_fault_per"))); //�ǰ������ 
		as_bean.setJ_fault_per	(request.getParameter("j_fault_per")	==null?0:AddUtil.parseDigit(request.getParameter("j_fault_per"))); //�������� ������( ���ض� ���� ����� �� �ֱ⿡ 100 �ϼ� ����.
		as_bean.setReq_amt	(request.getParameter("req_amt")	==null?0:AddUtil.parseDigit(request.getParameter("req_amt")));  //�Ҽ۱ݾ� 
		as_bean.setSuit_amt	(request.getParameter("suit_amt")	==null?0:AddUtil.parseDigit(request.getParameter("suit_amt")));  //������ݾ� 
		as_bean.setLoan_amt	(request.getParameter("loan_amt")	==null?0:AddUtil.parseDigit(request.getParameter("loan_amt")));  //������ݾ� 
		
		as_bean.setPay_amt	(request.getParameter("pay_amt")	==null?0:AddUtil.parseDigit(request.getParameter("pay_amt"))); //�Աݾ� 
		as_bean.setPay_dt	(request.getParameter("pay_dt")		==null?"":request.getParameter("pay_dt"));		//�Ա��� 
		as_bean.setSuit_st	(request.getParameter("suit_st")		==null?"":request.getParameter("suit_st"));		//�ϷῩ��-�ǰ����� �ִٸ� �Ϸ�� 
		as_bean.setSuit_rem	(request.getParameter("suit_rem")		==null?"":request.getParameter("suit_rem"));		//���� 
						
		if(as_bean.getAccid_id().equals("")){  //�ű�  
			as_bean.setCar_mng_id(c_id);
			as_bean.setAccid_id(accid_id);
			as_bean.setReg_id(ck_acar_id);
			count = as_db.insertAccidSuit(as_bean);	
						
			//���ϵ���� �����忡�� �޼��� ���� - �Ҽ����࿩�� �Ǵ�  		--�űԷ� ��Ͻÿ��� �ش� 					
			String sub 	= "���Ǻ�����Ȯ���Ҽ� ��û ";
			String cont 	= "�� ��� ���Ǻ�����Ȯ���Ҽ� ��û  &lt;br&gt; &lt;br&gt;  ����ȣ "+ l_cd+ " &lt;br&gt; &lt;br&gt;  ����Ͻ�:" + accid.getAccid_dt() ;  	
										
			String url 	=  "/acar/accid_mng/accid_s_frame.jsp";		 
				
			String target_id = nm_db.getWorkAuthUser("�����������");  
							
			//����� ���� ��ȸ
			UsersBean target_bean 	= umd.getUsersBean(target_id);
		
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";
					
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
			
			flag2 = cm_db.insertCoolMsg(msg);
						
			
		}else{
			as_bean.setUpdate_id(ck_acar_id);
			count = as_db.updateAccidSuit(as_bean);
		}
				
			
	} 
%>

<form name='form1' method='post' action='../accid_mng/accid_u_frame.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="serv_id" value='<%=serv_id%>'>
<input type='hidden' name="accid_st" value='<%=accid_st%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
</form>
<script language='javascript'>
function serv_tax(){
		var SUBWIN="<%=serv_tax_url%>";	
		window.open(SUBWIN, "DocReg", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
}	
function serv_send(){
	var fm = document.form1;
	fm.action = "accid_u_in<%=mode%>.jsp";		
	fm.target = "c_foot";		
	fm.submit();	
}
<%	if(count == 0){	%>
		alert('����� �����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');
		location='about:blank';
<%	}else{	%>
		alert("�����Ǿ����ϴ�");
		<%if(mode.equals("0")){%>
			var fm = document.form1;
			fm.action = "accid_u_frame.jsp";		
			fm.target = "d_content";		
			fm.submit();				
		<%}else if(mode.equals("7")){%>
			//alert('<%=serv_tax_url%>');
			serv_tax();
			var fm = document.form1;
			fm.action = "accid_u_in<%=mode%>.jsp";		
			fm.target = "c_foot";		
			fm.submit();		
			
		<%}else{
			if(mode.equals("")) mode="1";%>
			var fm = document.form1;
			fm.action = "accid_u_in<%=mode%>.jsp";		
			fm.target = "c_foot";		
			fm.submit();							
		<%}%>			
<%	}	%>


</script>
</body>
</html>
