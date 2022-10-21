package acar.inside_bank;

import java.util.*;

public class IbAcctAllTrDdBean {

    //Table : IB_ACCTALL_TR_DD :전계좌거래내역 (집금)
    
	private String	acct_seq;         	 	//계좌일련번호
	private String	tr_date;				//거래일자         
	private String	tr_date_seq;           	//거래일자일련번호  
	private String	tr_time;				//거래시간           
	private String	tr_af_date;				//후송거래일자         
	private String	tr_ipji_gbn;           	//입출력거래구분           
	private int	  	tr_amt;     	       	//거래금액         
	private int	  	tr_af_amt;      	   	//거래후 잔액      
	private String	br_cd;       		  	//거래점코드         
	private String	br_nm;              	//거래점명             
	private String	jukyo;         			//적요         
	private String	naeyong;           		//내용             
	private String	co_reg_nb;            	//게좌주 사업자번호           
	private String	co_nm;     				//계좌주명    
	private String	bank_id; 			  	//은행코드    
	private String	bank_nm;           		//은행명         
	private String	acct_nb;            	//계좌번호          
	private String	acct_tonghwa;        	//통화코드     
	private String	acct_nm;    			//계좌명  
	private String	last_upd_date;    		//마지막조회일자  
	private String	last_upd_time;    		//마지막조회시간  

	
	public IbAcctAllTrDdBean() {  
		acct_seq        	 = "";
		tr_date              = "";
		tr_date_seq          = "";
		tr_time              = "";
		tr_af_date           = "";
		tr_ipji_gbn          = "";	
		tr_amt             	 = 0;
		tr_af_amt          	 = 0;
		br_cd         		 = "";
		br_nm                = "";
		jukyo       		 = "";
		naeyong            	 = "";
		co_reg_nb            = "";
		co_nm   			 = "";
		bank_id    			 = "";
		bank_nm              = "";
		acct_nb              = "";
		acct_tonghwa         = "";
		acct_nm     		 = "";
		last_upd_date        = "";
		last_upd_time     	 = "";
		

	}

	// set Method
	public void setAcct_seq	           (String var){	acct_seq        	 = var;	}
	public void setTr_date             (String var){	tr_date              = var;	}
	public void setTr_date_seq         (String var){	tr_date_seq          = var;	}
	public void setTr_time        	   (String var){	tr_time            	 = var;	}
	public void setTr_af_date          (String var){	tr_af_date           = var;	}
	public void setTr_ipji_gbn         (String var){	tr_ipji_gbn          = var;	}
	public void setTr_amt   	       (int	   var){	tr_amt 		         = var;	}
	public void setTr_af_amt    	   (int	   var){	tr_af_amt    	     = var;	}
	public void setBr_cd        	   (String var){	br_cd        		 = var;	}
	public void setBr_nm               (String var){	br_nm                = var;	}
	public void setJukyo         	   (String var){	jukyo       		 = var;	}
	public void setNaeyong             (String var){	naeyong              = var;	}
	public void setCo_reg_nb           (String var){	co_reg_nb            = var;	}
	public void setCo_nm    		   (String var){	co_nm     			 = var;	}
	public void setBank_id   		   (String var){	bank_id   			 = var;	}
	public void setBank_nm             (String var){	bank_nm              = var;	}
	public void setAcct_nb             (String var){	acct_nb              = var;	}
	public void setAcct_tonghwa        (String var){	acct_tonghwa         = var;	}
	public void setAcct_nm    		   (String var){	acct_nm     		 = var;	}
	public void setlast_upd_date       (String var){	last_upd_date        = var;	}
	public void setLast_upd_time 	   (String var){	last_upd_time   	 = var;	}

	//Get Method
	public String getAcct_seq            (){		return acct_seq;			}
	public String getTr_date             (){		return tr_date;				}
	public String getTr_date_seq         (){		return tr_date_seq;			}
	public String getTr_time             (){		return tr_time;		  		}
	public String getTr_af_date          (){		return tr_af_date;			}
	public String getTr_ipji_gbn         (){		return tr_ipji_gbn;			}
	public int	  getTr_amt    		     (){		return tr_amt;		  		}
	public int	  getTr_aft_amt          (){		return tr_af_amt;			}
	public String getBr_cd       		 (){		return br_cd;				}
	public String getBr_nm               (){		return br_nm;				}
	public String getJukyo         		 (){		return jukyo;				}
	public String getNaeyong             (){		return naeyong;				}
	public String getCo_reg_nb           (){		return co_reg_nb;			}
	public String getCo_nm   			 (){		return co_nm;				}
	public String getBank_id		     (){		return bank_id;				}
	public String getBank_nm             (){		return bank_nm;				}
	public String getAcct_nb             (){		return acct_nb;				}
	public String getAcct_tonghwa        (){		return acct_tonghwa;		}
	public String getAcct_nm    		 (){		return acct_nm;				}
	public String getlast_upd_date       (){		return last_upd_date;		}
	public String getLast_upd_time 		 (){		return last_upd_time;		}

}





















