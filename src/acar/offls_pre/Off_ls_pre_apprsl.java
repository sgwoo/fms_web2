/**
 * 오프리스 매각준비차량 정보
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 02. 21. Fri.
 * @ last modify date : 
 *	-2003.3.7.Fri. 차량번호변경여부 칼럼을 테이블에서 제거함.
 *	-2003.3.12.Wed. 상품평가 수정시 책임소재파악위해 담당자, 최종수정자 추가. 구비서류준비여부체크.
 *	-2003.3.26.Wed. 보험상태추가
 *	-2003.4.11.Fri. 보증서추가
 */
package acar.offls_pre;

import java.util.*;

public class Off_ls_pre_apprsl 
{
	//Table : APPRSL 상품평가
	private String car_mng_id;
	private String lev;			//평가등급
	private String reason;		//평가요인
	private String car_st;		//차량상태
	private String imgfile1;	//이미지1
	private String imgfile2;	//이미지2
	private String imgfile3;	//이미지3
	private String imgfile4;	//이미지4
	private String imgfile5;	//이미지5
	private	String	sago_yn;	//
	private	String	lpg_yn;
	private	String	km;
	private	String	damdang;
	//private	String	num_ch;
	//private int		hppr;
	//private	int		stpr;
	//private int		bkpr;
	//private int		sptax;
	//private int		allcost;
	//private int		rspr;
	private String	actn_id;	//경매장아이디
	private String	damdang_id;	//담당자아이디
	private String	modify_id;	//최종수정자
	private String	doc_chk;	//구비서류체크
	private String	doc_seq;	//구비서류체크된순번
	private String	apprsl_dt;	//상품평가일자
	//private String	determ_id;	//가격결정자id
	private String	ins_com_id;	//보험회사id
	private String	ins_type;	//보험종류(책임,종합)
	private String	ins_st_dt;	//보험시작일
	private String	ins_ed_dt;	//보험만료일
	private int		ins_pr;		//보험가격
	private String	ins_pr_dt;	//보험가격입금일자
	private String	ass_st_dt;	//보증시작일
	private String	ass_ed_dt;	//보증만료일
	private String	ass_st_km;	//보증시작KM
	private String	ass_ed_km;	//보증만료KM
	private String	ass_wrt;	//보증서작성자
	private String	ass_chk;	//보증서존재여부
	//재리스 리스트 작은이미지
	private String imgfile6;	//이미지6
	
	private String	actn_wh;	//글로비스 위치

	private int		export_amt; //수출매각 제시가격

	public Off_ls_pre_apprsl(){
		this.car_mng_id = "";
		this.lev = "";
		this.reason = "";
		this.car_st = "";
		this.imgfile1 = "";
		this.imgfile2 = "";
		this.imgfile3 = "";
		this.imgfile4 = "";
		this.imgfile5 = "";
		this.sago_yn = "";
		this.lpg_yn ="";
		this.km = "";
		this.damdang = "";
		//this.num_ch = "";
		//this.hppr = 0;
		//this.stpr = 0;
		//this.bkpr = 0;
		//this.sptax = 0;
		//this.allcost = 0;
		//this.rspr = 0;
		this.actn_id = "";
		this.damdang_id = "";
		this.modify_id = "";
		this.doc_chk = "";
		this.doc_seq = "";
		this.apprsl_dt = "";
		//this.determ_id = "";
		this.ins_com_id = "";
		this.ins_type = "";
		this.ins_st_dt = "";
		this.ins_ed_dt = "";
		this.ins_pr = 0;
		this.ins_pr_dt = "";
		this.ass_st_dt = "";
		this.ass_ed_dt = "";
		this.ass_st_km = "";
		this.ass_ed_km = "";
		this.ass_wrt = "";
		this.ass_chk = "";
		this.imgfile6 = "";
		this.actn_wh = "";
		this.export_amt = 0;
	}

	//setMethod
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setLev(String val){ if(val==null) val=""; this.lev = val; }
	public void setReason(String val){ if(val==null) val=""; this.reason = val; }
	public void setCar_st(String val){ if(val==null) val=""; this.car_st = val; }
	public void setImgfile1(String val){ if(val==null) val=""; this.imgfile1 = val; }
	public void setImgfile2(String val){ if(val==null) val=""; this.imgfile2 = val; }
	public void setImgfile3(String val){ if(val==null) val=""; this.imgfile3 = val; }
	public void setImgfile4(String val){ if(val==null) val=""; this.imgfile4 = val; }
	public void setImgfile5(String val){ if(val==null) val=""; this.imgfile5 = val; }
	public void setSago_yn(String val){ if(val==null) val=""; this.sago_yn=val; }
	public void setLpg_yn(String val){ if(val==null) val=""; this.lpg_yn=val; }
	public void setKm(String val){ if(val==null) val=""; this.km = val; }
	public void setDamdang(String val){ if(val==null) val=""; this.damdang=val; }
	//public void setNum_ch(String val){ if(val==null) val=""; this.num_ch = val; }
	/*public void setHppr(int val){ this.hppr = val; }
	public void setStpr(int val){ this.stpr = val; }
	public void setBkpr(int val){ this.bkpr = val; }
	public void setSptax(int val){ this.sptax = val; }
	public void setAllcost(int val){ this.allcost = val; }
	public void setRspr(int val){ this.rspr = val; }	*/
	public void setActn_id(String val){ if(val==null) val=""; this.actn_id = val; }
	public void setDamdang_id(String val){ if(val==null) val=""; this.damdang_id = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }
	public void setDoc_chk(String val){ if(val==null) val=""; this.doc_chk = val; }
	public void setDoc_seq(String val){ if(val==null) val=""; this.doc_seq = val; }
	public void setApprsl_dt(String val){ if(val==null) val=""; this.apprsl_dt = val; }
	//public void setDeterm_id(String val){if(val==null) val=""; this.determ_id = val; }
	public void setIns_com_id(String val){ if(val==null) val=""; this.ins_com_id = val; }
	public void setIns_type(String val){ if(val==null) val=""; this.ins_type = val; }
	public void setIns_st_dt(String val){ if(val==null) val=""; this.ins_st_dt = val; }
	public void setIns_ed_dt(String val){ if(val==null) val=""; this.ins_ed_dt = val; }
	public void setIns_pr(int val){ this.ins_pr = val; }
	public void setIns_pr_dt(String val){ if(val==null) val=""; this.ins_pr_dt = val; }
	public void setAss_st_dt(String val){ if(val==null) val=""; this.ass_st_dt = val; }
	public void setAss_ed_dt(String val){ if(val==null) val=""; this.ass_ed_dt = val; }
	public void setAss_st_km(String val){ if(val==null) val=""; this.ass_st_km = val; }
	public void setAss_ed_km(String val){ if(val==null) val=""; this.ass_ed_km = val; }
	public void setAss_wrt(String val){ if(val==null) val=""; this.ass_wrt = val; }
	public void setAss_chk(String val){ if(val==null) val=""; this.ass_chk = val; }
	public void setImgfile6(String val){ if(val==null) val=""; this.imgfile6 = val; }
	public void setActn_wh(String val){ if(val==null) val=""; this.actn_wh = val; }

	public void setExport_amt(int val){ this.export_amt = val; }

	//getMethod
	public String getCar_mng_id(){ return car_mng_id; }
	public String getLev(){ return lev; }
	public String getReason(){ return reason; }
	public String getCar_st(){ return car_st; }
	public String getImgfile1(){ return imgfile1; }
	public String getImgfile2(){ return imgfile2; }
	public String getImgfile3(){ return imgfile3; }
	public String getImgfile4(){ return imgfile4; }
	public String getImgfile5(){ return imgfile5; }
	public String getSago_yn(){ return sago_yn; }
	public String getLpg_yn(){ return lpg_yn; }
	public String getKm(){ return km; }
	public String getDamdang(){ return damdang; }
	//public String getNum_ch(){ return num_ch; }
	/*public int getHppr(){ return hppr; }
	public int getStpr(){ return stpr; }
	public int getBkpr(){ return bkpr; }
	public int getSptax(){ return sptax; }
	public int getAllcost(){ return allcost; }
	public int getRspr(){ return rspr; }	*/
	public String getActn_id(){ return actn_id; }
	public String getDamdang_id(){ return damdang_id; }
	public String getModify_id(){ return modify_id; }
	public String getDoc_chk(){ return doc_chk; }
	public String getDoc_seq(){ return doc_seq; }
	public String getApprsl_dt(){ return apprsl_dt; }
	//public String getDeterm_id(){ return determ_id; }
	public String getIns_com_id(){ return ins_com_id; }
	public String getIns_type(){ return ins_type; }
	public String getIns_st_dt(){ return ins_st_dt; }
	public String getIns_ed_dt(){ return ins_ed_dt; }
	public int getIns_pr(){ return ins_pr; }
	public String getIns_pr_dt(){ return ins_pr_dt; }
	public String getAss_st_dt(){ return ass_st_dt; }
	public String getAss_ed_dt(){ return ass_ed_dt; }
	public String getAss_st_km(){ return ass_st_km; }
	public String getAss_ed_km(){ return ass_ed_km; }
	public String getAss_wrt(){ return ass_wrt; }
	public String getAss_chk(){ return ass_chk; }
	public String getImgfile6(){ return imgfile6; }
	public String getActn_wh(){ return actn_wh; }
	public int getExport_amt(){ return export_amt; }

}