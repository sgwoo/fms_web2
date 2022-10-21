<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String carNumber = request.getParameter("carNumber")==null?"":request.getParameter("carNumber");
	Vector carList = new Vector();
	
	if(carNumber != "" && carNumber != null){
	    carList = shDb.getShResListByCarNum(carNumber);
	}
	
%>


<html>
<head><title>기존 고객 검색</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script>
function searchCarList(){
	var frm = document.searchFrm;
	var carNumber = document.getElementById("carNumber").value;
	frm.carNumber.value = carNumber;
	frm.submit();
}

$(document).ready(function(){
	$('.selectCustomer').click(function(){
		var custName = $(this).text();
		var custTel = $(this).parent().parent().find(".cust-tel").text();
		var estId = $(this).parent().find(".estId").val();
		
		$(opener.document).find("#cust_nm").val(custName);
		$(opener.document).find("#cust_tel").val(custTel);
		$(opener.document).find("#prevEstId").val(estId);
		
		window.close();
	})
})
</script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
	<form name="searchFrm" method="post">
		<input type="hidden" name="carNumber"/>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
	    	<td align='left'>
	      		&nbsp;&nbsp;<img src=/acar/images/arrow_car_num.jpg align=absmiddle>&nbsp;
	        	<input type='text' name='carNumber' size='30' value='<%=carNumber%>' class='text' id="carNumber">
	        	&nbsp;<a href="javascript:searchCarList()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
				&nbsp;&nbsp;
	      	</td>
	    </tr>
	</table> 
	<table border="0" cellspacing="1" cellpadding="0" width=100%>
	   <tr> 
			<td width='5%' class='title'>연번</td>
			<td width="15%" class='title'>차량번호</td>	
			<td width="15%" class='title'>차종</td>
			<td width="20%" class='title'>고객</td>						
			<td width="15%" class='title'>연락처</td>
	   </tr>
	   <%
			for(int i=0; i<carList.size(); i++){
			    Hashtable ht = (Hashtable)carList.elementAt(i);
	   %>
	 	<tr>
	 		<td align="center"><%=i+1%></td>
	 		<td align="center"><%=ht.get("CAR_NO")%></td>
	 		<td align="center"><%=ht.get("CAR_NM")%></td>
	 		<td align="center">
	 			<a class="selectCustomer" href="javascript:;"><%=ht.get("CUST_NM")%></a>
	 			<input type="hidden" class="estId" value="<%=ht.get("EST_ID")%>"/>
	 		</td>
	 		<td align="center"><span class="cust-tel"><%=ht.get("CUST_TEL")%></span></td>
	 	</tr>
	   <%} %>
	</table>
</body>
</html>