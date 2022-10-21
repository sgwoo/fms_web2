<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_scrap.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5><%=car_no%> 차량번호 이력리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td style='height:15'></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border=0 cellspacing=1 width=100%>
                <tr> 
                    <td class=title width="4%">연번</td>
                    <td class=title width="9%">연식+카운터</td>
                    <td class=title width="4%">지역</td>
                    <td class=title width="17%">차대번호</td>
                    <td class=title width="20%">차명</td>
                    <td class=title width="8%">사용시작일</td>
                    <td class=title width="8%">변경일자</td>
                    <td class=title width="30%">비고</td>
                </tr>
                <%//계약이력
        			Vector scrs = sc_db.getCar_no_history(car_no);
        			int scr_size = scrs.size();
        			if(scr_size > 0){		
        				for(int i = 0 ; i < scr_size ; i++){
        				Hashtable scr = (Hashtable)scrs.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=scr.get("CAR_L_CD")%></td>
                    <td align="center"><%=scr.get("CAR_EXT")%></td>
                    <td align="center"><%=scr.get("CAR_NUM")%></td>
                    <td align="center"><%=scr.get("CAR_NM")%></td>
                    <td align="center"><%=scr.get("CHA_DT")%></td>
                    <td align="center"><%=sc_db.getEnd_cha_dt(String.valueOf(scr.get("CAR_MNG_ID")), String.valueOf(scr.get("CHA_SEQ")))%></td>
                    <td align="center"><%=scr.get("CHA_CAU")%><%=scr.get("CHA_CAU_SUB")%></td>
                </tr>
                <%		}%>
                <%	}else{%>
                <tr> 
                    <td colspan=9 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
                <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</body>
</html>
