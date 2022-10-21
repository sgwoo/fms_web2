/**
 * 재리스
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 12. 13. 월.
 * @ last modify date : 
 */
package acar.secondhand;

import java.util.*;

public class SecondhandBean{
	//Table : SECONDHAND	재리스
	private String car_mng_id;	//자동차관리번호
	private String seq;			//순번
	private int base_sh_pr;		//기준중고차가격
	private String base_sh_dt;	//중고차가격적용시기준일
	private String apply_sh_dt;	//견적기준일
	private String real_km;		//실주행거리
	private int apply_sh_pr;	//적용중고차가격
	private String reg_id;
	private String reg_dt;
	private String upd_id;
	private String upd_dt;
	private int ls12	;			//리스일반식
	private int ls18	;
	private int ls24	;
	private int ls30	;
	private int ls36	;
	private int ls42	;
	private int ls48	;
	private int lb12	;			//리스기본식
	private int lb18	;
	private int lb24	;
	private int lb30	;
	private int lb36	;
	private int lb42	;
	private int lb48	;
	private int rs1		;			//렌트일반식
	private int rs2		;
	private int rs3		;
	private int rs4		;
	private int rs5		;
	private int rs6		;
	private int rs7		;
	private int rs8		;
	private int rs9		;
	private int rs10	;
	private int rs11	;
	private int rs12	;
	private int rs18	;
	private int rs24	;
	private int rs30	;
	private int rs36	;
	private int rs42	;
	private int rs48	;
	private int rb1		;			//렌트기본식
	private int rb2		;
	private int rb3		;
	private int rb4		;
	private int rb5		;
	private int rb6		;
	private int rb7		;
	private int rb8		;
	private int rb9		;
	private int rb10	;
	private int rb11	;
	private int rb12	;
	private int rb18	;
	private int rb24	;
	private int rb30	;
	private int rb36	;
	private int rb42	;
	private int rb48	;
	private String upload_id;
	private String upload_dt;
	private String est_id;
	
	public SecondhandBean(){
		this.car_mng_id = "";
		this.seq = "";
		this.base_sh_pr = 0;
		this.base_sh_dt = "";
		this.apply_sh_dt = "";
		this.real_km = "";
		this.apply_sh_pr = 0;
		this.reg_id = "";
		this.reg_dt = "";
		this.upd_id = "";
		this.upd_dt = "";
		this.ls12	= 0;
		this.ls18	= 0;
		this.ls24	= 0;
		this.ls30	= 0;
		this.ls36	= 0;
		this.ls42	= 0;
		this.ls48	= 0;
		this.lb12	= 0;
		this.lb18	= 0;
			 lb24	= 0;
			 lb30	= 0;
			 lb36	= 0;
			 lb42	= 0;
			 lb48	= 0;
			 rs1	= 0;
			 rs2	= 0;
			 rs3	= 0;
			 rs4	= 0;
			 rs5	= 0;
			 rs6	= 0;
			 rs7	= 0;
			 rs8	= 0;
			 rs9	= 0;
			 rs10	= 0;
			 rs11	= 0;
			 rs12	= 0;
			 rs18	= 0;
			 rs24	= 0;
			 rs30	= 0;
			 rs36	= 0;
			 rs42	= 0;
			 rs48	= 0;
			 rb1	= 0;
			 rb2	= 0;
			 rb3	= 0;
			 rb4	= 0;
			 rb5	= 0;
			 rb6	= 0;
			 rb7	= 0;
			 rb8	= 0;
			 rb9	= 0;
			 rb10	= 0;
			 rb11	= 0;
			 rb12	= 0;
			 rb18	= 0;
			 rb24	= 0;
			 rb30	= 0;
			 rb36	= 0;
			 rb42	= 0;
			 rb48	= 0;
		this.upload_id = "";
		this.upload_dt = "";
		this.est_id   = "";
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setBase_sh_pr(int val){ this.base_sh_pr = val; }
	public void setBase_sh_dt(String val){ if(val==null) val=""; this.base_sh_dt = val; }
	public void setApply_sh_dt(String val){ if(val==null) val=""; this.apply_sh_dt = val; }
	public void setReal_km(String val){ if(val==null) val=""; this.real_km = val; }
	public void setApply_sh_pr(int val){ this.apply_sh_pr = val; }
	public void setReg_id(String val){ if(val==null) val=""; this.reg_id = val; }
	public void setReg_dt(String val){ if(val==null) val=""; this.reg_dt = val; }
	public void setUpd_id(String val){ if(val==null) val=""; this.upd_id = val; }
	public void setUpd_dt(String val){ if(val==null) val=""; this.upd_dt = val; }
	public void setLs12(int val){ this.ls12 = val; }
	public void setLs18(int val){ this.ls18 = val; }
	public void setLs24(int val){ this.ls24 = val; }
	public void setLs30(int val){ this.ls30 = val; }
	public void setLs36(int val){ this.ls36 = val; }
	public void setLs42(int val){ this.ls42 = val; }
	public void setLs48(int val){ this.ls48 = val; }
	public void setLb12(int val){ this.lb12 = val; }
	public void setLb18(int val){ this.lb18 = val; }
	public void setLb24(int val){ this.lb24 = val; }
	public void setLb30(int val){ this.lb30 = val; }
	public void setLb36(int val){ this.lb36 = val; }
	public void setLb42(int val){ this.lb42 = val; }
	public void setLb48(int val){ this.lb48 = val; }
	public void setRs1 (int val){ this.rs1	 = val; }
	public void setRs2 (int val){ this.rs2	 = val; }
	public void setRs3 (int val){ this.rs3	 = val; }
	public void setRs4 (int val){ this.rs4	 = val; }
	public void setRs5 (int val){ this.rs5	 = val; }
	public void setRs6 (int val){ this.rs6	 = val; }
	public void setRs7 (int val){ this.rs7	 = val; }
	public void setRs8 (int val){ this.rs8	 = val; }
	public void setRs9 (int val){ this.rs9	 = val; }
	public void setRs10(int val){ this.rs10 = val; }
	public void setRs11(int val){ this.rs11 = val; }
	public void setRs12(int val){ this.rs12 = val; }
	public void setRs18(int val){ this.rs18 = val; }
	public void setRs24(int val){ this.rs24 = val; }
	public void setRs30(int val){ this.rs30 = val; }
	public void setRs36(int val){ this.rs36 = val; }
	public void setRs42(int val){ this.rs42 = val; }
	public void setRs48(int val){ this.rs48 = val; }
	public void setRb1 (int val){ this.rb1	 = val; }
	public void setRb2 (int val){ this.rb2	 = val; }
	public void setRb3 (int val){ this.rb3	 = val; }
	public void setRb4 (int val){ this.rb4	 = val; }
	public void setRb5 (int val){ this.rb5	 = val; }
	public void setRb6 (int val){ this.rb6	 = val; }
	public void setRb7 (int val){ this.rb7	 = val; }
	public void setRb8 (int val){ this.rb8	 = val; }
	public void setRb9 (int val){ this.rb9	 = val; }
	public void setRb10(int val){ this.rb10 = val; }
	public void setRb11(int val){ this.rb11 = val; }
	public void setRb12(int val){ this.rb12 = val; }
	public void setRb18(int val){ this.rb18 = val; }
	public void setRb24(int val){ this.rb24 = val; }
	public void setRb30(int val){ this.rb30 = val; }
	public void setRb36(int val){ this.rb36 = val; }
	public void setRb42(int val){ this.rb42 = val; }
	public void setRb48(int val){ this.rb48 = val; }
	public void setUpload_id(String val){ if(val==null) val=""; this.upload_id = val; }
	public void setUpload_dt(String val){ if(val==null) val=""; this.upload_dt = val; }
	public void setEst_id(String val){ if(val==null) val=""; this.est_id = val; }
	
	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getSeq(){ return seq; }
	public int getBase_sh_pr(){ return base_sh_pr; }
	public String getBase_sh_dt(){ return base_sh_dt; }
	public String getApply_sh_dt(){ return apply_sh_dt; }
	public String getReal_km(){ return real_km; }
	public int getApply_sh_pr(){ return apply_sh_pr; }
	public String getReg_id(){ return reg_id; }
	public String getReg_dt(){ return reg_dt; }
	public String getUpd_id(){ return upd_id; }
	public String getUpd_dt(){ return upd_dt; }
	public int getLs12(){	return ls12;	}
	public int getLs18(){	return ls18;	}
	public int getLs24(){	return ls24;	}
	public int getLs30(){	return ls30;	}
	public int getLs36(){	return ls36;	}
	public int getLs42(){	return ls42;	}
	public int getLs48(){	return ls48;	}
	public int getLb12(){	return lb12;	}
	public int getLb18(){	return lb18;	}
	public int getLb24(){	return lb24;	}
	public int getLb30(){	return lb30;	}
	public int getLb36(){	return lb36;	}
	public int getLb42(){	return lb42;	}
	public int getLb48(){	return lb48;	}
	public int getRs1 (){	return rs1	;	}
	public int getRs2 (){	return rs2	;	}
	public int getRs3 (){	return rs3	;	}
	public int getRs4 (){	return rs4	;	}
	public int getRs5 (){	return rs5	;	}
	public int getRs6 (){	return rs6	;	}
	public int getRs7 (){	return rs7	;	}
	public int getRs8 (){	return rs8	;	}
	public int getRs9 (){	return rs9	;	}
	public int getRs10(){	return rs10;	}
	public int getRs11(){	return rs11;	}
	public int getRs12(){	return rs12;	}
	public int getRs18(){	return rs18;	}
	public int getRs24(){	return rs24;	}
	public int getRs30(){	return rs30;	}
	public int getRs36(){	return rs36;	}
	public int getRs42(){	return rs42;	}
	public int getRs48(){	return rs48;	}
	public int getRb1 (){	return rb1	;	}
	public int getRb2 (){	return rb2	;	}
	public int getRb3 (){	return rb3	;	}
	public int getRb4 (){	return rb4	;	}
	public int getRb5 (){	return rb5	;	}
	public int getRb6 (){	return rb6	;	}
	public int getRb7 (){	return rb7	;	}
	public int getRb8 (){	return rb8	;	}
	public int getRb9 (){	return rb9	;	}
	public int getRb10(){	return rb10;	}
	public int getRb11(){	return rb11;	}
	public int getRb12(){	return rb12;	}
	public int getRb18(){	return rb18;	}
	public int getRb24(){	return rb24;	}
	public int getRb30(){	return rb30;	}
	public int getRb36(){	return rb36;	}
	public int getRb42(){	return rb42;	}
	public int getRb48(){	return rb48;	}
	public String getUpload_id(){	return upload_id; }
	public String getUpload_dt(){	return upload_dt; }
	public String getEst_id(){     return est_id;   }

}