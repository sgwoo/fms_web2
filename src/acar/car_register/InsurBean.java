/**
 * 보험
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class InsurBean {
    //Table : INSUR
	private String car_mng_id;			//자동차관리번호
	private String ins_st;			//보험구분
	private String ins_sts;			//상태
	private String age_scp;			//연령범위
	private String car_use;			//차량용도
	private String ins_com_id;			//보험회사
	private String ins_con_no;			//보험계약번호
	private String conr_nm;			//계약자
	private String ins_start_dt;			//보험시작일
	private String ins_exp_dt;			//보험만료일
	private int rins_pcp_amt;			//책임보험_대인배상_가격
	private int vins_pcp_amt;			//임의보험_대인배상_가격
	private String vins_pcp_kd;			//임의보험_대인배상_종류
	private int vins_gcp_amt;			//임의보험_대물배상_가격
	private String vins_gcp_kd;			//임의보험_대물배상_종류
	private int vins_bacdt_amt;			//임의보험_자기신체사고_가격
	private String vins_bacdt_kd;			//임의보험_자기신체사고_종류
	private int vins_cacdt_amt;			//임의보험_자기차량손해_가격(자차면책금)
	private int vins_canoisr_amt;		//임의보험_무보험차상해_가격
	private int vins_cacdt_car_amt;		//임의보험_자기차량손해_차량_가격
	private int vins_cacdt_me_amt;		//임의보혐_자기차량손해_자기부담금
	private int vins_cacdt_cm_amt;		//임의보험_자기차량손해_보험가격(차량+자기부담금)
	private String pay_tm;			//납부횟수
	private String change_dt;			//보험료변경일
	private String change_cau;			//보험료변경사유
	private String change_itm_kd1;			//보험료변경항목1_가격
	private int change_itm_amt1;			//보험료변경항목1_종류
	private String change_itm_kd2;			//보험료변경항목2_가격
	private int change_itm_amt2;			//보험료변경항목2_종류
	private String change_itm_kd3;			//보험료변경항목3_가격
	private int change_itm_amt3;			//보험료변경항목3_종류
	private String change_itm_kd4;			//보험료변경항목4_가격
	private int change_itm_amt4;			//보험료변경항목4_종류
	private String car_rate;			//가입경력율
	private String ins_rate;			//보험율
	private String ext_rate;			//할인할증율
	private String air_ds_yn;			//에어백유무_운전석
	private String air_as_yn;			//에어백유무조수석
	private String agnt_nm;			//보험담당자_이름
	private String agnt_tel;			//보험담당자_전화번호
	private String agnt_imgn_tel;			//보험담당자_긴급전화번호
	private String agnt_fax;			//	보험담당자_FAX
	private String exp_dt;			//해지일자
	private String exp_cau;			//해지사유
	private int rtn_amt;			//해지환급금
	private String rtn_dt;			//해지환급일자

        
    // CONSTRCTOR            
    public InsurBean() {  
	    this.car_mng_id = "";			//자동차관리번호
		this.ins_st = "";			//보험구분
		this.ins_sts = "";			//상태
		this.age_scp = "";			//연령범위
		this.car_use = "";			//차량용도
		this.ins_com_id = "";			//보험회사
		this.ins_con_no = "";			//보험계약번호
		this.conr_nm = "";			//계약자
		this.ins_start_dt = "";			//보험시작일
		this.ins_exp_dt = "";			//보험만료일
		this.rins_pcp_amt = 0;			//책임보험_대인배상_가격
		this.vins_pcp_amt = 0;			//임의보험_대인배상_가격
		this.vins_pcp_kd = "";			//임의보험_대인배상_종류
		this.vins_gcp_amt = 0;			//임의보험_대물배상_가격
		this.vins_gcp_kd = "";			//임의보험_대물배상_종류
		this.vins_bacdt_amt = 0;			//임의보험_자기신체사고_가격
		this.vins_bacdt_kd = "";			//임의보험_자기신체사고_종류
		this.vins_cacdt_amt = 0;			//임의보험_자기차량손해_가격
		this.vins_canoisr_amt = 0;				//임의보험_무보험차상해_가격
		this.vins_cacdt_car_amt = 0;			//임의보험_자기차량손해_차량_가격
		this.vins_cacdt_me_amt = 0;				//임의보혐_자기차량손해_자기부담금
		this.vins_cacdt_cm_amt = 0;				//임의보험_자기차량손해_보험가격(차량+자기부담금)
		this.pay_tm = "";			//납부횟수
		this.change_dt = "";			//보험료변경일
		this.change_cau = "";			//보험료변경사유
		this.change_itm_kd1 = "";			//보험료변경항목1_가격
		this.change_itm_amt1 = 0;			//보험료변경항목1_종류
		this.change_itm_kd2 = "";			//보험료변경항목2_가격
		this.change_itm_amt2 = 0;			//보험료변경항목2_종류
		this.change_itm_kd3 = "";			//보험료변경항목3_가격
		this.change_itm_amt3 = 0;			//보험료변경항목3_종류
		this.change_itm_kd4 = "";			//보험료변경항목4_가격
		this.change_itm_amt4 = 0;			//보험료변경항목4_종류
		this.car_rate = "";			//가입경력율
		this.ins_rate = "";			//보험율
		this.ext_rate = "";			//할인할증율
		this.air_ds_yn = "";			//에어백유무_운전석
		this.air_as_yn = "";			//에어백유무조수석
		this.agnt_nm = "";			//보험담당자_이름
		this.agnt_tel = "";			//보험담당자_전화번호
		this.agnt_imgn_tel = "";			//보험담당자_긴급전화번호
		this.agnt_fax = "";			//	보험담당자_FAX
		this.exp_dt = "";			//해지일자
		this.exp_cau = "";			//해지사유
		this.rtn_amt = 0;			//해지환급금
		this.rtn_dt = "";			//해지환급일자
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setIns_st(String val){
		if(val==null) val="";
		this.ins_st = val;
	}
	public void setIns_sts(String val){
		if(val==null) val="";
		this.ins_sts = val;
	}
	public void setAge_scp(String val){
		if(val==null) val="";
		this.age_scp = val;
	}
	public void setCar_use(String val){
		if(val==null) val="";
		this.car_use = val;
	}
	public void setIns_com_id(String val){
		if(val==null) val="";
		this.ins_com_id = val;
	}
	public void setIns_con_no(String val){
		if(val==null) val="";
		this.ins_con_no = val;
	}
	public void setConr_nm(String val){
		if(val==null) val="";
		this.conr_nm = val;
	}
	public void setIns_start_dt(String val){
		if(val==null) val="";
		this.ins_start_dt = val;
	}
	public void setIns_exp_dt(String val){
		if(val==null) val="";
		this.ins_exp_dt = val;
	}
	public void setRins_pcp_amt(int val){
		this.rins_pcp_amt = val;
	}
	public void setVins_pcp_amt(int val){
		this.vins_pcp_amt = val;
	}
	public void setVins_pcp_kd(String val){
		if(val==null) val="";
		this.vins_pcp_kd = val;
	}
	public void setVins_gcp_amt(int val){
		this.vins_gcp_amt = val;
	}
	public void setVins_gcp_kd(String val){
		if(val==null) val="";
		this.vins_gcp_kd = val;
	}
	public void setVins_bacdt_amt(int val){
		this.vins_bacdt_amt = val;
	}
	public void setVins_bacdt_kd(String val){
		if(val==null) val="";
		this.vins_bacdt_kd = val;
	}
	public void setVins_cacdt_amt(int val){
		this.vins_cacdt_amt = val;
	}
	public void setVins_canoisr_amt(int val){
		this.vins_canoisr_amt = val;
	}
	public void setVins_cacdt_car_amt(int val){
		this.vins_cacdt_car_amt = val;
	}
	public void setVins_cacdt_me_amt(int val){
		this.vins_cacdt_me_amt = val;
	}
	public void setVins_cacdt_cm_amt(int val){ this.vins_cacdt_cm_amt = val; }
	public void setPay_tm(String val){
		if(val==null) val="";
		this.pay_tm = val;
	}
	public void setChange_dt(String val){
		if(val==null) val="";
		this.change_dt = val;
	}
	public void setChange_cau(String val){
		if(val==null) val="";
		this.change_cau = val;
	}
	public void setChange_itm_kd1(String val){
		if(val==null) val="";
		this.change_itm_kd1 = val;
	}
	public void setChange_itm_amt1(int val){
		this.change_itm_amt1 = val;
	}
	public void setChange_itm_kd2(String val){
		if(val==null) val="";
		this.change_itm_kd2 = val;
	}
	public void setChange_itm_amt2(int val){
		this.change_itm_amt2 = val;
	}
	public void setChange_itm_kd3(String val){
		if(val==null) val="";
		this.change_itm_kd3 = val;
	}
	public void setChange_itm_amt3(int val){
		this.change_itm_amt3 = val;
	}
	public void setChange_itm_kd4(String val){
		if(val==null) val="";
		this.change_itm_kd4 = val;
	}
	public void setChange_itm_amt4(int val){
		this.change_itm_amt4 = val;
	}
	public void setCar_rate(String val){
		if(val==null) val="";
		this.car_rate = val;
	}
	public void setIns_rate(String val){
		if(val==null) val="";
		this.ins_rate = val;
	}
	public void setExt_rate(String val){
		if(val==null) val="";
		this.ext_rate = val;
	}
	public void setAir_ds_yn(String val){
		if(val==null) val="";
		this.air_ds_yn = val;
	}
	public void setAir_as_yn(String val){
		if(val==null) val="";
		this.air_as_yn = val;
	}
	public void setAgnt_nm(String val){
		if(val==null) val="";
		this.agnt_nm = val;
	}
	public void setAgnt_tel(String val){
		if(val==null) val="";
		this.agnt_tel = val;
	}
	public void setAgnt_imgn_tel(String val){
		if(val==null) val="";
		this.agnt_imgn_tel = val;
	}
	public void setAgnt_fax(String val){
		if(val==null) val="";
		this.agnt_fax = val;
	}
	public void setExp_dt(String val){
		if(val==null) val="";
		this.exp_dt = val;
	}
	public void setExp_cau(String val){
		if(val==null) val="";
		this.exp_cau = val;
	}
	public void setRtn_amt(int val){
		this.rtn_amt = val;
	}
	public void setRtn_dt(String val){
		if(val==null) val="";
		this.rtn_dt = val;
	}
	
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getIns_st(){
		return ins_st;
	}
	public String getIns_sts(){
		return ins_sts;
	}
	public String getAge_scp(){
		return age_scp;
	}
	public String getCar_use(){
		return car_use;
	}
	public String getIns_com_id(){
		return ins_com_id;
	}
	public String getIns_con_no(){
		return ins_con_no;
	}
	public String getConr_nm(){
		return conr_nm;
	}
	public String getIns_start_dt(){
		return ins_start_dt;
	}
	public String getIns_exp_dt(){
		return ins_exp_dt;
	}
	public int getRins_pcp_amt(){
		return rins_pcp_amt;
	}
	public int getVins_pcp_amt(){
		return vins_pcp_amt;
	}
	public String getVins_pcp_kd(){
		return vins_pcp_kd;
	}
	public int getVins_gcp_amt(){
		return vins_gcp_amt;
	}
	public String getVins_gcp_kd(){
		return vins_gcp_kd;
	}
	public int getVins_bacdt_amt(){
		return vins_bacdt_amt;
	}
	public String getVins_bacdt_kd(){
		return vins_bacdt_kd;
	}
	public int getVins_cacdt_amt(){
		return vins_cacdt_amt;
	}
	public int getVins_canoisr_amt(){ return vins_canoisr_amt; }
	public int getVins_cacdt_car_amt(){ return vins_cacdt_car_amt; }
	public int getVins_cacdt_me_amt(){ return vins_cacdt_me_amt; }
	public int getVins_cacdt_cm_amt(){ return vins_cacdt_cm_amt; }
	public String getPay_tm(){
		return pay_tm;
	}
	public String getChange_dt(){
		return change_dt;
	}
	public String getChange_cau(){
		return change_cau;
	}
	public String getChange_itm_kd1(){
		return change_itm_kd1;
	}
	public int getChange_itm_amt1(){
		return change_itm_amt1;
	}
	public String getChange_itm_kd2(){
		return change_itm_kd2;
	}
	public int getChange_itm_amt2(){
		return change_itm_amt2;
	}
	public String getChange_itm_kd3(){
		return change_itm_kd3;
	}
	public int getChange_itm_amt3(){
		return change_itm_amt3;
	}
	public String getChange_itm_kd4(){
		return change_itm_kd4;
	}
	public int getChange_itm_amt4(){
		return change_itm_amt4;
	}
	public String getCar_rate(){
		return car_rate;
	}
	public String getIns_rate(){
		return ins_rate;
	}
	public String getExt_rate(){
		return ext_rate;
	}
	public String getAir_ds_yn(){
		return air_ds_yn;
	}
	public String getAir_as_yn(){
		return air_as_yn;
	}
	public String getAgnt_nm(){
		return agnt_nm;
	}
	public String getAgnt_tel(){
		return agnt_tel;
	}
	public String getAgnt_imgn_tel(){
		return agnt_imgn_tel;
	}
	public String getAgnt_fax(){
		return agnt_fax;
	}
	public String getExp_dt(){
		return exp_dt;
	}
	public String getExp_cau(){
		return exp_cau;
	}
	public int getRtn_amt(){
		return rtn_amt;
	}
	public String getRtn_dt(){
		return rtn_dt;
	}
}