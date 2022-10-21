package acar.parts;

public class IpgoBean
{
	private String reqseq;
	private String o_reqseq;
	private String ip_dt;
	private String reg_id;
	private String reg_dt;
	private String upd_id;
	private String upd_dt;
			
	public IpgoBean()
	{			
		reqseq  = "";
		o_reqseq  = "";
		ip_dt  = "";			
		reg_id= "";
		reg_dt= "";	
		upd_id= "";
		upd_dt= "";		
						
	}
	
	public void setReqseq(String str)	{	reqseq = str;	}
	public void setO_reqseq(String str)	{	o_reqseq = str;	}
	public void setIp_dt(String str)	{	ip_dt = str;	}
	public void setReg_id(String str)	{	reg_id = str;	}
	public void setReg_dt(String str)	{	reg_dt = str;	}
	public void setUpd_id(String str)	{	upd_id = str;	}
	public void setUpd_dt(String str)	{	upd_dt = str;	}
	
	public String getReqseq()	{	return reqseq;	}
	public String getO_reqseq()	{	return o_reqseq;	}
	public String getIp_dt()	{	return ip_dt;	}	
	public String getReg_id()	{	return reg_id;	}
	public String getReg_dt()	{	return reg_dt;	}	
	public String getUpd_id()	{	return upd_id;	}
	public String getUpd_dt()	{	return upd_dt;	}	
	
}