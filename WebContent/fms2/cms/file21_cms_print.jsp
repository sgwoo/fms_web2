<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		fm.action = 'file21_cms_print.jsp';
		fm.target='_self';
		fm.submit();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String adate = request.getParameter("adate")==null?"":request.getParameter("adate");
	String org_code = request.getParameter("org_code")==null?"9951572587":request.getParameter("org_code");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	
		//jip_cms ���̺��� �Աݹݿ��� ����Ƿ��� ��ȸ�ϱ�
	Vector vt2 = ai_db.getAJipCmsDate();
	int vt_size2 = vt2.size();	
	
	//jip_cms ���̺� ��ȸ�ϱ�
	Vector vt = ai_db.getJipCmsDateList(adate, org_code, s_kd, t_wd);
	int vt_size = vt.size();
	
%>
<form name='form1' method='post'  >

<input type='hidden' name='sh_height' value='74'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
 <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%> 
	   
		<tr>
		  <td width='100' class='title'>����Ƿ�����</td>
		  <td width='100' >&nbsp;
              <select name="adate">
			    <option value="">=== ����===</option>
<%		for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);%>
                <option value="<%=ht.get("ADATE")%>"  <% if(adate.equals(String.valueOf(ht.get("ADATE"))))%> selected<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ADATE")))%></option>
<%		}%>
              </select>					 
		  </td>
			   <td width='100' class='title'>����ڵ�</td>
		  		<td width='200' >&nbsp;
	              <select name="org_code">
				    <option value='' <%if(org_code.equals(""))%>selected<%%>>����</option>
				    <option value='9951572587'  <%if(org_code.equals("9951572587"))%>selected<%%>>9951572587 (����:amazoncar1)</option>             
			        <option value='9950110252'  <%if(org_code.equals("9950110252"))%>selected<%%>>9950110252 (��ȯ:amazoncar2)</option>              
			        <option value='9954513141'  <%if(org_code.equals("9954513141"))%>selected<%%>>9954513141 (���:amazoncar3)</option>    
			        <option value='9950110401'  <%if(org_code.equals("9950110401"))%>selected<%%>>9950110401 (����:amazoncar4)</option>  
			        <option value='9954516981'  <%if(org_code.equals("9954516981"))%>selected<%%>>9954516981 (���:amazoncar6)</option>     
			        <option value='9954517597'  <%if(org_code.equals("9954517597"))%>selected<%%>>9954517597 (�츮:amazoncar7)</option>  
			        <option value='9954519858'  <%if(org_code.equals("9954519858"))%>selected<%%>>9954519858 (����:amazoncar8)</option>    
			        <option value='9950110418'  <%if(org_code.equals("9950110418"))%>selected<%%>>9950110418 (�ϳ�:amazoncar5) (���x)</option>                                                              
	              </select>	
				</td>								  
			  <td width='100' class='title'>����</td>
			  <td width='300' >&nbsp;
	              <select name="s_kd">
	              <option value='' <%if(s_kd.equals(""))%>selected<%%>>��ü</option>
	              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
	              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>������ȣ</option>
	              <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>����ȣ</option>  
	             
	              </select>	
	              <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>	
				  &nbsp; <a href="javascript:search()"><img src="/acar/images/center/button_in_search.gif" align=absmiddle border="0"></a>	
		  </td>
	  </table>
	</td>
  </tr>  
  <tr>
	<td class='line'>
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
		<tr>
		  <td width='30' class='title'>����</td>
		  <td width='80' class='title'>�Ƿ���</td>
		  <td width='80' class='title'>����ڵ�</td>
		  <td class='title'>��ȣ</td>
		  <td width='100' class='title'>������ȣ</td>
		  <td width='120' class='title'>����ȣ</td>
		  
		  <td width='80' class='title'>�뿩��</td>
		  <td width='80' class='title'>���·�</td>
		  <td width='80' class='title'>��å��</td>
		  <td width='80' class='title'>��ü����</td>
		  <td width='80' class='title'>���������</td>
		  <td width='80' class='title'>�ܱ�&����Ʈ</td>
		  <td width='90' class='title'>�հ�</td>
		  <td width='50' class='title'>ó��</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);		%>
		<tr>
		  <td align="center" ><%=i+1%></td>
		  <td >&nbsp;<%=ht.get("ADATE")%></td>
		   <td align="center" >&nbsp;<%=ht.get("R_ORG_CODE")%></td>
		  <td >&nbsp;<%=ht.get("FIRM_NM")%></td>
		  <td align="center" ><%=ht.get("CAR_NO")%></td>
		  <td align="center" ><%=ht.get("ACODE")%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FINE")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("CAR_JA")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("DLY")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("CLS")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("RM")))%></td>
		  <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("AMT")))%></td>
		  <td align="right" ></td>
		</tr>
<%			total_amt1 = total_amt1 + Long.parseLong(String.valueOf(ht.get("FEE")));
			total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("FINE")));
			total_amt3 = total_amt3 + Long.parseLong(String.valueOf(ht.get("CAR_JA")));
			total_amt4 = total_amt4 + Long.parseLong(String.valueOf(ht.get("DLY")));
			total_amt5 = total_amt5 + Long.parseLong(String.valueOf(ht.get("CLS")));
			total_amt6 = total_amt6 + Long.parseLong(String.valueOf(ht.get("AMT")));
			total_amt7 = total_amt7 + Long.parseLong(String.valueOf(ht.get("RM")));
			
}%>	
		<tr>
		 
		  <td class=star colspan=6 align="center" >�հ�</td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt1)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt2)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt3)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt4)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt5)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt7)%></td>
		  <td align="right" class=star ><%=Util.parseDecimal(total_amt6)%></td>
		  <td align="right" class=star ></td>
		  
		</tr>	
	  </table>
	</td>
  </tr>  
</table>
</form>

</body>
</html>