<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	
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
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
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
	
		window.open("/acar/member/member_c.jsp?idx="+idx+"&client_id="+client_id+"&r_site="+r_site, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
		
	}
	
	//ID 등록
	function getRegMemberId(idx, client_id, r_site, member_id, pw){	
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;		
		var br_id = fm.br_id.value;
		var user_id = fm.user_id.value;
		var s_gubun1 = fm.s_gubun1.value;
		var s_gubun2 = fm.s_gubun2.value;
		var s_gubun3 = fm.s_gubun3.value;		
		var s_gubun4 = fm.s_gubun4.value;			
		var w = 430;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN="info_i.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&member_id="+member_id+"&client_id="+client_id+"&r_site="+r_site+"&pw="+pw+"&s_gubun1="+s_gubun1+"&s_gubun2="+s_gubun2+"&s_gubun3="+s_gubun3+"&s_gubun4="+s_gubun4;	
		window.open(SUBWIN, "InfoUp", "left="+winl+", top="+wint+", width="+w+", height="+h+", scrollbars=no");
		
	}
	
	//New 로그인
	function getLogin2(member_id, pwd){	
		var w = 450;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
// 		var SUBWIN="https://fms.amazoncar.co.kr/service/index.jsp?name="+member_id+"&passwd="+encodeURIComponent(pwd);	
// 		window.open(SUBWIN, "InfoUp1", "left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes");				
		
		var fm = document.form2;
		fm.memberId.value = member_id;
		fm.pwd.value = encodeURIComponent(pwd);
		fm.mode.value = '1';
// 		var SUBWIN="http://dev.amazoncar.co.kr/control/checkLogin";
		var SUBWIN="https://client.amazoncar.co.kr/control/fromFms";
		window.open('', 'popForm', 'left=5, top=5, width=1240, height=760, scrollbars=yes, status=yes, menubar=yes, toolbar=yes, resizable=yes');
		fm.action = SUBWIN;
		fm.method = 'POST';
		fm.target = 'popForm';
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
<form name='form2' method='post' novalidate>
	<input type='hidden' name='memberId' value="<%=member_id%>">
	<input type='hidden' name='pwd' value="">
	<input type='hidden' name='mode' value="">
</form>
<form name='form1' method='post' action='member_c.jsp' target='d_content'>
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
		<td colspan="2"><iframe src="member_sc_in.jsp?br_id=<%=br_id%>&user_id=<%=user_id%>&member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>&s_gubun1=<%=s_gubun1%>&s_gubun2=<%=s_gubun2%>&s_gubun3=<%=s_gubun3%>&s_gubun4=<%=s_gubun4%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&rent_cnt=<%=rent_cnt%>#<%=idx%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
	</tr>
</table>
</form>  
</body>
</html>
