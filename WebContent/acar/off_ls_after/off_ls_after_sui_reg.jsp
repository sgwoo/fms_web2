<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_sui.*, acar.client.*, acar.credit.* , acar.car_register.*, acar.car_scrap.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String enp_no1 = "";
	String enp_no2 = "";
	String enp_no3 = "";
  String des_zip = "";
  String des_addr = "";
  String des_nm = "";
  String des_tel = "";
  
	//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(car_mng_id);
  
  	
	//매입옵션 해지 서류배송정보
	Hashtable sui =olsD.getDesAddr(car_mng_id);
	Hashtable ht = olcD.getInsInfo(car_mng_id);
	sBean = olsD.getSui(car_mng_id);
		 		    
	if(!sBean.getEnp_no().equals("")){
		enp_no1 = sBean.getEnp_no().substring(0,3);
		enp_no2 = sBean.getEnp_no().substring(3,5);
		enp_no3 = sBean.getEnp_no().substring(5,10);
	}
		
	if(!sBean.getDes_zip().equals("")){
		des_zip = sBean.getDes_zip();
		des_addr = sBean.getDes_addr();
		des_nm = sBean.getDes_nm();
		des_tel = sBean.getDes_tel();
	} else {	
		if ( sui.get("DES_ZIP")  == null  ) 	{
			des_zip  = "";
			des_addr = "";
			des_nm = "";
			des_tel = "";
	   } else { 
			des_zip =String.valueOf(sui.get("DES_ZIP"));
			des_addr = String.valueOf(sui.get("DES_ADDR"));
			des_nm = String.valueOf(sui.get("DES_NM"));
			des_tel = String.valueOf(sui.get("DES_TEL"));
		}	
	}
	
	if(sBean.getMm_pr()==0){
		sBean.setMm_pr(cls.getOpt_amt());
	}
	
	LoginBean login = LoginBean.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//공급받는자
	ClientBean client = al_db.getClient(sBean.getClient_id());
	
	//차량정보
	cr_bean = crd.getCarRegBean(car_mng_id);
	
              	    
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

		//국세청과세유형조회
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
			if(!confirm('등록 하시겠습니까?')){ return; }
		}else if(ioru=="u"){
			if(!confirm('수정 하시겠습니까?')){ return; }
		}else if(ioru=="p"){
			if(!confirm('매각처리 하시겠습니까?')){ return; }			
		}else if(ioru=="h"){
			if(!confirm('서류전달 문자를 보내시겠습니까?')){ return; }				
		}
		fm.gubun.value = ioru;
		fm.action="/acar/off_ls_after/off_ls_after_sui_reg_ui.jsp";
		fm.target = "i_no";	
		fm.submit();
	}

	function CheckField()
	{
		var fm = document.form1;
		
		if(fm.sui_nm.value == ''){
			alert('성명을 입력하십시오');
			return false;
		}else if( fm.ssn1.value=='' || (!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || 
			((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) ||
			((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{
			alert('주민등록번호를 확인하십시오');
			return false;
		} else if( fm.des_zip.value=='' || fm.des_addr.value == '' || fm.des_nm.value == '' ) { 
			alert('서류배송주소,  수취인, 수취인연락처를 확인하십시오');
			return false;
		}
		
		return true;
	}

	function search_zip(str)
	{
		window.open("/acar/off_ls_sui/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
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
	
	function set_o_addr2()
	{
		var fm = document.form1;
		if(fm.des_ho.checked == true)
		{
			fm.des_zip.value = fm.d_zip.value;
			fm.des_addr.value = fm.d_addr.value;
			fm.des_nm.value = fm.sui_nm.value;
			fm.des_tel.value = fm.sui_tel.value;
		}
		else
		{
			fm.des_zip.value = '';
			fm.des_addr.value = '';
			fm.des_nm.value = '';
		}

	}
	
	function set_des_addr()
	{
		var fm = document.form1;
		if(fm.des_ho.checked == true)
		{
			fm.des_zip.value = fm.d_zip.value;
			fm.des_addr.value = fm.d_addr.value;
		}
		else
		{
			fm.des_zip.value = '';
			fm.des_addr.value = '';
		}
	}
	
	
	function set_up_addr(){
		var fm = document.form1;
		if(fm.c_up.checked == true){
			fm.car_nm.value = fm.sui_nm.value;
			fm.car_relation.value = '본인';
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
	
	//등록/수정: 고객 조회
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
	//고객 보기
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
	
	
//사업자등록번호 체크
function CheckBizNo() {
	
	var fm = document.form1;

//    alert(document.getElementById("enp_no1").value);
    
    var strNumb1 = document.getElementById("enp_no1").value;
    var strNumb2 = document.getElementById("enp_no2").value;
    var strNumb3 = document.getElementById("enp_no3").value;
    var strNumb = strNumb1+strNumb2+strNumb3;

    if (strNumb.length != 10) {
        alert("사업자등록번호가 잘못되었습니다.");
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
        alert("잘못된 사업자 등록번호 입니다.");
        return ;
    }
        alert("올바른 사업자 등록번호 입니다.");
    	return ;
}

//주민등록번호 체크

 var errfound = false;

function jumin_No(){
        if(!JuminCheck(document.getElementById("ssn1").value,document.getElementById("ssn2").value)){
                alert("잘못된 주민등록번호입니다.");
        } else  {
        		alert("올바른 주민등록번호입니다.");
		}
}

function jumin_No2(){
        if(!JuminCheck(document.getElementById("car_ssn1").value,document.getElementById("car_ssn2").value)){
                alert("잘못된 주민등록번호입니다.");
        } else  {
        		alert("올바른 주민등록번호입니다.");
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
            alert ("올바른 법인번호입니다.");
        }else{
            alert ("잘못된 법인번호입니다.");
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
            alert ("올바른 법인번호입니다.");
        }else{
            alert ("잘못된 법인번호입니다.");
        }
        
    }

}

function account_jangaamt(){
	var fm = document.form1;
	var fm2 = document.sh_form;	
	
	if(fm.jan_pr_dt.value == ''){	alert('입금일을 입력하십시오.'); return;}				
	
	fm2.rent_st.value 	= '1'; //재리스
	fm2.a_b.value 		= '1'; //1개월
	fm2.rent_dt.value 	= fm.jan_pr_dt.value; //입금일 기준
	fm2.mode.value 		= 'asset1';
	fm2.action='/acar/secondhand/getSecondhandJanga.jsp';
	fm2.target='i_no';
	fm2.submit();	
}

//-->
</script>
</head>
<body>
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="car_mng_id"		value="<%=car_mng_id%>">  
  <input type='hidden' name="mode"				value="">    
  <input type='hidden' name="rent_dt"			value="">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="a_b"				value="">     
  <input type='hidden' name="fee_opt_amt"		value="">
  <input type='hidden' name="cust_sh_car_amt"	value="">   
  <input type='hidden' name="sh_amt"			value="">     
  <input type='hidden' name="cls_n_mon"			value="">     
  <input type='hidden' name="today_dist"		value="">         
</form>

<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type='hidden' name='s_suifile' value='<%=sBean.getSuifile()%>'>
<input type='hidden' name='s_lpgfile' value='<%=sBean.getLpgfile()%>'>
<input type='hidden' name='s_suifile_del' value=''>
<input type='hidden' name='s_lpgfile_del' value=''>
<input type="hidden" name="gubun" value="">
<input type="hidden" name="client_id" value="<%=sBean.getClient_id()%>">

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td width="526"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약자 정보</span></font>&nbsp;&nbsp;&nbsp;&nbsp;<font color="#999999">♧ 최종수정자 : 
        <%if(login.getAcarName(sBean.getModify_id()).equals("error")){%>
        &nbsp; 
        <%}else{%>
        <%=login.getAcarName(sBean.getModify_id())%> 
        <%}%>
        </font></td>
        
        <td align="right">      
         <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>   
        	<%if(olsD.getCar_mng_id(car_mng_id).equals("")){%>
        		<a href='javascript:save("i");' onMouseOver="window.status=''; return true" title='등록'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        	<%}else{%>
        		<a href='javascript:save("h");' onMouseOver="window.status=''; return true" title='문자보내기'>문자보내기 </a> 
        		<a href='javascript:save("u");' onMouseOver="window.status=''; return true" title='수정'><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
        		<%if(cr_bean.getCar_use().equals("1")){ 
        			if(sc_db.getScrapCheck(cr_bean.getCar_no())==0){%>
			&nbsp;			
			<a href='javascript:save("p");' onMouseOver="window.status=''; return true" title='대폐차처리'><img src=/acar/images/center/button_dpc.gif align=absmiddle border=0></a>		
			<%}}%>
        		<%}%>        
        	<%}%>        
        </td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'> 공급받는자</td>
                    <td colspan="8">&nbsp; <input type='text' name='firm_nm' value="<%=client.getFirm_nm()%>" size='30' maxlength='40' class='text' onKeydown="javasript:EnterDown()">
        			<a href="javascript:select_client()"><img src=../images/center/button_in_search.gif border=0 align=absmiddle></a>
        			<%if(!sBean.getClient_id().equals("")){%>&nbsp;<a href="javascript:view_client()"><img src=../images/center/button_in_see.gif border=0 align=absmiddle></a><%}%>
        			     			
        			</td>
                </tr>
                <tr> 
                    <td class='title' width='12%'> 성명(명칭)</td>
                    <td colspan="2" width='22%'>&nbsp; <input type='text' name='sui_nm' value="<%=sBean.getSui_nm()%>" size='30' maxlength='40' class='text' style='IME-MODE: active'> </td>
                    <td class='title' width='12%'>관계</td>
                    <td width='13%' align='left'>&nbsp; <input type='text' name='relation' value="<%=sBean.getRelation()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'> </td>
                    <td class='title' width='12%'>계약일자</td>
                    <td colspan="3 width="12%">&nbsp; <input type='text' size='13' name='cont_dt' value="<%=AddUtil.ChangeDate2(sBean.getCont_dt())%>" maxlength='40' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr> 
                    <td class='title'>주민등록번호<br/> </td>
                    <td colspan="2">&nbsp;
                    <%if(!client.getClient_st().equals("1")){%>
	                    <input type='text' size='6' name='ssn1' maxlength='6' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(0,6));%>" >
	                      - 
	                    <input type='text' name='ssn2' maxlength='7' size='7' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(6));%>"  OnBlur="javascript:jumin_No();"> 
                    <%}else{%>
	                    <input type='text' size='6' name='ssn1' maxlength='6' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(0,6));%>" >
	                      - 
	                    <input type='text' name='ssn2' maxlength='7' size='7' class='text' value="<%if(!sBean.getSsn().equals("")) out.println(sBean.getSsn().substring(6));%>"  OnBlur="javascript:Biz_ck();"> 
					<%}%>

                    </td>
                    <td class='title'>사업자번호</td>
                    <td colspan="5">&nbsp;
                      <input type='text' name='enp_no1' value='<%= enp_no1 %>' size='3' class='text' maxlength='3'>
                      - 
                      <input type='text' name='enp_no2' value='<%= enp_no2 %>' size='2' class='text' maxlength='2'>
                      - 
                      <input type='text' name='enp_no3' value='<%= enp_no3 %>' size='5' class='text' maxlength='5'  OnBlur="javascript:CheckBizNo();"> 
                     
                     &nbsp;&nbsp;<a href="javascript:search_nts();"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
                     	
                    </td>
                </tr>
                <tr>
                    <td class='title'>전화번호</td>
                    <td colspan="2" >&nbsp; <input type='text' size='15' name='h_tel' maxlength='15' class='text' value="<%=sBean.getH_tel()%>" ></td>
                    <td class='title'>휴대폰번호</td>
                    <td colspan="5">&nbsp; <input type='text' size='15' name='m_tel' maxlength='15' class='text' value="<%=sBean.getM_tel()%>" ></td>
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
                    <td colspan='8'> &nbsp;
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
						<option value="" selected>선택하세요</option>
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
						<option value="">직접 입력</option>
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
								document.getElementById('d_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title width='12%'>등본상주소</td>
				  <td colspan=8>&nbsp;
					<input type="text" name='d_zip'  id="d_zip" size="7" maxlength='7' value="<%=sBean.getD_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text"  name='d_addr'  id="d_addr"  size="75"  maxlength="150"  value="<%=sBean.getD_addr()%>">
				  </td>
				</tr>		
<!--				
                <tr> 
                    <td class='title'>등본상주소</td>
                    <td colspan='5'> &nbsp; <input type='text' name='d_zip' value="<%=sBean.getD_zip()%>" size='7' class='text' readonly onClick="javascript:search_zip('d');"> 
                      <input type='text' name='d_addr' value="<%=sBean.getD_addr()%>" maxlength='60' size='70' class='text' style='IME-MODE: active'></td>
                </tr>
				-->
				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('h_zip').value = data.zonecode;
								document.getElementById('h_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title  width='12%'>실제주소</td>
				  <td colspan=8>&nbsp;
					<input type="text" name='h_zip' id="h_zip" size="7" maxlength='7' value="<%=sBean.getH_zip()%>">
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name='h_addr' id="h_addr"  size="75"  maxlength="150"  value="<%=sBean.getH_addr()%>">
					<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>상동 </td>
				</tr>	
<!--				
                <tr> 
                    <td class='title'>실제주소</td>
                    <td colspan='5'> &nbsp; <input type='text' name='h_zip' value="<%=sBean.getH_zip()%>" size='7' class='text' readonly onClick="javascript:search_zip('h');"> 
                      <input type='text' size='70' name='h_addr' value="<%=sBean.getH_addr()%>" maxlength='60' class='text'> 
                      <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>
                      상동</td>
                </tr>
				-->
				<script>
					function openDaumPostcode2() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('des_zip').value = data.zonecode;
								document.getElementById('des_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title  width='12%'>서류배송주소</td>
				  <td colspan=3>&nbsp;
					<input type="text" name='des_zip' id="des_zip" size="7" maxlength='7' value="<%=des_zip%>">
					<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name='des_addr' id="des_addr" size="75"  maxlength="150"  value="<%=des_addr%>">
					<input type='checkbox' name='des_ho' onClick='javascript:set_o_addr2()'>상동 </td>
				  <td class='title'  width='12%'>수취인</td>
                  <td>&nbsp;<input type='text' size='20' name='des_nm' value="<%=des_nm%>" maxlength='40' class='text'> </td>
				  <td class='title'  width='12%'>연락처</td>
                  <td  colspan=2 >&nbsp;<input type='text' size='20' name='des_tel' value="<%=des_tel%>" maxlength='40' class='text'> </td>
				  </td>
				</tr>
								
                <tr> 
                    <td class='title' rowspan="2">매매대금</td>
                    <td rowspan="2" colspan=2> &nbsp; <input type='text' size='10' name='mm_pr' value="<%=AddUtil.parseDecimal(sBean.getMm_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> </td>
                    <td class='title'  width='10%'>계약금</td>
                    <td> &nbsp; <input type='text' size='10' name='cont_pr' value="<%=AddUtil.parseDecimal(sBean.getCont_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=getJan_pr()'> </td>
                    <td class='title'>입금일</td>
                    <td colspan="2"> &nbsp; <input type='text' size='12' name='cont_pr_dt' value="<%=AddUtil.ChangeDate2(sBean.getCont_pr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr> 
                    <td class='title'> 잔금</td>
                    <td> &nbsp; <input type='text' size='10' name='jan_pr' value="<%=AddUtil.parseDecimal(sBean.getJan_pr())%>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
                    </td>
                    <td class='title'> 입금일</td>
                    <td colspan="3"> &nbsp; <input type='text' size='12' name='jan_pr_dt' value="<%=AddUtil.ChangeDate2(sBean.getJan_pr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                </tr>
				<!--
                <tr> 
                    <td class='title'>양도증명서스캔</td>
                    <td colspan="5" class='left'>&nbsp; <input type="file" name="filename" value='S' size="25"> 
                      &nbsp; <%if(!sBean.getSuifile().equals("")){%> <input type="button" name="b_map1" value="보기" onClick="javascript:view_file(1);"> 
                      &nbsp;&nbsp; <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))%> <input type="button" name="b_map3" value="삭제" onClick="javascript:drop_file('s');"> 
                      <%}%> </td>
                </tr>
                <tr> 
                    <td class='title'>LPG서류스캔</td>
                    <td colspan="5" class='left'>&nbsp; <input type="file" name="filename3" value='S' size="25"> 
                      &nbsp; <%if(!sBean.getLpgfile().equals("")){%> <input type="button" name="b_map2" value="보기" onClick="javascript:view_file('2');"> 
                      &nbsp;&nbsp; <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))%> <input type="button" name="b_map4" value="삭제" onClick="javascript:drop_file('l');"> 
                      <%}%> </td>
                </tr>
				-->
                <tr> 
                    <td class='title'>보증KM</td>
                    <td  colspan="2" class='left'>&nbsp; <input class="num" type="text" name="ass_st_km" size="10" value="<%=AddUtil.parseDecimal(sBean.getAss_st_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                      ~ 
                      <input class="num" type="text" name="ass_ed_km" size="10" value="<%=AddUtil.parseDecimal(sBean.getAss_ed_km())%>" onBlur='javascript:this.value=parseDecimal(this.value)'> 
                    </td>
                    <td class='title'>보증기간</td>
                    <td class='left'>&nbsp; <input class="text" type="text" name="ass_st_dt" size="12" value="<%=AddUtil.ChangeDate2(sBean.getAss_st_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input class="text" type="text" name="ass_ed_dt" size="12" value="<%=AddUtil.ChangeDate2(sBean.getAss_ed_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                    </td>
                    <td class='title'>보증서작성자</td>
                    <td colspan="3" class='left'>&nbsp; <input class="text" type='text' name='ass_wrt'    size='20' maxlength='20' value="<%=sBean.getAss_wrt()%>" > 
                    </td>
                </tr>
                <tr> 
                    <td class='title'> 기타사항 </td>
                    <td colspan='8'>&nbsp; <textarea name='etc' rows='2' cols='120' maxlength='500'><%=sBean.getEtc()%></textarea> 
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  <input type='checkbox' name='accid_yn' value="Y" <%if(sBean.getAccid_yn().equals("Y"))%>checked<%%>> 수의계약(잔존물)
                  &nbsp; 
                  <input type="text" name="sh_car_amt"  readonly  size="20" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>원
				  <a href="javascript:account_jangaamt()" onMouseOver="window.status=''; return true" title="잔가금액 계산하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a>
                 
                   </td>
                </tr>
                <tr>
                    <td class='title'>명의이전일</td>
                    <td>&nbsp; <input type='text' size='11' name='migr_dt' value="<%=AddUtil.ChangeDate2(sBean.getMigr_dt())%>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>명의이전후번호</td>
                    <td colspan="6">&nbsp; <input type='text' size='20' name='migr_no' value="<%=sBean.getMigr_no()%>" maxlength='20' class='text'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td><font color=red>* </font>&nbsp;특이사항 - &nbsp;<% if ( cls.getCls_st().equals("매입옵션") ) { %><%=cls.getRemark()%><% } %></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>이전명의자 정보</span>
        <input type='checkbox' name='c_up' onClick='javascript:set_up_addr()'>
        상동</td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'> 성명</td>
                    <td width="22%">&nbsp; 
                      <input type='text' name='car_nm' value="<%=sBean.getCar_nm()%>" size='30' maxlength='40' class='text' style='IME-MODE: active'>
                    </td>
                    <td class='title' width='15%'>관계 </td>
                    <td width='18%'>&nbsp; 
                      <input type='text' name='car_relation' value="<%=sBean.getCar_relation()%>" size='20' maxlength='40' class='text' style='IME-MODE: active'>
                    </td>
                    <td class='title' width='15%'>&nbsp;</td>
                    <td width='15%'>&nbsp; </td>
                </tr>
                <tr> 
                    <td class='title'>주민등록번호</td>
                    <td>&nbsp;
                    <%if(!client.getClient_st().equals("1")){%>
                    	<input type='text' size='6' name='car_ssn1' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(0,6));%>" maxlength='6' class='text'>
                      	- 
                      	<input type='text' name='car_ssn2' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(6));%>" maxlength='7' size='7' class='text' OnBlur="javascript:jumin_No2();">
               		<%}else{%>
               			<input type='text' size='6' name='car_ssn1' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(0,6));%>" maxlength='6' class='text'>
                      	- 
                      	<input type='text' name='car_ssn2' value="<%if(!sBean.getCar_ssn().equals("")) out.println(sBean.getCar_ssn().substring(6));%>" maxlength='7' size='7' class='text' OnBlur="javascript:Biz_ck2();">
               		<%}%>
                      &nbsp; </td>
                    <td class='title'>전화번호</td>
                    <td> &nbsp; 
                      <input type='text' size='15' value="<%=sBean.getCar_h_tel()%>" name='car_h_tel' maxlength='15' class='text'>
                    </td>
                    <td class='title'>핸드폰번호</td>
                    <td> &nbsp; 
                      <input type='text' size='15' value="<%=sBean.getCar_m_tel()%>" name='car_m_tel' maxlength='15' class='text'>
                    </td>
                </tr>
				<script>
					function openDaumPostcode3() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('car_zip').value = data.zonecode;
								document.getElementById('car_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>주소</td>
				  <td colspan=5>&nbsp;
					<input type="text" name="car_zip"  id="car_zip" size="7" maxlength='7' value="<%=sBean.getCar_zip()%>">
					<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="car_addr"  id="car_addr" size="100" value="<%=sBean.getCar_addr()%>">
				  </td>
				</tr>
				<!--
                <tr> 
                    <td class='title'>주소</td>
                    <td colspan="5">&nbsp; 
                      <input type='text' name='car_zip' value="<%=sBean.getCar_zip()%>" size='7' class='text' readonly onClick="javascript:search_zip('car');">
                      <input type='text' name='car_addr' value="<%=sBean.getCar_addr()%>" maxlength='60' size='70' class='text' style='IME-MODE: active'>
                    </td>
                </tr>
				-->
            </table>
        </td>
    </tr>
	<tr>
        <td></td>
    </tr>
    <tr> 
        <td align='left' colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험 정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'> 보험사</td>
                    <td width="22%">&nbsp; <input type='text' name='ins_nm' value='<%=ht.get("INS_COM_NM")%>' size='30' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>청구여부 </td>
                    <td width='18%'>&nbsp; <input type='text' name='ins_yes' value="<% if(ht.get("REQ_DT").equals("")) out.print("미청구"); else out.print("청구"); %>" size='20' maxlength='40' class='text' style='IME-MODE: active'> 
                    </td>
                    <td class='title' width='15%'>증권번호</td>
                    <td width='15%'>&nbsp;<input type='text' name='ins_no' value="<%=ht.get("INS_CON_NO")%>" size='20' maxlength='40' class='text' style='IME-MODE: active'>  </td>					
                </tr>
            </table>
        </td>
    </tr>
    <tR>
        <td></td>
    </tr>
    <%if(!olsD.getCar_mng_id(car_mng_id).equals("")){%>
	<!--매각대금입금현황-->
    <tr> 
        <td colspan="2"><iframe src="./off_ls_cmplt_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" name="sugum" width="100%" height="400" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
    <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>

</body>
</html>
