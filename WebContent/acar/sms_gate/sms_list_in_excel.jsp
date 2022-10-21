<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String result[]  	= new String[value_line];
	String value0[]  	= request.getParameterValues("value0");//수신자
	String value1[]  	= request.getParameterValues("value1");//수신번호
	String value2[]  	= request.getParameterValues("value2");//문자내용
	
	String destname 	= "";
	String destphone	= "";
	String excel_msg	= "";
	
	//명단수 합계
	int sum = 0;
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="javascript">
	function send_list(){
		fm = document.form1;
		fm.submit();		
	}
</script>
</head>

<body>
<form name="form1" action="./send_list.jsp" method="post">
<input name="sendname" type="hidden" value="">
<input name="sendphone" type="hidden" value="">
<input name="msg" type="hidden" value="">
<input name="req_dt" type="hidden" value="">
<input name="req_dt_h" type="hidden" value="">
<input name="req_dt_s" type="hidden" value="">
<input name="msg_type" type="hidden" value="0">
<input name="gubun1" type="hidden" value="">
<input name="gubun2" type="hidden" value="">
<table width="580" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line">
	  <table width="100%" border="0" cellspacing="1" cellpadding="0">
        <%	for(int i=start_row ; i < value_line ; i++){
				sum = i+1;
				
				destname 		= value0[i] ==null?"":AddUtil.replace(value0[i],"_ ","");
				destphone 		= value1[i] ==null?"":AddUtil.replace(AddUtil.replace(value1[i],"-",""),"_ ","");
				excel_msg 		= value2[i] ==null?"":AddUtil.replace(value2[i],"_ ","");
				
				if(destname.length() > 10){
					destname = destname.substring(0,10);
				}
	%>
        <tr>
          <td width="27"  align="center"><input name="pr" type="checkbox" value="<%= i %>" checked></td>
          <td width="27"  align="center"><%=i+1%></td>
          <td width="132"  align="center"><input name="destname" type="text" class="white" size="15" readonly="true" value="<%=destname%>"></td>
          <td width="128"  align="center"><input name="destphone" type="text" class="white" size="13" readonly="true" value="<%=destphone%>"></td>
          <td width="255"  align="center"><input name="excel_msg" type="text" class="white" size="30" readonly="true" value="<%=excel_msg%>"></td>
        </tr>
        <% 	} %>
        <tr> 
          <td colspan="5" class="title">&nbsp;</td>
        </tr>
      </table>
	</td>
  </tr>
</table>
</form>
</body>
</html>
<script language="javascript">
	parent.parent.form1.total.value = '<%= sum %>';
</script>
