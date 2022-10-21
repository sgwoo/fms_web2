<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
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

		d1 = fm.h_rent_start_dt.value+'00';
		d2 = fm.h_rent_end_dt.value+'00';		
		d3 = fm.h_deli_dt.value+'00';
		d4 = fm.h_ret_dt.value+'00';	
											
		t1 = getDateFromString(d1).getTime();
		t2 = getDateFromString(d2).getTime();
		t3 = t2 - t1;	
		t4 = getDateFromString(d3).getTime();
		t5 = getDateFromString(d4).getTime();
		t6 = t5 - t4;	

		if(t3 == t6){
			fm.add_months.value = 0;
			fm.add_days.value = 0;
			fm.add_hour.value = 0;
			fm.tot_months.value = fm.rent_months.value;
			fm.tot_days.value = fm.rent_days.value;
			fm.tot_hour.value = fm.rent_hour.value;		
		}else{//�ʰ� or �̸�
			fm.add_months.value 	= parseInt((t6-t3)/m);
			fm.add_days.value 		= parseInt(((t6-t3)%m)/l);
			fm.add_hour.value 		= parseInt((((t6-t3)%m)%l)/lh);						
			fm.tot_months.value 	= parseInt(t6/m);
			fm.tot_days.value 		= parseInt((t6%m)/l);
			fm.tot_hour.value 		= parseInt(((t6%m)%l)/lh);				
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
		//�߰��뿩��
		if(obj==fm.add_fee_s_amt){
			fm.add_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1) ;
			fm.add_fee_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
			if(fm.ins_yn.value == 'Y' && fm.rent_months.value == '0'){
				fm.add_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) * 0.1) ;	
			}else{
				fm.add_ins_s_amt.value = '0';				
			}
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

		fm.add_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value = parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		fm.tot_fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_etc_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));		
		fm.rent_sett_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
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
		location = "/acar/rent_end/rent_en_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&brch_id="+brch_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_cc="+s_cc+"&s_year="+s_year+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
//-->
</script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"5":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"j.sett_dt":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"c":request.getParameter("mode");
	int pay_tot_amt = 0;
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(mode.equals("u")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ
	int user_size = users.size();	
	
	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
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
	//�ܱ�뿩��������
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
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
 <input type='hidden' name='cust_id' value='<%=rc_bean.getCust_id()%>'>
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 <input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>
 <input type='hidden' name='h_deli_dt' value='<%=rc_bean.getDeli_dt()%>'>
 <input type='hidden' name='h_ret_dt' value='<%=rc_bean.getRet_dt()%>'> 
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'> 
 <input type='hidden' name='ins_yn' value='<%=rf_bean.getIns_yn()%>'>   

  <table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td colspan="2"><font color="navy">����ý��� -> ��������</font> -><font color="red"> 
        </font><font color="red">��೻�� ( 
        <%if(rent_st.equals("1")){%>
        �ܱ�뿩 
        <%}else if(rent_st.equals("2")){%>
        ������� 
        <%}else if(rent_st.equals("3")){%>
        ������ 
        <%}else if(rent_st.equals("9")){%>
        ������� 
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
        ��Ÿ 
        <%}else if(rent_st.equals("12")){%>
        ����Ʈ
        <%}%>
        )</font></td>
    </tr>
    <tr> 
      <td width="50%">< �������� ></td>
      <td align="right" width="50%"> <a href="javascript:car_reserve();"><%=reserv.get("CAR_NO")%></a> 
        || <a href="javascript:car_reserve2();">�����ڵ���</a> �뿩����Ʈ</td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width=80>������ȣ</td>
            <td align="center" width=90><%=reserv.get("CAR_NO")%></td>
            <td class=title width=70>����</td>
            <td align="left" colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
            <td class=title width=70>�����ȣ</td>
            <td align="left" colspan="3">&nbsp;<%=reserv.get("CAR_NUM")%></td>
          </tr>
          <tr> 
            <td class=title>���ʵ����</td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
            <td class=title>�������</td>
            <td align="center" width=85><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
            <td class=title width=110>��ⷮ</td>
            <td align="center" width="65"><%=reserv.get("DPM")%>cc</td>
            <td class=title>Į��</td>
            <td align="center" width=60><%=reserv.get("COLO")%></td>
            <td class=title width="50">����</td>
            <td align="center" width="120"><%=reserv.get("FUEL_KD")%></td>
          </tr>
          <tr> 
            <td class=title>���û��</td>
            <td colspan="3">&nbsp;<%=reserv.get("OPT")%></td>
            <td class=title>���翹������Ÿ�</td>
            <td align="center"><%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
            <td class=title>����������</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SERV_DT")))%></td>
          </tr>
          <tr> 
            <td class=title>����������</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAX_DT")))%></td>
            <td class=title>������ġ</td>
            <td align="center"><a href="javascript:car_map();">��ġ����</a></td>
            <td class=title>�ε�������</td>
            <td colspan="3">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%} else {%>none<%}%>"> 
      <td>< ������ ></td>
      <td align="right"> 
        <!--<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                <a href='javascript:save();'> <img src="/images/up_info.gif" width="50" height="18" aligh="absmiddle" border="0"> 
        </a>
        <%}%>
        <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a><a href='javascript:save();'> 
        </a> -->
        <a href='javascript:save();'> </a></td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"><font color="#FFFF00">����</font></td>
            <!--<a href="javascript:cust_select()"></a>-->
            <td width="130"> 
              <input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
              <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="15" class=whitetext>
            </td>
            <td class=title width="80">����</td>
            <td colspan="3"> 
              <input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="45" class=whitetext>
            </td>
            <td class=title width="85">�������</td>
            <td> 
              <input type="text" name="c_ssn" value="<%=rc_bean2.getSsn()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">��ȣ</td>
            <td colspan="5"> 
              <input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
            </td>
            <td class=title width="85">����ڵ�Ϲ�ȣ</td>
            <td> 
              <input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('c_zip').value = data.zonecode;
							document.getElementById('c_addr').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class=title width="80">�ּ�</td>
            <td colspan="7"> 
			<input type="text" name='c_zip' id="c_zip" size="7" value="<%=rc_bean2.getZip()%>" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr" value="<%=rc_bean2.getAddr()%>" size="100">

            </td>
          </tr>
          <tr> 
            <td class=title width="80">���������ȣ</td>
            <td> 
              <input type="text" name="c_lic_no" value="<%=rc_bean2.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
            </td>
            <td class=title width="80">��������</td>
            <td width="100"> 
              <input type="text" name="c_lic_st" value="<%=rc_bean2.getLic_st()%>" size="13" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td class=title width="80">��ȭ��ȣ</td>
            <td width="110"> 
              <input type="text" name="c_tel" value="<%=rc_bean2.getTel()%>" class=whitetext size="15">
            </td>
            <td class=title>�޴���</td>
            <td> 
              <input type="text" name="c_m_tel" value="<%=rc_bean2.getM_tel()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">��󿬶�ó</td>
            <td  colspan='7'> 
              <input type="hidden" name="mgr_st2" value="2">
              ����:&nbsp; 
              <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
              &nbsp;&nbsp; ����ó:&nbsp; 
              <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
              &nbsp; ����:&nbsp; 
              <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=<%=white%>text>
            </td>
          </tr>
          <tr> 
            <td class=title rowspan="2"><%if(rent_st.equals("12")){%>�߰�������<%}else{%>�ǿ�����<br>(�뿪��� ��)<%}%></td>
            <td  colspan='7'> 
              <input type="hidden" name="mgr_st1" value="1">
              ����:&nbsp; 
              <input type="text" name="mgr_nm1" value="<%=rm_bean1.getMgr_nm()%>" class=<%=white%>text size="10">
              &nbsp;&nbsp; �������:&nbsp; 
              <input type="text" name="m_ssn1" value="<%=rm_bean1.getSsn()%>" size="15" maxlength='8' class=<%=white%>text>
              &nbsp; ���������ȣ:&nbsp; 
              <input type="text" name="m_lic_no1" value="<%=rm_bean1.getLic_no()%>" size="16" class=<%=white%>text>
              ��ȭ��ȣ:&nbsp; 
              <input type="text" name="m_tel1" value="<%=rm_bean1.getTel()%>" size="15" class=<%=white%>text>
            </td>
          </tr>
		  <script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('m_zip1').value = data.zonecode;
							document.getElementById('m_addr1').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td  colspan='7'> �ּ�:&nbsp; 
			<input type="text" name='m_zip1' id="m_zip1" size="7" value="<%=rm_bean1.getZip()%>" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr1" value="<%=rm_bean1.getAddr()%>" size="95">

            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3")){%>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"><font color="#FFFF00">����</font></td>
            <!--<a href="javascript:cust_select()"></a>-->
            <td width="130"> 
              <input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
              <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="15" class=whitetext>
            </td>
            <td class=title width="80">����</td>
            <td width="297"> 
              <input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="45" class=whitetext>
            </td>
            <td class=title width="85">�������</td>
            <td> 
              <input type="text" name="c_ssn" value="<%=rc_bean2.getSsn()%>" size="15" maxlength='8' class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">��ȣ</td>
            <td colspan="3"> 
              <input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
            </td>
            <td class=title>����ڵ�Ϲ�ȣ</td>
            <td> 
              <input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">��󿬶�ó</td>
            <td  colspan='7'> 
              <input type="hidden" name="mgr_st2" value="2">
              ����:&nbsp; 
              <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
              &nbsp;&nbsp; ����ó:&nbsp; 
              <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
              &nbsp; ����:&nbsp; 
              <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=<%=white%>text>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <input type='hidden' name='c_zip' value=''>
    <input type='hidden' name='c_addr' value=''>
    <input type='hidden' name='c_lic_no' value=''>
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_tel' value=''>
    <input type='hidden' name='c_m_tel' value=''>
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <input type='hidden' name='c_firm_nm' value='(��)�Ƹ���ī'>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"><font color="#FFFF00">����</font></td>
            <td width="125"> 
              <input type='hidden' name='cust_st' value='4'>
              <input type="text" name="c_cust_st" value="����" size="15" class=whitetext>
            </td>
            <td class=title width="80">����</td>
            <td width="110"> 
              <select name='c_cust_nm' onChange='javascript:user_select()' <%=disabled%>>
                <option value="">==����==</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%		}
					}		%>
              </select>
            </td>
            <td class=title width="80">�����Ҹ�</td>
            <td width="125"> 
              <input type="text" name="c_brch_nm" value="<%=rc_bean2.getBrch_nm()%>" size="15" class=whitetext>
            </td>
            <td class=title width="90">�μ���</td>
            <td> 
              <input type="text" name="c_dept_nm" value="<%=rc_bean2.getDept_nm()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">���������ȣ</td>
            <td width="125"> 
              <input type="text" name="c_lic_no" value="<%=rc_bean2.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
            </td>
            <td class=title width="80">��������</td>
            <td width="110"> 
              <input type="text" name="c_lic_st" value="<%=rc_bean2.getLic_st()%>" size="15" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td class=title width="80">��ȭ��ȣ</td>
            <td width="125"> 
              <input type="text" name="c_tel" value="<%=rc_bean2.getTel()%>" class=whitetext size="15">
            </td>
            <td class=title>�޴���</td>
            <td> 
              <input type="text" name="c_m_tel" value="<%=rc_bean2.getM_tel()%>" size="15" class=whitetext>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else{%>
    <input type='hidden' name='c_cust_st' value='5'>
    <input type='hidden' name='c_cust_nm' value=''>
    <input type='hidden' name='c_firm_nm' value=''>
    <input type='hidden' name='c_ssn' value=''>
    <input type='hidden' name='c_enp_no' value=''>
    <input type='hidden' name='c_lic_no' value=''>
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_zip' value=''>
    <input type='hidden' name='c_addr' value=''>
    <%}%>
    <%if(rent_st.equals("2")){
		//�����������
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
    <tr> 
      <td colspan="2">< ������� ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">��������</td>
            <td width="160"><%=serv.get("OFF_NM")%></td>
            <td class=title width="90">����������ȣ</td>
            <td width="110"><%=serv.get("CAR_NO")%></td>
            <td class=title width="80">����</td>
            <td width="280"><%=serv.get("CAR_NM")%></td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("3")){
		//�����������
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr> 
      <td colspan="2">< ��������� ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">��������</td>
            <td width="160"><%=accid.get("OFF_NM")%></td>
            <td class=title width="90">����������ȣ</td>
            <td width="110"><%=accid.get("CAR_NO")%></td>
            <td class=title width="80">����</td>
            <td width="280"><%=accid.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class=title> ������ȣ</td>
            <td><%=accid.get("P_NUM")%></td>
            <td class=title>�����ں����</td>
            <td><%=accid.get("G_INS")%></td>
            <td class=title>�����</td>
            <td><%=accid.get("G_INS_NM")%></td>
          </tr>
        </table>
      </td>
    </tr>
	<%}else if(rent_st.equals("9")){
		//�����������
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getSub_c_id());%>
    <tr> 
      <td colspan="2">< ������� ></td>
    </tr>	
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"> ������ȣ</td>
            <td width="125"><%=ri_bean.getIns_num()%></td>
            <td class=title width="80">�����</td>
            <td colspan="5"> 
              <select name='ins_com_id' disabled>
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
            <td class=title width="80"> �����</td>
            <td width="125"><%=ri_bean.getIns_nm()%></td>
            <td class=title width="80">����ó��</td>
            <td width="110"><%=ri_bean.getIns_tel()%></td>
            <td class=title width="80">����ó��</td>
            <td><%=ri_bean.getIns_tel2()%></td>
            <td class=title width="80">�ѽ�</td>
            <td><%=ri_bean.getIns_fax()%></td>
          </tr>
        </table>
      </td>
    </tr>			
    <%}else if(rent_st.equals("6")){%>
    <tr> 
      <td colspan="2">< �������� ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">��������</td>
            <td width="160">&nbsp;</td>
            <td class=title width="90"> ��������</td>
            <td width="470">&nbsp; </td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("7")){%>
    <tr> 
      <td colspan="2">< �������� ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">��������</td>
            <td width="160">&nbsp;</td>
            <td class=title width="90"> ���˽ǽ���</td>
            <td width="110">&nbsp;</td>
            <td class=title width="80">���˾�ü��</td>
            <td width="280">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("8")){%>
    <tr> 
      <td colspan="2">< ������ ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">��������</td>
            <td width="160">&nbsp;</td>
            <td class=title width="90">�������</td>
            <td width="110">&nbsp;</td>
            <td class=title width="80">�����</td>
            <td width="280">&nbsp;</td>
          </tr>
          <tr> 
            <td class=title width="80"> �����</td>
            <td colspan="5">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <%}%>
    <tr> 
      <td colspan="2">< ������� ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width='80'>����ȣ</td>
            <td width='60'><%=rc_bean.getRent_s_cd()%></td>
            <td class=title width='60'>�������</td>
            <td width="80" ><%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
            <td class=title width='50'>������</td>
            <td width="90" ><%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
            <td width="50" class=title>�����</td>
            <td width="60" ><%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
            <td width="70" class=title>�̿�Ⱓ</td>
            <td width="200" ><%=AddUtil.ChangeDate4(rc_bean.getRent_start_dt())%>~ 
              <%=AddUtil.ChangeDate4(rc_bean.getRent_end_dt())%></td>
          </tr>
          <tr> 
            <td class=title>��Ÿ</td>
            <td colspan="9"><%=rc_bean.getEtc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">< ����/���� ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">���������Ͻ�</td>
            <td width="180"><%=AddUtil.ChangeDate4(rc_bean.getDeli_plan_dt())%>�� 
            </td>
            <td class=title width="80">���������Ͻ�</td>
            <td colspan="3"> <%=AddUtil.ChangeDate4(rc_bean.getRet_plan_dt())%>��</td>
          </tr>
          <tr> 
            <td class=title width="80">�����Ͻ�</td>
            <td width="180"><%=AddUtil.ChangeDate4(rc_bean.getDeli_dt())%>�� </td>
            <td class=title width="80">�����Ͻ�</td>
            <td colspan="3"> <%=AddUtil.ChangeDate4(rc_bean.getRet_dt())%>��</td>
          </tr>
          <tr> 
            <td class=title width="80">������ġ</td>
            <td width="180"><%=rc_bean.getDeli_loc()%></td>
            <td class=title width="80">������ġ</td>
            <td colspan="3"><%=rc_bean.getRet_loc()%></td>
          </tr>
          <tr> 
            <td class=title width="80">���������</td>
            <td width="180"><%=c_db.getNameById(rc_bean.getDeli_mng_id(), "USER")%></td>
            <td class=title width="80">���������</td>
            <td colspan="3"> <%=c_db.getNameById(rc_bean.getRet_mng_id(), "USER")%></td>
          </tr>
          <tr> 
            <td class=title>���ʾ����ð�</td>
            <td> 
              <input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=whitenum readonly>
              �ð� 
              <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum readonly>
              �� 
              <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=whitenum readonly>
              ���� </td>
            <td class=title>�߰��̿�ð�</td>
            <td width="180"> 
              <input type="text" name="add_hour" value="<%=rs_bean.getAdd_hour()%>" size="2" class=<%=white%>num >
              �ð� 
              <input type="text" name="add_days" value="<%=rs_bean.getAdd_days()%>" size="2" class=<%=white%>num >
              �� 
              <input type="text" name="add_months" value="<%=rs_bean.getAdd_months()%>" size="2" class=<%=white%>num >
              ���� </td>
            <td class=title width="80">���̿�ð�</td>
            <td> 
              <input type="text" name="tot_hour" value="<%=rs_bean.getTot_hour()%>" size="2" class=<%=white%>num >
              �ð� 
              <input type="text" name="tot_days" value="<%=rs_bean.getTot_days()%>" size="2" class=<%=white%>num >
              �� 
              <input type="text" name="tot_months" value="<%=rs_bean.getTot_months()%>" size="2" class=<%=white%>num >
              ���� </td>
          </tr>
          <tr> 
            <td class=title>���</td>
            <td colspan="5"> 
              <input type="text" name="etc" value="" size="110" class=<%=white%>text>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr align="right"> 
      <td colspan="2"><a href='javascript:self.close();' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>	
  </table>
</form>
<script language='javascript'>
<!--
/*
	getRentTime();

	var fm = document.form1;	
	if(fm.rent_st.value == '1' || fm.rent_st.value == '9'){
		fm.add_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.s_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));
		if(fm.rent_st.value == '1'){
			fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
		}else{
			fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));		
		}
	}
*/	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
