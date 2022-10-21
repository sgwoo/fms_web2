<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//수금현황
	Vector fees = ac_db.getAgentFeeStat();
	int fee_size = fees.size();	
	
	int total_cnt[]  = new int[6];
	long total_amt[] = new long[6];
					
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//세부리스트
	function view_list(car_off_id, gubun){
		window.open('incoming_agent_list.jsp?car_off_id='+car_off_id+'&gubun='+gubun, "STAT_LIST", "left=0, top=0, width=900, height=568, scrollbars=yes, status=yes, resize");
	}
//-->
</script>
</head>

<body leftmargin=15>

<form name='form1' method='post' action='incoming_agent.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 영업사원관리 > <span class=style5>수금현황(에이전트)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <!--
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 현황</span></td>
    </tr>
    -->
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width="3%" rowspan="3" align="center" class='title'>연번</td>
                    <td rowspan="3" width="11%" class='title' align="center">성명/상호</td>
                    <td width="7%" rowspan="3" align="center" class='title'>최초영업일</td>
                    <td colspan="2" align="center" class='title'>영업현황(누적)</td>
                    <td width="4%"  rowspan="3" align="center" class='title'>연체율</td>
                    <td colspan="10" align="center" class='title'>연체기간별 현황 </td>
                </tr>
                <tr>
                  <td width="3%"  rowspan="2" align="center" class='title'>건수</td>
                  <td width="10%"  rowspan="2" align="center" class='title'>총대여료<br>(미도래+미수금)</td>
                  <td colspan="2" align="center" class='title'>1월이내</td>
                  <td colspan="2" align="center" class='title'>1월이상</td>
                  <td colspan="2" align="center" class='title'>2월이상</td>
                  <td colspan="2" align="center" class='title'>3월이상</td>
                  <td colspan="2" align="center" class='title'>합계</td>
                </tr>
                <tr align="center">
                    <td width="3%" class='title'>건수</td> 
                    <td width="10%" class='title'>금액</td>
                    <td width="3%" class='title'>건수</td> 
                    <td width="9%" class='title'>금액</td>
                    <td width="3%" class='title'>건수</td> 
                    <td width="9%" class='title'>금액</td>
                    <td width="3%" class='title'>건수</td> 
                    <td width="9%" class='title'>금액</td>
                    <td width="3%" class='title'>건수</td> 
                    <td width="10%" class='title'>금액</td>
                </tr>
                <%if(fee_size > 0){
			for (int i = 0 ; i < fee_size ; i++){
				Hashtable ht = (Hashtable)fees.elementAt(i);
				
				int cnt[]  = new int[6];
				long amt[] = new long[6];
				
				cnt[0] = AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
				amt[0] = AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
				
				cnt[1] = AddUtil.parseInt(String.valueOf(ht.get("CNT2")));								
				amt[1] = AddUtil.parseLong(String.valueOf(ht.get("AMT2")));

				cnt[2] = AddUtil.parseInt(String.valueOf(ht.get("CNT3")));
				amt[2] = AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
				
				cnt[3] = AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
				amt[3] = AddUtil.parseLong(String.valueOf(ht.get("AMT4")));

				cnt[4] = AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
				amt[4] = AddUtil.parseLong(String.valueOf(ht.get("AMT5")));

				cnt[5] = AddUtil.parseInt(String.valueOf(ht.get("CNT6")));
				amt[5] = AddUtil.parseLong(String.valueOf(ht.get("AMT6")));

				
				total_cnt[0] 	= total_cnt[0] + cnt[0];
				total_cnt[1] 	= total_cnt[1] + cnt[1];
				total_cnt[2] 	= total_cnt[2] + cnt[2];
				total_cnt[3] 	= total_cnt[3] + cnt[3];
				total_cnt[4] 	= total_cnt[4] + cnt[4];
				total_cnt[5] 	= total_cnt[5] + cnt[5];
	
				total_amt[0] 	= total_amt[0] + amt[0];
				total_amt[1] 	= total_amt[1] + amt[1];
				total_amt[2] 	= total_amt[2] + amt[2];
				total_amt[3] 	= total_amt[3] + amt[3];
				total_amt[4] 	= total_amt[4] + amt[4];
				total_amt[5] 	= total_amt[5] + amt[5];
				
				%>
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("CAR_OFF_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(ac_db.getAgentFirstRentDt(String.valueOf(ht.get("CAR_OFF_ID"))))%></td>
                    <td align='center'><a href="javascript:view_list('<%=ht.get("CAR_OFF_ID")%>','1')"><%=cnt[0]%></a></td>
                    <td align='right'><%=Util.parseDecimal(amt[0])%></td>
                    <td align='center'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("DLY_PER")),2)%></td>
                    <td align='center'><a href="javascript:view_list('<%=ht.get("CAR_OFF_ID")%>','2')"><%=cnt[1]%></a></td>
                    <td align='right'><%=Util.parseDecimal(amt[1])%></td>
                    <td align='center'><a href="javascript:view_list('<%=ht.get("CAR_OFF_ID")%>','3')"><%=cnt[2]%></a></td>
                    <td align='right'><%=Util.parseDecimal(amt[2])%></td>
                    <td align='center'><a href="javascript:view_list('<%=ht.get("CAR_OFF_ID")%>','4')"><%=cnt[3]%></a></td>
                    <td align='right'><%=Util.parseDecimal(amt[3])%></td>
                    <td align='center'><a href="javascript:view_list('<%=ht.get("CAR_OFF_ID")%>','5')"><%=cnt[4]%></a></td>
                    <td align='right'><%=Util.parseDecimal(amt[4])%></td>
                    <td align='center'><a href="javascript:view_list('<%=ht.get("CAR_OFF_ID")%>','6')"><%=cnt[5]%></a></td>
                    <td align='right'><%=Util.parseDecimal(amt[5])%></td>                                  
                </tr>
                <%	}%>
                <tr>
                    <td class='title' colspan='3'>합계</td>
                    <td class='title'><%=total_cnt[0]%></td>
		    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt[0])%></td>
		    <td class='title'>&nbsp;</td>
		    <td class='title'><%=Util.parseDecimal(total_cnt[1])%></td>										
		    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt[1])%></td>	                              
		    <td class='title'><%=Util.parseDecimal(total_cnt[2])%></td>										
		    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt[2])%></td>	                              
		    <td class='title'><%=Util.parseDecimal(total_cnt[3])%></td>										
		    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt[3])%></td>	                              
		    <td class='title'><%=Util.parseDecimal(total_cnt[4])%></td>
		    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt[4])%></td>	                              
		    <td class='title'><%=Util.parseDecimal(total_cnt[5])%></td>										
		    <td class='title' style='text-align:right;'><%=Util.parseDecimal(total_amt[5])%></td>	                              
                </tr>                
        	<%}else{%>
                <tr> 
                    <td colspan="16" align="center">자료가 없습니다.</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>
