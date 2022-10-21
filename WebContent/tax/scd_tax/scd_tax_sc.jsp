<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String year = st_dt+end_dt;
	
	//발행작업스케줄
	Vector fee_scd = ScdMngDb.getFeeScdTaxScd(s_br, "1", "", "", "", "", "", "", year);
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
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//발행건수 연결
	function issue(reg_yn, cnt, req_dt){
		var fm = document.form1;
	  	fm.st_dt.value = req_dt;
  		fm.end_dt.value = req_dt;
		if(reg_yn == 'Y'){
		  	fm.gubun1.value = "4";
	  		fm.action = '/tax/tax_mng/tax_mng_frame.jsp';
		}else{
		  	fm.gubun1.value = "1";		
	  		fm.action = '/tax/issue_1/issue_1_frame.jsp';
		}
 		fm.target = 'd_content';
 		fm.submit();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='fee_scd_size' value='<%=fee_scd_size%>'>
<input type='hidden' name='req_dt' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
        <td class="line" id='td_title' style='position:relative;'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan="2" class='title'>연번</td>
                    <td width='10%' rowspan="2" class='title'>발행예정일</td>
                    <td width='11%' rowspan="2" class='title'>발행일자</td>
                    <td width='20%' rowspan="2" class='title'>대상기간</td>
                    <td colspan="2" class='title'>발행건수</td>
                    <td colspan="2" class='title'>미발행건수</td>
                    <td colspan="2" class='title'>합계</td>
                </tr>
                <tr>
                    <td width='8%' class='title'>건수</td>
                    <td width='10%' class='title'>금액</td>
                    <td width="8%" class='title'>건수</td>
                    <td width="10%" class='title'>금액</td>
                    <td width="8%" class='title'>건수</td>
                    <td width="10%" class='title'>금액</td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
	  <td class='line' width='100%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>		  
          <%for(int i = 0 ; i < fee_scd_size ; i++){
			        Hashtable ht = (Hashtable)fee_scd.elementAt(i);%>
          <tr>
            <td width='5%' align="center"><%=i+1%></td>
            <td width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_REQ_DT")))%></td>
            <td width='11%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
            <td width='20%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("S_FEE_EST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("E_FEE_EST_DT")))%></td>
            <td width='8%' align="center">
		        <%if(String.valueOf(ht.get("REQ_DT")).equals("0")){%>
		          <%=ht.get("Y_CNT")%>건
		        <%}else{%>
		          <a href="javascript:issue('Y','<%=ht.get("Y_CNT")%>','<%=ht.get("R_REQ_DT")%>')"><%=ht.get("Y_CNT")%>건</a>
		        <%}%>
		        </td>
            <td width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%>원&nbsp;</td>
            <td width='8%' align="center">
		        <%if(AddUtil.parseInt(String.valueOf(ht.get("A_CNT")))-AddUtil.parseInt(String.valueOf(ht.get("Y_CNT"))) == 0){%>		  
		          <%=AddUtil.parseInt(String.valueOf(ht.get("A_CNT")))-AddUtil.parseInt(String.valueOf(ht.get("Y_CNT")))%>건
		        <%}else{%>
		          <a href="javascript:issue('N','<%=AddUtil.parseInt(String.valueOf(ht.get("A_CNT")))-AddUtil.parseInt(String.valueOf(ht.get("Y_CNT")))%>','<%=ht.get("R_REQ_DT")%>')"><%=AddUtil.parseInt(String.valueOf(ht.get("A_CNT")))-AddUtil.parseInt(String.valueOf(ht.get("Y_CNT")))%>건</a>		  
		        <%}%>
		        </td>
            <td width='10%' align="right"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("FEE_AMT")))-AddUtil.parseInt(String.valueOf(ht.get("TAX_AMT"))))%>원&nbsp;</td>
            <td width='8%' align="center"><%=ht.get("A_CNT")%>건</td>
            <td width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;</td>
          </tr>
          <%}%>
          <%if(fee_scd_size == 0){%>
		      <tr>
		        <td colspan="10" align="center">등록된 데이타가 없습니다.</td>
		      </tr>
          <%}%>
        </table>
	    </td>
    </tr>
  </table>
</form>
</body>
</html>
