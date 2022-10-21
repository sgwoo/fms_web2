<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	Vector vt = ScdMngDb.getTaxCngList(s_br, s_kd, t_wd);
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//��༱��
	function Disp(tax_no, rent_l_cd, client_id){
		var fm = document.form1;
		opener.parent.c_foot.location.href = "<%=go_url%>?tax_no="+tax_no+"&rent_l_cd="+rent_l_cd+"&client_id="+client_id;		
		self.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_cont.jsp'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
  <table width="750" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>�˻�����: 
        <select name='s_kd'>
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>�Ϸù�ȣ</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>��ȣ</option>
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()">
		<input type="button" name="b_ms2" value="�˻�" onClick="javascript:search();" class="btn">
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=750>
          <tr> 
            <td class=title width="30">����</td>
            <td class=title width="70">�Ϸù�ȣ</td>
            <td class=title width="90">����ȣ</td>
            <td class=title width="100">��ȣ</td>
            <td class=title width="60">���౸��</td>			
            <td class=title width="70">�ۼ�����</td>
            <td class=title width="80">ǰ��</td>			
            <td class=title width="70">�հ�</td>
            <td class=title width="180">���</td>
          </tr>
          <%for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><a href="javascript:Disp('<%=ht.get("TAX_NO")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("TAX_NO")%></a></td>
            <td align="center"><%=ht.get("RENT_L_CD")%></td>
            <td align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
            <td align="center">
			<%if(String.valueOf(ht.get("UNITY_CHK")).equals("0")){%>��������
			<%}else{%>���չ���<%}%>
			</td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
            <td align="center"><%=ht.get("TAX_G")%></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%>��</td>
            <td>&nbsp;<span title='<%=ht.get("TAX_BIGO")%>'><%=AddUtil.subData(String.valueOf(ht.get("TAX_BIGO")), 15)%></span></td>															
          </tr>
          <%		}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>	
    <tr> 
      <td align="center"><input type="button" name="b_ms2" value="�ݱ�" onClick="javascript:window.close();" class="btn"></td>
    </tr>
  </table>
</form>
</body>
</html>