package acar.account;

import java.util.*;

public class IncomingBean {
    //Table : SCD_FEE
	private String gubun;		//구분:계획,수금,미수금,비율
	private String gubun_sub;	//세무구분
	private int tot_su1;		
    private int tot_su2;		
    private int tot_su3;		
    private int tot_su4;		
    private int tot_su5;		
    private int tot_su6;		
	private int tot_amt1;		
    private int tot_amt2;		
    private int tot_amt3;		
    private int tot_amt4;		
    private int tot_amt5;		
    private int tot_amt6;		
	private String tot_rate1;	
	private String tot_rate2;	
	private String tot_rate3;	
	private String tot_rate4;	
	private String tot_rate5;	
	private String tot_rate6;	
	private String tot_rate7;	
	private String tot_rate8;	

	public IncomingBean() {  
		gubun = "";
		gubun_sub = "";
		tot_su1 = 0;
		tot_su2 = 0;
		tot_su3 = 0;
		tot_su4 = 0;
		tot_su5 = 0;
		tot_su6 = 0;
		tot_amt1 = 0;
		tot_amt2 = 0;
		tot_amt3 = 0;
		tot_amt4 = 0;
		tot_amt5 = 0;
		tot_amt6 = 0;
		tot_rate1 = "";
		tot_rate2 = "";
		tot_rate3 = "";
		tot_rate4 = "";
		tot_rate5 = "";
		tot_rate6 = "";
		tot_rate7 = "";
		tot_rate8 = "";
	}

	// set Method
	public void setGubun(String str){		gubun = str;	}
	public void setGubun_sub(String str){	gubun_sub = str;}
	public void setTot_su1(int i){			tot_su1 = i;	}
	public void setTot_su2(int i){			tot_su2 = i;	}
	public void setTot_su3(int i){			tot_su3 = i;	}
	public void setTot_su4(int i){			tot_su4 = i;	}
	public void setTot_su5(int i){			tot_su5 = i;	}
	public void setTot_su6(int i){			tot_su6 = i;	}
	public void setTot_amt1(int i){			tot_amt1 = i;	}
	public void setTot_amt2(int i){			tot_amt2 = i;	}
	public void setTot_amt3(int i){			tot_amt3 = i;	}
	public void setTot_amt4(int i){			tot_amt4 = i;	}
	public void setTot_amt5(int i){			tot_amt5 = i;	}
	public void setTot_amt6(int i){			tot_amt6 = i;	}
	public void setTot_rate1(String str){	tot_rate1 = str;}
	public void setTot_rate2(String str){	tot_rate2 = str;}
	public void setTot_rate3(String str){	tot_rate3 = str;}
	public void setTot_rate4(String str){	tot_rate4 = str;}
	public void setTot_rate5(String str){	tot_rate5 = str;}
	public void setTot_rate6(String str){	tot_rate6 = str;}
	public void setTot_rate7(String str){	tot_rate7 = str;}
	public void setTot_rate8(String str){	tot_rate8 = str;}
	
	//Get Method
	public String getGubun(){		return gubun;		}
	public String getGubun_sub(){	return gubun_sub;	}
	public int getTot_su1(){		return tot_su1;		}	
	public int getTot_su2(){		return tot_su2;		}	
	public int getTot_su3(){		return tot_su3;		}	
	public int getTot_su4(){		return tot_su4;		}	
	public int getTot_su5(){		return tot_su5;		}	
	public int getTot_su6(){		return tot_su6;		}	
	public int getTot_amt1(){		return tot_amt1;	}	
	public int getTot_amt2(){		return tot_amt2;	}	
	public int getTot_amt3(){		return tot_amt3;	}	
	public int getTot_amt4(){		return tot_amt4;	}	
	public int getTot_amt5(){		return tot_amt5;	}	
	public int getTot_amt6(){		return tot_amt6;	}	
	public String getTot_rate1(){	return tot_rate1;	}
	public String getTot_rate2(){	return tot_rate2;	}
	public String getTot_rate3(){	return tot_rate3;	}
	public String getTot_rate4(){	return tot_rate4;	}
	public String getTot_rate5(){	return tot_rate5;	}
	public String getTot_rate6(){	return tot_rate6;	}
	public String getTot_rate7(){	return tot_rate7;	}
	public String getTot_rate8(){	return tot_rate8;	}

}