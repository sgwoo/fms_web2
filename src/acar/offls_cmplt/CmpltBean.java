/**
 * 오프리스 경매처분 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 06. 24. Tue.
 * @ last modify date : 
 */
package acar.offls_cmplt;

import java.util.*;

public class CmpltBean{
	private String car_mng_id; 					//자동차관리번호
	private int mm_amt;
	private String ip_dt;
	private String conv_dt;
	private int chul_su;
	private int nak_su;
	private int tak_su;
	private String client_id;
	private String lpgfile;

    public CmpltBean(){
		this.car_mng_id = ""; 					//자동차관리번호
		this.mm_amt = 0;
		this.ip_dt = "";
		this.conv_dt = "";
		this.chul_su = 0;
		this.nak_su = 0;
		this.tak_su = 0;
		this.client_id = "";
		this.lpgfile = "";
	}

	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setMm_amt(int val){ this.mm_amt = val; }
	public void setIp_dt(String val){ if(val==null) val=""; this.ip_dt = val; }
	public void setConv_dt(String val){ if(val==null) val=""; this.conv_dt = val; }
	public void setChul_su(int val){ this.chul_su = val; }
	public void setNak_su(int val){ this.nak_su = val; }
	public void setTak_su(int val){ this.tak_su = val; }
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val; }
	public void setLpgfile(String val){ if(val==null) val=""; this.lpgfile = val; }

	public String getCar_mng_id(){return car_mng_id;}
	public int getMm_amt(){ return mm_amt; }
	public String getIp_dt(){ return ip_dt; }
	public String getConv_dt(){ return conv_dt; }
	public int getChul_su(){ return chul_su; }
	public int getNak_su(){ return nak_su; }
	public int getTak_su(){ return tak_su; }
	public String getClient_id(){ return client_id; }
	public String getLpgfile(){ return lpgfile; }
}