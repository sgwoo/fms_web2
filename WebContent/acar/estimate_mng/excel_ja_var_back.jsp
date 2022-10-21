<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>

<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path, request.getInputStream());	
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

	Workbook workbook = Workbook.getWorkbook(fi);
	
	

	//������ ù��° sheet ������ �´�. 
	Sheet sheet = workbook.getSheet(0);
	
	
	for(int i = 0; i < sheet.getRows(); i++){
	
		Hashtable ht = new Hashtable();
		
		for(int j = 0; j < sheet.getColumns(); j++){
			
			Cell cell = sheet.getCell(j,i);
						
			double numberb2 = 0; 
			
			//���ڵ������϶� Float �ΰ� (�Ҽ���3�ڸ� �̻� ó������)
			if ( ( j==5 || (j>6 && j<13) || (j>14 && j<19) || j==20 || j==21 || j==37 || j==38 || (j>40 && j<44) || (j>44 && j<48) || j==53 || (j>55 && j<65) ||  (j>67 && j<73)  || j==83 || (j>87 && j<92) || j>160) 
			     && 
			     cell.getType() == CellType.NUMBER
			   ) { 
				
  				NumberCell nc = (NumberCell) cell; 
  				numberb2 = nc.getValue(); 
  				
  				ht.put(Integer.toString(j), String.valueOf(numberb2));
			}else{
				
				ht.put(Integer.toString(j), cell.getContents());
			} 
			
		}
		vt.add(ht);
	}
	
	int value_line = 0;
	int vt_size = vt.size();
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		
		var row_size = <%=sheet.getRows()%>;
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
		//fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/excel_ja_var_a.jsp';
		fm.action = 'excel_ja_var_a.jsp';
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
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width="<%=70+(120*sheet.getColumns())+60%>">
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
    <td>&nbsp;</td>
  </tr>      
  <tr>
      <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
              <tr>    	  
    	          <td width="150" height="30" class="title">��������</td>
    	          <td>&nbsp;<input name="reg_dt" type="text" class=text value="<%=AddUtil.getDate()%>"size="18" style1></td>
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
          <td width="120" class="title">0 �����ڵ�</td>
          <td width="120" class="title">1 ������</td>
          <td width="120" class="title">2 ����</td>
          <td width="120" class="title">3 �����Ǹſ���</td>
          <td width="120" class="title">4 ��������</td>
          <td width="120" class="title">5 ����������<br>24�����ܰ���</td>
          <td width="120" class="title">6 �Ϲݽ¿�<br>LPG����</td>
          <td width="120" class="title">7 �⺻Ư�Ҽ���</td>
          <td width="120" class="title">8 ���ν���Ư�Ҽ���</td>
          <td width="120" class="title">9 �����ܰ���<br>�����¼�</td>
          <td width="120" class="title">10 ȯ�溯��<br>(36����ȿ�����)</td>
          <td width="120" class="title">11 �縮��ȯ�溯��</td>
          <td width="120" class="title">12 �⺻����<br>�ܰ����¼�</td>
          <td width="120" class="title">13 �⺻����<br>����</td>
          <td width="120" class="title">14 �ʰ���������<br>�ܰ����¼�</td>
          <td width="120" class="title">15 ���û�簡��<br>�ܰ����¼�</td>
          <td width="120" class="title">16 ���û����������<br>�����ܰ����¼�</td>
          <td width="120" class="title">17 g1, g2 ��������</td>
          <td width="120" class="title">18 ����ũ��������</td>
          <td width="120" class="title">19 �����Ǹſ���</td>
          <td width="120" class="title">20 ǥ������Ÿ��ʰ�1��km���߰�����������(������,�縮������������)</td>
          <td width="120" class="title">21 ǥ������Ÿ��ʰ�1��km���߰�����������(��������Ÿ�����)</td>
          <td width="120" class="title">22 �����з��ڵ�</td>
          <td width="120" class="title">23 ����������</td>
          <td width="120" class="title">24 ��ⷮ</td>
          <td width="120" class="title">25 Ź�۷�(����)</td>
          <td width="120" class="title">26 Ź�۷�(�λ�)</td>
          <td width="120" class="title">27 Ź�۷�(����)</td>		  
          <td width="120" class="title">28 Ź�۷�(�뱸)</td>
          <td width="120" class="title">29 Ź�۷�(����)</td>		  
          <td width="120" class="title">30 tuixŹ�۷�(����)</td>
          <td width="120" class="title">31 tuixŹ�۷�(�λ�)</td>
          <td width="120" class="title">32 tuixŹ�۷�(����)</td>		  
          <td width="120" class="title">33 tuixŹ�۷�(�뱸)</td>
          <td width="120" class="title">34 tuixŹ�۷�(����)</td>		  
          <td width="120" class="title">35 LPGŰƮ����</td>
          <td width="120" class="title">36 �����л�LPGŰƮ���</td>		  
          <td width="120" class="title">37 ����������������Ʈ</td>
          <td width="120" class="title">38 ������������������</td>
          <td width="120" class="title">39 ��Ʈ�����</td>
          <td width="120" class="title">40 ���������</td>
          <td width="120" class="title">41 �Һ�������12/24����</td>
          <td width="120" class="title">42 �Һ�������36����</td>
          <td width="120" class="title">43 �Һ�������48�����̻�</td>
          <td width="120" class="title">44 ������������</td>		  
          <td width="120" class="title">45 ȯ�氳���δ�ݺδ���</td>
          <td width="120" class="title">46 ��ü���ȿ��D-�븮����������</td>		  
          <td width="120" class="title">47 ��ü���ȿ��E-����������޿���</td>		  
          <td width="120" class="title">48 ��ü���ȿ��G-�߰��ݾ�</td>				    		  		  		  		  		  		  	
          <td width="120" class="title">49 ����������</td>		
          <td width="120" class="title">50 �ܱ�뿩����</td>		
          <td width="120" class="title">51 ����Ÿ������Ѱ��ɿ���</td>		
          <td width="120" class="title">52 ��������������</td>		
          <td width="120" class="title">53 ī�帮����Ʈ��</td>				  
          <td width="120" class="title">54 ����Ʈ����</td>				  
          <td width="120" class="title">55 ������ ����</td>		
          <td width="120" class="title">56 ���������������</td>		          
          <td width="120" class="title">57 Ư��DC��</td>		          
          <td width="120" class="title">58 ��������¼�/td>		          
          <td width="120" class="title">59 ���� �ܱ⸶��������ġ</td>
          <td width="120" class="title">60 0�����ܰ������� ���� ����DC��</td>		          
          <td width="120" class="title">61 ��ü��������</td>
          <td width="120" class="title">62 �������� �ݿ����� �����¼�</td>
          <td width="120" class="title">63 �縮�������� ���� �¼�</td>
          <td width="120" class="title">64 �Ϲݽ� ������ ���� �¼�</td>
          <td width="120" class="title">65 ģȯ���� ����</td>
          <td width="120" class="title">66 ���κ����� ���޿���</td>
          <td width="120" class="title">67 0�����ܰ� ������ ����</td>
          <td width="120" class="title">68 0���� �����ܰ� ������</td>
          <td width="120" class="title">69 �Ϲݽ¿�LPG ������ ����60���� �̻��� ��� �ܰ� ������</td>
          <td width="120" class="title">70 �Ϲݽ¿�LPG ������� ����60���� �̻��� ��� �ܰ� ������</td>
          <td width="120" class="title">71 1000km�� �߰����� ������ �ݿ��¼�(��������Ÿ� ����)</td>
          <td width="120" class="title">72 �縮�� �ܱ� ������ ����ġ&nbsp;</td>
          <td width="120" class="title">73 ������ ���κ�����&nbsp;</td>
          <td width="120" class="title">74 ������ ��ƼĿ �߱޴��(�ش�1)&nbsp;</td>
          <td width="120" class="title">75 ��������&nbsp;</td>
          
          <!-- ����ȿ�� ���� �÷��߰�(20180528) -->
          <td width="120" class="title">76 ����ȿ�� ��� ��������(�ش�1)</td>
          <td width="120" class="title">77 ���Ⱑ�ɿ���-������Ͽ���</td>
          <td width="120" class="title">78 ����ȿ�� �ݰ��Ⱓ(��)X2</td>
          <td width="120" class="title">79 ����Ұ����</td>
          <td width="120" class="title">80 ���� ���Ⱑ�ɰ��� �뿩������(����)(10��31�� �뿩�������, 10��31�� - 1��1��)</td>
          <td width="120" class="title">81 ���� ��� �����ϼ� + 7��</td>
          <td width="120" class="title">82 ���� ����ȿ�� �ִ밪(�뿩 �����ϱ���)</td>
          <td width="120" class="title">83 ���� ����Ÿ� ���ȿ�� �ݿ���(����Ȯ���� ��ʰ���)</td>
          <td width="120" class="title">84 ���Ⱑ���� ������ϳ⵵ ������(������)</td>
          <td width="120" class="title">85 �縮�� ���Ⱑ�ɰ��� �뿩������(����)(10��31�� �뿩�������, 10��10�� - 1��1��)</td>
          <td width="120" class="title">86 ����ȿ�� �ִ밪(������)</td>
          <td width="120" class="title">87 ����ȿ�� �ִ밪(�縮�� �������)</td>
          <td width="120" class="title">88 �縮�� ����Ÿ� ���ȿ�� �ݿ���(����Ȯ���� ��ʰ���)</td>
          <td width="120" class="title">89 ����Ұ� ���ݾ� ������(������ ���, 1��������)</td>
          <td width="120" class="title">90 ���Կɼ��ִ� ���� ��������� ����ȿ�� ������</td>
          <td width="120" class="title">91 ���Կɼ��ִ� �縮�� ��������� ����ȿ�� ������</td>
          <td width="120" class="title">92 ���� ��ⷻƮ Ȩ������ �α�����(����/����) �α�1</td>
          <td width="120" class="title">93 ���� ���� Ȩ������ �α�����(����/����) �α�1</td>
          <td width="120" class="title">94 �ܱ�뿩����(������ û����)</td>
          <td width="120" class="title">95&nbsp;</td>
          
          <td width="120" class="title">96 �ڵ�</td>	
          <td width="120" class="title">97 ����</td>
          <td width="120" class="title">98 �̸�1</td>
          <td width="120" class="title">99 �������밪(48��������)</td>
          <td width="120" class="title">100 �����������(����)</td>
          <td width="120" class="title">101 �������밪(��������)</td>
          <td width="120" class="title">102 �������밪�ݰ���</td>
          <td width="120" class="title">103 ������������(����)</td>
          <td width="120" class="title">104 �����������밪(��������)</td>
          <td width="120" class="title">105 ����������������(��������)</td>
          <td width="120" class="title">106 ����������������(��.��������)</td>
          <td width="120" class="title">107 �̸�2</td>
          <td width="120" class="title">108 �������밪(48��������)</td>
          <td width="120" class="title">109 �����������(����)</td>
          <td width="120" class="title">110 �������밪(��������)</td>
          <td width="120" class="title">111 �������밪�ݰ���</td>
          <td width="120" class="title">112 ������������(����)</td>
          <td width="120" class="title">113 �����������밪(��������)</td>
          <td width="120" class="title">114 ����������������(��������)</td>
          <td width="120" class="title">115 ����������������(��.��������)</td>
          <td width="120" class="title">116 �̸�3</td>
          <td width="120" class="title">117 �������밪(48��������)</td>
          <td width="120" class="title">118 �����������(����)</td>
          <td width="120" class="title">119 �������밪(��������)</td>
          <td width="120" class="title">120 �������밪�ݰ���</td>
          <td width="120" class="title">121 ������������(����)</td>
          <td width="120" class="title">122 �����������밪(��������)</td>
          <td width="120" class="title">123 ����������������(��������)</td>
          <td width="120" class="title">124 ����������������(��.��������)</td>
          <td width="120" class="title">125 �̸�4</td>
          <td width="120" class="title">126 �������밪(48��������)</td>
          <td width="120" class="title">127 �����������(����)</td>
          <td width="120" class="title">128 �������밪(��������)</td>
          <td width="120" class="title">129 �������밪�ݰ���</td>
          <td width="120" class="title">130 ������������(����)</td>
          <td width="120" class="title">131 �����������밪(��������)</td>
          <td width="120" class="title">132 ����������������(��������)</td>
          <td width="120" class="title">133 ����������������(��.��������)</td>
          <td width="120" class="title">134 �̸�5</td>
          <td width="120" class="title">135 �������밪(48��������)</td>
          <td width="120" class="title">136 �����������(����)</td>
          <td width="120" class="title">137 �������밪(��������)</td>
          <td width="120" class="title">138 �������밪�ݰ���</td>
          <td width="120" class="title">139 ������������(����)</td>
          <td width="120" class="title">140 �����������밪(��������)</td>
          <td width="120" class="title">141 ����������������(��������)</td>
          <td width="120" class="title">142 ����������������(��.��������)</td>
          <td width="120" class="title">143 �̸�6</td>
          <td width="120" class="title">144 �������밪(48��������)</td>
          <td width="120" class="title">145 �����������(����)</td>
          <td width="120" class="title">146 �������밪(��������)</td>
          <td width="120" class="title">147 �������밪�ݰ���</td>
          <td width="120" class="title">148 ������������(����)</td>
          <td width="120" class="title">149 �����������밪(��������)</td>
          <td width="120" class="title">150 ����������������(��������)</td>
          <td width="120" class="title">151 ����������������(��.��������)</td>
          <td width="120" class="title">152 �̸�7</td>
          <td width="120" class="title">153 �������밪(48��������)</td>
          <td width="120" class="title">154 �����������(����)</td>
          <td width="120" class="title">155 �������밪(��������)</td>
          <td width="120" class="title">156 �������밪�ݰ���</td>
          <td width="120" class="title">157 ������������(����)</td>
          <td width="120" class="title">158 �����������밪(��������)</td>
          <td width="120" class="title">159 ����������������</td>
          <td width="120" class="title">160 ����������������</td>
          <td width="120" class="title">161 &nbsp;</td>
          <!--20151001 �߰� end-->
          <td width="120" class="title">162 �Ⱓ��Ư�Ҽ���1</td>
          <td width="120" class="title">163 �Ⱓ��Ư�Ҽ���2</td>
          <td width="120" class="title">164 �Ⱓ��Ư�Ҽ���3</td>
          <td width="120" class="title">165 �Ⱓ��Ư�Ҽ���4</td>
          <td width="120" class="title">166 �Ⱓ��Ư�Ҽ���5</td>
          <td width="120" class="title">167 �Ⱓ��Ư�Ҽ���6</td>
          <td width="120" class="title">168 �Ⱓ��Ư�Ҽ���7</td>
          <td width="120" class="title">169 �Ⱓ��Ư�Ҽ���8</td>
          <td width="120" class="title">170 �Ⱓ��Ư�Ҽ���9</td>
          <td width="120" class="title">171 �Ⱓ��Ư�Ҽ���10</td>
          <td width="120" class="title">172 �Ⱓ��Ư�Ҽ���11</td>
          <td width="120" class="title">173 �Ⱓ��Ư�Ҽ���12</td>
          <td width="120" class="title">174 �Ⱓ��Ư�Ҽ���13</td>
          <td width="120" class="title">175 �Ⱓ��Ư�Ҽ���14</td>
          <td width="120" class="title">176 �Ⱓ��Ư�Ҽ���15</td>
          <td width="120" class="title">177 �Ⱓ��Ư�Ҽ���16</td>
          <td width="120" class="title">178 �Ⱓ��Ư�Ҽ���17</td>
          <td width="120" class="title">179 �Ⱓ��Ư�Ҽ���18</td>
          <td width="120" class="title">180 �Ⱓ��Ư�Ҽ���19</td>
          <td width="120" class="title">181 �Ⱓ��Ư�Ҽ���20</td>
          <td width="120" class="title">182 �Ⱓ��Ư�Ҽ���21</td>
          <td width="120" class="title">183 �Ⱓ��Ư�Ҽ���22</td>
          <td width="121" class="title">184 �Ⱓ��Ư�Ҽ���23</td>
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
    	  <td width="30" class="title">����</td>
    	  <td width="40" class="title">������</td>	
    	  <td colspan='<%=sheet.getColumns()%>' class="title">���� ����Ÿ</td>
  		</tr>
<%
	for (int i = 0 ; i < vt_size ; i++){
		Hashtable content = (Hashtable)vt.elementAt(i);
%>  
        <tr>
    	  <td width="30" height="30" class="title"><%=i+1%></td>
    	  <td width="40" align="center"><input name="ch_start" type="checkbox" value="<%=i%>"></td>	
		  <% for(int j = 0; j < sheet.getColumns(); j++){%>
    	  <td width="120" align="center"><input name="value<%=j%>" type="text" class=text value="<%=content.get(String.valueOf(j))%>"size="13"></td>
		  <%	}%>
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
    <td align="center"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
<input type='hidden' name='value_line' value='<%=value_line%>'>   
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>