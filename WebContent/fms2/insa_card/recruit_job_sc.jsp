<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	InsaRcDatabase icd = new InsaRcDatabase();
	List<Insa_Rc_JobBean> list=icd.selectInsaRcJobAll();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function modifyInfo(theURL,winName,features) { 
		window.open(theURL,winName,features);
	}
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form2' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
   	<%	if(list.size()==0){%>
   	<tr>
		<td>-----���� �������� �ʽ��ϴ�.-----</td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_job.jsp?rc_no=0', 'qfList', 'left=350, top=50, width=850, height=600, scrollbars=yes, status=yes');">���</button>
		</td>
	</tr> 	  
	<%	}else{
			for(Insa_Rc_JobBean dto:list){
								
				String content = dto.getRc_job_cont();
				if(!content.contains("<div>")){ //�ű� �����ͷ� �ۼ��� ������ �ƴϸ� \r\n ���� <br/>�±׷� ġȯ��
					content = content.replaceAll("\r\n","<br/>");
				}				
	%>    
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_job.jsp?rc_no=<%=dto.getRc_no()%>', 'qfList', 'left=350, top=50, width=850, height=600, scrollbars=yes, status=yes');">����</button>
		</td>
	</tr>   
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				<input type="hidden" name="reg_id" value="<%=dto.getReg_id()%>">
				<input type="hidden" name="rc_no" value="<%=dto.getRc_no()%>">
											
	        	<tr>
	        		<td class='title' width='20%'>����</th>
	        		<td width='80%'>&nbsp;<b><%=dto.getRc_nm() %></b></td>
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>��������</th>
	        		<td width='80%'>&nbsp;<%=content%></td>
	        	</tr> 
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	  
    <%
	     }
	%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_job.jsp?rc_no=0', 'qfList', 'left=350, top=50, width=850, height=600, scrollbars=yes, status=yes');">�߰����</button>
		</td>
	</tr>
	<%
	   }
	%>   
  </table>

</form>
</body>
</html>
