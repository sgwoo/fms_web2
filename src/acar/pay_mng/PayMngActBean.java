package acar.pay_mng;

import java.util.*;

public class PayMngActBean {

    //Table : pay_ACT 출금원장
	private String	actseq;					//일련번호
	private String	reg_dt;					//등록일
	private String	reg_id;					//등록자
	private String	act_st;					//즉시,예약
	private String	act_dt;					//송금일자
	private long    amt;                    //지출총금액
	private int		commi;					//송금수수료
	private String	bank_id;				//지출처(입금)-은행코드
	private String	bank_nm;				//지출처(입금)-은행명
	private String	bank_no;				//지출처(입금)-계좌번호
	private String	a_bank_id;				//아마존카(출금)-은행코드
	private String	a_bank_nm;				//아마존카(출금)-은행명
	private String	a_bank_no;				//아마존카(출금)-계좌번호
	private String	act_bit;				//송금결과
	private String	bank_code;				//송금코드
	private String	r_act_dt;				//실송금일자
	private String	off_nm;					//지출처
	private String	rs_code;				//결과코드
	private String	bank_acc_nm;			//지출처(입금)-예금주명
	private String	bank_cms_bk;			//지출처(입금)-은행코드
	private String	a_bank_cms_bk;			//지출처(입금)-은행코드
	private String	app_id;					//승인자
	private String	bank_memo;				//입금자표시
	private String	cms_code;				//CMS코드
	private String	at_once;				//즉시,지정
	
	public PayMngActBean() {  
		actseq				= "";
		reg_dt				= "";
		reg_id				= "";
		act_st				= "";
		act_dt				= "";
		amt					= 0;
		commi				= 0;
		bank_id				= "";
		bank_nm				= "";
		bank_no				= "";
		a_bank_id			= "";
		a_bank_nm			= "";
		a_bank_no			= "";
		act_bit				= "";
		bank_code			= "";
		r_act_dt			= "";
		off_nm				= "";
		rs_code				= "";
		bank_acc_nm			= "";
		bank_cms_bk			= "";
		a_bank_cms_bk		= "";
		app_id				= "";
		bank_memo			= "";
		cms_code			= "";
		at_once				= "";
	}

	// set Method
	public void setActseq				(String str){	actseq			= str;	}
	public void setReg_dt				(String str){	reg_dt			= str;	}
	public void setReg_id				(String str){	reg_id			= str;	}
	public void setAct_st				(String str){	act_st			= str;	}
	public void setAct_dt				(String str){	act_dt			= str;	}
	public void setAmt					(long     i){	amt				= i;	}
	public void setCommi				(int      i){	commi			= i;	}
	public void setBank_id				(String str){	bank_id			= str;	}
	public void setBank_nm				(String str){	bank_nm			= str;	}
	public void setBank_no				(String str){	bank_no			= str;	}
	public void setA_bank_id			(String str){	a_bank_id		= str;	}
	public void setA_bank_nm			(String str){	a_bank_nm		= str;	}
	public void setA_bank_no			(String str){	a_bank_no		= str;	}
	public void setAct_bit				(String str){	act_bit			= str;	}
	public void setBank_code			(String str){	bank_code		= str;	}
	public void setR_act_dt				(String str){	r_act_dt		= str;	}
	public void setOff_nm				(String str){	off_nm			= str;	}
	public void setRs_code				(String str){	rs_code			= str;	}
	public void setBank_acc_nm			(String str){	bank_acc_nm		= str;	}
	public void setBank_cms_bk			(String str){	bank_cms_bk		= str;	}
	public void setA_bank_cms_bk		(String str){	a_bank_cms_bk	= str;	}
	public void setApp_id				(String str){	app_id			= str;	}
	public void setBank_memo			(String str){	bank_memo		= str;	}
	public void setCms_code				(String str){	cms_code		= str;	}
	public void setAt_once				(String str){	at_once			= str;	}

	//Get Method
	public String getActseq				(){				return actseq;			}
	public String getReg_dt				(){				return reg_dt;			}
	public String getReg_id				(){				return reg_id;			}
	public String getAct_st				(){				return act_st;			}
	public String getAct_dt				(){				return act_dt;			}
	public long   getAmt                (){				return amt;             }
	public int    getCommi				(){				return commi;			}
	public String getBank_id			(){				return bank_id;			}
	public String getBank_nm			(){				return bank_nm;			}
	public String getBank_no			(){				return bank_no;			}
	public String getA_bank_id			(){				return a_bank_id;		}
	public String getA_bank_nm			(){				return a_bank_nm;		}
	public String getA_bank_no			(){				return a_bank_no;		}
	public String getAct_bit			(){				return act_bit;			}
	public String getBank_code			(){				return bank_code;		}
	public String getR_act_dt			(){				return r_act_dt;		}
	public String getOff_nm				(){				return off_nm;			}
	public String getRs_code			(){				return rs_code;			}
	public String getBank_acc_nm		(){				return bank_acc_nm;		}
	public String getBank_cms_bk		(){				return bank_cms_bk;		}
	public String getA_bank_cms_bk		(){				return a_bank_cms_bk;	}
	public String getApp_id				(){				return app_id;			}
	public String getBank_memo			(){				return bank_memo;		}
	public String getCms_code			(){				return cms_code;		}
	public String getAt_once			(){				return at_once;		}

}
