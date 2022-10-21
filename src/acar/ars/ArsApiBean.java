package acar.ars;

public class ArsApiBean {

    private int no;             		// 템플릿 번호
    private String code;        	// 템플릿 코드
    private String name;        	// 템플릿 이름
    private String content;     	// 템플릿 내용
    private String org_name;    	// 발신 이름
    private String org_uuid;    	// 발신 프로필 키
    private String desc;        	// 설명
    private String category;    	// 카테고리
    private String category_1;  	// 카테고리_1
    private String showList;    	// 템플릿 관리 여부
    private String use_yn;			// 템플릿 사용여부
    private String m_nm;			// 메뉴
    
	private String type;			//구분
	private String client_id;		//고객 user_id
    private String firm_nm;		//고객명
    private String br_id;     		//담당자 br_id    

	private String user_id;     	//담당자 user_id
    private String user_nm;    	//담당자 이름
    private String user_m_tel;	//담당자 전화번호
    
    private String rent_mng_id;	
    private String rent_l_cd;		
    private String car_mng_id;	
    private String car_no;			
    private String ars_group;		//담당자그룹
    
    private int id;
    private String user_type;
    private String cid;
    private String redirect_number;
    private String hangup_time;
    private int bill_duration;
	private String call_status;
	private String info_type;
	
	private String result_code;
	
	private String called_number;
	private String access_number;
	private String call_date;
	private String dial_time;
	private String answer_time;
	private String dtmf_string;
	private String callback_flag;	
	private int call_duration;
	
	private String api_call_url;	

	public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
    	if (code == null) {
    		code = "";
    	}
    	this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
    	if (name == null) {
    		name = "";
    	}
    	this.name = name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
    	if (content == null) {
    		content = "";
    	}
    	this.content = content;
    }

    public String getOrg_name() {
        return org_name;
    }

    public void setOrg_name(String org_name) {
    	if (org_name == null) {
    		org_name = "";
    	}
    	this.org_name = org_name;
    }

    public String getOrg_uuid() {
        return org_uuid;
    }

    public void setOrg_uuid(String org_uuid) {
    	if (org_uuid == null) {
    		org_uuid = "";
    	}
    	this.org_uuid = org_uuid;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
    	if (desc == null) {
    		desc = "";
    	}
    	this.desc = desc;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
    	if (category == null) {
    		category = "";
    	}
    	this.category = category;
    }
    
    public String getCategory_1() {
        return category_1;
    }

    public void setCategory_1(String category_1) {
    	if (category_1 == null) {
    		category_1 = "";
    	}
    	this.category_1 = category_1;
    }

    public String getShowList() {
        return showList;
    }

    public void setShowList(String showList) {
    	if (showList == null) {
    		showList = "";
    	}
    	this.showList = showList;
    }

    public String getUse_yn() {
        return use_yn;
    }

    public void setUse_yn(String use_yn) {
    	if (use_yn == null) {
    		use_yn = "";
    	}
    	this.use_yn = use_yn;
    }
    
    public String getM_nm() {
    	return m_nm;
    }
    
    public void setM_nm(String m_nm) {
    	if (m_nm == null) {
    		m_nm = "";
    	}
    	this.m_nm = m_nm;
    }
    
    
    
    public String getType() {
		return type;
	}

	public void setType(String type) {
		if (type == null) {
			type = "";
    	}
		this.type = type;
	}
	
	public String getClient_id() {
		return client_id;
	}
	
	public void setClient_id(String client_id) {
		if (client_id == null) {
			client_id = "";
    	}
		this.client_id = client_id;
	}

	public String getFirm_nm() {
		return firm_nm;
	}

	public void setFirm_nm(String firm_nm) {
		if (firm_nm == null) {
			firm_nm = "";
    	}
		this.firm_nm = firm_nm;
	}
	
	public String getBr_id() {
		return br_id;
	}

	public void setBr_id(String br_id) {
		if (br_id == null) {
			br_id = "";
    	}
		this.br_id = br_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		if (user_id == null) {
			user_id = "";
    	}
		this.user_id = user_id;
	}

	public String getUser_nm() {
		return user_nm;
	}

	public void setUser_nm(String user_nm) {
		if (user_nm == null) {
			user_nm = "";
    	}
		this.user_nm = user_nm;
	}

	public String getUser_m_tel() {
		return user_m_tel;
	}

	public void setUser_m_tel(String user_m_tel) {
		if (user_m_tel == null) {
			user_m_tel = "";
    	}
		this.user_m_tel = user_m_tel;
	}
	
	public String getRent_mng_id() {
		return rent_mng_id;
	}

	public void setRent_mng_id(String rent_mng_id) {
		if (rent_mng_id == null) {
			rent_mng_id = "";
    	}
		this.rent_mng_id = rent_mng_id;
	}

	public String getRent_l_cd() {
		return rent_l_cd;
	}

	public void setRent_l_cd(String rent_l_cd) {
		if (rent_l_cd == null) {
			rent_l_cd = "";
    	}
		this.rent_l_cd = rent_l_cd;
	}

	public String getCar_mng_id() {
		return car_mng_id;
	}

	public void setCar_mng_id(String car_mng_id) {
		if (car_mng_id == null) {
			car_mng_id = "";
    	}
		this.car_mng_id = car_mng_id;
	}	

	public String getCar_no() {
		return car_no;
	}

	public void setCar_no(String car_no) {
		if (car_no == null) {
			car_no = "";
    	}
		this.car_no = car_no;
	}

	public String getArs_group() {
		return ars_group;
	}

	public void setArs_group(String ars_group) {
		if (ars_group == null) {
			ars_group = "";
    	}
		this.ars_group = ars_group;
	}
	
		
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUser_type() {
		return user_type;
	}

	public void setUser_type(String user_type) {
		if (user_type == null) {
			user_type = "";
    	}
		this.user_type = user_type;
	}

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		if (cid == null) {
			cid = "";
    	}
		this.cid = cid;
	}

	public String getRedirect_number() {
		return redirect_number;
	}

	public void setRedirect_number(String redirect_number) {
		if (redirect_number == null) {
			redirect_number = "";
    	}
		this.redirect_number = redirect_number;
	}

	public String getHangup_time() {
		return hangup_time;
	}

	public void setHangup_time(String hangup_time) {
		if (hangup_time == null) {
			hangup_time = "";
    	}
		this.hangup_time = hangup_time;
	}

	public int getBill_duration() {
		return bill_duration;
	}

	public void setBill_duration(int bill_duration) {
		this.bill_duration = bill_duration;
	}

	public String getCall_status() {
		return call_status;
	}

	public void setCall_status(String call_status) {
		if (call_status == null) {
			call_status = "";
    	}
		this.call_status = call_status;
	}
	
	public String getInfo_type() {
		return info_type;
	}
	
	public void setInfo_type(String info_type) {
		if (info_type == null) {
			info_type = "";
		}
		this.info_type = info_type;
	}

	public String getResult_code() {
		return result_code;
	}

	public void setResult_code(String result_code) {
		if (result_code == null) {
			result_code = "";
		}
		this.result_code = result_code;
	}

	public String getCalled_number() {
		return called_number;
	}

	public void setCalled_number(String called_number) {
		if (called_number == null) {
			called_number = "";
		}
		this.called_number = called_number;
	}

	public String getAccess_number() {
		return access_number;
	}

	public void setAccess_number(String access_number) {
		if (access_number == null) {
			access_number = "";
		}
		this.access_number = access_number;
	}

	public String getCall_date() {
		return call_date;
	}

	public void setCall_date(String call_date) {
		if (call_date == null) {
			call_date = "";
		}
		this.call_date = call_date;
	}

	public String getDial_time() {
		return dial_time;
	}

	public void setDial_time(String dial_time) {
		if (dial_time == null) {
			dial_time = "";
		}
		this.dial_time = dial_time;
	}

	public String getAnswer_time() {
		return answer_time;
	}

	public void setAnswer_time(String answer_time) {
		if (answer_time == null) {
			answer_time = "";
		}
		this.answer_time = answer_time;
	}

	public String getDtmf_string() {
		return dtmf_string;
	}

	public void setDtmf_string(String dtmf_string) {
		if (dtmf_string == null) {
			dtmf_string = "";
		}
		this.dtmf_string = dtmf_string;
	}

	public String getCallback_flag() {
		return callback_flag;
	}

	public void setCallback_flag(String callback_flag) {
		if (callback_flag == null) {
			callback_flag = "";
		}
		this.callback_flag = callback_flag;
	}

	public int getCall_duration() {
		return call_duration;
	}

	public void setCall_duration(int call_duration) {
		this.call_duration = call_duration;
	}

	public String getApi_call_url() {
		return api_call_url;
	}

	public void setApi_call_url(String api_call_url) {
		if (api_call_url == null) {
			api_call_url = "";
		}
		this.api_call_url = api_call_url;
	}
	

}
