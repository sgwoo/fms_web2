/**
 * 오프리스 진행차량 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 03. 25. Tue.
 * @ last modify date : -3.28.Fri.;nak_pr,nak_nm 추가
 *						-4.23.Wed.;car_pr,carhp 제거
 *						-4.25.Fri.;ama_nm,actn_nm 추가
 */
package acar.offls_actn;

import java.util.*;

public class Offls_auctionBean {
	//Table : AUCTION	경매장관리
	private String car_mng_id;	//자동차관리번호
	private String seq;			//순번
	private String actn_st;		//경매상태
	private String actn_cnt;	//경매회차
	private String actn_num;	//출품번호
	private String actn_dt;		//경매일자
	private int st_pr;		//시작가
	private int hp_pr;		//희망가
	private String ama_jum;		//아마존카점수
	private String ama_rsn;		//아마존카점수요인
	private String ama_nm;		//아마존카점수평가자
	private String actn_jum;	//경매장점수
	private String actn_rsn;	//경매장점수요인
	private String actn_nm;		//경매장점수평가자
	private String damdang_id;	//담당자
	private String modify_id;	//최종수정자
	private int nak_pr;			//낙찰가격
	private String nak_nm;		//낙찰자
	private String choi_st;		//최종상태
	private int o_s_amt;		//낙찰예상가
	private String offls_file;	//세금계산서
	private int out_amt;		//출품수수료

	public Offls_auctionBean(){
		this.car_mng_id = "";
		this.seq = "";
		this.actn_st = "";
		this.actn_cnt = "";
		this.actn_num = "";
		this.actn_dt = "";
		this.st_pr = 0;
		this.hp_pr = 0;
		this.ama_jum = "";
		this.ama_rsn = "";
		this.ama_nm = "";
		this.actn_jum = "";
		this.actn_rsn = "";
		this.actn_nm = "";
		this.damdang_id = "";
		this.modify_id = "";
		this.nak_pr = 0;
		this.nak_nm = "";
		this.choi_st = "";
		this.o_s_amt = 0;
		this.offls_file ="";
		this.out_amt = 0;
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setActn_st(String val){ if(val==null) val=""; this.actn_st = val; }
	public void setActn_cnt(String val){ if(val==null) val=""; this.actn_cnt = val; }
	public void setActn_num(String val){ if(val==null) val=""; this.actn_num = val; }
	public void setActn_dt(String val){ if(val==null) val=""; this.actn_dt = val; }
	public void setSt_pr(int val){ this.st_pr = val; }
	public void setHp_pr(int val){ this.hp_pr = val; }
	public void setAma_jum(String val){ if(val==null) val=""; this.ama_jum = val; }
	public void setAma_rsn(String val){ if(val==null) val=""; this.ama_rsn = val; }
	public void setAma_nm(String val){ if(val==null) val=""; this.ama_nm = val; }
	public void setActn_jum(String val){ if(val==null) val=""; this.actn_jum = val; }
	public void setActn_rsn(String val){ if(val==null) val=""; this.actn_rsn = val; }
	public void setActn_nm(String val){ if(val==null) val=""; this.actn_nm = val; }
	public void setDamdang_id(String val){ if(val==null) val=""; this.damdang_id = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }
	public void setNak_pr(int val){ this.nak_pr = val; }
	public void setNak_nm(String val){ if(val==null) val=""; this.nak_nm = val; }
	public void setChoi_st(String val){ if(val==null) val=""; this.choi_st = val; }
	public void setO_s_amt(int val){ this.o_s_amt = val; }
	public void setOffls_file(String val){ if(val==null) val=""; this.offls_file = val; }
	public void setOut_amt(int val){ this.out_amt = val; }

	

	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getSeq(){ return seq; }
	public String getActn_st(){ return actn_st; }
	public String getActn_cnt(){ return actn_cnt; }
	public String getActn_num(){ return actn_num; }
	public String getActn_dt(){ return actn_dt; }
	public int getSt_pr(){ return st_pr; }
	public int getHp_pr(){ return hp_pr; }
	public String getAma_jum(){ return ama_jum; }
	public String getAma_rsn(){ return ama_rsn; }
	public String getAma_nm(){ return ama_nm; }
	public String getActn_jum(){ return actn_jum; }
	public String getActn_rsn(){ return actn_rsn; }
	public String getActn_nm(){ return actn_nm; }
	public String getDamdang_id(){ return damdang_id; }
	public String getModify_id(){ return modify_id; }
	public int getNak_pr(){ return nak_pr; }
	public String getNak_nm(){ return nak_nm; }
	public String getChoi_st(){ return choi_st; }
	public int getO_s_amt(){ return o_s_amt; }
	public String getOffls_file(){ return offls_file; }
	public int getOut_amt(){ return out_amt; }

}