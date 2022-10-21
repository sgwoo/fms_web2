package acar.parts;

public class OrderBean
{
	private String reqseq;
	private String buy_dt;
	private String ven_code;
	private String ven_name;
	private int buy_qty;
	private int buy_s_amt;
	private int buy_v_amt;
	private int buy_amt;	
	private String trf_st1;
	private int trf_s_amt1;	
	private int trf_v_amt1;	
	private int trf_amt1;	
	private int trf_a_amt1;	
	private int trf_j_amt1;	
	private String cardno1;
	private String etc1;
	private String file_name1;
	private String autodoc_data_no1;
	private String trf_st2;
	private int trf_s_amt2;	
	private int trf_v_amt2;	
	private int trf_amt2;	
	private int trf_a_amt2;	
	private int trf_j_amt2;	
	private String cardno2;
	private String etc2;
	private String file_name2;
	private String autodoc_data_no2;
	private String trf_st3;
	private int trf_s_amt3;	
	private int trf_v_amt3;	
	private int trf_amt3;	
	private int trf_a_amt3;	
	private int trf_j_amt3;	
	private String cardno3;
	private String etc3;
	private String file_name3;
	private String autodoc_data_no3;	
	private String reg_id;
	private String reg_dt;
	private String sac_dt;
	private String ipgo_yn;
			
	public OrderBean()
	{
			
		reqseq  = "";
		buy_dt  = "";
		ven_code  = "";
		ven_name  = "";
		buy_qty = 0;
		 buy_s_amt  = 0;
		 buy_v_amt  = 0;
		 buy_amt   = 0;
		trf_st1  = "";
		 trf_s_amt1  = 0;	
		 trf_v_amt1  = 0;	
		 trf_amt1  = 0;
		 trf_a_amt1 = 0;	
		 trf_j_amt1 = 0;	
		 cardno1 = "";
		etc1= "";
		file_name1= "";
		autodoc_data_no1= "";
		trf_st2= "";
		 trf_s_amt2 = 0;	
		 trf_v_amt2 = 0;	
		 trf_amt2 = 0;	
		 trf_a_amt2 = 0;	
		 trf_j_amt2 = 0;	
	          cardno2 = "";
		etc2= "";
		file_name2= "";
		autodoc_data_no2= "";
		trf_st3= "";
		 trf_s_amt3 = 0;	
		 trf_v_amt3 = 0;	
		 trf_amt3 = 0;	
		 trf_a_amt3 = 0;	
		 trf_j_amt3 = 0;	
		 cardno3 = "";
		etc3= "";
		file_name3= "";
		autodoc_data_no3= "";	
		reg_id= "";
		reg_dt= "";		
		sac_dt= "";			
		ipgo_yn= "";			
			
	}
	
	public void setReqseq(String str)	{	reqseq = str;	}
	public void setBuy_dt(String str)	{	buy_dt = str;	}
	public void setVen_code(String str)	{	ven_code = str;	}
	public void setVen_name(String str)	{	ven_name = str;	}
	public void setBuy_qty(int i){			buy_qty = i;	}
	public void setBuy_s_amt(int i){		buy_s_amt = i;	}
	public void setBuy_v_amt(int i){		buy_v_amt = i;	}
	public void setBuy_amt(int i){			buy_amt = i;	}
	public void setTrf_st1(String str)	{	trf_st1 = str;	}
	public void setTrf_s_amt1(int i){			         trf_s_amt1 = i;	}
	public void setTrf_v_amt1(int i){			         trf_v_amt1 = i;	}
	public void setTrf_amt1(int i){			         trf_amt1 = i;	}
	public void setTrf_a_amt1(int i){			         trf_a_amt1 = i;	}
	public void setTrf_j_amt1(int i){			         trf_j_amt1 = i;	}
	public void setCardno1(String str)	{	cardno1 = str;	}
	public void setEtc1(String str)	{	etc1 = str;	}
	public void setFile_name1(String str)	{	file_name1 = str;	}
	public void setAutodoc_data_no1(String str)	{	autodoc_data_no1 = str;	}
	public void setTrf_st2(String str)	{	trf_st2 = str;	}
	public void setTrf_s_amt2(int i){			         trf_s_amt2 = i;	}
	public void setTrf_v_amt2(int i){			         trf_v_amt2 = i;	}
	public void setTrf_amt2(int i){			         trf_amt2 = i;	}
	public void setTrf_a_amt2(int i){			         trf_a_amt2 = i;	}
	public void setTrf_j_amt2(int i){			         trf_j_amt2 = i;	}
	public void setCardno2(String str)	{	cardno2 = str;	}
	public void setEtc2(String str)	{	etc2 = str;	}
	public void setFile_name2(String str)	{	file_name2 = str;	}
	public void setAutodoc_data_no2(String str)	{	autodoc_data_no2 = str;	}
	public void setTrf_st3(String str)	{	trf_st3 = str;	}
	public void setTrf_s_amt3(int i){			         trf_s_amt3 = i;	}
	public void setTrf_v_amt3(int i){			         trf_v_amt3 = i;	}
	public void setTrf_amt3(int i){			         trf_amt3 = i;	}
	public void setTrf_a_amt3(int i){			         trf_a_amt3 = i;	}
	public void setTrf_j_amt3(int i){			         trf_j_amt3 = i;	}
	public void setCardno3(String str)	{	cardno3 = str;	}
	public void setEtc3(String str)	{	etc3 = str;	}
	public void setFile_name3(String str)	{	file_name3 = str;	}
	public void setAutodoc_data_no3(String str)	{	autodoc_data_no3 = str;	}
	public void setReg_id(String str)	{	reg_id = str;	}
	public void setReg_dt(String str)	{	reg_dt = str;	}
	public void setSac_dt(String str)	{	sac_dt = str;	}
	public void setIpgo_yn(String str)	{	ipgo_yn = str;	}
		
	public String getReqseq()	{	return reqseq;	}
	public String getBuy_dt()	{	return buy_dt;	}
	public String getVen_code()	{	return ven_code;	}
	public String getVen_name()	{	return ven_name;	}	
	public int getBuy_qty(){		return buy_qty;		}	
	public int getBuy_s_amt(){		return buy_s_amt;		}	
	public int getBuy_v_amt(){		return buy_v_amt;		}	
	public int getBuy_amt(){		return buy_amt;		}	
	public String getTrf_st1()	{	return trf_st1;	}
	public int getTrf_s_amt1()	{		return trf_s_amt1;		}	
	public int getTrf_v_amt1()	{		return trf_v_amt1;		}	
	public int getTrf_amt1()	{		return trf_amt1;		}	
	public int getTrf_a_amt1()	{		return trf_a_amt1;		}	
	public int getTrf_j_amt1()	{		return trf_j_amt1;		}	
	public String getCardno1()	{	return cardno1;	}
	public String getEtc1()	{	return etc1;	}
	public String getFile_name1()	{	return file_name1;	}
	public String getAutodoc_data_no1()	{	return autodoc_data_no1;	}	
	public String getTrf_st2()	{	return trf_st2;	}
	public int getTrf_s_amt2()	{		return trf_s_amt2;		}	
	public int getTrf_v_amt2()	{		return trf_v_amt2;		}	
	public int getTrf_amt2()	{		return trf_amt2;		}	
	public int getTrf_a_amt2()	{		return trf_a_amt2;		}	
	public int getTrf_j_amt2()	{		return trf_j_amt2;		}	
	public String getCardno2()	{	return cardno2;	}
	public String getEtc2()	{	return etc2;	}
	public String getFile_name2()	{	return file_name2;	}
	public String getAutodoc_data_no2()	{	return autodoc_data_no2;	}	
	public String getTrf_st3()	{	return trf_st3;	}
	public int getTrf_s_amt3()	{		return trf_s_amt3;		}	
	public int getTrf_v_amt3()	{		return trf_v_amt3;		}	
	public int getTrf_amt3()	{		return trf_amt3;		}	
	public int getTrf_a_amt3()	{		return trf_a_amt3;		}	
	public int getTrf_j_amt3()	{		return trf_j_amt3;		}	
	public String getCardno3()	{	return cardno3;	}
	public String getEtc3()	{	return etc3;	}
	public String getFile_name3()	{	return file_name3;	}
	public String getAutodoc_data_no3()	{	return autodoc_data_no3;	}		
	public String getReg_id()	{	return reg_id;	}
	public String getReg_dt()	{	return reg_dt;	}	
	public String getSac_dt()	{	return sac_dt;	}	
	public String getIpgo_yn()	{	return ipgo_yn;	}	
}