/**
 * 정기점검정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarChaBean {
    //Table : CAR_CHA
    private String car_mng_id;			//자동차관리번호
	private int    seq_no;				//SEQ_NO
	private String cha_item;			//구조장치변경사항_내용
	private String cha_st_dt;			//구변검사일자1
	private String cha_end_dt;			//구변검사일자2
	private String cha_nm;				//구변검사책임자
	private String cha_st;				//구변구분
	private int    cha_amt;
	private int    cha_v_amt;
	private String off_nm;				//정비업체(작업)
	private String serv_id;				//
	private int    b_dist;                                     //최초주행거리
	private int    a_dist;                                   
        
    // CONSTRCTOR            
    public CarChaBean() {  
	    this.car_mng_id = "";			//자동차관리번호
		this.seq_no = 0;					//SEQ_NO
		this.cha_item = "";			//구조장치변경사항_내용
		this.cha_st_dt = "";			//구변검사일자1
		this.cha_end_dt = "";			//구변검사일자2
		this.cha_nm = "";				//구변검사책임자
		this.cha_st = "";
		this.cha_amt = 0;
		this.cha_v_amt = 0;
		this.off_nm = "";				//
		this.serv_id = "";
		this.b_dist = 0;
		this.a_dist = 0;
	}

	// get Method
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id = val;	}
	public void setSeq_no		(int    val){									this.seq_no		= val;	}	
	public void setCha_item		(String val){		if(val==null) val="";		this.cha_item	= val;	}	
	public void setCha_st_dt	(String val){		if(val==null) val="";		this.cha_st_dt	= val;	}
	public void setCha_end_dt	(String val){		if(val==null) val="";		this.cha_end_dt = val;	}
	public void setCha_nm		(String val){		if(val==null) val="";		this.cha_nm		= val;	}
	public void setCha_st		(String val){		if(val==null) val="";		this.cha_st		= val;	}
	public void setCha_amt		(int    val){									this.cha_amt	= val;	}
	public void setCha_v_amt	(int    val){									this.cha_v_amt	= val;	}
	public void setOff_nm		(String val){		if(val==null) val="";		this.off_nm		= val;	}
	public void setServ_id		(String val){		if(val==null) val="";		this.serv_id		= val;	}
	public void setB_dist		(int    val){									this.b_dist	= val;	}
	public void setA_dist		(int    val){									this.a_dist	= val;	}
	
	//Get Method
	public String getCar_mng_id	(){		return car_mng_id;	}
	public int    getSeq_no		(){		return seq_no;		}
	public String getCha_item	(){		return cha_item;	}
	public String getCha_st_dt	(){		return cha_st_dt;	}
	public String getCha_end_dt	(){		return cha_end_dt;	}
	public String getCha_nm		(){		return cha_nm;		}
	public String getCha_st		(){		return cha_st;		}
	public int    getCha_amt	(){		return cha_amt;		}
	public int    getCha_v_amt	(){		return cha_v_amt;	}
	public String getOff_nm		(){		return off_nm;		}
	public String getServ_id		(){		return serv_id;		}
	public int    getB_dist	(){		return b_dist;		}
	public int    getA_dist	(){		return a_dist;	}
	
}