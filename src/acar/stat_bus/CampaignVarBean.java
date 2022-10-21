package acar.stat_bus;

import java.util.*;

public class CampaignVarBean {

    //Table : CAMPAIGN

    private String  year;				//1
	private String  tm;					//2
    private String  cs_dt;				//3 캠페인기간
    private String  ce_dt;				//4 캠페인기간
    private String  bs_dt;				//5 2군평가기준기간
    private String  be_dt;				//6 2군평가기준기간	
    private int		amt;				//7 기준금액합계
	private int		bus_up_per;			//8 2군평가평균상회
	private int		bus_down_per;		//9 2군평가평균미달
	private int		mng_up_per;			//0 1군평가평균상회
	private int		mng_down_per;		//1 2군평가평균미달
	private int		bus_amt_per;		//2 2군포상금액적용율			
	private int		mng_amt_per;		//3 1군포상금액적용율			
	private int		new_bus_up_per;		//4 
	private int		new_bus_down_per;	//5
	private int		new_bus_amt_per;	//6
    private int		cnt1;				//7 신입사원기준실적 old
    private int		mon;				//8
    private String  cnt2;				//9
	private float	cmp_discnt_per;		//0
	private int		car_amt;			//1 기준금액 대당금액(2군)
	private String	bs_dt2;				//2 1군평가기준기간
	private String	be_dt2;				//3 1군평가기준기간
	private int		max_dalsung;		//4 최대달성율
	private int		bus_ga;				//5 2군가중치
	private int		mng_ga;				//6 1군가중치
	private int		bus_new_ga;			//7 신입사원가중치
	private String	enter_dt;			//8 신입사원기준일자
	private String	ns_dt1;				//9 신입사원1 입사기준일
	private String	ne_dt1;				//0 신입사원1 입사기준일
	private int		nm_cnt1;			//1 신입사원1 1군기준실적
	private int		nb_cnt1;			//2 신입사원1 2군기준실적
	private String	ns_dt2;				//9 신입사원2 입사기준일
	private String	ne_dt2;				//0 신입사원2 입사기준일
	private int		nm_cnt2;			//1 신입사원2 1군기준실적
	private int		nb_cnt2;			//2 신입사원2 2군기준실적
	private String	ns_dt3;				//9 신입사원3 입사기준일
	private String	ne_dt3;				//0 신입사원3 입사기준일
	private int		nm_cnt3;			//1 신입사원3 1군기준실적
	private int		nb_cnt3;			//2 신입사원3 2군기준실적
	private int		car_amt2;			//1 기준금액 대당금액(1군) 
	private int		max_dalsung2;		//4 최대달성율

	public CampaignVarBean() {  
		this.year				= "";
		this.tm					= "";
		this.cs_dt				= "";		
		this.ce_dt				= "";
		this.bs_dt				= "";
		this.be_dt				= "";
		this.amt				= 0;
		this.bus_up_per			= 0;
		this.bus_down_per		= 0;
		this.mng_up_per			= 0;
		this.mng_down_per		= 0;
		this.bus_amt_per		= 0;
		this.mng_amt_per		= 0;
		this.new_bus_up_per		= 0;
		this.new_bus_down_per	= 0;
		this.new_bus_amt_per	= 0;
		this.cnt1				= 0;
		this.mon				= 0;
		this.cnt2				= "";
		this.cmp_discnt_per		= 0;
		this.car_amt			= 0;
		this.bs_dt2				= "";
		this.be_dt2				= "";
		this.max_dalsung		= 0;
		this.bus_ga				= 0;
		this.mng_ga				= 0;
		this.bus_new_ga			= 0;
		this.enter_dt			= "";
		this.ns_dt1				= "";
		this.ne_dt1				= "";
		this.nm_cnt1			= 0;
		this.nb_cnt1			= 0;
		this.ns_dt2				= "";
		this.ne_dt2				= "";
		this.nm_cnt2			= 0;
		this.nb_cnt2			= 0;
		this.ns_dt3				= "";
		this.ne_dt3				= "";
		this.nm_cnt3			= 0;
		this.nb_cnt3			= 0;
		this.car_amt2			= 0;
		this.max_dalsung2		= 0;
	}

	// set Method
	public void setYear				(String val){	if(val==null) val="";	this.year				= val;	}
	public void setTm				(String val){	if(val==null) val="";	this.tm					= val;	}
	public void setCs_dt			(String val){	if(val==null) val="";	this.cs_dt				= val;	}
	public void setCe_dt			(String val){	if(val==null) val="";	this.ce_dt				= val;	}
	public void setBs_dt			(String val){	if(val==null) val="";	this.bs_dt				= val;	}
	public void setBe_dt			(String val){	if(val==null) val="";	this.be_dt				= val;	}
	public void setAmt				(int i){								this.amt				= i;	}
	public void setBus_up_per		(int i){								this.bus_up_per			= i;	}
	public void setBus_down_per		(int i){								this.bus_down_per		= i;	}
	public void setMng_up_per		(int i){								this.mng_up_per			= i;	}
	public void setMng_down_per		(int i){								this.mng_down_per		= i;	}
	public void setBus_amt_per		(int i){								this.bus_amt_per		= i;	}
	public void setMng_amt_per		(int i){								this.mng_amt_per		= i;	}
	public void setNew_bus_up_per	(int i){								this.new_bus_up_per		= i;	}
	public void setNew_bus_down_per	(int i){								this.new_bus_down_per	= i;	}
	public void setNew_bus_amt_per	(int i){								this.new_bus_amt_per	= i;	}
	public void setCnt1				(int i){								this.cnt1				= i;	}
	public void setMon				(int i){								this.mon				= i;	}
	public void setCnt2				(String val){	if(val==null) val="";	this.cnt2				= val;	}
    public void setCmp_discnt_per	(float i){								this.cmp_discnt_per		= i;	}
	public void setCar_amt			(int i){								this.car_amt			= i;	}
	public void setBs_dt2			(String val){	if(val==null) val="";	this.bs_dt2				= val;	}
	public void setBe_dt2			(String val){	if(val==null) val="";	this.be_dt2				= val;	}
	public void setMax_dalsung		(int i){								this.max_dalsung		= i;	}
	public void setBus_ga			(int i){								this.bus_ga				= i;	}
	public void setMng_ga			(int i){								this.mng_ga				= i;	}
	public void setBus_new_ga		(int i){								this.bus_new_ga			= i;	}
	public void setEnter_dt			(String val){	if(val==null) val="";	this.enter_dt			= val;	}
	public void setNs_dt1			(String val){	if(val==null) val="";	this.ns_dt1				= val;	}
	public void setNe_dt1			(String val){	if(val==null) val="";	this.ne_dt1				= val;	}
	public void setNm_cnt1			(int i){								this.nm_cnt1			= i;	}
	public void setNb_cnt1			(int i){								this.nb_cnt1			= i;	}
	public void setNs_dt2			(String val){	if(val==null) val="";	this.ns_dt2				= val;	}
	public void setNe_dt2			(String val){	if(val==null) val="";	this.ne_dt2				= val;	}
	public void setNm_cnt2			(int i){								this.nm_cnt2			= i;	}
	public void setNb_cnt2			(int i){								this.nb_cnt2			= i;	}
	public void setNs_dt3			(String val){	if(val==null) val="";	this.ns_dt3				= val;	}
	public void setNe_dt3			(String val){	if(val==null) val="";	this.ne_dt3				= val;	}
	public void setNm_cnt3			(int i){								this.nm_cnt3			= i;	}
	public void setNb_cnt3			(int i){								this.nb_cnt3			= i;	}
	public void setCar_amt2			(int i){								this.car_amt2			= i;	}
	public void setMax_dalsung2		(int i){								this.max_dalsung2		= i;	}
		

	//Get Method
	public String	getYear				(){			return year;				}
    public String	getTm				(){			return tm;					}
    public String	getCs_dt			(){			return cs_dt;				}
	public String	getCe_dt			(){			return ce_dt;				}
    public String	getBs_dt			(){			return bs_dt;				}
    public String	getBe_dt			(){			return be_dt;				}    
	public int		getAmt				(){			return amt;					}
	public int		getBus_up_per		(){			return bus_up_per;			}
	public int		getBus_down_per		(){			return bus_down_per;		}
	public int		getMng_up_per		(){			return mng_up_per;			}
	public int		getMng_down_per		(){			return mng_down_per;		}
	public int		getBus_amt_per		(){			return bus_amt_per;			}
	public int		getMng_amt_per		(){			return mng_amt_per;			}
	public int		getNew_bus_up_per	(){			return new_bus_up_per;		}
	public int		getNew_bus_down_per	(){			return new_bus_down_per;	}
	public int		getNew_bus_amt_per	(){			return new_bus_amt_per;		}
	public int		getCnt1				(){			return cnt1;				}
	public int		getMon				(){			return mon;					}
	public String	getCnt2				(){			return cnt2;				}
	public float	getCmp_discnt_per	(){			return cmp_discnt_per;		}
	public int		getCar_amt			(){			return car_amt;				}
	public String	getBs_dt2			(){			return bs_dt2;				}
	public String	getBe_dt2			(){			return be_dt2;				}
	public int		getMax_dalsung		(){			return max_dalsung;			}
	public int		getBus_ga			(){			return bus_ga;				}
	public int		getMng_ga			(){			return mng_ga;				}
	public int		getBus_new_ga		(){			return bus_new_ga;			}
    public String	getEnter_dt			(){			return enter_dt;			}
    public String	getNs_dt1			(){			return ns_dt1;				}
    public String	getNe_dt1			(){			return ne_dt1;				}
	public int		getNm_cnt1			(){			return nm_cnt1;				}
	public int		getNb_cnt1			(){			return nb_cnt1;				}
    public String	getNs_dt2			(){			return ns_dt2;				}
    public String	getNe_dt2			(){			return ne_dt2;				}
	public int		getNm_cnt2			(){			return nm_cnt2;				}
	public int		getNb_cnt2			(){			return nb_cnt2;				}
    public String	getNs_dt3			(){			return ns_dt3;				}
    public String	getNe_dt3			(){			return ne_dt3;				}
	public int		getNm_cnt3			(){			return nm_cnt3;				}
	public int		getNb_cnt3			(){			return nb_cnt3;				}
	public int		getCar_amt2			(){			return car_amt2;			}
	public int		getMax_dalsung2		(){			return max_dalsung2;		}


}
