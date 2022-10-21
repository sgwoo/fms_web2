<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	Vector fines = FineDocDb.getFineDocLists("총무", br_id, gubun1, gubun2, gubun3, "", "L", st_dt, end_dt, s_kd, t_wd, sort, asc);
	int fine_size = fines.size();
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//검색하기	
	function search(){
		var fm = document.form1;
		fm.action = "find_doc_search.jsp";		
		fm.submit();	
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search_ok(doc_id, gov_id, gov_nm, end_dt){
			
		var fm2 = document.form1;	
		fm2.doc_id.value = doc_id;
		fm2.target = "d_content";
		fm2.action = "debt_scd_reg_i.jsp";		
		fm2.submit();

		/*
		var fm = opener.document.form1;
		fm.doc_id.value = doc_id;
		fm.cpt_cd.value = gov_id;
		fm.bank_nm.value = gov_nm;
		fm.lend_dt.value = end_dt;				
		*/
		
		window.close();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="doc_id" value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>대출공문조회</span></span></td>
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
                    <td class='title' width=12%>연번</td>
                    <td width=23% class='title'>문서번호</td>
                    <td width=25% class='title'>금융사명</td>
                    <td width=25% class='title'>대출일</td>
                    <td width=15% class='title'>건수</td>
         
                </tr>
          <%for(int i = 0 ; i < fine_size ; i++){
			Hashtable ht = (Hashtable)fines.elementAt(i);%>
						  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:search_ok('<%=ht.get("DOC_ID")%>','<%=ht.get("GOV_ID")%>', '<%=ht.get("GOV_NM")%>', '<%=ht.get("END_DT")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a></td>
                    <td><%=ht.get("GOV_NM")%></a>
                    <td><%=AddUtil.getDate3(String.valueOf(ht.get("END_DT")))%></td>
                    <td><%=ht.get("CNT")%>건</td>
          
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
