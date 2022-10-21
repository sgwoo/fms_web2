/**
 * 오프리스 보험
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 06. 19. Thu.
 * @ last modify date : 
 */
package acar.offls_pre;

import java.util.*;

public class Offls_insBean{
	private String	car_mng_id;
	private String	ins_com_id;	//보험회사id
	private String	ins_type;	//보험종류(책임,종합)
	private String	ins_st_dt;	//보험시작일
	private String	ins_ed_dt;	//보험만료일
	private int		pay_pr;		//보험가격
	private String	pay_pr_dt;	//보험가격입금일자

	public Offls_insBean(){
		this.car_mng_id = "";
		this.ins_com_id = "";
		this.ins_type = "";
		this.ins_st_dt = "";
		this.ins_ed_dt = "";
		this.pay_pr = 0;
		this.pay_pr_dt = "";
	}

	//setMethod
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setIns_com_id(String val){ if(val==null) val=""; this.ins_com_id = val; }
	public void setIns_type(String val){ if(val==null) val=""; this.ins_type = val; }
	public void setIns_st_dt(String val){ if(val==null) val=""; this.ins_st_dt = val; }
	public void setIns_ed_dt(String val){ if(val==null) val=""; this.ins_ed_dt = val; }
	public void setPay_pr(int val){ this.pay_pr = val; }
	public void setPay_pr_dt(String val){ if(val==null) val=""; this.pay_pr_dt = val; }

	//getMethod
	public String getCar_mng_id(){ return car_mng_id; }
	public String getIns_com_id(){ return ins_com_id; }
	public String getIns_type(){ return ins_type; }
	public String getIns_st_dt(){ return ins_st_dt; }
	public String getIns_ed_dt(){ return ins_ed_dt; }
	public int getPay_pr(){ return pay_pr; }
	public String getPay_pr_dt(){ return pay_pr_dt; }
}