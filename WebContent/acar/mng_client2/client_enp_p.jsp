<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ page import="acar.client.*, acar.util.*, tax.*, acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	ClientBean client = al_db.getNewClient(client_id);
	
	//사업자등록증 이력
	Vector vts1 = ClientMngDb.getClientMngEnpHList(client_id);
	int vt_size1 = vts1.size();
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();	
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();		
	}
	
	
	//스캔관리 보기
	function view_scan_client(){
		window.open("/fms2/lc_rent/view_scan_client.jsp?client_id=<%=client_id%>", "VIEW_CLIENT_SCAN", "left=200, top=100, width=820, height=800, scrollbars=yes");		
	}
	
	function modify()
	{
		var fm = document.form1;
		if(fm.firm_nm.value == '')				{	alert('상호를 입력하십시오');			return;	}
		if(fm.client_nm.value == '')				{	alert('계약자를 입력하십시오');			return;	}
		
		//개인사업자		
		if(fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){
		
			//20140807 개인정보보험법으로 불필요한 주민번호 수집은 안됨
			if(<%=AddUtil.getDate(4)%> < 20140807){				
				if(fm.ssn1.value == '')				{	alert('주민등록번호(법인번호)를 입력하십시오');		return;	}
				if(fm.ssn2.value == '')				{	alert('주민등록번호(법인번호)를 입력하십시오');		return;	}						
				if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('주민등록번호(법인번호)를 확인하십시오');	return;	}				
			}else{
				if(fm.ssn1.value == '')				{	alert('생년월일을 입력하십시오');			return;	}			
				if( (!isNum(fm.ssn1.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) )	{	alert('생년월일을 확인하십시오');	return;	}
			}

			if(fm.enp_no1.value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
			if(fm.enp_no2.value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
			if(fm.enp_no3.value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}			
			if((!isNum(fm.enp_no1.value)) || (!isNum(fm.enp_no2.value)) || (!isNum(fm.enp_no3.value))|| ((fm.enp_no1.value.length != 3)&&(fm.enp_no1.value.length != 0)) || ((fm.enp_no2.value.length != 2)&&(fm.enp_no2.value.length != 0)) || ((fm.enp_no3.value.length != 5)&&(fm.enp_no3.value.length != 0)))	{	alert('사업자등록번호를 확인하십시오');	return;	}				
			
			if(fm.bus_cdt.value == '')				{	alert('업태를 입력하십시오');			return;	}
			if(fm.bus_itm.value == '')				{	alert('종목를 입력하십시오');			return;	}

		//법인,경매장	
		}else if(fm.client_st.value == '1' || fm.client_st.value == '6'){
			
			if ( '<%=client.getFirm_type()%>' == '6' || '<%=client.getFirm_type()%>' == '7' || '<%=client.getFirm_type()%>' == '8' || '<%=client.getFirm_type()%>' == '9' || '<%=client.getFirm_type()%>' == '10' || '<%=client.getFirm_type()%>' == '11' ) {	//국가,지방자치,정부투자기관,정부연구기관,비영리
			
			}else{
			
				if(fm.ssn1.value == '')				{	alert('법인번호를 입력하십시오');			return;	}
				if(fm.ssn2.value == '')				{	alert('법인번호를 입력하십시오');			return;	}						
				if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('주민등록번호(법인번호)를 확인하십시오');	return;	}
				
			}
			
			if(fm.enp_no1.value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
			if(fm.enp_no2.value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}
			if(fm.enp_no3.value == '')				{	alert('사업자등록번호를 입력하십시오');			return;	}			
			if((!isNum(fm.enp_no1.value)) || (!isNum(fm.enp_no2.value)) || (!isNum(fm.enp_no3.value))|| ((fm.enp_no1.value.length != 3)&&(fm.enp_no1.value.length != 0)) || ((fm.enp_no2.value.length != 2)&&(fm.enp_no2.value.length != 0)) || ((fm.enp_no3.value.length != 5)&&(fm.enp_no3.value.length != 0)))	{	alert('사업자등록번호를 확인하십시오');	return;	}				
	
			if(fm.client_st.value == '1' && fm.t_zip[1].value == '')			{	alert('본점소재지를 입력하십시오');		return;	}
			if(fm.client_st.value == '1' && fm.t_addr[1].value == '')			{	alert('본점소재지를 입력하십시오');		return;	}
			
			if(fm.bus_cdt.value == '')				{	alert('업태를 입력하십시오');			return;	}
			if(fm.bus_itm.value == '')				{	alert('종목를 입력하십시오');			return;	}
			
		//개인
		}else if(fm.client_st.value == '2'){
		
			if(fm.ssn1.value == '')					{	alert('주민등록번호(법인번호)를 입력하십시오');		return;	}
			if(fm.ssn2.value == '')					{	alert('주민등록번호(법인번호)를 입력하십시오');		return;	}						
			if((!isNum(fm.ssn1.value)) || (!isNum(fm.ssn2.value)) || ((fm.ssn1.value.length != 6)&&(fm.ssn1.value.length != 0)) || ((fm.ssn2.value.length != 7)&&(fm.ssn2.value.length != 0)))	{	alert('주민등록번호(법인번호)를 확인하십시오');	return;	}		
			
		}

		if(fm.t_zip[0].value == '')				{	alert('사업장주소를 입력하십시오');		return;	}
		if(fm.t_addr[0].value == '')				{	alert('사업장주소를 입력하십시오');		return;	}			
		
		if(fm.cng_dt.value == '')				{	alert('변경일자를 입력하십시오');		return;	}		

		if(confirm('변경하시겠습니까?'))
		{			
			fm.target='i_no';
			fm.submit();
		}
	}

	function value_set(c_nm, c_value){
		var fm = document.form1;
		if(c_nm == 'firm_nm') 	{	fm.firm_nm.value = c_value;					}
		if(c_nm == 'client_nm') {	fm.client_nm.value = c_value;				}
		var h_value = c_value.split("|");		
		if(c_nm == 't_zip0') 	{	fm.t_zip[0].value = h_value[0];		fm.t_addr[0].value = h_value[1];			}
		if(c_nm == 't_zip1') 	{	fm.t_zip[1].value = h_value[0];		fm.t_addr[1].value = h_value[1];			}
		if(c_nm == 'bus_cdt') 	{	fm.bus_cdt.value = c_value;				}
		if(c_nm == 'bus_itm') 	{	fm.bus_itm.value = c_value;				}				
	}
	
	function set_o_addr()
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}
		else
		{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
	}		
//-->
</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function check_jumin() {
    var chk =0;
    var yy = document.form1.ssn1.value.substring(0,2);
    var mm = document.form1.ssn1.value.substring(2,4);
    var dd = document.form1.ssn1.value.substring(4,6);
    var sex = document.form1.ssn2.value.substring(0,1);

    // 주민등록번호를 자리수에 맞게 입력했는지 체크
    if (document.form1.ssn2.value.split(" ").join("") == "") {
        alert ('주민등록번호를 입력하십시오.');
        document.form1.jumin1.focus();
        return false;
    }
    if (document.form1.ssn1.value.length!=6) {
        alert ('주민등록번호 앞자리를 입력하십시오');
        document.form1.jumin1.focus();
        return false;
    }
    if (document.form1.ssn2.value.length != 7 ) {
        alert ('주민등록번호 뒷자리를 입력하십시오.');
        document.form1.jumin2.focus();
        return false;
    }
    if (isNaN(document.form1.ssn1.value) || isNaN(document.form1.ssn2.value)) {
        document.form1.ssn1.value = ""
        document.form1.ssn2.value = ""
        alert('주민등록번호는 숫자만 가능합니다.');
        return false;


    }
    if ((document.form1.ssn1.value.length!=6)||(mm <1||mm>12||dd<1)){
        document.form1.ssn1.value = ""
        alert ('주민등록번호 앞자리가 잘못되었습니다.');
        document.form1.jumin1.focus();
        return false;
    }
    if ((sex != 1 && sex !=2 )||(document.form1.ssn2.value.length != 7 )){
        document.form1.ssn2.value = ""
        alert ('주민등록번호 뒷자리가 잘못되었습니다.');
        document.form1.ssn2.focus();
        return false;
    }

    for (var i = 0; i <=5 ; i++) {
        chk = chk + ((i%8+2) * parseInt(document.form1.ssn1.value.substring(i,i+1)))
    }
    for (var i = 6; i <=11 ; i++) {
        chk = chk + ((i%8+2) * parseInt(document.form1.ssn2.value.substring(i-6,i-5)))
    }

    chk = 11 - (chk %11)
    chk = chk % 10

    if (chk != document.form1.ssn2.value.substring(6,7)) {
        document.form1.ssn1.value = "";
        document.form1.ssn2.value = "";
        alert ('맞지 않는 주민등록번호입니다.');
        document.form1.ssn1.focus();
        return false;
    }

    return true;
}

 function isRegNo()
 {
 	
  var re = /-/g;
  sRegNo = document.form1.ssn1.value+document.form1.ssn2.value;

  if (sRegNo.length != 13){
		alert ('맞지 않는 법인등록번호입니다.');
   return false;
  }

  var arr_regno  = sRegNo.split("");
  var arr_wt   = new Array(1,2,1,2,1,2,1,2,1,2,1,2);
  var iSum_regno  = 0;
  var iCheck_digit = 0;

  for (i = 0; i < 12; i++){
    iSum_regno +=  eval(arr_regno[i]) * eval(arr_wt[i]);
  }

  iCheck_digit = 10 - (iSum_regno % 10);

  iCheck_digit = iCheck_digit % 10;

  if (iCheck_digit != arr_regno[12]){
  	alert ('맞지 않는 법인등록번호입니다.');
    return false;
  }
  return true;
 }
 
 	//계약정보 보기
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}
	
	function req_fee_start_act(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=user_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=520, height=470");
	}	


//-->	
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post' action='/acar/mng_client2/client_enp_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='seq' value='<%=vt_size1+1%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>사업자등록증 변경</span></span></td>
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
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='3%' class='title'>연번</td>
                    <td width='15%' class='title'>상호</td>
                    <td width='10%' class='title'>대표자</td>
                    <td width='10%' class='title'>사업자/<br>주민번호/<br>종사업자번호</td>					
                    <td width='16%' class='title'>사업장주소</td>
                    <td width='16%' class='title'>본점소재지</td>
                    <td width='10%' class='title'>업태</td>
                    <td width='10%' class='title'>종목</td>
                    <td width='10%' class='title'>변경일자</td>
                </tr>
                <%for(int i = 0 ; i < vt_size1 ; i++){
        				Hashtable ht = (Hashtable)vts1.elementAt(i);%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("FIRM_NM")%></td>
                    <td align="center"><%=ht.get("CLIENT_NM")%></td>
                    <td align="center"><%=ht.get("ENP_NO")%><br><%=ht.get("SSN")%><br><%=ht.get("TAXREGNO")%></td>					
                    <td>&nbsp;<%=ht.get("O_ADDR")%></td>
                    <td>&nbsp;<%=ht.get("HO_ADDR")%></td>
                    <td align="center"><%=ht.get("BUS_CDT")%></td>
                    <td align="center"><%=ht.get("BUS_ITM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%><br><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>	
	<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("고객사업자등록증변경",user_id)){%>
	<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<tr>
		<td align='right'></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>		
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='12%'> 구분 </td>
                    <td class='title' width='32%'>변경전</td>
                    <td class='title' width='4%'>좌동</td>
                    <td class='title' width='52%'>변경후</td>
                </tr>
                <tr>
                    <td class='title'> 고객구분 </td>
                    <td>&nbsp;
                      <%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");
        				else if(client.getClient_st().equals("6")) 	out.println("경매장");%></td>
                    <td align="center"></td>
                    <td>&nbsp;
                      <select name='client_st'>
                        <option value='1' <%if(client.getClient_st().equals("1")) out.println("selected");%>> 법인 </option>
                        <option value='2' <%if(client.getClient_st().equals("2")) out.println("selected");%>> 개인 </option>
                        <option value='3' <%if(client.getClient_st().equals("3")) out.println("selected");%>> 개인사업자(일반과세) </option>
                        <option value='4' <%if(client.getClient_st().equals("4")) out.println("selected");%>> 개인사업자(간이과세) </option>
                        <option value='5' <%if(client.getClient_st().equals("5")) out.println("selected");%>> 개인사업자(면세사업자)</option>
        				<option value='6' <%if(client.getClient_st().equals("6")) out.println("selected");%>> 경매장</option>
                      </select>
        		    </td>
                </tr>
                <tr>
                    <td class='title'>사업자번호</td>
                    <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%> (종사업자번호:<%=client.getTaxregno()%>)</td>
                    <td align="center"></td>
                    <td>&nbsp;
                      <input type='text' size='3' name='enp_no1' value='<%=client.getEnp_no1()%>' maxlength='3' class='text'>
        			  -
        			  <input type='text' size='2' name='enp_no2' value='<%=client.getEnp_no2()%>' maxlength='2' class='text'>
        			  -
        			  <input type='text' size='5' name='enp_no3' value='<%=client.getEnp_no3()%>' maxlength='5' class='text'>
					  &nbsp;&nbsp;
					  (종사업자번호 : <input type='text' size='3' name='taxregno' maxlength='4' class='text' value='<%=client.getTaxregno()%>'>)					  
					  </td>
                </tr>
                <tr>
                    <td class='title'>주민/법인번호</td>
                    <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
                    <td align="center"></td>
                    <td>&nbsp;
                      <input type='text' name='ssn1' maxlength='6' value='<%=client.getSsn1()%>' size='6' class='text'>
        			  -
        			  <input type='text' name='ssn2' maxlength='7' value='<%=client.getSsn2()%>' size='7' class='text' <%if(client.getClient_st().equals("2")){%>onBlur="check_jumin()"<%}else{%>onBlur="isRegNo()"<%}%>>
					  &nbsp;&nbsp;
					  <a href="http://www.nts.go.kr/cal/cal_check_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0></a>
					  </td>
                </tr>
                <tr>
                    <td class='title'>개업년월일</td>
                    <td>&nbsp;
                    <%= client.getOpen_year()%></td>
                    <td align="center"></td>
                    <td>&nbsp;
                      <input type='text' name="t_open_year" value='<%= client.getOpen_year()%>' size='10' class='text'></td>
                </tr>		
                <tr>
                    <td class='title'>상호</td>
                    <td>&nbsp;
                    <%=client.getFirm_nm()%>
					<%if(from_page.equals("/tax/tax_mng/tax_mng_sc.jsp") && !rent_l_cd.equals("")){
							Hashtable cont = a_db.getContViewCase("", rent_l_cd);%>
					&nbsp;<span class="b"><a href="javascript:view_client('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>', '<%=cont.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true" title="계약내용 보기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
					&nbsp;(영업담당:<a href="javascript:req_fee_start_act('', '<%=client.getFirm_nm()%>가 현재 폐업상태입니다. 확인 및 사후처리해주세요', '<%=cont.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title='영업담당자에게 알림'><%=c_db.getNameById(String.valueOf(cont.get("BUS_ID2")),"USER")%></a>)
					<%}%>
					</td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('firm_nm','<%=client.getFirm_nm()%>')"></td>
                    <td>&nbsp;
                      <input type='text' name='firm_nm' value='<%//=client.getFirm_nm()%>' size='55' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>대표자</td>
                    <td>&nbsp;
                    <%=client.getClient_nm()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('client_nm','<%=client.getClient_nm()%>')"></td>
                    <td>&nbsp;
                      <input type='text' size='55' name='client_nm' value='<%//=client.getClient_nm()%>' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>사업장 주소</td>
                    <td>&nbsp;
                    <%if(!client.getO_addr().equals("")){%>
        				(
        			<%}%>
        			<%=client.getO_zip()%>
        			<%if(!client.getO_addr().equals("")){%>
        				)<br>&nbsp;
        			<%}%>
        			<%=client.getO_addr()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('t_zip0','<%=client.getO_zip()%>|<%=client.getO_addr()%>')"></td>
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
								function openDaumPostcode() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('t_zip').value = data.zonecode;
											document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
											
										}
									}).open();
								}
							</script>		
					  <td colspan=>&nbsp;
						<input type="text" name='t_zip' id="t_zip" size="7" maxlength='7' >
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<textarea name='t_addr' id="t_addr" rows='2'  cols="75" ></textarea>
					  </td>
                </tr>
                <tr>
                    <td class='title'>본점소재지<br>/사업자주소</td>
                    <td>&nbsp;
                    <%if(!client.getHo_addr().equals("")){%>
        				(
        			<%}%>
        			<%=client.getHo_zip()%>
        			<%if(!client.getHo_addr().equals("")){%>
        			)<br>&nbsp;
        			<%}%>
        			<%=client.getHo_addr()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('t_zip1','<%=client.getHo_zip()%>|<%=client.getHo_addr()%>')"></td>
					<script>
						function openDaumPostcode1() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip1').value = data.zonecode;
									document.getElementById('t_addr1').value = data.address +" ("+ data.buildingName+")";
									
								}
							}).open();
						}
					</script>			
					  <td colspan=>
						<input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>상동
						<input type="text" name='t_zip' id="t_zip1" size="7" maxlength='7' >
						<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
						&nbsp;&nbsp;<textarea name='t_addr' id="t_addr1" rows='2'  cols="75" ></textarea>
					  </td>
                </tr>				
                <tr>
                    <td class='title'>업태</td>
                    <td>&nbsp;
                    <%=client.getBus_cdt()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('bus_cdt','<%=client.getBus_cdt()%>')"></td>
                    <td>&nbsp;
                      <input type='text' size='55' name='bus_cdt' value='<%//=client.getBus_cdt()%>' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>종목</td>
                    <td>&nbsp;
                    <%=client.getBus_itm()%></td>
                    <td align="center"><input type="checkbox" name="checkbox" value="" onclick="javascript:value_set('bus_itm','<%=client.getBus_itm()%>')"></td>
                    <td>&nbsp;
                      <input type='text' size='55' name='bus_itm' value='<%//=client.getBus_itm()%>' maxlength='40' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>변경일자</td>
                    <td align="center">-</td>
                    <td align="center"></td>
                    <td>&nbsp;
                    <input type='text' name="cng_dt" value='' size='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr>
                    <td class='title'>변경구분</td>
                    <td align="center">-</td>
                    <td align="center"></td>
                    <td>&nbsp;            
        		  	<input type="radio" name="cng_st" value="Y" checked>이력관리
                      <input type="radio" name="cng_st" value="N">내용정정</td>
                </tr>		
				
                <tr>
                    <td class='title'>네오엠거래처</td>
                    <td align="center">-</td>
                    <td align="center"></td>
                    <td>&nbsp;  
					  <%if(client.getVen_code().equals("")){%>
					  <input type="radio" name="ven_cng_st" value="1" checked>자동등록
					  <%}else{%>          
        		  	  <input type="radio" name="ven_cng_st" value="2" checked>자동수정
					  <%}%>
                      <input type="radio" name="ven_cng_st" value="3">거래처변경
					</td>
                </tr>						
				
            </table>
        </td>
    </tr>	
	<%}%>
	<tr>
		<td class=h></td>
	</tr>		
	<tr>
		<td align='right'> 
		<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			<a href="javascript:modify()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border="0"></a>
		<%}%>
			&nbsp;<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border="0"></a>			
		</td>
	</tr>
	<%if(from_page.equals("/tax/tax_mng/tax_mng_sc.jsp")){%>		
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=7% style="font-size : 8pt;">사무실번호</td>
                    <td width=14%>&nbsp;<%=client.getO_tel()%></td>
                    <td class=title width=7% style="font-size : 8pt;">휴대폰번호</td>
                    <td width=10%>&nbsp;<%=client.getM_tel()%></td>
                    <td class=title width=7% style="font-size : 8pt;">자택번호</td>
                    <td width=10%>&nbsp;<%=client.getH_tel()%></td>
                    <td class=title width=7% style="font-size : 8pt;">계산서담당</td>
                    <td width=8%>&nbsp;<%=client.getCon_agnt_nm()%></td>
                    <td class=title width=7% style="font-size : 8pt;">사무실번호</td>
                    <td width=8%>&nbsp;<%=client.getCon_agnt_o_tel()%></td>
                    <td class=title width=7% style="font-size : 8pt;">이동전화</td>
                    <td width=8%>&nbsp;<%=client.getCon_agnt_m_tel()%></td>
                </tr>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%}%>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객별 최근 스캔</span>
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:view_scan_client()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_more.gif border=0 align=absmiddle></a>
		</td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>연번</td>
                    <td class="title" width='20%'>구분</td>
                    <td class="title" width='40%'>설명</td>
                    <td class="title" width='20%'>파일보기</td>
                    <td class="title" width='15%'>등록일</td>
                </tr>

            </table>
        </td>
    </tr>	
</table>	
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
