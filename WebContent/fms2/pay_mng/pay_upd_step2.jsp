<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.pay_mng.*, acar.cont.*, acar.car_register.*, acar.accid.*, acar.cus_reg.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int    sh_height	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String r_acct_code 	= request.getParameter("r_acct_code")==null?"":request.getParameter("r_acct_code");
	String reqseq 		= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int    i_seq 		= request.getParameter("i_seq")==null?1:AddUtil.parseInt(request.getParameter("i_seq"));
	
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");	
	
	String chk="0";
	long total_amt1	= 0;
	long total_amt2	= 0;
	
	CommonDataBase 		c_db = CommonDataBase.getInstance();
	AccidDatabase 		as_db = AccidDatabase.getInstance();
	PayMngDatabase 		pm_db = PayMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	
	
	//��ݿ���
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	//��ݿ��� ���� �׸�
	Vector vt =  pm_db.getPayItemList(reqseq);
	int vt_size = vt.size();
	
	if(i_seq == 0 && vt_size>0)	i_seq = 1;
	
	//��ݿ���
	PayMngBean item	= pm_db.getPayItem(reqseq, i_seq);
	
	//�۱ݿ���
	PayMngActBean act = pm_db.getPayAct(pay.getBank_code(), pay.getP_pay_dt(), pay.getOff_nm(), pay.getBank_no(), pay.getA_bank_no());
	
	
	
	
	
	
	
	
	//Ź�ۻ���
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	//�����
	UsersBean reger_bean 	= umd.getUsersBean(pay.getReg_id());
	
	//������
	int user_size = c_db.getUserSize();
	
	if(user_size > 30 && user_size < 40) 		user_size = 40;
	else if(user_size > 40 && user_size < 50) 	user_size = 50;
	else if(user_size > 50 && user_size < 60) 	user_size = 60;
	else if(user_size > 60 && user_size < 70) 	user_size = 70;
	else if(user_size > 70 && user_size < 80) 	user_size = 80;
	else if(user_size > 80 && user_size < 90) 	user_size = 90;
	else if(user_size > 90 && user_size < 100) 	user_size = 100;
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&from_page="+from_page+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&reqseq="+reqseq+"";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" src="InnoAP.js"></script>
<script language="JavaScript">
<!--
	
	//��ĵ���
	function scan_file(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&reqseq=<%=reqseq%>&from_page=/fms2/pay_mng/pay_upd_step2.jsp&file_st="+file_st, "SCAN", "left=300, top=300, width=620, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//����Ʈ
	function list(){
		var fm = document.form1;		
		if(fm.from_page.value == ''){
			fm.action = '/fms2/pay_mng/pay_upd_step2.jsp';
		}else{
			fm.action = fm.from_page.value;
		}			
		fm.target = 'd_content';
		fm.submit();
	}	

	//����Ű ó��
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13'){		 			
			if(nm == 'off_id')			off_search(idx);			
		}
	}	

	
	
	//����ó��ȸ�ϱ�
	function off_search(idx){
		var fm = document.form1;	
		var t_wd = fm.off_nm.value;
		var off_st_nm = fm.off_st.options[fm.off_st.selectedIndex].text;
		if(fm.off_st.value == ''){		alert('��ȸ�� ����ó ������ �����Ͻʽÿ�.'); 	fm.off_st.focus(); 	return;}
		if(fm.off_nm.value == ''){		alert('��ȸ�� ����ó���� �Է��Ͻʽÿ�.'); 		fm.off_nm.focus(); 	return;}
		window.open("/fms2/pay_mng/off_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&off_st="+fm.off_st.value+"&idx="+idx+"&t_wd="+t_wd+"&off_st_nm="+off_st_nm, "OFF_LIST", "left=50, top=50, width=1150, height=550, scrollbars=yes");		
	}
	
	//�׿��� ��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		if(fm.ven_name.value == ''){	alert('��ȸ�� �׿����ŷ�ó���� �Է��Ͻʽÿ�.'); fm.ven_name.focus(); return;}
		window.open("/card/doc_reg/vendor_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&idx="+idx+"&t_wd="+fm.ven_name.value+"&from_page=/fms2/pay_mng/off_list.jsp", "VENDOR_LIST", "left=150, top=150, width=950, height=550, scrollbars=yes");		
	}			
	function ven_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') ven_search(idx);
	}	
		
	//������ȸ�ϱ�
	function Rent_search(){
		var fm = document.form1;	
		if(fm.car_info.value != '')	fm.t_wd.value = fm.car_info.value;
		window.open("/card/doc_reg/rent_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&go_url=/fms2/pay_mng/pay_dir_reg.jsp&t_wd="+fm.t_wd.value, "RENT_search", "left=350, top=150, width=600, height=400, scrollbars=yes");		
	}
	
	
		
	//�ݾ׼���
	function tot_buy_amt2(){
		var fm = document.form1;		
		//fm.buy_amt.value 			= parseDecimal(toInt(parseDigit(fm.sub_amt1.value)) + toInt(parseDigit(fm.sub_amt2.value)) + toInt(parseDigit(fm.sub_amt3.value)) + toInt(parseDigit(fm.sub_amt4.value)) + toInt(parseDigit(fm.sub_amt5.value)) + toInt(parseDigit(fm.sub_amt6.value)));		
	}		
		
	//�ݾ׼���
	function tot_buy_amt(){
		var fm = document.form1;		
		if(fm.ven_st[1].checked == true )
		{		
			fm.buy_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.buy_amt.value))));
			fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_amt.value)) - toInt(parseDigit(fm.buy_s_amt.value)));		
		}	
	}		
	function set_buy_amt(){
		var fm = document.form1;	
		fm.buy_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) + toInt(parseDigit(fm.buy_v_amt.value)));		
	}
	function set_buy_v_amt(){
		var fm = document.form1;	
		fm.buy_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.buy_s_amt.value)) * 0.1 );
		set_buy_amt();			
	}		
	function cng_input_vat()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio[0].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) + 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_amt();	
		}
		if(fm.vat_Rdio[1].checked == true && toInt(parseDigit(fm.buy_v_amt.value)) > 0)
		{
			var inAmt = Math.round(toInt(parseDigit(fm.buy_v_amt.value)) - 1);			
			fm.buy_v_amt.value = parseDecimal(inAmt);
			set_buy_amt();	
		}
	}	
	function cng_input_vat2()
	{
		var fm 		= document.form1;
		var inVat	= toInt(parseDigit(fm.buy_v_amt.value));
		
		if(fm.vat_Rdio2.checked == true && inVat > 0)
		{
			fm.buy_v_amt.value = 0;
			set_buy_amt();	
		}else{
			set_buy_v_amt();
			set_buy_amt();				
		}
	}		

	//����ó ���ý�
	function cng_off_input(){
		var fm = document.form1;
		fm.off_nm.focus();
		if(fm.off_st.options[fm.off_st.selectedIndex].value == 'user_id' && fm.buy_user_id.value != ''){
		}
	}
	

		
	function save()
	{
		var fm = document.form1;
		
		//�����̸鼭 ��ü���� �ִ°� üũ
		if(fm.p_way[0].checked == true && fm.bank_no.value != ''){
			alert('��ݹ���� �����ε� �Աݰ��¹�ȣ�� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.'); 
			return;
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action = 'pay_upd_step2_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
			
			link.getAttribute('href',originFunc);
		}
	}	
	
	//�۱ݸ���Ʈ
	function view_pay_act(bank_code, p_pay_dt, off_nm, bank_no, a_bank_no){
		window.open("pay_r_act_u.jsp<%=valus%>&bank_code="+bank_code+"&p_pay_dt="+p_pay_dt+"&off_nm="+off_nm+"&bank_no="+bank_no+"&a_bank_no="+a_bank_no, "VIEW_PAY_ACT", "left=10, top=10, width=1000, height=750, scrollbars=yes");							
	}
	
	//�����ϱ�
	function pay_delete(){
		var fm = document.form1;		
		
		if(!confirm('��ݿ��� ���� �Ͻðڽ��ϱ�?')){	return; }
		if(!confirm('�ٽ� Ȯ���մϴ�. ��ݿ��� ���� �Ͻðڽ��ϱ�?')){	return; }
		if(!confirm('������ ��ݿ��� ���� �Ͻðڽ��ϱ�?')){	return; }
		
		if(confirm('��¥�� ��ݿ��� ���� �Ͻðڽ��ϱ�?')){
			fm.action = 'pay_upd_step1_d.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}		
	}
	

	//����ȭ��
	function update_page(i_seq){
		window.open("pay_upd_step2_in.jsp<%=valus%>&mode=<%=mode%>&i_seq="+i_seq, "UPDATE_PAY_ITEM", "left=10, top=10, width=1200, height=750, scrollbars=yes");					
	}
		
	//�׿�����ǥ��ȸ
	function doc_reg(){
		var fm = document.form1;
		
		if(fm.ven_code.value == ''){ alert('�׿����ŷ�ó�ڵ尡 �����ϴ�.'); return; }
		
		if(confirm('�����ޱ���ǥ�� �����Ͻðڽ��ϱ�?')){
			fm.action = 'pay_c_u_25300_a.jsp';
			fm.target = 'i_no';
		}
	}		
	
	
	//�׿�����ǥ��ȸ
	function doc_reg_search(){
		var fm = document.form1;
		
		if(fm.ven_code.value == ''){ alert('�׿����ŷ�ó�ڵ尡 �����ϴ�.'); return; }
		
		if(confirm('�����ޱ���ǥ�� �����Ͻðڽ��ϱ�?')){
			fm.action = 'pay_c_u_25300_s_a.jsp';
			fm.target = 'i_no';
			fm.submit();		
		}
	}
	

	function view_autodocu(reqseq){
		window.open('pay_autodocu.jsp<%=valus%>', "PAY_AUTODOCU", "left=0, top=0, width=800, height=400, scrollbars=yes, status=yes, resizable=yes");	
	}				
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>  
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>        
  <input type='hidden' name='from_page' value='<%=from_page%>'>      
  <input type='hidden' name='r_est_dt' 	value='<%=pay.getP_est_dt()%>'>            
  <input type='hidden' name='off_id' 	value='<%=pay.getOff_id()%>'>              
  <input type='hidden' name='p_gubun' 	value='<%=item.getP_gubun()%>'>                
  <input type="hidden" name="rent_mng_id" value="<%=item.getP_cd1()%>">
  <input type="hidden" name="rent_l_cd" value="<%=item.getP_cd2()%>">
  <input type="hidden" name="car_mng_id" value="<%=item.getP_cd3()%>">
  <input type="hidden" name="client_id" value="">  
  <input type="hidden" name="accid_id" 	value="<%=item.getP_cd4()%>">
  <input type="hidden" name="serv_id" 	value="<%=item.getP_cd5()%>">
  <input type="hidden" name="maint_id" 	value="<%=item.getP_cd6()%>">  
  <input type='hidden' name='r_acct_code' value='<%=r_acct_code%>'>
  <input type='hidden' name='go_url' 	value='/fms2/pay_mng/pay_upd_step2.jsp'>      
  <input type='hidden' name='acct_code_nm' value=''>      
  <input type="hidden" name="ven_nm_cd" value="">
  <input type="hidden" name="mode" value="<%=mode%>">  

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						��ݿ��� ���� (2�ܰ�)</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!mode.equals("view")){%>
	<tr>
	    <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
	<tr> 
	<%}%>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>����ڵ�</td>
            <td >&nbsp;			  
              <%=reqseq%> </td>
          </tr>		
          <tr>
            <td width="15%" class=title>�������</td>
            <td >&nbsp;			  
              <%=AddUtil.ChangeDate2(pay.getP_pay_dt())%> </td>
          </tr>		
          <tr>
            <td class=title>�ݾ�</td>
            <td>&nbsp;
              <%=AddUtil.parseDecimalLong(pay.getAmt())%>
              �� &nbsp;
		    </td>
          </tr>		  
          <tr>
            <td class=title>����ó</td>
            <td>&nbsp;
              <select name='off_st' class='default' onchange="javascript:cng_off_input()" disabled>
                <option value="" >����</option>                
                <option value="off_id"   <%if(pay.getOff_st().equals("off_id"))	%>selected<%%>>���¾�ü</option>
                <option value="gov_id"   <%if(pay.getOff_st().equals("gov_id"))	%>selected<%%>>������</option>
                <option value="com_code" <%if(pay.getOff_st().equals("com_code"))%>selected<%%>>ī���</option>
				<option value="br_id"    <%if(pay.getOff_st().equals("br_id"))	%>selected<%%>>�Ƹ���ī</option>
				<option value="user_id"  <%if(pay.getOff_st().equals("user_id"))%>selected<%%>>�Ƹ���ī���</option>
				<option value="other"    <%if(pay.getOff_st().equals("other")||pay.getOff_st().equals("ven_code"))	%>selected<%%>>��Ÿ</option>
              </select><br>
			  &nbsp;
              <input type='text' name='off_nm' size='55' value='<%=pay.getOff_nm()%>' class='whitetext' style='IME-MODE: active' onKeyDown="javasript:enter('off_id', '')" readonly>
              &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> ����ڵ�Ϲ�ȣ :
			  <%//�׿����ڵ� ó��
				if(!pay.getVen_code().equals("") && pay.getS_idno().equals("")){
					Hashtable vendor = neoe_db.getVendorCase(pay.getVen_code());
					pay.setS_idno(String.valueOf(vendor.get("S_IDNO")));
				}%>
              <input type='text' name='off_idno' size='12' value='<%=pay.getS_idno()%>' class='whitetext'>
			  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> ����ó :
              <input type='text' name='off_tel' size='13' value='<%=pay.getOff_tel()%>' class='whitetext'>
			  <input type="hidden" name="off_id" value="<%=pay.getOff_id()%>" class='whitetext'></td>
          </tr>				  
          <tr>
            <td class=title>�׿����ŷ�ó</td>
            <td>&nbsp;
			  <input type='text' name='ven_name' size='55' value='<%=pay.getVen_name()%>' class='text' style='IME-MODE: active' onKeyDown="javasript:ven_enter('')" readonly>
			  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <input type='text' name='ven_code' size='8' value='<%=pay.getVen_code()%>' class='text'></td>
          </tr>
          <tr>
            <td class=title>��������</td>
            <td><input type="hidden" name="ve_st" value="">&nbsp;
			  <input type="radio" name="ven_st" value="1" <%if(pay.getVen_st().equals("1"))	%>checked<%%>>
              �Ϲݰ���&nbsp;
              <input type="radio" name="ven_st" value="2" <%if(pay.getVen_st().equals("2"))	%>checked<%%> >
              ���̰���&nbsp;
              <input type="radio" name="ven_st" value="3" <%if(pay.getVen_st().equals("3"))	%>checked<%%> >
              �鼼&nbsp;
              <input type="radio" name="ven_st" value="4" <%if(pay.getVen_st().equals("4"))	%>checked<%%> >
              �񿵸�����(�������/��ü)&nbsp;
              <input type="radio" name="ven_st" value="0" <%if(pay.getVen_st().equals("0"))	%>checked<%%> >
              ����&nbsp;			  
              <a href="https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a> </td>
          </tr>	
          <tr>
            <td class=title>���ݰ�꼭����</td>
            <td>&nbsp;
			    <input type='radio' name="tax_yn" value='Y' <%if(pay.getTax_yn().equals("Y"))	%>checked<%%> >�ִ�
				<input type='radio' name="tax_yn" value='N' <%if(pay.getTax_yn().equals("N"))	%>checked<%%> >����
				<input type='radio' name="tax_yn" value='C' <%if(pay.getTax_yn().equals("C"))	%>checked<%%> >���ݿ�����(���ι�ȣ : <input type='text' name='cash_acc_no' size='9' maxlength='9' value='<%=pay.getCash_acc_no()%>' class='default' >)
			</td>
          </tr>		
          <tr>
            <td class=title>�����ޱݹ��࿩��</td>
            <td >&nbsp;
			    <input type='radio' name="acct_code_st" value='1' <%if(pay.getAcct_code_st().equals("1"))	%>checked<%%> >�𸥴�.				
				<input type='radio' name="acct_code_st" value='4' <%if(pay.getAcct_code_st().equals("4"))	%>checked<%%> >�����ޱ� ó������ �ʴ´�.
				<input type='radio' name="acct_code_st" value='2' <%if(pay.getAcct_code_st().equals("2"))	%>checked<%%> >������� �����ޱ� ��ǥ�� �ִ�.
				<input type='radio' name="acct_code_st" value='3' <%if(pay.getAcct_code_st().equals("3"))	%>checked<%%> >��������� �����ޱ� ��ǥ�� �����ϰڴ�.			
			</td>
          </tr>		
          <tr>
            <td class=title>��ݽð�</td>
            <td>&nbsp;
			  	<input type='radio' name="at_once" value='Y' <%if(pay.getAt_once().equals("Y"))	%>checked<%%> >
				���
				<input type='radio' name="at_once" value='N' <%if(pay.getAt_once().equals("N")||pay.getAt_once().equals(""))%>checked<%%> >
                ����
			</td>
          </tr>		
          <tr>
            <td class=title>�۱����տ���</td>
            <td>&nbsp;
			  	<input type='radio' name="act_union_yn" value='N' <%if(pay.getAct_union_yn().equals("N"))	%>checked<%%> >
				�����۱�
				<input type='radio' name="act_union_yn" value='Y' <%if(pay.getAct_union_yn().equals("Y")||pay.getAct_union_yn().equals(""))%>checked<%%> >
                ���ռ۱� (���� ����ó�� ��� �۱�ó��)
			</td>
          </tr>		  		  		    		    		  
          <%
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "PAY";
			String content_seq  = reqseq; 
			
			Vector attach_vt = attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
			int attach_vt_size = attach_vt.size();   
			
			if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
          %>
          <tr>
            <%if(j==0){%><td rowspan="5" class=title>��������</td><%}%>
            <td>&nbsp;
                <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a>
                &nbsp;&nbsp;
                <a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
 	    </td>
         </tr>
         <%			}%>
         <%		}%>
         
         <%		for(int i=attach_vt_size;i < 5;i++){%>
          <tr>         
            <%if(attach_vt_size==0 && i==0){%><td rowspan="5" class=title>��������</td><%}%>   
            <td>&nbsp;
                <a href="javascript:scan_file('')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
 	    </td>
         </tr>                  
         <%		}%>   
		  <%if(pay.getM_amt() > 0 ){%>
          <tr>
            <td class=title>������</td>
            <td >&nbsp;������ݾ� : <%=pay.getM_amt()%>, ���� : <%=pay.getM_cau()%>
			</td>
          </tr>		  
		  <%}%>			  
          <tr>
            <td class=title>�۱ݰ��</td>
            <td >&nbsp;�Աݰ��� : <%=pay.getBank_nm()%> <%=pay.getBank_no()%>, ��ݰ��� : <%=pay.getA_bank_nm()%> <%=pay.getA_bank_no()%>, 
			           <%if(!pay.getA_bank_no().equals("")){%>�۱����� : <a href="javascript:view_pay_act('<%=pay.getBank_code()%>','<%=pay.getP_pay_dt()%>','<%=pay.getOff_nm()%>','<%=pay.getBank_no()%>','<%=pay.getA_bank_no()%>');"><%=act.getR_act_dt()%></a>, �۱ݱݾ� : <%=act.getAmt()%>��, ��ü������ : <%=act.getCommi()%>��, bank_code : <%=pay.getBank_code()%><%}%>
					   <%if(pay.getP_way().equals("3") || pay.getP_way().equals("2") || pay.getP_way().equals("7")){%>
					   <br>
					   &nbsp;<%if(pay.getP_way().equals("2")){%>����ī��<%}else if(pay.getP_way().equals("2")){%>�ĺ�ī��<%}else if(pay.getP_way().equals("7")){%>ī���Һ�<%}%> : <%=pay.getCard_nm()%> <%=pay.getCard_no()%>
					   <%}%>
			</td>
          </tr>		  			  
          <tr>
            <td class=title>����ڵ���ǥ</td>
            <td >&nbsp;<%if(!pay.getAutodocu_write_date().equals("")){%>��ǥ���� : <%=pay.getAutodocu_write_date()%>, ��ǥ���� : <%=pay.getAutodocu_data_gubun()%>, ��ǥ��ȣ : <a href="javascript:view_autodocu('<%=pay.getReqseq()%>');"><%=pay.getAutodocu_data_no()%></a>, pay_code : <%=pay.getPay_code()%> <%}%>
			</td>
          </tr>		  			  
		</table>
	  </td>
	</tr> 	
	<tr>
	  <td>�� ����� : <%=reger_bean.getUser_nm()%>, ����� : <%=pay.getReg_dt()%></td>
	</tr>  				
	<tr>
	  <td>�� ������ ��ĵ����� ���ÿ� ���� �ʽ��ϴ�. ������ �����ϰ� ��ĵ������ּ���.&nbsp;</td>
	</tr>  		
	<%	int pay_chk_cnt  =  pm_db.getPayRegChk2(pay);
		if(pay_chk_cnt>1 && pay.getReg_st().equals("D") && item.getP_st2().equals("���������")){%> 			
	<tr>
	  <td><font color=red>�� �ŷ�����, ����ó��, �ݾ��� ������ ���� �̹� ���ϵǾ� �ֽ��ϴ�. Ȯ���Ͻʽÿ�.</font></td>
	</tr> 		
	<%	}%>			
    <tr>
	    <td align='right'>
		<%if(pay.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id)){%>		
		<!--[��ȸ���]�����ޱ���ǥ����-->		
		<%	if(pay.getReg_st().equals("S") && !pay.getR_acct_code().equals("25300")){%>
		<%			if(item.getP_gubun().equals("11")||item.getP_gubun().equals("12")||item.getP_gubun().equals("13")||item.getP_gubun().equals("15")||item.getP_gubun().equals("16")||item.getP_gubun().equals("18")||item.getP_gubun().equals("19")){%>
		&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:doc_reg_search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_jpbh_mgg.gif border=0 align=absmiddle></a>
		<%			}%>
		<%	}%>
		<!--����-->
		&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:pay_delete();"><img src=/acar/images/center/button_delete.gif align=absmiddle border=0></a>
		<%}%>				
	    </td>
	</tr>	
	
	<tr>
	  <td><hr></td>
	</tr>  			
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���θ���Ʈ</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="10%" class=title>����</td>
            <td width="10%" class=title>�������</td>
            <td width="10%" class=title>�ݾ�</td>						
            <td width="10%" class=title>����</td>			
            <td width="10%" class=title>��������</td>			
            <td width="50%" class=title>����</td>									
          </tr>          
          <%	
          	String p_gubun_nm = ""; 
          	total_amt1 	= AddUtil.parseLong(String.valueOf(pay.getAmt()));
		 	for(int i = 0 ; i < vt_size ; i++){
				PayMngBean pm = (PayMngBean)vt.elementAt(i);
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(pm.getI_amt()));
				p_gubun_nm = pm.getP_st2()+pm.getP_st4();
				double cha_amt = 0;
				if(p_gubun_nm.equals("��������vat")){
					cha_amt 	= AddUtil.parseDouble(String.valueOf(pm.getSub_amt2())) - ( AddUtil.parseDouble(String.valueOf(pm.getSub_amt1()))*0.1 );
				}
		  %>			  
          <tr>
            <td align="center"><%=i+1%><input type="hidden" name="i_seq" 	value="<%=pm.getI_seq()%>">  </td>
            <td align="center"><%=pm.getBuy_user_nm()%></td>			
            <td align="right"><a href="javascript:update_page('<%=pm.getI_seq()%>');"><%=AddUtil.parseDecimalLong(pm.getI_amt())%>��</a>
            <font color=red>
            <br>
            <%=AddUtil.parseDecimalLong(pm.getSub_amt1())%>��
            <br>
            <%=AddUtil.parseDecimalLong(pm.getSub_amt2())%>��            
            </font>
            <%if(cha_amt>100){ %>
            <br>
            <font color=orange><b>(�ݾ�Ȯ��:<%=cha_amt%>��)</b></font>
            <%} %>
            </td>
            <td align="center"><%=pm.getP_st2()%></td>	
            <td align="center"><%=pm.getAcct_code()%></td>			
            <td>&nbsp;<textarea name="p_cont" cols="90" rows="2" class="text"><%=pm.getP_cont()%></textarea>
              <%if(ck_acar_id.equals("000029")) {%>
			  <br>|| p_cd1:<%=pm.getP_cd1()%> || p_cd2:<%=pm.getP_cd2()%> || p_cd3:<%=pm.getP_cd3()%> || p_cd4:<%=pm.getP_cd4()%> || p_cd5:<%=pm.getP_cd5()%> ||p_cd6:<%=pm.getP_cd6()%> ||
			  <br>|| p_st1:<%=pm.getP_st1()%> || p_st2:<%=pm.getP_st2()%> || p_st3:<%=pm.getP_st3()%> || p_st4:<%=pm.getP_st4()%> || p_st5:<%=pm.getP_st5()%> ||
			  <%} %>
			</td>												
          </tr>
	      <%}%>		
		  <tr>
		    <td class='title' colspan="2">�հ�</td>
		    <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt2)%>��</td>		
		    <td class='title' colspan="3">&nbsp;
			<%if(total_amt1 >total_amt2){%>
			<font color=red>�̵�Ϻ��� <%=AddUtil.parseDecimalLong(total_amt1-total_amt2)%>���� �ֽ��ϴ�.</font>
			<%}%>
			</td>			
		  </tr>	  
		</table>
	  </td>
	</tr> 					
	<tr>
	  <td>&nbsp;</td>
	</tr>  
	<%if(!mode.equals("view")){%>
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>				
    <tr>
	    <td align='right'>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	    <%}%>
	<%}else{%>	
    <tr>
	    <td align='right'>
	    <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<%}%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>	
  </table>
</form>
<script language='javascript'>
<!--
//	Keyvalue();
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

