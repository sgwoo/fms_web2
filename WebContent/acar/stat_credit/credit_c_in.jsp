<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_credit.*"%>
<jsp:useBean id="cr_db" scope="page" class="acar.stat_credit.CreditDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	int total_su = 0;
	long total_amt = 0;	
	
	Vector cre_scd = cr_db.getCreditScd(m_id, l_cd);
	int cre_scd_size = cre_scd.size();
%>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='tot_tm' value='<%=cre_scd_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%if(cre_scd_size>0){
				for(int i = 0 ; i < cre_scd_size ; i++){
					Hashtable cre = (Hashtable)cre_scd.elementAt(i);
					String credit = (String)cre.get("CREDIT");%>
                <tr> 
                    <td align='center' width=10%><%=i+1%></td>
                    <td align='center' width=15%><%=cre.get("CLS_GUBUN")%></td>
                    <td align='center' width=15%><%=cre.get("CREDIT_ST")%></td>
                    <td align='center' width=15%><%=cre.get("TM")%><%=cre.get("TM_ST")%>회</td>
                    <td align='right' width=21%><%=Util.parseDecimal(String.valueOf(cre.get("AMT")))%>원&nbsp;&nbsp;</td>
                    <td align='center' width=12%> 
        			  <%if(br_id.equals("S1") || br_id.equals(brch_id)){%>
                      <%	if((auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) && credit.equals("2")){%>
                      <a href="javascript:parent.change_scd('c', '<%=cre.get("CLS_GUBUN")%>', '<%=cre.get("RENT_ST")%>', '<%=cre.get("TM")%>', '<%=cre.get("TM_ST")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_cancel.gif" align="absmiddle" border="0"></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                      <%}%>			  
                    </td>
                    <td align='center' width=12%> 
        			  <%if(br_id.equals("S1") || br_id.equals(brch_id)){%>
                      <%	if((auth_rw.equals("5") || auth_rw.equals("6")) && credit.equals("2")){%>
                      <a href="javascript:parent.change_scd('d', '<%=cre.get("CLS_GUBUN")%>', '<%=cre.get("RENT_ST")%>', '<%=cre.get("TM")%>', '<%=cre.get("TM_ST")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a> 
                      <%	}else{%>
                      - 
                      <%	}%>
                      <%}%>			  
                    </td>
                </tr>
          <%
				total_su = total_su + 1;
				total_amt = total_amt + Long.parseLong(String.valueOf(cre.get("AMT"))); 
		  		}%>
                <tr> 
                    <td class='title'>합계</td>
                    <td class='title'>건수</td>
                    <td class='title'><%=total_su%>건</td>
                    <td class='title'>금액</td>
                    <td class='title' colspan="3"><%=Util.parseDecimal(total_amt)%>원</td>
                </tr>
          <%	}else{%>
                <tr> 
                    <td colspan='7' align='center'>미수채권 스케줄이 없습니다 </td>
                </tr>
          <%}%>
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
