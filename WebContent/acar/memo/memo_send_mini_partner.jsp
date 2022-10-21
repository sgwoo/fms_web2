<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_work 	= request.getParameter("user_work")==null?"":request.getParameter("user_work");
	String send_id 		= request.getParameter("send_id")==null?"":request.getParameter("send_id");
	String rece_id 		= request.getParameter("rece_id")==null?"":request.getParameter("rece_id");
	String m_title 		= request.getParameter("m_title")==null?"":request.getParameter("m_title");
	String m_content 	= request.getParameter("m_content")==null?"":request.getParameter("m_content");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(send_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("8888", user_work, "PARTNER", "Y"); //외부업체 리스트
	int user_size = users.size();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function send_memo(){
	fm = document.form1;	
	
	if(fm.rece_id.value == '')		{	alert('받는사람을 입력하십시오');	fm.rece_id.focus();			return;	}	
	if(fm.title.value == '')		{	alert('제목을 입력하십시오');		fm.title.focus();			return;	}
	if(fm.content.value == '')		{	alert('내용을 입력하십시오');		fm.content.focus();			return;	}
	
	if(get_length(fm.content.value) > 4000){
		alert("2000자 까지만 입력할 수 있습니다.");
		return;
	}
		
	if(!confirm("보내시겠습니까?")){ return; }	
	fm.action='memo_send_mini_partner_a.jsp';
	fm.target="i_no";
	fm.submit();	
}
//-->
</script>
</head>
<body onLoad="javascript:self.focus()">
<form action="" name="form1" method="post">
<input type="hidden" name="send_id" value="<%=send_id%>">
<input type="hidden" name="cmd" value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 메모함 > <span class=style5> 보낼메모 쓰기</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
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
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width="80">알림방식</td>
                    <td>&nbsp;						
        			  <input type='radio' name="send_st" value='2'>
        				쿨메신저 메시지
        			  <input type='radio' name="send_st" value='3' checked>
        				SMS 문자
					 </td>
                </tr>			
                <tr> 
                    <td class="title" width="80">받는사람</td>
                    <td>&nbsp;
						<select name="rece_id">
        			    	<option value="">선택</option>
                        	<%if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        	<option value='<%=user.get("USER_ID")%>' <%if(rece_id.equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_M_TEL")%> <%=user.get("USER_NM")%></option>
                        	<%	}
        					}		%>
                    </select></td>
                </tr>			
                <tr> 
                    <td class="title" width="80">제목</td>
                    <td>&nbsp;
						<input type="text" name="title" size="60" class=text value='<%=m_title%>'> </td>
                </tr>
                <tr> 
                    <td class="title">내용</td>
                    <td>&nbsp;
						<textarea name="content" cols='60' rows='7'><%=m_content%></textarea> </td>
                </tr>
                <tr> 
                    <td class="title" width="80">회신번호</td>
                    <td>&nbsp;
			<select name="send_phone">
				<%if(!sender_bean.getHot_tel().equals("")){%>
				<option value="<%=sender_bean.getHot_tel()%>">직통전화 : <%=sender_bean.getHot_tel()%></option>
				<%}%>
        			<option value="<%=sender_bean.getUser_m_tel()%>">휴&nbsp;대&nbsp;폰&nbsp; : <%=sender_bean.getUser_m_tel()%></option>        			        			
                    	</select> 
                    	(문자일때)
                    </td>
                </tr>                             
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:send_memo();"><img src=../images/center/button_memo_send.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td>* 문자는 80byte 초과시에 장문자로 발송됩니다.</td>
    </tr>	
    <tr>
        <td>* 문자발송시 [내용]에 [-보내는사람이름-]이 붙어서 나갑니다.</td>
    </tr>	
	<%if(!rece_id.equals("")){%>
    <tr>
        <td>* 받는사람을 변경할 수 있습니다. 변경시 내용 등을 알맞게 편집하십시오.</td>
    </tr>
	<%}%>	
	<%if(!m_content.equals("")){%>
    <tr>
        <td>* 내용은 편집할 수 있습니다.</td>
    </tr>
	<%}%>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
