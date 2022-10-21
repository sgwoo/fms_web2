<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.blackbox.*" %>
<%@ page import="acar.cus0601.*" %>
<jsp:useBean id="bbMdBean" class="acar.blackbox.BBModelBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	
	BlackBoxDatabase bbDb = BlackBoxDatabase.getInstance();
	
	BBModelBean[] modelList = bbDb.getModelListByOffName(t_wd); 
	
	
%>
<!DOCTYPE HTML>
<html>
<head>
<style>
.title{
	text-decoration:underline;
	cursor:pointer;
	color:#464e7c;
	font-weight:bold;
}
.link{
	text-decoration:underline;
	cursor:pointer;
	font-weight:bold;
}
</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script>
function search(){
	document.searchFrm.submit();
}
$(document).ready(function(){
	$("span.link").click(function(){
		var id = $(this).attr("id");
		var nm = $(this).text();
		var serial = $(this).parents("td").next().text();
		var compNm = $(this).parents("td").prev().text();
		
		$("#compName", opener.document).val(compNm);
		$("#modelName", opener.document).val(nm);
		$("#modelId", opener.document).val(id);
		$("#serialNo", opener.document).val(serial);
		
		window.close();
	})
})
</script>
</head>
<body>
	<form name="searchFrm">
		<div class="search-area">
			<label><i class="fa fa-check-circle"></i>블랙박스 업체명</label>
			<input type="text" class="input" name="t_wd" />
			<input type="button" class="button" value="검색" onclick="search()" />
		</div>
	</form>
	<div class="content">
		<table class="inner-table">
			<tr>
				<th>연번</th>
				<th>제조사명</th>
				<th>모델명</th>
				<th>일련번호</th>
				<th>가격</th>
				<!-- <th>사양</th> -->
				<th>비고</th>
			</tr>
			<%
				for(int i=0; i<modelList.length; i++){
					bbMdBean = modelList[i];
			%>
			<tr>
				<td style="text-align:center"><%=i+1%></td>
				<td style="text-align:center"><%=bbMdBean.getOff_nm()%></td>
				<td style="text-align:center">
				<%
					if(bbMdBean.getModel_nm().equals("C-2") || bbMdBean.getModel_nm().equals("LX-100 ALPHA")){
			%>			<%=bbMdBean.getModel_nm()%>
			<%		}else{
			%>			<span class="link" id="<%=bbMdBean.getModel_id()%>"><%=bbMdBean.getModel_nm()%></span>
			<%		} %>	
				</td>
				<td style="text-align:center"><%=bbMdBean.getSerial_num()%></td>
				<td style="text-align:right"><%=AddUtil.parseDecimal(bbMdBean.getPrice())%>원</td>
				<%-- <td><%=bbMdBean.getSpec()%></td> --%>
				<td>
					&nbsp;<%=bbMdBean.getEtc()%>
				</td>
			</tr>
			<%
			   
				}
			 %>
		</table>
	</div>
</body>
</html>