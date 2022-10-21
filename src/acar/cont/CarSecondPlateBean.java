package acar.cont;

public class CarSecondPlateBean {

	private String rent_mng_id = "";
	private String rent_l_cd = "";
	private String second_plate_yn = ""; //보조번호판발급요청
	private String warrant = ""; //위임장
	private String bus_regist = ""; //사업자등록증
	private String car_regist = ""; //차량등록증
	private String corp_regist = ""; //법인등기부등본
	private String corp_cert = ""; //법인임감증명서
	private String client_nm = ""; //우편물수령자
	private String client_number = ""; //우편물수령자 연락처
	private String client_zip = ""; //우편물수령지 우편주소
	private String client_addr = ""; //우편물수령지 주소
	private String client_detail_addr = ""; //우편물수령지 상세 주소
	private String etc = ""; //미회수 사유
	private String return_dt = ""; //회수일자
	private String reg_id = ""; //등록자
	private String reg_dt = ""; //등록일
	private String update_dt = ""; //수정일

	//CONSTRCTOR
	public CarSecondPlateBean() {
		rent_mng_id = "";
		rent_l_cd = "";
		second_plate_yn = "";
		warrant = "";
		bus_regist = "";
		car_regist = "";
		corp_regist = "";
		corp_cert = "";
		client_nm = "";
		client_number = "";
		client_zip = "";
		client_addr = "";
		client_detail_addr = "";
		etc = "";
		return_dt = "";
		reg_id = "";
		reg_dt = "";
		update_dt = "";
	}

	//Set Method
	public void setRent_mng_id(String str) {
		if (str == null) {
			str = "";
		}
		rent_mng_id = str;
	}

	public void setRent_l_cd(String str) {
		if (str == null) {
			str = "";
		}
		rent_l_cd = str;
	}

	public void setSecond_plate_yn(String str) {
		if (str == null) {
			str = "";
		}
		second_plate_yn = str;
	}

	public void setWarrant(String str) {
		if (str == null) {
			str = "";
		}
		warrant = str;
	}

	public void setBus_regist(String str) {
		if (str == null) {
			str = "";
		}
		bus_regist = str;
	}

	public void setCar_regist(String str) {
		if (str == null) {
			str = "";
		}
		car_regist = str;
	}

	public void setCorp_regist(String str) {
		if (str == null) {
			str = "";
		}
		corp_regist = str;
	}

	public void setCorp_cert(String str) {
		if (str == null) {
			str = "";
		}
		corp_cert = str;
	}

	public void setClient_nm(String str) {
		if (str == null) {
			str = "";
		}
		client_nm = str;
	}

	public void setClient_number(String str) {
		if (str == null) {
			str = "";
		}
		client_number = str;
	}

	public void setClient_zip(String str) {
		if (str == null) {
			str = "";
		}
		client_zip = str;
	}

	public void setClient_addr(String str) {
		if (str == null) {
			str = "";
		}
		client_addr = str;
	}

	public void setClient_detail_addr(String str) {
		if (str == null) {
			str = "";
		}
		client_detail_addr = str;
	}

	public void setEtc(String str) {
		if (str == null) {
			str = "";
		}
		etc = str;
	}

	public void setReturn_dt(String str) {
		if (str == null) {
			str = "";
		}
		return_dt = str;
	}

	public void setReg_id(String str) {
		if (str == null) {
			str = "";
		}
		reg_id = str;
	}

	public void setReg_dt(String str) {
		if (str == null) {
			str = "";
		}
		reg_dt = str;
	}

	public void setUpdate_dt(String str) {
		if (str == null) {
			str = "";
		}
		update_dt = str;
	}

	//Get Method
	public String getRent_mng_id() {
		return rent_mng_id;
	}

	public String getRent_l_cd() {
		return rent_l_cd;
	}

	public String getSecond_plate_yn() {
		return second_plate_yn;
	}

	public String getWarrant() {
		return warrant;
	}

	public String getBus_regist() {
		return bus_regist;
	}

	public String getCar_regist() {
		return car_regist;
	}

	public String getCorp_regist() {
		return corp_regist;
	}

	public String getCorp_cert() {
		return corp_cert;
	}

	public String getClient_nm() {
		return client_nm;
	}

	public String getClient_number() {
		return client_number;
	}

	public String getClient_zip() {
		return client_zip;
	}

	public String getClient_addr() {
		return client_addr;
	}

	public String getClient_detail_addr() {
		return client_detail_addr;
	}

	public String getEtc() {
		return etc;
	}

	public String getReturn_dt() {
		return return_dt;
	}

	public String getReg_id() {
		return reg_id;
	}

	public String getReg_dt() {
		return reg_dt;
	}

	public String getUpdate_dt() {
		return update_dt;
	}

}