/**
 * 오프리스 매각준비차량 엔카 등록 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 08. 19. Tue.
 * @ last modify date : 
 *	-
 */
package acar.offls_pre;

import java.util.*;

public class Off_ls_pre_encar 
{
	//Table : ENCAR 엔카
	private String car_mng_id;
	private String encar_id;
	private String reg_dt;
	private int count;
	private String opt_value;
	private int d_car_amt;
	private int s_car_amt;
	private int e_car_amt;
	private int ea_car_amt;
	private String content;
	private String guar_no;
	private int day_car_amt;
	private String reg_id;
	private String upd_id;
	private String img_path;

	public Off_ls_pre_encar(){
		this.car_mng_id = "";
		this.encar_id = "";
		this.reg_dt = "";
		this.count = 0;
		this.opt_value = "";
		this.d_car_amt = 0;
		this.s_car_amt = 0;
		this.e_car_amt = 0;
		this.ea_car_amt = 0;
		this.content = "";
		this.guar_no = "";
		this.day_car_amt = 0;
		this.reg_id = "";
		this.upd_id = "";
		this.img_path= "";
	}

	//setMethod
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setEncar_id(String val){ if(val==null) val=""; this.encar_id = val; }
	public void setReg_dt(String val){ if(val==null) val=""; this.reg_dt = val; }
	public void setCount(int val){ this.count = val; }
	public void setOpt_value(String val){ if(val==null) val=""; this.opt_value = val; }
	public void setD_car_amt(int val){ this.d_car_amt = val; }
	public void setS_car_amt(int val){ this.s_car_amt = val; }
	public void setE_car_amt(int val){ this.e_car_amt = val; }
	public void setEa_car_amt(int val){ this.ea_car_amt = val; }
	public void setContent(String val){ if(val==null) val=""; this.content = val; }
	public void setGuar_no(String val){ if(val==null) val=""; this.guar_no = val; }
	public void setDay_car_amt(int val){ this.day_car_amt = val; }
	public void setReg_id(String val){ if(val==null) val=""; this.reg_id = val; }
	public void setUpd_id(String val){ if(val==null) val=""; this.upd_id = val; }
	public void setImg_path(String val){ if(val==null) val=""; this.img_path = val; }

	//getMethod
	public String getCar_mng_id(){ return car_mng_id; }
	public String getEncar_id(){ return encar_id; }
	public String getReg_dt(){ return reg_dt; }
	public int getCount(){ return count; }
	public String getOpt_value(){ return opt_value; }
	public int getD_car_amt(){ return d_car_amt; }
	public int getS_car_amt(){ return s_car_amt; }
	public int getE_car_amt(){ return e_car_amt; }
	public int getEa_car_amt(){ return ea_car_amt; }
	public String getContent(){ return content; }
	public String getGuar_no(){ return guar_no; }
	public int getDay_car_amt(){ return day_car_amt; }
	public String getReg_id(){ return reg_id; }
	public String getUpd_id(){ return upd_id; }
	public String getImg_path(){ return img_path; }
}