package acar.admin;

import java.util.*;

public class StatCarBean {
    //Table : STAT_DEBT
    private String car_no;		//차량번호
	private String age;			//지역
    private String use;			//용도
	private int kd;				//차종
	private int year;			//연식

	private String save_dt;			//마감일자
	private String seq;				//일련번호
	private int y2000;				//2000년식
	private int y2001;				//2001년식
	private int y2002;				//2002년식
	private int y2003;				//2003년식
	private int y2004;				//2004년식
	private int y2005;				//2005년식
	private int y2006;				//2006년식
	private int y2007;				//2007년식
	private int y2008;				//2008년식
	private int y2009;				//2009년식
	private int y2010;				//2010년식
	private int y2011;				//2010년식
	private int y2012;				//2010년식
	private int y2013;				//2010년식
	private int y2014;				//2010년식
	private int y2015;				//2010년식
	private int y2016;				//2006년식
	private int y2017;				//2007년식
	private int y2018;				//2008년식
	private int y2019;				//2009년식
	private int y2020;				//2010년식
	private String reg_id;			//등록자


	public StatCarBean() {  
		this.car_no = "";
		this.age = "";
		this.use = "";
		this.kd = 0;
		this.year = 0;

		this.save_dt = "";
		this.seq = "";
		this.y2000 = 0;
		this.y2001 = 0;
		this.y2002 = 0;
		this.y2003 = 0;
		this.y2004 = 0;
		this.y2005 = 0;
		this.y2006 = 0;
		this.y2007 = 0;
		this.y2008 = 0;
		this.y2009 = 0;
		this.y2010 = 0;
		this.y2011 = 0;
		this.y2012 = 0;
		this.y2013 = 0;
		this.y2014 = 0;
		this.y2015 = 0;
		this.y2016 = 0;
		this.y2017 = 0;
		this.y2018 = 0;
		this.y2019 = 0;
		this.y2020 = 0;
		this.reg_id = "";
	}

	// set Method
	public void setCar_no(String val){		if(val==null) val=""; this.car_no = val;	}
	public void setAge(String val){			if(val==null) val=""; this.age = val;		}
	public void setUse(String val){			if(val==null) val=""; this.use = val;		}
	public void setKd(int val){				this.kd = val;			}
    public void setYear(int val){			this.year = val;		}

	public void setSave_dt(String val){		if(val==null) val=""; this.save_dt = val;	}
	public void setSeq(String val){			if(val==null) val=""; this.seq = val;		}
	public void setY2000(int val){			this.y2000 = val;		}	
	public void setY2001(int val){			this.y2001 = val;		}	
	public void setY2002(int val){			this.y2002 = val;		}	
	public void setY2003(int val){			this.y2003 = val;		}	
	public void setY2004(int val){			this.y2004 = val;		}	
	public void setY2005(int val){			this.y2005 = val;		}	
	public void setY2006(int val){			this.y2006 = val;		}	
	public void setY2007(int val){			this.y2007 = val;		}	
	public void setY2008(int val){			this.y2008 = val;		}	
	public void setY2009(int val){			this.y2009 = val;		}	
	public void setY2010(int val){			this.y2010 = val;		}	
	public void setY2011(int val){			this.y2011 = val;		}	
	public void setY2012(int val){			this.y2012 = val;		}	
	public void setY2013(int val){			this.y2013 = val;		}	
	public void setY2014(int val){			this.y2014 = val;		}	
	public void setY2015(int val){			this.y2015 = val;		}	
	public void setY2016(int val){			this.y2016 = val;		}	
	public void setY2017(int val){			this.y2017 = val;		}	
	public void setY2018(int val){			this.y2018 = val;		}	
	public void setY2019(int val){			this.y2019 = val;		}	
	public void setY2020(int val){			this.y2020 = val;		}	

	public void setReg_id(String val){		if(val==null) val=""; this.reg_id = val;	}

	//Get Method
	public String getCar_no(){			return car_no;		}
    public String getAge(){				return age;			}
    public String getUse(){				return use;			}
    public int getKd(){					return kd;			}
    public int getYear(){				return year;		}

	public String getSave_dt(){			return save_dt;		}
	public String getSeq(){				return seq;			}
    public int getY2000(){				return y2000;		}	
	public int getY2001(){				return y2001;		}	
	public int getY2002(){				return y2002;		}	
	public int getY2003(){				return y2003;		}	
	public int getY2004(){				return y2004;		}	
	public int getY2005(){				return y2005;		}	
	public int getY2006(){				return y2006;		}	
	public int getY2007(){				return y2007;		}	
	public int getY2008(){				return y2008;		}	
	public int getY2009(){				return y2009;		}	
	public int getY2010(){				return y2010;		}	
	public int getY2011(){				return y2011;		}	
	public int getY2012(){				return y2012;		}	
	public int getY2013(){				return y2013;		}	
	public int getY2014(){				return y2014;		}	
	public int getY2015(){				return y2015;		}	
	public int getY2016(){				return y2016;		}	
	public int getY2017(){				return y2017;		}	
	public int getY2018(){				return y2018;		}	
	public int getY2019(){				return y2019;		}	
	public int getY2020(){				return y2020;		}	
	public String getReg_id(){			return reg_id;		}	

}