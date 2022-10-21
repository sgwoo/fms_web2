<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String enp_no = request.getParameter("enp_no")==null?"":request.getParameter("enp_no");	
	s_kd = "4";
	t_wd1 = AddUtil.replace(enp_no, "-", "");
	
	if(!gubun1.equals("") && gubun2.equals("") && gubun3.equals("")){
									st_dt = gubun1+"0101"; end_dt = gubun1+"1231";
	}
	if(!gubun1.equals("") && !gubun2.equals("") && gubun3.equals("")){
		if(gubun2.equals("1")){		st_dt = gubun1+"0101"; end_dt = gubun1+"0331";}
		if(gubun2.equals("2")){		st_dt = gubun1+"0401"; end_dt = gubun1+"0630";}
		if(gubun2.equals("3")){		st_dt = gubun1+"0701"; end_dt = gubun1+"0930";}
		if(gubun2.equals("4")){		st_dt = gubun1+"1001"; end_dt = gubun1+"1231";}
	}
	if(!gubun1.equals("") && !gubun2.equals("") && !gubun3.equals("")){
									st_dt = gubun1+gubun3+"01"; end_dt = gubun1+gubun3+"31";
	}
	
	gubun1 = "1";
	sort = "5";
	// chk5 값 확인 - 임시로 9 넘김, 스페이스 경우 쿼리 select 결과 없음
	
	Vector vts = ScdMngDb.getTaxMngList(s_br, chk1, chk2, chk3, chk4, "9", chk6, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_tax(enp_no, idx){	
	
		var fm = document.form1;
		fm.s_kd.value = '5';
		fm.t_wd1.value = enp_no;
		fm.idx.value = idx;
		
		//
		//if(fm.gubun1.value != '' && fm.gubun2.value == '' && fm.gubun3.value == '' ){
		//  fm.st_dt.value = fm.gubun1.value+'0101';
		//  fm.end_dt.value = fm.gubun1.value+'1231';
	//	}else if(fm.gubun1.value != '' && fm.gubun2.value != '' && fm.gubun3.value == '' ){
	//	  if(fm.gubun2.value == '1'){
  	//	  fm.st_dt.value = fm.gubun1.value+'0101';
	 // 	  fm.end_dt.value = fm.gubun1.value+'0331';
	//	  }else if(fm.gubun2.value == '2'){
  	//	  fm.st_dt.value = fm.gubun1.value+'0401';
	 // 	  fm.end_dt.value = fm.gubun1.value+'0630';
	//	  }else if(fm.gubun2.value == '3'){
  	//	  fm.st_dt.value = fm.gubun1.value+'0701';
	 // 	  fm.end_dt.value = fm.gubun1.value+'0930';
	//	  }else if(fm.gubun2.value == '4'){
  	//	  fm.st_dt.value = fm.gubun1.value+'1001';
	 // 	  fm.end_dt.value = fm.gubun1.value+'1231';
	//	  }
//		}else{
	//	  fm.st_dt.value = fm.gubun1.value+''+fm.gubun3.value+'01';
	//	  fm.end_dt.value = fm.gubun1.value+''+fm.gubun3.value+'31';
	//	}
	//	fm.gubun1.value = '1';	
		
		fm.submit();
		self.close();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='../tax_mng/tax_mng_frame.jsp' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value=>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
  	<tr><td class=line2 colspan=2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='35%' id='td_title' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
          <td width='10%' class='title'>연번</td>
          <td width='20%' class='title'>일련번호</td>
          <td width='40%' class='title'>상호</td>
          <td width='30%' class='title'>사업자번호</td>
          </tr>
        </table>
      </td>
	    <td class='line' width='65%'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='13%' class='title'>세금일자</td>
            <td width='16%' class='title'>항목</td>
            <td width='13%' class='title'>공급가</td>
            <td width='10%' class='title'>부가세</td>
            <td width='13%' class='title'>합계</td>
            <td width='13%' class='title'>작성일자</td>
            <td width='13%' class='title'>출력일자</td>
            <td width='9%' class='title'>상태</td>
          </tr>
        </table>
	    </td>
    </tr>
<%	if(vt_size > 0){%>
    <tr>
	    <td class='line' width='35%' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='10%' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='20%' align='center'><a href="javascript:view_tax('<%=ht.get("TAX_NO")%>','<%=i+1%>')" onMouseOver="window.status=''; return true"><%=ht.get("TAX_NO")%></a></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='40%' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>			
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='30%' align='center'>
			      <%if(String.valueOf(ht.get("ENP_NO")).equals("")){%>
			      <%=AddUtil.ChangeSsn(AddUtil.ChangeSsn(String.valueOf(ht.get("SSN"))))%>
			      <%}else{%>
			      <%=AddUtil.ChangeSsn(AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO"))))%>
			      <%}%>			
			      </td>
          </tr>
          <%}%>
        </table>
	    </td>
	    <td class='line' width='65%'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='13%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='16%' align="center"><span title='<%=ht.get("TAX_G")%>'><%=AddUtil.subData(String.valueOf(ht.get("TAX_G")), 6)%></span></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='13%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_SUPPLY")))%>원</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_VALUE")))%>원</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='13%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%>원</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='13%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='13%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='9%' align="center">
			      <%if(String.valueOf(ht.get("TAX_ST")).equals("M")){%>
			      매출취소
			      <%}else if(String.valueOf(ht.get("TAX_ST")).equals("C")){%>
			      <font color=red>발행취소</font>
			      <%}else{%>
            정상
			      <%}%>			            
            </td>												
          </tr>
          <%}%>
        </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>등록된 데이타가 없습니다</td>
          </tr>
        </table>
      </td>
	    <td class='line' width='60%'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		        <td>&nbsp;</td>
	        </tr>
	      </table>
	    </td>
    </tr>
<% 	}%>
  </table>
</form>

</body>
</html>
