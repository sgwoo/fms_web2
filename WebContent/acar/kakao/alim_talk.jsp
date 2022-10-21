<%@ page contentType="text/html; charset=euc-kr" language="java" %>

<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.common.*, acar.cont.*, acar.ext.*, acar.car_mst.*" %>
<%@ page import="acar.kakao.*" %>

<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>

<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>


<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	

	// 로그인 정보
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}

	// 검색 구분
    String gubun1 	= request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");  //영업사원
    String gubun2 	= request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");  //영업사원 
    String gubun3 	= request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");    //영업사원 
    String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");		
    String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
    
    String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

    String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
    String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");

    // jjlim@20171101 add auto select
    String category_1 = request.getParameter("cate") == null ? "" : request.getParameter("cate");
    String category_2 = request.getParameter("cate1") == null ? "" : request.getParameter("cate1");
    String templateCode = request.getParameter("t_cd") == null ? "" : request.getParameter("t_cd");
    String rentMngId = request.getParameter("mng_id")==null? "":request.getParameter("mng_id");
    String rentLCode = request.getParameter("l_cd")==null? "":request.getParameter("l_cd");
    String rentSt = request.getParameter("rent_st")==null? "":request.getParameter("rent_st");

    String searchType  = request.getParameter("s_type") == null ? "" : request.getParameter("s_type");  // ??

	//test
	Hashtable fee_sum = af_db.getFeeScdDlySettleSum(rentMngId, rentLCode);
    int fee_all_sum = AddUtil.parseInt(String.valueOf(fee_sum.get("FEE_AMT")));
	
	//[계약별]대여료통계
	Hashtable fee_stat = af_db.getFeeScdStatPrint(rentMngId, rentLCode);
	int dly_tot_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT")));
	int dly_pay_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")));
	int total_amt 	= dly_tot_amt - dly_pay_amt;	
	int total_sum = fee_all_sum + total_amt;	

    //영업담당자 리스트
    Vector users = at_db.getUserList("", "", "EMP", "Y");
    int user_size = users.size();

	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();	
	Vector CodeList = FineDocDb.getZipSido();	
	Vector CodeList2 = FineDocDb.getZipGugun(gubun1);	
	
	// 대여차량 구매내역 조회 > 출고예정일자 조회
	ContPurBean pur = a_db.getContPur(rentMngId, rentLCode);
	String release_date = pur.getDlv_est_dt();
	if(release_date != null && !release_date.equals("")){
		release_date = AddUtil.getDate3(release_date) + " ("+AddUtil.getDateDay(release_date)+")";
	}
	
	int fee_size 	= af_db.getMaxRentSt(rentMngId, rentLCode);
	//마지막대여정보
	ContFeeBean max_fee = a_db.getContFeeNew(rentMngId, rentLCode, Integer.toString(fee_size));
	ContCarBean fee_etc = a_db.getContFeeEtc(rentMngId, rentLCode, Integer.toString(fee_size));
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rentMngId, rentLCode);
	
	//재리스 - 선수금 입금예정일
	if(templateCode.equals("acar0277")){
		//선수금입금예정일
		release_date = fee_etc.getCredit_sac_dt();
		if(release_date != null && !release_date.equals("")){
			release_date = AddUtil.getDate3(release_date) + " ("+AddUtil.getDateDay(release_date)+")";
		//차량인도예정일	
		}else{
			release_date = cont_etc.getCar_deli_est_dt();
			if(release_date != null && !release_date.equals("")){
				release_date = AddUtil.getDate3(release_date) + " ("+AddUtil.getDateDay(release_date)+")";
			}	
		}
	}
	
	// 선수금 조회
	// 보증금
	Vector grts = ae_db.getExtScd(rentMngId, rentLCode, "0");
	int grt_size = grts.size();
	int grt_amt = 0;		// 보증금 금액
	// 보증금 스케줄이 있고 입금되지 않은 금액. 입금일자가 없는.
	if(grt_size > 0){	
		for(int i=0; i<grt_size; i++){
			ExtScdBean grt = (ExtScdBean)grts.elementAt(i);
			if(grt.getExt_pay_dt().equals("")){
				grt_amt = grt.getExt_s_amt()+grt.getExt_v_amt();
			}
		}
	}
	//20220714 선수금스케줄이 아닌 계약약정금액
	grt_amt = max_fee.getGrt_amt_s();
	
	
	// 선납금
	Vector pps = ae_db.getExtScd(rentMngId, rentLCode, "1");
	int pp_size = pps.size();
	int pp_amt = 0;		// 선납금 금액
	// 선납금 스케출이 있고 입금되지 않은 금액. 입금일자가 없는.
	if(pp_size > 0){
		for(int i=0; i<pp_size; i++){
			ExtScdBean grt = (ExtScdBean)pps.elementAt(i);
			if(grt.getExt_pay_dt().equals("")){
				pp_amt = grt.getExt_s_amt()+grt.getExt_v_amt();
			}
		}
	}
	//20220714 선수금스케줄이 아닌 계약약정금액
	pp_amt = max_fee.getPp_s_amt()+max_fee.getPp_v_amt();
	
	// 개시대여료
	Vector ifees = ae_db.getExtScd(rentMngId, rentLCode, "2");
	int ifee_size = ifees.size();
	int ifee_amt = 0;		// 개시대여료 금액
	// 개시대여료 스케출이 있고 입금되지 않은 금액. 입금일자가 없는.
	if(pp_size > 0){
		for(int i=0; i<ifee_size; i++){
			ExtScdBean grt = (ExtScdBean)ifees.elementAt(i);
			if(grt.getExt_pay_dt().equals("")){
				ifee_amt = grt.getExt_s_amt()+grt.getExt_v_amt();
			}
		}
	}
	//20220714 선수금스케줄이 아닌 계약약정금액
	ifee_amt = max_fee.getIfee_s_amt()+max_fee.getIfee_v_amt();
	
	// 납부 은행 계좌 조회
	String content_code = "OFF_DOC";
	String content_seq  = "docs4";
	
 	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rentMngId, rentLCode);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	String carNm = cm_bean.getCar_nm();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">

    .table-style-1 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        color: #515150;
        font-weight: bold;
    }

    .table-back-1 {
        background-color: #B0BAEC
    }

    .font-1 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        font-weight: bold;
    }

    .font-2 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
    }

    .width-1 {
        width: 200px;
    }
    .width-2 {
        width: 250px;
    }
    .width-3 {
        width: 300px;
        padding: 2px;
        margin-bottom: 3px;
    }


    .message_body {
        width: 300px;
        height: 450px;
        background-color: #A0C0D7;
    }
    .message_bubble {
        width: 90%;
        height: 90%;
        margin: auto;
        border-radius: 3px;
        background-color: white;
    }
    .message_bubble_header {
        height: 50px;
        background-color: #FEE800;
        border-radius: 3px 3px 0px 0px;
    }
    .message_bubble_header_text {
        text-align: center;
        line-height: 50px;
    }
    .message_bubble_text_area {
        overflow-x: hidden;
        width: 90%;
        height: 80%;
        margin: 5%;
        resize: none;
        border: none;
    }
    .message_send_button {
        width: 300px;
        height: 30px;
        background-color: #FEE800;
        border: 0.5px solid grey;
        box-sizing: border-box;
    }
    #talk_content_1{
    	display: none;
    }
    #talk_content_2{
    	display: none;
    }
    #talk_content_3{
    	display: none;
    }
    #search-area{
    	display: none;
    }
</style>

<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
	

    function User(name, grade, phone) {
        this.name = name;
        this.grade = grade;
        this.phone = phone;
    }
    var mMultiUser = [];
    var mMultiSales = [];

    var fieldMap = {
        customer_name					: '고객명',
        customer_email					: '고객메일',
        customer_fax						: '고객 Fax 번호',

        car_num								: '차량 번호',
        p_car_num							: '차대번호',
        car_name								: '차량 이름',
        car_amount							: '차량 가격',
        rent_month								: '이용기간',
        
        car_num_name_arr				: '차량 번호',	// 경마장탁송차량안내용	2017.12.14
        car_num_name_arr_count	: '차량 이름',	// 경마장탁송차량안내용	2017.12.15

        company_branch		: '지점',
        company_phone		: '전화',
        zip_code					: '우편번호',
        company_addr			: '주소',

        manager_name			: '담당자 이름',
        manager_grade			: '담당자 직급',
        manager_phone		: '담당자 전화',
        
        bus_manager_name		: '담당자 이름(영업)',
        bus_manager_phone	: '담당자 전화(영업)',

        esti_send_way			: '견적서 발송',
        esti_link					: '견적서 링크',
        contract_no				: '계약 번호',
        contract_turn			: '계약 회차',
        contract_supp			: '계약 준비물',
        visit_place					: '방문 장소',
        visit_place_url			: '약도',
        return_place				: '반납 장소',
        car_e_date					: '차량 반납일 (년-월-일)',
        driver						: '운전자',
        driver2						: '추가운전자',

        dist							: '주행거리',
        dist_fee						: '주행거리 초과 비용',

        insurance_name		: '보험사 이름',
        insurance_phone		: '보험사 전화',
        insur_mng_name		: '보험사 담당자 이름',
        insur_mng_grade		: '보험사 담당자 직급',
        insur_mng_phone		: '보험사 담당자 전화',
        insur_info_url			: '보험정보 URL',

        fee_count					: '건 수 (차량대금결재)',
        rent_fee					: '월 대여료',
        rent_fee_all			: '대여료',
        unpaid					: '미납금',
        unpaid_interest			: '미납이자',
        tot_mnt					: '총 납입금',
        interest_rate			: '대여료 연체이율',
        
        pay_place					: '지출처',		// 출금 통보-지급 처리내역 2017.12.15
        pay_contents			: '지출내용',
        pay_amount				: '지출금액',
        
        payments_amount	: '지급금액',
        deduction_amount	: '공제금액',
        cost_amount			: '실지금액',

        rent_gubun				: '대여구분 예)장기대여계약/월렌트',
        gubun1						: '구분1',
        gubun2						: '구분2',
        month						: '개월',
        deposit_rate				: '보증금',
        distance					: '주행거리',

        bank_name				: '은행 이름',
        bank_account			: '은행 계좌',
        bank_full				: '은행 이름 및 은행 계좌',
        
        before_day				: '변경전 일',
        after_day					: '변경후 일',
        p_days						: '일간',
        dist_increase				: '주행거리 증가분',
        p_day_dist				: '1일 주행거리',
        p_year_dist				: '연환산 주행거리',

        date							: '날짜 (년-월-일)',
        date_ymd					: '날짜 (년 월 일)',
        update_date				: '변경일자',
        date_ymdhhmm		: '날짜 (년 월 일 시 분)',
        cur_date					: '현재 날짜 (년-월-일(요일))',
        cur_date_md			: '현재 날짜 (월/일)',
        cur_date_year			: '현재 날짜 (년)',
        cur_date_mon			: '현재 날짜 (월)',
        cur_date_day			: '현재 날짜 (일)',
        reg_date				: '현재 날짜 (년 월 일)',
        car_take_date_mn	: '인수 날짜 (월/일)',
        contract_s_date		: '계약 시작일 (년-월-일)',
        contract_e_date		: '계약 종료일 (년-월-일)',
        contract_s_date_mn	: '계약 시작일 (월/일)',
        contract_e_date_mn	: '계약 종료일 (월/일)',
        contract_date_mn		: '계약 출금일 (월/일)',
        expiration_date			: '유효 기한 (년 월 일 시)',
        last_date				: '확정 기한 (년 월 일 시)',

        sender_name			: '발신자',
        deliver_no					: '탁송번호',
        deliver_date				: '탁송 날짜 (월/일)',
        deliver_hour				: '탁송 날짜 (시간)',
        deliver_min				: '탁송 날짜 (분)',
        deliver_ymdhhmm		: '탁송 날짜 (년 월 일 시 분)',
        deliver_company		: '탁송 업체명',
        deliver_name			: '탁송 기사 이름',
        deliver_phone			: '탁송 기사 전화',
        un_count				: '미확인 건수',
        birth_gender			: '생년월일-한자리 숫자',
        
        supplies_name		: '용품 업체명',
        
        auction_name			: '경매장명',
        
        service_name			: '정비 업체명',
        service_amount		: '정비 금액',
        service_gubun			: '정비구분',
        service_contents		: '정비 내용',
        speed_mate_url		: '스피드메이트 URL',
        any_car_url				: '애니카랜드 URL',
        mater_car_phone		: '마스터자동차관리',
        sk_net_phone			: 'SK네트웍스',
        
        URL						: '대여료 스케줄표 URL',
        
        car_mng_service_url	: '자동차관리서비스 안내문',
        
        blumembers_link		: '블루멤버스 안내문',
        
        sos_url					: '긴급출동서비스 안내',
        accident_url			: '사고처리서비스 안내',
        maint_url				: '자동차정비 안내',
        
        release_date			: '출고예정일자',
        delivery_date			: '납품예정일자',
        gubun					: '보증금',
        pay_price				: '선납금/개시대여료',
        price_tot				: '합계',
        payprice_date			: '납부기한',
        Click					: '납부 은행 계좌'
        
    }

   
    var gUserId = '<%= user_id %>';

    var gContent = '';
    var gContractList = [];
    var gContractInfo = {};

    var gUserList = [];

    var gSalesList = [];


    // jjlim@20171101 add auto select
    var templateCode = '<%= templateCode %>';
    var cate = '<%= category_1 %>';
    var cate2 = '<%= category_2 %>';
    var rentMsgId = '<%= rentMngId %>';     
    var rentLCode = '<%= rentLCode %>';
    var rentSt = '<%= rentSt %>';
    
    //대여료 관련
    <%-- var fee_all_sum = '<%=Util.parseDecimal(fee_all_sum)%>';
    var total_amt = '<%=Util.parseDecimal(total_amt)%>';
    var total_sum = '<%=Util.parseDecimal(total_sum)%>'; --%>
    var fee_all_sum = '<%=fee_all_sum%>';
    var total_amt = '<%=total_amt%>';
    var total_sum = '<%=total_sum%>';
    var release_date = '<%=release_date%>'
    // 선수(보증)금 납부 안내문 관련.
    var dlv_est_dt = '<%=release_date%>';
    var gubun = '<%=Util.parseDecimal(grt_amt)%>원';
    var pay_price = '<%=Util.parseDecimal(pp_amt+ifee_amt)%>원';
    var price_tot = '<%=Util.parseDecimal(grt_amt+pp_amt+ifee_amt)%>원';

    function load() {
        // 구글 SHORT URL
        gapi.client.setApiKey('AIzaSyDTLDbQYFNKRuHhdqjLnz3WwUCvqpEyWMM');
        gapi.client.load('urlshortener', 'v1', function () {
        });
    }
    
$(document).ready(function(){
       	
  	//$('#select-category').hide();
  	$('#select-category').empty();
    var html =
        /* '<option value="0" selected>카테고리선택</option>'+ */
        '<option value="1" selected>장기대여</option>'+
        '<option value="2" selected>월렌트</option>'+
        '<option value="3" selected>협력업체</option>';
    $('#select-category').append(html);
	
    //$('#select-category').val("1");
    if (templateCode == "") {
    	//ajaxGetTemplateList("1", "1");
    	$('#select-first-category').val("0");
    	$('#select-category').val("1");
    } else {    	
    	$('#select-first-category').val("0");
    	$('#select-category').show();
    	$('#select-category').val("1");
    	//ajaxGetTemplateList(cate, cate2);
    }
    //ajaxGetTemplateList("1", "1");
	
	// 템플릿 카테고리 선택시 : 템플릿 리스트 가져옴
    $('#select-first-category').bind('change', function() {

        var option = $(this).find('option:selected');        
        if (option.val() == '0') {
        	
        	$('#select-category').empty();
            var html =
                '<option value="0" selected>카테고리선택</option>';
            $('#select-category').append(html);
        	
            $('#select-category').val("0");        	
        	$('#select-category').hide();
        	$('#template-select').show();
        	
        } else if (option.val() == '1') {
        	
        	$('#select-category').empty();
            var html =
                /* '<option value="0" selected>카테고리선택</option>'+ */
                '<option value="1" selected>장기대여</option>'+
                '<option value="2" selected>월렌트</option>'+
                '<option value="3" selected>협력업체</option>';
            $('#select-category').append(html);
            
        	$('#select-category').val("1");
        	$('#select-category').show();
        	$('#template-select').show();
            
        } else if (option.val() == '2') {
        	
        	$('#select-category').empty();
            var html =
                /* '<option value="0" selected>카테고리선택</option>'+ */
                '<option value="5" selected>대여개시</option>'+
                '<option value="6" selected>예약/예약취소</option>'+
                '<option value="7" selected>해지/종료</option>'+
                '<option value="8" selected>보험/정비/정기검사</option>'+
                '<option value="9" selected>탁송</option>'+
                '<option value="10" selected>협력업체</option>';
            $('#select-category').append(html);
            
        	$('#select-category').val("5");
        	$('#select-category').show();
        	$('#template-select').show();
        	
        } else {
        	
        	$('#select-category').empty();
            var html =
                '<option value="0" selected>카테고리선택</option>';
            $('#select-category').append(html);
        	
        	$('#select-category').val("0");
        	$('#select-category').hide();
        	$('#template-select').hide();
        }

        // 직접입력
        if (option.val() == '10') {
			
        	$('#select-category').val("0");
        	$('#template-select').val("0");
        	
        	$("#talk_content_1").show();
        	$("#talk_content_2").show();
        	$("#talk_content_3").show();
        	
            // 발신/수신 초기화
            $('#org-name').show();
            $('#spe-org-name').empty().hide();
            $('#recipient_num').val('').show();
            $('#spe-recipient-name').empty().hide();
            $('#spe-recipient-direct').hide();
            $('#spe-recipient-cnt').hide();

            mMultiUser.length = 0;
            mMultiSales.length = 0;

            // 검색 영역 초기화
            clearSearch();

            $('#template-select').empty();
            $('#template-select').append('<option value="0" selected>템플릿 선택</option>');

            gContent = '';

            $('#alim-textarea').hide();
            $('#alim-textarea-w').show();
            $('#alim-textarea-w').val('');

            $('#template-field-area').empty();
            $('#template-field-area-outter').hide();
            $('#message-length').html('0');

       //     $('#search-area').hide();
            $('#search-area').show();
        }
        // 템플릿 입력
        else {
            ajaxGetTemplateList($(this).val(), $('#select-category').val());
        }
    });
    // $('#select-category').trigger('change');

    // 템플릿 카테고리 선택시 : 템플릿 리스트 가져옴
    $('#select-category').bind('change', function() {

        var option = $(this).find('option:selected');

        // 직접입력
        /* if (option.val() == '99') {

            // 발신/수신 초기화
            $('#org-name').show();
            $('#spe-org-name').empty().hide();
            $('#recipient_num').val('').show();
            $('#spe-recipient-name').empty().hide();
            $('#spe-recipient-direct').hide();
            $('#spe-recipient-cnt').hide();

            mMultiUser.length = 0;
            mMultiSales.length = 0;

            // 검색 영역 초기화
            clearSearch();

            $('#template-select').empty();
            $('#template-select').append('<option value="0" selected>템플릿 선택</option>');

            gContent = '';

            $('#alim-textarea').hide();
            $('#alim-textarea-w').show();
            $('#alim-textarea-w').val('');

            $('#template-field-area').empty();
            $('#template-field-area-outter').hide();
            $('#message-length').html('0');

       //     $('#search-area').hide();
            $('#search-area').show();
        }
        // 템플릿 입력
        else {
            ajaxGetTemplateList($('#select-first-category').val(), $(this).val());
        } */
        ajaxGetTemplateList($('#select-first-category').val(), $(this).val());
    });
    $('#select-category').trigger('change');

    // 템플릿 선택
    $('#template-select').bind('change', function() {
        var option = $(this).find('option:selected');
        
        if (option.val() == '0') {
        	$("#talk_content_1").hide();
        	$("#talk_content_2").hide();
        	$("#talk_content_3").hide();
        } else if ($('#select-first-category').val() == '10') {
        	$("#talk_content_1").show();
        	$("#talk_content_2").show();
        	$("#talk_content_3").show();
        } else {
        	$("#talk_content_1").show();
        	$("#talk_content_2").show();
        	$("#talk_content_3").show();
        }

        // 발신/수신 초기화
        $('#org-name').show();
        $('#spe-org-name').empty().hide();
//        $('#org-phone').val('');
        $('#recipient_num').val('').show();
        $('#spe-recipient-name').empty().hide();
        $('#spe-recipient-direct').hide();
        $('#spe-recipient-cnt').hide();

        mMultiUser.length = 0;
        mMultiSales.length = 0;

        // 검색 영역 초기화
        clearSearch();

        // acar9999 : 직접입력 (친구톡)
        // 사용 안함
        if (option.val() == 'acar9999') {

            gContent = '';

            $('#alim-textarea').hide();
            $('#alim-textarea-w').show();
            $('#alim-textarea-w').val('');

            $('#template-field-area').empty();
            $('#template-field-area-outter').hide();
            $('#message-length').html('0');

            $('#search-area').hide();
//            $('#contract-search-area').hide();

        }
        else {

            $('#alim-textarea').show();
            $('#alim-textarea-w').hide();

            $('#template-field-area-outter').show();

            // 선택시 무조건 보이도록 우선 수정
            if (option.val() == '0') {
                $('#search-area').hide();
//                $('#contract-search-area').hide();
            }
            else {
                $('#search-area').show();
//                $('#contract-search-area').show();
            }

//            // 특정 템플릿에서만 계약 검색 화면 보이도록
//            if (option.val() == 'acar0037') {
//                $('#contract-search-area').show();
//            }
//            else {
//                $('#contract-search-area').hide();
//            }

            // r, n 변경
//            var newLine = String.fromCharCode(13, 10);
//            var text = option.data('content').replace(/\\n/g, newLine);
            var text = option.data('content');

            // 글로벌로 저장
            gContent = text;

            if (text != undefined) {
                var newLine = String.fromCharCode(13, 10);
                text = text.replace(/\\n/g, newLine);

                // 글로벌로 저장
                gContent = text;

                // 템플릿 필드 추가
                addTemplateField(text);

                // 선택된 템플릿 데이터를 텍스트필드에 넣음
                reloadTemplateContent();
            }



//        $('#alim-textarea').val(text);

            $('#org-name').val(gUserId).change();

            // jjlim add auto select
            // 자동 선택 기능: 검색영역 숨기고, 계약검색
            if (rentMsgId != '' && rentLCode != '') {
                $('#select-first-category').prop('disabled', true);
                /* $("#select-first-category option:eq(0)").before("<option value='0'>전체</option>");
                $("#select-first-category").val("0"); */
                //$('#select-category').hide();
                $('#select-category').prop('disabled', true);
                $('#template-select').prop('disabled', true);
                $('#search-area').hide();
                ajaxGetContractInfo(rentMsgId, rentLCode);

                // 검색완료 후 초기화
                //rentLCode = '';
                //rentMsgId = '';
            }


        }
    });

    function ajaxGetTemplateList(category_1, category) {
        var data = {
            cat_1: category_1,
            cat: category,
        };
        $.ajax({
            cache: false,
            type: 'GET',
            url: './alim_template_ajax.jsp',
            dataType: 'json',
            data: {
                cmd: 'list_only',
                data: JSON.stringify(data)
            },
            success: function(data) {
                setTemplateList(category, data);

                // jjlim@20171101 add auto select
                // 파라미터로 템플릿 코드가 오면 자동 선택 (한번만)
                if (templateCode != '') {
                    $('#select-first-category').val("0");                    
                    $('#select-category').val(cate2);
                    $('#template-select').val(templateCode);

                    templateCode = '';

                    // 파라미터로 L_CD가 오면 자동 검색 (한번만)
                    if (rentLCode != '') {
                        $('#contract-search-area select[name=s_kd]').val(2);
                        $('#contract-search-area input[name=t_wd]').val(rentLCode);
                        $('#search-cont-button').trigger('click');

//                        rentLCode = '';   // 검색완료 후 선택한다음 초기화
                    }

                }

                $('#template-select').trigger('change');
            },
            error: function(e) {
                alert('템플릿 리스트를 가져오지 못했습니다');
            }
        });
    }

    function setTemplateList(cat, data) {
        $('#template-select').empty();
        /* $('#template-select').append('<option value="0" selected>템플릿 선택</option>'); */
        data.forEach(function(tpl) {
            html =
                '<option value="'+ tpl.CODE +'" ' +
                'data-content="'+ tpl.CONTENT +'" '+
                '>'+ tpl.NAME +' ('+tpl.CODE+')'+'</option>';
            $('#template-select').append(html);
        });

//        if (cat == 0) {
//            $('#template-select').append('<option value="acar9999">직접 입력</option>');
//        }
    }

        // 발신자 변경
    $('#org-name').bind('change', function() {
        var selOpt = $(this).find(':selected');
//        alert(selOpt.attr('data-phone'));

//        // 발신번호 변경
//        $('#org-phone').val(selOpt.attr('data-phone'));

        // 템플릿 필드 변경
        $('#manager_name').val(selOpt.attr('data-name'));
        $('#manager_grade').val(selOpt.attr('data-grade'));
        $('#manager_phone').val(selOpt.attr('data-phone'));

        $('#company_branch').val(selOpt.attr('data-br-nm'));
        $('#company_addr').val(selOpt.attr('data-br-addr'));
        $('#company_phone').val(selOpt.attr('data-br-tel'));

//        gUsers.forEach(function(value, index) {
//            if (value.USER_ID == selOpt.val()) {
//                alert('OK!');
//            }
//        });

        reloadTemplateContent();
    });

    // 보내기 버튼 클릭
    $('#send-button').bind('click', function() {

        if ($('#template-select option:selected').val() == '') {
            alert('템플릿을 선택해주세요');
            return;
        }
//        if ($('#org-phone').val() == '') {
//            alert('발신번호를 입력해주세요');
//            return;
//        }

        if ($('#org-name option:selected').attr('data-phone') == '' && $('#spe-org-name option:selected').attr('data-phone') == '') {
            alert('발신번호가 없습니다');
            return;
        }
        if ($('#recipient_num').val() == '' && $('#spe-recipient-name').css('display') == 'none') {
            alert('수신번호를 입력해주세요');
            return;
        }
        if ($('#alim-textarea-w').css('display') != 'none' &&  $('#alim-textarea-w').val() == '') {
            alert('메시지를 입력해주세요');
            return;
        }


        var exitFlag = false;
        var fields = $('#template-field-area input')
        $.each(fields, function(index, value) {
            var val = $(value).val();
            if (val == '') {
                alert('템플릿 필드를 입력해주세요');
                exitFlag = true;
                return false;
            }
        });
        if (exitFlag == true) {
            return;
        }

        // 멀티 전송
        var multiFlag = false;
        var type = $('input[name=search-type]:checked');
        if ((type.val() == 'user' && mMultiUser.length > 1) || (type.val() == 'sales' && mMultiSales.length > 1)) {
            var result = confirm('여러명에게 전송하시겠습니까?');
            if (result == false) {
                return;
            }
            multiFlag = true;
        }

        // 태그 삭제 (br은 CR처리)
        var content = $('#alim-textarea').html();
        var newLine = String.fromCharCode(13, 10);
        content = content.replace(/<br>/g, newLine);

        // 멀티 전송 (customer_name) 필드는 변환하지 안는다 -> 나중에 서버에서
        if (multiFlag) {
            content = content.replace(/<span id="0".*<\/span>/, '{customer_name}');
        }
        content = content.replace(/<[^>]*>/g, '');

        var userId = '';
        var callbackNum = '';
        if ($('#org-name').css('display') != 'none') {
            userId = $('#org-name option:selected').attr('value');
            callbackNum = $('#org-name option:selected').attr('data-phone');
        }
        else {
            userId = $('#spe-org-name option:selected').attr('val');
            callbackNum = $('#spe-org-name option:selected').attr('data-phone');
        }

        var recipentNum = '';
        if ($('#spe-recipient-name').css('display') == 'none') {
            recipentNum = $('#recipient_num').val();
        }
        else {
            recipentNum = $('#spe-recipient-name option:selected').attr('data-phone');
        }

        // 알림톡: 1008, 친구톡(직접입력): 1009
        var msgType = '1008';
        if ($('#select-first-category option:selected').val() == '10') {
            msgType = '1009';
            content = $('#alim-textarea-w').val();
        }

		//리워드콜은 친구톡으로  
		 if ($('#template-select option:selected').val() == 'acar0055' || $('#template-select option:selected').val() == 'acar0069' || $('#template-select option:selected').val() == 'acar0209') {
		     msgType = '1009';
		 }
		
        var sendData = {
            'template_code': $('#template-select option:selected').val(),
            'content': encodeURIComponent(content),
            'callback_num': callbackNum,
            'recipient_num': recipentNum,
            'msg_type': msgType,
            'l_cd': rentLCode,          // jjlim@20171107
            'user_id': userId          // jjlim@20171107
        }

        if (multiFlag) {
            var users = []
            if (type.val() == 'user') {
                users = mMultiUser;
            }
            else if (type.val() == 'sales') {
                users = mMultiSales;
            }

//            var multiName = [];
//            var multiNum = [];
            var multi = [];
            users.forEach(function(value, index, array) {
                var multiObj = {
                    name: encodeURIComponent(value.name),
                    num: value.phone
                };
                multi.push(multiObj);
//                multiName.push(value.name);
//                multiNum.push(value.phone);
            });

            sendData['multi'] = multi;
//            sendData['multi_name'] = multiName;
//            sendData['multi_num'] = multiNum;
        }

//            // TODO CHECK 보내기 파라미터
//        alert("template_code: " + sendData.template_code + " callback: " + sendData.callback_num + " recipient: " + sendData.recipient_num + " msg_type: " + sendData.msg_type);
//        return;


        $.ajax({
            cache: false,
            type: 'POST',
            url: './alim_talk_ajax.jsp',
            dataType: 'json',
            data: {
//                data: sendData
                cmd: 'send_msg',
                data: JSON.stringify(sendData)
            },
            success: function(data) {
                alert('메시지를 전송했습니다');
            },
            error: function(e) {
                alert('메시지 전송에 실패했습니다');
            }
        })
    });

    // 계약검색 버튼 클릭
    $('#search-cont-button').bind('click', function() {

       var data = {
           s_kd: $('#contract-search-area select[name=s_kd] option:selected').val(),
           t_wd: encodeURIComponent($('#contract-search-area input[name=t_wd]').val()),
           andor: '',
           gubun4: $('#contract-search-area select[name=gubun4] option:selected').val(),
           gubun5: $('#contract-search-area select[name=gubun5] option:selected').val(),
           st_dt: $('#contract-search-area input[name=st_dt]').val(),
           end_dt: $('#contract-search-area input[name=end_dt]').val(),
       }

//        if (data.t_wd == '' && data.gubun1 == '' && data.gubun3 == '') {
//            if (data.gubun5 == '6' && ( data.st_dt == '' || data.end_dt == '' )) {
//                alert('기간을 입력하십시오.');
//                return;
//            }
//        }

        // 계약검색 파라미터
//        alert(JSON.stringify(data));

        $.ajax({
            type: 'POST',
            url: './alim_talk_ajax.jsp',
            dataType: 'json',
            data: {
                cmd: 'search_cont',
                data: JSON.stringify(data)
            },
            beforeSend: function() {
              $('#contract-search-loader').show();
            },
            success: function(data) {
                $('#contract-search-loader').hide();
                gContractList = data;

                makeContractTable(data);

            },
            error: function(e) {
                $('#contract-search-loader').hide();
                alert('검색 실패');
            }
        })

    });

    // 유저 검색 버튼 클릭
    $('#search-user-button').bind('click', function() {
        var cond = {
            s_kd: $('#user-search-area select[name=s_kd] option:selected').val()
        }
        ajaxSearchUser(cond);
    });

    // 영업사원 검색 버튼 클릭
    $('#search-sales-button').bind('click', function() {

        var a1 = $('#sales-search-area select[name=gubun] option:selected').val();
        var a2 = $('#sales-search-area select[name=cng_rsn] option:selected').val();
        if (a1 == '' && a2 == '') {
            var a3 = $('#sales-search-area select[name=gubun1] option:selected').val();
            var a4 = $('#sales-search-area select[name=gubun2] option:selected').val();
            var a5 = $('#sales-search-area select[name=gubun3] option:selected').val();

            if (a3 == '' || a4 == '' || a5 == '') {
                alert('소속사, 근무지역을 선택해주세요');
                return;
            }
        }

        var data = {
//            s_kd: $('select[name=s_kd] option:selected').val(),
//            t_wd: $('input[name=t_wd]').val(),
//            andor: '',

            gubun3: $('#sales-search-area select[name=gubun3] option:selected').val(),
            gubun1: encodeURIComponent($('#sales-search-area select[name=gubun1] option:selected').val()),
            gubun2: encodeURIComponent($('#sales-search-area select[name=gubun2] option:selected').val()),
            gubun: $('#sales-search-area select[name=gubun] option:selected').val(),
            gu_nm: encodeURIComponent($('#sales-search-area input[name=gu_nm]').val()),
            cng_rsn: $('#sales-search-area select[name=cng_rsn] option:selected').val(),
            st_dt: $('#sales-search-area input[name=st_dt]').val(),
            end_dt: $('#sales-search-area input[name=end_dt]').val()
        }

        // 계약검색 파라미터
//        alert(JSON.stringify(data));

        $.ajax({
            cache: false,
            type: 'POST',
            url: './alim_talk_ajax.jsp',
            dataType: 'json',
            data: {
                cmd: 'search_commi',
                data: JSON.stringify(data)
            },
            beforeSend: function() {
                $('#sales-search-loader').show();
            },
            success: function(data) {
                $('#sales-search-loader').hide();
                gSalesList = data;
                makeSalesTable(data);

//                gContractList = data;
//
//                makeContractTable(data);

            },
            error: function(e) {
                $('#sales-search-loader').hide();
                alert('검색 실패');
            }
        })

    });

        // 직접입력시 메시지 길이 체크
    $('#alim-textarea-w').bind('keyup', function() {
        $('#message-length').html($('#alim-textarea-w').val().length);
    });


    // 카카오 알림톡 템플릿 관리
    $('#manage-template').bind('click', function() {
        var SUBWIN="/acar/kakao/alim_template.jsp";
        window.open(SUBWIN, "MngKakaoAlimTemplate", "left=10, top=10, width=950, height=850, scrollbars=yes");
    });

    // 수신자 직접입력 체크시
    $('#spe-recipient-direct input[type=checkbox]').bind('change', function() {
        if ($(this).is(':checked')) {

            $('#recipient_num').show();
            $('#spe-recipient-name').hide();

        }
        else {

            $('#recipient_num').hide();
            $('#spe-recipient-name').show();
        }
    });


    // 검색 타입 선택
    $('input[name=search-type]').bind('change', function() {

        // 수신자 초기화
        $('#recipient_num').val('').show();
        $('#spe-recipient-name').empty().hide();
        $('#spe-recipient-direct').hide();
        $('#spe-recipient-cnt').hide();

        switch ($(this).val()) {
            case 'client':
                $('#contract-search-area').show();
                $('#user-search-area').hide();
                $('#sales-search-area').hide();
                clearSearchUser();
                clearSearchSales()
                break;
            case 'user':
                $('#contract-search-area').hide();
                $('#user-search-area').show();
                $('#sales-search-area').hide();
                clearSearchClient();
                clearSearchSales();
                break;
            case 'sales':
                $('#contract-search-area').hide();
                $('#user-search-area').hide();
                $('#sales-search-area').show();
                clearSearchClient();
                clearSearchUser();
                break;
        }
    });
//    $('input[name=search-type][value=client]').prop('checked', true);

})


    // 필드 추가
function addTemplateField(text) {

    $('#template-field-area').empty();

    // 정규식으로 필드 찾음
    var reg = /\#\{.*?\}/g;

    var matchs = text.match(reg);
    if (matchs == null) {
        return;
    }
    var templateFields = matchs.map(function(val) {
        return val.slice(2, -1);
    });

    // 중복 제거
    templateFields = templateFields.filter(function(item, pos) {
       return templateFields.indexOf(item) == pos;
    });

    // 필드 추가
    templateFields.forEach(function(val) {

        var html =
            '<div class="font-2" style="margin-top: 5px">' +
                '- ' + fieldMap[val] +
                '<div><input class="width-3" id="' + val + '" type="text"></div>' +
            '</div>';
        $('#template-field-area').append(html);
    });

    $('#template-field-area input').bind('change', function() {
            reloadTemplateContent();
    });

    // 필드별 기능
    addSpecificField();
}

// 필드별 기능
function addSpecificField() {
    var fields = $('#template-field-area input')
    $.each(fields, function(index, value) {

        var date = new Date();
        var week = new Array("일", "월", "화", "수", "목", "금", "토");
        var cur_year = date.getFullYear();
        var cur_month = date.getMonth() + 1;
        if (Number(cur_month) < 10) {
        	cur_month = "0"+cur_month;
        }
        var cur_day = date.getDate();
        if (Number(cur_day) < 10) {
        	cur_day = "0"+cur_day;
        }
		/*
        if (value.id == 'date') {
            $(value).val(cur_year + " " + cur_month + " " + cur_day + "");
        }
        else if (value.id == 'date_ymd') {
            $(value).val(cur_year + "년 " + cur_month + "월 " + cur_day + "일 ");
        }
        */
        if (value.id == 'last_date') {
            $(value).val(cur_year + "년 " + cur_month + "월 " + cur_day + "일");
        }        
        if (value.id == 'reg_date') {
            $(value).val(cur_year + "년 " + cur_month + "월 " + cur_day + "일");
        }        
        if (value.id == 'date_ymd') {
            $(value).val(cur_year + "년 " + cur_month + "월 " + cur_day + "일");
        }        
        if (value.id == 'update_date') {
            $(value).val(cur_year + "년 " + cur_month + "월 " + cur_day + "일");
        }
        if (value.id == 'cur_date_md') {
            $(value).val(cur_month + "/" + cur_day + "");
        }
        else if (value.id == 'cur_date_year') {
            $(value).val(cur_year + "");
        }
        else if (value.id == 'cur_date_mon') {
            $(value).val(cur_month + "");
        }
        else if (value.id == 'cur_date_day') {
            $(value).val(cur_day + "");
        }
        else if (value.id == 'cur_date') {
			var fullDate = cur_year + "-" + cur_month + "-" + cur_day + "("+ week[date.getDay()] +")";
        	$(value).val(fullDate);
        }
        else if (value.id == 'rent_fee_all') {
        	$(value).val(fee_all_sum);
        }
        else if (value.id == 'interest_rate') {
        	$(value).val('24%');
        }
        else if (value.id == 'unpaid_interest') {
        	$(value).val(total_amt);
        }
        else if (value.id == 'tot_mnt') {
        	$(value).val(total_sum);
        }
        else if (value.id == 'car_e_date') {
        	$(value).val(cur_year + "-" + cur_month + "-" + cur_day);
        }
        // 방문장소
        else if (value.id == 'visit_place') {
            var area = $(value).parent();
            area.empty();

            var html =
                '<select id="visit_place" class="width-3">' +
                    '<option value="" disabled selected>선택</option>' +
           <!--         '<option value="1" data-place="서울시 양천구 목동 914-5 한마음 공영 주차장(서문출입구 직전 20m)\nTEL: 02-6263-6378" data-url="http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg">서울시 양천구</option>' + -->
                    '<option value="2" data-place="서울시 영등포구 영등포로 34길 9 영등포 영남주차장\nTEL: 02-6263-6378" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg">서울시 영등포구</option>' +
                    '<option value="3" data-place="부산시 연제구 반송로 69 부산지점 하이트빌딩 3층\nTEL: 051-851-0606" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg">부산시 연제구 반송로</option>' +
                    '<option value="4" data-place="부산시 연제구 거제천로 230번길 70 지하1층 (연산동,웰메이드오피스텔)웰메이드주차장\nTEL: 051-851-0606" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg">부산시 연제구 거제천로</option>' +
                    <!--   '<option value="5" data-place="대전시 대덕구 신탄진로 319 금호자동차공업사 2층\nTEL: 042-824-1770" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg">대전시 대덕구 신탄진로</option>' + -->
                    '<option value="6" data-place="대전시 대덕구 벚꽃길 100 (주)현대카독크 2층\nTEL: 042-824-1770" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg">대전시 대덕구 벚꽃길</option>' +
                    '<option value="7" data-place="대구시 달서구 달서대로109길 58 (주)성서현대정비센터\nTEL: 053-582-2998" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg">대구시 달서구</option>' +
                    '<option value="8" data-place="광주시 서구 상무누리로 131-1 상무1급자동차공업사\nTEL: 062-385-0133" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg">광주시 서구</option>' +
                '</select>'
            area.append(html);

            $('#visit_place').bind('change', function() {
                reloadTemplateContent();
            });
        }
        // 계약방문시 준비물
        else if (value.id == 'contract_supp') {
            var area = $(value).parent();
            area.empty();

            var html =
                '<select id="contract_supp" class="width-3">' +
                '<option value="" disabled selected>선택</option>' +
                '<option value="본인명의 신용카드(체크카드 불가), 운전면허증">일반개인/본인방문/본인만 운전</option>' +
                '<option value="본인명의 신용카드(체크카드 불가), 운전면허증, 추가운전자(배우자) 면허증 사본, 가족관계 증명서류">일반개인/본인방문/추가운전자(배우자) 있는경우</option>' +
                '<option value="" disabled>---</option>' +
                '<option value="본인명의 신용카드(체크카드 불가), 운전면허증, 사업자 사본">개인사업자/본인방문/본인만 운전</option>' +
                '<option value="본인명의 신용카드(체크카드 불가), 운전면허증, 사업자 사본, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">개인사업자/본인방문/추가운전자 있는경우</option>' +
                '<option value="개인사업자 명의 신용카드(체크카드는 불가), 계약자(개인사업자) 운전면허증 사본, 사업자 사본, 운전자 [건강보험 자격확인서], 운전자 면허증">개인사업자/직원방문/계약자 운전자 여부 상관없이</option>' +
                '<option value="" disabled>---</option>' +
                '<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 대표자 개인카드 [체크카드 불가], 대표이사 운전면허증, 사업자 사본">법인/대표자방문/본인만 운전</option>' +
                '<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 대표자 개인카드 [체크카드 불가], 대표이사 운전면허증, 사업자 사본, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">법인/대표자방문/추가운전자 있는경우</option>' +
                '<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 법인 임직원 개인카드 [체크카드 불가], 사업자 사본, 방문자 [건강보험 자격확인서], 방문자 운전면허증">법인/직원방문/방문자만 운전</option>' +
                '<option value="기명식 법인카드(카드에 이용자 개인 이름이 찍혀있는 법인카드) 또는 법인 임직원 개인카드 [체크카드 불가], 사업자 사본, 방문자 [건강보험 자격확인서], 방문자 운전면허증, 추가운전자 [건강보험 자격확인서], 추가운전자 면허증사본">법인/직원방문/추가운전자 있는경우</option>' +
                '</select>'
            area.append(html);

            $('#contract_supp').bind('change', function() {
                reloadTemplateContent();
            });
        }

//        if (value.id == 'manager_name') {
//            var html =
//                '<input type="checkbox">발신자와 동일';
//
//            $(value).after(html);
//            $(value).next().bind('change', function() {
//               if (this.checked) {
//                   var name = $('#org-name option:selected').html();
//                   $('#manager_name').val(name);
//
//                   reloadTemplateContent();
//               }
//            });
//
//        }


		// 경매장탁송차량안내 전용 차량 번호, 차량 이름 여러대 넣기		2017.12.15
		else if (value.id == 'car_num_name_arr') {
            var area = $(value).parent();
            var area2 = $(value).parent().parent().next().children().first();
            area.empty();
            area2.empty();
			var html = '<input type="hidden" id="car_num_name_arr" style="width:100px;">'+
								'<input type="text" name="car_num_arr" id="car_num_arr" style="width:300px;">';	 
            area.append(html);
            
            var html2 = '<input type="hidden" id="car_num_name_arr_count" style="width:100px;">'+
            					'<input type="text" name="car_name_arr" id="car_name_arr" style="width:300px;"><input type="button" value="+" onclick="addRow()">';
            area2.append(html2);

            $('#car_num_name_arr').bind('change', function() {
                reloadTemplateContent();
            });
            $('#car_num_name_arr_count').bind('change', function() {
                reloadTemplateContent();
            });
        }
        
        // 마스타자동차관리 전화번호 default 설정		2017.12.15
		else if(value.id == 'mater_car_phone'){
			//$(value).val("마스타자동차관리(1588-6688)");
			$(value).val("1588-6688");
		}
		else if (value.id == 'sk_net_phone') {
			$(value).val("1670-5494");
		}
		
		// 선수(보증)금 납부안내문 변수 추가 2021.07.16.
		else if(value.id == 'release_date'){
			$(value).val(release_date);
		}
		else if(value.id == 'delivery_date'){
			$(value).val(release_date);
		}
		else if(value.id == 'gubun'){
			$(value).val(gubun);
			/* 선수금선택에서 보증금금액으로 변경됨
			var area = $(value).parent();
            area.empty();

            var html =
                '<select id="gubun" class="width-3">' +
                '<option value="" disabled selected>선택</option>' +
                '<option value="보증금">보증금</option>' +
                '<option value="선납금">선납금</option>' +
                '<option value="개시대여료">개시대여료</option>' +
                '</select>'
            area.append(html);

            $('#gubun').bind('change', function() {
                reloadTemplateContent();
            });
            */
		}
		else if(value.id == 'pay_price'){
			$(value).val(pay_price);
		}
		else if(value.id == 'price_tot'){
			$(value).val(price_tot);
		}
		else if(value.id == 'payprice_date'){
			$(value).val(release_date);
		}
		else if(value.id == 'Click'){
			var area = $(value).parent();
            area.empty();
            
            var html;
            var html = '<select id="Click" class="width-3" onChange="javascript:setAccountUrl(this.value)">' +
                '<option value="" disabled selected>선택</option>';
                
            <%
            Map<String, String> map = new HashMap<String, String>();
            
           	for(int k=0;k<attach_vt_size;k++){
            	 Hashtable ht = (Hashtable)attach_vt.elementAt(k);
            	 String ht_string =ht.get("FILE_NAME")+"";
            	 ht_string=ht_string.substring(0,ht_string.lastIndexOf("."));
            	 if(map.get(ht_string)==null){
            		 map.put(ht_string, k+"");
            	 }else{
            			map.put(ht_string, map.get(ht_string)+","+k);
            				
            	 }
            	  
            }
           	TreeMap<String,String> tm = new TreeMap<String,String>(map);
            Iterator<String> iteratorKey = tm.keySet().iterator();
            
            int doc_count=0;
            while(iteratorKey.hasNext()){
	  		 	doc_count++;
	  			String map_key = iteratorKey.next();
	  		 	String[] map_result =  map.get(map_key).split(",");
	  		 	for(int k=0;k<map_result.length;k++){
						Hashtable ht = (Hashtable)attach_vt.elementAt(Integer.parseInt(map_result[k]));
						
						String sfile_type = ht.get("FILE_NAME")+"";
						sfile_type = sfile_type.substring(sfile_type.lastIndexOf(".")+1,sfile_type.length());
						if(k==0){
							String sfile_name = ht.get("FILE_NAME")+"";
							sfile_name = sfile_name.substring(0,sfile_name.lastIndexOf("."));
            %>
            
            <%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
				var fileType = '<%=ht.get("FILE_TYPE")%>';
				var seq = '<%=ht.get("SEQ")%>';
				var fileSize = '<%=ht.get("FILE_SIZE")%>';
            	var url = popupURL(fileType, seq, fileSize); 		
            		html += '<option value="'+url+'"><%=sfile_name%>(<%=ht.get("FILE_TYPE")%>)</option>'
			 <%}else{%>
            	html += '<option value="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>"><%=sfile_name%>(<%=ht.get("FILE_TYPE")%>)</option>'
			 <%}%>
            
            <%
						}
	  		 	}
            }
            %>
			html += '</select>';
            
            area.append(html);

            $('#Click').bind('change', function() {
                reloadTemplateContent();
            });
		}
		
        

    });
}

// 경매장탁송차량안내 전용 화면 set 처리 함수		2017.12.15
function car_num_name_arr_event(){
	var display = "";
	var car_num_arr = $("input[name='car_num_arr']");
	var car_name_arr = $("input[name='car_name_arr']");
	car_name_arr.each(function(i){
		display += car_num_arr.eq(i).val();
		display += ",";
		display += car_name_arr.eq(i).val();
		display += " ";
	});
	var display_slice = display.slice(0, -1);	// 마지막 공백 제거
	
	$("#car_num_name_arr").val(display_slice).trigger('change');
	$("#car_num_name_arr_count").val(car_num_arr.length).trigger('change');
}

// 경매장탁송차량안내 전용 이벤트			2017.12.15
$(document).on("change", "input[name='car_name_arr']",function(){
	car_num_name_arr_event();
});

// 예약완료(홈페이지) 안내문				2017.12.15
$(document).on("change", "input[id='expiration_date']",function(){
	var preValue = $(this).val();
	if(preValue.indexOf("년") >= 0){
	}else {
		var splitValue = preValue.split(' ');
		for(var i=0; i<splitValue.length; i++){
			if(i == 0){
				preValue = splitValue[i];	
				preValue += '년 ';
			}else if(i == 1){
				preValue += splitValue[i];
				preValue += '월 ';
			}else if(i == 2){
				preValue += splitValue[i];
				preValue += '일 ';
			}else if(i == 3){
				preValue += splitValue[i];
				preValue += '시';
			}	
		}
		$("#expiration_date").val(preValue).trigger('change');
	}
	
});
	
// 경매장탁송차량안내 전용 row 추가		2017.12.14
function addRow(){
	var html = '<div style="border:1px solid gold;width:330px;">'+
						'- 차량 번호<br/><input type="text" name="car_num_arr" style="width:300px;"><br/>'+
						'- 차량 이름<br/><input type="text" name="car_name_arr" style="width:300px;"><input type="button" value="─" onclick="removeRow($(this))">'+
					'</div>';
	
	var area = $("#car_name_arr").parent();
	area.append(html);
}

// 경매장탁송차량안내 전용 row 삭제		2017.12.14
function removeRow(param){
	var area = param.parent();
	area.remove();
	car_num_name_arr_event();
}


// 템플릿 필드 텍스트 적용
function reloadTemplateContent() {

    if (gContent == undefined) {
        return;
    }

    var reg = /\#\{(.*?)\}/g;
    var emp = '<span style="color: blue">$1</span>';

    var idx = 1;

    var searchFields = {};

    // 템플릿 필드값 가져옴
    var fields = $('#template-field-area input');
    $.each(fields, function(index, value) {

        var val = $(value).val();
        if (val != '') {
            searchFields[value.id] = val;
        }
    });

    var selects = $('#template-field-area select');
    $.each(selects, function(index, value) {

        // 방문장소
        if (value.id == 'visit_place') {
            var place = $(value).find('option:selected').data('place');
            searchFields[value.id] = place;

            var field_url = $('#visit_place_url');
            if (field_url != undefined) {
                var url = $(value).find('option:selected').data('url');
                if (url != undefined) {
                    /* var request = gapi.client.urlshortener.url.insert({
                        resource: {longUrl: url}
                    });
                    request.execute(function (response) {
                        if (response.id != null) {
                            field_url.val(response.id);
                            reloadTemplateContentUrl();
                        }
                    }); */
                	var date = new Date();
                    var day = Number(date.getDate());
                    
                    var apiKey_val = "";
                    var login_val = "";
                    
                    if (day < 11) {
                    	apiKey_val = "R_21f7cc9eec1e4782a39f779fd2dd2881";
                    	login_val = "tax100";
                    } else if (day < 21) {
                    	apiKey_val = "R_a8d1106fb23c4e56a8342dc570b33782";
                    	login_val = "tax200";
                    } else {
                    	apiKey_val = "R_fb94416e7d944122b607d7642fb0b905";
                    	login_val = "amazoncar";
                    }
                    
                    get_short_bitly(url, apiKey_val, login_val);
                    
                    function get_short_bitly(long_url, apiKey_val, login_val) {
                	    $.getJSON(
                	        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
                	        { 
                	            "format": "json",
                	            "apiKey": apiKey_val,
                	            "login": login_val,
                	            "longUrl": long_url
                	        },
                	        function(response) {
                	    		field_url.val(response.data.url);
                                reloadTemplateContentUrl();
                	        }
                	    );
                	};
                } else {
                    field_url.val('');
                }
            }
        }
        else if (value.id == 'contract_supp') {
            var supp = $(value).find('option:selected').val();
            searchFields[value.id] = supp;
        }
        else if (value.id == 'gubun') {
            var supp = $(value).find('option:selected').val();
            searchFields[value.id] = supp;
            var pay_price_result;
            switch(supp){
            	case '보증금': 
            		pay_price_result = '<%=Util.parseDecimal(grt_amt)%>원'; 
            		break;
            	case '선납금': 
            		pay_price_result = '<%=Util.parseDecimal(pp_amt)%>원'; 
            		break;
            	case '개시대여료': 
            		pay_price_result = '<%=Util.parseDecimal(ifee_amt)%>원'; 
            		break;
            }
            searchFields['pay_price'] = pay_price_result;
            $('#pay_price').val(pay_price_result);
        }
        else if (value.id == 'Click') {
            var supp = $(value).find('option:selected').val();
            searchFields[value.id] = supp;
        }

    });


    // 강조할 필드 찾음
    var empText = gContent.replace(reg, function(match, p1, offset) {

        var val = searchFields[p1];
        if (val == undefined || val == '') {
            val = p1;
        }

        // 고객이름은 멀티 전송할수 있기 때문에 id = 0 으로 만듬
        if (p1 == 'customer_name') {
            return '<span id="0" style="color: blue">' + val + '</span>';
        }
        // 약도는 다시한번 처리해야 하기 때문에 99 로 만듬
        else if (p1 == 'visit_place_url') {
            return '<span id="99" style="color: blue">' + val + '</span>';
        }
        else {
            return '<span id="' + idx++ + '" style="color: blue">' + val + '</span>';
        }
    });

    // 엔터처리
    empText = empText.replace(/\r?\n/g,'<br>');

    $('#alim-textarea').html(empText);

    // 메시지 길이 체크
//    alert($('#alim-textarea').html().length);
    if (gContent == '') {
        $('#message-length').html($('#alim-textarea-w').val().length);
    }
    else {
        $('#message-length').html($('#alim-textarea').html().length);
    }
}

function reloadTemplateContentUrl() {

    // URL 템플릿 필드값 가져옴
    var field = $('#visit_place_url').val();
    var textarea = $('#alim-textarea').html();
    $('#alim-textarea').html(textarea.replace(/(<span id="99".*>).*(<\/span>)/, '$1' + field + '$2'));

//    content = content.replace(/(<span id="99".*>).*(<\/span>)/, '$1' + field + '$2');

}


// 계약 검색 결과 테이블 생성
function makeContractTable(datum) {
    var area = $('#contract-search-result-table')

    area.find('.contract-search-result').remove()

    var html = '';
    if (datum.length == 0) {
        html = '<tr class="contract-search-result" align="center"><td colspan="10">검색된 데이터가 없습니다</td></tr>';
        $('#contract-result-count').html('0');
    }
    else {
        datum.forEach(function(elem, index) {
            html +=
                '<tr class="contract-search-result" align="center" style="">' +
                '<td><input type="radio" name="contract-radio" value="'+ elem.RENT_ST +'"></td>' +
                '<td>' + (index + 1) + '</td>' +
                '<td>' + elem.USE_YN + '</td>' +
                '<td>' + elem.ST_NM + elem.RENT_L_CD + '</td>' +
                '<td>' + elem.RENT_DT + '</td>' +
                '<td>' + elem.FIRM_NM + '</td>' +
                '<td>' + elem.CAR_NO+ '</td>' +
                '<td>' + elem.CAR_NM + '</td>' +
                '<td>' + elem.INS_NM + '</td>' +
                '<td>' + elem.BUS_NM2 + '</td>' +
                '</tr>';
        });
    }
    area.append(html);

    $('#contract-result-count').html(datum.length);

    // 클릭시 템플릿 필드를 채움
    var rows = $('#contract-search-area input[type=radio]');
    rows.bind('click', function() {

        var idx = $(this).parent().parent().index() - 2;   // tr > td > input
        var contract = gContractList[idx];
//        var contract = gContractList[$(this).index() - 2];


        // jjlim@20171107 전역변수에도 넣어줌
        rentLCode = contract.RENT_L_CD;
        rentMsgId = contract.RENT_MNG_ID;

        // 계약 정보 가져옴
        var data = {
            m_id: contract.RENT_MNG_ID,
            l_cd: contract.RENT_L_CD,
            more_info: true //계약에서 바로 들어왔을 경우 리스트검색 정보가 없기때문에 더 가져옴 2017.11.16
        }

        $.ajax({
        	   cache: false, 
            type: 'POST',
            url: './alim_talk_ajax.jsp',
            dataType: 'json',
            data: {
                cmd: 'cont_info',
                data: JSON.stringify(data)
            },
            success: function(data) {
                gContractInfo = data;
                //setContractField(contract);
                setContractField(gContractInfo);

            },
            error: function(e) {
                alert('실패');
            }
        })
    });
}

// 계약 선택시 필드 채움
function setContractField(selectedContract) {

    // 발신자
    $('#org-name').hide();
    $('#spe-org-name').show();

    var org = $('#spe-org-name').empty()

    var users = gContractInfo.users
    users.forEach(function(user, index) {
        var html =
            '<option val="'+ user.USER_ID +'" data-name="'+ user.USER_NM +'" data-phone="'+ user.USER_M_TEL +'">' +
            user.USER_NM + " (" + user.USER_M_TEL + ")" +
            '</option>';
        if (users.length == index + 1) {
            html =
                '<option val="'+ user.USER_ID +'" data-name="'+ user.USER_NM +'" data-phone="'+ user.USER_M_TEL +'" selected>' +
                user.USER_NM + " (" + user.USER_M_TEL + ")" +
                '</option>';
        }
        org.append(html);
    });
//    var user = gContractInfo.user
//    var html =
//        '<option val="'+ user.USER_ID +'" data-name="'+ user.USER_NM +'" data-phone="'+ user.USER_M_TEL +'">' +
//            user.USER_NM + " (" + user.USER_M_TEL + ")" +
//        '</option>';
//    org.append(html);

    org.bind('change', function() {
        // 발신자 정보 -> 담당자 이름, 전화
        var selOpt = $(this).find(':selected');
        $('input#manager_name').val(selOpt.attr('data-name'));
        $('input#manager_phone').val(selOpt.attr('data-phone'));
        reloadTemplateContent();
    }).change();


    // 수신자
    $('#recipient_num').hide();
    $('#spe-recipient-name').show();
    $('#spe-recipient-direct').show().css('display', 'inline');
    $('#spe-recipient-direct input[type=checkbox]').prop('checked', false);

    var term = $('#spe-recipient-name').empty();

    var clnts = gContractInfo.clnts;
    clnts.forEach(function(elem, index) {
        var html =
            '<option val="'+ (index + 1) +'" data-name="'+ elem.USER_NM +'" data-phone="'+ elem.USER_M_TEL +'">' +
                elem.USER_DESC + " " + elem.USER_NM + " (" + elem.USER_M_TEL + ")" +
            '</option>';
        term.append(html);
    });

    term.bind('change', function() {
        // 수신자 정보 -> 고객 ?
        var selOpt = $(this).find(':selected');
        $('input#customer_name').val(selOpt.attr('data-name'));
        reloadTemplateContent();
    }).change();


    // 보험 필드
    var insur = gContractInfo.insur
    if ($('#template-select option:selected').val() == "acar0231") {    	
    	$('input#insurance_name').val(insur.INS_NM + "("+insur.INS_TEL+")");
    } else {    	
    	$('input#insurance_name').val(insur.INS_NM);
    }
    $('input#insurance_phone').val(insur.INS_TEL);
    $('input#insur_mng_name').val(insur.INS_MNG_NM);
    $('input#insur_mng_phone').val(insur.INS_MNG_TEL);

    // 차량
    var templateCode = '<%= templateCode %>';
    if(templateCode == 'acar0268' || templateCode == 'acar0277'){ // 선수금 납부안내문
    	var carNm = '<%=carNm%>';
    	$('input#car_name').val(carNm);   	
    } else{
	    $('input#car_name').val(selectedContract.CAR_NM);
    }
    $('input#car_num').val(selectedContract.CAR_NO);
    $('input#p_car_num').val(selectedContract.CAR_NUM);
    $('input#rent_month').val(selectedContract.MONTH);
    
    $('input#contract_s_date').val(selectedContract.RENT_START_DT);
    $('input#contract_e_date').val(selectedContract.RENT_END_DT);
    
    // 담당자(영업)
    $('input#bus_manager_name').val(selectedContract.BUS_NM);
    $('input#bus_manager_phone').val(selectedContract.BUS_M_TEL);
    
    // 대여개시안내 단축url
    var rent_st = selectedContract.RENT_ST;
    var result_rent_st = "";
    if (rent_st == "신규") {
    	result_rent_st = "1";
    } else if (rent_st == "연장") {
    	result_rent_st = "2";
    } else if (rent_st == "대차") {
    	result_rent_st = "3";
    } else if (rent_st == "증차") {
    	result_rent_st = "4";
    } else if (rent_st == "연장") {
    	result_rent_st = "5";
    } else if (rent_st == "재리스") {
    	result_rent_st = "6";
    } else {
    	result_rent_st = "7";
    }
        
    var date = new Date();
    var day = Number(date.getDate());
    
    var apiKey_val = "";
    var login_val = "";
    var long_url = "http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id=" + rentMsgId + "&l_cd=" +rentLCode + "&rent_st=" + rentSt;
    var long_service_url = "http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id=" + rentMsgId + "&l_cd=" +rentLCode + "&rent_st=" + rentSt;
    var blumembers_link = "http://fms1.amazoncar.co.kr/mailing/etc/bluemem.html";
    
    var sos_url = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_sos.jsp?rent_mng_id=" + rentMsgId + "&rent_l_cd=" +rentLCode;
    var accident_url = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_accident.jsp?rent_mng_id=" + rentMsgId + "&rent_l_cd=" +rentLCode;
    var maint_url = "http://fms1.amazoncar.co.kr/acar/ars/ars_info_maint.jsp?rent_mng_id=" + rentMsgId + "&rent_l_cd=" +rentLCode;
    
    if (day < 11) {
    	apiKey_val = "R_21f7cc9eec1e4782a39f779fd2dd2881";
    	login_val = "tax100";
    } else if (day < 21) {
    	apiKey_val = "R_a8d1106fb23c4e56a8342dc570b33782";
    	login_val = "tax200";
    } else {
    	apiKey_val = "R_fb94416e7d944122b607d7642fb0b905";
    	login_val = "amazoncar";
    }
    
    get_short_url(long_url, apiKey_val, login_val);
    get_short_service_url(long_service_url, apiKey_val, login_val);
    get_short_blumembers_link(blumembers_link, apiKey_val, login_val);
    
    get_short_sos_url(sos_url, apiKey_val, login_val);
    get_short_accident_url(accident_url, apiKey_val, login_val);
    get_short_maint_url(maint_url, apiKey_val, login_val);
    
    function get_short_url(long_url, apiKey_val, login_val) {
	    $.getJSON(
	        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
	        { 
	            "format": "json",
	            "apiKey": apiKey_val,
	            "login": login_val,
	            "longUrl": long_url
	        },
	        function(response) {
	            $('input#URL').val(response.data.url);
	    		reloadTemplateContent();
	        }
	    );
	};
	
    function get_short_service_url(long_service_url, apiKey_val, login_val) {
	    $.getJSON(
	        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
	        { 
	            "format": "json",
	            "apiKey": apiKey_val,
	            "login": login_val,
	            "longUrl": long_service_url
	        },
	        function(response) {
	            $('input#car_mng_service_url').val(response.data.url);
	    		reloadTemplateContent();
	        }
	    );
	};
	
    function get_short_blumembers_link(blumembers_link, apiKey_val, login_val) {
	    $.getJSON(
	        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
	        { 
	            "format": "json",
	            "apiKey": apiKey_val,
	            "login": login_val,
	            "longUrl": blumembers_link
	        },
	        function(response) {
	            $('input#blumembers_link').val(response.data.url);
	    		reloadTemplateContent();
	        }
	    );
	};
	
    function get_short_sos_url(sos_url, apiKey_val, login_val) {
	    $.getJSON(
	        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
	        { 
	            "format": "json",
	            "apiKey": apiKey_val,
	            "login": login_val,
	            "longUrl": sos_url
	        },
	        function(response) {
	            $('input#sos_url').val(response.data.url);
	    		reloadTemplateContent();
	        }
	    );
	};
	
    function get_short_accident_url(accident_url, apiKey_val, login_val) {
	    $.getJSON(
	        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
	        { 
	            "format": "json",
	            "apiKey": apiKey_val,
	            "login": login_val,
	            "longUrl": accident_url
	        },
	        function(response) {
	            $('input#accident_url').val(response.data.url);
	    		reloadTemplateContent();
	        }
	    );
	};
	
    function get_short_maint_url(maint_url, apiKey_val, login_val) {
	    $.getJSON(
	        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
	        { 
	            "format": "json",
	            "apiKey": apiKey_val,
	            "login": login_val,
	            "longUrl": maint_url
	        },
	        function(response) {
	            $('input#maint_url').val(response.data.url);
	    		reloadTemplateContent();
	        }
	    );
	};
	
	/* var request = gapi.client.urlshortener.url.insert({
        resource: {longUrl: long_url}
    });
    request.execute(function (response) {
        if (response.id != null) {
            $('input#URL').val(response.id);
            reloadTemplateContent();
        }
    }); */

    reloadTemplateContent();

    $(window).scrollTop(0);
}


// 영업사원 검색 결과 테이블 생성
function makeSalesTable(data) {

    var area = $('#sales-search-result-table')

    area.find('.sales-search-result').remove()

    var html = '';
    if (data.length == 0) {
        html = '<tr class="sales-search-result" align="center"><td colspan="10">검색된 데이터가 없습니다</td></tr>';
        $('#sales-result-count').html('0');

        $('#sales-search-check-all').hide();
    }
    else {
        data.forEach(function(elem, index) {
            html +=
                '<tr class="sales-search-result" align="center" style="">' +
                '<td><input type="checkbox" name="sales-checkbox"></td>' +
                '<td>' + (index + 1) + '</td>' +
                '<td>' + elem.CAR_COMP_NM + '</td>' +
                '<td>' + '-' + '</td>' +
                '<td>' + '-' + '</td>' +
                '<td>' + elem.EMP_NM + '</td>' +
                '<td>' + elem.EMP_M_TEL+ '</td>' +
                '<td>' + '-' + '</td>' +
                '<td>' + '-' + '</td>' +
                '<td>' + '-' + '</td>' +
                '</tr>';
        });

        $('#sales-search-check-all').show();
    }
    area.append(html);

    $('#sales-result-count').html(data.length);

    // 클릭시 템플릿 필드를 채움
    var rows = $('#sales-search-area input[type=checkbox]');
    rows.bind('click', function() {

        var idx = $(this).parent().parent().index() - 2;   // tr > td > input
        var sales = gSalesList[idx];

        if ($(this).prop('checked')) {
            // 수신자 추가
            var multiSales = new User(sales.EMP_NM, '', sales.EMP_M_TEL);
            mMultiSales.push(multiSales);
            setSalesField(sales);
        }
        else {
            // 수신자 삭제
            mMultiSales = mMultiSales.filter(function(item) {
                return item.name != sales.EMP_NM;
            });
            setSalesField(sales);
        }
    });


}

// 영업사원 정보로 필드 채움
function setSalesField(sales) {

    // 수신자
    $('#recipient_num').hide();
    $('#spe-recipient-name').show();
    $('#spe-recipient-direct').hide();
//    $('#spe-recipient-direct').show().css('display', 'inline');
    $('#spe-recipient-direct input[type=checkbox]').prop('checked', false);
    $('#spe-recipient-cnt').hide();

    if (mMultiSales.length == 0) {
        $('#recipient_num').show();
        $('#spe-recipient-name').hide();
        $('#spe-recipient-direct').hide();
        $('#spe-recipient-direct input[type=checkbox]').prop('checked', false);
        $('#spe-recipient-cnt').hide();

        $('#spe-recipient-name').empty()
        $('input#customer_name').val('');
        reloadTemplateContent();

    }
    else if (mMultiSales.length == 1) {
        var term = $('#spe-recipient-name').empty()
        var html =
            '<option val="'+ "1" +'" data-name="'+ sales.EMP_NM +'" data-phone="'+ sales.EMP_M_TEL +'">' +
            sales.EMP_NM + " (" + sales.EMP_M_TEL + ")" +
            '</option>';
        term.append(html);

        term.bind('change', function() {
            // 수신자 정보 -> 고객 ?
            var selOpt = $(this).find(':selected');
            $('input#customer_name').val(selOpt.attr('data-name'));
            reloadTemplateContent();
        }).change();


        reloadTemplateContent();

        $(window).scrollTop(0);
    }
    else {
        $('#spe-recipient-cnt').html(mMultiSales.length + '명 선택');
        $('#spe-recipient-cnt').show().css('display', 'inline');;
    }

}


// ajax 사용자 검색
function ajaxSearchUser(cond) {
    $.ajax({
    	  cache: false,
        type: 'POST',
        url: './alim_talk_ajax.jsp',
        dataType: 'json',
        data: {
            cmd: 'search_user',
            data: JSON.stringify(cond)
        },
        beforeSend: function() {
            $('#user-search-loader').show();
        },
        success: function(data) {
            $('#user-search-loader').hide();

            gUserList = data.filter(function(elem) {
                return elem.ID != '';
            });
            addUserTable(gUserList);
        },
        error: function(e) {
            $('#user-search-loader').hide();
            alert('검색 실패');
        }
    })
}

// 사용자 테이블 설정
function addUserTable(data) {
    var area = $('#user-search-result-table')

    area.find('.user-search-result').remove()

    var html = '';
    if (data.length == 0) {
        html = '<tr class="user-search-result" align="center"><td colspan="7">검색된 데이터가 없습니다</td></tr>';
        $('#user-result-count').html('0');

        $('#user-search-check-all').hide();
    }
    else {
        data.forEach(function(elem, index) {
            html +=
                '<tr class="user-search-result" align="center" style="">' +
                '<td><input type="checkbox" name="user-checkbox"></td>' +
                '<td>' + (index + 1) + '</td>' +
                '<td>' + elem.DEPT_ID + '</td>' +
                '<td>' + elem.BR_NM + '</td>' +
                '<td>' + elem.USER_NM + '</td>' +
                '<td>' + elem.USER_POS + '</td>' +
                '<td>' + elem.USER_M_TEL + '</td>' +
                '</tr>';
        });

        $('#user-search-check-all').show();
    }
    area.append(html);

    $('#user-result-count').html(data.length);

    // 클릭시 템플릿 필드를 채움
    var rows = $('#user-search-area input[type=checkbox]');
    rows.bind('click', function() {

        var idx = $(this).parent().parent().index() - 2;   // tr > td > input
        var user = gUserList[idx];

        if ($(this).prop('checked')) {
            // 수신자 추가
            var multiUser = new User(user.USER_NM, user.USER_POS, user.USER_M_TEL);
            mMultiUser.push(multiUser);
            setUserInfo(user);
        }
        else {
            // 수신자 삭제
            mMultiUser = mMultiUser.filter(function(item) {
                return item.name != user.USER_NM;
            });
            setUserInfo(user);
        }



    });


}

// 템플릿 필드를 채우고 리로드
function setUserInfo(user) {

    // 수신자
    $('#recipient_num').hide();
    $('#spe-recipient-name').show();
    $('#spe-recipient-direct').hide();
    $('#spe-recipient-direct input[type=checkbox]').prop('checked', false);
    $('#spe-recipient-cnt').hide();

    // 한개도 선택되지 않았을 경우
    if (mMultiUser.length == 0) {
        $('#recipient_num').show();
        $('#spe-recipient-name').hide();
        $('#spe-recipient-direct').hide();
        $('#spe-recipient-direct input[type=checkbox]').prop('checked', false);
        $('#spe-recipient-cnt').hide();

        $('#spe-recipient-name').empty()
        $('input#customer_name').val('');
        reloadTemplateContent();

    }
    // 한개 선택되었을 경우
    else if (mMultiUser.length == 1) {
        var term = $('#spe-recipient-name').empty()
        var html =
            '<option val="' + "1" + '" data-name="' + user.USER_NM + '" data-phone="' + user.USER_M_TEL + '">' +
            user.USER_NM + " (" + user.USER_M_TEL + ")" +
            '</option>';
        term.append(html);

        term.bind('change', function () {
            // 수신자 정보 -> 고객 ?
            var selOpt = $(this).find(':selected');
            $('input#customer_name').val(selOpt.attr('data-name'));
            reloadTemplateContent();
        }).change();

        reloadTemplateContent();

        $(window).scrollTop(0);
    }
    // 여러명 선택되었을 경우
    else {
        $('#spe-recipient-cnt').html(mMultiUser.length + '명 선택');
        $('#spe-recipient-cnt').show().css('display', 'inline');;

    }
}


// 지역 선택 기능
var cnt = new Array();
cnt[0] = new Array('구/군');
cnt[1] = new Array('구/군','강남구','강동구','강북구','강서구','관악구','광진구','구로구','금천구','노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구','성동구','성북구','송파구','양천구','영등포구','용산구','은평구','종로구','중구','중랑구');
cnt[2] = new Array('구/군','강서구','금정구','남구','동구','동래구','부산진구','북구','사상구','사하구','서구','수영구','연제구','영도구','중구','해운대구','기장군');
cnt[3] = new Array('구/군','남구','달서구','동구','북구','서구','수성구','중구','달성군');
cnt[4] = new Array('구/군','계양구','남구','남동구','동구','미추홀구','부평구','서구','연수구','중구','강화군','옹진군');
cnt[5] = new Array('구/군','광산구','남구','동구','북구','서구');
cnt[6] = new Array('구/군','대덕구','동구','서구','유성구','중구');
cnt[7] = new Array('구/군','남구','동구','북구','중구','울주군');
cnt[8] = new Array('구/군','세종특별자치시');
cnt[9] = new Array('구/군','고양시','과천시','광명시','구리시','군포시','남양주시','동두천시','부천시','성남시','수원시','시흥시','안산시','안양시','오산시','의왕시','의정부시','평택시','하남시','가평군','광주시','김포시','안성시','양주시','양평군','여주군','연천군','용인시','이천시','파주시','포천시','화성시');
cnt[10] = new Array('구/군','강릉시','동해시','삼척시','속초시','원주시','춘천시','태백시','고성군','양구군','양양군','영월군','인제군','정선군','철원군','평창군','홍천군','화천군','횡성군');
cnt[11] = new Array('구/군','제천시','청주시','충주시','괴산군','단양군','보은군','영동군','옥천군','음성군','진천군','청원군','증평군');
cnt[12] = new Array('구/군','공주시','계룡시','보령시','서산시','아산시','천안시','금산군','논산군','당진군','부여군','서천군','연기군','예산군','청양군','태안군','홍성군');
cnt[13] = new Array('구/군','군산시','김제시','남원시','익산시','전주시','정읍시','고창군','무주군','부안군','순창군','완주군','임실군','장수군','진안군');
cnt[14] = new Array('구/군','광양시','나주시','목포시','순천시','여수시','여천시','강진군','고흥군','곡성군','구례군','담양군','무안군','보성군','신안군','여천군','영광군','영암군','완도군','장성군','장흥군','진도군','함평군','해남군','화순군');
cnt[15] = new Array('구/군','경산시','경주시','구미시','김천시','문경시','상주시','안동시','영주시','영천시','포항시','고령군','군위군','봉화군','성주군','영덕군','영양군','예천군','울릉군','울진군','의성군','청도군','청송군','칠곡군');
cnt[16] = new Array('구/군','거제시','김해시','마산시','밀양시','사천시','울산시','진주시','진해시','창원시','통영시','거창군','고성군','남해군','산청군','양산시','의령군','창녕군','하동군','함안군','함양군','합천군');
cnt[17] = new Array('구/군','서귀포시','제주시','남제주군','북제주군');

function county_change(add) {

    $('select[name=gubun2]').empty();
    for (var i = 0; i < cnt[add].length; i++)
    {
        if (i == 0) {
            $('select[name=gubun2]').append('<option value="">'+ cnt[add][i] +'</option>');
        }
        else {
            $('select[name=gubun2]').append('<option value="'+ cnt[add][i] +'">'+ cnt[add][i] +'</option>');
        }
    }
}

function clearSearch(type) {
    if (type == null) {
        $('input[name=search-type][value=client]').prop("checked",true);
    }
    clearSearchClient();
    clearSearchUser();
    clearSearchSales();
}

function clearSearchClient() {
    gContractList.length = 0;
    gContractInfo = {};
    makeContractTable(gContractList);
}

function clearSearchUser() {
    mMultiUser.length = 0;
    gUserList.length = 0;
    addUserTable(gUserList);
}

function clearSearchSales() {
    mMultiSales.length = 0;
    gSalesList.length = 0;
    makeSalesTable(gSalesList);
}

// 유저 전체 선택시
function userCheckAll() {
    mMultiUser.length = 0;
    gUserList.forEach(function(user, index, array) {
        var multiUser = new User(user.USER_NM, user.USER_POS, user.USER_M_TEL);
        mMultiUser.push(multiUser);

        // 처음과 마지막 일때
        if (index == 0) {
            setUserInfo(user);
        }
        else if (index == array.length - 1) {
            setUserInfo(user);
        }
    });
    // 체크박스 체크
    $('#user-search-area input[type=checkbox]').prop('checked', true);

}

// 영업사원 전체 선택시
function salesCheckAll() {
    mMultiSales.length = 0;
    gSalesList.forEach(function(sales, index, array) {
        var multiSales = new User(sales.EMP_NM, '', sales.EMP_M_TEL);
        mMultiSales.push(multiSales);

        // 처음과 마지막 일때
        if (index == 0) {
            setSalesField(sales);
        }
        else if (index == array.length - 1) {
            setSalesField(sales);
        }
    });
    // 체크박스 체크
    $('#sales-search-area input[type=checkbox]').prop('checked', true);
}

// jjlim add auto select
function ajaxGetContractInfo(mngId, lCd) {
    // 계약 정보 가져옴
    var data = {
        m_id: mngId,
        l_cd: lCd,
        more_info: true         // jjlim@20171116 계약에서 바로 들어왔을 경우 리스트검색 정보가 없기때문에 더 가져옴
    }

    $.ajax({
        cache: false,
        type: 'POST',
        url: './alim_talk_ajax.jsp',
        dataType: 'json',
        data: {
            cmd: 'cont_info',
            data: JSON.stringify(data)
        },
        beforeSend: function() {
            $('#search-loader').show();
        },
        success: function(data) {
            $('#search-loader').hide();
            gContractInfo = data;
            setContractField(gContractInfo);

        },
        error: function(e) {
            alert('실패');
        }
    })
}

function popupURL(type, seq, size){
	var isImage = type.indexOf("image/") != -1 ? true : false;
	var isPDF = type.indexOf("/pdf") != -1 ? true : false;
	var isTIF  = type.indexOf("/tif") != -1 ? true : false;
	var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal_fms.jsp';
	
	if( isImage || isPDF ){
		if(type.indexOf("image/") != -1 ) {
			url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview_print_fms.jsp';
		}
		
		if(isTIF) {
			url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal_fms.jsp';
		}
						
		url = url + "?SEQ=" + seq + "&S_GUBUN="+size;
		
	}
	
	return url;
}

// 납부 은행 계좌 onChange 시 선택 값 단축 URL로 변경.
function setAccountUrl(account_url){
	
	// 이미 단축 url로 변경된 경우 return
	if(account_url.indexOf('fms3.amazoncar.co.kr') < 0){
		return;
	}
	
	var date = new Date();
    var day = Number(date.getDate());
    
    var apiKey_val = "";
    var login_val = "";
    
    if (day < 11) {
    	apiKey_val = "R_21f7cc9eec1e4782a39f779fd2dd2881";
    	login_val = "tax100";
    } else if (day < 21) {
    	apiKey_val = "R_a8d1106fb23c4e56a8342dc570b33782";
    	login_val = "tax200";
    } else {
    	apiKey_val = "R_fb94416e7d944122b607d7642fb0b905";
    	login_val = "amazoncar";
    }
    
    get_short_account_url(account_url, apiKey_val, login_val);
}

function get_short_account_url(account_url, apiKey_val, login_val){
	
	$.getJSON(
        "https://api-ssl.bitly.com/v3/shorten?callback=?", 
        { 
            "format": "json",
            "apiKey": apiKey_val,
            "login": login_val,
            "longUrl": account_url
        },
        function(response) {
            $('#Click option:selected').val(response.data.url);
    		reloadTemplateContent();
        }
    );
}

</script>

</head>

<body leftmargin="15">

<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>알림톡 > <span class=style5>알림톡 발송</span></span></td>
                        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr><td class=h></td></tr>
        <tr>
            <td colspan=10>
                <span class=style4>※ 직접입력(친구톡)은 플러스친구 에게만 전송됩니다. 플러스친구가 아니면 문자로 전송됩니다.</span>
                <%if(templateCode.equals("acar0268") || templateCode.equals("acar0277")){ %>
                <br>
                <span class=style4>※ 납부은행계좌는 안드로이드폰은 가급적 이미지파일을 선택하십시오. PDF 파일은 확인이 안될 수도 있습니다. </span>
                <%} %>
            </td>
        </tr>
        <tr style="display: none;"><td>
         <%  if (  nm_db.getWorkAuthUser("전산팀",user_id)  ) {%>
            <button id="manage-template" class="button">템플릿 관리</button>
        <% } %>    
        </td></tr>
        <tr><td class=h></td></tr>
    </table>
</div><br>

<%-- 알림톡 --%>
<div>
    <div class="table-style-1" style="display: none;"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">템플릿</div>
    <div style="display: none;">
    	<select id="select-first-category">
    		<option value="0">전체</option>
    		<option value="1">상품별</option>
    		<option value="2">내용별</option>    		
    		<option value="10">직접입력</option> 		
    	</select>
        <select id="select-category">
        	<!-- <option value="0">카테고리선택</option> -->
        </select>
        <select id="template-select">
            <!-- <option value="0" selected>템플릿 선택</option> -->
        </select>
        <img id="search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none;">
    </div>
    <br>

    <div class="table-style-1" id="talk_content_1" style="display: none"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">알림톡 발송</div>

    <div style="float: left" id="talk_content_2" style="display: none">
        <div class="message_body">
            <div style="height: 20px"></div>
            <div class="message_bubble">
                <div class="message_bubble_header">
                    <div class="message_bubble_header_text font-1">알림톡</div>
                </div>
                <div>
                    <div id="alim-textarea" class="message_bubble_text_area font-2"></div>
                    <%--<div id="alim-textarea" class="message_bubble_text_area" rows="5" cols="30" class="font-2" readonly style=" overflow-x: hidden; width: 90%; height: 80%; margin: 5%; resize: none; border: none"></div>--%>

                    <textarea id="alim-textarea-w" rows="5" cols="30" class="message_bubble_text_area font-2" style="display: none"></textarea>
                    <%--<textarea id="alim-textarea" rows="5" cols="30" class="font-2" readonly style=" overflow-x: hidden; width: 90%; height: 80%; margin: 5%; resize: none; border: none"></textarea>--%>
                </div>
            </div>
        </div>
        <button id="send-button" class="message_send_button font-1">보내기</button>
        <div>
            <div style="text-align: right; color: #737373; font-size: 12px; padding: 5px">현재: <span id="message-length">0</span> byte</div>
        </div>
    </div>

    <div style="margin-left: 350px" id="talk_content_3"  style="display: none">
        <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">발신자/수신자</div>
        <div>
            <div style="margin-top: 5px">
                <span class="font-2">발신자</span>
                <select name="aaa" id="org-name" class="width-1">
                    <option value="A1" disabled selected>발신자</option>
                    <%  if (user_size > 0) {
                        for (int i = 0; i < user_size; i++) {
                            Hashtable user = (Hashtable)users.elementAt(i); %>

                    <option value='<%= user.get("USER_ID") %>'
                            data-name="<%= user.get("USER_NM") %>"
                            data-phone="<%= user.get("USER_M_TEL") %>"
                            data-grade="<%= user.get("USER_POS") %>"
                            data-br-nm="<%= user.get("BR_NM") %>"
                            data-br-addr="<%= user.get("BR_ADDR") %>"
                            data-br-tel="<%= user.get("BR_TEL") %>"
                            <% if (user_id.equals(user.get("USER_ID"))) out.println("selected"); %>><%= user.get("USER_NM") %> (<%= user.get("USER_M_TEL") %>)</option>

                    <%  }
                    } %>
                </select>
                <select id="spe-org-name" class="width-2" style="display: none;">
                    <option value="" disabled selected>발신자</option>
                </select>
                <%--<input type="text" id="org-phone" value="<%= user_m_tel %>">--%>
            </div>
            <div style="margin-top: 5px">
                <span class="font-2">수신자</span>
                <input id="recipient_num" type="text" class="width-1" />
                <select id="spe-recipient-name" class="width-2" style="display: none;">
                    <option value="" disabled selected>수신자</option>
                </select>
                <div id="spe-recipient-direct" class="font-2" style="display: none"><input type="checkbox">직접입력</div>
                <span id="spe-recipient-cnt" class="font-2" style="margin-left: 5px; display: none; color: red;">0명 선택</span>

            </div>
        </div>
        <br>

        <div id="template-field-area-outter">
            <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">템플릿 필드</div>
            <div id="template-field-area"></div>
        </div>
        <br>
    </div>
</div>


<%-- 검색 영역 시작 --%>
<div id="search-area" style="clear: both">

<div class="font-2">
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">검색</div>
    <input type="radio" name="search-type" value="client" checked>고객
    <input type="radio" name="search-type" value="user">사용자
    <input type="radio" name="search-type" value="sales">영업사원
</div><br>

<%-- 계약 검색 --%>
<div id="contract-search-area" style="clear: both; width: 800px;">
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">계약 검색<img id="contract-search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none"></div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="800">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td class="title" width=10%>조회일자</td>
            <td width="45%">&nbsp;
                <select name='gubun4'>
                    <option value="1">계약일자</option>
                    <option value="2">계약승계일</option>
                </select>
                &nbsp;
                <select name='gubun5'>
                    <option value="1">당일</option>
                    <option value="2">전일</option>
                    <option value="3">2일</option>
                    <option value="4">당월</option>
                    <option value="5">전월</option>
                    <option value="6" selected>기간</option>
                </select>
                &nbsp;
                <input type="text" name="st_dt" size="10" value="" class="text">
                ~
                <input type="text" name="end_dt" size="10" value="" class="text">
            </td>
        </tr>
        <tr>
            <td class=title width=10%>검색조건</td>
            <td width=40%>&nbsp;
                <select name='s_kd'>
                    <option value='1' >상호 </option>
           <!--         <option value='13'>대표자 </option> -->
                    <option value='19'>사업자번호/생년월일</option>
                    <option value='2' >계약번호 </option>
                    <option value='3' >차량번호 </option>
           <!--         <option value='8' >최초영업자 </option>
                    <option value='10'>영업담당자 </option>
                    <option value='11'>관리담당자 </option> -->
                </select>
                &nbsp;
                <input type='text' name='t_wd' size='18' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            </td>
        </tr>
    </table>
    <div style="text-align: right; margin-top: 2px"><img id="search-cont-button" src=/acar/images/center/button_search.gif align=absmiddle border=0></div>

    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">총 <span id="contract-result-count">0</span> 건</div>
    <table id="contract-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='800'>
        <tr><td class=line2></td></tr>
        <tr>
            <td width="5%" class='title'>선택</td>
            <td width='6%' class='title'>연번</td>
            <td width='6%' class='title'>구분</td>
            <td width='12%' class='title'>계약번호</td>
            <td width='9%' class='title'>계약일</td>
            <td width="20%" class='title'>고객</td>
            <td width="10%" class='title'>차량번호</td>
            <td width="12%" class='title'>차종</td>
            <td width="10%" class='title'>보험사</td>
            <td width="10%" class='title'>영업<br>담당자</td>
        </tr>
            <tr class="contract-search-result" align='center'>
                <td colspan="10">검색된 데이타가 없습니다</td>
            </tr>
    </table>
    </div>

<!-- 사용자 검색 -->
<div id="user-search-area" style="clear: both; width: 800px; display: none">
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">사용자 검색<img id="user-search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none"></div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="800">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td class=title width=10%>검색조건</td>
            <td width=40%>&nbsp;
                <select name='s_kd'>
                    <option value='EMP'>전직원</option>
                    <option value='AGENT'>에이전트</option>
            <!--        <option value='BUS_EMP'>영업팀</option>
                    <option value='MNG_EMP'>고객지원팀</option>
                    <option value='GEN_EMP'>총무팀</option> -->
                </select>
            </td>
        </tr>
    </table>
    <div style="text-align: right; margin-top: 2px"><img id="search-user-button" src=/acar/images/center/button_search.gif align=absmiddle border=0></div>
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">총 <span id="user-result-count">0</span> 건 <button id="user-search-check-all" onclick="userCheckAll();" style="display: none;">전체선택</button></div>
    <table id="user-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='800'>
        <tr><td class=line2></td></tr>
        <tr>
            <td width="5%" class='title'>선택</td>
            <td width='6%' class='title'>연번</td>
            <td width='15%' class='title'>소속사</td>
            <td width="15%" class='title'>근무처</td>
            <td width='20%' class='title'>성명</td>
            <td width='15%' class='title'>직위</td>
            <td width="24%" class='title'>핸드폰</td>
        </tr>
        <tr class="user-search-result" align='center'>
            <td colspan="7">검색된 데이타가 없습니다</td>
        </tr>
    </table>
</div>

</div>

    <%-- 영업사원  검색  -- 20170927  추가  display:block 처리 20170927     고객, 사용자. 영업사원 검색시 사용함   ---%>
 <div id="sales-search-area" style="clear: both; width: 800px; display: none">
    <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">영업사원 검색<img id="sales-search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none"></div>
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="800">
        <tr><td class=line2 colspan=2></td></tr>
        <tr>
            <td class="title" width=10%>소속사 </td>
            <td width="35%">  <select name="gubun3">
                        <option value="">전체
                        <%
            for(int i=0; i<cc_r.length; i++){
                cc_bean = cc_r[i];
                if(cc_bean.getNm().equals("에이전트")) continue;
        %>
                        <option value="<%= cc_bean.getCode() %>" <% if(gubun3.equals(cc_bean.getCode())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                        <%}%>
                    </select>
                 &nbsp;
           </td>
            <td class="title" width=10%>근무지역 </td>
            <td width="35%">

                <select name='gubun1' onchange="county_change(this.selectedIndex);">
                    <option value=''>시/도</option>
                    <option value='서울'>서울특별시</option>
                    <option value='부산'>부산광역시</option>
                    <option value='대구'>대구광역시</option>
                    <option value='인천'>인천광역시</option>
                    <option value='광주'>광주광역시</option>
                    <option value='대전'>대전광역시</option>
                    <option value='울산'>울산광역시</option>
                    <option value='세종'>세종특별자치시</option>
                    <option value='경기'>경기도</option>
                    <option value='강원'>강원도</option>
                    <option value='충북'>충청북도</option>
                    <option value='충남'>충청남도</option>
                    <option value='전북'>전라북도</option>
                    <option value='전남'>전라남도</option>
                    <option value='경북'>경상북도</option>
                    <option value='경남'>경상남도</option>
                    <option value='제주'>제주도</option>
                </select>&nbsp;
                <select name='gubun2'>
                    <option value=''>구/군</option>
                </select>
            </td>
                      
        </tr>
        <tr>         
            <td class=title width=10%>검색조건</td>
            <td width=40%>&nbsp;
                         
                <select name="gubun">
                            <option value="">전체</option>
                            <option value="emp_nm" >성명</option>
                            <option value="car_comp" >자동차회사</option>
                            <option value="car_off" >지점</option>
                            <option value="car_off_nm" >영업소명</option>
                            <option value="emp_m_tel" >핸드폰</option>
                            <option value="damdang_id" >담당자</option>
                  </select>
                &nbsp;
                <input type='text' name='gu_nm' size='18' class='text' value='' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            </td>
            <td class=title width=10%>지정사유</td>
            <td width=40%>&nbsp;
              <select name="cng_rsn">
                        <option value="">==전체==</option>
                        <option value="1" >1.최근계약</option>
                        <option value="2" >2.대면상담</option>
                        <option value="3" >3.전화상담</option>
                        <option value="4" >4.전산배정</option>
                        <option value="5" >5.기타</option>
                      </select> &nbsp;<input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
                      ~ 
                      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" > 
            </td>                     
              
        </tr>
    </table>
    <div style="text-align: right; margin-top: 2px"><img id="search-sales-button" src=/acar/images/center/button_search.gif align=absmiddle border=0></div>

     <div class="table-style-1"><img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">총 <span id="sales-result-count">0</span> 건 <button id="sales-search-check-all" onclick="salesCheckAll();" style="display: none;">전체선택</button></div>
    <table id="sales-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='800'>
        <tr><td class=line2></td></tr>
        <tr>
            <td width="5%" class='title'>선택</td>
            <td width='6%' class='title'>연번</td>
            <td width='17%' class='title'>소속사</td>  <!-- CAR_COMP_NM -->
            <td width='11%' class='title'>근무지역</td>
            <td width='8%' class='title'>근무처</td>
            <td width="8%" class='title'>성명</td>  <!-- EMP_NM -->
            <td width="15%" class='title'>핸드폰</td>  <!-- EMP_M_TEL -->
            <td width="10%" class='title'>담당자</td>
            <td width="10%" class='title'>지정사유</td>
            <td width="7%" class='title'>지정일</td>

        </tr>
            <tr class="sales-search-result" align='center'>
                <td colspan="10">검색된 데이타가 없습니다</td>
            </tr>
    </table>
   </div>
</div>    <!-- end search-area -->

</body>
<script src="https://apis.google.com/js/client.js?onload=load"></script>
<script>

</script>
</html>
