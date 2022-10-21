<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "11", "02", "05");

	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	Vector vt = a_cmd.getConsCostCarForm();
	int vt_size = vt.size();
	
	int row_size = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src="/acar/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		if(fm.off_id.value == '')			{ alert('Ź�۾�ü�� �����Ͻʽÿ�.'); return; }
		if(fm.cost_b_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }

		if(!confirm("����Ͻðڽ��ϱ�?"))	return;
		fm.action = 'cons_cost_i_a.jsp';
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
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<input type='hidden' name='row_size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="1000">
  <tr>
    <td>&lt; ���� &gt; </td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="100" height="30" class="title">Ź�۾�ü</td>
    	  <td>&nbsp;
		      <select name='off_id'>
		      	    <option value='007751'>����Ư��</option>                                                        
                            <option value='009026'>��������</option>
                            <option value='011372'>�������(��)</option>
                            <option value='009771'>����ī��</option>
                            <option value='010265'>��ȭ������</option>                
                            <option value='010266'>�����</option>                  
                            <option value='010630'>���������</option>                
              </select>
          </td>
        </tr>
        <tr>
    	  <td width="100" height="30" class="title">��������</td>
    	  <td>&nbsp;
		  <input name="cost_b_dt" type="text" class=text value=""size="12"></td>
        </tr>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
  </tr>    
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="0" width=100%>  
			  <tr>
			    <td width="100" rowspan="2" class="title">������</td>
			    <td width="200" rowspan="2" class="title">����</td>
			    <td width="100" rowspan="2" class="title">������</td>				
				<td colspan="5" class="title">�μ�����</td>
			   </tr>
			   <tr>
			    <td width="100" class="title">���ﺻ��</td>
			    <td width="100" class="title">�λ�����</td>
			    <td width="100" class="title">��������</td>				
			    <td width="100" class="title">�뱸����</td>
			    <td width="100" class="title">��������</td>				
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
			  <%	if(String.valueOf(ht.get("NM")).equals("�����ڵ���")){	row_size=row_size+2;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='���' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='�ƻ�' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <%	}%>
			  <%	if(String.valueOf(ht.get("NM")).equals("����ڵ���")){	row_size=row_size+3;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='���ϸ�' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='ȭ��' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='����' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <%	}%>
			  <%	if(String.valueOf(ht.get("NM")).equals("�����ڸ����ڵ���(��)")){	row_size=row_size+1;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='�λ�' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <%	}%>		
			  <%	if(String.valueOf(ht.get("NM")).equals("�ѱ�����(��)")){	row_size=row_size+3;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='â��' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='����' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='��õ' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <%	}%>		
			  <%	if(String.valueOf(ht.get("NM")).equals("�ֿ��ڵ���(��)")){	row_size=row_size+1;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='����' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
			  </tr>			  
			  <%	}%>					  	  	  
			  <%}%>			  
            </table>
        </td>
    </tr>
  <tr>  
    <td align="center">[<%=row_size%>��]&nbsp; 
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
        <%}%>
        <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--
	document.form1.row_size.value = <%=row_size%>;
//-->
</SCRIPT>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>