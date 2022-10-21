<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		if((fm.reg_dt.value == '') || !isDate(fm.reg_dt.value))	{	alert('등록일을 확인하십시오');	return;	}
		else if(fm.content.value == '')							{	alert('메모내용을 확인하십시오');	return;	}		
		
		if(confirm('등록하시겠습니까?')){		
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function pop_close(){
//		parent.opener.location.reload();
		parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post' action='/acar/condition/rent_memo_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='tm_st' value='<%=tm_st%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='reg_id' value='<%=user_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
		            <td class='title' width=20%> 작성일 </td>
		            <td colspan='3' width=80%>&nbsp;
		            <input type='text' name='reg_dt' value='<%=Util.getDate()%>' size='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
		        </tr>
		        <tr>
		            <td class='title'> 작성자</td>
		            <td colspan='3'>&nbsp;
		            <%=c_db.getNameById(user_id, "USER")%></td>
		        </tr>		        
		        <tr>
		            <td class='title'> 계약진행자</td>
		            <td  colspan='3' align=""> &nbsp;&nbsp;
			            <select name='re_bus_id'>
			              <option value="">선택</option>
			              <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>							
				
			    		</select>
					</td>    						    	
		        </tr> 
		        <tr> 
			      	<td class="title" width="20%">메모</td>
			        <td  colspan='3' align="center"> 
			          <textarea name="content" cols="80" class="text" rows="5"></textarea>
			        </td>			 
			    </tr>
        	
	        </table>
	    </td>
    </tr>
    
    <tr>
	    <td align='right'>
	        <%if(!auth_rw.equals("1")){%>
	        <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	        <%}%>
	        <a href="javascript:pop_close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
