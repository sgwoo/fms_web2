package acar.insur;

public class InsurClsBean
{
	private String	car_mng_id;		//자동차관리번호
	private String	ins_st;			//보험구분
	private String	exp_st;			//용도변경내용
	private String	exp_aim;		//해지목적
	private String	exp_dt;			//해지일	
	private String	req_dt;			//청구일
	private int		use_day1;		//경과일수-대인배상1
	private int		use_day2;		//경과일수-대인배상11
	private int		use_day3;		//경과일수-대물배상
	private int		use_day4;		//경과일수-자기신체사고
	private int		use_day5;		//경과일수-자기차량손해
	private int		use_day6;		//경과일수-무보험차상해
	private int		use_day7;		//경과일수-긴급출동
	private int		use_amt1;		//경과보험료
	private int		use_amt2;		//경과보험료
	private int		use_amt3;		//경과보험료
	private int		use_amt4;		//경과보험료
	private int		use_amt5;		//경과보험료
	private int		use_amt6;		//경과보험료
	private int		use_amt7;		//경과보험료
	private String	exp_yn1;		//해지여부
	private String	exp_yn2;		//해지여부
	private String	exp_yn3;		//해지여부
	private String	exp_yn4;		//해지여부
	private String	exp_yn5;		//해지여부
	private String	exp_yn6;		//해지여부
	private String	exp_yn7;		//해지여부
	private int		tot_ins_amt;	//총보험료
	private int		tot_use_amt;	//경과보험료
	private int		nopay_amt;		//차회보험료
	private int		rtn_est_amt;	//환급예정보험료
	private int		rtn_amt;		//환급보험료
	private String	rtn_dt;			//입금일자
	private int		dif_amt;		//차액
	private String	dif_cau;		//차액발생사유
	private String	reg_id;			//최초등록자
	private String	reg_dt;			//최초등록일
	private String	upd_id;			//최종수정자
	private String	upd_dt;			//최종수정일
	private String	cls_st;			//해지구분

	public InsurClsBean()
	{
		car_mng_id		= "";
		ins_st			= "";
		exp_st			= "";
		exp_aim			= "";
		exp_dt			= "";
		req_dt			= "";
		use_day1		= 0;
		use_day2		= 0;
		use_day3		= 0;
		use_day4		= 0;
		use_day5		= 0;
		use_day6		= 0;
		use_day7		= 0;
		use_amt1		= 0;
		use_amt2		= 0;
		use_amt3		= 0;
		use_amt4		= 0;
		use_amt5		= 0;
		use_amt6		= 0;
		use_amt7		= 0;
		exp_yn1			= "";
		exp_yn2			= "";
		exp_yn3			= "";
		exp_yn4			= "";
		exp_yn5			= "";
		exp_yn6			= "";
		exp_yn7			= "";
		tot_ins_amt		= 0;
		tot_use_amt		= 0;
		nopay_amt		= 0;
		rtn_est_amt		= 0;
		rtn_amt			= 0;
		rtn_dt			= "";
		dif_amt			= 0;
		dif_cau			= "";
		reg_id			= "";
		reg_dt			= "";
		upd_id			= "";
		upd_dt			= "";
		cls_st			= "";

	}
	
	public void setCar_mng_id	(String str)	{	car_mng_id	= str;	}
	public void setIns_st		(String str)	{	ins_st		= str;	}
	public void setExp_st		(String str)	{	exp_st		= str;	}
	public void setExp_aim		(String str)	{	exp_aim		= str;	}
	public void setExp_dt		(String str)	{	exp_dt		= str;	}
	public void setReq_dt		(String str)	{	req_dt		= str;	}
	public void setUse_day1		(int i)			{	use_day1	= i;	}
	public void setUse_day2		(int i)			{	use_day2	= i;	}
	public void setUse_day3		(int i)			{	use_day3	= i;	}
	public void setUse_day4		(int i)			{	use_day4	= i;	}
	public void setUse_day5		(int i)			{	use_day5	= i;	}
	public void setUse_day6		(int i)			{	use_day6	= i;	}
	public void setUse_day7		(int i)			{	use_day7	= i;	}
	public void setUse_amt1		(int i)			{	use_amt1	= i;	}
	public void setUse_amt2		(int i)			{	use_amt2	= i;	}
	public void setUse_amt3		(int i)			{	use_amt3	= i;	}
	public void setUse_amt4		(int i)			{	use_amt4	= i;	}
	public void setUse_amt5		(int i)			{	use_amt5	= i;	}
	public void setUse_amt6		(int i)			{	use_amt6	= i;	}
	public void setUse_amt7		(int i)			{	use_amt7	= i;	}
	public void setExp_yn1		(String str)	{	exp_yn1		= str;	}
	public void setExp_yn2		(String str)	{	exp_yn2		= str;	}
	public void setExp_yn3		(String str)	{	exp_yn3		= str;	}
	public void setExp_yn4		(String str)	{	exp_yn4		= str;	}
	public void setExp_yn5		(String str)	{	exp_yn5		= str;	}
	public void setExp_yn6		(String str)	{	exp_yn6		= str;	}
	public void setExp_yn7		(String str)	{	exp_yn7		= str;	}
	public void setTot_ins_amt	(int i)			{	tot_ins_amt	= i;	}
	public void setTot_use_amt	(int i)			{	tot_use_amt	= i;	}
	public void setNopay_amt	(int i)			{	nopay_amt	= i;	}
	public void setRtn_est_amt	(int i)			{	rtn_est_amt	= i;	}
	public void setRtn_amt		(int i)			{	rtn_amt		= i;	}
	public void setRtn_dt		(String str)	{	rtn_dt		= str;	}
	public void setDif_amt		(int i)			{	dif_amt		= i;	}
	public void setDif_cau		(String str)	{	dif_cau		= str;	}
	public void setReg_id		(String str)	{	reg_id		= str;	}
	public void setReg_dt		(String str)	{	reg_dt		= str;	}
	public void setUpd_id		(String str)	{	upd_id		= str;	}
	public void setUpd_dt		(String str)	{	upd_dt		= str;	}
	public void setCls_st		(String str)	{	cls_st		= str;	}

	
	public String getCar_mng_id	()		{	return	car_mng_id;	}
	public String getIns_st		()		{	return	ins_st;		}
	public String getExp_st		()		{	return	exp_st;		}
	public String getExp_aim	()		{	return	exp_aim;	}
	public String getExp_dt		()		{	return	exp_dt;		}
	public String getReq_dt		()		{	return	req_dt;		}
	public int	  getUse_day1	()		{	return	use_day1;	}
	public int	  getUse_day2	()		{	return	use_day2;	}
	public int	  getUse_day3	()		{	return	use_day3;	}
	public int	  getUse_day4	()		{	return	use_day4;	}
	public int	  getUse_day5	()		{	return	use_day5;	}
	public int	  getUse_day6	()		{	return	use_day6;	}
	public int	  getUse_day7	()		{	return	use_day7;	}
	public int	  getUse_amt1	()		{	return	use_amt1;	}
	public int	  getUse_amt2	()		{	return	use_amt2;	}
	public int	  getUse_amt3	()		{	return	use_amt3;	}
	public int	  getUse_amt4	()		{	return	use_amt4;	}
	public int	  getUse_amt5	()		{	return	use_amt5;	}
	public int	  getUse_amt6	()		{	return	use_amt6;	}
	public int	  getUse_amt7	()		{	return	use_amt7;	}
	public String getExp_yn1	()		{	return	exp_yn1;	}
	public String getExp_yn2	()		{	return	exp_yn2;	}
	public String getExp_yn3	()		{	return	exp_yn3;	}
	public String getExp_yn4	()		{	return	exp_yn4;	}
	public String getExp_yn5	()		{	return	exp_yn5;	}
	public String getExp_yn6	()		{	return	exp_yn6;	}
	public String getExp_yn7	()		{	return	exp_yn7;	}
	public int	  getTot_ins_amt()		{	return	tot_ins_amt;}
	public int	  getTot_use_amt()		{	return	tot_use_amt;}
	public int	  getNopay_amt	()		{	return	nopay_amt;	}
	public int	  getRtn_est_amt()		{	return	rtn_est_amt;}
	public int	  getRtn_amt	()		{	return	rtn_amt;	}
	public String getRtn_dt		()		{	return	rtn_dt;		}
	public int	  getDif_amt	()		{	return	dif_amt;	}
	public String getDif_cau	()		{	return	dif_cau;	}
	public String getReg_id		()		{	return	reg_id;		}
	public String getReg_dt		()		{	return	reg_dt;		}
	public String getUpd_id		()		{	return	upd_id;		}
	public String getUpd_dt		()		{	return	upd_dt;		}
	public String getCls_st		()		{	return	cls_st;		}

}