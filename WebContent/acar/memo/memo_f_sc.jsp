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
	
	MemoBean[] bns = memo_db.getSendList(user_id);
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
function UpDisp()
{
	var theForm = document.AncDispForm;
	theForm.submit();
}
function AncClose()
{
	opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <form action="./anc_u.jsp" name="AncDispForm" method="post">
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>메모함 > <span class=style5>보낸메모함
						</span></span></td>
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
                    <td class="title" width=7%>연번</td>
                    <td class="title" width=13%>보낸일자</td>
                    <td class="title" width=11%>받는이</td>
                    <td class="title" width=56%>제목</td>
                    <td class="title" width=13%>수신확인</td>
                </tr>
		  <% if(bns.length>0){
		  		for(int i=0; i<bns.length; i++){ %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= AddUtil.ChangeDate2(bns[i].getMemo_dt()) %></td>
                    <td align="center">
                        <table border=0 cellspacing=0 width=100% cellpadding=3>
                            <tr>        
                                <td align=center>
                				<% if(bns[i].getAnonym_yn().equals("Y")){
                						out.print("익명");
                					}else{
                						StringTokenizer st = new StringTokenizer(bns[i].getRece_id()," ",true);
                						String[] seq = new String[st.countTokens()];
                						int k = 0;
                						while(st.hasMoreTokens()){
                							String token = st.nextToken();
                							out.print(c_db.getNameById(token, "USER")+" ");
                							k++;
                						}
                					}%>
                				</td>
                			</tr>
                		</table>
			        </td>
                    <td>&nbsp;<a href="memo_f_c.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>&memo_id=<%= bns[i].getMemo_id() %>" target="c_body"><%= bns[i].getTitle() %></a></td>
                    <td align="center">
        			<%	StringTokenizer st3 = new StringTokenizer(bns[i].getRece_id()," ",true);
        				String[] seq3 = new String[st3.countTokens()];
        					
        				StringTokenizer st2 = new StringTokenizer(bns[i].getRece_yn()," ",true);
        				String[] seq2 = new String[st2.countTokens()];
        				
        			 if(bns[i].getRece_yn().equals("")){ %>
        				미수신
        			<% }else{
        				if(seq3.length==seq2.length){ %>
        					 수신완료
        			  <%}else{%>
        					<%
        					int k2 = 0;				
        					while(st2.hasMoreTokens()){
        						String token = st2.nextToken();
        						out.print(c_db.getNameById(token, "USER")+" ");
        						k2++;
        					}
        					%>
        			<%  }//if
        			  }//if %></td>
                </tr>
		  <% 	}
		  }else{ %>
		        <tr>
		  	        <td colspan="5" align="center">보낸 메모가 없읍니다.</td>
		        </tr>
		  <% } %>
            </table>
              <input type="hidden" name="user_id" value="<%=user_id%>">
              <input type="hidden" name="user_pos" value="<%=user_pos%>">
              <input type="hidden" name="memo_id" value="<%=memo_id%>">
              <input type="hidden" name="cmd" value="">
        </td>
    </tr>
    </form>
</table>
</body>
</html>
