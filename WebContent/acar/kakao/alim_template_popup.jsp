<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS �˸��� ���ø� �˾�</title> 
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type="text/css">
    .table-style-1 {
        font-family:����, Gulim, AppleGothic, Seoul, Arial;
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
        font-family:����, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        font-weight: bold;
    }
    .font-2 {
        font-family:����, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
    }
</style>
</head>
<body>
<div style="overflow:auto;overflow-x:scroll;">
	<table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="550">
		<tr><td class=line2 colspan=2></td></tr>
		<tr><td class="title" width=35%>�ʵ��</td><td class="title" width=35%>�ڵ�</td><td class="title" width=30%>���</td></tr>
		<tr class="table-body-1"><td>����</td><td>&#36;{customer_name}</td><td></td></tr>
		<tr class="table-body-1"><td>������</td><td>&#36;{customer_email}</td><td></td></tr>
		<tr class="table-body-1"><td>�� Fax ��ȣ</td><td>&#36;{customer_fax}</td><td></td></tr>
		
        <tr class="table-body-1"><td>���� ��ȣ</td><td>&#36;{car_num}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ��ȣ</td><td>&#36;{p_car_num}</td><td></td></tr>
        <tr class="table-body-1"><td>���� �̸�</td><td>&#36;{car_name}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ����</td><td>&#36;{car_amount}</td><td></td></tr>
        
        <tr class="table-body-1"><td>���� ��ȣ</td><td>&#36;{car_num_name_arr}</td><td>�渶��Ź�������ȳ���</td></tr>
        <tr class="table-body-1"><td>���� �̸�</td><td>&#36;{car_num_name_arr_count}</td><td>�渶��Ź�������ȳ���</td></tr>
        
        <tr class="table-body-1"><td>����</td><td>&#36;{company_branch}</td><td></td></tr>
        <tr class="table-body-1"><td>��ȭ</td><td>&#36;{company_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>�����ȣ</td><td>&#36;{zip_code}</td><td></td></tr>
        <tr class="table-body-1"><td>�ּ�</td><td>&#36;{company_addr}</td><td></td></tr>
        <tr class="table-body-1"><td>����� �̸�</td><td>&#36;{manager_name}</td><td></td></tr>
        <tr class="table-body-1"><td>����� ����</td><td>&#36;{manager_grade}</td><td></td></tr>
        <tr class="table-body-1"><td>����� ��ȭ</td><td>&#36;{manager_phone}</td><td></td></tr>
        
        <tr class="table-body-1"><td>����� �̸�(����)</td><td>&#36;{bus_manager_name}</td><td></td></tr>
        <tr class="table-body-1"><td>����� ��ȭ(����)</td><td>&#36;{bus_manager_phone}</td><td></td></tr>
        
        <tr class="table-body-1"><td>������ �߼�</td><td>&#36;{esti_send_way}</td><td></td></tr>
        <tr class="table-body-1"><td>������ ��ũ</td><td>&#36;{esti_link}</td><td></td></tr>
        <tr class="table-body-1"><td>��� ��ȣ</td><td>&#36;{contract_no}</td><td></td></tr>
        <tr class="table-body-1"><td>��� ȸ��</td><td>&#36;{contract_turn}</td><td></td></tr>
        <tr class="table-body-1"><td>��� �غ�</td><td>&#36;{contract_supp}</td><td></td></tr>
        <tr class="table-body-1"><td>�湮 ���</td><td>&#36;{visit_place}</td><td></td></tr>
        <tr class="table-body-1"><td>�൵</td><td>&#36;{visit_place_url}</td><td></td></tr>
        <tr class="table-body-1"><td>�ݳ� ���</td><td>&#36;{return_place}</td><td></td></tr>
        <tr class="table-body-1"><td>�����ݳ��� (��-��-��)</td><td>&#36;{car_e_date}</td><td></td></tr>
        <tr class="table-body-1"><td>������</td><td>&#36;{driver}</td><td></td></tr>
        <tr class="table-body-1"><td>����Ÿ�</td><td>&#36;{dist}</td><td></td></tr>
        <tr class="table-body-1"><td>����Ÿ� �ʰ� ���</td><td>&#36;{dist_fee}</td><td></td></tr>
        <tr class="table-body-1"><td>����� �̸�</td><td>&#36;{insurance_name}</td><td></td></tr>
        <tr class="table-body-1"><td>����� ��ȭ</td><td>&#36;{insurance_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>����� ����� �̸�</td><td>&#36;{insur_mng_name}</td><td></td></tr>
        <tr class="table-body-1"><td>����� ����� ����</td><td>&#36;{insur_mng_grade}</td><td></td></tr>
        <tr class="table-body-1"><td>����� ����� ��ȭ</td><td>&#36;{insur_mng_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>�������� URL</td><td>&#36;{insur_info_url}</td><td></td></tr>
        
        <tr class="table-body-1"><td>�� ��(������ݰ���)</td><td>&#36;{fee_count}</td><td></td></tr>
        <tr class="table-body-1"><td>�� �뿩��</td><td>&#36;{rent_fee}</td><td></td></tr>
        <tr class="table-body-1"><td>�뿩��</td><td>&#36;{rent_fee_all}</td><td></td></tr>
        <tr class="table-body-1"><td>�̳� ����</td><td>&#36;{unpaid_interest}</td><td></td></tr>
        <tr class="table-body-1"><td>�� ���Ա�</td><td>&#36;{tot_mnt}</td><td></td></tr>
        <tr class="table-body-1"><td>�뿩�� ��ü����</td><td>&#36;{interest_rate}</td><td></td></tr>
        
        <tr class="table-body-1"><td>����ó</td><td>&#36;{pay_place}</td><td></td></tr>
        <tr class="table-body-1"><td>���⳻��</td><td>&#36;{pay_contents}</td><td></td></tr>
        <tr class="table-body-1"><td>����ݾ�</td><td>&#36;{pay_amount}</td><td></td></tr>
        
        <tr class="table-body-1"><td>���ޱݾ�</td><td>&#36;{payments_amount}</td><td></td></tr>
        <tr class="table-body-1"><td>�����ݾ�</td><td>&#36;{deduction_amount}</td><td></td></tr>
        <tr class="table-body-1"><td>�����ݾ�</td><td>&#36;{cost_amount}</td><td></td></tr>
        
        <tr class="table-body-1"><td>�뿩���� ��)���뿩���/����Ʈ</td><td>&#36;{rent_gubun}</td><td></td></tr>
        <tr class="table-body-1"><td>����1</td><td>&#36;{gubun1}</td><td></td></tr>
        <tr class="table-body-1"><td>����2</td><td>&#36;{gubun2}</td><td></td></tr>
        <tr class="table-body-1"><td>����</td><td>&#36;{month}</td><td></td></tr>
        <tr class="table-body-1"><td>������</td><td>&#36;{deposit_rate}</td><td></td></tr>
        <tr class="table-body-1"><td>����Ÿ�</td><td>&#36;{distance}</td><td></td></tr>
        <tr class="table-body-1"><td>���� �̸�</td><td>&#36;{bank_name}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ����</td><td>&#36;{bank_account}</td><td></td></tr>
        <tr class="table-body-1"><td>������ ��</td><td>&#36;{before_day}</td><td></td></tr>
        <tr class="table-body-1"><td>������ ��</td><td>&#36;{after_day}</td><td></td></tr>
        <tr class="table-body-1"><td>�ϰ�</td><td>&#36;{p_days}</td><td></td></tr>
        <tr class="table-body-1"><td>����Ÿ� ������</td><td>&#36;{dist_increase}</td><td></td></tr>
        <tr class="table-body-1"><td>1�� ����Ÿ�</td><td>&#36;{p_day_dist}</td><td></td></tr>
        <tr class="table-body-1"><td>��ȯ�� ����Ÿ�</td><td>&#36;{p_year_dist}</td><td></td></tr>
        <tr class="table-body-1"><td>��¥ (��-��-��) </td><td>&#36;{date}</td><td></td></tr>
        <tr class="table-body-1"><td>��¥ (�� �� ��)</td><td>&#36;{date_ymd}</td><td></td></tr>
        <tr class="table-body-1"><td>��������</td><td>&#36;{update_date}</td><td></td></tr>
        <tr class="table-body-1"><td>��¥ (�� �� �� �� ��)</td><td>&#36;{date_ymdhhmm}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ��¥ (��/��)</td><td>&#36;{cur_date_md}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ��¥ (��)</td><td>&#36;{cur_date_year}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ��¥ (��)</td><td>&#36;{cur_date_mon}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ��¥ (��)</td><td>&#36;{cur_date_day}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ��¥ (�� �� ��)</td><td>&#36;{reg_date}</td><td></td></tr>
        <tr class="table-body-1"><td>�μ� ��¥ (��/��)</td><td>&#36;{car_take_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>��� ������ (��-��-��)</td><td>&#36;{contract_s_date}</td><td></td></tr>
        <tr class="table-body-1"><td>��� ������ (��-��-��)</td><td>&#36;{contract_e_date}</td><td></td></tr>
        <tr class="table-body-1"><td>��� ������ (��/��)</td><td>&#36;{contract_s_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>��� ������ (��/��)</td><td>&#36;{contract_e_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>��� ����� (��/��)</td><td>&#36;{contract_date_mn}</td><td></td></tr>
        <tr class="table-body-1"><td>��ȿ ���� (�� �� �� ��)</td><td>&#36;{expiration_date}</td><td></td></tr>
        <tr class="table-body-1"><td>Ȯ�� ���� (�� �� ��)</td><td>&#36;{last_date}</td><td></td></tr>
        
        <tr class="table-body-1"><td>�߽���</td><td>&#36;{sender_name}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�۹�ȣ</td><td>&#36;{deliver_no}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�� ��¥ (��/��)</td><td>&#36;{deliver_date}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�� ��¥ (�ð�)</td><td>&#36;{deliver_hour}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�� ��¥ (��)</td><td>&#36;{deliver_min}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�� ��¥ (�� �� �� �� ��)</td><td>&#36;{deliver_ymdhhmm}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�� ��ü��</td><td>&#36;{deliver_company}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�� ��� �̸�</td><td>&#36;{deliver_name}</td><td></td></tr>
        <tr class="table-body-1"><td>Ź�� ��� ��ȭ</td><td>&#36;{deliver_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>��Ȯ�� �Ǽ�</td><td>&#36;{un_count}</td><td></td></tr>
        <tr class="table-body-1"><td>�������-���ڸ� ����</td><td>&#36;{birth_gender}</td><td>���븮���뺸</td></tr>
        
        <tr class="table-body-1"><td>��ǰ ��ü��</td><td>&#36;{supplies_name}</td><td></td></tr>
        
        <tr class="table-body-1"><td>������</td><td>&#36;{auction_name}</td><td></td></tr>
        
        <tr class="table-body-1"><td>���� ��ü��</td><td>&#36;{service_name}</td><td></td></tr>
        <tr class="table-body-1"><td>���� �ݾ�</td><td>&#36;{service_amount}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ����</td><td>&#36;{service_gubun}</td><td></td></tr>
        <tr class="table-body-1"><td>���� ����</td><td>&#36;{service_contents}</td><td></td></tr>
        <tr class="table-body-1"><td>���ǵ����Ʈ URL</td><td>&#36;{speed_mate_url}</td><td></td></tr>
        <tr class="table-body-1"><td>�ִ�ī���� URL</td><td>&#36;{any_car_url}</td><td></td></tr>
        <tr class="table-body-1"><td>�������ڵ�������</td><td>&#36;{mater_car_phone}</td><td></td></tr>
        <tr class="table-body-1"><td>SK��Ʈ����</td><td>&#36;{sk_net_phone}</td><td></td></tr>
        
        <tr class="table-body-1"><td>�뿩�� ������ǥ URL</td><td>&#36;{URL}</td><td></td></tr>
        
        <tr class="table-body-1"><td>�ڵ����������� �ȳ���</td><td>&#36;{car_mng_service_url}</td><td></td></tr>
        
        <tr class="table-body-1"><td>����������� �ȳ���</td><td>&#36;{blumembers_url}</td><td></td></tr>
        
        <tr class="table-body-1"><td>����⵿���� �ȳ�</td><td>&#36;{sos_url}</td><td></td></tr>
        <tr class="table-body-1"><td>���ó������ �ȳ�</td><td>&#36;{accident_url}</td><td></td></tr>
        <tr class="table-body-1"><td>�ڵ������� �ȳ�</td><td>&#36;{maint_url}</td><td></td></tr>
	</table>
</div>
</body>
</html>