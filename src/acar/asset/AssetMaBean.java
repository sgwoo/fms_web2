/**
 * 자산 Master 관리
 */
package acar.asset;
import java.util.*;

public class AssetMaBean {

	//Table : ASSETMA
	
   private String asset_code;    //자산코드
   private String asset_name;    //자산명
   private String gettm_gu;  
   private String ven_name;   //구입처
   private String get_date;  //취득일
   private String get_gubun; //취득형태
   private int	  guant;                   //수량
   private int 	  get_amt;    //취득가액 
   private float  life_exist;   //내용연수
   private float  ndepre_rate;   //상각율
   private String sdepre_type;
   private float  sdepre_rate;  //특별상각율
   private String depr_method;  //상각율
   private String depre_fyy;
   private String rdepr_syy;
   private int    rdepr_term;
   private String deprf_yn; //상각완료여부
   private int    jun_reser;  //전기말 상각누계액
   private int    jun_qdep;
   private String gasset_code;  //상각비계정코드
   private String insert_id;    //입력자
   private String insert_date;
   private String modify_id;  //수정자
   private String modify_date;  
   private String car_use;    //1:리스 2:렌트 
   private String car_mng_id;    // 
   private String acct_code;    //회계자산코드 
   private String car_no;     //자동차번호 
   private String first_car_no;    //최초등록번호 
   private String gisu;   //회계기수
   private String pay_st;   //특소세 과세여부
   private String ma_chk;   //차량대금 별도 등록
   private String dlv_dt;   //출고일(최초차량등록일)
 

	// CONSTRCTOR            
    public AssetMaBean() {  
    	
   		this.asset_code  = "";    
   		this.asset_name  = "";    
   		this.gettm_gu    = "";  
   		this.ven_name    = "";   
   		this.get_date    = "";  
   		this.get_gubun   = ""; 
   		this.guant  	 = 0;
   		this.get_amt	 = 0;    	
   		this.life_exist    = 0;
   		this.ndepre_rate = 0;  
   		this.sdepre_type = "";
   		this.sdepre_rate = 0;  
   		this.depr_method = "";  
   		this.depre_fyy   = "";
   		this.rdepr_syy   = "";
   		this.rdepr_term  = 0;
   		this.deprf_yn    = ""; 
   		this.jun_reser   = 0;  
   		this.jun_qdep    = 0;
   		this.gasset_code = ""; 
   		this.insert_id   = "";   
   		this.insert_date = "";
   		this.modify_id   = "";  
   		this.modify_date = "";  
   		this.car_use 	 = "";
   		this.car_mng_id  = "";
   		this.acct_code  = "";
   		this.car_no  = "";
   		this.first_car_no  = "";
   		this.gisu = "";
   		this.pay_st = "";
   		this.ma_chk = "";
   		this.dlv_dt = "";
   		
      
	}

	// set Method
	
	public void setAsset_code(String val){		if(val==null) val="";	this.asset_code = val;	} 
	public void setAsset_name(String val){		if(val==null) val="";	this.asset_name = val;	}      
	public void setGettm_gu(String val){		if(val==null) val="";	this.gettm_gu = val;	}   
	public void setVen_name(String val){		if(val==null) val="";	this.ven_name = val;	}
	public void setGet_date(String val){		if(val==null) val="";	this.get_date = val;	}
	public void setGet_gubun(String val){		if(val==null) val="";	this.get_gubun = val;	}    
	public void setGuant(int i){				this.guant = i;	}
	public void setGet_amt(int i){				this.get_amt = i;	} 	
	public void setLife_exist(float i){		this.life_exist = i;	}  
	public void setNdepre_rate(float i){		this.ndepre_rate = i;	}  
	public void setSdepre_type(String val){		if(val==null) val="";	this.sdepre_type = val;	}  
	public void setSdepre_rate(float i){		this.sdepre_rate = i;	}
	public void setDepr_method(String val){		if(val==null) val="";	this.depr_method = val;	}
	public void setDepre_fyy(String val){		if(val==null) val="";	this.depre_fyy = val;	} 
	public void setRdepr_syy(String val){		if(val==null) val="";	this.rdepr_syy = val;	} 
	public void setRdepr_term(int i){			this.rdepr_term = i;	} 
	public void setDeprf_yn(String val){		if(val==null) val="";	this.deprf_yn = val;	}
	public void setJun_reser(int i){			this.jun_reser = i;	}
	public void setJun_qdep(int i){				this.jun_qdep = i;	}
	public void setGasset_code(String val){		if(val==null) val="";	this.gasset_code = val;	} 
	public void setInsert_id(String val){		if(val==null) val="";	this.insert_id = val;	}      
	public void setInsert_date(String val){		if(val==null) val="";	this.insert_date = val;	} 
	public void setModify_id(String val){		if(val==null) val="";	this.modify_id = val;	}
	public void setModify_date(String val){		if(val==null) val="";	this.modify_date = val;	}
	public void setCar_use(String val){			if(val==null) val="";	this.car_use = val;	}
	public void setCar_mng_id(String val){		if(val==null) val="";	this.car_mng_id = val;	}
	public void setAcct_code(String val){		if(val==null) val="";	this.acct_code = val;	}
	public void setCar_no(String val){			if(val==null) val="";	this.car_no = val;	}
	public void setFirst_car_no(String val){	if(val==null) val="";	this.first_car_no = val;	}
	public void setGisu(String val){			if(val==null) val="";	this.gisu = val;	}
	public void setPay_st(String val){			if(val==null) val="";	this.pay_st = val;	}
	public void setMa_chk(String val){			if(val==null) val="";	this.ma_chk = val;	}
	public void setDlv_dt(String val){			if(val==null) val="";	this.dlv_dt = val;	}
	       
	
	//Get Method
	public String getAsset_code() {			return asset_code; }    
	public String getAsset_name() {			return asset_name; }      
	public String getGettm_gu()   {			return gettm_gu; }     
	public String getVen_name()   {			return ven_name; }     
	public String getGet_date()   {			return get_date; }    
	public String getGet_gubun()  {			return get_gubun; }     
	public int 	  getGuant()  	  {			return guant; }    
	public int	  getGet_amt()	  {			return get_amt; }    	
	public float  getLife_exist()	{		return life_exist; }
	public float  getNdepre_rate(){			return ndepre_rate; }    
	public String getSdepre_type(){			return sdepre_type; }    
	public float  getSdepre_rate(){			return sdepre_rate; }    
	public String getDepr_method(){			return depr_method; }    
	public String getDepre_fyy()  {			return depre_fyy; }    
	public String getRdepr_syy()  {			return rdepr_syy; }    
	public int	  getRdepr_term() {			return rdepr_term; }    
	public String getDeprf_yn()   {			return deprf_yn; }    
	public int    getJun_reser()  {			return jun_reser; }    
	public int 	  getJun_qdep()   {			return jun_qdep; }    
	public String getGasset_code(){			return gasset_code; }    
	public String getInsert_id()  {			return insert_id; }      
	public String getInsert_date(){			return insert_date; }    
	public String getModify_id()  {			return modify_id; }    
	public String getModify_date(){			return modify_date; }    
	public String getCar_use(){				return car_use; }  
	public String getCar_mng_id(){			return car_mng_id; }  
	public String getAcct_code(){			return acct_code; }  
	public String getCar_no(){				return car_no; }  
	public String getFirst_car_no(){		return first_car_no; }  
	public String getGisu(){				return gisu; }  
	public String getPay_st(){				return pay_st; }  
	public String getMa_chk(){			return ma_chk; }  
	public String getDlv_dt(){			return dlv_dt; }  
	 
}
