/**
 * 채권 관리
 */
package acar.credit;
import java.util.*;

public class CarCreditBean {

	//Table : carcredit - 채권관계
		
   private String rent_mng_id; //
   private String rent_l_cd;   //
   private int gi_amt;  		   	// 보증보험금액
   private int gi_c_amt; 			//청구금액 
   private int gi_j_amt; 			//잔존채권금액  
   private String c_ins;    		//손해보험사
   private String c_ins_d_nm;     	//담당자
   private String c_ins_tel;     	//전화번호
   private String crd_reg_gu1;       //보증보험청구여부    
   private String crd_reg_gu2;       //연대보증구상여부    
   private String crd_reg_gu3;       //채권추심외주여부    
   private String crd_reg_gu4;       //자동차손해보험여부    
   private String crd_reg_gu5;       //면제여부    
   private String crd_reg_gu6;       //대손처리여부
   private String crd_remark1;     //보증보험청구의견
   private String crd_remark2;     //연대보증인구상의견
   private String crd_remark3;     //채권추심외주의견
   private String crd_remark4;     //자동차손해보험의견
   private String crd_remark5;     //면제의견
   private String crd_remark6;     //대손처리의견
      
   private String crd_id;       //결재자 
   private String crd_reason;     //사유
   private String reg_dt;       //등록일    
   private String reg_id;       //등록자    
   private String upd_dt;       //수정일    
   private String upd_id;       //수정자    
           
   private String crd_req_gu1;       //보증보험 권리분석여부    
   private String crd_req_gu2;       //연대보증구상권리분석여부      
   private String crd_req_gu3;       //채권추심외주 권리분석여부   
   private String crd_req_gu4;       //자동차손해보험 권리분석여부      
   private String crd_req_gu5;       //자동차손해보험 권리분석여부  
   private String crd_req_gu6;       //자동차손해보험 권리분석여부  
   
   private String crd_pri1;       //보증보험     
   private String crd_pri2;       //연대보증구상       
   private String crd_pri3;       //채권추심외주    
   private String crd_pri4;       //자동차손해보험       
   private String crd_pri5;       //자동차손해보험       
   private String crd_pri6;       //자동차손해보험       
   
   private String crd_etc1;       //보증보험 적요    
   private String crd_etc2;       //연대보증구상 적요
   private String crd_etc3;       //채권추심외주  적요
   private String crd_etc4;       //자동차손해보험 적요 
   private String crd_etc5;       //자동차손해보험 적요 
   private String crd_etc6;       //자동차손해보험 적요 
     
   private String guar_st;       //보증인 유무  
      
	// CONSTRCTOR            
    public CarCreditBean() {  
    	
   		this.rent_mng_id  = "";    
   		this.rent_l_cd  = "";    
   		this.gi_amt = 0;  
   		this.gi_c_amt = 0;  
   		this.gi_j_amt = 0;  
   		this.c_ins    = "";  
   		this.c_ins_d_nm    = "";   
   		this.c_ins_tel    = "";  
   		this.crd_reg_gu1   = ""; 
 		this.crd_reg_gu2   = ""; 
 		this.crd_reg_gu3   = ""; 
 		this.crd_reg_gu4   = ""; 
 		this.crd_reg_gu5   = ""; 
 		this.crd_reg_gu6   = "";   		
   		this.crd_remark1   = ""; 
   		this.crd_remark2   = ""; 
   		this.crd_remark3   = ""; 
   		this.crd_remark4   = ""; 
   		this.crd_remark5   = ""; 
   		this.crd_remark6   = "";   						   		
   		this.crd_id   = ""; 
   		this.crd_reason   = ""; 					
   		this.reg_dt  = ""; 
   		this.reg_id  = ""; 
   		this.upd_dt  = ""; 
   		this.upd_id  = ""; 
   		   		
   		this.crd_req_gu1   = ""; 
 		this.crd_req_gu2   = ""; 
 		this.crd_req_gu3   = ""; 
 		this.crd_req_gu4   = ""; 
 		this.crd_req_gu5   = ""; 
 		this.crd_req_gu6   = ""; 
 		
 		this.crd_etc1   = ""; 
 		this.crd_etc2   = ""; 
 		this.crd_etc3   = ""; 
 		this.crd_etc4   = ""; 
 		this.crd_etc5   = ""; 
 		this.crd_etc6  = ""; 
 		
 		this.crd_pri1   = ""; 
 		this.crd_pri2   = ""; 
 		this.crd_pri3   = ""; 
 		this.crd_pri4   = ""; 
 		this.crd_pri5   = ""; 
 		this.crd_pri6   = "";  		
 		
 		this.guar_st   = "";  		
 	   		
	}
	
	// set Method
	public void setRent_mng_id(String val){		if(val==null) val="";	this.rent_mng_id = val;	} 
	public void setRent_l_cd(String val){		if(val==null) val="";	this.rent_l_cd = val;	}      
	public void setGi_amt(int i){				this.gi_amt = i;	} 
	public void setGi_c_amt(int i){				this.gi_c_amt = i;	} 
	public void setGi_j_amt(int i){				this.gi_j_amt = i;	} 
	public void setC_ins(String val){			if(val==null) val="";	this.c_ins = val;	}    
	public void setC_ins_d_nm(String val){		if(val==null) val="";	this.c_ins_d_nm = val;	}
	public void setC_ins_tel(String val){		if(val==null) val="";	this.c_ins_tel = val;	}    
	public void setCrd_reg_gu1(String val){		if(val==null) val="";	this.crd_reg_gu1 = val;	}
	public void setCrd_reg_gu2(String val){		if(val==null) val="";	this.crd_reg_gu2 = val;	}
	public void setCrd_reg_gu3(String val){		if(val==null) val="";	this.crd_reg_gu3 = val;	}
	public void setCrd_reg_gu4(String val){		if(val==null) val="";	this.crd_reg_gu4 = val;	}
	public void setCrd_reg_gu5(String val){		if(val==null) val="";	this.crd_reg_gu5 = val;	}
	public void setCrd_reg_gu6(String val){		if(val==null) val="";	this.crd_reg_gu6 = val;	}
	public void setCrd_remark1(String val){		if(val==null) val="";	this.crd_remark1 = val;	} 
	public void setCrd_remark2(String val){		if(val==null) val="";	this.crd_remark2 = val;	} 
	public void setCrd_remark3(String val){		if(val==null) val="";	this.crd_remark3 = val;	} 
	public void setCrd_remark4(String val){		if(val==null) val="";	this.crd_remark4 = val;	} 
	public void setCrd_remark5(String val){		if(val==null) val="";	this.crd_remark5 = val;	} 
	public void setCrd_remark6(String val){		if(val==null) val="";	this.crd_remark6 = val;	} 
	public void setCrd_id(String val){			if(val==null) val="";	this.crd_id = val;	}  
	public void setCrd_reason(String val){		if(val==null) val="";	this.crd_reason = val;	}  
	public void setReg_dt(String val){			if(val==null) val="";	this.reg_dt = val;	}  
	public void setReg_id(String val){			if(val==null) val="";	this.reg_id = val;	}  
	public void setUpd_dt(String val){			if(val==null) val="";	this.upd_dt = val;	}  
	public void setUpd_id(String val){			if(val==null) val="";	this.upd_id = val;	}  
	
	public void setCrd_req_gu1(String val){		if(val==null) val="";	this.crd_req_gu1 = val;	}
	public void setCrd_req_gu2(String val){		if(val==null) val="";	this.crd_req_gu2 = val;	}
	public void setCrd_req_gu3(String val){		if(val==null) val="";	this.crd_req_gu3 = val;	}
	public void setCrd_req_gu4(String val){		if(val==null) val="";	this.crd_req_gu4 = val;	}
	public void setCrd_req_gu5(String val){		if(val==null) val="";	this.crd_req_gu5 = val;	}
	public void setCrd_req_gu6(String val){		if(val==null) val="";	this.crd_req_gu6 = val;	}
		
	public void setCrd_etc1(String val){		if(val==null) val="";	this.crd_etc1 = val;	}
	public void setCrd_etc2(String val){		if(val==null) val="";	this.crd_etc2 = val;	}
	public void setCrd_etc3(String val){		if(val==null) val="";	this.crd_etc3 = val;	}
	public void setCrd_etc4(String val){		if(val==null) val="";	this.crd_etc4 = val;	}
	public void setCrd_etc5(String val){		if(val==null) val="";	this.crd_etc5 = val;	}
	public void setCrd_etc6(String val){		if(val==null) val="";	this.crd_etc6 = val;	}
			
	public void setCrd_pri1(String val){		if(val==null) val="";	this.crd_pri1 = val;	}
	public void setCrd_pri2(String val){		if(val==null) val="";	this.crd_pri2 = val;	}
	public void setCrd_pri3(String val){		if(val==null) val="";	this.crd_pri3 = val;	}
	public void setCrd_pri4(String val){		if(val==null) val="";	this.crd_pri4 = val;	}		
	public void setCrd_pri5(String val){		if(val==null) val="";	this.crd_pri5 = val;	}		
	public void setCrd_pri6(String val){		if(val==null) val="";	this.crd_pri6 = val;	}		
	
	public void setGuar_st(String val){		if(val==null) val="";	this.guar_st = val;	}		
		
			
	//Get Method
	public String getRent_mng_id()  {			return rent_mng_id; } 
	public String getRent_l_cd() 	{			return rent_l_cd;	}      
	
	public int	  getGi_amt()		{			return	gi_amt;		} 
	public int	  getGi_c_amt()		{			return  gi_c_amt;	} 
	public int 	  getGi_j_amt()		{			return  gi_j_amt;	} 
	public String getC_ins()		{			return  c_ins;		}    
	public String getC_ins_d_nm()	{			return	c_ins_d_nm;	}
	public String getC_ins_tel()	{			return	c_ins_tel;	}    
	public String getCrd_reg_gu1()	{			return	crd_reg_gu1;	}
	public String getCrd_reg_gu2()	{			return	crd_reg_gu2;	}
	public String getCrd_reg_gu3()	{			return	crd_reg_gu3;	}
	public String getCrd_reg_gu4()	{			return	crd_reg_gu4;	}
	public String getCrd_reg_gu5()	{			return	crd_reg_gu5;	}
	public String getCrd_reg_gu6()	{			return	crd_reg_gu6;	}
	public String getCrd_remark1()	{			return	crd_remark1;	} 
	public String getCrd_remark2()	{			return	crd_remark2;	} 
	public String getCrd_remark3()	{			return	crd_remark3;	} 
	public String getCrd_remark4()	{			return	crd_remark4;	} 
	public String getCrd_remark5()	{			return	crd_remark5;	} 
	public String getCrd_remark6()	{			return	crd_remark6;	} 
	public String getCrd_id()		{			return	crd_id;	}  
	public String getCrd_reason()	{			return	crd_reason;	}  
	public String getReg_dt()		{			return reg_dt; }    
	public String getReg_id()		{			return reg_id; }    
	public String getUpd_dt()		{			return upd_dt; }    
	public String getUpd_id()		{			return upd_id; }    

	public String getCrd_req_gu1()	{			return	crd_req_gu1;	}
	public String getCrd_req_gu2()	{			return	crd_req_gu2;	}
	public String getCrd_req_gu3()	{			return	crd_req_gu3;	}
	public String getCrd_req_gu4()	{			return	crd_req_gu4;	}
	public String getCrd_req_gu5()	{			return	crd_req_gu5;	}
	public String getCrd_req_gu6()	{			return	crd_req_gu6;	}
		
	public String getCrd_etc1()	{			return	crd_etc1;	}
	public String getCrd_etc2()	{			return	crd_etc2;	}
	public String getCrd_etc3()	{			return	crd_etc3;	}
	public String getCrd_etc4()	{			return	crd_etc4;	}
	public String getCrd_etc5()	{			return	crd_etc5;	}
	public String getCrd_etc6()	{			return	crd_etc6;	}
	
	public String getCrd_pri1()	{			return	crd_pri1;	}
	public String getCrd_pri2()	{			return	crd_pri2;	}
	public String getCrd_pri3()	{			return	crd_pri3;	}
	public String getCrd_pri4()	{			return	crd_pri4;	}
	public String getCrd_pri5()	{			return	crd_pri5;	}
	public String getCrd_pri6()	{			return	crd_pri6;	}
	
	public String getGuar_st()	{			return	guar_st;	}
	
}
