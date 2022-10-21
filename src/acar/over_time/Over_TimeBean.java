/**
 * 특근수당 - 특근수당신청
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 1. 20
 * @ last modify date : 
 */
package acar.over_time;

import java.util.*;

public class Over_TimeBean {
    //Table : over_time
    private String user_id;				//사용자 아이디
	private String reg_dt;		//등록일
	//사전결재
	private String over_sjgj;
	private String over_sjgj_dt;
	private String over_sjgj_op;
	//목적/처리결과
	private String over_cont;
	private String over_cr;
	
	/* 실제근로시간/인정근로시간 */
	private String jb_time;
	private String jb_time2;

	//근로장소 주소
	private String over_addr;

	//비용지출내역:식대
	private String over_card1_dt;
	private int over_card1_amt;
	private String over_cash1_dt;
	private int over_cash1_amt;
	private String over_cash1_file;
	private int over_cash1_cr_amt;
	private String over_cash1_cr_dt;
	private String over_cash1_cr_jpno;
	private String over_s_cash1_dt;
	private int over_s_cash1_amt;
	private String over_s_cash1_file;
	private int over_s_cash1_cr_amt;
	private String over_s_cash1_cr_jpno;

	//비용지출내역:교통비
	private String over_card2_dt;
	private int over_card2_amt;
	private String over_cash2_dt;
	private int over_cash2_amt;
	private String over_cash2_file;
	private int over_cash2_cr_amt;
	private String over_cash2_cr_dt;
	private String over_cash2_cr_jpno;
	private String over_s_cash2_dt;
	private int over_s_cash2_amt;
	private String over_s_cash2_file;
	private int over_s_cash2_cr_amt;
	private String over_s_cash2_cr_jpno;

	//비용지출내역:기타
	private String over_card3_dt;
	private int over_card3_amt;
	private String over_cash3_dt;
	private int over_cash3_amt;
	private String over_cash3_file;
	private int over_cash3_cr_amt;
	private String over_cash3_cr_dt;
	private String over_cash3_cr_jpno;
	private String over_s_cash3_dt;
	private int over_s_cash3_amt;
	private String over_s_cash3_file;
	private int over_s_cash3_cr_amt;
	private String over_s_cash3_cr_jpno;

	//비용지출 합계
	private int over_card_tot;
	private int over_cash_tot;
	private int over_s_cash_tot;
	//산출급여
	private int over_scgy;
	private String over_scgy_dt;
	private String over_scgy_pl_dt;
	//사전결재 - 팀장
	private String s_check;
	private String s_check_dt;
	private String s_check_id;
	//사전결재 - 대표이사
	private String s_check1;
	private String s_check1_dt;
	private String s_check1_id;
	//최종결재 - 
	private String t_check;
	private String t_check_dt;
	private String t_check_id;

	private String t_check1;
	private String t_check1_dt;
	private String t_check1_id;

	private String t_check2;
	private String t_check2_dt;
	private String t_check2_id;

	private String t_check3;
	private String t_check3_dt;
	private String t_check3_id;

	private String t_check4;
	private String t_check4_dt;
	private String t_check4_id;

	private String doc_no;
	//출퇴근시간
	private String start_dt;
	private String start_h;
	private String start_m;

	private String end_dt;
	private String end_h;
	private String end_m;

	private String over_time_year;
	private String over_time_mon;


		
    // CONSTRCTOR            
    public Over_TimeBean() {  
		this.user_id = "";
		this.reg_dt = "";
		this.over_sjgj = "";
		this.over_sjgj_dt = "";
		this.over_sjgj_op ="";
		this.over_cont = "";
		this.over_cr = "";

		this.jb_time = "";
		this.jb_time2 = "";
		this.over_addr = "";
		this.over_card1_dt = "";
		this.over_card1_amt =  0;
		this.over_cash1_dt = "";
		this.over_cash1_amt =  0;
		this.over_cash1_file = "";
		this.over_cash1_cr_amt =  0;
		this.over_cash1_cr_dt = "";
		this.over_cash1_cr_jpno = "";
		this.over_s_cash1_dt = "";
		this.over_s_cash1_amt =  0;
		this.over_s_cash1_file = "";
		this.over_s_cash1_cr_amt =  0;
		this.over_s_cash1_cr_jpno = "";
		this.over_card2_dt = "";
		this.over_card2_amt =  0;
		this.over_cash2_dt = "";
		this.over_cash2_amt =   0;
		this.over_cash2_file = "";
		this.over_cash2_cr_amt =  0;
		this.over_cash2_cr_dt = "";
		this.over_cash2_cr_jpno = "";
		this.over_s_cash2_dt = "";
		this.over_s_cash2_amt =  0;
		this.over_s_cash2_file = "";
		this.over_s_cash2_cr_amt =  0;
		this.over_s_cash2_cr_jpno = "";
		this.over_card3_dt = "";
		this.over_card3_amt =  0;
		this.over_cash3_dt = "";
		this.over_cash3_amt =  0;
		this.over_cash3_file = "";
		this.over_cash3_cr_amt =  0;
		this.over_cash3_cr_dt = "";
		this.over_cash3_cr_jpno = "";
		this.over_s_cash3_dt = "";
		this.over_s_cash3_amt =  0;
		this.over_s_cash3_file = "";
		this.over_s_cash3_cr_amt =  0;
		this.over_s_cash3_cr_jpno = "";
		this.over_card_tot =   0;
		this.over_cash_tot =   0;
		this.over_s_cash_tot =   0;
		this.over_scgy = 0;
		this.over_scgy_dt = "";
		this.over_scgy_pl_dt = "";

		this.s_check = "";
		this.s_check_dt = "";
		this.s_check_id = "";
		this.s_check1 = "";
		this.s_check1_dt = "";
		this.s_check1_id = "";

		this.t_check = "";
		this.t_check_dt = "";
		this.t_check_id = "";

		this.t_check1 = "";
		this.t_check1_dt = "";
		this.t_check1_id = "";

		this.t_check2 = "";
		this.t_check2_dt = "";
		this.t_check2_id = "";

		this.t_check3 = "";
		this.t_check3_dt = "";
		this.t_check3_id = "";

		this.t_check4 = "";
		this.t_check4_dt = "";
		this.t_check4_id = "";

		this.doc_no = "";

		this.start_dt = "";
		this.start_h = "";
		this.start_m = "";

		this.end_dt = "";
		this.end_h = "";
		this.end_m = "";

		this.over_time_year = "";
		this.over_time_mon = "";

	}


	// set Method
	public void setUser_id(String val)	{	if(val==null) val="";	this.user_id = val;		}
	public void setReg_dt(String val)	{	if(val==null) val="";	this.reg_dt = val;		}
	
	public void setOver_sjgj(String val)	{	if(val==null) val="";	this.over_sjgj = val;	}
	public void setOver_sjgj_dt(String val)	{	if(val==null) val="";	this.over_sjgj_dt = val;	}
	public void setOver_sjgj_op(String val)	{	if(val==null) val="";	this.over_sjgj_op = val;	}

	public void setOver_cont(String val){	if(val==null) val="";	this.over_cont = val;	}
	public void setOver_cr(String val)	{	if(val==null) val="";	this.over_cr = val;		}
	
	
	public void setJb_time(String val)	{	if(val==null) val="";	this.jb_time = val;		}
	public void setJb_time2(String val)	{	if(val==null) val="";	this.jb_time2 = val;		}

	public void setOver_addr(String val)	{if(val==null) val="";	this.over_addr = val;	}

	public void setOver_card1_dt (String val)	{if(val==null) val="";	this.over_card1_dt = val;	}
	public void setOver_card1_amt (int val)	{							this.over_card1_amt = val;	}
	public void setOver_cash1_dt (String val)	{if(val==null) val="";	this.over_cash1_dt = val;	}
	public void setOver_cash1_amt (int val)	{							this.over_cash1_amt = val;	}
	public void setOver_cash1_file (String val)	{if(val==null) val="";	this.over_cash1_file = val;	}
	public void setOver_cash1_cr_amt (int val)	{						this.over_cash1_cr_amt = val;	}
	public void setOver_cash1_cr_dt (String val)	{if(val==null) val="";	this.over_cash1_cr_dt = val;	}
	public void setOver_cash1_cr_jpno (String val)	{if(val==null) val="";	this.over_cash1_cr_jpno = val;	}
	public void setOver_s_cash1_dt (String val)	{if(val==null) val="";	this.over_s_cash1_dt = val;	}
	public void setOver_s_cash1_amt (int val)	{						this.over_s_cash1_amt = val;	}
	public void setOver_s_cash1_file (String val)	{if(val==null) val="";	this.over_s_cash1_file = val;	}
	public void setOver_s_cash1_cr_amt (int val){						this.over_s_cash1_cr_amt = val;	}
	public void setOver_s_cash1_cr_jpno (String val)	{if(val==null) val="";	this.over_s_cash1_cr_jpno = val;	}

	public void setOver_card2_dt (String val)	{if(val==null) val="";	this.over_card2_dt = val;	}
	public void setOver_card2_amt (int val)		{						this.over_card2_amt = val;	}
	public void setOver_cash2_dt (String val)	{if(val==null) val="";	this.over_cash2_dt = val;	}
	public void setOver_cash2_amt (int val)		{						this.over_cash2_amt = val;	}
	public void setOver_cash2_file (String val)	{if(val==null) val="";	this.over_cash2_file = val;	}
	public void setOver_cash2_cr_amt (int val)	{						this.over_cash2_cr_amt = val;	}
	public void setOver_cash2_cr_dt (String val)	{if(val==null) val="";	this.over_cash2_cr_dt = val;	}
	public void setOver_cash2_cr_jpno (String val)	{if(val==null) val="";	this.over_cash2_cr_jpno = val;	}
	public void setOver_s_cash2_dt (String val)	{if(val==null) val="";	this.over_s_cash2_dt = val;	}
	public void setOver_s_cash2_amt (int val)	{							this.over_s_cash2_amt = val;	}
	public void setOver_s_cash2_file (String val)	{if(val==null) val="";	this.over_s_cash2_file = val;	}
	public void setOver_s_cash2_cr_amt (int val){	this.over_s_cash2_cr_amt = val;	}
	public void setOver_s_cash2_cr_jpno (String val)	{if(val==null) val="";	this.over_s_cash2_cr_jpno = val;	}

	public void setOver_card3_dt (String val)	{if(val==null) val="";	this.over_card3_dt = val;	}
	public void setOver_card3_amt (int val)	{							this.over_card3_amt = val;	}
	public void setOver_cash3_dt (String val)	{if(val==null) val="";	this.over_cash3_dt = val;	}
	public void setOver_cash3_amt (int val)	{			this.over_cash3_amt = val;	}
	public void setOver_cash3_file (String val)	{if(val==null) val="";	this.over_cash3_file = val;	}
	public void setOver_cash3_cr_amt (int val){	this.over_cash3_cr_amt = val;	}
	public void setOver_cash3_cr_dt (String val)	{if(val==null) val="";	this.over_cash3_cr_dt = val;	}
	public void setOver_cash3_cr_jpno (String val)	{if(val==null) val="";	this.over_cash3_cr_jpno = val;	}
	public void setOver_s_cash3_dt (String val)	{if(val==null) val="";	this.over_s_cash3_dt = val;	}
	public void setOver_s_cash3_amt (int val){	this.over_s_cash3_amt = val;	}
	public void setOver_s_cash3_file (String val)	{if(val==null) val="";	this.over_s_cash3_file = val;	}
	public void setOver_s_cash3_cr_amt (int val){	this.over_s_cash3_cr_amt = val;	}
	public void setOver_s_cash3_cr_jpno (String val)	{if(val==null) val="";	this.over_s_cash3_cr_jpno = val;	}

	public void setOver_card_tot (int val)	{							this.over_card_tot = val;	}
	public void setOver_cash_tot (int val)	{							this.over_cash_tot = val;	}
	public void setOver_s_cash_tot (int val){							this.over_s_cash_tot = val;	}

	public void setOver_scgy (int val)		{							this.over_scgy = val;	}
	public void setOver_scgy_dt (String val)	{if(val==null) val="";	this.over_scgy_dt = val;	}
	public void setOver_scgy_pl_dt (String val)	{if(val==null) val="";	this.over_scgy_pl_dt = val;	}

	public void setS_check (String val)	{if(val==null) val="";	this.s_check = val;	}
	public void setS_check_dt(String val)	{if(val==null) val="";	this.s_check_dt = val;	}
	public void setS_check_id (String val)	{if(val==null) val="";	this.s_check_id = val;	}
	
	public void setS_check1 (String val)	{if(val==null) val="";	this.s_check1 = val;	}
	public void setS_check1_dt(String val)	{if(val==null) val="";	this.s_check1_dt = val;	}
	public void setS_check1_id (String val)	{if(val==null) val="";	this.s_check1_id = val;	}
	
	public void setT_check (String val)	{if(val==null) val="";	this.t_check = val;	}
	public void setT_check_dt (String val)	{if(val==null) val="";	this.t_check_dt = val;	}
	public void setT_check_id (String val)	{if(val==null) val="";	this.t_check_id = val;	}

	public void setT_check1 (String val)	{if(val==null) val="";	this.t_check1 = val;	}
	public void setT_check1_dt (String val)	{if(val==null) val="";	this.t_check1_dt = val;	}
	public void setT_check1_id (String val)	{if(val==null) val="";	this.t_check1_id = val;	}

	public void setT_check2 (String val)	{if(val==null) val="";	this.t_check2 = val;	}
	public void setT_check2_dt (String val)	{if(val==null) val="";	this.t_check2_dt = val;	}
	public void setT_check2_id (String val)	{if(val==null) val="";	this.t_check2_id = val;	}

	public void setT_check3 (String val)	{if(val==null) val="";	this.t_check3 = val;	}
	public void setT_check3_dt (String val)	{if(val==null) val="";	this.t_check3_dt = val;	}
	public void setT_check3_id (String val)	{if(val==null) val="";	this.t_check3_id = val;	}

	public void setT_check4 (String val)	{if(val==null) val="";	this.t_check4 = val;	}
	public void setT_check4_dt (String val)	{if(val==null) val="";	this.t_check4_dt = val;	}
	public void setT_check4_id (String val)	{if(val==null) val="";	this.t_check4_id = val;	}

	public void setDoc_no (String val)	{if(val==null) val="";	this.doc_no = val;	}

	public void setStart_dt (String val)	{if(val==null) val = ""; this.start_dt = val; }
	public void setStart_h (String val)	{if(val==null) val = ""; this.start_h = val; }
	public void setStart_m (String val)	{if(val==null) val = ""; this.start_m = val; }

	public void setEnd_dt (String val)	{if(val==null) val = ""; this.end_dt = val; }
	public void setEnd_h (String val)	{if(val==null) val = ""; this.end_h = val; }
	public void setEnd_m (String val)	{if(val==null) val = ""; this.end_m = val; }

	public void setOver_time_year (String val)	{ if(val==null) val = ""; this.over_time_year = val;}
	public void setOver_time_mon (String val)	{ if(val==null) val = ""; this.over_time_mon = val;}


	
				
	//Get Method
	public String 	getUser_id()	{			return user_id;		}
	public String	getReg_dt()		{			return reg_dt;		}

	public String	getOver_sjgj()		{			return over_sjgj;		}
	public String	getOver_sjgj_dt()		{		return over_sjgj_dt;		}
	public String	getOver_sjgj_op()		{		return over_sjgj_op;		}

	public String	getOver_cont()	{			return over_cont;	}
	public String	getOver_cr()	{			return over_cr;		}

	public String	getJb_time(){				return jb_time;		}
	public String	getJb_time2(){				return jb_time2;		}
	public String	getOver_addr()		{			return over_addr;		}

	public String	getOver_card1_dt()			{			return over_card1_dt;		}
	public int	getOver_card1_amt()			{			return over_card1_amt;		}
	public String	getOver_cash1_dt()			{			return over_cash1_dt;		}
	public int	getOver_cash1_amt()			{			return over_cash1_amt;		}
	public String	getOver_cash1_file()		{			return over_cash1_file;		}
	public int	getOver_cash1_cr_amt()		{			return over_cash1_cr_amt;		}
	public String	getOver_cash1_cr_dt()		{			return over_cash1_cr_dt;		}
	public String	getOver_cash1_cr_jpno()		{			return over_cash1_cr_jpno;		}
	public String	getOver_s_cash1_dt()		{			return over_s_cash1_dt;		}
	public int	getOver_s_cash1_amt()		{			return over_s_cash1_amt;		}
	public String	getOver_s_cash1_file()		{			return over_s_cash1_file;		}
	public int	getOver_s_cash1_cr_amt()	{			return over_s_cash1_cr_amt;		}
	public String	getOver_s_cash1_cr_jpno()	{			return over_s_cash1_cr_jpno;		}

	public String	getOver_card2_dt()			{			return over_card2_dt;		}
	public int	getOver_card2_amt()			{			return over_card2_amt;		}
	public String	getOver_cash2_dt()			{			return over_cash2_dt;		}
	public int	getOver_cash2_amt()			{			return over_cash2_amt;		}
	public String	getOver_cash2_file()		{			return over_cash2_file;		}
	public int	getOver_cash2_cr_amt()		{			return over_cash2_cr_amt;		}
	public String	getOver_cash2_cr_dt()		{			return over_cash2_cr_dt;		}
	public String	getOver_cash2_cr_jpno()		{			return over_cash2_cr_jpno;		}
	public String	getOver_s_cash2_dt()		{			return over_s_cash2_dt;		}
	public int	getOver_s_cash2_amt()		{			return over_s_cash2_amt;		}
	public String	getOver_s_cash2_file()		{			return over_s_cash2_file;		}
	public int	getOver_s_cash2_cr_amt()	{			return over_s_cash2_cr_amt;		}
	public String	getOver_s_cash2_cr_jpno()	{			return over_s_cash2_cr_jpno;		}

	public String	getOver_card3_dt()			{			return over_card3_dt;		}
	public int	getOver_card3_amt()			{			return over_card3_amt;		}
	public String	getOver_cash3_dt()			{			return over_cash3_dt;		}
	public int	getOver_cash3_amt()			{			return over_cash3_amt;		}
	public String	getOver_cash3_file()		{			return over_cash3_file;		}
	public int	getOver_cash3_cr_amt()		{			return over_cash3_cr_amt;		}
	public String	getOver_cash3_cr_dt()		{			return over_cash3_cr_dt;		}
	public String	getOver_cash3_cr_jpno()		{			return over_cash3_cr_jpno;		}
	public String	getOver_s_cash3_dt()		{			return over_s_cash3_dt;		}
	public int	getOver_s_cash3_amt()		{			return over_s_cash3_amt;		}
	public String	getOver_s_cash3_file()		{			return over_s_cash3_file;		}
	public int	getOver_s_cash3_cr_amt()	{			return over_s_cash3_cr_amt;		}
	public String	getOver_s_cash3_cr_jpno()	{			return over_s_cash3_cr_jpno;		}

	public int	getOver_card_tot()	{			return over_card_tot;		}
	public int	getOver_cash_tot()	{			return over_cash_tot;		}
	public int	getOver_s_cash_tot(){			return over_s_cash_tot;		}

	public int	getOver_scgy()	{			return over_scgy;		}
	public String	getOver_scgy_dt()	{			return over_scgy_dt;		}
	public String	getOver_scgy_pl_dt()	{			return over_scgy_pl_dt;		}

	public String	getS_check()	{			return s_check;		}
	public String	getS_check_dt()	{			return s_check_dt;		}
	public String	getS_check_id()	{			return s_check_id;		}

	public String	getS_check1()	{			return s_check1;		}
	public String	getS_check1_dt()	{			return s_check1_dt;		}
	public String	getS_check1_id()	{			return s_check1_id;		}

	public String	getT_check()	{			return t_check;		}
	public String	getT_check_dt()	{			return t_check_dt;		}
	public String	getT_check_id()	{			return t_check_id;		}

	public String	getT_check1()	{			return t_check1;		}
	public String	getT_check1_dt()	{			return t_check1_dt;		}
	public String	getT_check1_id()	{			return t_check1_id;		}
	
	public String	getT_check2()	{			return t_check2;		}
	public String	getT_check2_dt()	{			return t_check2_dt;		}
	public String	getT_check2_id()	{			return t_check2_id;		}
	
	public String	getT_check3()	{			return t_check3;		}
	public String	getT_check3_dt()	{			return t_check3_dt;		}
	public String	getT_check3_id()	{			return t_check3_id;		}

	public String	getT_check4()	{			return t_check4;		}
	public String	getT_check4_dt()	{			return t_check4_dt;		}
	public String	getT_check4_id()	{			return t_check4_id;		}

	public String	getDoc_no()	{			return doc_no;		}

	public String	getStart_dt()	{			return start_dt;		}
	public String	getStart_h()	{			return start_h;		}
	public String	getStart_m()	{			return start_m;		}

	public String	getEnd_dt()	{			return end_dt;		}
	public String	getEnd_h()	{			return end_h;		}
	public String	getEnd_m()	{			return end_m;		}

	public String	getOver_time_year()	{	return over_time_year;	}
	public String	getOver_time_mon()	{	return over_time_mon;	}


}