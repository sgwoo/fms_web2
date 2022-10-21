<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//카드기본현황 조회
	Vector vt = oc_db.getCarCashBackContStat("");
	int vt_size = vt.size();
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function CarStatCont(car_off_id){
		var fm = document.form1;
		fm.car_off_id.value = car_off_id;
		fm.action = "car_cash_back_bill_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='car_off_id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>약정현황</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan='2' class='title'>연번</td>
                    <td colspan='2' class='title'>거래처</td>
                    <td colspan='2' class='title'>판매장려금 산출</td>
                    <td colspan='2' class='title'>판매장려금 수금</td>
                    <td colspan='2' class='title'>연락처</td>
                </tr>
                <tr>
                    <td width='10%' class='title'>소속사명</td>
                    <td width='20%' class='title'>대리점</td>
                    <td width='20%' class='title'>산출기준</td>
                    <td width='5%' class='title'>요율</td>
                    <td width='10%' class='title'>기준</td>
                    <td width='10%' class='title'>약정일</td>
                    <td width='10%' class='title'>담당자</td>
                    <td width='10%' class='title'>전화</td>
                </tr>                
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
                <tr>
                    <td class='title'><%=i+1%></td>
                    <td align="center"><%=ht.get("NM")%></td>
                    <td align="center"><a href="javascript:CarStatCont('<%=ht.get("CAR_OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_OFF_NM")%></a></td>
                    <td align="center">판매수당(소속사에서 받은)</td>
                    <td align="center"><%=ht.get("CASHBACK_PER")%>%</td>
                    <td align="center">출고일자</td>
                    <td align="center"><%=ht.get("CASHBACK_EST_DT")%></td>
                    <td align="center"><%=ht.get("PO_AGNT_NM")%></td>
                    <td align="center"><%=ht.get("PO_AGNT_O_TEL")%></td>
                </tr>                  
	            <%	}%>
	            <%}else{%>
                <tr>
                    <td colspan="9" align="center">등록된 데이타가 없습니다.</td>
                </tr>
	            <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	  
  </table>
</form>
</body>
</html>
