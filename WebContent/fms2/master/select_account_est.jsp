<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		fm.work_st.value = work_st;
		fm.target = 'i_no';
		fm.action = 'autowork_a.jsp';
		fm.submit();
	}
	
	function popup(url)
	{
		var fm = document.form1;
				
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}	
	
	function popup2(url, s_var)
	{
		var fm = document.form1;
		fm.s_var.value = s_var;		
		fm.target = '_blank';
		fm.action = url;
		fm.submit();
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_var' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>

	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>입출금예정관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

 
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 지출예정 - <b>할부금 (원금+이자)</b> : 예상월 <input type='text' size='11' name='debt_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)%>'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_account_est_debt_list.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(연번 | 일자 | 금액)
           &nbsp;&nbsp;
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 지출예정 - <b>보험료</b> : 예상월 <input type='text' size='11' name='ins_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)%>'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_account_est_ins_list.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(연번 | 일자 | 금액)
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 입금/예정 - <b>대여료</b> : 예상월 <input type='text' size='11' name='fee_end_dt' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)%>'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_account_est_fee_list2.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(일자 | CMS | CMS외 기타 | 합계 --- 전전월,전월,당월)
	</td>
  </tr>
  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td> 
  </tr>
  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%>
  <tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. 약정스케줄 - <b>할부금 (원금)</b> : 예상월 <input type='text' size='11' name='debt_end_dt2' maxlength='10' class='default' value='<%=AddUtil.getDate(1)+"-"+AddUtil.getDate(2)%>'>
	       &nbsp;&nbsp;<a href="javascript:popup('select_account_est_debt_list2.jsp')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
		   &nbsp;&nbsp;(연번 | 일자 | 금액)
		   &nbsp;&nbsp;약정일 기준 (공휴일,주말 처리전)

	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <%} %>
  <tr>
	<td>&nbsp;</td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
