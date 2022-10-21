/**
 * 정비내역
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 3. 12.
 * @ last modify date : 2004. 3. 30. -상호(계약자)추가.
 */
package acar.cus0601;

import java.util.*;

public class ServListBean {
    //Table : SERVICE 정비
	private String car_mng_id;		//차량관리번호
	private String car_no;			//차량번호
	private String serv_id;			//정비id
	private String accid_id;		//사고기록id
	private String serv_dt;			//정비일자
	private String serv_st;			//정비구분
	private String checker;			//점검자
	private int tot_amt;			//정비금액
	private String set_dt;			//결제일
	private String rep_item;		//점검품목
	private String rep_cont;		//점검내용
	private String firm_nm;			//상호명
	private String ipgodt;
	private String chulgodt;

	// CONSTRCTOR            
    public ServListBean() {  
		this.car_mng_id = "";
		this.car_no = "";
		this.serv_id = ""; 
		this.accid_id = ""; 
		this.serv_dt = "";
		this.serv_st = ""; 
		this.checker = ""; 
		this.tot_amt = 0; 
		this.set_dt = ""; 
		this.rep_item = ""; 
		this.rep_cont = ""; 
		this.firm_nm = "";
		this.ipgodt = ""; 
		this.chulgodt = "";
	}

	//set Method
	public void setCar_mng_id(String val){	if(val==null) val="";		this.car_mng_id = val;	}
	public void setCar_no(String val){		if(val==null) val="";		this.car_no = val;		}
	public void setServ_id(String val){		if(val==null) val="";		this.serv_id = val;		}
	public void setAccid_id(String val){	if(val==null) val="";		this.accid_id = val;	}
	public void setServ_dt(String val){		if(val==null) val="";		this.serv_dt = val;		}
	public void setServ_st(String val){		if(val==null) val="";		this.serv_st = val;		}
	public void setChecker(String val){		if(val==null) val="";		this.checker = val;		}
	public void setTot_amt(int val){									this.tot_amt = val;		}
	public void setSet_dt(String val){		if(val==null) val="";		this.set_dt = val;		}
	public void setRep_item(String val){	if(val==null) val="";		this.rep_item = val;	}
	public void setRep_cont(String val){	if(val==null) val="";		this.rep_cont = val;	}
	public void setFirm_nm(String val){		if(val==null) val="";		this.firm_nm = val;		}
	public void setIpgodt  (String val){	if(val==null) val="";		this.ipgodt  = val;		}
	public void setChulgodt(String val){	if(val==null) val="";		this.chulgodt = val;	}

	//Get Method
	public String getCar_mng_id(){	return car_mng_id;	}
	public String getCar_no(){		return car_no;		}
	public String getServ_id(){		return serv_id;		}
	public String getAccid_id(){	return accid_id;	}
	public String getServ_dt(){		return serv_dt;		}
	public String getServ_st(){		return serv_st;		}
	public String getChecker(){		return checker;		}
	public int getTot_amt(){		return tot_amt;		}
	public String getSet_dt(){		return set_dt;		}
	public String getRep_item(){	return rep_item;	}
	public String getRep_cont(){	return rep_cont;	}
	public String getFirm_nm(){		return firm_nm;		}
	public String getIpgodt  (){	return ipgodt;		}
	public String getChulgodt(){	return chulgodt;	}
}