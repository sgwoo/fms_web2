<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
<%@ page import="acar.cont.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String memo_st = request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	String gov_nm = client.getFirm_nm();
	
	Vector fines = new Vector();
	int fine_size = 0;
	
	if(memo_st.equals("client")){
		fines = FineDocDb.getFineDocLists("채권추심", "", "", "", "", "", "", "", "", "1", gov_nm, "", "");
		fine_size = fines.size();
	}else{
		fines = FineDocDb.getFineDocLists("채권추심", "", "", "", "", "", "", "", "", "3", l_cd, "", "");
		fine_size = fines.size();
	}
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(fine_size > 0){
		for(int i = 0 ; i < fine_size ; i++){
				Hashtable ht = (Hashtable)fines.elementAt(i);%>
		        <tr>
        		    <td width='17%' align='center'><%=ht.get("DOC_ID")%></td>
        		    <td width='15%' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
        		    <td width='40%' align='center'><%=ht.get("TITLE")%></td>
        		    <td width='14%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT")))%></td>
        		    <td width='10%' align='center'><a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=ht.get("FILENAME")%>" target="_blank"><img src=/acar/images/center/button_in_see.gif border=0 align=absmiddle></a></td>					
		        	<td width='4%' align='center'>
						<% if (ht.get("F_RESULT").equals("1")) { %>
						<span title="<%=ht.get("F_REASON_NM")%>">반송</span>
						<%}else if (ht.get("F_RESULT").equals("2")) { %>
						<span title="<%=ht.get("F_REASON_NM")%>">도착</span>
						<% } else { %>&nbsp;<% } %></td>
		        </tr>
	<%		}
	}else{%>
		        <tr>
		            <td colspan='6' align='center'>등록된 데이타가 없습니다 </td>
		        </tr>
<%	}%>
	        </table>
	    </td>
    </tr>
</table>
</body>
</html>

