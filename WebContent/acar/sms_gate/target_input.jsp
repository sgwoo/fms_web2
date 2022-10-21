<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>

<%
	int width = 300;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function checkNaN(num)
{
	if(isNaN(num))
		return 0;
	else
		return num;
}
	function toInt(str)
	{
		var num = parseInt(str, 10);
		return checkNaN(num);
	}

	//등록하기
	function save(){
		fm = document.form1;
		
		var row_size=0;
								
		<%for (int i = 0 ; i < 20 ; i++){%> 
		if(fm.value1[<%=i%>].value != '') row_size++;
		<%}%> 
												
		fm.row_size.value = row_size;												
		fm.value_line.value = row_size;														
												
												
		if(!confirm("등록하시겠습니까?"))	return;
				
		opener.smsList.smsList_t.location.href = "./sms_list_t.jsp";
		fm.target = "smsList_in";
		fm.action = "./sms_list_in_excel.jsp";
		fm.submit();
		
		window.close();
	}
//-->
</SCRIPT>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</HEAD>
<BODY>
<p>
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='row_size' value='<%=0%>'>
<input type='hidden' name='col_size' value='<%=2%>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%=30+(width*2)%>">
  <tr>
    <td>&lt; 수신자 직접 작성 &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td align="center"><span class="style1">- 양식폼 - </span></td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td width="30" class="title">연번</td>
          <td width="<%=width%>" class="title">수신자</td>
          <td width="<%=width%>" class="title">수신번호</td>
        </tr>
      </table></td>
  </tr>  
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="30" class="title">연번</td>
    	  <td colspan='<%=2%>' class="title">직접작성</td>
  		</tr>
<%
	for (int i = 0 ; i < 20 ; i++){%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i+1%></td>
    	  <td width="<%=width%>" align="center"><input name="value0" type="text" class=text style1   value="<%//=content.get(Integer.toString(j))%>"size="40"></td>
    	  <td width="<%=width%>" align="center"><input name="value1" type="text" class=text style1   value="<%//=content.get(Integer.toString(j))%>"size="20">
    	  <input name="value2" type="hidden" class=text style1   ></td>
<%	} %>
  		</tr>
	  </table>
	</td>
  </tr> 
  <tr>
    <td>&nbsp;</td>
  </tr>        
  <tr>  
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
<input type='hidden' name='value_line' value='<%=20%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>