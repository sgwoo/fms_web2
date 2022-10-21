/**
 * ���� ����
 */
package acar.asset;
import java.util.*;

public class YassetDepBean {

	//Table : YASSETDEP
	
   private String asset_code;    //�ڻ��ڵ�
   private String gisu;    //�� (���)
   private String dep_type;    // �� ���� 2:���� 4:�Ϸ�
   private int	  get_amt;     //   ����
   private int	  book_dr;     // ��� ���� 
   private int	  book_cr;     // ��� ����
   private int	  jun_reser;     //  ���⸻ ���� �󰢾�
   private int	  jun_qdep;     // 
   private int	  dep_amt;     // ��� �󰢾�
   private int	  sdep_amt;     // Ư�� �󰢾�
   private int	  dep_edit;     // �� �󰢺�
   private int	  sdep_edit;     // Ư�� �󰢺�
   private int	  qdep_amt;     // 
   private int	  reser_dr;     // ��� ����� ����
   private int	  reser_cr;     // ��� ����� ����
   private String insert_id;     // ������
   private String insert_date;    //������
   private String modify_id;    //������ 
   private String modify_date;   //������  
   

	// CONSTRCTOR            
    public YassetDepBean() {  
    	
   		this.asset_code  = "";   
   		this.gisu 		 = "";   
   		this.dep_type  	 = "";   
   		this.get_amt  	 = 0;
   		this.book_dr  	 = 0;
   		this.book_cr  	 = 0;
   		this.jun_reser   = 0;
   		this.jun_qdep  	 = 0;
   		this.dep_amt  	 = 0;
   		this.sdep_amt  	 = 0;
   		this.dep_edit  	 = 0;
   		this.sdep_edit   = 0;
   		this.qdep_amt  	 = 0;
   		this.reser_dr  	 = 0;
   		this.reser_cr  	 = 0;
   		this.insert_id	 = "";    
   		this.insert_date = "";  
   		this.modify_id   = "";   
   		this.modify_date = "";  
   	   		      
	}

	// set Method
	public void setAsset_code(String val){		if(val==null) val="";	this.asset_code = val;	} 
	public void setGisu(String val){			if(val==null) val="";	this.gisu = val;	} 
	public void setDep_type(String val){		if(val==null) val="";	this.dep_type = val;	} 
	public void setGet_amt(int i){				this.get_amt = i;	}
	public void setBook_dr(int i){				this.book_dr = i;	}
	public void setBook_cr(int i){				this.book_cr = i;	}
	public void setJun_reser(int i){			this.jun_reser = i;	}
	public void setJun_qdep(int i){				this.jun_qdep = i;	}
	public void setDep_amt(int i){				this.dep_amt = i;	}
	public void setSdep_amt(int i){				this.sdep_amt = i;	}    
	public void setDep_edit(int i){				this.dep_edit = i;	}
	public void setSdep_edit(int i){			this.sdep_edit = i;	}
	public void setQdep_amt(int i){				this.qdep_amt = i;	}
	public void setReser_dr(int i){				this.reser_dr = i;	}
	public void setReser_cr(int i){				this.reser_cr = i;	}
	public void setInsert_id(String val){		if(val==null) val="";	this.insert_id = val;	}   
	public void setInsert_date(String val){		if(val==null) val="";	this.insert_date = val;	}
	public void setModify_id(String val){		if(val==null) val="";	this.modify_id = val;	}
	public void setModify_date(String val){		if(val==null) val="";	this.modify_date = val;	}    

	
	//Get Method
	public String getAsset_code() {			return asset_code; } 
	public String getGisu() {				return gisu; } 
	public String getDep_type() {			return dep_type; } 
	public int 	  getGet_amt() {			return get_amt; }   
	public int 	  getBook_dr() {			return book_dr; }   
	public int 	  getBook_cr() {			return book_cr; }   
	public int 	  getJun_reser() {			return jun_reser; }   
	public int 	  getJun_qdep() {			return jun_qdep; }   
	public int 	  getDep_amt() {			return dep_amt; }   
	public int 	  getSdep_amt() {			return sdep_amt; }   
	public int 	  getDep_edit() {			return dep_edit; }   
	public int 	  getSdep_edit() {			return sdep_edit; }   
	public int 	  getQdep_amt() {			return qdep_amt; }   
	public int 	  getReser_dr() {			return reser_dr; }   
	public int 	  getReser_cr() {			return reser_cr; }   
	public String getInsert_id() {			return insert_id; }      
	public String getInsert_date()  {		return insert_date; }     
	public String getModify_id() {			return modify_id; }     
	public String getModify_date() {		return modify_date; }    

}
