<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.bill_mng.*, acar.client.*, acar.car_register.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	
	//��ü�� ����
	Vector dly_cont = af_db.getFeeDlyContViewClientList(base.getClient_id());
	int dly_cont_size = dly_cont.size();	
	for(int i = 0 ; i < dly_cont_size ; i++){
		Hashtable ht = (Hashtable)dly_cont.elementAt(i);
		boolean dly_flag = af_db.calDelayDtPrint(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), String.valueOf(ht.get("CLS_DT")), String.valueOf(ht.get("RENT_DT")));
	}
	

	//[��ະ]�뿩�ὺ����
	Vector fee_scds2 = af_db.getFeeScdDlySettleList(m_id, l_cd);
	int scd_size2 = fee_scds2.size();
	
	
	//[��ະ]�뿩�����
	Hashtable fee_stat = af_db.getFeeScdStatPrint(m_id, l_cd);
	
	//[�ŷ�ó��]�뿩�ὺ����
	Vector fee_scds = af_db.getFeeScdDlySettleClientArsList(base.getClient_id());
	int scd_size = fee_scds.size();
	
	//[�ŷ�ó��]�뿩�Ῥü�� ���
	Vector dly_scds = af_db.getFeeScdDlyStatClient(base.getClient_id());
	int dly_size = dly_scds.size();
	
	//��å��
	Vector serv_scds = af_db.getServScdStatClient(base.getClient_id());
	int serv_size = serv_scds.size();
	
	//���·�
	Vector fine_scds = af_db.getFineScdStatClient(base.getClient_id());
	int fine_size = fine_scds.size();
	
	//���������
	Vector cls_scds = af_db.getClsScdStatClient(base.getClient_id());
	int cls_size = cls_scds.size();
	
	//������
	Vector grt_scds = af_db.getGrtScdStatClient(base.getClient_id());
	int grt_size = grt_scds.size();
	
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
	long total_amt4 	= 0;
	long total_amt5 	= 0;
	long total_amt6 	= 0;
	long total_amt7 	= 0;
	long total_amt8 	= 0;
	long total_amt9 	= 0;
	long total_amt10 	= 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--

	//��ü����
	function AllSelect(idx){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd2"){		
					if(idx == '2'){
						if(ck.value=='1' || ck.value=='2'){
							if(ck.checked == false){
								ck.click();
							}else{
								ck.click();
							}
							cnt++;
						}
					}
					else{
						if(ck.value==idx){
							if(ck.checked == false){
								ck.click();
							}else{
								ck.click();
							}
							cnt++;
						}
					}
							
			}
		}
	}		
		
	function CountMailList(idx){
		var fm = document.form1;
		var len = fm.ch_cd2.length;
		var mail_dyr_ggr = 0;
		var mail_etc_ycr = 0;
		var est_amt_s = 0;
		var est_amt_v = 0;
		var mail_etc_gtr = 0;
		var good_name_split ="";
		var good_name ="";
		var value_dyr = 0;
		var value_dyr_mn = 0;
		var value_bjk = 0;
		var value_gtr = 0;
		var value_hj = 0;
		var value_ssg = 0;
		var count_gubun = 0;
		var msg ="";
		if(len>1){
			for(var i=0; i<len; i++){
			var ck = fm.ch_cd2[i];
			
				if(ck.checked == false){
					
				}else{
					if(ck.value=="1"){
					//	mail_dyr_ggr += toInt(parseDigit(fm.est_amt[i].value));
						est_amt_s += toInt(parseDigit(fm.est_amt_s[i].value));
						est_amt_v += toInt(parseDigit(fm.est_amt_v[i].value));
						value_dyr += toInt(parseDigit(fm.est_amt_s[i].value))+ toInt(parseDigit(fm.est_amt_v[i].value));
					}else if(ck.value=="2"){
						mail_etc_ycr += toInt(parseDigit(fm.est_amt[i].value));
						value_dyr_mn += toInt(parseDigit(fm.est_amt[i].value));
					}else if(ck.value=="3"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt[i].value));
						value_bjk += toInt(parseDigit(fm.est_amt[i].value));
					}else if(ck.value=="4"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt[i].value));
						value_gtr += toInt(parseDigit(fm.est_amt[i].value));
					}else if(ck.value=="5"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt[i].value));
						value_hj += toInt(parseDigit(fm.est_amt[i].value));
					}else if(ck.value=="6"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt[i].value));
						value_ssg += toInt(parseDigit(fm.est_amt[i].value));
					}
					good_name_split = fm.ch_car_no[i].value;
					
					
					if(good_name.indexOf(good_name_split)<0){
						good_name += fm.ch_car_no[i].value+" ";
					}
						
					
				}
				cnt++;
			}
		}else{
			var ck = fm.ch_cd2;
			
				if(ck.checked == false){
					
				}else{
					if(ck.value=="1"){
						est_amt_s += toInt(parseDigit(fm.est_amt_s.value));
						est_amt_v += toInt(parseDigit(fm.est_amt_v.value));
						value_dyr += toInt(parseDigit(fm.est_amt_s.value))+ toInt(parseDigit(fm.est_amt_v.value));
					}else if(ck.value=="2"){
						mail_etc_ycr += toInt(parseDigit(fm.est_amt.value));
						value_dyr_mn += toInt(parseDigit(fm.est_amt.value));
					}else if(ck.value=="3"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt.value));
						value_bjk += toInt(parseDigit(fm.est_amt.value));
					}else if(ck.value=="4"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt.value));
						value_gtr += toInt(parseDigit(fm.est_amt.value));
					}else if(ck.value=="5"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt.value));
						value_hj += toInt(parseDigit(fm.est_amt.value));
					}else if(ck.value=="6"){
						mail_etc_gtr += toInt(parseDigit(fm.est_amt.value));
						value_ssg += toInt(parseDigit(fm.est_amt.value));
					}
					
					good_name_split = fm.ch_car_no.value;

					if(good_name.indexOf(good_name_split)<0){
						good_name += fm.ch_car_no.value+" ";
					}
					
				}
				cnt++;
		}
		
		fm.good_name.value = good_name;
		fm.mail_dyr_ggr.value = parseDecimal(est_amt_s);
		fm.mail_etc_ycr.value = parseDecimal(mail_etc_ycr);
		fm.mail_dyr_bgs.value = parseDecimal(est_amt_v);
		fm.mail_etc_gtr.value = parseDecimal(mail_etc_gtr);
		fm.mail_etc_hap.value = parseDecimal(mail_etc_gtr+mail_etc_ycr);
		fm.mail_dyr_hap.value = parseDecimal(est_amt_s+est_amt_v);
		fm.settle_mny.value = parseDecimal(est_amt_s+est_amt_v+mail_etc_gtr+mail_etc_ycr);
		fm.card_fee.value = parseDecimal(Math.floor((est_amt_s+est_amt_v+mail_etc_gtr+mail_etc_ycr)*0.027));
		fm.kj_ggr.value = parseDecimal(est_amt_s+mail_etc_gtr+mail_etc_ycr+Math.floor((est_amt_s+est_amt_v+mail_etc_gtr+mail_etc_ycr)*0.027));
		fm.kj_bgs.value = parseDecimal(est_amt_v);
		fm.good_mny.value = parseDecimal(est_amt_s+mail_etc_gtr+mail_etc_ycr+Math.floor((est_amt_s+est_amt_v+mail_etc_gtr+mail_etc_ycr)*0.027)+est_amt_v);
	

		if(value_dyr>0){ count_gubun++; msg+= "�뿩��"+parseDecimal(value_dyr);}
		if(value_dyr_mn>0){if(count_gubun>0){msg+= "+�뿩��̳�����"+parseDecimal(value_dyr_mn);}else{msg+= "�뿩��̳�����"+parseDecimal(value_dyr_mn);} count_gubun++;}
		if(value_bjk>0){if(count_gubun>0){msg+= "+��å��"+parseDecimal(value_bjk);}else{msg+= "��å��"+parseDecimal(value_bjk);} count_gubun++;}
		if(value_gtr>0){if(count_gubun>0){msg+= "+���·�"+parseDecimal(value_gtr);}else{msg+= "���·�"+parseDecimal(value_gtr);} count_gubun++;}
		if(value_hj>0){if(count_gubun>0){msg+= "+���������"+parseDecimal(value_hj);}else{msg+= "���������"+parseDecimal(value_hj);} count_gubun++;}
		if(value_ssg>0){if(count_gubun>0){msg+= "+������"+parseDecimal(value_ssg);}else{msg+= "������"+parseDecimal(value_ssg);} count_gubun++;}
		if(count_gubun>0){msg+="=�ѱݾ�"+parseDecimal(value_dyr+value_dyr_mn+value_bjk+value_gtr+value_hj+value_ssg)+"��";}
		
		fm.msg.value = msg;
		
	}
	
	function sendP(){
		opener.document.form1.mail_dyr_ggr.value = document.form1.mail_dyr_ggr.value;
		opener.document.form1.mail_etc_ycr.value = document.form1.mail_etc_ycr.value;
		opener.document.form1.mail_dyr_bgs.value = document.form1.mail_dyr_bgs.value;
		opener.document.form1.mail_etc_gtr.value = document.form1.mail_etc_gtr.value;
		opener.document.form1.mail_etc_hap.value = document.form1.mail_etc_hap.value;
		opener.document.form1.mail_dyr_hap.value = document.form1.mail_dyr_hap.value;
		opener.document.form1.settle_mny.value = document.form1.settle_mny.value;
		opener.document.form1.card_fee.value = document.form1.card_fee.value;
		opener.document.form1.kj_ggr.value = document.form1.kj_ggr.value;
		opener.document.form1.kj_bgs.value = document.form1.kj_bgs.value;
		opener.document.form1.good_mny.value = document.form1.good_mny.value;
		
		opener.document.form1.good_name.value = document.form1.good_name.value.replace(/\,/g, " ");
		
		opener.document.form1.msg.value = document.form1.msg.value;
		alert('�������� ������ �ԷµǾ����ϴ�.');
		if(document.form1.mail_check.checked==true){
			select_email();
			window.open("about:blank","_self").close();
		}
		else{
			window.open("about:blank","_self").close();
		}
	}		
	
	//���ø��Ϲ߼�
	function select_email(){
		var fm =document.form1;	
		fm.buyr_name.value=opener.document.form1.buyr_name.value;
		fm.buyr_mail.value=opener.document.form1.buyr_mail.value;
		fm.target = "_blank";
		fm.action = "/fms2/ars_card/select_mail_input_docs.jsp";
		fm.submit();	

	}		
	
	function sumCount(){
		var fm =document.form1;	
		fm.mail_dyr_ggr.value = parseDecimal(fm.mail_dyr_ggr.value);
		fm.mail_dyr_bgs.value = parseDecimal(fm.mail_dyr_bgs.value);
		fm.mail_dyr_hap.value = parseDecimal(toInt(parseDigit(fm.mail_dyr_ggr.value))+toInt(parseDigit(fm.mail_dyr_bgs.value)));
		fm.mail_etc_gtr.value = parseDecimal(fm.mail_etc_gtr.value);
		fm.mail_etc_ycr.value = parseDecimal(fm.mail_etc_ycr.value);
		fm.mail_etc_hap.value = parseDecimal(toInt(parseDigit(fm.mail_etc_gtr.value))+toInt(parseDigit(fm.mail_etc_ycr.value)));
		fm.settle_mny.value = parseDecimal(toInt(parseDigit(fm.mail_dyr_hap.value))+toInt(parseDigit(fm.mail_etc_hap.value)));
		fm.card_fee.value = parseDecimal(Math.floor(toInt(parseDigit(fm.settle_mny.value))*0.027));
		fm.kj_ggr.value = parseDecimal(toInt(parseDigit(fm.mail_dyr_ggr.value))+toInt(parseDigit(fm.mail_etc_hap.value)));
		fm.kj_bgs.value = parseDecimal(fm.mail_dyr_bgs.value);
		fm.good_mny.value = parseDecimal(toInt(parseDigit(fm.kj_ggr.value))+toInt(parseDigit(fm.kj_bgs.value))+toInt(parseDigit(fm.card_fee.value)));
	

	}		

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='scd_size' value=''>
<input type='hidden' name='s_cnt' value='<%=s_cnt%>'>
<input type='hidden' name='h_fee_amt1' value=''>
<input type='hidden' name='h_dly_amt1' value=''>
<input type='hidden' name='h_fee_amt2' value=''>
<input type='hidden' name='h_dly_amt2' value=''>
<input type='hidden' name='good_name' value=''>
<input type='hidden' name='msg' value=''>
<input type='hidden' name='buyr_name' value=''>
<input type='hidden' name='buyr_mail' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����+��ü ä�� �޽���<span class=style5> (�뿩��+��ü����+��å��+���·�+���������)</span></span></td>	
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
                    <td class='title' width='15%'>��ȣ</td>
                    <td width='85%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>

  
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ���� 5���̳�+��ü �뿩�� ����Ʈ</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<input type='hidden' name='scd_size2' value='<%=scd_size%>'>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>����</td>
                    <td class="title" width='15%'>������ȣ</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='5%'>ȸ��</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='10%'>�Աݿ�����</td>
                    <td class="title" width='15%'>�ݾ�</td>			
                    <td class="title" width='5%'><input type="checkbox" name="ch_all2" value="Y" onclick="javascript:AllSelect(2);"></td>
                </tr>
				
				<%	if(scd_size > 0){
						for(int i = 0 ; i < scd_size ; i++){
							Hashtable fee_scd = (Hashtable)fee_scds.elementAt(i);
							total_amt3 	= total_amt3 + Long.parseLong(String.valueOf(fee_scd.get("FEE_AMT")));%>
							<input type='hidden' name='fee_amt' value='<%=fee_scd.get("FEE_AMT")%>'>	
                <tr>
                    <td align="center"><%=i+1%></td>				
                    <td align="center"><%=fee_scd.get("CAR_NO")%>
                    <input type='hidden' name='ch_car_no' size='10' value='<%=fee_scd.get("CAR_NO")%>'></td>
                    <td align="center"><%=fee_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=fee_scd.get("FEE_TM")%></td>
                    <td align="center"><%=fee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_AMT")))%>' readonly>��
                    <input type='hidden' name='est_amt_s' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_S_AMT")))%>'>
                    <input type='hidden' name='est_amt_v' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_V_AMT")))%>'></td>
                    <td align="center"><input type="checkbox" name="ch_cd2" value="1" onclick="javascript:CountMailList(2);"></td>										
                </tr>							
				<%		}
					}%>
							
				<%	if(dly_size > 0){
						for(int i = 0 ; i < dly_size ; i++){
							Hashtable dly_scd = (Hashtable)dly_scds.elementAt(i);
							int dly_jan_amt = AddUtil.parseInt(String.valueOf(dly_scd.get("JAN_AMT")));
							total_amt4 	= total_amt4 + Long.parseLong(String.valueOf(dly_scd.get("JAN_AMT")));
							scd_size++;
					%>
                <tr>
				    <td align="center"><%=scd_size%></td>	
                    <td align="center"><%=dly_scd.get("CAR_NO")%>
                    <input type='hidden' name='ch_car_no' size='10' value='<%=dly_scd.get("CAR_NO")%>'></td>
                    <td align="center"><%=dly_scd.get("CAR_NM")%></td>					
                    <td align="center">-</td>
                    <td colspan="2" align="center">�뿩�� �̼���ü���� �հ�</td>					
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(dly_jan_amt)%>' readonly>��</td>
                    <td align="center"><input type="checkbox" name="ch_cd2" value="2" onclick="javascript:CountMailList(2);">				
                    <%if(scd_size>0){%><input type='hidden' name='est_amt_s' size='10' class='num' value='0'>
                    <input type='hidden' name='est_amt_v' size='10' class='num' value='0'><%}%>	
                    </td>					
                </tr>							
				<%		}
					}%>													
                <tr>
                    <td colspan="2" class=title>�հ�</td>
					<td colspan="4" class=title>
					�뿩�� : <input type='text' name='total_fee_amt2' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt3)%>'>��, 
					��ü���� : <input type='text' name='total_dly_amt2' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt4)%>'>��</td>					
                    <td class=title><input type='text' name='total_amt2' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt3+total_amt4)%>'>��
                  </td>
                    <td class=title>&nbsp;</td>						
                </tr>																																				
            </table>
        </td>
    </tr>
	<input type='hidden' name='scd_size3' value='<%=serv_size%>'>
	<%	if(serv_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ���� ��å�� �̼� ����Ʈ</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>����</td>
                    <td class="title" width='15%'>������ȣ</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='5%'>ȸ��</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='10%'>�Աݿ�����</td>
                    <td class="title" width='15%'>�ݾ�</td>	
                    <td class="title" width='5%'><input type="checkbox" name="ch_all3" value="Y" onclick="javascript:AllSelect(3);"></td>										
                </tr>	
				<%	for(int i = 0 ; i < serv_size ; i++){
							Hashtable serv_scd = (Hashtable)serv_scds.elementAt(i);
							total_amt5 	= total_amt5 + Long.parseLong(String.valueOf(serv_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='serv_amt' value='<%=serv_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center"><%=serv_scd.get("CAR_NO")%>
					<input type='hidden' name='ch_car_no' size='10' value='<%=serv_scd.get("CAR_NO")%>'></td>
                    <td align="center"><%=serv_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=serv_scd.get("EXT_TM")%></td>
                    <td align="center"><%=serv_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(serv_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(serv_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type="checkbox" name="ch_cd2" value="3" onclick="javascript:CountMailList(2);">
                    <input type='hidden' name='est_amt_s' size='10' class='num' value='0'>
                    <input type='hidden' name='est_amt_v' size='10' class='num' value='0'></td>					
                </tr>							
				<%	}%>									
                <tr>
                    <td colspan="6" class=title>�հ�</td>
                    <td class=title><input type='text' name='total_amt3' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt5)%>'>��</td>
                    <td class=title>&nbsp;</td>
                </tr>									
            </table>
        </td>
    </tr>							
	<%}%>	
	<input type='hidden' name='scd_size4' value='<%=fine_size%>'>
	<%	if(fine_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ���� ���·� �̼� ����Ʈ</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>����</td>
                    <td class="title" width='15%'>������ȣ</td>
                    <td class="title" width='15%'>��������</td>					
                    <td class="title" width='15%'>���ݳ���</td>
                    <td class="title" width='15%'>�������</td>					
                    <td class="title" width='15%'>�ݾ�</td>			
                    <td class="title" width='5%'><input type="checkbox" name="ch_all4" value="Y" onclick="javascript:AllSelect(4);"></td>										
                </tr>	
				<%	for(int i = 0 ; i < fine_size ; i++){
							Hashtable fine_scd = (Hashtable)fine_scds.elementAt(i);
							total_amt6 	= total_amt6 + Long.parseLong(String.valueOf(fine_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='fine_amt' value='<%=fine_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center"><%=fine_scd.get("CAR_NO")%>
					<input type='hidden' name='ch_car_no' size='10' value='<%=fine_scd.get("CAR_NO")%>'></td></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(fine_scd.get("VIO_DT")))%></td>					
                    <td align="center"><%=fine_scd.get("VIO_CONT")%></td>
                    <td align="center"><%=fine_scd.get("VIO_PLA")%></td>					
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fine_scd.get("EXT_AMT")))%>'>��
                    <input type='hidden' name='est_amt_s' size='10' class='num' value='0'>
                    <input type='hidden' name='est_amt_v' size='10' class='num' value='0'></td>
                    <td align="center"><input type="checkbox" name="ch_cd2" value="4" onclick="javascript:CountMailList(2)"></td>					
                </tr>							
				<%	}%>								
                <tr>
                    <td colspan="5" class=title>�հ�</td>
                    <td class=title><input type='text' name='total_amt4' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt6)%>'>��</td>
                    <td class=title>&nbsp;</td>
                </tr>									
				
            </table>
        </td>
    </tr>							
	<%}%>			
	<input type='hidden' name='scd_size5' value='<%=cls_size%>'>
	<%	if(cls_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ���� ��������� �̼� ����Ʈ</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>����</td>
                    <td class="title" width='15%'>������ȣ</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='5%'>ȸ��</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='10%'>�Աݿ�����</td>
                    <td class="title" width='15%'>�ݾ�</td>	
                    <td class="title" width='5%'><input type="checkbox" name="ch_all5" value="Y" onclick="javascript:AllSelect(5);"></td>										
                </tr>	
				<%	for(int i = 0 ; i < cls_size ; i++){
							Hashtable cls_scd = (Hashtable)cls_scds.elementAt(i);
							total_amt6 	= total_amt6 + Long.parseLong(String.valueOf(cls_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='cls_amt' value='<%=cls_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center"><%=cls_scd.get("CAR_NO")%>
					<input type='hidden' name='ch_car_no' size='10' value='<%=cls_scd.get("CAR_NO")%>'></td>
                    <td align="center"><%=cls_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=cls_scd.get("EXT_TM")%></td>
                    <td align="center"><%=cls_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(cls_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(cls_scd.get("EXT_AMT")))%>'>��
                    <input type='hidden' name='est_amt_s' size='10' class='num' value='0'>
                    <input type='hidden' name='est_amt_v' size='10' class='num' value='0'></td>
                    <td align="center"><input type="checkbox" name="ch_cd2" value="5" onclick="javascript:CountMailList(2);"></td>					
                </tr>							
				<%	}%>									
                <tr>
                    <td colspan="6" class=title>�հ�</td>
                    <td class=title><input type='text' name='total_amt5' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt6)%>'>��</td>
                    <td class=title>&nbsp;</td>
                </tr>									
            </table>
        </td>
    </tr>							
	<%}%>		
	<input type='hidden' name='scd_size6' value='<%=grt_size%>'>
	<%	if(grt_size > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ���� ������ �̼� ����Ʈ</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
				    <td class="title" width='5%'>����</td>
                    <td class="title" width='15%'>������ȣ</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='5%'>ȸ��</td>
                    <td class="title" width='15%'>����</td>					
                    <td class="title" width='10%'>�Աݿ�����</td>
                    <td class="title" width='15%'>�ݾ�</td>	
                    <td class="title" width='5%'><input type="checkbox" name="ch_all6" value="Y" onclick="javascript:AllSelect(6);"></td>										
                </tr>	
				<%	for(int i = 0 ; i < grt_size ; i++){
							Hashtable grt_scd = (Hashtable)grt_scds.elementAt(i);
							total_amt7 	= total_amt7 + Long.parseLong(String.valueOf(grt_scd.get("EXT_AMT")));
					%>
					<input type='hidden' name='grt_amt' value='<%=grt_scd.get("EXT_AMT")%>'>
                <tr>
                    <td align="center"><%=i+1%></td>		
					<td align="center"><%=grt_scd.get("CAR_NO")%>
					<input type='hidden' name='ch_car_no' size='10' value='<%=grt_scd.get("CAR_NO")%>'></td>
                    <td align="center"><%=grt_scd.get("CAR_NM")%></td>					
                    <td align="center"><%=grt_scd.get("EXT_TM")%></td>
                    <td align="center"><%=grt_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(grt_scd.get("EXT_AMT")))%>'>��
                    <input type='hidden' name='est_amt_s' size='10' class='num' value='0'>
                    <input type='hidden' name='est_amt_v' size='10' class='num' value='0'></td>
                    <td align="center"><input type="checkbox" name="ch_cd2" value="6" onclick="javascript:CountMailList(2);"></td>					
                </tr>							
				<%	}%>									
                <tr>
                    <td colspan="6" class=title>�հ�</td>
                    <td class=title><input type='text' name='total_amt6' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt7)%>'>��</td>
                    <td class=title>&nbsp;</td>
                </tr>									
            </table>
        </td>
    </tr>							
	<%}%>	
	 	
	  <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ���� ����  </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr>
    	<td class='line'> 
    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
    					<tr>
                	<td class=title width=5% rowspan='8'>����<br>����</td>
                	<td class=title width=5% rowspan='3'>�뿩��</td>
                	<td class=title width=10% style="height:30px;">���ް�</td>
                	<td>&nbsp;
                        <input type='text' name='mail_dyr_ggr' size='30' value='' class='text' style="text-align:right;" onchange="javascript:sumCount();"></td>
                </tr> 
                 <tr>
                	<td class=title width=10% style="height:30px;">�ΰ���</td>
                	<td>&nbsp;
                        <input type='text' name='mail_dyr_bgs' size='30' value='' class='text' style="text-align:right;" onchange="javascript:sumCount();"></td>
                </tr>  
                <tr>
                	<td class=title width=10% style="height:30px;">�Ұ�</td>
                	<td>&nbsp;
                        <input type='text' name='mail_dyr_hap' size='30' value='' class='text' style="text-align:right;border:white;" readonly></td>
                </tr> 
                <tr>
                	<td class=title width=5% rowspan='3'>��Ÿ<br>(VAT<br>�����)</td>
                	<td class=title width=5% style="height:30px;">���·� ��</td>
                	<td>&nbsp;
                        <input type='text' name='mail_etc_gtr' size='30' value='' class='text' style="text-align:right;" onchange="javascript:sumCount();"></td>
                </tr>  
                <tr>
                	<td class=title width=5% style="height:30px;">��ü��</td>
                	<td>&nbsp;
                        <input type='text' name='mail_etc_ycr' size='30' value='' class='text' style="text-align:right;" onchange="javascript:sumCount();"></td>
                </tr> 
                <tr>
                	<td class=title width=5% style="height:30px;">�Ұ�</td>
                	<td>&nbsp;
                        <input type='text' name='mail_etc_hap' size='30' value='' class='text' style="text-align:right;border:white;" readonly></td>
                </tr> 
                <tr>
                	<td class=title width=5% colspan='2' style="height:30px;">�հ�</td>
                	<td>&nbsp;
                        <input type='text' name='settle_mny' size='30' value='' class='text' style="text-align:right;border:white;" readonly></td>
                </tr> 
                <tr>
                	<td class=title width=5% colspan='2' style="height:30px;">��޼�����</td>
                	<td>&nbsp;
                        <input type='text' name='card_fee' size='30' value='' class='text' style="text-align:right;border:white;" readonly>&nbsp;&nbsp;����� �հ� x <input type='text' name='card_per' size='3' value='2.7' class='whitetext' style="text-align:right;" readonly>%</td>
                </tr>      
                 <tr>
                	<td class=title width=5% rowspan='4'>����<br>�ݾ�</td>
                </tr>           
                 <tr>
                	<td class=title width=5% colspan='2' style="height:30px;">���ް�</td>
                	<td>&nbsp;
                        <input type='text' name='kj_ggr' size='30' value='' class='text' style="text-align:right;border:white;" readonly>&nbsp;&nbsp;�뿩��(���ް�)+��Ÿ+��޼�����</td>
                </tr>  
                 <tr>
                	<td class=title width=5% colspan='2' style="height:30px;">�ΰ���</td>
                	<td>&nbsp;
                        <input type='text' name='kj_bgs' size='30' value='' class='text' style="text-align:right;border:white;" readonly></td>
                </tr>       						
                 <tr>
                	<td class=title width=5% colspan='2' style="height:30px;">�հ�</td>
                	<td>&nbsp;
                        <input type='text' name='good_mny' size='30' value='' class='text' style="text-align:right;font-weight:bold;border:white;" readonly></td>
                </tr>  
    		
    		</table>
    	</td>
    </tr>
    <tr>
    	<td style="text-align:left;">
    		<font color=red>�� �ݾ� ���� û���� �ݾ��� ���� �Է��Ͻʽÿ�.</font>
    	</td>
    </tr>
    <tr>
    	<td style="text-align:left;">
    		<input type="checkbox" name="mail_check" value="Y" onclick="">���� �߼��ϱ�
    	</td>
    </tr>
   
    <tr> 
        <td style="text-align:center;"><a href="javascript:sendP();"><img src=/acar/images/center/button_reg.gif align=absmiddle ></a></td>
    </tr>	
</table>


</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>

</script>
</body>
</html>