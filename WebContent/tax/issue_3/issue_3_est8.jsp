<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	String tax_supply = "";
	String tax_value = "";
	String tax_yn = "N";
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "18");
	
	//업무대여
	Vector grts = ScdMngDb.getUserRentScdList(s_br, st_dt+end_dt, "N");
	int grt_size = grts.size();	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}
	
	//발행
	function tax_reg(){
		var fm = document.form1;	
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("세금계산서를 발행할 계약을 선택하세요.");
			return;
		}	
		
		if(fm.tax_dt.value == ''){	alert('세금일자를 입력해주십시오.'); return; }
		if(fm.tax_g.value == ''){	alert('내용을 입력해주십시오.'); return; }		
		
		var size = toInt(fm.size.value);
		if(size > 1){
			for(var i=0 ; i<size ; i++){				
				fm.tax_supply[i].value = parseDecimal(toInt(parseDigit(fm.tax_amt[i].value)) / 1.1 );
				fm.tax_value[i].value = parseDecimal(toInt(parseDigit(fm.tax_amt[i].value)) - toInt(parseDigit(fm.tax_supply[i].value)) );
			}		
		}else{
			fm.tax_supply.value = parseDecimal(toInt(parseDigit(fm.tax_amt.value)) / 1.1 );
			fm.tax_value.value = parseDecimal(toInt(parseDigit(fm.tax_amt.value)) - toInt(parseDigit(fm.tax_supply.value)) );		
		}
		
		if(confirm('수시발행 하시겠습니까?'))
		{			
//			fm.target = "i_no";
			fm.action = "user_i_tax_a.jsp";
			fm.submit();						
		}
	}
//-->
</script>

</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="firm_nm" value="">  
  <input type="hidden" name="size" value="<%=grt_size%>">    
<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr> 
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>업무대여 발행대상 리스트</span></td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>  
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='5%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
          <td width='5%' class='title'>연번</td>
          <td width='15%' class='title'>근무지</td>
          <td width='10%' class='title'>부서</td>
          <td width='15%' class='title'>성명</td>
          <td width="15%" class='title'>차량번호</td>
          <td width="20%" class='title'>차명</td>
          <td width="15%" class='title'>대여료</td>
          </tr>
		<%	if(grt_size > 0){
				for (int i = 0 ; i < grt_size ; i++){
					Hashtable grt = (Hashtable)grts.elementAt(i);%>		
        <tr>
          <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=grt.get("USER_ID")%><%=i%>">
          </td>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=grt.get("BR_NM")%></td>		  
          <td align="center"><%=grt.get("NM")%></td>
          <td align="center"><%=grt.get("USER_NM")%></td>
          <td align="center"><%=grt.get("CAR_NO")%></td>
          <td align="center"><span title='<%=grt.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CAR_NM")), 10)%></span></td>		  
          <td align="center"><span class="ledger_contC">
            <input type="text" name="tax_amt" size="8" value="<%=Util.parseDecimal(String.valueOf(grt.get("AMT")))%>" class="num">
			<input type="hidden" name="tax_supply" value="">
			<input type="hidden" name="tax_value" value="">
			<input type="hidden" name="user_nm" value="<%=grt.get("USER_NM")%>">
			<input type="hidden" name="user_ssn" value="<%=grt.get("USER_SSN")%>">
			<input type="hidden" name="car_mng_id" value="<%=grt.get("CAR_MNG_ID")%>">
			<input type="hidden" name="car_no" value="<%=grt.get("CAR_NO")%>">
			<input type="hidden" name="car_nm" value="<%=grt.get("CAR_NM")%>">
			<input type="hidden" name="car_use" value="<%=grt.get("CAR_USE")%>">
          </span>원&nbsp;</td>
          </tr>
		<%		}
			}%>
<% 		if(grt_size == 0){%>
		<tr>
		  <td colspan="8" align="center">등록된 데이타가 없습니다.</td>
		  </tr>
<% 		}%>					
      </table></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서 발행</span></td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>
    <tr>
      <td colspan="2" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='10%' class='title'>세금일자</td>
          <td width='10%'>&nbsp;
<!--            <input type="text" name="tax_dt" size="10" value="<%=st_dt%>-<%=end_dt%>-<%=AddUtil.getMonthDate(AddUtil.parseInt(st_dt), AddUtil.parseInt(end_dt))%>" class="text">-->
            <input type="text" name="tax_dt" size="10" value="<%=AddUtil.getDate()%>" class="text">			
          </td>
          <td width='10%' class='title'>내용</td>
          <td width='30%'>&nbsp;
		    <input type="text" name="tax_g" size="30" value="대여료" class="text">
          </td>
          <td width='10%' class='title'>비고</td>
          <td width='30%'>&nbsp;
		    <input type="text" name="tax_bigo" size="30" value="" class="text">
          </td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td colspan="2">
	  * 업무대여 계산서 발급 대상은 영업직 외근자, 고객지원팀 외근자, 차량등록자 입니다. 위 명단을 확인하고 발행하세요.
	  </td>
    </tr>			
    <tr>
      <td colspan="2" align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		<a href="javascript:tax_reg();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>	
	  <%}%>
	  </td>
    </tr>		
  </table>
</form>
</body>
</html>
