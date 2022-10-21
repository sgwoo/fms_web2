<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ page import="acar.partner.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%

	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");

	CommonDataBase c_db = CommonDataBase.getInstance();	
	Serv_EmpDatabase se_db = Serv_EmpDatabase.getInstance();
			
	String off_id = "";
	off_id = se_db.getServOffId(bank_id);
	
	Vector vt = se_db.getServ_empList("", "", "1", "1", off_id, "1");
	int vt_size = vt.size();	
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--	
	function search_ok(off_id, emp_nm, seq){
		var fm = opener.document.form1;
		fm.off_id.value = off_id;
		fm.emp_nm.value = emp_nm;
		fm.seq.value = seq;

		window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>금융기관 대출담당자 조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=10%>연번</td>
                    <td width=30% class='title'>이름</td>
                    <td width=30% class='title'>부서</td>
                    <td width=30% class='title'>직급</td>
         
                </tr>
         <% for(int i=0; i< vt_size; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i); %>		  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:search_ok('<%=off_id%>', '<%=ht.get("EMP_NM")%>','<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true"><%=ht.get("EMP_NM")%></a></td>
                    <td><%=ht.get("DEPT_NM")%></td>
                    <td><%=ht.get("POS")%></td>          
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
