<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
function select_doc_app(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("ī�带 �����ϼ���.");
			return;
		}	
				
		if(confirm('�ϰ������Ͻðڽ��ϱ�?')){
			fm.target = "i_no";
			fm.action = "doc_app_step.jsp";
			fm.submit();
		}
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	int cnt = 3; //��Ȳ ��� ������ �Ѽ�
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-260;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<form name='form1'  method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='cardno' value=''>
<input type='hidden' name='buy_id' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
<tr><td>  
  		
		&nbsp;&nbsp;
		<input type="button" class="button" value='�ϰ�����' onclick='javascript:select_doc_app();'>
	</td>
	</tr>			    
    <tr> 
      <td height="<%=height%>"><iframe src="doc_app_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--����ͳ��� - sh ���� - ��ܸ޴� ���� - (���μ�*40)-->
    </tr>  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
