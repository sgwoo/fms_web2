<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.partner.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String cpt_cd 	= request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Vector vt = se_dt.getBank_DCGR_List(cpt_cd);
	int vt_size = vt.size();	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--


//-->
</script>
</head>
<body leftmargin="10">


<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<div class="navigation">
	<span class=style1></span><span class=style5>○대출거래현황(기준일자 : <%=AddUtil.getDate()%> 현재)</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tbody>
					<tr>
						<td rowspan=3 class="title">연번</td>
						<td colspan=3 class="title">약정내용</td>
						<td rowspan=3 class="title">회전(<br>리볼빙<br>)여부</td>
						<td colspan=2 class="title">약정한도</td>
						<td colspan=8 class="title">실행현황</td>
						<td rowspan=3 class="title">실행합계</td>
						<td colspan=2 class="title">상환내역</td>
					</tr>
					<tr>
						<td rowspan=2 class="title">체결일</td>
						<td colspan=2 class="title">실행일정</td>
						<td rowspan=2 class="title">한도</td>
						<td rowspan=2 class="title">잔액</td>
						<td colspan=2 class="title">24개월</td>
						<td colspan=2 class="title">36개월</td>
						<td colspan=2 class="title">48개월</td>
						<td colspan=2 class="title">60개월</td>
						<td rowspan=2 class="title">상환</td>
						<td rowspan=2 class="title">잔액</td>
					</tr>
					<tr>
						<td class="title">개시일</td>
						<td class="title">종료예정일</td>
						<td class="title">금액</td>
						<td class="title">금리</td>
						<td class="title">금액</td>
						<td class="title">금리</td>
						<td class="title">금액</td>
						<td class="title">금리</td>
						<td class="title">금액</td>
						<td class="title">금리</td>
					</tr>
					<% for(int i=0; i< vt_size; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
					<tr>
						<td align="center"><%=i+1%></td>
						<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("체결일자")))%></td>
						<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("실행개시일")))%></td>
						<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("실행종료일")))%></td>
						<td align="center"><%=ht.get("회전여부")%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("약정한도금액")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("약정한도잔액")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("금액_24개월")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("금리_24개월")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("금액_36개월")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("금리_36개월")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("금액_48개월")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("금리_48개월")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("금액_60개월")))%></td>
						<td align="right"><%=AddUtil.parseFloat(String.valueOf(ht.get("금리_60개월")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("실행합계금액")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("상환금액")))%></td>
						<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("상환잔액")))%></td>
					</tr>
					<%}%>
				</tbody>
			</table>
        </td>
    </tr>
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>