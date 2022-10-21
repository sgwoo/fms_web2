<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>

<%@ include file="/acar/cookies.jsp" %>

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
	String prop_id = request.getParameter("prop_id")==null?"":request.getParameter("prop_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String re_seq = request.getParameter("re_seq")==null?"":request.getParameter("re_seq");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
		
	Vector memos = p_db.getEvalMemo(prop_id, seq,  re_seq , user_id);
	int memo_size = memos.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=400>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(memo_size > 0){
		for(int i = 0 ; i < memo_size ; i++){
			Hashtable ht = (Hashtable)memos.elementAt(i);%>
				
	            <tr>
        		    <td width='20%' align='center'><%=ht.get("USER_NM")%></td>        		
        		    <td width='68%'><%=Util.parseDecimal(String.valueOf(ht.get("E_AMT")))%>    
		            </td>
		        </tr>
<%		}
	}else{%>
		        <tr>
		            <td colspan='4' align='center'>등록된 데이타가 없습니다 </td>
		        </tr>
<%	}%>
	        </table>
	    </td>
    </tr>
</table>
</body>
</html>
