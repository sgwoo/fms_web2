<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String idx 				= request.getParameter("idx")==null?"":request.getParameter("idx");
	String client_id	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq				= request.getParameter("seq")==null?"":request.getParameter("seq");
	String t_wd				= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	t_wd = AddUtil.replace(t_wd,"'","");
	
	//�뿩��
	Vector vts = IssueDb.getIssue1TaxItemSearchList(t_wd);
	int vt_size = vts.size();
	
	//�����뿩��
	Vector vts2 = IssueDb.getIssue1TaxItemClsSearchList(t_wd);
	int vt_size2 = vts2.size();
	
	//��å��
	Vector vts3 = IssueDb.getIssue1TaxItemServSearchList(t_wd);
	int vt_size3 = vts3.size();

%>

<html>
<head><title>�ŷ�ó �˻�</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function Search(){
		var fm = document.form1;
		fm.action = "tax_item_list_search.jsp";
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') document.form1.submit();
	}

	function setItem(rent_l_cd, car_mng_id, fee_tm, rent_st, rent_seq, car_no, car_nm, car_use, dt1, dt2, st, idx){
		var fm = opener.document.form1;
		fm.rent_l_cd.value 		= rent_l_cd;
		fm.car_mng_id.value 	= car_mng_id;	
		fm.tm.value 			= fee_tm;			
		fm.rent_st.value 		= rent_st;
		fm.rent_seq.value 		= rent_seq;
		fm.car_use.value 		= car_use;
		fm.item_car_no[<%=idx%>].value 	= car_no;		
		fm.item_car_nm[<%=idx%>].value 	= car_nm;					
		fm.item_dt1[<%=idx%>].value 	= dt1;		
		fm.item_dt2[<%=idx%>].value 	= dt2;					

		<%if(vt_size+vt_size2+vt_size3 >1){%>	
		fm.item_supply[<%=idx%>].value 	= document.form1.item_supply[idx].value;		
		fm.item_value[<%=idx%>].value 	= document.form1.item_value[idx].value;					
		fm.item_amt[<%=idx%>].value 	= document.form1.item_amt[idx].value;							
		if(document.form1.item_supply[idx].value == '0' || document.form1.item_supply[idx].value == ''){
			alert('�ݾ��� �Է��Ͻʽÿ�.');
			return;
		}
		<%}else{%>
		fm.item_supply[<%=idx%>].value 	= document.form1.item_supply.value;		
		fm.item_value[<%=idx%>].value 	= document.form1.item_value.value;					
		fm.item_amt[<%=idx%>].value 	= document.form1.item_amt.value;							
		if(document.form1.item_supply.value == '0' || document.form1.item_supply.value == ''){
			alert('�ݾ��� �Է��Ͻʽÿ�.');
			return;
		}
		<%}%>
		
		
		if(st == 'scd'){
			fm.item_g[<%=idx%>].value 		= '�뿩��';			
			fm.gubun.value 					= '1';						
		}else if(st == 'cls'){
			fm.item_g[<%=idx%>].value 		= '�����뿩��';				
			fm.gubun.value 					= '1';											
		}else{
			fm.item_g[<%=idx%>].value 		= '����������';				
			fm.gubun.value 					= '7';											
		}
		
		opener.del_chk_set(<%=idx%>);

		window.close();
	}
	
	//�ŷ����� �ݾ׼���
	function set_amt(idx){
		
		var fm = document.form1;		
		
		<%if(vt_size+vt_size2+vt_size3 >1){%>
		fm.item_value[idx].value 	= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) * 0.1 );
		fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
		<%}else{%>
		fm.item_value.value 		= parseDecimal(toInt(parseDigit(fm.item_supply.value)) * 0.1 );
		fm.item_amt.value 			= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
		<%}%>
		
	}	
	
	//�ŷ����� �ݾ׼���
	function set_amt2(idx){
		
		var fm = document.form1;		
		
		<%if(vt_size+vt_size2+vt_size3 >1){%>
		fm.item_amt[idx].value 		= parseDecimal(toInt(parseDigit(fm.item_supply[idx].value)) + toInt(parseDigit(fm.item_value[idx].value)));			
		<%}else{%>
		fm.item_amt.value 			= parseDecimal(toInt(parseDigit(fm.item_supply.value)) + toInt(parseDigit(fm.item_value.value)));			
		<%}%>
		
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' method='post' action='tax_item_list_search.jsp'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='vid_size' value='<%=vt_size+vt_size2+vt_size3%>'>
<input type='hidden' name='ven_code' value=''>
<input type='hidden' name='ven_name' value=''>
<input type='hidden' name='off_id' value=''>
<input type='hidden' name='off_nm' value=''>
<input type='hidden' name='off_idno' value=''>
<input type='hidden' name='go_url' value='/tax/issue_1_tax/tax_item_list_search.jsp'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td align='left'>
      &nbsp;&nbsp;<img src=/acar/images/center/arrow_glc.gif align=absmiddle>&nbsp;
        <input type='text' name='t_wd' size='30' value='<%=t_wd%>' class='text' onKeyDown='javascript:enter()'>

        &nbsp;<a href="javascript:document.form1.submit()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
		&nbsp;&nbsp;
		(����뿩��,�����뿩��,���ñ� �߰� ����)
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='3%' class='title'>����</td>			
            <td width="8%" class='title'>����</td>
            <td width='10%' class='title'>��ȣ</td>			
            <td width='10%' class='title'>������ȣ</td>			
            <td width='10%' class='title'>����</td>			
            <td width='5%' class='title'>ȸ��</td>
            <td width='8%' class='title'>���ް�</td>
            <td width='7%' class='title'>�ΰ���</td>
            <td width='8%' class='title'>�հ�</td>			
            <td width='8%' class='title'>�Աݿ�����</td>
            <td width='8%' class='title'>��������</td>
            <td width='8%' class='title'>���࿹����</td>			
            <td width='7%' class='title'>����</td>						
          </tr>
                <%if(vt_size > 0 && !t_wd.equals("")){
						for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center">�뿩��</td>		
            <td align='center'><%=ht.get("FIRM_NM")%></td>
			      <td align='center'><a href="javascript:setItem('<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("FEE_TM")%>','<%=ht.get("RENT_ST")%>','<%=ht.get("RENT_SEQ")%>','<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>','<%=ht.get("CAR_USE")%>', '<%=ht.get("USE_S_DT")%>', '<%=ht.get("USE_E_DT")%>', 'scd','<%=i%>');"><%=ht.get("CAR_NO")%></a></td>
            <td align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 4)%></span></td>
            <td align='center'><%=ht.get("FEE_TM")%>ȸ</td>
            <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>��&nbsp;</td>
            <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>��&nbsp;</td>
            <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>��&nbsp;</td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_FEE_EST_DT")))%></td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>			
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_REQ_DT")))%></td>		
            <td align='center'><%=ht.get("USE_YN")%></td>	
			        <input type='hidden' name='item_supply' value='<%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>'>
			        <input type='hidden' name='item_value' value='<%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>'>
			        <input type='hidden' name='item_amt' value='<%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>'>						          			
          </tr>
                <%	}
				}%>		
                <%if(vt_size2 > 0 && !t_wd.equals("")){
						for(int i = 0 ; i < vt_size2 ; i++){
							Hashtable ht = (Hashtable)vts2.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center">�����뿩��</td>		
            <td align='center'><%=ht.get("FIRM_NM")%></td>
			      <td align='center'><a href="javascript:setItem('<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','','','','<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>','<%=ht.get("CAR_USE")%>', '<%=ht.get("CLS_DT")%>', '', 'cls','<%=vt_size+i%>');"><%=ht.get("CAR_NO")%></a></td>
            <td align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 4)%></span></td>
            <td align='center'>-</td>
            <td align="right" ><input type="text" name="item_supply" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=vt_size+i%>);'>��&nbsp;</td>
            <td align="right" ><input type="text" name="item_value" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt2(<%=vt_size+i%>);'>��&nbsp;</td>
            <td align="right" ><input type="text" name="item_amt" size="10" value="" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value);'>��&nbsp;</td>
            <td align="center"><%//=AddUtil.ChangeDate2(String.valueOf(ht.get("R_FEE_EST_DT")))%></td>
            <td align="center"><%//=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>			
            <td align="center"><%//=AddUtil.ChangeDate2(String.valueOf(ht.get("R_REQ_DT")))%></td>		
            <td align='center'><%=ht.get("USE_YN")%></td>							          			
          </tr>
                <%	}
				}%>		 
                <%if(vt_size3 > 0 && !t_wd.equals("")){
						for(int i = 0 ; i < vt_size3 ; i++){
							Hashtable ht = (Hashtable)vts3.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center">��å��</td>		
            <td align='center'><%=ht.get("FIRM_NM")%></td>
			      <td align='center'><a href="javascript:setItem('<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SERV_ID")%>','','','<%=ht.get("CAR_NO")%>','<%=ht.get("CAR_NM")%>','<%=ht.get("CAR_USE")%>', '<%=ht.get("SERV_DT")%>', '', 'serv','<%=vt_size+vt_size2+i%>');"><%=ht.get("CAR_NO")%></a></td>
            <td align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 4)%></span></td>
            <td align='center'>-</td>
            <td align="right" ><input type="text" name="item_supply" size="10" value="<%=Util.parseDecimal(String.valueOf(ht.get("EXT_S_AMT")))%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(<%=vt_size+vt_size2+i%>);'>��&nbsp;</td>
            <td align="right" ><input type="text" name="item_value" size="10" value="<%=Util.parseDecimal(String.valueOf(ht.get("EXT_V_AMT")))%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value); set_amt2(<%=vt_size+vt_size2+i%>);'>��&nbsp;</td>
            <td align="right" ><input type="text" name="item_amt" size="10" value="<%=Util.parseDecimal(String.valueOf(ht.get("EXT_AMT")))%>" class="taxnum" onBlur='javascript:this.value=parseDecimal(this.value);'>��&nbsp;</td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_EST_DT")))%></td>
            <td align="center"><%//=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>			
            <td align="center"><%//=AddUtil.ChangeDate2(String.valueOf(ht.get("R_REQ_DT")))%></td>		
            <td align='center'><%=ht.get("USE_YN")%></td>							          			
          </tr>
                <%	}
				}%>						
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td align='right'>
      	<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  </table>
</form>
</body>
</html>