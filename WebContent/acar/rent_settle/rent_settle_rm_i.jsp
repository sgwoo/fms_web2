<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�ܱ�뿩---------------------------------------------------------------------------------------------------------
			
	//�뿩�ϼ� ���ϱ�
	function getRentTime() {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var d3;
		var d4;		
		var t1;
		var t2;
		var t3;
		var t4;
		var t5;
		var t6;

		d1 = fm.h_rent_start_dt.value;
		d2 = fm.h_rent_end_dt.value;		
		d3 = fm.h_deli_dt.value;
		d4 = fm.h_ret_dt.value;	
											
		t1 = getDateFromString(d1).getTime();
		t2 = getDateFromString(d2).getTime();
		t3 = t2 - t1;	
		t4 = getDateFromString(d3).getTime();
		t5 = getDateFromString(d4).getTime();
		t6 = t5 - t4;	

        if (d4 == "") {  //������ ���� ��� skip
        
        } else {
          	if(t3 == t6){
				fm.add_months.value 	= 0;
				fm.add_days.value 	= 0;
				fm.add_hour.value 	= 0;
				fm.tot_months.value 	= fm.rent_months.value;
				fm.tot_days.value 	= fm.rent_days.value;
				fm.tot_hour.value 	= fm.rent_hour.value;
		}else{//�ʰ� or �̸�
				
				fm.add_months.value 	= parseInt((t6-t3)/m);
				fm.add_days.value 	= parseInt(((t6-t3)%m)/l);
				fm.add_hour.value 	= parseInt((((t6-t3)%m)%l)/lh);						
				fm.tot_months.value 	= parseInt(t6/m);
				fm.tot_days.value 	= parseInt((t6%m)/l);
				fm.tot_hour.value 	= parseInt(((t6%m)%l)/lh);				
		}
        }
        				
					
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
	//����뿩�� �ڵ����
	function getFee_sam(){
		var fm = document.form1;
		fm.action = '/acar/rent_settle/short_fee_nodisplay.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
	//�ݾ� ����	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		//�뿩��
		if(obj==fm.ag_fee_s_amt){
			fm.ag_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) * 0.1) ;
			fm.ag_fee_amt.value = parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.ag_fee_v_amt.value)));
		//�߰��뿩��
		}else if(obj==fm.add_fee_s_amt){
			fm.add_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1) ;
			fm.add_fee_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
			//if(fm.ins_yn.value == 'Y' && fm.rent_months.value == '0'){
			//	fm.add_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) * 0.1) ;	
			//}else{
			//	fm.add_ins_s_amt.value = '0';				
			//}
		}else if(obj==fm.add_fee_v_amt){
			fm.add_fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_v_amt.value)) / 0.1) ;
			fm.add_fee_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
		}else if(obj==fm.add_fee_amt){
			fm.add_fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.add_fee_amt.value))));
			fm.add_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) - toInt(parseDigit(fm.add_fee_s_amt.value)));		
		//�߰���Ÿ���
		}else if(obj==fm.add_etc_s_amt){
			fm.add_etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) * 0.1) ;
			fm.add_etc_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_v_amt.value)));
		}else if(obj==fm.add_etc_v_amt){
			fm.add_etc_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_v_amt.value)) / 0.1) ;
			fm.add_etc_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_v_amt.value)));
		}else if(obj==fm.add_etc_amt){
			fm.add_etc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.add_etc_amt.value))));
			fm.add_etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_amt.value)) - toInt(parseDigit(fm.add_etc_s_amt.value)));		
		//��å��
		}else if(obj==fm.ins_m_s_amt){
			fm.ins_m_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) * 0.1) ;
			fm.ins_m_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)));
		}else if(obj==fm.ins_m_v_amt){
			fm.ins_m_s_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_v_amt.value)) / 0.1) ;
			fm.ins_m_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)));
		}else if(obj==fm.ins_m_amt){
			fm.ins_m_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_m_amt.value))));
			fm.ins_m_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_amt.value)) - toInt(parseDigit(fm.ins_m_s_amt.value)));		
		//������
		}else if(obj==fm.ins_h_s_amt){
			fm.ins_h_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) * 0.1) ;
			fm.ins_h_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)));
		}else if(obj==fm.ins_h_v_amt){
			fm.ins_h_s_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_v_amt.value)) / 0.1) ;
			fm.ins_h_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)));
		}else if(obj==fm.ins_h_amt){
			fm.ins_h_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_h_amt.value))));
			fm.ins_h_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_amt.value)) - toInt(parseDigit(fm.ins_h_s_amt.value)));		
		//������
		}else if(obj==fm.oil_s_amt){
			fm.oil_v_amt.value = parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) * 0.1) ;
			fm.oil_amt.value = parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));
		}else if(obj==fm.oil_v_amt){
			fm.oil_s_amt.value = parseDecimal(toInt(parseDigit(fm.oil_v_amt.value)) / 0.1) ;
			fm.oil_amt.value = parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));
		}else if(obj==fm.oil_amt){
			fm.oil_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.oil_amt.value))));
			fm.oil_v_amt.value = parseDecimal(toInt(parseDigit(fm.oil_amt.value)) - toInt(parseDigit(fm.oil_s_amt.value)));		
		//�뿪���1
		}else if(obj==fm.d_pay_amt1 || obj==fm.d_pay_amt2){
			fm.d_pay_tot_amt.value = parseDecimal(toInt(parseDigit(fm.d_pay_amt1.value)) + toInt(parseDigit(fm.d_pay_amt2.value)));
		}

		fm.ag_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.ag_etc_s_amt.value)));
		fm.ag_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_amt.value)) + toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.ag_etc_amt.value)));
		fm.add_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));		
		fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
	}			

	//�뿪���:���� ���÷���
	function driv_display(){
		var fm = document.form1;
		if(fm.driv_serv_st.options[fm.driv_serv_st.selectedIndex].value == '2'){
			tr_drv2.style.display	= '';						
		}else{
			tr_drv2.style.display	= 'none';
			fm.d_paid_dt1.value = '';
			fm.d_paid_dt2.value = '';
			fm.d_pay_amt1.value = '0';
			fm.d_pay_amt2.value = '0';
			fm.d_pay_tot_amt.value = '0';			
		}	
	}	
	
	//�ݾ� ����	
	function pay_set_amt(){
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;		
		fm.rest_amt1.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value))) ;
		fm.rest_amt2.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value))) ;
	}			
	


	
	// ��Ÿ ------------------------------------------------------------------------------------------------
	
	//������ġ ��ȸ
	function car_map(){
/*		var fm = document.form1;
		var SUBWIN="car_map.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarMap", "left=50, top=50, width=730, height=530, scrollbars=yes");
*/		
	}

	//����������Ȳ ��ȸ
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}

	//��������������Ȳ ��ȸ
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}


	//����ϱ�
	function all_reset(){
		var fm = document.form1;	
		fm.reset();
	}
	
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.sett_dt.value == ''){ alert('�������ڸ� Ȯ���Ͻʽÿ�'); fm.sett_dt.focus(); return; }
		if(fm.run_km.value == ''){ alert('��������Ÿ��� Ȯ���Ͻʽÿ�'); fm.run_km.focus(); return; }
		if(fm.rent_st.value == '1' && (fm.add_months.value != '0' || fm.add_days.value != '0' || fm.add_hour.value != '0') && fm.add_fee_s_amt.value == '0'){
//			alert('�ڵ������ �Ͻʽÿ�'); return;
		}

		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
	
		fm.action = 'rent_settle_i_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
	}
	
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;		
		var brch_id = fm.brch_id.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var s_cc 	= fm.s_cc.value;
		var s_year 	= fm.s_year.value;				
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		location = "/acar/rent_settle/rent_se_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&brch_id="+brch_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_cc="+s_cc+"&s_year="+s_year+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.run_km.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "01");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"i":request.getParameter("mode");
	String disabled = "";
	String white = "";
	String readonly = "";
	int pay_tot_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	

	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	//����������
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//�Աݽ�����
	Vector conts = rs_db.getScdRentList(s_cd);
	int cont_size = conts.size();
%>
<form action="rent_settle_i_a.jsp" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'>
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>
 <input type='hidden' name='code' value='<%=code%>'>  
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'>
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
 <input type='hidden' name='asc' value='<%=asc%>'>
 <input type='hidden' name='mode' value='<%=mode%>'> 
 
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='s_cd' value='<%=s_cd%>'> 
 <input type='hidden' name='rent_st' value='<%=rent_st%>'>
 <input type='hidden' name='use_st' value='<%=use_st%>'>
 <input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
 <input type='hidden' name='cust_id' value='<%=rc_bean.getCust_id()%>'> 
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 <input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>
 <input type='hidden' name='h_deli_dt' value='<%=rc_bean.getDeli_dt()%>'>
 <input type='hidden' name='h_ret_dt' value='<%=rc_bean.getRet_dt()%>'> 
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'> 
 <input type='hidden' name='ins_yn' value='<%=rf_bean.getIns_yn()%>'>   

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �繫ȸ�� > ������� > <span class=style5>������ 
                        ( 
                       <%if(rent_st.equals("1")){%>
                �ܱ�뿩 
                <%}else if(rent_st.equals("2")){%>
                ������� 
                <%}else if(rent_st.equals("3")){%>
                ������ 
                <%}else if(rent_st.equals("9")){%>
                ������� 
                <%}else if(rent_st.equals("10")){%>
                �������� 
                <%}else if(rent_st.equals("4")){%>
                �����뿩 
                <%}else if(rent_st.equals("5")){%>
                �������� 
                <%}else if(rent_st.equals("6")){%>
                �������� 
                <%}else if(rent_st.equals("7")){%>
                �������� 
                <%}else if(rent_st.equals("8")){%>
                ������ 
                <%}else if(rent_st.equals("11")){%>
                �����
                <%}else if(rent_st.equals("12")){%>
                ����Ʈ
                <%}%>	
                        )</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
        <td align="right" width="70%">
	    <img src=/acar/images/center/arrow.gif> <%=reserv.get("CAR_NO")%> �뿩����Ʈ <a href="javascript:car_reserve();"><img src="/acar/images/center/button_see.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;&nbsp;<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>&nbsp;
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save();'> <img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
        <%}%>
        <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a><a href='javascript:save();'></a>		
	    </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                <td class=title>������ȣ</td>
                <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                <td class=title>����</td>
                <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                <td class=title>�����ȣ</td>
                <td colspan="3">&nbsp;<%=reserv.get("CAR_NUM")%></td>
              </tr>
              <tr> 
                <td class=title width=10%>���ʵ����</td>
                <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                <td class=title width=10%>�������</td>
                <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                <td class=title width=11%>��ⷮ</td>
                <td width=10%>&nbsp;<%=reserv.get("DPM")%>cc</td>
                <td class=title width=10%>Į��</td>
                <td width=10%>&nbsp;<%=reserv.get("COLO")%></td>
                <td class=title width=9%>����</td>
                <td width=10%>&nbsp;<%=reserv.get("FUEL_KD")%></td>
              </tr>
              <tr> 
                <td class=title>���û��</td>
                <td colspan="3">&nbsp;<%=reserv.get("OPT")%></td>
                <td class=title>���翹������Ÿ�</td>
                <td>&nbsp;<%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
                <td class=title>����������</td>
                <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SERV_DT")))%></td>
              </tr>
            </table>
      </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("12")){%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        <td align="right"></td>
    </tr>
    <%if(rent_st.equals("1") || rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("9") || rent_st.equals("10") || rent_st.equals("12")){%>
     <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%><%=rc_bean2.getCust_st()%></td>
                    <td class=title width=10%>����</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=18%>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class=title width=11%>����ڵ�Ϲ�ȣ</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getEnp_no()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(rc_bean2.getCust_id(),"USER")%></td>
                    <td class=title width=10%>�����Ҹ�</td>
                    <td width=15%>&nbsp;<%=rc_bean2.getBrch_nm()%></td>
                    <td class=title width=10%>�μ���</td>
                    <td width=30%>&nbsp;<%=rc_bean2.getDept_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}%>
    <%if(rent_st.equals("2")){
		//�����������
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
		
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=25%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=16%>&nbsp;<%=serv.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=29%>&nbsp;<%=serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("3")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=25%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=16%>&nbsp;<%=accid.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=29%>&nbsp;<%=accid.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=accid.get("P_NUM")%></td>
                    <td class=title>�����ں����</td>
                    <td>&nbsp;<%=accid.get("G_INS")%></td>
                    <td class=title>�����</td>
                    <td>&nbsp;<%=accid.get("G_INS_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//�����������
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getRent_s_cd());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title> ������ȣ</td>
                    <td>&nbsp;<%=ri_bean.getIns_num()%></td>
                    <td class=title>�����</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id' disabled>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>�����</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_nm()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=16%>&nbsp;<%=ri_bean.getIns_tel()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_tel2()%></td>
                    <td class=title width=10%>�ѽ�</td>
                    <td width=14%>&nbsp;<%=ri_bean.getIns_fax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
    <%}else if(rent_st.equals("6")){
		//������������
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=41%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%> ��������</td>
                    <td width=39%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("7")){%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=90%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("8")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=25%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>�������</td>
                    <td width=16%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td class=title width=10%>�����</td>
                    <td width=29%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=10%>&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=11%>������</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
                    <td width=10% class=title>�����</td>
                    <td colspan=3>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="5">&nbsp;<%=rc_bean.getEtc()%></td>
                    <td class=title>�����Ⱓ</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>~ 
                      <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_cont style="display:<%if(rent_st.equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�������</td>
                    <td width=10%> 
                      <%if(rf_bean.getDriver_yn().equals("Y")){%>
                      &nbsp;���� 
                      <%}else{%>
                      &nbsp;������ 
                      <%}%>
                    </td>
                    <td class=title width=10%>���ú���</td>
                    <td> 
                      <%if(rf_bean.getIns_yn().equals("Y")){%>
                      &nbsp;���� 
                      <%}else{%>
                      &nbsp;�̰��� 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title>�����Ͻ�</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���ʾ����ð�</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=whitenum readonly>
                      �ð� 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum readonly>
                      �� 
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=whitenum readonly>
                      ���� </td>
                    <td class=title width=10%>�߰��̿�ð�</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="add_hour" value="" size="2" class=num >
                      �ð� 
                      <input type="text" name="add_days" value="" size="2" class=num >
                      �� 
                      <input type="text" name="add_months" value="" size="2" class=num >
                      ���� </td>
                    <td class=title width=10%>���̿�ð�</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="tot_hour" value="" size="2" class=num >
                      �ð� 
                      <input type="text" name="tot_days" value="" size="2" class=num >
                      �� 
                      <input type="text" name="tot_months" value="" size="2" class=num >
                      ���� </td>
                </tr>
                <tr> 
                    <td class=title>���</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="etc" value="" size="130" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩��� ����</span></td>
        <td align="right"><a href="javascript:getFee_sam();"><img src=/acar/images/center/button_jdgs.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0" width=100%>
            	<tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=41%> 
                        &nbsp;<input type="text" name="sett_dt" value="<%=AddUtil.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>��������Ÿ�</td>
                    <td width=39%> 
                        &nbsp;<input type="text" name="run_km" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_sett1 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% rowspan="2" class=title>����</td>
                    <td colspan="3" class=title>�뿩��</td>
                    <td width=10% rowspan="2" class=title>���ú����</td>
                    <td width=10% rowspan="2" class=title>������</td>
                    <td width=10% rowspan="2" class=title>������</td>
                    <td width=10% rowspan="2" class=title>�Ұ�(��)<!--(��)--></td>
                    <td rowspan="2" class=title>�հ�(VAT����)</td>
                </tr>
                <tr>
                  <td width=10% class=title>����</td>
                  <td width=10% class=title>������̼�</td>
                  <td width=10% class=title>��Ÿ</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td align="center">
                      <input type='hidden' name='ag_fee_amt' value=''>
                      <input type='hidden' name='ag_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()-rf_bean.getDc_v_amt())%>'>			 
                      <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()-rf_bean.getDc_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_navi_amt' value=''>
                      <input type='hidden' name='ag_navi_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>'>			 
                      <input type="text" name="ag_navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_etc_amt' value=''>
                      <input type='hidden' name='ag_etc_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>'>			 
                      <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_cons1_amt' value=''>
                      <input type='hidden' name='ag_cons1_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>'>			 
                      <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_cons2_amt' value=''>
                      <input type='hidden' name='ag_cons2_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>'>			 
                      <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>                      
                    <td align="center"> 
                      <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt())%>" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr>
                  <td class=title>�߰�</td> 
                    <td align="center">
                      <input type='hidden' name='add_fee_amt' value='0'>
                      <input type='hidden' name='add_fee_v_amt' value='0'>
                      <input type="text" name="add_fee_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">
                      <input type='hidden' name='add_navi_amt' value='0'>
                      <input type='hidden' name='add_navi_v_amt' value='0'>
                      <input type="text" name="add_navi_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">
                      <input type='hidden' name='add_etc_amt' value='0'>
                      <input type='hidden' name='add_etc_v_amt' value='0'>
                      <input type="text" name="add_etc_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>                      
                    <td align="center"> 
                      <input type="text" name="add_ins_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center">
                      <input type='hidden' name='add_cons1_amt' value='0'>
                      <input type='hidden' name='add_cons1_v_amt' value='0'>
                      <input type="text" name="add_cons1_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>                      
                    <td align="center">
                      <input type='hidden' name='add_cons2_amt' value='0'>
                      <input type='hidden' name='add_cons2_v_amt' value='0'>
                      <input type="text" name="add_cons2_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>                      
                    <td align="center"> 
                      <input type="text" name="add_tot_s_amt" value="0" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="add_tot_amt" value="0" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr></tr><tr></tr>            
    <tr id=tr_sett2 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>    				
                <tr>
                  <td class=title width=10%>�Ұ�</td> 
                    <td align="center" width=10%> 
                      <input type="text" name="tot_fee_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_navi_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_etc_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_ins_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_cons_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_clss_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center" width=10%> 
                      <input type="text" name="rent_tot_s_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="0" size="10" readonly class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr></tr><tr></tr>            
    <tr id=tr_sett3 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr> 
                    <td class=title rowspan="7" width=3%>��<br>��<br>��<br>��</td>
                    <td class=title width=7%>����</td>
                    <td class=title width=10%>���ް�</td>
                    <td class=title width=10%>�ΰ���</td>
                    <td class=title width=10%>�հ�</td>
                    <td class=title width=60%>���</td>
                </tr>
                <tr>
                  <td class=title>�����</td> 
                    <td align="center"> 
                      <input type='hidden' name='cls_amt' value='0'>
                      <input type='hidden' name='cls_v_amt' value='0'>
                      <input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
�� </td>
                    <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
�� </td>
                    <td>�ܿ��Ⱓ �뿩����� 10%�� ������� �ΰ��˴ϴ�.                   </td>
                </tr>
                <tr>
                  <td class=title>��å��</td>
                  <td align="center"><input type='hidden' name='ins_m_amt' value='0'>
                    <input type='hidden' name='ins_m_v_amt' value='0'>
                    <input type="text" name="ins_m_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td align="center"><input type='hidden' name='ins_h_amt' value='0'>
                    <input type='hidden' name='ins_h_v_amt' value='0'>
                    <input type="text" name="ins_h_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td>���� ��å������ ���� ���߻��� �뿩������ �����Ⱓ�� �ش��ϴ� �뿩����� 50%�� ���� �δ��մϴ�. </td>
                </tr>
                <tr>
                  <td class=title>������</td>
                  <td align="center"><input type='hidden' name='oil_amt' value='0'>
                    <input type='hidden' name='oil_v_amt' value='0'>
                    <input type="text" name="oil_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class=title>KM�ʰ�����</td>
                  <td align="center"><input type='hidden' name='km_amt' value='0'>
                    <input type='hidden' name='km_v_amt' value='0'>
                    <input type="text" name="km_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td> 5,000km/1����, �ʰ��� 1km�� 80���� �߰������ �ΰ��˴ϴ�. </td>
                </tr>
                <tr>
                  <td class=title>�Ұ�</td>
                  <td align="center"><input type="text" name="etc_tot_s_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td align="center"><input type="text" name="etc_tot_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
��</td>
                  <td>&nbsp;</td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_pay_nm style='display:<%if(rf_bean.getPaid_way().equals("1")){%>block<%}else{%>none<%}%>'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ա�ó��</span></td>
    </tr>
    <tr id=tr_pay1 style='display:<%if(rf_bean.getPaid_way().equals("1")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=20%>����</td>
                    <td class=title width=20%> 
                        <p>�������</p>
                    </td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>�ݾ�</td>
                    <td class=title width=20%>���</td>
                </tr>
    		  <%
    			if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);%>		  
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      ���ຸ���� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      �����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      �뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      ����� 
                      <%}%>
                    </td>
                    <td align="center">
        			<%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>
        			����
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>
        			ī��
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>
        			�ڵ���ü
        			<%}%>				
        			</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"><input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">-</td>
                </tr>
    		  <%		pay_tot_amt = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		}
    		  	}%> 			  
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"><input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_drv_nm style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿪���(�������)</span></td>
    </tr>
    <tr id=tr_drv1 style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=3 style='height:1'></td>
                </tr>
                <tr> 
                    <td class="title" width=10%>�������</td>
                    <td> 
                      <select name="driv_serv_st" onchange="javascript:driv_display();">
                        <option value="">����</option>
                        <option value="1">�Ҽӿ뿪ȸ��� ���� ����</option>
                        <option value="2">�뿩�� ����� �ջ�</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv2 style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=20%>����</td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>�ݾ�</td>
                    <td class=title width=20%>���</td>
                </tr>
                <tr id=tr_scd style='display:block'> 
                    <td align="center">�Ա� 
                        <input type="hidden" name="d_rent_st1" value="1">
                    </td>
                    <td align="center"> 
                        <select name="d_paid_st1">
                            <option value="1">ī��</option>
                            <option value="2">����</option>
                            <option value="3">�ڵ���ü</option>
                        </select>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=text name="d_pay_dt1" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=num name="d_pay_amt1" value=""onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                        ��</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td align="center">
                        <input type="hidden" name="d_rent_st2" value="2">
                    </td>
                    <td align="center"> 
                        <select name="d_paid_st2">
                            <option value="1">ī��</option>
                            <option value="2">����</option>
                            <option value="3">�ڵ���ü</option>
                        </select>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=text name="d_pay_dt2" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=num name="d_pay_amt2" value="" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                        ��</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class="title"> �հ�</td>
                    <td align="center">&nbsp; </td>
                    <td align="center">&nbsp; </td>
                    <td align="center"> 
                        <input type='text' size='12' class=whitenum name="d_pay_tot_amt" value="0" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv3 style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width=10%>���</td>
                    <td> 
                      <input type='text' size='90' class=text name="driv_serv_etc" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm2 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id=tr_sett2 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�������</td>
                    <td class=title_p style='text-align:left'> 
                      &nbsp;&nbsp;<input type='text' size='12' class=text name="rent_sett_amt" value="" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      �� (����뿩�� �հ� - �Ա�ó�� �հ�, �������/�뿩������� �ջ��� ��� : �뿪��� �հ� ����)</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	//�̿�Ⱓ ����	
	getRentTime();
	
	var fm = document.form1;	
	if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){

		if(fm.add_hour.value == '0' && fm.add_days.value == '0' && fm.add_months.value == '0'){
			fm.add_fee_s_amt.value = '0';
			fm.add_ins_s_amt.value = '0';
			fm.add_etc_s_amt.value = '0';
			fm.add_tot_s_amt.value = '0';
			fm.add_tot_amt.value = '0';		
		}	
		
		fm.ag_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.ag_fee_v_amt.value)));
		fm.ag_navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_v_amt.value)));
		fm.ag_etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.ag_etc_v_amt.value)));	
		fm.ag_cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_v_amt.value)));	
		fm.ag_cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons2_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_v_amt.value)));	
		fm.ag_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_s_amt.value)));
		fm.ag_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.ag_navi_amt.value)) 	+ toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.ag_etc_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_amt.value)));
		
		fm.add_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) 		+ toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) 		+ toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) 	+ toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		
		fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_navi_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value)));
		fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_cons_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value)));
		fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		
		
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) 	+ toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) 		+ toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));
		
		if(fm.rent_st.value == '1' || fm.rent_st.value == '12'){
			fm.rent_sett_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
		}else{
			fm.rent_sett_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));
		}
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
