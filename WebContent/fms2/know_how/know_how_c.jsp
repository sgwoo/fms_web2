<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.know_how.*"%>
<%@ page import="acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="k_bean" class="acar.know_how.Know_howBean" scope="page" />
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%
	Know_how_Database kh_db = Know_how_Database.getInstance();

	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int know_how_id = request.getParameter("know_how_id")==null?0:Util.parseInt(request.getParameter("know_how_id"));
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String title = request.getParameter("title")==null?"":request.getParameter("title");
	String know_how_st = request.getParameter("know_how_st")==null?"":request.getParameter("know_how_st");
	    
    String cmd = "";
    String reply_content ="";
    
    int know_how_seq = 0;
    
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");

	String acar_id = login.getCookieValue(request, "acar_id");
	reg_dt = Util.getDate();

	u_bean = umd.getUsersBean(acar_id);

	

	//공지사항 한건 조회
	k_bean = kh_db.getKnowHowBean(know_how_id);
	
	String content = k_bean.getContent();
		
	Vector vt2 = kh_db.Know_how_RpView(know_how_id, know_how_seq, user_id);
	int vt2_size = vt2.size();
	
	String  theURL  =  "https://fms3.amazoncar.co.kr/data/k_how/";
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	CommonDataBase c_db = CommonDataBase.getInstance();
	int size = 0;
	String s_know_how_id = request.getParameter("know_how_id")==null?"":request.getParameter("know_how_id");
	String content_code = "KNOW_HOW";
	String content_seq  = s_know_how_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	String file_type2 = "";
	String seq2 = "";
	String file_name2 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq+1).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}else if((content_seq+2).equals(aht.get("CONTENT_SEQ"))){
			file_name2 = String.valueOf(aht.get("FILE_NAME"));
			file_type2 = String.valueOf(aht.get("FILE_TYPE"));
			seq2 = String.valueOf(aht.get("SEQ"));

		}
	}
%>
<html>
<head>
<title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<style>
.userct,#userct{width:450px;height:350px;margin:20px 0 30px 20px;position:relative;z-index:10;color:#000;word-break:break-all}
.line_height{	line-height: 25px;		}
</style>
<script language='javascript'>
<!--
function UpDisp()
{
	var fm = document.Know_how_from;
	fm.action = "./know_how_u.jsp";
	fm.submit();
}

function Know_how_Close()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}

function ChangeDT()
{
	var fm = document.Know_how_from;
	fm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
}

//길이점검
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}
//리스트 가기	

function go_to_list()
{
	var fm = document.Know_how_from;
	fm.action = "./know_how_frame.jsp";
	fm.target = 'd_content';
	fm.submit();
}
	//댓글 등록
function Comment_save(){
		var fm = document.Know_how_from;
		if(fm.know_how_id.value == ''){ 		alert('게시물 아이디가 없습니다.'); return; }		
		if(fm.acar_id.value == ''){ 	alert('로그인된 아이디가 없습니다.'); return; }
		if(fm.reply_content.value == ''){ 	alert('댓글의 내용을 입력하십시오'); return; }
		fm.cmd.value = "c";
		fm.target="i_no";
		fm.submit();
	}
	
	//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
		//theURL = "https://fms3.amazoncar.co.kr/data/k_how/"+theURL;
		window.open(theURL,winName,features);
}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body onLoad="javascript:self.focus()" >
<form action="./know_how_a.jsp" name="Know_how_from" method="post" >
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='acar_id' value='<%=acar_id%>'>
<input type='hidden' name='know_how_id' value='<%=know_how_id%>'>
<input	type="hidden" name="know_how_seq" value=""> 
<input type='hidden' name='cmd' value=''>	

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master	> 아마존카 지식IN > <span class=style5>내용보기</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7	height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td align="right">
<%	if(acar_id.equals(k_bean.getUser_id()) || nm_db.getWorkAuthUser("전산팀",acar_id)){%>	
						<a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0></a>
<%}%>						
						<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="11%" class="title">카테고리</td>
					<td >&nbsp;&nbsp;&nbsp;
						<%if(k_bean.getKnow_how_st().equals("1")){%>지식Q&A
						<%}else {%>오픈지식
					   	<%}%> 					
				   </td>
				   	<td width="10%" class="title borSt" >공개범위</td>
					<td  class="borSt">&nbsp;
					<select name="p_view">
						<option value="" <%if(k_bean.getP_view().equals("")){%>selected<%}%>>선택</option>
						<option value="Y" <%if(k_bean.getP_view().equals("Y")){%>selected<%}%> >협력업체</option>
						<option value="A" <%if(k_bean.getP_view().equals("A")){%>selected<%}%>>에이전트</option>
						<option value="J" <%if(k_bean.getP_view().equals("J")){%>selected<%}%>>협력업체/에이전트</option>		
					</select>&nbsp;(※협력업체/에이전트도  조회가능하도록 선택할 수 있습니다.)					
					</td>
				   
				</tr>
				<tr>
					<td width="11%" class="title">작성자</td>
					<td width="39%">&nbsp;&nbsp;&nbsp;<%=c_db.getNameByUserId(k_bean.getUser_id(), "name")%></td>
					<td width="11%" class="title">작성일</td>
					<td width="39%">&nbsp;&nbsp;&nbsp;<%= AddUtil.ChangeDate2(k_bean.getReg_dt()) %></td>
				</tr>
				<tr>
					<td align="center" class="title">제목</td>
					<td colspan="3">&nbsp;&nbsp;&nbsp;<%=k_bean.getTitle()%></td>
				</tr>
				
			<tr style="height: 300px;">
				<td class="title">내용</td>
				<td colspan="3" style="height:200" valign="top">
					<table border=0 cellspacing=0 cellpadding=0 >
						<tr>
							<td style="padding:10px;" class="line_height"><%=content%></td>
						</tr>
					</table>
				</td>
			</tr>
				
			<tr>
			    	<td class='title'>첨부파일1</td>
			    	<td colspan="3">&nbsp;
					
							<%if(!file_name1.equals("")){%>
								<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
									<a href="javascript:openPopF('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=file_name1%></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						
							<%}%>
				
					  </td>
			    </tr>
				<tr>
			    	<td class='title'>첨부파일2</td>
			    	<td colspan="3">&nbsp;
					
							<%if(!file_name2.equals("")){%>
								<%if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
									<a href="javascript:openPopF('<%=file_type2%>','<%=seq2%>');" title='보기' ><%=file_name2%></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					
							<%}%>
					
					</td>
			    </tr>
			    
			</table>
		</td>
	</tr>


	<tr>
		<td></td>
	</tr>
    <tr>
		<td class=line2></td>
	</tr>	
	<tr>
		<td class="line">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="11%" class="title">작성자</td>
					<td class="title">내용</td>
					<td width="13%" class="title">등록일</td>
				</tr>
<% if(vt2_size > 0){
	for(int j=0; j< vt2_size; j++){
	Hashtable ht2 = (Hashtable)vt2.elementAt(j);
%> 				
				<tr>
					<td align="center"><%=ht2.get("USER_NM")%></td>
					<td><table width=100% border=0 cellspacing=0 cellpadding=3><tr><td><%=ht2.get("REPLY_CONTENT")%></td></tr></table></td>
					<td align="center"><%= AddUtil.ChangeDate2((String)ht2.get("REG_DT")) %></td>
				</tr>
<%}%>
<%}else{%>				
				<tr>
					<td colspan="3" align="center">등록된 리플이 없습니다.</td>
				</tr>
<%}%>				
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>댓글달기</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
	  <td class="line">
		  <table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr>
			    <td align="center">
				<textarea name="reply_content" cols="145" rows="4" class="default"></textarea></td>
			  <td width="13%" align="center"><a href="javascript:Comment_save()"><img src="/acar/images/center/button_in_reg.gif" align=absmiddle border=0></a></td>
			</tr>
		  </table>
	  </td>
    </tr>
</table>


</form>
<iframe src="about:blank" name="i_no" width="50" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>