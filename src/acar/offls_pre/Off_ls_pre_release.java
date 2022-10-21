/**
 * 오프리스 매각준비차량 재리스
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 04. 16. 
 * @ last modify date : 
 *	-
 */
package acar.offls_pre;

import java.util.*;

public class Off_ls_pre_release
{
	//Table : RELEASE 재리스
	private String car_mng_id;
	private int	fee24_s_amt;
	private int fee24_v_amt;
	private int fee36_s_amt;
	private int fee36_v_amt;
	private int gua_amt;
	private int pp_amt;
	//private int st_amt;
	private String reg_id;
	private String upd_id;
	private int mo24_amt;	//매입옵션 24개월
	private int mo36_amt;	//매입옵션 36개월

	public Off_ls_pre_release(){
		this.car_mng_id = "";
		this.fee24_s_amt = 0;
		this.fee24_v_amt = 0;
		this.fee36_s_amt = 0;
		this.fee36_v_amt = 0;
		this.gua_amt = 0;
		this.pp_amt = 0;
		//this.st_amt = 0;
		this.reg_id = "";
		this.upd_id = "";
		this.mo24_amt = 0;
		this.mo36_amt = 0;
	}

	//setMethod
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setFee24_s_amt(int val){ this.fee24_s_amt = val; }
	public void setFee24_v_amt(int val){ this.fee24_v_amt = val; }
	public void setFee36_s_amt(int val){ this.fee36_s_amt = val; }
	public void setFee36_v_amt(int val){ this.fee36_v_amt = val; }
	public void setGua_amt(int val){ this.gua_amt = val; }
	public void setPp_amt(int val){ this.pp_amt = val; }
	//public void setSt_amt(int val){ this.st_amt = val; }
	public void setReg_id(String val){ if(val==null) val=""; this.reg_id = val; }
	public void setUpd_id(String val){ if(val==null) val=""; this.upd_id = val; }
	public void setMo24_amt(int val){ this.mo24_amt = val; }
	public void setMo36_amt(int val){ this.mo36_amt = val; }

	//getMethod
	public String getCar_mng_id(){ return car_mng_id; }
	public int getFee24_s_amt(){ return fee24_s_amt; }
	public int getFee24_v_amt(){ return fee24_v_amt; }
	public int getFee36_s_amt(){ return fee36_s_amt; }
	public int getFee36_v_amt(){ return fee36_v_amt; }
	public int getGua_amt(){ return gua_amt; }
	public int getPp_amt(){ return pp_amt; }
	//public int getSt_amt(){ return st_amt; }
	public String getReg_id(){ return reg_id; }
	public String getUpd_id(){ return upd_id; }
	public int getMo24_amt(){ return mo24_amt; }
	public int getMo36_amt(){ return mo36_amt; }
}