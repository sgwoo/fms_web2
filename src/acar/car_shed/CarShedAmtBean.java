package acar.car_shed;

public class CarShedAmtBean
{
	private String shed_id;  //관리구분 아이디
	private String reg_id; //등록자
	private String reg_dt; //등록일
	private String mng_dt; //귀속월
	private int m_amt; //월정관리비
	private int p_amt;	//추가관리비
	private int h_amt;	//합계
	private int s_amt;	//소모품비
	private int u_amt;	//월정주차요금(업무용)	 
	private int c_amt;	//차고지임대료

	
	public CarShedAmtBean()
	{
		shed_id		= "";
		reg_id		= "";
		reg_dt		= "";
		mng_dt	= "";
		m_amt		= 0;
		p_amt		= 0;
		h_amt		= 0;
		s_amt		= 0;
		u_amt		= 0;
		c_amt		= 0;


	}
	
	public void setShed_id(String str)		{	shed_id		= str;	}
	public void setReg_id(String str)		{	reg_id		= str;	}
	public void setReg_dt(String str)		{	reg_dt		= str;	}
	public void setMng_dt(String str)		{	mng_dt		= str;	}
	public void setM_amt(int    val){                       this.m_amt		= val;	}
	public void setP_amt(int    val){                       this.p_amt		= val;	}
	public void setH_amt(int    val){                       this.h_amt		= val;	}
	public void setS_amt(int    val){                       this.s_amt		= val;	}
	public void setU_amt(int    val){                       this.u_amt		= val;	}
	public void setC_amt(int    val){                       this.c_amt		= val;	}

	
	public String getShed_id()		{	return	shed_id;	}
	public String getReg_id()		{	return	reg_id;	}		
	public String getReg_dt()		{	return	reg_dt;	}
	public String getMng_dt()		{	return	mng_dt;	}
	public int    getM_amt		(){		return m_amt;		}
	public int    getP_amt		(){		return p_amt;		}
	public int    getH_amt		(){		return h_amt;		}
	public int    getS_amt		(){		return s_amt;		}
	public int    getU_amt		(){		return u_amt;		}
	public int    getC_amt		(){		return c_amt;		}

}