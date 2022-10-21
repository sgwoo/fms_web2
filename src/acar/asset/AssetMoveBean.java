/**
 * �ڻ� ���� ����
 */
package acar.asset;
import java.util.*;

public class AssetMoveBean {

	//Table : ASSETMOVE
	
   private String asset_code;    //�ڻ��ڵ�
   private int	  assch_seri;     //����
   private String asset_name;    //�ڻ��
   private String acct_code;    //ȸ���ڻ��ڵ� 
   private String assch_date;   //������  
   private String assch_type;   //���汸��
   private String assch_rmk;  //����
   private int	  cap_amt;   //�����
   private String inter_yn;          
   private int 	  sale_quant;    //�Ű�����
   private int    sale_amt;    //�Ű��ݾ�
   private int    bookv_pd;   //�󰢴����
   
   private String car_mng_id;    //
   private String car_no;    //����ȣ
   private String car_nm;    //����
   
   private String comm_yn;    //��������ǥ
   private String sale_yn;    //�Ű���ǥ
   private String ven_code;    //vendor - �����
   private String client_id2;    //�ŸŻ�
   private String client_tax;    //��ǥ���� check

   private int    sh_car_amt;    //���� �ܰ�
   private int s_sup_amt;   // �Ű�(��������) ���ް�	  
   
   
	// CONSTRCTOR            
    public AssetMoveBean() {  
    	
   		this.asset_code  = "";    
   		this.assch_seri  	 = 0;
   		this.asset_name  = "";    
   		this.acct_code    = "";  
   		this.assch_date    = "";   
   		this.assch_type    = "";  
   		this.assch_rmk   = ""; 
   		this.cap_amt  	 = 0;
   		this.inter_yn    = "";  
   		this.sale_quant	 = 0;  
   		this.sale_amt	 = 0;    
   		this.bookv_pd = 0;  
   		
   		this.car_mng_id  = ""; 
   		this.car_no  = ""; 
   		this.car_nm  = ""; 
   		
   		this.comm_yn  = ""; 
   		this.sale_yn  = ""; 
   		
   		this.ven_code  = ""; 
   		this.client_id2  = ""; 
   		this.client_tax  = ""; 
   		
   		this.sh_car_amt	 = 0;  
   		this.s_sup_amt    = 0;
   		      
	}

	// set Method
	public void setAsset_code(String val){		if(val==null) val="";	this.asset_code = val;	} 
	public void setAssch_seri(int i){			this.assch_seri = i;	}
	public void setAsset_name(String val){		if(val==null) val="";	this.asset_name = val;	}      
	public void setAcct_code(String val){		if(val==null) val="";	this.acct_code = val;	}   
	public void setAssch_date(String val){		if(val==null) val="";	this.assch_date = val;	}
	public void setAssch_type(String val){		if(val==null) val="";	this.assch_type = val;	}
	public void setAssch_rmk(String val){		if(val==null) val="";	this.assch_rmk = val;	}    
	public void setCap_amt(int i){				this.cap_amt = i;	}
	public void setInter_yn(String val){		if(val==null) val="";	this.inter_yn = val;	}  
	public void setSale_quant(int i){			this.sale_quant = i;	} 
	public void setSale_amt(int i){				this.sale_amt = i;	} 
	public void setBookv_pd(int i){				this.bookv_pd = i;	}    
	
	public void setCar_mng_id(String val){		if(val==null) val="";	this.car_mng_id = val;	} 
	public void setCar_no(String val){		if(val==null) val="";	this.car_no = val;	}  
	public void setCar_nm(String val){		if(val==null) val="";	this.car_nm = val;	}  
	
	public void setComm_yn(String val){		if(val==null) val="";	this.comm_yn = val;	}  
	public void setSale_yn(String val){		if(val==null) val="";	this.sale_yn = val;	}  
	
	public void setVen_code(String val){		if(val==null) val="";	this.ven_code = val;	}  
	public void setClient_id2(String val){		if(val==null) val="";	this.client_id2 = val;	}  
	public void setClient_tax(String val){		if(val==null) val="";	this.client_tax = val;	}  
	public void setSh_car_amt(int i){			this.sh_car_amt = i;	}
         public void setS_sup_amt(int i){			this.s_sup_amt = i;	}
	
	//Get Method
	public String getAsset_code() {			return asset_code; } 
	public int 	  getAssch_seri() {			return assch_seri; }      
	public String getAsset_name() {			return asset_name; }      
	public String getAcct_code()  {			return acct_code; }     
	public String getAssch_date() {			return assch_date; }     
	public String getAssch_type() {			return assch_type; }    
	public String getAssch_rmk()  {			return assch_rmk; }     
	public int 	  getCap_amt()    {			return cap_amt; }   
	public String getInter_yn(){			return inter_yn; }   
	public int	  getSale_quant() {			return sale_quant; }    
	public int	  getSale_amt()	  {			return sale_amt; }    
	public int    getBookv_pd()   {			return bookv_pd; }    
	
	public String getCar_mng_id() {			return car_mng_id; } 
	public String getCar_no()	  {			return car_no; } 	
	public String getCar_nm()	  {			return car_nm; } 	
	
	public String getComm_yn()	  {			return comm_yn; } 	
	public String getSale_yn()	  {			return sale_yn; } 	   
	
	public String getVen_code()	  {			return ven_code; } 	   
	public String getClient_id2()	  {			return client_id2; } 	  
	public String getClient_tax()	  {			return client_tax; } 	  
	
	public int	  getSh_car_amt()	  {			return sh_car_amt; }     
	public int       getS_sup_amt()   {			return s_sup_amt; }    
 
}
