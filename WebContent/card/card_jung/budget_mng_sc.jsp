<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="card.*" %>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
		
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
		
	String byear = request.getParameter("byear")==null?Util.getDate().substring(0,4):request.getParameter("byear");
	String bgubun = request.getParameter("bgubun")==null?"1":request.getParameter("bgubun");
		
	Vector vt = CardDb.getUserBudgetAll(byear, bgubun);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
    long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    long t_amt10[] = new long[1];
    long t_amt11[] = new long[1];
    long t_amt12[] = new long[1];
    long t_amt13[] = new long[1];
    long t_amt14[] = new long[1];
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>사용자관리</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--

function UserBudget(job_st)
{
	
	var SUBWIN="./user_budget_iwol.jsp?job_st="+job_st;	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=450, height=400, scrollbars=no");
}

function UserAdd()
{
	
	var SUBWIN="./user_budget_i.jsp?cmd=i&auth_rw=<%=auth_rw%>";	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=450, height=400, scrollbars=no");
}

function UserUpdate(user_id, byear, bgubun)
{
	
	var SUBWIN="../card_jung/info_u.jsp?user_id="+user_id+"&byear="+byear+"&bgubun="+bgubun;	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=550, height=400, scrollbars=no");
}

function etc()
{
	
	var SUBWIN="./budget_etc.html";	
	window.open(SUBWIN, "UserDisp", "left=100, top=100, width=430, height=400, scrollbars=no");
}

//-->
</script>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0  width=100%>

	<tr>
        <td align="right">
        <a href="javascript:etc()">특이사항</a>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
 		&nbsp;<a href="javascript:UserAdd()"><img src="/acar/images/center/button_reg_syjys.gif" align="absmiddle" border="0"></a>
        &nbsp;<a href="javascript:UserBudget('1')"><img src="/acar/images/center/button_niw.gif" align="absmiddle" border="0"></a>
        &nbsp;<a href="javascript:UserBudget('2')"><img src="/acar/images/center/button_jj_m.gif" align="absmiddle" border="0"></a>
		
<%	}%>
        </td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>
        <td class=line>
            <table border=0 cellpadding=0 cellspacing=1 width=100%>
            	
            	<tr>
            		<td width=3% class=title>연번</td>
            		<td width=7% class=title>부서</td>
            		<td width=6% class=title>직급</td>
            		<td width=5% class=title>이름</td>
            		<td width=5% class=title>이월</td>
            		<td width=5% class=title>1월 </td>
            		<td width=5% class=title>2월 </td>
            		<td width=5% class=title>3월 </td>
            		<td width=5% class=title>4월 </td>
            		<td width=6% class=title>5월 </td>
            		<td width=5% class=title>6월 </td>
            		<td width=5% class=title>7월 </td>
            		<td width=5% class=title>8월 </td>
            		<td width=5% class=title>9월 </td>
            		<td width=6% class=title>10월 </td>
            		<td width=5% class=title>11월 </td>
            		<td width=5% class=title>12월 </td>
            		<td width=7% class=title>계</td>
            	</tr>
<%
    for(int i=0; i < vt_size; i++){
       Hashtable ht = (Hashtable)vt.elementAt(i);
       
       	for(int j=0; j<1; j++){
					    t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("PRV")));
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("JAN")));
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("FEB")));
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("MAR")));
						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("APR")));
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("MAY")));
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("JUN")));
						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("JUL")));
						t_amt9[j] += AddUtil.parseLong(String.valueOf(ht.get("AUG")));
						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("SEP")));
						t_amt11[j] += AddUtil.parseLong(String.valueOf(ht.get("OCT")));
						t_amt12[j] += AddUtil.parseLong(String.valueOf(ht.get("NOV")));
						t_amt13[j] += AddUtil.parseLong(String.valueOf(ht.get("DEC")));
						t_amt14[j] += AddUtil.parseLong(String.valueOf(ht.get("PRV")))+ AddUtil.parseLong(String.valueOf(ht.get("JAN")))+ AddUtil.parseLong(String.valueOf(ht.get("FEB"))) + AddUtil.parseLong(String.valueOf(ht.get("MAR")))+ AddUtil.parseLong(String.valueOf(ht.get("APR")))+ AddUtil.parseLong(String.valueOf(ht.get("MAY"))) + AddUtil.parseLong(String.valueOf(ht.get("JUN"))) + AddUtil.parseLong(String.valueOf(ht.get("JUL")))+ AddUtil.parseLong(String.valueOf(ht.get("AUG"))) + AddUtil.parseLong(String.valueOf(ht.get("SEP"))) + AddUtil.parseLong(String.valueOf(ht.get("OCT")))+ AddUtil.parseLong(String.valueOf(ht.get("NOV"))) + AddUtil.parseLong(String.valueOf(ht.get("DEC")));
						
		}
		
		long tot = 0;
     	tot = AddUtil.parseLong(String.valueOf(ht.get("PRV")))+ AddUtil.parseLong(String.valueOf(ht.get("JAN")))+ AddUtil.parseLong(String.valueOf(ht.get("FEB"))) + AddUtil.parseLong(String.valueOf(ht.get("MAR")))+ AddUtil.parseLong(String.valueOf(ht.get("APR")))+ AddUtil.parseLong(String.valueOf(ht.get("MAY"))) + AddUtil.parseLong(String.valueOf(ht.get("JUN"))) + AddUtil.parseLong(String.valueOf(ht.get("JUL")))+ AddUtil.parseLong(String.valueOf(ht.get("AUG"))) + AddUtil.parseLong(String.valueOf(ht.get("SEP"))) + AddUtil.parseLong(String.valueOf(ht.get("OCT")))+ AddUtil.parseLong(String.valueOf(ht.get("NOV"))) + AddUtil.parseLong(String.valueOf(ht.get("DEC")));
						
%>
            	<tr>
            		<td align="center"><%= i+1%></td>
            		<td align=center><%= ht.get("DEPT_NM")%></td>
            		<td align=center><%= ht.get("USER_POS")%></td>
            		<td align=center>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>            		
            		<a href="javascript:UserUpdate('<%= ht.get("USER_ID") %>', '<%=byear%>', '<%=bgubun%>')">
<%	}%>
					<%= ht.get("USER_NM") %></a>
            		</td>
            		<td align=right><%= Util.parseDecimal(ht.get("PRV"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("JAN"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("FEB"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("MAR"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("APR"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("MAY"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("JUN"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("JUL"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("AUG"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("SEP"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("OCT"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("NOV"))%></td>
            		<td align=right><%= Util.parseDecimal(ht.get("DEC"))%></td>
            		<td align=right><%= Util.parseDecimal(tot)%></td>
            	</tr>
<%}%>
<% if(vt_size > 0) { %>
					<tr>
            		<td class=title colspan=4 align="center"> 합계 </td>
            	   	<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt1[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt2[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt3[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt4[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt5[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt6[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt7[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt8[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt9[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt10[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt11[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt12[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt13[0])%></td>
            		<td class=title style="text-align:right; font-size:8pt"><%= Util.parseDecimal(t_amt14[0])%></td>
            	</tr>
<%}%> 
<% if(vt_size == 0) { %>
            <tr>
                <td colspan=18 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>  
            </table>
        </td>
    </tr>
</table>
</body>
</html>