<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	String year = st_dt+end_dt;
	
	//발행작업스케줄
	Vector fee_scd = ScdMngDb.getFeeScdStopTax(s_br, year);
	int fee_scd_size = fee_scd.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//미발행건수 연결
	function issue(reg_yn, print_st, req_dt, rent_l_cd){
		var fm = document.form1;
  	fm.gubun1.value = "1";
  	fm.st_dt.value = req_dt;
  	fm.end_dt.value = req_dt;
  	fm.s_kd.value = "2";
  	fm.t_wd1.value = rent_l_cd;
		if(print_st == '계약건별'){
	  	fm.action = '/tax/issue_1/issue_1_frame.jsp';
		}else{
	  	fm.action = '/tax/issue_2/issue_2_frame.jsp';
		}
 		fm.target = 'd_content';
 		fm.submit();
	}
	
	//계산서일시중지관리
	function FeeScdStop(m_id, l_cd, seq){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.seq.value = seq;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=750, height=600, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}
	
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='fee_scd_size' value='<%=fee_scd_size%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='mode' value='view'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='5%' class='title'>연번</td>
            <td width='7%' class='title'>중지구분</td>
            <td width='13%' class='title'>상호</td>
            <td width='10%' class='title'>차량번호</td>
            <td width='5%' class='title'>회차</td>
            <td width='8%' class='title'>입금예정일</td>			
            <td width='8%' class='title'>발행예정일</td>
            <td width='9%' class='title'>공급가</td>
            <td width='8%' class='title'>부가세</td>
            <td width='9%' class='title'>합계</td>
            <td class='title'>중지사유</td>
          </tr>
<%		for(int i = 0 ; i < fee_scd_size ; i++){
			Hashtable ht = (Hashtable)fee_scd.elementAt(i);%>						  
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><a href="javascript:FeeScdStop('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("STOP_SEQ")%>')"><%=ht.get("STOP_ST")%></td>
            <td align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
            <td align="center"><%=ht.get("CAR_NO")%></td>
            <td align="center"><%=ht.get("FEE_TM")%>회</td>			
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
<!--            <td align="center"><a href="javascript:issue('N','<%=ht.get("PRINT_ST")%>','<%=ht.get("REQ_DT")%>','<%=ht.get("RENT_L_CD")%>')"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></a></td>-->
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>			
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>원&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;</td>
            <td align="center"><%=ht.get("STOP_CAU")%></td>
          </tr>
<%		}%>	
<% 		if(fee_scd_size == 0){%>
		<tr>
		  <td colspan="11" align="center">등록된 데이타가 없습니다.</td>
		</tr>
<% 		}%>					  
        </table></td>
    </tr>
  </table>
</form>
</body>
</html>
