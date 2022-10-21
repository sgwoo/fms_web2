package acar.credit;

public class ClsEstBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호               
	private String cls_st;			//해지구분 (1:출고전해지, 2:중도해지, 3:출고전차종변경, 4:출고후차종변경, 5:영업소변경)   
	private String cls_st_r;			//해지구분
	private String term_yn;			//처리구분               
	private String cls_dt;			//해지일자        
	private String reg_id;			//의뢰자ID               
	private String cls_cau;			//해지사유               

	private String trf_dt;			//이관일자   
	private int    grt_amt;			//보증금            
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
	//private int    dfee_s_amt;		//연체월대여료_공급가    
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
	private int    fdft_amt1;		//미납금액                                                                                                                                
	private int    fdft_dc_amt;		//위약금DC금액                                                                                                                                
	private int    fdft_amt2;		//고객이 납입할 금액                                                                                                                       
	private String pay_dt;		   	//위약금지급및환급일                                                                                                                      
	
	//2차 추가
	private String cls_est_dt;		//위약금 입금예정일
	private String dly_days;		//위약금 연체일수
	private int dly_amt;			//위약금 연체금액
	private String vat_st;			//부가가치세 포함 여부
	private String ext_dt;			//세금계산서 발행일
	private String ext_id;			//세금계산서 발행담당자

	//3차 추가
	private String cls_doc_yn;	//중도해지정산서 여부
	private String opt_per;		//매입옵션율
	private int	   opt_amt;		//매입옵션가
	private String opt_dt;		//이전일자
	private int	   no_v_amt;	//미납부가세
	
	private int	   car_ja_amt;	//면책금
	private String r_mon;		//실이용기간
	private String r_day;		//실이용기간
	private int	   fine_amt;	//미납과태료
	private int    etc_amt;		//차량회수외주비
	private int    etc2_amt;		//차량회수부대비
	private int    etc3_amt;		//잔존차량가격
	private int    etc4_amt;		//기타손해배상금	
	
	private int    cls_s_amt;	//해지정산금 공급가
	private int    cls_v_amt;	//해지정산금 부가세
	private int    ex_di_amt;	//과부족대여료
	private String ifee_mon;	//개시대여료경과기간
	private String ifee_day;	//개시대여료경과기간
	private int    ifee_ex_amt;	//개시대여료경과금액
	private int    rifee_s_amt;	//개시대여료잔액금액
	private String cancel_yn;	//매출취소여부
	private String reg_dt;
		
	private String  div_st;				    //구분 1:완납, 2:분납  
	private int	 	div_cnt;			    //분납횟수  
	private String  est_dt;				    //채무자 자구책 약정일  
	private int 	est_amt;                //채권약정금액               
	private String 	est_nm;                 //약정자                   
	private String  gur_nm;                 //대위변제자         
	private String  gur_rel_tel;            //대위변제자 연락처
	private String  gur_rel;                //대위변제자 관계    
	private String  remark;                 //의견   
		 	
    //확정금액, 상각금액    	
 	private int		dfee_amt;                 //대여료(미납대여료+과부족)   
	private int		fine_amt_1;   
	private int		car_ja_amt_1;      
	private int		dly_amt_1;      
	private int		etc_amt_1;      
	private int		etc2_amt_1;      
	private int		dft_amt_1;     
	private int		ex_di_amt_1;      
	private int		nfee_amt_1;      
	private int		etc3_amt_1;      
	private int		etc4_amt_1;      
	 
	private int		no_v_amt_1;      
	private int		fdft_amt1_1;   
	private int		dfee_amt_1;      //과부족+미납대여료   
		
	//세금계산서 관련  
	private String		tax_chk0;   //중도해지위약금 세금계산서
	private String		tax_chk1;   //기타손해배상금 세금계산서   
	private String		tax_chk2;   //잔여개시대여료 세금계산서
	private String		tax_chk3;   //잔여선납금 세금계산서
	private String		tax_chk4;   //외주비용 세금계산서  
	private String		tax_chk5;   //부대비용 세금계산서  
	private String		tax_chk6;   //대여료 세금계산서   	
  	 
	private int		rifee_s_amt_s;   //잔여개시대여료 공급가
	private int		rfee_s_amt_s;    //잔여선납금 공급가     
	private int		etc_amt_s;        //외주비용 공급가        
	private int		etc2_amt_s;       //부대비용 공급가        
	private int		dft_amt_s;        //중도해지위약금 공급가          
	private int		dfee_amt_s;       //대여료 공급가  
	private int		etc4_amt_s;       //기타손해배상금 공급가  
	
	private int		rifee_s_amt_v;        //잔여개시대여료 부가세    
	private int		rfee_s_amt_v;         //잔여선납금 부가세  
	private int		etc_amt_v;             //외주비용 부가세         
	private int		etc2_amt_v;            //부대비용 부가세         
	private int		dft_amt_v;             //중도해지위약금 부가세   
	private int		dfee_amt_v;            //대여료 부가세           
	private int		etc4_amt_v;            //기타손해배상금 부가세   
	
	private String  upd_dt;       //수정일    
    private String  upd_id;       //수정자    
        
   	private int	   car_ja_no_amt;	//면책금 중 미입금된 계산서 미발행금액
   	private String  autodoc_yn;       //회계처리여부(정산시점)  
   	
   	private String dft_int_1;			//위약금적용율    
   	private int	   fdft_amt3;		    // 차량매각시 고객 납입금액     
  
    private String  tax_reg_gu;      //세금계산서 통합발행
    
    private int		tot_dist;    //주행거리 
    private String  cms_chk;      //해지정산금 cms 인출의뢰
    private String  ext_st;      //매입옵션시 환불여부
    
    private String  r_tax_dt;      //해지일이 아닌 계산서 발행일
           
    private int		opt_s_amt;    //매입옵션 공급가액 
    private int		opt_v_amt;    //매입옵션 부가세액 
    
    private String	 dft_cost_id;    //위약금 차액 영업효율 귀속대상 
                 	
     private String	 serv_st;    //예비차 사용가능
     
     private int		over_amt;            //초과운행 예정           
     private int	          over_amt_1;            //초과운행 확정   
     private int	          over_amt_s;            //초과운행 공급가   
     private int	          over_amt_v;            //초과운행 부가세   
     
     private String	 match;    //만기매칭
    
     private int	         m_o_amt;            //매입옵션
     private String	 serv_gubun;    //예비차 적용형태
           	
	public ClsEstBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
		cls_st		= "";     
		cls_st_r	= "";     
		term_yn		= "";    
		cls_dt		= "";     
		reg_id		= "";     
		cls_cau		= "";    
	
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
	//	dfee_s_amt	= 0;   
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
		no_v_amt	= 0;
		car_ja_amt	= 0;
		r_mon		= "";
		r_day		= "";
		fine_amt	= 0;
		etc_amt		= 0;
		etc2_amt	= 0;
		etc3_amt	= 0;
		etc4_amt	= 0;		
						
		cls_s_amt	= 0;
		cls_v_amt	= 0;
		ex_di_amt	= 0;
		ifee_mon	= "";
		ifee_day	= "";
		ifee_ex_amt	= 0;
		rifee_s_amt	= 0;
		cancel_yn	= "";
		reg_dt		= "";
				
		div_st		= "";		
		div_cnt		= 0;       
	 	est_dt		= "";         
		est_amt		= 0;      
		est_nm		= "";         
		gur_nm		= "";        
		gur_rel_tel	= "";       
		gur_rel		= "";         
		remark		= "";     
		 
		dfee_amt	= 0;  
		fine_amt_1	= 0; 
		car_ja_amt_1= 0;     
		dly_amt_1	= 0;    
		etc_amt_1	= 0; 
		etc2_amt_1	= 0;   
		dft_amt_1	= 0;
		ex_di_amt_1 = 0;   
		nfee_amt_1	= 0;    
		etc3_amt_1	= 0;   
		etc4_amt_1	= 0;   
		
		no_v_amt_1	= 0;     
		fdft_amt1_1	= 0;    
		dfee_amt_1	= 0;    
	
		tax_chk0 = "";   //중도해지위약금 세금계산서 
		tax_chk1 = "";   //기타손해배상금 세금계산서   
		tax_chk2 = "";   //잔여개시대여료 세금계산서 
		tax_chk3 = "";   //잔여선납금 세금계산서
		tax_chk4 = "";   //외주비용 세금계산서  
		tax_chk5 = "";   //부대비용 세금계산서  
		tax_chk6 = "";   //대여료 세금계산서   
		  	
		rifee_s_amt_s = 0;   //잔여개시대여료 공급가
		rfee_s_amt_s = 0;    //잔여선납금 공급가     
		
		etc_amt_s = 0;        //외주비용 공급가        
		etc2_amt_s = 0;       //부대비용 공급가        
		dft_amt_s = 0;        //중도해지위약금 공급가          
		dfee_amt_s = 0;       //대여료 공급가  
		
		etc4_amt_s = 0;       //기타손해배상금 공급가  	
		
		rifee_s_amt_v = 0;        //잔여개시대여료 부가세    
		rfee_s_amt_v = 0;         //잔여선납금 부가세        
	      
		etc_amt_v = 0;             //외주비용 부가세         
		etc2_amt_v = 0;            //부대비용 부가세         
		dft_amt_v = 0;             //중도해지위약금 부가세   
		dfee_amt_v = 0;            //대여료 부가세           
		
		etc4_amt_v = 0;            //기타손해배상금 부가세   		
  
		upd_dt  = ""; 
   		upd_id  = "";  	 
       	
    	car_ja_no_amt = 0;   	
    	autodoc_yn = "";       //회계처리여부(정산시점)   	
       	dft_int_1		= "";       	
    	fdft_amt3 = 0;  	 	
                     
        tax_reg_gu = "";
        tot_dist = 0;    //주행거리
        cms_chk = "";
        ext_st = "";
        
        r_tax_dt = "";
               
       	opt_s_amt = 0;    // 
       	opt_v_amt = 0;    // 
			
		dft_cost_id = "";			
		serv_st = "";	
			
		over_amt	= 0;
		over_amt_1	= 0;	
		over_amt_s	= 0;	
		over_amt_v	= 0;	
		match = "";	
			
		m_o_amt	= 0;	
		serv_gubun = "";	

	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}
	public void setCls_st(String str)		{	cls_st		= str; 	}       
	public void setCls_st_r(String str)		{	cls_st_r	= str; 	}       
	public void setTerm_yn(String str)		{	term_yn		= str; 	}
	public void setCls_dt(String str)		{	cls_dt		= str; 	}
	public void setReg_id(String str)		{	reg_id		= str; 	}
	public void setCls_cau(String str)		{	cls_cau		= str; 	}

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
//	public void setDfee_s_amt(int i)		{	dfee_s_amt	= i; 	}
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

	public void setNo_v_amt(int i)			{	no_v_amt	= i;   	}
	public void setCar_ja_amt(int i)		{	car_ja_amt	= i;   	}
	public void setR_mon(String str)		{	r_mon		= str; 	}
	public void setR_day(String str)		{	r_day		= str; 	}
	public void setFine_amt(int i)			{	fine_amt	= i;   	}
	public void setEtc_amt(int i)			{	etc_amt		= i;   	}
	public void setEtc2_amt(int i)			{	etc2_amt	= i;   	}
	public void setEtc3_amt(int i)			{	etc3_amt	= i;   	}
	public void setEtc4_amt(int i)			{	etc4_amt	= i;   	}
						
	public void setCls_s_amt(int i)			{	cls_s_amt	= i;   	}
	public void setCls_v_amt(int i)			{	cls_v_amt	= i;   	}
	public void setEx_di_amt(int i)			{	ex_di_amt	= i;   	}
	public void setIfee_mon(String str)		{	ifee_mon	= str; 	}
	public void setIfee_day(String str)		{	ifee_day	= str; 	}
	public void setIfee_ex_amt(int i)		{	ifee_ex_amt	= i;   	}
	public void setRifee_s_amt(int i)		{	rifee_s_amt	= i;   	}
	public void setCancel_yn(String str)	{	cancel_yn	= str; 	}
	public void setReg_dt(String str)		{	reg_dt		= str; 	}

	public void setDiv_st(String str)		{	div_st		= str; 	}
	public void setDiv_cnt(int i)			{	div_cnt		= i; 	}
	public void setEst_dt(String str)		{	est_dt		= str; 	}
	public void setEst_amt(int i)			{	est_amt		= i; 	}
	public void setEst_nm(String str)		{	est_nm		= str; 	}
	public void setGur_nm(String str)		{	gur_nm		= str; 	}
	public void setGur_rel_tel(String str)	{	gur_rel_tel	= str; 	}
	public void setGur_rel(String str)		{	gur_rel		= str; 	}
	public void setRemark(String str)		{	remark		= str; 	}
		
	public void setDfee_amt(int i)			{	dfee_amt		= i; 	}	
	public void setFine_amt_1(int i)		{	fine_amt_1		= i; 	}	
	public void setCar_ja_amt_1(int i)		{	car_ja_amt_1	= i; 	}	
	public void setDly_amt_1(int i)			{	dly_amt_1		= i; 	}	
	public void setEtc_amt_1(int i)			{	etc_amt_1		= i; 	}	
	public void setEtc2_amt_1(int i)		{	etc2_amt_1		= i; 	}	
	public void setDft_amt_1(int i)			{	dft_amt_1		= i; 	}	
	public void setEx_di_amt_1(int i)		{	ex_di_amt_1		= i; 	}	
	public void setNfee_amt_1(int i)		{	nfee_amt_1		= i; 	}	
	public void setEtc3_amt_1(int i)		{	etc3_amt_1		= i; 	}	
	public void setEtc4_amt_1(int i)		{	etc4_amt_1		= i; 	}	
	public void setNo_v_amt_1(int i)		{	no_v_amt_1		= i; 	}	
	public void setFdft_amt1_1(int i)		{	fdft_amt1_1		= i; 	}	
	public void setDfee_amt_1(int i)		{	dfee_amt_1		= i; 	}	
	
	public void setTax_chk0(String str)		{	tax_chk0		= str; 	}
	public void setTax_chk1(String str)		{	tax_chk1		= str; 	}
	public void setTax_chk2(String str)		{	tax_chk2		= str; 	}
	public void setTax_chk3(String str)		{	tax_chk3		= str; 	}
	public void setTax_chk4(String str)		{	tax_chk4		= str; 	}
	public void setTax_chk5(String str)		{	tax_chk5		= str; 	}
	public void setTax_chk6(String str)		{	tax_chk6		= str; 	}
	
	public void	setRifee_s_amt_s(int i)		{  rifee_s_amt_s	= i;    }
	public void	setRfee_s_amt_s(int i)		{  rfee_s_amt_s		= i;    }		
	
	public void setEtc_amt_s(int i)			{	etc_amt_s		= i; 	}	
	public void setEtc2_amt_s(int i)		{	etc2_amt_s		= i; 	}	
	public void setDft_amt_s(int i)			{	dft_amt_s		= i; 	}	
	public void setDfee_amt_s(int i)		{	dfee_amt_s		= i; 	}	
	
	public void setEtc4_amt_s(int i)		{	etc4_amt_s		= i; 	}	
		
	public void	setRifee_s_amt_v(int i)		{  rifee_s_amt_v	= i;    }
	public void	setRfee_s_amt_v(int i)		{  rfee_s_amt_v		= i;    }		
	
	public void setEtc_amt_v(int i)			{	etc_amt_v		= i; 	}	
	public void setEtc2_amt_v(int i)		{	etc2_amt_v		= i; 	}	
	public void setDft_amt_v(int i)			{	dft_amt_v		= i; 	}	
	public void setDfee_amt_v(int i)		{	dfee_amt_v		= i; 	}	
	
	public void setEtc4_amt_v(int i)		{	etc4_amt_v		= i; 	}	
	
	public void setUpd_dt(String str)		{	upd_dt			= str; 	}	 
	public void setUpd_id(String str)		{	upd_id			= str; 	}	 
		
	public void setCar_ja_no_amt(int i)		{	car_ja_no_amt	= i; 	}	
	public void setAutodoc_yn(String str)	{	autodoc_yn		= str; 	}
			
	public void setDft_int_1(String str)	{	dft_int_1		= str; 	}	
	public void setFdft_amt3(int i)			{	fdft_amt3	= i;   	}
			
	public void setTax_reg_gu(String str)	{	tax_reg_gu	= str; 	}
	public void setTot_dist(int i)			{	tot_dist	= i; 	}
	public void setCms_chk(String str)		{	cms_chk	= str; 	}
	public void setExt_st(String str)		{	ext_st	= str; 	}
		
	public void setR_tax_dt(String str)		{	r_tax_dt	= str; 	}		
		
	public void setOpt_s_amt(int i)			{	opt_s_amt		= i; 	}
	public void setOpt_v_amt(int i)			{	opt_v_amt		= i; 	}
	
	public void setDft_cost_id(String str)	{	dft_cost_id	= str; 	}	 	
	
	public void setServ_st(String str)	{	serv_st	= str; 	}	
	
	public void setOver_amt(int i)		{	over_amt		= i; 	}	
	public void setOver_amt_1(int i)		{	over_amt_1		= i; 	}	
	public void setOver_amt_s(int i)		{	over_amt_s		= i; 	}	
	public void setOver_amt_v(int i)		{	over_amt_v		= i; 	}
	
	public void setMatch(String str)	{	match	= str; 	}		
			
	public void setM_o_amt(int i)		{	m_o_amt		= i; 	}	
	public void setServ_gubun(String str)	{	serv_gubun	= str; 	}	
										
	public String getRent_mng_id()	{	return rent_mng_id;    	}  
	public String getRent_l_cd()	{	return rent_l_cd;      	}    
	public String getCls_st()		{	return cls_st;         	}         
	public String getCls_st_r()		{	return cls_st_r;       	}         
	public String getTerm_yn()		{	return term_yn;        	}      
	public String getCls_dt()		{	return cls_dt;         	}       
	public String getReg_id()		{	return reg_id;         	}       
	public String getCls_cau()		{	return cls_cau;        	}      

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
//	public int    getDfee_s_amt()	{	return dfee_s_amt;     	}   
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
	 
	public int    getNo_v_amt()		{	return no_v_amt;     	}   
	public int    getCar_ja_amt()	{	return car_ja_amt;     	}   
	public String getR_mon()		{	return r_mon;			}   
	public String getR_day()		{	return r_day;			}   
	public int    getFine_amt()		{	return fine_amt;     	}   
	public int    getEtc_amt()		{	return etc_amt;     	}   
	public int    getEtc2_amt()		{	return etc2_amt;     	}   
	public int    getEtc3_amt()		{	return etc3_amt;     	}   
	public int    getEtc4_amt()		{	return etc4_amt;     	}   
	
	public int    getCls_s_amt()	{	return cls_s_amt;     	}   
	public int    getCls_v_amt()	{	return cls_v_amt;     	}   
	public int    getEx_di_amt()	{	return ex_di_amt;     	}   
	public String getIfee_mon()		{	return ifee_mon;		}   
	public String getIfee_day()		{	return ifee_day;		}   
	public int    getIfee_ex_amt()	{	return ifee_ex_amt;    	}   
	public int    getRifee_s_amt()	{	return rifee_s_amt;    	}   
	public String getCancel_yn()	{	return cancel_yn;		}   
	public String getReg_dt()		{	return reg_dt;			}   
						
	public String getDiv_st()		{	return  div_st; 	   	}
	public int	  getDiv_cnt()		{	return  div_cnt; 	    }
	public String getEst_dt()		{	return  est_dt; 		}
	public int 	  getEst_amt()		{	return  est_amt;	 	}
	public String getEst_nm()		{	return  est_nm; 		}
	public String getGur_nm()		{	return  gur_nm; 		}
	public String getGur_rel_tel()	{	return  gur_rel_tel; 	}	
	public String getGur_rel()		{	return  gur_rel; 		}
	public String getRemark()		{	return  remark; 		}	
	
	public int	  getDfee_amt()		{	return  dfee_amt;       }		
	public int	  getFine_amt_1()	{	return  fine_amt_1;      }
	public int	  getCar_ja_amt_1()	{	return  car_ja_amt_1;    }
	public int	  getDly_amt_1()	{	return  dly_amt_1;       }
	public int	  getEtc_amt_1()	{	return  etc_amt_1;       }
	public int	  getEtc2_amt_1()	{	return  etc2_amt_1;      }
	public int	  getDft_amt_1()	{	return  dft_amt_1;       }
	public int	  getEx_di_amt_1()	{	return  ex_di_amt_1;      }
	public int	  getNfee_amt_1()	{	return  nfee_amt_1;      }
	public int	  getEtc3_amt_1()	{	return  etc3_amt_1;      }
	public int	  getEtc4_amt_1()	{	return  etc4_amt_1;      }
	
	public int	  getNo_v_amt_1()	{	return  no_v_amt_1;      }
	public int	  getFdft_amt1_1()	{	return  fdft_amt1_1;     }
	public int	  getDfee_amt_1()	{	return  dfee_amt_1;      }  //과부족+미납대여료

	public String getTax_chk0()		{	return  tax_chk0; 	   	}
	public String getTax_chk1()		{	return  tax_chk1; 	   	}
	public String getTax_chk2()		{	return  tax_chk2; 	   	}
	public String getTax_chk3()		{	return  tax_chk3; 	   	}
	public String getTax_chk4()		{	return  tax_chk4; 	   	}
	public String getTax_chk5()		{	return  tax_chk5; 	   	}
	public String getTax_chk6()		{	return  tax_chk6; 	   	}
	
	public int	  getRifee_s_amt_s(){	return  rifee_s_amt_s;    }
	public int	  getRfee_s_amt_s()	{	return  rfee_s_amt_s;    }		

	public int	  getEtc_amt_s()	{	return  etc_amt_s;       }
	public int	  getEtc2_amt_s()	{	return  etc2_amt_s;      }
	public int	  getDft_amt_s()	{	return  dft_amt_s;       }
	public int	  getDfee_amt_s()	{	return  dfee_amt_s;      }
	
	public int	  getEtc4_amt_s()	{	return  etc4_amt_s;      }
		
	public int	  getRifee_s_amt_v(){	return  rifee_s_amt_v;   }
	public int	  getRfee_s_amt_v()	{	return  rfee_s_amt_v;    }		
	
	public int	  getEtc_amt_v()	{	return  etc_amt_v;       }
	public int	  getEtc2_amt_v()	{	return  etc2_amt_v;      }
	public int	  getDft_amt_v()	{	return  dft_amt_v;       }
	public int	  getDfee_amt_v()	{	return  dfee_amt_v;      }
	
	public int	  getEtc4_amt_v()	{	return  etc4_amt_v;      }
	
	public String getUpd_dt()		{	return 	upd_dt;			 }    
	public String getUpd_id()		{	return 	upd_id; 		 }    
			
	public int    getCar_ja_no_amt(){	return car_ja_no_amt;    }    
	public String getAutodoc_yn()	{	return autodoc_yn;		 }	
	
	public String getDft_int_1()	{	return dft_int_1;        	}      
	public int	  getFdft_amt3()	{	return  fdft_amt3;      }
			
	public String getTax_reg_gu()	{	return  tax_reg_gu;	}		
	public int	  getTot_dist()		{	return  tot_dist;		 }
	public String getCms_chk()		{	return  cms_chk;	}	
	public String getExt_st()		{	return  ext_st;	}	
	
	public String getR_tax_dt()		{	return  r_tax_dt;	}	
			
	public int	  getOpt_s_amt()		{	return opt_s_amt;		 }
	public int	  getOpt_v_amt()		{	return opt_v_amt;		 }
	
	public String getDft_cost_id()		{	return dft_cost_id;	} 
				
	 public String getServ_st()		{	return serv_st;	} 
	 
	public int	  getOver_amt()	{	return  over_amt;      }
	public int	  getOver_amt_1()	{	return  over_amt_1;      }
	public int	  getOver_amt_s()	{	return  over_amt_s;      }
	public int	  getOver_amt_v()	{	return  over_amt_v;      }
	
	public String getMatch()		{	return match;	} 
	 
  	public int	  getM_o_amt()	{	return  m_o_amt;      }
 	public String getServ_gubun()		{	return serv_gubun;	} 
	 
}