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
	
	//����Ȯ��
	boolean bool = memo_db.rece_yn(memo_id,user_id);
	MemoBean bn = memo_db.getMemo(memo_id);
	MemoBean[] bns = memo_db.getSendList(user_id);
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function rece_yn()
{
	var fm = document.form1;
	var rece_yn = "<%= bn.getRece_yn() %>";
	var yn = rece_yn.indexOf("<%= user_id %>");
	if(yn>-1){ alert("�̹� ����Ȯ�� �ϼ����ϴ�."); return; }
	else{
		if(!confirm("����Ȯ�� �ϰ����ϱ�?")){ return; }
		fm.target = "i_no";
		fm.action = "memo_rece_yn.jsp";
		fm.submit();
	}
}
function list(){
	parent.opener.location.reload();
	location.href = "memo_t_sc.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>";
}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()" onUnload="javascript:parent.opener.location.reload();">
<form action="" name="form1" method="post">  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�޸��� > <span class=style5> �����޸� �б�	</span></span></td>
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
                    <td class="title" width=12%>������</td>
                    <td align="center" width=38%><%if(bn.getSend_id().equals("client")){
        									out.print("��");
        								}else if(bn.getAnonym_yn().equals("Y")){
        									out.print("�͸�");
        								}else{
        									out.print(c_db.getNameById(bn.getSend_id(), "USER"));
        								}%></td>
                      <td class="title" width=12%>��������</td>
                      <td align="center" width=38%><%= AddUtil.ChangeDate2(bn.getMemo_dt()) %></td>
                </tr>
        
        			 <% if(!bn.getAnrece_yn().equals("Y")){ %>
        			
                <tr>                 			
                    <td class="title">�޴��� </td>
                    <td colspan="3"> 
                        <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">        			
                            <tr>         				  
                                <td>
        						<% 					
        							StringTokenizer st = new StringTokenizer(bn.getRece_id()," ");
        
        							while(st.hasMoreTokens())
        										
        
        								out.print(c_db.getNameById(st.nextToken(), "USER")+" ");
        								%>
        					    </td>
                            </tr>
        				
                        </table>
                    </td>
                </tr>
		
			<%}%>
			
                <tr> 
                    <td class="title">����</td>
                    <td colspan="3"> 
                        <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
                          <tr> 
                            <td><%= bn.getTitle() %></td>
                          </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="title">����</td>
                    <td colspan="3" style="height:280" valign="top"> 
                        <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
                            <tr> 
                                <td> 
                          
                                <textarea name="content" cols='85' rows='23'><%= bn.getContent() %></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
          </table>
          <input type="hidden" name="user_id" value="<%=user_id%>">
          <input type="hidden" name="user_pos" value="<%=user_pos%>">
          <input type="hidden" name="memo_id" value="<%=memo_id%>">
          <input type="hidden" name="cmd" value="">
        </td>
    </tr>
    <tr>
		<td class=h ></td>
	</tr>
    <tr>
	    
      <td align="right">
	  <%// if(bn.getRece_yn().indexOf(user_id)<0){ <a href="javascript:rece_yn();">����Ȯ��</a> ||  } %>
	  <% if(!bn.getSend_id().equals("client") && !bn.getAnonym_yn().equals("Y")){ %><a href="memo_a_i.jsp?user_id=<%=user_id%>&user_pos=<%=user_pos%>&memo_id=<%=memo_id%>" target="c_body"><img src=../images/center/button_memo_re.gif border=0></a><% } %>
      <a href="javascript:list();"><img src=../images/center/button_list.gif border=0></a></td>
    </tr>	  
    </form>
 </table>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
