/**
 * 오프리스 진행차량 개별상담
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 03. 28. Fri.
 * @ last modify date : -3.28.Fri.;nak_pr은 auction 테이블에서 nak_nm과 함께 관리
 *						-4.04.Fri. ;개별상담은 각 경매회찰별로관리하기 위해 actn_cnt경매회차 추가
 */
package acar.offls_actn;

import java.util.*;

public class Offls_per_talkBean {
	//Table : PER_TALK	개별상담
	private String car_mng_id;	//자동차관리번호
	private String actn_cnt;	//경매회차
	private String seq;			//순번
	private int cust_pr;		//고객제시액
	private int ama_pr;			//당사제시액
	private String reason;		//결렬사유
	private String nak_yn;		//낙찰유무

	public Offls_per_talkBean(){
		this.car_mng_id = "";
		this.actn_cnt = "";
		this.seq = "";
		this.cust_pr = 0;
		this.ama_pr = 0;
		this.reason = "";
		this.nak_yn = "";
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setActn_cnt(String val){ if(val==null) val=""; this.actn_cnt = val; }
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setCust_pr(int val){ this.cust_pr = val; }
	public void setAma_pr(int val){ this.ama_pr = val; }
	public void setReason(String val){ if(val==null) val=""; this.reason = val; }
	public void setNak_yn(String val){ if(val==null) val=""; this.nak_yn = val; }

	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getActn_cnt(){ return actn_cnt; }
	public String getSeq(){ return seq; }
	public int getCust_pr(){ return cust_pr; }
	public int getAma_pr(){ return ama_pr; }
	public String getReason(){ return reason; }
	public String getNak_yn(){ return nak_yn; }
}