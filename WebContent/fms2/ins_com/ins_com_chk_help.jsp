<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>

<div class="navigation">
	<span class=style1>보험관리 ></span><span class=style5>보험요청내용</span>
</div>

<table border="0" cellspacing="0" cellpadding="0" width='650'>  
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>가입요청 점검내용</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>구분</td>
					<td width='450' class='title'>내용</td>
			  </tr>
				<tr>
					<td class='title'>계약해지</td>
					<td>&nbsp;출고전해지 등 계약이 해지되었다.</td>
			  </tr>
				<tr>
					<td class='title'>보험 기등록</td>
					<td>&nbsp;보험이 이미 등록되어 있다.</td>
			  </tr>
			</table>
		</td>
	</tr>     
    <tr> 
        <td>※ 차대번호, 차량번호, 블랙박스 정보를 갱신 처리한다.</td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>    
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>갱신요청 점검내용</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>구분</td>
					<td width='450' class='title'>내용</td>
			  </tr>
				<tr>
					<td class='title'>명의이전일 경과</td>
					<td>&nbsp;경매 및 매입옵션이 되엇으며, 명의이전일이 갱신시작일보다 작다.</td>
			  </tr>
				<tr>
					<td class='title'>계약변경</td>
					<td>&nbsp;갱신 요청시 계약과 현 시점의 계약이 다르다.</td>
			  </tr>
				<tr>
					<td class='title'>계약해지</td>
					<td>&nbsp;계약이 해지 완료되었다.</td>
			  </tr>
				<tr>
					<td class='title'>계약해지의뢰</td>
					<td>&nbsp;계약이 해지의뢰가 등록되었다.</td>
			  </tr>
				<tr>
					<td class='title'>보험 기등록</td>
					<td>&nbsp;동일자로 갱신보험이 이미 등록되어 있다.</td>
			  </tr>			  
			</table>
		</td>
	</tr>     
    <tr> 
        <td>&nbsp;</td>
    </tr>    
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배서요청 점검내용</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>구분</td>
					<td width='450' class='title'>내용</td>
			  </tr>
				<tr>
					<td class='title'>계약해지취소</td>
					<td>&nbsp;해지문서관리에서 요청한 건으로 해지의뢰가 삭제되었다.</td>
			  </tr>
			</table>
		</td>
	</tr>     
    <tr> 
        <td>※ 보험변경요청에서 등록된 건은 배서요청 등록전에 보험 기반영 및 배서현황에 기등록을 확인하고 정상건만 등록한다.</td>
    </tr>
	
    <tr> 
        <td>&nbsp;</td>
    </tr>    
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지요청 점검내용</span></td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>구분</td>
					<td width='450' class='title'>내용</td>
			  </tr>
				<tr>
					<td class='title'>해지 기등록</td>
					<td>&nbsp;보험해지가 이미 등록되어 있다</td>
			  </tr>
			</table>
		</td>
	</tr>     	
    <tr> 
        <td>&nbsp;</td>
    </tr>            
    <tr>
        <td align="right">		
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
</table>

</body>
</html>
