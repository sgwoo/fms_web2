/**
 * 견적변수관리-중고차잔가변수
 */
package acar.estimate_mng;

public class EstiJgVarBean {

	//Table : ESTI_JG_VAR
    private String sh_code; //
    private String seq; 	//
    private String com_nm; 	//
    private String cars; 	//
    private String new_yn; 	//
    private float  jg_1; 	//
    private String jg_2;	//
	private float  jg_3; 	//
	private float  jg_4; 	//
	private float  jg_5; 	//
	private float  jg_6; 	//
	private int    jg_7; 	//
 	private float  jg_8; 	//
	private float  jg_9; 	//
	private float  jg_10; 	//
    private float  jg_11; 	//
    private float  jg_12; 	//
    private String jg_13; 	//
    private String jg_a; 	//
    private String jg_b; 	//
    private int    jg_c; 	//
    private int    jg_d1; 	//
    private int    jg_d2; 	//
    private int    jg_d3; 	//
    private String jg_e; 	//
    private int    jg_e1; 	//
	private float  jg_f; 	//
	private float  jg_g; 	//
	private String jg_h; 	//
	private String jg_i; 	//
	private float  jg_j1; 	//
 	private float  jg_j2; 	//
	private float  jg_j3; 	//
    private String app_dt; 	//
    private String jg_k; 	//
	private float  jg_l; 	//
	private float  jg_st1; 	//
	private float  jg_st2; 	//
	private float  jg_st3; 	//
	private float  jg_st4; 	//
	private float  jg_st5; 	//
	private float  jg_st6; 	//
	private float  jg_st7; 	//
	private float  jg_st8; 	//
	private float  jg_st9; 	//
	private float  jg_st10; //
	private float  jg_e_d; 	//자체출고효율-대리점수수료율
	private float  jg_e_e; 	//자체출고효율-요율
	private int    jg_e_g; 	//자체출고효율-추가금액
    private String jg_q; 	//
    private String jg_r; 	//
    private String jg_s; 	//
    private String jg_t; 	//
	private float  jg_u;	//
	private float  jg_14;	//표준주행거리 초과1만km당 중고차가 조정율(낙찰가.재리스잔존가관련)
	private String reg_dt; 	//
	private float  jg_3_1; 	//
	private float  jg_st11; //
	private float  jg_st12; //
	private float  jg_st13; //
	private float  jg_st14; //
	private float  jg_5_1; 	//
	private String jg_v; 	//
	private float  jg_st15; //
	private String jg_w; 	//
	private float  jg_x; 	//
	private float  jg_y; 	//
	private float  jg_z; 	//자차보험승수
    private int    jg_d4; 	//
    private int    jg_d5; 	//
	private float  jg_g_1; 	//
	private float  jg_g_2; 	//
	private float  jg_g_3; 	//
	private float  jg_15;	//표준주행거리 초과1만km당 중고차가 조정율(약정운행거리관련)
	private float  jg_g_4; 	//
	private float  jg_g_5; 	//
	private float  jg_st16; //
	private String jg_opt_st; 	//색삭 및 사양 관련 잔가 조정 변수
	private String jg_opt_1;	//
	private float  jg_opt_2; 	//
	private float  jg_opt_3; 	//
	private float  jg_opt_4; 	//
	private float  jg_opt_5; 	//
	private float  jg_opt_6; 	//
	private float  jg_opt_7; 	//
	private String jg_opt_8;	//
	private float  jg_g_6; 		//일반식관리비 조정승수
	private float  jg_st17; //
	private float  jg_st18; //
	private String jg_opt_9;	//
	private float  jg_st19; //
	private String jg_g_7;	//친환경차 구분
	private String jg_g_8;	//정부보조금 지급여부
	private String jg_g_9;	//0개월잔가 적용방식 구분
	private float  jg_g_10; //0개월 기준잔가 조정율
	private float  jg_g_11; //일반승용LPG 현시점 차령60개월 이상일 경우 잔가 조정율
	private float  jg_g_12; //일반승용LPG 종료시점 차령60개월 이상일 경우 잔가 조정율
	private float  jg_g_13; //1000km당 중고차가 조정율 반영승수(약정운행거리 계약시)
    private int    jg_d6; 	//tuix탁송료
    private int    jg_d7; 	//tuix탁송료
    private int    jg_d8; 	//tuix탁송료
    private int    jg_d9; 	//tuix탁송료
    private int    jg_d10; 	//tuix탁송료
	private float  jg_g_14; //재리스 단기 마진율 조정치
    private int    jg_g_15; //전기차 정부보조금
    private String jg_g_16; //저공해스티커발급대상
    private int    jg_g_17; //승차정원
    //수출효과 관련 변수 추가 (20180528)
    private String jg_g_18; //수출효과 대상 차종구분
    private int    jg_g_19; //수출가능연도-신차등록연도 
    private int    jg_g_20; //수출효과 반감기간(년)X2
    private String jg_g_21; //수출불가 사양
    private int    jg_g_22; //신차수출가능견적 대여만료일
    private int    jg_g_23; //신차출고 납기일수+7일
    private int    jg_g_24; //신차수출효과 최대값
    private float  jg_g_25; //신차주행거리 상쇄효과 반영율
    private String jg_g_26; //수출가능한 신차등록년도 시작일
    private int    jg_g_27; //재리스 수출가능견적대여만료일(일수)
    private int    jg_g_28; //수출효과최대값(현시점)
    private int    jg_g_29; //수출효과최대값(재리스 종료시점)
    private float  jg_g_30; //재리스  주행거리 상쇄효과 반영율
    private float  jg_g_31; //수출불가사고금액 기준율
    private float  jg_g_32; //매입옵션있는 신차 연장견적시 수출효과적용율
    private float  jg_g_33; //매입옵션있는 재리스 연장견적시 수출효과적용율
	private float  jg_st20; //
	private float  jg_st21; //
	private int    jg_g_34; //신차 장기렌트 홈페이지 인기차종(국산/수입) 인기1
    private int    jg_g_35; //신차 리스 홈페이지 인기차종(국산/수입) 인기1
    private String jg_g_36; //단기대여구분(대차료 청구용)
    private int jg_g_38;
    private int jg_g_39;
    private int jg_g_40;
    private int jg_g_41;
    private int jg_g_42;
    private int jg_g_43;
    private int jg_g_44;
    private float jg_g_45;
    private float  jg_st22; //개별소비세 20200101
    private float  jg_st23; //기간별 특소세율 20200225
    private int jg_g_46;	// 전기차지자체보조금(기타지역 참고견적용) 20220110
    

	// CONSTRCTOR            
    public EstiJgVarBean() {  
    	this.sh_code	= "";  
    	this.seq		= "";  
		this.com_nm		= "";  
		this.cars		= "";  
		this.new_yn 	= "";  
		this.jg_1		= 0.0f;   
    	this.jg_2		= "";  
		this.jg_3		= 0.0f;   
		this.jg_4		= 0.0f;   
		this.jg_5		= 0.0f;   
		this.jg_6		= 0.0f;   
 		this.jg_7		= 0;   
		this.jg_8		= 0.0f;   
		this.jg_9		= 0.0f;   
		this.jg_10		= 0.0f;   
		this.jg_11		= 0.0f;   
		this.jg_12		= 0.0f;   
    	this.jg_13		= "";  
    	this.jg_a		= "";  
		this.jg_b		= "";  
		this.jg_c		= 0;   
		this.jg_d1		= 0;   
    	this.jg_d2		= 0;   
    	this.jg_d3		= 0;   
		this.jg_e		= "";  
    	this.jg_e1		= 0;   
		this.jg_f		= 0.0f;   
		this.jg_g		= 0.0f;   
		this.jg_h		= "";  
 		this.jg_i		= "";  
		this.jg_j1		= 0.0f;   
		this.jg_j2		= 0.0f;   
		this.jg_j3		= 0.0f;   
		this.app_dt		= "";  
 		this.jg_k		= "";  
		this.jg_l		= 0.0f;   
		this.jg_st1		= 0.0f;   
		this.jg_st2		= 0.0f;   
		this.jg_st3		= 0.0f;   
		this.jg_st4		= 0.0f;   
		this.jg_st5		= 0.0f;   
		this.jg_st6		= 0.0f;   
		this.jg_st7		= 0.0f;   
		this.jg_st8		= 0.0f;   
		this.jg_st9		= 0.0f;   
		this.jg_st10	= 0.0f;   
		this.jg_e_d		= 0.0f;   
		this.jg_e_e		= 0.0f;   
		this.jg_e_g		= 0;   
 		this.jg_q		= "";  
 		this.jg_r		= "";  
 		this.jg_s		= "";  
 		this.jg_t		= "";  
		this.jg_u		= 0.0f;   
		this.jg_14		= 0.0f;
		this.reg_dt		= "";  
		this.jg_3_1		= 0.0f;   
		this.jg_st11	= 0.0f;   
		this.jg_st12	= 0.0f;   
		this.jg_st13	= 0.0f;   
		this.jg_st14	= 0.0f;   
		this.jg_5_1		= 0.0f;
		this.jg_v		= "";  
		this.jg_st15	= 0.0f;
		this.jg_w		= "";  
		this.jg_x		= 0.0f;   
		this.jg_y		= 0.0f;   
		this.jg_z		= 0.0f;   
    	this.jg_d4		= 0;   
    	this.jg_d5		= 0;   
		this.jg_g_1		= 0.0f;   
		this.jg_g_2		= 0.0f;   
		this.jg_g_3		= 0.0f;   
		this.jg_g_4		= 0.0f;   
		this.jg_g_5		= 0.0f;   
		this.jg_15		= 0.0f;
		this.jg_st16	= 0.0f;
		this.jg_opt_st	= ""; 
		this.jg_opt_1	= ""; 
		this.jg_opt_2	= 0.0f; 
		this.jg_opt_3	= 0.0f; 
		this.jg_opt_4	= 0.0f; 
		this.jg_opt_5	= 0.0f; 
		this.jg_opt_6	= 0.0f; 
		this.jg_opt_7	= 0.0f; 
		this.jg_opt_8	= ""; 
		this.jg_g_6		= 0.0f;
		this.jg_st17	= 0.0f;
		this.jg_st18	= 0.0f;
		this.jg_opt_9	= ""; 
		this.jg_st19	= 0.0f;
		this.jg_g_7		= ""; 
		this.jg_g_8		= ""; 
		this.jg_g_9		= ""; 
		this.jg_g_10	= 0.0f;
		this.jg_g_11	= 0.0f;
		this.jg_g_12	= 0.0f;
		this.jg_g_13	= 0.0f;
		this.jg_d6		= 0;   
		this.jg_d7		= 0;   
		this.jg_d8		= 0;   
		this.jg_d9		= 0;   
		this.jg_d10		= 0;   
		this.jg_g_14	= 0.0f;
		this.jg_g_15	= 0;
		this.jg_g_16	= "";
		this.jg_g_17	= 0;
	    //수출효과 관련 변수 추가 (20180528)
		this.jg_g_18	= "";
		this.jg_g_19	= 0;
		this.jg_g_20	= 0;
		this.jg_g_21	= "";
		this.jg_g_22	= 0;
		this.jg_g_23	= 0;
		this.jg_g_24	= 0;
		this.jg_g_25	= 0.0f;
		this.jg_g_26	= "";
		this.jg_g_27	= 0;
		this.jg_g_28	= 0;
		this.jg_g_29	= 0;
		this.jg_g_30	= 0.0f;
		this.jg_g_31	= 0.0f;
		this.jg_g_32	= 0.0f;
		this.jg_g_33	= 0.0f;
		this.jg_st20	= 0.0f;   
		this.jg_st21	= 0.0f;
		this.jg_g_34	= 0;
		this.jg_g_35	= 0;
		this.jg_g_36	= "";
		this.jg_g_38	= 0;
		this.jg_g_39	= 0;
		this.jg_g_40	= 0;
		this.jg_g_41	= 0;
		this.jg_g_42	= 0;
		this.jg_g_43	= 0;
		this.jg_g_44	= 0;
		this.jg_g_45	= 0.0f;
		this.jg_st22	= 0.0f;
		this.jg_st23	= 0.0f;
		this.jg_g_46	= 0;
	}

	// get Method
    public void setSh_code		(String val){		if(val==null) val="";	this.sh_code	= val;		}
    public void setSeq			(String val){		if(val==null) val="";	this.seq		= val;		}
	public void setCom_nm		(String val){		if(val==null) val="";	this.com_nm		= val;		}		
	public void setCars			(String val){		if(val==null) val="";	this.cars		= val;		}
	public void setNew_yn		(String val){		if(val==null) val="";	this.new_yn		= val;		}
	public void setJg_1			(float  val){								this.jg_1		= val;		}
	public void setJg_2			(String val){		this.jg_2 = val == null ? "0" : val; 			}
	public void setJg_3			(float  val){								this.jg_3		= val;		}
	public void setJg_4			(float  val){								this.jg_4		= val;		}
	public void setJg_5			(float  val){								this.jg_5		= val;		}
	public void setJg_6			(float  val){								this.jg_6		= val;		}
	public void setJg_7			(int    val){								this.jg_7		= val;		}
	public void setJg_8			(float  val){								this.jg_8		= val;		}
	public void setJg_9			(float  val){								this.jg_9		= val;		}
	public void setJg_10		(float  val){								this.jg_10		= val;		}
	public void setJg_11		(float  val){								this.jg_11		= val;		}
	public void setJg_12		(float  val){								this.jg_12		= val;		}
    public void setJg_13		(String val){		if(val==null) val="";	this.jg_13		= val;		}
    public void setJg_a			(String val){		if(val==null) val="";	this.jg_a		= val;		}
	public void setJg_b			(String val){		if(val==null) val="0";	this.jg_b		= val;		}		
	public void setJg_c			(int    val){								this.jg_c		= val;		}
	public void setJg_d1		(int    val){								this.jg_d1		= val;		}
	public void setJg_d2		(int    val){								this.jg_d2		= val;		}
	public void setJg_d3		(int    val){								this.jg_d3		= val;		}
	public void setJg_e			(String val){		if(val==null) val="0";	this.jg_e		= val;		}
	public void setJg_e1		(int    val){								this.jg_e1		= val;		}
	public void setJg_f			(float  val){								this.jg_f		= val;		}
	public void setJg_g			(float  val){								this.jg_g		= val;		}
	public void setJg_h			(String val){		if(val==null) val="0";	this.jg_h		= val;		}
	public void setJg_i			(String val){		if(val==null) val="0";	this.jg_i		= val;		}
	public void setJg_j1		(float val){								this.jg_j1		= val;		}
	public void setJg_j2		(float val){								this.jg_j2		= val;		}
	public void setJg_j3		(float val){								this.jg_j3		= val;		}
	public void setApp_dt		(String val){		if(val==null) val="0";	this.app_dt		= val;		}
	public void setJg_k			(String val){		if(val==null) val="0";	this.jg_k		= val;		}
	public void setJg_l			(float  val){								this.jg_l		= val;		}
	public void setJg_st1		(float  val){								this.jg_st1		= val;		}
	public void setJg_st2		(float  val){								this.jg_st2		= val;		}
	public void setJg_st3		(float  val){								this.jg_st3		= val;		}
	public void setJg_st4		(float  val){								this.jg_st4		= val;		}
	public void setJg_st5		(float  val){								this.jg_st5		= val;		}
	public void setJg_st6		(float  val){								this.jg_st6		= val;		}
	public void setJg_st7		(float  val){								this.jg_st7		= val;		}
	public void setJg_st8		(float  val){								this.jg_st8		= val;		}
	public void setJg_st9		(float  val){								this.jg_st9		= val;		}
	public void setJg_st10		(float  val){								this.jg_st10	= val;		}
	public void setJg_e_d		(float  val){								this.jg_e_d		= val;		}
	public void setJg_e_e		(float  val){								this.jg_e_e		= val;		}
	public void setJg_e_g		(int    val){								this.jg_e_g		= val;		}
	public void setJg_q			(String val){		if(val==null) val="0";	this.jg_q		= val;		}
	public void setJg_r			(String val){		if(val==null) val="0";	this.jg_r		= val;		}
	public void setJg_s			(String val){		if(val==null) val="0";	this.jg_s		= val;		}
	public void setJg_t			(String val){		if(val==null) val="0";	this.jg_t		= val;		}
	public void setJg_u			(float  val){								this.jg_u		= val;		}
	public void setJg_14		(float  val){								this.jg_14		= val;		}
	public void setReg_dt		(String val){		if(val==null) val="0";	this.reg_dt		= val;		}
	public void setJg_3_1		(float  val){								this.jg_3_1		= val;		}
	public void setJg_st11		(float  val){								this.jg_st11	= val;		}
	public void setJg_st12		(float  val){								this.jg_st12	= val;		}
	public void setJg_st13		(float  val){								this.jg_st13	= val;		}
	public void setJg_st14		(float  val){								this.jg_st14	= val;		}
	public void setJg_5_1		(float  val){								this.jg_5_1		= val;		}
	public void setJg_v			(String val){		if(val==null) val="0";	this.jg_v		= val;		}
	public void setJg_st15		(float  val){								this.jg_st15	= val;		}
	public void setJg_w			(String val){		if(val==null) val="0";	this.jg_w		= val;		}
	public void setJg_x			(float  val){								this.jg_x		= val;		}
	public void setJg_y			(float  val){								this.jg_y		= val;		}
	public void setJg_z			(float  val){								this.jg_z		= val;		}
	public void setJg_d4		(int    val){								this.jg_d4		= val;		}
	public void setJg_d5		(int    val){								this.jg_d5		= val;		}
	public void setJg_g_1		(float  val){								this.jg_g_1		= val;		}
	public void setJg_g_2		(float  val){								this.jg_g_2		= val;		}
	public void setJg_g_3		(float  val){								this.jg_g_3		= val;		}
	public void setJg_g_4		(float  val){								this.jg_g_4		= val;		}
	public void setJg_g_5		(float  val){								this.jg_g_5		= val;		}
	public void setJg_15		(float  val){								this.jg_15		= val;		}
	public void setJg_st16		(float  val){								this.jg_st16	= val;		}
	public void setJg_opt_st	(String val){		if(val==null) val="0";	this.jg_opt_st	= val;		}
	public void setJg_opt_1		(String val){		if(val==null) val="0";	this.jg_opt_1	= val;		}
	public void setJg_opt_2		(float  val){								this.jg_opt_2	= val;		}
	public void setJg_opt_3		(float  val){								this.jg_opt_3	= val;		}
	public void setJg_opt_4		(float  val){								this.jg_opt_4	= val;		}
	public void setJg_opt_5		(float  val){								this.jg_opt_5	= val;		}
	public void setJg_opt_6		(float  val){								this.jg_opt_6	= val;		}
	public void setJg_opt_7		(float  val){								this.jg_opt_7	= val;		}
	public void setJg_opt_8		(String val){		if(val==null) val="0";	this.jg_opt_8	= val;		}
	public void setJg_g_6		(float  val){								this.jg_g_6		= val;		}
	public void setJg_st17		(float  val){								this.jg_st17	= val;		}
	public void setJg_st18		(float  val){								this.jg_st18	= val;		}
	public void setJg_opt_9		(String val){		if(val==null) val="0";	this.jg_opt_9	= val;		}
	public void setJg_st19		(float  val){								this.jg_st19	= val;		}
	public void setJg_g_7		(String val){		if(val==null) val="0";	this.jg_g_7		= val;		}
	public void setJg_g_8		(String val){		if(val==null) val="0";	this.jg_g_8		= val;		}
	public void setJg_g_9		(String val){		if(val==null) val="0";	this.jg_g_9		= val;		}
	public void setJg_g_10		(float  val){								this.jg_g_10	= val;		}
	public void setJg_g_11		(float  val){								this.jg_g_11	= val;		}
	public void setJg_g_12		(float  val){								this.jg_g_12	= val;		}
	public void setJg_g_13		(float  val){								this.jg_g_13	= val;		}
	public void setJg_d6		(int    val){								this.jg_d6		= val;		}
	public void setJg_d7		(int    val){								this.jg_d7		= val;		}
	public void setJg_d8		(int    val){								this.jg_d8		= val;		}
	public void setJg_d9		(int    val){								this.jg_d9		= val;		}
	public void setJg_d10		(int    val){								this.jg_d10		= val;		}
	public void setJg_g_14		(float  val){								this.jg_g_14	= val;		}
	public void setJg_g_15		(int    val){								this.jg_g_15	= val;		}
	public void setJg_g_16		(String val){		if(val==null) val="";	this.jg_g_16	= val;		}
	public void setJg_g_17		(int    val){								this.jg_g_17	= val;		}
	public void setJg_g_18		(String val){		if(val==null) val="";	this.jg_g_18	= val;		}
	public void setJg_g_19		(int    val){								this.jg_g_19	= val;		}
	public void setJg_g_20		(int    val){								this.jg_g_20	= val;		}
	public void setJg_g_21		(String val){		if(val==null) val="";	this.jg_g_21	= val;		}
	public void setJg_g_22		(int    val){								this.jg_g_22	= val;		}
	public void setJg_g_23		(int    val){								this.jg_g_23	= val;		}
	public void setJg_g_24		(int    val){								this.jg_g_24	= val;		}
	public void setJg_g_25		(float  val){								this.jg_g_25	= val;		}
	public void setJg_g_26		(String val){		if(val==null) val="";	this.jg_g_26	= val;		}
	public void setJg_g_27		(int    val){								this.jg_g_27	= val;		}
	public void setJg_g_28		(int    val){								this.jg_g_28	= val;		}
	public void setJg_g_29		(int    val){								this.jg_g_29	= val;		}
	public void setJg_g_30		(float  val){								this.jg_g_30	= val;		}
	public void setJg_g_31		(float  val){								this.jg_g_31	= val;		}
	public void setJg_g_32		(float  val){								this.jg_g_32	= val;		}
	public void setJg_g_33		(float  val){								this.jg_g_33	= val;		}
	public void setJg_st20		(float  val){								this.jg_st20	= val;		}
	public void setJg_st21		(float  val){								this.jg_st21	= val;		}
	public void setJg_g_34		(int    val){								this.jg_g_34	= val;		}
	public void setJg_g_35		(int    val){								this.jg_g_35	= val;		}
	public void setJg_g_36		(String val){		if(val==null) val="";	this.jg_g_36	= val;		}
	public void setJg_g_38		(int val){		this.jg_g_38	= val;		}
	public void setJg_g_39		(int val){		this.jg_g_39	= val;		}
	public void setJg_g_40		(int val){		this.jg_g_40	= val;		}
	public void setJg_g_41		(int val){		this.jg_g_41	= val;		}
	public void setJg_g_42		(int val){		this.jg_g_42	= val;		}
	public void setJg_g_43		(int val){		this.jg_g_43	= val;		}
	public void setJg_g_44		(int val){		this.jg_g_44	= val;		}
	public void setJg_g_45		(float  val){								this.jg_g_45	= val;		}
	public void setJg_st22		(float  val){								this.jg_st22	= val;		}
	public void setJg_st23		(float  val){								this.jg_st23	= val;		}
	public void setJg_g_46		(int val){		this.jg_g_46	= val;		}

	//Get Method
	public String getSh_code	()	{		return sh_code;		}
	public String getSeq		()	{		return seq;			}
	public String getCom_nm		()	{		return com_nm;		}
	public String getCars		()	{		return cars;		}
	public String getNew_yn		()	{		return new_yn;		}
	public float  getJg_1		()	{		return jg_1;		}
	public String getJg_2		()	{		return jg_2;		}
	public float  getJg_3		()	{		return jg_3;		}
	public float  getJg_4		()	{		return jg_4;		}
	public float  getJg_5		()	{		return jg_5;		}
	public float  getJg_6		()	{		return jg_6;		}
	public int    getJg_7		()	{		return jg_7;		}
	public float  getJg_8		()	{		return jg_8;		}
	public float  getJg_9		()	{		return jg_9;		}
	public float  getJg_10		()	{		return jg_10;		}
	public float  getJg_11		()	{		return jg_11;		}
	public float  getJg_12		()	{		return jg_12;		}
	public String getJg_13		()	{		return jg_13;		}
	public String getJg_a		()	{		return jg_a;		}
	public String getJg_b		()	{		return jg_b;		}
	public int    getJg_c		()	{		return jg_c;		}
	public int    getJg_d1		()	{		return jg_d1;		}
	public int    getJg_d2		()	{		return jg_d2;		}
	public int    getJg_d3		()	{		return jg_d3;		}
	public String getJg_e		()	{		return jg_e;		}
	public int    getJg_e1		()	{		return jg_e1;		}
	public float  getJg_f		()	{		return jg_f;		}
	public float  getJg_g		()	{		return jg_g;		}
	public String getJg_h		()	{		return jg_h;		}
	public String getJg_i		()	{		return jg_i;		}
	public float getJg_j1		()	{		return jg_j1;		}
	public float getJg_j2		()	{		return jg_j2;		}
	public float getJg_j3		()	{		return jg_j3;		}
	public String getApp_dt		()	{		return app_dt;		}
	public String getJg_k		()	{		return jg_k;		}
	public float  getJg_l		()	{		return jg_l;		}
	public float  getJg_st1		()	{		return jg_st1;		}
	public float  getJg_st2		()	{		return jg_st2;		}
	public float  getJg_st3		()	{		return jg_st3;		}
	public float  getJg_st4		()	{		return jg_st4;		}
	public float  getJg_st5		()	{		return jg_st5;		}
	public float  getJg_st6		()	{		return jg_st6;		}
	public float  getJg_st7		()	{		return jg_st7;		}
	public float  getJg_st8		()	{		return jg_st8;		}
	public float  getJg_st9		()	{		return jg_st9;		}
	public float  getJg_st10	()	{		return jg_st10;		}
	public float  getJg_e_d		()	{		return jg_e_d;		}
	public float  getJg_e_e		()	{		return jg_e_e;		}
	public int    getJg_e_g		()	{		return jg_e_g;		}
	public String getJg_q		()	{		return jg_q;		}
	public String getJg_r		()	{		return jg_r;		}
	public String getJg_s		()	{		return jg_s;		}
	public String getJg_t		()	{		return jg_t;		}
	public float  getJg_u		()	{		return jg_u;		}
	public float  getJg_14		()	{		return jg_14;		}
	public String getReg_dt		()	{		return reg_dt;		}
	public float  getJg_3_1		()	{		return jg_3_1;		}
	public float  getJg_st11	()	{		return jg_st11; 	}
	public float  getJg_st12	()	{		return jg_st12; 	}
	public float  getJg_st13	()	{		return jg_st13; 	}
	public float  getJg_st14	()	{		return jg_st14; 	}
	public float  getJg_5_1		()	{		return jg_5_1;		}
	public String getJg_v		()	{		return jg_v;		}
	public float  getJg_st15	()	{		return jg_st15; 	}
	public String getJg_w		()	{		return jg_w;		}
	public float  getJg_x		()	{		return jg_x;		}
	public float  getJg_y		()	{		return jg_y;		}
	public float  getJg_z		()	{		return jg_z;		}
	public int    getJg_d4		()	{		return jg_d4;		}
	public int    getJg_d5		()	{		return jg_d5;		}
	public float  getJg_g_1		()	{		return jg_g_1;		}
	public float  getJg_g_2		()	{		return jg_g_2;		}
	public float  getJg_g_3		()	{		return jg_g_3;		}
	public float  getJg_g_4		()	{		return jg_g_4;		}
	public float  getJg_g_5		()	{		return jg_g_5;		}
	public float  getJg_15		()	{		return jg_15;		}
	public float  getJg_st16	()	{		return jg_st16; 	}
	public String getJg_opt_st	()	{		return jg_opt_st; 	}
	public String getJg_opt_1	()	{		return jg_opt_1;	}
	public float  getJg_opt_2	()	{		return jg_opt_2; 	}
	public float  getJg_opt_3	()	{		return jg_opt_3; 	}
	public float  getJg_opt_4	()	{		return jg_opt_4; 	}
	public float  getJg_opt_5	()	{		return jg_opt_5; 	}
	public float  getJg_opt_6	()	{		return jg_opt_6; 	}
	public float  getJg_opt_7	()	{		return jg_opt_7; 	}
	public String getJg_opt_8	()	{		return jg_opt_8;	}
	public float  getJg_g_6		()	{		return jg_g_6;		}
	public float  getJg_st17	()	{		return jg_st17; 	}
	public float  getJg_st18	()	{		return jg_st18; 	}
	public String getJg_opt_9	()	{		return jg_opt_9;	}
	public float  getJg_st19	()	{		return jg_st19; 	}
	public String getJg_g_7		()	{		return jg_g_7;		}
	public String getJg_g_8		()	{		return jg_g_8;		}
	public String getJg_g_9		()	{		return jg_g_9;		}
	public float  getJg_g_10	()	{		return jg_g_10;		}
	public float  getJg_g_11	()	{		return jg_g_11;		}
	public float  getJg_g_12	()	{		return jg_g_12;		}
	public float  getJg_g_13	()	{		return jg_g_13;		}
	public int    getJg_d6		()	{		return jg_d6;		}
	public int    getJg_d7		()	{		return jg_d7;		}
	public int    getJg_d8		()	{		return jg_d8;		}
	public int    getJg_d9		()	{		return jg_d9;		}
	public int    getJg_d10		()	{		return jg_d10;		}
	public float  getJg_g_14	()	{		return jg_g_14;		}
	public int    getJg_g_15	()	{		return jg_g_15;		}
	public String getJg_g_16	()	{		return jg_g_16;		}
	public int    getJg_g_17	()	{		return jg_g_17;		}
	public String getJg_g_18	()	{		return jg_g_18;		}
	public int    getJg_g_19	()	{		return jg_g_19;		}
	public int    getJg_g_20	()	{		return jg_g_20;		}
	public String getJg_g_21	()	{		return jg_g_21;		}
	public int    getJg_g_22	()	{		return jg_g_22;		}
	public int    getJg_g_23	()	{		return jg_g_23;		}
	public int    getJg_g_24	()	{		return jg_g_24;		}
	public float  getJg_g_25	()	{		return jg_g_25;		}
	public String getJg_g_26	()	{		return jg_g_26;		}
	public int    getJg_g_27	()	{		return jg_g_27;		}
	public int    getJg_g_28	()	{		return jg_g_28;		}
	public int    getJg_g_29	()	{		return jg_g_29;		}
	public float  getJg_g_30	()	{		return jg_g_30;		}
	public float  getJg_g_31	()	{		return jg_g_31;		}
	public float  getJg_g_32	()	{		return jg_g_32;		}
	public float  getJg_g_33	()	{		return jg_g_33;		}
	public float  getJg_st20	()	{		return jg_st20;		}
	public float  getJg_st21	()	{		return jg_st21;		}
	public int    getJg_g_34	()	{		return jg_g_34;		}
	public int    getJg_g_35	()	{		return jg_g_35;		}
	public String getJg_g_36	()	{		return jg_g_36;		}
	public int getJg_g_38	()	{		return jg_g_38;		}
	public int getJg_g_39	()	{		return jg_g_39;		}
	public int getJg_g_40	()	{		return jg_g_40;		}
	public int getJg_g_41	()	{		return jg_g_41;		}
	public int getJg_g_42	()	{		return jg_g_42;		}
	public int getJg_g_43	()	{		return jg_g_43;		}
	public int getJg_g_44	()	{		return jg_g_44;		}
	public float  getJg_g_45	()	{		return jg_g_45;		}
	public float  getJg_st22	()	{		return jg_st22;		}
	public float  getJg_st23	()	{		return jg_st23;		}
	public int getJg_g_46	()	{		return jg_g_46;		}

}
