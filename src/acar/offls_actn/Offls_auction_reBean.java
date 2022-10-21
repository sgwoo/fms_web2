/**
 * 오프리스 진행차량 재출품 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 04. 14. Mon.
 * @ last modify date : 
 */
package acar.offls_actn;

import java.util.*;

public class Offls_auction_reBean {
	//Table : AUCTION_RE 재출품관리
	private String car_mng_id;		//자동차관리번호
	private String actn_cnt;		//경매회차
	private String damdang_id;		//담당자
	private int st_pr;				//시작가
	private int hp_pr;				//희망가
	private String re_dt;			//재출품일자
	private String re_nm;			//재출품담당자
	private String re_tel;			//재출품담당자전화번호
	private String modify_id;		//최종수정자

	public Offls_auction_reBean(){
		this.car_mng_id = "";
		this.actn_cnt = "";
		this.damdang_id = "";
		this.st_pr = 0;
		this.hp_pr = 0;
		this.re_dt = "";
		this.re_nm = "";
		this.re_tel = "";
		this.modify_id = "";
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setActn_cnt(String val){ if(val==null) val=""; this.actn_cnt = val; }
	public void setDamdang_id(String val){ if(val==null) val=""; this.damdang_id = val; }
	public void setSt_pr(int val){ this.st_pr = val; }
	public void setHp_pr(int val){ this.hp_pr = val; }
	public void setRe_dt(String val){ if(val==null) val=""; this.re_dt = val; }
	public void setRe_nm(String val){ if(val==null) val=""; this.re_nm = val; }
	public void setRe_tel(String val){ if(val==null) val=""; this.re_tel = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }

	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getActn_cnt(){ return actn_cnt; }
	public String getDamdang_id(){ return damdang_id; }
	public int getSt_pr(){ return st_pr; }
	public int getHp_pr(){ return hp_pr; }
	public String getRe_dt(){ return re_dt; }
	public String getRe_nm(){ return re_nm; }
	public String getRe_tel(){ return re_tel; }
	public String getModify_id(){ return modify_id; }
}