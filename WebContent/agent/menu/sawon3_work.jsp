<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.partner.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="po_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	UsersBean user1 	= umd.getUsersBean(nm_db.getWorkAuthUser("심사"));
	UsersBean user2 	= umd.getUsersBean(nm_db.getWorkAuthUser("차량대금기안자"));
	UsersBean user3 	= umd.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	UsersBean user4 	= umd.getUsersBean(nm_db.getWorkAuthUser("대전보험담당"));
	UsersBean user5 	= umd.getUsersBean(nm_db.getWorkAuthUser("본사주차장관리"));
	UsersBean user6 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리"));
	UsersBean user7 	= umd.getUsersBean(nm_db.getWorkAuthUser("에이전트관리2"));
	UsersBean user8 	= umd.getUsersBean(nm_db.getWorkAuthUser("차량등록자"));
	

	UsersBean user_r [] = umd.getUserAllSostel("", "0020", "");
	
	Vector vt = po_db.PartnerAll("", "", "", "", "", "");
	int vt_size = vt.size();		
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>무제 문서</title>
<style type=text/css>
<!--
.style1 {color: #848484}
.style2 {color: #424242}
.style3 {
	color: #0a3489;
	font-weight: bold;
}
-->
</style>
<script language="JavaScript">
<!--
//-->
</script>
<script language='JavaScript' src='/include/common.js'></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>
<body>
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td align=center>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>아마존카 업무 연락망</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <!--  영업기획팀 시작 -->
   
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
					      <td width=16% class=title>구분</td>
					      <td width=20% class=title>업체</td>
            		<td width=8% class=title>직급</td>
            		<td width=8% class=title>성명</td>
            		<td width=12% class=title>휴대폰</td>
            		<td width=12% class=title>전화</td>
               	<td width=24% class=title>비고</td>
            	</tr>
            	<tr>
            		<td align="center">심사</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user1.getUser_pos()  %></td>
            		<td align=center><%=user1.getUser_nm() %></td>
            		<td align=center><%=user1.getUser_m_tel()%></td>
            		<td align=center><%=user1.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>            	
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
				<%if(user_bean.getUser_id().equals("000077") || user_bean.getUser_id().equals("000144")){%>
            	<tr>
            		<td align="center">업무지원</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user_bean.getUser_pos()  %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center><%= user_bean.getUser_m_tel()%></td>
            		<td align=center><%= user_bean.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>
				<%}%>
<%}%>
            	<tr>
            		<td align="center">업무지원</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user6.getUser_pos()  %></td>
            		<td align=center><%=user6.getUser_nm() %></td>
            		<td align=center><%=user6.getUser_m_tel()%></td>
            		<td align=center><%=user6.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>
            	<tr>
            		<td align="center">업무지원</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user7.getUser_pos()  %></td>
            		<td align=center><%=user7.getUser_nm() %></td>
            		<td align=center><%=user7.getUser_m_tel()%></td>
            		<td align=center><%=user7.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>            	
            	<tr>
            		<td align="center">차량대금결제</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user2.getUser_pos()  %></td>
            		<td align=center><%=user2.getUser_nm() %></td>
            		<td align=center><%=user2.getUser_m_tel()%></td>
            		<td align=center><%=user2.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>
				<tr>
					<td align=center>차량등록</td>
					<td align=center>아마존카</td>
            		<td align=center><%=user8.getUser_pos()  %></td>
            		<td align=center><%=user8.getUser_nm() %></td>
            		<td align=center><%=user8.getUser_m_tel()%></td>
            		<td align=center><%=user8.getHot_tel() %></td>
					<td>&nbsp;</td>
				</tr>
            	<tr>
            		<td align="center">세금계산서</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user3.getUser_pos()  %></td>
            		<td align=center><%=user3.getUser_nm() %></td>
            		<td align=center><%=user3.getUser_m_tel()%></td>
            		<td align=center><%=user3.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>    
            	<tr>
            		<td align="center">보험</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user4.getUser_pos()  %></td>
            		<td align=center><%=user4.getUser_nm() %></td>
            		<td align=center><%=user4.getUser_m_tel()%></td>
            		<td align=center><%=user4.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>      
            	<tr>
            		<td align="center">주차장 신차인수</td>
            		<td align="center">아마존카</td>
            		<td align=center><%=user5.getUser_pos()  %></td>
            		<td align=center><%=user5.getUser_nm() %></td>
            		<td align=center><%=user5.getUser_m_tel()%></td>
            		<td align=center><%=user5.getHot_tel() %></td>
            		<td align=center></td>
            	</tr>                	            	  
            </table>
        </td>
    </tr>
    <!--  영업기획팀 끝 -->
    
    <tr>
		<td>&nbsp;</td>
	</tr>
     <!--  협력업체 시작 -->
	<tr>
    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>협력업체</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>    
    <tr>
        <td class=line>    
			<table border=0 cellspacing=1 width=100%>
				<tr>
					<td width=16% class=title>구분</td>
					<td width=20% class=title>업체</td>
            		<td width=16% class=title>직급/성명</td>
            		<td width=12% class=title>휴대폰</td>
            		<td width=12% class=title>전화</td>
               		<td width=24% class=title>비고</td>
				</tr>
				
				<tr>
					<td align=center>용품업체(서울)</td>
					<td align=center>다옴방</td>
					<td align=center>대표 조존복</td>
					<td align=center>010-5218-2164</td>
					<td align=center>02-2068-7582</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>용품업체(대전)</td>
					<td align=center>(주)미성테크</td>
					<td align=center>실장 최동호</td>
					<td align=center>010-9386-0990</td>
					<td align=center>042-488-2437</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>용품업체(대구)</td>
					<td align=center>아시아나상사</td>
					<td align=center>대표 박종학</td>
					<td align=center>010-3509-9435</td>
					<td align=center>053-587-1550</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>용품업체(광주)</td>
					<td align=center>용용이자동차용품점</td>
					<td align=center>대표 양선례</td>
					<td align=center>010-5414-5710</td>
					<td align=center>062-453-5710</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>용품업체(부산)</td>
					<td align=center>스마일TS</td>
					<td align=center>대표 이문희</td>
					<td align=center>010-2000-8018</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>용품업체(제주도)</td>
					<td align=center>루마제주연동점</td>
					<td align=center>대표 진명수</td>
					<td align=center>010-2693-4851</td>
					<td align=center>064-749-4851</td>
					<td>&nbsp;주소: 제주시 일주서로 7818</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>탁송업체</td>
					<td align=center>(주)아마존탁송</td>
					<td align=center>대표 조순희</td>
					<td align=center>010-7302-8839</td>
					<td align=center>02-2644-2225</td>
					<td>&nbsp;070-8868-2227 정미옥 주임    직통</td>
				</tr>
				<tr>
					<td align=center>탁송업체</td>
					<td align=center>일등전국탁송</td>
					<td align=center>대표 김충용</td>
					<td align=center>&nbsp;</td>
					<td align=center>1800-2612</td>
					<td>&nbsp;대구/부산/광주 (에프엔티코리아)</td>
				</tr>
				<tr>
					<td align=center>탁송업체</td>
					<td align=center>하이카콤(대전)</td>
					<td align=center>대표 임명식</td>
					<td align=center>010-2890-0802</td>
					<td align=center>042-639-1230</td>
					<td>&nbsp;대전탁송</td>
				</tr>
				<tr>
					<td align=center>탁송업체</td>
					<td align=center>퍼스트드라이브</td>
					<td align=center>대표 박영진</td>
					<td align=center>010-4449-7986</td>
					<td align=center>010-4449-7986</td>
					<td>&nbsp;대전탁송(콜 전화도 대표자에게 전화달라고 요청)</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>자체탁송업체 (캐리어)</td>
					<td align=center>상원물류㈜(구 영원물류)</td>
					<td align=center>부장 박연수</td>
					<td align=center>010-3262-5080</td>
					<td align=center>02-2277-7265</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>자체탁송업체 (캐리어)</td>
					<td align=center>㈜삼진특수</td>
					<td align=center>부장 신동식</td>
					<td align=center>010-4311-3882</td>
					<td align=center>031-288-0995</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>긴급출동</td>
					<td align=center>마스타 자동차관리</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>1588-6688</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>긴급출동</td>
					<td align=center>삼성애니카랜드</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>02-2119-3117</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td align=center>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>보험사</td>
					<td align=center>렌터카공제조합</td>
					<td align=center>사고접수</td>
					<td align=center>&nbsp;</td>
					<td align=center>1661-7977</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align=center>보험사</td>
					<td align=center>동부화재</td>
					<td align=center>사고접수</td>
					<td align=center>&nbsp;</td>
					<td align=center>1588-0100</td>
					<td>&nbsp;</td>
				</tr>
			</table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>    
</body>
</html>
