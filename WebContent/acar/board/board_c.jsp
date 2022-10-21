<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, cust.board.*"%>
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
	
	//계약상세내역 보기
	function getViewCont(bbs_st, bbs_id){
		var fm = document.form1;
		fm.bbs_st.value = bbs_st;
		fm.bbs_id.value = bbs_id;
		fm.action = 'board_c.jsp';
		fm.submit();
	}
	
	//수정하기
	function update(){
		var fm = document.form1;
		fm.cmd.value = 'u';
		fm.action = 'board_i.jsp';
		fm.submit();
	}	
	//댓글 등록
function Comment_save(){
		var fm = document.form1;
		if(fm.bbs_id.value == ''){ 		alert('게시물 아이디가 없습니다.'); return; }		
		if(fm.reply_content.value == ''){ 	alert('댓글의 내용을 입력하십시오'); return; }
		fm.cmd.value = "r";
//		fm.target="i_no";
		fm.action = 'board_c.jsp';
		fm.submit();
	}
//-->
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' action='board_c.jsp' target=''>
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
<input type='hidden' name="cmd" value="">

<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > <span class=style5><%if(bbs_st.equals("1")){%>
						공지사항 
						<%}else if(bbs_st.equals("2")){%>
						건의함 
						<%}%>
						상세내역</span></span></td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr> 
		<td align="right">
			<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
				<a href='javascript:update();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_modify.gif"  aligh="absmiddle" border="0"></a>
			<%}%>
				<a href='javascript:go_to_list();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_list.gif"  aligh="absmiddle" border="0"></a>
		</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td width='100' class='title'>작성자</td>
					<td width='300'>&nbsp;&nbsp;
						<%if(bbs_st.equals("1")){%>
						아마존카 
						<%}else if(bbs_st.equals("2")){%>
						<%=bean.getUser_nm()%><%=bean.getFirm_nm()%> 
						<%}%>
					</td>
					<td width='100' class='title'>조회수</td>
					<td width='300'>&nbsp;&nbsp;<%=bean.getHit()%></td>
				</tr>
				<tr> 
					<td align='center'class='title'>이메일</td>
					<td>&nbsp;&nbsp; 
						<%if(bbs_st.equals("1")){%>
						webmaster@amazoncar.co.kr 
						<%}else if(bbs_st.equals("2")){%>
						<%=bean.getUser_nm()%><%=bean.getEmail()%> 
						<%}%>
					</td>
					<td align='center'class='title'>작성일자</td>
					<td>&nbsp;&nbsp;<%=AddUtil.ChangeDate2(bean.getReg_dt())%></td>
				</tr>
				<tr> 
					<td align='center'class='title'>제목</td>
					<td colspan="3">&nbsp;&nbsp;<%=bean.getTitle()%></td>
				</tr>
				<tr> 
					<td align='center'class='title'>내용</td>
					<td colspan="3" align="center" valign="middle"> 
						<textarea name="content" cols="110" rows="20" readonly><%=bean.getContent()%></textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
		<td align="right" height="18">
		<%if(gubun.equals("2")){%>
		<a href='javascript:update();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
		<a href='javascript:reReg();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/images/reply.gif"  aligh="absmiddle" border="0"></a>
		<%}%>
		</td>
	</tr>	
		<%	if(bbs_st.equals("2")){
		Vector conts = b_db.getBoardList(bbs_st, bean.getRef());
		int cont_size = conts.size();
		if(cont_size > 1){%>
		<%     		for(int i = 0 ; i < cont_size ; i++){
		Hashtable cont = (Hashtable)conts.elementAt(i);%>
	<tr>
		<td> 
			<%if(i == 0){%>
				<img src="../../images/arrow2.gif" width="12" height="9"><font color="#993399"><font color="#333366">관련글</font></font> 
			| 
			<%}else{%>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<%for(int j=0; j<AddUtil.parseInt(String.valueOf(cont.get("RE_LEVEL"))); j++){ out.println("&nbsp;&nbsp;"); }%>
				<img src="../../images/cust/rei.gif" width="25" height="9">&nbsp; 
			<%}%>
				<a href="javascript:getViewCont('<%=cont.get("BBS_ST")%>','<%=cont.get("BBS_ID")%>');"><%=cont.get("TITLE")%></a>
		</td>
	</tr>
<%}}}%>		
	<tr>
		<td></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;<img src=http://211.52.73.67/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>댓글달기</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class="line">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td align="center">
						<textarea name="reply_content" cols="100" rows="5" class="default"></textarea></td>
					<td width="13%" align="center"><a href="javascript:Comment_save()"><img src="http://211.52.73.67/acar/images/center/button_in_reg.gif" align=absmiddle border=0></a></td>
				</tr>
					<input type='hidden' name='reply_content' value=''>	
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
