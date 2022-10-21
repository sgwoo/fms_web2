package acar.parts;

public class ItemBean
{
	private String reqseq;
	private int seq_no;
	private String parts_no;
	private int qty;   // 
	private int o_s_amt;
	private int o_v_amt;  //
	private int o_amt;  // 
	private int r_s_amt;  //단가 - 공급가
	private int r_v_amt;  // 단가 -  부가세
	private String car_comp_id;
	private String car_cd;

		
	public ItemBean()
	{
		reqseq = "";
		seq_no = 0;
		parts_no = "";
		qty =0;
		o_s_amt = 0;
		o_v_amt = 0;	
		o_amt = 0;		
		r_s_amt = 0;
		r_v_amt = 0;	
		car_comp_id = "";
		car_cd = "";

	}
	
	public void setReqseq(String str)	{	reqseq = str;	}
	public void setSeq_no(int i){			seq_no = i;	}
	public void setParts_no(String str)	{	parts_no = str;	}
	public void setQty(int i){			         qty = i;	}
	public void setO_s_amt(int i){			o_s_amt = i;	}
	public void setO_v_amt(int i){			o_v_amt = i;	}
	public void setO_amt(int i){			o_amt = i;	}
	public void setR_s_amt(int i){			r_s_amt = i;	}
	public void setR_v_amt(int i){			r_v_amt = i;	}
	public void setCar_comp_id(String str)	{	car_comp_id = str;	}
	public void setCar_cd(String str)	{	car_cd = str;	}
	
	public String getReqseq()	{	return reqseq;	}
	public int getSeq_no(){		return seq_no;		}	
	public String getParts_no()	{	return parts_no;	}
	public int getQty()	{		return qty;		}	
	public int getO_s_amt(){		return o_s_amt;		}	
	public int getO_v_amt(){		return o_v_amt;		}	
	public int getO_amt(){		return o_amt;		}	
	public int getR_s_amt(){		return r_s_amt;		}	
	public int getR_v_amt(){		return r_v_amt;		}	
	public String getCar_comp_id()	{	return car_comp_id;	}
	public String getCar_cd()	{	return car_cd;	}
	
}