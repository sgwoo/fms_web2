package tax;

import java.util.*;

public class TaxCngBean {

	//Table :tax_cng
	private String tax_no;			
	private int	   seq;			
	private String cng_cau;			
	private String cng_dt;			
	private String cng_id;				
	private String cng_st;				


	// CONSTRCTOR            
	public TaxCngBean() {  
		tax_no		= "";
		seq			= 0;
		cng_cau		= "";
		cng_dt		= "";
		cng_id		= "";
		cng_st		= "";
	}

	//Set Method
	public void setTax_no	(String val){	if(val==null) val="";	tax_no		= val;	}
	public void setSeq		(int val)   {							seq			= val;	}	
	public void setCng_cau	(String val){	if(val==null) val="";	cng_cau		= val;	}
	public void setCng_dt	(String val){	if(val==null) val="";	cng_dt		= val;	}
	public void setCng_id	(String val){	if(val==null) val="";	cng_id		= val;	}
	public void setCng_st	(String val){	if(val==null) val="";	cng_st		= val;	}

	//Get Method
	public String getTax_no	(){		return		tax_no;		}
	public int	  getSeq	(){		return		seq;		}
	public String getCng_cau(){		return		cng_cau;	}
	public String getCng_dt	(){		return		cng_dt;		}
	public String getCng_id	(){		return		cng_id;		}
	public String getCng_st	(){		return		cng_st;		}
}
