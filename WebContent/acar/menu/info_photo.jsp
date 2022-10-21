<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//사용자별 사진올리기 등록
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String file_st 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	
	String user_nm = "";
	String user_ssn1 = "";
	
	
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	user_nm 	= user_bean.getUser_nm();
	user_ssn1 	= user_bean.getUser_ssn1();

	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "USERS";
	String content_seq  = user_id+""+file_st;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;	
		if(confirm('등록 하시겠습니까?')){			
			fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.USERS%>";		
			fm.submit();
		}				
	}	
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body  onLoad="self.focus()">
<center>
<form name='form1' method='post' enctype="multipart/form-data">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="file_st" value="<%=file_st%>">
<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=400>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 사용자관리 > <span class=style5>사용자 사진올리기</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
	<tr>
    	<td class=line>
            <table border="0" cellspacing="1" width=400>
            <tr align="center"> 
              <td width="90" class=title>이름</td>
              <td width="110">&nbsp;<%=user_nm%></td>
              <td width="90" class=title>생년월일</td>
              <td width="110">&nbsp;<%=user_ssn1%></td>
            </tr>
            <tr align="center"> 
              <td class=title>사진</td>
              <td colspan=3>
                        <input type="file" name="file" size="30" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=user_id%><%=file_st%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.USERS%>'>        			              
              </td>
            </tr>
          </table>
        </td>
    </tr>
    <tr>
        <td>
        <table border="0" cellspacing="3" width=400>
        <tr>
              <td align="right"> <a href="javascript:save()"><img src=../images/pop/button_reg.gif border=0></a>&nbsp <a href="javascript:self.close();window.close();"><img src=../images/pop/button_close.gif border=0></a </td>
            </tr>
        </table>
       </td>
    </tr>
</table>
</form>
</center><iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

</body>
</html>