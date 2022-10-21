package acar.cont;

public class ContPurBean
{
	private String rent_mng_id; 
	private String rent_l_cd;
	private String rpt_no;
	private String dlv_brch; 
	private String reg_ext_dt; 
	private String dlv_con_dt; 
	private String dlv_est_dt; 
	private String dlv_est_h; 
	private String tmp_drv_no; 
	private String gds_yn;
	private String pur_st;
	private int    con_amt;
	private String con_pay_dt;
	private int    trf_amt1;
	private String trf_pay_dt1; 
	private int    trf_amt2;
	private String trf_pay_dt2; 
	private int    trf_amt3;
	private String trf_pay_dt3; 
	private int    trf_amt4;
	private String trf_pay_dt4; 
	/*추가*/
	private String tmp_drv_st;//임시운행기간
	private String tmp_drv_et;//임시운행기간
	private String pur_pay_dt;//지출일자
	/*추가20080612*/
	private String dlv_ext;		//출고지
	private String udt_st;		//인수지구분
	private String udt_est_dt;	//인수예정일
	private String udt_dt;		//인수일자
	private String cons_st;		//탁송구분
	private String off_id;		//탁송업체번호
	private String off_nm;		//탁송업체명
	private int    cons_amt1;	//탁송료1
	private int    cons_amt2;	//탁송료2
	private int    jan_amt;		//잔액
	private String con_est_dt;	//지출처리요청일
	private String rent_ext;	//납품지
	private String trf_st1;		//지급수단
	private String trf_st2;		//지급수단
	private String trf_st3;		//지급수단
	private String trf_st4;		//지급수단
	private String card_kind1;	//카드종류
	private String card_kind2;	//카드종류
	private String card_kind3;	//카드종류
	private String card_kind4;	//카드종류
	private String cardno1;		//카드번호
	private String cardno2;		//카드번호
	private String cardno3;		//카드번호
	private String cardno4;		//카드번호
	private String trf_cont1;	//적요
	private String trf_cont2;	//적요
	private String trf_cont3;	//적요
	private String trf_cont4;	//적요
	private String pur_est_dt;	//처리예정일
	private String est_car_no;	//예상차량번호
	private String car_num;		//차대번호
	private String req_code;	//지출문서번호
	private String autodocu_write_date;
	private String autodocu_data_no;
	private String dlv_ext_ven_code;
	private String car_off_ven_code;
	private String card_com_ven_code;
	private String one_self;			//자체출고여부
	private String con_amt_cont;		//고객선납관련
	private String acc_st1;				//계좌종류
	private String acc_st2;				//계좌종류
	private String acc_st3;				//계좌종류
	private String acc_st4;				//계좌종류
	private String con_bank;			//선수금은행
	private String con_acc_no;			//선수금계좌
	private String con_acc_nm;			//선수금예금주
	private String acq_cng_yn;			//취득세명의변경여부
	private String cpt_cd;				//금융사코드
	private String com_tint;			//제조사용품
	private String com_film_st;			//필름구분
	private String com_tint_coupon_no;	//쿠폰번호
	private String com_tint_coupon_dt;	//쿠폰수령일
	private String com_tint_coupon_pay_dt;	//쿠폰지급일
	private String com_tint_coupon_reg_id;	//쿠폰 등록자
	private String delay_cont;			//장기간 미출고 사유
	private String dir_pur_yn;			//특판출고여부
	private String pur_req_dt;			//출고요청일
	private String pur_bus_st;			//영업구분
	private String pur_req_yn;			//출고요청여부
	private String pur_com_firm;		//특판 고객명
	private String ecar_loc_st;			//전기차 고객주소지
	//20180412 추가
	private String trf_st5;				//지급수단-임시운행보험료
	private int    trf_amt5;			//금액-임시운행보험료
	private String card_kind5;			//카드종류-임시운행보험료
	private String cardno5;				//카드번호-임시운행보험료
	private String trf_cont5;			//적요-임시운행보험료
	private String trf_pay_dt5;			//지급일자-임시운행보험료
	private String acc_st5;				//계좌종류-임시운행보험료
	//20181005
	private String con_amt_pay_req;		//선납금 송금요청일시
	private String trf_amt_pay_req;		//임시운행보험료 선납금송금요청일시
	//20190201
	private String hcar_loc_st;			//수소차고객주소지
	//20220826
	private String trf_st0;				//지급수단-선수금
	private String acc_st0;				//계좌종류-선수금
	private String trf_est_dt5;			//지출예정일-임시운행보험료	

	                                    
	public ContPurBean()
	{
		rent_mng_id			= "";   
		rent_l_cd			= "";   
		rpt_no				= "";   
		dlv_brch			= "";
		reg_ext_dt			= "";   
		dlv_con_dt			= "";   
		dlv_est_dt			= "";   
		dlv_est_h			= "";   
		tmp_drv_no			= "";   
		gds_yn				= "";   
		pur_st				= "";   
		con_amt				= 0;
		con_pay_dt			= "";   
		trf_amt1			= 0;
		trf_pay_dt1			= "";   
		trf_amt2			= 0;
		trf_pay_dt2			= "";   
		trf_amt3			= 0;
		trf_pay_dt3			= "";   
		trf_amt4			= 0;
		trf_pay_dt4			= "";   
		tmp_drv_st			= "";
		tmp_drv_et			= "";	
		pur_pay_dt			= "";
		dlv_ext				= "";
		udt_st				= "";
		udt_est_dt			= "";
		udt_dt				= "";
		cons_st				= "";
		off_id				= "";
		off_nm				= "";
		cons_amt1			= 0;
		cons_amt2			= 0;
		jan_amt				= 0;
		con_est_dt			= "";
		rent_ext			= "";
		trf_st1				= "";   
		trf_st2				= "";
		trf_st3				= "";	
		trf_st4				= "";
		card_kind1			= "";
		card_kind2			= "";
		card_kind3			= "";
		card_kind4			= "";
		cardno1				= "";
		cardno2				= "";
		cardno3				= "";
		cardno4				= "";   
		trf_cont1			= "";
		trf_cont2			= "";	
		trf_cont3			= "";
		trf_cont4			= "";
		pur_est_dt			= "";
		est_car_no			= "";
		car_num				= "";
		req_code			= "";
		autodocu_write_date	= "";
		autodocu_data_no	= "";
		dlv_ext_ven_code 	= "";
		car_off_ven_code 	= "";
		card_com_ven_code	= "";
		one_self			= "";
		con_amt_cont		= "";
		acc_st1				= "";   
		acc_st2				= "";
		acc_st3				= "";	
		acc_st4				= "";
		con_bank			= "";
		con_acc_no			= "";
		con_acc_nm			= "";
		acq_cng_yn			= "";
		cpt_cd				= "";
		com_tint			= "";
		com_film_st			= "";
		com_tint_coupon_no	= "";
		com_tint_coupon_dt	= "";
		com_tint_coupon_pay_dt	= "";
		com_tint_coupon_reg_id	= "";
		delay_cont			= "";
		dir_pur_yn			= "";
		pur_req_dt			= "";
		pur_bus_st			= "";
		pur_req_yn			= "";
		pur_com_firm		= "";
		ecar_loc_st			= "";	
		trf_st5				= "";   
		trf_amt5			= 0;
		card_kind5			= "";   
		cardno5				= "";
		trf_cont5			= "";	
		trf_pay_dt5			= "";
		acc_st5				= "";
		con_amt_pay_req		= "";
		trf_amt_pay_req		= "";
		hcar_loc_st			= "";
		trf_st0				= "";
		acc_st0				= "";
		trf_est_dt5			= "";
		
	}
	
	public void setRent_mng_id			(String str)	{ rent_mng_id			= str;	}
	public void setRent_l_cd			(String str)	{ rent_l_cd				= str;	} 	
	public void setRpt_no				(String str)	{ rpt_no				= str;	} 		
	public void setDlv_brch				(String str)	{ dlv_brch				= str;	} 		
	public void setReg_ext_dt			(String str)	{ reg_ext_dt			= str;	} 
	public void setDlv_con_dt			(String str)	{ dlv_con_dt			= str;	} 
	public void setDlv_est_dt			(String str)	{ dlv_est_dt			= str;	} 
	public void setDlv_est_h			(String str)	{ dlv_est_h				= str;	} 
	public void setTmp_drv_no			(String str)	{ tmp_drv_no			= str;	} 
	public void setGds_yn				(String str)	{ gds_yn				= str;	} 		
	public void setPur_st				(String str)	{ pur_st				= str;	} 		
	public void setCon_amt				(int i)			{ con_amt				= i;	} 		
	public void setCon_pay_dt			(String str)	{ con_pay_dt			= str;	} 
	public void setTrf_amt1				(int i)			{ trf_amt1				= i;	} 		
	public void setTrf_pay_dt1			(String str)	{ trf_pay_dt1			= str;	}
	public void setTrf_amt2				(int i)			{ trf_amt2				= i;	} 		
	public void setTrf_pay_dt2			(String str)	{ trf_pay_dt2			= str;	}
	public void setTrf_amt3				(int i)			{ trf_amt3				= i;	} 		
	public void setTrf_pay_dt3			(String str)	{ trf_pay_dt3			= str;	}
	public void setTrf_amt4				(int i)			{ trf_amt4				= i;	} 		
	public void setTrf_pay_dt4			(String str)	{ trf_pay_dt4			= str;	}
	public void setTmp_drv_st			(String str)	{ tmp_drv_st			= str;	}
	public void setTmp_drv_et			(String str)	{ tmp_drv_et			= str;	}
	public void setPur_pay_dt			(String str)	{ pur_pay_dt			= str;	}
	public void setDlv_ext				(String str)	{ dlv_ext				= str;	}
	public void setUdt_st				(String str)	{ udt_st				= str;	}
	public void setUdt_est_dt			(String str)	{ udt_est_dt			= str;	}
	public void setUdt_dt				(String str)	{ udt_dt				= str;	}
	public void setCons_st				(String str)	{ cons_st				= str;	}
	public void setOff_id				(String str)	{ off_id				= str;	}
	public void setOff_nm				(String str)	{ off_nm				= str;	}
	public void setCons_amt1			(int i)			{ cons_amt1				= i;	}
	public void setCons_amt2			(int i)			{ cons_amt2				= i;	}
	public void setJan_amt				(int i)			{ jan_amt				= i;	}
	public void setCon_est_dt			(String str)	{ con_est_dt			= str;	}
	public void setRent_ext				(String str)	{ rent_ext				= str;	}
	public void setTrf_st1				(String str)	{ trf_st1				= str;	}
	public void setTrf_st2				(String str)	{ trf_st2				= str;	}
	public void setTrf_st3				(String str)	{ trf_st3				= str;	}
	public void setTrf_st4				(String str)	{ trf_st4				= str;	}
	public void setCard_kind1			(String str)	{ card_kind1			= str;	}
	public void setCard_kind2			(String str)	{ card_kind2			= str;	}
	public void setCard_kind3			(String str)	{ card_kind3			= str;	}
	public void setCard_kind4			(String str)	{ card_kind4			= str;	}
	public void setCardno1				(String str)	{ cardno1				= str;	}
	public void setCardno2				(String str)	{ cardno2				= str;	}
	public void setCardno3				(String str)	{ cardno3				= str;	}
	public void setCardno4				(String str)	{ cardno4				= str;	}
	public void setTrf_cont1			(String str)	{ trf_cont1				= str;	}
	public void setTrf_cont2			(String str)	{ trf_cont2				= str;	}
	public void setTrf_cont3			(String str)	{ trf_cont3				= str;	}
	public void setTrf_cont4			(String str)	{ trf_cont4				= str;	}
	public void setPur_est_dt			(String str)	{ pur_est_dt			= str;	}
	public void setEst_car_no			(String str)	{ est_car_no			= str;	}
	public void setCar_num				(String str)	{ car_num				= str;	}
	public void setReq_code				(String str)	{ req_code				= str;	}
	public void setAutodocu_write_date	(String val)	{	if(val==null) val="";		autodocu_write_date	= val;}
	public void setAutodocu_data_no		(String val)	{	if(val==null) val="";		autodocu_data_no	= val;}
	public void setDlv_ext_ven_code		(String val)	{	if(val==null) val="";		dlv_ext_ven_code 	= val;}
	public void setCar_off_ven_code		(String val)	{	if(val==null) val="";		car_off_ven_code 	= val;}
	public void setCard_com_ven_code	(String val)	{	if(val==null) val="";		card_com_ven_code	= val;}
	public void setOne_self				(String str)	{ one_self				= str;	}
	public void setCon_amt_cont			(String str)	{ con_amt_cont			= str;	}
	public void setAcc_st1				(String str)	{ acc_st1				= str;	}
	public void setAcc_st2				(String str)	{ acc_st2				= str;	}
	public void setAcc_st3				(String str)	{ acc_st3				= str;	}
	public void setAcc_st4				(String str)	{ acc_st4				= str;	}
	public void setCon_bank				(String str)	{ con_bank				= str;	}
	public void setCon_acc_no			(String str)	{ con_acc_no			= str;	}
	public void setCon_acc_nm			(String str)	{ con_acc_nm			= str;	}
	public void setAcq_cng_yn			(String str)	{ acq_cng_yn			= str;	}
	public void setCpt_cd				(String str)	{ cpt_cd				= str;	}
	public void setCom_tint				(String str)	{ com_tint				= str;	}
	public void setCom_film_st			(String str)	{ com_film_st			= str;	}
	public void setCom_tint_coupon_no	(String str)	{ com_tint_coupon_no	= str;	}
	public void setCom_tint_coupon_dt	(String str)	{ com_tint_coupon_dt	= str;	}
	public void setCom_tint_coupon_pay_dt(String str)	{ com_tint_coupon_pay_dt= str;	}
	public void setCom_tint_coupon_reg_id(String str)	{ com_tint_coupon_reg_id= str;	}
	public void setDelay_cont			(String str)	{ delay_cont			= str;	}
	public void setDir_pur_yn			(String str)	{ dir_pur_yn			= str;	}
	public void setPur_req_dt			(String str)	{ pur_req_dt			= str;	}
	public void setPur_bus_st			(String str)	{ pur_bus_st			= str;	}
	public void setPur_req_yn			(String str)	{ pur_req_yn			= str;	}	
	public void setPur_com_firm			(String str)	{ pur_com_firm			= str;	}	
	public void setEcar_loc_st			(String str)	{ ecar_loc_st			= str;	}	
	public void setTrf_st5				(String str)	{ trf_st5				= str;	}
	public void setTrf_amt5				(int i)			{ trf_amt5				= i;	} 		
	public void setCard_kind5			(String str)	{ card_kind5			= str;	}
	public void setCardno5				(String str)	{ cardno5				= str;	}
	public void setTrf_cont5			(String str)	{ trf_cont5				= str;	}
	public void setTrf_pay_dt5			(String str)	{ trf_pay_dt5			= str;	}
	public void setAcc_st5				(String str)	{ acc_st5				= str;	}
	public void setCon_amt_pay_req		(String str)	{ con_amt_pay_req		= str;	}
	public void setTrf_amt_pay_req		(String str)	{ trf_amt_pay_req		= str;	}
	public void setHcar_loc_st			(String val)	{ hcar_loc_st			= val;	}
	public void setTrf_st0				(String str)	{ trf_st0				= str;	}
	public void setAcc_st0				(String str)	{ acc_st0				= str;	}
	public void setTrf_est_dt5			(String str)	{ trf_est_dt5			= str;	}


	public String getRent_mng_id		()	{ return rent_mng_id;				}
	public String getRent_l_cd			()	{ return rent_l_cd;					}
	public String getRpt_no				()	{ return rpt_no;					}
	public String getDlv_brch			()	{ return dlv_brch;					}
	public String getReg_ext_dt			()	{ return reg_ext_dt;				}
	public String getDlv_con_dt			()	{ return dlv_con_dt;				}
	public String getDlv_est_dt			()	{ return dlv_est_dt;				}
	public String getDlv_est_h			()	{ return dlv_est_h;					}
	public String getTmp_drv_no			()	{ return tmp_drv_no;				}
	public String getGds_yn				()	{ return gds_yn;					}
	public String getPur_st				()	{ return pur_st;					}
	public int    getCon_amt			()	{ return con_amt;					}
	public String getCon_pay_dt			()	{ return con_pay_dt;				}
	public int    getTrf_amt1			()	{ return trf_amt1;					}
	public String getTrf_pay_dt1		()	{ return trf_pay_dt1;				}
	public int    getTrf_amt2			()	{ return trf_amt2;					}
	public String getTrf_pay_dt2		()	{ return trf_pay_dt2;				}
	public int    getTrf_amt3			()	{ return trf_amt3;					}
	public String getTrf_pay_dt3		()	{ return trf_pay_dt3;				}
	public int    getTrf_amt4			()	{ return trf_amt4;					}
	public String getTrf_pay_dt4		()	{ return trf_pay_dt4;				}
	public String getTmp_drv_st			()	{ return tmp_drv_st;				}
	public String getTmp_drv_et			()	{ return tmp_drv_et;				}
	public String getPur_pay_dt			()	{ return pur_pay_dt;				}	
	public String getDlv_ext			()	{ return dlv_ext;					}
	public String getUdt_st				()	{ return udt_st;					}
	public String getUdt_est_dt			()	{ return udt_est_dt;				}
	public String getUdt_dt				()	{ return udt_dt;					}
	public String getCons_st			()	{ return cons_st;					}
	public String getOff_id				()	{ return off_id;					}
	public String getOff_nm				()	{ return off_nm;					}
	public int    getCons_amt1			()	{ return cons_amt1;					}
	public int    getCons_amt2			()	{ return cons_amt2;					}
	public int    getJan_amt			()	{ return jan_amt;					}
	public String getCon_est_dt			()	{ return con_est_dt;				}
	public String getRent_ext			()	{ return rent_ext;					}
	public String getTrf_st1			()	{ return trf_st1;					}
	public String getTrf_st2			()	{ return trf_st2;					}
	public String getTrf_st3			()	{ return trf_st3;					}
	public String getTrf_st4			()	{ return trf_st4;					}	
	public String getCard_kind1			()	{ return card_kind1;				}
	public String getCard_kind2			()	{ return card_kind2;				}
	public String getCard_kind3			()	{ return card_kind3;				}
	public String getCard_kind4			()	{ return card_kind4;				}
	public String getCardno1			()	{ return cardno1;					}
	public String getCardno2			()	{ return cardno2;					}
	public String getCardno3			()	{ return cardno3;					}
	public String getCardno4			()	{ return cardno4;					}
	public String getTrf_cont1			()	{ return trf_cont1;					}
	public String getTrf_cont2			()	{ return trf_cont2;					}
	public String getTrf_cont3			()	{ return trf_cont3;					}	
	public String getTrf_cont4			()	{ return trf_cont4;					}
	public String getPur_est_dt			()	{ return pur_est_dt;				}
	public String getEst_car_no			()	{ return est_car_no;				}
	public String getCar_num			()	{ return car_num;					}
	public String getReq_code			()	{ return req_code;					}
	public String getAutodocu_write_date()	{ return autodocu_write_date;		}
	public String getAutodocu_data_no	()	{ return autodocu_data_no;			}
	public String getDlv_ext_ven_code	()	{ return dlv_ext_ven_code;			}
	public String getCar_off_ven_code	()	{ return car_off_ven_code;			}
	public String getCard_com_ven_code	()	{ return card_com_ven_code;			}
	public String getOne_self			()	{ return one_self;					}
	public String getCon_amt_cont		()	{ return con_amt_cont;				}
	public String getAcc_st1			()	{ return acc_st1;					}
	public String getAcc_st2			()	{ return acc_st2;					}
	public String getAcc_st3			()	{ return acc_st3;					}
	public String getAcc_st4			()	{ return acc_st4;					}	
	public String getCon_bank			()	{ return con_bank;					}	
	public String getCon_acc_no			()	{ return con_acc_no;				}	
	public String getCon_acc_nm			()	{ return con_acc_nm;				}	
	public String getAcq_cng_yn			()	{ return acq_cng_yn;				}	
	public String getCpt_cd				()	{ return cpt_cd;					}	
	public String getCom_tint			()	{ return com_tint;					}	
	public String getCom_film_st		()	{ return com_film_st;				}	
	public String getCom_tint_coupon_no	()	{ return com_tint_coupon_no;		}	
	public String getCom_tint_coupon_dt	()	{ return com_tint_coupon_dt;		}	
	public String getCom_tint_coupon_pay_dt	()	{ return com_tint_coupon_pay_dt;		}	
	public String getCom_tint_coupon_reg_id	()	{ return com_tint_coupon_reg_id;		}	
	public String getDelay_cont			()	{ return delay_cont;				}	
	public String getDir_pur_yn			()	{ return dir_pur_yn;				}
	public String getPur_req_dt			()	{ return pur_req_dt;				}
	public String getPur_bus_st			()	{ return pur_bus_st;				}
	public String getPur_req_yn			()	{ return pur_req_yn;				}	
	public String getPur_com_firm		()	{ return pur_com_firm;				}	
	public String getEcar_loc_st		()	{ return ecar_loc_st;				}	
	public String getTrf_st5			()	{ return trf_st5;					}
	public int    getTrf_amt5			()	{ return trf_amt5;					}
	public String getCard_kind5			()	{ return card_kind5;				}
	public String getCardno5			()	{ return cardno5;					}
	public String getTrf_cont5			()	{ return trf_cont5;					}
	public String getTrf_pay_dt5		()	{ return trf_pay_dt5;				}	
	public String getAcc_st5			()	{ return acc_st5;					}
	public String getCon_amt_pay_req	()	{ return con_amt_pay_req;			}	
	public String getTrf_amt_pay_req	()	{ return trf_amt_pay_req;			}
	public String getHcar_loc_st		()	{ return hcar_loc_st;				}
	public String getTrf_st0			()	{ return trf_st0;					}
	public String getAcc_st0			()	{ return acc_st0;					}
	public String getTrf_est_dt5		()	{ return trf_est_dt5;				}
	


}