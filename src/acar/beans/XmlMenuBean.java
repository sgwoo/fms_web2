package acar.beans;

public class XmlMenuBean {
    //Table : MA_MENU (구MENU)
    private String m_st;					//대메뉴 구분
    private String m_st2;					//중메뉴 구분
    private String m_cd;					//소메뉴 구분
    private String m_nm;					//메뉴명
    private String url;						//url
    private String note;					//비고
    private int seq;						//순번
	private String base;					//디폴트체크
	private String user_id;
	private int sort;
        
    // CONSTRCTOR            
    public XmlMenuBean() {  
    	this.m_st = "";
    	this.m_st2 = "";
	    this.m_cd = "";
	    this.m_nm = "";
	    this.url = "";
	    this.note = "";
	    this.seq = 1;
		this.base = "";
		this.user_id = "";
		this.sort = 1;
	}

	//Set Method
	public void setM_st(String val){		if(val==null) val="";		this.m_st = val;	}
	public void setM_st2(String val){		if(val==null) val="";		this.m_st2 = val;	}
	public void setM_cd(String val){		if(val==null) val="";		this.m_cd = val;	}
	public void setM_nm(String val){		if(val==null) val="";		this.m_nm = val;	}
	public void setUrl(String val){			if(val==null) val="";		this.url = val;		}
	public void setNote(String val){		if(val==null) val="";		this.note = val;	}
	public void setSeq(int val){										this.seq = val;		}
	public void setBase(String val){		if(val==null) val="";		this.base = val;	}
	public void setUser_id(String val){		if(val==null) val="";		this.user_id = val;	}
	public void setSort(int val){										this.sort = val;	}

	//Get Method	
	public String getM_st(){		return m_st;	}
	public String getM_st2(){		return m_st2;	}
	public String getM_cd(){		return m_cd;	}
	public String getM_nm(){		return m_nm;	}
	public String getUrl(){			return url;		}
	public String getNote(){		return note;	}
	public int getSeq(){			return seq;		}
	public String getBase(){		return base;	}
	public String getUser_id(){		return user_id;	}
	public int getSort(){			return sort;	}

}