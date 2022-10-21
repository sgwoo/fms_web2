package acar.tire;

import java.util.*;

public class TireBean {
	private String seq;
	private String reg_id;
	private String reg_dt;
	private String car_mng_id;
	private String dtire_note;
	private String dtire_carno;
	private String req_nm;
	private String dtire_dt;
	private int dtire_amt;
	private String dtire_gb;
	private String dtire_yn;
	private String dtire_item1;
	private int		dtire_item_amt1;
	private String dtire_item2;
	private int		dtire_item_amt2;
	private String dtire_item3;
	private int		dtire_item_amt3;
	private String dtire_item4;
	private int		dtire_item_amt4;
	private String dtire_item5;
	private int		dtire_item_amt5;
	private String dtire_item6;
	private int		dtire_item_amt6;
	private String dtire_carnm;
	private int		dtire_km;
	private String rent_l_cd;

	private String serv_id;
	private int dtire_s_amt;
	private int dtire_v_amt;
	private String dc;
	private int		dtire_item_v_amt1;//부가세
	private int		dtire_item_s_amt1;//공급가
	private int		dtire_item_v_amt2;
	private int		dtire_item_s_amt2;
	private int		dtire_item_v_amt3;
	private int		dtire_item_s_amt3;
	private int		dtire_item_v_amt4;
	private int		dtire_item_s_amt4;
	private int		dtire_item_v_amt5;
	private int		dtire_item_s_amt5;
	private int		dtire_item_v_amt6;
	private int		dtire_item_s_amt6;
	private int		dtire_item_t_amt1;//총계
	private int		dtire_item_t_amt2;
	private int		dtire_item_t_amt3;
	private int		dtire_item_t_amt4;
	private int		dtire_item_t_amt5;
	private int		dtire_item_t_amt6;
	private int		dtire_item_su1;
	private int		dtire_item_su2;
	private int		dtire_item_su3;
	private int		dtire_item_su4;
	private int		dtire_item_su5;
	private int		dtire_item_su6;


    // CONSTRCTOR            
    public TireBean () {  
	    this.seq			= "";
		this.reg_id			= "";
		this.reg_dt			= "";
		this.car_mng_id		= "";
		this.dtire_note		= "";
		this.dtire_carno	= "";
		this.req_nm			= "";
	    this.dtire_dt		= "";
		this.dtire_amt		= 0;
		this.dtire_gb		= "";
		this.dtire_yn		= "";
		this.dtire_item1	= "";
		this.dtire_item_amt1 = 0;
		this.dtire_item2	= "";
		this.dtire_item_amt2 = 0;
		this.dtire_item3	= "";
		this.dtire_item_amt3 = 0;
		this.dtire_item4	= "";
		this.dtire_item_amt4 = 0;
		this.dtire_item5	= "";
		this.dtire_item_amt5 = 0;
		this.dtire_item6	= "";
		this.dtire_item_amt6 = 0;
		this.dtire_carnm	="";
		this.dtire_km = 0;
		this.rent_l_cd = "";

		this.serv_id = "";

		this.dtire_s_amt		= 0;
		this.dtire_v_amt		= 0;
		this.dc					= "";

		this.dtire_item_v_amt1 = 0;
		this.dtire_item_s_amt1 = 0;
		this.dtire_item_v_amt2 = 0;
		this.dtire_item_s_amt2 = 0;
		this.dtire_item_v_amt3 = 0;
		this.dtire_item_s_amt3 = 0;
		this.dtire_item_v_amt4 = 0;
		this.dtire_item_s_amt4 = 0;
		this.dtire_item_v_amt5 = 0;
		this.dtire_item_s_amt5 = 0;
		this.dtire_item_v_amt6 = 0;
		this.dtire_item_s_amt6 = 0;
		this.dtire_item_t_amt1 = 0;
		this.dtire_item_t_amt2 = 0;
		this.dtire_item_t_amt3 = 0;
		this.dtire_item_t_amt4 = 0;
		this.dtire_item_t_amt5 = 0;
		this.dtire_item_t_amt6 = 0;

		this.dtire_item_su1 = 0;
		this.dtire_item_su2 = 0;
		this.dtire_item_su3 = 0;
		this.dtire_item_su4 = 0;
		this.dtire_item_su5 = 0;
		this.dtire_item_su6 = 0;





	}


	// get Method
	public void setSeq				(String val){		if(val==null) val="";		this.seq			= val;	}
	public void setReg_id			(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setCar_mng_id		(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setDtire_note		(String val){		if(val==null) val="";		this.dtire_note		= val;	}
	public void setDtire_carno		(String val){		if(val==null) val="";		this.dtire_carno	= val;	}
	public void setReq_nm			(String val){		if(val==null) val="";		this.req_nm			= val;	}
	public void setDtire_dt			(String val){		if(val==null) val="";		this.dtire_dt		= val;	}
	public void setDtire_amt		(int	val){									this.dtire_amt		= val;	}
	public void setDtire_gb			(String val){		if(val==null) val="";		this.dtire_gb		= val;	}
	public void setDtire_yn			(String val){		if(val==null) val="";		this.dtire_yn		= val;	}
	public void setDtire_item1		(String val){		if(val==null) val="";		this.dtire_item1	= val;	}
	public void setDtire_item_amt1	(int	val){									this.dtire_item_amt1	= val;	}
	public void setDtire_item2		(String val){		if(val==null) val="";		this.dtire_item2	= val;	}
	public void setDtire_item_amt2	(int	val){									this.dtire_item_amt2	= val;	}
	public void setDtire_item3		(String val){		if(val==null) val="";		this.dtire_item3	= val;	}
	public void setDtire_item_amt3	(int	val){									this.dtire_item_amt3	= val;	}
	public void setDtire_item4		(String val){		if(val==null) val="";		this.dtire_item4	= val;	}
	public void setDtire_item_amt4	(int	val){									this.dtire_item_amt4	= val;	}
	public void setDtire_item5		(String val){		if(val==null) val="";		this.dtire_item5	= val;	}
	public void setDtire_item_amt5	(int	val){									this.dtire_item_amt5	= val;	}
	public void setDtire_item6		(String val){		if(val==null) val="";		this.dtire_item6	= val;	}
	public void setDtire_item_amt6	(int	val){									this.dtire_item_amt6	= val;	}
	public void setDtire_carnm		(String val){		if(val==null) val="";		this.dtire_carnm	= val;	}
	public void setDtire_km			(int	val){									this.dtire_km	= val;	}
	public void setRent_l_cd		(String val){		if(val==null) val="";		this.rent_l_cd	= val;	}
	public void setServ_id		(String val){		if(val==null) val="";		this.serv_id	= val;	}
	public void setDtire_s_amt		(int	val){									this.dtire_s_amt		= val;	}
	public void setDtire_v_amt		(int	val){									this.dtire_v_amt		= val;	}
	public void setDc		(String val){		if(val==null) val="";		this.dc	= val;	}

	public void setDtire_item_v_amt1	(int	val){									this.dtire_item_v_amt1	= val;	}
	public void setDtire_item_s_amt1	(int	val){									this.dtire_item_s_amt1	= val;	}
	public void setDtire_item_v_amt2	(int	val){									this.dtire_item_v_amt2	= val;	}
	public void setDtire_item_s_amt2	(int	val){									this.dtire_item_s_amt2	= val;	}
	public void setDtire_item_v_amt3	(int	val){									this.dtire_item_v_amt3	= val;	}
	public void setDtire_item_s_amt3	(int	val){									this.dtire_item_s_amt3	= val;	}
	public void setDtire_item_v_amt4	(int	val){									this.dtire_item_v_amt4	= val;	}
	public void setDtire_item_s_amt4	(int	val){									this.dtire_item_s_amt4	= val;	}
	public void setDtire_item_v_amt5	(int	val){									this.dtire_item_v_amt5	= val;	}
	public void setDtire_item_s_amt5	(int	val){									this.dtire_item_s_amt5	= val;	}
	public void setDtire_item_v_amt6	(int	val){									this.dtire_item_v_amt6	= val;	}
	public void setDtire_item_s_amt6	(int	val){									this.dtire_item_s_amt6	= val;	}
	public void setDtire_item_t_amt1	(int	val){									this.dtire_item_t_amt1	= val;	}
	public void setDtire_item_t_amt2	(int	val){									this.dtire_item_t_amt2	= val;	}
	public void setDtire_item_t_amt3	(int	val){									this.dtire_item_t_amt3	= val;	}
	public void setDtire_item_t_amt4	(int	val){									this.dtire_item_t_amt4	= val;	}
	public void setDtire_item_t_amt5	(int	val){									this.dtire_item_t_amt5	= val;	}
	public void setDtire_item_t_amt6	(int	val){									this.dtire_item_t_amt6	= val;	}
	public void setDtire_item_su1	(int	val){									this.dtire_item_su1	= val;	}
	public void setDtire_item_su2	(int	val){									this.dtire_item_su2	= val;	}
	public void setDtire_item_su3	(int	val){									this.dtire_item_su3	= val;	}
	public void setDtire_item_su4	(int	val){									this.dtire_item_su4	= val;	}
	public void setDtire_item_su5	(int	val){									this.dtire_item_su5	= val;	}
	public void setDtire_item_su6	(int	val){									this.dtire_item_su6	= val;	}




	//Get Method
	public String getSeq			(){		return seq;				}
	public String getReg_id			(){		return reg_id;			}
	public String getReg_dt			(){		return reg_dt;			}
	public String getCar_mng_id		(){		return car_mng_id;		}
	public String getDtire_note		(){		return dtire_note;		}
	public String getDtire_carno	(){		return dtire_carno;		}
	public String getReq_nm			(){		return req_nm;		}
	public String getDtire_dt		(){		return dtire_dt;		}
	public int	  getDtire_amt		(){		return dtire_amt;		}
	public String getDtire_gb		(){		return dtire_gb;		}
	public String getDtire_yn		(){		return dtire_yn;		}
	public String getDtire_item1	(){		return dtire_item1;		}
	public int	  getDtire_item_amt1(){		return dtire_item_amt1;		}
	public String getDtire_item2	(){		return dtire_item2;		}
	public int	  getDtire_item_amt2(){		return dtire_item_amt2;		}
	public String getDtire_item3	(){		return dtire_item3;		}
	public int	  getDtire_item_amt3(){		return dtire_item_amt3;		}
	public String getDtire_item4	(){		return dtire_item4;		}
	public int	  getDtire_item_amt4(){		return dtire_item_amt4;		}
	public String getDtire_item5	(){		return dtire_item5;		}
	public int	  getDtire_item_amt5(){		return dtire_item_amt5;		}
	public String getDtire_item6	(){		return dtire_item6;		}
	public int	  getDtire_item_amt6(){		return dtire_item_amt6;		}
	public String getDtire_carnm	(){		return dtire_carnm;		}
	public int	  getDtire_km		(){		return dtire_km;		}
	public String getRent_l_cd	(){		return rent_l_cd;		}
	public String getServ_id	(){		return serv_id;		}
	public int	  getDtire_s_amt		(){		return dtire_s_amt;		}
	public int	  getDtire_v_amt		(){		return dtire_v_amt;		}
	public String getDc	(){		return dc;		}

	public int	  getDtire_item_v_amt1(){		return dtire_item_v_amt1;		}
	public int	  getDtire_item_s_amt1(){		return dtire_item_s_amt1;		}
	public int	  getDtire_item_v_amt2(){		return dtire_item_v_amt2;		}
	public int	  getDtire_item_s_amt2(){		return dtire_item_s_amt2;		}
	public int	  getDtire_item_v_amt3(){		return dtire_item_v_amt3;		}
	public int	  getDtire_item_s_amt3(){		return dtire_item_s_amt3;		}
	public int	  getDtire_item_v_amt4(){		return dtire_item_v_amt4;		}
	public int	  getDtire_item_s_amt4(){		return dtire_item_s_amt4;		}
	public int	  getDtire_item_v_amt5(){		return dtire_item_v_amt5;		}
	public int	  getDtire_item_s_amt5(){		return dtire_item_s_amt5;		}
	public int	  getDtire_item_v_amt6(){		return dtire_item_v_amt6;		}
	public int	  getDtire_item_s_amt6(){		return dtire_item_s_amt6;		}
	public int	  getDtire_item_t_amt1(){		return dtire_item_t_amt1;		}
	public int	  getDtire_item_t_amt2(){		return dtire_item_t_amt2;		}
	public int	  getDtire_item_t_amt3(){		return dtire_item_t_amt3;		}
	public int	  getDtire_item_t_amt4(){		return dtire_item_t_amt4;		}
	public int	  getDtire_item_t_amt5(){		return dtire_item_t_amt5;		}
	public int	  getDtire_item_t_amt6(){		return dtire_item_t_amt6;		}
	public int	  getDtire_item_su1(){		return dtire_item_su1;		}
	public int	  getDtire_item_su2(){		return dtire_item_su2;		}
	public int	  getDtire_item_su3(){		return dtire_item_su3;		}
	public int	  getDtire_item_su4(){		return dtire_item_su4;		}
	public int	  getDtire_item_su5(){		return dtire_item_su5;		}
	public int	  getDtire_item_su6(){		return dtire_item_su6;		}


}