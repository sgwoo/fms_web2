<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, cust.board.*"%>
<jsp:useBean id="b_db" scope="page" class="cust.board.BoardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
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
	
	
	
	//조회수 증가
	b_db.getHitAdd(bbs_st, bbs_id);
	
	BoardBean bean = b_db.getBoardCase(bbs_st, bbs_id);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
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
		location = "board_frame.jsp?member_id="+member_id+"&client_id="+client_id+"&r_site="+r_site+"&auth_rw="+auth_rw+"&gubun="+gubun+"&s_yy="+s_yy+"&s_mm="+s_mm+"&s_dd="+s_dd+"&s_kd="+s_kd+"&t_wd="+t_wd+"&idx="+idx;
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
	//답글쓰기
	function reReg(){
		var fm = document.form1;
		fm.cmd.value = 'r';
		fm.action = 'board_i.jsp';
		fm.submit();
	}	
		
//-->
</script>
</head>
<body leftmargin="15">

<form name='form1' method='post' action='board_c.jsp' target=''>
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

<table border="0" cellspacing="0" cellpadding="0" width=400>
	<tr> 
		<td> <img src="../menu/img/main/news_title.gif" width="264" height="25"></td>
	</tr>
	<tr> 
		<td align="right">&nbsp;</td>
	</tr>
	<tr> 
		<td class=line> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td width='60' class='title'>작성자</td>
					<td width='180' align="center"> 
						<%if(bbs_st.equals("1")){%>
						아마존카 
						<%}else if(bbs_st.equals("2")){%>
						<%=bean.getUser_nm()%><%=bean.getFirm_nm()%> 
						<%}%>
					</td>
					<td width='60' class='title'>조회수</td>
					<td width='100' align="center"><%=bean.getHit()%></td>
				</tr>
				<tr> 
					<td align='center'class='title' width="60">이메일</td>
					<td align="center" width="180"> 
						<%if(bbs_st.equals("1")){%>
						webmaster@amazoncar.co.kr 
						<%}else if(bbs_st.equals("2")){%>
						<%=bean.getUser_nm()%><%=bean.getEmail()%> 
						<%}%>
					</td>
					<td align='center'class='title' width="60">작성일자</td>
					<td align='center' width="100"><%=AddUtil.ChangeDate2(bean.getReg_dt())%></td>
				</tr>
				<tr> 
					<td align='center'class='title' width="60">제목</td>
					<td colspan="3">&nbsp;&nbsp;<%=bean.getTitle()%></td>
				</tr>
				<tr> 
					<td align='center'class='title' width="60">내용</td>
					<td colspan="3" align="center" valign="middle"> 
						<textarea name="content" cols="50" rows="15" readonly><%=bean.getContent()%></textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
		<td align="right" height="18"> <a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/center/button_close.gif"  aligh="absmiddle" border="0"></a> 
		</td>
	</tr>	
</table>
</form>
</body>
</html>
