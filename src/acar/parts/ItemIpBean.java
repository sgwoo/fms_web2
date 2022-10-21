package acar.parts;

public class ItemIpBean
{
	private String reqseq;
	private int seq_no;
	private String parts_no;
	private int qty;   // 
	private String location;
	private String trans;
	private String io_yn;
	private String reg_id;
	private String reg_dt;
	private String car_comp_id;
	private String car_cd;
		
	public ItemIpBean()
	{
		reqseq = "";
		seq_no = 0;
		parts_no = "";
		qty =0;
		location = "";
		trans = "";
		io_yn = "";
		reg_id = "";
		reg_dt = "";
		car_comp_id = "";
		car_cd = "";
	}
	
	public void setReqseq(String str)	{	reqseq = str;	}
	public void setSeq_no(int i){			seq_no = i;	}
	public void setParts_no(String str)	{	parts_no = str;	}
	public void setQty(int i){			         qty = i;	}
	public void setLocation(String str)	{	location = str;	}
	public void setTrans(String str)	{	trans = str;	}
	public void setIo_yn(String str)	{	io_yn = str;	}
	public void setReg_id(String str)	{	reg_id= str;	}
	public void setReg_dt(String str)	{	reg_dt= str;	}
	public void setCar_comp_id(String str)	{	car_comp_id= str;	}
	public void setCar_cd(String str)	{	car_cd= str;	}
	
	public String getReqseq()	{	return reqseq;	}
	public int getSeq_no(){		return seq_no;		}	
	public String getParts_no()	{	return parts_no;	}
	public int getQty()	{		return qty;		}	
	public String getLocation()	{	return location;	}
	public String getTrans()	{	return trans;	}
	public String getIo_yn ()	{	return io_yn;	}
	public String getReg_id ()	{	return reg_id;	}
	public String getReg_dt ()	{	return reg_dt;	}
	public String getCar_comp_id ()	{	return car_comp_id;	}
	public String getCar_cd ()	{	return car_cd;	}
	
}