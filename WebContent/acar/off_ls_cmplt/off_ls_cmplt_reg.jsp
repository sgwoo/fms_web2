<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*, acar.client.*, acar.car_register.*, acar.car_scrap.*,acar.offls_actn.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String actn_id = request.getParameter("actn_id")==null?"":request.getParameter("actn_id");
	String actn_dt = request.getParameter("actn_dt")==null?"":request.getParameter("actn_dt");
			
	String enp_no1 = "";
	String enp_no2 = "";
	String enp_no3 = "";
	
	sBean = olsD.getSui(car_mng_id);
	if(!sBean.getEnp_no().equals("")){
		enp_no1 = sBean.getEnp_no().substring(0,3);
		enp_no2 = sBean.getEnp_no().substring(3,5);
		enp_no3 = sBean.getEnp_no().substring(5,10);
	}
	
	Hashtable ht = olcD.getInsInfo(car_mng_id);
	LoginBean login = LoginBean.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//���޹޴���
	ClientBean client = al_db.getClient(sBean.getClient_id());
	
	//��������
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	if(sBean.getMm_pr() == 0){
		String seq = olaD.getAuction_maxSeq(car_mng_id);
		auction = olaD.getAuction(car_mng_id, seq);
		sBean.setMm_pr(auction.getNak_pr());
	}
	
	//�ڻ�ó�� �Ϸ�
	String deprf_yn = "";
	deprf_yn = olsD.getAssetYn(car_mng_id);
	
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

		//����û����������ȸ
	function search_nts(){
		var fm = document.form1;
	//	fm.nts_yn.value='Y';
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}	
	
	
	function save(ioru)
	{
		var fm = document.form1;	
		if(!this.CheckField()) return;
		
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.email.value = fm.email_1.value+'@'+fm.email_2.value;
		}
		
		if(ioru=="i"){			
			if(!confirm('��� �Ͻðڽ��ϱ�?')){ return; }
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.gubun.value = ioru;
			fm.action="/acar/off_ls_cmplt/off_ls_cmplt_reg_ui.jsp";
			fm.target = "i_no";	
			fm.submit();
			
			link.getAttribute('href',originFunc);
						
		}else if(ioru=="u"){
			if(!confirm('���� �Ͻðڽ��ϱ�?')){ return; }
			
			fm.gubun.value = ioru;
			fm.action="/acar/off_ls_cmplt/off_ls_cmplt_reg_ui.jsp";
			fm.target = "i_no";	
			fm.submit();			
			
		}else if(ioru=="p"){
			if(!this.pCheck()) return;
			if(!confirm('�Ű�ó�� �Ͻðڽ��ϱ�?')){ return; }
			
			fm.gubun.value = ioru;
			fm.action="/acar/off_ls_cmplt/off_ls_cmplt_reg_ui.jsp";
			fm.target = "i_no";	
			fm.submit();			
		}

	}

	function CheckField()
	{
		var fm = document.form1;
		if(fm.sui_nm.value == ''){
			alert('������ �Է��Ͻʽÿ�');
			return false;
		}
		return true;
	}


	function set_o_addr()
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.h_zip.value = fm.d_zip.value;
			fm.h_addr.value = fm.d_addr.value;
		}
		else
		{
			fm.h_zip.value = '';
			fm.h_addr.value = '';
		}
	}
	
	function set_up_addr(){
		var fm = document.form1;
		if(fm.c_up.checked == true){
			fm.car_nm.value = fm.sui_nm.value;
			fm.car_relation.value = '����';
			fm.car_ssn1.value = fm.ssn1.value;
			fm.car_ssn2.value = fm.ssn2.value;
			fm.car_h_tel.value = fm.h_tel.value;
			fm.car_m_tel.value = fm.m_tel.value;
			fm.car_zip.value = fm.d_zip.value;
			fm.car_addr.value = fm.d_addr.value;
		}else{
			fm.car_nm.value = '';
			fm.car_relation.value = '';
			fm.car_ssn1.value = '';
			fm.car_ssn2.value = '';
			fm.car_h_tel.value = '';
			fm.car_m_tel.value = '';
			fm.car_zip.value = '';
			fm.car_addr.value = '';
		}
	}
	
	function view_file(idx)	
	{
		if(idx == '1'){ 	
			var map_path = document.form1.s_suifile.value;
		}else if(idx == '2'){	 			
			var map_path = document.form1.s_lpgfile.value;
		}
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/sui/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}
	function drop_file(idx){
		if(idx=='s'){
			document.form1.s_suifile_del.value = '1';
		}else if(idx=='l'){
			document.form1.s_lpgfile_del.value = '1';
		}
	}
	function getJan_pr(){
		document.form1.jan_pr.value = 
		parseDecimal(parseDigit(document.form1.mm_pr.value) - parseDigit(document.form1.cont_pr.value));
		return parseDecimal(document.form1.cont_pr.value);
	}
	function pCheck(){
		var fm = document.form1;
		if(fm.migr_dt.value == ''){
			alert('������������ �Է��Ͻʽÿ�');
			return false;
		}else if(fm.migr_no.value == ''){
			alert('���������Ĺ�ȣ�� �Է��Ͻʽÿ�');
			return false;
		}
		return true;
	}
	
	//���/����: �� ��ȸ
	function select_client()
	{
		var fm = document.form1;
		var h_wd = "";
		if(fm.firm_nm.value == '') 	h_wd = fm.sui_nm.value;		
		else 						h_wd = fm.firm_nm.value;	

		fm.sui_nm.value = '';
		fm.ssn1.value = '';
		fm.ssn2.value = '';
		fm.enp_no1.value = '';
		fm.enp_no2.value = '';
		fm.enp_no3.value = '';
		fm.d_zip.value = '';
		fm.d_addr.value = '';
		fm.relation.value = '';

		window.open("/acar/off_ls_cmplt/client_s_p.jsp?go_url=/acar/off_ls_cmplt/off_ls_cmplt_reg.jsp&h_wd="+h_wd, "CLIENT", "left=100, top=100, width=650, height=500, status=yes");
	}		
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		window.open("/acar/mng_client2/client_enp.jsp?client_id="+fm.client_id.value, "VIEW_CLIENT", "left=100, top=100, width=630, height=500");
	}		
function EnterDown(){
	var keyValue = event.keyCode;
	<%if(!sBean.getClient_id().equals("")){%>
	if (keyValue =='13') view_client();
	<%}else{%>
	if (keyValue =='13') select_client();	
	<%}%>	
}


//����ڵ�Ϲ�ȣ üũ
function CheckBizNo() {
	
	var fm = document.form1;

//    alert(document.getElementById("enp_no1").value);
    
    var strNumb1 = document.getElementById("enp_no1").value;
    var strNumb2 = document.getElementById("enp_no2").value;
    var strNumb3 = document.getElementById("enp_no3").value;
    var strNumb = strNumb1+strNumb2+strNumb3;

    if (strNumb.length != 10) {
        alert("����ڵ�Ϲ�ȣ�� �߸��Ǿ����ϴ�.");
        return ;
    }
    
        sumMod  =   0;
        sumMod  +=  parseInt(strNumb.substring(0,1));
        sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
        sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
        sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
        sumMod  +=  parseInt(strNumb.substring(9,10));
    
    if (sumMod % 10  !=  0) {
        alert("�߸��� ����� ��Ϲ�ȣ �Դϴ�.");
        return ;
    }
        alert("�ùٸ� ����� ��Ϲ�ȣ �Դϴ�.");
    	return ;
}

//�ֹε�Ϲ�ȣ üũ

 var errfound = false;

function jumin_No(){
        if(!JuminCheck(document.getElementById("ssn1").value,document.getElementById("ssn2").value)){
                alert("�߸��� �ֹε�Ϲ�ȣ�Դϴ�.");
        } else  {
        		alert("�ùٸ� �ֹε�Ϲ�ȣ�Դϴ�.");
		}
}

function jumin_No2(){
        if(!JuminCheck(document.getElementById("car_ssn1").value,document.getElementById("car_ssn2").value)){
                alert("�߸��� �ֹε�Ϲ�ȣ�Դϴ�.");
        } else  {
        		alert("�ùٸ� �ֹε�Ϲ�ȣ�Դϴ�.");
		}
}

function JuminCheck(jumin1, jumin2){
        check = false;
        total =0;
        temp = new Array(13);
        for(i=1; i<=6; i++)temp[i] = jumin1.charAt(i-1);
        for(i=7; i<=13; i++) temp[i] =jumin2.charAt(i-7);
        for(i=1; i<=12;i++){
                k = i + 1;
                if(k >= 10) k = k% 10 + 2;
                total = total + temp[i] *k;
        }
        mm = temp[3] + temp[4];
        dd =temp[5] + temp[6];
        totalmod = total % 11;
        chd = 11 -totalmod;
        if(chd == temp[13] && mm < 13 && dd< 32 && (temp[7]==1 ||temp[7]==2))
                check=true;
        return check;
}

function Biz_ck(){

	var fm = document.form1;

	var strBiz1 = fm.ssn1.value;
	var strBiz2 = fm.ssn2.value;
    var str_len ;
    var str_no = strBiz1+strBiz2;

    str_len = str_no.length;

    if (str_len == 13 ){
			
        no_ck = str_no.substring(0, 1) * 1;
        no_ck = no_ck + str_no.substring( 1, 2) * 2;
        no_ck = no_ck + str_no.substring( 2, 3) * 1;
        no_ck = no_ck + str_no.substring( 3, 4) * 2;
        no_ck = no_ck + str_no.substring( 4, 5) * 1;
        no_ck = no_ck + str_no.substring( 5, 6) * 2;
        no_ck = no_ck + str_no.substring( 6, 7) * 1;
        no_ck = no_ck + str_no.substring( 7, 8) * 2;
        no_ck = no_ck + str_no.substring( 8, 9) * 1;
        no_ck = no_ck + str_no.substring( 9, 10) * 2;
        no_ck = no_ck + str_no.substring( 10, 11) * 1;
        no_list = no_ck + str_no.substring( 11, 12) * 2;
        no_ck_no = no_list / 10;
        ck_no = "'"+no_ck_no+"'";
        namuji = ck_no.substring(3,4);
        no = 10 - namuji; 
        if (no > 9 ){
            no = 0;
        }
        if (no == str_no.substring(12, 13)){
            alert ("�ùٸ� ���ι�ȣ�Դϴ�.");
        }else{
            alert ("�߸��� ���ι�ȣ�Դϴ�.");
        }
        
    }

}

function Biz_ck2(){

	var fm = document.form1;

	var strBiz1 = fm.car_ssn1.value;
	var strBiz2 = fm.car_ssn2.value;
    var str_len ;
    var str_no = strBiz1+strBiz2;

    str_len = str_no.length;

    if (str_len == 13 ){
			
        no_ck = str_no.substring(0, 1) * 1;
        no_ck = no_ck + str_no.substring( 1, 2) * 2;
        no_ck = no_ck + str_no.substring( 2, 3) * 1;
        no_ck = no_ck + str_no.substring( 3, 4) * 2;
        no_ck = no_ck + str_no.substring( 4, 5) * 1;
        no_ck = no_ck + str_no.substring( 5, 6) * 2;
        no_ck = no_ck + str_no.substring( 6, 7) * 1;
        no_ck = no_ck + str_no.substring( 7, 8) * 2;
        no_ck = no_ck + str_no.substring( 8, 9) * 1;
        no_ck = no_ck + str_no.substring( 9, 10) * 2;
        no_ck = no_ck + str_no.substring( 10, 11) * 1;
        no_list = no_ck + str_no.substring( 11, 12) * 2;
        no_ck_no = no_list / 10;
        ck_no = "'"+no_ck_no+"'";
        namuji = ck_no.substring(3,4);
        no = 10 - namuji; 
        if (no > 9 ){
            no = 0;
        }
        if (no == str_no.substring(12, 13)){
            alert ("�ùٸ� ���ι�ȣ�Դϴ�.");
        }else{
            alert ("�߸��� ���ι�ȣ�Դϴ�.");
        }
        
    }

}

function SuiCancel(){
	   var fm = document.form1;
	 //��꼭 ����� �� ��� Ȯ�� �� ó�� 
		if(!confirm('������� �Ͻðڽ��ϱ�?')){	return;	}
		
		fm.action = "sui_cancel_a.jsp";
		fm.target = "i_no";	
		fm.submit();			
}

//-->
</script>
</head>
<body>
<form name="form1" action=""  method="post">

<!--<form name="form1" action="" enctype='multipart/form-data' method="post"> -->
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type='hidden' name='s_suifile' value='<%=sBean.getSuifile()%>'>
<input type='hidden' name='s_lpgfile' value='<%=sBean.getLpgfile()%>'>
<input type='hidden' name='s_suifile_del' value=''>
<input type='hidden' name='s_lpgfile_del' value=''>
<input type="hidden" name="gubun" value="">
<input type="hidden" name="client_id" value="<%=sBean.getClient_id()%>">
<input type="hidden" name="actn_dt" value="<%=actn_dt%>">
<input type="hidden" name="actn_id" value="<%=actn_id%>">
<%-- <%=car_mng_id %> --%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>

    <tr> 
        <td width="526"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� ����</span>&nbsp;&nbsp;&nbsp;<font color="#999999"> <img src=/acar/images/center/arrow_cjsjj.gif align=absmiddle> : 
        <%if(login.getAcarName(sBean.getModify_id()).equals("error")){%>
        &nbsp; 
        <%}else{%>
        <%=login.getAcarName(sBean.getModify_id())%> 
        <%}%>
        </font></td>
        <td align="right"> 
        <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
      	<%	if(olsD.getCar_mng_id(car_mng_id).equals("")){%>
		<a id="submitLink" href='javascript:save("i");' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <%	}else{%> 
		<a href='javascript:save("u");' onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
		&nbsp;
		<a href='javascript:save("p");' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_mgak.gif align=absmiddle border=0></a>
			
        <%	}%> 
        <%}%>
        <!-- �ڻ꿡�� �Ű�ó������ ��츸  -->
        <%  if ( ck_acar_id.equals("000063")  &&  ( deprf_yn.equals("2") ||  deprf_yn.equals("4")  ) ) {%>
		&nbsp;<a href="javascript:SuiCancel()" onMouseOver="window.status=''; return true">[�������]</a>&nbsp;
		<% } %> 
						
		</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'> ���޹޴���</td>
                    <td colspan="5">&nbsp; <input type='text' name='firm_nm' value="<%=client.getFirm_nm()%>" size='30' maxlength='40' class='text' onKeydown="javasript:EnterDown()">
        			<a href="javascript:select_client()"><img src=../images/center/button_in_search.gif border=0 align=absmiddle></a>
        			<%if(!sBean.getClient_id().equals("")){%>&nbsp;<a href="javascript:view_client()"><img src=../images/center/button_in_see.gif border=0 align=absmiddle></a><%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title' width='15%'> ����(��Ī)</td>
                    <td width='22%'>&nbsp; <input type='text' name='sui_nm' value="<%=sBean.getSui_nm()%>" size='30' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>����</td>
                    <td width='18%' align='left'>&nbsp; <input type='text' name='relation' value="<%=sBean.getRelation()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>�������</td>
                    <td width="15%">&nbsp; <input type='text' size='13' name='cont_dt' value="<%if(sBean.getCont_dt().equals("")) {%><%=AddUtil.ChangeDate2(actn_dt)%><%} else {%><%=AddUtil.ChangeDate2(sBean.getCont_dt())%><%}%>" maxlength='40' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�ֹε�Ϲ�ȣ<br/> </td>
                    <td>&nbsp; 
                    <%if(!client.getClient_st().equals("1")){%>
                    	<input type='text' size='6' name='ssn1' maxlength='6' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(0,6));%>" >
                      	- 
                      	<input type='text' name='ssn2' maxlength='7' size='7' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(6));%>" > <!-- onBlur="javascript:jumin_No();"-->
                    <%}else{%>
	                   	<input type='text' size='6' name='ssn1' maxlength='6' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(0,6));%>" >
                      	- 
                      	<input type='text' name='ssn2' maxlength='7' size='7' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(6));%>" onBlur="javascript:Biz_ck();"> 
               		<%}%>
                    </td>
                    <td class='title'>����ڹ�ȣ</td>
                    <td colspan="3">&nbsp;
                      <input type='text' name='enp_no1' value='<%= enp_no1 %>' size='3' class='text' maxlength='3'>
                      - 
                      <input type='text' name='enp_no2' value='<%= enp_no2 %>' size='2' class='text' maxlength='2'>
                      - 
                      <input type='text' name='enp_no3' value='<%= enp_no3 %>' size='5' class='text' maxlength='5' onBlur="javascript:CheckBizNo();">  
                      
                              &nbsp;&nbsp;<a href="javascript:search_nts();"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
                              
                    </td>
                </tr>
                <tr>
                    <td class='title'>��ȭ��ȣ</td>
                    <td>&nbsp; <input type='text' size='15' name='h_tel' maxlength='15' class='text' value="<%=sBean.getH_tel()%>" ></td>
                    <td class='title'>�޴�����ȣ</td>
                    <td colspan="3">&nbsp; <input type='text' size='15' name='m_tel' maxlength='15' class='text' value="<%=sBean.getM_tel()%>" ></td>
                </tr>
				<%	String email_1 = "";
					String email_2 = "";
					if(!sBean.getEmail().equals("")){
						int mail_len = sBean.getEmail().indexOf("@");
						if(mail_len > 0){
							email_1 = sBean.getEmail().substring(0,mail_len);
							email_2 = sBean.getEmail().substring(mail_len+1);
						}
					}
				%>		
                <tr> 
                    <td class='title'>E-mail</td>
                    <td colspan='5'> &nbsp;
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
						<option value="" selected>�����ϼ���</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
						</select>
					  <input type='hidden' name='email' value='<%=sBean.getEmail()%>'>
					  <!--<input type='text' name='email' value="<%=sBean.getEmail()%>" size='20' maxlength='40' class='text'>-->
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('d_zip').value = data.zonecode;
								document.getElementById('d_addr').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>		
		
				<tr>
				  <td class=title>����ּ�</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="d_zip" id="d_zip" size="7" maxlength='7' value="<%=sBean.getD_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="d_addr" id="d_addr" size="90" value="<%=sBean.getD_addr()%>">
				  </td>
				</tr>

				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('h_zip').value = data.zonecode;
								document.getElementById('h_addr').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>�����ּ�</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="h_zip" id="h_zip" size="7" maxlength='7' value="<%=sBean.getH_zip()%>">
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="h_addr" id="h_addr" size="90" value="<%=sBean.getH_addr()%>">
					<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
                      ��
				  </td>
				</tr>

                <tr> 
                    <td class='title' rowspan="2">�ŸŴ��</td>
                    <td rowspan="2"> &nbsp; <input type='text' size='10' name='mm_pr' value="<%=AddUtil.parseDecimal(sBean.getMm_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
                    </td>
                    <td class='title'>����</td>
                    <td> &nbsp; <input type='text' size='10' name='cont_pr' value="<%=AddUtil.parseDecimal(sBean.getCont_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=getJan_pr()'> 
                    </td>
                    <td class='title'>�Ա���</td>
                    <td> &nbsp; <input type='text' size='12' name='cont_pr_dt' value="<%=AddUtil.ChangeDate2(sBean.getCont_pr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'> �ܱ�</td>
                    <td> &nbsp; <input type='text' size='10' name='jan_pr' value="<%=AddUtil.parseDecimal(sBean.getJan_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
                    </td>
                    <td class='title'> �Ա���</td>
                    <td> &nbsp; <input type='text' size='12' name='jan_pr_dt' value="<%=AddUtil.ChangeDate2(sBean.getJan_pr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                </tr>
				<!--
                <tr> 
                    <td class='title'>�絵������ĵ</td>
                    <td colspan="5" class='left'>&nbsp; <input type="file" name="filename" value='S' size="25"> 
                      &nbsp; <%if(!sBean.getSuifile().equals("")){%> <input type="button" name="b_map1" value="����" onClick="javascript:view_file(1);"> 
                      &nbsp;&nbsp; <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))%> <input type="button" name="b_map3" value="����" onClick="javascript:drop_file('s');"> 
                      <%}%> </td>
                </tr>
                <tr> 
                    <td class='title'>LPG������ĵ</td>
                    <td colspan="5" class='left'>&nbsp; <input type="file" name="filename3" value='S' size="25"> 
                      &nbsp; <%if(!sBean.getLpgfile().equals("")){%> <input type="button" name="b_map2" value="����" onClick="javascript:view_file('2');"> 
                      &nbsp;&nbsp; <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))%> <input type="button" name="b_map4" value="����" onClick="javascript:drop_file('l');"> 
                      <%}%> </td>
                </tr>
				-->
                <tr> 
                    <td class='title'>����KM</td>
                    <td class='left'>&nbsp; <input class="num" type="text" name="ass_st_km" size="10" value="<%=AddUtil.parseDecimal(sBean.getAss_st_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ~ 
                      <input class="num" type="text" name="ass_ed_km" size="10" value="<%=AddUtil.parseDecimal(sBean.getAss_ed_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'> 
                    </td>
                    <td class='title'>�����Ⱓ</td>
                    <td class='left'>&nbsp; <input class="text" type="text" name="ass_st_dt" size="12" value="<%=AddUtil.ChangeDate2(sBean.getAss_st_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input class="text" type="text" name="ass_ed_dt" size="12" value="<%=AddUtil.ChangeDate2(sBean.getAss_ed_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                    <td class='title'>�������ۼ���</td>
                    <td class='left'>&nbsp; <input class="text" type='text' name='ass_wrt'    size='20' maxlength='20' value="<%=sBean.getAss_wrt()%>" > 
                    </td>
                </tr>
                <tr> 
                    <td class='title'> ��Ÿ���� </td>
                    <td colspan='5'>&nbsp; <textarea name='etc' rows='2' cols='120' maxlength='500'><%=sBean.getEtc()%></textarea> 
                    </td>
                </tr>
                <tr>
                    <td class='title'>����������</td>
                    <td>&nbsp; <input type='text' size='12' name='migr_dt' value="<%=AddUtil.ChangeDate2(sBean.getMigr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>���������Ĺ�ȣ</td>
                    <td colspan="3">&nbsp; <input type='text' size='20' name='migr_no' value="<%=sBean.getMigr_no()%>" maxlength='20' class='text'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������� ����</span> <input type='checkbox' name='c_up' onClick='javascript:set_up_addr()'>��</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'> ����</td>
                    <td width="22%">&nbsp; <input type='text' name='car_nm' value="<%=sBean.getCar_nm()%>" size='30' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>���� </td>
                    <td width='18%'>&nbsp; <input type='text' name='car_relation' value="<%=sBean.getCar_relation()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>&nbsp;</td>
                    <td width='15%'>&nbsp; </td>					
                </tr>
                <tr> 
                    <td class='title'>�ֹε�Ϲ�ȣ</td>
                    <td>&nbsp; 
                	<%if(!client.getClient_st().equals("1")){%>
	                    <input type='text' size='6' name='car_ssn1' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(0,6));%>" maxlength='6' class='text'>
	                      - 
	                    <input type='text' name='car_ssn2' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(6));%>" maxlength='7' size='7' class='text' onBlur="javascript:jumin_No2();"> 
                    <%}else{%>
	                    <input type='text' size='6' name='car_ssn1' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(0,6));%>" maxlength='6' class='text'>
	                      - 
	                    <input type='text' name='car_ssn2' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(6));%>" maxlength='7' size='7' class='text' onBlur="javascript:Biz_ck2();"> 
                   	<%}%>
                      &nbsp; </td>
                    <td class='title'>��ȭ��ȣ</td>
                    <td> &nbsp; <input type='text' size='15' value="<%=sBean.getCar_h_tel()%>" name='car_h_tel' maxlength='15' class='text'> 
                    </td>
                    <td class='title'>�ڵ�����ȣ</td>
                    <td> &nbsp; <input type='text' size='15' value="<%=sBean.getCar_m_tel()%>" name='car_m_tel' maxlength='15' class='text'> 
                    </td>
                </tr>
				<script>
					function openDaumPostcode2() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('car_zip').value = data.zonecode;
								document.getElementById('car_addr').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>�ּ�</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="car_zip" id="car_zip" size="7" maxlength='7' value="<%=sBean.getCar_zip()%>">
					<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name="car_addr" id="car_addr" size="90" value="<%=sBean.getCar_addr()%>">
				  </td>
				</tr>

            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'> �����</td>
                    <td width="22%">&nbsp; <input type='text' name='ins_nm' value='<%=ht.get("INS_COM_NM")%>' size='30' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>û������ </td>
                    <td width='18%'>&nbsp; <input type='text' name='ins_yes' value="<% if(ht.get("REQ_DT").equals("")) out.print("��û��"); else out.print("û��"); %>" size='20' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>���ǹ�ȣ</td>
                    <td width='15%'>&nbsp;<input type='text' name='ins_no' value="<%=ht.get("INS_CON_NO")%>" size='20' maxlength='40' class='text' style='IME-MODE: active'>  </td>					
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <%if(!olsD.getCar_mng_id(car_mng_id).equals("") && ( auth_rw.equals("4")||auth_rw.equals("6") ) ){%>
    <tr> 
        <td colspan="2"><iframe src="./off_ls_cmplt_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&actn_dt=<%=actn_dt%>" name="sugum" width="100%" height="370" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>