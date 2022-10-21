<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.pay_mng.*, acar.partner.*, acar.common.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_st	= request.getParameter("off_st")==null?"":request.getParameter("off_st");
	String file_st	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String seq	= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//금융사리스트
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Hashtable ht2 = se_dt.Bank_accView(off_id, seq);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//등록하기
	function save(){
		fm = document.form1;
		
		if(!confirm("등록하시겠습니까?"))	return;
		fm.cmd.value = "in";
		file_save();
		fm.action = "reg_scan_a.jsp";
		fm.submit();
	}
	
	function modify(){
		fm = document.form1;
		//if(fm.filename.value == ""){	alert("파일을 선택해 주세요!");		fm.filename.focus();	return;		}		
		
		if(!confirm("수정하시겠습니까?"))	return;
		fm.cmd.value = "up";
		fm.action = "reg_scan_a.jsp";
		fm.submit();
	}
	
	function bank_delete(){
		fm = document.form1;
		//if(fm.filename.value == ""){	alert("파일을 선택해 주세요!");		fm.filename.focus();	return;		}		
		
		if(!confirm("삭제 하시겠습니까?"))	return;
		
		fm.cmd.value = "de";
		fm.action = "reg_scan_a.jsp";
		fm.submit();
	}
	
	function file_save(){
		var fm2 = document.form2;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
		
		fm2.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.BANK_ACC%>";
		fm2.submit();
	}
//-->
</script>
</head>

<body>
<form name='form1' action='' method='post' enctype="">
  <input type='hidden' name="auth_rw" 	value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 	value="<%=user_id%>">
  <input type='hidden' name="br_id"   	value="<%=br_id%>">
  <input type="hidden" name="off_id" 		value="<%=off_id%>">
  <input type='hidden' name="file_st"	value="<%=file_st%>">  
  <input type='hidden' name="seq"	value="<%=seq%>">
  <input type='hidden' name="cmd"	value="">
<div class="navigation">
	<span class=style1>업체정보관리 ></span><span class=style5>계좌추가</span>
</div>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td align="right">
		<%if(cmd.equals("in")){%>
		
		<input type="button" class="button" value="등록" onclick="save()"/>
		<%}else if(cmd.equals("up")){%>
		<input type="button" class="button" value="수정" onclick="modify()"/>
		<input type="button" class="button" value="삭제" onclick="bank_delete()"/>
		
		<%}%>&nbsp; 
		<input type="button" class="button" value="닫기" onclick="window.close()"/>
		
		</td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>	
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>은행명</td>
                    <td colspan="" align=left>&nbsp;<select name='bank_id'>
							<option value=''>선택</option>
							<%	for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
											%>
							<option value='<%= bank_ht.get("CODE")%>' <%if(bank_ht.get("CODE").equals(ht2.get("BANK_ID")) ){%> selected <%}%>><%= bank_ht.get("NM")%></option>
							<%	}%>
						</select>
					</td>
				</tr>
				<tr>
                    <td class=title>계좌번호</td>
                    <td>&nbsp;<input type="text" name="acc_no" value="<%=ht2.get("ACC_NO")%>" size="49" class=text></td>
				</tr>
				<tr>
                    <td class=title>적요</td>
                    <td align="" colspan="">&nbsp;<input type="text" name="etc" value="<%=ht2.get("ETC")%>" size="70" class=text></td>
                </tr>
			</table>
        </td>
    </tr>
</table>
</form>

<form action="" name="form2" method="POST" enctype="multipart/form-data">
	<input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
	<input type='hidden' name="user_id" 		value="<%=user_id%>">
	<input type="hidden" name="off_st" 		value="<%=off_st%>">
	<input type="hidden" name="off_id" 		value="<%=off_id%>">
	<input type='hidden' name="file_st"	value="<%=file_st%>">  
	<input type='hidden' name="seq"	value="<%=seq%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td class=line2 colspan=2></td>
	</tr>	
	<tr>
		<td align="right" class="line">
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width=15%>스캔파일</td>
					<td width=85%>&nbsp;
					<input type='file' name="file" size='40' class='text'>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=off_st%><%=off_id%><%=seq%><%=file_st%>' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.BANK_ACC%>' />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
