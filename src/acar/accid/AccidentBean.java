/**
 * �����
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.accid;

import java.util.*;

public class AccidentBean {
    //Table : CAR_REG
	private String car_mng_id; 					//�ڵ���������ȣ
	private String car_no;
	private String client_nm;
	private String firm_nm;
	private String accid_id;
	private String rent_mng_id;
	private String rent_l_cd;
	private String accid_st;
	private String accid_st_nm;
	private String our_car_nm;
	private String our_car_name;	
	private String our_driver;
	private String our_tel;
	private String our_m_tel;
	private String our_ssn;
	private String our_lic_kd;
	private String our_lic_no;
	private String our_ins;
	private String our_num;
	private String our_post;
	private String our_addr;
	private String accid_dt;
	private String accid_city;
	private String accid_gu;
	private String accid_dong;
	private String accid_point;
	private String accid_cont;
	private String ot_car_no;
	private String ot_car_nm;
	private String ot_driver;
	private String ot_tel;
	private String ot_m_tel;
	private String ot_ins;
	private String ot_num;
	private String ot_ins_nm;
	private String ot_ins_tel;
	private String ot_ins_m_tel;
	private String ot_pol_sta;
	private String ot_pol_nm;
	private String ot_pol_tel;
	private String ot_pol_m_tel;
	private int hum_amt;
	private String hum_nm;
	private String hum_tel;
	private int mat_amt;
	private String mat_nm;
	private String mat_tel;
	private int one_amt;
	private String one_nm;
	private String one_tel;
	private int my_amt;
	private String my_nm;
	private String my_tel;
	private String ref_dt;
	private int ex_tot_amt;
	private int tot_amt;
	private int rec_amt;
	private String rec_dt;
	private String rec_plan_dt;
	private int sup_amt;
	private String sup_dt;
	private int ins_sup_amt;
	private String ins_sup_dt;
	private int ins_tot_amt;
	private String off_id;
	private String off_nm;
	private String serv_id;	
	//�߰�
	//�������� ��� �Ұ�� ����
	private String sub_rent_gu;	//�뿩����(���������,�ܱ�뿩,��Ÿ)
	private String sub_firm_nm;	//��ȣ
	private String sub_rent_st;	//���Ⱓ������
	private String sub_rent_et;	//���Ⱓ������
	private String sub_etc;		//Ư�̻���
	//���,��������
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	//��������
	private String our_lic_dt;
	private String our_tel2;
	private String ot_ssn;
	private String ot_lic_kd;
	private String ot_lic_no;
	private String ot_tel2;
	private String our_dam_st;
	private String ot_dam_st;
	//�����
	private String accid_addr;
	private String accid_cont2;
	private String imp_fault_st;
	private String imp_fault_sub;
	private int our_fault_per;
	private String ot_pol_st;
	private String ot_pol_num;
	private String ot_pol_fax;
	//������/������
	private String ins_req_gu;
	private String ins_req_st;
	private String ins_car_nm;
	private String ins_car_no;
	private int ins_day_amt;
	private String ins_use_st;
	private String ins_use_et;
	private String ins_nm;
	private String ins_tel;
	private int ins_req_amt;
	private String ins_req_dt;
	private int ins_pay_amt;
	private String ins_pay_dt;
	private String ins_use_day;
	private String r_site;
	private String use_yn;
	private String cls_st;	
	private String memo;
	private String car_in_dt;	//�����԰�����
	private String car_out_dt;	//�����������
	private String ins_end_dt;	//���躸��Ϸ���
	//�߰� 2004.07.07
	private String rent_s_cd;		//�ܱ����ȣ
	private String accid_type;		//�������
	private String accid_type_sub;	//�������-����
	private String speed;		//����üӵ�
	private String road_stat;	//����õ��θ����
	private String road_stat2;	//����õ��θ����
	private String weather;		//����ó���
	private String hum_end_dt;	//���κ��躸��Ϸ���
	private String mat_end_dt;	//�빰���躸��Ϸ���
	private String one_end_dt;	//�ڼպ��躸��Ϸ���
	private String my_end_dt;	//�������躸��Ϸ���
	private String settle_st;	//ó������
	private String settle_dt;	//ó���Ϸ�����
	private String settle_id;	//�Ϸ������
	private String settle_cont;	//ó������
	private String settle_note;	//���������� �߰� : 2010-11-24
	//�߰� 2004.08.17
	private String settle_st1;	//ó������
	private String settle_dt1;	//ó���Ϸ�����
	private String settle_id1;	//�Ϸ������
	private String settle_st2;	//ó������
	private String settle_dt2;	//ó���Ϸ�����
	private String settle_id2;	//�Ϸ������
	private String settle_st3;	//ó������
	private String settle_dt3;	//ó���Ϸ�����
	private String settle_id3;	//�Ϸ������
	private String settle_st4;	//ó������
	private String settle_dt4;	//ó���Ϸ�����
	private String settle_id4;	//�Ϸ������
	private String settle_st5;	//ó������
	private String settle_dt5;	//ó���Ϸ�����
	private String settle_id5;	//�Ϸ������
	private String dam_type1;	//���Ը�-����
	private String dam_type2;	//���Ը�-�빰
	private String dam_type3;	//���Ը�-�ڼ�
	private String dam_type4;	//���Ը�-����
	private String settle_st6;	//ó������
	private String settle_dt6;	//ó���Ϸ�����
	private String settle_id6;	//�Ϸ������
	private int    amor_amt;	//������� �Աݾ�
	private String amor_nm;		//������� �����
	private String amor_tel;	//������� ����ó
	private String amor_end_dt;	//������� ����Ϸ���
	private int    amor_req_amt;	//������� û���ݾ�
	private String amor_req_dt;		//������� û������
	
	private String bus_id2;		//������ �����
	private String acc_dt;
	private String acc_id;
	//20121128
	private String reg_ip;
	
	// 20161004  ����Ȯ���� ���翩�� 
	private String pre_doc;
	private String pre_cls;

	//20201224 - ��������
	private String asset_st;
	
    // CONSTRCTOR            
    public AccidentBean() {  
		this.car_mng_id = ""; 					//�ڵ���������ȣ
		this.car_no = "";
		this.client_nm = "";
		this.firm_nm = "";
		this.accid_id = "";
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.accid_st = "";
		this.accid_st_nm = "";
		this.our_car_nm = "";
		this.our_car_name = "";
		this.our_driver = "";
		this.our_tel = "";
		this.our_m_tel = "";
		this.our_ssn = "";
		this.our_lic_kd = "";
		this.our_lic_no = "";
		this.our_ins = "";
		this.our_num = "";
		this.our_post = "";
		this.our_addr = "";
		this.accid_dt = "";
		this.accid_city = "";
		this.accid_gu = "";
		this.accid_dong = "";
		this.accid_point = "";
		this.accid_cont = "";
		this.ot_car_no = "";
		this.ot_car_nm = "";
		this.ot_driver = "";
		this.ot_tel = "";
		this.ot_m_tel = "";
		this.ot_ins = "";
		this.ot_num = "";
		this.ot_ins_nm = "";
		this.ot_ins_tel = "";
		this.ot_ins_m_tel = "";
		this.ot_pol_sta = "";
		this.ot_pol_nm = "";
		this.ot_pol_tel = "";
		this.ot_pol_m_tel = "";
		this.hum_amt = 0;
		this.hum_nm = "";
		this.hum_tel = "";
		this.mat_amt = 0;
		this.mat_nm = "";
		this.mat_tel = "";
		this.one_amt = 0;
		this.one_nm = "";
		this.one_tel = "";
		this.my_amt = 0;
		this.my_nm = "";
		this.my_tel = "";
		this.ref_dt = "";
		this.ex_tot_amt = 0;
		this.tot_amt = 0;
		this.rec_amt = 0;
		this.rec_dt = "";
		this.rec_plan_dt = "";
		this.sup_amt = 0;
		this.sup_dt = "";
		this.ins_sup_amt = 0;
		this.ins_sup_dt = "";
		this.ins_tot_amt = 0;
		this.off_id = "";
		this.off_nm = "";
		this.serv_id = "";
		//�߰�
		this.sub_rent_gu = "";	//�뿩����(���������,�ܱ�뿩,��Ÿ)
		this.sub_firm_nm = "";	//��ȣ
		this.sub_rent_st = "";	//���Ⱓ������
		this.sub_rent_et = "";	//���Ⱓ������
		this.sub_etc = "";		//Ư�̻���
		//���,��������
		this.reg_dt = "";
		this.reg_id = "";
		this.update_dt = "";
		this.update_id = "";
		//��������
		this.our_lic_dt = "";
		this.our_tel2 = "";
		this.ot_ssn = "";
		this.ot_lic_kd = "";
		this.ot_lic_no = "";
		this.ot_tel2 = "";
		this.our_dam_st = "";
		this.ot_dam_st = "";
		//�����
		this.accid_addr = "";
		this.accid_cont2 = "";
		this.imp_fault_st = "";
		this.imp_fault_sub = "";
		this.our_fault_per = 0;
		this.ot_pol_st = "";
		this.ot_pol_num = "";
		this.ot_pol_fax = "";
		//������/������
		this.ins_req_gu = "";
		this.ins_req_st = "";
		this.ins_car_nm = "";
		this.ins_car_no = "";
		this.ins_day_amt =0;
		this.ins_use_st = "";
		this.ins_use_et = "";
		this.ins_nm = "";
		this.ins_tel = "";
		this.ins_req_amt = 0;
		this.ins_req_dt = "";
		this.ins_pay_amt = 0;
		this.ins_pay_dt = "";
		this.ins_use_day = "";
		this.r_site = "";
		this.use_yn = "";
		this.cls_st = "";
		this.memo = "";
		this.car_in_dt = "";
		this.car_out_dt = "";
		this.ins_end_dt = "";
		this.rent_s_cd = "";
		this.accid_type = "";
		this.accid_type_sub = "";
		this.speed = "";
		this.road_stat = "";
		this.road_stat2 = "";
		this.weather = "";
		this.hum_end_dt = "";
		this.mat_end_dt = "";
		this.one_end_dt = "";
		this.my_end_dt = "";
		this.settle_st = "";
		this.settle_dt = "";
		this.settle_id = "";
		this.settle_cont = "";
		this.settle_note = "";
		this.settle_st1 = "";
		this.settle_dt1 = "";
		this.settle_id1 = "";
		this.settle_st2 = "";
		this.settle_dt2 = "";
		this.settle_id2 = "";
		this.settle_st3 = "";
		this.settle_dt3 = "";
		this.settle_id3 = "";
		this.settle_st4 = "";
		this.settle_dt4 = "";
		this.settle_id4 = "";
		this.settle_st5 = "";
		this.settle_dt5 = "";
		this.settle_id5 = "";
		this.dam_type1 = "";
		this.dam_type2 = "";
		this.dam_type3 = "";
		this.dam_type4 = "";
		this.settle_st6 = "";
		this.settle_dt6 = "";
		this.settle_id6 = "";
		this.amor_amt		= 0;
		this.amor_nm		= "";
		this.amor_tel		= "";
		this.amor_end_dt	= "";
		this.amor_req_amt	= 0;
		this.amor_req_dt	= "";		
		this.bus_id2	= "";
		this.acc_dt = "";
		this.acc_id = "";
		this.reg_ip = "";
		this.pre_doc = "";
		this.pre_cls = "";
		this.asset_st = "";
		
	}


	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
	public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
	public void setAccid_id(String val){
		if(val==null) val="";
		this.accid_id = val;
	}
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
	public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setAccid_st(String val){
		if(val==null) val="";
		this.accid_st = val;
	}
	public void setOur_car_nm(String val){
		if(val==null) val="";
		this.our_car_nm = val;
	}
	public void setOur_car_name(String val){
		if(val==null) val="";
		this.our_car_name = val;
	}
	public void setOur_driver(String val){
		if(val==null) val="";
		this.our_driver = val;
	}
	public void setOur_tel(String val){
		if(val==null) val="";
		this.our_tel = val;
	}
	public void setOur_m_tel(String val){
		if(val==null) val="";
		this.our_m_tel = val;
	}
	public void setOur_ssn(String val){
		if(val==null) val="";
		this.our_ssn = val;
	}
	public void setOur_lic_kd(String val){
		if(val==null) val="";
		this.our_lic_kd = val;
	}
	public void setOur_lic_no(String val){
		if(val==null) val="";
		this.our_lic_no = val;
	}
	public void setOur_ins(String val){
		if(val==null) val="";
		this.our_ins = val;
	}
	public void setOur_num(String val){
		if(val==null) val="";
		this.our_num = val;
	}
	public void setOur_post(String val){
		if(val==null) val="";
		this.our_post = val;
	}
	public void setOur_addr(String val){
		if(val==null) val="";
		this.our_addr = val;
	}
	public void setAccid_dt(String val){
		if(val==null) val="";
		this.accid_dt = val;
	}
	public void setAccid_city(String val){
		if(val==null) val="";
		this.accid_city = val;
	}
	public void setAccid_gu(String val){
		if(val==null) val="";
		this.accid_gu = val;
	}
	public void setAccid_dong(String val){
		if(val==null) val="";
		this.accid_dong = val;
	}
	public void setAccid_point(String val){
		if(val==null) val="";
		this.accid_point = val;
	}
	public void setAccid_cont(String val){
		if(val==null) val="";
		this.accid_cont = val;
	}
	public void setOt_car_no(String val){
		if(val==null) val="";
		this.ot_car_no = val;
	}
	public void setOt_car_nm(String val){
		if(val==null) val="";
		this.ot_car_nm = val;
	}
	public void setOt_driver(String val){
		if(val==null) val="";
		this.ot_driver = val;
	}
	public void setOt_tel(String val){
		if(val==null) val="";
		this.ot_tel = val;
	}
	public void setOt_m_tel(String val){
		if(val==null) val="";
		this.ot_m_tel = val;
	}
	public void setOt_ins(String val){
		if(val==null) val="";
		this.ot_ins = val;
	}
	public void setOt_num(String val){
		if(val==null) val="";
		this.ot_num = val;
	}
	public void setOt_ins_nm(String val){
		if(val==null) val="";
		this.ot_ins_nm = val;
	}
	public void setOt_ins_tel(String val){
		if(val==null) val="";
		this.ot_ins_tel = val;
	}
	public void setOt_ins_m_tel(String val){
		if(val==null) val="";
		this.ot_ins_m_tel = val;
	}
	public void setOt_pol_sta(String val){
		if(val==null) val="";
		this.ot_pol_sta = val;
	}
	public void setOt_pol_nm(String val){
		if(val==null) val="";
		this.ot_pol_nm = val;
	}
	public void setOt_pol_tel(String val){
		if(val==null) val="";
		this.ot_pol_tel = val;
	}
	public void setOt_pol_m_tel(String val){
		if(val==null) val="";
		this.ot_pol_m_tel = val;
	}
	public void setHum_amt(int val){
		this.hum_amt = val;
	}
	public void setHum_nm(String val){
		if(val==null) val="";
		this.hum_nm = val;
	}
	public void setHum_tel(String val){
		if(val==null) val="";
		this.hum_tel = val;
	}
	public void setMat_amt(int val){
		this.mat_amt = val;
	}
	public void setMat_nm(String val){
		if(val==null) val="";
		this.mat_nm = val;
	}
	public void setMat_tel(String val){
		if(val==null) val="";
		this.mat_tel = val;
	}
	public void setOne_amt(int val){
		this.one_amt = val;
	}
	public void setOne_nm(String val){
		if(val==null) val="";
		this.one_nm = val;
	}
	public void setOne_tel(String val){
		if(val==null) val="";
		this.one_tel = val;
	}
	public void setMy_amt(int val){
		this.my_amt = val;
	}
	public void setMy_nm(String val){
		if(val==null) val="";
		this.my_nm = val;
	}
	public void setMy_tel(String val){
		if(val==null) val="";
		this.my_tel = val;
	}
	public void setRef_dt(String val){
		if(val==null) val="";
		this.ref_dt = val;
	}
	public void setEx_tot_amt(int val){
		this.ex_tot_amt = val;
	}
	public void setTot_amt(int val){
		this.tot_amt = val;
	}
	public void setRec_amt(int val){
		this.rec_amt = val;
	}
	public void setRec_dt(String val){
		if(val==null) val="";
		this.rec_dt = val;
	}
	public void setRec_plan_dt(String val){
		if(val==null) val="";
		this.rec_plan_dt = val;
	}
	public void setSup_amt(int val){
		this.sup_amt = val;
	}
	public void setSup_dt(String val){
		if(val==null) val="";
		this.sup_dt = val;
	}
	public void setIns_sup_amt(int val){
		this.ins_sup_amt = val;
	}
	public void setIns_sup_dt(String val){
		if(val==null) val="";
		this.ins_sup_dt = val;
	}
	public void setIns_tot_amt(int val){
		this.ins_tot_amt = val;
	}
	public void setOff_id(String val){
		if(val==null) val="";
		this.off_id = val;
	}
	public void setOff_nm(String val){
		if(val==null) val="";
		this.off_nm = val;
	}
	public void setServ_id(String val){
		if(val==null) val="";
		this.serv_id = val;
	}	
	public void setSub_rent_gu(String val){		if(val==null) val="";	this.sub_rent_gu = val;	}	
	public void setSub_firm_nm(String val){		if(val==null) val="";	this.sub_firm_nm = val;	}	
	public void setSub_rent_st(String val){		if(val==null) val="";	this.sub_rent_st = val;	}	
	public void setSub_rent_et(String val){		if(val==null) val="";	this.sub_rent_et = val;	}	
	public void setSub_etc(String val){			if(val==null) val="";	this.sub_etc = val;		}	
	public void setReg_dt(String val){			if(val==null) val="";	this.reg_dt = val;		}	
	public void setReg_id(String val){			if(val==null) val="";	this.reg_id = val;		}	
	public void setUpdate_dt(String val){		if(val==null) val="";	this.update_dt = val;	}	
	public void setUpdate_id(String val){		if(val==null) val="";	this.update_id = val;	}	
	public void setOur_lic_dt(String val){		if(val==null) val="";	this.our_lic_dt = val;	}	
	public void setOur_tel2(String val){		if(val==null) val="";	this.our_tel2 = val;	}	
	public void setOt_ssn(String val){			if(val==null) val="";	this.ot_ssn = val;		}	
	public void setOt_lic_kd(String val){		if(val==null) val="";	this.ot_lic_kd = val;	}	
	public void setOt_lic_no(String val){		if(val==null) val="";	this.ot_lic_no = val;	}	
	public void setOt_tel2(String val){			if(val==null) val="";	this.ot_tel2 = val;		}	
	public void setOur_dam_st(String val){		if(val==null) val="";	this.our_dam_st = val;	}	
	public void setOt_dam_st(String val){		if(val==null) val="";	this.ot_dam_st = val;	}	
	public void setAccid_addr(String val){		if(val==null) val="";	this.accid_addr = val;	}	
	public void setAccid_cont2(String val){		if(val==null) val="";	this.accid_cont2 = val;	}	
	public void setImp_fault_st(String val){	if(val==null) val="";	this.imp_fault_st = val;}	
	public void setImp_fault_sub(String val){	if(val==null) val="";	this.imp_fault_sub = val;}	
	public void setOur_fault_per(int val){								this.our_fault_per = val;}
	public void setOt_pol_st(String val){		if(val==null) val="";	this.ot_pol_st = val;	}	
	public void setOt_pol_num(String val){		if(val==null) val="";	this.ot_pol_num = val;	}	
	public void setOt_pol_fax(String val){		if(val==null) val="";	this.ot_pol_fax = val;	}	
	public void setIns_req_gu(String val){		if(val==null) val="";	this.ins_req_gu = val;	}	
	public void setIns_req_st(String val){		if(val==null) val="";	this.ins_req_st = val;	}	
	public void setIns_car_nm(String val){		if(val==null) val="";	this.ins_car_nm = val;	}	
	public void setIns_car_no(String val){		if(val==null) val="";	this.ins_car_no = val;	}	
	public void setIns_day_amt(int val){								this.ins_day_amt = val;	}
	public void setIns_use_st(String val){		if(val==null) val="";	this.ins_use_st = val;	}	
	public void setIns_use_et(String val){		if(val==null) val="";	this.ins_use_et = val;	}	
	public void setIns_nm(String val){			if(val==null) val="";	this.ins_nm = val;		}	
	public void setIns_tel(String val){			if(val==null) val="";	this.ins_tel = val;		}	
	public void setIns_req_amt(int val){								this.ins_req_amt = val;	}
	public void setIns_req_dt(String val){		if(val==null) val="";	this.ins_req_dt = val;	}	
	public void setIns_pay_amt(int val){								this.ins_pay_amt = val;	}
	public void setIns_pay_dt(String val){		if(val==null) val="";	this.ins_pay_dt = val;	}	
	public void setIns_use_day(String val){		if(val==null) val="";	this.ins_use_day = val;	}	
	public void setR_site(String val){			if(val==null) val="";	this.r_site = val;		}	
	public void setUse_yn(String val){			if(val==null) val="";	this.use_yn = val;		}	
	public void setCls_st(String val){			if(val==null) val="";	this.cls_st = val;		}	
	public void setMemo(String val){			if(val==null) val="";	this.memo = val;		}
	public void setCar_in_dt(String val){		if(val==null) val="";	this.car_in_dt = val;	}
	public void setCar_out_dt(String val){		if(val==null) val="";	this.car_out_dt = val;	}
	public void setIns_end_dt(String val){		if(val==null) val="";	this.ins_end_dt = val;	}
	public void setRent_s_cd(String val){		if(val==null) val="";	this.rent_s_cd = val;	}
	public void setAccid_type(String val){		if(val==null) val="";	this.accid_type = val;	}
	public void setAccid_type_sub(String val){	if(val==null) val="";	this.accid_type_sub = val;}
	public void setSpeed(String val){			if(val==null) val="";	this.speed = val;		}
	public void setRoad_stat(String val){		if(val==null) val="";	this.road_stat = val;	}
	public void setRoad_stat2(String val){		if(val==null) val="";	this.road_stat2 = val;	}
	public void setWeather(String val){			if(val==null) val="";	this.weather = val;		}
	public void setHum_end_dt(String val){		if(val==null) val="";	this.hum_end_dt = val;	}
	public void setMat_end_dt(String val){		if(val==null) val="";	this.mat_end_dt = val;	}
	public void setOne_end_dt(String val){		if(val==null) val="";	this.one_end_dt = val;	}
	public void setMy_end_dt(String val){		if(val==null) val="";	this.my_end_dt = val;	}
	public void setSettle_st(String val){		if(val==null) val="";	this.settle_st = val;	}
	public void setSettle_dt(String val){		if(val==null) val="";	this.settle_dt = val;	}
	public void setSettle_id(String val){		if(val==null) val="";	this.settle_id = val;	}
	public void setSettle_cont(String val){		if(val==null) val="";	this.settle_cont = val;	}
	public void setSettle_note(String val){		if(val==null) val="";	this.settle_note = val;	}

	public void setSettle_st1(String val){		if(val==null) val="";	this.settle_st1 = val;	}
	public void setSettle_dt1(String val){		if(val==null) val="";	this.settle_dt1 = val;	}
	public void setSettle_id1(String val){		if(val==null) val="";	this.settle_id1 = val;	}
	public void setSettle_st2(String val){		if(val==null) val="";	this.settle_st2 = val;	}
	public void setSettle_dt2(String val){		if(val==null) val="";	this.settle_dt2 = val;	}
	public void setSettle_id2(String val){		if(val==null) val="";	this.settle_id2 = val;	}
	public void setSettle_st3(String val){		if(val==null) val="";	this.settle_st3 = val;	}
	public void setSettle_dt3(String val){		if(val==null) val="";	this.settle_dt3 = val;	}
	public void setSettle_id3(String val){		if(val==null) val="";	this.settle_id3 = val;	}
	public void setSettle_st4(String val){		if(val==null) val="";	this.settle_st4 = val;	}
	public void setSettle_dt4(String val){		if(val==null) val="";	this.settle_dt4 = val;	}
	public void setSettle_id4(String val){		if(val==null) val="";	this.settle_id4 = val;	}
	public void setSettle_st5(String val){		if(val==null) val="";	this.settle_st5 = val;	}
	public void setSettle_dt5(String val){		if(val==null) val="";	this.settle_dt5 = val;	}
	public void setSettle_id5(String val){		if(val==null) val="";	this.settle_id5 = val;	}
	public void setDam_type1(String val){		if(val==null) val="";	this.dam_type1 = val;	}
	public void setDam_type2(String val){		if(val==null) val="";	this.dam_type2 = val;	}
	public void setDam_type3(String val){		if(val==null) val="";	this.dam_type3 = val;	}
	public void setDam_type4(String val){		if(val==null) val="";	this.dam_type4 = val;	}
	public void setSettle_st6(String val){		if(val==null) val="";	this.settle_st6 = val;	}
	public void setSettle_dt6(String val){		if(val==null) val="";	this.settle_dt6 = val;	}
	public void setSettle_id6(String val){		if(val==null) val="";	this.settle_id6 = val;	}

	public void setAmor_amt		(int val)	{							this.amor_amt		= val;	}
	public void setAmor_nm		(String val){	if(val==null) val="";	this.amor_nm		= val;	}	
	public void setAmor_tel		(String val){	if(val==null) val="";	this.amor_tel		= val;	}	
	public void setAmor_end_dt	(String val){	if(val==null) val="";	this.amor_end_dt	= val;	}	
	public void setAmor_req_amt	(int val)	{							this.amor_req_amt	= val;	}
	public void setAmor_req_dt	(String val){	if(val==null) val="";	this.amor_req_dt	= val;	}	
	public void setBus_id2		(String val){	if(val==null) val="";	this.bus_id2	= val;	}	
	public void setAcc_dt(String val){			if(val==null) val="";	this.acc_dt = val;		}	
	public void setAcc_id(String val){			if(val==null) val="";	this.acc_id = val;		}	
	public void setReg_ip(String val){			if(val==null) val="";	this.reg_ip = val;		}	

	public void setPre_doc(String val){			if(val==null) val="";	this.pre_doc = val;		}	
	public void setPre_cls(String val){			if(val==null) val="";	this.pre_cls = val;		}	
	
	public void setAsset_st(String val){		if(val==null) val="";	this.asset_st = val;		}	

	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getCar_no(){
		return car_no;
	}
	public String getClient_nm(){
		return client_nm;
	}
	public String getFirm_nm(){
		return firm_nm;
	}
	public String getAccid_id(){
		return accid_id;
	}
	public String getRent_mng_id(){
		return rent_mng_id;
	}
	public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getAccid_st(){
		return accid_st;
	}
	public String getOur_car_nm(){
		return our_car_nm;
	}
	public String getOur_car_name(){
		return our_car_name;
	}
	public String getOur_driver(){
		return our_driver;
	}
	public String getOur_tel(){
		return our_tel;
	}
	public String getOur_m_tel(){
		return our_m_tel;
	}
	public String getOur_ssn(){
		return our_ssn;
	}
	public String getOur_lic_kd(){
		return our_lic_kd;
	}
	public String getOur_lic_no(){
		return our_lic_no;
	}
	public String getOur_ins(){
		return our_ins;
	}
	public String getOur_num(){
		return our_num;
	}
	public String getOur_post(){
		return our_post;
	}
	public String getOur_addr(){
		return our_addr;
	}
	public String getAccid_dt(){
		return accid_dt;
	}
	public String getAccid_city(){
		return accid_city;
	}
	public String getAccid_gu(){
		return accid_gu;
	}
	public String getAccid_dong(){
		return accid_dong;
	}
	public String getAccid_point(){
		return accid_point;
	}
	public String getAccid_cont(){
		return accid_cont;
	}
	public String getOt_car_no(){
		return ot_car_no;
	}
	public String getOt_car_nm(){
		return ot_car_nm;
	}
	public String getOt_driver(){
		return ot_driver;
	}
	public String getOt_tel(){
		return ot_tel;
	}
	public String getOt_m_tel(){
		return ot_m_tel;
	}
	public String getOt_ins(){
		return ot_ins;
	}
	public String getOt_num(){
		return ot_num;
	}
	public String getOt_ins_nm(){
		return ot_ins_nm;
	}
	public String getOt_ins_tel(){
		return ot_ins_tel;
	}
	public String getOt_ins_m_tel(){
		return ot_ins_m_tel;
	}
	public String getOt_pol_sta(){
		return ot_pol_sta;
	}
	public String getOt_pol_nm(){
		return ot_pol_nm;
	}
	public String getOt_pol_tel(){
		return ot_pol_tel;
	}
	public String getOt_pol_m_tel(){
		return ot_pol_m_tel;
	}
	public int getHum_amt(){
		return hum_amt;
	}
	public String getHum_nm(){
		return hum_nm;
	}
	public String getHum_tel(){
		return hum_tel;
	}
	public int getMat_amt(){
		return mat_amt;
	}
	public String getMat_nm(){
		return mat_nm;
	}
	public String getMat_tel(){
		return mat_tel;
	}
	public int getOne_amt(){
		return one_amt;
	}
	public String getOne_nm(){
		return one_nm;
	}
	public String getOne_tel(){
		return one_tel;
	}
	public int getMy_amt(){
		return my_amt;
	}
	public String getMy_nm(){
		return my_nm;
	}
	public String getMy_tel(){
		return my_tel;
	}
	public String getRef_dt(){
		return ref_dt;
	}
	public int getEx_tot_amt(){
		return ex_tot_amt;
	}
	public int getTot_amt(){
		return tot_amt;
	}
	public int getRec_amt(){
		return rec_amt;
	}
	public String getRec_dt(){
		return rec_dt;
	}
	public String getRec_plan_dt(){
		return rec_plan_dt;
	}
	public int getSup_amt(){
		return sup_amt;
	}
	public String getSup_dt(){
		return sup_dt;
	}
	public int getIns_sup_amt(){
		return ins_sup_amt;
	}
	public String getIns_sup_dt(){
		return ins_sup_dt;
	}
	public int getIns_tot_amt(){
		return ins_tot_amt;
	}
	public String getOff_id(){
		return off_id;
	}
	public String getOff_nm(){
		return off_nm;
	}
	public String getServ_id(){
		return serv_id;
	}
	public String getSub_rent_gu(){		return sub_rent_gu;	}	
	public String getSub_firm_nm(){		return sub_firm_nm;	}	
	public String getSub_rent_st(){		return sub_rent_st;	}	
	public String getSub_rent_et(){		return sub_rent_et;	}	
	public String getSub_etc(){			return sub_etc;		}	
	public String getReg_dt(){			return reg_dt;		}	
	public String getReg_id(){			return reg_id;		}	
	public String getUpdate_dt(){		return update_dt;	}	
	public String getUpdate_id(){		return update_id;	}	
	public String getOur_lic_dt(){		return our_lic_dt;	}	
	public String getOur_tel2(){		return our_tel2;	}	
	public String getOt_ssn(){			return ot_ssn;		}	
	public String getOt_lic_kd(){		return ot_lic_kd;	}	
	public String getOt_lic_no(){		return ot_lic_no;	}	
	public String getOt_tel2(){			return ot_tel2;		}	
	public String getOur_dam_st(){		return our_dam_st;	}	
	public String getOt_dam_st(){		return ot_dam_st;	}	
	public String getAccid_addr(){		return accid_addr;	}	
	public String getAccid_cont2(){		return accid_cont2;	}	
	public String getImp_fault_st(){	return imp_fault_st;}	
	public String getImp_fault_sub(){	return imp_fault_sub;}	
	public int getOur_fault_per(){		return our_fault_per;}
	public String getOt_pol_st(){		return ot_pol_st;	}	
	public String getOt_pol_num(){		return ot_pol_num;	}	
	public String getOt_pol_fax(){		return ot_pol_fax;	}	
	public String getIns_req_gu(){		return ins_req_gu;	}	
	public String getIns_req_st(){		return ins_req_st;	}	
	public String getIns_car_nm(){		return ins_car_nm;	}	
	public String getIns_car_no(){		return ins_car_no;	}	
	public int getIns_day_amt(){		return ins_day_amt;	}
	public String getIns_use_st(){		return ins_use_st;	}	
	public String getIns_use_et(){		return ins_use_et;	}	
	public String getIns_nm(){			return ins_nm;		}	
	public String getIns_tel(){			return ins_tel;		}	
	public int getIns_req_amt(){		return ins_req_amt;	}
	public String getIns_req_dt(){		return ins_req_dt;	}	
	public int getIns_pay_amt(){		return ins_pay_amt;	}
	public String getIns_pay_dt(){		return ins_pay_dt;	}	
	public String getIns_use_day(){		return ins_use_day;	}	
	public String getR_site(){			return r_site;		}	
	public String getUse_yn(){			return use_yn;		}
	public String getCls_st(){			return cls_st;		}
/*	public String getUse_yn_nm(){
		if(use_yn.equals("Y"))			use_yn_nm = "�뿩";
		else							use_yn_nm = "����";
		return use_yn_nm;
	}	*/
	public String getAccid_st_nm(){
		if(accid_st.equals("1"))		accid_st_nm = "����";
		else if(accid_st.equals("2"))	accid_st_nm = "����";
		else if(accid_st.equals("3"))	accid_st_nm = "�ֹ�";
		else if(accid_st.equals("4"))	accid_st_nm = "��������";
		else if(accid_st.equals("5"))	accid_st_nm = "�������";
		else if(accid_st.equals("6"))	accid_st_nm = "����";
		else if(accid_st.equals("7"))	accid_st_nm = "�縮������";
		else						accid_st_nm = "�ܵ�";
		return accid_st_nm;
	}
	public String getMemo(){ return memo; }
	public String getCar_in_dt(){ return car_in_dt; }
	public String getCar_out_dt(){ return car_out_dt; }
	public String getIns_end_dt(){ return ins_end_dt; }
	public String getRent_s_cd(){ return rent_s_cd; }
	public String getAccid_type(){ return accid_type; }
	public String getAccid_type_sub(){ return accid_type_sub; }
	public String getSpeed(){ return speed; }
	public String getRoad_stat(){ return road_stat; }
	public String getRoad_stat2(){ return road_stat2; }
	public String getWeather(){ return weather; }
	public String getHum_end_dt(){ return hum_end_dt; }
	public String getMat_end_dt(){ return mat_end_dt; }
	public String getOne_end_dt(){ return one_end_dt; }
	public String getMy_end_dt(){ return my_end_dt; }
	public String getSettle_st(){ return settle_st; }
	public String getSettle_dt(){ return settle_dt; }
	public String getSettle_id(){ return settle_id; }
	public String getSettle_cont(){ return settle_cont; }
	public String getSettle_note(){ return settle_note; } //��� �������� �߰� 2010-11-24

	public String getSettle_st1(){ return settle_st1; }
	public String getSettle_dt1(){ return settle_dt1; }
	public String getSettle_id1(){ return settle_id1; }
	public String getSettle_st2(){ return settle_st2; }
	public String getSettle_dt2(){ return settle_dt2; }
	public String getSettle_id2(){ return settle_id2; }
	public String getSettle_st3(){ return settle_st3; }
	public String getSettle_dt3(){ return settle_dt3; }
	public String getSettle_id3(){ return settle_id3; }
	public String getSettle_st4(){ return settle_st4; }
	public String getSettle_dt4(){ return settle_dt4; }
	public String getSettle_id4(){ return settle_id4; }
	public String getSettle_st5(){ return settle_st5; }
	public String getSettle_dt5(){ return settle_dt5; }
	public String getSettle_id5(){ return settle_id5; }
	public String getDam_type1(){ return dam_type1; }
	public String getDam_type2(){ return dam_type2; }
	public String getDam_type3(){ return dam_type3; }
	public String getDam_type4(){ return dam_type4; }
	public String getSettle_st6(){ return settle_st6; }
	public String getSettle_dt6(){ return settle_dt6; }
	public String getSettle_id6(){ return settle_id6; }

	public int    getAmor_amt		(){		return amor_amt;		}
	public String getAmor_nm		(){		return amor_nm;			}	
	public String getAmor_tel		(){		return amor_tel;		}	
	public String getAmor_end_dt	(){		return amor_end_dt;		}	
	public int    getAmor_req_amt	(){		return amor_req_amt;	}
	public String getAmor_req_dt	(){		return amor_req_dt;		}	
	public String getBus_id2	(){		return bus_id2;		}	
	public String getAcc_dt(){			return acc_dt;		}	
	public String getAcc_id(){			return acc_id;		}	
	public String getReg_ip(){			return reg_ip;		}	
	
	public String getPre_doc(){			return pre_doc;		}	
	public String getPre_cls(){			return pre_cls;		}	
	public String getAsset_st(){			return asset_st;		}  //��������	

}
