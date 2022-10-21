<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 	= request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int total_su = 0;
	long total_amt = 0;
	long rtn_amt = 0;
	
	Vector taxs = t_db.getTaxMngList(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, gubun7, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int tax_size = taxs.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">

<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=1100>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
	<td class='line' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td class='title'>품명</td>
		    <td class='title'>규격</td>
		    <td class='title'>단위</td>
		    <td class='title'>이월량</td>
		    <td class='title'>제조량</td>
		    <td class='title'>계</td>
		    <td class='title'>판매</td>
		    <td class='title'>자가소비</td>
		    <td class='title'>계</td>
		    <td class='title'>자가소비</td>
		    <td class='title'>미납세</td>
		    <td class='title'>수출면세</td>
		    <td class='title'>외국군납면세</td>
		    <td class='title'>외교관면세</td>
		    <td class='title'>외국인전용판매장면세</td>
		    <td class='title'>조건부면세</td>
		    <td class='title'>무조건면세</td>
		    <td class='title'>그밖의면세</td>		    
		    <td class='title'>계</td>		    
		    <td class='title'>합계</td>		    
		    <td class='title'>남은양</td>		    
		</tr>
		<%if(tax_size > 0){%>
            	<%	for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);%>
                <tr> 
                    <td align='center'><%=tax.get("CAR_NO")%></td>
                    <td align='center'>0</td>
                    <td align='center'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                </tr>
                <tr> 
                    <td align='center'>소계</td>
                    <td align='center'>0</td>
                    <td align='center'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>0</td>
                    <td align='right'>1</td>
                    <td align='right'>0</td>
                </tr>                
                <%}}%>
            </table>
      </td>
</table>
</form>
</body>
</html>
