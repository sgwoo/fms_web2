/**
 * KCP 결재시스템
 */
package acar.ars_card;

import java.util.*;

public class ArsCardBean {

    //Table : ars_card	
	private String ars_code     ;
	private String client_id    ;
	private String reg_dt       ;
	private String reg_id       ;
	private String buyr_name    ;
	private String buyr_tel2    ;
	private String buyr_mail    ;
	private String good_name    ;
	private String good_cont    ;
	private int    good_mny     ;
	private String card_kind    ;
	private String card_no      ;
	private String card_y_mm    ;
	private String card_y_yy    ;
	private String quota        ;
	private String app_id       ;
	private String app_dt       ;
	private String app_st       ;
	private int    settle_mny   ;
	private int    card_fee     ;
	private String exempt_yn    ;
	private String exempt_cau   ;
	private String ars_content  ;
	private String card_per     ;
	private String ars_step     ;
	private int    settle_mny_1 ;
	private int    settle_mny_2 ;
	private int    m_card_fee   ;
	private String bus_nm       ;
	private String mng_nm       ;
	private String req_resultmsg;
	private String cancel_dt    ;

    // CONSTRCTOR            
    public ArsCardBean() {  
		this.ars_code     = ""; 					
		this.client_id    = "";
		this.reg_dt       = "";
		this.reg_id       = "";
		this.buyr_name    = "";
		this.buyr_tel2    = "";
		this.buyr_mail    = "";
		this.good_name    = "";
		this.good_cont    = "";
		this.good_mny     = 0;
		this.card_kind    = "";
		this.card_no      = "";
		this.card_y_mm    = "";
		this.card_y_yy    = "";
		this.quota        = "";
		this.app_id       = ""; 					
		this.app_dt       = "";
		this.app_st       = "";
		this.settle_mny   = 0;
		this.card_fee     = 0;
		this.exempt_yn    = ""; 					
		this.exempt_cau   = "";
		this.ars_content  = "";
		this.card_per     = "";
		this.ars_step     = "";
		this.settle_mny_1 = 0;
		this.settle_mny_2 = 0;
		this.m_card_fee   = 0;
		this.bus_nm       = "";
		this.mng_nm       = "";
		this.req_resultmsg= "";
		this.cancel_dt    = "";
	}

	// get Method
	public void setArs_code     (String val){		if(val==null) val="";	this.ars_code     = val;	}
	public void setClient_id    (String val){		if(val==null) val="";	this.client_id    = val;	}
	public void setReg_dt       (String val){		if(val==null) val="";	this.reg_dt       = val;	}
	public void setReg_id       (String val){		if(val==null) val="";	this.reg_id       = val;	}	
	public void setBuyr_name    (String val){		if(val==null) val="";	this.buyr_name    = val;	}	
	public void setBuyr_tel2    (String val){		if(val==null) val="";	this.buyr_tel2    = val;	}	
	public void setBuyr_mail    (String val){		if(val==null) val="";	this.buyr_mail    = val;	}
	public void setGood_name    (String val){		if(val==null) val="";	this.good_name    = val;	}	
	public void setGood_cont    (String val){		if(val==null) val="";	this.good_cont    = val;	}	
	public void setGood_mny     (int val)   {			                    this.good_mny     = val;	}	
	public void setCard_kind    (String val){		if(val==null) val="";	this.card_kind    = val;	}	
	public void setCard_no      (String val){		if(val==null) val="";	this.card_no      = val;	}	
	public void setCard_y_mm    (String val){		if(val==null) val="";	this.card_y_mm    = val;	}
	public void setCard_y_yy    (String val){		if(val==null) val="";	this.card_y_yy    = val;	}
	public void setQuota        (String val){		if(val==null) val="";	this.quota        = val;	}
	public void setApp_id       (String val){		if(val==null) val="";	this.app_id       = val;	}	
	public void setApp_dt       (String val){		if(val==null) val="";	this.app_dt       = val;	}	
	public void setApp_st       (String val){		if(val==null) val="";	this.app_st       = val;	}	
	public void setSettle_mny   (int val)   {			                    this.settle_mny   = val;	}	
	public void setCard_fee     (int val)   {			                    this.card_fee     = val;	}
	public void setExempt_yn    (String val){		if(val==null) val="";	this.exempt_yn    = val;	}	
	public void setExempt_cau   (String val){		if(val==null) val="";	this.exempt_cau   = val;	}	
	public void setArs_content  (String val){		if(val==null) val="";	this.ars_content  = val;	}
	public void setCard_per     (String val){		if(val==null) val="";	this.card_per     = val;	}
	public void setArs_step     (String val){		if(val==null) val="";	this.ars_step     = val;	}
	public void setSettle_mny_1 (int val)   {			                    this.settle_mny_1 = val;	}
	public void setSettle_mny_2 (int val)   {			                    this.settle_mny_2 = val;	}
	public void setM_card_fee   (int val)   {			                    this.m_card_fee   = val;	}
	public void setBus_nm       (String val){		if(val==null) val="";	this.bus_nm       = val;	}
	public void setMng_nm       (String val){		if(val==null) val="";	this.mng_nm       = val;	}
	public void setReq_resultmsg(String val){		if(val==null) val="";	this.req_resultmsg= val;	}
	public void setCancel_dt    (String val){		if(val==null) val="";	this.cancel_dt    = val;	}

	//Get Method
	public String getArs_code     (){		return ars_code     ;}
	public String getClient_id    (){		return client_id    ;}
	public String getReg_dt       (){		return reg_dt       ;}
	public String getReg_id       (){		return reg_id       ;}	
	public String getBuyr_name    (){		return buyr_name    ;}	
	public String getBuyr_tel2    (){		return buyr_tel2    ;}	
	public String getBuyr_mail    (){		return buyr_mail    ;}
	public String getGood_name    (){		return good_name    ;}	
	public String getGood_cont    (){		return good_cont    ;}	
	public int    getGood_mny     (){		return good_mny     ;}	
	public String getCard_kind    (){		return card_kind    ;}	
	public String getCard_no      (){		return card_no      ;}	
	public String getCard_y_mm    (){		return card_y_mm    ;}
	public String getCard_y_yy    (){		return card_y_yy    ;}
	public String getQuota        (){		return quota        ;}
	public String getApp_id       (){		return app_id       ;}	
	public String getApp_dt       (){		return app_dt       ;}	
	public String getApp_st       (){		return app_st       ;}	
	public int    getSettle_mny   (){		return settle_mny   ;}	
	public int    getCard_fee     (){		return card_fee     ;}	
	public String getExempt_yn    (){		return exempt_yn    ;}	
	public String getExempt_cau   (){		return exempt_cau   ;}	
	public String getArs_content  (){		return ars_content  ;}	
	public String getCard_per     (){		return card_per     ;}
	public String getArs_step     (){		return ars_step     ;}
	public int    getSettle_mny_1 (){		return settle_mny_1 ;}
	public int    getSettle_mny_2 (){		return settle_mny_2 ;}
	public int    getM_card_fee   (){		return m_card_fee   ;}
	public String getBus_nm       (){		return bus_nm       ;}
	public String getMng_nm       (){		return mng_nm       ;}
	public String getReq_resultmsg(){		return req_resultmsg;}
	public String getCancel_dt    (){		return cancel_dt    ;}


}	