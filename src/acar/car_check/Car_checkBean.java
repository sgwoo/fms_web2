
package acar.car_check;

import java.util.*;

public class Car_checkBean {
    //Table : Car_checkBean
    private String check_no;     //점검번호
    private String off_id;		//업체ID
    private String off_nm;		//업체명	 
	private String car_mng_id;		//차량관리번호
	private String rent_mng_id;		//계약번호
    private String rent_l_cd;		//장기계약번호
    private String rent_s_cd;		//단기계약번호
    private String driver_nm;		//점검자
    private String driver_tel;		//점검자 연락처
    private String reg_id;			//등록로그인 ID
    private String reg_dt;			//등록일자
    private String pay_dt;			//지급일자
	
    private String a1;		//본넷트 1:스크러치 2:찌그러짐 3:광택 4:종합 5:수선요청 6:적요 1~5 = Y, N 6=서술
    private String a2;	
    private String a3;         
    private String a4;
    private String a5;         
    private String a6;

    private String b1;		//범퍼 전       
    private String b2;
    private String b3;         
    private String b4;
    private String b5;         
    private String b6;

    private String c1;         //범퍼 후
    private String c2;
    private String c3;         
    private String c4;
    private String c5;         
    private String c6;

    private String d1;         //트렁크
    private String d2;
    private String d3;         
    private String d4;
    private String d5;         
    private String d6;

    private String e1;         //좌측 앞휀다
    private String e2;
    private String e3;         
    private String e4;
    private String e5;         
    private String e6;

    private String f1;         //좌측 전도어
    private String f2;
    private String f3;         
    private String f4;
    private String f5;         
    private String f6;

    private String g1;         //좌측 후도어
    private String g2;
    private String g3;         
    private String g4;
    private String g5;         
    private String g6;

    private String h1;         //좌측 후휀다
    private String h2;
    private String h3;         
    private String h4;
    private String h5;         
    private String h6;

    private String i1;         //좌측 스텝/필라/기타
    private String i2;
    private String i3;         
    private String i4;
    private String i5;         
    private String i6;

    private String j1;         //후측 앞휀다
    private String j2;
    private String j3;         
    private String j4;
    private String j5;         
    private String j6;

    private String k1;         //우측 전도어
    private String k2;
    private String k3;         
    private String k4;
    private String k5;         
    private String k6;

    private String l1;         //우측 후도어
    private String l2;
    private String l3;         
    private String l4;
    private String l5;         
    private String l6;

    private String m1;         //우측 후휀다
    private String m2;
    private String m3;         
    private String m4;
    private String m5;         
    private String m6;

    private String n1;         //우측 스텝/필라/기타
    private String n2;
    private String n3;         
    private String n4;
    private String n5;         
    private String n6;

    private String aa1;         //엔진룸 청결정도 1:정상 2:보충 3:정비 4:교환 5:종합 6:적요
    private String aa2;
    private String aa3;         
    private String aa4;
    private String aa5;         
    private String aa6;

    private String ab1;			//엔진오일         
    private String ab2;
    private String ab3;         
    private String ab4;
    private String ab5;         
    private String ab6;

    private String ac1;         //냉각수
    private String ac2;
    private String ac3;         
    private String ac4;
    private String ac5;         
    private String ac6;

    private String ad1;         //타르제거
    private String ad2;
    private String ad3;         
    private String ad4;
    private String ad5;         
    private String ad6;

    private String ae1;         //배터리 상태
    private String ae2;
    private String ae3;         
    private String ae4;
    private String ae5;         
    private String ae6;

    private String af1;         //브레이크액
    private String af2;
    private String af3;         
    private String af4;
    private String af5;         
    private String af6;

    private String ag1;         //와셔액
    private String ag2;
    private String ag3;         
    private String ag4;
    private String ag5;         
    private String ag6;

    private String ah1;         //파워스티어링 오일
    private String ah2;
    private String ah3;         
    private String ah4;
    private String ah5;         
    private String ah6;

    private String ai1;         //변속기어 오일
    private String ai2;
    private String ai3;         
    private String ai4;
    private String ai5;         
    private String ai6;

    private String aj1;         //누수
    private String aj2;
    private String aj3;         
    private String aj4;
    private String aj5;         
    private String aj6;

    private String ak1;         //외관 청결정도
    private String ak2;
    private String ak3;         
    private String ak4;
    private String ak5;         
    private String ak6;

    private String al1;         //쇽업 쇼바
    private String al2;
    private String al3;         
    private String al4;
    private String al5;         
    private String al6;

    private String am1;         //타이어 공기압
    private String am2;
    private String am3;         
    private String am4;
    private String am5;         
    private String am6;

    private String an1;         //타이어 마모상태
    private String an2;
    private String an3;         
    private String an4;
    private String an5;         
    private String an6;

    private String ao1;         //램프류
    private String ao2;
    private String ao3;         
    private String ao4;
    private String ao5;         
    private String ao6;

    private String ap1;         //배기가스의 색깔
    private String ap2;
    private String ap3;         
    private String ap4;
    private String ap5;         
    private String ap6;

    private String aq1;         //실내 청결정도
    private String aq2;
    private String aq3;         
    private String aq4;
    private String aq5;         
    private String aq6;

    private String ar1;         //핸들의 유격
    private String ar2;
    private String ar3;         
    private String ar4;
    private String ar5;         
    private String ar6;

	private String as1;         //페달의 유격
    private String as2;
    private String as3;         
    private String as4;
    private String as5;         
    private String as6;

    private String at1;         //브레이크의 작동상태
    private String at2;
    private String at3;         
    private String at4;
    private String at5;         
    private String at6;

    private String au1;         //변속레버의 조작성
    private String au2;
    private String au3;         
    private String au4;
    private String au5;         
    private String au6;

    private String av1;         //실내/외 백밀러
    private String av2;
    private String av3;         
    private String av4;
    private String av5;         
    private String av6;

    private String aw1;         //경적의 작동
    private String aw2;
    private String aw3;         
    private String aw4;
    private String aw5;         
    private String aw6;

    private String ax1;         //와이퍼 작동
    private String ax2;
    private String ax3;         
    private String ax4;
    private String ax5;         
    private String ax6;

    private String ay1;         //각종계기의 상태
    private String ay2;
    private String ay3;         
    private String ay4;
    private String ay5;         
    private String ay6;

	private String dist;		//주행거리 입력
	private String rm_st;		//최종의견-상태
	private String rm_cont;		//최종의견-내용

	private String firm_nm;
	private String mng_id;
	private String mng_id2;

	private String mng_check;
	private String mng_check_dt;

    // CONSTRCTOR            
    public Car_checkBean () {  
    	this.check_no		= "";
	    this.off_id			= "";
	    this.off_nm			= "";
		this.car_mng_id		= "";
		this.rent_mng_id	= "";
    	this.rent_l_cd		= "";
	   	this.rent_s_cd		= "";
    	this.driver_nm		= "";
	    this.driver_tel		= "";
		this.reg_id			= "";
		this.reg_dt			= "";
    	this.pay_dt			= "";

		this.a1		= "";
	    this.a2		= "";
		this.a3		= "";
	    this.a4		= "";
		this.a5		= "";
	    this.a6		= "";

		this.b1		= "";
	    this.b2		= "";
		this.b3		= "";
	    this.b4		= "";
		this.b5		= "";
	    this.b6		= "";

		this.c1		= "";
	    this.c2		= "";
		this.c3		= "";
	    this.c4		= "";
		this.c5		= "";
	    this.c6		= "";

		this.d1		= "";
	    this.d2		= "";
		this.d3		= "";
	    this.d4		= "";
		this.d5		= "";
	    this.d6		= "";

		this.e1		= "";
	    this.e2		= "";
		this.e3		= "";
	    this.e4		= "";
		this.e5		= "";
	    this.e6		= "";

		this.f1		= "";
	    this.f2		= "";
		this.f3		= "";
	    this.f4		= "";
		this.f5		= "";
	    this.f6		= "";

		this.g1		= "";
	    this.g2		= "";
		this.g3		= "";
	    this.g4		= "";
		this.g5		= "";
	    this.g6		= "";

		this.h1		= "";
	    this.h2		= "";
		this.h3		= "";
	    this.h4		= "";
		this.h5		= "";
	    this.h6		= "";

		this.i1		= "";
	    this.i2		= "";
		this.i3		= "";
	    this.i4		= "";
		this.i5		= "";
	    this.i6		= "";

		this.j1		= "";
	    this.j2		= "";
		this.j3		= "";
	    this.j4		= "";
		this.j5		= "";
	    this.j6		= "";

		this.k1		= "";
	    this.k2		= "";
		this.k3		= "";
	    this.k4		= "";
		this.k5		= "";
	    this.k6		= "";

		this.l1		= "";
	    this.l2		= "";
		this.l3		= "";
	    this.l4		= "";
		this.l5		= "";
	    this.l6		= "";

		this.m1		= "";
	    this.m2		= "";
		this.m3		= "";
	    this.m4		= "";
		this.m5		= "";
	    this.m6		= "";

		this.n1		= "";
	    this.n2		= "";
		this.n3		= "";
	    this.n4		= "";
		this.n5		= "";
	    this.n6		= "";

		this.aa1		= "";
	    this.aa2		= "";
		this.aa3		= "";
	    this.aa4		= "";
		this.aa5		= "";
	    this.aa6		= "";

		this.ab1		= "";
	    this.ab2		= "";
		this.ab3		= "";
	    this.ab4		= "";
		this.ab5		= "";
	    this.ab6		= "";

		this.ac1		= "";
	    this.ac2		= "";
		this.ac3		= "";
	    this.ac4		= "";
		this.ac5		= "";
	    this.ac6		= "";

		this.ad1		= "";
	    this.ad2		= "";
		this.ad3		= "";
	    this.ad4		= "";
		this.ad5		= "";
	    this.ad6		= "";

		this.ae1		= "";
	    this.ae2		= "";
		this.ae3		= "";
	    this.ae4		= "";
		this.ae5		= "";
	    this.ae6		= "";

		this.af1		= "";
	    this.af2		= "";
		this.af3		= "";
	    this.af4		= "";
		this.af5		= "";
	    this.af6		= "";

		this.ag1		= "";
	    this.ag2		= "";
		this.ag3		= "";
	    this.ag4		= "";
		this.ag5		= "";
	    this.ag6		= "";

		this.ah1		= "";
	    this.ah2		= "";
		this.ah3		= "";
	    this.ah4		= "";
		this.ah5		= "";
	    this.ah6		= "";

		this.ai1		= "";
	    this.ai2		= "";
		this.ai3		= "";
	    this.ai4		= "";
		this.ai5		= "";
	    this.ai6		= "";

		this.aj1		= "";
	    this.aj2		= "";
		this.aj3		= "";
	    this.aj4		= "";
		this.aj5		= "";
	    this.aj6		= "";

		this.ak1		= "";
	    this.ak2		= "";
		this.ak3		= "";
	    this.ak4		= "";
		this.ak5		= "";
	    this.ak6		= "";

		this.al1		= "";
	    this.al2		= "";
		this.al3		= "";
	    this.al4		= "";
		this.al5		= "";
	    this.al6		= "";

		this.am1		= "";
	    this.am2		= "";
		this.am3		= "";
	    this.am4		= "";
		this.am5		= "";
	    this.am6		= "";

		this.an1		= "";
	    this.an2		= "";
		this.an3		= "";
	    this.an4		= "";
		this.an5		= "";
	    this.an6		= "";

		this.ao1		= "";
	    this.ao2		= "";
		this.ao3		= "";
	    this.ao4		= "";
		this.ao5		= "";
	    this.ao6		= "";

		this.ap1		= "";
	    this.ap2		= "";
		this.ap3		= "";
	    this.ap4		= "";
		this.ap5		= "";
	    this.ap6		= "";

		this.aq1		= "";
	    this.aq2		= "";
		this.aq3		= "";
	    this.aq4		= "";
		this.aq5		= "";
	    this.aq6		= "";

		this.ar1		= "";
	    this.ar2		= "";
		this.ar3		= "";
	    this.ar4		= "";
		this.ar5		= "";
	    this.ar6		= "";

		this.as1		= "";
	    this.as2		= "";
		this.as3		= "";
	    this.as4		= "";
		this.as5		= "";
	    this.as6		= "";

		this.at1		= "";
	    this.at2		= "";
		this.at3		= "";
	    this.at4		= "";
		this.at5		= "";
	    this.at6		= "";

		this.au1		= "";
	    this.au2		= "";
		this.au3		= "";
	    this.au4		= "";
		this.au5		= "";
	    this.au6		= "";

		this.av1		= "";
	    this.av2		= "";
		this.av3		= "";
	    this.av4		= "";
		this.av5		= "";
	    this.av6		= "";

		this.aw1		= "";
	    this.aw2		= "";
		this.aw3		= "";
	    this.aw4		= "";
		this.aw5		= "";
	    this.aw6		= "";

		this.ax1		= "";
	    this.ax2		= "";
		this.ax3		= "";
	    this.ax4		= "";
		this.ax5		= "";
	    this.ax6		= "";

		this.ay1		= "";
	    this.ay2		= "";
		this.ay3		= "";
	    this.ay4		= "";
		this.ay5		= "";
	    this.ay6		= "";

		this.dist		= "";
		this.rm_st		= "";
		this.rm_cont	= "";	

		this.firm_nm	= "";
		this.mng_id		= "";
		this.mng_id2		= "";
	
		this.mng_check		= "";
		this.mng_check_dt	= "";
	}


	// get Method
	public void setCheck_no			(String val){		if(val==null) val="";		this.check_no		= val;	}
	public void setOff_id			(String val){		if(val==null) val="";		this.off_id			= val;	}
	public void setOff_nm			(String val){		if(val==null) val="";		this.off_nm			= val;	}
	public void setCar_mng_id		(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setRent_mng_id		(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setRent_l_cd		(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setRent_s_cd		(String val){		if(val==null) val="";		this.rent_s_cd		= val;	}
	public void setDriver_nm		(String val){		if(val==null) val="";		this.driver_nm		= val;	}
	public void setDriver_tel		(String val){		if(val==null) val="";		this.driver_tel	= val;		}
	public void setReg_id			(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setPay_dt			(String val){		if(val==null) val="";		this.pay_dt			= val;	}

	public void setA1	(String val){		if(val==null) val="";		this.a1		= val;	}
	public void setA2	(String val){		if(val==null) val="";		this.a2		= val;	}
	public void setA3	(String val){		if(val==null) val="";		this.a3		= val;	}
	public void setA4	(String val){		if(val==null) val="";		this.a4		= val;	}
	public void setA5	(String val){		if(val==null) val="";		this.a5		= val;	}
	public void setA6	(String val){		if(val==null) val="";		this.a6		= val;	}

	public void setB1	(String val){		if(val==null) val="";		this.b1		= val;	}
	public void setB2	(String val){		if(val==null) val="";		this.b2		= val;	}
	public void setB3	(String val){		if(val==null) val="";		this.b3		= val;	}
	public void setB4	(String val){		if(val==null) val="";		this.b4		= val;	}
	public void setB5	(String val){		if(val==null) val="";		this.b5		= val;	}
	public void setB6	(String val){		if(val==null) val="";		this.b6		= val;	}

	public void setC1	(String val){		if(val==null) val="";		this.c1		= val;	}
	public void setC2	(String val){		if(val==null) val="";		this.c2		= val;	}
	public void setC3	(String val){		if(val==null) val="";		this.c3		= val;	}
	public void setC4	(String val){		if(val==null) val="";		this.c4		= val;	}
	public void setC5	(String val){		if(val==null) val="";		this.c5		= val;	}
	public void setC6	(String val){		if(val==null) val="";		this.c6		= val;	}

	public void setD1	(String val){		if(val==null) val="";		this.d1		= val;	}
	public void setD2	(String val){		if(val==null) val="";		this.d2		= val;	}
	public void setD3	(String val){		if(val==null) val="";		this.d3		= val;	}
	public void setD4	(String val){		if(val==null) val="";		this.d4		= val;	}
	public void setD5	(String val){		if(val==null) val="";		this.d5		= val;	}
	public void setD6	(String val){		if(val==null) val="";		this.d6		= val;	}

	public void setE1	(String val){		if(val==null) val="";		this.e1		= val;	}
	public void setE2	(String val){		if(val==null) val="";		this.e2		= val;	}
	public void setE3	(String val){		if(val==null) val="";		this.e3		= val;	}
	public void setE4	(String val){		if(val==null) val="";		this.e4		= val;	}
	public void setE5	(String val){		if(val==null) val="";		this.e5		= val;	}
	public void setE6	(String val){		if(val==null) val="";		this.e6		= val;	}

	public void setF1	(String val){		if(val==null) val="";		this.f1		= val;	}
	public void setF2	(String val){		if(val==null) val="";		this.f2		= val;	}
	public void setF3	(String val){		if(val==null) val="";		this.f3		= val;	}
	public void setF4	(String val){		if(val==null) val="";		this.f4		= val;	}
	public void setF5	(String val){		if(val==null) val="";		this.f5		= val;	}
	public void setF6	(String val){		if(val==null) val="";		this.f6		= val;	}

	public void setG1	(String val){		if(val==null) val="";		this.g1		= val;	}
	public void setG2	(String val){		if(val==null) val="";		this.g2		= val;	}
	public void setG3	(String val){		if(val==null) val="";		this.g3		= val;	}
	public void setG4	(String val){		if(val==null) val="";		this.g4		= val;	}
	public void setG5	(String val){		if(val==null) val="";		this.g5		= val;	}
	public void setG6	(String val){		if(val==null) val="";		this.g6		= val;	}

	public void setH1	(String val){		if(val==null) val="";		this.h1		= val;	}
	public void setH2	(String val){		if(val==null) val="";		this.h2		= val;	}
	public void setH3	(String val){		if(val==null) val="";		this.h3		= val;	}
	public void setH4	(String val){		if(val==null) val="";		this.h4		= val;	}
	public void setH5	(String val){		if(val==null) val="";		this.h5		= val;	}
	public void setH6	(String val){		if(val==null) val="";		this.h6		= val;	}

	public void setI1	(String val){		if(val==null) val="";		this.i1		= val;	}
	public void setI2	(String val){		if(val==null) val="";		this.i2		= val;	}
	public void setI3	(String val){		if(val==null) val="";		this.i3		= val;	}
	public void setI4	(String val){		if(val==null) val="";		this.i4		= val;	}
	public void setI5	(String val){		if(val==null) val="";		this.i5		= val;	}
	public void setI6	(String val){		if(val==null) val="";		this.i6		= val;	}

	public void setJ1	(String val){		if(val==null) val="";		this.j1		= val;	}
	public void setJ2	(String val){		if(val==null) val="";		this.j2		= val;	}
	public void setJ3	(String val){		if(val==null) val="";		this.j3		= val;	}
	public void setJ4	(String val){		if(val==null) val="";		this.j4		= val;	}
	public void setJ5	(String val){		if(val==null) val="";		this.j5		= val;	}
	public void setJ6	(String val){		if(val==null) val="";		this.j6		= val;	}

	public void setK1	(String val){		if(val==null) val="";		this.k1		= val;	}
	public void setK2	(String val){		if(val==null) val="";		this.k2		= val;	}
	public void setK3	(String val){		if(val==null) val="";		this.k3		= val;	}
	public void setK4	(String val){		if(val==null) val="";		this.k4		= val;	}
	public void setK5	(String val){		if(val==null) val="";		this.k5		= val;	}
	public void setK6	(String val){		if(val==null) val="";		this.k6		= val;	}

	public void setL1	(String val){		if(val==null) val="";		this.l1		= val;	}
	public void setL2	(String val){		if(val==null) val="";		this.l2		= val;	}
	public void setL3	(String val){		if(val==null) val="";		this.l3		= val;	}
	public void setL4	(String val){		if(val==null) val="";		this.l4		= val;	}
	public void setL5	(String val){		if(val==null) val="";		this.l5		= val;	}
	public void setL6	(String val){		if(val==null) val="";		this.l6		= val;	}

	public void setM1	(String val){		if(val==null) val="";		this.m1		= val;	}
	public void setM2	(String val){		if(val==null) val="";		this.m2		= val;	}
	public void setM3	(String val){		if(val==null) val="";		this.m3		= val;	}
	public void setM4	(String val){		if(val==null) val="";		this.m4		= val;	}
	public void setM5	(String val){		if(val==null) val="";		this.m5		= val;	}
	public void setM6	(String val){		if(val==null) val="";		this.m6		= val;	}

	public void setN1	(String val){		if(val==null) val="";		this.n1		= val;	}
	public void setN2	(String val){		if(val==null) val="";		this.n2		= val;	}
	public void setN3	(String val){		if(val==null) val="";		this.n3		= val;	}
	public void setN4	(String val){		if(val==null) val="";		this.n4		= val;	}
	public void setN5	(String val){		if(val==null) val="";		this.n5		= val;	}
	public void setN6	(String val){		if(val==null) val="";		this.n6		= val;	}

	public void setAa1	(String val){		if(val==null) val="";		this.aa1		= val;	}
	public void setAa2	(String val){		if(val==null) val="";		this.aa2		= val;	}
	public void setAa3	(String val){		if(val==null) val="";		this.aa3		= val;	}
	public void setAa4	(String val){		if(val==null) val="";		this.aa4		= val;	}
	public void setAa5	(String val){		if(val==null) val="";		this.aa5		= val;	}
	public void setAa6	(String val){		if(val==null) val="";		this.aa6		= val;	}

	public void setAb1	(String val){		if(val==null) val="";		this.ab1		= val;	}
	public void setAb2	(String val){		if(val==null) val="";		this.ab2		= val;	}
	public void setAb3	(String val){		if(val==null) val="";		this.ab3		= val;	}
	public void setAb4	(String val){		if(val==null) val="";		this.ab4		= val;	}
	public void setAb5	(String val){		if(val==null) val="";		this.ab5		= val;	}
	public void setAb6	(String val){		if(val==null) val="";		this.ab6		= val;	}

	public void setAc1	(String val){		if(val==null) val="";		this.ac1		= val;	}
	public void setAc2	(String val){		if(val==null) val="";		this.ac2		= val;	}
	public void setAc3	(String val){		if(val==null) val="";		this.ac3		= val;	}
	public void setAc4	(String val){		if(val==null) val="";		this.ac4		= val;	}
	public void setAc5	(String val){		if(val==null) val="";		this.ac5		= val;	}
	public void setAc6	(String val){		if(val==null) val="";		this.ac6		= val;	}

	public void setAd1	(String val){		if(val==null) val="";		this.ad1		= val;	}
	public void setAd2	(String val){		if(val==null) val="";		this.ad2		= val;	}
	public void setAd3	(String val){		if(val==null) val="";		this.ad3		= val;	}
	public void setAd4	(String val){		if(val==null) val="";		this.ad4		= val;	}
	public void setAd5	(String val){		if(val==null) val="";		this.ad5		= val;	}
	public void setAd6	(String val){		if(val==null) val="";		this.ad6		= val;	}

	public void setAe1	(String val){		if(val==null) val="";		this.ae1		= val;	}
	public void setAe2	(String val){		if(val==null) val="";		this.ae2		= val;	}
	public void setAe3	(String val){		if(val==null) val="";		this.ae3		= val;	}
	public void setAe4	(String val){		if(val==null) val="";		this.ae4		= val;	}
	public void setAe5	(String val){		if(val==null) val="";		this.ae5		= val;	}
	public void setAe6	(String val){		if(val==null) val="";		this.ae6		= val;	}

	public void setAf1	(String val){		if(val==null) val="";		this.af1		= val;	}
	public void setAf2	(String val){		if(val==null) val="";		this.af2		= val;	}
	public void setAf3	(String val){		if(val==null) val="";		this.af3		= val;	}
	public void setAf4	(String val){		if(val==null) val="";		this.af4		= val;	}
	public void setAf5	(String val){		if(val==null) val="";		this.af5		= val;	}
	public void setAf6	(String val){		if(val==null) val="";		this.af6		= val;	}

	public void setAg1	(String val){		if(val==null) val="";		this.ag1		= val;	}
	public void setAg2	(String val){		if(val==null) val="";		this.ag2		= val;	}
	public void setAg3	(String val){		if(val==null) val="";		this.ag3		= val;	}
	public void setAg4	(String val){		if(val==null) val="";		this.ag4		= val;	}
	public void setAg5	(String val){		if(val==null) val="";		this.ag5		= val;	}
	public void setAg6	(String val){		if(val==null) val="";		this.ag6		= val;	}

	public void setAh1	(String val){		if(val==null) val="";		this.ah1		= val;	}
	public void setAh2	(String val){		if(val==null) val="";		this.ah2		= val;	}
	public void setAh3	(String val){		if(val==null) val="";		this.ah3		= val;	}
	public void setAh4	(String val){		if(val==null) val="";		this.ah4		= val;	}
	public void setAh5	(String val){		if(val==null) val="";		this.ah5		= val;	}
	public void setAh6	(String val){		if(val==null) val="";		this.ah6		= val;	}

	public void setAi1	(String val){		if(val==null) val="";		this.ai1		= val;	}
	public void setAi2	(String val){		if(val==null) val="";		this.ai2		= val;	}
	public void setAi3	(String val){		if(val==null) val="";		this.ai3		= val;	}
	public void setAi4	(String val){		if(val==null) val="";		this.ai4		= val;	}
	public void setAi5	(String val){		if(val==null) val="";		this.ai5		= val;	}
	public void setAi6	(String val){		if(val==null) val="";		this.ai6		= val;	}

	public void setAj1	(String val){		if(val==null) val="";		this.aj1		= val;	}
	public void setAj2	(String val){		if(val==null) val="";		this.aj2		= val;	}
	public void setAj3	(String val){		if(val==null) val="";		this.aj3		= val;	}
	public void setAj4	(String val){		if(val==null) val="";		this.aj4		= val;	}
	public void setAj5	(String val){		if(val==null) val="";		this.aj5		= val;	}
	public void setAj6	(String val){		if(val==null) val="";		this.aj6		= val;	}

	public void setAk1	(String val){		if(val==null) val="";		this.ak1		= val;	}
	public void setAk2	(String val){		if(val==null) val="";		this.ak2		= val;	}
	public void setAk3	(String val){		if(val==null) val="";		this.ak3		= val;	}
	public void setAk4	(String val){		if(val==null) val="";		this.ak4		= val;	}
	public void setAk5	(String val){		if(val==null) val="";		this.ak5		= val;	}
	public void setAk6	(String val){		if(val==null) val="";		this.ak6		= val;	}

	public void setAl1	(String val){		if(val==null) val="";		this.al1		= val;	}
	public void setAl2	(String val){		if(val==null) val="";		this.al2		= val;	}
	public void setAl3	(String val){		if(val==null) val="";		this.al3		= val;	}
	public void setAl4	(String val){		if(val==null) val="";		this.al4		= val;	}
	public void setAl5	(String val){		if(val==null) val="";		this.al5		= val;	}
	public void setAl6	(String val){		if(val==null) val="";		this.al6		= val;	}

	public void setAm1	(String val){		if(val==null) val="";		this.am1		= val;	}
	public void setAm2	(String val){		if(val==null) val="";		this.am2		= val;	}
	public void setAm3	(String val){		if(val==null) val="";		this.am3		= val;	}
	public void setAm4	(String val){		if(val==null) val="";		this.am4		= val;	}
	public void setAm5	(String val){		if(val==null) val="";		this.am5		= val;	}
	public void setAm6	(String val){		if(val==null) val="";		this.am6		= val;	}

	public void setAn1	(String val){		if(val==null) val="";		this.an1		= val;	}
	public void setAn2	(String val){		if(val==null) val="";		this.an2		= val;	}
	public void setAn3	(String val){		if(val==null) val="";		this.an3		= val;	}
	public void setAn4	(String val){		if(val==null) val="";		this.an4		= val;	}
	public void setAn5	(String val){		if(val==null) val="";		this.an5		= val;	}
	public void setAn6	(String val){		if(val==null) val="";		this.an6		= val;	}

	public void setAo1	(String val){		if(val==null) val="";		this.ao1		= val;	}
	public void setAo2	(String val){		if(val==null) val="";		this.ao2		= val;	}
	public void setAo3	(String val){		if(val==null) val="";		this.ao3		= val;	}
	public void setAo4	(String val){		if(val==null) val="";		this.ao4		= val;	}
	public void setAo5	(String val){		if(val==null) val="";		this.ao5		= val;	}
	public void setAo6	(String val){		if(val==null) val="";		this.ao6		= val;	}

	public void setAp1	(String val){		if(val==null) val="";		this.ap1		= val;	}
	public void setAp2	(String val){		if(val==null) val="";		this.ap2		= val;	}
	public void setAp3	(String val){		if(val==null) val="";		this.ap3		= val;	}
	public void setAp4	(String val){		if(val==null) val="";		this.ap4		= val;	}
	public void setAp5	(String val){		if(val==null) val="";		this.ap5		= val;	}
	public void setAp6	(String val){		if(val==null) val="";		this.ap6		= val;	}

	public void setAq1	(String val){		if(val==null) val="";		this.aq1		= val;	}
	public void setAq2	(String val){		if(val==null) val="";		this.aq2		= val;	}
	public void setAq3	(String val){		if(val==null) val="";		this.aq3		= val;	}
	public void setAq4	(String val){		if(val==null) val="";		this.aq4		= val;	}
	public void setAq5	(String val){		if(val==null) val="";		this.aq5		= val;	}
	public void setAq6	(String val){		if(val==null) val="";		this.aq6		= val;	}

	public void setAr1	(String val){		if(val==null) val="";		this.ar1		= val;	}
	public void setAr2	(String val){		if(val==null) val="";		this.ar2		= val;	}
	public void setAr3	(String val){		if(val==null) val="";		this.ar3		= val;	}
	public void setAr4	(String val){		if(val==null) val="";		this.ar4		= val;	}
	public void setAr5	(String val){		if(val==null) val="";		this.ar5		= val;	}
	public void setAr6	(String val){		if(val==null) val="";		this.ar6		= val;	}

	public void setAs1	(String val){		if(val==null) val="";		this.as1		= val;	}
	public void setAs2	(String val){		if(val==null) val="";		this.as2		= val;	}
	public void setAs3	(String val){		if(val==null) val="";		this.as3		= val;	}
	public void setAs4	(String val){		if(val==null) val="";		this.as4		= val;	}
	public void setAs5	(String val){		if(val==null) val="";		this.as5		= val;	}
	public void setAs6	(String val){		if(val==null) val="";		this.as6		= val;	}

	public void setAt1	(String val){		if(val==null) val="";		this.at1		= val;	}
	public void setAt2	(String val){		if(val==null) val="";		this.at2		= val;	}
	public void setAt3	(String val){		if(val==null) val="";		this.at3		= val;	}
	public void setAt4	(String val){		if(val==null) val="";		this.at4		= val;	}
	public void setAt5	(String val){		if(val==null) val="";		this.at5		= val;	}
	public void setAt6	(String val){		if(val==null) val="";		this.at6		= val;	}

	public void setAu1	(String val){		if(val==null) val="";		this.au1		= val;	}
	public void setAu2	(String val){		if(val==null) val="";		this.au2		= val;	}
	public void setAu3	(String val){		if(val==null) val="";		this.au3		= val;	}
	public void setAu4	(String val){		if(val==null) val="";		this.au4		= val;	}
	public void setAu5	(String val){		if(val==null) val="";		this.au5		= val;	}
	public void setAu6	(String val){		if(val==null) val="";		this.au6		= val;	}

	public void setAv1	(String val){		if(val==null) val="";		this.av1		= val;	}
	public void setAv2	(String val){		if(val==null) val="";		this.av2		= val;	}
	public void setAv3	(String val){		if(val==null) val="";		this.av3		= val;	}
	public void setAv4	(String val){		if(val==null) val="";		this.av4		= val;	}
	public void setAv5	(String val){		if(val==null) val="";		this.av5		= val;	}
	public void setAv6	(String val){		if(val==null) val="";		this.av6		= val;	}

	public void setAw1	(String val){		if(val==null) val="";		this.aw1		= val;	}
	public void setAw2	(String val){		if(val==null) val="";		this.aw2		= val;	}
	public void setAw3	(String val){		if(val==null) val="";		this.aw3		= val;	}
	public void setAw4	(String val){		if(val==null) val="";		this.aw4		= val;	}
	public void setAw5	(String val){		if(val==null) val="";		this.aw5		= val;	}
	public void setAw6	(String val){		if(val==null) val="";		this.aw6		= val;	}

	public void setAx1	(String val){		if(val==null) val="";		this.ax1		= val;	}
	public void setAx2	(String val){		if(val==null) val="";		this.ax2		= val;	}
	public void setAx3	(String val){		if(val==null) val="";		this.ax3		= val;	}
	public void setAx4	(String val){		if(val==null) val="";		this.ax4		= val;	}
	public void setAx5	(String val){		if(val==null) val="";		this.ax5		= val;	}
	public void setAx6	(String val){		if(val==null) val="";		this.ax6		= val;	}

	public void setAy1	(String val){		if(val==null) val="";		this.ay1		= val;	}
	public void setAy2	(String val){		if(val==null) val="";		this.ay2		= val;	}
	public void setAy3	(String val){		if(val==null) val="";		this.ay3		= val;	}
	public void setAy4	(String val){		if(val==null) val="";		this.ay4		= val;	}
	public void setAy5	(String val){		if(val==null) val="";		this.ay5		= val;	}
	public void setAy6	(String val){		if(val==null) val="";		this.ay6		= val;	}

	public void setDist	(String val){		if(val==null) val="";		this.dist		= val;	}
	public void setRm_st(String val){		if(val==null) val="";		this.rm_st		= val;	}
	public void setRm_cont	(String val){	if(val==null) val="";		this.rm_cont	= val;	}

	public void setFirm_nm	(String val){	if(val==null) val="";		this.firm_nm	= val;	}
	public void setMng_id	(String val){	if(val==null) val="";		this.mng_id		= val;	}
	public void setMng_id2	(String val){	if(val==null) val="";		this.mng_id2		= val;	}

	public void setMng_check (String val){	if(val==null) val="";		this.mng_check	= val;	}
	public void setMng_check_dt (String val){	if(val==null) val="";		this.mng_check_dt	= val;	}

	
	//Get Method
	public String getCheck_no		(){		return check_no;			}
	public String getOff_id			(){		return off_id;			}
	public String getOff_nm			(){		return off_nm;			}
	public String getCar_mng_id		(){		return car_mng_id;		}
	public String getRent_mng_id	(){		return rent_mng_id;		}
	public String getRent_l_cd		(){		return rent_l_cd;		}
	public String getRent_s_cd		(){		return rent_s_cd;		}
	public String getDriver_nm		(){		return driver_nm;		}
	public String getDriver_tel		(){		return driver_tel;	}
	public String getReg_id			(){		return reg_id;			}
	public String getReg_dt			(){		return reg_dt;			}
	public String getPay_dt			(){		return pay_dt;			}

	public String getA1		(){		return a1;		}
	public String getA2		(){		return a2;		}
	public String getA3		(){		return a3;		}
	public String getA4		(){		return a4;		}
	public String getA5		(){		return a5;		}
	public String getA6		(){		return a6;		}

	public String getB1		(){		return b1;		}
	public String getB2		(){		return b2;		}
	public String getB3		(){		return b3;		}
	public String getB4		(){		return b4;		}
	public String getB5		(){		return b5;		}
	public String getB6		(){		return b6;		}

	public String getC1		(){		return c1;		}
	public String getC2		(){		return c2;		}
	public String getC3		(){		return c3;		}
	public String getC4		(){		return c4;		}
	public String getC5		(){		return c5;		}
	public String getC6		(){		return c6;		}

	public String getD1		(){		return d1;		}
	public String getD2		(){		return d2;		}
	public String getD3		(){		return d3;		}
	public String getD4		(){		return d4;		}
	public String getD5		(){		return d5;		}
	public String getD6		(){		return d6;		}

	public String getE1		(){		return e1;		}
	public String getE2		(){		return e2;		}
	public String getE3		(){		return e3;		}
	public String getE4		(){		return e4;		}
	public String getE5		(){		return e5;		}
	public String getE6		(){		return e6;		}

	public String getF1		(){		return f1;		}
	public String getF2		(){		return f2;		}
	public String getF3		(){		return f3;		}
	public String getF4		(){		return f4;		}
	public String getF5		(){		return f5;		}
	public String getF6		(){		return f6;		}

	public String getG1		(){		return g1;		}
	public String getG2		(){		return g2;		}
	public String getG3		(){		return g3;		}
	public String getG4		(){		return g4;		}
	public String getG5		(){		return g5;		}
	public String getG6		(){		return g6;		}

	public String getH1		(){		return h1;		}
	public String getH2		(){		return h2;		}
	public String getH3		(){		return h3;		}
	public String getH4		(){		return h4;		}
	public String getH5		(){		return h5;		}
	public String getH6		(){		return h6;		}

	public String getI1		(){		return i1;		}
	public String getI2		(){		return i2;		}
	public String getI3		(){		return i3;		}
	public String getI4		(){		return i4;		}
	public String getI5		(){		return i5;		}
	public String getI6		(){		return i6;		}

	public String getJ1		(){		return j1;		}
	public String getJ2		(){		return j2;		}
	public String getJ3		(){		return j3;		}
	public String getJ4		(){		return j4;		}
	public String getJ5		(){		return j5;		}
	public String getJ6		(){		return j6;		}

	public String getK1		(){		return k1;		}
	public String getK2		(){		return k2;		}
	public String getK3		(){		return k3;		}
	public String getK4		(){		return k4;		}
	public String getK5		(){		return k5;		}
	public String getK6		(){		return k6;		}

	public String getL1		(){		return l1;		}
	public String getL2		(){		return l2;		}
	public String getL3		(){		return l3;		}
	public String getL4		(){		return l4;		}
	public String getL5		(){		return l5;		}
	public String getL6		(){		return l6;		}

	public String getM1		(){		return m1;		}
	public String getM2		(){		return m2;		}
	public String getM3		(){		return m3;		}
	public String getM4		(){		return m4;		}
	public String getM5		(){		return m5;		}
	public String getM6		(){		return m6;		}

	public String getN1		(){		return n1;		}
	public String getN2		(){		return n2;		}
	public String getN3		(){		return n3;		}
	public String getN4		(){		return n4;		}
	public String getN5		(){		return n5;		}
	public String getN6		(){		return n6;		}

	public String getAa1		(){		return aa1;		}
	public String getAa2		(){		return aa2;		}
	public String getAa3		(){		return aa3;		}
	public String getAa4		(){		return aa4;		}
	public String getAa5		(){		return aa5;		}
	public String getAa6		(){		return aa6;		}

	public String getAb1		(){		return ab1;		}
	public String getAb2		(){		return ab2;		}
	public String getAb3		(){		return ab3;		}
	public String getAb4		(){		return ab4;		}
	public String getAb5		(){		return ab5;		}
	public String getAb6		(){		return ab6;		}

	public String getAc1		(){		return ac1;		}
	public String getAc2		(){		return ac2;		}
	public String getAc3		(){		return ac3;		}
	public String getAc4		(){		return ac4;		}
	public String getAc5		(){		return ac5;		}
	public String getAc6		(){		return ac6;		}

	public String getAd1		(){		return ad1;		}
	public String getAd2		(){		return ad2;		}
	public String getAd3		(){		return ad3;		}
	public String getAd4		(){		return ad4;		}
	public String getAd5		(){		return ad5;		}
	public String getAd6		(){		return ad6;		}

	public String getAe1		(){		return ae1;		}
	public String getAe2		(){		return ae2;		}
	public String getAe3		(){		return ae3;		}
	public String getAe4		(){		return ae4;		}
	public String getAe5		(){		return ae5;		}
	public String getAe6		(){		return ae6;		}

	public String getAf1		(){		return af1;		}
	public String getAf2		(){		return af2;		}
	public String getAf3		(){		return af3;		}
	public String getAf4		(){		return af4;		}
	public String getAf5		(){		return af5;		}
	public String getAf6		(){		return af6;		}

	public String getAg1		(){		return ag1;		}
	public String getAg2		(){		return ag2;		}
	public String getAg3		(){		return ag3;		}
	public String getAg4		(){		return ag4;		}
	public String getAg5		(){		return ag5;		}
	public String getAg6		(){		return ag6;		}

	public String getAh1		(){		return ah1;		}
	public String getAh2		(){		return ah2;		}
	public String getAh3		(){		return ah3;		}
	public String getAh4		(){		return ah4;		}
	public String getAh5		(){		return ah5;		}
	public String getAh6		(){		return ah6;		}

	public String getAi1		(){		return ai1;		}
	public String getAi2		(){		return ai2;		}
	public String getAi3		(){		return ai3;		}
	public String getAi4		(){		return ai4;		}
	public String getAi5		(){		return ai5;		}
	public String getAi6		(){		return ai6;		}

	public String getAj1		(){		return aj1;		}
	public String getAj2		(){		return aj2;		}
	public String getAj3		(){		return aj3;		}
	public String getAj4		(){		return aj4;		}
	public String getAj5		(){		return aj5;		}
	public String getAj6		(){		return aj6;		}

	public String getAk1		(){		return ak1;		}
	public String getAk2		(){		return ak2;		}
	public String getAk3		(){		return ak3;		}
	public String getAk4		(){		return ak4;		}
	public String getAk5		(){		return ak5;		}
	public String getAk6		(){		return ak6;		}

	public String getAl1		(){		return al1;		}
	public String getAl2		(){		return al2;		}
	public String getAl3		(){		return al3;		}
	public String getAl4		(){		return al4;		}
	public String getAl5		(){		return al5;		}
	public String getAl6		(){		return al6;		}

	public String getAm1		(){		return am1;		}
	public String getAm2		(){		return am2;		}
	public String getAm3		(){		return am3;		}
	public String getAm4		(){		return am4;		}
	public String getAm5		(){		return am5;		}
	public String getAm6		(){		return am6;		}

	public String getAn1		(){		return an1;		}
	public String getAn2		(){		return an2;		}
	public String getAn3		(){		return an3;		}
	public String getAn4		(){		return an4;		}
	public String getAn5		(){		return an5;		}
	public String getAn6		(){		return an6;		}

	public String getAo1		(){		return ao1;		}
	public String getAo2		(){		return ao2;		}
	public String getAo3		(){		return ao3;		}
	public String getAo4		(){		return ao4;		}
	public String getAo5		(){		return ao5;		}
	public String getAo6		(){		return ao6;		}

	public String getAp1		(){		return ap1;		}
	public String getAp2		(){		return ap2;		}
	public String getAp3		(){		return ap3;		}
	public String getAp4		(){		return ap4;		}
	public String getAp5		(){		return ap5;		}
	public String getAp6		(){		return ap6;		}

	public String getAq1		(){		return aq1;		}
	public String getAq2		(){		return aq2;		}
	public String getAq3		(){		return aq3;		}
	public String getAq4		(){		return aq4;		}
	public String getAq5		(){		return aq5;		}
	public String getAq6		(){		return aq6;		}

	public String getAr1		(){		return ar1;		}
	public String getAr2		(){		return ar2;		}
	public String getAr3		(){		return ar3;		}
	public String getAr4		(){		return ar4;		}
	public String getAr5		(){		return ar5;		}
	public String getAr6		(){		return ar6;		}

	public String getAs1		(){		return as1;		}
	public String getAs2		(){		return as2;		}
	public String getAs3		(){		return as3;		}
	public String getAs4		(){		return as4;		}
	public String getAs5		(){		return as5;		}
	public String getAs6		(){		return as6;		}

	public String getAt1		(){		return at1;		}
	public String getAt2		(){		return at2;		}
	public String getAt3		(){		return at3;		}
	public String getAt4		(){		return at4;		}
	public String getAt5		(){		return at5;		}
	public String getAt6		(){		return at6;		}

	public String getAu1		(){		return au1;		}
	public String getAu2		(){		return au2;		}
	public String getAu3		(){		return au3;		}
	public String getAu4		(){		return au4;		}
	public String getAu5		(){		return au5;		}
	public String getAu6		(){		return au6;		}

	public String getAv1		(){		return av1;		}
	public String getAv2		(){		return av2;		}
	public String getAv3		(){		return av3;		}
	public String getAv4		(){		return av4;		}
	public String getAv5		(){		return av5;		}
	public String getAv6		(){		return av6;		}

	public String getAw1		(){		return aw1;		}
	public String getAw2		(){		return aw2;		}
	public String getAw3		(){		return aw3;		}
	public String getAw4		(){		return aw4;		}
	public String getAw5		(){		return aw5;		}
	public String getAw6		(){		return aw6;		}

	public String getAx1		(){		return ax1;		}
	public String getAx2		(){		return ax2;		}
	public String getAx3		(){		return ax3;		}
	public String getAx4		(){		return ax4;		}
	public String getAx5		(){		return ax5;		}
	public String getAx6		(){		return ax6;		}

	public String getAy1		(){		return ay1;		}
	public String getAy2		(){		return ay2;		}
	public String getAy3		(){		return ay3;		}
	public String getAy4		(){		return ay4;		}
	public String getAy5		(){		return ay5;		}
	public String getAy6		(){		return ay6;		}

	public String getDist		(){		return	dist;	}
	public String getRm_st		(){		return	rm_st;	}
	public String getRm_cont	(){		return	rm_cont;	}

	public String getFirm_nm	(){		return	firm_nm;	}
	public String getMng_id		(){		return	mng_id;		}
	public String getMng_id2	(){		return	mng_id2;	}

	public String getMng_check	(){		return	mng_check;	}
	public String getMng_check_dt	(){		return	mng_check_dt;	}
}