<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.user_mng.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();	
	
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id = request.getParameter("br_id")  ==null?acar_br:request.getParameter("br_id");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String andor = request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	String fee_rent_st = request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	//�ڵ����⺻����-�⺻����
	CarMstBean cm_bean2 = cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());		
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	
	//cont_etc.getGrt_suc_l_cd()
	//grt_suc_m_id, grt_suc_l_cd
	
	//���������
	int grt_suc_fee_size = 0;
	ContFeeBean grt_suc_fee = new ContFeeBean();
	
	if(!cont_etc.getGrt_suc_l_cd().equals("")){
		grt_suc_fee_size = af_db.getMaxRentSt(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
		grt_suc_fee = a_db.getContFeeNew(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd(), grt_suc_fee_size+"");		
	}
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type-"text/css>
<!--	
input.whitetextredb		{ text-align:left; font-size : 9pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#ff0000;  font-weight:bold;}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//����������� ���÷���
	function display_tae(){
		var fm = document.form1;
		if(fm.prv_dlv_yn[0].checked == true){//����
			tr_tae2.style.display = 'none';
		}else{ //�ִ�
			tr_tae2.style.display = '';
		}
	}
	//��������� ��ȸ
	function car_search(st){
		var fm = document.form1;
		if(st == 'taecha'){window.open("search_res_car.jsp?taecha=Y&client_id=<%=base.getClient_id()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");
		}else{window.open("search_ext_car.jsp?taecha=Y", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");}
	}
	//����
	function update(idx){
		var fm = document.form1;

		
				<%if(!base.getCar_st().equals("2")){%>
					if(fm.prv_dlv_yn[1].checked == true){
						if(fm.tae_car_no.value == '')		{ alert('���������-�ڵ����� �����Ͻʽÿ�.'); 			fm.tae_car_no.focus(); 		return; }					
						if(fm.tae_car_rent_st.value == '')	{ alert('���������-�뿩�������� �Է��Ͻʽÿ�.'); 		fm.tae_car_rent_st.focus(); return; }
						if(fm.tae_req_st.value == '')		{ alert('���������-û�����θ� �����Ͻʽÿ�.'); 		fm.tae_req_st.focus(); 		return; }
						if(fm.tae_req_st.value == '1'){
							if(toInt(parseDigit(fm.tae_rent_fee.value)) == 0)	{ alert('���������-���뿩�Ḧ �Է��Ͻʽÿ�.'); 			fm.tae_rent_fee.focus(); 	return; }
							if(toInt(parseDigit(fm.tae_rent_inv.value)) == 0)	{ alert('���������-�������� �Է��Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
							if(fm.tae_est_id.value == '')	{ alert('���������-������ ����ϱ⸦ �Ͻʽÿ�.'); 			fm.tae_rent_inv.focus(); 	return; }
							<%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
                            <%}else{%>
							if(fm.tae_rent_fee_st[0].checked == false && fm.tae_rent_fee_st[1].checked == false){
								alert('��������� ������ <����� ���� �뿩 ��� ������ �������> �׸� ����Ʈ �������� ǥ��Ǿ� �ִ� ��쿡 ����Ʈ �������� �Է��ϰ�, ����Ʈ �������� ǥ��Ǿ� ���� ���� ��쿡�� ���������� ǥ��Ǿ� ���� ������ üũ���ּ���.'); return;
							}else{
								if(fm.tae_rent_fee_st[0].checked == true){
									if(toInt(parseDigit(fm.tae_rent_fee_cls.value)) == 0){ alert('���� ������ �������(����Ʈ������)�� �Է��Ͻʽÿ�.'); return;									}
									if(toInt(parseDigit(fm.tae_rent_fee.value)) >= toInt(parseDigit(fm.tae_rent_fee_cls.value)))	{ alert('���� ������ �������(����Ʈ������)���� ����������� ���뿩�Ẹ�� ũ�� �ʽ��ϴ�. Ȯ���Ͻʽÿ�.'); 			fm.tae_rent_fee_cls.focus(); 	return; }
								}else{
									fm.tae_rent_fee_cls.value = 0;
								}								
							}
							<%}%>
							if(fm.tae_tae_st.value == '')	{ alert('���������-��꼭���࿩�θ� �����Ͻʽÿ�.'); 	fm.tae_tae_st.focus(); 		return; }						
						}					
						if(toInt(parseDigit(fm.tae_rent_fee.value))>0){
							fm.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.tae_rent_fee.value))));
							fm.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(fm.tae_rent_fee.value)) - toInt(parseDigit(fm.tae_rent_fee_s.value)));						
						}
						if(fm.tae_sac_id.value == '')		{ alert('���������-�����ڸ� �����Ͻʽÿ�.'); 			fm.tae_sac_id.focus(); 		return; }
					}
					
					if(fm.car_mng_id.value == fm.tae_car_mng_id.value){
						var est_day = getRentTime('d', fm.tae_car_rent_st.value, fm.tae_car_rent_et.value);
						fm.end_rent_link_day.value = est_day;
						var est_amt = (<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>-<%=grt_suc_fee.getFee_s_amt()+grt_suc_fee.getFee_v_amt()%>)/<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
						est_amt = replaceFloatRound(est_amt);
						fm.end_rent_link_per.value = est_amt;						
						if(est_day > 35 || est_amt > 30){
							tr_tae3.style.display = '';
							fm.end_rent_link_sac_id_text.value = '(�ʼ�)';
							//������üũ
							if(fm.end_rent_link_sac_id.value == ''){ alert('�����Ī���� �̰������� ���� �����ڸ� �����Ͻʽÿ�.'); fm.end_rent_link_sac_id.focus(); 		return;}
						}						
					}	
					
				<%}%>

		
		fm.idx.value = idx;
		
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_b_s_a.jsp';
			fm.target='_self';
			fm.submit();
		}							
	}
	
	//��������� �����뿩�� ��� (����)
	function estimate_taecha(st){
		var fm = document.form1;
		
		if(fm.tae_car_mng_id.value == '' && '<%=base.getRent_st()%>' == '3' && fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
			fm.tae_car_mng_id.value 	= '<%=cr_bean.getCar_mng_id()%>';
			fm.tae_car_id.value 		= '<%=cm_bean.getCar_id()%>';
			fm.tae_car_seq.value 		= '<%=cm_bean.getCar_seq()%>';
			fm.tae_car_nm.value 		= '<%=cr_bean.getCar_nm()%>';
			fm.tae_init_reg_dt.value 	= '<%=cr_bean.getInit_reg_dt()%>';						
		}
		
		if(fm.tae_car_mng_id.value == '')	{ alert('��������� ������ �����Ͻʽÿ�.');	return;}
		if(fm.tae_car_id.value == '')		{ alert('��������� ������ �ٽ� �����Ͻʽÿ�.');	return;}
		fm.esti_stat.value 	= st;
		if(st == 'view'){ fm.target = '_blank'; }else{ fm.target = 'i_no'; }
		fm.action='get_fee_estimate_taecha.jsp';
		fm.submit();
	}
	//�������μ�
	function TaechaEstiPrint(est_id){ 
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=<%=from_page%>&est_id="+est_id;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}	

	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/fms2/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();
	}
	
	//�������������̷�
	function EstiHistory() {
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=1100, height=800, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/rm_esti_history_cont.jsp';
		fm.submit();
	}
	
	//��������� �˻�
	function EstiTaeSearch(){
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=1100, height=800, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/tae_esti_history_cont.jsp';
		fm.submit();		
	}
	
	//�뿩�ϼ� ���ϱ�
	function getRentTime(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;		
					
		if(dt1 != '' && dt2 != ''){
			d1 = replaceString('-','',dt1)+'00'+ '00';
			d2 = replaceString('-','',dt2)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;
			
			if(st == 'm') 			rent_time = parseInt(t3/m);
			if(st == 'd') 			rent_time = parseInt(t3/l);			
			
			return rent_time;
			
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	

//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>

<form action='lc_b_s_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s_14.jsp'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="opt"			value="<%=car.getOpt()%>">
  <input type='hidden' name="car_b"			value="<%=AddUtil.replace(cm_bean.getCar_b()," ","")%><%=AddUtil.replace(cm_bean2.getCar_b()," ","")%>">
  <input type='hidden' name="s_st" 			value="<%=cm_bean.getS_st()%>">
  <input type='hidden' name="dpm" 			value="<%=cm_bean.getDpm()%>">
  <input type='hidden' name="s_dc1_re" 			value="<%=car.getS_dc1_re()%>">
  <input type='hidden' name="s_dc1_yn" 			value="<%=car.getS_dc1_yn()%>">
  <input type='hidden' name="s_dc1_amt"			value="<%=car.getS_dc1_amt()%>">
  <input type='hidden' name="s_dc2_re" 			value="<%=car.getS_dc2_re()%>">
  <input type='hidden' name="s_dc2_yn" 			value="<%=car.getS_dc2_yn()%>">
  <input type='hidden' name="s_dc2_amt"			value="<%=car.getS_dc2_amt()%>">
  <input type='hidden' name="s_dc3_re" 			value="<%=car.getS_dc3_re()%>">
  <input type='hidden' name="s_dc3_yn" 			value="<%=car.getS_dc3_yn()%>">
  <input type='hidden' name="s_dc3_amt"			value="<%=car.getS_dc3_amt()%>">
  <input type='hidden' name="s_dc1_re_etc"		value="<%=car.getS_dc1_re_etc()%>">  
  <input type='hidden' name="s_dc2_re_etc"		value="<%=car.getS_dc2_re_etc()%>">  
  <input type='hidden' name="s_dc3_re_etc"		value="<%=car.getS_dc3_re_etc()%>">      
  <input type='hidden' name="s_dc1_per"			value="<%=car.getS_dc1_per()%>">  
  <input type='hidden' name="s_dc2_per"			value="<%=car.getS_dc2_per()%>">  
  <input type='hidden' name="s_dc3_per"			value="<%=car.getS_dc3_per()%>">      
  <input type='hidden' name="car_end_dt"		value="<%=cr_bean.getCar_end_dt()%>">
  <input type='hidden' name="car_gu"			value="<%=base.getCar_gu()%>">  
  <input type='hidden' name="fin_seq" 			value="">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">      
  <input type='hidden' name="gur_size"			value="">     
  <input type='hidden' name="client_st" 		value="<%=client.getClient_st()%>">     
  <input type='hidden' name="o_1"			value="">
  <input type='hidden' name="ro_13"			value="">  
  <input type='hidden' name="o_13"			value="">  
  <input type='hidden' name="o_13_amt"			value="">    
  <input type='hidden' name="esti_stat"			value="">
  <input type='hidden' name="t_dc_amt"			value="">  
  <input type='hidden' name="idx"			value="">  
  <input type='hidden' name="scan_cnt"			value="">    
  <input type='hidden' name="chk_cnt"			value="">
  <input type='hidden' name="car_id"			value="<%=cm_bean.getCar_id()%>">  
  <input type='hidden' name="car_id2"			value="<%=cm_bean2.getCar_id()%>">    
  <input type='hidden' name='client_id' 		value='<%=base.getClient_id()%>'>
       
  <input type='hidden' name="est_from"			value="lc_b_u">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">            
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">            
  

  
  
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>�̰���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������<%if(base.getRent_st().equals("3")){%>(�����Ī����)<%}%></span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tae1 style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>�������������</td>
                    <td width="20%">&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("")) fee.setPrv_dlv_yn("N"); %>
                      <input type='radio' name="prv_dlv_yn" value='N' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      ����
                      <input type='radio' name="prv_dlv_yn" value='Y' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
        	 		�ִ�
        		    </td>
                    <td width="10%" class=title style="font-size : 7pt;">�����Ⱓ���Կ���</td>
                    <td>&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("Y") && fee.getPrv_mon_yn().equals("")) fee.setPrv_mon_yn("0"); %>
                      <input type='radio' name="prv_mon_yn" value='0' <%if(fee.getPrv_mon_yn().equals("0")){%> checked <%}%> >
                      ������
                      <input type='radio' name="prv_mon_yn" value='1' <%if(fee.getPrv_mon_yn().equals("1")){%> checked <%}%> >
        	 		����
        		    </td>						
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>������ȣ</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='tae_car_no' size='12' class='text' <%if(!base.getRent_st().equals("3"))%>readonly<%%> value='<%=taecha.getCar_no()%>'>
                      &nbsp;<span class="b"><a href="javascript:car_search('taecha')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span> 
        			  <input type='hidden' name='tae_no'		 value='<%=taecha.getNo()%>'>				    
        			  <input type='hidden' name='tae_car_mng_id' value='<%=taecha.getCar_mng_id()%>'>
        			  <input type='hidden' name='tae_car_id'	 value='<%=taecha.getCar_id()%>'>
        			  <input type='hidden' name='tae_car_seq'	 value='<%=taecha.getCar_seq()%>'>
					  <input type='hidden' name='tae_s_cd'	 	 value='<%=taecha.getRent_s_cd()%>'>
        			</td>
                    <td width="10%" class='title'>����</td>
                    <td>&nbsp;
                      <input type="text" name="tae_car_nm" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getCar_nm()%>'></td>
                    <td class='title'>���ʵ����</td>
                    <td>&nbsp; 
                    <input type="text" name="tae_init_reg_dt" size="15" maxlength='10' readonly class=whitetext value='<%=taecha.getInit_reg_dt()%>'></td>
                </tr>
                <tr>
                    <td class=title>�뿩������</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_st' class='text' size='12' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>�뿩������</td>
                    <td >&nbsp;
                      <input type='text' name='tae_car_rent_et' class='text' size='12' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
        			  &nbsp;</td>
                <td class='title'>�뿩�ἱ�Աݿ���</td>
                <td>&nbsp;
                	<input type='radio' name="tae_f_req_yn" value='Y' <%if(taecha.getF_req_yn().equals("Y")){%> checked <%}%> >
                  ���Ա�
                  <input type='radio' name="tae_f_req_yn" value='N' <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> checked <%}%> >
    	 		        ���Ա�
    	 		        </td>
                </tr>
                <tr>
                    <td class=title>���뿩��</td>
                    <td colspan='3' >&nbsp;
                      <input type='text' name='tae_rent_fee' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
        			  <input type='hidden' name='tae_rent_fee_s'	 value=''>
        			  <input type='hidden' name='tae_rent_fee_v'	 value=''>	
        			  <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              		  <%}else{%>	
        			  <a href="javascript:EstiTaeSearch();"><img src=/acar/images/center/button_in_search.gif align="absmiddle" border="0" alt="���������������ȸ"></a>
        			  <%}%>			  					  
        			</td>
                    <td class=title>������</td>
                    <td>&nbsp;					  
                      <input type='text' name='tae_rent_inv' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����) 
					  <span class="b"><a href="javascript:estimate_taecha('account')" onMouseOver="window.status=''; return true" title="�����ϱ�"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					  <%	if(!taecha.getRent_inv().equals("0")){
					  			ContCarBean t_fee_add = a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, "t");%>
					  <a href="javascript:TaechaEstiPrint('<%=t_fee_add.getBc_est_id()%>');"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%	}%>
					  
        			  <input type='hidden' name='tae_rent_inv_s'	 value=''>
        			  <input type='hidden' name='tae_rent_inv_v'	 value=''>					  
					  <input type='hidden' name='tae_est_id'	 	 value='<%=taecha.getEst_id()%>'>					  
        			</td>
              </tr>		
              <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              <%}else{%>
              <tr>
                    <td class=title>���������ÿ������</td>
                    <td colspan='5' >&nbsp;
                      <input type='radio' name="tae_rent_fee_st" value='1' <%if(taecha.getRent_fee_st().equals("1")){%> checked <%}%> >
                                      ����Ʈ������
                      <input type='text' name='tae_rent_fee_cls' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  ��(vat����)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          �������� ǥ��Ǿ� ���� ����	                        				  					 
        			</td>                     
              </tr>		
              <%}%>  
              <tr>
                <td class=title>û������</td>
                <td>&nbsp;
                  <select name='tae_req_st'>
                    <option value="">����</option>
                    <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>û��</option>
                    <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>�������</option>
                  </select></td>
                <td class='title' style="font-size : 8pt;">��꼭���࿩��</td>
                <td>&nbsp;
                  <select name='tae_tae_st'>
                    <option value="">����</option>
                    <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>����</option>
                    <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>�̹���</option>
                  </select></td>
                <td class='title'>������</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="tae_sac_id" value="<%=taecha.getTae_sac_id()%>">			
			<a href="javascript:User_search('tae_sac_id', '0');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>			
    		</td>
              </tr>
            </table>
        </td>
    </tr>
    <%if(base.getRent_st().equals("3")){%>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
	<td>* �����Ī������ ��� ������ȣ�� "<%=cr_bean.getCar_no()%>"�� �Է��Ͻð�(�˻��� �ȵ�), �����Ⱓ�� ������, 
	      �뿩�������� �����ε���, �뿩�������� ����� ���Ό����, ���뿩��� ����� ���뿩��, û�����δ� û��, ��꼭���࿩�δ� �������� �Է��ϼ���.</td>
    </tr>    
    <%} %>	
    <%if(fee.getPrv_dlv_yn().equals("Y") && !taecha.getCar_no().equals("") && !taecha.getCar_no().equals(cr_bean.getCar_no())){%>
	<td>* ������� & ����Ʈ ����: <a href="javascript:EstiHistory();"><img src=/acar/images/center/button_in_gjir.gif align="absmiddle" border="0" alt="�����̷�"></a></td>
    </tr>         
    <%} %>    
	<tr>
	    <td align="right"><%if(!san_st.equals("��û") ||   auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('14')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
	    	&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
    	</td>
	<tr>
	<tr id=tr_tae3 style="display:none">
	    <td>
	        * �����Ī���� �̰������ٱݾ� ���� : �������� ���� <input name="end_rent_link_day" type="text" class="text"  readonly value="" size="4">��,
	        �����뿩��� ���� �뿩�� ���� <input name="end_rent_link_per" type="text" class="text"  readonly value="" size="4">%<br>
	        * �����Ī �Է��� ��  "���������"  �뿩������ / �뿩������ ���̰� 35�� �̻�, �Ǵ� ������� ���� 30% �̻� ���̰� �߻��ϸ� ����������� �Էµ� "���뿩��"�� ��������  ����������� �������� �ݿ��Ѵ�.<br> 
	        * ������ <input name="user_nm" type="text" class="text"  readonly value="<%//=c_db.getNameById(taecha.getTae_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="end_rent_link_sac_id" value="<%//=taecha.getTae_sac_id()%>">			
			<a href="javascript:User_search('end_rent_link_sac_id', '1');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<input name="end_rent_link_sac_id_text" type="text" class="whitetextredb"  readonly value="" size="10">
	           
	    </td> 
	<tr>		
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--

<%if(!cont_etc.getGrt_suc_l_cd().equals("")){%>
init_end_rent();
<%}%>

function init_end_rent(){
	var fm = document.form1;
	if(fm.car_mng_id.value == fm.tae_car_mng_id.value){	
		var est_day = getRentTime('d', fm.tae_car_rent_st.value, fm.tae_car_rent_et.value);
		fm.end_rent_link_day.value = est_day;
		var est_amt = (<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>-<%=grt_suc_fee.getFee_s_amt()+grt_suc_fee.getFee_v_amt()%>)/<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>;
		est_amt = replaceFloatRound(est_amt);
		fm.end_rent_link_per.value = est_amt;						
		if(est_day > 35 || est_amt > 30){
			tr_tae3.style.display = '';
			fm.end_rent_link_sac_id_text.value = '(�ʼ�)';
		}
		return;
	}
}

//-->
</script>
</body>
</html>
