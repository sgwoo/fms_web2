<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		if(parseDigit(fm.pp_s_amt.value).length == 0)
		{	alert('월대여료를 확인하십시오');	return;	}
		fm.target='i_no';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
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
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String p_st = request.getParameter("p_st")==null?"":request.getParameter("p_st");
	int size = request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "01");
	
	//기본정보
	Hashtable fee = af_db.getFeebase(m_id, l_cd);
	
	String brch_id = String.valueOf(fee.get("BRCH_ID"));
%>
<form name='form1' action='/fms2/con_grt/grt_scd_i_a.jsp' method='post' target=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='p_st' value='<%=p_st%>'>
<input type='hidden' name='size' value='<%=size%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > 선수금 관리 > <span class=style5><%if(p_st.equals("0")){%>보증금<%}else if(p_st.equals("1")){%>선납금<%}else{%>개시대여료<%}%> 회차추가</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
			        <td class=line2></td>
			    </tr>
				<tr>
					<td class='line'>						 
                        <table border="0" cellspacing="1" cellpadding="0" width=380>
                            <tr> 
                              <td width=20% class='title'>회차</td>
                              <td width=30%>&nbsp; 
                                <input type='text' name='pp_tm' size='2' value='<%=size+1%>' class='text'>
                              </td>
                              <td width=20% class='title'>입금예정일</td>
                              <td width=30%>&nbsp;
                                <input type='text' name='pp_est_dt' size='12' maxlength='12' value='' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'>
                              </td>
                            </tr>
                            <tr> 
                              <td class='title'>공급가</td>
                              <td>&nbsp; 
                                <input type='text' name='pp_s_amt' size='10' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                                원&nbsp;</td>
                              <td class='title'>부가세</td>
                              <td>&nbsp; 
                                <input type='text' name='pp_v_amt' size='10' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
                                원&nbsp;</td>
                            </tr>
                        </table>
				    </td>
		        </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'>&nbsp;</td>
	</tr>
	<tr>
		<td align='right'>
		<%if(br_id.equals("S1") || br_id.equals(brch_id)){%> 
        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		
		  <a href="javascript:save()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_plus.gif align=absmiddle border=0></a>
		<%	}%>
		<%}%>
		  &nbsp;<a href="javascript:window.close()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>