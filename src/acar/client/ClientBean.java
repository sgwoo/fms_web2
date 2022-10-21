package acar.client;

public class ClientBean
{
	//Table : CLIENT

	private String client_id		= "";
	private String client_st		= "";
	private String client_nm		= "";
	private String firm_nm			= "";
	private String ssn1				= "";
	private String ssn2				= "";
	private String enp_no1			= "";
	private String enp_no2			= "";
	private String enp_no3			= "";
	private String h_tel			= "";
	private String o_tel			= "";
	private String m_tel			= "";
	private String homepage			= "";
	private String fax				= "";
	private String bus_cdt			= "";
	private String bus_itm			= "";
	private String ho_addr			= "";
	private String ho_zip			= "";
	private String o_addr			= "";
	private String o_zip			= "";
	private String com_nm			= "";
	private String dept				= "";
	private String title			= "";
	private String car_use			= "";
	private String con_agnt_nm		= "";
	private String con_agnt_o_tel	= "";
	private String con_agnt_m_tel	= "";
	private String con_agnt_fax		= "";
	private String con_agnt_email	= "";
	private String con_agnt_dept	= "";
	private String con_agnt_title	= "";
	private String etc				= "";        
	private String open_year		= "";
	private float firm_price		= 0;     
	private float firm_price_y		= 0;
	private float firm_price_b		= 0;
	private String firm_day			= "";
	private String firm_day_y		= "";
	private String firm_day_b		= "";
	//등록,수정정보
	private String reg_dt			= "";
	private String reg_id			= "";
	private String update_dt		= "";
	private String update_id		= "";
	//20051013 추가
	private String rank				= "";
	private String first_vst_dt		= "";
	private String cycle_vst		= "";
	private String tot_vst			= "";
	private String ven_code			= "";
	private String print_st			= "";
	private String etax_not_cau		= "";
	//20070504 추가-네오엠 입금처리위해 필요
	private String bank_code		= "";	//무통장입금은행
	private String deposit_no		= "";	//무통장입금계좌
	// 20070710 newFMS 고객정보 추가 
	private String firm_st			= "";
	private String enp_yn			= "";
	private String enp_nm			= "";
	private String firm_type		= "";
	private String found_year		= "";
	private String repre_st			= "";
	private String repre_ssn1 		= "";
	private String repre_ssn2 		= "";
	private String repre_addr		= "";
	private String repre_zip		= "";
	private String repre_email		= "";
	private String job				= "";
	private String pay_st			= "";
	private String pay_type			= "";
	private String comm_addr 		= "";
	private String comm_zip			= "";
	private String wk_year			= "";
	private String bigo_yn			= "";
	private String main_client		= "";
	private String dly_sms			= "";
	private String etc_cms			= "";
	private String fine_yn			= "";
	private String item_mail_yn		= "";
	private String tax_mail_yn		= "";
	private String taxregno			= "";
	//20101026 임의연장 계산서발행방식
	private String im_print_st		= "";
	private String tm_print_yn		= "";
	//20100428 계산서과련
	private String bigo_value1		= "";
	private String bigo_value2		= ""; 
	private String pubform			= "";	
	private String print_car_st		= "";	
	private String nationality		= "";	
	//20110708 계산서 품목다중표시여부
	private String etax_item_st		= "";	
	private String dly_yn			= "";	
	private String repre_nm			= "";
	//20170710 계산서 추가수신자	
	private String con_agnt_nm2		= "";
	private String con_agnt_o_tel2	= "";
	private String con_agnt_m_tel2	= "";
	private String con_agnt_fax2	= "";
	private String con_agnt_email2	= "";
	private String con_agnt_dept2	= "";
	private String con_agnt_title2	= "";
	//20180113 운전면허번호, 자동이체통보문자발송여부 추가
	private String lic_no			= "";
	private String cms_sms			= "";
	// 2020.11. 개인사업자의 공동대표자 항목 추가
	private String repre_st2			= "";
	private String repre_ssn2_1 		= "";
	private String repre_ssn2_2 		= "";
	private String repre_addr2		= "";
	private String repre_zip2		= "";
	private String repre_email2		= "";
	private String repre_nm2			= "";

	
	// CONSTRCTOR   	
	public ClientBean()
	{
		client_id		= "";    
		client_st		= "";        
		client_nm		= "";    
		firm_nm			= "";    
		ssn1			= "";
		ssn2			= "";
		enp_no1			= "";    
		enp_no2			= "";    
		enp_no3			= "";    
		h_tel			= "";    
		o_tel			= "";    
		m_tel			= "";    
		homepage		= "";    
		fax				= "";    
		bus_cdt			= "";    
		bus_itm			= "";    
		ho_addr			= "";    
		ho_zip			= "";    
		o_addr			= "";    
		o_zip			= "";    
		com_nm			= "";    
		dept			= "";    
		title			= "";    
		car_use			= "";    
		con_agnt_nm		= "";
		con_agnt_o_tel	= "";
		con_agnt_m_tel	= "";
		con_agnt_fax	= "";
		con_agnt_email	= "";
		con_agnt_dept	= "";
		con_agnt_title	= "";
		etc				= "";
		open_year		= "";
		firm_price		= 0;
		firm_price_y	= 0;
		firm_price_b	= 0;
		firm_day		= "";
		firm_day_y		= "";
		firm_day_b		= "";
		reg_dt			= "";
		reg_id			= "";
		update_dt		= "";
		update_id		= "";
		rank			= "";
		first_vst_dt	= "";
		cycle_vst		= "";
		tot_vst			= "";
		ven_code		= "";
		print_st		= "";
		etax_not_cau	= "";
		bank_code		= "";
		deposit_no		= "";
		firm_st			= "";
		enp_yn			= "";
		enp_nm			= "";
		firm_type		= "";
		found_year		= "";
		repre_st		= "";
		repre_ssn1 		= "";
		repre_ssn2 		= "";
		repre_addr		= "";
		repre_zip		= "";
		repre_email		= "";
		job				= "";
		pay_st			= "";
		pay_type		= "";
		comm_addr 		= "";
		comm_zip		= "";
		wk_year			= "";
		bigo_yn			= "";
		main_client		= "";
		dly_sms			= "";
		etc_cms			= "";
		fine_yn			= "";
		item_mail_yn	= "";
		tax_mail_yn		= "";
		taxregno		= "";
		im_print_st		= "";
		tm_print_yn		= "";
		bigo_value1		= "";	
		bigo_value2		= "";	
		pubform			= "";	
		print_car_st	= "";
		nationality		= "";
		etax_item_st	= "";
		dly_yn			= "";
		repre_nm		= "";
		con_agnt_nm2	= "";
		con_agnt_o_tel2	= "";
		con_agnt_m_tel2	= "";
		con_agnt_fax2	= "";
		con_agnt_email2	= "";
		con_agnt_dept2	= "";
		con_agnt_title2	= "";
		lic_no			= "";
		cms_sms			= "";
		repre_st2		= "";
		repre_ssn2_1 		= "";
		repre_ssn2_2 		= "";
		repre_addr2		= "";
		repre_zip2		= "";
		repre_email2		= "";
		repre_nm2		= "";
	}
	
	//Set Method
	public void setClient_id		(String str) 	{	if(str==null) str="";	client_id		= str; }
	public void setClient_st		(String str)	{	if(str==null) str="";	client_st		= str; }
	public void setClient_nm		(String str)	{	if(str==null) str="";	client_nm		= str; }		
	public void setFirm_nm			(String str)	{	if(str==null) str="";	firm_nm			= str; }    
	public void setSsn1				(String str)	{	if(str==null) str="";	ssn1			= str; }    	
	public void setSsn2				(String str)	{	if(str==null) str="";	ssn2			= str; }    	
	public void setEnp_no1			(String str)	{	if(str==null) str="";	enp_no1			= str; }    		
	public void setEnp_no2			(String str)	{	if(str==null) str="";	enp_no2			= str; }    		
	public void setEnp_no3			(String str)	{	if(str==null) str="";	enp_no3			= str; }    		
	public void setH_tel			(String str)	{	if(str==null) str="";	h_tel			= str; }		
	public void setO_tel			(String str)	{	if(str==null) str="";	o_tel			= str; }		
	public void setM_tel			(String str)	{	if(str==null) str="";	m_tel			= str; }		
	public void setHomepage			(String str)	{	if(str==null) str="";	homepage		= str; }
	public void setFax				(String str)	{	if(str==null) str="";	fax				= str; }    	
	public void setBus_cdt			(String str)	{	if(str==null) str="";	bus_cdt			= str; }    
	public void setBus_itm			(String str)	{	if(str==null) str="";	bus_itm			= str; }    			
	public void setHo_addr			(String str)	{	if(str==null) str="";	ho_addr			= str; }    	
	public void setHo_zip			(String str)	{	if(str==null) str="";	ho_zip			= str; }    	
	public void setO_addr			(String str)	{	if(str==null) str="";	o_addr			= str; }    	
	public void setO_zip			(String str)	{	if(str==null) str="";	o_zip			= str; }		
	public void setCom_nm			(String str)	{	if(str==null) str="";	com_nm			= str; }    
	public void setDept				(String str)	{	if(str==null) str="";	dept			= str; }	
	public void setTitle			(String str)	{	if(str==null) str="";	title			= str; }		
	public void setCar_use			(String str)	{	if(str==null) str="";	car_use			= str; }    
	public void setCon_agnt_nm		(String str)	{	if(str==null) str="";	con_agnt_nm		= str; }    
	public void setCon_agnt_o_tel	(String str)	{	if(str==null) str="";	con_agnt_o_tel	= str; }  
	public void setCon_agnt_m_tel	(String str) 	{	if(str==null) str="";	con_agnt_m_tel	= str; }  
	public void setCon_agnt_fax		(String str)	{	if(str==null) str="";	con_agnt_fax	= str; }
	public void setCon_agnt_email	(String str)	{	if(str==null) str="";	con_agnt_email	= str; }  
	public void setCon_agnt_dept	(String str)	{	if(str==null) str="";	con_agnt_dept	= str; }	
	public void setCon_agnt_title	(String str)	{	if(str==null) str="";	con_agnt_title	= str; }  
	public void setEtc				(String str)	{	if(str==null) str="";	etc				= str; }    
	public void setOpen_year		(String str)	{	if(str==null) str="";	open_year		= str; }    
	public void setFirm_price		(float f)		{							firm_price		= f;   }    
	public void setFirm_price_y		(float f)		{							firm_price_y	= f;   }    
	public void setFirm_price_b		(float f)		{							firm_price_b	= f;   }    
	public void setFirm_day			(String str)	{	if(str==null) str="";	firm_day		= str; }    
	public void setFirm_day_y		(String str)	{	if(str==null) str="";	firm_day_y		= str; }    
	public void setFirm_day_b		(String str)	{	if(str==null) str="";	firm_day_b		= str; }    	
	public void setReg_dt			(String str)	{	if(str==null) str="";	reg_dt			= str; }	
	public void setReg_id			(String str)	{	if(str==null) str="";	reg_id			= str; }	
	public void setUpdate_dt		(String str)	{	if(str==null) str="";	update_dt		= str; }	
	public void setUpdate_id		(String str)	{	if(str==null) str="";	update_id		= str; }	
	public void setRank				(String str)	{	if(str==null) str="";	rank			= str; }    
	public void setFirst_vst_dt		(String str)	{	if(str==null) str="";	first_vst_dt	= str; }    
	public void setCycle_vst		(String str)	{	if(str==null) str="";	cycle_vst		= str; }    	
	public void setTot_vst			(String str)	{	if(str==null) str="";	tot_vst			= str; }	
	public void setVen_code			(String str)	{	if(str==null) str="";	ven_code		= str; }	
	public void setPrint_st			(String str)	{	if(str==null) str="";	print_st		= str; }	
	public void setEtax_not_cau		(String str)	{	if(str==null) str="";	etax_not_cau	= str; }	
	public void setBank_code		(String str)	{	if(str==null) str="";	bank_code		= str; }	
	public void setDeposit_no		(String str)	{	if(str==null) str="";	deposit_no		= str; }
	public void setFirm_st			(String str)	{	if(str==null) str="";	firm_st			= str; }
	public void setEnp_yn			(String str)	{	if(str==null) str="";	enp_yn		    = str; }
	public void setEnp_nm			(String str)	{	if(str==null) str="";	enp_nm		    = str; }
	public void setFirm_type		(String str)	{	if(str==null) str="";	firm_type	    = str; }
	public void setFound_year		(String str)	{	if(str==null) str="";	found_year	    = str; }
	public void setRepre_st			(String str)	{	if(str==null) str="";	repre_st	    = str; }
	public void setRepre_ssn1		(String str)	{	if(str==null) str="";	repre_ssn1	    = str; }
	public void setRepre_ssn2		(String str)	{	if(str==null) str="";	repre_ssn2	    = str; }
	public void setRepre_addr		(String str)	{	if(str==null) str="";	repre_addr	    = str; }
	public void setRepre_zip		(String str)	{	if(str==null) str="";	repre_zip	    = str; }
	public void setRepre_email		(String str)	{	if(str==null) str="";	repre_email		= str; }
	public void setJob				(String str)	{	if(str==null) str="";	job				= str; }
	public void setPay_st			(String str)	{	if(str==null) str="";	pay_st		    = str; }
	public void setPay_type			(String str)	{	if(str==null) str="";	pay_type	    = str; }
	public void setComm_addr		(String str)	{	if(str==null) str="";	comm_addr	    = str; }
	public void setComm_zip			(String str)	{	if(str==null) str="";	comm_zip	    = str; }	
	public void setWk_year			(String str)	{	if(str==null) str="";	wk_year		    = str; }	
	public void setBigo_yn			(String str)	{	if(str==null) str="";	bigo_yn		    = str; }	
	public void setMain_client		(String str)	{	if(str==null) str="";	main_client	    = str; }	
	public void setDly_sms			(String str)	{	if(str==null) str="";	dly_sms		    = str; }	
	public void setEtc_cms			(String str)	{	if(str==null) str="";	etc_cms		    = str; }	
	public void setFine_yn			(String str)	{	if(str==null) str="";	fine_yn		    = str; }	
	public void setItem_mail_yn		(String str)	{	if(str==null) str="";	item_mail_yn    = str; }	
	public void setTax_mail_yn		(String str)	{	if(str==null) str="";	tax_mail_yn	    = str; }	
	public void setTaxregno			(String str)	{	if(str==null) str="";	taxregno	    = str; }	
	public void setIm_print_st		(String str)	{	if(str==null) str="";	im_print_st		= str; }	
	public void setTm_print_yn		(String str)	{	if(str==null) str="";	tm_print_yn		= str; }	
	public void setBigo_value1		(String str)	{	if(str==null) str="";	bigo_value1		= str; }	
	public void setBigo_value2		(String str)	{	if(str==null) str="";	bigo_value2		= str; }	
	public void setPubform			(String str)	{	if(str==null) str="";	pubform			= str; }	
	public void setPrint_car_st		(String str)	{	if(str==null) str="";	print_car_st	= str; }	
	public void setNationality		(String str)	{	if(str==null) str="";	nationality		= str; }	
	public void setEtax_item_st		(String str)	{	if(str==null) str="";	etax_item_st	= str; }	
	public void setDly_yn			(String str)	{	if(str==null) str="";	dly_yn			= str; }	
	public void setRepre_nm			(String str)	{	if(str==null) str="";	repre_nm	    = str; }
	public void setCon_agnt_nm2		(String str)	{	if(str==null) str="";	con_agnt_nm2	= str; }    
	public void setCon_agnt_o_tel2	(String str)	{	if(str==null) str="";	con_agnt_o_tel2	= str; }  
	public void setCon_agnt_m_tel2	(String str) 	{	if(str==null) str="";	con_agnt_m_tel2	= str; }  
	public void setCon_agnt_fax2	(String str)	{	if(str==null) str="";	con_agnt_fax2	= str; }
	public void setCon_agnt_email2	(String str)	{	if(str==null) str="";	con_agnt_email2	= str; }  
	public void setCon_agnt_dept2	(String str)	{	if(str==null) str="";	con_agnt_dept2	= str; }	
	public void setCon_agnt_title2	(String str)	{	if(str==null) str="";	con_agnt_title2	= str; }  
	public void setLic_no			(String str)	{	if(str==null) str="";	lic_no			= str; }	
	public void setCms_sms			(String str)	{	if(str==null) str="";	cms_sms			= str; }	
	public void setRepre_st2			(String str)	{	if(str==null) str="";	repre_st2	    = str; }
	public void setRepre_ssn2_1		(String str)	{	if(str==null) str="";	repre_ssn2_1	    = str; }
	public void setRepre_ssn2_2		(String str)	{	if(str==null) str="";	repre_ssn2_2	    = str; }
	public void setRepre_addr2		(String str)	{	if(str==null) str="";	repre_addr2	    = str; }
	public void setRepre_zip2		(String str)	{	if(str==null) str="";	repre_zip2	    = str; }
	public void setRepre_email2		(String str)	{	if(str==null) str="";	repre_email2		= str; }
	public void setRepre_nm2			(String str)	{	if(str==null) str="";	repre_nm2	    = str; }
	

	//Get Method	
	public String getClient_id		()	{	return client_id;		}
	public String getClient_st		()	{	return client_st;		}
	public String getClient_nm		()	{	return client_nm;		}
	public String getFirm_nm		()	{	return firm_nm;			}
	public String getSsn1			()	{	return ssn1;			}
	public String getSsn2			()	{	return ssn2;			}
	public String getEnp_no1		()	{	return enp_no1;			}
	public String getEnp_no2		()	{	return enp_no2;			}
	public String getEnp_no3		()	{	return enp_no3;			}
	public String getH_tel			()	{	return h_tel;			}
	public String getO_tel			()	{	return o_tel;			}
	public String getM_tel			()	{	return m_tel;			}
	public String getHomepage		()	{	return homepage;		}
	public String getFax			()	{	return fax;				}
	public String getBus_cdt		()	{	return bus_cdt;			}
	public String getBus_itm		()	{	return bus_itm;			}
	public String getHo_addr		()	{	return ho_addr;			}
	public String getHo_zip			()	{	return ho_zip;			}
	public String getO_addr			()	{	return o_addr;			}
	public String getO_zip			()	{	return o_zip;			}
	public String getCom_nm			()	{	return com_nm;			}
	public String getDept			()	{	return dept;			}
	public String getTitle			()	{	return title;			}
	public String getCar_use		()	{	return car_use;			}
	public String getCon_agnt_nm	()	{	return con_agnt_nm;		}
	public String getCon_agnt_o_tel	()	{	return con_agnt_o_tel;	}
	public String getCon_agnt_m_tel	() 	{	return con_agnt_m_tel;	}
	public String getCon_agnt_fax	()	{	return con_agnt_fax;	}
	public String getCon_agnt_email	()	{	return con_agnt_email;	}
	public String getCon_agnt_dept	()	{	return con_agnt_dept;	}
	public String getCon_agnt_title	()	{	return con_agnt_title;	}
	public String getEtc			()	{	return etc;				}
	public String getOpen_year		()	{	return open_year;		}
	public float getFirm_price		()	{	return firm_price;		}
	public float getFirm_price_y	()	{	return firm_price_y;	}
	public float getFirm_price_b	()	{	return firm_price_b;	}
	public String getFirm_day		()	{	return firm_day;		}
	public String getFirm_day_y		()	{	return firm_day_y;		}
	public String getFirm_day_b		()	{	return firm_day_b;		}
	public String getReg_dt			()	{	return reg_dt;			}
	public String getReg_id			()	{	return reg_id;			}
	public String getUpdate_dt		()	{	return update_dt;		}
	public String getUpdate_id		()	{	return update_id;		}
	public String getRank			()	{	return rank;			}
	public String getFirst_vst_dt	()	{	return first_vst_dt;	}
	public String getCycle_vst		()	{	return cycle_vst;		}
	public String getTot_vst		()	{	return tot_vst;			}
	public String getVen_code		()	{	return ven_code;		}
	public String getPrint_st		()	{	return print_st;		}
	public String getEtax_not_cau	()	{	return etax_not_cau;	}
	public String getBank_code		()	{	return bank_code;		}
	public String getDeposit_no		()	{	return deposit_no;		}
	public String getFirm_st		()	{	return firm_st;			}
	public String getEnp_yn			()	{	return enp_yn;			}
	public String getEnp_nm			()	{	return enp_nm;			}
	public String getFirm_type		()	{	return firm_type;		}
	public String getFound_year		()	{	return found_year;		}
	public String getRepre_st		()	{	return repre_st;		}
	public String getRepre_ssn1		()	{	return repre_ssn1;		}
	public String getRepre_ssn2		()	{	return repre_ssn2;		}
	public String getRepre_addr		()	{	return repre_addr;		}
	public String getRepre_zip		()	{	return repre_zip;		}
	public String getRepre_email	()	{	return repre_email;		}
	public String getJob			()	{	return job;				}
	public String getPay_st			()	{	return pay_st;			}
	public String getPay_type		()	{	return pay_type;		}
	public String getComm_addr 		()	{	return comm_addr;		}
	public String getComm_zip		()	{	return comm_zip;		}
	public String getWk_year		()	{	return wk_year;			}
	public String getBigo_yn		()	{	return bigo_yn;			}
	public String getMain_client	()	{	return main_client;		}
	public String getDly_sms		()	{	return dly_sms;			}
	public String getEtc_cms		()	{	return etc_cms;			}
	public String getFine_yn		()	{	return fine_yn;			}
	public String getItem_mail_yn	()	{	return item_mail_yn;	}
	public String getTax_mail_yn	()	{	return tax_mail_yn;		}
	public String getTaxregno		()	{	return taxregno;		}
	public String getIm_print_st	()	{	return im_print_st;		}
	public String getTm_print_yn	()	{	return tm_print_yn;		}
	public String getBigo_value1	()	{	return bigo_value1;		}	
	public String getBigo_value2	()	{	return bigo_value2;		}	
	public String getPubform		()	{	return pubform;			}	
	public String getPrint_car_st	()	{	return print_car_st;	}	
	public String getNationality	()	{	return nationality;		}	
	public String getEtax_item_st	()	{	return etax_item_st;	}	
	public String getDly_yn			()	{	return dly_yn;			}	
	public String getRepre_nm		()	{	return repre_nm;		}
	public String getCon_agnt_nm2	()	{	return con_agnt_nm2;	}
	public String getCon_agnt_o_tel2()	{	return con_agnt_o_tel2;	}
	public String getCon_agnt_m_tel2() 	{	return con_agnt_m_tel2;	}
	public String getCon_agnt_fax2	()	{	return con_agnt_fax2;	}
	public String getCon_agnt_email2()	{	return con_agnt_email2;	}
	public String getCon_agnt_dept2	()	{	return con_agnt_dept2;	}
	public String getCon_agnt_title2()	{	return con_agnt_title2;	}
	public String getLic_no			()	{	return lic_no;			}	
	public String getCms_sms		()	{	return cms_sms;			}	
	public String getRepre_st2		()	{	return repre_st2;		}
	public String getRepre_ssn2_1		()	{	return repre_ssn2_1;		}
	public String getRepre_ssn2_2		()	{	return repre_ssn2_2;		}
	public String getRepre_addr2		()	{	return repre_addr2;		}
	public String getRepre_zip2		()	{	return repre_zip2;		}
	public String getRepre_email2	()	{	return repre_email2;		}
	public String getRepre_nm2		()	{	return repre_nm2;		}
                                    										
}