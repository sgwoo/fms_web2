<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_anc.*, acar.common.*,acar.user_mng.*" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="bc_bean" class="acar.off_anc.BbsCommentBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String acar_id = request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	String s_bbs_id = request.getParameter("bbs_id")==null?"":request.getParameter("bbs_id");
	int bbs_id = request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	if(acar_id.equals("")){
	acar_id = ck_acar_id;
	}
	
	String user_id = ck_acar_id;

	String end_yn = ""; //결재완료
	String comst	= request.getParameter("comst")==null?"":request.getParameter("comst");
	String bbs_st = "";
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	a_bean.setComst(comst);
	
	if(bbs_id == 0){
		out.println("선택된 공지사항이 없습니다.");
		return;
	}
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	//공지사항 한건 조회
	a_bean = oad.getAncBean(bbs_id);
	
	//읽기체크
	count = oad.readChkAnc(bbs_id, acar_id);
	
	//댓글리스트
	BbsCommentBean bc_r [] = oad.getBbsCommentList(bbs_id);
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	CommonDataBase c_db = CommonDataBase.getInstance();	

	int size = 0;
	
	String content_code = "BBS";
	String content_seq  = s_bbs_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	//2016-06-03 Text Editor 추가 -- ks.cho
	String content = a_bean.getContent();
	if(!content.contains("<div>")){ //신규 에디터로 작성한 내용이 아니면 \r\n 값을 <br/>태그로 치환함
		content = content.replaceAll("\r\n","<br/>");
	}
	
	//나의공지사항 체크(2018.02.20)
	String myBbs_chk = oad.selectMyAnc(s_bbs_id);
	boolean myBbs = false;
	if(!myBbs_chk.equals("")){
		String[] myBbs_id = myBbs_chk.split("A");
		for(int i=1; i<myBbs_id.length; i++){
			if(myBbs_id[i].equals(user_id)){
				myBbs = true;
			}
		}
	}
	
	//현재날짜 구하기(자기댓글삭제기능관련) (2018.02.28)
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat ( "yyyyMMdd", Locale.KOREA );
	Date curDay = new Date ();
	String today = simpleDateFormat.format( curDay );

%>
<html>
<head><title>FMS</title>
<script language='javascript'>
	var popObj = null;
<!--

	//리스트
	function list(){
		var fm = document.AncDispForm;			
		fm.action = 'anc_s_grid_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//댓글 등록
function Comment_save(){
		var fm = document.AncDispForm;
		if(fm.bbs_id.value == ''){ 		alert('게시물 아이디가 없습니다.'); return; }		
		if(fm.acar_id.value == ''){ 	alert('로그인된 아이디가 없습니다.'); return; }
		if(fm.comment.value == ''){ 	alert('댓글의 내용을 입력하십시오'); return; }
		fm.action = './anc_comment_a.jsp';
		fm.submit();
	}

function Comment_save2(){
		var fm = document.AncDispForm;
		fm.action = './anc_comst_a.jsp';
		fm.submit();
	}

function UpDisp()
{
	var exp_dt_chg_yn = '<%=a_bean.getExp_dt_chg_yn()%>';
	if(exp_dt_chg_yn=='Y'){
		alert("만료일을 연장한 내역이 있어 해당 공지사항은 수정이 불가능합니다.");
		return false;
	}
	var theForm = document.AncDispForm;
	theForm.submit();
}

//팝업창 닫기
function AncClose()
{
	//opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}

	
	//파일다운이력
	function file_down_history(){
		var fm = document.AncDispForm;
		var fn = '<%//= a_bean.getAtt_file1() %>';
		var usern = '<%=acar_id%>';

		fn = (encodeURIComponent(fn));
		usern = (encodeURIComponent(usern));

		fm.action = 'file_down_history.jsp?file_nm='+fn+'&user_id='+usern;
		fm.target = 'i_no';
		fm.submit();		
	}
	//스캔등록
function scan_reg(){
		window.open("anc_reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&bbs_id=<%=bbs_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

//댓글(공지에대한 의견)삭제	
function deleteAncComment(bbs_id, bbs_comment_seq){	
	var str = confirm("댓글을 삭제하시겠습니까?");
	if(str == true){
		//location.href="./anc_comment_b.jsp?bbs_id="+bbs_id+"&bbs_comment_seq="+bbs_comment_seq;
		window.open("anc_comment_b.jsp?bbs_id="+bbs_id+"&bbs_comment_seq="+bbs_comment_seq, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}else{
		return false;
	}
}

//나의공지사항에 등록 (2018.02.14)
function regMyAnc(){
	if(confirm("나의공지사항에 추가하시겠습니까?")==true){
		window.open("my_anc_a.jsp?user_id=<%=user_id%>&bbs_id=<%=bbs_id%>&mode=MI", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
	}
}

//나의공지사항에서 삭제 (2018.02.20)
function delMyAnc(){
	if(confirm("나의공지사항에서 삭제 하시겠습니까?")==true){
		window.open("my_anc_a.jsp?user_id=<%=user_id%>&bbs_id=<%=bbs_id%>&mode=MD", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
	}
}

//중요공지사항 지정 (20181121)
function regImportAnc(){
	if(confirm("중요공지사항으로 지정 하시겠습니까?")==true){
		window.open("my_anc_a.jsp?user_id=<%=user_id%>&bbs_id=<%=bbs_id%>&mode=II", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
	}
}

//중요공지사항 해제 (20181121)
function delImportAnc(){
	if(confirm("중요공지사항에서 지정해제 하시겠습니까?")==true){
		window.open("my_anc_a.jsp?user_id=<%=user_id%>&bbs_id=<%=bbs_id%>&mode=ID", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
	}
}

//만료일 업데이트(20180801)
function update_exp_dt(){
	var fm = document.AncDispForm;
	var exp_dt = fm.exp_dt.value.replace(/-/gi,'');
	if(exp_dt=="" || exp_dt.length != 8){
		alert("연장할 만료일자를 정확히 입력해주세요."); 
		fm.exp_dt.focus();
		return;
	}
	if(confirm("만료일 연장시 더이상 공지내용을 수정하실수 없습니다.\n\n만료일을 변경하시겠습니까?")==true){
		fm.cmd.value = "exp_dt_u";
		fm.target="i_no";
		fm.action = "anc_null_ui.jsp";	
		fm.submit();
	}
}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body onLoad="javascript:self.focus()" id="body">
<form action="./anc_u.jsp" name="AncDispForm" method="post">
	<input type="hidden" name="user_id" value="<%=a_bean.getUser_id()%>">
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="acar_id" value="<%=acar_id%>">
	<input type="hidden" name="from_page" value="<%=from_page%>">	
	<input type="hidden" name="comst" value="Y">
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   	
	<input type="hidden" name="cmd" value="">
<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > <span class=style5> 공지사항</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
    <tr>
	    <td align='right'>
	    	<%if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("이사",user_id)||nm_db.getWorkAuthUser("본사총무팀장",user_id)
			 	||nm_db.getWorkAuthUser("본사영업팀장",user_id)||nm_db.getWorkAuthUser("본사영업기획팀장",user_id)||nm_db.getWorkAuthUser("본사관리팀장",user_id)
			 	||nm_db.getWorkAuthUser("본사영업부팀장",user_id)||nm_db.getWorkAuthUser("감사",user_id)){ %>
			 	<%if(a_bean.getImpor_yn().equals("Y")){ %>
			 		<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:delImportAnc();">중요공지사항 해제</a>&nbsp;&nbsp;&nbsp;&nbsp;
			 	<%}else{ %>
			 		<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:regImportAnc();">중요공지사항 지정</a>&nbsp;&nbsp;&nbsp;&nbsp;
			 	<%} %>
	    	<%} %>
	    	<%if(myBbs==true){ %>
	    		<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:delMyAnc();">나의공지사항 삭제</a>&nbsp;&nbsp;&nbsp;&nbsp;
	    	<%}else{ %>
		 		<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:regMyAnc();">나의공지사항 담기</a>&nbsp;&nbsp;&nbsp;&nbsp;
	    	<%} %>
	 		
	       <%	if(acar_id.equals(a_bean.getUser_id()) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || user_id.equals("000096")){%>	
	    	<%    if ( Integer.parseInt(AddUtil.getReplace_dt(a_bean.getExp_dt())) >=  Integer.parseInt(AddUtil.getReplace_dt(AddUtil.getDate()))) {%>
	        <a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify_s.gif align=absmiddle border=0></a>
	        <% } %>
	        &nbsp;&nbsp;&nbsp;	 
	        <%}%>       
	        <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
	</tr>	

	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="0" width="100%">
			<tr>
				<td class="title" colspan="">현재 등록된 카테고리</td>
				<td align="center" colspan=""><b>
				<%if(a_bean.getBbs_st().equals("1")){%>일반공지
				<%}else if(a_bean.getBbs_st().equals("2")){%>최근뉴스
				<%}else if(a_bean.getBbs_st().equals("3")){%>판매조건
				<%}else if(a_bean.getBbs_st().equals("4")){%>업무협조
				<%}else if(a_bean.getBbs_st().equals("5")){%>경조사
				<%}else if(a_bean.getBbs_st().equals("6")){%>규정및인사
				<%}else if(a_bean.getBbs_st().equals("7")){%>업그레이드
				<%}else if(a_bean.getBbs_st().equals("8")){%>에이전트
				<%}%> 
				</b></td>
				<td class="title">공개범위</td>
				<td align="left">
				<%if(a_bean.getP_view().equals("Y")){%>&nbsp;&nbsp;협력업체
				<%}else if(a_bean.getP_view().equals("A")){%>&nbsp;&nbsp;에이전트
				<%}else if(a_bean.getP_view().equals("J")){%>&nbsp;&nbsp;협력업체/에이전트
				<%}else {%>사내 공지
				<%}%> 
				</td>
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
				<td>&nbsp;&nbsp;<%=a_bean.getExp_dt()%>
				<%if(acar_id.equals(a_bean.getUser_id()) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || user_id.equals("000096")){ %>
					&nbsp;&nbsp;<input type="text" class="text" name="exp_dt" size="12" value="<%=a_bean.getExp_dt()%>">
					<input type="button" class="button" style="font-size: 12px; padding:3.5px;" value="만료일연장" onclick="javascript:update_exp_dt();">
				<%} %>
				</td>
			</tr>
			<tr>
				<td align="center" class="title">제목</td>
				<td align="center" colspan="3">
				<!-- 		  중요 처리 -->
			  	<%if(a_bean.getImpor_yn().equals("Y")){%>
			  		<img alt="icon-star" src="/images/icon_star.png">&nbsp;
			  	<%} %>
				<%if(a_bean.getRead_yn().equals("Y")){%> <img src="/images/n_icon.gif"
					border=0 align=absmiddle>&nbsp; <%}%> <%=a_bean.getTitle()%></td>
			</tr>
			<tr style="height: 370px;">
				<td class="title">내용</td>
				<td colspan="3" style="height:200" valign="top">
					<table border=0 cellspacing=0 cellpadding=0 >
						<tr>
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
					 <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><%=ht.get("FILE_NAME")%></a>
					 <%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					 </td>
				</tr>
				<%}%>
				<%if(attach_vt.size() < 5){%>
				<tr>
					<td align='center'class='title'>첨부파일 추가</td>
					<td colspan="3">&nbsp;&nbsp;<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
				</tr>
				<%} %>
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
          <td width="15%" class="title">작성자</td>
          <td class="title">내용</td>
          <td width="15%" class="title">등록일</td>
       	  <td width="7%" class="title"></td>
        </tr>
		<%	for(int i=0; i<bc_r.length; i++){
	        	bc_bean = bc_r[i];
				String cont = AddUtil.replace(bc_bean.getContent(),"\\","&#92;&#92;");
				cont = AddUtil.replace(cont,"\"","&#34;");
				cont = Util.htmlR(cont);				
				int bbs_comment_seq = bc_bean.getSeq();	//추가(댓글삭제)
		%>

	        <tr>
			<%if(!cont.equals("")){ %>
	          <td align="center"><%if(a_bean.getScm_yn().equals("Y")){%>익명<%}else{%><%=bc_bean.getUser_nm()%><%}%></td>
	          <td>&nbsp;<%=cont%></td>
	          <td align="center"><%=bc_bean.getReg_dt()%></td>
	          <%if(Integer.parseInt(((String)a_bean.getExp_dt().replace("-",""))) >= Integer.parseInt(today)){ %>
		          <%if(bc_bean.getReg_id().equals(ck_acar_id)){%>
			          <td align="center">
			          	<a onclick="deleteAncComment(<%=bbs_id%>,<%=bbs_comment_seq%>);" href="#" style="text-decoration: none;"><span style="color:red;">삭제</span></a>
			          </td>
		          <%}else{ %>
		          	  <td></td>	
		          <%} %>
	           <%}else{ %>
	           		<td></td>
	           <%} %>
			<%}%>
	        </tr>
		<%}%>

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

<%if(a_bean.getBbs_st().equals("6") && !a_bean.getComst().equals("Y") ){%>
	<tr>
		<td class="line">
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr>
				<td class="title" align="center">결재여부</td>
				<td class="title" align="center"><INPUT TYPE="radio"
					NAME="comst" value="N">결재대기</td>
				<td class="title" align="center"><INPUT TYPE="radio"
					NAME="comst" value="Y">결재완료</td>
				<td width="80" align="center"><a href="javascript:Comment_save2()"><img src="../images/center/button_reg.gif" align=absmiddle border=0></a></td>
			</tr>
		</table>
		</td>
	</tr>
<%}%>


<%// 결재 정보 끝 %>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
    <tr>
		<td class=line2></td>
	</tr>
	<tr>
	  <td class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr>
			  <td width="135" class="title">댓글</td>
			  <td width="350" align="center">
				<textarea name="comment" id="comment" cols="110" rows="3" class="text"></textarea></td>
			  <td width="80" align="center"><a href="javascript:Comment_save()"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a></td>
			</tr>
		  </table>
	  </td>
    </tr>


	<tr>
		<td></td>
	</tr>

</table>
</center>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
	//특수문자 ' " 제한 2018.02.06
	var regex = /['"]/gi;
	var comment;
	$("#comment").bind("keyup",function(){comment = $("#comment").val();if(regex.test(comment)){$("#comment").val(comment.replace(regex,""));}});
</script>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</form>		
</body>
</html>