/**
 * 자동차등록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarRegBean {
    //Table : CAR_REG
	private String car_mng_id; 					//자동차관리번호
	private String car_no; 						//차량번호
	private String car_num; 					//차대번호
	private String init_reg_dt; 				//최초등록일
	private String car_kd; 						//차종
	private String car_use; 					//용도
	private String car_nm; 						//차명
	private String car_form; 					//형식 
	private String car_y_form; 					//연식
	private String mot_form; 					//원동기형식
	private String dpm; 						//재원_배기량
	private int    taking_p; 					//재원_승차정원
	private String tire; 						//재원_타이어
	private String fuel_kd; 					//재원_연료의종류
	private String conti_rat; 					//재원_연비
	private String mort_st; 					//저당권_구분
	private String mort_dt; 					//저당권_일자
	private String loan_st; 					//등록수수료_공채구분
	private int    loan_b_amt; 					//등록수수료_공채매입시
	private int    loan_s_amt; 					//등록수수료_공채할인시
	private String loan_s_rat; 					//등록수수료_공채할인율
	private int    reg_amt; 					//등록수수료_등록세
	private int    acq_amt; 					//등록수수료_취득세
	private int    no_m_amt; 					//등록수수료_번호판제작비
	private int    stamp_amt; 					//등록수수료_증인지대
	private int    etc; 						//등록수수료_기타
	private String maint_st_dt; 				//검사유효기간1
	private String maint_end_dt; 				//검사유효기간2
	private String cha_no1; 					//변경전번호
	private String cha_no2; 					//변경전번호2
	private String car_end_dt; 					//차령만료일
	private String test_st_dt; 					//점검유효기간1
	private String test_end_dt; 				//점검유효기간2
	private String acq_std; 					//취득세_과세표준
	private int    acq_acq; 					//취득세_취득세
	private String acq_f_dt; 					//취득세_납기일자
	private String acq_ex_dt; 					//취득세_지출일자
	private String acq_re; 						//취득세_문의처
	private String acq_is_p; 					//취득세_고지서발급자
	private String acq_is_o; 					//취득세_발급처
	private String reg_dt; 						//작성일자
	private String reg_nm; 						//작성자
	private String first_car_no;				//최초등록번호
	private String cha_seq;						//자동차등록번호 변경 번호
	private String guar_gen_y;					//일반성보증_연
	private String guar_gen_km;					//일반성보증_km
	private String guar_endur_y;				//내구성보증_연
	private String guar_endur_km;				//내구성보증_km
	private String car_ext;						//지역
	private String car_doc_no;					//등록증관리번호
	private String reg_pay_dt;					//등록증관리번호
	private String car_a_yn;					//자동차등록전표발행여부
	private String max_kg;						//최대적재량
	private String asset_yn;					//감가상각 등록여부  
	private String prepare;						//감가상각 등록여부  
	private String off_ls;						//감가상각 등록여부  
	private String park;						//현위치
	private String secondhand_dt;				//재리스등록일자
	private String reg_amt_card;				//차량등록세카드결재여부
	private String no_amt_card;					//번호판대금카드결재여부
	private String gps	;						//GPS장착여부
	private String update_id;					//수정자
	private String update_dt;					//수정일	
	private String acq_amt_card;				//취득세카드결재여부	
	private String dg_id;
	private String dg_dt;
	private String dg_no;
	private String dg_yn;
	private String dist_cng;					//계기판교체 20120507
	private String rm_st;						//월렌트상태 20120614 (1-즉시)
	private String secondhand;					//재리스결정
	private int    import_car_amt; 				//수입차차량가격
	private int    import_tax_amt; 				//수입차관세가격
	private String import_tax_dt;				//수입차관세신고일자
	private int    import_spe_tax_amt;			//수입차개별소비세가격
	private String car_end_yn;					//차령연장 2회완료 여부
	private String spe_dc_st;					//특별할인여부
	private String spe_dc_cau;					//특별할인사유
	private float  spe_dc_per;					//특별할인 대여료DC
	private String spe_dc_s_dt;					//특별할인기한시작일
	private String spe_dc_d_dt;					//특별할인기한종료일
	private String ncar_spe_dc_cau;		//신차인수거부 특별할인 사유
	private int    ncar_spe_dc_amt;		//신차인수거부 특별할인 금액
	private int    ncar_spe_dc_day;		//신차인수거부 특별할인 기간
	private String ncar_spe_dc_dt;		//신차인수거부 특별할인 결정일
	private int    car_length;		//제원길이
	private int    car_width;		//제원너비
	
	
    // CONSTRCTOR            
    public CarRegBean() {  
		this.car_mng_id		= ""; 				//자동차관리번호
		this.car_no			= ""; 				//차량번호
		this.car_num		= ""; 				//차대번호
		this.init_reg_dt	= ""; 				//최초등록일
		this.car_kd			= ""; 				//차종
		this.car_use		= ""; 				//용도
		this.car_nm			= ""; 				//차명
		this.car_form		= ""; 				//형식 
		this.car_y_form		= ""; 				//연식
		this.mot_form		= ""; 				//원동기형식
		this.dpm			= ""; 				//재원_배기량
		this.taking_p		= 0; 				//재원_승차정원
		this.tire			= ""; 				//재원_타이어
		this.fuel_kd		= ""; 				//재원_연료의종류
		this.conti_rat		= ""; 				//재원_연비
		this.mort_st		= ""; 				//저당권_구분
		this.mort_dt		= ""; 				//저당권_일자
		this.loan_st		= ""; 				//등록수수료_공채구분
		this.loan_b_amt		= 0; 				//등록수수료_공채매입시
		this.loan_s_amt		= 0; 				//등록수수료_공채할인시
		this.loan_s_rat		= ""; 				//등록수수료_공채할인율
		this.reg_amt		= 0; 				//등록수수료_등록세
		this.acq_amt		= 0; 				//등록수수료_취득세
		this.no_m_amt		= 0; 				//등록수수료_번호판제작비
		this.stamp_amt		= 0; 				//등록수수료_증인지대
		this.etc			= 0; 				//등록수수료_기타
		this.maint_st_dt	= ""; 				//검사유효기간1
		this.maint_end_dt	= ""; 				//검사유효기간2
		this.cha_no1		= ""; 				//변경전번호
		this.cha_no2		= ""; 				//변경전번호2
		this.car_end_dt		= ""; 				//차령만료일
		this.test_st_dt		= ""; 				//점검유효기간1
		this.test_end_dt	= ""; 				//점검유효기간2
		this.acq_std		= ""; 				//취득세_과세표준
		this.acq_acq		= 0; 				//취득세_취득세
		this.acq_f_dt		= ""; 				//취득세_납기일자
		this.acq_ex_dt		= ""; 				//취득세_지출일자
		this.acq_re			= ""; 				//취득세_문의처
		this.acq_is_p		= ""; 				//취득세_고지서발급자
		this.acq_is_o		= ""; 				//취득세_발급처
		this.reg_dt			= ""; 				//작성일자
		this.reg_nm			= ""; 				//작성자
		this.first_car_no	= "";	
		this.cha_seq		= "";
		this.guar_gen_y		= "";
		this.guar_gen_km	= "";
		this.guar_endur_y	= "";
		this.guar_endur_km	= "";
		this.car_ext		= "";
		this.car_doc_no		= "";
		this.reg_pay_dt		= "";
		this.car_a_yn		= "";
		this.max_kg			= "";
		this.asset_yn		= "";
		this.prepare		= "";
		this.off_ls			= "";
		this.park			= "";
		this.secondhand_dt	= "";
		this.reg_amt_card	= "";
		this.no_amt_card	= "";
		this.gps			= "";
		this.update_id		= "";
		this.update_dt		= "";
		this.acq_amt_card	= "";
		this.dg_id			= "";
		this.dg_dt			= "";
		this.dg_no			= "";
		this.dg_yn			= "";
		this.dist_cng		= "";
		this.rm_st			= "";
		this.secondhand		= "";
		this.import_car_amt	= 0; 				
		this.import_tax_amt	= 0; 		
		this.import_tax_dt	= "";
		this.import_spe_tax_amt = 0;
		this.car_end_yn		= "";
		this.spe_dc_st		= "";
		this.spe_dc_cau		= "";
		this.spe_dc_per		= 0; 
		this.spe_dc_s_dt	= "";
		this.spe_dc_d_dt	= "";
		this.ncar_spe_dc_cau= "";
		this.ncar_spe_dc_amt= 0;
		this.ncar_spe_dc_day= 0; 
		this.ncar_spe_dc_dt	= "";
		this.car_length= 0; //제원-길이
		this.car_width= 0; //제원-너비

	}
	

	// get Method
	public void setCar_mng_id		(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setCar_no			(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setCar_num			(String val){		if(val==null) val="";		this.car_num		= val;	}
	public void setInit_reg_dt		(String val){		if(val==null) val="";		this.init_reg_dt	= val;	}
	public void setCar_kd			(String val){		if(val==null) val="";		this.car_kd			= val;	}
	public void setCar_use			(String val){		if(val==null) val="";		this.car_use		= val;	}
	public void setCar_nm			(String val){		if(val==null) val="";		this.car_nm			= val;	}
	public void setCar_form			(String val){		if(val==null) val="";		this.car_form		= val;	}
	public void setCar_y_form		(String val){		if(val==null) val="";		this.car_y_form		= val;	}
	public void setMot_form			(String val){		if(val==null) val="";		this.mot_form		= val;	}
	public void setDpm				(String val){		if(val==null) val="";		this.dpm			= val;	}
	public void setTaking_p			(int val){										this.taking_p		= val;	}
	public void setTire				(String val){		if(val==null) val="";		this.tire			= val;	}
	public void setFuel_kd			(String val){		if(val==null) val="";		this.fuel_kd		= val;	}
	public void setConti_rat		(String val){		if(val==null) val="";		this.conti_rat		= val;	}
	public void setMort_st			(String val){		if(val==null) val="";		this.mort_st		= val;	}
	public void setMort_dt			(String val){		if(val==null) val="";		this.mort_dt		= val;	}
	public void setLoan_st			(String val){		if(val==null) val="";		this.loan_st		= val;	}
	public void setLoan_b_amt		(int val){										this.loan_b_amt		= val;	}
	public void setLoan_s_amt		(int val){										this.loan_s_amt		= val;	}
	public void setLoan_s_rat		(String val){		if(val==null) val="";		this.loan_s_rat		= val;	}
	public void setReg_amt			(int val){										this.reg_amt		= val;	}
	public void setAcq_amt			(int val){										this.acq_amt		= val;	}
	public void setNo_m_amt			(int val){										this.no_m_amt		= val;	}
	public void setStamp_amt		(int val){										this.stamp_amt		= val;	}
	public void setEtc				(int val){										this.etc			= val;	}
	public void setMaint_st_dt		(String val){		if(val==null) val="";		this.maint_st_dt	= val;	}
	public void setMaint_end_dt		(String val){		if(val==null) val="";		this.maint_end_dt	= val;	}
	public void setCha_no1			(String val){		if(val==null) val="";		this.cha_no1		= val;	}
	public void setCha_no2			(String val){		if(val==null) val="";		this.cha_no2		= val;	}
	public void setCar_end_dt		(String val){		if(val==null) val="";		this.car_end_dt		= val;	}
	public void setTest_st_dt		(String val){		if(val==null) val="";		this.test_st_dt		= val;	}
	public void setTest_end_dt		(String val){		if(val==null) val="";		this.test_end_dt	= val;	}
	public void setAcq_std			(String val){		if(val==null) val="";		this.acq_std		= val;	}
	public void setAcq_acq			(int val){										this.acq_acq		= val;	}
	public void setAcq_f_dt			(String val){		if(val==null) val="";		this.acq_f_dt		= val;	}
	public void setAcq_ex_dt		(String val){		if(val==null) val="";		this.acq_ex_dt		= val;	}
	public void setAcq_re			(String val){		if(val==null) val="";		this.acq_re			= val;	}
	public void setAcq_is_p			(String val){		if(val==null) val="";		this.acq_is_p		= val;	}
	public void setAcq_is_o			(String val){		if(val==null) val="";		this.acq_is_o		= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setReg_nm			(String val){		if(val==null) val="";		this.reg_nm			= val;	}		
	public void setFirst_car_no		(String val){		if(val==null) val="";		this.first_car_no	= val;	}
	public void setCha_seq			(String val){		if(val==null) val="";		this.cha_seq		= val;	}
	public void setGuar_gen_y		(String val){		if(val==null) val="";		this.guar_gen_y		= val;	}
	public void setGuar_gen_km		(String val){		if(val==null) val="";		this.guar_gen_km	= val;	}
	public void setGuar_endur_y		(String val){		if(val==null) val="";		this.guar_endur_y	= val;	}
	public void setGuar_endur_km	(String val){		if(val==null) val="";		this.guar_endur_km	= val;	}
	public void setCar_ext			(String val){		if(val==null) val="";		this.car_ext		= val;	}
	public void setCar_doc_no		(String val){		if(val==null) val="";		this.car_doc_no		= val;	}
	public void setReg_pay_dt		(String val){		if(val==null) val="";		this.reg_pay_dt		= val;	}
	public void setCar_a_yn			(String val){		if(val==null) val="";		this.car_a_yn		= val;	}
	public void setMax_kg			(String val){		if(val==null) val="";		this.max_kg			= val;	}
	public void setAsset_yn			(String val){    	if(val==null) val="";		this.asset_yn		= val;	}	
	public void setPrepare			(String val){		if(val==null) val="";		this.prepare		= val;	}
	public void setOff_ls			(String val){    	if(val==null) val="";		this.off_ls			= val;	}	
	public void setPark				(String val){    	if(val==null) val="";		this.park			= val;	}	
	public void setSecondhand_dt	(String val){		if(val==null) val="";		this.secondhand_dt	= val;	}	
	public void setReg_amt_card		(String val){		if(val==null) val="";		this.reg_amt_card	= val;	}	
	public void setNo_amt_card		(String val){		if(val==null) val="";		this.no_amt_card	= val;	}	
	public void setGps				(String val){		if(val==null) val="";		this.gps			= val;	}		
	public void setUpdate_id		(String val){		if(val==null) val="";		this.update_id		= val;	}	
	public void setUpdate_dt		(String val){		if(val==null) val="";		this.update_dt		= val;	}	
	public void setAcq_amt_card		(String val){		if(val==null) val="";		this.acq_amt_card	= val;	}	
	public void setDg_id			(String val){		if(val==null) val="";		this.dg_id			= val;	}	
	public void setDg_dt			(String val){		if(val==null) val="";		this.dg_dt			= val;	}	
	public void setDg_no			(String val){		if(val==null) val="";		this.dg_no			= val;	}	
	public void setDg_yn			(String val){		if(val==null) val="";		this.dg_yn			= val;	}	
	public void setDist_cng			(String val){		if(val==null) val="";		this.dist_cng		= val;	}	
	public void setRm_st			(String val){		if(val==null) val="";		this.rm_st			= val;	}	
	public void setSecondhand		(String val){		if(val==null) val="";		this.secondhand		= val;	}	
	public void setImport_car_amt	(int val){										this.import_car_amt	= val;	}
	public void setImport_tax_amt	(int val){										this.import_tax_amt	= val;	}
	public void setImport_tax_dt	(String val){		if(val==null) val="";		this.import_tax_dt	= val;	}
	public void setImport_spe_tax_amt(int val){										this.import_spe_tax_amt	= val;	}	
	public void setCar_end_yn		(String val){		if(val==null) val="";		this.car_end_yn		= val;	}	
	public void setSpe_dc_st		(String val){		if(val==null) val="";		this.spe_dc_st		= val;	}	
	public void setSpe_dc_cau		(String val){		if(val==null) val="";		this.spe_dc_cau		= val;	}	
	public void setSpe_dc_per		(float val){									this.spe_dc_per		= val;	}
	public void setSpe_dc_s_dt		(String val){		if(val==null) val="";		this.spe_dc_s_dt	= val;	}
	public void setSpe_dc_d_dt		(String val){		if(val==null) val="";		this.spe_dc_d_dt	= val;	}
	public void setNcar_spe_dc_cau	(String val){		if(val==null) val="";		this.ncar_spe_dc_cau= val;	}	
	public void setNcar_spe_dc_amt	(int val){										this.ncar_spe_dc_amt= val;	}
	public void setNcar_spe_dc_day	(int val){										this.ncar_spe_dc_day= val;	}
	public void setNcar_spe_dc_dt 	(String val){		if(val==null) val="";		this.ncar_spe_dc_dt	= val;	}
	public void setCar_length		(int val){										this.car_length		= val;	}
	public void setCar_width		(int val){										this.car_width		= val;	}
	
	//Get Method
	public String getCar_mng_id		(){		return car_mng_id;		}
	public String getCar_no			(){		return car_no;			}
	public String getCar_num		(){		return car_num;			}
	public String getInit_reg_dt	(){		return init_reg_dt;		}
	public String getCar_kd			(){		return car_kd;			}
	public String getCar_use		(){		return car_use;			}
	public String getCar_nm			(){		return car_nm;			}
	public String getCar_form		(){		return car_form;		}
	public String getCar_y_form		(){		return car_y_form;		}
	public String getMot_form		(){		return mot_form;		}
	public String getDpm			(){		return dpm;				}
	public int    getTaking_p		(){		return taking_p;		}
	public String getTire			(){		return tire;			}
	public String getFuel_kd		(){		return fuel_kd;			}
	public String getConti_rat		(){		return conti_rat;		}
	public String getMort_st		(){		return mort_st;			}
	public String getMort_dt		(){		return mort_dt;			}
	public String getLoan_st		(){		return loan_st;			}
	public int    getLoan_b_amt		(){		return loan_b_amt;		}
	public int    getLoan_s_amt		(){		return loan_s_amt;		}
	public String getLoan_s_rat		(){		return loan_s_rat;		}
	public int    getReg_amt		(){		return reg_amt;			}
	public int    getAcq_amt		(){		return acq_amt;			}
	public int    getNo_m_amt		(){		return no_m_amt;		}
	public int    getStamp_amt		(){		return stamp_amt;		}
	public int    getEtc			(){		return etc;				}
	public String getMaint_st_dt	(){		return maint_st_dt;		}
	public String getMaint_end_dt	(){		return maint_end_dt;	}
	public String getCha_no1		(){		return cha_no1;			}
	public String getCha_no2		(){		return cha_no2;			}
	public String getCar_end_dt		(){		return car_end_dt;		}
	public String getTest_st_dt		(){		return test_st_dt;		}
	public String getTest_end_dt	(){		return test_end_dt;		}
	public String getAcq_std		(){		return acq_std;			}
	public int    getAcq_acq		(){		return acq_acq;			}
	public String getAcq_f_dt		(){		return acq_f_dt;		}
	public String getAcq_ex_dt		(){		return acq_ex_dt;		}
	public String getAcq_re			(){		return acq_re;			}
	public String getAcq_is_p		(){		return acq_is_p;		}
	public String getAcq_is_o		(){		return acq_is_o;		}
	public String getReg_dt			(){		return reg_dt;			}
	public String getReg_nm			(){		return reg_nm;			}
	public String getFirst_car_no	(){		return first_car_no;	}
	public String getCha_seq		(){		return cha_seq;			}
	public String getGuar_gen_y		(){		return guar_gen_y;		}
	public String getGuar_gen_km	(){		return guar_gen_km;		}
	public String getGuar_endur_y	(){		return guar_endur_y;	}
	public String getGuar_endur_km	(){		return guar_endur_km;	}
	public String getCar_ext		(){		return car_ext;			}
	public String getCar_doc_no		(){		return car_doc_no;		}
	public String getReg_pay_dt		(){		return reg_pay_dt;		}
	public String getCar_a_yn		(){		return car_a_yn;		}
	public String getMax_kg			(){		return max_kg;			}
	public String getAsset_yn		(){		return asset_yn;		}
	public String getPrepare		(){		return prepare;			}
	public String getOff_ls			(){		return off_ls;			}
	public String getPark			(){		return park;			}
	public String getSecondhand_dt	(){		return secondhand_dt;	}
	public String getReg_amt_card	(){		return reg_amt_card;	}
	public String getNo_amt_card	(){		return no_amt_card;		}
	public String getGps			(){		return gps;				}
	public String getUpdate_id		(){		return update_id;		}
	public String getUpdate_dt		(){		return update_dt;		}
	public String getAcq_amt_card	(){		return acq_amt_card;	}
	public String getDg_id			(){		return dg_id;			}
	public String getDg_dt			(){		return dg_dt;			}
	public String getDg_no			(){		return dg_no;			}
	public String getDg_yn			(){		return dg_yn;			}
	public String getDist_cng		(){		return dist_cng;		}
	public String getRm_st			(){		return rm_st;			}
	public String getSecondhand		(){		return secondhand;		}
	public int    getImport_car_amt	(){		return import_car_amt;	}
	public int    getImport_tax_amt	(){		return import_tax_amt;	}
	public String getImport_tax_dt	(){		return import_tax_dt;	}
	public int    getImport_spe_tax_amt	(){		return import_spe_tax_amt;	}
	public String getCar_end_yn		(){		return car_end_yn;		}
	public String getSpe_dc_st		(){		return spe_dc_st;		}
	public String getSpe_dc_cau		(){		return spe_dc_cau;		}
	public float  getSpe_dc_per		(){		return spe_dc_per;		}
	public String getSpe_dc_s_dt	(){		return spe_dc_s_dt;		}
	public String getSpe_dc_d_dt	(){		return spe_dc_d_dt;		}
	public String getNcar_spe_dc_cau(){		return ncar_spe_dc_cau;	}
	public int    getNcar_spe_dc_amt(){		return ncar_spe_dc_amt;	}
	public int    getNcar_spe_dc_day(){		return ncar_spe_dc_day;	}
	public String getNcar_spe_dc_dt (){		return ncar_spe_dc_dt;	}
	public int    getCar_length		(){		return car_length;		}
	public int    getCar_width		(){		return car_width;		}


}