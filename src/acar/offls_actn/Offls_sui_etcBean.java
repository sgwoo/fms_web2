/**
 * 오프리스 매각 기타

 */
package acar.offls_actn;

import java.util.*;

public class Offls_sui_etcBean {
	//Table : SUI_ETC
	private String car_mng_id;	//자동차관리번호
	private String comm_yn;	      //수수료전표
	private String sale_yn;			//매각전표
	private int comm1_sup;		//
	private int comm1_vat;		//
	private int comm1_tot;		//
	private int comm2_sup;		//
	private int comm2_vat;		//
	private int comm2_tot;		//
	private int comm3_sup;		//
	private int comm3_vat;		//
	private int comm3_tot;		//
	private int comm4_sup;		//
	private int comm4_vat;		//
	private int comm4_tot;		
	private String comm_date;	 //수수료발생일자 (매각일자)
	private String car_no;	 //차량번호
	private String car_nm;	 //차명
	private String first_car_no;	 //first 차량번호
	private String car_use;	 // 1:리스 2:대여
	
	private int sale_amt;		// 매각액
	private int comm_amt;		// 수수료전체
	private int get_amt;		// 자산취득액
	private int adep_amt;		// 상각누계액
	private int gdep_amt;		//  구매보조금 
	
	private String sui_nm;	 // 1:리스 2:대여
	private String client_id;	 //
	private int sup_amt;		// 매각액 부가세
	
	private String commfile;
	

	public Offls_sui_etcBean(){
		this.car_mng_id = "";
		this.comm_yn = "";
		this.sale_yn = "";
		this.comm1_sup = 0;
		this.comm1_vat = 0;
		this.comm1_tot = 0;
		this.comm2_sup = 0;
		this.comm2_vat = 0;
		this.comm2_tot = 0;
		this.comm3_sup = 0;
		this.comm3_vat = 0;
		this.comm3_tot = 0;
		this.comm4_sup = 0;
		this.comm4_vat = 0;
		this.comm4_tot = 0;
		this.comm_date = "";
		this.car_no = "";
		this.car_nm = "";
		this.first_car_no = "";
		this.car_use = "";
				
		this.sale_amt = 0;		// 매각액
		this.comm_amt = 0;		// 수수료전체
		this.get_amt = 0;		// 자산취득액
		this.adep_amt = 0;		// 상각누계액
		this.gdep_amt = 0;		// 상각누계액
			
		this.sui_nm = "";
		this.client_id = "";
		this.sup_amt = 0;		//  
		
		this.commfile = "";
		
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setComm_yn(String val){ if(val==null) val=""; this.comm_yn = val; }
	public void setSale_yn(String val){ if(val==null) val=""; this.sale_yn = val; }
	public void setComm1_sup(int val){ this.comm1_sup = val; }
	public void setComm1_vat(int val){ this.comm1_vat = val; }
	public void setComm1_tot(int val){ this.comm1_tot = val; }
	public void setComm2_sup(int val){ this.comm2_sup = val; }
	public void setComm2_vat(int val){ this.comm2_vat = val; }
	public void setComm2_tot(int val){ this.comm2_tot = val; }
	public void setComm3_sup(int val){ this.comm3_sup = val; }
	public void setComm3_vat(int val){ this.comm3_vat = val; }
	public void setComm3_tot(int val){ this.comm3_tot = val; }
	public void setComm4_sup(int val){ this.comm4_sup = val; }
	public void setComm4_vat(int val){ this.comm4_vat = val; }
	public void setComm4_tot(int val){ this.comm4_tot = val; }
	public void setComm_date(String val){ if(val==null) val=""; this.comm_date = val; }
	public void setCar_no(String val){ if(val==null) val=""; this.car_no = val; }
	public void setCar_nm(String val){ if(val==null) val=""; this.car_nm = val; }
	public void setFirst_car_no(String val){ if(val==null) val=""; this.first_car_no = val; }
	public void setCar_use(String val){ if(val==null) val=""; this.car_use = val; }
			
	
	public void setSale_amt(int val){ this.sale_amt = val; }
	public void setComm_amt(int val){ this.comm_amt = val; }
	public void setGet_amt(int val){ this.get_amt = val; }
	public void setAdep_amt(int val){ this.adep_amt = val; }
	public void setGdep_amt(int val){ this.gdep_amt = val; }
	
	public void setSui_nm(String val){ if(val==null) val=""; this.sui_nm = val; }
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val; }
	
	public void setSup_amt(int val){ this.sup_amt = val; }
	
	public void setCommfile(String val){ if(val==null) val=""; this.commfile = val; }

	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getComm_yn(){ return comm_yn; }
	public String getSale_yn(){ return sale_yn; }
	public int getComm1_sup(){ return comm1_sup; }
	public int getComm1_vat(){ return comm1_vat; }
	public int getComm1_tot(){ return comm1_tot; }
	public int getComm2_sup(){ return comm2_sup; }
	public int getComm2_vat(){ return comm2_vat; }
	public int getComm2_tot(){ return comm2_tot; }
	public int getComm3_sup(){ return comm3_sup; }
	public int getComm3_vat(){ return comm3_vat; }
	public int getComm3_tot(){ return comm3_tot; }
	public int getComm4_sup(){ return comm4_sup; }
	public int getComm4_vat(){ return comm4_vat; }
	public int getComm4_tot(){ return comm4_tot; }
	public String getComm_date(){ return comm_date; }
	public String getCar_no(){ return car_no; }
	public String getCar_nm(){ return car_nm; }
	public String getFirst_car_no(){ return first_car_no; }
	public String getCar_use(){ return car_use; }
				
	public int getSale_amt(){ return sale_amt; }
	public int getComm_amt(){ return comm_amt; }
	public int getGet_amt(){ return get_amt; }
	public int getAdep_amt(){ return adep_amt; }
	public int getGdep_amt(){ return gdep_amt; }
	
	public String getSui_nm(){ return sui_nm; }
	public String getClient_id(){ return client_id; }
	
	public int getSup_amt(){ return sup_amt; }
	
	public String getCommfile(){ return commfile; }
				
}