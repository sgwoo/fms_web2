<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String file_st	 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String file_cont 	= request.getParameter("file_cont")==null?"":request.getParameter("file_cont");
	String remove_seq	= request.getParameter("remove_seq")==null?"":request.getParameter("remove_seq");
	String idx		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String rent_st		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_mng_id2 	= request.getParameter("rent_mng_id2")==null?"":request.getParameter("rent_mng_id2");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	String docs_menu 	= request.getParameter("docs_menu")==null?"":request.getParameter("docs_menu");
	
	if(!rent_mng_id2.equals("") && !remove_seq.equals("")){
		return;
	}
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		fm = document.form1;
		if(fm.file.value == ""){	alert("파일을 선택해 주세요!");		fm.file.focus();	return;		}		
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		
	
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value;
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.OFF_DOC%>";				

		fm.submit();
	}
	
//-->
</script>
</head>

<body onload='javascript:document.form1.file_cont.focus();'>

<form name='form1' action='' method='post' enctype="multipart/form-data">
	<input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
	<input type='hidden' name="user_id" 		value="<%=user_id%>">
	<input type='hidden' name="br_id"   		value="<%=br_id%>">
	<input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
	<input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
	<input type='hidden' name="remove_seq"	value="<%=remove_seq%>">
	<input type='hidden' name="idx"			value="<%=idx%>">
	<input type='hidden' name="from_page" 	value="<%=from_page%>">  
	<input type='hidden' name="fee_size" 		value="<%=fee_size%>">    
	<input type='hidden' name="seq" 		value="">
	<input type='hidden' name="copy_path"		value="">
	<input type='hidden' name="copy_type"		value="">
	<input type='hidden' name="docs_menu"		value="<%=docs_menu%>">
	<div class="navigation">
		<span class="style1">인사관리 > 사규관리  > 퇴직연금제도규약 > </span><span class="style5"> 규약 등록</span>
	</div>
	<div class="content">
		<table class="inner-table">
			<tr>
				<th class='title'>첨부파일</th>
                <td>
                    <input type="file" name="file" size="50" class=text>
                    <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='pension'>
                    <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.OFF_DOC%>'>                               			    
                </td>
			</tr>
		</table>
		<div style="float:right;margin-top:15px;">
			<input type="button" class="button btn-submit" value="등록" onclick="javascript:save()" />
			<input type="button" class="button" value="닫기" onclick="javascript:window.close()" />
		</div>
	</div>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
