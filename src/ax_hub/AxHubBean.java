/**
 * KCP 결재시스템
 */
package ax_hub;

import java.util.*;

public class AxHubBean {

    //Table : ax_hub
	
	//결제요청
	private String req_tx       ; 					
	private String ordr_idxx    ;
	private String pay_method   ; 
	private String good_name    ;
	private int    good_mny     ;
	private String buyr_name    ;
	private String buyr_tel1    ;
	private String buyr_tel2    ;
	private String buyr_mail    ;
	private String tax_flag     ;
	private int    comm_tax_mny ;
	private int    comm_fee_mny ;
	private int    comm_vat_mny ;
	private String good_cd      ;
	private String good_expr    ;

	//결제결과
	private String tno          ; 					
	private int    amount       ;
	private String card_cd      ;
	private String card_name    ;
	private String app_time     ;
	private String app_no       ;
	private String card_no      ;
	private String noinf        ;
	private String quota        ;

	//아마존카정보
	private String am_ax_code   ;
	private String am_good_st   ;
	private String am_good_id1  ;	
	private String am_good_id2  ;
	private int    am_good_s_amt;
	private int    am_good_v_amt;
	private int    am_good_m_amt;
	private int    am_good_amt;
	private String reg_dt       ;
	private String reg_id       ;
	private String am_card_kind ;
	private String am_card_sign ;
	private String am_card_rel  ;
	private String am_m_tel		;


    // CONSTRCTOR            
    public AxHubBean() {  
		this.req_tx			= ""; 					
		this.ordr_idxx		= "";
		this.pay_method		= "";
		this.good_name		= "";
		this.good_mny		= 0;
		this.buyr_name		= "";
		this.buyr_tel1		= "";
		this.buyr_tel2		= "";
		this.buyr_mail		= "";
		this.tax_flag		= "";
		this.comm_tax_mny	= 0;
		this.comm_fee_mny	= 0;
		this.comm_vat_mny	= 0;
		this.good_cd		= "";
		this.good_expr		= "";
		this.tno			= ""; 					
		this.amount			= 0;
		this.card_cd		= "";
		this.card_name		= "";
		this.app_time		= "";
		this.app_no			= "";
		this.card_no		= "";
		this.noinf			= "";
		this.quota			= "";
		this.am_ax_code		= "";
		this.am_good_st		= "";
		this.am_good_id1	= "";
		this.am_good_id2	= "";
		this.am_good_s_amt	= 0;
		this.am_good_v_amt	= 0;
		this.am_good_m_amt	= 0;
		this.am_good_amt	= 0;
		this.reg_dt			= "";
		this.reg_id			= "";
		this.am_card_kind	= "";
		this.am_card_sign	= "";
		this.am_card_rel	= "";
		this.am_m_tel		= "";
	}

	// get Method
	public void setReq_tx			(String val){		if(val==null) val="";	this.req_tx			= val;	}
	public void setOrdr_idxx		(String val){		if(val==null) val="";	this.ordr_idxx		= val;	}
	public void setPay_method		(String val){		if(val==null) val="";	this.pay_method		= val;	}
	public void setGood_name		(String val){		if(val==null) val="";	this.good_name		= val;	}	
	public void setGood_mny			(int val)   {			                    this.good_mny		= val;	}	
	public void setBuyr_name		(String val){		if(val==null) val="";	this.buyr_name		= val;	}	
	public void setBuyr_tel1		(String val){		if(val==null) val="";	this.buyr_tel1		= val;	}	
	public void setBuyr_tel2		(String val){		if(val==null) val="";	this.buyr_tel2		= val;	}
	public void setBuyr_mail		(String val){		if(val==null) val="";	this.buyr_mail		= val;	}	
	public void setTax_flag			(String val){		if(val==null) val="";	this.tax_flag		= val;	}	
	public void setComm_tax_mny		(int val)   {			                    this.comm_tax_mny	= val;	}	
	public void setComm_fee_mny		(int val)   {			                    this.comm_fee_mny	= val;	}	
	public void setComm_vat_mny		(int val)   {			                    this.comm_vat_mny	= val;	}	
	public void setGood_cd			(String val){		if(val==null) val="";	this.good_cd		= val;	}	
	public void setGood_expr		(String val){		if(val==null) val="";	this.good_expr		= val;	}	
	public void setTno				(String val){		if(val==null) val="";	this.tno			= val;	}
	public void setAmount			(int val)   {			                    this.amount			= val;	}	
	public void setCard_cd			(String val){		if(val==null) val="";	this.card_cd		= val;	}
	public void setCard_name		(String val){		if(val==null) val="";	this.card_name		= val;	}
	public void setApp_time			(String val){		if(val==null) val="";	this.app_time		= val;	}	
	public void setApp_no			(String val){		if(val==null) val="";	this.app_no			= val;	}	
	public void setCard_no			(String val){		if(val==null) val="";	this.card_no		= val;	}	
	public void setNoinf			(String val){		if(val==null) val="";	this.noinf			= val;	}
	public void setQuota			(String val){		if(val==null) val="";	this.quota			= val;	}	
	public void setAm_ax_code		(String val){		if(val==null) val="";	this.am_ax_code		= val;	}
	public void setAm_good_st		(String val){		if(val==null) val="";	this.am_good_st		= val;	}
	public void setAm_good_id1		(String val){		if(val==null) val="";	this.am_good_id1	= val;	}	
	public void setAm_good_id2		(String val){		if(val==null) val="";	this.am_good_id2	= val;	}
	public void setAm_good_s_amt	(int val)   {			                    this.am_good_s_amt	= val;	}	
	public void setAm_good_v_amt	(int val)   {			                    this.am_good_v_amt	= val;	}	
	public void setAm_good_m_amt	(int val)   {			                    this.am_good_m_amt	= val;	}	
	public void setAm_good_amt		(int val)   {			                    this.am_good_amt	= val;	}	
	public void setReg_dt			(String val){		if(val==null) val="";	this.reg_dt			= val;	}	
	public void setReg_id			(String val){		if(val==null) val="";	this.reg_id			= val;	}	
	public void setAm_card_kind		(String val){		if(val==null) val="";	this.am_card_kind	= val;	}
	public void setAm_card_sign		(String val){		if(val==null) val="";	this.am_card_sign	= val;	}	
	public void setAm_card_rel		(String val){		if(val==null) val="";	this.am_card_rel	= val;	}
	public void setAm_m_tel 		(String val){		if(val==null) val="";	this.am_m_tel		= val;	}


	//Get Method
	public String getReq_tx			(){		return req_tx       ;}
	public String getOrdr_idxx		(){		return ordr_idxx    ;}
	public String getPay_method		(){		return pay_method   ;}
	public String getGood_name		(){		return good_name    ;}	
	public int    getGood_mny		(){		return good_mny     ;}	
	public String getBuyr_name		(){		return buyr_name    ;}	
	public String getBuyr_tel1		(){		return buyr_tel1    ;}	
	public String getBuyr_tel2		(){		return buyr_tel2    ;}
	public String getBuyr_mail		(){		return buyr_mail    ;}	
	public String getTax_flag		(){		return tax_flag     ;}	
	public int    getComm_tax_mny	(){		return comm_tax_mny ;}	
	public int    getComm_fee_mny	(){		return comm_fee_mny ;}	
	public int    getComm_vat_mny	(){		return comm_vat_mny ;}	
	public String getGood_cd		(){		return good_cd      ;}	
	public String getGood_expr		(){		return good_expr    ;}	
	public String getTno			(){		return tno			;}
	public int    getAmount			(){		return amount		;}	
	public String getCard_cd		(){		return card_cd		;}
	public String getCard_name		(){		return card_name	;}
	public String getApp_time		(){		return app_time		;}	
	public String getApp_no			(){		return app_no		;}	
	public String getCard_no		(){		return card_no		;}	
	public String getNoinf			(){		return noinf		;}
	public String getQuota			(){		return quota		;}	
	public String getAm_ax_code		(){		return am_ax_code   ;}
	public String getAm_good_st		(){		return am_good_st   ;}
	public String getAm_good_id1	(){		return am_good_id1  ;}	
	public String getAm_good_id2	(){		return am_good_id2  ;}
	public int    getAm_good_s_amt	(){		return am_good_s_amt;}	
	public int    getAm_good_v_amt	(){		return am_good_v_amt;}	
	public int    getAm_good_m_amt	(){		return am_good_m_amt;}	
	public int    getAm_good_amt	(){		return am_good_amt  ;}	
	public String getReg_dt			(){		return reg_dt       ;}		
	public String getReg_id			(){		return reg_id       ;}		
	public String getAm_card_kind	(){		return am_card_kind	;}
	public String getAm_card_sign	(){		return am_card_sign	;}	
	public String getAm_card_rel	(){		return am_card_rel	;}
	public String getAm_m_tel		(){		return am_m_tel		;}


}												