/**
 * 차종
 */
package acar.car_mst;

import java.util.*;

public class CarOptBean {
    //Table : CAR_SEL
	private String car_comp_id;   //자동차사코드
    private String car_cd;			//차종분류코드
    private String car_id;			//차종분류코드
    private String car_u_seq;		//차명업데이트관리번호
    private String car_s_seq;		//선택사양관리번호
	private String use_yn;			//사용여부
	private String car_s;			//선택사양 옵션명
	private int car_s_p;			//선택사양 가격
	private String car_s_dt;		//선택사양 기준일
	private String opt_b;			//선택사양 세부사양
	private String jg_opt_st;		//사양 조정잔가 구분자
	private String jg_tuix_st;		//tuix/tuon 트림여부
	private String lkas_yn;			//차선이탈 제어형(LKAS) 
	private String ldws_yn;			//차선이탈 경고형(LDWS)
	private String aeb_yn;			//긴급제동 제어형(AEB)
	private String fcw_yn;			//긴급제동 경고형(FCW)
	private String garnish_yn;		//가니쉬
	private String hook_yn;		//견인고리
	private String car_rank;		//순서정렬값
	private String jg_opt_yn;		//잔가미반영 여부
       
    // CONSTRCTOR            
    public CarOptBean() {
    	this.car_comp_id	= ""; 
    	this.car_cd		= "";					
    	this.car_id		= "";					
	    this.car_u_seq	= "";				
	    this.car_s_seq	= "";
	    this.use_yn		= "";
	    this.car_s		= "";
		this.car_s_p	= 0;
	    this.car_s_dt	= "";
		this.opt_b		= "";
		this.jg_opt_st	= "";
		this.jg_tuix_st	= "";
		this.lkas_yn 		= "";
		this.ldws_yn		= "";
		this.aeb_yn 		= "";
		this.fcw_yn 		= "";
		this.garnish_yn	= "";
		this.hook_yn		= "";
		this.car_rank 		= "";
		this.jg_opt_yn 	= "";
	}

	// get Method
	public void setCar_comp_id	(String val){		if(val==null) val="";	this.car_comp_id	= val;		}
	public void setCar_cd		(String val){		if(val==null) val="";	this.car_cd			= val;		}
	public void setCar_id		(String val){		if(val==null) val="";	this.car_id			= val;		}
	public void setCar_u_seq	(String val){		if(val==null) val="";	this.car_u_seq		= val;		}
	public void setCar_s_seq	(String val){		if(val==null) val="";	this.car_s_seq		= val;		}
	public void setUse_yn		(String val){		if(val==null) val="";	this.use_yn			= val;		}
	public void setCar_s		(String val){		if(val==null) val="";	this.car_s			= val;		}
	public void setCar_s_p		(int i){									this.car_s_p		= i;		}
	public void setCar_s_dt		(String val){		if(val==null) val="";	this.car_s_dt		= val;		}
	public void setOpt_b		(String val){		if(val==null) val="";	this.opt_b			= val;		}
	public void setJg_opt_st	(String val){		if(val==null) val="";	this.jg_opt_st		= val;		}
	public void setJg_tuix_st	(String val){		if(val==null) val="";	this.jg_tuix_st		= val;		}
	public void setLkas_yn		(String val){		if(val==null) val="";	this.lkas_yn			= val;		}	
	public void setLdws_yn		(String val){		if(val==null) val="";	this.ldws_yn			= val;		}	
	public void setAeb_yn			(String val){		if(val==null) val="";	this.aeb_yn			= val;		}	
	public void setFcw_yn			(String val){		if(val==null) val="";	this.fcw_yn			= val;		}	
	public void setGarnish_yn		(String val){		if(val==null) val="";	this.garnish_yn	= val;		}	
	public void setHook_yn		(String val){		if(val==null) val="";	this.hook_yn	= val;		}	
	public void setCar_rank		(String val){		if(val==null) val="";	this.car_rank		= val;		}	
	public void setJg_opt_yn	(String val){		if(val==null) val="";	this.jg_opt_yn		= val;		}	
		
	//Get Method
	public String getCar_comp_id(){		return car_comp_id;		}
	public String getCar_cd		(){		return car_cd;			}
	public String getCar_id		(){		return car_id;			}
	public String getCar_u_seq	(){		return car_u_seq;		}
	public String getCar_s_seq	(){		return car_s_seq;		}
	public String getUse_yn		(){		return use_yn;			}
	public String getCar_s		(){		return car_s;			}
	public int getCar_s_p		(){		return car_s_p;			}
	public String getCar_s_dt	(){		return car_s_dt;		}
	public String getOpt_b		(){		return opt_b;			}
	public String getJg_opt_st	(){		return jg_opt_st;		}
	public String getJg_tuix_st	(){		return jg_tuix_st;		}
	public String getLkas_yn		(){		return lkas_yn;		}	
	public String getLdws_yn	(){		return ldws_yn;		}	
	public String getAeb_yn		(){		return aeb_yn;			}	
	public String getFcw_yn		(){		return fcw_yn;			}	
	public String getGarnish_yn(){		return garnish_yn;	}	
	public String getHook_yn(){			return hook_yn;	}	
	public String getCar_rank	(){		return car_rank;		}	
	public String getJg_opt_yn	(){		return jg_opt_yn;		}	

}
