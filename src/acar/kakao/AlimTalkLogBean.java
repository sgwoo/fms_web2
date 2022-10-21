package acar.kakao;

import java.text.SimpleDateFormat;
import java.util.Date;

public class AlimTalkLogBean {

    private int mt_pr;                  // number(11)	NN	PK	메시지 고유 아이디	ata_mmt_tran의 primary key,sequence로 unique한 값
    private String mt_refkey;           //	varchar2(20)	부서 코드 (참조용 필드)	payment code(부서별로 정산시 입력)
    private String priority;            //	char(2)	NN	'S'	메시지 우선 순위	사용안함
    private Date date_client_req;       // timestamp	NN	'1970-01-01 00:00:00'	전송 예약 시간
    private String subject;             // varchar2(40)	NN	' '	메시지 제목	공백 입력
    private String content;             //	varchar2(4000)	NN	전송 메시지	공백 포함 1000 자로 제한
    private String callback;            //	varchar2(25)	NN	발신자 전화 번호
    private String msg_status;          //	char(1)	NN	'1'	메시지 상태	1-전송대기, 2-결과대기, 3-완료
    private String recipient_num;       //	varchar2(25)	수신자 전화 번호
    private Date date_mt_sent;          //	timestamp	Biz talk G/W 접수 시간
    private Date date_rslt;             //	timestamp	단말기 도착 시간
    private Date date_mt_report;        //	timestamp	Biz talk 으로부터 결과 수신한 시간
    private String report_code	;         // char(4)	전송 결과	1000-성공, 기타-실패(결과코드 문서 참조)
    private String rs_id;               //	varchar2(20)	전송된 Biz talk G/W 정보
    private String country_code;        //	varchar2(8)	NN	'82'	국가 코드	사용안함
    private int msg_type;               //	number(11)	NN	'1008'	메시지 종류 	1008-카카오톡 알림톡, 1009-카카오톡 친구톡
    private String crypto_yn;           //	char(1)	'Y'	암호화 사용 유무
    private String ata_id;              //	char(2)	' ' 	ATA 이중화시 사용되는 ID	' ' 인경우: 이중화사용안함, ' ' 아닌경우: 이중화사용
    private Date reg_date;              //	timestamp	sysdate	데이터 등록일자
    private String sender_key;          //	varchar2(40)	NN	카카오톡 알림톡 발신 프로필 키
    private String template_code;       //	varchar2(30)	카카오톡 알림톡 메시지 유형 템플릿 코드
    private String response_method;     //	varchar2(20)	NN	카카오톡 알림톡 메시지 발송 방식	'push', 'realtime','polling'
    private String message_group_code;  //	varchar2(30)	카카오톡 메시지 유형 구분 값
    private String attachment_type;     //	varchar2(20)	카카오톡 메시지 첨부 타입	'button'(버튼타입이 자유설정일 경우)
    private String attachment_name;     // varchar2(100)	카카오톡 첨부 타입별 이름
    private String attachment_url;      //	varchar2(100)	카카오톡 첨부 타입별 링크 주소
    private String img_url;             //	varchar2(200)	친구톡 이미지 URL	카카오톡에 등록된 Image의 URL
    private String img_link;            //	varchar2(100)	친구톡 이미지 클릭시 이동할 URL	Image 클릭시 이동할 Page의 URL
    private String etc_text_1;          //	varchar2(100)	유저 기타필드	텍스트 필드
    private String etc_text_2;          //	varchar2(100)	유저 기타필드	텍스트 필드
    private String etc_text_3;          //	varchar2(100)	유저 기타필드	텍스트 필드
    private int etc_num_1;              //	number(11)	유저 기타필드	숫자 필드
    private int etc_num_2;              //	number(11)	유저 기타필드	숫자 필드
    private int etc_num_3;              //	number(11)	유저 기타필드	숫자 필드
    private Date etc_date_1;            //	timestamp	유저 기타필드	시간 필드

    private String userNm;            //	유저 이름(발송자1)
    private String userNm2;            //	유저 이름(발송자2)
    private String firmNm;            //	상호

    public int getMt_pr() {
        return mt_pr;
    }

    public void setMt_pr(int mt_pr) {
        this.mt_pr = mt_pr;
    }

    public String getMt_refkey() {
        return mt_refkey;
    }

    public void setMt_refkey(String mt_refkey) {
        this.mt_refkey = mt_refkey;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public Date getDate_client_req() {
        return date_client_req;
    }

    public String getDate_client_req_str() {
        return new SimpleDateFormat("yyyy.MM.dd").format(date_client_req);
    }

    public String getDate_client_req_str2() {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date_client_req);
    }

    public void setDate_client_req(Date date_client_req) {
        this.date_client_req = date_client_req;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCallback() {
        return callback;
    }

    public void setCallback(String callback) {
        this.callback = callback;
    }

    public String getMsg_status() {
        return msg_status;
    }

    public void setMsg_status(String msg_status) {
        this.msg_status = msg_status;
    }

    public String getRecipient_num() {
        return recipient_num;
    }

    public void setRecipient_num(String recipient_num) {
        this.recipient_num = recipient_num;
    }

    public Date getDate_mt_sent() {
        return date_mt_sent;
    }

    public void setDate_mt_sent(Date date_mt_sent) {
        this.date_mt_sent = date_mt_sent;
    }

    public Date getDate_rslt() {
        return date_rslt;
    }

    public void setDate_rslt(Date date_rslt) {
        this.date_rslt = date_rslt;
    }

    public Date getDate_mt_report() {
        return date_mt_report;
    }

    public void setDate_mt_report(Date date_mt_report) {
        this.date_mt_report = date_mt_report;
    }

    public String getReport_code() {
        return report_code;
    }

    public void setReport_code(String report_code) {
        this.report_code = report_code;
    }

    public String getRs_id() {
        return rs_id;
    }

    public void setRs_id(String rs_id) {
        this.rs_id = rs_id;
    }

    public String getCountry_code() {
        return country_code;
    }

    public void setCountry_code(String country_code) {
        this.country_code = country_code;
    }

    public int getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(int msg_type) {
        this.msg_type = msg_type;
    }

    public String getCrypto_yn() {
        return crypto_yn;
    }

    public void setCrypto_yn(String crypto_yn) {
        this.crypto_yn = crypto_yn;
    }

    public String getAta_id() {
        return ata_id;
    }

    public void setAta_id(String ata_id) {
        this.ata_id = ata_id;
    }

    public Date getReg_date() {
        return reg_date;
    }

    public void setReg_date(Date reg_date) {
        this.reg_date = reg_date;
    }

    public String getSender_key() {
        return sender_key;
    }

    public void setSender_key(String sender_key) {
        this.sender_key = sender_key;
    }

    public String getTemplate_code() {
        return template_code;
    }

    public void setTemplate_code(String template_code) {
        this.template_code = template_code;
    }

    public String getResponse_method() {
        return response_method;
    }

    public void setResponse_method(String response_method) {
        this.response_method = response_method;
    }

    public String getMessage_group_code() {
        return message_group_code;
    }

    public void setMessage_group_code(String message_group_code) {
        this.message_group_code = message_group_code;
    }

    public String getAttachment_type() {
        return attachment_type;
    }

    public void setAttachment_type(String attachment_type) {
        this.attachment_type = attachment_type;
    }

    public String getAttachment_name() {
        return attachment_name;
    }

    public void setAttachment_name(String attachment_name) {
        this.attachment_name = attachment_name;
    }

    public String getAttachment_url() {
        return attachment_url;
    }

    public void setAttachment_url(String attachment_url) {
        this.attachment_url = attachment_url;
    }

    public String getImg_url() {
        return img_url;
    }

    public void setImg_url(String img_url) {
        this.img_url = img_url;
    }

    public String getImg_link() {
        return img_link;
    }

    public void setImg_link(String img_link) {
        this.img_link = img_link;
    }

    public String getEtc_text_1() {
        return etc_text_1;
    }

    public void setEtc_text_1(String etc_text_1) {
        this.etc_text_1 = etc_text_1;
    }

    public String getEtc_text_2() {
        return etc_text_2;
    }

    public void setEtc_text_2(String etc_text_2) {
        this.etc_text_2 = etc_text_2;
    }

    public String getEtc_text_3() {
        return etc_text_3;
    }

    public void setEtc_text_3(String etc_text_3) {
        this.etc_text_3 = etc_text_3;
    }

    public int getEtc_num_1() {
        return etc_num_1;
    }

    public void setEtc_num_1(int etc_num_1) {
        this.etc_num_1 = etc_num_1;
    }

    public int getEtc_num_2() {
        return etc_num_2;
    }

    public void setEtc_num_2(int etc_num_2) {
        this.etc_num_2 = etc_num_2;
    }

    public int getEtc_num_3() {
        return etc_num_3;
    }

    public void setEtc_num_3(int etc_num_3) {
        this.etc_num_3 = etc_num_3;
    }

    public Date getEtc_date_1() {
        return etc_date_1;
    }

    public void setEtc_date_1(Date etc_date_1) {
        this.etc_date_1 = etc_date_1;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }
    
    public String getUserNm2() {
        return userNm2;
    }

    public void setUserNm2(String userNm2) {
        this.userNm2 = userNm2;
    }
    
     public String getFirmNm() {
        return firmNm;
    }

    public void setFirmNm(String firmNm) {
        this.firmNm = firmNm;
    }
    
}
