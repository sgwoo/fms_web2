/**
 * 차량회수 관리
 */
package acar.credit;
import java.util.*;

public class CarRecoBean {

	//Table : carreco - 차량회수
	
   private String rent_mng_id; //
   private String rent_l_cd;   //
   private String reco_st;     // 차량회수여부
   private String reco_d1_st;  //차량회수구분 
   private String reco_d2_st;  //차량미회수구분  
   private String reco_cau;    //사유
   private String reco_dt;     //회수일
   private String reco_id;     //회수담당자
   private String ip_dt;       //입고일    
   private int	  etc2_d1_amt;     //부대비용
   private String etc2_d1_dt;       //부대비용지출일 
   private int	  etc2_d2_amt;     //탁송비용
   private String etc2_d2_dt;       //탁송비용지출일 
   private int	  etc2_d3_amt;     //기타비용
   private String etc2_d3_dt;       //기타비용지출일 
   private int	  etc_d1_amt;     //외주비용
   private String etc_d1_dt;       //외주비용지출일 
   private String reg_dt;       //등록일    
   private String reg_id;       //등록자    
   private String upd_dt;       //수정일    
   private String upd_id;       //수정자    
   private String park;       //주차장    
   private String park_cont;       //주차시 특이사항    
           
      
	// CONSTRCTOR            
    public CarRecoBean() {  
    	
   		this.rent_mng_id  = "";    
   		this.rent_l_cd  = "";    
   		this.reco_st    = "";  
   		this.reco_d1_st    = "";   
   		this.reco_d2_st    = "";  
   		this.reco_cau   = ""; 
   		this.reco_dt  	 = "";
   		this.ip_dt    = "";  
   		this.etc2_d1_amt = 0;  
   		this.etc2_d1_dt  = ""; 
   		this.etc2_d2_amt = 0;  
   		this.etc2_d2_dt  = ""; 
   		this.etc2_d3_amt = 0;  
   		this.etc2_d3_dt  = ""; 
   		this.etc_d1_amt = 0;  
   		this.etc_d1_dt  = ""; 
   		this.reg_dt  = ""; 
   		this.reg_id  = ""; 
   		this.upd_dt  = ""; 
   		this.upd_id  = ""; 
   		this.park  = ""; 
   		this.park_cont  = ""; 
   						
   	  		      
	}

	// set Method
	public void setRent_mng_id(String val){		if(val==null) val="";	this.rent_mng_id = val;	} 
	public void setRent_l_cd(String val){		if(val==null) val="";	this.rent_l_cd = val;	}      
	public void setReco_st(String val){			if(val==null) val="";	this.reco_st = val;	}   
	public void setReco_d1_st(String val){		if(val==null) val="";	this.reco_d1_st = val;	}
	public void setReco_d2_st(String val){		if(val==null) val="";	this.reco_d2_st = val;	}
	public void setReco_cau(String val){		if(val==null) val="";	this.reco_cau = val;	}    
	public void setReco_dt(String val){			if(val==null) val="";	this.reco_dt = val;	}
	public void setIp_dt(String val){			if(val==null) val="";	this.ip_dt = val;	}    
	public void setReco_id(String val){			if(val==null) val="";	this.reco_id = val;	}
	public void setEtc2_d1_amt(int i){			this.etc2_d1_amt = i;	} 
	public void setEtc2_d1_dt(String val){		if(val==null) val="";	this.etc2_d1_dt = val;	} 
	public void setEtc2_d2_amt(int i){			this.etc2_d2_amt = i;	} 
	public void setEtc2_d2_dt(String val){		if(val==null) val="";	this.etc2_d2_dt = val;	}   
	public void setEtc2_d3_amt(int i){			this.etc2_d3_amt = i;	} 
	public void setEtc2_d3_dt(String val){		if(val==null) val="";	this.etc2_d3_dt = val;	}   
	public void setEtc_d1_amt(int i){			this.etc_d1_amt = i;	} 
	public void setEtc_d1_dt(String val){		if(val==null) val="";	this.etc_d1_dt = val;	}  
	public void setReg_dt(String val){			if(val==null) val="";	this.reg_dt = val;	}  
	public void setReg_id(String val){			if(val==null) val="";	this.reg_id = val;	}  
	public void setUpd_dt(String val){			if(val==null) val="";	this.upd_dt = val;	}  
	public void setUpd_id(String val){			if(val==null) val="";	this.upd_id = val;	}  
	public void setPark(String val){			if(val==null) val="";	this.park = val;	}  
	public void setPark_cont(String val){		if(val==null) val="";	this.park_cont = val;	}  
	
	
	
	//Get Method
	public String getRent_mng_id()  {			return rent_mng_id; } 
	public String getRent_l_cd() 	{			return rent_l_cd; }      
	public String getReco_st()  	{			return reco_st; }     
	public String getReco_d1_st() 	{			return reco_d1_st; }     
	public String getReco_d2_st() 	{			return reco_d2_st; }    
	public String getReco_cau()  	{			return reco_cau; }     
	public String getReco_dt()    	{			return reco_dt; }   
	public String getReco_id()		{			return reco_id; }   
	public String getIp_dt()		{			return ip_dt; }   
	public int	  getEtc2_d1_amt()  {			return etc2_d1_amt; }    
	public String getEtc2_d1_dt()	{			return etc2_d1_dt; }   
	public int	  getEtc2_d2_amt()  {			return etc2_d2_amt; }    
	public String getEtc2_d2_dt()	{			return etc2_d2_dt; }   
	public int	  getEtc2_d3_amt()  {			return etc2_d3_amt; }    
	public String getEtc2_d3_dt()	{			return etc2_d3_dt; }   
	public int	  getEtc_d1_amt()   {			return etc_d1_amt; }    
	public String getEtc_d1_dt()	{			return etc_d1_dt; }    
	public String getReg_dt()	{				return reg_dt; }    
	public String getReg_id()	{				return reg_id; }    
	public String getUpd_dt()	{				return upd_dt; }    
	public String getUpd_id()	{				return upd_id; }    
	public String getPark()	{					return park; }    
	public String getPark_cont()	{			return park_cont; }    


}
