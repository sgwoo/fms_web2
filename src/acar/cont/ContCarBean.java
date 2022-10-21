package acar.cont;

public class ContCarBean
{
	public String rent_mng_id			= "";
	public String rent_l_cd				= "";
	public String car_id				= "";
	public String colo					= "";
	public String ex_gas				= "";
	public int    imm_amt				= 0;
	public String opt					= "";
	public String lpg_yn				= ""; 
	public String lpg_setter			= "";
	public int    lpg_price				= 0; 
	public String lpg_pay_dt			= ""; 
	public int    car_cs_amt			= 0; 
	public int    car_cv_amt			= 0; 
	public int    car_fs_amt			= 0; 
	public int    car_fv_amt			= 0;  
	public int    opt_cs_amt			= 0;  
	public int    opt_cv_amt			= 0;  
	public int    opt_amt_m				= 0;  
	public int    opt_fs_amt			= 0;  
	public int    opt_fv_amt			= 0;  
	public int    clr_cs_amt			= 0;  
	public int    clr_cv_amt			= 0;  
	public int    clr_fs_amt			= 0;  
	public int    clr_fv_amt			= 0;  
	public int    sd_cs_amt				= 0; 
	public int    sd_cv_amt				= 0; 
	public int    sd_fs_amt				= 0;
	public int    sd_fv_amt				= 0;
	public int    dc_cs_amt				= 0; 
	public int    dc_cv_amt				= 0; 
	public int    dc_fs_amt				= 0;
	public int    dc_fv_amt				= 0;	
	public String car_comp_nm			= "";		/*추가*/
	public String car_comp_cd			= "";
	public String car_cd				= "";
	public String purc_gu				= "";
	public String car_ext				= "";
	public String bae4					= "";		
	public String gi_st					= "0";		//5/19추가	
	public String add_opt				= "";		//11/10추가	
	public String opt_code				= "";		//2004-02-03 추가
	public String car_seq				= "";
	public String dlv_dt				= "";	
	public String reg_est_dt			= "";		//2007-07-10추가
	public int    sun_per				= 0;
	public String extra_set				= "";
	public String remark				= "";
	public String s_dc1_re				= "";
	public String s_dc1_yn				= "";
	public int    s_dc1_amt				= 0;
	public String s_dc2_re				= "";
	public String s_dc2_yn				= "";
	public int    s_dc2_amt				= 0;
	public String s_dc3_re				= "";
	public String s_dc3_yn				= "";
	public int    s_dc3_amt				= 0;
	public String pay_st				= "";
	public int    spe_tax				= 0;
	public int    edu_tax				= 0;
	public String car_origin			= "";
	public int    sh_car_amt			= 0;
	public String sh_year				= "";
	public String sh_month				= "";
	public String sh_day				= "";
	public String sh_day_bas_dt			= "";
	public int    sh_amt				= 0;
	public float  sh_ja					= 0;
	public int    sh_km					= 0;
	public int    sh_tot_km				= 0;
	public String sh_km_bas_dt			= "";
	public String lpg_kit				= "";
	public String rent_st				= "";
	public String chk_id				= "";
	public String chk_dt				= "";
	public String cms_not_cau			= "";
	public int    add_opt_amt			= 0;
	public String s_dc1_re_etc			= "";
	public String s_dc2_re_etc			= "";
	public String s_dc3_re_etc			= "";
	public float  s_dc1_per				= 0;
	public float  s_dc2_per				= 0;
	public float  s_dc3_per				= 0;
	public String car_amt_dt			= "";
	public String sh_init_reg_dt		= "";		
	public String bus_agnt_id			= "";		//영업대리인
	public float  bus_agnt_per			= 0;		//영업대리인실적-규정
	public float  bus_agnt_r_per		= 0;		//영업대리인실적-계약
	public int    extra_amt				= 0;		//견적미반영서비스품목 금액
	public String cls_n_mon				= "";		//위약금면제개월수
	public int    cls_n_amt				= 0;		//대차계약시 이전차위약면제금액
	public String bc_est_id				= "";		//영업효율변수-견적번호
	public int    bc_s_a				= 0;		//영업효율변수-10만원당월할부금
	public String bc_s_b				= "";		//영업효율변수-계약기간
	public int    bc_s_c				= 0;		//영업효율변수-기준대여료
	public float  bc_s_d				= 0;		//영업효율변수-목표마진율
	public float  bc_s_e				= 0;		//영업효율변수-대여요금할인율
	public int    bc_s_f				= 0;		//영업효율변수-자체출고효율
	public int    bc_s_g				= 0;		//영업효율변수-정상대여료
	public float  bc_s_i				= 0;		//영업효율변수-캐쉬백율-실결제기준
	public float  bc_s_i2				= 0;		//영업효율변수-캐쉬백율-견적반영분
	public int    bc_b_a				= 0;		//영업효율변수-기본식월관리비
	public int    bc_b_b				= 0;		//영업효율변수-일바식추가월관리비
	public int    bc_b_d				= 0;		//영업효율변수-재리스초기영업비용
	public float  bc_b_e1				= 0;		//영업효율변수-낙찰승수반영율
	public int    bc_b_e2				= 0;		//영업효율변수-경매장예상낙찰가격
	public int    bc_b_k				= 0;		//영업효율변수-초우량일반식추가월관리비
	public int    bc_b_n				= 0;		//영업효율변수-견적메이커탁송료
	public int    bc_b_c				= 0;		//영업효율변수-기대마진
	public int    bc_b_e				= 0;		//영업효율변수-중고차평가이익
	public int    bc_b_g				= 0;		//영업효율변수-기타이익
	public int    bc_b_u				= 0;		//영업효율변수-기타비용
	public int    bc_b_ac				= 0;		//영업효율변수-기타반영
	public int    agree_dist			= 0;		//LPG견적-약정운행거리
	public String bc_b_g_cont			= "";		//영업효율변수-기타이익내용
	public String bc_b_u_cont			= "";		//영업효율변수-기타비용내용
	public String bc_b_ac_cont			= "";		//영업효율변수-기타반영내용
	public String bc_etc				= "";		//영업효율변수-유의사항
	public int    over_run_amt			= 0;		//LPG견적-초과운행부담금
	public int    over_run_day			= 0;		//LPG견적-초과운행부담금
	public int    over_serv_amt			= 0;		//정비비용상한금액
	public String agree_dist_yn			= "";		//약정운행거리 제한유무
	public int    min_agree_dist		= 0;		//약정운행거리허용범위
	public int    max_agree_dist		= 0;		//약정운행거리허용범위
	public String cng_chk_id			= "";		//계약변경점검자
	public String cng_chk_dt			= "";		//계약변경점검일
	public String cng_chk_st			= "";		//계약변경구분
	public String reg_dt				= "";		//등록일자
	public String in_col				= "";		//내장칼라	
	public String garnish_col			= "";		//가니쉬칼라	
	public String hipass_yn				= "";		//20120612 하이패스여부	
	public String bluelink_yn			= "";		//20181012 블루링크여부(현대자동차이며 신차일경우에만)	
	public String car_tax_dt			= "";		//20120719 차량매입세금계산서일자
	public int    import_card_amt		= 0;		//수입차 카드결제금액
	public int    import_cash_back		= 0;		//수입차 (현금)캐쉬백금액
	public String con_day				= "";		//대여일수(월렌트)
	public String con_etc				= "";		//계약서기타특이사항
	public int    import_bank_amt		= 0;		//수입차 금융비용
	public int    bc_b_t				= 0;		//영업효율변수-용품사양
	public int    over_bas_km			= 0;		//보유차 계약시점 주행거리 - 계약서상 주행거리
	public int    r_import_cash_back	= 0;		//수입차 (현금)캐쉬백금액 실발생분
	public int    r_import_bank_amt		= 0;		//수입차 금융비용 실발생분
	public String tint_b_yn				= "";		//20141223 용품-블랙박스
	public String tint_s_yn				= "";		//20141223 용품-썬팅	-> 2017.12.22 용품 전면 썬팅(기본형) 
	public String tint_ps_yn			= "";		// 용품 고급 썬팅						2017.12.22
	public String tint_ps_nm			= "";		// 용품 고급 썬팅 내용
	public int 	  tint_ps_amt			= 0;		// 용품 고급 썬팅 추가금액(공급가)
	public String tint_ps_st			= "";		// 용품 고급 썬팅 선택값
	public String tint_n_yn				= "";		//20141223 용품-내비게이션
	public String tint_bn_yn			= "";		//20200422 용품-블랙박스 미제공 할인(빌트인캠)
	public String tint_bn_nm			= "";		//20220502 용품-블랙박스 미제공 할인(빌트인캠,고객장착) 사유
	public String tint_sn_yn			= "";		//20210831 용품-전면썬팅미시공할인
	public String new_license_plate		= "";		//20201117 용품-신형번호판신청
	public String second_license_plate	= "";		//20201127 보조번호판
	public String tint_cons_yn			= "";		//20200615 용품-추가탁송료등 선택
	public int    tint_cons_amt			= 0;		//20200615 용품-추가탁송료등 입력값
	public int    cust_est_km			= 0;		//20141223 고객예상주행거리
	public int    tint_s_per			= 0;		//20141229 용품-썬팅투과율
	public String bus_yn				= "";		//계약여부
	public String bus_cau				= "";		//미계약이유
	public String bus_cau_dt			= "";		//미계약이유등록일시
	public String serv_b_yn				= "";		//20150724 서비스품목-블랙박스
	public String serv_sc_yn			= "";		//20180412 서비스품목-고정형충전기
	public String jg_opt_st				= ""; 		//사양 잔가 조정 변수
	public String jg_col_st				= ""; 		//색상 잔가 조정 변수
	public String credit_sac_id			= ""; 		//20160222 채권확보결재자
	public String credit_sac_dt			= ""; 		//20160222 채권확보결재일자
	public String dc_ra_st			    = ""; 		//20160222 대여료DC 적용근거
	public String dc_ra_sac_id			= ""; 		//20160222 대여료DC 결재자
	public String dc_ra_etc			    = ""; 		//20160222 대여료DC 적요
	public int    tax_dc_s_amt			= 0;		//20160811 친환경차 개소세 감면액
	public int    tax_dc_v_amt	        = 0;		//20160811 친환경차 개소세 감면액
	public int    ecar_pur_sub_amt		= 0;		//20160811 친환경차 구매보조금
	public String ecar_pur_sub_st 		= "";		//20160811 친환경차 구매보조금 수령방식
	public String conti_rat             = "";       //20161101 연비정보
	public int    commi_s_amt			= 0;		//20161206 중고차 수수료
	public int    commi_v_amt	        = 0;		//20161206 중고차 수수료
	public int    accid_serv_amt		= 0;		//20161206 중고차 추정수리비
	public int    sh_est_amt			= 0;		//20161206 경매장시세
	public String accid_serv_cont 		= "";		//20161214 중고차 사고내용
	public int    driver_add_amt		= 0;		//20170309 운전자추가요금(공급가)
	public int    driver_add_v_amt		= 0;		//20180330 운전자추가요금(부가세)
	public String jg_tuix_st			= "";		//tuix/tuon 트림 여부
	public String jg_tuix_opt_st		= "";		//tuix/tuon 옵션 여부
	public String eco_e_tag				= "";		//맑은서울스티커 발급
	public String lkas_yn				= "";		// 2017. 11. 16		차선이탈 제어형
	public String lkas_yn_opt_st 		= "";		// 2017. 11. 16		차선이탈 제어형(옵션)
	public String ldws_yn				= "";		// 2017. 11. 16		차선이탈 경고형
	public String ldws_yn_opt_st 		= "";		// 2017. 11. 16		차선이탈 경고형(옵션)
	public String aeb_yn				= "";		// 2017. 11. 16		긴급제동 제어형
	public String aeb_yn_opt_st 		= "";		// 2017. 11. 16		긴급제동 제어형(옵션)
	public String fcw_yn				= "";		// 2017. 11. 16		긴급제동 경고형
	public String fcw_yn_opt_st			="";		// 2017. 11. 16		긴급제동 경고형(옵션)
	public String ev_yn					="";		// 2017. 11. 22		전기차 여부
	public String tint_eb_yn			= "";		//20180406 이동형충전기
	public int    storage_s_amt			= 0;		//20181010 중고차 보관료
	public int    storage_v_amt	        = 0;		//20181010 중고차 보관료
	public String return_select			="";		//20190201 전기차/수소차 인수/반납 유형
	public String van_add_opt			="";		//20190717 출고후추가장착옵션(화물차)
	public String others_device			="";		//20191202 기타장치 
	public String hook_yn				= "";		// 20200602		견인고리
	public String hook_yn_opt_st		="";		// 20200602		견인고리(옵션)
	public String br_to_st				=""; 		//고객주소지(차량인도지역) 선택값
	public String br_to					=""; 		//고객주소지(차량인도지역)
	public String br_from				="";		//차량현위치
	public String br_from_st			="";		//차량현위치 선택값
	public String bc_dlv_yn				="";		//출고일견적기준
	public int    rtn_run_amt			= 0;		//20220325 환급대여료
	public String rtn_run_amt_yn		="";		//20220412 환급대여료적용여부
	public String top_cng_yn			="";		//20220922 탑차(구조변경)
	

	public void setRent_mng_id			(String str)		{	rent_mng_id			= str;	}
	public void setRent_l_cd			(String str)		{	rent_l_cd			= str;	}  
	public void setCar_id				(String str)		{   car_id				= str;	}
	public void setColo					(String str)        {   colo				= str;	}
	public void setEx_gas				(String str)		{   ex_gas				= str;	}
	public void setImm_amt				(int i)				{   imm_amt				= i;	}
	public void setOpt					(String str)        {   opt					= str;	}
	public void setLpg_yn				(String str)		{  	lpg_yn				= str;	}
	public void setLpg_setter			(String str)		{  	lpg_setter			= str;	}
	public void setLpg_price			(int i)				{  	lpg_price			= i;	}
	public void setLpg_pay_dt			(String str)		{  	lpg_pay_dt			= str;	}
	public void setCar_cs_amt			(int i)				{  	car_cs_amt			= i;	}
	public void setCar_cv_amt			(int i)				{   car_cv_amt			= i;	}
	public void setCar_fs_amt			(int i)				{   car_fs_amt			= i;	}
	public void setCar_fv_amt			(int i)				{   car_fv_amt			= i;	}
	public void setOpt_cs_amt			(int i)				{   opt_cs_amt			= i;	}
	public void setOpt_cv_amt			(int i)				{   opt_cv_amt			= i;	}
	public void setOpt_amt_m			(int i)				{   opt_amt_m			= i;	}
	public void setOpt_fs_amt			(int i)				{   opt_fs_amt			= i;	}
	public void setOpt_fv_amt			(int i)				{   opt_fv_amt			= i;	}
	public void setClr_cs_amt			(int i)				{   clr_cs_amt			= i;	}
	public void setClr_cv_amt			(int i)				{   clr_cv_amt			= i;	}
	public void setClr_fs_amt			(int i)				{   clr_fs_amt			= i;	}
	public void setClr_fv_amt			(int i)				{   clr_fv_amt			= i;	}
	public void setSd_cs_amt			(int i)				{   sd_cs_amt			= i;	}
	public void setSd_cv_amt			(int i)				{   sd_cv_amt			= i;	}
	public void setSd_fs_amt			(int i)				{   sd_fs_amt			= i;	}
	public void setSd_fv_amt			(int i)				{   sd_fv_amt			= i;	}
	public void setDc_cs_amt			(int i)				{   dc_cs_amt			= i;	}
	public void setDc_cv_amt			(int i)				{   dc_cv_amt			= i;	}
	public void setDc_fs_amt			(int i)				{   dc_fs_amt			= i;	}
	public void setDc_fv_amt			(int i)				{   dc_fv_amt			= i;	}
	public void setPurc_gu				(String str)		{   purc_gu				= str;	}
	public void setCar_ext				(String str)		{   car_ext				= str;	}
	public void setBae4					(String str)		{   bae4				= str;	}
	public void setGi_st				(String str)		{   gi_st				= str;	}
	public void setAdd_opt				(String str)		{   add_opt				= str;	}
	public void setOpt_code				(String str)		{   opt_code			= str;	}
	public void setCar_seq				(String str)		{   car_seq				= str;	}
	public void setDlv_dt				(String str)	    {   dlv_dt				= str;	}
	public void setReg_est_dt			(String str)		{	reg_est_dt			= str;	}
	public void setSun_per				(int i)				{   sun_per				= i;	}
	public void setExtra_set			(String str)		{	extra_set			= str;	}
	public void setRemark				(String str)		{	remark				= str;	}  
	public void setS_dc1_re				(String str)		{   s_dc1_re			= str;	}
	public void setS_dc1_yn				(String str)        {   s_dc1_yn			= str;	}
	public void setS_dc1_amt			(int i)				{   s_dc1_amt			= i;	}
	public void setS_dc2_re				(String str)		{   s_dc2_re			= str;	}
	public void setS_dc2_yn				(String str)        {   s_dc2_yn			= str;	}
	public void setS_dc2_amt			(int i)				{   s_dc2_amt			= i;	}
	public void setS_dc3_re				(String str)		{   s_dc3_re			= str;	}
	public void setS_dc3_yn				(String str)        {   s_dc3_yn			= str;	}
	public void setS_dc3_amt			(int i)				{   s_dc3_amt			= i;	}
	public void setPay_st				(String str)		{   pay_st				= str;	}
	public void setSpe_tax				(int i)				{   spe_tax				= i;	}
	public void setEdu_tax				(int i)				{   edu_tax				= i;	}
	public void setCar_origin			(String str)		{   car_origin			= str;	}
	public void setCar_comp_nm			(String str)		{   car_comp_nm			= str;	}
	public void setCar_comp_cd			(String str)		{   car_comp_cd			= str;	}
	public void setCar_cd				(String str)		{   car_cd				= str;	}
	public void setSh_car_amt			(int    i)			{   sh_car_amt			= i;	}
	public void setSh_year				(String str)		{   sh_year				= str;	}
	public void setSh_month				(String str)		{   sh_month			= str;	}
	public void setSh_day				(String str)		{   sh_day				= str;	}
	public void setSh_day_bas_dt		(String str)		{   sh_day_bas_dt		= str;	}
	public void setSh_amt				(int    i)			{   sh_amt				= i;	}
	public void setSh_ja				(float  i)			{   sh_ja				= i;	}
	public void setSh_km				(int    i)			{   sh_km				= i;	}
	public void setSh_tot_km			(int    i)			{   sh_tot_km			= i;	}
	public void setSh_km_bas_dt			(String str)		{   sh_km_bas_dt		= str;	}
	public void setLpg_kit				(String str)		{   lpg_kit				= str;	}
	public void setRent_st				(String str)		{   rent_st				= str;	}
	public void setChk_id				(String str)		{   chk_id				= str;	}
	public void setChk_dt				(String str)		{   chk_dt				= str;	}
	public void setCms_not_cau			(String str)		{   cms_not_cau			= str;	}
	public void setAdd_opt_amt			(int i)				{   add_opt_amt			= i;	}
	public void setS_dc1_re_etc			(String str)		{   s_dc1_re_etc		= str;  }
	public void setS_dc2_re_etc			(String str)		{   s_dc2_re_etc		= str;  }
	public void setS_dc3_re_etc			(String str)		{   s_dc3_re_etc		= str;	}
	public void setS_dc1_per			(float  i)			{   s_dc1_per			= i;	}
	public void setS_dc2_per			(float  i)			{   s_dc2_per			= i;	}
	public void setS_dc3_per			(float  i)			{   s_dc3_per			= i;	}
	public void setCar_amt_dt			(String str)		{   car_amt_dt			= str;	}
	public void setSh_init_reg_dt		(String str)		{   sh_init_reg_dt		= str;	}
	public void setBus_agnt_id			(String str)		{   bus_agnt_id			= str;	}
	public void setBus_agnt_per			(float  i)			{   bus_agnt_per		= i;	}
	public void setBus_agnt_r_per		(float  i)			{   bus_agnt_r_per		= i;	}
	public void setExtra_amt			(int i)				{   extra_amt			= i;	}
	public void setCls_n_mon			(String str)		{   cls_n_mon			= str;  }
	public void setCls_n_amt			(int i)				{   cls_n_amt			= i;	}
	public void setBc_est_id			(String str)		{   bc_est_id			= str;	}
	public void setBc_s_a				(int    i  )		{   bc_s_a				= i;	}
	public void setBc_s_b				(String str)		{   bc_s_b				= str;  }
	public void setBc_s_c				(int    i  )		{   bc_s_c				= i;	}
	public void setBc_s_d				(float  i  )		{   bc_s_d				= i;	}
	public void setBc_s_e				(float  i  )		{   bc_s_e				= i;	}
	public void setBc_s_f				(int    i  )		{   bc_s_f				= i;	}
	public void setBc_s_g				(int    i  )		{   bc_s_g				= i;	}
	public void setBc_s_i				(float  i  )		{   bc_s_i				= i;	}
	public void setBc_s_i2				(float  i  )		{   bc_s_i2				= i;	}
	public void setBc_b_a				(int    i  )		{   bc_b_a				= i;	}
	public void setBc_b_b				(int    i  )		{   bc_b_b				= i;	}
	public void setBc_b_d				(int    i  )		{   bc_b_d				= i;	}
	public void setBc_b_e1				(float  i  )		{   bc_b_e1				= i;	}
	public void setBc_b_e2				(int    i  )		{   bc_b_e2				= i;	}
	public void setBc_b_k				(int    i  )		{   bc_b_k				= i;	}
	public void setBc_b_n				(int    i  )		{   bc_b_n				= i;	}
	public void setBc_b_c				(int    i  )		{   bc_b_c				= i;	}
	public void setBc_b_e				(int    i  )		{   bc_b_e				= i;	}
	public void setBc_b_g				(int    i  )		{   bc_b_g				= i;	}
	public void setBc_b_u				(int    i  )		{   bc_b_u				= i;	}
	public void setBc_b_ac				(int    i  )		{   bc_b_ac				= i;	}
	public void setAgree_dist			(int	i  )		{   agree_dist			= i;	}
	public void setBc_b_g_cont			(String str)		{   bc_b_g_cont			= str;  }
	public void setBc_b_u_cont			(String str)		{   bc_b_u_cont			= str;  }
	public void setBc_b_ac_cont			(String str)		{   bc_b_ac_cont		= str;  }
	public void setBc_etc				(String str)		{   bc_etc				= str;  }
	public void setOver_run_amt			(int    i  )		{   over_run_amt		= i;	}
	public void setOver_run_day			(int    i  )		{   over_run_day		= i;	}
	public void setOver_serv_amt		(int    i  )		{   over_serv_amt		= i;	}
	public void setAgree_dist_yn		(String str)		{   agree_dist_yn		= str;  }
	public void setMin_agree_dist		(int	i  )		{   min_agree_dist		= i;	}
	public void setMax_agree_dist		(int	i  )		{   max_agree_dist		= i;	}
	public void setCng_chk_id			(String str)		{   cng_chk_id			= str;	}
	public void setCng_chk_dt			(String str)		{   cng_chk_dt			= str;	}
	public void setCng_chk_st			(String str)		{   cng_chk_st			= str;	}
	public void setReg_dt				(String str)		{   reg_dt				= str;	}
	public void setIn_col				(String str)		{   in_col				= str;	}
	public void setGarnish_col			(String str)		{   garnish_col			= str;	}
	public void setHipass_yn			(String str)		{	hipass_yn			= str;	}		
	public void setBluelink_yn			(String str)		{	bluelink_yn			= str;	}		
	public void setCar_tax_dt			(String str)		{	car_tax_dt			= str;	}		
	public void setImport_card_amt		(int	i  )		{   import_card_amt		= i;	}
	public void setImport_cash_back		(int	i  )		{   import_cash_back	= i;	}
	public void setCon_day				(String str)		{	con_day				= str;	}		
	public void setCon_etc				(String str)		{	con_etc				= str;	}
	public void setImport_bank_amt		(int	i  )		{   import_bank_amt		= i;	}	
	public void setBc_b_t				(int    i  )		{   bc_b_t				= i;	}
	public void setOver_bas_km			(int    i  )		{   over_bas_km			= i;	}
	public void setR_import_cash_back	(int	i  )		{   r_import_cash_back	= i;	}
	public void setR_import_bank_amt	(int	i  )		{   r_import_bank_amt	= i;	}
	public void setTint_b_yn			(String str)		{	tint_b_yn			= str;	}		
	public void setTint_s_yn			(String str)		{	tint_s_yn			= str;	}
	public void setTint_ps_yn			(String str)		{	tint_ps_yn			= str;	}
	public void setTint_ps_nm			(String str)		{	tint_ps_nm			= str;	}
	public void setTint_ps_amt			(int 	i  )		{	tint_ps_amt			= i;	}
	public void setTint_ps_st			(String str)		{	tint_ps_st			= str;	}
	public void setTint_n_yn			(String str)		{	tint_n_yn			= str;	}
	public void setTint_bn_yn			(String str)		{	tint_bn_yn			= str;	}
	public void setTint_bn_nm			(String str)		{	tint_bn_nm			= str;	}
	public void setTint_sn_yn			(String str)		{	tint_sn_yn			= str;	}
	public void setNew_license_plate	(String str)		{	new_license_plate	= str;	}
	public void setSecond_license_plate	(String str)		{	second_license_plate= str;	}
	public void setTint_cons_yn			(String str)		{	tint_cons_yn		= str;	}
	public void setTint_cons_amt		(int 	i  )		{	tint_cons_amt		= i;	}
	public void setCust_est_km			(int    i  )		{   cust_est_km			= i;	}
	public void setTint_s_per			(int    i  )		{   tint_s_per			= i;	}
	public void setBus_yn				(String val)		{	if(val==null) val="";	this.bus_yn			= val;	}	
	public void setBus_cau				(String val)		{	if(val==null) val="";	this.bus_cau		= val;	}	
	public void setBus_cau_dt			(String val)		{	if(val==null) val="";	this.bus_cau_dt		= val;	}	
	public void setServ_b_yn			(String str)		{	serv_b_yn			= str;	}
	public void setServ_sc_yn			(String str)		{	serv_sc_yn			= str;	}
	public void setJg_opt_st			(String val)		{	if(val==null) val="";	this.jg_opt_st		= val;	}
	public void setJg_col_st			(String val)		{	if(val==null) val="";	this.jg_col_st		= val;	}	
	public void setCredit_sac_id		(String str)		{   credit_sac_id		= str;	}
	public void setCredit_sac_dt		(String str)		{   credit_sac_dt		= str;	}
	public void setDc_ra_st				(String str)		{   dc_ra_st			= str;	}
	public void setDc_ra_sac_id			(String str)		{   dc_ra_sac_id		= str;	}
	public void setDc_ra_etc			(String str)		{   dc_ra_etc			= str;	}	
	public void setTax_dc_s_amt			(int i)				{   tax_dc_s_amt		= i;	}
	public void setTax_dc_v_amt	  		(int i)				{   tax_dc_v_amt	 	= i;	}
	public void setEcar_pur_sub_amt		(int i)				{   ecar_pur_sub_amt	= i;	}
	public void setEcar_pur_sub_st 		(String str)		{   ecar_pur_sub_st 	= str;	}
	public void setConti_rat            (String str)        {   conti_rat           = str;  }
	public void setCommi_s_amt			(int i)				{   commi_s_amt			= i;	}
	public void setCommi_v_amt			(int i)				{   commi_v_amt	 		= i;	}
	public void setAccid_serv_amt		(int i)				{   accid_serv_amt		= i;	}
	public void setSh_est_amt			(int i)				{   sh_est_amt			= i;	}
	public void setAccid_serv_cont 		(String str)		{   accid_serv_cont 	= str;	}
	public void setDriver_add_amt		(int i)				{	driver_add_amt		= i;	}
	public void setDriver_add_v_amt		(int i)				{	driver_add_v_amt	= i;	}	//2018.03.30 
	public void setJg_tuix_st			(String val)		{	jg_tuix_st			= val;	}	
	public void setJg_tuix_opt_st		(String val)		{	jg_tuix_opt_st		= val;	}		
	public void setEco_e_tag			(String val)		{	eco_e_tag			= val;	}	
	public void setLkas_yn				(String val)		{	lkas_yn				= val;	}	
	public void setLkas_yn_opt_st		(String val)		{	lkas_yn_opt_st		= val;	}		
	public void setLdws_yn				(String val)		{	ldws_yn				= val;	}	
	public void setLdws_yn_opt_st		(String val)		{	ldws_yn_opt_st		= val;	}		
	public void setAeb_yn				(String val)		{	aeb_yn				= val;	}	
	public void setAeb_yn_opt_st		(String val)		{	aeb_yn_opt_st		= val;	}		
	public void setFcw_yn				(String val)		{	fcw_yn				= val;	}	
	public void setFcw_yn_opt_st		(String val)		{	fcw_yn_opt_st		= val;	}
	public void setEv_yn				(String val)		{	ev_yn				= val;	}	
	public void setTint_eb_yn			(String str)		{	tint_eb_yn			= str;	}
	public void setStorage_s_amt		(int i)				{   storage_s_amt		= i;	}
	public void setStorage_v_amt		(int i)				{   storage_v_amt	 	= i;	}
	public void setReturn_select		(String val)		{	return_select		= val;	}
	public void setVan_add_opt			(String val)		{	van_add_opt			= val;	}	
	public void setOthers_device		(String val)		{	others_device		= val;	}
	public void setHook_yn				(String val)		{	hook_yn				= val;	}	
	public void setHook_yn_opt_st		(String val)		{	hook_yn_opt_st		= val;	}
	public void setBr_to_st				(String val)		{	br_to_st			= val;	}	
	public void setBr_from_st			(String val)		{	br_from_st			= val;	}	
	public void setBr_to				(String val)		{	br_to				= val;	}	
	public void setBr_from				(String val)		{	br_from				= val;	}
	public void setBc_dlv_yn			(String val)		{	bc_dlv_yn			= val;	}
	public void setRtn_run_amt			(int    i  )		{   rtn_run_amt			= i;	}
	public void setRtn_run_amt_yn		(String val)		{	rtn_run_amt_yn		= val;	}
	public void setTop_cng_yn			(String val)		{	top_cng_yn			= val;	}
	


	public String getRent_mng_id		()		{ 	return rent_mng_id;			}
	public String getRent_l_cd			()		{ 	return rent_l_cd;			}
	public String getCar_id				()		{   return car_id;				}
	public String getColo				()		{   return colo;				}
	public String getEx_gas				()		{   return ex_gas;				}
	public int    getImm_amt			()		{   return imm_amt;				}
	public String getOpt				()		{   return opt;					}
	public String getLpg_yn				()		{   return lpg_yn;				}
	public String getLpg_setter			()		{   return lpg_setter;			}
	public int    getLpg_price			()		{   return lpg_price;			}
	public String getLpg_pay_dt			()		{   return lpg_pay_dt;			}
	public int    getCar_cs_amt			()		{	return car_cs_amt;			}
	public int    getCar_cv_amt			()		{   return car_cv_amt;			}
	public int    getCar_fs_amt			()		{   return car_fs_amt;			}
	public int    getCar_fv_amt			()		{   return car_fv_amt;			}
	public int    getOpt_cs_amt			()		{   return opt_cs_amt;			}
	public int    getOpt_cv_amt			()		{   return opt_cv_amt;			}
	public int    getOpt_amt_m			()		{   return opt_amt_m;			}
	public int    getOpt_fs_amt			()		{   return opt_fs_amt;			}
	public int    getOpt_fv_amt			()		{   return opt_fv_amt;			}
	public int    getClr_cs_amt			()		{   return clr_cs_amt;			}
	public int    getClr_cv_amt			()		{   return clr_cv_amt;			}
	public int    getClr_fs_amt			()		{   return clr_fs_amt;			}
	public int    getClr_fv_amt			()		{   return clr_fv_amt;			}
	public int    getSd_cs_amt			()		{   return sd_cs_amt;			}
	public int    getSd_cv_amt			()		{   return sd_cv_amt;			}
	public int    getSd_fs_amt			()		{   return sd_fs_amt;			}
	public int    getSd_fv_amt			()		{   return sd_fv_amt;			}
	public int    getDc_cs_amt			()		{   return dc_cs_amt;			}
	public int    getDc_cv_amt			()		{   return dc_cv_amt;			}
	public int    getDc_fs_amt			()		{   return dc_fs_amt;			}
	public int    getDc_fv_amt			()		{   return dc_fv_amt;			}
	public String getPurc_gu			()		{	return purc_gu;				}	
	public String getCar_ext			()		{	return car_ext;				}	
	public String getBae4				()		{	return bae4;				}	
	public String getGi_st				()		{	return gi_st;				}	
	public String getAdd_opt			()     	{   return add_opt;				}
	public String getOpt_code			()    	{   return opt_code;			}
	public String getCar_seq			()     	{   return car_seq;				}
	public String getReg_est_dt			()		{	return reg_est_dt;			}
	public int	  getSun_per			()		{   return sun_per;				}
	public String getExtra_set			()		{	return extra_set;			}
	public String getRemark				()		{	return remark;				}  
	public String getS_dc1_re			()		{   return s_dc1_re;			}
	public String getS_dc1_yn			()		{   return s_dc1_yn;			}
	public int	  getS_dc1_amt			()		{   return s_dc1_amt;			}
	public String getS_dc2_re			()		{   return s_dc2_re;			}
	public String getS_dc2_yn			()		{   return s_dc2_yn;			}
	public int	  getS_dc2_amt			()		{   return s_dc2_amt;			}
	public String getS_dc3_re			()		{   return s_dc3_re;			}
	public String getS_dc3_yn			()		{   return s_dc3_yn;			}
	public int	  getS_dc3_amt			()		{   return s_dc3_amt;			}
	public String getPay_st				()		{   return pay_st;				}
	public int	  getSpe_tax			()		{   return spe_tax;				}
	public int	  getEdu_tax			()		{   return edu_tax;				}
	public String getCar_origin			()		{   return car_origin;			}
	public String getCar_comp_nm		()		{	return car_comp_nm;			}	
	public String getCar_comp_cd		()		{	return car_comp_cd;			}	
	public String getCar_cd				()		{	return car_cd;				}	
	public String getDlv_dt				()     	{   return dlv_dt;				}
	public int    getSh_car_amt			()		{   return sh_car_amt;			}
	public String getSh_year			()		{   return sh_year;				}
	public String getSh_month			()		{   return sh_month;			}
	public String getSh_day				()		{   return sh_day;				}
	public String getSh_day_bas_dt		()		{   return sh_day_bas_dt;		}
	public int    getSh_amt				()		{   return sh_amt;				}
	public float  getSh_ja				()		{	return sh_ja;				}
	public int    getSh_km				()		{	return sh_km;				}
	public int    getSh_tot_km			()		{	return sh_tot_km;			}
	public String getSh_km_bas_dt		()		{	return sh_km_bas_dt;		}
	public String getLpg_kit			()		{	return lpg_kit;				}
	public String getRent_st			()		{	return rent_st;				}
	public String getChk_id				()		{	return chk_id;				}
	public String getChk_dt				()		{	return chk_dt;				}
	public String getCms_not_cau		()		{	return cms_not_cau;			}
	public int	  getAdd_opt_amt		()		{   return add_opt_amt;			}
	public String getS_dc1_re_etc		()		{   return s_dc1_re_etc;		}
	public String getS_dc2_re_etc		()		{   return s_dc2_re_etc;		}
	public String getS_dc3_re_etc		()		{   return s_dc3_re_etc;		}
	public float  getS_dc1_per			()		{	return s_dc1_per;			}
	public float  getS_dc2_per			()		{	return s_dc2_per;			}
	public float  getS_dc3_per			()		{	return s_dc3_per;			}
	public String getCar_amt_dt			()		{   return car_amt_dt;			}
	public String getSh_init_reg_dt		()		{	return sh_init_reg_dt;		}
	public String getBus_agnt_id		()		{	return bus_agnt_id;			}
	public float  getBus_agnt_per		()		{	return bus_agnt_per;		}
	public float  getBus_agnt_r_per		()		{	return bus_agnt_r_per;		}
	public int	  getExtra_amt			()		{   return extra_amt;			}
	public String getCls_n_mon			()		{   return cls_n_mon;			}
	public int	  getCls_n_amt			()		{   return cls_n_amt;			}
	public String getBc_est_id			()		{	return bc_est_id;			}
	public int    getBc_s_a				()		{   return bc_s_a;				}
	public String getBc_s_b				()		{   return bc_s_b;				}
	public int    getBc_s_c				()		{   return bc_s_c;				}
	public float  getBc_s_d				()		{   return bc_s_d;				}
	public float  getBc_s_e				()		{	return bc_s_e;				}
	public int    getBc_s_f				()		{	return bc_s_f;				}
	public int    getBc_s_g				()		{	return bc_s_g;				}
	public float  getBc_s_i				()		{   return bc_s_i;				}
	public float  getBc_s_i2			()		{   return bc_s_i2;				}
	public int    getBc_b_a				()		{	return bc_b_a;				}
	public int    getBc_b_b				()		{	return bc_b_b;				}
	public int    getBc_b_d				()		{	return bc_b_d;				}
	public float  getBc_b_e1			()		{	return bc_b_e1;				}
	public int    getBc_b_e2			()		{   return bc_b_e2;				}
	public int    getBc_b_k				()		{   return bc_b_k;				}
	public int    getBc_b_n				()		{   return bc_b_n;				}
	public int    getBc_b_c				()		{   return bc_b_c;				}
	public int    getBc_b_e				()		{   return bc_b_e;				}
	public int    getBc_b_g				()		{   return bc_b_g;				}
	public int    getBc_b_u				()		{   return bc_b_u;				}
	public int    getBc_b_ac			()		{   return bc_b_ac;				}
	public int    getAgree_dist			()		{   return agree_dist;			}
	public String getBc_b_g_cont		()		{   return bc_b_g_cont;			}
	public String getBc_b_u_cont		()		{   return bc_b_u_cont;			}
	public String getBc_b_ac_cont		()		{   return bc_b_ac_cont;		}
	public String getBc_etc				()		{   return bc_etc;				}
	public int    getOver_run_amt		()		{   return over_run_amt;		}
	public int    getOver_run_day		()		{   return over_run_day;		}
	public int    getOver_serv_amt		()		{   return over_serv_amt;		}
	public String getAgree_dist_yn		()		{   return agree_dist_yn;		}
	public int    getMin_agree_dist		()		{   return min_agree_dist;		}
	public int    getMax_agree_dist		()		{   return max_agree_dist;		}
	public String getCng_chk_id			()		{	return cng_chk_id;			}
	public String getCng_chk_dt			()		{	return cng_chk_dt;			}
	public String getCng_chk_st			()		{	return cng_chk_st;			}
	public String getReg_dt				()		{	return reg_dt;				}
	public String getIn_col				()		{	return in_col;				}
	public String getGarnish_col		()		{	return garnish_col;			}
	public String getHipass_yn			()		{	return hipass_yn;			}
	public String getBluelink_yn		()		{	return bluelink_yn;			}
	public String getCar_tax_dt			()		{	return car_tax_dt;			}
	public int    getImport_card_amt	()		{   return import_card_amt;		}
	public int    getImport_cash_back	()		{   return import_cash_back;	}
	public String getCon_day			()		{	return con_day;				}
	public String getCon_etc			()		{	return con_etc;				}
	public int    getImport_bank_amt	()		{   return import_bank_amt;		}
	public int    getBc_b_t				()		{   return bc_b_t;				}
	public int    getOver_bas_km		()		{   return over_bas_km;			}
	public int    getR_import_cash_back	()		{   return r_import_cash_back;	}
	public int    getR_import_bank_amt	()		{   return r_import_bank_amt;	}
	public String getTint_b_yn			()		{	return tint_b_yn;			}
	public String getTint_s_yn			()		{	return tint_s_yn;			}
	public String getTint_ps_yn			()		{	return tint_ps_yn;			}
	public String getTint_ps_nm			()		{	return tint_ps_nm;			}
	public int	  getTint_ps_amt		()		{	return tint_ps_amt;			}
	public String getTint_ps_st			()		{	return tint_ps_st;			}
	public String getTint_n_yn			()		{	return tint_n_yn;			}
	public String getTint_bn_yn			()		{	return tint_bn_yn;			}
	public String getTint_bn_nm			()		{	return tint_bn_nm;			}
	public String getTint_sn_yn			()		{	return tint_sn_yn;			}
	public String getNew_license_plate	()		{	return new_license_plate;	}
	public String getSecond_license_plate()		{	return second_license_plate;}
	public String getTint_cons_yn		()		{	return tint_cons_yn;		}
	public int	  getTint_cons_amt		()		{	return tint_cons_amt;		}
	public int    getCust_est_km		()		{   return cust_est_km;			}
	public int    getTint_s_per			()		{   return tint_s_per;			}
	public String getBus_yn				()		{	return bus_yn;				}
	public String getBus_cau			()		{	return bus_cau;				}
	public String getBus_cau_dt			()		{	return bus_cau_dt;			}
	public String getServ_b_yn			()		{	return serv_b_yn;			}
	public String getServ_sc_yn			()		{	return serv_sc_yn;			}
	public String getJg_opt_st			()		{	return jg_opt_st; 			}
	public String getJg_col_st			()		{	return jg_col_st; 			}		
	public String getCredit_sac_id		()		{	return credit_sac_id;		}
	public String getCredit_sac_dt		()		{	return credit_sac_dt;		}
	public String getDc_ra_st			()		{	return dc_ra_st;			}
	public String getDc_ra_sac_id		()		{	return dc_ra_sac_id;		}
	public String getDc_ra_etc			()		{	return dc_ra_etc;			}
	public int    getTax_dc_s_amt		()		{   return tax_dc_s_amt;		}
	public int    getTax_dc_v_amt	  	()		{   return tax_dc_v_amt;		}
	public int    getEcar_pur_sub_amt	()		{   return ecar_pur_sub_amt;	}
	public String getEcar_pur_sub_st 	()		{	return ecar_pur_sub_st;		}
	public String getConti_rat          ()      {   return conti_rat;           }   
	public int    getCommi_s_amt		()		{   return commi_s_amt;			}
	public int    getCommi_v_amt		()		{   return commi_v_amt;			}
	public int    getAccid_serv_amt		()		{   return accid_serv_amt;		}
	public int    getSh_est_amt			()		{   return sh_est_amt;			}
	public String getAccid_serv_cont 	()		{	return accid_serv_cont;		}
	public int    getDriver_add_amt		()		{   return driver_add_amt;		}
	public int    getDriver_add_v_amt	()		{   return driver_add_v_amt;	}		//2018.03.30 
	public String getJg_tuix_st			()		{	return jg_tuix_st;			}	
	public String getJg_tuix_opt_st		()		{	return jg_tuix_opt_st;		}	
	public String getEco_e_tag			()		{	return eco_e_tag;			}	
	public String getLkas_yn			()		{	return lkas_yn;				}	
	public String getLkas_yn_opt_st		()		{	return lkas_yn_opt_st;		}	
	public String getLdws_yn			()		{	return ldws_yn;				}	
	public String getLdws_yn_opt_st		()		{	return ldws_yn_opt_st;		}	
	public String getAeb_yn				()		{	return aeb_yn;				}	
	public String getAeb_yn_opt_st		()		{	return aeb_yn_opt_st;		}	
	public String getFcw_yn				()		{	return fcw_yn;				}	
	public String getFcw_yn_opt_st		()		{	return fcw_yn_opt_st;		}	
	public String getEv_yn				()		{	return ev_yn;				}	
	public String getTint_eb_yn			()		{	return tint_eb_yn;			}
	public int    getStorage_s_amt		()		{   return storage_s_amt;		}
	public int    getStorage_v_amt		()		{   return storage_v_amt;		}
	public String getReturn_select		()		{   return return_select;		}
	public String getVan_add_opt		()		{   return van_add_opt;			}
	public String getOthers_device		()		{	return others_device;		}
	public String getHook_yn			()		{	return hook_yn;				}	
	public String getHook_yn_opt_st		()		{	return hook_yn_opt_st;		}
	public String getBr_to_st			()		{	return br_to_st;			}	
	public String getBr_from_st			()		{	return br_from_st;			}	
	public String getBr_to				()		{	return br_to;				}	
	public String getBr_from			()		{	return br_from;				}
	public String getBc_dlv_yn			()		{	return bc_dlv_yn;			}
	public int    getRtn_run_amt		()		{   return rtn_run_amt;			}
	public String getRtn_run_amt_yn		()		{	return rtn_run_amt_yn;		}
	public String getTop_cng_yn			()		{	return top_cng_yn;			}
	
	
}