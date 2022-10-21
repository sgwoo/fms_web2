package acar.arrear;

import java.util.*;

public class ArrearBean {
    //Table : Arrear
    private String rent_mng_id;	
    private String rent_l_cd;	
    private String seq;			//순번			
    private String reg_dt;			//날짜
	private String user_id;		//사용자ID
	private String user_nm;		//사용자명
	private String credit_method;	//채권추심의뢰 방식
    private String credit_desc;		//내용	
    private String arr_type;		//종류


	public ArrearBean() {  
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.seq = "";
		this.reg_dt = "";
		this.user_id = "";
		this.user_nm = "";
		this.credit_method = "";
		this.credit_desc = "";
		this.arr_type = "";
		
	}

	// set Method
	public void setRent_mng_id(String val){			if(val==null) val=""; this.rent_mng_id = val;		}
	public void setRent_l_cd(String val){		if(val==null) val=""; this.rent_l_cd = val;	}
	public void setSeq(String val){		if(val==null) val=""; this.seq = val;	}
	public void setReg_dt(String val){		if(val==null) val=""; this.reg_dt = val;	}
    public void setUser_id(String val){		if(val==null) val=""; this.user_id = val;	}
    public void setUser_nm(String val){	if(val==null) val=""; this.user_nm = val;	}
    public void setCredit_method(String val){	if(val==null) val=""; this.credit_method = val;	}
    public void setCredit_desc(String val){			if(val==null) val=""; this.credit_desc = val;		}
    public void setArr_type(String val){		if(val==null) val=""; this.arr_type = val;	}
 
	
	//Get Method
	public String getRent_mng_id(){			return rent_mng_id;			}
    public String getRent_l_cd(){		return rent_l_cd;		}
    public String getSeq(){		return seq;		}
	public String getReg_dt(){		return reg_dt;		}
	public String getUser_id(){		return user_id;		}
    public String getUser_nm(){	return user_nm;	}
    public String getCredit_method(){	return credit_method;	}
	public String getCredit_desc(){			return credit_desc;			}
    public String getArr_type(){		return arr_type;		}
  
	
}