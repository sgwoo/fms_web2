package acar.admin;

import java.util.*;

public class AucBean {
    //Table : STAT_DLY
    private Date 	actn_dt    = null;				
    private String 	actn_off_nm  = "";	
	private int 	actn_cnt  = 0;
	private int 	actn_num  = 0;
	private String 	car_name = "";
	private String 	car_y_form= "";
	private String 	auto_yn= "";
	private String 	fuel_kd= "";
	private int 	dpm  = 0;
	private int 	agree_dist  = 0;
	private String 	col = "";
	private String 	car_use = "";
	private String 	car_own = "";
	private String 	rating1 = "";
	private String 	rating2 = "";
	private int 	st_pr  = 0;
	private int 	nak_pr  = 0;
	private String 	car_name2 = "";
	private String 	jg_code = "";
	private Date 	init_reg_dt = null;
	private String 	opt = "";
	private String 	etc = "";
	private int 	actn_car_amt  = 0 ;
	private int 	taking_p;
	private String 	car_no = "";
	private int 	hp_pr = 0;
	private int 	file_seq = 0;
	private String 	d_gubun = "";
	
	public AucBean() {  
		this.actn_dt = null;		
		this.actn_off_nm = "";	
		this.actn_cnt = 0;       
		this.actn_num = 0;       
		this.car_name = "";       
		this.car_y_form = "";     
		this.auto_yn = "";        
		this.fuel_kd = "";        
		this.dpm = 0;            
		this.agree_dist = 0;     
		this.col = "";            
		this.car_use = "";        
		this.car_own = "";        
		this.rating1 = "";        
		this.rating2 = "";        
		this.st_pr= 0;          
		this.nak_pr= 0;         
		this.car_name2 = "";      
		this.jg_code = "";        
		this.init_reg_dt =null;    
		this.opt = "";            
		this.etc = "";            
		this.actn_car_amt= 0;   
		this.taking_p= 0;       
		this.car_no = "";         
		this.hp_pr = 0;          
		this.file_seq = 0;          
		this.d_gubun = "";         
	}

	

	// set Method
	public void setActn_dt		(Date date)		{   if(date!=null) actn_dt = date;		}
	public void setActn_off_nm 	(String val)	{   actn_off_nm = val;	}
	public void setActn_cnt     (int i)			{   actn_cnt = i;     	}
	public void setActn_num     (int i)			{   actn_num = i;     	}
	public void setCar_name     (String val)	{   car_name = val;    	}
	public void setCar_y_form   (String val)	{   car_y_form = val;  	}
    public void setAuto_yn      (String val)	{   auto_yn = val;     	}
	public void setFuel_kd      (String val)	{   fuel_kd = val;     	}
	public void setDpm          (int i)			{   dpm = i;          	}
	public void setAgree_dist   (int i)			{   agree_dist = i;   	}
    public void setCol          (String val)	{   col = val;         	}
	public void setCar_use      (String val)	{   car_use = val;     	}
	public void setCar_own      (String val)	{   car_own = val;     	}
	public void setRating1      (String val)	{   rating1 = val;     	}
    public void setRating2      (String val)	{   rating2 = val;     	}
	public void setSt_pr        (int i)			{   st_pr= i;         	}
	public void setNak_pr       (int i)			{   nak_pr= i;        	}
	public void setCar_name2    (String val)	{   car_name2 = val;   	}
    public void setJg_code      (String val)	{   jg_code = val;     	}
	public void setInit_reg_dt  (Date date)		{   if(date!=null) init_reg_dt =date;	}
	public void setOpt          (String val)	{   opt = val;         	}
	public void setEtc          (String val)	{   etc = val;         	}
	public void setActn_car_amt (int i)			{   actn_car_amt= i;  	}
	public void setTaking_p     (int i)			{   taking_p= i;      	}
    public void setCar_no       (String val)	{   car_no = val;      	}
	public void setHp_pr        (int i)			{   hp_pr = i;        	}
	public void setFile_seq     (int i)			{   file_seq = i;       }
	public void setD_gubun      (String val)	{   d_gubun = val;      }

	
	//Get Method
	public Date 	 getActn_dt	  	(){	return actn_dt;		}
    public String 	 getActn_off_nm (){	return actn_off_nm ;}
    public int 	 	 getActn_cnt    (){	return actn_cnt;    }
	public int 	 	 getActn_num    (){	return actn_num;    }
	public String 	 getCar_name    (){	return car_name;    }
	public String 	 getCar_y_form  (){	return car_y_form;  }
	public String 	 getAuto_yn     (){	return auto_yn;     }
	public String 	 getFuel_kd     (){	return fuel_kd;     }
	public int 	 	 getDpm         (){	return dpm;         }
	public int 	 	 getAgree_dist  (){	return agree_dist;  }
	public String 	 getCol         (){	return col;         }
	public String 	 getCar_use     (){	return car_use;     }
	public String 	 getCar_own     (){	return car_own;     }
	public String 	 getRating1     (){	return rating1;     }
	public String 	 getRating2     (){	return rating2;     }
	public int 	 	 getSt_pr       (){	return st_pr;       }
	public int 	 	 getNak_pr      (){	return nak_pr;      }
	public String 	 getCar_name2   (){	return car_name2;   }
	public String 	 getJg_code     (){	return jg_code;     }
    public Date 	 getInit_reg_dt (){	return init_reg_dt; }
    public String 	 getOpt         (){	return opt;         }
    public String 	 getEtc         (){	return etc;         }
    public int 	 	 getActn_car_amt(){	return actn_car_amt;}	
	public int 	 	 getTaking_p    (){	return taking_p;    }
	public String 	 getCar_no      (){	return car_no;      }
    public int 	 	 getHp_pr       (){	return hp_pr;       }
    public int 	 	 getFile_seq    (){	return file_seq;    }
    public String 	 getD_gubun 	(){	return d_gubun;    	}



	@Override
	public String toString() {
		return "AucBean [actn_dt=" + actn_dt + ", actn_off_nm=" + actn_off_nm + ", actn_cnt=" + actn_cnt + ", actn_num="
				+ actn_num + ", car_name=" + car_name + ", car_y_form=" + car_y_form + ", auto_yn=" + auto_yn
				+ ", fuel_kd=" + fuel_kd + ", dpm=" + dpm + ", agree_dist=" + agree_dist + ", col=" + col + ", car_use="
				+ car_use + ", car_own=" + car_own + ", rating1=" + rating1 + ", rating2=" + rating2 + ", st_pr="
				+ st_pr + ", nak_pr=" + nak_pr + ", car_name2=" + car_name2 + ", jg_code=" + jg_code + ", init_reg_dt="
				+ init_reg_dt + ", opt=" + opt + ", etc=" + etc + ", actn_car_amt=" + actn_car_amt + ", taking_p="
				+ taking_p + ", car_no=" + car_no + ", hp_pr=" + hp_pr + ", file_seq=" + file_seq + ", d_gubun="
				+ d_gubun + "]";
	}



   
}