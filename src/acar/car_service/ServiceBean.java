/**
 * 서비스
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_service;

import java.util.*;

public class ServiceBean {
    //Table : SERVICE
    private String car_no;
	private String car_mng_id; 					//자동차관리번호
	private String serv_id; 
	private String accid_id; 
	private String rent_mng_id; 
	private String rent_l_cd; 
	private String off_id;
	private String off_nm; 
	private String serv_dt; 
	private String serv_st;
	private String serv_st_nm; 
	private String checker; 
	private String tot_dist; 
	private String rep_nm; 
	private String rep_tel; 
	private String rep_m_tel; 
	private int rep_amt; 
	private int sup_amt; 
	private int add_amt; 
	private int dc; 
	private int tot_amt; 
	private String sup_dt; 
	private String set_dt; 
	private String bank; 
	private String acc_no; 
	private String acc_nm; 
	private String rep_item; 
	private String rep_cont; 
	private String cust_plan_dt; 
	private int cust_amt; 
	private String cust_agnt;
	private String accid_dt;	
	private String off_tel;		//추가
	private String off_fax; 
	private String cust_req_dt;
	private String cust_pay_dt;
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	private String scan_file;	
	private String no_dft_yn;
	private String no_dft_cau;
   	private String bill_doc_yn;		//거래명세서포함여부  0:세금계산서 미발행 1:개별발행
	private String bill_mon;		//거래명세서포함월	
	private String serv_jc;
	private String cust_serv_dt;
	private String next_serv_dt;
	private String next_rep_cont;
	private String spd_chk;	//추가 2004.01.08.	
	private String ipgodt;
	private String chulgodt;
	private String tax_yn;			//세금계산서 발행여부
	private String jung_st;			//정산회차 :  1->1회차 2->2회차 3->3회차 4->4회차
	private int r_labor;            //공임계( 도장을 공임에 포함)
	private int r_amt;  			//부품계
	private int r_dc;               //부품dc
	private int r_j_amt;  			//부품dc 반영금액
	private int ext_amt;  			//고객직접입금액(정비업체)
	private String jung_st_r;
	private int cls_amt;  			//해지정산포함금액
	private int cls_s_amt;  			//해지정산포함금액
	private int cls_v_amt;  			//해지정산포함금액
	private int cust_s_amt;  			//청구 공급가액
	private int cust_v_amt;  			//청구 부가세액
	private String ext_cau;		  //고객 입금 사유
	private String sac_yn;		  //면책금 담당자 확인
	private String sac_dt;		  //면책금 담당자 확인일자
	
	private String paid_st;		  //면책금 청구구분
	private String paid_type;		  //면책금 수금방법(cms, 무통장)
	private String bus_id2;		  //비용담당자 - 사고

	private String car_comp_id;
	private String spdchk_dt;	//추가 2004.07.20.
	private int dly_amt;
	
	private String file_path;		  //scan file 경로
	private String saleebill_yn;	  //입금표발행 유무
	private String agnt_email;	  //입금표발행 이메일
	
	private String pre_set_dt;   //정산현황II 사용
		        
    // CONSTRCTOR            
    public ServiceBean() {  
    	this.car_no = "";
		this.car_mng_id = ""; 					//자동차관리번호
		this.serv_id = ""; 
		this.accid_id = ""; 
		this.rent_mng_id = ""; 
		this.rent_l_cd = ""; 
		this.off_id = ""; 
		this.off_nm = "";
		this.serv_dt = ""; 
		this.serv_st = ""; 
		this.serv_st_nm = "";
		this.checker = ""; 
		this.tot_dist = ""; 
		this.rep_nm = ""; 
		this.rep_tel = ""; 
		this.rep_m_tel = ""; 
		this.rep_amt = 0; 
		this.sup_amt = 0; 
		this.add_amt = 0; 
		this.dc = 0; 
		this.tot_amt = 0; 
		this.sup_dt = ""; 
		this.set_dt = ""; 
		this.bank = ""; 
		this.acc_no = ""; 
		this.acc_nm = ""; 
		this.rep_item = ""; 
		this.rep_cont = ""; 
		this.cust_plan_dt = ""; 
		this.cust_amt = 0; 
		this.cust_agnt = "";
		this.accid_dt = "";
		this.off_tel = ""; 
		this.off_fax = "";
		this.cust_req_dt = "";
		this.cust_pay_dt = "";
		this.reg_dt = "";
		this.reg_id = "";
		this.update_dt = "";
		this.update_id = "";
		this.scan_file = "";
		this.no_dft_yn = "";
		this.no_dft_cau = "";
		this.bill_doc_yn = "";
		this.bill_mon = "";
		this.serv_jc = "";
		this.cust_serv_dt = "";
		this.next_serv_dt = "";
		this.next_rep_cont = "";
		this.spd_chk = "";
		this.ipgodt = "";
		this.chulgodt = "";
		this.tax_yn = "";
		this.jung_st = "";
		this.r_labor = 0; 
		this.r_amt	= 0;
		this.r_dc = 0; 
		this.r_j_amt	= 0;
		this.ext_amt	= 0;
		this.jung_st_r  = "";
		this.cls_amt	= 0;
		this.cls_s_amt  = 0;  			//해지정산포함금액
		this.cls_v_amt  = 0;  			//해지정산포함금액
		this.cust_s_amt = 0;  			//청구 공급가액
		this.cust_v_amt = 0;  			//청구 부가세액
		this.ext_cau  = "";		  //고객 입금 사유
		this.sac_yn  = "";		 //면책금 담당자 확인
		this.sac_dt  = "";		  //면책금 담당자 확인일자
		
		this.paid_st  = "";		  //면책금 청구구분
		this.paid_type  = "";		  //면책금 수금방법
		this.bus_id2  = "";		  //비용담당자

		this.car_comp_id = "";
		this.spdchk_dt = "";
		this.dly_amt	= 0;
		this.file_path = "";
		this.saleebill_yn = "";
		this.agnt_email = "";
		
		this.pre_set_dt = "";

	}

	// get Method
	public void setCar_no(String val){		if(val==null) val="";		this.car_no = val;	}
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id = val;	}
	public void setServ_id		(String val){		if(val==null) val="";		this.serv_id = val;	} 
	public void setAccid_id		(String val){		if(val==null) val="";		this.accid_id = val;	} 
	public void setRent_mng_id	(String val){		if(val==null) val="";		this.rent_mng_id = val;	} 
	public void setRent_l_cd(String val){		if(val==null) val="";		this.rent_l_cd = val;	} 
	public void setOff_id(String val){		if(val==null) val="";		this.off_id = val;	}
	public void setOff_nm(String val){		if(val==null) val="";		this.off_nm = val;	} 
	public void setServ_dt(String val){		if(val==null) val="";		this.serv_dt = val;	} 
	public void setServ_st(String val){		if(val==null) val="";		this.serv_st = val;	}
	public void setChecker(String val){		if(val==null) val="";		this.checker = val;	} 
	public void setTot_dist(String val){		if(val==null) val="";		this.tot_dist = val;	} 
	public void setRep_nm(String val){		if(val==null) val="";		this.rep_nm = val;	} 
	public void setRep_tel(String val){		if(val==null) val="";		this.rep_tel = val;	} 
	public void setRep_m_tel(String val){		if(val==null) val="";		this.rep_m_tel = val;	} 
	public void setRep_amt(int val){		this.rep_amt = val;	} 
	public void setSup_amt(int val){		this.sup_amt = val;	} 
	public void setAdd_amt(int val){		this.add_amt = val;	} 
	public void setDc(int val){		this.dc = val;	} 
	public void setTot_amt(int val){		this.tot_amt = val;	} 
	public void setSup_dt(String val){		if(val==null) val="";		this.sup_dt = val;	} 
	public void setSet_dt(String val){		if(val==null) val="";		this.set_dt = val;	} 
	public void setBank(String val){		if(val==null) val="";		this.bank = val;	} 
	public void setAcc_no(String val){		if(val==null) val="";		this.acc_no = val;	} 
	public void setAcc_nm(String val){		if(val==null) val="";		this.acc_nm = val;	} 
	public void setRep_item(String val){		if(val==null) val="";		this.rep_item = val;	} 
	public void setRep_cont(String val){		if(val==null) val="";		this.rep_cont = val;	} 
	public void setCust_plan_dt(String val){		if(val==null) val="";		this.cust_plan_dt = val;	} 
	public void setCust_amt(int val){		this.cust_amt = val;	} 
	public void setCust_agnt(String val){		if(val==null) val="";		this.cust_agnt = val;	}
	public void setAccid_dt(String val){		if(val==null) val="";		this.accid_dt = val;	}	
	public void setOff_tel(String val){		if(val==null) val="";		this.off_tel = val;	}
	public void setOff_fax(String val){		if(val==null) val="";		this.off_fax = val;	} 
	public void setCust_req_dt(String val){		if(val==null) val="";	this.cust_req_dt = val;	}	
	public void setCust_pay_dt(String val){		if(val==null) val="";	this.cust_pay_dt = val;	}	
	public void setReg_dt(String val){			if(val==null) val="";	this.reg_dt = val;		}	
	public void setReg_id(String val){			if(val==null) val="";	this.reg_id = val;		}	
	public void setUpdate_dt(String val){		if(val==null) val="";	this.update_dt = val;	}	
	public void setUpdate_id(String val){		if(val==null) val="";	this.update_id = val;	}	
	public void setScan_file(String val){		if(val==null) val="";	this.scan_file = val;	}	
	public void setNo_dft_yn(String val){		if(val==null) val="";	this.no_dft_yn = val;	}	
	public void setNo_dft_cau(String val){		if(val==null) val="";	this.no_dft_cau = val;	}	
	public void setBill_doc_yn(String str){	if(str==null) str="";	this.bill_doc_yn= str;	}
	public void setBill_mon(String str){ if(str==null) str="";	this.bill_mon= str;	}
	public void setServ_jc(String val){ if(val==null) val=""; this.serv_jc = val; }
	public void setCust_serv_dt(String val){ if(val==null) val=""; this.cust_serv_dt = val; }
	public void setNext_serv_dt(String val){ if(val==null) val=""; this.next_serv_dt = val; }
	public void setNext_rep_cont(String val){ if(val==null) val=""; this.next_rep_cont = val; }
	public void setSpd_chk(String val){ if(val==null) val=""; this.spd_chk = val; }
	public void setIpgodt(String val){ if(val==null) val=""; this.ipgodt = val; }
	public void setChulgodt(String val){ if(val==null) val=""; this.chulgodt = val; }
	public void setTax_yn(String str){		if(str==null) str="";	this.tax_yn = str;		}
	public void setJung_st(String str){		if(str==null) str="";	this.jung_st = str;		}
	public void setR_labor(int val){		this.r_labor = val;	} 
	public void setR_amt(int val){			this.r_amt = val;	} 	
	public void setR_dc(int val){			this.r_dc = val;	} 
	public void setR_j_amt(int val){			this.r_j_amt = val;	} 	
	public void setExt_amt(int val){			this.ext_amt = val;	} 	
	public void setJung_st_r(String str){		if(str==null) str="";	this.jung_st_r = str;		}
	public void setCls_amt(int val){			this.cls_amt = val;	} 
		
	public void setCls_s_amt(int val){			this.cls_s_amt = val;	} 	
	public void setCls_v_amt(int val){			this.cls_v_amt = val;	} 	
	public void setCust_s_amt(int val){			this.cust_s_amt = val;	} 	
	public void setCust_v_amt(int val){			this.cust_v_amt = val;	} 	
	public void setExt_cau(String str){		if(str==null) str="";	this.ext_cau = str;		}
	public void setSac_yn(String str){		if(str==null) str="";	this.sac_yn = str;		}
	public void setSac_dt(String str){		if(str==null) str="";	this.sac_dt = str;		}
	public void setPaid_st(String str){		if(str==null) str="";	this.paid_st = str;		}
	public void setPaid_type(String str){		if(str==null) str="";	this.paid_type = str;		}
	public void setBus_id2(String str){		if(str==null) str="";	this.bus_id2 = str;		}
	
	public void setCar_comp_id(String str){		if(str==null) str="";	this.car_comp_id = str;		}
	public void setSpdchk_dt(String val){ if(val==null) val=""; this.spdchk_dt = val; }
	public void setDly_amt(int val){			this.dly_amt = val;	} 
	public void setFile_path(String val){ if(val==null) val=""; this.file_path = val; }	
	public void setSaleebill_yn(String val){ if(val==null) val=""; this.saleebill_yn = val; }	
	public void setAgnt_email(String val){ if(val==null) val=""; this.agnt_email = val; }	
	
	public void setPre_set_dt(String val){ if(val==null) val=""; this.pre_set_dt = val; }
	
	//Get Method
	public String getCar_no(){		return car_no;	}
	public String getCar_mng_id(){		return car_mng_id;	}
	public String getServ_id(){		return serv_id;	}
	public String getAccid_id(){		return accid_id;	}
	public String getRent_mng_id(){		return rent_mng_id;	}
	public String getRent_l_cd(){		return rent_l_cd;	}
	public String getOff_id(){		return off_id;	}
	public String getOff_nm(){		return off_nm;	}
	public String getServ_dt(){		return serv_dt;	}
	public String getServ_st(){		return serv_st;	}
	
	public String getServ_st_nm(){

		if(serv_st.equals("1")){
			serv_st_nm = "순회점검";
		}else if(serv_st.equals("2")){
			serv_st_nm = "일반정비";
		}else if(serv_st.equals("3")){
			serv_st_nm = "보증정비";
		}else if(serv_st.equals("4")){
			serv_st_nm = "운행자차";
		}else if(serv_st.equals("5")){
			serv_st_nm = "사고자차";
		}else if(serv_st.equals("7")){
			serv_st_nm = "재리스정비";
		}else if(serv_st.equals("8")){
			serv_st_nm = "정기검사";
		}else if(serv_st.equals("9")){
			serv_st_nm = "정기정밀";
		}else if(serv_st.equals("10")){
			serv_st_nm = "정기점검";	
		}else if(serv_st.equals("12")){
			serv_st_nm = "해지정비";	
		}else if(serv_st.equals("13")){
			serv_st_nm = "자차";			
		}else if(serv_st.equals("11")){
			serv_st_nm = "신차영업관련";	
		}
		return serv_st_nm;
	}
	
	public String getChecker(){		return checker;	}
	public String getTot_dist(){		return tot_dist;	}
	public String getRep_nm(){		return rep_nm;	}
	public String getRep_tel(){		return rep_tel;	}
	public String getRep_m_tel(){		return rep_m_tel;	}
	public int getRep_amt(){		return rep_amt;	}
	public int getSup_amt(){		return sup_amt;	}
	public int getAdd_amt(){		return add_amt;	}
	public int getDc(){		return dc;	}
	public int getTot_amt(){		return tot_amt;	}
	public String getSup_dt(){		return sup_dt;	}
	public String getSet_dt(){		return set_dt;	}
	public String getBank(){		return bank;	}
	public String getAcc_no(){		return acc_no;	}
	public String getAcc_nm(){		return acc_nm;	}
	public String getRep_item(){		return rep_item;	}
	public String getRep_cont(){		return rep_cont;	}
	public String getCust_plan_dt(){		return cust_plan_dt;	}
	public int getCust_amt(){		return cust_amt;	}
	public String getCust_agnt(){		return cust_agnt;	}
	public String getAccid_dt(){		return accid_dt;	}
	public String getOff_tel(){		return off_tel;	}
	public String getOff_fax(){	return off_fax;	}		
	public String getCust_req_dt(){		return cust_req_dt;	}	
	public String getCust_pay_dt(){		return cust_pay_dt;	}	
	public String getReg_dt(){			return reg_dt;		}	
	public String getReg_id(){			return reg_id;		}	
	public String getUpdate_dt(){		return update_dt;	}	
	public String getUpdate_id(){		return update_id;	}	
	public String getScan_file(){		return scan_file;	}	
	public String getNo_dft_yn(){		return no_dft_yn;	}	
	public String getNo_dft_cau(){		return no_dft_cau;	}	
	public String getBill_doc_yn()	{ return bill_doc_yn; }  
	public String getBill_mon()		{ return bill_mon; } 
	public String getServ_jc(){ return serv_jc; }
	public String getCust_serv_dt(){ return cust_serv_dt; }
	public String getNext_serv_dt(){ return next_serv_dt; }
	public String getNext_rep_cont(){ return next_rep_cont; }
	public String getSpd_chk(){ return spd_chk; }
	public String getIpgodt(){ return ipgodt; }
	public String getChulgodt(){ return chulgodt; }
	public String getTax_yn()		{ return tax_yn;	}  
	public String getJung_st()		{ return jung_st;	}  
	public int getR_labor(){		return r_labor;	}
	public int getR_amt(){			return r_amt;	}
	public int getR_dc(){			return r_dc;	}
	public int getR_j_amt(){		return r_j_amt;	}
	public int getExt_amt(){		return ext_amt;	}
	public String getJung_st_r()		{ return jung_st_r;	} 
	public int getCls_amt(){		return cls_amt;	}
	
	public int getCls_s_amt(){		return cls_s_amt;	}
	public int getCls_v_amt(){		return cls_v_amt;	}
	public int getCust_s_amt(){		return cust_s_amt;	}
	public int getCust_v_amt(){		return cust_v_amt;	}
	public String getExt_cau()		{ return ext_cau;	} 
	public String getSac_yn()		{ return sac_yn;	} 
	public String getSac_dt()		{ return sac_dt;	} 
	public String getPaid_st()		{ return paid_st;	} 
	public String getPaid_type()		{ return paid_type;	} 
	public String getBus_id2()		{ return bus_id2;	} 

	public String getCar_comp_id()		{ return car_comp_id;	} 
	public String getSpdchk_dt(){ return spdchk_dt; }
	public int getDly_amt(){		return dly_amt;	}
	
	public String getFile_path(){ return file_path; }
	public String getSaleebill_yn(){ return saleebill_yn; }
	public String getAgnt_email(){ return agnt_email; }

	public String getPre_set_dt()		{ return pre_set_dt;	} 

}