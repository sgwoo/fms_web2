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
	
	boolean bool = memo_db.rece_yn(memo_id,user_id);
	MemoBean bn = memo_db.getMemo(memo_id);
	MemoBean[] bns = memo_db.getSendList(user_id);
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
</head>
<body onLoad="javascript:self.focus()">
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <form action="./anc_u.jsp" name="AncDispForm" method="post">
  	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>메모함 > <span class=style5> 
보낸메모 읽기
						</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class='line'>           
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width=12%>보낸이</td>
                    <td align="center" width=38%><%= c_db.getNameById(bn.getSend_id(), "USER") %></td>
                    <td class="title" width=12%>보낸일자</td>
                    <td align="center" width=38%><%= AddUtil.ChangeDate2(bn.getMemo_dt()) %></td>
                </tr>
                <tr> 
                    <td class="title">받는이 </td>
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
			    <tr> 
                    <td class="title">제목</td>
                    <td colspan="3"> 
                        <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
                            <tr> 
                                <td><%= bn.getTitle() %></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class="title">내용</td>
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
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>   
        <td align="right"><a href="javascript:history.go(-1)"><img src=../images/center/button_list.gif border=0></a></td>
    </tr>	  
    </form>
</table>
</body>
</html>
