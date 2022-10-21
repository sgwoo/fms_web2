package acar.admin;

import java.util.*;

public class StatDlyBean {
    //Table : STAT_DLY
    private String save_dt;			//등록일자
	private String seq;				//일련번호
    private String bus_id2;			//사원ID
	private long tot_amt;			//전체대여료
	private long amt;				//연체대여료
	private int su;					//연체건수
	private String per1;			//연체율
	private String per2;			//연체점유비
	private String reg_id;			//등록자
	private long tot_dly_amt;		//총연체대여료
	private long three_amt;			//3개월받을어음
	private String avg_per;			//평균연체율
	private String cmp_per;			//적용연체율

	public StatDlyBean() {  
		this.save_dt = "";
		this.seq = "";
		this.bus_id2 = "";
		this.tot_amt = 0;
		this.amt = 0;
		this.su = 0;
		this.per1 = "";
		this.per1 = "";
		this.reg_id = "";
		this.tot_dly_amt = 0;
		this.three_amt = 0;
		this.avg_per = "";
		this.cmp_per = "";
	}

	// set Method
	public void setSave_dt(String val){	if(val==null) val="";	this.save_dt = val;		}
	public void setSeq(String val){		if(val==null) val="";	this.seq = val;			}
	public void setBus_id2(String val){	if(val==null) val="";	this.bus_id2 = val;		}
	public void setTot_amt(long i){								this.tot_amt = i;		}
    public void setAmt(long i){									this.amt = i;			}
    public void setSu(int i){									this.su = i;			}
    public void setPer1(String val){	if(val==null) val="";	this.per1 = val;		}
    public void setPer2(String val){	if(val==null) val="";	this.per2 = val;		}
    public void setReg_id(String val){	if(val==null) val="";	this.reg_id = val;		}
	public void setTot_dly_amt(long i){							this.tot_dly_amt = i;	}
	public void setThree_amt(long i){							this.three_amt = i;		}
    public void setAvg_per(String val){	if(val==null) val="";	this.avg_per = val;		}
    public void setCmp_per(String val){	if(val==null) val="";	this.cmp_per = val;		}
	
	//Get Method
	public String getSave_dt(){			return save_dt;		}
    public String getSeq(){				return seq;			}
    public String getBus_id2(){			return bus_id2;		}
	public long getTot_amt(){			return tot_amt;		}
	public long getAmt(){				return amt;			}
    public int getSu(){					return su;			}
    public String getPer1(){			return per1;		}
    public String getPer2(){			return per2;		}
    public String getReg_id(){			return reg_id;		}
	public long getTot_dly_amt(){		return tot_dly_amt;	}	
	public long getThree_amt(){			return three_amt;	}	
    public String getAvg_per(){			return avg_per;		}
    public String getCmp_per(){			return cmp_per;		}

}