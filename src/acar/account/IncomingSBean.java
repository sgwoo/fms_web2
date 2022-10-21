package acar.account;

import java.util.*;

public class IncomingSBean {
    //Table : SCD_FEE
	private String gubun;		//구분:계획,수금,미수금,비율
	private String gubun_sub;	//세무구분
	private String tot_su1;		//당월건수
    private String tot_su2;		//당월금액		
    private String tot_su3;		//당일건수
    private String tot_su4;		//당일금액
    private String tot_su5;		//추가
	private String tot_su6;		//당월건수
    private String tot_su7;		//당월금액		
    private String tot_su8;		//당일건수
    private String tot_su9;		//당일금액
	private String tot_amt1;	//연체건수
    private String tot_amt2;	//연체금액
    private String tot_amt3;	//합계건수
    private String tot_amt4;	//합계금액
	private String tot_amt5;
	private int st;
	private String br_id;
	private String dept_id;
	private String partner_id;
	private String partner_nm;
	private String reg_dt;
	private String tot_amt6;
	private String tot_amt7;
	private String tot_amt8;  //연체율 - 내근
	private String tot_amt9;  //감소치 - 내근 

	public IncomingSBean() {  
		gubun = "";
		gubun_sub = "";
		tot_su1 = "";
		tot_su2 = "";
		tot_su3 = "";
		tot_su4 = "";
		tot_su5 = "";		
		tot_su6 = "";
		tot_su7 = "";
		tot_su8 = "";
		tot_su9 = "";
		tot_amt1 = "";
		tot_amt2 = "";
		tot_amt3 = "";
		tot_amt4 = "";
		tot_amt5 = "";
		st = 0;
		br_id = "";
		dept_id = "";
		partner_id = "";
		partner_nm = "";
		reg_dt = "";
		tot_amt6 = "";
		tot_amt7 = "";
		tot_amt8 = "";
		tot_amt9 = "";
	}

	// set Method
	public void setGubun(String str){		gubun = str;	}
	public void setGubun_sub(String str){	gubun_sub = str;}
	public void setTot_su1(String str){		tot_su1 = str;	}
	public void setTot_su2(String str){		tot_su2 = str;	}
	public void setTot_su3(String str){		tot_su3 = str;	}
	public void setTot_su4(String str){		tot_su4 = str;	}
	public void setTot_su5(String str){		tot_su5 = str;	}
	public void setTot_su6(String str){		tot_su6 = str;	}
	public void setTot_su7(String str){		tot_su7 = str;	}
	public void setTot_su8(String str){		tot_su8 = str;	}
	public void setTot_su9(String str){		tot_su9 = str;	}
	public void setTot_amt1(String str){	tot_amt1 = str;	}
	public void setTot_amt2(String str){	tot_amt2 = str;	}
	public void setTot_amt3(String str){	tot_amt3 = str;	}
	public void setTot_amt4(String str){	tot_amt4 = str;	}
	public void setTot_amt5(String str){	tot_amt5 = str;	}
	public void setSt(int str){				st = str;		}
	public void setBr_id(String str){		br_id = str;	}
	public void setDept_id(String str){		dept_id = str;	}
	public void setPartner_id(String str){	partner_id = str;	}
	public void setPartner_nm(String str){	partner_nm = str;	}
	public void setReg_dt(String str){	reg_dt = str;	}
	public void setTot_amt6(String str){	tot_amt6 = str;	}
	public void setTot_amt7(String str){	tot_amt7 = str;	}
	public void setTot_amt8(String str){	tot_amt8 = str;	}
	public void setTot_amt9(String str){	tot_amt9 = str;	}

	//Get Method
	public String getGubun(){		return gubun;		}
	public String getGubun_sub(){	return gubun_sub;	}
	public String getTot_su1(){		return tot_su1;		}	
	public String getTot_su2(){		return tot_su2;		}	
	public String getTot_su3(){		return tot_su3;		}	
	public String getTot_su4(){		return tot_su4;		}	
	public String getTot_su5(){		return tot_su5;		}	
	public String getTot_su6(){		return tot_su6;		}	
	public String getTot_su7(){		return tot_su7;		}	
	public String getTot_su8(){		return tot_su8;		}	
	public String getTot_su9(){		return tot_su9;		}	
	public String getTot_amt1(){	return tot_amt1;	}	
	public String getTot_amt2(){	return tot_amt2;	}	
	public String getTot_amt3(){	return tot_amt3;	}	
	public String getTot_amt4(){	return tot_amt4;	}	
	public String getTot_amt5(){	return tot_amt5;	}	
	public int getSt(){				return st;			}	
	public String getBr_id(){		return br_id;		}
	public String getDept_id(){		return dept_id;		}
	public String getPartner_id(){	return partner_id;	}	
	public String getPartner_nm(){	return partner_nm;	}	
	public String getReg_dt()	{	return reg_dt;	}	
	public String getTot_amt6(){	return tot_amt6;	}	
	public String getTot_amt7(){	return tot_amt7;	}	
	public String getTot_amt8(){	return tot_amt8;	}	
	public String getTot_amt9(){	return tot_amt9;	}	

}