<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%

	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();

	// �α��� ����
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}

	// �˻� ����
    String gubun1 = request.getParameter("gubun1")==null?	"":request.getParameter("gubun1");	//�������
    String gubun2 = request.getParameter("gubun2")==null?	"":request.getParameter("gubun2");	//������� 
    String gubun3 = request.getParameter("gubun3")==null?	"":request.getParameter("gubun3");	//������� 
    String cng_rsn = request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
    String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
    
    String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

    String gubun4 = request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
    String gubun5 = request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");

    // jjlim@20171101 add auto select
    String category_1 = request.getParameter("cate") == null ? "" : request.getParameter("cate");
    String category_2 = request.getParameter("cate1") == null ? "" : request.getParameter("cate1");
    String templateCode = request.getParameter("t_cd") == null ? "" : request.getParameter("t_cd");
    String rentMngId = request.getParameter("mng_id")==null? "":request.getParameter("mng_id");
    String rentLCode = request.getParameter("l_cd")==null? "":request.getParameter("l_cd");
    String rentSt = request.getParameter("rent_st")==null? "":request.getParameter("rent_st");

    String searchType = request.getParameter("s_type") == null ? "" : request.getParameter("s_type");  // ??

	//TODO
	Hashtable fee_sum = af_db.getFeeScdDlySettleSum(rentMngId, rentLCode);
    int fee_all_sum = AddUtil.parseInt(String.valueOf(fee_sum.get("FEE_AMT")));
	
	//[��ະ]�뿩�����
	Hashtable fee_stat = af_db.getFeeScdStatPrint(rentMngId, rentLCode);
	int dly_tot_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT")));
	int dly_pay_amt = AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")));
	int total_amt 	= dly_tot_amt - dly_pay_amt;	
	int total_sum = fee_all_sum + total_amt;
	
    

    // ��������� ����Ʈ
    Vector users = at_db.getUserList("", "", "EMP", "Y");
    int user_size = users.size();

    

	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();	
	Vector CodeList = FineDocDb.getZipSido();	
	Vector CodeList2 = FineDocDb.getZipGugun(gubun1);	
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS - �˸��� �߼�</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
.logo_area {
	height: 60px;
	background-image: linear-gradient(#E8E8E8, #FCFCFC, #FFF);
}
.logo_img {
	margin-left: 20px;
}
.no-drag {
	-ms-user-select: none;
	-moz-user-select: -moz-none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	user-select:none;
}
.menu_table_top {
	border: 0px;
	padding: 0px;
	border-spacing: 0px;
}
.menu_table_top td {
	width: 100px;
	height: 40px;
	vertical-align: middle;
    text-align: center;
    background-color: #349BD5;
    cursor: pointer;
	line-height: 14pt;
	font-family: Nanum Square;
    color: #FFF;
	font-weight: bold;
}
.menu_table_top td:hover {
	background-color: #F6F6F6;
	color: #349BD5;
	font-weight: bold;
}
.menu_table_mid {
	border: 0px;
	padding: 0px;
	border-spacing: 0px;
}
.menu_table_mid td {
	width: 100px;
	height: 40px;
	vertical-align: middle;
    text-align: center;
    color: #FFF;
    background-color: #349BD5;
    cursor: pointer;
	line-height: 14pt;
	font-family: Nanum Square;
    color: #FFF;
	font-weight: bold;
}
.menu_table_mid td:hover {
	background-color: #F6F6F6;
	color: #349BD5;
	font-weight: bold;
}
.menu_table_sub {
	border: 0px;
	padding: 0px;
	border-spacing: 0px;	
}
.menu_table_sub td {
	width: 100px;
	height: 40px;
	vertical-align: middle;
    text-align: center;
    background-color: #349BD5;
    cursor: pointer;
	line-height: 14pt;
	font-family: Nanum Square;
    color: #FFF;
	font-weight: bold;
}
.menu_table_sub td:hover {
	background-color: #F6F6F6;
	color: #349BD5;
	font-weight: bold;
}
.template-list-up {
	/* width: 100%; */
	/* width: 350px; */
	height: 100%;
	min-width: 350px;
	/* max-width: 350px; */
	max-height: 450px;
	font-size: 12px;
	line-height: 30px;
	overflow: auto;
	white-space: nowrap;
	border: 1px solid #399ED6;
	border-radius: 5px;
	float: left;
}
.template_select {
	cursor: pointer;
	padding-left: 5px;
	padding-right: 5px;
}
.template_select:hover {
	background-color: #399ED6;
	/* font-weight: bold; */
	color: #FFF;
}
.top_active {
	background-color: #F6F6F6 !important;
	color: #349BD5 !important;
	font-weight: bold !important;
}
.mid_active {
	background-color: #F6F6F6 !important;
	color: #349BD5 !important;
	font-weight: bold !important;
}
.sub_active {
	background-color: #F6F6F6 !important;
	color: #349BD5 !important;
	font-weight: bold !important;
}
.list_active {
	background-color: #399ED6 !important;
	/* font-weight: bold !important; */
	color: #FFF !important;
}
.table-style-1 {
    font-family:����, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
    color: #515150;
    font-weight: bold;
}
.table-back-1 {
    background-color: #B0BAEC
}
.font-1 {
    font-family:����, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
    font-weight: bold;
}
.font-2 {
    font-family:����, Gulim, AppleGothic, Seoul, Arial;
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
    border: 1px solid #f5e000;
    box-sizing: border-box;
}
/* 
#talk_content_1{
	display: none;
}
#talk_content_2{
	display: none;
}
#talk_content_3{
	display: none;
} 
*/
#search-area {
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
        customer_name			: '����',
        customer_email			: '������',
        customer_fax				: '�� Fax ��ȣ',

        car_num						: '���� ��ȣ',
        p_car_num					: '�����ȣ',
        car_name					: '���� �̸�',
        car_amount				: '���� ����',
        rent_month					: '�̿�Ⱓ',
        
        car_num_name_arr				: '���� ��ȣ',	// �渶��Ź�������ȳ��� 2017.12.14
        car_num_name_arr_count		: '���� �̸�',	// �渶��Ź�������ȳ��� 2017.12.15

        company_branch		: '����',
        company_phone		: '��ȭ',
        zip_code				: '�����ȣ',
        company_addr			: '�ּ�',

        manager_name		: '����� �̸�',
        manager_grade		: '����� ����',
        manager_phone		: '����� ��ȭ',
        
        bus_manager_name		: '����� �̸�(����)',
        bus_manager_phone	: '����� ��ȭ(����)',

        esti_send_way		: '������ �߼�',
        esti_link					: '������ ��ũ',
        contract_no			: '��� ��ȣ',
        contract_turn			: '��� ȸ��',
        contract_supp			: '��� �غ�',
        visit_place				: '�湮 ���',
        visit_place_url			: '�൵',
        return_place			: '�ݳ� ���',
        car_e_date				: '���� �ݳ��� (��-��-��)',
        driver						: '������',
        driver2						: '�߰�������',

        dist						: '����Ÿ�',
        dist_fee					: '����Ÿ� �ʰ� ���',

        insurance_name		: '����� �̸�',
        insurance_phone		: '����� ��ȭ',
        insur_mng_name		: '����� ����� �̸�',
        insur_mng_grade		: '����� ����� ����',
        insur_mng_phone	: '����� ����� ��ȭ',
        insur_info_url			: '�������� URL',

        fee_count				: '�� �� (������ݰ���)',
        rent_fee					: '�� �뿩��',
        rent_fee_all			: '�뿩��',
        unpaid					: '�̳���',
        unpaid_interest		: '�̳�����',
        tot_mnt					: '�� ���Ա�',
        interest_rate			: '�뿩�� ��ü����',
        
        pay_place				: '����ó',		// ��� �뺸-���� ó������ 2017.12.15
        pay_contents			: '���⳻��',
        pay_amount			: '����ݾ�',
        
        payments_amount	: '���ޱݾ�',
        deduction_amount	: '�����ݾ�',
        cost_amount			: '�����ݾ�',

        rent_gubun				: '�뿩���� ��)���뿩���/����Ʈ',
        gubun1					: '����1',
        gubun2					: '����2',
        month					: '����',
        deposit_rate			: '������',
        distance					: '����Ÿ�',

        bank_name				: '���� �̸�',
        bank_account			: '���� ����',
        bank_full				: '���� �̸� �� ���� ����',
        
        before_day				: '������ ��',
        after_day				: '������ ��',
        p_days					: '�ϰ�',
        dist_increase			: '����Ÿ� ������',
        p_day_dist				: '1�� ����Ÿ�',
        p_year_dist			: '��ȯ�� ����Ÿ�',

        date							: '��¥ (��-��-��)',
        date_ymd					: '��¥ (�� �� ��)',
        update_date				: '��������',
        date_ymdhhmm			: '��¥ (�� �� �� �� ��)',
        cur_date						: '���� ��¥ (��-��-��(����))',
        cur_date_md				: '���� ��¥ (��/��)',
        cur_date_year				: '���� ��¥ (��)',
        cur_date_mon				: '���� ��¥ (��)',
        cur_date_day				: '���� ��¥ (��)',
        reg_date					: '���� ��¥ (�� �� ��)',
        car_take_date_mn		: '�μ� ��¥ (��/��)',
        contract_s_date			: '��� ������ (��-��-��)',
        contract_e_date			: '��� ������ (��-��-��)',
        contract_s_date_mn		: '��� ������ (��/��)',
        contract_e_date_mn	: '��� ������ (��/��)',
        contract_date_mn		: '��� ����� (��/��)',
        expiration_date			: '��ȿ ���� (�� �� �� ��)',
        last_date					: 'Ȯ�� ���� (�� �� �� ��)',

        sender_name				: '�߽���',
        deliver_no					: 'Ź�۹�ȣ',
        deliver_date				: 'Ź�� ��¥ (��/��)',
        deliver_hour				: 'Ź�� ��¥ (�ð�)',
        deliver_min					: 'Ź�� ��¥ (��)',
        deliver_ymdhhmm		: 'Ź�� ��¥ (�� �� �� �� ��)',
        deliver_company			: 'Ź�� ��ü��',
        deliver_name				: 'Ź�� ��� �̸�',
        deliver_phone				: 'Ź�� ��� ��ȭ',
        un_count					: '��Ȯ�� �Ǽ�',
        birth_gender				: '�������-���ڸ� ����',
        
        supplies_name			: '��ǰ ��ü��',
        
        auction_name				: '������',
        
        service_name				: '���� ��ü��',
        service_amount			: '���� �ݾ�',
        service_gubun				: '���񱸺�',
        service_contents			: '���� ����',
        speed_mate_url			: '���ǵ����Ʈ URL',
        any_car_url					: '�ִ�ī���� URL',
        mater_car_phone			: '�������ڵ�������',
        sk_net_phone				: 'SK��Ʈ����',
        
        URL							: '�뿩�� ������ǥ URL',
        
        car_mng_service_url		: '�ڵ����������� �ȳ���',
        
        blumembers_link			: '������� �ȳ���',
        
        sos_url						: '����⵿���� �ȳ�',
        accident_url				: '���ó������ �ȳ�',
        maint_url					: '�ڵ������� �ȳ�'
        
        
    }
   
    var gUserId = "<%= user_id %>";

    var gContent = "";
    var gContractList = [];
    var gContractInfo = {};

    var gUserList = [];
    var gSalesList = [];

    var templateCode = "<%= templateCode %>";
    var cate = "<%= category_1 %>";
    var cate2 = "<%= category_2 %>";
    var rentMsgId = "<%= rentMngId %>";     
    var rentLCode = "<%= rentLCode %>";
    var rentSt = "<%= rentSt %>";
    
    // �뿩�� ����
    <%-- var fee_all_sum = '<%=Util.parseDecimal(fee_all_sum)%>';
    var total_amt = '<%=Util.parseDecimal(total_amt)%>';
    var total_sum = '<%=Util.parseDecimal(total_sum)%>'; --%>
    var fee_all_sum = "<%=fee_all_sum%>";
    var total_amt = "<%=total_amt%>";
    var total_sum = "<%=total_sum%>";

    // 20190710 ���� google short url ���� ����� ��� �Ұ� -> bitly�� ��ü
    // ���� - get_short_bitly(url, apiKey_val, login_val)
    function load() {
        // ���� SHORT URL
        gapi.client.setApiKey('AIzaSyDTLDbQYFNKRuHhdqjLnz3WwUCvqpEyWMM');
        gapi.client.load('urlshortener', 'v1', function () {
        });
    }
    
$(document).ready(function(){
    
	// ���ø� ����
	$("#template-list-up").on("click", "div", function(e) {
		
		$(this).parent().find(".list_active").removeClass("list_active");
		$(this).addClass("list_active");
		
		var option = $(this);
		
		$("#talk_content_1").show();
		$("#talk_content_2").show();
		$("#talk_content_3").show();
	
		// �߽�/���� �ʱ�ȭ
		$("#org-name").show();
		$("#spe-org-name").empty().hide();
		$("#recipient_num").val("").show();
		$("#spe-recipient-name").empty().hide();
		$("#spe-recipient-direct").hide();
		$("#spe-recipient-cnt").hide();
		
		mMultiUser.length = 0;
		mMultiSales.length = 0;
	
		// �˻� ���� �ʱ�ȭ
		// clearSearch();
		
		// acar9999 : �����Է� (ģ����)
		// ��� ����
		if (option.attr("id") == "acar9999") {
		
			gContent = "";
		
			$("#alim-textarea").hide();
			$("#alim-textarea-w").show();
			$("#alim-textarea-w").val('');
			
			$("#template-field-area").empty();
			$("#template-field-area-outter").hide();
			$("#message-length").html("0");
			
			$("#search-area").hide();
		
		} else {
		
			$("#alim-textarea").show();
			$("#alim-textarea-w").hide();
			
			$("#template-field-area-outter").show();
		
			// ���ý� ������ ���̵��� �켱 ����
			if (option.attr("id") == "0") {
			    $("#search-area").hide();
			} else {
			    $("#search-area").show();
			}
		
			// r, n ����
			// var newLine = String.fromCharCode(13, 10);
			// var text = option.data('content').replace(/\\n/g, newLine);
			var text = option.data("content");
			
			// �۷ι��� ����
			gContent = text;
		
			if (text != undefined) {
			    var newLine = String.fromCharCode(13, 10);
			    text = text.replace(/\\n/g, newLine);
			
			    // �۷ι��� ����
			    gContent = text;
			
			    // ���ø� �ʵ� �߰�
			    addTemplateField(text);
			
			    // ���õ� ���ø� �����͸� �ؽ�Ʈ�ʵ忡 ����
			    reloadTemplateContent();
			}
		
			$("#org-name").val(gUserId).change();
			
			// auto select
			// �ڵ� ���� ���: �˻����� �����, ���˻�
			if (rentMsgId != "" && rentLCode != "") {
			    
			    // $('#search-area').hide();
			    ajaxGetContractInfo(rentMsgId, rentLCode);
			
			    // �˻��Ϸ� �� �ʱ�ȭ
			    // rentLCode = '';
			    // rentMsgId = '';
			}
		}
		
	});
    
    // �޴��̸��� ���� �˻����� �ϼ�
    function ajaxGetNewTemplateList(m_nm_top, m_nm_mid, m_nm_sub) {
		
    	var m_nm_text = "";
    	// ��ܸ޴�
    	if (!(m_nm_top == "" || m_nm_top == "undefined")) {
    		m_nm_text = "#"+m_nm_top;
    	}
    	// �ߴܸ޴�
    	if (!(m_nm_mid == "" || m_nm_mid == "undefined")) {
    		m_nm_text += "/"+m_nm_mid;
    	}
		// �ϴܸ޴�
    	if (!(m_nm_sub == "" || m_nm_sub == "undefined")) {
    		m_nm_text += "/"+m_nm_sub;
    	}
    	
        var data = {
            m_nm: encodeURIComponent(m_nm_text)
        };
        
        $.ajax({
            cache: false,
            type: 'GET',
            url: './alim_template_ajax.jsp',
            dataType: 'json',
            data: {
                cmd: 'new_list_only',
                data: JSON.stringify(data)
            },
            success: function(data) {
            	setTemplateNewList(data);
                
                // �Ķ���ͷ� ���ø� �ڵ尡 ���� �ڵ� ���� (�ѹ���)
                if (templateCode != "") {
                    templateCode = "";
                    // �Ķ���ͷ� L_CD�� ���� �ڵ� �˻� (�ѹ���)
                    if (rentLCode != "") {
                        $("#contract-search-area select[name=s_kd]").val(2);
                        $("#contract-search-area input[name=t_wd]").val(rentLCode);
                        $("#search-cont-button").trigger("click");
                     	// �˻��Ϸ� �� �����Ѵ��� �ʱ�ȭ
						// rentLCode = "";
                    }
                }
            },
            error: function(e) {
                alert("���ø� ����Ʈ�� �������� ���߽��ϴ�.");
            }
        });
    }
    
    function setTemplateNewList(data) {    	
    	$("#template-list-up").empty();
        data.forEach(function(tpl) {
        	html = 
            	"<div id='" + tpl.CODE + "' class='template_select no-drag' data-content='" + tpl.CONTENT + "'>" + 
            	tpl.NAME + "(" + tpl.CODE + ")" +
            	"</div>";
           	$("#template-list-up").append(html);      
        });
    }

    // �߽��� ����
    $("#org-name").on("change", function() {
        var selOpt = $(this).find(":selected");
		// �߽Ź�ȣ ����
		// $('#org-phone').val(selOpt.attr('data-phone'));

        // ���ø� �ʵ� ����
        $("#manager_name").val(selOpt.attr("data-name"));
        $("#manager_grade").val(selOpt.attr("data-grade"));
        $("#manager_phone").val(selOpt.attr("data-phone"));

        $("#company_branch").val(selOpt.attr("data-br-nm"));
        $("#company_addr").val(selOpt.attr("data-br-addr"));
        $("#company_phone").val(selOpt.attr("data-br-tel"));

		/* gUsers.forEach(function(value, index) {
			if (value.USER_ID == selOpt.val()) {
				alert('OK!');
			}
		}); */
        reloadTemplateContent();
    });

    // ������ ��ư Ŭ��
    $("#send-button").on("click", function() {
		        
		/* if ($('#org-phone').val() == '') {
			alert('�߽Ź�ȣ�� �Է����ּ���');
			return;
		} */
		if ($(".top_active").index() != 2) {
	        if (!$("#template-list-up div").hasClass("list_active")) {
	            alert('���ø��� �������ּ���');
	            return;
	        }
		}
        if ($('#org-name option:selected').attr('data-phone') == '' && $('#spe-org-name option:selected').attr('data-phone') == '') {
            alert('�߽Ź�ȣ�� �����ϴ�');
            return;
        }
        if ($("#recipient_num").val() == "" && $("#spe-recipient-name").css("display") == "none") {
            alert("���Ź�ȣ�� �Է����ּ���");
            return;
        }
        if ($("#alim-textarea-w").css("display") != "none" &&  $("#alim-textarea-w").val() == "") {
            alert("�޽����� �Է����ּ���");
            return;
        }

        var exitFlag = false;
        var fields = $("#template-field-area input");
        
        $.each(fields, function(index, value) {
            var val = $(value).val();
            if (val == "") {
                alert("���ø� �ʵ带 �Է����ּ���");
                exitFlag = true;
                return false;
            }
        });
        
        if (exitFlag == true) {
            return;
        }

        // ��Ƽ ����
        var multiFlag = false;
        var type = $("input[name=search-type]:checked");
        
        if ((type.val() == "user" && mMultiUser.length > 1) || (type.val() == "sales" && mMultiSales.length > 1)) {
            var result = confirm("�������� �����Ͻðڽ��ϱ�?");
            if (result == false) {
                return;
            }
            multiFlag = true;
        }

        // �±� ���� (br�� CRó��)
        var content = $("#alim-textarea").html();
        var newLine = String.fromCharCode(13, 10);
        content = content.replace(/<br>/g, newLine);

        // ��Ƽ ���� (customer_name) �ʵ�� ��ȯ���� �ȴ´� -> ���߿� ��������
        if (multiFlag) {
            content = content.replace(/<span id="0".*<\/span>/, '{customer_name}');
        }
        content = content.replace(/<[^>]*>/g, '');

        var userId = "";
        var callbackNum = "";
        if ($("#org-name").css("display") != "none") {
            userId = $("#org-name option:selected").attr("value");
            //callbackNum = $("#org-name option:selected").attr("data-phone");
            if ($("#org-name option:selected").attr("data-loan-st") == "") {
            	callbackNum = $("#org-name option:selected").attr("data-hot-tel");
            } else {            	
	            callbackNum = $("#org-name option:selected").attr("data-phone");
            }
        } else {
            userId = $("#spe-org-name option:selected").attr("val");
            //callbackNum = $("#spe-org-name option:selected").attr("data-phone");
            callbackNum = $("#spe-org-name option:selected").attr("data-phone");
            if ($("#spe-org-name option:selected").attr("data-loan-st") == "") {
            	callbackNum = $("#spe-org-name option:selected").attr("data-hot-tel");
            } else {            	
            	callbackNum = $("#spe-org-name option:selected").attr("data-phone");
            }
        }

        var recipentNum = "";
        if ($("#spe-recipient-name").css("display") == "none") {
            recipentNum = $("#recipient_num").val();
        } else {
            recipentNum = $("#spe-recipient-name option:selected").attr("data-phone");
        }
        
        // �˸���: ���ø��ڵ�, ģ����(�����Է�): 0
        var templateCode = $(".list_active").attr("id");
        if ($(".top_active").index() == 2) {
        	templateCode = "0";
        }

        // �˸���: 1008, ģ����(�����Է�): 1009
        var msgType = "1008";
        if ($(".top_active").index() == 2) {
            msgType = "1009";
            content = $("#alim-textarea-w").val();
        }

		//���������� ģ��������  
		if ($(".list_active").attr("id") == "acar0055" || $(".list_active").attr("id") == "acar0069" || $(".list_active").attr("id") == "acar0209") {
		    msgType = "1009";
		}
		
        var sendData = {
            /* "template_code": $(".list_active").attr("id"), */
            "template_code": templateCode,
            "content": encodeURIComponent(content),
            "callback_num": callbackNum,
            "recipient_num": recipentNum,
            "msg_type": msgType,
            "l_cd": rentLCode,
            "user_id": userId
        }

        if (multiFlag) {
            var users = []
            if (type.val() == "user") {
                users = mMultiUser;
            } else if (type.val() == "sales") {
                users = mMultiSales;
            }

			// var multiName = [];
			// var multiNum = [];
            var multi = [];
            users.forEach(function(value, index, array) {
                var multiObj = {
                    name: encodeURIComponent(value.name),
                    num: value.phone
                };
                multi.push(multiObj);
				// multiName.push(value.name);
				// multiNum.push(value.phone);
            });

            sendData['multi'] = multi;
			// sendData['multi_name'] = multiName;
			// sendData['multi_num'] = multiNum;
        }
		// TODO CHECK ������ �Ķ����
		// alert("template_code: " + sendData.template_code + " callback: " + sendData.callback_num + " recipient: " + sendData.recipient_num + " msg_type: " + sendData.msg_type);
		// return;

        $.ajax({
            cache: false,
            type: 'POST',
            url: './alim_talk_ajax.jsp',
            dataType: 'json',
            data: {
				// data: sendData
                cmd: 'send_msg',
                data: JSON.stringify(sendData)
            },
            success: function(data) {
                alert('�޽����� �����߽��ϴ�');
            },
            error: function(e) {
                alert('�޽��� ���ۿ� �����߽��ϴ�');
            }
        })
    });

    // ���˻� ��ư Ŭ��
    $("#search-cont-button").on("click", function() {

		var data = {
		    s_kd: $("#contract-search-area select[name=s_kd] option:selected").val(),
		    t_wd: encodeURIComponent($("#contract-search-area input[name=t_wd]").val()),
		    andor: "",
		    gubun4: $("#contract-search-area select[name=gubun4] option:selected").val(),
		    gubun5: $("#contract-search-area select[name=gubun5] option:selected").val(),
		    st_dt: $("#contract-search-area input[name=st_dt]").val(),
		    end_dt: $("#contract-search-area input[name=end_dt]").val(),
		}

        // ���˻� �Ķ����
        $.ajax({
            type: "POST",
            url: "./alim_talk_ajax.jsp",
            dataType: "json",
            data: {
                cmd: "search_cont",
                data: JSON.stringify(data)
            },
            beforeSend: function() {
              $("#contract-search-loader").show();
            },
            success: function(data) {
                $("#contract-search-loader").hide();
                gContractList = data;
                makeContractTable(data);
            },
            error: function(e) {
                $("#contract-search-loader").hide();
                alert("�˻� ����");
            }
        })

    });

    // ���� �˻� ��ư Ŭ��
    $("#search-user-button").on("click", function() {
        var cond = {
            s_kd: $("#user-search-area select[name=s_kd] option:selected").val()
        }
        ajaxSearchUser(cond);
    });

    // ������� �˻� ��ư Ŭ��
    $("#search-sales-button").on("click", function() {

        var a1 = $('#sales-search-area select[name=gubun] option:selected').val();
        var a2 = $('#sales-search-area select[name=cng_rsn] option:selected').val();
        if (a1 == "" && a2 == "") {
            var a3 = $('#sales-search-area select[name=gubun1] option:selected').val();
            var a4 = $('#sales-search-area select[name=gubun2] option:selected').val();
            var a5 = $('#sales-search-area select[name=gubun3] option:selected').val();

            if (a3 == "" || a4 == "" || a5 == "") {
                alert("�Ҽӻ�, �ٹ������� �������ּ���");
                return;
            }
        }

        var data = {
            gubun3: $('#sales-search-area select[name=gubun3] option:selected').val(),
            gubun1: encodeURIComponent($('#sales-search-area select[name=gubun1] option:selected').val()),
            gubun2: encodeURIComponent($('#sales-search-area select[name=gubun2] option:selected').val()),
            gubun: $('#sales-search-area select[name=gubun] option:selected').val(),
            gu_nm: encodeURIComponent($('#sales-search-area input[name=gu_nm]').val()),
            cng_rsn: $('#sales-search-area select[name=cng_rsn] option:selected').val(),
            st_dt: $('#sales-search-area input[name=st_dt]').val(),
            end_dt: $('#sales-search-area input[name=end_dt]').val()
        }
        
        // ���˻� �Ķ����
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
                $("#sales-search-loader").show();
            },
            success: function(data) {
                $("#sales-search-loader").hide();
                gSalesList = data;
                makeSalesTable(data);
            },
            error: function(e) {
                $('#sales-search-loader').hide();
                alert('�˻� ����');
            }
        })
    });

    // �����Է½� �޽��� ���� üũ
    $('#alim-textarea-w').on('keyup', function() {
        $('#message-length').html($('#alim-textarea-w').val().length);
    });

    // īī�� �˸��� ���ø� ����
    $('#manage-template').on('click', function() {
        var SUBWIN="/acar/kakao/alim_template.jsp";
        window.open(SUBWIN, "MngKakaoAlimTemplate", "left=10, top=10, width=950, height=850, scrollbars=yes");
    });

    // ������ �����Է� üũ��
    $('#spe-recipient-direct input[type=checkbox]').on('change', function() {
        if ($(this).is(':checked')) {
            $('#recipient_num').show();
            $('#spe-recipient-name').hide();
        } else {
            $('#recipient_num').hide();
            $('#spe-recipient-name').show();
        }
    });

    // �˻� Ÿ�� ����
    $('input[name=search-type]').on('change', function() {
        // ������ �ʱ�ȭ
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

 	// �޴� ����Ʈȭ - �ߴ� �޴�����	
	var mid = new Array();
	mid[0] = new Array("���뿩", "����Ʈ", "���¾�ü", "���ݾȳ�");
	mid[1] = new Array("�������", "�뿩����", "����ȳ�", "�������", "��ü�ȳ�", "����ȳ�", "�������", "����˻�", "����ȳ�", "Ź��", "�����ȳ�");
	
	var sub = new Array();
	sub[0] = new Array("�������", "�뿩����", "����ȳ�", "�������", "��ü�ȳ�", "����˻�", "����ȳ�", "�����ȳ�");
	sub[1] = new Array("�������", "�뿩����", "����ȳ�", "�������", "��ü�ȳ�", "����ȳ�", "�������", "����˻�", "����ȳ�", "�����ȳ�");
	sub[2] = new Array("����˻�", "Ź��");
	sub[3] = new Array();
	sub[4] = new Array();
	
	//�ߴܸ޴� ��������
	function create_mid(idx) {
		$("#item_mid").empty();
		for (var i = 0; i < mid[idx].length; i++) {
			$("#item_mid").append("<td class='no-drag'>"+ mid[idx][i] +"</td>");
		}		
		return mid[idx].length;
	}
	
	//�ϴܸ޴� ��������
	function create_sub(idx) {
		$("#item_sub").empty();
		for (var i = 0; i < sub[idx].length; i++) {
			$("#item_sub").append("<td class='no-drag'>"+ sub[idx][i] +"</td>");
		}		
		return sub[idx].length;
	}
	
	//��ܸ޴� Ŭ����
	$(".menu_table_top tr").on("click", "td", function(e){
		$(this).closest("tr").find(".top_active").removeClass("top_active");
		$(this).addClass("top_active");
		if ($(this).hasClass("top_active")) {
			var idx = $(".top_active").index();
			// ģ���� Ŭ����
			if (idx == 2) {
				$("#start_mid").hide();
				$("#start_sub").hide();
				
				// ���ø� ��� �ʱ�ȭ
				$("#template-list-up").empty();
				
				// �߽�/���� �ʱ�ȭ
	            $("#org-name").show();
	            $("#spe-org-name").empty().hide();
	            $("#recipient_num").val("").show();
	            $("#spe-recipient-name").empty().hide();
	            $("#spe-recipient-direct").hide();
	            $("#spe-recipient-cnt").hide();

	            mMultiUser.length = 0;
	            mMultiSales.length = 0;

	            // �˻� ���� �ʱ�ȭ
	            clearSearch();
	            
	            gContent = "";
	            
	            $("#alim-textarea").hide();
	            $("#alim-textarea").empty();
	            $("#alim-textarea-w").show();
	            $("#alim-textarea-w").val("");

	            $("#template-field-area").empty();
	            $("#template-field-area-outter").hide();
	            $("#message-length").html("0");

	       		// $('#search-area').hide();
	            $("#search-area").show();
	            
	         	// �˻��Ϸ� �� �ʱ�ȭ
			    rentLCode = "";
			    rentMsgId = "";
	            
			} else {				
				var create_count = create_mid(idx);
				$("#start_mid").show();
				$("#start_sub").hide();
				ajaxGetNewTemplateList($(".top_active").text(), "", "");
			}
			
			// �˻� ���� �ʱ�ȭ
            clearSearch();
			$("#alim-textarea").empty();
			$("#alim-textarea-w").val("");
			$("#template-field-area").empty();
		}		
	});
	
	//�ߴܸ޴� Ŭ����
	$(".menu_table_mid tr").on("click", "td", function(e){
		$(this).closest("tr").find(".mid_active").removeClass("mid_active");
		$(this).addClass("mid_active");
		if ($(this).hasClass("mid_active")) {
			var top_idx = $(".top_active").index();
			var idx = $(".mid_active").index();
			if (top_idx == 0) {
				var create_count = create_sub(idx);
				if (create_count > 0) {
					$("#start_sub").show();
				} else {
					$("#start_sub").hide();	
				}
			} else {
				$("#start_sub").hide();
			}			
		}
		ajaxGetNewTemplateList($(".top_active").text(), $(".mid_active").text(), "");
		
		// �˻� ���� �ʱ�ȭ
        clearSearch();
		$("#alim-textarea").empty();
		$("#alim-textarea-w").val("");
		$("#template-field-area").empty();
	});
	
	//�ϴܸ޴� Ŭ����
	$(".menu_table_sub tr").on("click", "td", function(e){
		$(this).closest("tr").find(".sub_active").removeClass("sub_active");
		$(this).addClass("sub_active");
		ajaxGetNewTemplateList($(".top_active").text(), $(".mid_active").text(), $(".sub_active").text());
		
		// �˻� ���� �ʱ�ȭ
        clearSearch();
		$("#alim-textarea").empty();
		$("#alim-textarea-w").val("");
		$("#template-field-area").empty();
	});

})

// �ʵ� �߰�
function addTemplateField(text) {

    $('#template-field-area').empty();

    // ���Խ����� �ʵ� ã��
    var reg = /\#\{.*?\}/g;

    var matchs = text.match(reg);
    if (matchs == null) {
        return;
    }
    
    var templateFields = matchs.map(function(val) {
        return val.slice(2, -1);
    });

    // �ߺ� ����
    templateFields = templateFields.filter(function(item, pos) {
       return templateFields.indexOf(item) == pos;
    });

    // �ʵ� �߰�
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

    // �ʵ庰 ���
    addSpecificField();
}

// �ʵ庰 ���
function addSpecificField() {
    var fields = $('#template-field-area input');
    $.each(fields, function(index, value) {

        var date = new Date();
        var week = new Array("��", "��", "ȭ", "��", "��", "��", "��");
        var cur_year = date.getFullYear();
        var cur_month = date.getMonth() + 1;
        if (Number(cur_month) < 10) {
        	cur_month = "0"+cur_month;
        }
        var cur_day = date.getDate();
        if (Number(cur_day) < 10) {
        	cur_day = "0"+cur_day;
        }
        if (value.id == 'last_date') {
            $(value).val(cur_year + "�� " + cur_month + "�� " + cur_day + "��");
        }        
        if (value.id == 'reg_date') {
            $(value).val(cur_year + "�� " + cur_month + "�� " + cur_day + "��");
        }        
        if (value.id == 'date_ymd') {
            $(value).val(cur_year + "�� " + cur_month + "�� " + cur_day + "��");
        }        
        if (value.id == 'update_date') {
            $(value).val(cur_year + "�� " + cur_month + "�� " + cur_day + "��");
        }
        if (value.id == 'cur_date_md') {
            $(value).val(cur_month + "/" + cur_day + "");
            
        } else if (value.id == 'cur_date_year') {
            $(value).val(cur_year + "");
            
        } else if (value.id == 'cur_date_mon') {
            $(value).val(cur_month + "");
            
        } else if (value.id == 'cur_date_day') {
            $(value).val(cur_day + "");
            
        } else if (value.id == 'cur_date') {
			var fullDate = cur_year + "-" + cur_month + "-" + cur_day + "("+ week[date.getDay()] +")";
        	$(value).val(fullDate);
        	
        } else if (value.id == 'rent_fee_all') {
        	$(value).val(fee_all_sum);
        	
        } else if (value.id == 'interest_rate') {
        	$(value).val('24%');
        	
        } else if (value.id == 'unpaid_interest') {
        	$(value).val(total_amt);
        	
        } else if (value.id == 'tot_mnt') {
        	$(value).val(total_sum);
        	
        } else if (value.id == 'car_e_date') {
        	$(value).val(cur_year + "-" + cur_month + "-" + cur_day);
        	
        // �湮���
        } else if (value.id == 'visit_place') {
            var area = $(value).parent();
            area.empty();

            var html =
                '<select id="visit_place" class="width-3">' +
                    '<option value="" disabled selected>����</option>' +
           			<!-- '<option value="1" data-place="����� ��õ�� �� 914-5 �Ѹ��� ���� ������(�������Ա� ���� 20m)\nTEL: 02-6263-6378" data-url="http://fms1.amazoncar.co.kr/acar/images/center/yd.jpg">����� ��õ��</option>' + -->
                    '<option value="2" data-place="����� �������� �������� 34�� 9 ������ ����������\nTEL: 02-6263-6378" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_s_youngnam.jpg">����� ��������</option>' +
                    '<option value="3" data-place="�λ�� ������ �ݼ۷� 69 �λ����� ����Ʈ���� 3��\nTEL: 051-851-0606" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_p_hite.jpg">�λ�� ������ �ݼ۷�</option>' +
                    '<option value="4" data-place="�λ�� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵�������\nTEL: 051-851-0606" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_p_wellmade.jpg">�λ�� ������ ����õ��</option>' +
                    <!-- '<option value="5" data-place="������ ����� ��ź���� 319 ��ȣ�ڵ��������� 2��\nTEL: 042-824-1770" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_dj_kh.jpg">������ ����� ��ź����</option>' + -->
                    '<option value="6" data-place="������ ����� ���ɱ� 100 (��)����ī��ũ 2��\nTEL: 042-824-1770" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_dj_hd.jpg">������ ����� ���ɱ�</option>' +
                    '<option value="7" data-place="�뱸�� �޼��� �޼����109�� 58 (��)��������������\nTEL: 053-582-2998" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_dg_hd.jpg">�뱸�� �޼���</option>' +
                    '<option value="8" data-place="���ֽ� ���� �󹫴����� 131-1 ��1���ڵ���������\nTEL: 062-385-0133" data-url="http://fms1.amazoncar.co.kr/acar/images/center/map_k_sm.jpg">���ֽ� ����</option>' +
                '</select>'
            area.append(html);

            $("#visit_place").on("change", function() {
                reloadTemplateContent();
            });
            
        // ���湮�� �غ�
        } else if (value.id == "contract_supp") {
            var area = $(value).parent();
            area.empty();

            var html =
                '<select id="contract_supp" class="width-3">' +
                '<option value="" disabled selected>����</option>' +
                '<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������">�Ϲݰ���/���ι湮/���θ� ����</option>' +
                '<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, �߰�������(�����) ������ �纻, �������� ������">�Ϲݰ���/���ι湮/�߰�������(�����) �ִ°��</option>' +
                '<option value="" disabled>---</option>' +
                '<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, ����� �纻">���λ����/���ι湮/���θ� ����</option>' +
                '<option value="���θ��� �ſ�ī��(üũī�� �Ұ�), ����������, ����� �纻, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">���λ����/���ι湮/�߰������� �ִ°��</option>' +
                '<option value="���λ���� ���� �ſ�ī��(üũī��� �Ұ�), �����(���λ����) ���������� �纻, ����� �纻, ������ [�ǰ����� �ڰ�Ȯ�μ�], ������ ������">���λ����/�����湮/����� ������ ���� �������</option>' +
                '<option value="" disabled>---</option>' +
                '<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ��ǥ�� ����ī�� [üũī�� �Ұ�], ��ǥ�̻� ����������, ����� �纻">����/��ǥ�ڹ湮/���θ� ����</option>' +
                '<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ��ǥ�� ����ī�� [üũī�� �Ұ�], ��ǥ�̻� ����������, ����� �纻, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">����/��ǥ�ڹ湮/�߰������� �ִ°��</option>' +
                '<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ���� ������ ����ī�� [üũī�� �Ұ�], ����� �纻, �湮�� [�ǰ����� �ڰ�Ȯ�μ�], �湮�� ����������">����/�����湮/�湮�ڸ� ����</option>' +
                '<option value="���� ����ī��(ī�忡 �̿��� ���� �̸��� �����ִ� ����ī��) �Ǵ� ���� ������ ����ī�� [üũī�� �Ұ�], ����� �纻, �湮�� [�ǰ����� �ڰ�Ȯ�μ�], �湮�� ����������, �߰������� [�ǰ����� �ڰ�Ȯ�μ�], �߰������� �������纻">����/�����湮/�߰������� �ִ°��</option>' +
                '</select>'
            area.append(html);

            $("#contract_supp").on("change", function() {
                reloadTemplateContent();
            });
		
        // �����Ź�������ȳ� ���� ���� ��ȣ, ���� �̸� ������ �ֱ�		2017.12.15
        } else if (value.id == "car_num_name_arr") {
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

            $("#car_num_name_arr").on("change", function() {
                reloadTemplateContent();
            });
            
            $("#car_num_name_arr_count").on("change", function() {
                reloadTemplateContent();
            });
            
        // ����Ÿ�ڵ������� ��ȭ��ȣ default ����		2017.12.15
        } else if(value.id == "mater_car_phone"){
			//$(value).val("����Ÿ�ڵ�������(1588-6688)");
			$(value).val("1588-6688");
		} else if (value.id == "sk_net_phone") {
			$(value).val("1670-5494");
		}

    });
}

// �����Ź�������ȳ� ���� ȭ�� set ó�� �Լ� 2017.12.15
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
	var display_slice = display.slice(0, -1);	// ������ ���� ����	
	$("#car_num_name_arr").val(display_slice).trigger("change");
	$("#car_num_name_arr_count").val(car_num_arr.length).trigger("change");
}

// �����Ź�������ȳ� ���� �̺�Ʈ 2017.12.15
$(document).on("change", "input[name='car_name_arr']",function(){
	car_num_name_arr_event();
});

// ����Ϸ�(Ȩ������) �ȳ��� 2017.12.15
$(document).on("change", "input[id='expiration_date']",function() {
	var preValue = $(this).val();
	if (preValue.indexOf("��") >= 0) {
	} else {
		var splitValue = preValue.split(' ');
		for (var i=0; i<splitValue.length; i++) {
			if (i == 0) {
				preValue = splitValue[i];	
				preValue += '�� ';
			} else if (i == 1) {
				preValue += splitValue[i];
				preValue += '�� ';
			} else if (i == 2) {
				preValue += splitValue[i];
				preValue += '�� ';
			} else if (i == 3) {
				preValue += splitValue[i];
				preValue += '��';
			}	
		}
		$("#expiration_date").val(preValue).trigger("change");
	}	
});
	
// �����Ź�������ȳ� ���� row �߰� 2017.12.14
function addRow() {
	var html = '<div style="border:1px solid gold;width:330px;">'+
						'- ���� ��ȣ<br/><input type="text" name="car_num_arr" style="width:300px;"><br/>'+
						'- ���� �̸�<br/><input type="text" name="car_name_arr" style="width:300px;"><input type="button" value="��" onclick="removeRow($(this))">'+
					'</div>';
	
	var area = $("#car_name_arr").parent();
	area.append(html);
}

// �����Ź�������ȳ� ���� row ���� 2017.12.14
function removeRow(param) {
	var area = param.parent();
	area.remove();
	car_num_name_arr_event();
}

// ���ø� �ʵ� �ؽ�Ʈ ����
function reloadTemplateContent() {

    if (gContent == undefined) {
        return;
    }

    var reg = /\#\{(.*?)\}/g;
    var emp = '<span style="color: blue">$1</span>';
    var idx = 1;
    var searchFields = {};

    // ���ø� �ʵ尪 ������
    var fields = $("#template-field-area input");
    $.each(fields, function(index, value) {
        var val = $(value).val();
        if (val != "") {
            searchFields[value.id] = val;
        }
    });

    var selects = $("#template-field-area select");
    $.each(selects, function(index, value) {

        // �湮���
        if (value.id == "visit_place") {
            var place = $(value).find("option:selected").data("place");
            searchFields[value.id] = place;

            var field_url = $("#visit_place_url");
            if (field_url != undefined) {
                var url = $(value).find("option:selected").data("url");
                if (url != undefined) {
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
                    field_url.val("");
                }
            }
        } else if (value.id == "contract_supp") {
            var supp = $(value).find("option:selected").val();
            searchFields[value.id] = supp;
        }
    });

    // ������ �ʵ� ã��
    var empText = gContent.replace(reg, function(match, p1, offset) {

        var val = searchFields[p1];
        if (val == undefined || val == "") {
            val = p1;
        }
        // ���̸��� ��Ƽ �����Ҽ� �ֱ� ������ id = 0 ���� ����
        if (p1 == "customer_name") {
            return '<span id="0" style="color: blue">' + val + '</span>';
            
        // �൵�� �ٽ��ѹ� ó���ؾ� �ϱ� ������ 99 �� ����
        } else if (p1 == "visit_place_url") {
            return '<span id="99" style="color: blue">' + val + '</span>';
            
        } else {
            return '<span id="' + idx++ + '" style="color: blue">' + val + '</span>';
        }
    });

    // ����ó��
    empText = empText.replace(/\r?\n/g,'<br>');

    $("#alim-textarea").html(empText);

    // �޽��� ���� üũ
	// alert($('#alim-textarea').html().length);
    if (gContent == "") {
        $("#message-length").html($("#alim-textarea-w").val().length);
    } else {
        $("#message-length").html($("#alim-textarea").html().length);
    }
}

function reloadTemplateContentUrl() {
    // URL ���ø� �ʵ尪 ������
    var field = $("#visit_place_url").val();
    var textarea = $("#alim-textarea").html();
    $("#alim-textarea").html(textarea.replace(/(<span id="99".*>).*(<\/span>)/, '$1' + field + '$2'));
	// content = content.replace(/(<span id="99".*>).*(<\/span>)/, '$1' + field + '$2');
}

// ��� �˻� ��� ���̺� ����
function makeContractTable(datum) {
    var area = $("#contract-search-result-table");

    area.find(".contract-search-result").remove();

    var html = "";
    if (datum.length == 0) {
        html = '<tr class="contract-search-result" align="center"><td colspan="10">�˻��� �����Ͱ� �����ϴ�</td></tr>';
        $("#contract-result-count").html("0");
        
    } else {
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
    $("#contract-result-count").html(datum.length);

    // Ŭ���� ���ø� �ʵ带 ä��
    var rows = $("#contract-search-area input[type=radio]");
    rows.bind("click", function() {

        var idx = $(this).parent().parent().index() - 2; // tr > td > input
        var contract = gContractList[idx];
		// var contract = gContractList[$(this).index() - 2];

        // ������������ �־��� 2017.11.07
        rentLCode = contract.RENT_L_CD;
        rentMsgId = contract.RENT_MNG_ID;

        // ��� ���� ������
        var data = {
            m_id: contract.RENT_MNG_ID,
            l_cd: contract.RENT_L_CD,
            more_info: true //��࿡�� �ٷ� ������ ��� ����Ʈ�˻� ������ ���⶧���� �� ������ 2017.11.16
        }

        $.ajax({
        	cache: false,
            type: "POST",
            url: "./alim_talk_ajax.jsp",
            dataType: "json",
            data: {
                cmd: "cont_info",
                data: JSON.stringify(data)
            },
            success: function(data) {
                gContractInfo = data;
                //setContractField(contract);
                setContractField(gContractInfo);
            },
            error: function(e) {
                alert("����");
            }
        })
    });
}

// ��� ���ý� �ʵ� ä��
function setContractField(selectedContract) {

    // �߽���
    $("#org-name").hide();
    $("#spe-org-name").show();

    var org = $("#spe-org-name").empty();

    var users = gContractInfo.users;
    users.forEach(function(user, index) {
        var html = "";
        
        if (user.LOAN_ST == "") {
	        html = '<option val="'+ user.USER_ID +'" data-name="'+ user.USER_NM +'" data-phone="'+ user.HOT_TEL +'">' +
	            		user.USER_NM + " (" + user.HOT_TEL + ")" +
	           		'</option>';
        } else {
	        html = '<option val="'+ user.USER_ID +'" data-name="'+ user.USER_NM +'" data-phone="'+ user.USER_M_TEL +'">' +
			    		user.USER_NM + " (" + user.USER_M_TEL + ")" +
			   		'</option>';
        }
        
        if (users.length == index + 1) {        	
        	if (user.LOAN_ST == "") {        		
	            html =
	                '<option val="'+ user.USER_ID +'" data-name="'+ user.USER_NM +'" data-phone="'+ user.HOT_TEL +'" selected>' +
	                user.USER_NM + " (" + user.HOT_TEL + ")" +
	                '</option>';
        	} else {        		
	            html =
	                '<option val="'+ user.USER_ID +'" data-name="'+ user.USER_NM +'" data-phone="'+ user.USER_M_TEL +'" selected>' +
	                user.USER_NM + " (" + user.USER_M_TEL + ")" +
	                '</option>';
        	}        	
        }
        org.append(html);
    });

    // �߽��� ���� -> ����� �̸�, ��ȭ
    org.bind("change", function() {
        var selOpt = $(this).find(":selected");
        $("input#manager_name").val(selOpt.attr("data-name"));
        $("input#manager_phone").val(selOpt.attr("data-phone"));
        reloadTemplateContent();
    }).change();

    // ������
    $("#recipient_num").hide();
    $("#spe-recipient-name").show();
    $("#spe-recipient-direct").show().css("display", "inline");
    $("#spe-recipient-direct input[type=checkbox]").prop("checked", false);

    var term = $("#spe-recipient-name").empty();

    var clnts = gContractInfo.clnts;
    clnts.forEach(function(elem, index) {
        var html =
            '<option val="'+ (index + 1) +'" data-name="'+ elem.USER_NM +'" data-phone="'+ elem.USER_M_TEL +'">' +
                elem.USER_DESC + " " + elem.USER_NM + " (" + elem.USER_M_TEL + ")" +
            '</option>';
        term.append(html);
    });

    // ������ ���� -> �� ?
    term.bind("change", function() {
        var selOpt = $(this).find(":selected");
        $("input#customer_name").val(selOpt.attr("data-name"));
        reloadTemplateContent();
    }).change();

    // ���� �ʵ�
    var insur = gContractInfo.insur;
    if ($("#template-list-up").find(".list_active").attr("id") == "acar0231") {
    	$("input#insurance_name").val(insur.INS_NM + "("+insur.INS_TEL+")");
    } else {
    	$("input#insurance_name").val(insur.INS_NM);
    }
    $("input#insurance_phone").val(insur.INS_TEL);
    $("input#insur_mng_name").val(insur.INS_MNG_NM);
    $("input#insur_mng_phone").val(insur.INS_MNG_TEL);

    // ����
    $("input#car_name").val(selectedContract.CAR_NM);
    $("input#car_num").val(selectedContract.CAR_NO);
    $('input#p_car_num').val(selectedContract.CAR_NUM);
    $('input#rent_month').val(selectedContract.MONTH);
    
    $("input#contract_s_date").val(selectedContract.RENT_START_DT);
    $("input#contract_e_date").val(selectedContract.RENT_END_DT);
    
    // �����(����)
    $("input#bus_manager_name").val(selectedContract.BUS_NM);
    $("input#bus_manager_phone").val(selectedContract.BUS_M_TEL);
    
    // �뿩���þȳ� ����url
    var rent_st = selectedContract.RENT_ST;
    var result_rent_st = "";
    if (rent_st == "�ű�") {
    	result_rent_st = "1";
    } else if (rent_st == "����") {
    	result_rent_st = "2";
    } else if (rent_st == "����") {
    	result_rent_st = "3";
    } else if (rent_st == "����") {
    	result_rent_st = "4";
    } else if (rent_st == "����") {
    	result_rent_st = "5";
    } else if (rent_st == "�縮��") {
    	result_rent_st = "6";
    } else {
    	result_rent_st = "7";
    }
        
    var date = new Date();
    var day = Number(date.getDate());
    
    var apiKey_val = "";
    var login_val = "";
    var long_url = "http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id=" + rentMsgId + "&l_cd=" + rentLCode + "&rent_st=" + rentSt;
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
	            $("input#URL").val(response.data.url);
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
	
    reloadTemplateContent();
    $(window).scrollTop(0);
}


// ������� �˻� ��� ���̺� ����
function makeSalesTable(data) {
    var area = $("#sales-search-result-table");
    area.find(".sales-search-result").remove();

    var html = "";
    
    if (data.length == 0) {
        html = '<tr class="sales-search-result" align="center"><td colspan="10">�˻��� �����Ͱ� �����ϴ�</td></tr>';
        $("#sales-result-count").html("0");
        $("#sales-search-check-all").hide();
        
    } else {
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
        $("#sales-search-check-all").show();
    }
    
    area.append(html);
    $("#sales-result-count").html(data.length);

    // Ŭ���� ���ø� �ʵ带 ä��
    var rows = $("#sales-search-area input[type=checkbox]");
    rows.bind("click", function() {

        var idx = $(this).parent().parent().index() - 2;   // tr > td > input
        var sales = gSalesList[idx];

        if ($(this).prop("checked")) {
            // ������ �߰�
            var multiSales = new User(sales.EMP_NM, '', sales.EMP_M_TEL);
            mMultiSales.push(multiSales);
            setSalesField(sales);
            
        } else {
            // ������ ����
            mMultiSales = mMultiSales.filter(function(item) {
                return item.name != sales.EMP_NM;
            });
            setSalesField(sales);
        }
    });
}

// ������� ������ �ʵ� ä��
function setSalesField(sales) {

    // ������
    $("#recipient_num").hide();
    $("#spe-recipient-name").show();
    $("#spe-recipient-direct").hide();
	// $('#spe-recipient-direct').show().css('display', 'inline');
    $("#spe-recipient-direct input[type=checkbox]").prop("checked", false);
    $("#spe-recipient-cnt").hide();

    if (mMultiSales.length == 0) {
        $("#recipient_num").show();
        $("#spe-recipient-name").hide();
        $("#spe-recipient-direct").hide();
        $("#spe-recipient-direct input[type=checkbox]").prop("checked", false);
        $("#spe-recipient-cnt").hide();

        $("#spe-recipient-name").empty();
        $("input#customer_name").val("");
        reloadTemplateContent();

    } else if (mMultiSales.length == 1) {
        var term = $("#spe-recipient-name").empty();
        var html =
            '<option val="'+ "1" +'" data-name="'+ sales.EMP_NM +'" data-phone="'+ sales.EMP_M_TEL +'">' +
            sales.EMP_NM + " (" + sales.EMP_M_TEL + ")" +
            '</option>';
        term.append(html);

        // ������ ���� -> �� ?
        term.bind("change", function() {
            var selOpt = $(this).find(":selected");
            $("input#customer_name").val(selOpt.attr("data-name"));
            reloadTemplateContent();
        }).change();

        reloadTemplateContent();
        $(window).scrollTop(0);
        
    } else {
        $("#spe-recipient-cnt").html(mMultiSales.length + "�� ����");
        $("#spe-recipient-cnt").show().css("display", "inline");
    }
}


// ajax ����� �˻�
function ajaxSearchUser(cond) {
    $.ajax({
		cache: false,
        type: "POST",
        url: "./alim_talk_ajax.jsp",
        dataType: "json",
        data: {
            cmd: "search_user",
            data: JSON.stringify(cond)
        },
        beforeSend: function() {
            $("#user-search-loader").show();
        },
        success: function(data) {
            $("#user-search-loader").hide();
            gUserList = data.filter(function(elem) {
                return elem.ID != "";
            });
            addUserTable(gUserList);
        },
        error: function(e) {
            $("#user-search-loader").hide();
            alert("�˻� ����");
        }
    })
}

// ����� ���̺� ����
function addUserTable(data) {
    var area = $("#user-search-result-table");

    area.find(".user-search-result").remove();

    var html = "";
    if (data.length == 0) {
        html = '<tr class="user-search-result" align="center"><td colspan="7">�˻��� �����Ͱ� �����ϴ�</td></tr>';
        $("#user-result-count").html("0");
        $("#user-search-check-all").hide();
        
    } else {
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
        $("#user-search-check-all").show();
    }
    
    area.append(html);
    $("#user-result-count").html(data.length);

    // Ŭ���� ���ø� �ʵ带 ä��
    var rows = $("#user-search-area input[type=checkbox]");
    rows.bind("click", function() {

        var idx = $(this).parent().parent().index() - 2;	// tr > td > input
        var user = gUserList[idx];

        if ($(this).prop("checked")) {
            // ������ �߰�
            var multiUser = new User(user.USER_NM, user.USER_POS, user.USER_M_TEL);
            mMultiUser.push(multiUser);
            setUserInfo(user);
            
        } else {
            // ������ ����
            mMultiUser = mMultiUser.filter(function(item) {
                return item.name != user.USER_NM;
            });
            setUserInfo(user);
        }
    });
}

// ���ø� �ʵ带 ä��� ���ε�
function setUserInfo(user) {

    // ������
    $("#recipient_num").hide();
    $("#spe-recipient-name").show();
    $("#spe-recipient-direct").hide();
    $("#spe-recipient-direct input[type=checkbox]").prop("checked", false);
    $("#spe-recipient-cnt").hide();

    // �Ѱ��� ���õ��� �ʾ��� ���
    if (mMultiUser.length == 0) {
        $("#recipient_num").show();
        $("#spe-recipient-name").hide();
        $("#spe-recipient-direct").hide();
        $("#spe-recipient-direct input[type=checkbox]").prop("checked", false);
        $("#spe-recipient-cnt").hide();

        $("#spe-recipient-name").empty();
        $("input#customer_name").val("");
        reloadTemplateContent();
        
    // �Ѱ� ���õǾ��� ���
    } else if (mMultiUser.length == 1) {
        var term = $("#spe-recipient-name").empty();
        var html =
            '<option val="' + "1" + '" data-name="' + user.USER_NM + '" data-phone="' + user.USER_M_TEL + '">' +
            	user.USER_NM + " (" + user.USER_M_TEL + ")" +
            '</option>';
        term.append(html);

        term.bind("change", function () {
            // ������ ���� -> �� ?
            var selOpt = $(this).find(":selected");
            $("input#customer_name").val(selOpt.attr("data-name"));
            reloadTemplateContent();
        }).change();

        reloadTemplateContent();

        $(window).scrollTop(0);
        
    // ������ ���õǾ��� ���
    } else {
        $("#spe-recipient-cnt").html(mMultiUser.length + "�� ����");
        $("#spe-recipient-cnt").show().css("display", "inline");
    }
}


// ���� ���� ���
var cnt = new Array();
cnt[0] = new Array('��/��');
cnt[1] = new Array('��/��','������','������','���ϱ�','������','���Ǳ�','������','���α�','��õ��','�����','������','���빮��','���۱�','������','���빮��','���ʱ�','������','���ϱ�','���ı�','��õ��','��������','��걸','����','���α�','�߱�','�߶���');
cnt[2] = new Array('��/��','������','������','����','����','������','�λ�����','�ϱ�','���','���ϱ�','����','������','������','������','�߱�','�ؿ�뱸','���屺');
cnt[3] = new Array('��/��','����','�޼���','����','�ϱ�','����','������','�߱�','�޼���');
cnt[4] = new Array('��/��','��籸','����','������','����','����Ȧ��','����','����','������','�߱�','��ȭ��','������');
cnt[5] = new Array('��/��','���걸','����','����','�ϱ�','����');
cnt[6] = new Array('��/��','�����','����','����','������','�߱�');
cnt[7] = new Array('��/��','����','����','�ϱ�','�߱�','���ֱ�');
cnt[8] = new Array('��/��','����Ư����ġ��');
cnt[9] = new Array('��/��','����','��õ��','�����','������','������','�����ֽ�','����õ��','��õ��','������','������','�����','�Ȼ��','�Ⱦ��','�����','�ǿս�','�����ν�','���ý�','�ϳ���','����','���ֽ�','������','�ȼ���','���ֽ�','����','���ֱ�','��õ��','���ν�','��õ��','���ֽ�','��õ��','ȭ����');
cnt[10] = new Array('��/��','������','���ؽ�','��ô��','���ʽ�','���ֽ�','��õ��','�¹��','����','�籸��','��籺','������','������','������','ö����','��â��','ȫõ��','ȭõ��','Ⱦ����');
cnt[11] = new Array('��/��','��õ��','û�ֽ�','���ֽ�','���걺','�ܾ籺','������','������','��õ��','������','��õ��','û����','����');
cnt[12] = new Array('��/��','���ֽ�','����','���ɽ�','�����','�ƻ��','õ�Ƚ�','�ݻ걺','��걺','������','�ο���','��õ��','���ⱺ','���걺','û�籺','�¾ȱ�','ȫ����');
cnt[13] = new Array('��/��','�����','������','������','�ͻ��','���ֽ�','������','��â��','���ֱ�','�ξȱ�','��â��','���ֱ�','�ӽǱ�','�����','���ȱ�');
cnt[14] = new Array('��/��','�����','���ֽ�','������','��õ��','������','��õ��','������','���ﱺ','���','���ʱ�','��籺','���ȱ�','������','�žȱ�','��õ��','������','���ϱ�','�ϵ���','�强��','���ﱺ','������','����','�س���','ȭ����');
cnt[15] = new Array('��/��','����','���ֽ�','���̽�','��õ��','�����','���ֽ�','�ȵ���','���ֽ�','��õ��','���׽�','��ɱ�','������','��ȭ��','���ֱ�','������','���籺','��õ��','�︪��','������','�Ǽ���','û����','û�۱�','ĥ�');
cnt[16] = new Array('��/��','������','���ؽ�','�����','�о��','��õ��','����','���ֽ�','���ؽ�','â����','�뿵��','��â��','����','���ر�','��û��','����','�Ƿɱ�','â�籺','�ϵ���','�Ծȱ�','�Ծ籺','��õ��');
cnt[17] = new Array('��/��','��������','���ֽ�','�����ֱ�','�����ֱ�');

function county_change(add) {

    $("select[name=gubun2]").empty();
    for (var i = 0; i < cnt[add].length; i++) {
        if (i == 0) {
            $('select[name=gubun2]').append('<option value="">'+ cnt[add][i] +'</option>');
        } else {
            $('select[name=gubun2]').append('<option value="'+ cnt[add][i] +'">'+ cnt[add][i] +'</option>');
        }
    }
}

function clearSearch(type) {
    if (type == null) {
        $("input[name=search-type][value=client]").prop("checked",true);
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

// ���� ��ü ���ý�
function userCheckAll() {
    mMultiUser.length = 0;
    gUserList.forEach(function(user, index, array) {
        var multiUser = new User(user.USER_NM, user.USER_POS, user.USER_M_TEL);
        mMultiUser.push(multiUser);
        // ó���� ������ �϶�
        if (index == 0) {
            setUserInfo(user);
        } else if (index == array.length - 1) {
            setUserInfo(user);
        }
    });
    
    // üũ�ڽ� üũ
    $("#user-search-area input[type=checkbox]").prop("checked", true);
}

// ������� ��ü ���ý�
function salesCheckAll() {
    mMultiSales.length = 0;
    gSalesList.forEach(function(sales, index, array) {
        var multiSales = new User(sales.EMP_NM, "", sales.EMP_M_TEL);
        mMultiSales.push(multiSales);
        // ó���� ������ �϶�
        if (index == 0) {
            setSalesField(sales);
        } else if (index == array.length - 1) {
            setSalesField(sales);
        }
    });    
    // üũ�ڽ� üũ
    $("#sales-search-area input[type=checkbox]").prop("checked", true);
}

// jjlim add auto select
function ajaxGetContractInfo(mngId, lCd) {
    // ��� ���� ������
    var data = {
        m_id: mngId,
        l_cd: lCd,
        more_info: true //��࿡�� �ٷ� ������ ��� ����Ʈ�˻� ������ ���⶧���� �� ������ 2017.11.16
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
            $("#search-loader").show();
        },
        success: function(data) {
            $("#search-loader").hide();
            gContractInfo = data;
            setContractField(gContractInfo);
        },
        error: function(e) {
            alert("����");
        }
    })
}

</script>
</head>
<!-- <body leftmargin="15"> -->
<body style="margin: 0px 0px 30px 0px;">
<%-- <div style="display: none;"> 
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7>
                        	<img src=/acar/images/center/menu_bar_1.gif width=7 height=33>
                        </td>
                        <td class=bar>
                        	&nbsp;&nbsp;&nbsp;
                        	<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>
                        	&nbsp;
                        	<span class=style1>
                        		�˸��� > <span class="style5">�˸��� �߼�</span>
                        	</span>
                        </td>
                        <td width=7>
                        	<img src=/acar/images/center/menu_bar_2.gif width=7 height=33>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td class=h></td>
        </tr>
        <tr>
            <td colspan=10>
                <span class=style4>�� �����Է�(ģ����)�� �÷���ģ�� ���Ը� ���۵˴ϴ�. �÷���ģ���� �ƴϸ� ���ڷ� ���۵˴ϴ�.</span>
            </td>
        </tr>
        <tr>
        	<td>
			<% if (nm_db.getWorkAuthUser("������",user_id)) { %>
            	<button id="manage-template" class="button">���ø� ����</button>
			<% } %>
        	</td>
        </tr>
        <tr>
        	<td class=h></td>
        </tr>
    </table>
</div> --%>

<!-- ��ܿ���_START -->
<div style="height: 180px;">    
	<table width=100% border=0 cellspacing=0 cellpadding=0 style="height: 100px;">
	    <tr>
	        <td valign="top" style="padding-top: 30px;">
	            <table width=100% border=0 cellspacing=0 cellpadding=0>
	            	<tr style="display: none;">
	            		<td class="logo_area">
	            			<img class="logo_img" src="https://www.amazoncar.co.kr/resources/images/logo_1.png">
	            		</td>
	            	</tr>
	                <tr>
	                    <td valign="top" style="background-color: #349BD5; border-bottom: 1px solid #FFF;">
	                        <table class="menu_table_top">
	                            <!--1 depth menu ���� -->
	                            <tr>
	                              	<td class="no-drag">��ǰ��</td>
	                              	<td class="no-drag">���뺰</td>
	                              	<td class="no-drag">ģ����</td>
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr id="start_mid" style="display: none;">
	                    <td valign="top" style="background-color: #349BD5; border-bottom: 1px solid #FFF;">
	                        <table class="menu_table_mid">
		                        <!--2 depth menu ���� -->
	                            <tr id="item_mid">
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr id="start_sub" style="display: none;">
	                    <td valign="top" style="background-color: #349BD5; border-bottom: 1px solid #FFF;">
	                        <table class="menu_table_sub">
	                        	<!--3 depth menu ���� -->
	                            <tr id="item_sub">
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	</table>
</div>
<!-- ��ܿ���_END -->

<!-- �˸���_START -->
<div style="height: 600px; margin: 0px 15px;">
    <!-- <div class="table-style-1">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">���ø�
    </div>
    <div>
    	<select id="select-first-category">
    		<option value="0">��ü</option>
    		<option value="1">��ǰ��</option>
    		<option value="2">���뺰</option>
    		<option value="10">�����Է�</option>
    	</select>
        <select id="select-category">
        </select>
        <select id="template-select">
        </select>
        <img id="search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none;">
    </div> -->

    <div class="table-style-1" id="talk_content_1" style="padding-bottom: 15px;">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">�˸��� ���ø� ����Ʈ
    </div>
	
	<!-- 20190708_�ű� ���ø� ����Ʈ ���� �߰� -->
	<!-- <div style="width: 30%;"> -->
    <div id="template-list-up" class="template-list-up">
    </div>
	<!-- </div> -->
    
    <!-- <div style="width: 65%; float: right;"> -->
	    <div id="talk_content_2" style="float: left; padding-left: 3%;">
	        <div class="message_body">
	            <div style="height: 20px;"></div>
	            <div class="message_bubble">
	                <div class="message_bubble_header">
	                    <div class="message_bubble_header_text font-1">�˸���</div>
	                </div>
	                <div>
	                    <div id="alim-textarea" class="message_bubble_text_area font-2"></div>
	                    <%--<div id="alim-textarea" class="message_bubble_text_area" rows="5" cols="30" class="font-2" readonly style=" overflow-x: hidden; width: 90%; height: 80%; margin: 5%; resize: none; border: none"></div>--%>
	
	                    <textarea id="alim-textarea-w" rows="5" cols="30" class="message_bubble_text_area font-2" style="display: none"></textarea>
	                    <%--<textarea id="alim-textarea" rows="5" cols="30" class="font-2" readonly style=" overflow-x: hidden; width: 90%; height: 80%; margin: 5%; resize: none; border: none"></textarea>--%>
	                </div>
	            </div>
	        </div>
	        <button id="send-button" class="message_send_button font-1">������</button>
	        <div>
	            <div style="text-align: right; color: #737373; font-size: 12px; padding: 5px;">����: <span id="message-length">0</span> byte</div>
	        </div>
	    </div>
	
	    <!-- <div style="margin-left: 350px" id="talk_content_3"  style="display: none"> -->
	    <div id="talk_content_3" style="float: left; padding-left: 3%;">
	        <div class="table-style-1">
	        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">�߽���/������
	        </div>
	        <div>
	            <div style="margin-top: 5px">
	                <span class="font-2">�߽���</span>
	                <select name="aaa" id="org-name" class="width-1">
	                    <option value="A1" disabled selected>�߽���</option>
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
		                            data-hot-tel="<%= user.get("HOT_TEL") %>"
		                            data-loan-st="<%= user.get("LOAN_ST") %>"
                        	<% if (user_id.equals(user.get("USER_ID"))) out.println("selected"); %>>
                        		<%= user.get("USER_NM") %> 
                        		<%if (user.get("LOAN_ST").equals("")) {%>
	                        			(<%= user.get("HOT_TEL") %>)
                        		<%} else {%>
	                        			(<%= user.get("USER_M_TEL") %>)
                        		<%}%>
                        		</option>	
	                    <%  }
	                    } %>
	                </select>
	                <select id="spe-org-name" class="width-2" style="display: none;">
	                    <option value="" disabled selected>�߽���</option>
	                </select>
	                <%--<input type="text" id="org-phone" value="<%= user_m_tel %>">--%>
	            </div>
	            <div style="margin-top: 5px">
	                <span class="font-2">������</span>
	                <input id="recipient_num" type="text" class="width-1" />
	                <select id="spe-recipient-name" class="width-2" style="display: none;">
	                    <option value="" disabled selected>������</option>
	                </select>
	                <div id="spe-recipient-direct" class="font-2" style="display: none">
	                	<input type="checkbox">�����Է�
	                </div>
	                <span id="spe-recipient-cnt" class="font-2" style="margin-left: 5px; display: none; color: red;">0�� ����</span>
	            </div>
	        </div>
	        <br>
	
	        <div id="template-field-area-outter">
	            <div class="table-style-1">
	            	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">���ø� �ʵ�
	            </div>
	            <div id="template-field-area"></div>
	        </div>
	        <br>
	    </div>
    <!-- </div> -->

</div>
<!-- �˸���_END -->

<!-- �˻�����_START -->
<div id="search-area" style="clear: both; margin: 0px 15px;">

	<div class="font-2">
	    <div class="table-style-1">
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">�˻�
	    </div>
	    <input type="radio" name="search-type" value="client" checked>��
	    <input type="radio" name="search-type" value="user">�����
	    <input type="radio" name="search-type" value="sales">�������
	</div>
	<br>
	
	<%-- ��� �˻� --%>
	<!-- <div id="contract-search-area" style="clear: both; width: 800px;"> -->
	<div id="contract-search-area" style="clear: both;">
	    <div class="table-style-1">
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">��� �˻�<img id="contract-search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none">
	    </div>
	    <!-- <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="800"> -->
	    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="100%">
	        <tr>
	        	<td class=line2 colspan=2></td>
	        </tr>
	        <tr>
	            <td class="title" width=10%>��ȸ����</td>
	            <td width="45%">&nbsp;
	                <select name='gubun4'>
	                    <option value="1">�������</option>
	                    <option value="2">���°���</option>
	                </select>
	                &nbsp;
	                <select name='gubun5'>
	                    <option value="1">����</option>
	                    <option value="2">����</option>
	                    <option value="3">2��</option>
	                    <option value="4">���</option>
	                    <option value="5">����</option>
	                    <option value="6" selected>�Ⱓ</option>
	                </select>
	                &nbsp;
	                <input type="text" name="st_dt" size="10" value="" class="text">
	                ~
	                <input type="text" name="end_dt" size="10" value="" class="text">
	            </td>
	        </tr>
	        <tr>
	            <td class=title width=10%>�˻�����</td>
	            <td width=40%>&nbsp;
	                <select name='s_kd'>
	                    <option value='1' >��ȣ </option>
	                    <option value='19'>����ڹ�ȣ/�������</option>
	                    <option value='2' >����ȣ </option>
	                    <option value='3' >������ȣ </option>
	           			<!-- <option value='8' >���ʿ����� </option>
	                    <option value='10'>��������� </option>
	                    <option value='11'>��������� </option> -->
	           			<!-- <option value='13'>��ǥ�� </option> -->
	                </select>
	                &nbsp;
	                <input type='text' name='t_wd' size='18' class='text' value="">
	            </td>
	        </tr>
	    </table>
	    
	    <div style="text-align: right; margin-top: 2px">
	    	<img id="search-cont-button" src=/acar/images/center/button_search.gif align=absmiddle border=0>
	    </div>
	
	    <div class="table-style-1">
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">�� <span id="contract-result-count">0</span> ��
	    </div>
	    <!-- <table id="contract-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='800'> -->
	    <table id="contract-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='100%'>
	        <tr>
	        	<td class=line2></td>
	        </tr>
	        <tr>
	            <td width="5%" class='title'>����</td>
	            <td width='6%' class='title'>����</td>
	            <td width='6%' class='title'>����</td>
	            <td width='12%' class='title'>����ȣ</td>
	            <td width='9%' class='title'>�����</td>
	            <td width="20%" class='title'>��</td>
	            <td width="10%" class='title'>������ȣ</td>
	            <td width="12%" class='title'>����</td>
	            <td width="10%" class='title'>�����</td>
	            <td width="10%" class='title'>����<br>�����</td>
	        </tr>
            <tr class="contract-search-result" align="center">
                <td colspan="10">�˻��� ����Ÿ�� �����ϴ�</td>
            </tr>
	    </table>
    </div>
	
	<!-- ����� �˻� -->
	<!-- <div id="user-search-area" style="clear: both; width: 800px; display: none"> -->
	<div id="user-search-area" style="clear: both; width: 100%; display: none;">
	    <div class="table-style-1">
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px;">����� �˻�<img id="user-search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none;">
	    </div>
	    <!-- <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="800"> -->
	    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="100%">
	        <tr>
	        	<td class="line2" colspan="2"></td>
	        </tr>
	        <tr>
	            <td class="title" width=10%>�˻�����</td>
	            <td width=40%>&nbsp;
	                <select name='s_kd'>
	                    <option value='EMP'>������</option>
	                    <option value='AGENT'>������Ʈ</option>
	            		<!-- <option value='BUS_EMP'>������</option>
	                    <option value='MNG_EMP'>��������</option>
	                    <option value='GEN_EMP'>�ѹ���</option> -->
	                </select>
	            </td>
	        </tr>
	    </table>
	    
	    <div style="text-align: right; margin-top: 2px">
	    	<img id="search-user-button" src=/acar/images/center/button_search.gif align=absmiddle border=0>
	    </div>
	    
	    <div class="table-style-1">
	    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">�� <span id="user-result-count">0</span> �� <button id="user-search-check-all" onclick="userCheckAll();" style="display: none;">��ü����</button>
	    </div>
	    
	    <!-- <table id="user-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='800'> -->
	    <table id="user-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='100%'>
	        <tr>
	        	<td class=line2></td>
	        </tr>
	        <tr>
	            <td width="5%" class='title'>����</td>
	            <td width='6%' class='title'>����</td>
	            <td width='15%' class='title'>�Ҽӻ�</td>
	            <td width="15%" class='title'>�ٹ�ó</td>
	            <td width='20%' class='title'>����</td>
	            <td width='15%' class='title'>����</td>
	            <td width="24%" class='title'>�ڵ���</td>
	        </tr>
	        <tr class="user-search-result" align='center'>
	            <td colspan="7">�˻��� ����Ÿ�� �����ϴ�</td>
	        </tr>
	    </table>
	</div>
</div>

<%-- �������  �˻�  -- 20170927  �߰�  display:block ó�� 20170927     ��, �����. ������� �˻��� �����   ---%>
<!-- <div id="sales-search-area" style="clear: both; width: 800px; display: none"> -->
<div id="sales-search-area" style="clear: both; margin: 0px 15px; display: none;">
    <div class="table-style-1">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">������� �˻�<img id="sales-search-loader" src=/acar/images/ajax-loader.gif align="absmiddle" style="margin: 2px; display: none;">
    </div>
    
    <!-- <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="800"> -->
    <table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="100%">
        <tr>
        	<td class=line2 colspan=2></td>
        </tr>
        <tr>
            <td class="title" width=10%>�Ҽӻ� </td>
            <td width="35%">&nbsp;
            	<select name="gubun3">
                	<option value="">��ü
				<%
            	for(int i=0; i<cc_r.length; i++){
                cc_bean = cc_r[i];
                if(cc_bean.getNm().equals("������Ʈ")) continue;
        		%>
                    <option value="<%= cc_bean.getCode() %>" <% if(gubun3.equals(cc_bean.getCode())) out.print("selected"); %>><%= cc_bean.getNm() %></option>
                <%
                }
                %>
            	</select>
                 &nbsp;
           	</td>
            <td class="title" width=10%>�ٹ����� </td>
            <td width="35%">&nbsp;
                <select name='gubun1' onchange="county_change(this.selectedIndex);">
                    <option value=''>��/��</option>
                    <option value='����'>����Ư����</option>
                    <option value='�λ�'>�λ걤����</option>
                    <option value='�뱸'>�뱸������</option>
                    <option value='��õ'>��õ������</option>
                    <option value='����'>���ֱ�����</option>
                    <option value='����'>����������</option>
                    <option value='���'>��걤����</option>
                    <option value='����'>����Ư����ġ��</option>
                    <option value='���'>��⵵</option>
                    <option value='����'>������</option>
                    <option value='���'>��û�ϵ�</option>
                    <option value='�泲'>��û����</option>
                    <option value='����'>����ϵ�</option>
                    <option value='����'>���󳲵�</option>
                    <option value='���'>���ϵ�</option>
                    <option value='�泲'>��󳲵�</option>
                    <option value='����'>���ֵ�</option>
                </select>&nbsp;
                <select name='gubun2'>
                    <option value=''>��/��</option>
                </select>
            </td>                      
        </tr>
        <tr>
        	<td class="title" width=10%>�˻�����</td>
            <td width=40%>&nbsp;
            	<select name="gubun">
					<option value="">��ü</option>
                    <option value="emp_nm" >����</option>
                    <option value="car_comp" >�ڵ���ȸ��</option>
                    <option value="car_off" >����</option>
                    <option value="car_off_nm" >�����Ҹ�</option>
                    <option value="emp_m_tel" >�ڵ���</option>
                    <option value="damdang_id" >�����</option>
                </select>
                &nbsp;
                <input type='text' name='gu_nm' size='18' class='text' value="">
            </td>
            <td class="title" width=10%>��������</td>
            <td width=40%>&nbsp;
            	<select name="cng_rsn">
	                <option value="">==��ü==</option>
	                <option value="1" >1.�ֱٰ��</option>
	                <option value="2" >2.�����</option>
	                <option value="3" >3.��ȭ���</option>
	                <option value="4" >4.�������</option>
	                <option value="5" >5.��Ÿ</option>
                </select> &nbsp;
                <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text"> ~ 
                <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" > 
            </td>
        </tr>
    </table>
    
    <div style="text-align: right; margin-top: 2px;">
    	<img id="search-sales-button" src=/acar/images/center/button_search.gif align=absmiddle border=0>
    </div>

   	<div class="table-style-1">
   		<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px">�� <span id="sales-result-count">0</span> �� <button id="sales-search-check-all" onclick="salesCheckAll();" style="display: none;">��ü����</button>
   	</div>
   	
    <!-- <table id="sales-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='800'> -->
    <table id="sales-search-result-table" class="table-back-1" border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
        	<td class=line2></td>
        </tr>
        <tr>
            <td width="5%" class='title'>����</td>
            <td width='6%' class='title'>����</td>
            <td width='17%' class='title'>�Ҽӻ�</td>  <!-- CAR_COMP_NM -->
            <td width='11%' class='title'>�ٹ�����</td>
            <td width='8%' class='title'>�ٹ�ó</td>
            <td width="8%" class='title'>����</td>  <!-- EMP_NM -->
            <td width="15%" class='title'>�ڵ���</td>  <!-- EMP_M_TEL -->
            <td width="10%" class='title'>�����</td>
            <td width="10%" class='title'>��������</td>
            <td width="7%" class='title'>������</td>
        </tr>
        <tr class="sales-search-result" align='center'>
            <td colspan="10">�˻��� ����Ÿ�� �����ϴ�</td>
        </tr>
    </table>
</div>
<!-- �˻�����_END -->

</body>
<script src="https://apis.google.com/js/client.js?onload=load"></script>
<script>

</script>
</html>
