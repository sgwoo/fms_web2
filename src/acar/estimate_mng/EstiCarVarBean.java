/**
 * 견적변수관리-차종별
 */
package acar.estimate_mng;
import java.util.*;

public class EstiCarVarBean {

	//Table : ESTI_CAR_VAR
    private String a_e;				//소분류코드
    private String a_a;				//대여구분
    private String seq;				//일련번호
    private String a_c;				//대분류
    private String m_st;			//중분류
    private String s_sd;			//소분류기준
	private String cars;			//해당차종
	private String a_j;				//견적적용일
    private float  s_f;				//취득세율
    private float  o_2;				//특소세율
    private int    o_3;				//특소세전차량가
    private int    o_4;				//탁송료
	private float  o_5;				//등록세율
    private float  o_6;				//채권매입액-서울
    private float  o_7;				//채권매입액-경기
    private float  o_11;			//영업사원수당율
    private float  o_13_1;			//최대잔가율-12개월
    private float  o_13_2;			//최대잔가율-18개월
	private float  o_13_3;			//최대잔가율-24개월
	private float  o_13_4;			//최대잔가율-30개월
	private float  o_13_5;			//최대잔가율-36개월
	private float  o_13_6;			//최대잔가율-42개월
	private float  o_13_7;			//최대잔가율-48개월
	private int    o_14;			//cc당 자동차세
	private int    o_15;			//차종별자동차세
    private int    o_a;				//2004-7.9 cc당 자동차세
    private int    o_b;				//2004-7.9 차종별 자동차세
    private int    o_c;				//2007-7.9 cc당 자동차세
    private int    o_d;				//2007-7.9 차종별 자동차세
	private int    oa_d;			//만21세이상 운전보험 가입시 대여료 인상2(금액)
    private int    g_2;				//종합보험료
    private float  g_4;				//자차보험요율
    private int    g_6;				//기본식일반관리비
    private int    g_7;				//일반식추가관리비        
	private int    oa_e_1;			//LPG키트 장착료-48개월
	private int    oa_e_2;			//LPG키트 장착료-42개월
	private int    oa_e_3;			//LPG키트 장착료-36개월
	private int    oa_e_4;			//LPG키트 장착료-30개월
	private int    oa_e_5;			//LPG키트 장착료-24개월
	private int    oa_e_6;			//LPG키트 장착료-18개월
	private int    oa_e_7;			//LPG키트 장착료-12개월
    private float  o_6_1;			//채권매입액-서울 :20080104
    private float  o_6_2_1;			//채권매입액-경기1
    private float  o_6_2_2;			//채권매입액-경기2
    private float  o_6_3;			//채권매입액-부산
    private float  o_6_4;			//채권매입액-경남
    private float  o_6_5;			//채권매입액-대전
    private float  o_6_7;			//채권매입액-인천
	private float  o_6_8;			//채권매입액-제주
    private float  o_e;				//1년차7-10인승cc당
    private float  o_f;				//2년차7-10인승cc당
    private float  o_g;				//3년차7-10인승cc당
    private float  sh_o_6_1;		//채권매입액-서울 (재리스)
    private float  sh_o_6_2_1;		//채권매입액-경기1
    private float  sh_o_6_2_2;		//채권매입액-경기2
    private float  sh_o_6_3;		//채권매입액-부산
    private float  sh_o_6_4;		//채권매입액-경남
    private float  sh_o_6_5;		//채권매입액-대전
    private float  sh_o_6_7;		//채권매입액-인천
	private float  sh_o_6_8;		//채권매입액-제주
	//20120223 보험변수추가
	private int    g_2_c;			//비용비교 일반법인 업무용 종합보험(긴급출동포함)
	private float  g_3;				//종합보험적용율
	private float  g_3_c;			//비용비교 종합보험적용율
	private float  g_4_b;			//일반법인 업무용 자차보험요율(삼성화재기준)
	private float  g_5;				//자차보험적용율(아마존카)
	private float  g_5_b;			//비용비교 자차보험적용율
	private float  k_tu;			//만21세이상 운전보험 가입시 대여료인상1(차가대비)
	private float  k_tu_b;			//비용비교 만21세이상 운전보험 가입시 대여료인상1(차가대비)
	private int    k_pu;			//만21세이상 운전보험 가입시 대여료인상2(금액)
	private int    k_pu_b;			//비용비교 만21세이상 운전보험 가입시 대여료인상2(금액)
	private float  o_5_c;			//통합취득세율(리스-제주)
	private int    k_gin;			//긴급출동서비스
	private int    sh_g_2;			//재리스 종합보험료 20150429


	// CONSTRCTOR            
    public EstiCarVarBean() {  
    	this.a_e		= "";
    	this.a_a		= "";
    	this.seq		= "";
		this.a_c		= "";
    	this.m_st		= "";
    	this.s_sd		= "";
    	this.cars		= "";
    	this.a_j		= "";
    	this.s_f		= 0;
    	this.o_2		= 0;
    	this.o_3		= 0;
    	this.o_4		= 0;
    	this.o_5		= 0;
    	this.o_6		= 0;
    	this.o_7		= 0;
    	this.o_11		= 0;
    	this.o_13_1		= 0;
    	this.o_13_2		= 0;
    	this.o_13_3		= 0;
		this.o_13_4		= 0;
    	this.o_13_5		= 0;
    	this.o_13_6		= 0;
		this.o_13_7		= 0;
    	this.o_14		= 0;
    	this.o_15		= 0;
    	this.o_a		= 0;
    	this.o_b		= 0;
    	this.o_c		= 0;
    	this.o_d		= 0;
		this.oa_d		= 0;
    	this.g_2		= 0;
    	this.g_4		= 0;
    	this.g_6		= 0;
		this.g_7		= 0;
		this.oa_e_1		= 0;
		this.oa_e_2		= 0;
		this.oa_e_3		= 0;
		this.oa_e_4		= 0;
		this.oa_e_5		= 0;
		this.oa_e_6		= 0;
		this.oa_e_7		= 0;
    	this.o_6_1		= 0;
    	this.o_6_2_1	= 0;
    	this.o_6_2_2	= 0;
    	this.o_6_3		= 0;
    	this.o_6_4		= 0;
    	this.o_6_5		= 0;
    	this.o_6_7		= 0;
		this.o_6_8		= 0;
    	this.o_e		= 0;
    	this.o_f		= 0;
    	this.o_g		= 0;
    	this.sh_o_6_1	= 0;
    	this.sh_o_6_2_1	= 0;
    	this.sh_o_6_2_2	= 0;
    	this.sh_o_6_3	= 0;
    	this.sh_o_6_4	= 0;
    	this.sh_o_6_5	= 0;
    	this.sh_o_6_7	= 0;
		this.sh_o_6_8	= 0;
    	this.g_2_c		= 0;
    	this.g_3		= 0;
    	this.g_3_c		= 0;
    	this.g_4_b		= 0;
    	this.g_5		= 0;
    	this.g_5_b		= 0;
    	this.k_tu		= 0;
    	this.k_tu_b		= 0;
    	this.k_pu		= 0;
		this.k_pu_b		= 0;
		this.o_5_c		= 0;
    	this.k_gin		= 0;
		this.sh_g_2		= 0;

	}

	// get Method
    public void setA_e			(String val){		if(val==null) val="";	this.a_e		= val;	}
    public void setA_a			(String val){		if(val==null) val="";	this.a_a		= val;	}
    public void setSeq			(String val){		if(val==null) val="";	this.seq		= val;	}
    public void setA_c			(String val){		if(val==null) val="";	this.a_c		= val;	}
    public void setM_st			(String val){		if(val==null) val="";	this.m_st		= val;	}
    public void setS_sd			(String val){		if(val==null) val="";	this.s_sd		= val;	}
    public void setCars			(String val){		if(val==null) val="";	this.cars		= val;	}
    public void setA_j			(String val){		if(val==null) val="";	this.a_j		= val;	}
	public void setS_f			(float    i){								this.s_f		= i;	}
	public void setO_2			(float    i){								this.o_2		= i;	}
	public void setO_3			(int      i){								this.o_3		= i;	}
	public void setO_4			(int      i){								this.o_4		= i;	}
	public void setO_5			(float    i){								this.o_5		= i;	}
	public void setO_6			(float    i){								this.o_6		= i;	}
	public void setO_7			(float    i){								this.o_7		= i;	}
	public void setO_11			(float    i){								this.o_11		= i;	}
	public void setO_13_1		(float    i){								this.o_13_1		= i;	}
	public void setO_13_2		(float    i){								this.o_13_2		= i;	}
	public void setO_13_3		(float    i){								this.o_13_3		= i;	}
	public void setO_13_4		(float    i){								this.o_13_4		= i;	}
	public void setO_13_5		(float    i){								this.o_13_5		= i;	}
	public void setO_13_6		(float    i){								this.o_13_6		= i;	}
	public void setO_13_7		(float    i){								this.o_13_7		= i;	}
	public void setO_14			(int      i){								this.o_14		= i;	}
	public void setO_15			(int      i){								this.o_15		= i;	}
	public void setO_a			(int      i){								this.o_a		= i;	}
	public void setO_b			(int      i){								this.o_b		= i;	}
	public void setO_c			(int      i){								this.o_c		= i;	}
	public void setO_d			(int      i){								this.o_d		= i;	}
	public void setOa_d			(int      i){								this.oa_d		= i;	}
	public void setG_2			(int      i){								this.g_2		= i;	}
	public void setG_4			(float    i){								this.g_4		= i;	}
	public void setG_6			(int      i){								this.g_6		= i;	}
	public void setG_7			(int      i){								this.g_7		= i;	}
	public void setOa_e_1		(int      i){								this.oa_e_1		= i;	}
	public void setOa_e_2		(int      i){								this.oa_e_2		= i;	}
	public void setOa_e_3		(int      i){								this.oa_e_3		= i;	}
	public void setOa_e_4		(int      i){								this.oa_e_4		= i;	}
	public void setOa_e_5		(int      i){								this.oa_e_5		= i;	}
	public void setOa_e_6		(int      i){								this.oa_e_6		= i;	}
	public void setOa_e_7		(int      i){								this.oa_e_7		= i;	}
	public void setO_6_1		(float    i){								this.o_6_1		= i;	}
	public void setO_6_2_1		(float    i){								this.o_6_2_1	= i;	}
	public void setO_6_2_2		(float    i){								this.o_6_2_2	= i;	}
	public void setO_6_3		(float    i){								this.o_6_3		= i;	}
	public void setO_6_4		(float    i){								this.o_6_4		= i;	}
	public void setO_6_5		(float    i){								this.o_6_5		= i;	}
	public void setO_6_7		(float    i){								this.o_6_7		= i;	}
	public void setO_6_8		(float    i){								this.o_6_8		= i;	}
	public void setO_e			(float    i){								this.o_e		= i;	}
	public void setO_f			(float    i){								this.o_f		= i;	}
	public void setO_g			(float    i){								this.o_g		= i;	}
	public void setSh_o_6_1		(float    i){								this.sh_o_6_1	= i;	}
	public void setSh_o_6_2_1	(float    i){								this.sh_o_6_2_1	= i;	}
	public void setSh_o_6_2_2	(float    i){								this.sh_o_6_2_2	= i;	}
	public void setSh_o_6_3		(float    i){								this.sh_o_6_3	= i;	}
	public void setSh_o_6_4		(float    i){								this.sh_o_6_4	= i;	}
	public void setSh_o_6_5		(float    i){								this.sh_o_6_5	= i;	}
	public void setSh_o_6_7		(float    i){								this.sh_o_6_7	= i;	}
	public void setSh_o_6_8		(float    i){								this.sh_o_6_8	= i;	}
	public void setG_2_c		(int      i){								this.g_2_c		= i;	}
	public void setG_3			(float    i){								this.g_3		= i;	}
	public void setG_3_c		(float    i){								this.g_3_c		= i;	}
	public void setG_4_b		(float    i){								this.g_4_b		= i;	}
	public void setG_5			(float    i){								this.g_5		= i;	}
	public void setG_5_b		(float    i){								this.g_5_b		= i;	}
	public void setK_tu			(float    i){								this.k_tu		= i;	}
	public void setK_tu_b		(float    i){								this.k_tu_b		= i;	}
	public void setK_pu			(int      i){								this.k_pu		= i;	}
	public void setK_pu_b		(int      i){								this.k_pu_b		= i;	}
	public void setO_5_c		(float    i){								this.o_5_c		= i;	}
	public void setK_gin		(int      i){								this.k_gin		= i;	}
	public void setSh_g_2		(int      i){								this.sh_g_2		= i;	}

		
	//Get Method
	public String getA_e		(){			return a_e;			}
	public String getA_a		(){			return a_a;			}
	public String getSeq		(){			return seq;			}
	public String getA_c		(){			return a_c;			}
	public String getM_st		(){			return m_st;		}	
	public String getS_sd		(){			return s_sd;		}
	public String getCars		(){			return cars;		}
	public String getA_j		(){			return a_j;			}
	public float  getS_f		(){			return s_f;			}
	public float  getO_2		(){			return o_2;			}
	public int    getO_3		(){			return o_3;			}
	public int    getO_4		(){			return o_4;			}
	public float  getO_5		(){			return o_5;			}
	public float  getO_6		(){			return o_6;			}
	public float  getO_7		(){			return o_7;			}
	public float  getO_11		(){			return o_11;		}
	public float  getO_13_1		(){			return o_13_1;		}
	public float  getO_13_2		(){			return o_13_2;		}
	public float  getO_13_3		(){			return o_13_3;		}
	public float  getO_13_4		(){			return o_13_4;		}
	public float  getO_13_5		(){			return o_13_5;		}
	public float  getO_13_6		(){			return o_13_6;		}
	public float  getO_13_7		(){			return o_13_7;		}
	public int    getO_14		(){			return o_14;		}
	public int    getO_15		(){			return o_15;		}
	public int    getO_a		(){			return o_a;			}
	public int    getO_b		(){			return o_b;			}
	public int    getO_c		(){			return o_c;			}
	public int    getO_d		(){			return o_d;			}
	public int    getOa_d		(){			return oa_d;		}
	public int    getG_2		(){			return g_2;			}
	public float  getG_4		(){			return g_4;			}
	public int    getG_6		(){			return g_6;			}
	public int    getG_7		(){			return g_7;			}
	public int    getOa_e_1		(){			return oa_e_1;		}
	public int    getOa_e_2		(){			return oa_e_2;		}
	public int    getOa_e_3		(){			return oa_e_3;		}
	public int    getOa_e_4		(){			return oa_e_4;		}
	public int    getOa_e_5		(){			return oa_e_5;		}
	public int    getOa_e_6		(){			return oa_e_6;		}
	public int    getOa_e_7		(){			return oa_e_7;		}
	public float  getO_6_1		(){			return o_6_1;		}
	public float  getO_6_2_1	(){			return o_6_2_1;		}
	public float  getO_6_2_2	(){			return o_6_2_2;		}
	public float  getO_6_3		(){			return o_6_3;		}
	public float  getO_6_4		(){			return o_6_4;		}
	public float  getO_6_5		(){			return o_6_5;		}
	public float  getO_6_7		(){			return o_6_7;		}
	public float  getO_6_8		(){			return o_6_8;		}
	public float  getO_e		(){			return o_e;			}
	public float  getO_f		(){			return o_f;			}
	public float  getO_g		(){			return o_g;			}
	public float  getSh_o_6_1	(){			return sh_o_6_1;	}
	public float  getSh_o_6_2_1	(){			return sh_o_6_2_1;	}
	public float  getSh_o_6_2_2	(){			return sh_o_6_2_2;	}
	public float  getSh_o_6_3	(){			return sh_o_6_3;	}
	public float  getSh_o_6_4	(){			return sh_o_6_4;	}
	public float  getSh_o_6_5	(){			return sh_o_6_5;	}
	public float  getSh_o_6_7	(){			return sh_o_6_7;	}
	public float  getSh_o_6_8	(){			return sh_o_6_8;	}
	public int    getG_2_c		(){			return g_2_c;		}
	public float  getG_3		(){			return g_3;			}
	public float  getG_3_c		(){			return g_3_c;		}
	public float  getG_4_b		(){			return g_4_b;		}
	public float  getG_5		(){			return g_5;			}
	public float  getG_5_b		(){			return g_5_b;		}
	public float  getK_tu		(){			return k_tu;		}
	public float  getK_tu_b		(){			return k_tu_b;		}
	public int    getK_pu		(){			return k_pu;		}
	public int    getK_pu_b		(){			return k_pu_b;		}
	public float  getO_5_c		(){			return o_5_c;		}
	public int    getK_gin		(){			return k_gin;		}
	public int    getSh_g_2		(){			return sh_g_2;		}


}

