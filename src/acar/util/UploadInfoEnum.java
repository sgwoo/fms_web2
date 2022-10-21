package acar.util;


/****
 * ���� ���ε� ����
 * @author Dev.ywkim
 * @since 2015. 05. 15
 *  1: 1MB, 0 : ������
 */
public enum UploadInfoEnum {
	FREE_TIME(						"upload_folder_01", "FREE_TIME"					,"5"),//�ް����
	BAD_COMPLAINT_REQ(				"upload_folder_02", "BAD_COMPLAINT_REQ"			,"2"),//�����������û
	BULLETIN(						"upload_folder_03", "BULLETIN"					,"0"),//�系�Խ���
	BBS(							"upload_folder_04", "BBS"						,"0"),//��������
	CARD_DOC(						"upload_folder_05", "CARD_DOC"					,"1"),//ī����ǥ���
	CAR_CHANGE(						"upload_folder_06", "CAR_CHANGE"				,"1"),//�ڵ�������
	FINE(							"upload_folder_07", "FINE"						,"1"),//���·�
	STAT_ACCT(						"upload_folder_08", "STAT_ACCT"					,"0"),
	TINT(							"upload_folder_09", "TINT"						,"2"),//��ǰor���
	USERS(							"upload_folder_10", "USERS"						,"1"),//��������
	YEAR_JUNGSAN(					"upload_folder_11", "YEAR_JUNGSAN"				,"2"), //�������� 
	ALLOT(							"upload_folder_12", "ALLOT"						,"2"),
	APPRSL(							"upload_folder_13", "APPRSL"					,"5"),//�������
	FINE_DOC(						"upload_folder_14", "FINE_DOC"					,"2"), //�ְ��߼۴���
	LC_SCAN(						"upload_folder_15", "LC_SCAN"					,"5"),//���⺻��ĵ����
	PIC_RESRENT_ACCID(				"upload_folder_16", "PIC_RESRENT_ACCID"			,"1"),//����������༭
	PAY(							"upload_folder_17", "PAY"						,"0"),//���
	STAT_CMP(						"upload_folder_18", "STAT_CMP"					,"2"),//��ź񿵼������
	CLS_ETC(						"upload_folder_19", "CLS_ETC"					,"2"),//�������깮������
	BANK_ACC(						"upload_folder_20", "BANK_ACC"					,"1"),
	PROP_BBS(						"upload_folder_21", "PROP_BBS"					,"2"),//������
	SUI_ETC(						"upload_folder_22", "SUI_ETC"					,"2"),
	ACTN_SCAN(						"upload_folder_23", "ACTN_SCAN"					,"2"),//������ĵ����
	KNOW_HOW(						"upload_folder_24", "KNOW_HOW"					,"2"), //�Ƹ���ī ����IN
	OVER_TIME(						"upload_folder_25", "OVER_TIME"					,"1"),//Ư�ٰ���
	SC_SCAN(						"upload_folder_26", "SC_SCAN"					,"1"),//�������
	CAR_OFF_EMP(					"upload_folder_27", "CAR_OFF_EMP"				,"1"),//�����������
	CONSIGNMENT(					"upload_folder_28", "CONSIGNMENT"				,"1"),//Ź�۵��
	LEND_BANK(						"upload_folder_29", "LEND_BANK"					,"5"),//����������
	PARTS_ORDER(					"upload_folder_30", "PARTS_ORDER"				,"1"),
	COMMI(							"upload_folder_31", "COMMI"						,"1"),//���޼��������
	COOPERATION(					"upload_folder_32", "COOPERATION"				,"2"), //��������
	PIC_ACCID(						"upload_folder_33", "PIC_ACCID"					,"3"),//���ó�������������
	SERVICE(						"upload_folder_34", "SERVICE"					,"0"),
	DOC_SETTLE(						"upload_folder_35", "DOC_SETTLE"				,"2"),
	OFF_DOC(						"upload_folder_36", "OFF_DOC"					,"5"),//�ڷ�Ǿ�������
    ESTI_SPE(						"upload_folder_37", "ESTI_SPE"                  ,"5"),//Ȩ������ ����Ʈ �������� ÷������
    CAR_COL(						"upload_folder_38", "CAR_COL"                   ,"1"),//������� �̹���
    INSUR(							"upload_folder_39", "INSUR"						,"0"),//���谡������
    RECALL(							"upload_folder_40", "RECALL"					,"5"),//���ݾȳ���(20190108)
	ACCIDENT(						"upload_folder_41", "ACCIDENT"					,"0"),//������(20190423)
	RECEIVE(						"upload_folder_42", "RECEIVE"					,"5");//ä�ǰ���(20191216)

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