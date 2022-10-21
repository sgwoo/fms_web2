<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.table_div {
	margin-top: 10px;
	margin-left: 10px;
}
.header_title {
	border: 5px #b0baec;
}
.header_title td {
	text-align: center;
	vertical-align: middle;
	font-family: 굴림, Gulim, AppleGothic, Seoul, Arial;
	border: 1px solid #b0baec;
	border-right: 0px;
	border-bottom: 0px;
	height: 30px;
}
.header_title td:LAST-CHILD {
	border-right: 1px solid #b0baec;
}
.body_content td {
	text-align: center;
	vertical-align: middle;
	font-family: 굴림, Gulim, AppleGothic, Seoul, Arial;
	border: 1px solid #b0baec;
	border-right: 0px;
	border-bottom: 0px;
	height: 30px;
}
.body_content td:LAST-CHILD {
	border-right: 1px solid #b0baec;
}
.detail_content {
	text-align: left !important;
	padding-left: 10px;
}

.title_bottom_nth, .title_bottom td {
	border-bottom: 1px solid #b0baec !important;
}

.last_content {
	padding-top: 15px;
}
</style>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}
	
//-->
</script>
</head>

<body leftmargin="15">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 사규관리 > <span class=style5>사내복장규정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>근무복장 규정(남성 직원 동일)</span></td>
        <td align=right><img src=/acar/images/center/arrow.gif align=absmiddle>&nbsp;2018년 06월 20일 제정</td>
    </tr>
</table>
<div class="table_div">
	<table width=70% border=0 cellspacing=0 cellpadding=0>
		<thead>
	     <tr class="header_title">
	     	<td colspan="2" class="title">구분</td>
	     	<td class="title" width=80>규정</td>
	     	<td class="title" width=80>예외규정</td>
	     	<td class="title">세부내용</td>
	     </tr>
	    </thead>
	    <tbody>
	    	<tr class="body_content">
	    		<td rowspan="4" class="title">상의</td>
	    		<td>Y셔츠</td>
	    		<td>○</td>
	    		<td></td>
	    		<td class="detail_content">색상, 긴팔, 반팔 제한 없음</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>T셔츠</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content">카라 유무와 관계 없이 착용 불가</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>정장</td>
	    		<td>○</td>
	    		<td></td>
	    		<td class="detail_content">소재 제한 없음</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>점퍼류</td>
	    		<td>X</td>
	    		<td>○</td>
	    		<td class="detail_content">비즈니스 룩에서 벗어나지 않는 차림새</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td rowspan="3" class="title">하의</td>
	    		<td>신사복바지</td>
	    		<td>○</td>
	    		<td></td>
	    		<td class="detail_content">기본핏만 착용 가능</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>청바지</td>
	    		<td>X</td>
	    		<td>○</td>
	    		<td class="detail_content">기본핏만 착용 가능 (슬림핏, 배기핏, 루즈핏 등, 과도한 탈색, 찢어진 바지는 착용불가)</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>면바지</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content">
	    		<td rowspan="5" class="title title_bottom_nth">신발</td>
	    		<td>정장구두</td>
	    		<td>○</td>
	    		<td></td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>로퍼</td>
	    		<td>X</td>
	    		<td>○</td>
	    		<td class="detail_content">비즈니스 룩에 한정</td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>스니커즈</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content">
	    		<td>운동화</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr class="body_content title_bottom">
	    		<td>샌들</td>
	    		<td>X</td>
	    		<td>X</td>
	    		<td class="detail_content"></td>
	    	</tr>
	    	<tr>
	    		<td colspan="5" class="last_content">
	    			※ 금요일, 연휴 전 근무일에는 주말 나들이를 위해 규정에서 벗어난 차림새 특히 주의 바랍니다.<br>
	    			※ 직군에 관계없이 모든 여직원은 상기 규정에 적용받지 않습니다.  
	    		</td>
	    	</tr>
	    </tbody>
	</table>
</div>
</body>
</html>