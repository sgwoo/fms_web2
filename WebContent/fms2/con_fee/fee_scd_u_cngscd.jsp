<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//�ڵ���ü����
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//�뿩�⺻����
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	Vector ht = af_db.getFeeScdCngNew(l_cd, rent_st, rent_seq, "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	int tae_sum = af_db.getTaeCnt_lcd(l_cd);
	
	if(rent_st.equals("")){ tae_sum = 0; }
	
	Hashtable rtn = af_db.getFeeRtnCase(m_id, l_cd, rent_st, rent_seq);
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�뿩������ ����
	function cng_schedule()
	{
		var fm = document.form1;
	
		
		if(fm.fee_tm.value 		== '')				
			{	alert('����ȸ���� �����Ͻʽÿ�.'); 		fm.fee_tm.focus(); 	return; }
		if(fm.cng_st.value 		== 'fee_amt'){
			if(fm.fee_s_amt.value == '' || fm.fee_s_amt.value == '0' || fm.fee_v_amt.value == '' || fm.fee_v_amt.value == '0' || fm.fee_amt.value == '' || fm.fee_amt.value == '0')
			{	alert('���뿩�Ḧ Ȯ���Ͻʽÿ�.'); 		fm.fee_amt.focus(); 	return; }
		}
		if((fm.cng_st.value == 'req_dt' 	|| fm.cng_st.value == 'fee_est_dt') && fm.req_dt.value == '')
			{	alert('�������ڸ� �Է��Ͻʽÿ�.'); 		fm.req_dt.focus(); 		return; }
		if((fm.cng_st.value == 'tax_out_dt' || fm.cng_st.value == 'fee_est_dt') && fm.tax_out_dt.value == '')
			{	alert('�������ڸ� �Է��Ͻʽÿ�.'); 		fm.tax_out_dt.focus(); 	return; }
		if(fm.cng_st.value == 'fee_est_dt' && fm.fee_est_dt.value == '')
			{	alert('�Աݿ����ϸ� �Է��Ͻʽÿ�.'); 	fm.fee_est_dt.focus(); 	return; }
		if(fm.cng_cau.value 		== '')				
			{	alert('��������� �����Ͻʽÿ�.'); 		fm.cng_cau.focus(); 	return; }
			
			
		var values = fm.fee_tm.options[fm.fee_tm.selectedIndex].value;
		var value_split = values.split(",");
		fm.r_fee_tm.value = value_split[0];
			
		if(fm.c_all[2].checked==true){
			if(fm.s_max_tm.value == ''){ alert('��������ȸ���� �����Ͽ� �ֽʽÿ�.'); fm.s_max_tm.focus(); return;}
			if(toInt(fm.r_fee_tm.value) >= toInt(fm.s_max_tm.value)){ alert('�������ȸ������ ��������ȸ���� �۽��ϴ�. Ȯ���Ͻʽÿ�.'); fm.s_max_tm.focus(); return; }			
		}else{
			fm.s_max_tm.value = '';
		}

		<%	if(cng_st.equals("fee_amt")){%>		
		if(fm.ins_cng.checked==true){
			if(fm.ins_cng_st[0].checked==false && fm.ins_cng_st[1].checked==false){ alert('�뿩�ắ������� �����Ͻʽÿ�. '); return;}	
			if(toInt(parseDigit(fm.ins_cng_amt.value))==0){ alert('���濡 ���� ���ް��������� �Է��Ͻʽÿ�.'); fm.ins_cng_amt.focus(); return;}
			if(fm.ins_cng_dt.value == ''){ alert('�������ڸ� �Է��Ͻʽÿ�.'); fm.ins_cng_dt.focus(); return; }
			if(fm.c_all[0].checked == true){ alert('�������� �����ϴ� ��� ����ȸ�� ������ ��������ȸ��(������ORƯ��ȸ��)�� �����ؾ� �մϴ�.'); return; }
		}		
		<%	}%>
			
		var a_dt 	= '';
		var b_dt 	= '';
		var cha_mon = 0;
		var a_dt_nm = '';
		
		if(fm.cng_st.value 			== 'req_dt'){
			a_dt 	= fm.a_req_dt.value;
			b_dt 	= fm.req_dt.value;			
			a_dt_nm = '�������ڰ�';
		}else if(fm.cng_st.value 	== 'tax_out_dt'){
			a_dt 	= fm.a_tax_out_dt.value;
			b_dt 	= fm.tax_out_dt.value;			
			a_dt_nm = '�������ڰ�';
		}else if(fm.cng_st.value 	== 'fee_est_dt'){		
			a_dt 	= fm.a_fee_est_dt.value;
			b_dt 	= fm.fee_est_dt.value;					
			a_dt_nm = '�Աݿ�������';
			
			var est_dt = replaceString('-','',fm.fee_est_dt.value);
			fm.fee_est_y.value = est_dt.substring(0,4);
			fm.fee_est_m.value = est_dt.substring(4,6);
			fm.fee_est_d.value = est_dt.substring(6,8);
			
		}	
					
		if(a_dt != ''){
			cha_mon = getRentTime('m', a_dt, b_dt);
			if(cha_mon > 2){ 
				if(!confirm('�Է��� '+a_dt_nm+' �δ��̻� ���̳��ϴ�.\n\n�������� �����Ͻðڽ��ϱ�?'))			
					return;
			}
			if(cha_mon <  -2){ 
				if(!confirm('�Է��� '+a_dt_nm+' -�δ��̻� ���̳��ϴ�.\n\n�������� �����Ͻðڽ��ϱ�?'))			
					return;
			}
		}
		
		if(fm.cng_st.value 	== 'fee_est_dt'){		
			a_dt 	= fm.a_req_dt.value;
			b_dt 	= fm.req_dt.value;		
			cha_mon = 0;	
			a_dt_nm = '��������';
			if(a_dt != ''){
				cha_mon = getRentTime('m', a_dt, b_dt);
				if(cha_mon > 2){ 
					if(!confirm('�Է��� '+a_dt_nm+' �δ��̻� ���̳��ϴ�.\n\n�������� �����Ͻðڽ��ϱ�?'))			
						return;
				}
				if(cha_mon <  -2){ 
					if(!confirm('�Է��� '+a_dt_nm+' -�δ��̻� ���̳��ϴ�.\n\n�������� �����Ͻðڽ��ϱ�?'))			
						return;
				}
			}		
			a_dt 	= fm.a_tax_out_dt.value;
			b_dt 	= fm.tax_out_dt.value;			
			cha_mon = 0;	
			a_dt_nm = '��������';
			if(a_dt != ''){
				cha_mon = getRentTime('m', a_dt, b_dt);
				if(cha_mon > 2){ 
					if(!confirm('�Է��� '+a_dt_nm+' �δ��̻� ���̳��ϴ�.\n\n�������� �����Ͻðڽ��ϱ�?'))			
						return;
				}
				if(cha_mon <  -2){ 
					if(!confirm('�Է��� '+a_dt_nm+' -�δ��̻� ���̳��ϴ�.\n\n�������� �����Ͻðڽ��ϱ�?'))			
						return;
				}
			}					
		}
		
		if(confirm('�����ٸ� ���� �Ͻðڽ��ϱ�?'))
		{							
			fm.action = './fee_scd_u_cngscd_a.jsp';
			fm.target = '_self';
			fm.submit();
		}
	}		
	
	function set_before(){
		var fm = document.form1;
		var values = fm.fee_tm.options[fm.fee_tm.selectedIndex].value;
		var value_split = values.split(",");
		<%if(cng_st.equals("fee_amt")){%>
		fm.a_fee_s_amt.value 	= parseDecimal(value_split[1]);
		fm.a_fee_v_amt.value 	= parseDecimal(value_split[2]);
		fm.a_fee_amt.value 		= parseDecimal(toInt(parseDigit(fm.a_fee_s_amt.value)) + toInt(parseDigit(fm.a_fee_v_amt.value))); 		
		fm.rc_cont.value		= '[��ȸ���� '+parseDecimal(value_split[6])+'���� �ԱݵǾ� �ֽ��ϴ�. �ܾ��� �����Ǵ� ������ Ȯ���ϼ���]';
		<%}%>
		<%if(cng_st.equals("req_dt") || cng_st.equals("fee_est_dt")){%>		
		fm.a_req_dt.value 		= ChangeDate(value_split[3]);
		<%}%>		
		<%if(cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt")){%>				
		fm.a_tax_out_dt.value 	= ChangeDate(value_split[4]);
		<%}%>		
		<%if(cng_st.equals("fee_est_dt") || cng_st.equals("fee_est_dt")){%>				
		fm.a_fee_est_dt.value 	= ChangeDate(value_split[5]);
		<%}%>		
	}
	function cal_sv_amt(obj)
	{
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);

		if(obj == fm.fee_s_amt){ //���뿩�� ���ް�
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_v_amt){ //���뿩�� �ΰ���		
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_amt){ //���뿩�� �հ�		
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
		}
	}	
	
	//���躯������
	function setInsamt(){
		var fm = document.form1;
		if(fm.ins_cng.checked == true){
			if(fm.ins_cng_st[0].checked==false && fm.ins_cng_st[1].checked==false){ fm.ins_cng_st[0].checked=true}	
			if(toInt(parseDigit(fm.ins_cng_amt.value))==0 && toInt(parseDigit(fm.fee_amt.value))>0){
				fm.ins_cng_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.a_fee_amt.value))); 		
			}else if(toInt(parseDigit(fm.ins_cng_amt.value))>0 && toInt(parseDigit(fm.fee_amt.value))==0){
				fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.a_fee_amt.value)) + toInt(parseDigit(fm.ins_cng_amt.value))); 	
				cal_sv_amt(fm.fee_amt);					
			}else if(toInt(parseDigit(fm.ins_cng_amt.value))<0 && toInt(parseDigit(fm.fee_amt.value))==0){
				fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.a_fee_amt.value)) + toInt(parseDigit(fm.ins_cng_amt.value))); 	
				cal_sv_amt(fm.fee_amt);					
			}
			if((fm.cng_cau.value=='' || fm.cng_cau.value=='�뿩�ắ��') && fm.ins_cng_st[0].checked == true){
				fm.cng_cau.value = '���躯��';
			}else if((fm.cng_cau.value=='' || fm.cng_cau.value=='���躯��') && fm.ins_cng_st[1].checked == true){
				fm.cng_cau.value = '�뿩�ắ��';
			}
			fm.fee_amt_cng.checked = true;
			
			setInscau();
			
		}else{
			fm.ins_cng_amt.value = 0;
			fm.fee_amt_cng.checked = false;
			fm.cng_cau.value = '';
		}
	}
	
	function setInscau(){
		var fm = document.form1;
		if(fm.ins_cng_st[0].checked == true){
			fm.cng_cau.value = '���躯��';
		}else if(fm.ins_cng_st[1].checked == true){
			fm.cng_cau.value = '�뿩�ắ��';
		}
		if(fm.ins_cng_sub_st.value != ''){			
			fm.cng_cau.value = fm.cng_cau.value + ' : ' + fm.ins_cng_sub_st.value;
		}
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='rent_seq' value='<%=rent_seq%>'>
<input type='hidden' name='cng_st' value='<%=cng_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='r_fee_tm' value=''>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>
<input type='hidden' name='fee_est_y' value=''>
<input type='hidden' name='fee_est_m' value=''>
<input type='hidden' name='fee_est_d' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������� > �뿩�ὺ���ٰ��� > <span class=style5>�뿩�ὺ���� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td class=line2></td>
    </tr>  	
	<tr>
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='14%' class='title'>����ȣ</td>
                    <td width='20%'>
    			    &nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='14%' class='title'>��ȣ</td>
                    <td>
    			    &nbsp;<%=base.get("FIRM_NM")%></td>
                </tr>
    		    <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr>
                    <td class='title'>��뺻����</td>
                    <td colspan="3">&nbsp;<%=base.get("R_SITE_NM")%></td>
                </tr>	
    		    <%}%>	   
                <tr>
                    <td class='title'>������ȣ</td>
                    <td>
    			    &nbsp;<font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>����</td>
                    <td>
    			    &nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr>
                    <td class='title'> �뿩��� </td>
                    <td>
    			    &nbsp;<%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td>
    				&nbsp;<%if(!cms.getCms_bank().equals("")){%>
					<b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
    			 	<%=cms.getCms_bank()%>:<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>(�ſ�<%=cms.getCms_day()%>��)
    			 	<%}else{%>
    			 	-
    			 	<%}%>			 
    			    </td>
                </tr>
                <tr>
                    <td class='title'>���������</td>
                    <td>
    			    &nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td class='title'>���������</td>
                    <td>
    			    &nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>		   
            </table>
	    </td>
	</tr>
	<tr> 
        <td class=h></td>
    </tr>
	<%if(!rent_seq.equals("1")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����û��</span></td>	
	</tr>	
	<tr> 
        <td class=line2></td>
    </tr>  			
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='14%' class='title'>���޹޴���</td>
                    <td width="28%">&nbsp;<%=rtn.get("FIRM_NM")%></td>
                    <td width="14%" class='title'>���뿩��</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(rtn.get("RTN_AMT")))%>��&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>			
	<%}%>
<%	if(rent_st.equals("") && idx==1){%>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� �����뿩</span></td>	
	</tr>	
<%	}%>		
<%	if(idx==2){%>  		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(rent_st.equals("1")){%>����<%}else{%><%=AddUtil.parseInt(rent_st)-1%>�� ����<%}%>�뿩</span></td>	
	</tr>	  
<%	}%>	
    <tr> 
        <td class=line2></td>
    </tr>			
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title' width=14%>����ȸ��</td>
                    <td colspan="2">
   					&nbsp;  <%	String max_tm = "";
								if(ht_size > 0){%>
        						<select name='fee_tm' onchange="javascript:set_before()">
        					<%		for(int i = 0 ; i < ht_size ; i++){
        								FeeScdBean bean = (FeeScdBean)ht.elementAt(i);
        								if(i==0){
        									fee_scd = bean;
        								}
										max_tm =bean.getFee_tm(); %>
        							<option value='<%=bean.getFee_tm()%>,<%=bean.getFee_s_amt()%>,<%=bean.getFee_v_amt()%>,<%=bean.getReq_dt()%>,<%=bean.getTax_out_dt()%>,<%=bean.getFee_est_dt()%>,<%=bean.getRc_amt()%>'><%=AddUtil.parseInt(bean.getFee_tm())%></option>
        					<%		}%>
        						</select> ȸ
								<input type='text' name='rc_cont' value='' size='70' class='whitetext'>
							<br>	
							&nbsp;
        		              <input type="radio" name="c_all" value="O" checked>
                		      <b>��ȸ��</b>�� ����
							<br>	
							&nbsp;
        		              <input type="radio" name="c_all" value="Y">
                		      ����ȸ������ <b>��� ȸ��</b> ����
							  <br>
							  &nbsp;
							    <input type="radio" name="c_all" value="M">
							  ����ȸ������ <b><input type='text' name='s_max_tm' value='' size='2' class='num'>ȸ������</b> ����
        					<%	}else{%>
        						���ð����� ȸ���� �����ϴ�.
        					<%	}%>					
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class='title' width=14%>ȸ������</td>
                    <td colspan="2">
        					&nbsp;											  
							  <select name='mon_st'>
        							<option value='1'> 1����</option>
        							<option value='12'>12����</option>									
        						</select>						
                    </td>
                </tr>				
                <tr>
                    <td colspan="2" class='title'>����</td>
                    <td width="42%" class='title'>������</td>
                    <td class='title'>������</td>
                </tr>
    <%	if(cng_st.equals("fee_amt")){%>		  
                <tr>
                    <td width='5%' rowspan="3" class='title'>��<br>
                    ��<br>
                    ��<br>��</td>
                    <td width='9%' class='title'>���ް�</td>
                    <td align="center">
                      <input type='text' name='a_fee_s_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt())%>' size='8' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                    <td align="center">
                    <input type='text' name='fee_s_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>��</td>
                </tr>
                <tr>
                    <td class='title'>�ΰ���</td>
                    <td align="center">
                      <input type='text' name='a_fee_v_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_v_amt())%>' size='8' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                    <td align="center">
                    <input type='text' name='fee_v_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>��</td>
                </tr>
                <tr>
                    <td class='title'>�հ�</td>
                    <td align="center">
                      <input type='text' name='a_fee_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt())%>' size='8' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
                    <td align="center">
                    <input type='text' name='fee_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>��</td>
                </tr>		
                <tr>
                    <td colspan="2" class='title' width=14%>������ȸ��</td>
                    <td colspan="2">
        					&nbsp;
        		              <input type="checkbox" name="max_auto" value="Y">
                		      �ڵ����ڰ�� (����ȸ������ �ټ� ������ ���)	
                    </td>
                </tr>				  
    <%	}%>
    <%	if(cng_st.equals("req_dt") || cng_st.equals("fee_est_dt") ){%>		  		  
                <tr>
                    <td colspan="2" class='title'>��������</td>
                    <td align="center">
                    <input type='text' name='a_req_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getReq_dt())%>' size='11' class='whitetext' readonly onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                    <td align="center">
                    <input type='text' name='req_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
    <%	}%>
    <%	if(cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt") ){%>		  		  		  
                <tr>
                    <td colspan="2" class='title'>��������</td>
                    <td align="center">
                      <input type='text' name='a_tax_out_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getTax_out_dt())%>' size='11' class='whitetext' readonly onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                    <td align="center">
                    <input type='text' name='tax_out_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
    <%	}%>
    <%	if(cng_st.equals("fee_est_dt")){%>		  		  		  
                <tr>
                    <td colspan="2" class='title'>�Աݿ�����</td>
                    <td align="center">
        			  <input type='text' name='a_fee_est_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getFee_est_dt())%>' size='11' class='whitetext' readonly onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			</td>
                    <td align="center">
                    <input type='text' name='fee_est_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
    <%	}%>	
            </table>
	    </td>
    </tr>
	<tr>
	    <td align='right'>&nbsp;</td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    <%	if(cng_st.equals("fee_amt")){%>		  
                <tr>
                    <td width="14%" class='title'>���ڰ�� �� ȸ������</td>
                    <td>
                        &nbsp;<input type="checkbox" name="ins_cng" value="Y" onclick="javascript:setInsamt();"> ���뿩�� ���ڰ�� ����ó�� <font color='#999999'>(üũ�� ������ �Է½� ���뿩�� �ڵ����)</font>
    	 		              <br>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	  ������� : 
                    	<input type='radio' name="ins_cng_st" value='1' onclick="javascript:setInsamt();">
                        ���躯��
                        <input type='radio' name="ins_cng_st" value='2' onclick="javascript:setInsamt();">
    	 		        �뿩�ắ��    	 		        
                    	&nbsp;&nbsp;&nbsp;&nbsp;
                    	  (���λ��� : <select name='ins_cng_sub_st'  onchange="javascript:setInscau()">
                    	            <option value=''>����</option>
        							<option value='21��->26��'>21��->26��</option>
        							<option value='26��->21��'>26��->21��</option>									
        							<option value='�߰������ڵ��'>�߰������ڵ��</option>
        							<option value='�߰������ڵ�����'>�߰������ڵ�����</option>
        							<option value='�����Ÿ�����'>�����Ÿ�����</option>
        							<option value='�빰���Աݾ׺���'>�빰���Աݾ׺���</option>
        						</select>		
    	 		        )
						<br>	 
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							���뿩�������� : <input type='text' name='ins_cng_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setInsamt();'>�� (�ΰ�������) / 
							�������� : <input type='text' name='ins_cng_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>							
                    </td>
                </tr>				
	<%	}%>				
                <tr>
                    <td width="14%" class='title'>���ϰ�����</td>
                    <td>
                        &nbsp;<input type="checkbox" name="comm_value" value="Y"> ���� ��ȸ���� ���밪�� ������ ������ ���� (ȸ���� ��ȭ�� ����)
                    </td>
                </tr>	
                <%if(cng_st.equals("req_dt") || cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt")){%>		  
                <tr>
                    <td width="14%" class='title'>��������<%if(cng_st.equals("fee_est_dt")){%>1<%}%></td>
                    <td>
                        &nbsp;<input type="checkbox" name="maxday_yn" value="Y"> ����
                        <font color=red>&nbsp;(<%if(cng_st.equals("fee_est_dt")){%>��������-<%}%>�������ڰ� �����϶� �����ϼ���.)</font>
                    </td>
                </tr>	                
                <%}%>
                <%if(cng_st.equals("fee_est_dt")){%>		  
                <tr>
                    <td width="14%" class='title'>��������2</td>
                    <td>
                        &nbsp;<input type="checkbox" name="maxday_yn2" value="Y"> ����
                        <font color=red>&nbsp;(�Աݿ�����-�������ڰ� �����϶� �����ϼ���.)</font>
                    </td>
                </tr>	                                
                <%}%>
				
    <%	if(cng_st.equals("fee_est_dt")){%>		  
                <tr>
                    <td width="14%" class='title'>�����Ϻ���</td>
                    <td>
                        &nbsp;<input type="checkbox" name="fee_est_day_cng" value="Y"> ������-�뿩������ �ſ��������ڵ� ����
                    </td>
                </tr>				
	<%	}else{%>		
	<input type='hidden' name='fee_est_day_cng' value='N'>
	<%	}%>		  		  		  
	
								
    <%	if(cng_st.equals("fee_amt")){%>		  
                <tr>
                    <td width="14%" class='title'>�뿩��ݺ���</td>
                    <td>
                        &nbsp;<input type="checkbox" name="fee_amt_cng" value="Y"> ������-�뿩������ �뿩�� ����ݵ� ����
                    </td>
                </tr>				
	<%	}else{%>		
	<input type='hidden' name='fee_amt_cng' value='N'>
	<%	}%>									
	
                <tr>
                    <td width="14%" class='title'>�������</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="82" rows="5" class=default style='IME-MODE: active'></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align='right'>&nbsp;</td>
    </tr>	
	<tr>
	    <td align="center">		
            <a href="javascript:cng_schedule();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>
      		&nbsp;&nbsp;	
      		<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>		
	    </td>
	</tr>	
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
