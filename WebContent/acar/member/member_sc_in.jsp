<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	Vector conts = new Vector();
	int cont_size = 0;
	
	
	if(!t_wd.equals("")){
		conts = m_db.getMemberList(s_gubun1, s_gubun2, s_gubun3, s_gubun4, s_kd, t_wd);
		cont_size = conts.size();
	}
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>

<script language="JavaScript">	
	//고객FMS 아이디 사용처리 ( use_yn을 "Y"로 )
	function set_member_id(idx, client_id){
		
		var fm = document.form1;
		
		if(!confirm('고객FMS를 사용할 수 있게 처리하시겠습니까?')){	return;	}		
	
		fm.target = "i_no";
		fm.action = "set_member_id.jsp?idx="+idx+"&client_id="+client_id;
	
		fm.submit();
	}
	
	
		
	
//-->
</script> 

<body>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class=line2></td>
    </tr>
    <tr>
		<td class='line2'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		            <td width=5% class='title'>연번</td>
		            <td width=10% class='title'>고객구분</td>
		            <td width=27% class='title'>상호</td>
		            <td width=10% class='title'>계약자</td>
		            <td class='title' width=10%>지점/현장</td>
		            <td class='title' width=15%>아이디</td>		       
		            <td class='title' width=7%>계약진행</td>		          
		            <td class='title' width=10%>고객서비스</td>
          		</tr>
			</table>
		</td>	
	</tr>
	
    <tr>       
        <td class='line' width='100%'> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable cont = (Hashtable)conts.elementAt(i);
				String yn=String.valueOf(cont.get("Y_CNT"));
//				%>
                <tr> 
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=5%><a name=<%=i+1%>><%=i+1%></a></td>
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=10%><%=cont.get("CLIENT_ST")%></td>
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=27%><a href="javascript:parent.getViewCont('<%=cont.get("IDX")%>','<%=cont.get("CLIENT_ID")%>','<%=cont.get("R_SITE")%>','<%=cont.get("MEMBER_ID")%>')"><span title='<%=cont.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(cont.get("FIRM_NM")), 20)%></span></a></td>
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=10%><span title='<%=cont.get("CLIENT_NM")%>'><%=AddUtil.subData(String.valueOf(cont.get("CLIENT_NM")), 5)%></span></td>
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=10%> 
                        <span title='<%=cont.get("R_SITE_NM")%>'><%=AddUtil.subData(String.valueOf(cont.get("R_SITE_NM")), 10)%></span></td>
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=15%> 
                        <%if(!String.valueOf(cont.get("MEMBER_ID")).equals("")){%>
                        <%if(String.valueOf(cont.get("MEMBER_ID")).equals("amazoncar")){%>
                        <%=cont.get("MEMBER_ID")%> 
                        <%}else{%>
                        <strong><font color=#CC9933><%=cont.get("MEMBER_ID")%></font></strong> 
                        <%}%>
                        <%}else{%>
                        <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                       <!--  <a href="javascript:parent.getRegMemberId('<%=i+1%>','<%=cont.get("CLIENT_ID")%>','<%=cont.get("R_SITE")%>','<%=cont.get("MEMBER_ID")%>','<%=cont.get("PW")%>')">ID등록</a> -->
                        <%	}else{%>
                        -
                        <%}%>
                        <%}%>
                        &nbsp;&nbsp;
                        <% if ( String.valueOf(cont.get("USE_YN")).equals("N")  ) { %>  <!--  use_yn을 "Y"로 처리  -->                        
                        <input type="button" class="button" value="고객FMS 사용처리" onclick="javascript:set_member_id('<%=cont.get("IDX")%>', '<%=cont.get("CLIENT_ID")%>');">
                        <% } %>
                      </td>
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=7%><%=cont.get("Y_CNT")%>건</td>
                      <td <%if(yn.equals("0"))%>class=g<%%> align='center' width=10%>
            		  <% if(auth_rw.equals("4")||auth_rw.equals("5")||auth_rw.equals("6")){ %>    
            			   <% if ( String.valueOf(cont.get("USE_YN")).equals("N") ||  String.valueOf(cont.get("MEMBER_ID")).equals("") ) { %> - <% } else { %>     			  
            			  <a href="javascript:parent.getLogin2('<%=cont.get("MEMBER_ID")%>','<%=cont.get("PWD")%>')"><img src=../images/center/button_in_login.gif border=0 align=absmiddle></a>            		  
            		  		<% } %>
            		  <% } %>
            		  </td>            		  		 
                </tr>
                <%	}
        		}else{%>
                <tr> 
                    <td align='center' colspan="9">해당 데이타가 없습니다.</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
	<%if(t_wd.equals("")){%>
	<tr>
		<td>* 검색단어로 조회하십시오.</td>
    </tr>
	<%}%>	
</table>
<form  name="form1" method="POST">

<input type="hidden" name="idx" >
<input type="hidden" name="client_id" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</form>
</body>
</html>
