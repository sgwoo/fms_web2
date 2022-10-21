/**
 * 사고기록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_accident;

import java.util.*;

public class AccidentBean {
    //Table : CAR_REG
	private String car_mng_id; 					//자동차관리번호
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
	//추가
	//예비차일 경우 소계약 내용
	private String sub_rent_gu;	//대여구분(출고전대차,단기대여,기타)
	private String sub_firm_nm;	//상호
	private String sub_rent_st;	//계약기간시작일
	private String sub_rent_et;	//계약기간종료일
	private String sub_etc;		//특이사항
	//등록,수정정보
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	//인적사항
	private String our_lic_dt;
	private String our_tel2;
	private String ot_ssn;
	private String ot_lic_kd;
	private String ot_lic_no;
	private String ot_tel2;
	private String our_dam_st;
	private String ot_dam_st;
	//사고내용
	private String accid_addr;
	private String accid_cont2;
	private String imp_fault_st;
	private String imp_fault_sub;
	private int our_fault_per;
	private String ot_pol_st;
	private String ot_pol_num;
	private String ot_pol_fax;
	//휴차료/대차료
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

    // CONSTRCTOR            
    public AccidentBean() {  
		this.car_mng_id = ""; 					//자동차관리번호
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
		//추가
		this.sub_rent_gu = "";	//대여구분(출고전대차,단기대여,기타)
		this.sub_firm_nm = "";	//상호
		this.sub_rent_st = "";	//계약기간시작일
		this.sub_rent_et = "";	//계약기간종료일
		this.sub_etc = "";		//특이사항
		//등록,수정정보
		this.reg_dt = "";
		this.reg_id = "";
		this.update_dt = "";
		this.update_id = "";
		//인적사항
		this.our_lic_dt = "";
		this.our_tel2 = "";
		this.ot_ssn = "";
		this.ot_lic_kd = "";
		this.ot_lic_no = "";
		this.ot_tel2 = "";
		this.our_dam_st = "";
		this.ot_dam_st = "";
		//사고내용
		this.accid_addr = "";
		this.accid_cont2 = "";
		this.imp_fault_st = "";
		this.imp_fault_sub = "";
		this.our_fault_per = 0;
		this.ot_pol_st = "";
		this.ot_pol_num = "";
		this.ot_pol_fax = "";
		//휴차료/대차료
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
		if(use_yn.equals("Y"))			use_yn_nm = "대여";
		else							use_yn_nm = "해지";
		return use_yn_nm;
	}	*/
	public String getAccid_st_nm(){
		if(accid_st.equals("1"))		accid_st_nm = "피해자";
		else if(accid_st.equals("2"))	accid_st_nm = "가해자";
		else if(accid_st.equals("3"))	accid_st_nm = "쌍방";
		else if(accid_st.equals("4"))	accid_st_nm = "운행자차";
		else if(accid_st.equals("5"))	accid_st_nm = "사고자차";
		else if(accid_st.equals("6"))	accid_st_nm = "수해";
		else if(accid_st.equals("7"))	accid_st_nm = "재리스정비";


		return accid_st_nm;
	}
	public String getMemo(){ return memo; }

}
