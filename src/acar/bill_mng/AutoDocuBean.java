package acar.bill_mng;

import java.util.*;

public class AutoDocuBean {

	private int data_no;
	private String ven_code;
    private String firm_nm;
    private String acct_dt;
    private String acct_code;
    private String bank_code;
    private String bank_name;
    private String deposit_no;
    private String deposit_name;
    private String acct_cont;
	private int amt;
	private int amt2;
	private int amt3;
	private int amt4;
	private int amt5;
	private int amt6;
	private int amt7;
	private int amt8;
	private String node_code;
	private String insert_id;
    private String write_dt;
    private String ven_type;
    private String s_idno;
    private String item_code;
    private String item_name;
    private String sa_code;
    private String kname;
    private String dept_code;
    private String dept_name;
    private String cardno;
    private String buy_id;
    private String card_name;
    private String com_code;
    private String com_name;
	private String tax_yn;
	private int data_line;
	private String car_st;
	private String acct_cd1;
	private String acct_cd2;
	private String acct_cd3;
	private String acct_cd4;
	private String ven_code2;
	private String ven_code3;
	private String ven_code4;
    private String firm_nm2;
    private String firm_nm3;
    private String firm_nm4;
    private String cardno1;
    private String cardno2;
    private String cardno3;
    private String cardno4;
    private String cardnm1;
    private String cardnm2;
    private String cardnm3;
    private String cardnm4;
    private String ven_code5;
    private String ven_code6;
    private String ven_code7;
    private String firm_nm5;
    private String firm_nm6;
    private String firm_nm7;
    private String acct_cont1;
    private String acct_cont2;
    private String acct_cont3;
    private String acct_cont4;
	private String nm_item;


	
    public AutoDocuBean() {  
		this.data_no = 0;
		this.ven_code = "";
    	this.firm_nm = "";
	    this.acct_dt = "";
	    this.acct_code = "";
	    this.bank_code = "";
	    this.bank_name = "";
	    this.deposit_no = "";
	    this.deposit_name = "";
	    this.acct_cont = "";
		this.amt = 0;
		this.amt2 = 0;
		this.amt3 = 0;
		this.amt4 = 0;
		this.amt5 = 0;
		this.amt6 = 0;
		this.amt7 = 0;
		this.amt8 = 0;
		this.node_code = "";
		this.insert_id = "";
		this.write_dt = "";
    	this.ven_type = "";
    	this.s_idno = "";
    	this.item_code = "";
    	this.item_name = "";
    	this.sa_code = "";
    	this.kname = "";
    	this.dept_code = "";
    	this.dept_name = "";
    	this.cardno = "";
    	this.buy_id = "";
    	this.card_name = "";
    	this.com_code = "";
    	this.com_name = "";
		this.tax_yn	= "";
		this.acct_cd1	= "";
		this.acct_cd2	= "";
		this.acct_cd3	= "";
		this.acct_cd4	= "";
		this.data_line	= 0;
		this.car_st		= "";
		this.ven_code2 = "";
		this.ven_code3 = "";
		this.ven_code4 = "";
    	this.firm_nm2 = "";
    	this.firm_nm3 = "";
    	this.firm_nm4 = "";
		this.cardno1	= "";
		this.cardno2	= "";
		this.cardno3	= "";
		this.cardno4	= "";
		this.cardnm1	= "";
		this.cardnm2	= "";
		this.cardnm3	= "";
		this.cardnm4	= "";
		this.ven_code5 = "";
		this.ven_code6 = "";
		this.ven_code7 = "";
    	this.firm_nm5 = "";
    	this.firm_nm6 = "";
    	this.firm_nm7 = "";
	    this.acct_cont1 = "";
	    this.acct_cont2 = "";
	    this.acct_cont3 = "";
	    this.acct_cont4 = "";
		this.nm_item	= "";

	}

	// get Method
	public void setData_no(int i){									data_no  = i;			} 
	public void setVen_code(String val){	if(val==null) val="";	this.ven_code = val;	}
	public void setFirm_nm(String val){		if(val==null) val="";	this.firm_nm = val;		}
	public void setAcct_dt(String val){		if(val==null) val="";	this.acct_dt = val;		}
	public void setAcct_code(String val){	if(val==null) val="";	this.acct_code = val;	}
	public void setBank_code(String val){	if(val==null) val="";	this.bank_code = val;	}
	public void setBank_name(String val){	if(val==null) val="";	this.bank_name = val;	}
	public void setDeposit_no(String val){	if(val==null) val="";	this.deposit_no = val;	}
	public void setDeposit_name(String val){if(val==null) val="";	this.deposit_name = val;}
	public void setAcct_cont(String val){	if(val==null) val="";	this.acct_cont = val;	}
	public void setAmt(int i){										amt  = i;				} 
	public void setAmt2(int i){										amt2  = i;				} 
	public void setAmt3(int i){										amt3  = i;				} 
	public void setAmt4(int i){										amt4  = i;				} 
	public void setAmt5(int i){										amt5  = i;				} 
	public void setAmt6(int i){										amt6  = i;				} 
	public void setAmt7(int i){										amt7  = i;				} 
	public void setAmt8(int i){										amt8  = i;				} 
	public void setNode_code(String val){	if(val==null) val="";	this.node_code = val;	}
	public void setInsert_id(String val){	if(val==null) val="";	this.insert_id = val;	}
	public void setWrite_dt(String val){	if(val==null) val="";	this.write_dt = val;	}
	public void setVen_type(String val){	if(val==null) val="";	this.ven_type = val;	}
	public void setS_idno(String val){		if(val==null) val="";	this.s_idno = val;		}
	public void setItem_code(String val){	if(val==null) val="";	this.item_code = val;	}
	public void setItem_name(String val){	if(val==null) val="";	this.item_name = val;	}
	public void setSa_code	(String val){	if(val==null) val="";	this.sa_code = val;		}
	public void setKname	(String val){	if(val==null) val="";	this.kname = val;		}
	public void setDept_code(String val){	if(val==null) val="";	this.dept_code = val;	}
	public void setDept_name(String val){	if(val==null) val="";	this.dept_name = val;	}
	public void setCardno	(String val){	if(val==null) val="";	this.cardno = val;		}
	public void setBuy_id	(String val){	if(val==null) val="";	this.buy_id = val;		}
	public void setCard_name(String val){	if(val==null) val="";	this.card_name = val;	}
	public void setCom_code(String val){	if(val==null) val="";	this.com_code = val;	}
	public void setCom_name(String val){	if(val==null) val="";	this.com_name = val;	}
	public void setTax_yn	(String val){	if(val==null) val="";	this.tax_yn	= val;		}
	public void setAcct_cd1	(String val){	if(val==null) val="";	this.acct_cd1 = val;	}
	public void setAcct_cd2	(String val){	if(val==null) val="";	this.acct_cd2 = val;	}
	public void setAcct_cd3	(String val){	if(val==null) val="";	this.acct_cd3 = val;	}
	public void setAcct_cd4	(String val){	if(val==null) val="";	this.acct_cd4 = val;	}
	public void setData_line(int i){								data_line = i;			}
	public void setCar_st	(String val){	if(val==null) val="";	this.car_st = val;		}
	public void setVen_code2(String val){	if(val==null) val="";	this.ven_code2 = val;	}
	public void setVen_code3(String val){	if(val==null) val="";	this.ven_code3 = val;	}
	public void setVen_code4(String val){	if(val==null) val="";	this.ven_code4 = val;	}
	public void setFirm_nm2	(String val){	if(val==null) val="";	this.firm_nm2 = val;	}
	public void setFirm_nm3	(String val){	if(val==null) val="";	this.firm_nm3 = val;	}
	public void setFirm_nm4	(String val){	if(val==null) val="";	this.firm_nm4 = val;	}
	public void setCardno1	(String val){	if(val==null) val="";	this.cardno1	= val;	}
	public void setCardno2	(String val){	if(val==null) val="";	this.cardno2	= val;	}
	public void setCardno3	(String val){	if(val==null) val="";	this.cardno3	= val;	}
	public void setCardno4	(String val){	if(val==null) val="";	this.cardno4	= val;	}
	public void setCardnm1	(String val){	if(val==null) val="";	this.cardnm1	= val;	}
	public void setCardnm2	(String val){	if(val==null) val="";	this.cardnm2	= val;	}
	public void setCardnm3	(String val){	if(val==null) val="";	this.cardnm3	= val;	}
	public void setCardnm4	(String val){	if(val==null) val="";	this.cardnm4	= val;	}
	public void setVen_code5(String val){	if(val==null) val="";	this.ven_code5 = val;	}
	public void setVen_code6(String val){	if(val==null) val="";	this.ven_code6 = val;	}
	public void setVen_code7(String val){	if(val==null) val="";	this.ven_code7 = val;	}
	public void setFirm_nm5	(String val){	if(val==null) val="";	this.firm_nm5 = val;	}
	public void setFirm_nm6	(String val){	if(val==null) val="";	this.firm_nm6 = val;	}
	public void setFirm_nm7	(String val){	if(val==null) val="";	this.firm_nm7 = val;	}
	public void setAcct_cont1(String val){	if(val==null) val="";	this.acct_cont1 = val;	}
	public void setAcct_cont2(String val){	if(val==null) val="";	this.acct_cont2 = val;	}
	public void setAcct_cont3(String val){	if(val==null) val="";	this.acct_cont3 = val;	}
	public void setAcct_cont4(String val){	if(val==null) val="";	this.acct_cont4 = val;	}
	public void setNm_item	(String val){	if(val==null) val="";	this.nm_item	= val;	}
	

	//Get Method
	public int    getData_no(){		return data_no;		} 
	public String getVen_code(){	return ven_code;	}
	public String getFirm_nm(){		return firm_nm;		}
	public String getAcct_dt(){		return acct_dt;		}
	public String getAcct_code(){	return acct_code;	}
	public String getBank_code(){	return bank_code;	}
	public String getBank_name(){	return bank_name;	}
	public String getDeposit_no(){	return deposit_no;	}
	public String getDeposit_name(){return deposit_name;}
	public String getAcct_cont(){	return acct_cont;	}
	public int    getAmt(){			return amt;			} 
	public int    getAmt2(){		return amt2;		} 
	public int    getAmt3(){		return amt3;		} 
	public int    getAmt4(){		return amt4;		} 
	public int    getAmt5(){		return amt5;		} 
	public int    getAmt6(){		return amt6;		} 
	public int    getAmt7(){		return amt7;		} 
	public int    getAmt8(){		return amt8;		} 
	public String getNode_code(){	return node_code;	}
	public String getInsert_id(){	return insert_id;	}
	public String getWrite_dt(){	return write_dt;	}
	public String getVen_type(){	return ven_type;	}
	public String getS_idno(){		return s_idno;		}
	public String getItem_code(){	return item_code;	}
	public String getItem_name(){	return item_name;	}
	public String getSa_code  (){	return sa_code;		}
	public String getKname	  (){	return kname;		}
	public String getDept_code(){	return dept_code;	}
	public String getDept_name(){	return dept_name;	}
	public String getCardno	  (){	return cardno;		}
	public String getBuy_id	  (){	return buy_id;		}
	public String getCard_name(){	return card_name;	}
	public String getCom_code(){	return com_code;	}
	public String getCom_name(){	return com_name;	}
	public String getTax_yn	(){		return tax_yn;		}
	public String getAcct_cd1(){	return acct_cd1;	}
	public String getAcct_cd2(){	return acct_cd2;	}
	public String getAcct_cd3(){	return acct_cd3;	}
	public String getAcct_cd4(){	return acct_cd4;	}
	public int    getData_line(){	return data_line;	}
	public String getCar_st(){		return car_st;		}
	public String getVen_code2(){	return ven_code2;	}
	public String getFirm_nm2(){	return firm_nm2;	}
	public String getVen_code3(){	return ven_code3;	}
	public String getFirm_nm3(){	return firm_nm3;	}
	public String getVen_code4(){	return ven_code4;	}
	public String getFirm_nm4(){	return firm_nm4;	}
	public String getCardno1()	{	return cardno1;		}
	public String getCardno2()	{	return cardno2;		}
	public String getCardno3()	{	return cardno3;		}
	public String getCardno4()	{	return cardno4;		}
	public String getCardnm1()	{	return cardnm1;		}
	public String getCardnm2()	{	return cardnm2;		}
	public String getCardnm3()	{	return cardnm3;		}
	public String getCardnm4()	{	return cardnm4;		}
	public String getVen_code5(){	return ven_code5;	}
	public String getVen_code6(){	return ven_code6;	}
	public String getVen_code7(){	return ven_code7;	}
	public String getFirm_nm5(){	return firm_nm5;	}
	public String getFirm_nm6(){	return firm_nm6;	}
	public String getFirm_nm7(){	return firm_nm7;	}
	public String getAcct_cont1(){	return acct_cont1;	}
	public String getAcct_cont2(){	return acct_cont2;	}
	public String getAcct_cont3(){	return acct_cont3;	}
	public String getAcct_cont4(){	return acct_cont4;	}
	public String getNm_item	(){	return nm_item;		}


}