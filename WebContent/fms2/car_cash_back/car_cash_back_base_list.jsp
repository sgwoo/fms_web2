<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, acar.out_car.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String st = request.getParameter("st")==null?"":request.getParameter("st");
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	
	Vector vt = oc_db.getCarCashBackBaseList(st, car_off_id);
	int vt_size = vt.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=c_db.getNameById(car_off_id,"CAR_OFF")%> home</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='3%' class='title'>연번</td>
                    <td width='8%' class='title'>출고일자</td>
                    <td width='8%' class='title'>차량번호</td>
                    <td width='15%' class='title'>차명</td>
                    <td width='34%' class='title'>내용</td>
                    <td width='8%' class='title'>예정일자</td>
                    <td width='8%' class='title'>적립금액</td>
                    <td width='8%' class='title'>입금일자</td>
                    <td width='8%' class='title'>입금금액</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					            total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
					      %>
                <tr>
                    <td align="center" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=i+1%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=ht.get("CAR_NO")%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=ht.get("CAR_NM")%></td>
                    <td <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_BIGO")))%></td>                    
                    <td align="center" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="right" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%></td>
                    <td align="center" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                    <td align="right" <%if(String.valueOf(ht.get("DLV_ST")).equals("dlv")){ %> style="color:red"<%} %>><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("INCOM_AMT")))%></td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='6'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="9" align="center">등록된 데이타가 없습니다.</td>
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
