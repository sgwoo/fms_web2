<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.end_cont.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.end_cont.End_ContDatabase"/>
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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	Vector memos = new Vector();
	
	memos = ec_db.getEndContMemo(m_id, l_cd);
		
	int memo_size = memos.size();
		
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%	if(memo_size > 0){
			for(int i = 0 ; i < memo_size ; i++){
				End_ContBean memo = (End_ContBean)memos.elementAt(i);%>
                <tr>
        		  <td width='15%' align='center'><%=c_db.getNameById(memo.getReg_id(), "USER")%></td>
        		  <td width='15%' align='center'><%=AddUtil.ChangeDate2(memo.getReg_dt())%></td>
        		  <td width='15%' align='center'><%=c_db.getNameById(memo.getRe_bus_id(), "USER")%></td>					
                  <td width='55%'>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                    <%=Util.htmlBR(memo.getContent())%></td>
                            </tr>
                        </table>
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
