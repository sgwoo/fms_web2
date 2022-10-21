<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, cust.board.*, cust.member.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<jsp:useBean id="b_db" scope="page" class="cust.board.BoardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String bbs_st = request.getParameter("bbs_st")==null?"":request.getParameter("bbs_st");
	String bbs_id = request.getParameter("bbs_id")==null?"":request.getParameter("bbs_id");
	
	
	
	BoardBean bean = b_db.getBoardCase(bbs_st, bbs_id);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//리스트 가기	
	function go_to_list()
	{
		var fm = document.form1;
		var member_id = fm.member_id.value;
		var client_id = fm.client_id.value;			
		var r_site	= fm.r_site.value;								
		var auth_rw = fm.auth_rw.value;
		var gubun 	= fm.gubun.value;		
		var s_yy 	= fm.s_yy.value;
		var s_mm 	= fm.s_mm.value;
		var s_dd 	= fm.s_dd.value;		
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var idx 	= fm.idx.value;	
		location = "board_frame<%=gubun%>.jsp?member_id="+member_id+"&client_id="+client_id+"&r_site="+r_site+"&auth_rw="+auth_rw+"&gubun="+gubun+"&s_yy="+s_yy+"&s_mm="+s_mm+"&s_dd="+s_dd+"&s_kd="+s_kd+"&t_wd="+t_wd+"&idx="+idx;
	}	
	
	//등록/수정
	function save(){
		var fm = document.form1;
		if(fm.title.value  == ''){ alert('제목을 입력하십시오'); fm.title.focus(); return;}
		if(fm.content.value  == ''){ alert('내용을 입력하십시오'); fm.content.focus(); return;}		
		fm.target = "i_no";
		fm.submit();
	}	
//-->
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' action='board_null.jsp' target=''>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="gubun" value="<%=gubun%>">
<input type='hidden' name="s_yy" value="<%=s_yy%>">
<input type='hidden' name="s_mm" value="<%=s_mm%>">
<input type='hidden' name="s_dd" value="<%=s_dd%>">
<input type='hidden' name="s_kd" value="<%=s_kd%>">
<input type='hidden' name="t_wd" value="<%=t_wd%>">
<input type='hidden' name="idx" value="<%=idx%>">
<input type='hidden' name="bbs_st" value="<%=bbs_st%>">
<input type='hidden' name="bbs_id" value="<%=bbs_id%>">
<input type='hidden' name="ref" value="<%=bean.getRef()%>">
<input type='hidden' name="re_level" value="<%=bean.getRe_level()%>">
<input type='hidden' name="re_step" value="<%=bean.getRe_step()%>">
<input type='hidden' name="cmd" value="<%=cmd%>">

<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > <span class=style5>
							<%if(gubun.equals("1")){%>
						공지사항 
						<%}else if(gubun.equals("2")){%>
						건의함 
						<%}%>
						<%if(cmd.equals("i")){%>
						등록 
						<%}else if(cmd.equals("u")){%>
						수정 
						<%}else if(cmd.equals("r")){%>
						답글쓰기
						<%}%></span></span>
					</td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr> 
		<td align="right"><a href='javascript:go_to_list();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_list.gif" aligh="absmiddle" border="0"></a></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line> 
			<table border="0" cellspacing="1" cellpadding="3" width='100%'>
				<%if(cmd.equals("u")){%>
				<tr> 
					<td width='12%' class='title'>작성자</td>
					<td width='38%'> 
						<%if(bbs_st.equals("1")){%>
						&nbsp;아마존카 
						<%}else if(bbs_st.equals("2")){%>
						<%=bean.getUser_nm()%><%=bean.getFirm_nm()%> 
						<%}%>
					</td>
					<td width='12%' class='title'>조회수</td>
					<td width='38%'>&nbsp;<%=bean.getHit()%></td>
				</tr>
				<tr> 
					<td align='center'class='title'>이메일</td>
					<td>&nbsp; 
						<input type="text" name="email" value="<%=bean.getEmail()%>" size="45" class=text>
					</td>
					<td align='center'class='title'>작성일자</td>
					<td align='center'><%=AddUtil.ChangeDate2(bean.getReg_dt())%></td>
				</tr>
				<tr> 
					<td align='center'class='title'>제목</td>
					<td colspan="3">&nbsp; 
						<input type="text" name="title" value="<%=bean.getTitle()%>" size="100" class=text>
					</td>
				</tr>
				<tr> 
					<td align='center'class='title'>내용</td>
					<td colspan="3" valign="middle">&nbsp; 
						<textarea name="content" cols="110" rows="20"><%=bean.getContent()%></textarea>
					</td>
				</tr>
					<%}else{%>
				<tr> 
					<td width='12%' class='title'>작성자</td>
					<td width='38%'>&nbsp;아마존카</td>
					<td width='12%' class='title'>작성일자</td>
					<td width='38%'>&nbsp;<%=AddUtil.getDate()%></td>
				</tr>
				<tr> 
					<td align='center'class='title' width="100">이메일</td>
					<td colspan="3">&nbsp; 
						<input type="text" name="email" value="아마존카" size="45" class=text>
					</td>
				</tr>
				<tr> 
					<td align='center'class='title' width="100">제목</td>
					<td colspan="3">&nbsp; 
						<input type="text" name="title" value="<%//=bean.getTitle()%>" size="100" class=text>
					</td>
				</tr>
				<tr> 
					<td align='center'class='title' width="100">내용</td>
					<td colspan="3" valign="middle">&nbsp; 
						<textarea name="content" cols="110" rows="20"><%//=bean.getContent()%></textarea>
					</td>
				</tr>
					<%}%>
					<%if(cmd.equals("r")){%>
				<tr> 
					<td align='center'class='title' width="100">상위글 제목</td>
					<td colspan="3">&nbsp; <%=bean.getTitle()%></td>
				</tr>
				<tr> 
					<td align='center'class='title' width="100">상위글 내용</td>
					<td colspan="3">&nbsp; <%=bean.getContent()%></td>
				</tr>
					<%}%>
			</table>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr> 
		<td align="right"><a href='javascript:save();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><%if(!cmd.equals("u")){%><img src="../images/center/button_reg.gif" aligh="absmiddle" border="0"><%}else{%><img src="../images/center/button_modify.gif" aligh="absmiddle" border="0"><%}%></a> 
			<a href='javascript:document.form1.reset();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_cancel.gif" aligh="absmiddle" border="0"></a> 
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
