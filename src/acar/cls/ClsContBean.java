package acar.cls;

public class ClsContBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호               
	private String cls_st;			//해지구분 (1:출고전해지, 2:중도해지, 3:출고전차종변경, 4:출고후차종변경, 5:영업소변경)
	private String term_yn;			//처리구분               
	private String cls_dt;			//해지일자               
	private String reg_id;			//담당자ID               
	private String cls_cau;			//해지사유               
	private String p_brch_cd;		//구영업소코드           
	private String new_brch_cd;		//신규영업소코드         
	private String trf_dt;			//이관일자               
	private int    ifee_s_amt;		//초기대여료_공급가      
	private int    ifee_v_amt;		//초기대여료_부가세      
	private String ifee_etc;		//초기대여료_비고        
	private int    pp_s_amt;		//선납금_공급가          
	private int    pp_v_amt;		//선납금_부가세          
	private String pp_etc;			//선납금_비고            
	private int    pded_s_amt;		//선납금월공제액_공급가  
	private int    pded_v_amt;		//선납금월공제액_부가세  
	private String pded_etc;		//선납금월공제액_비고    
	private int    tpded_s_amt;		//선납금공제총액_공급가  
	private int    tpded_v_amt;		//선납금공제총액_부가세  
	private String tpded_etc;		//선납금공제총액_비고    
	private int    rfee_s_amt;		//잔여대여료_공급가      
	private int    rfee_v_amt;		//잔여대여료_부가세      
	private String rfee_etc;		//잔여대여료_비고        
	private String dfee_tm;			//연체월대여료_회수      
	private int    dfee_s_amt;		//연체월대여료_공급가    
	private int    dfee_v_amt;		//연체월대여료_부가세    
	private String nfee_tm;			//미수금월대여료_회수    
	private int    nfee_s_amt;		//미수금월대여료_공급가  
	private int    nfee_v_amt;		//미수금월대여료_부가세  
	private String nfee_mon;		//대여료미납이용기간_개월
	private String nfee_day;		//대여료미납이용기간_일
	private String nfee_days;		//대여료미납이용기간_전체일수
	private int    nfee_amt;		//미납대여료             		
	private int    tfee_amt;		//대여료총액             
	private int    mfee_amt;		//환산월평균대여료       
	private String rcon_mon;		//잔여계약기간_개월
	private String rcon_day;		//잔여계약기간_일  
	private String rcon_days;		//잔여계약기간_전체일수
	private int    trfee_amt;		//잔여계약기간대여료총액 
	private String dft_int;			//위약금적용율           
	private int    dft_amt;			//중도해지위약금         
	private String no_dft_yn;		//위약금면제여부                                                                                                                              
	private String no_dft_cau;		//위약금면제사유                                                                                                                              
	private int    fdft_amt1;		//최종위약금1                                                                                                                                 
	private int    fdft_dc_amt;		//위약금DC금액                                                                                                                                
	private int    fdft_amt2;		//최종위약금2                                                                                                                                 
	private String pay_dt;		    	//위약금지급및환급일                                                                                                                          
	/*추가*/
	private String pp_st;			//선납금납입방식
	//2차 추가
	private String cls_est_dt;		//위약금 입금예정일
	private String dly_days;		//위약금 연체일수
	private int dly_amt;			//위약금 연체금액
	private String vat_st;			//부가가치세 포함 여부
	private String ext_dt;			//세금계산서 발행일
	private String ext_id;			//세금계산서 발행담당자
	private int    grt_amt;			//보증금
	//3차 추가
	private String cls_doc_yn;	//중도해지정산서 여부
	private String opt_per;		//매입옵션율
	private int	   opt_amt;		//매입옵션가
	private String opt_dt;		//이전일자
	private String opt_mng;		//이전등록담당자
	private int		no_v_amt;	//미납부가세
	private int		car_ja_amt;	//면책금
	private String r_mon;		//실이용기간
	private String r_day;		//실이용기간
	private int    etc_amt;		//기타비용
	private int    cls_s_amt;	//공급가
	private int    cls_v_amt;	//부가세
	

	public ClsContBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
		cls_st		= "";     
		term_yn		= "";    
		cls_dt		= "";     
		reg_id		= "";     
		cls_cau		= "";    
		p_brch_cd	= "";  
		new_brch_cd	= "";
		trf_dt		= "";     
		ifee_s_amt	= 0;
		ifee_v_amt	= 0;   
		ifee_etc	= "";   
		pp_s_amt	= 0;     
		pp_v_amt	= 0;     
		pp_etc		= "";     
		pded_s_amt	= 0;   
		pded_v_amt	= 0;   
		pded_etc	= "";   
		tpded_s_amt	= 0;  
		tpded_v_amt	= 0;  
		tpded_etc	= "";  
		rfee_s_amt	= 0;   
		rfee_v_amt	= 0;   
		rfee_etc	= "";   
		dfee_tm		= "";    
		dfee_s_amt	= 0;   
		dfee_v_amt	= 0;   
		nfee_tm		= "";    
		nfee_s_amt	= 0;   
		nfee_v_amt	= 0;   
		nfee_mon	= "";
		nfee_day	= "";
		nfee_days	= "";
		nfee_amt	= 0;     
		tfee_amt	= 0;     
		mfee_amt	= 0;     
		rcon_mon	= "";
		rcon_day	= "";  
		rcon_days	= ""; 
		trfee_amt	= 0;    
		dft_int		= "";      
		dft_amt		= 0;      
		no_dft_yn	= "";    
		no_dft_cau	= "";   
		fdft_amt1	= 0;    
		fdft_dc_amt	= 0;  
		fdft_amt2	= 0;    
		pay_dt		= "";       
		pp_st		= "";
		cls_est_dt	= "";
		dly_days	= "";
		dly_amt		= 0;
		vat_st		= "";
		ext_dt		= "";
		ext_id		= "";
		grt_amt		= 0;
		cls_doc_yn	= "";
		opt_per		= "";
		opt_amt		= 0;
		opt_dt		= "";
		opt_mng		= "";
		no_v_amt	= 0;
		car_ja_amt	= 0;
		r_mon		= "";
		r_day		= "";
		etc_amt		= 0;
		cls_s_amt	= 0;
		cls_v_amt	= 0;
		
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}
	public void setCls_st(String str)		{	cls_st		= str; 	}
	public void setTerm_yn(String str)		{	term_yn		= str; 	}
	public void setCls_dt(String str)		{	cls_dt		= str; 	}
	public void setReg_id(String str)		{	reg_id		= str; 	}
	public void setCls_cau(String str)		{	cls_cau		= str; 	}
	public void setP_brch_cd(String str)	{	p_brch_cd	= str; 	}
	public void setNew_brch_cd(String str)	{	new_brch_cd	= str; 	}
	public void setTrf_dt(String str)		{	trf_dt		= str; 	}
	public void setIfee_s_amt(int i)		{	ifee_s_amt	= i;   	}
	public void setIfee_v_amt(int i)		{	ifee_v_amt	= i;   	}
	public void setIfee_etc(String str)		{	ifee_etc	= str; 	}
	public void setPp_s_amt(int i)			{	pp_s_amt	= i; 	}
	public void setPp_v_amt(int i)			{	pp_v_amt	= i; 	}
	public void setPp_etc(String str)		{	pp_etc		= str; 	}
	public void setPded_s_amt(int i)		{	pded_s_amt	= i; 	}
	public void setPded_v_amt(int i)		{	pded_v_amt	= i; 	}
	public void setPded_etc(String str)		{	pded_etc	= str; 	}
	public void setTpded_s_amt(int i)		{	tpded_s_amt	= i; 	}
	public void setTpded_v_amt(int i)		{	tpded_v_amt	= i; 	}
	public void setTpded_etc(String str)	{	tpded_etc	= str; 	}
	public void setRfee_s_amt(int i)		{	rfee_s_amt	= i; 	}
	public void setRfee_v_amt(int i)		{	rfee_v_amt	= i; 	}
	public void setRfee_etc(String str)		{	rfee_etc	= str; 	}
	public void setDfee_tm(String str)		{	dfee_tm		= str; 	}
	public void setDfee_s_amt(int i)		{	dfee_s_amt	= i; 	}
	public void setDfee_v_amt(int i)		{	dfee_v_amt	= i; 	}
	public void setNfee_tm(String str)		{	nfee_tm		= str; 	}
	public void setNfee_s_amt(int i)		{	nfee_s_amt	= i; 	}
	public void setNfee_v_amt(int i)		{	nfee_v_amt	= i; 	}
	public void setNfee_mon(String str)		{	nfee_mon 	= str; 	}
	public void setNfee_day(String str)		{	nfee_day	= str; 	}
	public void setNfee_days(String str)	{	nfee_days	= str; 	}
	public void setNfee_amt(int i)			{	nfee_amt	= i; 	}
	public void setTfee_amt(int i)			{	tfee_amt	= i; 	}
	public void setMfee_amt(int i)			{	mfee_amt	= i; 	}
	public void setRcon_mon(String str)		{	rcon_mon 	= str; 	}
	public void setRcon_day(String str)		{	rcon_day	= str; 	}
	public void setRcon_days(String str)	{	rcon_days	= str; 	}
	public void setTrfee_amt(int i)			{	trfee_amt	= i; 	}
	public void setDft_int(String str)		{	dft_int		= str; 	}
	public void setDft_amt(int i)			{	dft_amt		= i; 	}
	public void setNo_dft_yn(String str)	{	no_dft_yn	= str; 	}
	public void setNo_dft_cau(String str)	{	no_dft_cau	= str; 	}
	public void setFdft_amt1(int i)			{	fdft_amt1	= i; 	}
	public void setFdft_dc_amt(int i)		{	fdft_dc_amt	= i; 	}
	public void setFdft_amt2(int i)			{	fdft_amt2	= i; 	}
	public void setPay_dt(String str)		{	pay_dt		= str; 	}
	public void setPp_st(String str)		{	pp_st		= str; 	}
	public void setCls_est_dt(String str)	{	cls_est_dt	= str; 	}
	public void setDly_days(String str)		{	dly_days	= str; 	}
	public void setDly_amt(int i)			{	dly_amt		= i; 	}
	public void setVat_st(String str)		{	vat_st		= str; 	}
	public void setExt_dt(String str)		{	ext_dt		= str; 	}
	public void setExt_id(String str)		{	ext_id		= str; 	}
	public void setGrt_amt(int i)			{	grt_amt		= i;   	}
	public void setCls_doc_yn(String str)	{	cls_doc_yn	= str; 	}
	public void setOpt_per(String str)		{	opt_per		= str; 	}
	public void setOpt_amt(int i)			{	opt_amt		= i;   	}
	public void setOpt_dt(String str)		{	opt_dt		= str; 	}
	public void setOpt_mng(String str)		{	opt_mng		= str; 	}
	public void setNo_v_amt(int i)			{	no_v_amt	= i;   	}
	public void setCar_ja_amt(int i)		{	car_ja_amt	= i;   	}
	public void setR_mon(String str)		{	r_mon		= str; 	}
	public void setR_day(String str)		{	r_day		= str; 	}
	public void setEtc_amt(int i)			{	etc_amt		= i;   	}
	public void setCls_s_amt(int i)			{	cls_s_amt	= i;   	}
	public void setCls_v_amt(int i)			{	cls_v_amt	= i;   	}
	

	public String getRent_mng_id()	{	return rent_mng_id;    	}  
	public String getRent_l_cd()	{	return rent_l_cd;      	}    
	public String getCls_st()		{	return cls_st;         	}       
	public String getTerm_yn()		{	return term_yn;        	}      
	public String getCls_dt()		{	return cls_dt;         	}       
	public String getReg_id()		{	return reg_id;         	}       
	public String getCls_cau()		{	return cls_cau;        	}      
	public String getP_brch_cd()	{	return p_brch_cd;      	}    
	public String getNew_brch_cd()	{	return new_brch_cd;    	}  
	public String getTrf_dt()		{	return trf_dt;         	}       
	public int    getIfee_s_amt()	{	return ifee_s_amt;     	}   
	public int    getIfee_v_amt()	{	return ifee_v_amt;     	}   
	public String getIfee_etc()		{	return ifee_etc;       	}     
	public int    getPp_s_amt()		{	return pp_s_amt;       	}     
	public int    getPp_v_amt()		{	return pp_v_amt;       	}     
	public String getPp_etc()		{	return pp_etc;         	}       
	public int    getPded_s_amt()	{	return pded_s_amt;     	}	   
	public int    getPded_v_amt()	{	return pded_v_amt;     	}   
	public String getPded_etc()		{	return pded_etc;       	}     
	public int    getTpded_s_amt()	{	return tpded_s_amt;    	}  
	public int    getTpded_v_amt()	{	return tpded_v_amt;    	}  
	public String getTpded_etc()	{	return tpded_etc;      	}    
	public int    getRfee_s_amt()	{	return rfee_s_amt;     	}   
	public int    getRfee_v_amt()	{	return rfee_v_amt;     	}   
	public String getRfee_etc()		{	return rfee_etc;       	}     
	public String getDfee_tm()		{	return dfee_tm;        	}      
	public int    getDfee_s_amt()	{	return dfee_s_amt;     	}   
	public int    getDfee_v_amt()	{	return dfee_v_amt;     	}   
	public String getNfee_tm()		{	return nfee_tm;        	}      
	public int    getNfee_s_amt()	{	return nfee_s_amt;     	}   
	public int    getNfee_v_amt()	{	return nfee_v_amt;     	}   
	public String getNfee_mon()		{	return nfee_mon;		}  
	public String getNfee_day()		{	return nfee_day;    	}  
	public String getNfee_days()	{	return nfee_days;    	}  
	public int    getNfee_amt()		{	return nfee_amt;       	}     
	public int    getTfee_amt()		{	return tfee_amt;       	}     
	public int    getMfee_amt()		{	return mfee_amt;       	}     
	public String getRcon_mon()		{	return rcon_mon;  		}  
	public String getRcon_day()		{	return rcon_day;    	}  
	public String getRcon_days()	{	return rcon_days;    	}  
	public int    getTrfee_amt()	{	return trfee_amt;      	}    
	public String getDft_int()		{	return dft_int;        	}      
	public int    getDft_amt()		{	return dft_amt;        	}      
	public String getNo_dft_yn()	{	return no_dft_yn;      	}    
	public String getNo_dft_cau()	{	return no_dft_cau;     	}   
	public int    getFdft_amt1()	{	return fdft_amt1;      	}    
	public int    getFdft_dc_amt()	{	return fdft_dc_amt;    	}  
	public int    getFdft_amt2()	{	return fdft_amt2;      	}    
	public String getPay_dt()		{	return pay_dt;         	}       
	public String getPp_st()		{	return pp_st;			}       
	public String getCls_est_dt()	{	return cls_est_dt;		}       
	public String getDly_days()		{	return dly_days;		}       
	public int    getDly_amt()		{	return dly_amt;      	}    
	public String getVat_st()		{	return vat_st;			}       
	public String getExt_dt()		{	return ext_dt;			}       
	public String getExt_id()		{	return ext_id;			}       
	public int    getGrt_amt()		{	return grt_amt;     	}   
	public String getCls_doc_yn()	{	return cls_doc_yn;		}       
	public String getOpt_per()		{	return opt_per;			}       
	public int    getOpt_amt()		{	return opt_amt;     	}   
	public String getOpt_dt()		{	return opt_dt;			}       
	public String getOpt_mng()		{	return opt_mng;			}   
	public int    getNo_v_amt()		{	return no_v_amt;     	}   
	public int    getCar_ja_amt()	{	return car_ja_amt;     	}   
	public String getR_mon()		{	return r_mon;			}   
	public String getR_day()		{	return r_day;			}   
	public int    getEtc_amt()		{	return etc_amt;     	}   
	public int    getCls_s_amt()	{	return cls_s_amt;     	}   
	public int    getCls_v_amt()	{	return cls_v_amt;     	}   
	   
}