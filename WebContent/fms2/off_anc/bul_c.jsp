<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.common.*" %>
<jsp:useBean id="b_bean" class="acar.off_anc.BulBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int b_id = request.getParameter("b_id")==null?0:Util.parseInt(request.getParameter("b_id"));
	String s_b_id = request.getParameter("b_id")==null?"":request.getParameter("b_id");
	int count = 0;	
	
	String acar_id = ck_acar_id;
	
	OffBulDatabase oad = OffBulDatabase.getInstance();
	b_bean = oad.getBulBean(b_id);
	
	//조회수 증가
	oad.getHitAdd(b_id);
	
	//댓글리스트
	BulCommentBean bc_r [] = oad.getBulCommentList(b_id);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	CommonDataBase c_db = CommonDataBase.getInstance();	

	int size = 0;
	
	String content_code = "BULLETIN";
	String content_seq  = s_b_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	//2016-06-03 Text Editor 추가 -- ks.cho
	String content = b_bean.getContent();
	if(!content.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
		content = content.replaceAll("\r\n","<br/>");
	}
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='javascript'>
<!--
function UpDisp()
{
	var theForm = document.AncDispForm;
	theForm.action = 'bul_u.jsp';
//	theForm.target = 'd_content';	
	theForm.submit();
	
//	var SUBWIN="./bul_u.jsp?b_id=<%=b_id%>";	
//	window.open(SUBWIN, "AncReg", "left=100, top=100, width=850, height=650, scrollbars=yes");
		
}


//리스트 가기	
function go_to_list()
{
		var fm = document.AncDispForm;
				
		var auth_rw = fm.auth_rw.value;
	
		location = "bul_s_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&auth_rw="+auth_rw;
	
}	
	
function AncClose()
{
	
	self.close();
	window.close();
}
	
	//댓글 등록
function Comment_save(){
		var fm = document.AncDispForm;
		if(fm.b_id.value == ''){ 		alert('게시물 아이디가 없습니다.'); return; }		
//		if(fm.acar_id.value == ''){ 	alert('로그인된 아이디가 없습니다.'); return; }
		if(fm.comment.value == ''){ 	alert('댓글의 내용을 입력하십시오'); return; }
		fm.action = 'bul_comment_a.jsp';
		fm.target = 'i_no';
		fm.submit();
		
}


function scan_reg(){
		window.open("bul_reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=ck_acar_id%>&b_id=<%=b_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body onLoad="javascript:self.focus()">
<form action="./bul_u.jsp" name="AncDispForm" method="post" >
	<input type="hidden" name="user_id" value="<%=b_bean.getUser_id()%>">
	<input type="hidden" name="b_id" 	value="<%=b_id%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	
	<input type="hidden" name="cmd" 	value="">
<table border="0" cellspacing="0" cellpadding="0" width=800>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5> 사내 게시판 </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan='4' align='right'>
			<%if(acar_id.equals(b_bean.getUser_id())){%>	
		 	<a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0></a> 
			<%}%>
			<a href="javascript:AncClose()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align=absmiddle border=0></a></td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td class="title">작성자</td>
					<td align="center"><%=b_bean.getUser_nm()%></td>
					<td class="title">부서</td>
					<td align="center"><%=b_bean.getDept_nm()%></td>
				</tr>
				<tr>
					<td class="title" width="100">작성일</td>
					<td align="center" width="300"><%=b_bean.getReg_dt()%></td>
					<td class="title" width="100">만료일</td>
					<td align="center" width="300"><%=b_bean.getExp_dt()%></td>
				</tr>
				<tr>
					<td class="title">제목</td>
					<td colspan="3" >&nbsp;&nbsp;<%=b_bean.getTitle()%></td>
				</tr>	
			    <tr> 
	           		 <td align='center'class='title'>내용</td>
	           		 <td colspan="3" style="height:250" valign="top">
					    <table border=0 cellspacing=0 cellpadding=0 >
						<tr>
								<!--	<textarea name="content" cols="110" rows="20" readonly><%=b_bean.getContent()%></textarea> -->
							<td style="padding:10px;"><%=content%></td>
						</tr>
					  </table>
			        	</td>
	            </tr>
				<%if(attach_vt.size() > 0){%>
				<%for(int i=0; i< attach_vt.size(); i++){
                		Hashtable ht = (Hashtable)attach_vt.elementAt(i);       
                    %>
				<tr> 
					 <td align='center'class='title'>첨부파일<%=i+1%></td>
					 <td colspan="3" >&nbsp;&nbsp;
					 <%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>
					 <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><%=ht.get("FILE_NAME")%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 </td>
				</tr>
				<%}%>
				<%}else{%>
				<tr>
					<td align='center'class='title'>첨부파일</td>
					<td colspan="3" >&nbsp;&nbsp;<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
				</tr>
				<%}%>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
    </tr>
	
</table>
</form>


</body>
</html>

