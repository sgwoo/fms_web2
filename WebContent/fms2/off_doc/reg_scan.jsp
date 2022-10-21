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
	String syear 	= request.getParameter("syear")==null?"":request.getParameter("syear");
	
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
		
		if(fm.file_rent_st.value=='asset'){
			  fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_rent_st.value+fm.syear.value;
		}else{
			 fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_rent_st.value;
		}
	
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.OFF_DOC%>";				

		fm.submit();
	}
	function showYear(){
		fm = document.form1;
		var con = document.getElementById("syear");
		if(fm.file_rent_st.value=='asset'){
			  con.style.display = 'inline';
		}else{
			  con.style.display = 'none';
		}
	}
	
	
	
//-->
</script>
</head>

<body onload='javascript:document.form1.file_cont.focus();'>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="remove_seq"	value="<%=remove_seq%>">
  <input type='hidden' name="idx"			value="<%=idx%>">
  <input type='hidden' name="rent_st"		value="<%=rent_st%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">  
  <input type='hidden' name="fee_size" 		value="<%=fee_size%>">    
  <input type='hidden' name="seq" 		value="">
  <input type='hidden' name="copy_path"		value="">
  <input type='hidden' name="copy_type"		value="">
  <input type='hidden' name="docs_menu"		value="<%=docs_menu%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>업무서식등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td class=line2></td>
	</tr>
	      <%	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);%>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='15%'>구분</td>
                    <td>&nbsp;
                      <select name="file_rent_st" onchange="javascript:showYear();">					  
                        <option value="docs1"<%if(docs_menu.equals("docs1")){%>selected<%}%>>법인기본서류</option>
												<option value="docs2"<%if(docs_menu.equals("docs2")){%>selected<%}%>>인사/급여서식</option>
												<option value="docs3"<%if(docs_menu.equals("docs3")){%>selected<%}%>>본사/지점약도</option>	
												<option value="docs4"<%if(docs_menu.equals("docs4")){%>selected<%}%>>법인은행계좌사본</option>	
												<option value="docs5"<%if(docs_menu.equals("docs5")){%>selected<%}%>>영업팀업무서식</option>	
												<option value="docs6"<%if(docs_menu.equals("docs6")){%>selected<%}%>>총무팀업무서식</option>	
												<option value="docs7"<%if(docs_menu.equals("docs7")){%>selected<%}%>>고객지원팀업무서식</option>	
												<option value="asset"<%if(docs_menu.equals("asset")){%>selected<%}%>>자산_5년기준</option>	
												<option value="docs8"<%if(docs_menu.equals("docs8")){%>selected<%}%>>기타서식</option>							
                      </select> 	 <input type="text" class="text" id ="syear" <%if(docs_menu.equals("asset")){%><%}else{%>style="display:none;"<%}%> value="<%=syear%>" >	
                     	
                    </td>
                </tr>	
                <tr>
                    <td class='title'>첨부파일</td>
                    <td>
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=rent_mng_id%><%=rent_l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.OFF_DOC%>'>                               			    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	
    <tr>
        <td>☞ <b>첨부파일명</b>을 해당 업무서식명으로 수정한 후 등록해주세요.</td>
    </tr>	
    <tr>
        <td>☞ 업무서식을 수정할 때에는 기존 파일을 삭제한 후 다시 등록해주세요.</td>
    </tr>	

    <tr>
        <td align="right">
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
