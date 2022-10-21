<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, card.*,acar.common.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path , request.getInputStream());
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

	Workbook workbook = Workbook.getWorkbook(fi);
	
	//������ ù��° sheet ������ �´�. 
	Sheet sheet = workbook.getSheet(0);
	
	for(int i = 0; i < sheet.getRows(); i++){
	
		Hashtable ht = new Hashtable();
		
		for(int j = 0; j < sheet.getColumns(); j++){
			
			Cell cell = sheet.getCell(j,i);
			
			ht.put(Integer.toString(j), cell.getContents());
			
		}
		vt.add(ht);
	}
	
	int v_td_width = 120;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
			
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
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

	//����ϱ�
	function save(){
		fm = document.form1;
		
		var row_size = toInt(fm.value_line.value);		
		var cnt=0;
		var idnum="";
		
		for(var i=0 ; i<row_size ; i++){
			if(fm.ch_start[i].checked == true){
				cnt++;
				idnum=fm.ch_start[i].value;
			}
		}	
		if(cnt == 0){
		 	alert("�������� �����ϼ���.");
			return;
		}	
		if(cnt > 1){
		 	alert("�ϳ��� �����ุ �����ϼ���.");
			return;
		}		
			
		fm.start_row.value = idnum;
		
		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
		fm.action = 'excel_reg_a.jsp';
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
<input type='hidden' name='row_size' value='<%=sheet.getRows()%>'>
<input type='hidden' name='col_size' value='<%=sheet.getColumns()%>'>
<input type='hidden' name='start_row' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="<%=80+(v_td_width*sheet.getColumns())%>">
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
          <td width="50" class="title">������</td>         
                                <td width="<%=v_td_width%>" class="title">1)�������</td>
                                <td width="<%=v_td_width%>" class="title">2)�����ȣ</td>
                                <td width="<%=v_td_width%>" class="title">3)��û�Ͻ�</td><!-- ��û�Ͻ� �߰�(20181107)-->
                                <td width="<%=v_td_width%>" class="title">4)����</td>
                                <td width="<%=v_td_width%>" class="title">5)����ǰ��</td>
                                <td width="<%=v_td_width%>" class="title">6)�������</td>
                                <td width="<%=v_td_width%>" class="title">7)�������</td>
                                <td width="<%=v_td_width%>" class="title">8)���Ͻ�����</td>
                                <td width="<%=v_td_width%>" class="title">9)�Һ��ڰ�</td>
                                <td width="<%=v_td_width%>" class="title">10)����</td>
                                <td width="<%=v_td_width%>" class="title">11)������������</td>
                                <td width="<%=v_td_width%>" class="title">12)�������</td>
                                <td width="<%=v_td_width%>" class="title">13)���</td>
                                <td width="<%=v_td_width%>" class="title">14)�����</td>
                                <td width="<%=v_td_width%>" class="title">15)����</td>
                                <td width="<%=v_td_width%>" class="title">16)���ּ���</td>
                                <td width="<%=v_td_width%>" class="title">17)�Ƹ���ī����ȣ</td>
                                <td width="<%=v_td_width%>" class="title">18)��������</td>
                                <td width="<%=v_td_width%>" class="title">19)������Ʈ���⿩��</td>
                                <td width="<%=v_td_width%>" class="title">20)��ü��������</td>
                                <!--<td width="<%=v_td_width%>" class="title">21)Q�ڵ�</td>-->
                                <td width="<%=v_td_width%>" class="title">21)�������޹��</td>
                                <td width="<%=v_td_width%>" class="title">22)ī��/������</td>
                                <td width="<%=v_td_width%>" class="title">23)��������</td>
                                <td width="<%=v_td_width%>" class="title">24)ī��/���¹�ȣ</td>
                                <td width="<%=v_td_width%>" class="title">25)����/������</td>
                                <td width="<%=v_td_width%>" class="title">26)�������⿹����</td>
                                
        </tr>
      </table></td>
  </tr>  
  <tr>
    <td>* ������Ʈ���⿩��, ��ü�������ο� <!--Q�ڵ��--> �ش�Ǹ� �����빮�� Y �� �־��ֽʽÿ�. (���� ����)</td>
  </tr> 
  <tr>
    <td>* �������޹�� : ����=1, �ĺ�ī��=3 ���ڰ����� �־��ּ���.</td>
  </tr> 
  <tr>
    <td>* ī��/������� select�� <select name='con_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>'><%=bank.getNm()%></option>
                        <%		}
        					}%>
                        <%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>'><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
                    </select> �� �ִ� ���� �״�� �־��ּ���.</td>
  </tr> 
  <tr>
    <td>* �������޹���� ī���� ��� ���޹�ĸ� �ְ�, ���������� �Է����� �ʾƵ� �˴ϴ�.</td>
  </tr>
  <tr>
    <td>* �������� : ��������=1, �������=2 ���ڰ����� �־��ּ���.</td>
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
    	  <td width="30" class="title">����</td>
    	  <td width="50" class="title">������</td>	
    	  <td colspan='<%=sheet.getColumns()%>' class="title">���� ����Ÿ</td>
  		</tr>
<%
	int value_line = 0;
	int vt_size = vt.size();
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
		if(String.valueOf(content.get("0")).equals("") && String.valueOf(content.get("1")).equals("") && String.valueOf(content.get("2")).equals(""))  continue;%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=value_line+1%></td>
    	  <td width="50" align="center"><input name="ch_start" type="checkbox" class="style1" value="<%=value_line%>"></td>	
    	  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="<%=v_td_width%>" align="center"><input name="value<%=j%>" type="text" class=text style1   value="<%=content.get(Integer.toString(j))%>"size="13"></td>
    	  <%}%>
  		</tr>
<%		value_line++;
	}%>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>* �������� �����Ͻʽÿ�</td>
  </tr>  
  <tr>  
    <td align="left"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
<input type='hidden' name='value_line' value='<%=value_line%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<SCRIPT LANGUAGE="JavaScript">
<!--
//-->
</SCRIPT>
</BODY>
</HTML>