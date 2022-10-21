<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.common.*"%>
<%@ page import="acar.know_how.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="k_bean" class="acar.know_how.Know_howBean" scope="page" />
<%@ include file="/acar/cookies.jsp"%>

<%
	Know_how_Database kh_db = Know_how_Database.getInstance();

	LoginBean login = LoginBean.getInstance();
	
	
	int know_how_id = request.getParameter("know_how_id")==null?0:Util.parseInt(request.getParameter("know_how_id"));
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

    String auth_rw = "";
    String cmd = "";
	String know_how_st = "";

	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("know_how_id") != null) know_how_id = Util.parseInt(request.getParameter("know_how_id"));
	

	String acar_id = login.getCookieValue(request, "acar_id");

	
	//공지사항 한건 조회
	k_bean = kh_db.getKnowHowBean(know_how_id);
	
	String content = k_bean.getContent();
		

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
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link href="https://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css" rel="stylesheet"> 
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.css" rel="stylesheet">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script> 
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.js"></script>

<script src="/include/common.js"></script>
<script>
function Know_how_Up()
{
	var fm = document.Know_how_from;

	if(fm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
	
	/* if(get_length(fm.content.value) > 4000){
		alert("4000자 까지만 입력할 수 있습니다.");
		return;
	}	 */
	
	if(!confirm('수정하시겠습니까?'))
		return;		
		
	fm.cmd.value = "u";
	fm.target="i_no";
	fm.action = "know_how_a.jsp";
	fm.submit();

}
function Know_how_Del()
{
	var fm = document.Know_how_from;
	if(!confirm('삭제하시겠습니까?'))
		return;	
	fm.cmd.value = "d";
	fm.action = "know_how_a.jsp";
	fm.target="i_no";
	fm.submit();
}

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
function Know_how_Close()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}

//리스트 가기	
function go_to_list()
{
		var fm = document.Know_how_from;
	//	var auth_rw = fm.auth_rw.value;
	//	location = "know_how_frame.jsp?auth_rw="+auth_rw;
		
		fm.action = "./know_how_frame.jsp";
		fm.target = 'd_content';
		fm.submit();	
	
}	

//스캔등록
function scan_reg(idx){
		window.open("reg_scan.jsp?idx="+idx+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&know_how_id=<%=know_how_id%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

	//스캔삭제
function scan_del(idx){
		var theForm = document.Know_how_from;
		theForm.remove_idx.value =idx;
		
		if(!confirm('삭제하시겠습니까?')){		return;	}
		
		theForm.action = "https://fms3.amazoncar.co.kr/acar/upload/k_how_del_scan_a.jsp";
		theForm.target = "i_no";
		theForm.submit();		

}

</script>
<script>
$(document).ready(function() {
   	  $('#summernote').summernote({
   	  	height:400,
   	  	callbacks: { // 콜백을 사용
                     // 이미지를 업로드할 경우 이벤트를 발생
   	  	   onImageUpload: function(files, editor, welEditable) {
	    	
			    sendFile(files, this);
			}
		}
   	  });
   	});

 function sendFile(files, editor) {
   		for (var i = 0; i < files.length; i++) {
    		var file = files[i];
 	        var tokens = file.name.split('.');
 	         
 	        tokens.pop();
	        var content_seq = '<%=know_how_id%>'; 
	        var file_name = files[i].name;
	     	var file_size = files[i].size;
	        var file_type = files[i].type;
	         
            // 파일 전송을 위한 폼생성
	 	 	data = new FormData();
	 	    data.append("uploadFile", file);
	 	    data.append("content_code", "KNOW_HOW");
	  	    data.append("content_seq", content_seq);
	  	    data.append("file_name", file_name);
	 	    data.append("file_size", file_size);
	 	    data.append("file_type", file_type); 
	 	    
	 	    $.ajax({ // ajax를 통해 파일 업로드 처리
	 	        data : data,
	 	        type : "POST",
	 	        url : "https://fms3.amazoncar.co.kr/fms2/attach/summernote_imageUpload.jsp",
	 	        cache : false,
	 	        contentType : false,
	 	        processData : false,
	 	        success : function(data) { // 처리가 성공할 경우
                    // 에디터에 이미지 출력
	 	        	$(editor).summernote('editor.insertImage', data.url);
	 	        }
	 	    }); 
   	  }
	}
 
	// 특수문자 제한	2018.01.09			'와 "만 제한하기로 변경 2018.02.06
	var regex = /['"]/gi;
	var title;
	var content;
	
	$("#title").bind("keyup",function(){title = $("#title").val();if(regex.test(title)){$("#title").val(title.replace(regex,""));}});	// 제목
	$("#content").bind("keyup",function(){content1 = $("#content").val();if(regex.test(content)){$("#content").val(content.replace(regex,""));}});	//내용
</script>

<style>
.borSt {
	 border: 1px solid #b0baec;
    }
button[data-original-title="Video"]{ display: none; }
</style>
</head>
<body onLoad="javascript:self.focus()">
<form  name="Know_how_from" method="post" >
<input type="hidden" name="remove_idx" 	value="">
<input type='hidden' name='reg_dt' value='<%=k_bean.getReg_dt()%>'>	
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input	type="hidden" name="know_how_id" value="<%=know_how_id%>"> 
<%-- <input	type="hidden" name="know_how_st" value="<%=know_how_st%>"> --%>
<input	type="hidden" name="cmd" value="">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1> 아마존카 지식IN > <span class=style5> 내용수정</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class="" ></td>
	</tr>
	
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="10%" class="title borSt">카테고리</td>
					<td >
						&nbsp;&nbsp;<INPUT type="radio" name="know_how_st" value="1" <%if(k_bean.getKnow_how_st().equals("1")){%>checked<%}%> >지식Q&amp;A&nbsp;&nbsp; 
						<INPUT type="radio" name="know_how_st" value="2" <%if(k_bean.getKnow_how_st().equals("2")){%>checked<%}%> >오픈지식&nbsp;&nbsp;
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
					<td width="10%" class="title borSt">작성자</td>
					<td width="40%" class="borSt">&nbsp;&nbsp;&nbsp;<%=c_db.getNameByUserId(k_bean.getUser_id(), "name")%></td>
					<td width="10%" class="title borSt">작성일</td>
					<td width="40%" class="borSt">&nbsp;&nbsp;<%= AddUtil.ChangeDate2(k_bean.getReg_dt()) %></td>
	
				</tr>
				<tr>
					<td align="center" class="title borSt" >제목</td>
					<td colspan="3" class="borSt">&nbsp;&nbsp;&nbsp;<input type='text' name="title" size='100' class='text' value="<%=k_bean.getTitle()%>"></td>
				</tr>
				<tr>
				<td class="title borSt">내용</td>
				<td colspan="3"><textarea name="content" id="summernote"><%=content%></textarea>		
				</td>
			</tr>
			
			
				<tr>
			    	<td class='title borSt'>첨부파일1</td>
			    	<td colspan="3" class="borSt">&nbsp;
							<%if(!file_name1.equals("")){%>
								<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
									<a href="javascript:openPopF('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=file_name1%></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}else{%>
								<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
							<%}%>
				
					  </td>
			    </tr>
				<tr>
			    	<td class='title borSt'>첨부파일2</td>
			    	<td colspan="3" class="borSt">&nbsp;
							<%if(!file_name2.equals("")){%>
								<%if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
									<a href="javascript:openPopF('<%=file_type2%>','<%=seq2%>');" title='보기' ><%=file_name2%></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}else{%>
								<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
							<%}%>
					
					</td>
			    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%">
				<tr>
					<td  align='center'><a href="javascript:Know_how_Up()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0></a>&nbsp;&nbsp;
						<a href="javascript:Know_how_Del()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align=absmiddle border=0></a>&nbsp;&nbsp;
							<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align=absmiddle border=0></a>&nbsp;&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>

<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>
