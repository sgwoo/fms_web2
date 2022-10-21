/**
 * 견적서관리
 */
package acar.estimate_mng;

import java.util.*;


public class EstimateBean {
    //Table : ESTIMATE
    private String est_id;			//견적번호(년도2자리+월2자리+구분(f=fms,w=web)1자리+일련번호4자리)
    private String est_nm;			//고객/상호명
    private String est_ssn;			//주민/사업자등록번호
    private String est_tel;			//연락처
    private String est_fax;			//팩스번호
    private String car_comp_id;		//자도차사번호
    private String car_cd;			//차종번호
    private String car_id;			//모델번호
    private String car_seq;			//모델관리번호
    private int    car_amt;			//차량기본가격
    private String opt;				//선택사항
    private String opt_seq;			//선택관리번호
    private int    opt_amt;			//선택가격
    private int    opt_amt_m;		//선택미반영가격
    private String col;				//색상
    private String col_seq;			//색상관리번호
    private int    col_amt;			//색상가격
    private String dc;				//할인내용
    private String dc_seq;			//할인관리번호
    private int    dc_amt;			//할인가격
    private int    o_1;				//총차량가격
    private String a_a;				//대여상품
    private String a_b;				//대여기간
    private String a_h;				//등록지역
    private String pp_st;			//초기납입금구분(1:기본-개시대여료, 2:옵션-선납금,보증금)
	private float  pp_per;			//적용선납율
	private int    pp_amt;			//적용선납금액
	private float  rg_8;			//적용보증금율
	private int    rg_8_amt;		//적용보증금액
    private String ins_age;			//운전자연령(1:26세, 2:21세)
    private String ins_dj;			//대물,자손가입금액(1:5천, 2:1억)
	private float  ro_13;			//적용잔가율
	private int    ro_13_amt;		//적용잔가금액
    private int    g_10;			//개시대여 적용 월수
    private int    gi_amt;			//보증보험가입금액
    private int    gi_fee;			//보증보험료
    private int    gtr_amt;			//보증금
    private int    pp_s_amt;		//선납금-공급가
    private int    pp_v_amt;		//선납금-부가세
    private int    ifee_s_amt;		//개시대여료-공급가
    private int    ifee_v_amt;		//개시대여료-부가세
    private int    fee_s_amt;		//대여료-공급가
    private int    fee_v_amt;		//대여료-부가세
    private String reg_id;			//등록자
    private String reg_dt;			//등록일자
    private String update_id;		//수정자	
    private String update_dt;		//수정일자
    private String reg_nm;			//등록자
	private String ins_good;		//보험명
	private int    car_ja;			//자차면책금
	private String lpg_yn;			//lpg장착여부
	private String gi_yn;			//보증보험가입여부
	private String car_nm;		
	private String car_name;	
	private String talk_tel;		//전화상담연락처
	private String talk_st;			//전화상담구분
	private float  fee_dc_per;		//대여료DC
	private String m_user_id;		//전화상담자
	private String m_reg_dt;		//전화상담일
	private String spr_yn;			//우량기업 여부 1:우량, 0:기본
	private String mgr_nm;			//법인-대표자성명
	private String mgr_ssn;			//법인-대표자주민번호
	private String job;				//개인-직업
	private String rent_dt;			//계약일자-장기계약계산기준일
	private String est_gubun;
	private float  o_11;			//적용영업수당율
	private String lpg_kit;			//lpg키트종류
	private String est_st;			//견적구분
	private String est_from;		//견적목적
	private int    today_dist;		//예상주행거리
	private float  o_13;			//최대잔가율
	private String udt_st;			//차량인수지점
	private int    agree_dist;		//LPG견적-약정운행거리
	private int    over_run_amt;	//LPG견적-초과운행부담금
	private String from_page;		//
	private float  cls_per;			//적용위약금율
	private String rent_mng_id;		
	private String rent_l_cd;		
	private String rent_st;			
	private String reg_code;			
	private String eh_code;			
	private String ins_per;			//피보험자구분 아마존카1, 고객2
	private int    over_serv_amt;	//정비비용상한금액
	private int    over_run_day;	//정비비용상한금액
	private float  cls_n_per;		//필요위약금율
	private String one_self;		//자체출고여부
	private String doc_type;		//필요서류표기
	private String dir_pur_commi_yn;		//특판출고
	private String vali_type;		//견적유효기간표기
	private String opt_chk;			//매입옵션여부
	private int    fee_opt_amt;		//매입옵션금액
	private float  gi_per;			//보증보험가입율
	private String set_code;			
	private int    seq;				//스페셜견적 차종 일련번호(최대3개)
	private String car_mng_id;		//스폐셜견적 재리스일때 자동차관리번호
    private String est_email;		//이메일
	private String est_type;
	private String caroff_emp_yn;	//영업사원용 여부
	private String months	;
	private String days		;
	private String tot_rm	;
	private String tot_rm1	;
	private String per		;
	private String navi_yn	;
	private String est_check;		//기존거래처여부등 체크
	private String print_type;		//출력구분
    private int    ctr_s_amt;		//조정대여료-공급가
    private int    ctr_v_amt;		//조정대여료-부가세
	private String use_yn	;		//사용여부
	private String compare_yn;		//비용비고보기여부
	private int    b_agree_dist;	//LPG견적-표준 약정운행거리
	private float  b_o_13;			//표준 최대잔가율
	private String loc_st;			//차량인도지역
	private String tint_b_yn;		//용품 블랙박스
	private String tint_s_yn;		//용품 전면 썬팅(기본형)
	private String tint_sn_yn;		//용품 전면 썬팅 미시공 할인
	private String tint_ps_yn;		//용품 고급 썬팅
	private String tint_ps_nm;		//용품 고급 썬팅 내용
	private int tint_ps_amt;		//용품 고급 썬팅 추가금액(공급가)
	private String tint_ps_st;		//용품 고급 썬팅 선택값
	private String tint_n_yn;		//용품 내비게이션
	private String tint_bn_yn;		//용품 블랙박스 미제공 할인
	private String tint_cons_yn;	//추가탁송료 체크
	private int tint_cons_amt;		//추가탁송료(금액)
	private float  spe_dc_per;		//특별할인 대여료DC
	private String in_col;			//내부색상
	private String garnish_col;		//가니쉬색상
	private String bus_yn;			//계약여부
	private String bus_cau;			//미계약이유
    private int    accid_serv_amt1;	//사고수리비1
    private int    accid_serv_amt2;	//사고수리비2
	private String accid_serv_zero;	//무사고차견적
	private String insurant;		//보험계약자여부
	private String bus_cau_dt;		//미계약이유등록일시
	private String cha_st_dt;		//계기판교환 최종교환일
    private int    b_dist;			//계기판교환 전주행거리
	private String jg_opt_st;		//사양 잔가 조정 변수
	private String jg_col_st;		//색상 잔가 조정 변수
	private String max_use_mon;		//최대대여개월수
	private int    tax_dc_amt;		//개소세감면금액
	private String ecar_loc_st;		//전기차고객주소지
	private String eco_e_tag;		//맑은서울스티커 발급
	private int    ecar_pur_sub_amt;//친환경차구매보조금
	private String ecar_pur_sub_st; //친환경차구매보조금 수령방식
	private String conti_rat;		//연비 정보
	private int    driver_add_amt;	//운전자추가요금(공급가)
	private float  ctr_cls_per;     //적용위약율 수정전 금액
	private String pp_ment_yn;		//초기납입금안내문구
	private String tot_dt;			//주행거리확인일자
	private String jg_tuix_st;		//tuix/tuon 트림 여부
	private String jg_tuix_opt_st;	//tuix/tuon 옵션 여부
	private String lkas_yn;			//차선이탈 제어형 트림 여부
	private String lkas_yn_opt_st;	//차선이탈 제어형 옵션 여부
	private String ldws_yn;			//차선이탈 경고형 트림 여부
	private String ldws_yn_opt_st;	//차선이탈 경고형 옵션 여부
	private String aeb_yn;			//긴급제동 제어형 트림 여부
	private String aeb_yn_opt_st;	//긴급제동 제어형 옵션 여부
	private String fcw_yn;			//긴급제동 경고형 트림 여부
	private String fcw_yn_opt_st;	//긴급제동 경고형 옵션 여부
	private String garnish_yn;		//가니쉬
	private String garnish_yn_opt_st;	//가니쉬 옵션 여부
	private String hook_yn;			//견인고리
	private String hook_yn_opt_st;	//견인고리 옵션 여부
	private String ev_yn;			//전기차 여부
	private String damdang_nm;		//영업사원 직접입력한 이름
	private String damdang_m_tel;	//영업사원 직접입력한 휴대폰번호
	private String bus_st;			//영업구분, 계약-영업구분과 같음
	private String com_emp_yn;		//법인임직원한정운전특약 가입여부
	private String tint_eb_yn;		//용품 이동형충전기
	private String etc;				//기타(car_nm 테이블 etc2 컬럼)
	private String bigo;			//비고(code 테이블 bigo 컬럼)
	private String return_select;	//인수/반납 유형
	private String hcar_loc_st;		//수소차고객주소지
	private String ecar_pur_sub_yn; //친환경차구매보조금 재계산여부
	private String import_pur_st;	//수입차출고 타입
	private int car_b_p2;			//적용면세차자
	private int r_dc_amt;			//렌트 세금계산서D/C
	private int l_dc_amt;			//리스 세금계산서D/C
	private int r_card_amt;			//렌트 카드결제금액
	private int l_card_amt;			//리스 카드결제금액
	private int r_cash_back;		//렌트 Cash back
	private int l_cash_back;		//리스 Cash back
	private int r_bank_amt;			//렌트 탁송썬팅비용등
	private int l_bank_amt;			//리스 탁송썬팅비용등
	private String gi_grade;		//보증보험료산출 등급
	private String info_st;			//개소세환원안내문구
	private String br_to_st;		//고객주소지(차량인도지역) 초기입력값
	private String br_to;			//고객주소지(차량인도지역)
	private String br_from_st;		//차량현위치 선택값
	private String br_from;			//차량현위치
	private String legal_yn;		//법률비용지원급(고급형)
	private String esti_d_etc;		//견적서 제조사DC 추가문구
	private String new_license_plate;		//신차번호판 신청
	private int    rtn_run_amt;		//20220325 환급대여료
	private String rtn_run_amt_yn;	//20220412 환급대여료
	private String cng_dt;			//20220520 변경일자
	private String top_cng_yn;		//20220922 탑차(구조변경)
	
	

	// CONSTRCTOR            
    public EstimateBean() {  
		this.est_id				= "";
	    this.est_nm				= "";
	    this.est_ssn			= "";
	    this.est_tel			= "";
	    this.est_fax			= "";
	    this.car_comp_id		= "";
	    this.car_cd				= "";
	    this.car_id				= "";
	    this.car_seq			= "";
	    this.car_amt			= 0;
	    this.opt				= "";
	    this.opt_seq			= "";
	    this.opt_amt			= 0;
	    this.opt_amt_m			= 0;
	    this.col				= "";
	    this.col_seq			= "";
	    this.col_amt			= 0;
	    this.dc					= "";
	    this.dc_seq				= "";
	    this.dc_amt				= 0;
	    this.o_1				= 0;
	    this.a_a				= "";
	    this.a_b				= "";
	    this.a_h				= "";
	    this.pp_st				= "";
		this.pp_amt				= 0;
	    this.pp_per				= 0;
	    this.rg_8				= 0;
		this.ins_good			= "";
	    this.ins_age			= "";
	    this.ins_dj				= "";
	    this.ro_13				= 0;
	    this.g_10				= 0;
	    this.gi_amt				= 0;
	    this.gi_fee				= 0;
	    this.gtr_amt			= 0;	    
		this.pp_s_amt			= 0;
		this.pp_v_amt			= 0;
		this.ifee_s_amt			= 0;
		this.ifee_v_amt			= 0;
		this.fee_s_amt			= 0;
		this.fee_v_amt			= 0;
	    this.reg_id				= "";
		this.reg_dt				= "";
	    this.update_id			= "";
		this.update_dt			= "";
	    this.reg_nm				= "";
		this.car_ja				= 0;
		this.lpg_yn				= "";
		this.gi_yn				= "";
		this.car_nm				= "";
		this.car_name			= "";
		this.talk_tel			= "";
		this.talk_st			= "";
		this.ro_13_amt			= 0;
		this.rg_8_amt			= 0;
		this.fee_dc_per			= 0;
		this.m_user_id			= "";
		this.m_reg_dt			= "";
		this.spr_yn				= "";
		this.mgr_nm				= "";
		this.mgr_ssn			= "";
		this.job				= "";
		this.rent_dt			= "";
		this.est_gubun			= "";
	    this.o_11				= 0;
		this.lpg_kit			= "";
    	this.est_st				= "";
	    this.est_from			= "";
	    this.today_dist			= 0;
	    this.o_13				= 0;
	    this.udt_st				= "";
		this.agree_dist			= 0;
		this.over_run_amt		= 0;
    	this.from_page			= "";
		this.cls_per			= 0;
		this.rent_mng_id		= "";
		this.rent_l_cd			= "";
		this.rent_st			= "";
		this.reg_code			= "";
		this.eh_code			= "";
		this.ins_per			= "";
		this.over_serv_amt		= 0;
		this.over_run_day		= 0;
		this.cls_n_per			= 0;
		this.one_self			= "";
		this.doc_type			= "";
		this.dir_pur_commi_yn	= "";
		this.vali_type			= "";
		this.opt_chk			= "";
		this.fee_opt_amt		= 0;
		this.gi_per				= 0;
		this.set_code			= "";
	    this.seq				= 0;
	    this.car_mng_id			= "";
	    this.est_email			= "";
		this.est_type			= "";
		this.caroff_emp_yn		= "";
		this.months				= "";
	    this.days				= "";
	    this.tot_rm				= "";
		this.tot_rm1			= "";
		this.per				= "";
		this.navi_yn			= "";
		this.est_check			= "";
		this.print_type			= "";
		this.ctr_s_amt			= 0;
		this.ctr_v_amt			= 0;
		this.use_yn				= "";
		this.compare_yn			= "";
		this.b_agree_dist		= 0;
		this.b_o_13				= 0;
		this.loc_st				= "";
		this.tint_b_yn			= "";
		this.tint_s_yn			= "";
		this.tint_sn_yn			= "";
		this.tint_ps_yn			= "";
		this.tint_ps_nm			= "";
		this.tint_ps_amt		= 0;
		this.tint_ps_st			= "";
		this.tint_n_yn			= "";
		this.tint_bn_yn			= "";
		this.tint_cons_yn		= "";
		this.tint_cons_amt		= 0;
		this.spe_dc_per			= 0;
		this.in_col				= "";
		this.garnish_col		= "";
		this.bus_yn				= "";
		this.bus_cau			= "";
		this.accid_serv_amt1	= 0;
		this.accid_serv_amt2	= 0;
		this.accid_serv_zero	= "";
		this.insurant			= "";
		this.bus_cau_dt			= "";
		this.cha_st_dt			= "";
		this.b_dist				= 0;
		this.jg_opt_st			= ""; 
		this.jg_col_st			= ""; 
		this.max_use_mon		= "";
		this.tax_dc_amt			= 0;
		this.ecar_loc_st		= ""; 
		this.eco_e_tag			= "";
		this.ecar_pur_sub_amt	= 0;
		this.ecar_pur_sub_st    = "";
		this.conti_rat          = "";
		this.driver_add_amt		= 0;
		this.ctr_cls_per        = 0;
		this.pp_ment_yn			= "";
		this.tot_dt				= "";
		this.jg_tuix_st			= "";
		this.jg_tuix_opt_st		= "";
		this.lkas_yn			= "";
		this.lkas_yn_opt_st		= "";
		this.ldws_yn			= "";
		this.ldws_yn_opt_st		= "";
		this.aeb_yn				= "";
		this.aeb_yn_opt_st		= "";
		this.fcw_yn				= "";
		this.fcw_yn_opt_st		= "";
		this.garnish_yn			= "";
		this.garnish_yn_opt_st	= "";
		this.hook_yn			= "";
		this.hook_yn_opt_st		= "";
		this.ev_yn				= "";
		this.damdang_nm			= "";
		this.damdang_m_tel		= "";
		this.bus_st				= "";	
		this.com_emp_yn			= "";
		this.tint_eb_yn			= "";
		this.etc				= "";
		this.bigo				= "";
		this.return_select		= ""; 
		this.hcar_loc_st		= ""; 
		this.ecar_pur_sub_yn    = "";
		this.import_pur_st    	= "";
		this.car_b_p2    		= 0;
		this.r_dc_amt    		= 0;
		this.l_dc_amt    		= 0;
		this.r_card_amt   	 	= 0;
		this.l_card_amt    		= 0;
		this.r_cash_back    	= 0;
		this.l_cash_back    	= 0;
		this.r_bank_amt    		= 0;
		this.l_bank_amt    		= 0;
		this.gi_grade    		= "";
		this.info_st    		= "";
		this.br_to   	 		= "";
		this.br_to_st   		= "";
		this.br_from			= "";
		this.br_from_st			= "";
		this.legal_yn			= "";
		this.esti_d_etc			= "";
		this.new_license_plate	= "";
		this.rtn_run_amt		= 0;
		this.rtn_run_amt_yn		= "";
		this.cng_dt 			= "";
		this.top_cng_yn 		= "";
	}

	// set Method
	public void setEst_id			(String val){		if(val==null) val="";	this.est_id				= val;	}
    public void setEst_nm			(String val){		if(val==null) val="";	this.est_nm				= val;	}
    public void setEst_ssn			(String val){		if(val==null) val="";	this.est_ssn			= val;	}
    public void setEst_tel			(String val){		if(val==null) val="";	this.est_tel			= val;	}
    public void setEst_fax			(String val){		if(val==null) val="";	this.est_fax			= val;	}
    public void setCar_comp_id		(String val){		if(val==null) val="";	this.car_comp_id		= val;	}
	public void setCar_cd			(String val){		if(val==null) val="";	this.car_cd				= val;	}
	public void setCar_id			(String val){		if(val==null) val="";	this.car_id				= val;	}
	public void setCar_seq			(String val){		if(val==null) val="";	this.car_seq			= val;	}
    public void setCar_amt			(int    val){								this.car_amt			= val;	}
    public void setOpt				(String val){		if(val==null) val="";	this.opt				= val;	}
	public void setOpt_seq			(String val){		if(val==null) val="";	this.opt_seq			= val;	}
    public void setOpt_amt			(int    val){								this.opt_amt			= val;	}
    public void setOpt_amt_m		(int    val){								this.opt_amt_m		= val;	}
    public void setCol				(String val){		if(val==null) val="";	this.col				= val;	}
	public void setCol_seq			(String val){		if(val==null) val="";	this.col_seq			= val;	}
    public void setCol_amt			(int    val){								this.col_amt			= val;	}
    public void setDc				(String val){		if(val==null) val="";	this.dc					= val;	}
	public void setDc_seq			(String val){		if(val==null) val="";	this.dc_seq				= val;	}
    public void setDc_amt			(int    val){								this.dc_amt				= val;	}
    public void setO_1				(int    val){								this.o_1				= val;	}
    public void setA_a				(String val){		if(val==null) val="";	this.a_a				= val;	}
    public void setA_b				(String val){		if(val==null) val="";	this.a_b				= val;	}
    public void setA_h				(String val){		if(val==null) val="";	this.a_h				= val;	}
    public void setPp_st			(String val){		if(val==null) val="";	this.pp_st				= val;	}
    public void setPp_amt			(int    val){								this.pp_amt				= val;	}
	public void setPp_per			(float  val){								this.pp_per				= val;	}
	public void setRg_8				(float  val){								this.rg_8				= val;	}
    public void setIns_good			(String val){		if(val==null) val="";	this.ins_good			= val;	}	
	public void setIns_age			(String val){		if(val==null) val="";	this.ins_age			= val;	}	
    public void setIns_dj			(String val){		if(val==null) val="";	this.ins_dj				= val;	}
    public void setRo_13			(float val){								this.ro_13				= val;	}
    public void setG_10				(int    val){								this.g_10				= val;	}	
    public void setGi_amt			(int    val){								this.gi_amt				= val;	}
    public void setGi_fee			(int    val){								this.gi_fee				= val;	}
    public void setGtr_amt			(int    val){								this.gtr_amt			= val;	}
    public void setPp_s_amt			(int    val){								this.pp_s_amt			= val;	}
    public void setPp_v_amt			(int    val){								this.pp_v_amt			= val;	}
    public void setIfee_s_amt		(int    val){								this.ifee_s_amt			= val;	}
    public void setIfee_v_amt		(int    val){								this.ifee_v_amt			= val;	}
    public void setFee_s_amt		(int    val){								this.fee_s_amt			= val;	}
    public void setFee_v_amt		(int    val){								this.fee_v_amt			= val;	}
	public void setReg_id			(String val){		if(val==null) val="";	this.reg_id				= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";	this.reg_dt				= val;	}
	public void setUpdate_id		(String val){		if(val==null) val="";	this.update_id			= val;	}
	public void setUpdate_dt		(String val){		if(val==null) val="";	this.update_dt			= val;	}
	public void setReg_nm			(String val){		if(val==null) val="";	this.reg_nm				= val;	}
    public void setCar_ja			(int    val){								this.car_ja				= val;	}
	public void setLpg_yn			(String val){		if(val==null) val="0";	this.lpg_yn				= val;	}
	public void setGi_yn			(String val){		if(val==null) val="0";	this.gi_yn				= val;	}
	public void setCar_nm			(String val){		if(val==null) val="";	this.car_nm				= val;	}
	public void setCar_name			(String val){		if(val==null) val="";	this.car_name			= val;	}
	public void setTalk_tel			(String val){
		if(val==null) val="";	
		if(val.equals("")) talk_st = "메모";
		if(!val.equals("")) talk_st = "상담신청";
		this.talk_tel = val;	
	}
    public void setRo_13_amt		(int    val){								this.ro_13_amt			= val;	}	
    public void setRg_8_amt			(int    val){								this.rg_8_amt			= val;	}	
    public void setFee_dc_per		(float  val){								this.fee_dc_per			= val;	}	
	public void setM_user_id		(String val){		if(val==null) val="";	this.m_user_id			= val;	}
	public void setM_reg_dt			(String val){		if(val==null) val="";	this.m_reg_dt			= val;	}
	public void setSpr_yn			(String val){		if(val==null) val="";	this.spr_yn				= val;	}
	public void setMgr_nm			(String val){		if(val==null) val="";	this.mgr_nm				= val;	}
	public void setMgr_ssn			(String val){		if(val==null) val="";	this.mgr_ssn			= val;	}
	public void setJob				(String val){		if(val==null) val="";	this.job				= val;	}
	public void setRent_dt			(String val){		if(val==null) val="";	this.rent_dt			= val;	}
	public void setEst_gubun		(String val){		if(val==null) val="";	this.est_gubun			= val;	}
    public void setO_11				(float  val){								this.o_11				= val;	}
	public void setLpg_kit			(String val){		if(val==null) val="0";	this.lpg_kit			= val;	}
	public void setEst_st			(String val){		if(val==null) val="";	this.est_st				= val;	}
    public void setEst_from			(String val){		if(val==null) val="";	this.est_from			= val;	}
    public void setToday_dist		(int    val){								this.today_dist			= val;	}
    public void setO_13				(float  val){								this.o_13				= val;	}
	public void setUdt_st			(String val){		if(val==null) val="";	this.udt_st				= val;	}	
	public void setAgree_dist		(int	val){								this.agree_dist			= val;	}
	public void setOver_run_amt		(int	val){								this.over_run_amt		= val;	}
	public void setFrom_page		(String val){		if(val==null) val="";	this.from_page			= val;	}
    public void setCls_per			(float  val){								this.cls_per			= val;	}
	public void setRent_mng_id		(String val){		if(val==null) val="";	this.rent_mng_id		= val;	}
	public void setRent_l_cd		(String val){		if(val==null) val="";	this.rent_l_cd			= val;	}
    public void setRent_st			(String val){		if(val==null) val="";	this.rent_st			= val;	}
    public void setReg_code			(String val){		if(val==null) val="";	this.reg_code			= val;	}
    public void setEh_code			(String val){		if(val==null) val="";	this.eh_code			= val;	}
    public void setIns_per			(String val){		if(val==null) val="";	this.ins_per			= val;	}
	public void setOver_serv_amt	(int	val){								this.over_serv_amt		= val;	}
	public void setCls_n_per		(float  val){								this.cls_n_per			= val;	}
	public void setOver_run_day		(int	val){								this.over_run_day		= val;	}
    public void setOne_self			(String val){		if(val==null) val="";	this.one_self			= val;	}
	public void setDoc_type			(String val){		if(val==null) val="";	this.doc_type			= val;	}
	public void setDir_pur_commi_yn	(String val){		if(val==null) val="";	this.dir_pur_commi_yn	= val;	}
	public void setVali_type		(String val){		if(val==null) val="";	this.vali_type			= val;	}
    public void setOpt_chk			(String val){		if(val==null) val="";	this.opt_chk			= val;	}
	public void setFee_opt_amt		(int	val){								this.fee_opt_amt		= val;	}
	public void setGi_per			(float  val){								this.gi_per				= val;	}
	public void setSet_code			(String val){		if(val==null) val="";	this.set_code			= val;	}
    public void setSeq				(int    val){								this.seq				= val;	}
	public void setCar_mng_id		(String val){		if(val==null) val="";	this.car_mng_id			= val;	}
    public void setEst_email		(String val){		if(val==null) val="";	this.est_email			= val;	}
    public void setEst_type			(String val){		if(val==null) val="";	this.est_type			= val;	}
	public void setCaroff_emp_yn	(String val){		if(val==null) val="";	this.caroff_emp_yn		= val;	}
	public void setMonths			(String val){		if(val==null) val="";	this.months				= val;	}
	public void setDays				(String val){		if(val==null) val="";	this.days				= val;	}
	public void setTot_rm			(String val){		if(val==null) val="";	this.tot_rm				= val;	}
	public void setTot_rm1			(String val){		if(val==null) val="";	this.tot_rm1			= val;	}
	public void setPer				(String val){		if(val==null) val="";	this.per				= val;	}
	public void setNavi_yn			(String val){		if(val==null) val="";	this.navi_yn			= val;	}
	public void setEst_check		(String val){		if(val==null) val="";	this.est_check			= val;	}
	public void setPrint_type		(String val){		if(val==null) val="";	this.print_type			= val;	}
    public void setCtr_s_amt		(int    val){								this.ctr_s_amt			= val;	}
    public void setCtr_v_amt		(int    val){								this.ctr_v_amt			= val;	}
	public void setUse_yn			(String val){		if(val==null) val="";	this.use_yn				= val;	}
	public void setCompare_yn		(String val){		if(val==null) val="";	this.compare_yn			= val;	}
	public void setB_agree_dist		(int	val){								this.b_agree_dist		= val;	}
	public void setB_o_13			(float  val){								this.b_o_13				= val;	}
	public void setLoc_st			(String val){		if(val==null) val="";	this.loc_st				= val;	}	
	public void setTint_b_yn		(String val){		if(val==null) val="";	this.tint_b_yn			= val;	}	
	public void setTint_s_yn		(String val){		if(val==null) val="";	this.tint_s_yn			= val;	}		
	public void setTint_sn_yn		(String val){		if(val==null) val="";	this.tint_sn_yn			= val;	}		
	public void setTint_ps_yn		(String val){		if(val==null) val="";	this.tint_ps_yn			= val;	}
	public void setTint_ps_nm		(String val){		if(val==null) val="";	this.tint_ps_nm			= val;	}
	public void setTint_ps_amt		(int val)	{								this.tint_ps_amt		= val;	}
	public void setTint_ps_st		(String val){		if(val==null) val="";	this.tint_ps_st			= val;	}
	public void setTint_n_yn		(String val){		if(val==null) val="";	this.tint_n_yn			= val;	}	
	public void setTint_bn_yn		(String val){		if(val==null) val="";	this.tint_bn_yn			= val;	}	
	public void setTint_cons_yn		(String val){		if(val==null) val="";	this.tint_cons_yn		= val;	}	
	public void setTint_cons_amt	(int val)	{								this.tint_cons_amt		= val;	}
    public void setSpe_dc_per		(float  val){								this.spe_dc_per			= val;	}	
	public void setIn_col			(String val){		if(val==null) val="";	this.in_col				= val;	}
	public void setGarnish_col		(String val){		if(val==null) val="";	this.garnish_col		= val;	}
	public void setBus_yn			(String val){		if(val==null) val="";	this.bus_yn				= val;	}	
	public void setBus_cau			(String val){		if(val==null) val="";	this.bus_cau			= val;	}
	public void setAccid_serv_amt1	(int	val){								this.accid_serv_amt1	= val;	}	
	public void setAccid_serv_amt2	(int	val){								this.accid_serv_amt2	= val;	}
	public void setAccid_serv_zero	(String val){		if(val==null) val="";	this.accid_serv_zero	= val;	}	
	public void setInsurant			(String val){		if(val==null) val="";	this.insurant			= val;	}
	public void setBus_cau_dt		(String val){		if(val==null) val="";	this.bus_cau_dt			= val;	}
	public void setCha_st_dt		(String val){		if(val==null) val="";	this.cha_st_dt			= val;	}
	public void setB_dist			(int	val){								this.b_dist				= val;	}
	public void setJg_opt_st		(String val){		if(val==null) val="";	this.jg_opt_st			= val;	}
	public void setJg_col_st		(String val){		if(val==null) val="";	this.jg_col_st			= val;	}
	public void setMax_use_mon		(String val){		if(val==null) val="";	this.max_use_mon		= val;	}
	public void setTax_dc_amt		(int	val){								this.tax_dc_amt			= val;	}
	public void setEcar_loc_st		(String val){		if(val==null) val="";	this.ecar_loc_st		= val;	}
	public void setEco_e_tag		(String val){		if(val==null) val="";	this.eco_e_tag			= val;	}	
	public void setEcar_pur_sub_amt	(int	val){								this.ecar_pur_sub_amt	= val;	}
	public void setEcar_pur_sub_st	(String val){		if(val==null) val="";	this.ecar_pur_sub_st	= val;	}
	public void setConti_rat        (String val){       if(val==null) val="";   this.conti_rat          = val;  }
	public void setDriver_add_amt	(int	val){								this.driver_add_amt		= val;	}
	public void setCtr_cls_per      (float  val){                               this.ctr_cls_per        = val;  }
	public void setPp_ment_yn		(String val){		if(val==null) val="";	this.pp_ment_yn			= val;	}	
	public void setTot_dt			(String val){		if(val==null) val="";	this.tot_dt				= val;	}	
	public void setJg_tuix_st		(String val){		if(val==null) val="";	this.jg_tuix_st			= val;	}	
	public void setJg_tuix_opt_st	(String val){		if(val==null) val="";	this.jg_tuix_opt_st		= val;	}	
	public void setLkas_yn			(String val){		if(val==null) val="";	this.lkas_yn			= val;	}	
	public void setLkas_yn_opt_st	(String val){		if(val==null) val="";	this.lkas_yn_opt_st		= val;	}	
	public void setLdws_yn			(String val){		if(val==null) val="";	this.ldws_yn			= val;	}	
	public void setLdws_yn_opt_st	(String val){		if(val==null) val="";	this.ldws_yn_opt_st		= val;	}	
	public void setAeb_yn			(String val){		if(val==null) val="";	this.aeb_yn				= val;	}	
	public void setAeb_yn_opt_st	(String val){		if(val==null) val="";	this.aeb_yn_opt_st		= val;	}	
	public void setFcw_yn			(String val){		if(val==null) val="";	this.fcw_yn				= val;	}	
	public void setFcw_yn_opt_st	(String val){		if(val==null) val="";	this.fcw_yn_opt_st		= val;	}	
	public void setGarnish_yn		(String val){		if(val==null) val="";	this.garnish_yn			= val;	}	
	public void setGarnish_yn_opt_st(String val){		if(val==null) val="";	this.garnish_yn_opt_st	= val;	}	
	public void setHook_yn			(String val){		if(val==null) val="";	this.hook_yn			= val;	}	
	public void setHook_yn_opt_st	(String val){		if(val==null) val="";	this.hook_yn_opt_st		= val;	}
	public void setEv_yn			(String val){		if(val==null) val="";	this.ev_yn				= val;	}	
	public void setDamdang_nm		(String val){		if(val==null) val="";	this.damdang_nm			= val;	}	
	public void setDamdang_m_tel	(String val){		if(val==null) val="";	this.damdang_m_tel		= val;	}	
	public void setBus_st			(String val){		if(val==null) val="";	this.bus_st				= val;	}	
	public void setCom_emp_yn		(String val){		if(val==null) val="";	this.com_emp_yn			= val;	}
	public void setTint_eb_yn		(String val){		if(val==null) val="";	this.tint_eb_yn			= val;	}
	public void setEtc				(String val){		if(val==null) val="";	this.etc				= val;	}
	public void setBigo				(String val){		if(val==null) val="";	this.bigo				= val;	}
	public void setReturn_select	(String val){		if(val==null) val="";	this.return_select		= val;	}
	public void setHcar_loc_st		(String val){		if(val==null) val="";	this.hcar_loc_st		= val;	}
	public void setEcar_pur_sub_yn	(String val){		if(val==null) val="";	this.ecar_pur_sub_yn	= val;	}
	public void setImport_pur_st	(String val){		if(val==null) val="";	this.import_pur_st		= val;	}
    public void setCar_b_p2			(int    val){			this.car_b_p2			= val;	}
    public void setR_dc_amt			(int    val){			this.r_dc_amt			= val;	}
    public void setL_dc_amt			(int    val){			this.l_dc_amt			= val;	}    
    public void setR_card_amt		(int    val){			this.r_card_amt			= val;	}
    public void setL_card_amt		(int    val){			this.l_card_amt			= val;	}    
    public void setR_cash_back		(int    val){			this.r_cash_back			= val;	}
    public void setL_cash_back		(int    val){			this.l_cash_back			= val;	}    
    public void setR_bank_amt		(int    val){			this.r_bank_amt			= val;	}
    public void setL_bank_amt		(int    val){			this.l_bank_amt			= val;	}
    public void setGi_grade			(String val){		if(val==null) val="";	this.gi_grade			= val;	}
    public void setInfo_st			(String val){		if(val==null) val="";	this.info_st			= val;	}
    public void setBr_to			(String val){		if(val==null) val="";	this.br_to				= val;	}
    public void setBr_to_st			(String val){		if(val==null) val="";	this.br_to_st			= val;	}
    public void setBr_from			(String val){		if(val==null) val="";	this.br_from			= val;	}
	public void setBr_from_st		(String val){		if(val==null) val="";	this.br_from_st			= val;	}
    public void setLegal_yn			(String val){		if(val==null) val="";	this.legal_yn			= val;	}
    public void setEsti_d_etc		(String val){		if(val==null) val="";	this.esti_d_etc			= val;	}
    public void setNew_license_plate(String val){		if(val==null) val="";	this.new_license_plate	= val;	}
    public void setRtn_run_amt		(int	val){								this.rtn_run_amt		= val;	}
    public void setRtn_run_amt_yn	(String val){		if(val==null) val="";	this.rtn_run_amt_yn		= val;	}
    public void setCng_dt			(String val){		if(val==null) val="";	this.cng_dt				= val;	}
    public void setTop_cng_yn		(String val){		if(val==null) val="";	this.top_cng_yn			= val;	}

	//Get Method
	public String getEst_id				(){			return est_id;				}
	public String getEst_nm				(){			return est_nm;				}
    public String getEst_ssn			(){			return est_ssn;				}
    public String getEst_tel			(){			return est_tel;				}
    public String getEst_fax			(){			return est_fax;				}
    public String getCar_comp_id		(){			return car_comp_id;			}
    public String getCar_cd				(){			return car_cd;				}
    public String getCar_id				(){			return car_id;				}
    public String getCar_seq			(){			return car_seq;				}
    public int    getCar_amt			(){			return car_amt;				}
	public String getOpt				(){			return opt;					}
    public String getOpt_seq			(){			return opt_seq;				}
    public int    getOpt_amt			(){			return opt_amt;				}
    public int    getOpt_amt_m			(){			return opt_amt_m;			}
	public String getCol				(){			return col;					}
    public String getCol_seq			(){			return col_seq;				}
    public int    getCol_amt			(){			return col_amt;				}
	public String getDc					(){			return dc;					}
    public String getDc_seq				(){			return dc_seq;				}
    public int    getDc_amt				(){			return dc_amt;				}
    public int    getO_1				(){			return o_1;					}
	public String getA_a				(){			return a_a;					}
	public String getA_b				(){			return a_b;					}
	public String getA_h				(){			return a_h;					}
	public String getPp_st				(){			return pp_st;				}
    public int    getPp_amt				(){			return pp_amt;				}
    public float  getPp_per				(){			return pp_per;				}
    public float  getRg_8				(){			return rg_8;				}
	public String getIns_good			(){			return ins_good;			}
	public String getIns_age			(){			return ins_age;				}
	public String getIns_dj				(){			return ins_dj;				}
    public float  getRo_13				(){			return ro_13;				}
    public int    getG_10				(){			return g_10;				}
    public int    getGi_amt				(){			return gi_amt;				}
    public int    getGi_fee				(){			return gi_fee;				}
    public int    getGtr_amt			(){			return gtr_amt;				}
    public int    getPp_s_amt			(){			return pp_s_amt;			}
    public int    getPp_v_amt			(){			return pp_v_amt;			}
    public int    getIfee_s_amt			(){			return ifee_s_amt;			}
    public int    getIfee_v_amt			(){			return ifee_v_amt;			}
    public int    getFee_s_amt			(){			return fee_s_amt;			}
    public int    getFee_v_amt			(){			return fee_v_amt;			}
	public String getReg_id				(){			return reg_id;				}
    public String getReg_dt				(){			return reg_dt;				}
	public String getUpdate_id			(){			return update_id;			}
    public String getUpdate_dt			(){			return update_dt;			}
	public String getReg_nm				(){			return reg_nm;				}
    public int    getCar_ja				(){			return car_ja;				}
    public String getLpg_yn				(){			return lpg_yn;				}
    public String getGi_yn				(){			return gi_yn;				}
    public String getCar_nm				(){			return car_nm;				}
    public String getCar_name			(){			return car_name;			}
    public String getTalk_tel			(){			return talk_tel;			}
    public String getTalk_st			(){			return talk_st;				}
    public int    getRo_13_amt			(){			return ro_13_amt;			}
    public int    getRg_8_amt			(){			return rg_8_amt;			}
    public float  getFee_dc_per			(){			return fee_dc_per;			}
    public String getM_user_id			(){			return m_user_id;			}
    public String getM_reg_dt			(){			return m_reg_dt;			}
	public String getSpr_yn				(){			return spr_yn;				}
    public String getMgr_nm				(){			return mgr_nm;				}
    public String getMgr_ssn			(){			return mgr_ssn;				}
	public String getJob				(){			return job;					}
	public String getRent_dt			(){			return rent_dt;				}
	public String getEst_gubun			(){			return est_gubun;			}
    public float  getO_11				(){			return o_11;				}
    public String getLpg_kit			(){			return lpg_kit;				}
	public String getEst_st				(){			return est_st;				}
	public String getEst_from			(){			return est_from;			}
    public int    getToday_dist			(){			return today_dist;			}
    public float  getO_13				(){			return o_13;				}
	public String getUdt_st				(){			return udt_st;				}
	public int    getAgree_dist			(){			return agree_dist;			}
	public int    getOver_run_amt		(){			return over_run_amt;		}
	public int    getOver_run_day		(){			return over_run_day;		}
	public String getFrom_page			(){			return from_page;			}
    public float  getCls_per			(){			return cls_per;				}
    public String getRent_mng_id		(){			return rent_mng_id;			}
	public String getRent_l_cd			(){			return rent_l_cd;			}
	public String getRent_st			(){			return rent_st;				}
	public String getReg_code			(){			return reg_code;			}
	public String getEh_code			(){			return eh_code;				}
	public String getIns_per			(){			return ins_per;				}
	public int    getOver_serv_amt		(){			return over_serv_amt;		}
	public float  getCls_n_per			(){			return cls_n_per;			}
	public String getOne_self			(){			return one_self;			}
	public String getDoc_type			(){			return doc_type;			}
	public String getDir_pur_commi_yn	(){			return dir_pur_commi_yn;	}
	public String getVali_type			(){			return vali_type;			}
	public String getOpt_chk			(){			return opt_chk;				}
	public int    getFee_opt_amt		(){			return fee_opt_amt;			}
	public float  getGi_per				(){			return gi_per;				}
	public String getSet_code			(){			return set_code;			}
	public int    getSeq				(){			return seq;					}
	public String getCar_mng_id			(){			return car_mng_id;			}
	public String getEst_email			(){			return est_email;			}
	public String getEst_type			(){			return est_type;			}
	public String getCaroff_emp_yn		(){			return caroff_emp_yn;		}	
    public String getMonths				(){			return months	;			}
	public String getDays				(){			return days		;			}
    public String getTot_rm				(){			return tot_rm	;			}
	public String getTot_rm1			(){			return tot_rm1	;			}
    public String getPer				(){			return per		;			}
    public String getNavi_yn			(){			return navi_yn	;			}
	public String getEst_check			(){			return est_check;			}
	public String getPrint_type			(){			return print_type;			}
    public int    getCtr_s_amt			(){			return ctr_s_amt;			}
    public int    getCtr_v_amt			(){			return ctr_v_amt;			}
	public String getUse_yn				(){			return use_yn	;			}
	public String getCompare_yn			(){			return compare_yn;			}
	public int    getB_agree_dist		(){			return b_agree_dist;		}
	public float  getB_o_13				(){			return b_o_13;				}
	public String getLoc_st				(){			return loc_st;				}
	public String getTint_b_yn			(){			return tint_b_yn;			}
	public String getTint_s_yn			(){			return tint_s_yn;			}	
	public String getTint_sn_yn			(){			return tint_sn_yn;			}	
	public String getTint_ps_yn			(){			return tint_ps_yn;			}
	public String getTint_ps_nm			(){			return tint_ps_nm;			}
	public int	  getTint_ps_amt		(){			return tint_ps_amt;			}
	public String getTint_ps_st			(){			return tint_ps_st;			}
	public String getTint_n_yn			(){			return tint_n_yn;			}
	public String getTint_bn_yn			(){			return tint_bn_yn;			}
	public String getTint_cons_yn		(){			return tint_cons_yn;		}
	public int	  getTint_cons_amt		(){			return tint_cons_amt;		}
    public float  getSpe_dc_per			(){			return spe_dc_per;			}
	public String getIn_col				(){			return in_col;				}
	public String getGarnish_col		(){			return garnish_col;			}
	public String getBus_yn				(){			return bus_yn;				}
	public String getBus_cau			(){			return bus_cau;				}
    public int    getAccid_serv_amt1	(){			return accid_serv_amt1;		}
    public int    getAccid_serv_amt2	(){			return accid_serv_amt2;		}
	public String getAccid_serv_zero	(){			return accid_serv_zero;		}
	public String getInsurant			(){			return insurant;			}
	public String getBus_cau_dt			(){			return bus_cau_dt;			}
	public String getCha_st_dt			(){			return cha_st_dt;			}
	public int    getB_dist				(){			return b_dist;				}
	public String getJg_opt_st			(){			return jg_opt_st;			}
	public String getJg_col_st			(){			return jg_col_st;			}
	public String getMax_use_mon		(){			return max_use_mon;			}
	public int    getTax_dc_amt			(){			return tax_dc_amt;			}
	public String getEcar_loc_st		(){			return ecar_loc_st;			}
	public String getEco_e_tag			(){			return eco_e_tag;			}	
	public int    getEcar_pur_sub_amt	(){			return ecar_pur_sub_amt;	}
	public String getEcar_pur_sub_st	(){			return ecar_pur_sub_st;		}
	public String getConti_rat          (){         return conti_rat;           }
	public int    getDriver_add_amt		(){			return driver_add_amt;		}
	public float  getCtr_cls_per        (){         return ctr_cls_per;         }
	public String getPp_ment_yn			(){			return pp_ment_yn;			}
	public String getTot_dt				(){			return tot_dt;				}
	public String getJg_tuix_st			(){			return jg_tuix_st;			}	
	public String getJg_tuix_opt_st		(){			return jg_tuix_opt_st;		}
	public String getLkas_yn			(){			return lkas_yn;				}	
	public String getLkas_yn_opt_st		(){			return lkas_yn_opt_st;		}	
	public String getLdws_yn			(){			return ldws_yn;				}	
	public String getLdws_yn_opt_st		(){			return ldws_yn_opt_st;		}	
	public String getAeb_yn				(){			return aeb_yn;				}	
	public String getAeb_yn_opt_st		(){			return aeb_yn_opt_st;		}	
	public String getFcw_yn				(){			return fcw_yn;				}	
	public String getFcw_yn_opt_st		(){			return fcw_yn_opt_st;		}
	public String getGarnish_yn			(){			return garnish_yn;			}	
	public String getGarnish_yn_opt_st	(){			return garnish_yn_opt_st;	}
	public String getHook_yn			(){			return hook_yn;				}	
	public String getHook_yn_opt_st		(){			return hook_yn_opt_st;		}
	public String getEv_yn				(){			return ev_yn;				}
	public String getDamdang_nm			(){			return damdang_nm;			}
	public String getDamdang_m_tel		(){			return damdang_m_tel;		}	
	public String getBus_st				(){			return bus_st;				}	
	public String getCom_emp_yn			(){			return com_emp_yn;			}	
	public String getTint_eb_yn			(){			return tint_eb_yn;			}
	public String getEtc				(){			return etc;					}
	public String getBigo				(){			return bigo;				}
	public String getReturn_select		(){			return return_select;		}
	public String getHcar_loc_st		(){			return hcar_loc_st;			}
	public String getEcar_pur_sub_yn	(){			return ecar_pur_sub_yn;		}
	public String getImport_pur_st		(){			return import_pur_st;		}
	public int    getCar_b_p2			(){			return car_b_p2;			}
	public int    getR_dc_amt			(){			return r_dc_amt;			}
	public int    getL_dc_amt			(){			return l_dc_amt;			}
	public int    getR_card_amt			(){			return r_card_amt;			}
	public int    getL_card_amt			(){			return l_card_amt;			}
	public int    getR_cash_back		(){			return r_cash_back;			}
	public int    getL_cash_back		(){			return l_cash_back;			}
	public int    getR_bank_amt			(){			return r_bank_amt;			}
	public int    getL_bank_amt			(){			return l_bank_amt;			}
	public String getGi_grade			(){			return gi_grade;			}
	public String getInfo_st			(){			return info_st;				}
	public String getBr_to				(){			return br_to;				}
	public String getBr_to_st			(){			return br_to_st;			}
	public String getBr_from			(){			return br_from;				}
	public String getBr_from_st			(){			return br_from_st;			}
	public String getLegal_yn			(){			return legal_yn;			}
	public String getEsti_d_etc			(){			return esti_d_etc;			}
	public String getNew_license_plate	(){			return new_license_plate;	}
	public int    getRtn_run_amt		(){			return rtn_run_amt;			}
	public String getRtn_run_amt_yn		(){			return rtn_run_amt_yn;		}
	public String getCng_dt				(){			return cng_dt;				}
	public String getTop_cng_yn			(){			return top_cng_yn;			}

}	