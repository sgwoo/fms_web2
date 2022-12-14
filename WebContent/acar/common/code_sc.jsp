<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*" %>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String c_st 		= request.getParameter("c_st")==null?"":request.getParameter("c_st");
		

	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");

	
	CommonDataBase c_db = CommonDataBase.getInstance();

	CodeBean code_r [] = c_db.getCodeAll(c_st);
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
function CodeUpdate(c_st, code, auth_rw)
{
	
	var SUBWIN="../common/code_c.jsp?from_page=<%=from_page%>&c_st="+c_st+"&code="+code+"&auth_rw="+auth_rw;	
	window.open(SUBWIN, "CodeDisp", "left=200, top=200, width=700, height=350, scrollbars=no");
		
}

function reg_code()
{
					
	var SUBWIN="../common/code_i.jsp?auth_rw=<%=auth_rw%>&from_page=<%=from_page%>&c_st=<%=c_st%>";	
	window.open(SUBWIN, "CodeDisp", "left=200, top=200, width=700, height=350, scrollbars=no");
}

function parent_reload(){
	var o_fm = parent.opener.form1;
	
	te = o_fm.app_b_st;

<%	if(code_r.length > 0){%>

	te.length = <%= code_r.length+1 %>;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%		for(int i = 0 ; i < code_r.length ; i++){
			code_bean = code_r[i];	%>

	te.options[<%=i+1%>].value 	= '<%= code_bean.getNm_cd() %>';
	te.options[<%=i+1%>].text 	= '<%= code_bean.getNm() %>';

<%		}
	}else{	%>
	
	te.length = 1;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%	}	%>

	alert('적용되었습니다. 기준금리를 선택하십시오.');

}

function CodeClose()
{
	parent.window.close();	
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
<body topmargin=0>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>


</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>
    <tr>
    	<td align='right' colspan='2'><a href='javascript:reg_code();' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a></td>
    </tr>
<%	}%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td class=title>연번</td>
            		<td class=title>코드</td>
            		<td class=title>사용코드명</td>
            		<td class=title>코드명칭</td>
            		<td class=title>
					<%if(c_st.equals("0001")){%>
					출처
					<%}else if(c_st.equals("0013")){%>
					판정기관
					<%}else if(c_st.equals("0018")||c_st.equals("0019")||c_st.equals("0020")||c_st.equals("0021")){%>
					거래처코드					
					<%}else if(c_st.equals("0022")){%>
					탁송금액
					<%}else{%>
					반영여부
					<%}%>					
					</td>
            		<%if(!from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
            		<td class=title>CMS사용코드(은행일때만 적용)</td>
            		<%}%>

            	</tr>
<%
    for(int i=0; i<code_r.length; i++){
         code_bean = code_r[i];
%>
                <tr>
                	<td align="center"><%= i+1%></td>
                    <td align=center><a href="javascript:CodeUpdate('<%= code_bean.getC_st() %>','<%= code_bean.getCode() %>',<%=auth_rw%>)"><%=code_bean.getCode()%></a></td>
                    <td align=center><%= code_bean.getNm_cd() %></td>
                    <td align=center><%= code_bean.getNm() %></td>
                    <td align=center>
					<%if(c_st.equals("0001")){%>
						<%if(code_bean.getApp_st().equals("1")) {%>국산
						<%}else if(code_bean.getApp_st().equals("2")){%>수입차
						<%}%>
	                <%}else if(c_st.equals("0013")){%>
						<%if(code_bean.getApp_st().equals("1")){%>KIS-법인
						<%}else if(code_bean.getApp_st().equals("2")){%>크레탐-개인
						<%}else if(code_bean.getApp_st().equals("3")){%>크레탑-법인
						<%}else{%>개인
						<%}%>						
					<%}else{%>
					<%= code_bean.getApp_st() %>
					<%}%>					
					</td>
					</td>					
                    <%if(!from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
                    <td align=center><%= code_bean.getCms_bk() %></td>
                    <%}%>

                </tr>
<%}%> 
<% if(code_r.length == 0) { %>
                <tr>
                    <td colspan=<%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>5<%}else{%>6<%}%> align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
<%}%>           	
             </table>
        </td>
    </tr>
    <%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
    <tr>
        <td>
        	<span class="b"><a href="javascript:parent_reload()" onMouseOver="window.status=''; return true" title="클릭하세요">[자금관리등록화면 적용]</a></span>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
	<tr>
		<td align='right'>
		<a href="javascript:CodeClose()" onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif border=0></a></td>
	</tr>        
    <%}%>
</table>
</body>
</html>