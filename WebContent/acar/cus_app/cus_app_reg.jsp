<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_app.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	CusApp_Database ca_db = CusApp_Database.getInstance();
	CusAppBean caBn = ca_db.getCus_app(client_id);
	Hashtable ht = ca_db.getClientBase(client_id);
	
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function set(gubun){
	fm = document.form1;
	if(gubun=="i"){
		if(!confirm('등록 하시겠습니까?')){ return; }
	}else if(gubun=="u"){
		if(!confirm('수정 하시겠습니까?')){ return; }
	}
	fm.gubun.value = gubun;
	fm.action = "cus_app_reg_iu.jsp";
	fm.target = "i_no";
	fm.submit();
}	
-->
</script>
</head>

<body>
<form name='form1' method='post' action=''>
<input type="hidden" name="client_id" value="<%= client_id %>">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리> <span class=style5>고객평가관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td align=right><a href="javascript:history.back();"><img src="/acar/images/center/button_back_p.gif"  align="absbottom" border="0"></a></td>
    </tr>  	
    <tr> 
        <td colspan="2"><img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>외형</span></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr> 
        <td class=line colspan="2"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=10% rowspan="5">사무실</td>
                    <td class=title width=20%>&nbsp;</td>
                    <td width=70%>&nbsp; <input type="radio" name="aaa" value="1" <% if(caBn.getAaa().equals("1")) out.print("checked"); %>>
                      자가 
                      <input type="radio" name="aaa" value="2" <% if(caBn.getAaa().equals("2")) out.print("checked"); %>>
                      임차 
                      <input type="radio" name="aaa" value="3" <% if(caBn.getAaa().equals("3")) out.print("checked"); %>>
                      미파악</td>
                </tr>
                <tr> 
                    <td class=title>&nbsp;</td>
                    <td>&nbsp; <input type="radio" name="aab" value="1" <% if(caBn.getAab().equals("1")) out.print("checked"); %>>
                      대형빌딩 
                      <input type="radio" name="aab" value="2" <% if(caBn.getAab().equals("2")) out.print("checked"); %>>
                      소형빌딩 
                      <input type="radio" name="aab" value="3" <% if(caBn.getAab().equals("3")) out.print("checked"); %>>
                      기타</td>
                </tr>
                <tr> 
                    <td class=title>규모</td>
                    <td>&nbsp; <input type="text" name="aac" size="5" value="<%= caBn.getAac() %>">
                      평</td>
                </tr>
                <tr> 
                    <td class=title>환경</td>
                    <td>&nbsp; <input type="radio" name="aad" value="1" <% if(caBn.getAad().equals("1")) out.print("checked"); %>>
                      상 
                      <input type="radio" name="aad" value="2" <% if(caBn.getAad().equals("2")) out.print("checked"); %>>
                      중 
                      <input type="radio" name="aad" value="3" <% if(caBn.getAad().equals("3")) out.print("checked"); %>>
                      하</td>
                </tr>
                <tr> 
                    <td class=title>사무집기</td>
                    <td>&nbsp; <input type="radio" name="aae" value="1" <% if(caBn.getAad().equals("1")) out.print("checked"); %>>
                      상 
                      <input type="radio" name="aae" value="2" <% if(caBn.getAad().equals("2")) out.print("checked"); %>>
                      중 
                      <input type="radio" name="aae" value="3" <% if(caBn.getAad().equals("3")) out.print("checked"); %>>
                      하</td>
                </tr>
                <tr> 
                    <td class=title rowspan="4">공장</td>
                    <td class=title>&nbsp;</td>
                    <td>&nbsp; <input type="radio" name="aba" value="1" <% if(caBn.getAba().equals("1")) out.print("checked"); %>>
                      자가 
                      <input type="radio" name="aba" value="2" <% if(caBn.getAba().equals("2")) out.print("checked"); %>>
                      임차 
                      <input type="radio" name="aba" value="3" <% if(caBn.getAba().equals("3")) out.print("checked"); %>>
                      없음 
                      <input type="radio" name="aba" value="4" <% if(caBn.getAba().equals("4")) out.print("checked"); %>>
                      미파악</td>
                </tr>
                <tr> 
                    <td class=title>규모</td>
                    <td>&nbsp; <input type="text" name="abb" size="5" value="<%= caBn.getAbb() %>">
                      평</td>
                </tr>
                <tr> 
                    <td class=title>환경</td>
                    <td>&nbsp; <input type="radio" name="abc" value="1" <% if(caBn.getAbc().equals("1")) out.print("checked"); %>>
                      상 
                      <input type="radio" name="abc" value="2" <% if(caBn.getAbc().equals("2")) out.print("checked"); %>>
                      중 
                      <input type="radio" name="abc" value="3" <% if(caBn.getAbc().equals("3")) out.print("checked"); %>>
                      하</td>
                </tr>
                <tr> 
                    <td class=title>사무집기</td>
                    <td>&nbsp; <input type="radio" name="abd" value="1" <% if(caBn.getAbd().equals("1")) out.print("checked"); %>>
                      상 
                      <input type="radio" name="abd" value="2" <% if(caBn.getAbd().equals("2")) out.print("checked"); %>>
                      중 
                      <input type="radio" name="abd" value="3" <% if(caBn.getAbd().equals("3")) out.print("checked"); %>>
                      하</td>
                </tr>
                <tr> 
                    <td class=title rowspan="3">근무인원</td>
                    <td class=title>사무실</td>
                    <td>&nbsp; <input type="text" name="aca" size="5" value="<%= caBn.getAca() %>">
                      명</td>
                </tr>
                <tr> 
                    <td class=title>공장</td>
                    <td> &nbsp; <input type="text" name="acb" size="5" value="<%= caBn.getAcb() %>">
                      명</td>
                </tr>
                <tr> 
                    <td class=title>전월대비변동인원</td>
                    <td> &nbsp; <input type="text" name="acc" size="5" value="<%= caBn.getAcc() %>">
                      명</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2">자동차</td>
                    <td class=title>업무용자동차 보유대수</td>
                    <td>&nbsp; <input type="text" name="ada" size="5" value="<%= caBn.getAda() %>">
                      대</td>
                </tr>
                <tr> 
                    <td class=title>경쟁사이용차량수</td>
                    <td>&nbsp; <input type="text" name="adb" size="5" value="<%= caBn.getAdb() %>">
                      대</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>기초자료</span></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr> 
        <td class=line colspan="2"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=30%>개업년월일</td>
                    <td width=70%>&nbsp;&nbsp;<%= AddUtil.ChangeDate2((String)ht.get("OPEN_YEAR")) %>
                    </td>
                </tr>
                <tr> 
                    <td class=title>기초자본금</td>
                    <td>&nbsp;&nbsp;<%= AddUtil.parseDecimal((String)ht.get("FIRM_PRICE")) %> 백만원(<%= AddUtil.ChangeDate2((String)ht.get("FIRM_DAY")) %> 기준)</td>
                </tr>
                <tr> 
                    <td class=title>매출규모</td>
                    <td>&nbsp;&nbsp;<%= AddUtil.parseDecimal((String)ht.get("FIRM_PRICE_Y")) %> 백만원(<%= AddUtil.ChangeDate2((String)ht.get("FIRM_DAY_Y")) %> 기준)</td>
                </tr>
                <tr> 
                    <td class=title>업태</td>
                    <td>&nbsp;&nbsp;<%= ht.get("BUS_CDT") %> </td>
                </tr>
                <tr> 
                    <td class=title>업종</td>
                    <td>&nbsp;&nbsp;<%= ht.get("BUS_ITM") %> </td>
                </tr>
                <tr> 
                    <td class=title>최초거래개시일/경과년수</td>
                    <td>&nbsp;&nbsp;<%= AddUtil.ChangeDate2((String)ht.get("FIRST_RENT_DT")) %>
                     /<%= ht.get("YEAR_CNT") %> 년</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>호감도</span></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr> 
        <td class=line colspan="2"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title colspan="2">대표</td>
                    <td>&nbsp; <input type="radio" name="baa" value="1" <% if(caBn.getBaa().equals("1")) out.print("checked"); %>>
                      호의적 
                      <input type="radio" name="baa" value="2" <% if(caBn.getBaa().equals("2")) out.print("checked"); %>>
                      비호의적 
                      <input type="radio" name="baa" value="3" <% if(caBn.getBaa().equals("3")) out.print("checked"); %>>
                      보통 
                      <input type="radio" name="baa" value="4" <% if(caBn.getBaa().equals("4")) out.print("checked"); %>>
                      없음</td>
                </tr>
                <tr> 
                    <td class=title rowspan="4" width=10%>차량담당자</td>
                    <td class=title width=20%>부서</td>
                    <td width=70%>&nbsp; <input type="text" name="bba" size="10" value="<%= caBn.getBba() %>"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>성명</td>
                    <td>&nbsp; <input type="text" name="bbb" size="10" value="<%= caBn.getBbb() %>"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>호감도</td>
                    <td>&nbsp; <input type="radio" name="bbc" value="1" <% if(caBn.getBbc().equals("1")) out.print("checked"); %>>
                      호의적 
                      <input type="radio" name="bbc" value="2" <% if(caBn.getBbc().equals("2")) out.print("checked"); %>>
                      비호의적 
                      <input type="radio" name="bbc" value="3" <% if(caBn.getBbc().equals("3")) out.print("checked"); %>>
                      보통 
                      <input type="radio" name="bbc" value="4" <% if(caBn.getBbc().equals("4")) out.print("checked"); %>>
                      없음</td>
                </tr>
                <tr> 
                    <td class=title>기타특징</td>
                    <td>&nbsp; <input type="text" name="bbd" size="60" value="<%= caBn.getBbd() %>"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title rowspan="4">회계담당자</td>
                    <td class=title>부서</td>
                    <td>&nbsp; <input type="text" name="bca" size="10" value="<%= caBn.getBca() %>"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>성명</td>
                    <td>&nbsp; <input type="text" name="bcb" size="10" value="<%= caBn.getBcb() %>"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>호감도</td>
                    <td>&nbsp; <input type="radio" name="bcc" value="1" <% if(caBn.getBcc().equals("1")) out.print("checked"); %>>
                      호의적 
                      <input type="radio" name="bcc" value="2" <% if(caBn.getBcc().equals("2")) out.print("checked"); %>>
                      비호의적 
                      <input type="radio" name="bcc" value="3" <% if(caBn.getBcc().equals("3")) out.print("checked"); %>>
                      보통 
                      <input type="radio" name="bcc" value="4" <% if(caBn.getBcc().equals("4")) out.print("checked"); %>>
                      없음</td>
                </tr>
                <tr> 
                    <td class=title>기타특징</td>
                    <td>&nbsp; <input type="text" name="bcd" size="60" value="<%= caBn.getBcd() %>"> 
                    </td>
                </tr>
                  
                <tr> 
                    <td class=title rowspan="4">차량이용자</td>
                    <td class=title>부서</td>
                    <td>&nbsp; <input type="text" name="bda" size="10" value="<%= caBn.getBda() %>"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>성명</td>
                    <td>&nbsp; <input type="text" name="bdb" size="10" value="<%= caBn.getBdb() %>"> 
                    </td>
                </tr>
                <tr> 
                    <td class=title>호감도</td>
                    <td>&nbsp; <input type="radio" name="bdc" value="1" <% if(caBn.getBdc().equals("1")) out.print("checked"); %>>
                      호의적 
                      <input type="radio" name="bdc" value="2" <% if(caBn.getBdc().equals("2")) out.print("checked"); %>>
                      비호의적 
                      <input type="radio" name="bdc" value="3" <% if(caBn.getBdc().equals("3")) out.print("checked"); %>>
                      보통 
                      <input type="radio" name="bdc" value="4" <% if(caBn.getBdc().equals("4")) out.print("checked"); %>>
                      없음</td>
                </tr>
                <tr> 
                    <td class=title>기타특징</td>
                    <td>&nbsp; <input type="text" name="bdd" size="60" value="<%= caBn.getBdd() %>"> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>평가</span></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr> 
        <td class=line colspan="2"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=30%>결재</td>
                    <td width=70%>&nbsp; <input type="radio" name="caa" value="1" <% if(caBn.getCaa().equals("1")) out.print("checked"); %>>
                      원활 
                      <input type="radio" name="caa" value="2" <% if(caBn.getCaa().equals("2")) out.print("checked"); %>>
                      지체 
                      <input type="radio" name="caa" value="3" <% if(caBn.getCaa().equals("3")) out.print("checked"); %>>
                      불량 
                      <input type="radio" name="caa" value="4" <% if(caBn.getCaa().equals("4")) out.print("checked"); %>>
                      부도</td>
                </tr>
                <tr> 
                    <td class=title>성장성</td>
                    <td>&nbsp; <input type="radio" name="cbb" value="1" <% if(caBn.getCbb().equals("1")) out.print("checked"); %>>
                      매우양호 
                      <input type="radio" name="cbb" value="2" <% if(caBn.getCbb().equals("2")) out.print("checked"); %>>
                      양호 
                      <input type="radio" name="cbb" value="3" <% if(caBn.getCbb().equals("3")) out.print("checked"); %>>
                      보통 
                      <input type="radio" name="cbb" value="4" <% if(caBn.getCbb().equals("4")) out.print("checked"); %>>
                      불분명 
                      <input type="radio" name="cbb" value="5" <% if(caBn.getCbb().equals("5")) out.print("checked"); %>>
                      평가불가</td>
                </tr>
                <tr> 
                    <td class=title>거래확장가능성</td>
                    <td>&nbsp; <input type="radio" name="ccc" value="1" <% if(caBn.getCcc().equals("1")) out.print("checked"); %>>
                      매우양호 
                      <input type="radio" name="ccc" value="2" <% if(caBn.getCcc().equals("2")) out.print("checked"); %>>
                      양호 
                      <input type="radio" name="ccc" value="3" <% if(caBn.getCcc().equals("3")) out.print("checked"); %>>
                      보통 
                      <input type="radio" name="ccc" value="4" <% if(caBn.getCcc().equals("4")) out.print("checked"); %>>
                      불분명 
                      <input type="radio" name="ccc" value="5" <% if(caBn.getCcc().equals("5")) out.print("checked"); %>>
                      평가불가</td>
                </tr>
                <tr> 
                    <td class=title>종합적인 판단을 한다면?</td>
                    <td>&nbsp; <input type="radio" name="cdd" value="1" <% if(caBn.getCdd().equals("1")) out.print("checked"); %>>
                      최우수 
                      <input type="radio" name="cdd" value="2" <% if(caBn.getCdd().equals("2")) out.print("checked"); %>>
                      우수 
                      <input type="radio" name="cdd" value="3" <% if(caBn.getCdd().equals("3")) out.print("checked"); %>>
                      보통 
                      <input type="radio" name="cdd" value="4" <% if(caBn.getCdd().equals("4")) out.print("checked"); %>>
                      침체 
                      <input type="radio" name="cdd" value="5" <% if(caBn.getCdd().equals("5")) out.print("checked"); %>>
                      부실</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2" align="right"><% if(caBn.getClient_id().equals("")){ %> <a href="javascript:set('i')"><img src="/acar/images/center/button_reg.gif"  align="absbottom" border="0"></a> 
        <% }else{ %> <a href="javascript:set('u')"><img src="/acar/images/button_modify.gif"  align="absbottom" border="0"></a> 
        <% } %></td>
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
