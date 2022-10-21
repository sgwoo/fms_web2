<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String msg = request.getParameter("msg")==null?"":request.getParameter("msg");
	String senddate = request.getParameter("senddate")==null?"":request.getParameter("senddate");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Vector resultList = umd.getSmsResult_msg_V5(msg);
	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//-->
</script>
</head>
<body>
<form name="form1" method="post">
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
          <%	if(resultList.size() !=0 ){
		for(int i=0; i< resultList.size(); i++){
			Hashtable ht = (Hashtable)resultList.elementAt(i);
			String status = (String)ht.get("STATUS");
			String rslt  =  (String)ht.get("CALL_RESULT");
%>
          <tr> 
            <td width="30" align="center"><%= i+1 %></td>
            <td width="80" align="center"><%= ht.get("DEST_NAME") %></td>
            <td width="80" align="center"><%= ht.get("DEST_PHONE")%></td>
            <td width="100" align="center">
              <%if(status.equals("0")) out.print("���");
        														else if(status.equals("1")) out.print("�߼���");
        														else if(status.equals("2")) out.print("�߼ۿϷ�");
        														else if(status.equals("3")) out.print("�߼ۿ���"); %>
            </td>
            <td width="100" align="center">
              <% if(rslt.equals("4100")) out.print("����!");
        														else if(rslt.equals("4400")) out.print("��������");
        														else if(rslt.equals("4410")) out.print("�߸�����ȭ��ȣ");
        														else if(rslt.equals("4420")) out.print("��Ÿ����");
        														else if(rslt.equals("4430")) out.print("���Űź�"); %>
            </td>
            <td width="150" align="center"><%= AddUtil.ChangeDate3((String)ht.get("SEND_TIME")) %></td>
            <td width="152" align="center"><%= AddUtil.ChangeDate3((String)ht.get("REPORT_TIME")) %></td>
          </tr>
          <% 		}
	}else{ %>
          <tr> 
            <td colspan="7" align="center">�ش� �����Ͱ� �����ϴ�. </td>
          </tr>
          <% 	} %>
          <tr>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
          </tr>
		  
        </table></td>
  </tr>
</table>
</form>
</body>
</html>