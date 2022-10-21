package acar.util;


/****
 * 파일 업로드 정보
 * @author Dev.ywkim
 * @since 2015. 05. 15
 *  1: 1MB, 0 : 무제한
 */
public enum UploadInfoEnum {
	FREE_TIME(						"upload_folder_01", "FREE_TIME"					,"5"),//휴가등록
	BAD_COMPLAINT_REQ(				"upload_folder_02", "BAD_COMPLAINT_REQ"			,"2"),//고소장접수요청
	BULLETIN(						"upload_folder_03", "BULLETIN"					,"0"),//사내게시판
	BBS(							"upload_folder_04", "BBS"						,"0"),//공지사항
	CARD_DOC(						"upload_folder_05", "CARD_DOC"					,"1"),//카드전표등록
	CAR_CHANGE(						"upload_folder_06", "CAR_CHANGE"				,"1"),//자동차관리
	FINE(							"upload_folder_07", "FINE"						,"1"),//과태료
	STAT_ACCT(						"upload_folder_08", "STAT_ACCT"					,"0"),
	TINT(							"upload_folder_09", "TINT"						,"2"),//용품or블박
	USERS(							"upload_folder_10", "USERS"						,"1"),//직원사진
	YEAR_JUNGSAN(					"upload_folder_11", "YEAR_JUNGSAN"				,"2"), //연말정산 
	ALLOT(							"upload_folder_12", "ALLOT"						,"2"),
	APPRSL(							"upload_folder_13", "APPRSL"					,"5"),//예약관리
	FINE_DOC(						"upload_folder_14", "FINE_DOC"					,"2"), //최고서발송대장
	LC_SCAN(						"upload_folder_15", "LC_SCAN"					,"5"),//계약기본스캔파일
	PIC_RESRENT_ACCID(				"upload_folder_16", "PIC_RESRENT_ACCID"			,"1"),//대차차량계약서
	PAY(							"upload_folder_17", "PAY"						,"0"),//출금
	STAT_CMP(						"upload_folder_18", "STAT_CMP"					,"2"),//통신비영수증등록
	CLS_ETC(						"upload_folder_19", "CLS_ETC"					,"2"),//해지정산문서관리
	BANK_ACC(						"upload_folder_20", "BANK_ACC"					,"1"),
	PROP_BBS(						"upload_folder_21", "PROP_BBS"					,"2"),//제안함
	SUI_ETC(						"upload_folder_22", "SUI_ETC"					,"2"),
	ACTN_SCAN(						"upload_folder_23", "ACTN_SCAN"					,"2"),//낙찰스캔관리
	KNOW_HOW(						"upload_folder_24", "KNOW_HOW"					,"2"), //아마존카 지식IN
	OVER_TIME(						"upload_folder_25", "OVER_TIME"					,"1"),//특근관리
	SC_SCAN(						"upload_folder_26", "SC_SCAN"					,"1"),//배차등록
	CAR_OFF_EMP(					"upload_folder_27", "CAR_OFF_EMP"				,"1"),//영업사원관리
	CONSIGNMENT(					"upload_folder_28", "CONSIGNMENT"				,"1"),//탁송등록
	LEND_BANK(						"upload_folder_29", "LEND_BANK"					,"5"),//은행대출관리
	PARTS_ORDER(					"upload_folder_30", "PARTS_ORDER"				,"1"),
	COMMI(							"upload_folder_31", "COMMI"						,"1"),//지급수수료관리
	COOPERATION(					"upload_folder_32", "COOPERATION"				,"2"), //업무협조
	PIC_ACCID(						"upload_folder_33", "PIC_ACCID"					,"3"),//사고처리결과문서관리
	SERVICE(						"upload_folder_34", "SERVICE"					,"0"),
	DOC_SETTLE(						"upload_folder_35", "DOC_SETTLE"				,"2"),
	OFF_DOC(						"upload_folder_36", "OFF_DOC"					,"5"),//자료실업무서식
    ESTI_SPE(						"upload_folder_37", "ESTI_SPE"                  ,"5"),//홈페이지 월렌트 차량예약 첨부파일
    CAR_COL(						"upload_folder_38", "CAR_COL"                   ,"1"),//색상관리 이미지
    INSUR(							"upload_folder_39", "INSUR"						,"0"),//보험가입증명서
    RECALL(							"upload_folder_40", "RECALL"					,"5"),//리콜안내문(20190108)
	ACCIDENT(						"upload_folder_41", "ACCIDENT"					,"0"),//사고관련(20190423)
	RECEIVE(						"upload_folder_42", "RECEIVE"					,"5");//채권관련(20191216)

	private String value;
	private String text;
	private String limit;
	
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
	public String getLimit() {
		return limit;
	}

	public void setLimit(String limit) {
		this.limit = limit;
	}

	UploadInfoEnum(String value, String text, String limit){
		this.value	= value;
		this.text	= text;
		this.limit	= limit; 
	}
	
	public static UploadInfoEnum getEnumByValue(String value){
		for(UploadInfoEnum enu : UploadInfoEnum.values()){
			if(enu.value.equals(value))
				return enu;
		}
		return null;
	}
	
	public static UploadInfoEnum getEnumByText(String value){
		for(UploadInfoEnum enu : UploadInfoEnum.values()){
			if(enu.text.equals(value))
				return enu;
		}
		return null;
	}	
}