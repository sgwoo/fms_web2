/**
 * 계출관리 - 자체출고현황마감
 * @ author : Gill Sun Ryu
 * @ e-mail : koobuk@gmail.com
 * @ create date : 2012. 9. 20
 * @ last modify date : 
 */
package acar.out_car;

import java.util.*;

public class  Out_carBean{
    //Table : OUT_CAR_MAGAM
	private String save_dt;		//마감일자
	private String save_dt2;		//마감일자
	private String rent_l_cd;	//계약번호
    private String rpt_no;		
	private String car_num;		//차대번호
	private String rent_dt;		//계약일      
	private String dlv_dt;		//차량출시일
	private String init_reg_dt;	//차량등록일
	private String dlv_off;		//출고지점
	private String bc_s_f;		//영업효율
	private String bc_s_f2;		//영업효율2 영업효율*1.1
	private String reg_dt;
	
    // CONSTRCTOR            
    public Out_carBean() {  
		this.save_dt ="";
		this.save_dt2 ="";
		this.rent_l_cd ="";
		this.rpt_no ="";	
		this.car_num ="";
		this.rent_dt ="";
		this.dlv_dt ="";
		this.init_reg_dt ="";
		this.dlv_off ="";
		this.bc_s_f ="";
		this.bc_s_f2 ="";
		this.reg_dt = "";
	}

	// set Method
	public void setSave_dt(String val){		if(val==null) val="";		this.save_dt	= val;	}
	public void setSave_dt2(String val){	if(val==null) val="";		this.save_dt2	= val;	}
	public void setRent_l_cd(String val){	if(val==null) val="";		this.rent_l_cd	= val;	}
	public void setRpt_no(String val){		if(val==null) val="";		this.rpt_no = val;		}
	public void setCar_num(String val){		if(val==null) val="";		this.car_num = val;		}
	public void setRent_dt(String val){		if(val==null) val="";		this.rent_dt = val;		}
	public void setDlv_dt(String val){		if(val==null) val="";		this.dlv_dt = val;		}
	public void setInit_reg_dt(String val){	if(val==null) val="";		this.init_reg_dt = val;	}
	public void setDlv_off(String val){		if(val==null) val="";		this.dlv_off = val;		}
	public void setBc_s_f(String val){		if(val==null) val="";		this.bc_s_f = val;		}
	public void setBc_s_f2(String val){		if(val==null) val="";		this.bc_s_f2 = val;		}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;		}

	//Get Method
	public String	getSave_dt(){		return save_dt;		}
	public String	getSave_dt2(){		return save_dt2;	}
	public String 	getRent_l_cd(){		return rent_l_cd;	}
	public String 	getRpt_no(){		return rpt_no;		}
	public String 	getCar_num(){		return car_num;		}
	public String 	getRetn_dt(){		return rent_dt;		}
	public String	getDlv_dt(){		return dlv_dt;		}
	public String  	getInit_reg_dt(){	return init_reg_dt;	}
	public String	getDlv_off(){		return dlv_off;		}
	public String	getBc_s_f(){		return bc_s_f;		}
	public String	getBc_s_f2(){		return bc_s_f2;		}
	public String	getReg_dt(){		return reg_dt;		}

}