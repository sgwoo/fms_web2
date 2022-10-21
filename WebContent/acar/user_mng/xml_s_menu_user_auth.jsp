<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String m_st = request.getParameter("m_st")==null?"":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	
	UsersBean user_r [] = umd.getUserXmlAuthAll("", "acar", "",m_st,m_st2,m_cd); 
	
	MaMenuBean m_bean = nm_db.getXmlMenuCase(m_st,m_st2,m_cd);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>사용자관리</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function cng_display(idx){
		var fm = document.AuthForm;
		var size = toInt(fm.size.value);
		for(i=0; i<size; i++){	
			//외부사용자는 읽기로 고정					
		        if(fm.auth_rw[i].options[fm.auth_rw[i].selectedIndex].value.substring(0,6) == '000203'){		        
				fm.auth_rw[i].options[1].selected = true;
			}else{
			        if(fm.auth_rw[i].options[fm.auth_rw[i].selectedIndex].value.substring(12) != '6'){		        
					fm.auth_rw[i].options[idx].selected = true;
				}						
			}			
		}
	}
	function AuthReg(){
		var theForm = document.AuthForm;
		if(!confirm('권한부여하시겠습니까?')){
			return;
		}
		theForm.target = 'i_no';
		theForm.submit();
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

<body>

<form action="./xml_s_menu_user_auth_a.jsp" name="AuthForm" method="POST" >
<input type='hidden' name='size' value='<%=user_r.length%>'>

<table border=0 cellspacing=0 cellpadding=0  width=500>
    <tr>
        <td><font color=red>[소메뉴]</font> <%=m_bean.getM_nm()%> (<%=m_bean.getUrl()%>)</td>
    </tr>
    <tr>
        <td><hr></td>
    </tr>	 	
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="auth_st" value="0" onClick="javascript:cng_display(0)">접근제한
		 <input type="radio" name="auth_st" value="1" onClick="javascript:cng_display(1)">읽기
		 <input type="radio" name="auth_st" value="2" onClick="javascript:cng_display(2)">쓰기
		 <input type="radio" name="auth_st" value="3" onClick="javascript:cng_display(3)">수정
		 <input type="radio" name="auth_st" value="4" onClick="javascript:cng_display(4)">쓰기+수정
		 <input type="radio" name="auth_st" value="5" onClick="javascript:cng_display(5)">삭제
		 <input type="radio" name="auth_st" value="6" onClick="javascript:cng_display(6)">전체		 
		 </td>
    </tr>  
    <tr>
    	<td align=right><a href="javascript:AuthReg()"><img src=../images/pop/button_reg.gif border=0></a></td>
    </tr>    	 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td width=10% class=title>연번</td>
            		<td width=20% class=title>근무지</td>
            		<td width=20% class=title>부서</td>
            		<td width=30% class=title>이름</td>
            		<td width=20% class=title>권한</td>
            	</tr>
<%
    for(int i=0; i<user_r.length; i++){
        user_bean = user_r[i];
%>
            	<tr>
            		<td align="center"><%= i+1%></td>
            		<td align=center><%= user_bean.getBr_nm() %></td>
            		<td align=center><%= user_bean.getDept_nm() %></td>
            		<td align=center><%= user_bean.getUser_nm() %></td>
            		<td align=center>
					  <select name="auth_rw" <%if(!user_bean.getUser_aut().equals("0") && !user_bean.getUser_aut().equals(""))%> class='default'<%%>>
                        <option value="<%=user_bean.getUser_id()%><%=m_st%><%=m_st2%><%=m_cd%>0" <%if(user_bean.getUser_aut().equals("0"))%>selected<%%>>0</option>
                        <option value="<%=user_bean.getUser_id()%><%=m_st%><%=m_st2%><%=m_cd%>1" <%if(user_bean.getUser_aut().equals("1"))%>selected<%%>>1</option>
                        <option value="<%=user_bean.getUser_id()%><%=m_st%><%=m_st2%><%=m_cd%>2" <%if(user_bean.getUser_aut().equals("2"))%>selected<%%>>2</option>
                        <option value="<%=user_bean.getUser_id()%><%=m_st%><%=m_st2%><%=m_cd%>3" <%if(user_bean.getUser_aut().equals("3"))%>selected<%%>>3</option>
                        <option value="<%=user_bean.getUser_id()%><%=m_st%><%=m_st2%><%=m_cd%>4" <%if(user_bean.getUser_aut().equals("4"))%>selected<%%>>4</option>
                        <option value="<%=user_bean.getUser_id()%><%=m_st%><%=m_st2%><%=m_cd%>5" <%if(user_bean.getUser_aut().equals("5"))%>selected<%%>>5</option>
                        <option value="<%=user_bean.getUser_id()%><%=m_st%><%=m_st2%><%=m_cd%>6" <%if(user_bean.getUser_aut().equals("6"))%>selected<%%>>6</option>
                      </select>					
					</td>
            	</tr>
<%}%>
<% if(user_r.length == 0) { %>
            <tr>
                <td colspan=5 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>  
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>