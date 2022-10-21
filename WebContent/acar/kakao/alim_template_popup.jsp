<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS 알림톡 템플릿 팝업</title> 
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
    .table-body-1 {
        text-align: center;
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
</style>
</head>
<body>
<div style="overflow:auto;overflow-x:scroll;">
	<table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="550">
		<tr><td class=line2 colspan=2></td></tr>
		<tr><td class="title" width=35%>필드명</td><td class="title" width=35%>코드</td><td class="title" width=30%>비고</td></tr>
		<tr class="table-body-1"><td>고객명</td><td>&#36;{customer_name}</td><td></td></tr>
		<tr class="table-body-1"><td>고객메일</td><td>&#36;{customer_email}</td><td></td></tr>
		<tr class="table-body-1"><td>고객 Fax 번호</td><td>&#36;{customer_fax}</td><td></td></tr>
		
        <tr class="table-body-1"><td>차량 번호</td><td>&#36;{car_num}</td><td></td></tr>
        <tr class="table-body-1"><td>차대 번호</td><td>&#36;{p_car_num}</td><td></td></tr>
        <tr class="table-body-1"><td>차량 이름</td><td>&#36;{car_name}</td><td></td></tr>
        <tr class="table-body-1"><td>차량 가격</td><td>&#36;{car_amount}</td><td></td></tr>
        
        <tr class="table-body-1"><td>차량 번호</td><td>&#36;{car_num_name_arr}</td><td>경마장탁송차량안내용</td></tr>
        <tr class="table-body-1"><td>차량 이름</td><td>&#36;{car_num_name_arr_count}</td><td>경마장탁송차량안내용</td></tr>
        
        <tr class="table-body-1"><td>지점</td><td>&#36;{company_branch}</td><td></td></tr>
        <tr class="table-body-1"><td>전화</td><td>&#36;{company_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>우편번호</td><td>&#36;{zip_code}</td><td></td></tr>
        <tr class="table-body-1"><td>주소</td><td>&#36;{company_addr}</td><td></td></tr>
        <tr class="table-body-1"><td>담당자 이름</td><td>&#36;{manager_name}</td><td></td></tr>
        <tr class="table-body-1"><td>담당자 직급</td><td>&#36;{manager_grade}</td><td></td></tr>
        <tr class="table-body-1"><td>담당자 전화</td><td>&#36;{manager_phone}</td><td></td></tr>
        
        <tr class="table-body-1"><td>담당자 이름(영업)</td><td>&#36;{bus_manager_name}</td><td></td></tr>
        <tr class="table-body-1"><td>담당자 전화(영업)</td><td>&#36;{bus_manager_phone}</td><td></td></tr>
        
        <tr class="table-body-1"><td>견적서 발송</td><td>&#36;{esti_send_way}</td><td></td></tr>
        <tr class="table-body-1"><td>견적서 링크</td><td>&#36;{esti_link}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 번호</td><td>&#36;{contract_no}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 회차</td><td>&#36;{contract_turn}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 준비물</td><td>&#36;{contract_supp}</td><td></td></tr>
        <tr class="table-body-1"><td>방문 장소</td><td>&#36;{visit_place}</td><td></td></tr>
        <tr class="table-body-1"><td>약도</td><td>&#36;{visit_place_url}</td><td></td></tr>
        <tr class="table-body-1"><td>반납 장소</td><td>&#36;{return_place}</td><td></td></tr>
        <tr class="table-body-1"><td>차량반납일 (년-월-일)</td><td>&#36;{car_e_date}</td><td></td></tr>
        <tr class="table-body-1"><td>운전자</td><td>&#36;{driver}</td><td></td></tr>
        <tr class="table-body-1"><td>주행거리</td><td>&#36;{dist}</td><td></td></tr>
        <tr class="table-body-1"><td>주행거리 초과 비용</td><td>&#36;{dist_fee}</td><td></td></tr>
        <tr class="table-body-1"><td>보험사 이름</td><td>&#36;{insurance_name}</td><td></td></tr>
        <tr class="table-body-1"><td>보험사 전화</td><td>&#36;{insurance_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>보험사 담당자 이름</td><td>&#36;{insur_mng_name}</td><td></td></tr>
        <tr class="table-body-1"><td>보험사 담당자 직급</td><td>&#36;{insur_mng_grade}</td><td></td></tr>
        <tr class="table-body-1"><td>보험사 담당자 전화</td><td>&#36;{insur_mng_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>보험정보 URL</td><td>&#36;{insur_info_url}</td><td></td></tr>
        
        <tr class="table-body-1"><td>건 수(차량대금결재)</td><td>&#36;{fee_count}</td><td></td></tr>
        <tr class="table-body-1"><td>월 대여료</td><td>&#36;{rent_fee}</td><td></td></tr>
        <tr class="table-body-1"><td>대여료</td><td>&#36;{rent_fee_all}</td><td></td></tr>
        <tr class="table-body-1"><td>미납 이자</td><td>&#36;{unpaid_interest}</td><td></td></tr>
        <tr class="table-body-1"><td>총 납입금</td><td>&#36;{tot_mnt}</td><td></td></tr>
        <tr class="table-body-1"><td>대여료 연체이율</td><td>&#36;{interest_rate}</td><td></td></tr>
        
        <tr class="table-body-1"><td>지출처</td><td>&#36;{pay_place}</td><td></td></tr>
        <tr class="table-body-1"><td>지출내용</td><td>&#36;{pay_contents}</td><td></td></tr>
        <tr class="table-body-1"><td>지출금액</td><td>&#36;{pay_amount}</td><td></td></tr>
        
        <tr class="table-body-1"><td>지급금액</td><td>&#36;{payments_amount}</td><td></td></tr>
        <tr class="table-body-1"><td>공제금액</td><td>&#36;{deduction_amount}</td><td></td></tr>
        <tr class="table-body-1"><td>실지금액</td><td>&#36;{cost_amount}</td><td></td></tr>
        
        <tr class="table-body-1"><td>대여구분 예)장기대여계약/월렌트</td><td>&#36;{rent_gubun}</td><td></td></tr>
        <tr class="table-body-1"><td>구분1</td><td>&#36;{gubun1}</td><td></td></tr>
        <tr class="table-body-1"><td>구분2</td><td>&#36;{gubun2}</td><td></td></tr>
        <tr class="table-body-1"><td>개월</td><td>&#36;{month}</td><td></td></tr>
        <tr class="table-body-1"><td>보증금</td><td>&#36;{deposit_rate}</td><td></td></tr>
        <tr class="table-body-1"><td>주행거리</td><td>&#36;{distance}</td><td></td></tr>
        <tr class="table-body-1"><td>은행 이름</td><td>&#36;{bank_name}</td><td></td></tr>
        <tr class="table-body-1"><td>은행 계좌</td><td>&#36;{bank_account}</td><td></td></tr>
        <tr class="table-body-1"><td>변경전 일</td><td>&#36;{before_day}</td><td></td></tr>
        <tr class="table-body-1"><td>변경후 일</td><td>&#36;{after_day}</td><td></td></tr>
        <tr class="table-body-1"><td>일간</td><td>&#36;{p_days}</td><td></td></tr>
        <tr class="table-body-1"><td>주행거리 증가분</td><td>&#36;{dist_increase}</td><td></td></tr>
        <tr class="table-body-1"><td>1일 주행거리</td><td>&#36;{p_day_dist}</td><td></td></tr>
        <tr class="table-body-1"><td>연환산 주행거리</td><td>&#36;{p_year_dist}</td><td></td></tr>
        <tr class="table-body-1"><td>날짜 (년-월-일) </td><td>&#36;{date}</td><td></td></tr>
        <tr class="table-body-1"><td>날짜 (년 월 일)</td><td>&#36;{date_ymd}</td><td></td></tr>
        <tr class="table-body-1"><td>변경일자</td><td>&#36;{update_date}</td><td></td></tr>
        <tr class="table-body-1"><td>날짜 (년 월 일 시 분)</td><td>&#36;{date_ymdhhmm}</td><td></td></tr>
        <tr class="table-body-1"><td>현재 날짜 (월/일)</td><td>&#36;{cur_date_md}</td><td></td></tr>
        <tr class="table-body-1"><td>현재 날짜 (년)</td><td>&#36;{cur_date_year}</td><td></td></tr>
        <tr class="table-body-1"><td>현재 날짜 (월)</td><td>&#36;{cur_date_mon}</td><td></td></tr>
        <tr class="table-body-1"><td>현재 날짜 (일)</td><td>&#36;{cur_date_day}</td><td></td></tr>
        <tr class="table-body-1"><td>현재 날짜 (년 월 일)</td><td>&#36;{reg_date}</td><td></td></tr>
        <tr class="table-body-1"><td>인수 날짜 (월/일)</td><td>&#36;{car_take_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 시작일 (년-월-일)</td><td>&#36;{contract_s_date}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 종료일 (년-월-일)</td><td>&#36;{contract_e_date}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 시작일 (월/일)</td><td>&#36;{contract_s_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 종료일 (월/일)</td><td>&#36;{contract_e_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>계약 출금일 (월/일)</td><td>&#36;{contract_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>유효 기한 (년 월 일 시)</td><td>&#36;{expiration_date}</td><td></td></tr>
        <tr class="table-body-1"><td>확정 기한 (년 월 일)</td><td>&#36;{last_date}</td><td></td></tr>
        
        <tr class="table-body-1"><td>발신자</td><td>&#36;{sender_name}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송번호</td><td>&#36;{deliver_no}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송 날짜 (월/일)</td><td>&#36;{deliver_date}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송 날짜 (시간)</td><td>&#36;{deliver_hour}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송 날짜 (분)</td><td>&#36;{deliver_min}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송 날짜 (년 월 일 시 분)</td><td>&#36;{deliver_ymdhhmm}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송 업체명</td><td>&#36;{deliver_company}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송 기사 이름</td><td>&#36;{deliver_name}</td><td></td></tr>
        <tr class="table-body-1"><td>탁송 기사 전화</td><td>&#36;{deliver_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>미확인 건수</td><td>&#36;{un_count}</td><td></td></tr>
        <tr class="table-body-1"><td>생년월일-한자리 숫자</td><td>&#36;{birth_gender}</td><td>출고대리인통보</td></tr>
        
        <tr class="table-body-1"><td>용품 업체명</td><td>&#36;{supplies_name}</td><td></td></tr>
        
        <tr class="table-body-1"><td>경매장명</td><td>&#36;{auction_name}</td><td></td></tr>
        
        <tr class="table-body-1"><td>정비 업체명</td><td>&#36;{service_name}</td><td></td></tr>
        <tr class="table-body-1"><td>정비 금액</td><td>&#36;{service_amount}</td><td></td></tr>
        <tr class="table-body-1"><td>정비 구분</td><td>&#36;{service_gubun}</td><td></td></tr>
        <tr class="table-body-1"><td>정비 내용</td><td>&#36;{service_contents}</td><td></td></tr>
        <tr class="table-body-1"><td>스피드메이트 URL</td><td>&#36;{speed_mate_url}</td><td></td></tr>
        <tr class="table-body-1"><td>애니카랜드 URL</td><td>&#36;{any_car_url}</td><td></td></tr>
        <tr class="table-body-1"><td>마스터자동차관리</td><td>&#36;{mater_car_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>SK네트웍스</td><td>&#36;{sk_net_phone}</td><td></td></tr>
        
        <tr class="table-body-1"><td>대여료 스케줄표 URL</td><td>&#36;{URL}</td><td></td></tr>
        
        <tr class="table-body-1"><td>자동차관리서비스 안내문</td><td>&#36;{car_mng_service_url}</td><td></td></tr>
        
        <tr class="table-body-1"><td>블루멤버스서비스 안내문</td><td>&#36;{blumembers_url}</td><td></td></tr>
        
        <tr class="table-body-1"><td>긴급출동서비스 안내</td><td>&#36;{sos_url}</td><td></td></tr>
        <tr class="table-body-1"><td>사고처리서비스 안내</td><td>&#36;{accident_url}</td><td></td></tr>
        <tr class="table-body-1"><td>자동차정비 안내</td><td>&#36;{maint_url}</td><td></td></tr>
	</table>
</div>
</body>
</html>