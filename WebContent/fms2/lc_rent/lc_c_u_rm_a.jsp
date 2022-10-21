<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.car_office.*, acar.res_search.*, acar.client.*,  acar.ext.*,  acar.fee.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_register.*, acar.im_email.*, tax.*, acar.estimate_mng.*, acar.short_fee_mng.*"%>
<%@ page import="acar.kakao.*" %>
<%@ page import="java.lang.reflect.Array" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="sfm_db" scope="page" class="acar.short_fee_mng.ShortFeeMngDatabase"/>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%

	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//����1,����0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag9 = true;
	boolean flag12 = true;	
	int i_flag4 = 0;
	
	int flag = 0;
		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase 		e_db 	= EstiDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//cont_etc
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);	
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//20170217 ����Ʈ ���ǻ��� �ȳ�����
	
	//[���]�������� ��ȸ
	Hashtable insur = a_db.getInsurOfCont(rent_l_cd, rent_mng_id);
	
	//���ΰ�����������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();
    String s_person = "";
    for(int i = 0 ; i < mgr_size ; i++){
        CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
       if(mgr.getMgr_st().equals("�߰��̿���") || mgr.getMgr_st().equals("�߰�������")){
        		s_person =mgr.getMgr_nm();
       }
   } 
   
   //������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));	
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
   
%>


<%
	if(cng_item.equals("deli")){
	
		//fee_rm
		ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
	
		String deli_plan_dt	= request.getParameter("deli_plan_dt")==null?"":request.getParameter("deli_plan_dt");
		String deli_plan_h	= request.getParameter("deli_plan_h")==null?"00":request.getParameter("deli_plan_h");
		String deli_plan_m	= request.getParameter("deli_plan_m")==null?"00":request.getParameter("deli_plan_m");
		String ret_plan_dt	= request.getParameter("ret_plan_dt")==null?"":request.getParameter("ret_plan_dt");
		String ret_plan_h	= request.getParameter("ret_plan_h")==null?"00":request.getParameter("ret_plan_h");
		String ret_plan_m	= request.getParameter("ret_plan_m")==null?"00":request.getParameter("ret_plan_m");
	
		if(!deli_plan_dt.equals("")){
			fee_rm.setDeli_plan_dt	(deli_plan_dt+""+deli_plan_h+""+deli_plan_m);
		}
		if(!ret_plan_dt.equals("")){
			fee_rm.setRet_plan_dt	(ret_plan_dt+""+ret_plan_h+""+ret_plan_m);
		}
	
		fee_rm.setDeli_loc	(request.getParameter("deli_loc")==null?"":request.getParameter("deli_loc"));
		fee_rm.setRet_loc	(request.getParameter("ret_loc")==null?"":request.getParameter("ret_loc"));
			
		if(fee_rm.getRent_mng_id().equals("")){
			fee_rm.setRent_mng_id		(rent_mng_id);
			fee_rm.setRent_l_cd		(rent_l_cd);
			fee_rm.setRent_st		("1");
			//=====[fee_rm] insert=====
			flag2 = a_db.insertFeeRm(fee_rm);
		}else{
			//=====[fee_rm] update=====
			flag2 = a_db.updateFeeRm(fee_rm);
		}	
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		fee_etc.setSh_km				(request.getParameter("sh_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
		flag1 = a_db.updateFeeEtc(fee_etc);
	
%>
	
<script language='javascript'>
<%		if(!flag2){	%>	alert('����Ʈ ��������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');			<%		}	%>		
</script>
<%	}%>

	
<%
	if(cng_item.equals("fee")){
	
		String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	
		if(rent_st.equals("1")){
		
		
			cont_etc.setGrt_suc_m_id	(request.getParameter("grt_suc_m_id")	==null?"":request.getParameter("grt_suc_m_id"));
			cont_etc.setGrt_suc_l_cd	(request.getParameter("grt_suc_l_cd")	==null?"":request.getParameter("grt_suc_l_cd"));
			cont_etc.setGrt_suc_c_no	(request.getParameter("grt_suc_c_no")	==null?"":request.getParameter("grt_suc_c_no"));
			cont_etc.setGrt_suc_o_amt	(request.getParameter("grt_suc_o_amt")==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_o_amt")));
			cont_etc.setGrt_suc_r_amt	(request.getParameter("grt_suc_r_amt")==null? 0:AddUtil.parseDigit(request.getParameter("grt_suc_r_amt")));				
			cont_etc.setCar_deli_dt			(request.getParameter("car_deli_dt")	==null?"":request.getParameter("car_deli_dt"));
		
			if(cont_etc.getRent_mng_id().equals("")){
				//=====[cont_etc] update=====
				cont_etc.setRent_mng_id	(rent_mng_id);
				cont_etc.setRent_l_cd	(rent_l_cd);
				flag9 = a_db.insertContEtc(cont_etc);
			}else{
				//=====[cont_etc] update=====
				flag9 = a_db.updateContEtc(cont_etc);
			}		
		}
	
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		
		
	
		int old_value = fee.getInv_s_amt();
		int new_value = request.getParameter("inv_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt"));
	

		int old_amt1 = fee.getFee_s_amt();
		int new_amt1 = request.getParameter("fee_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));


	
		if(!rent_st.equals("1")){
			fee.setExt_agnt			(request.getParameter("ext_agnt")	==null? "":request.getParameter("ext_agnt"));
			fee.setRent_dt			(request.getParameter("rent_dt")	==null? "":request.getParameter("rent_dt"));
		}
		
		if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("�����ٻ�����",ck_acar_id) || nm_db.getWorkAuthUser("�����ٺ�������",ck_acar_id)){		
			fee.setCon_mon			(request.getParameter("con_mon")		==null?"0":request.getParameter("con_mon"));
			fee.setRent_start_dt		(request.getParameter("rent_start_dt")		==null?"":request.getParameter("rent_start_dt"));
			fee.setRent_end_dt		(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));		
		}
		
		fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
		fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
		fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
		fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
		fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
		fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
		fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
		fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
		if(rent_st.equals("1")){
			fee.setInv_s_amt		(request.getParameter("inv_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_s_amt")));
			fee.setInv_v_amt		(request.getParameter("inv_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("inv_v_amt")));
		}else{
			fee.setInv_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
			fee.setInv_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
		}
		
		fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
		fee.setFee_est_day		(request.getParameter("fee_est_day")		==null?"":request.getParameter("fee_est_day"));
		fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")	==null?"":request.getParameter("fee_pay_start_dt"));
		fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")		==null?"":request.getParameter("fee_pay_end_dt"));
		fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));
		fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")		==null?"":request.getParameter("grt_suc_yn"));
		fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt"));
		fee.setFee_fst_amt		(request.getParameter("fee_fst_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
		
		
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
		
		String inv_cng_st = "";
		if(old_value-new_value > 0){
			inv_cng_st= "-";
		}
		if(old_value-new_value < 0){
			inv_cng_st= "+";
		}
		
		//����뿩�� ����� �̷³����
		if(!inv_cng_st.equals("")){
			LcRentCngHBean cng = new LcRentCngHBean();
			cng.setRent_mng_id	(rent_mng_id);
			cng.setRent_l_cd	(rent_l_cd);
			cng.setCng_item		("inv_amt");
			cng.setOld_value	(Integer.toString(old_value));
			cng.setNew_value	(Integer.toString(new_value));
			cng.setCng_cau		("����");
			cng.setCng_id		(user_id);
			cng.setRent_st		(rent_st);
			cng.setS_amt		(fee.getInv_s_amt());
			cng.setV_amt		(fee.getInv_v_amt());
			flag2 = a_db.updateLcRentCngH(cng);
		}
		
				
		//�뿩��Ÿ����-------------------------------------------------------------------------------------------
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
		fee_etc.setBus_agnt_id		(request.getParameter("bus_agnt_id")	==null?"":request.getParameter("bus_agnt_id"));
		fee_etc.setAgree_dist		(request.getParameter("agree_dist")	==null? 0:AddUtil.parseDigit(request.getParameter("agree_dist")));
		fee_etc.setOver_run_amt		(request.getParameter("over_run_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("over_run_amt")));
		fee_etc.setAgree_dist_yn	(request.getParameter("agree_dist_yn")	==null?"":request.getParameter("agree_dist_yn"));
		fee_etc.setCon_day		(request.getParameter("con_day")	==null?"":request.getParameter("con_day"));		
			
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id		(rent_mng_id);
			fee_etc.setRent_l_cd		(rent_l_cd);
			fee_etc.setRent_st			(rent_st);
			//=====[fee_etc] insert=====
			flag1 = a_db.insertFeeEtc(fee_etc);
		}else{
			//=====[fee_etc] update=====
			flag1 = a_db.updateFeeEtc(fee_etc);
		}


		//fee_rm
		ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, rent_st);
		
		int old_amt2 = fee_rm.getT_fee_s_amt();
		int new_amt2 = request.getParameter("t_fee_s_amt")==null? 0:AddUtil.parseDigit(request.getParameter("t_fee_s_amt"));
		
		int old_amt3 = fee_rm.getF_rent_tot_amt();
		int new_amt3 = request.getParameter("f_rent_tot_amt")==null? 0:AddUtil.parseDigit(request.getParameter("f_rent_tot_amt"));
		
		if(rent_st.equals("1")){
			fee_rm.setDc_s_amt	(request.getParameter("dc_s_amt")==null?0:Util.parseDigit(request.getParameter("dc_s_amt")));
			fee_rm.setDc_v_amt	(request.getParameter("dc_v_amt")==null?0:Util.parseDigit(request.getParameter("dc_v_amt")));
			fee_rm.setNavi_s_amt	(request.getParameter("navi_s_amt")==null?0:Util.parseDigit(request.getParameter("navi_s_amt")));
			fee_rm.setNavi_v_amt	(request.getParameter("navi_v_amt")==null?0:Util.parseDigit(request.getParameter("navi_v_amt")));
			fee_rm.setEtc_s_amt	(request.getParameter("etc_s_amt")==null?0:Util.parseDigit(request.getParameter("etc_s_amt")));
			fee_rm.setEtc_v_amt	(request.getParameter("etc_v_amt")==null?0:Util.parseDigit(request.getParameter("etc_v_amt")));
		}
		fee_rm.setT_fee_s_amt	(request.getParameter("t_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_s_amt")));
		fee_rm.setT_fee_v_amt	(request.getParameter("t_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_v_amt")));
		fee_rm.setCons1_s_amt	(request.getParameter("cons1_s_amt")==null?0:Util.parseDigit(request.getParameter("cons1_s_amt")));
		fee_rm.setCons1_v_amt	(request.getParameter("cons1_v_amt")==null?0:Util.parseDigit(request.getParameter("cons1_v_amt")));
		fee_rm.setCons2_s_amt	(request.getParameter("cons2_s_amt")==null?0:Util.parseDigit(request.getParameter("cons2_s_amt")));
		fee_rm.setCons2_v_amt	(request.getParameter("cons2_v_amt")==null?0:Util.parseDigit(request.getParameter("cons2_v_amt")));
		fee_rm.setF_rent_tot_amt(request.getParameter("f_rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("f_rent_tot_amt")));
		fee_rm.setF_paid_way	(request.getParameter("f_paid_way")==null?"":request.getParameter("f_paid_way"));
		fee_rm.setF_paid_way2	(request.getParameter("f_paid_way2")==null?"":request.getParameter("f_paid_way2"));
		fee_rm.setReg_id	(user_id);
		fee_rm.setUpdate_id	(user_id);
		fee_rm.setNavi_yn	(request.getParameter("navi_yn")==null?"":request.getParameter("navi_yn"));
		fee_rm.setCons1_yn	(request.getParameter("cons1_yn")==null?"":request.getParameter("cons1_yn"));
		fee_rm.setCons2_yn	(request.getParameter("cons2_yn")==null?"":request.getParameter("cons2_yn"));
		fee_rm.setAmt_per	(request.getParameter("amt_per")==null?"":request.getParameter("amt_per"));
		fee_rm.setEtc_cont	(request.getParameter("etc_cont")==null?"":request.getParameter("etc_cont"));
		fee_rm.setF_con_amt	(request.getParameter("f_con_amt")==null?0:Util.parseDigit(request.getParameter("f_con_amt")));		
		
		if(!fee_rm.getCons1_yn().equals("Y") && fee_rm.getCons1_s_amt()>0)	fee_rm.setCons1_yn("Y");
		if(!fee_rm.getCons1_yn().equals("N") && fee_rm.getCons1_s_amt()==0)	fee_rm.setCons1_yn("N");
		if(!fee_rm.getCons2_yn().equals("Y") && fee_rm.getCons2_s_amt()>0)	fee_rm.setCons2_yn("Y");
		if(!fee_rm.getCons2_yn().equals("Y") && fee_rm.getCons2_s_amt()==0)	fee_rm.setCons2_yn("N");
		
		if(fee_rm.getRent_mng_id().equals("")){
	
			//�ֱ� Ȩ������ ����뿩��
			Hashtable hp = oh_db.getSecondhandCase_20090901("", "", base.getCar_mng_id());	
		 
			//��������
			String est_id = shDb.getSearchEstIdShRm(base.getCar_mng_id(), "21", "1", "", String.valueOf(hp.get("REAL_KM")), String.valueOf(hp.get("UPLOAD_DT")), String.valueOf(hp.get("RM1")), String.valueOf(hp.get("REG_CODE")));
				
			//��������
			EstimateBean e_bean = e_db.getEstimateShCase(est_id);
				
			//��������
			cm_bean = cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());

			//����������
			String jg_b_dt = e_db.getVar_b_dt("jg", e_bean.getRent_dt());				
			EstiJgVarBean ej_bean = e_db.getEstiJgVarDtCase(cm_bean.getJg_code(), jg_b_dt);

			//�ܱ���ǥ
			ShortFeeMngBean sf_bean = sfm_db.getShortFeeMngCase(ej_bean.getJg_r(), "2", e_bean.getRent_dt());
						
			fee_rm.setCars		(ej_bean.getJg_v());
			fee_rm.setAmt_01d	(sf_bean.getAmt_01d());
			fee_rm.setAmt_03d	(sf_bean.getAmt_03d());
			fee_rm.setAmt_05d	(sf_bean.getAmt_05d());
			fee_rm.setAmt_07d	(sf_bean.getAmt_07d());				
			fee_rm.setRent_mng_id		(rent_mng_id);
			fee_rm.setRent_l_cd		(rent_l_cd);
			fee_rm.setRent_st		("1");
			//=====[fee_etc] insert=====
			flag6 = a_db.insertFeeRm(fee_rm);
		}else{
			//=====[fee_etc] update=====
			flag6 = a_db.updateFeeRm(fee_rm);
		}	
		
		
		//�ݾ׺����� �����ٴ���ڿ��� �޽��� �߼�
		
		if(old_amt1+old_amt2+old_amt3 > new_amt1+new_amt2+new_amt3 || old_amt1+old_amt2+old_amt3 < new_amt1+new_amt2+new_amt3){
		
			String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
			String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
			String c_client_nm 	= request.getParameter("c_client_nm")==null?"":request.getParameter("c_client_nm");
		
			//�ڵ���ü����ڿ��� �뺸
			String memo_title 	= "";			
			memo_title += car_no+" "+c_firm_nm+" "+c_client_nm;	
		
			String sub4 	= "����Ʈ �뿩��� ���� �ȳ�";
			String cont4 	= "����Ʈ �뿩��� ���� �ȳ��մϴ�. ("+memo_title+") Ȯ���Ͻñ� �ٶ��ϴ�.";
			String url4	= "/fms2/lc_rent/lc_c_frame.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|c_st=rm";
						
			UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
		
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean4 = csd.getCarScheTodayBean(target_bean4.getUser_id());
			if(!cs_bean4.getUser_id().equals("") && !cs_bean4.getWork_id().equals("")){
				String target_id4 = cs_bean4.getWork_id();
				target_bean4 	= umd.getUsersBean(target_id4);
			}
		
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data4 = "";
			xml_data4 =  "<COOLMSG>"+
  					 "<ALERTMSG>"+
					 "    <BACKIMG>4</BACKIMG>"+
					 "    <MSGTYPE>104</MSGTYPE>"+
					 "    <SUB>"+sub4+"</SUB>"+
  					 "    <CONT>"+cont4+"</CONT>"+
					 "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url4+"</URL>"; 						 
			xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
			xml_data4 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
 					 "    <MSGICON>10</MSGICON>"+
 					 "    <MSGSAVE>1</MSGSAVE>"+
 					 "    <LEAVEDMSG>1</LEAVEDMSG>"+
  					 "    <FLDTYPE>1</FLDTYPE>"+
 					 "  </ALERTMSG>"+
 					 "</COOLMSG>";
			
			CdAlertBean msg4 = new CdAlertBean();
			msg4.setFlddata(xml_data4);
			msg4.setFldtype("1");
									
			//flag4 = cm_db.insertCoolMsg(msg4); 20130912 ��꼭����� �߼� ���ʿ� ��û
							
		}
		
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�뿩���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
<%		if(!flag1){	%>	alert('������ �̷� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
<%		if(!flag4){	%>	alert('����������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("rent_start")){
	
		
		
	
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
			
		fee.setRent_start_dt		(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
		fee.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
		fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")	==null?"":request.getParameter("fee_pay_tm"));
		fee.setFee_est_day		(request.getParameter("fee_est_day")	==null?"":request.getParameter("fee_est_day"));
		fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")==null?"":request.getParameter("fee_pay_start_dt"));
		fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")	==null?"":request.getParameter("fee_pay_end_dt"));
		fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")	==null?"":request.getParameter("fee_fst_dt"));
		fee.setFee_fst_amt		(request.getParameter("fee_fst_amt").equals("")?0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
		
		//=====[fee] update=====
		flag1 = a_db.updateContFeeNew(fee);
		
					
		base.setRent_start_dt		(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
		base.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
		
		//=====[cont] update=====
		flag2 = a_db.updateContBaseNew(base);
		
		
		//�����ε���
		cont_etc.setCar_deli_dt		(request.getParameter("car_deli_dt")	==null?"":request.getParameter("car_deli_dt"));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag3 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag3 = a_db.updateContEtc(cont_etc);
		}
		
			
		
		//�������� �ϳ��� ����, �����ٻ������� ���ý� ����Ʈ ������ �����Ѵ�.-------------------------------------------------------
		
		
		String scd_reg_yn 	= request.getParameter("scd_reg_yn")==null?"":request.getParameter("scd_reg_yn");
		
		//�����뿩������ �뿩Ƚ�� �ִ밪
		int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);
		
		
		String cms_type 	= request.getParameter("cms_type")==null?"":request.getParameter("cms_type");
		
		//fee_rm
		ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");	
		fee_rm.setCms_type	(cms_type);
		//=====[fee_rm] update=====
		flag6 = a_db.updateFeeRm(fee_rm);

				
		if(max_fee_tm == 0 && scd_reg_yn.equals("Y")){

			//����ȸ��
			int i_fee_pay_tm = AddUtil.parseInt(fee.getFee_pay_tm());
							
			
			//�����̷� ���------------------------------------------------------------------------
			FeeScdCngBean cng = new FeeScdCngBean();
			cng.setRent_mng_id	(rent_mng_id);
			cng.setRent_l_cd	(rent_l_cd);
			cng.setFee_tm		("1");
			cng.setAll_st		("");
			cng.setGubun		("����Ʈ �űԻ���");
			cng.setB_value		("");
			cng.setA_value		(fee.getFee_pay_tm()+"ȸ��");
			cng.setCng_id		(user_id);
			cng.setCng_cau		("����Ʈ �űԻ��� ���");
		
			if(!af_db.insertFeeScdCng(cng)) flag += 1;
			
			//1ȸ�����Ⱓ
			String f_use_start_dt 	= fee.getRent_start_dt();
			String f_use_end_dt 	= fee.getRent_end_dt();
			String f_fee_est_dt 	= fee.getFee_fst_dt();
			
			//���ʰ������-�Ѿ�
			if(fee_rm.getF_paid_way().equals("2")){// || i_fee_pay_tm == 1
				
				FeeScdBean fee_scd = new FeeScdBean();
				
				fee_scd.setRent_mng_id		(rent_mng_id);
				fee_scd.setRent_l_cd		(rent_l_cd);
				fee_scd.setFee_tm		("1");			
				fee_scd.setRent_st		("1");						//����/����
				fee_scd.setTm_st2		("0");						//0-�Ϲݴ뿩�� (1-ȸ������)						
				fee_scd.setRent_seq		("1");			
				fee_scd.setTm_st1		("0");						//0-���뿩�� (1~�ܾ�)
				fee_scd.setRc_yn		("0");						//0-�̼���
				fee_scd.setUpdate_id		(user_id);				
				fee_scd.setUse_s_dt		(f_use_start_dt);				//1ȸ�� ���Ⱓ ������
				fee_scd.setUse_e_dt		(f_use_end_dt);					//1ȸ�� ���Ⱓ ������
				fee_scd.setFee_est_dt		(f_fee_est_dt);					//1ȸ�� ������								
				fee_scd.setFee_s_amt		(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt());	//1ȸ�� �뿩��
				fee_scd.setFee_v_amt		(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt());	//1ȸ�� �뿩��													
				fee_scd.setTax_out_dt		(fee_scd.getFee_est_dt());
				fee_scd.setR_fee_est_dt		(af_db.getValidDt(fee_scd.getFee_est_dt()));
				fee_scd.setReq_dt		(fee_scd.getFee_est_dt());
				fee_scd.setR_req_dt		(fee_scd.getFee_est_dt());
			

				if(fee_rm.getCons2_s_amt() > 0){
					//������ ����
					if(fee_rm.getF_paid_way2().equals("1")){
						fee_scd.setFee_s_amt		(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt());	//1ȸ�� �뿩��
						fee_scd.setFee_v_amt		(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt());	//1ȸ�� �뿩��									
					//������ ������					
					}else{
						//2ȸ�� ������ ���� ������ ����
						FeeScdBean fee_scd2 = new FeeScdBean();
						fee_scd2.setRent_mng_id		(rent_mng_id);
						fee_scd2.setRent_l_cd		(rent_l_cd);
						fee_scd2.setFee_tm		("2");			
						fee_scd2.setRent_st		("1");				//����/����
						fee_scd2.setTm_st2		("0");				//0-�Ϲݴ뿩�� (1-ȸ������)						
						fee_scd2.setRent_seq		("1");			
						fee_scd2.setTm_st1		("0");				//0-���뿩�� (1~�ܾ�)
						fee_scd2.setRc_yn		("0");				//0-�̼���
						fee_scd2.setUpdate_id		(user_id);				
						fee_scd2.setUse_s_dt		("");				//1ȸ�� ���Ⱓ ������
						fee_scd2.setUse_e_dt		("");				//1ȸ�� ���Ⱓ ������
						fee_scd2.setFee_est_dt		(fee.getRent_end_dt());		//1ȸ�� ������								
						fee_scd2.setFee_s_amt		(fee_rm.getCons2_s_amt());	//1ȸ�� �뿩��
						fee_scd2.setFee_v_amt		(fee_rm.getCons2_v_amt());	//1ȸ�� �뿩��								
						fee_scd2.setTax_out_dt		(fee_scd2.getFee_est_dt());
						fee_scd2.setR_fee_est_dt	(af_db.getValidDt(fee_scd2.getFee_est_dt()));
						fee_scd2.setReq_dt		(fee_scd2.getFee_est_dt());
						fee_scd2.setR_req_dt		(fee_scd2.getFee_est_dt());						
						
						if(!af_db.insertFeeScd(fee_scd2)) i_flag4 += 1;
					}
				}
				
				if(!af_db.insertFeeScd(fee_scd)) i_flag4 += 1;
								
				
				
			//���ʰ������-1����ġ�̰ų� ����ȸ���϶�
			}else{
				
				f_use_end_dt = c_db.addMonth(f_use_start_dt, 1);				
				f_use_end_dt = c_db.addDay(f_use_end_dt, -1);
				
				String r_use_end_dt 	= "";
				int count1 = 0;
				
				int r_t_fee_s_amt = 0;
				int r_t_fee_v_amt = 0;				
	
				for(int i = max_fee_tm ; i < i_fee_pay_tm+max_fee_tm ; i++){
				
					FeeScdBean fee_scd = new FeeScdBean();
					
				
					fee_scd.setRent_mng_id		(rent_mng_id);
					fee_scd.setRent_l_cd		(rent_l_cd);
					fee_scd.setFee_tm		(String.valueOf(i+1));			
					fee_scd.setRent_st		("1");						//����/����
					fee_scd.setTm_st2		("0");						//0-�Ϲݴ뿩�� (1-ȸ������)						
					fee_scd.setRent_seq		("1");			
					fee_scd.setTm_st1		("0");						//0-���뿩�� (1~�ܾ�)
					fee_scd.setRc_yn		("0");						//0-�̼���
					fee_scd.setUpdate_id		(user_id);
					
					
					//1ȸ��---------------------------------------------------------------------------------------------
					if(i == max_fee_tm){				
					
						fee_scd.setUse_s_dt		(f_use_start_dt);				//1ȸ�� ���Ⱓ ������
						fee_scd.setUse_e_dt		(f_use_end_dt);					//1ȸ�� ���Ⱓ ������
						fee_scd.setFee_est_dt		(f_fee_est_dt);					//1ȸ�� ������								
						fee_scd.setFee_s_amt		(fee.getFee_s_amt()+fee_rm.getCons1_s_amt());	//1ȸ�� �뿩��
						fee_scd.setFee_v_amt		(fee.getFee_v_amt()+fee_rm.getCons1_v_amt());	//1ȸ�� �뿩��	
						
						if(fee_rm.getCons2_s_amt() > 0){
							//������ ����
							if(fee_rm.getF_paid_way2().equals("1")){												
								fee_scd.setFee_s_amt		(fee_scd.getFee_s_amt()+fee_rm.getCons2_s_amt());	//1ȸ�� �뿩��
								fee_scd.setFee_v_amt		(fee_scd.getFee_v_amt()+fee_rm.getCons2_v_amt());	//1ȸ�� �뿩��								
							//������ ������������ 1ȸ���� �ִٸ� ������ �������ش�.	
							}else{
								if(i_fee_pay_tm == 1){
									fee_scd.setFee_s_amt	(fee_scd.getFee_s_amt()+fee_rm.getCons2_s_amt());	//1ȸ�� �뿩��
									fee_scd.setFee_v_amt	(fee_scd.getFee_v_amt()+fee_rm.getCons2_v_amt());	//1ȸ�� �뿩��
								}							
							}
						}
										
					}else{
					
						//2ȸ�� �Ⱓ�������� ��ȸ�� �������� �Ѵ�.
						fee_scd.setUse_s_dt		(c_db.addDay(r_use_end_dt, 1));				
						fee_scd.setUse_e_dt		(c_db.addMonth(f_use_end_dt, count1));
						fee_scd.setFee_est_dt		(c_db.addMonth(f_fee_est_dt, count1));
						fee_scd.setFee_s_amt		(fee.getFee_s_amt());
						fee_scd.setFee_v_amt		(fee.getFee_v_amt());
					
						//������ȸ���̸�
						if(i == (i_fee_pay_tm+max_fee_tm-1)){
							fee_scd.setUse_e_dt		(fee.getRent_end_dt());
														
							if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) <= AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
								fee_scd.setFee_est_dt		(fee_scd.getUse_s_dt());								
							}
							
							/*
							if(fee_rm.getCons2_s_amt() > 0){
								//���ʳ��Կ� ������ �����Խ� ������ȸ���� �߰�
								if(fee_rm.getF_paid_way2().equals("2")){												
									fee_scd.setFee_s_amt		(fee_scd.getFee_s_amt()+fee_rm.getCons2_s_amt());	//1ȸ�� �뿩��
									fee_scd.setFee_v_amt		(fee_scd.getFee_v_amt()+fee_rm.getCons2_v_amt());	//1ȸ�� �뿩��								
								}
							}
							*/
						
							fee_scd.setFee_s_amt		(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()-r_t_fee_s_amt);
							fee_scd.setFee_v_amt		(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt()-r_t_fee_v_amt);
							
						}
					}

					fee_scd.setTax_out_dt		(fee_scd.getFee_est_dt());
					fee_scd.setR_fee_est_dt		(af_db.getValidDt(fee_scd.getFee_est_dt()));
					fee_scd.setReq_dt		(fee_scd.getFee_est_dt());
					fee_scd.setR_req_dt		(fee_scd.getFee_est_dt());
					
					
					if(!af_db.insertFeeScd(fee_scd)) i_flag4 += 1;
					
					
					r_use_end_dt 		= fee_scd.getUse_e_dt();
					count1++;
					
					r_t_fee_s_amt 		= r_t_fee_s_amt + fee_scd.getFee_s_amt();
					r_t_fee_v_amt 		= r_t_fee_v_amt + fee_scd.getFee_v_amt();					
					
					
				}
				
			}						
						
		
		}
		
			//20151116 ����Ʈ �뿩���ý� �ڵ���ü ��û���� �ֱ�
			//cms_mng
			ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
			
			if(cms_type.equals("cms")){
			
				if(cms.getCms_start_dt().equals("")){
				
					if(fee.getFee_fst_dt().equals(""))	fee.setFee_fst_dt(fee.getRent_start_dt());
					
					cms.setCms_start_dt	(c_db.addMonth(fee.getFee_fst_dt(), 1));	
					cms.setCms_day		(fee.getFee_est_day());
				}
				
				if(cms.getApp_dt().equals("")){
					cms.setApp_dt(AddUtil.getDate());
					cms.setApp_id(user_id);
				}
				cms.setUpdate_id(user_id);
				//=====[cms_mng] update=====
				flag2 = a_db.updateContCmsMng(cms);
				
			}
			
			//�ſ�ī�� �ڵ����
			ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
			
			if(cms_type.equals("card")){
			
				if(card_cms.getCms_start_dt().equals("")){
				
					if(fee.getFee_fst_dt().equals(""))	fee.setFee_fst_dt(fee.getRent_start_dt());
					
					card_cms.setCms_start_dt	(c_db.addMonth(fee.getFee_fst_dt(), 1));	
					card_cms.setCms_day				(fee.getFee_est_day());
				}
				if(card_cms.getApp_dt().equals("")){
					card_cms.setApp_dt(AddUtil.getDate());
					card_cms.setApp_id(user_id);
				}
				card_cms.setUpdate_id(user_id);
				//=====[card_cms_mng] update=====
				flag2 = a_db.updateContCardCmsMng(card_cms);
				
			}			
						
						
			
			//����Ʈ ���������뺸��
			
			//2. ��޽��� �޼��� ����------------------------------------------------------------------------------------------
			
			if(client.getClient_st().equals("1") && AddUtil.parseInt(cm_bean.getS_st())>101 && AddUtil.parseInt(cm_bean.getS_st()) < 600 && AddUtil.parseInt(cm_bean.getS_st()) != 409){
			
				String sub 		= "����Ʈ ���������뺸��";
				String cont_b = "[ "+rent_l_cd+" "+client.getFirm_nm()+ " "+client.getEnp_no1()+"-"+client.getEnp_no2()+"-"+client.getEnp_no3()+" "+cr_bean.getCar_no();
				String cont = "";
				String url = "/fms2/lc_rent/lc_c_frame.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;
				String m_url = "/fms2/lc_rent/lc_c_frame.jsp";
				String target_id = nm_db.getWorkAuthUser("�λ꺸����");
			
				cont = cont_b + " ]  &lt;br&gt; &lt;br&gt; ����Ʈ ������  &lt;br&gt; &lt;br&gt; ";
				cont = cont + ec_db.getContCngInsCngMsg(rent_mng_id, rent_l_cd, "1");
			
				//���躯���û ���ν��� ȣ��
				String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "1");
			
				CarSchDatabase csd = CarSchDatabase.getInstance();
				CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
				if(!cs_bean.getUser_id().equals("")){
					target_id = nm_db.getWorkAuthUser("���纸����");
					//�������� ��� �ް��϶�
					cs_bean = csd.getCarScheTodayBean(target_id);
					if(!cs_bean.getWork_id().equals("")) target_id = cs_bean.getWork_id();
				}
			
				//����� ���� ��ȸ
				UsersBean target_bean2 	= umd.getUsersBean(target_id);			
				UsersBean sender_bean2 	= umd.getUsersBean(user_id);
			
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
				xml_data += "    <SENDER>"+sender_bean2.getId()+"</SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
			
				//�뿩�����϶� �߼��ϱ�� ��.
				//flag12 = cm_db.insertCoolMsg(msg);
			}
			
		
		//������ ��������� ���� ���� �߼��Ѵ�. : 20100716
				
		
		//��� ����� ���� ���� ����
		Hashtable sms = c_db.getDmailSms(rent_mng_id, rent_l_cd, "1");
		
		Hashtable cont_view = a_db.getContViewCase(rent_mng_id, rent_l_cd);
		
		UsersBean target_bean 	= umd.getUsersBean(base.getMng_id());
		
		String sms_reg_yn 	= request.getParameter("sms_reg_yn")==null?"":request.getParameter("sms_reg_yn");
		
		
		
		
		if(sms_reg_yn.equals("Y") ){  //20170209 (����) ����Ʈ ���ǻ��� �ȳ����� �߼�
		
						
			String s_destphone = "";
			s_destphone = String.valueOf(sms.get("TEL"));
			
			String s_destname = "";
			s_destname = String.valueOf(sms.get("NM"));
			
			//�����⺻����
   			ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
			
			String cont_sms 	= String.valueOf(cont_view.get("FIRM_NM"))+" ���� �ȳ��Ͻʴϱ�. ģ���� �ŷڷ� ��ô� �Ƹ���ī�Դϴ�. ��û�Ͻ� ����Ʈ ���� �̿��� ���� ���ǻ��� �ȳ� �帳�ϴ�. \n\n1. ����Ÿ� �� "+AddUtil.parseDecimal(f_fee_etc.getAgree_dist())+"km�ʰ��� �ʰ� 1km�� "+AddUtil.parseDecimal(f_fee_etc.getOver_run_amt())+"��(�ΰ�������)�� �ʰ����� �߰��뿩�� �ΰ� \n\n"+
			"2. ���� ��� �ѵ�\n- �빰 : 1��\n- ���� : ����\n- �ڱ��ü��� : ���.���� 1�� / �λ� 1,500����\n- �ڱ��������� ��å�� : ��� 1�Ǵ� �ִ� 30����\n- ���ó�� ����� : "+target_bean.getUser_nm()+" ("+target_bean.getUser_m_tel()+") \n"+
			" - ���ó�� �����(�������) : "+String.valueOf(insur.get("INS_COM_NM"))+" ("+  String.valueOf(insur.get("INS_TEL"))+")\n\n"+
			"3. �ſ�ī�� �ڵ���� ��û �ȳ�\n- �Ⱓ ���� �� ��� �翬��� ���뿩��, �ߵ������� �����, ��å��, ��ü����, ���·� ���� ������ ���Ͽ� ������ �ſ�ī�� �ڵ���� �̿��û���� �ۼ� �ϼž� �մϴ�. \n\n"+
			"4. ���� ���� �� �Ҹ�ǰ ����\n- ����� ���ǵ����Ʈ�� ���� �԰� �� ���� ����˴ϴ�. (�Ƹ���ī ���� ��)\n\n"+
			"5. ����⵿ : �Ƹ���ī������ ������  ������ ���� ����⵿ ���񽺸� 24�ð� �����մϴ�.\n- ����Ÿ����⵿ (1588-6688)\n\n"+
			"6. �����̿� �����\n- ��� ���� 7�������� �ϱ� ����ڿ��� ��û���ֽʽÿ�.\n- ���� ���� 9��- ���� 5�� / �ڿ��� ���� (010-3381-3388 / 042-824-1360) \n- ����, �뿩��, ��࿬��, �ݳ� ���ǵ� �����մϴ�. \n\n"+
			"7. �뿩 ���� ��� ������\n- "+String.valueOf(client.getClient_nm())+" ��";
			if(!s_person.equals("")){ 
				cont_sms+=","+ s_person+" ��";
			}
			cont_sms+="�� ���������մϴ�. \n\n8. ���� �ݳ��ð�\n- �ݳ��� ���� ���� 5����������\n\n9. ���� �ݳ����\n";
			if(   (insur.get("BR_ID")+"").equals("D1")    ){
				cont_sms+="��ȣ�ڵ��������� (042-824-1770)\n	���������� ����� �͵� 295-1����\n(��)�Ƹ���ī www.amazoncar.co.kr"; 
			} else if(   (insur.get("BR_ID")+"").equals("G1")    ){
			   cont_sms+="�������������� (053-582-2998)\n�뱸�� �޼��� �޼����109�� 58\n(��)�Ƹ���ī www.amazoncar.co.kr"; 
			} else if(   (insur.get("BR_ID")+"").equals("J1")    ){
			  cont_sms+="��1���ڵ��������� (062-385-0133)���� ���� �󹫴����� 131-1\n(��)�Ƹ���ī www.amazoncar.co.kr"; 
			} else if(   (insur.get("BR_ID")+"").equals("B1")    ){
			  cont_sms+="�ΰ��ڵ������� (051-851-0606)\n�λ� ������ ����õ�� 270���� 5\n(��)�Ƹ���ī www.amazoncar.co.kr"; 
			}else{
				cont_sms+="���������� (02-6263-6378)\n����� �������� �������� 34�� 9\n (��)�Ƹ���ī www.amazoncar.co.kr";
			}


			// jjlim add alimtalk
			// acar0038 ����Ʈ ��û �� �˸� -> acar0063���� ���� 
			if (s_destphone.equals("") == false) {
				String customer_name = String.valueOf(cont_view.get("FIRM_NM"));		// ���̸�
				String dist = AddUtil.parseDecimal(f_fee_etc.getAgree_dist());			// ����Ÿ�
				String dist_fee = AddUtil.parseDecimal(f_fee_etc.getOver_run_amt());	// ����Ÿ� �ʰ� ���
				String insur_mng_name = target_bean.getUser_nm();						// ���ó�� �����
				String insur_mng_pos = target_bean.getUser_pos();						// ���ó�� ����� ���� 
				String insur_mng_phone = " (" + target_bean.getUser_m_tel() + ")";		// ���ó�� ����� ��ȭ
				String insurance_name = String.valueOf(insur.get("INS_COM_NM"));		// ���ó�� �����
				String insurance_phone = String.valueOf(insur.get("INS_TEL"));			// ���ó�� ����� ��ȭ
				String driver = String.valueOf(client.getClient_nm()) + " ";			// ������
				String driver2 = s_person + " ���� ";			// ������
				String car_service_info = "���ǵ����Ʈ (https://www.speedmate.com/shop_search/shop_search.do)";		// �����ü
				String sos_service_info = "����Ÿ�ڵ��� (1588-6688)";								// ����⵿				
				String sk_net_info = "sk��Ʈ���� (1670-5494)"; //sk��Ʈ���� ����ó
				
				String etc1 = rent_l_cd;
				String etc2 = ck_acar_id;
				
				
				if(!s_person.equals("")){
					//driver += ", " + s_person + " ��";
				}else{
					driver2 = "����";
				}
				String visit_place = null;												// �ݳ����
				String return_place = null;												// �൵
				String parking_map = "";													// �൵
				if ((insur.get("BR_ID")+"").equals("D1")) {
					visit_place = "����ī��ũ 2�� (042-824-1770)\n������ ����� ���ɱ� 100";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg";
					parking_map = "http://kko.to/5kTS9j74J";
				}
				else if ((insur.get("BR_ID")+"").equals("G1")) {
					visit_place = "�������������� (053-582-2998)\n�뱸�� �޼��� �޼����109�� 58";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg";
					parking_map = "http://kko.to/9ZRdpTTmd";
				}
				else if ((insur.get("BR_ID")+"").equals("J1")) {
					visit_place = "��1���ڵ��������� (062-385-0133)���� ���� �󹫴����� 131-1";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg";
					parking_map = "http://kko.to/-VXvHD_ol";
				}
				else if ((insur.get("BR_ID")+"").equals("B1")) {
					visit_place = "�ΰ��ڵ������� (051-851-0606)\n�λ� ������ ����õ�� 270���� 5";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_p_bugyung.jpg";
					parking_map = "http://kko.to/0peONPKDI";
				}
				else {
					visit_place = "���������� (02-6263-6378)\n����� �������� �������� 34�� 9";
					//parking_map = "http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg";
					parking_map = "http://kko.to/M3C3ewyaQ";
				}
				if(!parking_map.equals("")){
					//return_place = "�൵ �ٷ� ���� "+ShortenUrlGoogle.getShortenUrl(parking_map); // �൵
					return_place = "�൵ �ٷ� ���� "+parking_map; // �൵
				}

				//acar0063- > acar0073 (��������) -> acar0110 (�ִ�ī����) -> 20220511 acar_0262, acar_0264
				//List<String> fieldList = Arrays.asList(customer_name, driver, dist, dist_fee, insur_mng_name, insur_mng_phone, insurance_name, insurance_phone,  car_service_info, sos_service_info,  insur_mng_name,  insur_mng_phone, visit_place, return_place);
				//at_db.sendMessageReserve("acar0110", fieldList, s_destphone,  "02-392-4242", null , etc1,  etc2);
				List<String> fieldList = Arrays.asList(customer_name, driver, driver2, dist, dist_fee, insur_mng_name, insur_mng_phone, insurance_name, insurance_phone);
				at_db.sendMessageReserve("acar_0262", fieldList, s_destphone,  "02-392-4242", null , etc1,  etc2);
				
				//�ð�����
				for(int t = 0; t <2; t++){
					Thread.sleep(1000);
				}
				
				List<String> fieldList2 = Arrays.asList(customer_name, car_service_info, sos_service_info, sk_net_info, insur_mng_name,  insur_mng_phone, visit_place, return_place, customer_name);
				at_db.sendMessageReserve("acar_0264", fieldList2, s_destphone,  "02-392-4242", null , etc1,  etc2);

			}


		}		
		
		
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�뿩���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');			<%		}	%>		
<%		if(!flag2){	%>	alert('���⺻���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
<%		if(!flag3){	%>	alert('����Ÿ���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("pay_way")){
	
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
			
		
		//�ڵ���ü-------------------------------------------------------------------------------------------
		
		//cms_mng
		ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
		
		String o_cms_est_dt = cms.getCms_start_dt();

		if(cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("CMS����",user_id) || nm_db.getWorkAuthUser("��ݴ��",user_id)){
		
			cms.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
			cms.setCms_bank		(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
			cms.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
			cms.setCms_day		(request.getParameter("cms_day")	==null?"":request.getParameter("cms_day"));
			
			cms.setCms_tel		(request.getParameter("cms_tel")==null?"":request.getParameter("cms_tel"));
			cms.setCms_m_tel	(request.getParameter("cms_m_tel")==null?"":request.getParameter("cms_m_tel"));
			cms.setCms_email	(request.getParameter("cms_email")==null?"":request.getParameter("cms_email"));
			cms.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
			
			cms.setCms_dep_post	(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
			cms.setCms_dep_addr	(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
			cms.setCms_start_dt	(request.getParameter("cms_start_dt")	==null?"":request.getParameter("cms_start_dt"));
			cms.setBank_cd		(request.getParameter("cms_bank_cd")	==null?"":request.getParameter("cms_bank_cd"));
		
			if(!cms.getBank_cd().equals("")){
				cms.setCms_bank		(c_db.getNameById(cms.getBank_cd(), "BANK"));
			}
			
			cms.setApp_dt(AddUtil.getDate());
			cms.setApp_id(user_id);
		
			if(!cms.getCms_acc_no().equals("")){
			
				if(cms.getSeq().equals("")){
					cms.setRent_mng_id	(rent_mng_id);
					cms.setRent_l_cd	(rent_l_cd);
					cms.setReg_st		("1");
					cms.setCms_st		("1");
					cms.setReg_id		(user_id);
					//=====[cms_mng] insert=====
					flag2 = a_db.insertContCmsMng(cms);
					
					
					//�ڵ���ü ��û �޽��� ����
					
					
					
					
				}else{
					cms.setUpdate_id	(user_id);
					//=====[cms_mng] update=====
					flag2 = a_db.updateContCmsMng(cms);
				}
			}
			
			
			String cms_est_dt 	= request.getParameter("cms_start_dt")==null?"":request.getParameter("cms_start_dt");
			String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
			String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
			String c_client_nm 	= request.getParameter("c_client_nm")==null?"":request.getParameter("c_client_nm");
			
			//�ڵ���ü����ڿ��� �뺸
			String memo_title 	= "����Ʈ-";
	
		
			memo_title += car_no+" "+c_firm_nm+" "+c_client_nm;		
		
			//��ü���� �߰�
			if(!cms_est_dt.equals("")){
				memo_title = memo_title + ", ��ü������ : "+cms_est_dt+" ";
			}
			
			
			
			String sub4 	= "����Ʈ CMS �ڵ���ü ��û";
			String cont4 	= "����Ʈ CMS �ڵ���ü ��û("+memo_title+")�Ǿ����� Ȯ���Ͻñ� �ٶ��ϴ�.";
			String url4	= "/fms2/lc_rent/lc_c_frame.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|c_st=rm";
			String m_url  ="/fms2/lc_rent/cms_rm_s_frame.jsp";
			UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("CMS����"));
		
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean4 = csd.getCarScheTodayBean(target_bean4.getUser_id());
			if(!cs_bean4.getUser_id().equals("") && !cs_bean4.getWork_id().equals("")){
				String target_id4 = cs_bean4.getWork_id();
				target_bean4 	= umd.getUsersBean(target_id4);
			}
		
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data4 = "";
			xml_data4 =  "<COOLMSG>"+
  					 "<ALERTMSG>"+
					 "    <BACKIMG>4</BACKIMG>"+
					 "    <MSGTYPE>104</MSGTYPE>"+
					 "    <SUB>"+sub4+"</SUB>"+
  					 "    <CONT>"+cont4+"</CONT>"+
					 "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url4+"&m_url="+m_url+"</URL>"; 						 
			xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
			xml_data4 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
 					 "    <MSGICON>10</MSGICON>"+
 					 "    <MSGSAVE>1</MSGSAVE>"+
 					 "    <LEAVEDMSG>1</LEAVEDMSG>"+
  					 "    <FLDTYPE>1</FLDTYPE>"+
 					 "  </ALERTMSG>"+
 					 "</COOLMSG>";
			
			CdAlertBean msg4 = new CdAlertBean();
			msg4.setFlddata(xml_data4);
			msg4.setFldtype("1");
			
			
			if(o_cms_est_dt.equals("") && !cms_est_dt.equals("")){
				flag4 = cm_db.insertCoolMsg(msg4);
			}
			
		}
		
	
	

	%>
<script language='javascript'>
<%		if(!flag2){	%>	alert('�ڵ���ü ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
</script>
<%	}%>


<%
	if(cng_item.equals("pay_way3")){
	
		//fee
		ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
			
		
		//�ڵ���ü-------------------------------------------------------------------------------------------
		
		//cms_mng
		ContCmsBean card_cms = a_db.getCardCmsMng(rent_mng_id, rent_l_cd);
		
		String o_cms_est_dt = card_cms.getCms_start_dt();

		if(card_cms.getApp_dt().equals("") || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("CMS����",user_id) || nm_db.getWorkAuthUser("�ſ�ī���ڵ����",user_id)){
		
			card_cms.setCms_acc_no	(request.getParameter("c_cms_acc_no")	==null?"":request.getParameter("c_cms_acc_no"));
			card_cms.setCms_bank		(request.getParameter("c_cms_bank")	==null?"":request.getParameter("c_cms_bank"));
			card_cms.setCms_dep_nm	(request.getParameter("c_cms_dep_nm")	==null?"":request.getParameter("c_cms_dep_nm"));
			card_cms.setCms_day			(request.getParameter("c_cms_day")	==null?"":request.getParameter("c_cms_day"));
			
			card_cms.setCms_tel			(request.getParameter("c_cms_tel")==null?"":request.getParameter("c_cms_tel"));
			card_cms.setCms_m_tel		(request.getParameter("c_cms_m_tel")==null?"":request.getParameter("c_cms_m_tel"));
			card_cms.setCms_email		(request.getParameter("c_cms_email")==null?"":request.getParameter("c_cms_email"));
			card_cms.setCms_dep_ssn	(request.getParameter("c_cms_dep_ssn")==null?"":request.getParameter("c_cms_dep_ssn"));
			
			card_cms.setCms_dep_post(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
			card_cms.setCms_dep_addr(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
			card_cms.setCms_start_dt(request.getParameter("c_cms_start_dt")	==null?"":request.getParameter("c_cms_start_dt"));
			
			card_cms.setApp_dt(AddUtil.getDate());
			card_cms.setApp_id(user_id);
			
			
		
			if(!card_cms.getCms_acc_no().equals("") || !card_cms.getCms_bank().equals("")){
			
				if(card_cms.getSeq().equals("")){
					card_cms.setRent_mng_id	(rent_mng_id);
					card_cms.setRent_l_cd	(rent_l_cd);
					card_cms.setReg_st		("1");
					card_cms.setCms_st		("1");
					card_cms.setReg_id		(user_id);
					//=====[card_cms_mng] insert=====
					flag2 = a_db.insertContCardCmsMng(card_cms);
					
					
					//�ڵ���ü ��û �޽��� ����				
					
					
					
				}else{
					card_cms.setUpdate_id	(user_id);
					//=====[card_cms_mng] update=====
					flag2 = a_db.updateContCardCmsMng(card_cms);
				}
			}
			
			
			String cms_est_dt 	= request.getParameter("c_cms_start_dt")==null?"":request.getParameter("c_cms_start_dt");
			String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
			String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
			String c_client_nm 	= request.getParameter("c_client_nm")==null?"":request.getParameter("c_client_nm");
			
			//�ڵ���ü����ڿ��� �뺸
			String memo_title 	= "����Ʈ-";
	
		
			memo_title += car_no+" "+c_firm_nm+" "+c_client_nm;		
		
			//��ü���� �߰�
			if(!cms_est_dt.equals("")){
				memo_title = memo_title + ", ��ü������ : "+cms_est_dt+" ";
			}
			
			
			
			String sub4 	= "����Ʈ �ſ�ī�� �ڵ���� ��û";
			String cont4 	= "����Ʈ �ſ�ī�� �ڵ���� ��û("+memo_title+")�Ǿ����� Ȯ���Ͻñ� �ٶ��ϴ�.";
			String url4	= "/fms2/lc_rent/lc_c_frame.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|c_st=rm";
			String m_url  ="/fms2/lc_rent/cms_rm_s_frame.jsp";
			UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("CMS����"));
		
			CarSchDatabase csd = CarSchDatabase.getInstance();
			CarScheBean cs_bean4 = csd.getCarScheTodayBean(target_bean4.getUser_id());
			if(!cs_bean4.getUser_id().equals("") && !cs_bean4.getWork_id().equals("")){
				String target_id4 = cs_bean4.getWork_id();
				target_bean4 	= umd.getUsersBean(target_id4);
			}
		
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data4 = "";
			xml_data4 =  "<COOLMSG>"+
  					 "<ALERTMSG>"+
					 "    <BACKIMG>4</BACKIMG>"+
					 "    <MSGTYPE>104</MSGTYPE>"+
					 "    <SUB>"+sub4+"</SUB>"+
  					 "    <CONT>"+cont4+"</CONT>"+
					 "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url4+"&m_url="+m_url+"</URL>"; 						 
			xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
			xml_data4 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
 					 "    <MSGICON>10</MSGICON>"+
 					 "    <MSGSAVE>1</MSGSAVE>"+
 					 "    <LEAVEDMSG>1</LEAVEDMSG>"+
  					 "    <FLDTYPE>1</FLDTYPE>"+
 					 "  </ALERTMSG>"+
 					 "</COOLMSG>";
			
			CdAlertBean msg4 = new CdAlertBean();
			msg4.setFlddata(xml_data4);
			msg4.setFldtype("1");
			
			
			if(o_cms_est_dt.equals("") && !cms_est_dt.equals("")){
				flag4 = cm_db.insertCoolMsg(msg4);				
			}
			
		}
		
	
	

	%>
<script language='javascript'>
<%		if(!flag2){	%>	alert('�ſ�ī�� �ڵ���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');		<%		}	%>		
</script>
<%	}%>



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
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;
	
	if('<%=from_page%>' == '/fms2/lc_rent/lc_bc_frame.jsp'){
		fm.rent_st.value = '<%=request.getParameter("rent_st")==null?"1":request.getParameter("rent_st")%>';
		fm.action = '/fms2/lc_rent/lc_bc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else if('<%=from_page%>' == '/fms2/car_pur/pur_doc_u.jsp'){
		fm.rent_st.value = '1';
		fm.action = '/fms2/car_pur/pur_doc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else if('<%=from_page%>' == '/fms2/lc_rent/lc_c_c_fee.jsp' && '<%=base.getCar_st()%>' == '4'){
		fm.action = '/fms2/lc_rent/lc_c_c_fee_rm.jsp';		
		fm.target = 'c_foot';
		fm.submit();		
	}else{
		fm.action = '<%=from_page%>';	
		fm.target = 'c_foot';
		fm.submit();
	}
	
	parent.window.close();
//	window.close();

</script>
</body>
</html>
