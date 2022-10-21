/**
 * 견적서관리
 */
package acar.estimate_mng;

import java.util.*;


public class EstiSpeBean {
    //Table : ESTI_SPE
    private String est_id;		//견적번호(년도2자리+월2자리+구분(f=fms,w=web,s=special)1자리+일련번호4자리)
    private String est_st;		//고객구분
	private String est_nm;		//고객/상호명
    private String est_ssn;		//주민/사업자등록번호
    private String est_agnt;	//담당자
    private String est_tel;		//연락처
    private String est_bus;		//업종
    private String est_year;	//업력
    private String car_nm;		//희망차종
    private String etc;			//기타
    private String reg_dt;		//등록일
	private String est_area;	//사업지역
    private String est_fax;		//팩스
    private String car_nm2;		//희망차종2
    private String car_nm3;		//희망차종3
	private	String reg_id;		//작성자 - 고객상담요청 
	private String est_email;	//이메일
	private String client_yn;	//기존고객여부

	private String m_user_id;	//전화상담자
	private String m_reg_dt;	//전화상담일
	private String rent_yn;		//계약체결여부
	private String est_gubun;	//상담구분
    private String t_user_id;	//전화통화자
    private String t_reg_dt;	//전화통화일
    private String t_note;	 
    private String b_note;		//통화가 이루어지지 않은 경우
    private String b_reg_dt;	//통화가 이루어지지 않은 경우
	private String county;		//기존고객여부
	
	//201610 홈페이지 리뉴얼 : 상담요청 및 차량예약 보완
	private String zipcode;		//우편번호
	private String addr1;		//주소1
	private String addr2;		//주소2
	private String account;		//계좌번호
    private String bank;		//은행
	private String driver_year;	//개인-운전경력
    private String urgen_tel;	//유선번호
	//20170412
    private String est_comp_ceo;	//대표자명
    private String est_comp_tel;	//회사연락처
    private String est_comp_cel;	//대표자연락처
    //20180313
    private String car_use_addr1;	//차량이용지 주소1
    private String car_use_addr2;	//차량이용지 주소2
    
    private String br_to;
    private String br_to_st;
    private String br_from;
	private String br_from_st;


    // CONSTRCTOR            
    public EstiSpeBean() {  
    	this.est_id			= "";
    	this.est_st			= "";
	    this.est_nm			= "";
	    this.est_ssn		= "";
	    this.est_tel		= "";
	    this.est_fax		= "";
	    this.est_agnt		= "";
	    this.est_bus		= "";
	    this.est_year		= "";
	    this.car_nm			= "";
	    this.etc			= "";
	    this.reg_dt			= "";
		this.m_user_id		= "";
		this.m_reg_dt		= "";
		this.rent_yn		= "";
		this.est_area		= "";
		this.est_gubun		= "";
	    this.car_nm2		= "";
	    this.car_nm3		= "";
	    this.reg_id			= "";
	    this.t_user_id		= "";
		this.t_reg_dt		= "";
		this.t_note			= "";
		this.b_note			= "";
		this.b_reg_dt		= "";
		this.est_email		= "";
		this.client_yn		= "";
		this.county			= "";
	    this.zipcode		= "";
	    this.addr1			= "";
		this.addr2			= "";
		this.account		= "";
		this.bank			= "";
		this.driver_year	= "";
		this.urgen_tel		= "";
		this.est_comp_ceo	= "";
		this.est_comp_tel	= "";
		this.est_comp_cel	= "";
		this.car_use_addr1	= "";	//차량이용지주소1 추가(2018.03.13)
		this.car_use_addr2	= "";	//차량이용지주소2 추가(2018.03.13)
		this.br_to		= "";
		this.br_to_st		= "";
		this.br_from	= "";
		this.br_from_st	= "";

	}

	// get Method
	public void setEst_id			(String val){	if(val==null) val="";	this.est_id			= val;	}
	public void setEst_st			(String val){	if(val==null) val="";	this.est_st			= val;	}
    public void setEst_nm			(String val){	if(val==null) val="";	this.est_nm			= val;	}
    public void setEst_ssn			(String val){	if(val==null) val="";	this.est_ssn		= val;	}
    public void setEst_tel			(String val){	if(val==null) val="";	this.est_tel		= val;	}
    public void setEst_fax			(String val){	if(val==null) val="";	this.est_fax		= val;	}
    public void setEst_agnt			(String val){	if(val==null) val="";	this.est_agnt		= val;	}
    public void setEst_bus			(String val){	if(val==null) val="";	this.est_bus		= val;	}
	public void setEst_year			(String val){	if(val==null) val="";	this.est_year		= val;	}
	public void setCar_nm			(String val){	if(val==null) val="";	this.car_nm			= val;	}
	public void setEtc				(String val){	if(val==null) val="";	this.etc			= val;	}
	public void setReg_dt			(String val){	if(val==null) val="";	this.reg_dt			= val;	}
	public void setM_user_id		(String val){	if(val==null) val="";	this.m_user_id		= val;	}
	public void setM_reg_dt			(String val){	if(val==null) val="";	this.m_reg_dt		= val;	}
	public void setRent_yn			(String val){	if(val==null) val="";	this.rent_yn		= val;	}
	public void setEst_area			(String val){	if(val==null) val="";	this.est_area		= val;	}
	public void setEst_gubun		(String val){	if(val==null) val="";	this.est_gubun		= val;	}
	public void setCar_nm2			(String val){	if(val==null) val="";	this.car_nm2		= val;	}
	public void setCar_nm3			(String val){	if(val==null) val="";	this.car_nm3		= val;	}
	public void setReg_id			(String val){	if(val==null) val="";	this.reg_id			= val;	}
	public void setT_user_id		(String val){	if(val==null) val="";	this.t_user_id		= val;	}
	public void setT_reg_dt			(String val){	if(val==null) val="";	this.t_reg_dt		= val;	}
	public void setT_note			(String val){	if(val==null) val="";	this.t_note			= val;	}
	public void setB_note			(String val){	if(val==null) val="";	this.b_note			= val;	}
	public void setB_reg_dt			(String val){	if(val==null) val="";	this.b_reg_dt		= val;	}
	public void setEst_email		(String val){	if(val==null) val="";	this.est_email		= val;	}
	public void setClient_yn		(String val){	if(val==null) val="";	this.client_yn		= val;	}
	public void setCounty			(String val){	if(val==null) val="";	this.county			= val;	}
	public void setZipcode			(String val){	if(val==null) val="";	this.zipcode		= val;	}
	public void setAddr1			(String val){	if(val==null) val="";	this.addr1			= val;	}
	public void setAddr2			(String val){	if(val==null) val="";	this.addr2			= val;	}
	public void setAccount			(String val){	if(val==null) val="";	this.account		= val;	}
	public void setBank				(String val){	if(val==null) val="";	this.bank			= val;	}
	public void setDriver_year		(String val){	if(val==null) val="";	this.driver_year	= val;	}
	public void setUrgen_tel		(String val){	if(val==null) val="";	this.urgen_tel		= val;	}
	public void setEst_comp_ceo		(String val){	if(val==null) val="";	this.est_comp_ceo	= val;	}
	public void setEst_comp_tel		(String val){	if(val==null) val="";	this.est_comp_tel	= val;	}
	public void setEst_comp_cel		(String val){	if(val==null) val="";	this.est_comp_cel	= val;	}
	public void setCar_use_addr1	(String val){	if(val==null) val="";	this.car_use_addr1	= val;	}	//차량이용지주소1 추가(2018.03.13)
	public void setCar_use_addr2	(String val){	if(val==null) val="";	this.car_use_addr2	= val;	}	//차량이용지주소2 추가(2018.03.13)
	public void setBr_to		(String val){	if(val==null) val="";	this.br_to		= val;	}
	public void setBr_to_st		(String val){	if(val==null) val="";	this.br_to_st		= val;	}
	public void setBr_from	(String val){	if(val==null) val="";	this.br_from	= val;	}
	public void setBr_from_st	(String val){	if(val==null) val="";	this.br_from_st	= val;	}

	//Get Method
	public String getEst_id			(){		return est_id;			}
	public String getEst_st			(){		return est_st;			}
	public String getEst_nm			(){		return est_nm;			}
    public String getEst_ssn		(){		return est_ssn;			}
    public String getEst_tel		(){		return est_tel;			}
    public String getEst_fax		(){		return est_fax;			}
    public String getEst_agnt		(){		return est_agnt;		}
    public String getEst_bus		(){		return est_bus;			}
    public String getEst_year		(){		return est_year;		}
    public String getCar_nm			(){		return car_nm;			}
    public String getEtc			(){		return etc;				}
    public String getReg_dt			(){		return reg_dt;			}
    public String getM_user_id		(){		return m_user_id;		}
    public String getM_reg_dt		(){		return m_reg_dt;		}
    public String getRent_yn		(){		return rent_yn;			}
    public String getEst_area		(){		return est_area;		}
    public String getEst_gubun		(){		return est_gubun;		}
    public String getCar_nm2		(){		return car_nm2;			}
    public String getCar_nm3		(){		return car_nm3;			}    
    public String getReg_id			(){		return reg_id;			}
	public String getT_user_id		(){		return t_user_id;		}
    public String getT_reg_dt		(){		return t_reg_dt;		}
    public String getT_note			(){		return t_note;			}
    public String getB_note			(){		return b_note;			}
    public String getB_reg_dt		(){		return b_reg_dt;		}
	public String getEst_email		(){		return est_email;		}
	public String getClient_yn		(){		return client_yn;		}
   	public String getCounty			(){		return county;			}
	public String getZipcode		(){		return zipcode;			}
    public String getAddr1			(){		return addr1;			}
    public String getAddr2			(){		return addr2;			}
    public String getAccount		(){		return account;			}
    public String getBank			(){		return bank;			}
	public String getDriver_year	(){		return driver_year;		}
	public String getUrgen_tel		(){		return urgen_tel;		}
	public String getEst_comp_ceo	(){		return est_comp_ceo;	}
	public String getEst_comp_tel	(){		return est_comp_tel;	}
	public String getEst_comp_cel	(){		return est_comp_cel;	}
	public String getCar_use_addr1	(){		return car_use_addr1;	}	//차량이용지주소1 추가(2018.03.13)
	public String getCar_use_addr2	(){		return car_use_addr2;	}	//차량이용지주소2 추가(2018.03.13)
	public String getBr_to	(){		return br_to;	}
	public String getBr_to_st	(){		return br_to_st;	}
	public String getBr_from(){		return br_from;	}
	public String getBr_from_st(){		return br_from_st;	}

}	

