/**
 * 오프리스 수의매각정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 27. Tue.
 * @ last modify date : 
 */
package acar.offls_sui;

import java.util.*;

public class SuiBean {
    //Table : SUI
	private String car_mng_id;
	private String client_id;
	private String sui_nm;
	private String ssn;
	private String relation;
	private String h_tel;
	private String m_tel;
	private String cont_dt;
	private String h_addr;
	private String h_zip;
	private String d_addr;
	private String d_zip;
	private String car_nm;
	private String car_relation;
	private String car_addr;
	private String car_zip;
	private String car_ssn;
	private String car_h_tel;
	private String car_m_tel;
	private String etc;
	private String suifile;
	private String lpgfile;
	private String ass_st_dt;
	private String ass_ed_dt;
	private String ass_st_km;
	private String ass_ed_km;
	private String ass_wrt;
	private int mm_pr;
	private int cont_pr;
	private int jan_pr;
	private String modify_id;
	private String cont_pr_dt;
	private String jan_pr_dt;
	private String migr_dt;
	private String migr_no;
	private String enp_no;
	private String email;
   	private String sui_st;
   	private String des_zip;
   	private String des_addr;
   	private String des_nm;
   	private String bill_doc_yn;  //폐차 계산서 발행으로 인한 추가 - 20140710
	private String udt_dt;
	private String des_tel; //수취인연락처 - 20191021
	private String accid_yn; //수의계약(잔존물)  - 20201119
	private int sh_car_amt;  //수의계약(잔존물) 잔가 
    // CONSTRCTOR
    public SuiBean() {
		this.car_mng_id = "";
		this.client_id = "";
		this.sui_nm = "";
		this.ssn = "";
		this.relation = "";
		this.h_tel = "";
		this.m_tel = "";
		this.cont_dt = "";
		this.h_addr = "";
		this.h_zip = "";
		this.d_addr = "";
		this.d_zip = "";
		this.car_nm = "";
		this.car_relation = "";
		this.car_addr = "";
		this.car_zip = "";
		this.car_ssn = "";
		this.car_h_tel = "";
		this.car_m_tel = "";
		this.etc = "";
		this.suifile = "";
		this.lpgfile = "";
		this.ass_st_dt = "";
		this.ass_ed_dt = "";
		this.ass_st_km = "";
		this.ass_ed_km = "";
		this.ass_wrt = "";
		this.mm_pr = 0;
		this.cont_pr = 0;
		this.jan_pr = 0;
		this.modify_id = "";
		this.cont_pr_dt = "";
		this.jan_pr_dt = "";
		this.migr_dt = "";
		this.migr_no = "";
		this.enp_no = "";
		this.email = "";
		this.sui_st = "";
		this.des_zip = "";
		this.des_addr = "";
		this.des_nm = "";
		this.bill_doc_yn = "";
		this.udt_dt = "";
		this.des_tel = "";
		this.accid_yn = "";
		this.sh_car_amt = 0;
	}

	// set Method
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val; }
	public void setSui_nm(String val){ if(val==null) val=""; this.sui_nm = val; }
	public void setSsn(String val){ if(val==null) val=""; this.ssn = val; }
	public void setRelation(String val){ if(val==null) val=""; this.relation = val; }
	public void setH_tel(String val){ if(val==null) val=""; this.h_tel = val; }
	public void setM_tel(String val){ if(val==null) val=""; this.m_tel = val; }
	public void setCont_dt(String val){ if(val==null) val=""; this.cont_dt = val; }
	public void setH_addr(String val){ if(val==null) val=""; this.h_addr = val; }
	public void setH_zip(String val){ if(val==null) val=""; this.h_zip = val; }
	public void setD_addr(String val){ if(val==null) val=""; this.d_addr = val; }
	public void setD_zip(String val){ if(val==null) val=""; this.d_zip = val; }
	public void setCar_nm(String val){ if(val==null) val=""; this.car_nm = val; }
	public void setCar_relation(String val){ if(val==null) val=""; this.car_relation = val; }
	public void setCar_addr(String val){ if(val==null) val=""; this.car_addr = val; }
	public void setCar_zip(String val){ if(val==null) val=""; this.car_zip = val; }
	public void setCar_ssn(String val){ if(val==null) val=""; this.car_ssn = val; }
	public void setCar_h_tel(String val){ if(val==null) val=""; this.car_h_tel = val; }
	public void setCar_m_tel(String val){ if(val==null) val=""; this.car_m_tel = val; }
	public void setEtc(String val){ if(val==null) val=""; this.etc = val; }
	public void setSuifile(String val){ if(val==null) val=""; this.suifile = val; }
	public void setLpgfile(String val){ if(val==null) val=""; this.lpgfile = val; }
	public void setAss_st_dt(String val){ if(val==null) val=""; this.ass_st_dt = val; }
	public void setAss_ed_dt(String val){ if(val==null) val=""; this.ass_ed_dt = val; }
	public void setAss_st_km(String val){ if(val==null) val=""; this.ass_st_km = val; }
	public void setAss_ed_km(String val){ if(val==null) val=""; this.ass_ed_km = val; }
	public void setAss_wrt(String val){ if(val==null) val=""; this.ass_wrt = val; }
	public void setMm_pr(int val){ this.mm_pr = val; }
	public void setCont_pr(int val){ this.cont_pr = val; }
	public void setJan_pr(int val){ this.jan_pr = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }
	public void setCont_pr_dt(String val){ if(val==null) val=""; this.cont_pr_dt = val; }
	public void setJan_pr_dt(String val){ if(val==null) val=""; this.jan_pr_dt = val; }
	public void setMigr_dt(String val){ if(val==null) val=""; this.migr_dt = val; }
	public void setMigr_no(String val){ if(val==null) val=""; this.migr_no = val; }
	public void setEnp_no(String val){ if(val==null) val=""; this.enp_no = val; }
	public void setEmail(String val){ if(val==null) val=""; this.email = val; }
	public void setSui_st(String val){ if(val==null) val=""; this.sui_st = val; }
	public void setDes_zip(String val){ if(val==null) val=""; this.des_zip = val; }
	public void setDes_addr(String val){ if(val==null) val=""; this.des_addr = val; }
	public void setDes_nm(String val){ if(val==null) val=""; this.des_nm = val; }
	public void setBill_doc_yn(String val){ if(val==null) val=""; this.bill_doc_yn = val; }
	public void setUdt_dt(String val){ if(val==null) val=""; this.udt_dt = val; }
	public void setDes_tel(String val){ if(val==null) val=""; this.des_tel = val; }
	public void setAccid_yn(String val){ if(val==null) val=""; this.accid_yn = val; }
	public void setSh_car_amt(int val){ this.sh_car_amt = val; }


	//get Method
	public String getCar_mng_id(){ return car_mng_id; }
	public String getClient_id(){ return client_id; }
	public String getSui_nm(){ return sui_nm; }
	public String getSsn(){ return ssn; }
	public String getRelation(){ return relation; }
	public String getH_tel(){ return h_tel; }
	public String getM_tel(){ return m_tel; }
	public String getCont_dt(){ return cont_dt; }
	public String getH_addr(){ return h_addr; }
	public String getH_zip(){ return h_zip; }
	public String getD_addr(){ return d_addr; }
	public String getD_zip(){ return d_zip; }
	public String getCar_nm(){ return car_nm; }
	public String getCar_relation(){ return car_relation; }
	public String getCar_addr(){ return car_addr; }
	public String getCar_zip(){ return car_zip; }
	public String getCar_ssn(){ return car_ssn; }
	public String getCar_h_tel(){ return car_h_tel; }
	public String getCar_m_tel(){ return car_m_tel; }
	public String getEtc(){ return etc; }
	public String getSuifile(){ return suifile; }
	public String getLpgfile(){ return lpgfile; }
	public String getAss_st_dt(){ return ass_st_dt; }
	public String getAss_ed_dt(){ return ass_ed_dt; }
	public String getAss_st_km(){ return ass_st_km; }
	public String getAss_ed_km(){ return ass_ed_km; }
	public String getAss_wrt(){ return ass_wrt; }
	public int getMm_pr(){ return mm_pr; }
	public int getCont_pr(){ return cont_pr; }
	public int getJan_pr(){ return jan_pr; }
	public String getModify_id(){ return modify_id; }
	public String getCont_pr_dt(){ return cont_pr_dt; }
	public String getJan_pr_dt(){ return jan_pr_dt; }
	public String getMigr_dt(){ return migr_dt; }
	public String getMigr_no(){ return migr_no; }
	public String getEnp_no(){ return enp_no; }
	public String getEmail(){ return email; }
	public String getSui_st(){ return sui_st; }
	public String getDes_zip(){ return des_zip; }
	public String getDes_addr(){ return des_addr; }
	public String getDes_nm(){ return des_nm; }
	public String getBill_doc_yn(){ return bill_doc_yn; }
	public String getUdt_dt(){ return udt_dt; }
	public String getDes_tel(){ return des_tel; }
	public String getAccid_yn(){ return accid_yn; }
	public int getSh_car_amt(){ return sh_car_amt; }
}