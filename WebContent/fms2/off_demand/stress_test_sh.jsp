<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//관리현황
	Vector deb1s = ad_db.getStatDebtList("stat_rent_month");
	int deb1_size = deb1s.size();
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//하단페이지 보기
	function display_sc(st){
		var fm = document.form1;	
		fm.action = 'stress_test_sc'+st+'.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>FMS운영관리 > Admin > <span class=style5>스트레스 테스트</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
  <tr>
    <td class=h></td> 
  </tr>	
  <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						<select name="save_dt">
						<%	if(deb1_size > 0){
				    			for(int i = 0 ; i < deb1_size ; i++){
									StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);
									if(AddUtil.parseInt(AddUtil.replace(sd.getSave_dt(),"-","")) >= 20210930){
						%>		
							<option value="<%=sd.getSave_dt()%>"><%=sd.getSave_dt()%></option>		
						<%			}
								}
							}%>
						</select>            			      
					</td>
                </tr>
            </table>
        </td>
    </tr>
  <tr>
    <td align="center">
    	<input type="button" class="button" value="1.스트레스테스트" onclick="javascript:display_sc('1');">&nbsp;
    	<input type="button" class="button" value="2.CASH FLOW" onclick="javascript:display_sc('2');">&nbsp;
    	<input type="button" class="button" value="3.잔존가치 증빙 보안" onclick="javascript:display_sc('3');">&nbsp;
    	<input type="button" class="button" value="4.기타부채 및 기타자산" onclick="javascript:display_sc('4');">&nbsp;
    	<input type="button" class="button" value="5.인건비 및 관리비" onclick="javascript:display_sc('5');">&nbsp;
    	<input type="button" class="button" value="6.전분기대비" onclick="javascript:display_sc('6');">&nbsp;    	
    	<input type="button" class="button" value="7.전월대비" onclick="javascript:display_sc('7');">&nbsp;
    </td>
  </tr>
</table>
</form>
</body>
</html>
