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
	
	MemoBean[] bns = memo_db.getReceList(user_id);
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">//���� ������
setInterval(function(){
	$(".blink").toggle();
	}, 1000);
</script> 
</head>
<body onLoad="javascript:self.focus()">
   <form action="./anc_u.jsp" name="AncDispForm" method="post">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	 <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�޸��� > <span class=style5>�����޸���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'>           
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                <td class="title" width="6%">����</td>
                <td class="title" width="13%">��������</td>
                <td class="title" width="10%">������</td>
                <td class="title" width=61%>����</td>
                <td class="title" width="10%">���ſ���</td>
              </tr>
    		  <% if(bns.length>0){
    				for(int i=0; i<bns.length; i++){ %>
              <tr> 
                <td align="center" ><%= i+1 %></td>
                <td align="center"><%= AddUtil.ChangeDate2(bns[i].getMemo_dt()) %></td>
                <td align="center"><%if(bns[i].getSend_id().equals("client")){
    									out.print("��");
    								}else if(bns[i].getAnonym_yn().equals("Y")){
    									out.print("�͸�");
    								}else{
    									out.print(c_db.getNameById(bns[i].getSend_id(), "USER"));
    								}%></td>
                <td>&nbsp;&nbsp;
                	<a href="memo_t_c.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>&memo_id=<%= bns[i].getMemo_id() %>" target="c_body"><%= bns[i].getTitle() %>
			  		</a>
                	<!-- New ó�� -->
			  		<%if(AddUtil.ChangeDate2(bns[i].getMemo_dt()).equals(AddUtil.getDate())){ %>
				  		&nbsp;<span class="blink" style="font-size:11px; font-weight: bold; color:rgba(238, 34, 0, 0.81); letter-spacing: -1px;">N ew</span>
			  		<%}%>
			  		<!-- New ó�� �� -->
                	</td>
                <td width="60" align="center">
    			<% if(!bns[i].getRece_yn().trim().equals("")){ 
    				StringTokenizer st2 = new StringTokenizer(bns[i].getRece_yn()," ",true);
    				int k2 = 0;
    				String[] seq2 = new String[st2.countTokens()];
    				while(st2.hasMoreTokens()){
    					String token = st2.nextToken();
    					if(user_id.equals(token)){
    						out.print("����");
    						break;
    					}
    					k2++;
    				}
    				//out.print("�̼���");
    			  }else{ %>
    				�̼���
    			<% } %></td>
              </tr>
    		  <% 	}//for��
    		  }else{ %>
    		  <tr>
    		  	<td colspan="5" align="center">���� �޸� �����ϴ�.</td>
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