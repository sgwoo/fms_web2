<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, cust.member.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String rent_cnt = request.getParameter("rent_cnt")==null?"":request.getParameter("rent_cnt");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	ClientBean client = al_db.getClient(client_id);
	
	MemberBean bean = m_db.getMemberCase(client_id, r_site, member_id);	
	
	String r_site_nm = "";
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_to_list()
	{
		var fm = document.form1;
		var br_id = fm.br_id.value;
		var user_id = fm.user_id.value;
		var member_id = fm.member_id.value;
		var client_id = fm.client_id.value;			
		var r_site	= fm.r_site.value;								
		var auth_rw = fm.auth_rw.value;
		var s_gubun1 = fm.s_gubun1.value;
		var s_gubun2 = fm.s_gubun2.value;
		var s_gubun3 = fm.s_gubun3.value;		
		var s_gubun4 = fm.s_gubun4.value;
		var rent_cnt= fm.rent_cnt.value;		
		var idx 	= fm.idx.value;	
		location = "log_frame.jsp?br_id="+br_id+"&user_id="+user_id+"&member_id="+member_id+"&client_id="+client_id+"&r_site="+r_site+"&auth_rw="+auth_rw+"&s_gubun1="+s_gubun1+"&s_gubun2="+s_gubun2+"&s_gubun3="+s_gubun3+"&s_gubun4="+s_gubun4+"&rent_cnt="+rent_cnt+"&idx="+idx;
	}
	
	//검색하기
	function search(){
		var fm = document.form1;
		fm.target="inner";
		fm.action="log_c_in.jsp";		
		fm.submit();
	}

	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_gubun1" value="<%=s_gubun1%>">
<input type='hidden' name="s_gubun2" value="<%=s_gubun2%>">
<input type='hidden' name="s_gubun3" value="<%=s_gubun3%>">
<input type='hidden' name="s_gubun4" value="<%=s_gubun4%>">
<input type='hidden' name="rent_cnt" value="<%=rent_cnt%>">
<input type='hidden' name="idx" value="<%=idx%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > 로그인정보 > <span class=style5>로그인내역</span></span></td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
    <tr> 
        <td align='right'> 
        <!--
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
		<%}%>-->
        <a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="../images/center/button_list.gif"  aligh="absmiddle" border="0"></a> 
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'> ID</td>
                    <td width='23%'>&nbsp; <%=bean.getMember_id()%></td>
                    <td class='title' width='10%'>상호</td>
                    <td width='23%'>&nbsp; <%=client.getFirm_nm()%></td>
                    <td class='title' width='10%'>계약자</td>
                    <td width="24%">&nbsp; <%=client.getClient_nm()%></td>
                </tr>
		  <%if(!r_site_nm.equals("")){%>
                <tr> 
                    <td class='title' width='10%'> 사용본거지</td>
                    <td colspan="5">&nbsp; <%=r_site_nm%></td>
                </tr>
		  <%}%>		  
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jusi.gif align=absmiddle>
            &nbsp;<select name='s_yy'>
              <option value="">전체</option>
              <%for(int i=2004; i<=AddUtil.getDate2(1); i++){%>
              <option value="<%=i%>" <%if(AddUtil.parseInt(s_yy) == i){%>selected<%}%>><%=i%>년</option>
              <%}%>
            </select>
            <select name='s_mm' onChange='javascript:search();'>
              <option value="">전체</option>
              <%for(int i=1; i<=12; i++){%>
              <option value="<%=i%>" <%if(AddUtil.parseInt(s_mm) == i){%>selected<%}%>><%=i%>월</option>
              <%}%>
            </select>
            <a href='javascript:search();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_search.gif"  align=absmiddle  border="0"></a> 
        </td>
    </tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
	    <td>
	        <table width=100% border=0 cellspacing=0 cellpadding=0>
	            <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td class='title' width=8%>연번</td>
                                <td class='title' width=25%>로그인</td>
                                <td class='title' width=25%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;로그아웃&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td class='title' width=42%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=17>&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan=2><iframe src="log_c_in.jsp?member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&s_yy=<%=s_yy%>&s_mm=<%=s_mm%>" name="inner" width="100%" height="550" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>
