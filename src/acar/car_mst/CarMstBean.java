/**
 * 차종
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_mst;

import java.util.*;

public class CarMstBean {
    //Table : CAR_OFF
    private String car_comp_id;		//자동차회사ID
    private String car_comp_nm;		//자동차회사이름
    private String code;
    private String car_cd;
    private String car_nm;
    private String car_id;
    private String car_name;
	private String car_yn;
	private String section;					//차종분류코드
	private String sec_st;					//차종분류 전체차종적용여부
	private String car_seq;				//업데이트 일련번호
	private String car_b;					//기본사양
	private int    car_b_p;					//기본가격
	private String car_b_dt;				//기준일자
	private int    max_le_36;
	private int    max_le_24;
	private int    max_le_12;
	private int    max_re_36;
	private int    max_re_24;
	private int    max_re_18;
	private int    dpm;
	private String s_st;
	private int    sd_amt;
	private String est_yn;
	private int    max_le_42;
	private int    max_re_42;
	private String car_b_inc_id;
	private String car_b_inc_seq;
	private String sh_code;
	private String diesel_yn;
	private String auto_yn;
	private String jg_code;
	private String air_ds_yn;
	private String air_as_yn;
	private String air_cu_yn;
	private String abs_yn;
	private String rob_yn;
	private String sp_car_yn;
	private String end_dt;					//단종일자
	private int    car_b_p2;				//수입차-적용면세가 (2013-05-01)
	private int    r_dc_amt;				//수입차-렌트세금계산서D/C
	private int    l_dc_amt;				//수입차-리스세금계산서D/C
	private int    r_cash_back;			//수입차-렌트 Cash Back
	private int    l_cash_back;			//수입차-리스 Cash Back
	private int    r_card_amt;			//수입차-렌트 카드결제금액
	private int    l_card_amt;			//수입차-리스 카드결제금액
	private int    r_bank_amt;			//수입차-렌트 금융비용
	private int    l_bank_amt;			//수입차-리스 금융비용
	private String etc;						//비고
	private String car_y_form;			//연식
	private String main_yn;				//신차 견적 보여주기 차종 : 주요차종 보여주기
	private String hp_yn;
	private String jg_tuix_st;				//tuix/tuon 트림여부
	private String lkas_yn;					//차선이탈 제어형(LKAS) 
	private String ldws_yn;				//차선이탈 경고형(LDWS)
	private String aeb_yn;					//긴급제동 제어형(AEB)
	private String fcw_yn;					//긴급제동 경고형(FCW)
	private String garnish_yn;					//가니쉬
	private String hook_yn;					//견인고리
	private String etc2;						//기타         추가(2018.02.08)
	private String car_y_form2;			//연식
	private String car_y_form3;			//연식
	private String duty_free_opt;		//개소세 면세가/과세가 표시여부 (20190429)
	private String car_y_form_yn;		//신차견적서 연형표기여부 (2019610)
	private String ab_nm;		// 차명 키워드
	private String dlv_ext;		// 차명 키워드
	
    // CONSTRCTOR            
    public CarMstBean() {  
    	this.car_comp_id			= "";
	    this.car_comp_nm		= "";
	    this.code						= "";
	    this.car_cd					= "";
	    this.car_nm					= "";
	    this.car_id					= "";
	    this.car_name				= "";
		this.car_yn					= "";
		this.section					= "";
		this.sec_st					= "";
		this.car_seq					= "";
		this.car_b						= "";
		this.car_b_p					= 0;
		this.car_b_dt				= "";	
		this.max_le_36			= 0;
		this.max_le_24			= 0;
		this.max_le_12			= 0;
		this.max_re_36			= 0;
		this.max_re_24			= 0;
		this.max_re_18			= 0;
		this.dpm						= 0;
		this.s_st						= "";
		this.sd_amt					= 0;
		this.est_yn					= "";
		this.max_le_42			= 0;
		this.max_re_42			= 0;
		this.car_b_inc_id			= "";
		this.car_b_inc_seq		= "";
		this.sh_code					="";
		this.diesel_yn				= "";
		this.auto_yn					= "";
		this.jg_code					="";
		this.air_ds_yn				= "";
		this.air_as_yn				= "";
		this.air_cu_yn				= "";
		this.abs_yn					= "";
		this.rob_yn					= "";    
		this.sp_car_yn				= "";
		this.end_dt					= "";	
		this.car_b_p2				= 0;
		this.r_dc_amt				= 0;
		this.l_dc_amt				= 0;
		this.r_cash_back			= 0;
		this.l_cash_back			= 0;
		this.r_card_amt			= 0;
		this.l_card_amt			= 0;
		this.r_bank_amt			= 0;
		this.l_bank_amt			= 0;
		this.etc						= "";	
		this.car_y_form			= "";
		this.main_yn				= "";
		this.hp_yn					= "";
		this.jg_tuix_st				= "";
		this.lkas_yn 					= "";
		this.ldws_yn					= "";
		this.aeb_yn 					= "";
		this.fcw_yn 					= "";
		this.garnish_yn 					= "";
		this.hook_yn 					= "";
		this.etc2						= "";	//기타 추가(2018.02.08)
		this.car_y_form2			= "";
		this.car_y_form3			= "";
		this.duty_free_opt		= "";
		this.car_y_form_yn		= "";
		this.ab_nm = "";
		this.dlv_ext = "";
	}

	// get Method
	public void setCar_comp_id		(String val){		if(val==null) val="";	this.car_comp_id		= val;	}
	public void setCar_comp_nm	(String val){		if(val==null) val="";	this.car_comp_nm	= val;	}
	public void setCode					(String val){		if(val==null) val="";	this.code					= val;	}
	public void setCar_cd				(String val){		if(val==null) val="";	this.car_cd				= val;	}
	public void setCar_nm				(String val){		if(val==null) val="";	this.car_nm				= val;	}
	public void setCar_id				(String val){		if(val==null) val="";	this.car_id				= val;	}
	public void setCar_name			(String val){		if(val==null) val="";	this.car_name			= val;	}
	public void setCar_yn				(String val){		if(val==null) val="";	this.car_yn				= val;	}
	public void setSection				(String val){		if(val==null) val="";	this.section				= val;	}
	public void setSec_st				(String val){		if(val==null) val="";	this.sec_st				= val;	}
	public void setCar_seq			(String val){		if(val==null) val="";	this.car_seq				= val;	}
	public void setCar_b				(String val){		if(val==null) val="";	this.car_b					= val;	}
	public void setCar_b_p			(int      i){								this.car_b_p				= i;	}
	public void setCar_b_dt			(String val){		if(val==null) val="";	this.car_b_dt			= val;	}
	public void setDpm					(int      i){								this.dpm			= i;	}
	public void setMax_le_36		(int      i){								this.max_le_36		= i;	}
	public void setMax_le_24		(int      i){								this.max_le_24		= i;	}
	public void setMax_le_12		(int      i){								this.max_le_12		= i;	}
	public void setMax_re_36		(int      i){								this.max_re_36		= i;	}
	public void setMax_re_24		(int      i){								this.max_re_24		= i;	}
	public void setMax_re_18		(int      i){								this.max_re_18		= i;	}
	public void setS_st					(String val){		if(val==null) val="";	this.s_st					= val;	}
	public void setSd_amt				(int      i){								this.sd_amt			= i;	}
	public void setEst_yn				(String val){		if(val==null) val="";	this.est_yn				= val;	}
	public void setMax_le_42		(int      i){								this.max_le_42		= i;	}
	public void setMax_re_42		(int      i){								this.max_re_42		= i;	}
	public void setCar_b_inc_id		(String val){		if(val==null) val="";	this.car_b_inc_id		= val;	}
	public void setCar_b_inc_seq	(String val){		if(val==null) val="";	this.car_b_inc_seq	= val;	}
	public void setSh_code			(String val){		if(val==null) val="";	this.sh_code				= val;	}
	public void setDiesel_yn			(String val){		if(val==null) val="";	this.diesel_yn			= val;	}
	public void setAuto_yn			(String val){		if(val==null) val="";	this.auto_yn				= val;	}
	public void setJg_code			(String val){		if(val==null) val="";	this.jg_code				= val;	}
	public void setAir_ds_yn	    	(String str){		if(str==null) str="";	this.air_ds_yn			= str;	}		
	public void setAir_as_yn	    	(String str){		if(str==null) str="";	this.air_as_yn			= str;	}		
	public void setAir_cu_yn	    	(String str){		if(str==null) str="";	this.air_cu_yn			= str;	}		
	public void setAbs_yn		    	(String str){		if(str==null) str="";	this.abs_yn				= str;	}    	
	public void setRob_yn		    	(String str){		if(str==null) str="";	this.rob_yn				= str;	}
	public void setSp_car_yn	    	(String str){		if(str==null) str="";	this.sp_car_yn			= str;	}
	public void setEnd_dt				(String val){		if(val==null) val="";	this.end_dt				= val;	}
	public void setCar_b_p2			(int      i){								this.car_b_p2		= i;	}
	public void setR_dc_amt			(int      i){								this.r_dc_amt		= i;	}
	public void setL_dc_amt			(int      i){								this.l_dc_amt		= i;	}
	public void setR_cash_back		(int      i){								this.r_cash_back	= i;	}
	public void setL_cash_back		(int      i){								this.l_cash_back	= i;	}
	public void setR_card_amt		(int      i){								this.r_card_amt	= i;	}
	public void setL_card_amt		(int      i){								this.l_card_amt	= i;	}
	public void setR_bank_amt		(int      i){								this.r_bank_amt	= i;	}
	public void setL_bank_amt		(int      i){								this.l_bank_amt	= i;	}
	public void setEtc					(String val){		if(val==null) val="";	this.etc					= val;	}
	public void setCar_y_form		(String val){		if(val==null) val="";	this.car_y_form		= val;	}
	public void setMain_yn			(String val){		if(val==null) val="";	this.main_yn			= val;	}
	public void setHp_yn				(String val){		if(val==null) val="";	this.hp_yn				= val;	}
	public void setJg_tuix_st			(String val){		if(val==null) val="";	this.jg_tuix_st			= val;	}
	public void setLkas_yn			(String val){		if(val==null) val="";	this.lkas_yn				= val;	}	
	public void setLdws_yn			(String val){		if(val==null) val="";	this.ldws_yn				= val;	}	
	public void setAeb_yn				(String val){		if(val==null) val="";	this.aeb_yn				= val;	}	
	public void setFcw_yn				(String val){		if(val==null) val="";	this.fcw_yn				= val;	}
	public void setGarnish_yn				(String val){		if(val==null) val="";	this.garnish_yn				= val;	}
	public void setHook_yn				(String val){		if(val==null) val="";	this.hook_yn				= val;	}
	public void setEtc2					(String val){		if(val==null) val="";	this.etc2					= val;	}	//기타 추가 (2018.02.08)
	public void setCar_y_form2		(String val){		if(val==null) val="";	this.car_y_form2		= val;	}
	public void setCar_y_form3		(String val){		if(val==null) val="";	this.car_y_form3		= val;	}
	public void setDuty_free_opt	(String val){		if(val==null) val="";	this.duty_free_opt	= val;	}
	public void setCar_y_form_yn	(String val){		if(val==null) val="";	this.car_y_form_yn	= val;	}
	public void setAb_nm	(String val){		if(val==null) val="";	this.ab_nm	= val;	}
	public void setDlv_ext	(String val){		if(val==null) val="";	this.dlv_ext	= val;	}
		
	//Get Method
	public String getCar_comp_id		(){		return car_comp_id;		}
	public String getCar_comp_nm		(){		return car_comp_nm;		}
	public String getCode					(){		return code;					}
	public String getCar_cd				(){		return car_cd;					}
	public String getCar_nm				(){		return car_nm;				}
	public String getCar_id					(){		return car_id;					}
	public String getCar_name			(){		return car_name;			}
	public String getCar_yn				(){		return car_yn;					}
	public String getSection				(){		return section;					}
	public String getSec_st				(){		return sec_st;					}
	public String getCar_seq				(){		return car_seq;				}
	public String getCar_b					(){		return car_b;					}
	public int    getCar_b_p				(){		return car_b_p;				}
	public String getCar_b_dt				(){		return car_b_dt;				}
	public int    getDpm						(){		return dpm;						}
	public int    getMax_le_36			(){		return max_le_36;			}
	public int    getMax_le_24			(){		return max_le_24;			}
	public int    getMax_le_12			(){		return max_le_12;			}
	public int    getMax_re_36			(){		return max_re_36;			}
	public int    getMax_re_24			(){		return max_re_24;			}
	public int    getMax_re_18			(){		return max_re_18;			}
	public String getS_st					(){		return s_st;						}
	public int    getSd_amt				(){		return sd_amt;				}
	public String getEst_yn				(){		return est_yn;					}
	public int    getMax_le_42			(){		return max_le_42;			}
	public int    getMax_re_42			(){		return max_re_42;			}
	public String getCar_b_inc_id		(){		return car_b_inc_id;		}
	public String getCar_b_inc_seq	(){		return car_b_inc_seq;		}
	public String getSh_code				(){		return sh_code;				}
	public String getDiesel_yn			(){		return diesel_yn;				}
	public String getAuto_yn				(){		return auto_yn;				}
	public String getJg_code				(){		return jg_code;				}
	public String getAir_ds_yn	   	 	(){		return air_ds_yn;				}
	public String getAir_as_yn	   		(){		return air_as_yn;				}
	public String getAir_cu_yn	   		(){		return air_cu_yn;				}
	public String getAbs_yn		    	(){		return abs_yn;					}
	public String getRob_yn		    	(){		return rob_yn;					}
	public String getSp_car_yn	    	(){		return sp_car_yn;			}
	public String getEnd_dt				(){		return end_dt;					}
	public int    getCar_b_p2				(){		return car_b_p2;				}
	public int    getR_dc_amt				(){		return r_dc_amt;				}
	public int    getL_dc_amt				(){		return l_dc_amt;				}
	public int    getR_cash_back		(){		return r_cash_back;			}
	public int    getL_cash_back			(){		return l_cash_back;			}
	public int    getR_card_amt			(){		return r_card_amt;			}
	public int    getL_card_amt			(){		return l_card_amt;			}
	public int    getR_bank_amt			(){		return r_bank_amt;			}
	public int    getL_bank_amt			(){		return l_bank_amt;			}
	public String getEtc						(){		return etc;						}
	public String getCar_y_form			(){		return car_y_form;			}
	public String getMain_yn				(){		return main_yn;				}
	public String getHp_yn					(){		return hp_yn;					}
	public String getJg_tuix_st			(){		return jg_tuix_st;				}	
	public String getLkas_yn				(){		return lkas_yn;				}	
	public String getLdws_yn				(){		return ldws_yn;				}	
	public String getAeb_yn				(){		return aeb_yn;				}	
	public String getFcw_yn				(){		return fcw_yn;					}
	public String getGarnish_yn				(){		return garnish_yn;					}
	public String getHook_yn				(){		return hook_yn;					}
	public String getEtc2					(){		return etc2;						}	//기타 추가(2018.02.08)
	public String getCar_y_form2		(){		return car_y_form2;		}
	public String getCar_y_form3		(){		return car_y_form3;		}
	public String getDuty_free_opt		(){		return duty_free_opt;		}
	public String getCar_y_form_yn	(){		return car_y_form_yn;		}
	public String getAb_nm	(){		return ab_nm;		}
	public String getDlv_ext	(){		return dlv_ext;		}

}