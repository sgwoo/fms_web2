package acar.parts;

public class ChulgoBean
{
	private String reqseq;
	private int seq_no;
	private String ch_dt;
	private String parts_no;
	private String parts_nm;
	private String maker_nm;
	private String car_nm;
	private String location;
	private String i_reqseq;
	private int qty;

	private String sac_dt;
	private String off_id;
	private String car_mng_id;
	private String rent_l_cd;
	private String bus_id2;
	private String ipgo_dt;
	private String chulgo_dt;
	private String reg_id;
	private String reg_dt;
	private String upd_id;
	private String upd_dt;

	public ChulgoBean()
	{			
		reqseq  = "";
		seq_no = 0;
		ch_dt  = "";	
		parts_no = "";
		parts_nm = "";
		maker_nm = "";
		car_nm = "";
		location = "";
		qty =0;			
		sac_dt= "";		
		off_id= "";		
		car_mng_id = "";
		rent_l_cd = "";
		bus_id2 = "";
		ipgo_dt = "";
		chulgo_dt = "";
		reg_id= "";
		reg_dt= "";	
		upd_id= "";
		upd_dt= "";	
		i_reqseq = "";	

						
	}
	
	public void setReqseq(String str)	{	reqseq = str;	}
	public void setSeq_no(int i){			seq_no = i;	}
	public void setCh_dt(String str)	{	ch_dt = str;	}
	public void setParts_no(String str)	{	parts_no = str;	}
	public void setParts_nm(String str)	{	parts_nm = str;	}
	public void setMaker_nm(String str)	{	maker_nm = str;	}
	public void setCar_nm(String str)	{	car_nm = str;	}
	public void setLocation(String str)	{	location = str;	}
	public void setQty(int i){			         qty = i;	}
	public void setSac_dt(String str)	{	sac_dt = str;	}
	public void setOff_id(String str)	{	off_id = str;	}
	public void setCar_mng_id(String str)	{	car_mng_id = str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd = str;	}
	public void setBus_id2(String str)	{	bus_id2 = str;	}
	public void setIpgo_dt(String str)	{	ipgo_dt = str;	}
	public void setChulgo_dt(String str)	{	chulgo_dt = str;	}
	public void setReg_id(String str)	{	reg_id = str;	}
	public void setReg_dt(String str)	{	reg_dt = str;	}
	public void setUpd_id(String str)	{	upd_id = str;	}
	public void setUpd_dt(String str)	{	upd_dt = str;	}
	public void setI_reqseq(String str)	{	i_reqseq = str;	}

	
	public String getReqseq()	{	return reqseq;	}
	public int getSeq_no(){		return seq_no;		}	
	public String getCh_dt()	{	return ch_dt;	}
	public String getParts_no()	{	return parts_no;	}
	public String getParts_nm()	{	return parts_nm;	}
	public String getMaker_nm()	{	return maker_nm;	}
	public String getCar_nm()	{	return car_nm;	}
	public String getLocation()	{	return location;	}
	public int getQty()	{		return qty;		}	
	public String getSac_dt()	{	return sac_dt;	}	
	public String getOff_id()	{	return off_id;	}	
	public String getCar_mng_id()	{	return car_mng_id;	}	
	public String getRent_l_cd()	{	return rent_l_cd;	}	
	public String getBus_id2()	{	return bus_id2;	}	
	public String getIpgo_dt()	{	return ipgo_dt;	}	
	public String getChulgo_dt()	{	return chulgo_dt;	}	
	public String getReg_id()	{	return reg_id;	}
	public String getReg_dt()	{	return reg_dt;	}	
	public String getUpd_id()	{	return upd_id;	}
	public String getUpd_dt()	{	return upd_dt;	}	
	public String getI_reqseq()	{	return i_reqseq;	}	

	
}