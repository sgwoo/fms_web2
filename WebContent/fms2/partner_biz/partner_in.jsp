<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="po_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	Vector conts = new Vector();
	int cont_size = 0;
	
	Vector vt = po_db.Partner_idps(s_kd, t_wd);
	int vt_size = vt.size();
	

%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>       
        <td class='line' width='100%'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		            <td width=10% class='title'>연번</td>
		            <td width=30% class='title'>상호</td>
					<td width=20% class='title'>특이사항</td>
		            <td class='title' width=15%>아이디</td>
		            <td class='title' width=15%>비밀번호</td>
		            <td class='title' width=10%>로그인</td>
          		</tr>
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
                <tr> 
                      <td align='center' width=10%><%=i+1%></td>
                      <td align='center' width=30%><a href="javascript:parent.BranchUpdate('<%=ht.get("PO_ID")%>')"><%=ht.get("PO_NM")%></a></td>
					  <td align='center' width=20%><%=ht.get("PO_NOTE")%></td>
                      <td align='center' width=15%><%=ht.get("PO_LOGIN_ID")%></td>
                      <td align='center' width=15%><%=ht.get("PO_LOGIN_PS")%></td>
                      <td align='center' width=10%>
            			  <a href="javascript:parent.getLogin2('<%=ht.get("PO_WEB")%>','<%=ht.get("PO_LOGIN_ID")%>','<%=ht.get("PO_LOGIN_PS")%>')"><img src=/acar/images/center/button_in_login.gif border=0 align=absmiddle></a>
            			  </td>
                </tr>
                <%	}
        		}else{%>
                <tr> 
                    <td align='center' colspan="5">해당 데이타가 없습니다.</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
	<%if(t_wd.equals("")){%>
	<tr>
		<td>* 검색단어로 조회하십시오.</td>
    </tr>
	<%}%>	
</table>
</body>
</html>
