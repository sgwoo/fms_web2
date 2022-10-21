// 단기대여 요금관리

// 작성일 : 2003.12.18 (정현미)

package acar.short_fee_mng;

public class ShortFeeMngBean
{
	private String kind;			//차량구분
	private String section;			//차량구분코드
	private String fee_st;			//요금구분:대여요금총액, 1개월 대여요금
	private int amt_12h;			//12시간요금
	private int amt_01d;			//01일요금
	private int amt_02d;			//02일요금
	private int amt_03d;			//03일요금
	private int amt_04d;			//04일요금
	private int amt_05d;			//05일요금
	private int amt_06d;			//06일요금
	private int amt_07d;			//07일요금
	private int amt_08d;			//08일요금
	private int amt_09d;			//09일요금
	private int amt_10d;			//10일요금
	private int amt_11d;			//11일요금
	private int amt_12d;			//12일요금
	private int amt_13d;			//13일요금
	private int amt_14d;			//14일요금
	private int amt_15d;			//15일요금
	private int amt_16d;			//16일요금
	private int amt_17d;			//17일요금
	private int amt_18d;			//18일요금
	private int amt_19d;			//19일요금
	private int amt_20d;			//20일요금
	private int amt_21d;			//21일요금
	private int amt_22d;			//22일요금
	private int amt_23d;			//23일요금
	private int amt_24d;			//24일요금
	private int amt_25d;			//25일요금
	private int amt_26d;			//26일요금
	private int amt_27d;			//27일요금
	private int amt_28d;			//28일요금
	private int amt_29d;			//29일요금
	private int amt_30d;			//30일요금
	private int amt_01m;			//01개월요금
	private int amt_02m;			//02개월요금
	private int amt_03m;			//03개월요금
	private int amt_04m;			//04개월요금
	private int amt_05m;			//05개월요금
	private int amt_06m;			//06개월요금
	private int amt_07m;			//07개월요금
	private int amt_08m;			//08개월요금
	private int amt_09m;			//09개월요금
	private int amt_10m;			//10개월요금
	private int amt_11m;			//11개월요금
	private String use_yn;			//사용여부
	private String reg_id;			//등록자
	private String reg_dt;			//등록일
	private String update_id;		//수정자
	private String update_dt;		//수정일
	private String stand_car;		//대표차량
	private String nm;				//차량구분명
	
	public ShortFeeMngBean()
	{
		kind	= "";    
		section = "";    
		fee_st = "";    
		amt_12h = 0;
		amt_01d = 0;
		amt_02d = 0;
		amt_03d = 0;
		amt_04d = 0;
		amt_05d = 0;
		amt_06d = 0;
		amt_07d = 0;
		amt_08d = 0;
		amt_09d = 0;
		amt_10d = 0;
		amt_11d = 0;
		amt_12d = 0;
		amt_13d = 0;
		amt_14d = 0;
		amt_15d = 0;
		amt_16d = 0;
		amt_17d = 0;
		amt_18d = 0;
		amt_19d = 0;
		amt_20d = 0;
		amt_21d = 0;
		amt_22d = 0;
		amt_23d = 0;
		amt_24d = 0;
		amt_25d = 0;
		amt_26d = 0;
		amt_27d = 0;
		amt_28d = 0;
		amt_29d = 0;
		amt_30d = 0;
		amt_01m = 0;
		amt_02m = 0;
		amt_03m = 0;
		amt_04m = 0;
		amt_05m = 0;
		amt_06m = 0;
		amt_07m = 0;
		amt_08m = 0;
		amt_09m = 0;
		amt_10m = 0;
		amt_11m = 0;		
		use_yn = "";    
		reg_dt = "";    
		reg_id = "";    
		update_dt = "";    
		update_id = "";
		stand_car = "";
		nm = "";
	}
	
	public void setKind(String str) 		{ kind			= str; }
	public void setSection(String str)		{ section		= str; }    	
	public void setFee_st(String str)		{ fee_st		= str; }		
	public void setAmt_12h(int i)			{ amt_12h		= i;   }    
	public void setAmt_01d(int i)			{ amt_01d		= i;   }    
	public void setAmt_02d(int i)			{ amt_02d		= i;   }    
	public void setAmt_03d(int i)			{ amt_03d		= i;   }    
	public void setAmt_04d(int i)			{ amt_04d		= i;   }    
	public void setAmt_05d(int i)			{ amt_05d		= i;   }    
	public void setAmt_06d(int i)			{ amt_06d		= i;   }    
	public void setAmt_07d(int i)			{ amt_07d		= i;   }    
	public void setAmt_08d(int i)			{ amt_08d		= i;   }    
	public void setAmt_09d(int i)			{ amt_09d		= i;   }    
	public void setAmt_10d(int i)			{ amt_10d		= i;   }    
	public void setAmt_11d(int i)			{ amt_11d		= i;   }    
	public void setAmt_12d(int i)			{ amt_12d		= i;   }    
	public void setAmt_13d(int i)			{ amt_13d		= i;   }    
	public void setAmt_14d(int i)			{ amt_14d		= i;   }    
	public void setAmt_15d(int i)			{ amt_15d		= i;   }    
	public void setAmt_16d(int i)			{ amt_16d		= i;   }    
	public void setAmt_17d(int i)			{ amt_17d		= i;   }    
	public void setAmt_18d(int i)			{ amt_18d		= i;   }    
	public void setAmt_19d(int i)			{ amt_19d		= i;   }    
	public void setAmt_20d(int i)			{ amt_20d		= i;   }    
	public void setAmt_21d(int i)			{ amt_21d		= i;   }    
	public void setAmt_22d(int i)			{ amt_22d		= i;   }    
	public void setAmt_23d(int i)			{ amt_23d		= i;   }    
	public void setAmt_24d(int i)			{ amt_24d		= i;   }    
	public void setAmt_25d(int i)			{ amt_25d		= i;   }    
	public void setAmt_26d(int i)			{ amt_26d		= i;   }    
	public void setAmt_27d(int i)			{ amt_27d		= i;   }    
	public void setAmt_28d(int i)			{ amt_28d		= i;   }    
	public void setAmt_29d(int i)			{ amt_29d		= i;   }    
	public void setAmt_30d(int i)			{ amt_30d		= i;   }    
	public void setAmt_01m(int i)			{ amt_01m		= i;   }    
	public void setAmt_02m(int i)			{ amt_02m		= i;   }    
	public void setAmt_03m(int i)			{ amt_03m		= i;   }    
	public void setAmt_04m(int i)			{ amt_04m		= i;   }    
	public void setAmt_05m(int i)			{ amt_05m		= i;   }    
	public void setAmt_06m(int i)			{ amt_06m		= i;   }    
	public void setAmt_07m(int i)			{ amt_07m		= i;   }    
	public void setAmt_08m(int i)			{ amt_08m		= i;   }    
	public void setAmt_09m(int i)			{ amt_09m		= i;   }    
	public void setAmt_10m(int i)			{ amt_10m		= i;   }    
	public void setAmt_11m(int i)			{ amt_11m		= i;   }    	
	public void setUse_yn(String str)		{ use_yn		= str; }    
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setReg_id(String str)		{ reg_id		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setUpdate_id(String str)	{ update_id		= str; }    
	public void setStand_car(String str)	{ stand_car		= str; }    
	public void setNm(String str)			{ nm			= str; }    

	public String getKind() 		{ return kind;			}
	public String getSection()		{ return section;		}
	public String getFee_st()		{ return fee_st;		}
	public int getAmt_12h()			{ return amt_12h;		}
	public int getAmt_01d()			{ return amt_01d;		}
	public int getAmt_02d()			{ return amt_02d;		}
	public int getAmt_03d()			{ return amt_03d;		}
	public int getAmt_04d()			{ return amt_04d;		}
	public int getAmt_05d()			{ return amt_05d;		}
	public int getAmt_06d()			{ return amt_06d;		}
	public int getAmt_07d()			{ return amt_07d;		}
	public int getAmt_08d()			{ return amt_08d;		}
	public int getAmt_09d()			{ return amt_09d;		}
	public int getAmt_10d()			{ return amt_10d;		}
	public int getAmt_11d()			{ return amt_11d;		}
	public int getAmt_12d()			{ return amt_12d;		}
	public int getAmt_13d()			{ return amt_13d;		}
	public int getAmt_14d()			{ return amt_14d;		}
	public int getAmt_15d()			{ return amt_15d;		}
	public int getAmt_16d()			{ return amt_16d;		}
	public int getAmt_17d()			{ return amt_17d;		}
	public int getAmt_18d()			{ return amt_18d;		}
	public int getAmt_19d()			{ return amt_19d;		}
	public int getAmt_20d()			{ return amt_20d;		}
	public int getAmt_21d()			{ return amt_21d;		}
	public int getAmt_22d()			{ return amt_22d;		}
	public int getAmt_23d()			{ return amt_23d;		}
	public int getAmt_24d()			{ return amt_24d;		}
	public int getAmt_25d()			{ return amt_25d;		}
	public int getAmt_26d()			{ return amt_26d;		}
	public int getAmt_27d()			{ return amt_27d;		}
	public int getAmt_28d()			{ return amt_28d;		}
	public int getAmt_29d()			{ return amt_29d;		}
	public int getAmt_30d()			{ return amt_30d;		}
	public int getAmt_01m()			{ return amt_01m;		}
	public int getAmt_02m()			{ return amt_02m;		}
	public int getAmt_03m()			{ return amt_03m;		}
	public int getAmt_04m()			{ return amt_04m;		}
	public int getAmt_05m()			{ return amt_05m;		}
	public int getAmt_06m()			{ return amt_06m;		}
	public int getAmt_07m()			{ return amt_07m;		}
	public int getAmt_08m()			{ return amt_08m;		}
	public int getAmt_09m()			{ return amt_09m;		}
	public int getAmt_10m()			{ return amt_10m;		}
	public int getAmt_11m()			{ return amt_11m;		}
	public String getUse_yn()		{ return use_yn;		}
	public String getReg_dt()		{ return reg_dt;		}
	public String getReg_id()		{ return reg_id;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getUpdate_id()	{ return update_id;		}
	public String getStand_car()	{ return stand_car;		}
	public String getNm()			{ return nm;			}

}