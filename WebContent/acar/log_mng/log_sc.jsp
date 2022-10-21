<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

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
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String rent_cnt = request.getParameter("rent_cnt")==null?"":request.getParameter("rent_cnt");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-75;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//내용보기
	function getViewCont(idx, client_id, r_site, member_id){	
		var fm = document.form1;
		fm.idx.value = idx;
		fm.client_id.value = client_id;
		fm.r_site.value = r_site;
		fm.member_id.value = member_id;		
		fm.target = 'd_content';
		fm.submit();
	}
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' action='log_c.jsp' target='d_content'>
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
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name="rent_cnt" value="<%=rent_cnt%>">
<input type='hidden' name="idx" value="<%=idx%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class=line2></td>
	</tr> 
	<tr> 
		<td class='line'>	
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td width=5% class='title' rowspan="2">연번</td>
					<td width=13% class='title' rowspan="2">아이디</td>
					<td width=22% class='title' rowspan="2">상호</td>
					<td width=12% class='title' rowspan="2">계약자</td>
					<td class='title' rowspan="2" width=18%>사용본거지</td>
					<td class='title' colspan="2">최종로그인</td>
				</tr>
				<tr> 
					<td class='title' width=15%>&nbsp;&nbsp;&nbsp;일시&nbsp;&nbsp;&nbsp;</td>
					<td class='title' width=15%>&nbsp;&nbsp;IP&nbsp;&nbsp;</td>
				</tr>
			</table>
		</td>
        <td width='17'>&nbsp;</td>
	</tr
	<tr> 
		<td colspan="2"><iframe src="log_sc_in.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&s_gubun2=<%=s_gubun2%>&s_gubun3=<%=s_gubun3%>&s_gubun4=<%=s_gubun4%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&rent_cnt=<%=rent_cnt%>#<%=idx%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
	</tr>
</table>
</form>  
</body>
</html>
