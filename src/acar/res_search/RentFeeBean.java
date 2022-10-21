// 단기계약 대여관리

// 작성일 : 2003.12.11 (정현미)

package acar.res_search;

public class RentFeeBean
{
	private String rent_s_cd;		//단기계약관리번호
	private String driver_yn;		//운전기사 포함 여부
	private String tax_yn;			//세금계산서 발행 여부
	private String ins_yn;			//선택보험 가입 여부
	private String gua_st;			//연대보증 여부
	private String gua_cau;			//연대보증 면제사유
	private String paid_way;		//결제방법
	private String paid_st;			//결제수단
	private String card_no;			//신용카드번호
	private int    fee_s_amt;		//대여료-공급가
	private int    fee_v_amt;		//대여료-부가세
	private int    dc_s_amt;		//DC-공급가
	private int    dc_v_amt;		//DC-부가세
	private int    ins_s_amt;		//선택보험료-공급가
	private int    ins_v_amt;		//선택보험료-부가세
	private int    etc_s_amt;		//기타비용-공급가
	private int    etc_v_amt;		//기타비용-부가세
	private int    rent_tot_amt;	//총결제금액
	private String reg_id;			//등록자
	private String reg_dt;			//등록일
	private String update_id;		//수정자
	private String update_dt;		//수정일
	private int    tot_s_amt;
	private int    tot_v_amt;
	private int    inv_s_amt;		// 견적대여료_공급가        
	private int    inv_v_amt;		// 견적대여료_부가세      
	private String cons_yn;			//탁송요청여부
	private String navi_yn;			//네비게이션여부
	private String gps_yn;			//GPS장착여부
	private String oil_st;			//주유게이지
	private int    dist_km;			//주행거리
	private String est_id;			//견적관리번호
	private int    navi_s_amt;		//네비게이션_공급가        
	private int    navi_v_amt;		//네비게이션_부가세      
	private int    cons1_s_amt;		//배차료_공급가        
	private int    cons1_v_amt;		//배차료_부가세      
	private int    cons2_s_amt;		//반차료_공급가        
	private int    cons2_v_amt;		//반차료_부가세      
	private String fee_etc;			//대여요금특이사항
	private String cms_bank;		//자동이체은행
	private String cms_acc_no;		//은행계좌번호
	private String cms_dep_nm;		//계좌예금주
	private String my_accid_yn;		//휴차보상여부
	private int    car_ja;			//반차료_부가세      
	private int    over_run_amt;	//주행거리초과요금
	private String cars;			//단기대여차량명
	private int    amt_01d;			//1일대여요금
	private int    amt_03d;			//3일대여요금
	private int    amt_05d;			//5일대여요금
	private int    amt_07d;			//7일대여요금
	private int    f_rent_tot_amt;	//최초결제금액
	private String f_paid_way;		//최초결제방법
	private String f_paid_way2;		//최초결제방법-반차료포함여부
	private int    t_dc_amt;		//1개월이상할인
	private int    m2_dc_amt;		//1개월이상할인-2회차
	private int    m3_dc_amt;		//1개월이상할인-3회차
	private String amt_per;			//할인율
	private String car_use;			//차량사용용도
	private String serial_no;		//네비serial
	private String card_y_mm;		//신용카드유효월
	private String card_y_yy;		//신용카드유효년
	private String card_user;		//신용카드소유자


	public RentFeeBean()
	{
		rent_s_cd		= "";    
		driver_yn		= "";        
		tax_yn			= "";    
		ins_yn			= "";    
		gua_st			= "";
		gua_cau			= "";
		paid_way		= "";
		paid_st			= "";
		card_no			= "";
		fee_s_amt		= 0;
		fee_v_amt		= 0;
		dc_s_amt		= 0;
		dc_v_amt		= 0;    
		ins_s_amt		= 0;
		ins_v_amt		= 0;
		etc_s_amt		= 0;
		etc_v_amt		= 0;
		rent_tot_amt	= 0;
		reg_id			= "";
		reg_dt			= "";
		update_id		= "";
		update_dt		= "";
		tot_s_amt		= 0;
		tot_v_amt		= 0;
		inv_s_amt		= 0;
		inv_v_amt		= 0;
		cons_yn			= "";        
		navi_yn			= "";    
		gps_yn			= "";    
		oil_st			= "";
		dist_km			= 0;
		est_id			= "";
		navi_s_amt		= 0;
		navi_v_amt		= 0;
		cons1_s_amt		= 0;
		cons1_v_amt		= 0;    
		cons2_s_amt		= 0;
		cons2_v_amt		= 0;
		fee_etc			= "";
		cms_bank		= "";        
		cms_acc_no		= "";    
		cms_dep_nm		= "";    
		my_accid_yn		= "";    
		car_ja			= 0;
		over_run_amt	= 0;
		cars			= "";
		amt_01d			= 0;
		amt_03d			= 0;
		amt_05d			= 0;
		amt_07d			= 0;   
		f_rent_tot_amt	= 0;
		f_paid_way		= "";
		f_paid_way2		= "";
		t_dc_amt		= 0;   
		m2_dc_amt		= 0;   
		m3_dc_amt		= 0;   
		amt_per			= "";
		car_use			= "";
		serial_no		= "";
		card_y_mm		= "";
		card_y_yy		= "";
		card_user		= "";


	}
	
	public void setRent_s_cd		(String str) 	{ rent_s_cd		= str; }
	public void setDriver_yn		(String str)	{ driver_yn		= str; }
	public void setTax_yn			(String str)	{ tax_yn		= str; }    	
	public void setIns_yn			(String str)	{ ins_yn		= str; }		
	public void setGua_st			(String str)	{ gua_st		= str; }		
	public void setGua_cau			(String str)	{ gua_cau		= str; }		
	public void setPaid_way			(String str)	{ paid_way		= str; }    
	public void setPaid_st			(String str)	{ paid_st		= str; }    
	public void setCard_no			(String str)	{ card_no		= str; }    
	public void setFee_s_amt		(int i)			{ fee_s_amt		= i;   }    	
	public void setFee_v_amt		(int i)			{ fee_v_amt		= i;   }    	
	public void setDc_s_amt			(int i)			{ dc_s_amt		= i;   }    	
	public void setDc_v_amt			(int i)			{ dc_v_amt		= i;   }    	
	public void setIns_s_amt		(int i)			{ ins_s_amt		= i;   }    	
	public void setIns_v_amt		(int i)			{ ins_v_amt		= i;   }    	
	public void setEtc_s_amt		(int i)			{ etc_s_amt		= i;   }    	
	public void setEtc_v_amt		(int i)			{ etc_v_amt		= i;   }    	
	public void setRent_tot_amt		(int i)			{ rent_tot_amt	= i;   }    	
	public void setReg_id			(String str)	{ reg_id		= str; }    
	public void setReg_dt			(String str)	{ reg_dt		= str; }    
	public void setUpdate_id		(String str)	{ update_id		= str; }    
	public void setUpdate_dt		(String str)	{ update_dt		= str; }    
	public void setInv_s_amt		(int i)			{ inv_s_amt		= i;   }    	
	public void setInv_v_amt		(int i)			{ inv_v_amt		= i;   }    	
	public void setCons_yn			(String str)	{ cons_yn		= str; }
	public void setNavi_yn			(String str)	{ navi_yn		= str; }    	
	public void setGps_yn			(String str)	{ gps_yn		= str; }		
	public void setOil_st			(String str)	{ oil_st		= str; }		
	public void setDist_km			(int i)			{ dist_km		= i;   }    	
	public void setEst_id			(String str)	{ est_id		= str; }
	public void setNavi_s_amt		(int i)			{ navi_s_amt	= i;   }    	
	public void setNavi_v_amt		(int i)			{ navi_v_amt	= i;   }    	
	public void setCons1_s_amt		(int i)			{ cons1_s_amt	= i;   }    	
	public void setCons1_v_amt		(int i)			{ cons1_v_amt	= i;   }    	
	public void setCons2_s_amt		(int i)			{ cons2_s_amt	= i;   }    	
	public void setCons2_v_amt		(int i)			{ cons2_v_amt	= i;   }
	public void setFee_etc			(String str)	{ fee_etc		= str; }
	public void setCms_bank			(String str)	{ cms_bank		= str; }    	
	public void setCms_acc_no		(String str)	{ cms_acc_no	= str; }		
	public void setCms_dep_nm		(String str)	{ cms_dep_nm	= str; }		
	public void setMy_accid_yn		(String str)	{ my_accid_yn	= str; }
	public void setCar_ja			(int i)			{ car_ja		= i;   }
	public void setOver_run_amt		(int i)			{ over_run_amt	= i;   }    	
	public void setCars				(String str)	{ cars			= str; }
	public void setAmt_01d			(int i)			{ amt_01d		= i;   }    	
	public void setAmt_03d			(int i)			{ amt_03d		= i;   }    	
	public void setAmt_05d			(int i)			{ amt_05d		= i;   }    	
	public void setAmt_07d			(int i)			{ amt_07d		= i;   }    
	public void setF_rent_tot_amt	(int i)			{ f_rent_tot_amt= i;   }    	
	public void setF_paid_way		(String str)	{ f_paid_way	= str; }    
	public void setF_paid_way2		(String str)	{ f_paid_way2	= str; }   
	public void setT_dc_amt			(int i)			{ t_dc_amt		= i;   }    	
	public void setM2_dc_amt		(int i)			{ m2_dc_amt		= i;   }    	
	public void setM3_dc_amt		(int i)			{ m3_dc_amt		= i;   }   
	public void setAmt_per			(String str)	{ amt_per		= str; }   
	public void setCar_use			(String str)	{ car_use		= str; }   
	public void setSerial_no		(String str)	{ serial_no		= str; }   
	public void setCard_y_mm		(String str)	{ card_y_mm		= str; }
	public void setCard_y_yy		(String str)	{ card_y_yy		= str; }
	public void setCard_user		(String str)	{ card_user     = str; }	


	public String getRent_s_cd		()				{ return rent_s_cd;		}
	public String getDriver_yn		()				{ return driver_yn;		}
	public String getTax_yn			()				{ return tax_yn;		}
	public String getIns_yn			()				{ return ins_yn;		}
	public String getGua_st			()				{ return gua_st;		}
	public String getGua_cau		()				{ return gua_cau;		}
	public String getPaid_way		()				{ return paid_way;		}
	public String getPaid_st		()				{ return paid_st;		}
	public String getCard_no		()				{ return card_no;		}
	public int    getFee_s_amt		()				{ return fee_s_amt;		}
	public int    getFee_v_amt		()				{ return fee_v_amt;		}
	public int    getDc_s_amt		()				{ return dc_s_amt;		}
	public int    getDc_v_amt		()				{ return dc_v_amt;		}
	public int    getIns_s_amt		()				{ return ins_s_amt;		}
	public int    getIns_v_amt		()				{ return ins_v_amt;		}
	public int    getEtc_s_amt		()				{ return etc_s_amt;		}
	public int    getEtc_v_amt		()				{ return etc_v_amt;		}
	public int    getRent_tot_amt	()				{ return rent_tot_amt;	}
	public String getReg_id			()				{ return reg_id;		}
	public String getReg_dt			()				{ return reg_dt;		}
	public String getUpdate_id		()				{ return update_id;		}
	public String getUpdate_dt		()				{ return update_dt;		}
	public int    getTot_s_amt		()				{ return fee_s_amt+cons1_s_amt+cons2_s_amt;	}
	public int    getTot_v_amt		()				{ return fee_v_amt+cons1_v_amt+cons2_v_amt;	}
	public int    getInv_s_amt		()				{ return inv_s_amt;		}
	public int    getInv_v_amt		()				{ return inv_v_amt;		}
	public String getCons_yn		()				{ return cons_yn;		}
	public String getNavi_yn		()				{ return navi_yn;		}
	public String getGps_yn			()				{ return gps_yn;		}
	public String getOil_st			()				{ return oil_st;		}
	public int    getDist_km		()				{ return dist_km;		}
	public String getEst_id			()				{ return est_id;		}
	public int    getNavi_s_amt		()				{ return navi_s_amt;	}
	public int    getNavi_v_amt		()				{ return navi_v_amt;	}
	public int    getCons1_s_amt	()				{ return cons1_s_amt;	}
	public int    getCons1_v_amt	()				{ return cons1_v_amt;	}
	public int    getCons2_s_amt	()				{ return cons2_s_amt;	}
	public int    getCons2_v_amt	()				{ return cons2_v_amt;	}
	public String getFee_etc		()				{ return fee_etc;		}
	public String getCms_bank		()				{ return cms_bank;		}
	public String getCms_acc_no		()				{ return cms_acc_no;	}
	public String getCms_dep_nm		()				{ return cms_dep_nm;	}
	public String getMy_accid_yn	()				{ return my_accid_yn;	}
	public int    getCar_ja			()				{ return car_ja;		}
	public int    getOver_run_amt	()				{ return over_run_amt;	}
	public String getCars			()				{ return cars;			}
	public int    getAmt_01d		()				{ return amt_01d;		}
	public int    getAmt_03d		()				{ return amt_03d;		}
	public int    getAmt_05d		()				{ return amt_05d;		}
	public int    getAmt_07d		()				{ return amt_07d;		}
	public int    getF_rent_tot_amt	()				{ return f_rent_tot_amt;}
	public String getF_paid_way		()				{ return f_paid_way;	}
	public String getF_paid_way2	()				{ return f_paid_way2;	}
	public int    getT_dc_amt		()				{ return t_dc_amt;		}
	public int    getM2_dc_amt		()				{ return m2_dc_amt;		}
	public int    getM3_dc_amt		()				{ return m3_dc_amt;		}
	public String getAmt_per		()				{ return amt_per;		}
	public String getCar_use		()				{ return car_use;		}
	public String getSerial_no		()				{ return serial_no;		}
	public String getCard_y_mm		()				{ return card_y_mm;		}
	public String getCard_y_yy		()				{ return card_y_yy;		}
	public String getCard_user		()				{ return card_user;		}	


}