<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String s_gubun 	= request.getParameter("s_gubun")==null?"":request.getParameter("s_gubun");  //X:�μ�������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	
	//ī������
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	//�ŷ�ó����
	Hashtable vendor = new Hashtable();
	if(!cd_bean.getVen_code().equals("")){
		vendor = neoe_db.getVendorCase(cd_bean.getVen_code());
	}
	
	String card_file = cd_bean.getCard_file();
	

	String buy_user_id 		= cd_bean.getBuy_user_id();
	dept_id 				= c_db.getUserDept(buy_user_id);

	String brch_id 			= c_db.getUserBrch(buy_user_id);
	String chief_id			= "000004";

	if(brch_id.equals("S1") && dept_id.equals("0001"))					chief_id = "000005";
	if(brch_id.equals("S1") && dept_id.equals("0002"))					chief_id = "000026";
	if(buy_user_id.equals("000003") || buy_user_id.equals("000035"))			chief_id = "";
	if(brch_id.equals("B1"))								chief_id = "000053";
	if(brch_id.equals("D1"))								chief_id = "000052";
	if(brch_id.equals("G1"))								chief_id = "000054";
	if(brch_id.equals("J1"))								chief_id = "000020";
	if(brch_id.equals("S2"))								chief_id = "000005";
	
	
	String chk="0";
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	String car_su = "1";
	
	
	Vector vt_item = CardDb.getCardDocItemList(cardno, buy_id); 
 	int vt_i_size1 = vt_item.size();
 	
 	if ( vt_i_size1 > 0) {
 	    car_su = Integer.toString(vt_i_size1);
 	} 
	
	double img_width 	= 680;
	double img_height 	= 1009;
	String file_path = AddUtil.replace(AddUtil.replace(AddUtil.replace(cd_bean.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/");
//	String file_path = String.valueOf(cd_bean.getBuy_dt());
//	file_path = file_path.substring(0,4);

	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	int size = 0;
	
	String content_code = "CARD_DOC";
	String content_seq  = cardno+buy_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}
	}	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	
	
	//����
	function Save(){
		var fm = document.form1;

		if(fm.cardno.value == '')	{	alert('ī���ȣ�� �Է��Ͻʽÿ�.'); 	fm.cardno.focus(); 		return; }
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		if(fm.buy_s_amt.value == '0'){	alert('���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_s_amt.focus(); 	return; }
		if(fm.buy_amt.value == '0'){	alert('���Աݾ��� �Է��Ͻʽÿ�.'); 	fm.buy_amt.focus(); 	return; }		
		if(fm.ven_name.value == ''){	alert('�ŷ�ó�� �Է��Ͻʽÿ�.'); 	fm.ven_name.focus(); 	return; }
		if(fm.buy_v_amt.value != '0' && fm.ven_code.value == ''){	alert('�ŷ�ó�� ��ȸ�Ͻʽÿ�?'); return; }

			
		if(confirm('�����Ͻðڽ��ϱ�?')){
			//document.domain = "amazoncar.co.kr";
			fm.action='doc_reg_us_a.jsp';		
			fm.target='i_no';
			fm.submit();
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
	
	//�ݾ׼���

	function tot_buy_amt(){
		var fm = document.form1;	
		
		if(fm.ven_st[0].checked == true )
		{		
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}			
		
	}	
	
	
	//�ݾ׼���
	function set_buy_amt(){
		var fm = document.form1;	
		fm.buy_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) + toInt(parseDigit(fm.buy_v_amt.value)));				
	}
	
	//�ݾ׼���
	function set_buy_s_amt(){
		var fm = document.form1;	
		fm.buy_s_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_v_amt.value)));				
	}
	
	//�ݾ׼���
	function set_buy_v_amt(){
		var fm = document.form1;	
		//����� ������
		//if(fm.acct_code[1].checked == false ){
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		//}
		set_buy_amt();			
	}	
	
	//�׿�����ȸ-�ſ�ī��
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "../doc_reg/neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
	//�׿�����ȸ-ǰ��
	function Neom_search2(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'item')	fm.t_wd.value = fm.item_name.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "../card_mng/neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter2(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search2(s_kd);
	}
	
	//�ŷ�ó��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.ven_name.value != '')	fm.t_wd.value = fm.ven_name.value;		
		window.open("../doc_reg/vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=300, top=300, width=700, height=400, scrollbars=yes");		
	}
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	//������ȸ�ϱ�
	function Rent_search(idx1){
		var fm = document.form1;	
		var t_wd;		 
	
		if(fm.buy_dt.value == '')	{	alert('�ŷ����ڸ� �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
				
		//������ ����
		if(fm.acct_code[4].checked == true){ 	//���������
			if(fm.acct_code_g[7].checked == false && fm.acct_code_g[8].checked == false && fm.acct_code_g[9].checked == false && fm.acct_code_g[10].checked == false && fm.acct_code_g[11].checked == false )
			{	alert('������ �����Ͻʽÿ�.'); 	fm.buy_dt.focus(); 		return; }
		}
					
		if(fm.item_name[idx1].value != ''){	fm.t_wd.value = fm.item_name[idx1].value;		}
		else{ 							alert('��ȸ�� ������ȣ/��ȣ�� �Է��Ͻʽÿ�.'); 	fm.item_name.focus(); 	return;}
		
		
		if ( fm.acct_code[4].checked == true ) {
			if (fm.acct_code_g[7].checked 	== true  || fm.acct_code_g[10].checked 	== true ) { //�Ϲ������, �縮�� �����
				window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
		    } else {
		    	window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			    
		    }
		} else if ( fm.acct_code[5].checked == true ) {
			window.open("../doc_reg/service_search.jsp?idx1="+idx1+"&t_wd="+fm.t_wd.value+"&buy_dt="+fm.buy_dt.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");			
	    } else {		
			window.open("../doc_reg/rent_search.jsp?t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
		}
			
	}
	
	function Rent_enter(idx1) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Rent_search(idx1);
	}	
		
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm.value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "../card_mng/user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}	
	
	//������ȸ-�����Է�
	function User_search2(nm, idx)
	{
		var fm = document.form1;
		if(fm.user_nm[idx].value != '') 	fm.t_wd.value = fm.user_nm[idx].value;
		else								fm.t_wd.value = '';
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "../card_mng/user_search.jsp?dept_id="+fm.dept_id[idx-1].value+"&nm="+nm+"&idx="+idx;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter2(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search2(nm, idx);
	}	
	
	//�������� �ȳ���
	function help(){
		var fm = document.form1;
		var SUBWIN="../doc_reg/help.jsp";	
		window.open(SUBWIN, "help", "left=350, top=350, width=400, height=300, scrollbars=yes, status=yes");
	}
	
			
	function cng_input_vat()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio[0].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) + 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
		
		if(fm.vat_Rdio[1].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) - 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_s_amt();	
		}
	}
	
	//�����Է½� �հ��� �� ����
	function Keyvalue()
	{
		var fm 		= document.form1;
		var innTot	= 0;
		
		for(i=0; i<60 ; i++){
			innTot += toInt(parseDigit(fm.money[i].value));
		}
		fm.txtTot.value = parseDecimal(innTot);
	}
	
	function CardDocHistory(ven_code, cardno, buy_id){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code+"&cardno="+cardno+"&buy_id="+buy_id, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
	
	function VendorHistory(ven_code){
		var fm = document.form1;
		window.open("../doc_reg/vendor_history.jsp?ven_code="+ven_code, "VENDOR_H_LIST", "left=10, top=10, width=1050, height=600, scrollbars=yes");				
	}
	
	
	//ī����ǥ ī�庯��
	function doc_card_change(){
		var fm = document.form1;
		window.open("about:blank",'CardChange','scrollbars=yes,status=no,resizable=yes,width=600,height=200,left=250,top=250');		
		fm.action = "card_change.jsp";
		fm.target = "CardChange";
		fm.submit();		
	}
	
	function check_save(){
		var fm = document.form1;
		fm.action = './check_a.jsp';		
		fm.submit();
	}

        //����/������ Ȯ��
	function doc_card_gj(){
		var fm = document.form1;
		fm.action = './card_gj_a.jsp';		
		fm.submit();
	}
//-->
</script>

</head>
<body onload="javascript:document.form1.buy_dt.focus();">
<form action="" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type="hidden" name="cardno" value="<%=cardno%>">
<input type="hidden" name="buy_id" value="<%=buy_id%>">
<input type="hidden" name="s_gubun" value="<%=s_gubun%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%  >
	<tr>
		<td width="400" valign="top">
			<table border=0 cellspacing=0 cellpadding=0 width=400>
				<tr>
					<td colspan=3 >
						<table width=400 border=0 cellpadding=0 cellspacing=0>
							<tr>
								<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
								<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
									<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>��ǥ���� �� ������ �Բ�����</span></span></td>
								<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td class=h></td></tr><tr><td class=h></td></tr>
				<tr><td class=line2 colspan=2></td></tr>
				<tr> 
					<td colspan="2" class="line">
						<table border="0" cellspacing="1" cellpadding="0" width='400'>
							<tr>
								<td width="120" class='title'>�ſ�ī���ȣ</td>
								<td width="280">&nbsp;<input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" readonly>
              &nbsp;<a href="javascript:doc_card_change();" ><img src=/acar/images/center/button_in_modify_card.gif border=0 align=absmiddle></a>&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>	
				<tr><td class=h></td></tr>
				<tr>
					<td  colspan=2 class=h>
						<img src=/acar/images/center/arrow_ccdrj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getReg_id(), "USER")%>  
						&nbsp;&nbsp; <img src=/acar/images/center/arrow_ccdri.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getReg_dt())%> <br>
						<img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : <%=c_db.getNameById(cd_bean.getApp_id(), "USER")%>
						&nbsp;&nbsp; <img src=/acar/images/center/arrow_cjsji.gif align=absmiddle> : <%=AddUtil.ChangeDate2(cd_bean.getApp_dt())%> 
					</td>
				</tr>
				<tr><td class=h></td></tr>
				<tr><td class=line2 colspan=2></td></tr>
				<tr>
					<td colspan="2" class=line>
						<table border="0" cellspacing="1" cellpadding="0" width='400'>
							<tr>
								<td colspan="2" class='title' width='120'>�ŷ�����</td>
								<td width="280">&nbsp;
								<input name="buy_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(cd_bean.getBuy_dt())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
							</tr>
							<tr>
								<td width="5%" rowspan="3" class='title'>��<br>��<br>��<br>��</td>
								<td class='title' width="100">���ް�</td>
								<td>&nbsp;
								<input type="text" name="buy_s_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_s_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_v_amt();'>
								��</td>
							</tr>		  
							<tr>
								<td class='title'>�ΰ���</td>
								<td>&nbsp;
								<input type="text" name="buy_v_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_v_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_buy_amt();'>
								��
								</td>
							</tr>
							<tr>
								<td class='title'>�հ�</td>
								<td>&nbsp;
								<input type="text" name="buy_amt" value="<%=Util.parseDecimal(cd_bean.getBuy_amt())%>" size="12" class=num onBlur='javascript:this.value=parseDecimal(this.value); tot_buy_amt();'>
								��
								</td>
							</tr>
							<tr>
								<td colspan="2" class='title'>�ŷ�ó</td>
								<td>&nbsp;
								<input name="ven_name" type="text" class="text" value="<%=cd_bean.getVen_name()%>" size="40" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
			  <input type="hidden" name="ven_code" value="<%=cd_bean.getVen_code()%>">
			  <input type="hidden" name="ven_nm_cd" value="">
			  <br>&nbsp;
			  <a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			  &nbsp;<a href="javascript:CardDocHistory('<%=cd_bean.getVen_code()%>','<%=cd_bean.getCardno()%>','<%=cd_bean.getBuy_id()%>');" ><img src=/acar/images/center/button_in_uselist.gif border=0 align=absmiddle></a>
			  &nbsp;<a href="javascript:VendorHistory('<%=cd_bean.getVen_code()%>');" ><img src=/acar/images/center/button_in_bgir.gif border=0 align=absmiddle></a></td>
							</tr>
							<tr>
								<td colspan="2" class='title'>����ڵ�Ϲ�ȣ</td>
								<td>&nbsp;
								<%=AddUtil.ChangeEnt_no(String.valueOf(vendor.get("S_IDNO")))%>
								</td>
							</tr>
							<tr>
								<td colspan="2" class='title'>��������</td>
								<td >&nbsp;<input type="radio" name="ven_st" value="1" <%if(cd_bean.getVen_st().equals("1"))%>checked<%%>>�Ϲݰ���<br>
			     &nbsp;<input type="radio" name="ven_st" value="2" <%if(cd_bean.getVen_st().equals("2"))%>checked<%%>>���̰���<br>
			     &nbsp;<input type="radio" name="ven_st" value="3" <%if(cd_bean.getVen_st().equals("3"))%>checked<%%>>�鼼<br>
			     &nbsp;<input type="radio" name="ven_st" value="4" <%if(cd_bean.getVen_st().equals("4"))%>checked<%%>>�񿵸�����(�������/��ü)<br>
					<!--&nbsp;&nbsp;<a href="http://www.nts.go.kr/cal/cal_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif border=0 align=absmiddle></a>-->
					&nbsp;&nbsp;<a href="http://www.nts.go.kr/cal/cal_check_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>					
								</td>
							</tr>		            		  
							<tr>
								<td colspan="2" class='title'>�����</td>
								<td width="280">&nbsp;
								<%=c_db.getNameById(cd_bean.getBuy_user_id(), "USER")%>
			  								</td>
							</tr>

							<tr>
								<td colspan="2" class='title'>��������</td>
								<td width="280" align="left">&nbsp;
									<%if(cd_bean.getAcct_code().equals("00001")||cd_bean.getAcct_code().equals("00002")||cd_bean.getAcct_code().equals("00003")||cd_bean.getAcct_code().equals("00004")||cd_bean.getAcct_code().equals("00005")||cd_bean.getAcct_code().equals("00006")||cd_bean.getAcct_code().equals("00007")||cd_bean.getAcct_code().equals("00009")){%>
									<font color="#CCCCCC">[����]</font>
									<%}else{%>
									<font color="#CCCCCC">[����]</font>
									<%}%>
									&nbsp;
									<%if(cd_bean.getAcct_code().equals("00001")){%>�����Ļ���<%}%>
									<%if(cd_bean.getAcct_code().equals("00002")){%>�����<%}%>
									<%if(cd_bean.getAcct_code().equals("00003")){%>�������<%}%>
									<%if(cd_bean.getAcct_code().equals("00004")){%>����������<%}%>
									<%if(cd_bean.getAcct_code().equals("00005")){%>���������<%}%>
									<%if(cd_bean.getAcct_code().equals("00006")){%>��������<%}%>
									<%if(cd_bean.getAcct_code().equals("00007")){%>�繫��ǰ��<%}%>
									<%if(cd_bean.getAcct_code().equals("00009")){%>��ź�<%}%>

									<%if(cd_bean.getAcct_code().equals("00008")){%>�Ҹ�ǰ��<%}%>
									<%if(cd_bean.getAcct_code().equals("00010")){%>�����μ��<%}%>
									<%if(cd_bean.getAcct_code().equals("00011")){%>���޼�����<%}%>
									<%if(cd_bean.getAcct_code().equals("00012")){%>��ǰ<%}%>
									<%if(cd_bean.getAcct_code().equals("00013")){%>���ޱ�<%}%>
									<%if(cd_bean.getAcct_code().equals("00014")){%>�����Ʒú�<%}%>
									<%if(cd_bean.getAcct_code().equals("00015")){%>���ݰ�����<%}%>
									<%if(cd_bean.getAcct_code().equals("00016")){%>�뿩�������<%}%>
									<%if(cd_bean.getAcct_code().equals("00017")){%>�����������<%}%>
									<%if(cd_bean.getAcct_code().equals("00019")){%>��ݺ�<%}%>
									<%if(cd_bean.getAcct_code().equals("00015")){%>�������<%}%>
								</td>			
							</tr>
						</table>
					</td>
				</tr>
				<tr><td class=h></td></tr>
				<tr><td class=h colspan='2'>���̻���� ��� Ȯ�ι�ư�� Ŭ���Ͻø� �ڵ�üũ�� �˴ϴ�. <br> �س�������ϰ� ������ư Ŭ���� ����ڰ� Ȯ���Ѱ����� ���ϴ�. </td></tr>
				<tr><td class=h></td></tr>
				<tr>
					<td align="left">
					<%if(!s_gubun.equals("X")){%>	<a href="javascript:check_save()"><img src=/acar/images/center/button_conf.gif border=0 align=absmiddle></a><%}%>
					</td>
					<td align="right">	
						<%if(!s_gubun.equals("X")){%><a href="javascript:Save()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a><%}%>
						<%if(s_gubun.equals("X")){%><a href="javascript:doc_card_gj()"><img src=/acar/images/center/button_bsj.gif border=0 align=absmiddle></a><%}%>
						<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
					</td>
				</tr>
			</table>
		</td>
		<td width="800" valign="top">
			<table border=0 cellspacing=0 cellpadding=0 width=100%>
				<tr>
					<td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="Ȯ��" onclick="zoomin()">
										<input type="button" value="���" onclick="zoomout()"></td>
				</tr>
				<tr>
					<td>
					<%if(!cd_bean.getCard_file().equals("")){%>
						<img name="test" src="https://fms3.amazoncar.co.kr/data/<%=file_path%><%=cd_bean.getCard_file()%>" width=800 height=<%=img_height%>><br style="page-break-before:always;">
					<%}else{%>
						<%if(!file_name1.equals("")){%>
						<img name="test" src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=seq1%>" width=800 height=<%=img_height%>><br style="page-break-before:always;">
						<%}else{%>
							<center><font color='red'>��ϵ� ��ĵ �������� �����ϴ�.</font></center>
						<%}%>	
					<%}%>
					</td>
				</tr>
			</table>		
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
var a = 1

function zoomin(){
	a += 0.1
	document.test.style.zoom = a
}

function zoomout(){
	a -= 0.1
	document.test.style.zoom = a
}
//-->
</script>
</body>
</html>
