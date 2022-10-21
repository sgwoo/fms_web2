package acar.settle_acc;

import java.util.*;

public class SettleStatBean {
	private String gubun;		//구분:대여료,선수금,과태료,면책금,휴차료,중도해지위약금
	private int su;				//건수
    private int amt;			//금액
    private int dly_amt;		//연체금액

	public SettleStatBean() {  
		gubun = "";
		su = 0;
		amt = 0;
		dly_amt = 0;
	}

	// set Method
	public void setGubun(String str){		gubun = str;	}
	public void setSu(int i){				su = i;			}
	public void setAmt(int i){				amt = i;		}
	public void setDly_amt(int i){			dly_amt = i;	}
	
	//Get Method
	public String getGubun(){			return gubun;		}
	public int getSu(){					return su;			}	
	public int getAmt(){				return amt;			}	
	public int getDly_amt(){			return dly_amt;		}	
}

