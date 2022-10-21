<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	Vector vt = oc_db.getCarCashBackDayList(s_yy, s_mm, base_dt, car_off_id);
	int vt_size = vt.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function CarBaseUp(serial){
		var fm = document.form1;
		fm.serial.value = serial;
		fm.target = "_self";
		fm.action = "car_cash_back_day_ui.jsp";
		fm.submit();				
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='base_dt' value='<%=base_dt%>'>
<input type='hidden' name='car_off_id' value='<%=car_off_id%>'>
<input type='hidden' name='serial' value=''>


  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=c_db.getNameById(car_off_id,"CAR_OFF")%> <%=AddUtil.ChangeDate2(base_dt)%> 현항</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='3%' class='title'>연번</td>
                    <td width='8%' class='title'>출고일자</td>
                    <td width='8%' class='title'>차량번호</td>
                    <td width='14%' class='title'>차명</td>
                    <td width='30%' class='title'>내용</td>
                    <td width='8%' class='title'>예정일자</td>
                    <td width='8%' class='title'>적립금액</td>
                    <td width='8%' class='title'>입금일자</td>
                    <td width='8%' class='title'>입금금액</td>
                    <td width='5%' class='title'>-</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					            total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    <td>&nbsp;<%=ht.get("BASE_BIGO")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%></td>
                    <td align="center"><a href="javascript:CarBaseUp('<%=ht.get("SERIAL")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a></td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='6'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td>&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="10" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr> 
    <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
	      <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>    
  </table>
</form>
</body>
</html>
