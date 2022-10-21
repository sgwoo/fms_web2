<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		document.form1.submit();
	}
	
	function cookieset(x){
//	 	SetCookie(x.name, x.value);
	}
	function SetCookie(cName, cValue){
		document.cookie = cName+"="+escape(cValue); 		
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<%
	String s_rtn 	= request.getParameter("s_rtn")==null?"":request.getParameter("s_rtn");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	String max_cltr_rat = request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat");
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	String rtn_size = request.getParameter("rtn_size")==null?"":request.getParameter("rtn_size");
%>
<form name='form1' action='bank_mapping_sc.jsp' target='p_foot' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='max_cltr_rat' value='<%=max_cltr_rat%>'>
<input type='hidden' name='rtn_st' value='<%=rtn_st%>'>
<input type='hidden' name='lend_amt_lim' value='<%=lend_amt_lim%>'>
<input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=3>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp; <span class=style1>재무회계 > 구매자금관리 > 은행대출관리 ><span class=style5>은행별 할부 리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td width=35%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_etc.gif align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>		  
              <option value="" <%if(s_kd.equals(""))%>selected<%%>>전체</option>
            </select>
            <input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            </td>
	    <%if(!rtn_st.equals("0")){%>	
        <td width=14%>&nbsp;<img src=../images/center/arrow_sangh.gif align=absmiddle>&nbsp;
            <select name='s_rtn' onchange="cookieset(this);">
              <option value="" <%if(s_rtn.equals(""))%>selected<%%>>전체</option>		
    		<%for(int i=1; i<=Integer.parseInt(rtn_size); i++){%>
              <option value="<%=i%>" <%if(s_rtn.equals(Integer.toString(i)))%>selected<%%>><%=i%>차</option>
    		<%}%>
            </select>
        </td>
	    <%}else{%><input type='hidden' name='s_rtn' value=''><%}%>
        <td><a href='javascript:search()'><img src=../images/center/button_search.gif align=absmiddle border=0></a></td>
        </tr>
  </table>
</form>
</body>
</html>