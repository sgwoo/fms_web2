<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	
	if(car_name.equals("��ü")) car_name = "";
	if(car_name.equals("����")) car_name = "";
	if(view_dt.equals("��ü")) 	view_dt = "";
	if(view_dt.equals("����")) 	view_dt = "";
	if(!car_name.equals(""))	view_dt = "";
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	Vector vt = a_cmd.getCarNmExcelYnList(car_comp_id, car_cd, car_name, view_dt);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		if(!confirm("�ϰ�ó���Ͻðڽ��ϱ�?"))	return;
		fm.action = 'car_nm_yn_list2_a.jsp';
		fm.submit();
	}
	
//-->
</script>
</head>
<body>
<form action="" method='post' name="form1">
<input type='hidden' name='size' value='<%=vt_size%>'>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<input type='hidden' name='car_name' value='<%=car_name%>'>
<input type='hidden' name='view_dt' value='<%=view_dt%>'>


<table border=0 cellspacing=0 cellpadding=0 width=1150>
	<tr>
		<td><�ϰ� ���/�̻�� ó��>
		</td>	
	</tr>	
    <tr>
      <td class=h></td>
    </tr>	
		<tr>
			<td class=line2></td>
		</tr>    
    <tr>
        <td class=line>
				<table border="0" cellspacing="1" cellpadding="0" width="100%">
			  <tr>
			    <td width="30" align="center">����</td>
			    <td width="110"  align="center">������</td>
			    <td width="150" align="center">����</td>
			    <td width="370" align="center">��</td>
			    <td width="80" align="center">�⺻����</td>
			    <td width="80"  align="center">��������</td>
			    <td width="60"  align="center">��뿩��</td>
			    <td width="60"  align="center">��������</td>
			    <td width="60"  align="center">Ȩ������<br>��������</td>
			    <td width="70"  align="center">���꿩��</td>
			    <td width="80"  align="center">TUIX/TUON<br>Ʈ������</td>
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
			  <tr>
			    <td align="center"><%=i+1%>
			    	<input type='hidden' name='car_id' value='<%=ht.get("CAR_ID")%>'>
			    	<input type='hidden' name='car_seq' value='<%=ht.get("CAR_SEQ")%>'>
			    </td>
			    <td align="center"><%=ht.get("NM")%></td>
			    <td align="center"><%=ht.get("CAR_NM")%></td>
			    <td align="center">&nbsp;<%=ht.get("CAR_NAME")%></td>
			    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_B_P")))%></td>
			    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_B_DT")))%></td>
			    <td align="center">
			    	<select name="use_yn">
              <option value="Y" <%if(String.valueOf(ht.get("USE_YN")).equals("Y")){%> selected <%}%>>Y</option>
              <option value="N" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y")){%> selected <%}%>>N</option>
            </select>
			    <td align="center">
			    	<select name="est_yn">
              <option value="Y" <%if(String.valueOf(ht.get("EST_YN")).equals("Y")){%> selected <%}%>>Y</option>
              <option value="N" <%if(!String.valueOf(ht.get("EST_YN")).equals("Y")){%> selected <%}%>>N</option>
            </select>
			    </td>
			    <td align="center">
			    	<select name="hp_yn">
              <option value="Y" <%if(String.valueOf(ht.get("HP_YN")).equals("Y")){%> selected <%}%>>Y</option>
              <option value="N" <%if(!String.valueOf(ht.get("HP_YN")).equals("Y")){%> selected <%}%>>N</option>
            </select>
			    </td>
          <td align="center">
			    	<select name="end_dt">
			    		<option value=""  <%if(String.valueOf(ht.get("END_DT")).equals("")) {%> selected <%}%>>�̼���</option>
              <option value="Y" <%if(String.valueOf(ht.get("END_DT")).equals("Y")){%> selected <%}%>>����</option>
              <option value="N" <%if(String.valueOf(ht.get("END_DT")).equals("N")){%> selected <%}%>>����</option>
            </select>
			    </td>		
          <td align="center">
			    	<select name="jg_tuix_st">
              <option value="" <%if(String.valueOf(ht.get("JG_TUIX_ST")).equals("")){%> selected <%}%>>�̼���</option>
              <option value="N" <%if(String.valueOf(ht.get("JG_TUIX_ST")).equals("N")){%> selected <%}%>>���ش�</option>
              <option value="Y" <%if(String.valueOf(ht.get("JG_TUIX_ST")).equals("Y")){%> selected <%}%>>�ش�</option>
            </select>
			    </td>			    	    
			  </tr>
			  <%}%>
            </table>
        </td>
    </tr>
	<tr>
		<td align='right'>
      (<input type="checkbox" name="end_hp_yn" value="Y" checked> ���꿩�ο� Ȩ��������뿩�θ� �����Ѵ�.)
      &nbsp;&nbsp;
			<input type="button" class="button" value="�ϰ�ó��" onclick="javascript:save();">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" class="button" value="�ݱ�" onclick="javascript:self.close();window.close();">
		</td>	
	</tr>		
</table>
</form>
</body>
</html>