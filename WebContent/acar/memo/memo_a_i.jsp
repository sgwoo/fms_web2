<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ page import="acar.memo.*" %>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String user_pos = request.getParameter("user_pos")==null?"":request.getParameter("user_pos");
	String memo_id = request.getParameter("memo_id")==null?"":request.getParameter("memo_id");
	int count = 0;
	
	MemoBean bn = memo_db.getMemo(memo_id);
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function reply(){
	fm = document.form1;	
	if(fm.title.value == ''){	alert('제목을 입력하십시오');	return;	}
	else if(fm.content.value == ''){	alert('내용을 입력하십시오');	return;	}
	else if(get_length(fm.content.value) > 4000){
		alert("2000자 까지만 입력할 수 있습니다.");
		return;
	}
	if(!confirm("답장을 보내겠읍니까?")){ return; }
	fm.action='memo_reply.jsp';
	fm.target="i_no";
	fm.submit();	
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <form action="" name="form1" method="post">
	  <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>메모함 > <span class=style5>답장쓰기</span></span></td>
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
    <tr> 
        <td class='line'>           
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width=15%>받는이</td>
                    <td>&nbsp;<%if(bn.getSend_id().equals("client")){
        									out.print("고객");
        								}else if(bn.getAnonym_yn().equals("Y")){
        									out.print("익명");
        								}else{
        									out.print(c_db.getNameById(bn.getSend_id(), "USER"));
        								}%></td>
                </tr>
                <tr> 
                    <td class="title" width=85%>제목</td>
                    <td> 
                      <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
                        <tr> 
                          <td>
                            <input type="text" name="title" value="[답변]<%= bn.getTitle() %>" size="70">
                          </td>
                        </tr>
                      </table>
                    </td>
                </tr>
                <tr> 
                    <td class="title">내용</td>
                    <td style="height:280" valign="top"> 
                        <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
                            <tr> 
                                <td> 
                                    <textarea name="content" cols='80' rows='23'><%= bn.getContent() %></textarea>
                                </td>
                                </tr>
                      </table>
                    </td>
                </tr>
            </table>
              <input type="hidden" name="user_id" value="<%=user_id%>">
              <input type="hidden" name="user_pos" value="<%=user_pos%>">
              <input type="hidden" name="memo_id" value="<%=memo_id%>">
    		  <input type="hidden" name="send_id" value="<%=bn.getSend_id()%>">
    		  <input type="hidden" name="anonym_yn" value="<%=bn.getAnonym_yn()%>">
              <input type="hidden" name="cmd" value="">
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    
        <td align="right">
	  	<a href="javascript:reply();" target="c_body"><img src=../images/center/button_memo_res.gif border=0></a>
	  	<a href="memo_t_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>" target="c_body"><img src=../images/center/button_list.gif border=0></a></td>
    </tr>	  
    </form>
</table>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
