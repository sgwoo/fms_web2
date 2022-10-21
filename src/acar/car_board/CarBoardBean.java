package acar.car_board;

import java.util.*;

public class CarBoardBean {
    //Table : Arrear
    private String rent_mng_id;	
    private String rent_l_cd;	
    private int seq;			//순번			
    private String reg_dt;			//날짜
	private String reg_id;		//사용자ID
	private String car_mng_id;	//
    private String gubun;		//종류	
    private String content;		//내용


	public CarBoardBean() {  
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.seq = 0;
		this.reg_dt = "";
		this.reg_id = "";	
		this.car_mng_id= "";
		this.gubun = "";
		this.content = "";
		
	}

	// set Method
	public void setRent_mng_id(String val){			if(val==null) val=""; this.rent_mng_id = val;		}
	public void setRent_l_cd(String val){		if(val==null) val=""; this.rent_l_cd = val;	}
	public void setSeq		(int val)	{							this.seq		= val;	}
	public void setReg_dt(String val){		if(val==null) val=""; this.reg_dt = val;	}
    public void setReg_id(String val){		if(val==null) val=""; this.reg_id = val;	}
    public void setCar_mng_id(String val){	if(val==null) val=""; this.car_mng_id = val;	}
    public void setGubun(String val){			if(val==null) val=""; this.gubun = val;		}
    public void setContent(String val){		if(val==null) val=""; this.content = val;	}
 
	
	//Get Method
	public String getRent_mng_id(){			return rent_mng_id;			}
    public String getRent_l_cd(){		return rent_l_cd;		}
    public  int getSeq(){		return seq;		}
	public String getReg_dt(){		return reg_dt;		}
	public String getReg_id(){		return reg_id;		}
    public String getCar_mng_id(){	return car_mng_id;	}
	public String getGubun(){			return gubun;			}
    public String getContent(){		return content;		}
  
	
}