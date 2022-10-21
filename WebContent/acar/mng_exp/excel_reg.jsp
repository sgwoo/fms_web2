<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>

<%
	// ���������� ���ε�� ����
	String uploadPath = request.getSession().getServletContext().getRealPath("/file/");

	// �������� �ִ� ũ��
	int sizeLimit = 50 * 1024 * 1024 ;

	// �������� ���ε�
	MultipartExcelUpload excelUploadComponent = MultipartExcelUpload.getInstance();

	Hashtable parameters = new Hashtable();

	parameters = excelUploadComponent.MultipartRequestExcelSave(request, response, sizeLimit, uploadPath);

	Vector vt = excelUploadComponent.getExcelData(response, uploadPath, (String) parameters.get("fileName"));

	if (vt == null) {
		out.write("���� ������ �о������ ���߽��ϴ�.");

		return;
	}

	int rowSize = vt.size();

	if (rowSize == 0 || vt.get(0) == null) {
		out.write("���� ���� ������ �����ϴ�.");

		return;
	}

	int columnSize = ((ArrayList) vt.elementAt(0)).size();

	String gubun1 = (String) parameters.get("gubun1");
	String user_id = (String) parameters.get("user_id");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<script language="JavaScript" src="/acar/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
	
		fm.start_row.value = '1';
		
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
	//	fm.action ="https://fms3.amazoncar.co.kr/acar/admin/mng_exp_excel_reg_a.jsp?exp_st="+fm.exp_st.value+"&dt1="+fm.dt1.value+"&dt2="+fm.dt2.value;
		
		fm.target= '_parent';
			
		fm.action = "excel_reg_a.jsp?exp_st="+fm.exp_st.value+"&dt1="+fm.dt1.value+"&dt2="+fm.dt2.value;
		fm.submit();
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
<input type='hidden' name='user_id' value='<%= user_id %>'>
<input type='hidden' name='gubun1' value='<%= gubun1 %>'>
<input type='hidden' name='row_size' value='<%= rowSize %>'>
<input type='hidden' name='col_size' value='<%= columnSize %>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%= 70 + (120 * columnSize)%>">
  <tr>
    <td>&lt; ���� ���� �б� &gt; </td>
  </tr>
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td align="center"><span class="style1">- ����� - </span></td>
  </tr>
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td width="30" class="title">����</td>
          <td width="40" class="title">������</td>
          <td width="120" class="title">�����ڵ�</td>
          <td width="120" class="title">������ȣ</td>		  
          <td width="120" class="title">������</td>
          <td width="120" class="title">������</td>
          <td width="120" class="title">���μ���</td>
          <td width="120" class="title">��������</td>
          <td width="120" class="title">��������</td>		  		  
          <td width="120" class="title">����</td>		  
        </tr>
      </table></td>
  </tr>  
  <tr>
    <td><hr></td>
  </tr>
  <tr>
    <td>&lt; ���� &gt; </td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="100" height="30" rowspan="2" class="title">����</td>
    	  <td width="150">&nbsp;
		    <select name='exp_st'>
              <option value='3'>�ڵ�����</option>
              <option value='2'>ȯ�氳���δ��</option>
            </select></td>
    	  <td width="100" height="30" rowspan="2" class="title">��������</td>
    	  <td width="150">&nbsp;
		  <input name="dt1" type="text" class=text value="" size="12"></td>
    	  <td width="100" height="30" class="title">��������</td>
    	  <td>&nbsp;
		  <input name="dt2" type="text" class=text value="" size="12"></td>
        </tr>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
  </tr>    
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0">  
        <tr>
    	  <td width="30" class="title">����</td>
    	  <td width="40" class="title">������</td>	
    	  <td colspan='<%=columnSize%>' class="title">���� ����Ÿ</td>
  		</tr>
<%
	int vt_size = vt.size();

	int value_line = 0;

	for (int i = 0 ; i < vt_size ; i++) {
		ArrayList content = (ArrayList) vt.elementAt(i);

		if (String.valueOf(content.get(0)).equals("")
		 && String.valueOf(content.get(1)).equals("")
		 && String.valueOf(content.get(2)).equals("")) {
			continue;  
		}
%>
        <tr>
    	  <td width="30" height="30" class="title"><%= (i + 1) %></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%= i %>"></td>	
<%		for (int j = 0; j < columnSize; j++) { %>
    	  <td width="120" align="center"><input name="value<%= j %>" type="text" class=text style1 value="<%= content.get(j) %>" size="13"></td>
<%		} %>
  		</tr>
<%
		value_line = i + 1;
	}
%>
	  </table>
	</td>
  </tr> 
  <tr>
    <td>* �������� �����Ͻʽÿ�</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
<input type='hidden' name='value_line' value='<%=value_line%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>