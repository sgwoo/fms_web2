// 단기계약 정산관리

// 작성일 : 2003.12.11 (정현미)

package acar.res_search;

public class RentSettleBean
{
	private String rent_s_cd;			//단기계약관리번호
	private String sett_dt;				//정산일자
	private String run_km;				//주행거리
	private String agree_hour;			//약정시간
	private String agree_days;			//약정시간
	private String agree_months;		//약정시간
	private String add_hour;			//추가시간
	private String add_days;			//추가시간
	private String add_months;			//추가시간
	private String tot_hour;			//이용시간
	private String tot_days;			//이용시간
	private String tot_months;			//이용시간
	private String etc;					//비고
	private int    add_fee_amt;			//추가-대여료
	private int    add_fee_s_amt;		//추가-대여료
	private int    add_fee_v_amt;		//추가-대여료
	private int    add_ins_amt;			//추가_선택보험료
	private int    add_ins_s_amt;		//추가_선택보험료
	private int    add_ins_v_amt;		//추가_선택보험료
	private int    add_etc_amt;			//추가-기타비용
	private int    add_etc_s_amt;		//추가-기타비용
	private int    add_etc_v_amt;		//추가-기타비용
	private int    ins_m_amt;			//부대비용-면채금
	private int    ins_m_s_amt;			//부대비용-면채금
	private int    ins_m_v_amt;			//부대비용-면채금
	private int    ins_h_amt;			//부대비용-휴차료
	private int    ins_h_s_amt;			//부대비용-휴차료
	private int    ins_h_v_amt;			//부대비용-휴차료
	private int    oil_amt;				//부대비용-유류비
	private int    oil_s_amt;			//부대비용-유류비
	private int    oil_v_amt;			//부대비용-유류비
	private int    rent_tot_amt;		//정산대여료
	private int    rent_sett_amt;		//총정산금
	private String driv_serv_st;		//운전기사 용역비용 결재방법:별도, 합산
	private String driv_serv_etc;		//운전기사 용역비용 비고
	private String reg_id;				//등록자
	private String reg_dt;				//등록일
	private String update_id;			//수정자
	private String update_dt;			//수정일
	//20120615 월렌트정산 추가
	private int    add_navi_amt;		//네비게이션_공급가        
	private int    add_navi_s_amt;		//네비게이션_공급가        
	private int    add_navi_v_amt;		//네비게이션_부가세      
	private int    add_cons1_amt;		//배차료_공급가        
	private int    add_cons1_s_amt;		//배차료_공급가        
	private int    add_cons1_v_amt;		//배차료_부가세      
	private int    add_cons2_amt;		//반차료_공급가        
	private int    add_cons2_s_amt;		//반차료_공급가        
	private int    add_cons2_v_amt;		//반차료_부가세      
	private int    cls_amt;				//위약금_공급가    
	private int    cls_s_amt;			//위약금_공급가    
	private int    cls_v_amt;			//위약금_부가세      
	private int    km_amt;				//km초과운행_공급가        
	private int    km_s_amt;			//km초과운행_공급가        
	private int    km_v_amt;			//km초과운행_부가세      
	private int    add_inv_amt;			//월대여료
	private int    add_inv_s_amt;		//월대여료_공급가   
	private int    add_inv_v_amt;		//월대여료_부가세    
	private int    fine_s_amt;			//과태료


	public RentSettleBean()
	{
		rent_s_cd			= "";    
		sett_dt				= "";        
		run_km				= "";    
		agree_hour			= "";
		agree_days			= "";
		agree_months		= "";
		add_hour			= "";
		add_days			= "";
		add_months			= "";
		tot_hour			= "";
		tot_days			= "";
		tot_months			= "";
		etc					= "";
		add_fee_amt			= 0;
		add_fee_s_amt		= 0;
		add_fee_v_amt		= 0;
		add_ins_amt			= 0;
		add_ins_s_amt		= 0;
		add_ins_v_amt		= 0;
		add_etc_amt			= 0;
		add_etc_s_amt		= 0;
		add_etc_v_amt		= 0;
		ins_m_amt			= 0;    
		ins_m_s_amt			= 0;    
		ins_m_v_amt			= 0;    
		ins_h_amt			= 0;
		ins_h_s_amt			= 0;
		ins_h_v_amt			= 0;
		oil_amt				= 0;
		oil_s_amt			= 0;
		oil_v_amt			= 0;
		rent_tot_amt		= 0;
		rent_sett_amt		= 0;
		driv_serv_st		= "";
		driv_serv_etc		= "";
		reg_id				= "";
		reg_dt				= "";
		update_id			= "";
		update_dt			= "";
		add_navi_amt		= 0;
		add_navi_s_amt		= 0;
		add_navi_v_amt		= 0;
		add_cons1_amt		= 0;
		add_cons1_s_amt		= 0;
		add_cons1_v_amt		= 0;
		add_cons2_amt		= 0;
		add_cons2_s_amt		= 0;
		add_cons2_v_amt		= 0;
		cls_amt				= 0;
		cls_s_amt			= 0;
		cls_v_amt			= 0;
		km_amt				= 0;
		km_s_amt			= 0;
		km_v_amt			= 0;
		add_inv_amt			= 0;
		add_inv_s_amt		= 0;
		add_inv_v_amt		= 0;
		fine_s_amt			= 0;

	}
	
	public void setRent_s_cd			(String str) 	{ rent_s_cd			= str; }
	public void setSett_dt				(String str)	{ sett_dt			= str; }
	public void setRun_km				(String str)	{ run_km			= str; }    	
	public void setAgree_hour			(String str)	{ agree_hour		= str; }		
	public void setAgree_days			(String str)	{ agree_days		= str; }		
	public void setAgree_months			(String str)	{ agree_months		= str; }		
	public void setAdd_hour				(String str)	{ add_hour			= str; }		
	public void setAdd_days				(String str)	{ add_days			= str; }		
	public void setAdd_months			(String str)	{ add_months		= str; }		
	public void setTot_hour				(String str)	{ tot_hour			= str; }		
	public void setTot_days				(String str)	{ tot_days			= str; }		
	public void setTot_months			(String str)	{ tot_months		= str; }		
	public void setEtc					(String str)	{ etc				= str; }    
	public void setAdd_fee_s_amt		(int i)			{ add_fee_s_amt		= i;   }    	
	public void setAdd_fee_v_amt		(int i)			{ add_fee_v_amt		= i;   }    	
	public void setAdd_ins_s_amt		(int i)			{ add_ins_s_amt		= i;   }    	
	public void setAdd_ins_v_amt		(int i)			{ add_ins_v_amt		= i;   }    	
	public void setAdd_etc_s_amt		(int i)			{ add_etc_s_amt		= i;   }    	
	public void setAdd_etc_v_amt		(int i)			{ add_etc_v_amt		= i;   }    	
	public void setIns_m_s_amt			(int i)			{ ins_m_s_amt		= i;   }    	
	public void setIns_m_v_amt			(int i)			{ ins_m_v_amt		= i;   }    	
	public void setIns_h_s_amt			(int i)			{ ins_h_s_amt		= i;   }    	
	public void setIns_h_v_amt			(int i)			{ ins_h_v_amt		= i;   }    	
	public void setOil_s_amt			(int i)			{ oil_s_amt			= i;   }    	
	public void setOil_v_amt			(int i)			{ oil_v_amt			= i;   }    	
	public void setRent_tot_amt			(int i)			{ rent_tot_amt		= i;   }    	
	public void setRent_sett_amt		(int i)			{ rent_sett_amt		= i;   }    	
	public void setDriv_serv_st			(String str)	{ driv_serv_st		= str; }    
	public void setDriv_serv_etc		(String str)	{ driv_serv_etc		= str; }    
	public void setReg_id				(String str)	{ reg_id			= str; }    
	public void setReg_dt				(String str)	{ reg_dt			= str; }    
	public void setUpdate_id			(String str)	{ update_id			= str; }    
	public void setUpdate_dt			(String str)	{ update_dt			= str; } 
	public void setAdd_navi_s_amt		(int i)			{ add_navi_s_amt	= i;   }    	
	public void setAdd_navi_v_amt		(int i)			{ add_navi_v_amt	= i;   }    	
	public void setAdd_cons1_s_amt		(int i)			{ add_cons1_s_amt	= i;   }    	
	public void setAdd_cons1_v_amt		(int i)			{ add_cons1_v_amt	= i;   }    	
	public void setAdd_cons2_s_amt		(int i)			{ add_cons2_s_amt	= i;   }    	
	public void setAdd_cons2_v_amt		(int i)			{ add_cons2_v_amt	= i;   }
	public void setCls_s_amt			(int i)			{ cls_s_amt			= i;   }    	
	public void setCls_v_amt			(int i)			{ cls_v_amt			= i;   }    	
	public void setKm_s_amt				(int i)			{ km_s_amt			= i;   }    	
	public void setKm_v_amt				(int i)			{ km_v_amt			= i;   }    	
	public void setAdd_inv_s_amt		(int i)			{ add_inv_s_amt		= i;   }    	
	public void setAdd_inv_v_amt		(int i)			{ add_inv_v_amt		= i;   }    	
	public void setFine_s_amt			(int i)			{ fine_s_amt		= i;   }    	
	

	public String getRent_s_cd			()				{ return rent_s_cd;							}
	public String getSett_dt			()				{ return sett_dt;							}
	public String getRun_km				()				{ return run_km;							}
	public String getAgree_hour			()				{ return agree_hour;						}
	public String getAgree_days			()				{ return agree_days;						}
	public String getAgree_months		()				{ return agree_months;						}
	public String getAdd_hour			()				{ return add_hour;							}
	public String getAdd_days			()				{ return add_days;							}
	public String getAdd_months			()				{ return add_months;						}
	public String getTot_hour			()				{ return tot_hour;							}
	public String getTot_days			()				{ return tot_days;							}
	public String getTot_months			()				{ return tot_months;						}
	public String getEtc				()				{ return etc;								}
	public int    getAdd_fee_amt		()				{ return add_fee_s_amt+add_fee_v_amt;		}
	public int    getAdd_fee_s_amt		()				{ return add_fee_s_amt;						}
	public int    getAdd_fee_v_amt		()				{ return add_fee_v_amt;						}
	public int    getAdd_ins_amt		()				{ return add_ins_s_amt+add_ins_v_amt;		}
	public int    getAdd_ins_s_amt		()				{ return add_ins_s_amt;						}
	public int    getAdd_ins_v_amt		()				{ return add_ins_v_amt;						}
	public int    getAdd_etc_amt		()				{ return add_etc_s_amt+add_etc_v_amt;		}
	public int    getAdd_etc_s_amt		()				{ return add_etc_s_amt;						}
	public int    getAdd_etc_v_amt		()				{ return add_etc_v_amt;						}
	public int    getIns_m_amt			()				{ return ins_m_s_amt+ins_m_v_amt;			}
	public int    getIns_m_s_amt		()				{ return ins_m_s_amt;						}
	public int    getIns_m_v_amt		()				{ return ins_m_v_amt;						}
	public int    getIns_h_amt			()				{ return ins_h_s_amt+ins_h_v_amt;			}
	public int    getIns_h_s_amt		()				{ return ins_h_s_amt;						}
	public int    getIns_h_v_amt		()				{ return ins_h_v_amt;						}
	public int    getOil_amt			()				{ return oil_s_amt+oil_v_amt;				}
	public int    getOil_s_amt			()				{ return oil_s_amt;							}
	public int    getOil_v_amt			()				{ return oil_v_amt;							}
	public int    getRent_tot_amt		()				{ return rent_tot_amt;						}
	public int    getRent_sett_amt		()				{ return rent_sett_amt;						}
	public String getDriv_serv_st		()				{ return driv_serv_st;						}
	public String getDriv_serv_etc		()				{ return driv_serv_etc;						}
	public String getReg_id				()				{ return reg_id;							}
	public String getReg_dt				()				{ return reg_dt;							}
	public String getUpdate_id			()				{ return update_id;							}
	public String getUpdate_dt			()				{ return update_dt;							}
	public int    getAdd_navi_amt		()				{ return add_navi_s_amt+add_navi_v_amt;		}
	public int    getAdd_navi_s_amt		()				{ return add_navi_s_amt;					}
	public int    getAdd_navi_v_amt		()				{ return add_navi_v_amt;					}
	public int    getAdd_cons1_amt		()				{ return add_cons1_s_amt+add_cons1_v_amt;	}
	public int    getAdd_cons1_s_amt	()				{ return add_cons1_s_amt;					}
	public int    getAdd_cons1_v_amt	()				{ return add_cons1_v_amt;					}
	public int    getAdd_cons2_amt		()				{ return add_cons2_s_amt+add_cons2_v_amt;	}
	public int    getAdd_cons2_s_amt	()				{ return add_cons2_s_amt;					}
	public int    getAdd_cons2_v_amt	()				{ return add_cons2_v_amt;					}
	public int    getCls_amt			()				{ return cls_s_amt+cls_v_amt;				}
	public int    getCls_s_amt			()				{ return cls_s_amt;							}
	public int    getCls_v_amt			()				{ return cls_v_amt;							}
	public int    getKm_amt				()				{ return km_s_amt+km_v_amt;					}
	public int    getKm_s_amt			()				{ return km_s_amt;							}
	public int    getKm_v_amt			()				{ return km_v_amt;							}
	public int    getAdd_inv_amt		()				{ return add_inv_s_amt+add_inv_v_amt;		}
	public int    getAdd_inv_s_amt		()				{ return add_inv_s_amt;						}
	public int    getAdd_inv_v_amt		()				{ return add_inv_v_amt;						}
	public int    getFine_s_amt			()				{ return fine_s_amt;						}
	
}