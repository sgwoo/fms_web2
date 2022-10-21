<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.common.*, acar.user_mng.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="bc_bean" class="acar.off_anc.BbsCommentBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int bbs_id = request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	int count = 0;	
	String s_bbs_id = request.getParameter("bbs_id")==null?"":request.getParameter("bbs_id");
	String acar_id = ck_acar_id;

	String end_yn = ""; //결재완료
	String com_st = "" ;  // 추가
	String bbs_st = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	OffAncDatabase oad = OffAncDatabase.getInstance();

	//공지사항 한건 조회
	a_bean = oad.getAncBean(bbs_id);
	//읽기체크
	count = oad.readChkAnc(bbs_id, acar_id);

	//조회수 증가
//	oad.getHitAdd(bbs_id);
	
	//댓글리스트
	BbsCommentBean bc_r [] = oad.getBbsCommentList(bbs_id);
	
	
		//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	CommonDataBase c_db = CommonDataBase.getInstance();	

	int size = 0;
	
	String content_code = "BBS";
	String content_seq  = s_bbs_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

	var popObj = null;
	
	
	//댓글 등록
function Comment_save(){
		var fm = document.AncDispForm;
		if(fm.bbs_id.value == ''){ 		alert('게시물 아이디가 없습니다.'); return; }		
		if(fm.acar_id.value == ''){ 	alert('로그인된 아이디가 없습니다.'); return; }
		if(fm.comment.value == ''){ 	alert('댓글의 내용을 입력하십시오'); return; }
		fm.action = 'anc_comment_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}

function UpDisp()
{
	var fm = document.AncDispForm;
	
	fm.action = '/fms2/off_anc/anc_u.jsp?ck_acar_id=<%=acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>';
	fm.submit();
}

//팝업창 닫기
function AncClose(){
	self.close();
}

//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr/data/bulletin/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
		file_down_history();	
	}
	//파일다운이력
	function file_down_history(){
		var fm = document.AncDispForm;
		fm.action = 'http://fms1.amazoncar.co.kr/acar/off_anc/file_down_history.jsp?file_nm=<%//= a_bean.getAtt_file1() %>&user_id=<%=acar_id%>';
		fm.target = 'i_no';
		fm.submit();		
	}
	
	//스캔등록
function scan_reg(){
		window.open("/fms2/off_anc/anc_reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=acar_id%>&bbs_id=<%=bbs_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body onLoad="javascript:self.focus()">
<form  name="AncDispForm" method="post">
	<input type="hidden" name="user_id" value="<%=a_bean.getUser_id()%>">
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="acar_id" value="<%=acar_id%>">

	<input type="hidden" name="cmd" value="">
<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5> 공지사항</span></span></td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	
	<tr>
		<td colspan='4' align='right'>
		<%	if(acar_id.equals(a_bean.getUser_id()) || nm_db.getWorkAuthUser("전산팀",acar_id) ){%>	
		 <a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src="../images/center/button_modify.gif" align=absmiddle border=0></a> 
		<%	}%>
		<a href="javascript:AncClose()" onMouseOver="window.status=''; return true"><img src="../images/center/button_close.gif" align=absmiddle border=0></a>&nbsp;</td>
	</tr>

	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="0" width="100%">
			<tr>
				<td class="title" colspan="2">현재 등록된 카테고리</td>
				<td align="center" colspan="2"><b>
				<%if(a_bean.getBbs_st().equals("1")){%>일반공지
				<%}else if(a_bean.getBbs_st().equals("2")){%>최근뉴스
				<%}else if(a_bean.getBbs_st().equals("3")){%>판매조건
				<%}else if(a_bean.getBbs_st().equals("4")){%>업무협조
				<%}else if(a_bean.getBbs_st().equals("5")){%>경조사
				<%}else if(a_bean.getBbs_st().equals("6")){%>규정 및 인사
				<%}%> 
				</b></td>
			</tr>
			<tr>
				<td class="title" width=15%>작성자</td>
				<td width=25%>&nbsp;&nbsp;<%=a_bean.getUser_nm()%></td>
				<td class="title" width=15%>부서</td>
				<td width=45%>&nbsp;&nbsp;<%=a_bean.getDept_nm()%></td>
				
			</tr>
			<tr>
				<td class="title">작성일</td>
				<td>&nbsp;&nbsp;<%=a_bean.getReg_dt()%></td>
				<td class="title">만료일</td>
				<td>&nbsp;&nbsp;<%=a_bean.getExp_dt()%></td>
			</tr>
			<tr>
				<td align="center" class="title">제목</td>
				<td align="center" colspan="3">
				<%if(a_bean.getRead_yn().equals("Y")){%> <img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp; <%}%> <%=a_bean.getTitle()%></td>
			</tr>
			<tr>
				<td class="title">내용</td>
				<td colspan="3" style="height:200" valign="top">
					<table border=0 cellspacing=0 cellpadding=0 >
						<tr>
							<td align="center">&nbsp;&nbsp;<textarea name="content" cols='74' rows='20'><%=a_bean.getContent()%></textarea></td>
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
					 <a href="javascript:openPop('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
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
					<%	if(acar_id.equals(a_bean.getUser_id()) || nm_db.getWorkAuthUser("전산팀",acar_id)){%>	
					<td colspan="3" >&nbsp;&nbsp;<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
					<%}%>
				</tr>
				<%}%>
		</table>

	</td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
    </tr>

	<%if(bc_r.length >0){%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공지에 대한 의견</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class="line"><table border="0" cellspacing="1" cellpadding="0" width=100%>
        <tr>
          <td width=15% class="title">작성자</td>
          <td class="title">내용</td>
          <td width=15% class="title">등록일</td>
        </tr>
		<%	for(int i=0; i<bc_r.length; i++){
	        	bc_bean = bc_r[i];
				String cont = AddUtil.replace(bc_bean.getContent(),"\\","&#92;&#92;");
				cont = AddUtil.replace(cont,"\"","&#34;");
				cont = Util.htmlR(cont);
				
			//if(bc_bean.getReg_id().equals("000003"))
			//		end_yn="Y";
				
		%>
        <tr>
          <td align="center"><%=bc_bean.getUser_nm()%></td>
          <td>
            <table width=100% border=0 cellspacing=0 cellpadding=3>
                <tr>
                    <td><%=cont%></td>
                </tr>
            </table>
          </td>
          <td align="center"><%=bc_bean.getReg_dt()%></td>
        </tr>
		<%	}%>
      </table></td>
    </tr>
	<%}%>
	
	<tr>
		<td></td>
	</tr>
	<tr>
		<td></td>
	</tr>
	<%// 결재 정보 시작   : 결재대기 - N, 결재완료 - Y %>

<%//if(!end_yn.equals("Y")){
		if(a_bean.getBbs_st().equals("6") && acar_id.equals("000003")){
%>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class="line">
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr>
				<td class="title" align="center">결재여부</td>
				<td class="title" align="center"><INPUT TYPE="radio"
					NAME="com_st" value="N">결재대기</td>
				<td class="title" align="center"><INPUT TYPE="radio"
					NAME="com_st" value="Y">결재완료</td>
			</tr>
		</table>
		</td>
	</tr>
<%} %>
<%// 결재 정보 끝 %>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr>
			  <td width="70" class="title">댓글</td>
			  <td width="350" align="center">
				<textarea name="comment" cols="74" rows="3" class="text"></textarea></td>
			  <td width="80" align="center"><a href="javascript:Comment_save()"><img src="../images/center/button_reg.gif" align=absmiddle border=0></a></td>
			</tr>
		  </table>
	  </td>
    </tr>


	<tr>
		<td></td>
	</tr>

</table>
</center>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</form>		
</body>
</html>