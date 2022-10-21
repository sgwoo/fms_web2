/**
 * 월상각 관리
 */
package acar.asset;
import java.util.*;

public class AssetDepBean {

	//Table : ASSETDEP
	
   private String asset_code;    //자산코드
   private String asset_mm;    //월
   private String gisu;    //년 (기수)
   private int	  book_mdr;     //   
   private int	  book_mcr;     // 
   private int	  dep_mamt;     // 
   private int	  sdep_mamt;     // 
   private String acct_date;     // 
   private int	  reser_mdr;     //  
   private int	  reser_mcr;     // 
   private String insert_id;     // 생성자
   private String insert_date;    //생성일
   private String modify_id;    //수정자 
   private String modify_date;   //수정일  
   

	// CONSTRCTOR            
    public AssetDepBean() {  
    	
   		this.asset_code  = "";   
   		this.asset_mm  = "";   
   		this.gisu  = "";   
   		this.book_mdr  	 = 0;
   		this.book_mcr  	 = 0;
   		this.dep_mamt  	 = 0;
   		this.sdep_mamt   = 0;
   		this.acct_date   = "";
   		this.reser_mdr   = 0;
   		this.reser_mcr   = 0;
   		this.insert_id	  = "";    
   		this.insert_date  = "";  
   		this.modify_id    = "";   
   		this.modify_date  = "";  
   	   		      
	}

	// set Method
	public void setAsset_code(String val){		if(val==null) val="";	this.asset_code = val;	} 
	public void setAsset_mm(String val){		if(val==null) val="";	this.asset_mm = val;	} 
	public void setGisu(String val){			if(val==null) val="";	this.gisu = val;	} 
	public void setBook_mdr(int i){				this.book_mdr = i;	}
	public void setBook_mcr(int i){				this.book_mcr = i;	}
	public void setDep_mamt(int i){				this.dep_mamt = i;	}
	public void setSdep_mamt(int i){			this.sdep_mamt = i;	}
	public void setAcct_date(String val){		if(val==null) val="";	this.acct_date = val;	}    
	public void setReser_mdr(int i){			this.reser_mdr = i;	}
	public void setReser_mcr(int i){			this.reser_mcr = i;	}  
	public void setInsert_id(String val){		if(val==null) val="";	this.insert_id = val;	}   
	public void setInsert_date(String val){		if(val==null) val="";	this.insert_date = val;	}
	public void setModify_id(String val){		if(val==null) val="";	this.modify_id = val;	}
	public void setModify_date(String val){		if(val==null) val="";	this.modify_date = val;	}    

	
	//Get Method
	public String getAsset_code() {			return asset_code; } 
	public String getAsset_mm() {			return asset_mm; } 
	public String getGisu() {				return gisu; } 
	public int 	  getBook_mdr() {			return book_mdr; }   
	public int 	  getBook_mcr() {			return book_mcr; }   
	public int 	  getDep_mamt() {			return dep_mamt; }   
	public int 	  getSdep_mamt() {			return sdep_mamt; }   
	public String getAcct_date() {			return acct_date; }   
	public int 	  getReser_mdr() {			return reser_mdr; }   
	public int 	  getReser_mcr() {			return reser_mcr; }   
	public String getInsert_id() {			return insert_id; }      
	public String getInsert_date()  {		return insert_date; }     
	public String getModify_id() {			return modify_id; }     
	public String getModify_date() {		return modify_date; }    

}
