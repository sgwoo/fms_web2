package acar.cont;

public class ContFeeRmBean
{

	private String rent_mng_id		;		// 계약관리번호             
	private String rent_l_cd		;		// 계약번호                 
	private String rent_st			;		// 구분   
	private int    dc_s_amt			;		//DC-공급가
	private int    dc_v_amt			;		//DC-부가세
	private int    navi_s_amt		;		//네비게이션_공급가        
	private int    navi_v_amt		;		//네비게이션_부가세      
	private int    etc_s_amt		;		//기타비용-공급가
	private int    etc_v_amt		;		//기타비용-부가세
	private int    t_fee_s_amt		;		//대여료-공급가
	private int    t_fee_v_amt		;		//대여료-부가세
	private int    cons1_s_amt		;		//배차료_공급가        
	private int    cons1_v_amt		;		//배차료_부가세      
	private int    cons2_s_amt		;		//반차료_공급가        
	private int    cons2_v_amt		;		//반차료_부가세      
	private String f_paid_way		;		//최초결제방법
	private String f_paid_way2		;		//최초결제방법-반차료포함여부
	private int    f_rent_tot_amt	;		//최초결제금액
	private int    f_con_amt		;	    //예약선수금
	private String navi_yn			;		//네비게이션여부
	private String cons1_yn			;		//탁송요청여부
	private String cons2_yn			;		//탁송요청여부
	private String etc_cont			;		//기타비용-내용
	private String est_id			;		//견적관리번호
	private String amt_per			;		//할인율
	private String cars				;		//단기대여차량명
	private int    amt_01d			;		//1일대여요금
	private int    amt_03d			;		//3일대여요금
	private int    amt_05d			;		//5일대여요금
	private int    amt_07d			;		//7일대여요금
	private String serial_no		;		//네비serial	
	private String reg_id			;		//등록자
	private String reg_dt			;		//등록일
	private String update_id		;		//수정자
	private String update_dt		;		//수정일
	private String car_use			;		//차량이용용도
	private String my_accid_yn		;		//휴차보상료구분
	private String deli_plan_dt		;		//배차예정일시
	private String ret_plan_dt		;		//반차예정일시
	private String deli_loc			;		//배차장소
	private String ret_loc			;		//반차장소
	private String card_no;			//신용카드번호
	private String card_y_mm;		//신용카드유효월
	private String card_y_yy;		//신용카드유효년
	private String card_user;		//신용카드소유자
	private String cms_type;		//2회차청구구분


	public ContFeeRmBean()
	{
		rent_mng_id		= "";
		rent_l_cd		= "";
		rent_st			= "";
		dc_s_amt		= 0;
		dc_v_amt		= 0;
		navi_s_amt		= 0;
		navi_v_amt		= 0;
		etc_s_amt		= 0;
		etc_v_amt		= 0;
		t_fee_s_amt		= 0;
		t_fee_v_amt		= 0;
		cons1_s_amt		= 0;
		cons1_v_amt		= 0;
		cons2_s_amt		= 0;
		cons2_v_amt		= 0;
		f_paid_way		= "";
		f_paid_way2		= "";
		f_rent_tot_amt	= 0;
		f_con_amt		= 0;
		navi_yn			= "";
		cons1_yn		= "";
		cons2_yn		= "";
		etc_cont		= "";
		est_id			= "";
		amt_per			= "";
		cars			= "";
		amt_01d			= 0;
		amt_03d			= 0;
		amt_05d			= 0;
		amt_07d			= 0;
		serial_no		= "";
		reg_id			= "";
		reg_dt			= "";
		update_id		= "";
		update_dt		= "";
		car_use			= "";
		my_accid_yn		= "";
		deli_plan_dt	= "";
		ret_plan_dt		= "";
		deli_loc		= "";
		ret_loc			= "";
		card_no			= "";
		card_y_mm		= "";
		card_y_yy		= "";
		card_user		= "";
		cms_type		= "";
	}
	



	public void setRent_mng_id		(String str)	{ rent_mng_id		= str;	}
	public void setRent_l_cd		(String str)	{ rent_l_cd			= str;	}
	public void setRent_st			(String str)	{ rent_st			= str;	}
	public void setDc_s_amt			(int i)			{ dc_s_amt			= i;	}
	public void setDc_v_amt			(int i)			{ dc_v_amt			= i;	}
	public void setNavi_s_amt		(int i)			{ navi_s_amt		= i;	}
	public void setNavi_v_amt		(int i)			{ navi_v_amt		= i;	}
	public void setEtc_s_amt		(int i)			{ etc_s_amt			= i;	}
	public void setEtc_v_amt		(int i)			{ etc_v_amt			= i;	}
	public void setT_fee_s_amt		(int i)			{ t_fee_s_amt		= i;	}
	public void setT_fee_v_amt		(int i)			{ t_fee_v_amt		= i;	}
	public void setCons1_s_amt		(int i)			{ cons1_s_amt		= i;	}
	public void setCons1_v_amt		(int i)			{ cons1_v_amt		= i;	}
	public void setCons2_s_amt		(int i)			{ cons2_s_amt		= i;	}
	public void setCons2_v_amt		(int i)			{ cons2_v_amt		= i;	}
	public void setF_paid_way		(String str)	{ f_paid_way		= str;	}
	public void setF_paid_way2		(String str)	{ f_paid_way2		= str;	}
	public void setF_rent_tot_amt	(int i)			{ f_rent_tot_amt	= i  ;	}
	public void setF_con_amt		(int i)			{ f_con_amt			= i  ;	}
	public void setNavi_yn			(String str)	{ navi_yn			= str;	}
	public void setCons1_yn			(String str)	{ cons1_yn			= str;	}
	public void setCons2_yn			(String str)	{ cons2_yn			= str;	}
	public void setEtc_cont			(String str)	{ etc_cont			= str;	}
	public void setEst_id			(String str)	{ est_id			= str;	}
	public void setAmt_per			(String str)	{ amt_per			= str;	}
	public void setCars				(String str)	{ cars				= str;	}
	public void setAmt_01d			(int i)			{ amt_01d			= i;	}
	public void setAmt_03d			(int i)			{ amt_03d			= i;	}
	public void setAmt_05d			(int i)			{ amt_05d			= i;	}
	public void setAmt_07d			(int i)			{ amt_07d			= i;	}
	public void setSerial_no		(String str)	{ serial_no			= str;	}
	public void setReg_id			(String str)	{ reg_id			= str;	}
	public void setReg_dt			(String str)	{ reg_dt			= str;	}
	public void setUpdate_id		(String str)	{ update_id			= str;	}
	public void setUpdate_dt		(String str)	{ update_dt			= str;	}
	public void setCar_use			(String str)	{ car_use			= str;	}
	public void setMy_accid_yn		(String str)	{ my_accid_yn		= str;	}
	public void setDeli_plan_dt		(String str)	{ deli_plan_dt		= str;	}
	public void setRet_plan_dt		(String str)	{ ret_plan_dt		= str;	}
	public void setDeli_loc			(String str)	{ deli_loc			= str;	}
	public void setRet_loc			(String str)	{ ret_loc			= str;	}
	public void setCard_no			(String str)	{ card_no			= str;  }	
	public void setCard_y_mm		(String str)	{ card_y_mm			= str;  }
	public void setCard_y_yy		(String str)	{ card_y_yy			= str;  }
	public void setCard_user		(String str)	{ card_user			= str;  }	
	public void setCms_type			(String str)	{ cms_type			= str;  }	






	public String getRent_mng_id	()		{ return rent_mng_id		;	}
	public String getRent_l_cd		()		{ return rent_l_cd			;	}
	public String getRent_st		()		{ return rent_st			;	}
	public int    getDc_s_amt		()		{ return dc_s_amt			;	}
	public int    getDc_v_amt		()		{ return dc_v_amt			;	}
	public int    getNavi_s_amt		()		{ return navi_s_amt			;	}
	public int    getNavi_v_amt		()		{ return navi_v_amt			;	}
	public int    getEtc_s_amt		()		{ return etc_s_amt			;	}
	public int    getEtc_v_amt		()		{ return etc_v_amt			;	}
	public int    getT_fee_s_amt	()		{ return t_fee_s_amt		;	}
	public int    getT_fee_v_amt	()		{ return t_fee_v_amt		;	}
	public int    getCons1_s_amt	()		{ return cons1_s_amt		;	}
	public int    getCons1_v_amt	()		{ return cons1_v_amt		;	}
	public int    getCons2_s_amt	()		{ return cons2_s_amt		;	}
	public int    getCons2_v_amt	()		{ return cons2_v_amt		;	}
	public String getF_paid_way		()		{ return f_paid_way			;	}
	public String getF_paid_way2	()		{ return f_paid_way2		;	}
	public int    getF_rent_tot_amt	()		{ return f_rent_tot_amt		;	}
	public int    getF_con_amt		()		{ return f_con_amt			;	}
	public String getNavi_yn		()		{ return navi_yn			;	}
	public String getCons1_yn		()		{ return cons1_yn			;	}
	public String getCons2_yn		()		{ return cons2_yn			;	}
	public String getEtc_cont		()		{ return etc_cont			;	}
	public String getEst_id			()		{ return est_id				;	}
	public String getAmt_per		()		{ return amt_per			;	}
	public String getCars			()		{ return cars				;	}
	public int    getAmt_01d		()		{ return amt_01d			;	}
	public int    getAmt_03d		()		{ return amt_03d			;	}
	public int    getAmt_05d		()		{ return amt_05d			;	}
	public int    getAmt_07d		()		{ return amt_07d			;	}
	public String getSerial_no		()		{ return serial_no			;	}
	public String getReg_id			()		{ return reg_id				;	}
	public String getReg_dt			()		{ return reg_dt				;	}
	public String getUpdate_id		()		{ return update_id			;	}
	public String getUpdate_dt		()		{ return update_dt			;	}
	public String getCar_use		()		{ return car_use			;	}
	public String getMy_accid_yn	()		{ return my_accid_yn		;	}
	public String getDeli_plan_dt	()		{ return deli_plan_dt		;	}
	public String getRet_plan_dt	()		{ return ret_plan_dt		;	}
	public String getDeli_loc		()		{ return deli_loc			;	}
	public String getRet_loc		()		{ return ret_loc			;	}
	public String getCard_no		()		{ return card_no			;	}	
	public String getCard_y_mm		()		{ return card_y_mm			;	}
	public String getCard_y_yy		()		{ return card_y_yy			;	}
	public String getCard_user		()		{ return card_user			;	}	
	public String getCms_type		()		{ return cms_type			;	}	

}