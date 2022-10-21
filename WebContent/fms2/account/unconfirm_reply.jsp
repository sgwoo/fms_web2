<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.user_mng.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit(request.getParameter("incom_amt"));
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//저장하기
	function save(){
		var fm = document.form1;
		
		if(fm.reply_cont.value == ""){ alert("내용을 입력하십시오."); return; }
		
		if(!confirm('등록하시겠습니까?')){	return;	}
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
		fm.action = 'unconfirm_reply_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
		
		link.getAttribute('href',originFunc);	
	}
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.reply_id.focus()">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
<input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
<input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
<table border=0 cellspacing=0 cellpadding=0 width=400>
  
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<%if(!acar_de.equals("1000")){%>
                <tr> 
                    <td class=title width="20%">등록자</td>
                    <td><SELECT NAME="reply_id" >
                    	 <option value="">선택</option>
			                <%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
			                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
			                <%		}
								}%>
           			   </select></td>
        	    
    		    </tr>		
    		    <%}else{%>
    		    <input type="hidden" name="reply_id" 		value="<%=ck_acar_id%>">
    		    <%}%>
                <tr> 
                    <td class=title width="20%">내용</td>
                    <td> 
                        <textarea name="reply_cont" cols="50" class="text" rows="7"></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
		
		<a id="submitLink" href="javascript:save();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
