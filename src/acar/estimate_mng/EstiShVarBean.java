/**
 * 견적변수관리-공통 계산식
 */
package acar.estimate_mng;
import java.util.*;

public class EstiShVarBean {

	//Table : ESTI_SH_VAR
    private String sh_code;		//코드
    private String seq;			//일련번호(업데이트)
    private String cars;		//해당차동차들
    private float  janga24;		//차령24개월잔가율
    private String jeep_yn;		//짚 여부
	private String rentcar;		//렌트(lpg)여부
	private String svn_nn_yn;	//7~9인승 영부
	private String lpg_ga_yn;	//lpg장착가능여부
	private int    lpg_amt;		//lpg장탈착비용
	private int    lpg_add_amt;	//직접분사 추가금액
 	private String reg_dt;		//기준일자
	private int    taksong_se;	//탁송료-서울
	private int    taksong_bu;	//탁송료-부산
    private float  af_m12_24;	//할부이자율 12/24개월
    private float  af_m36;		//할부이자율 36개월
    private float  af_m48_60;	//할부이자율 48/60개월

	// CONSTRCTOR            
    public EstiShVarBean() {  
    	this.sh_code = "";
    	this.seq = "";
		this.cars = "";
		this.janga24 = 0.0f;
		this.jeep_yn = "";
    	this.rentcar = "";
		this.svn_nn_yn = "";
		this.lpg_ga_yn = "";
		this.lpg_amt = 0;
		this.lpg_add_amt = 0;
 		this.reg_dt		= "";
		this.taksong_se = 0;
		this.taksong_bu = 0;
		this.af_m12_24	= 0.0f;
		this.af_m36		= 0.0f;
		this.af_m48_60	= 0.0f;

	}

	// get Method
    public void setSh_code		(String val){		if(val==null) val="";	this.sh_code = val;		}
    public void setSeq			(String val){		if(val==null) val="";	this.seq = val;			}
	public void setCars			(String val){		if(val==null) val="";	this.cars = val;		}		
	public void setJanga24		(float val){								this.janga24 = val;		}
	public void setJeep_yn		(String val){		if(val==null) val="";	this.jeep_yn = val;		}
	public void setRentcar		(String val){		if(val==null) val="";	this.rentcar = val;		}
	public void setSvn_nn_yn	(String val){		if(val==null) val="";	this.svn_nn_yn = val;	}
	public void setLpg_ga_yn	(String val){		if(val==null) val="";	this.lpg_ga_yn = val;	}
	public void setLpg_amt		(int val){									this.lpg_amt = val;		}
	public void setLpg_add_amt	(int val){									this.lpg_add_amt = val;	}
	public void setReg_dt		(String val){		if(val==null) val="";	this.reg_dt		= val;	}
	public void setTaksong_se	(int val){									this.taksong_se = val;	}
	public void setTaksong_bu	(int val){									this.taksong_bu = val;	}
	public void setAf_m12_24	(float val){								this.af_m12_24	= val;	}
	public void setAf_m36		(float val){								this.af_m36		= val;	}
	public void setAf_m48_60	(float val){								this.af_m48_60	= val;	}

	//Get Method
	public String getSh_code	()	{		return sh_code;		}
	public String getSeq		()	{		return seq;			}
	public String getCars		()	{		return cars;		}
	public float  getJanga24	()	{		return janga24;		}
	public String getJeep_yn	()	{		return jeep_yn;		}
	public String getRentcar	()	{		return rentcar;		}
	public String getSvn_nn_yn	()	{		return svn_nn_yn;	}
	public String getLpg_ga_yn	()	{		return lpg_ga_yn;	}
	public int	  getLpg_amt	()	{		return lpg_amt;		}
	public int	  getLpg_add_amt()	{		return lpg_add_amt; }
	public String getReg_dt		()	{		return reg_dt;		}
	public int	  getTaksong_se	()	{		return taksong_se;	}
	public int	  getTaksong_bu	()	{		return taksong_bu;	}
	public float  getAf_m12_24	()	{		return af_m12_24;	}
	public float  getAf_m36		()	{		return af_m36;		}
	public float  getAf_m48_60	()	{		return af_m48_60;	}

}
