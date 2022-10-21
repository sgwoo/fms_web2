<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_tot_amt = request.getParameter("rent_tot_amt")==null?"":request.getParameter("rent_tot_amt");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "02");
	
	Vector conts = rs_db.getScdRentList(s_cd, "");
	int cont_size = conts.size();
	
	long total_amt1 	= 0;
	long total_amt2 	= 0;
	long total_amt3 	= 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�ܾ׼���
	function set_rest_amt(){
		var fm = document.form1;
		
		
		return;
		for(i=0;i<parseInt(fm.c_size.value);i++){	
			if(i == 0){
				if(fm.c_size.value == '0'){
					fm.rest_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.rent_amt.value)) ) ;
			 	}else{
					fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.rent_amt[i].value)) ) ;
			 	}			 
			}else{
				if(fm.c_size.value == '0'){
					fm.rest_amt.value = parseDecimal(toInt(parseDigit(fm.rest_amt.value)) - toInt(parseDigit(fm.pay_amt.value)) ) ;		
			 	}else{
					fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.rest_amt[i-1].value)) - toInt(parseDigit(fm.pay_amt[i].value)) ) ;		
			 	}			 
			}
		}		
	}
	
	function set_rent_amt(idx){
		var fm = document.form1;
		if(<%=cont_size%>==0){
			fm.rent_amt.value = parseDecimal(toInt(parseDigit(fm.rent_s_amt.value)) + toInt(parseDigit(fm.rent_v_amt.value)));
		}else{
			fm.rent_amt[idx].value = parseDecimal(toInt(parseDigit(fm.rent_s_amt[idx].value)) + toInt(parseDigit(fm.rent_v_amt[idx].value)));
		}
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post' target=''>
<input type='hidden' name='c_size' value='<%=cont_size%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='rent_tot_amt' value='<%=rent_tot_amt%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='3%' class='title'>����</td>
                    <td width='9%' class='title'>��ݱ���</td>
                    <td width='3%' class='title'>����</td>
                    <td width='9%' class='title'>���ݱ���</td>
                    <td width='8%' class='title'>�Աݿ�����</td>
                    <td width='8%' class='title'>���ް�</td>		
                    <td width='7%' class='title'>�ΰ���</td>		
                    <td width='8%' class='title'>�հ�</td>
                    <td width='8%' class='title'>�Ա����� </td>
                    <td width='8%' class='title'>���Աݾ�</td>                    
                    <td width='7%' class='title'>���ݰ�꼭</td>						
                    <td width='4%' class='title'>��ü��</td>
                    <td width='4%' class='title'>��ü��</td>
                    <td width='5%' class='title'>�Ա�<br>���</td>
                    <td width='9%' class='title'>����<br>����</td>
                </tr>
		<%if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
			
				Hashtable sr = (Hashtable)conts.elementAt(i);
				
				String is = "";
				String white = "";
				
				if(!String.valueOf(sr.get("PAY_DT")).equals("") || String.valueOf(sr.get("RENT_AMT")).equals("0")){
					is 	= "class='is'";
					white 	= "white";
				}
				
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(sr.get("RENT_S_AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(sr.get("RENT_V_AMT")));
				total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(sr.get("RENT_AMT")));
				%>					
    			<input type='hidden' name='tm' value='<%=sr.get("TM")%>'>
    			<input type='hidden' name='rest_amt' value='<%=sr.get("REST_AMT")%>'>
                <tr> 
                    <td <%=is%> align='center'><%=i+1%></td>
                    <td <%=is%> align='center'>
                                <select name="rent_st">
            	              	  <option value="">==����==</option>			              	              	  
                	          <option value="1" <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>selected<%}%>>�����</option>
                    	          <option value="2" <%if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>selected<%}%>>�����뿩��</option>
                    	          <option value="3" <%if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>selected<%}%>>�뿩��</option>
                    	          <option value="5" <%if(String.valueOf(sr.get("RENT_ST")).equals("5")){%>selected<%}%>>����뿩��</option>
                    	          <option value="4" <%if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>selected<%}%>>�����</option>
                    	          <option value="6" <%if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>selected<%}%>>������</option>
                    	          <option value="7" <%if(String.valueOf(sr.get("RENT_ST")).equals("7")){%>selected<%}%>>��ü����</option>
                    	          <option value="8" <%if(String.valueOf(sr.get("RENT_ST")).equals("8")){%>selected<%}%>>���·�</option>
        	                </select>        	                
        	    </td>
        	    <td <%=is%> align='center'>
        	    		<input type='text' name='ext_seq' size='2' value='<%=sr.get("EXT_SEQ")%>' class='<%=white%>text'>
        	    </td>
        	    <td <%=is%> align='center'>
        	                <select name="paid_st">
            	                  <option value="">=����=</option>			  
                	          <option value="1" <%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>selected<%}%>>����</option>
                    	          <option value="2" <%if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>selected<%}%>>�ſ�ī��</option> 
                    	          <option value="3" <%if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>selected<%}%>>�ڵ���ü</option>					  
                    	          <option value="4" <%if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>selected<%}%>>�������Ա�</option>					  					  
        	                </select>        					
        			</td>		
                    <td <%=is%> align='center'><input type='text' name='est_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(sr.get("EST_DT")))%>' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td <%=is%> align='center'><input type='text' name='rent_s_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_S_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>			
                    <td <%=is%> align='center'><input type='text' name='rent_v_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_V_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>			
                    <td <%=is%> align='center'><input type='text' name='rent_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("RENT_AMT")))%>' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=i%>);'></td>
                    <td <%=is%> align='center'><input type='text' name='pay_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td <%=is%> align='center'><input type='text' name='pay_amt' size='8' value='<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rest_amt()'></td>                    
                    <td <%=is%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(sr.get("TAX_DT")))%>
                      <!--���ݰ�꼭 �����û-->
                      <%if(String.valueOf(sr.get("TAX_DT")).equals("") && AddUtil.parseLong(String.valueOf(sr.get("RENT_V_AMT"))) >0 && !String.valueOf(sr.get("PAID_ST")).equals("2")){%>
                      �����û
                      <%}%>
                    </td>
                    <td <%=is%> align='right'><%=sr.get("DLY_DAYS")%></td>
                    <td <%=is%> align='right'><%=Util.parseDecimal(String.valueOf(sr.get("DLY_AMT")))%></td>
                    <td <%=is%> align='center'>
                      <!--�Ա�/���-->
                      <%if(!mode.equals("view")){%>
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){
        			  			if(String.valueOf(sr.get("PAY_DT")).equals("")){%>
        	              <a href="javascript:parent.change_scd('p', <%=i%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_ig.gif  align=absmiddle border="0"></a>
        				  <%	}else{%>
        	              <a href="javascript:parent.change_scd('c', <%=i%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_cancel.gif  align=absmiddle border="0"></a>			  
        				  <%	}%>				  
                      <%	}%>
                      <%}%>
        			</td>
                    <td <%=is%> align='center' width='9%'>
                      <!--����/����-->
                      <%if(!mode.equals("view")){%>
                      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:parent.change_scd('u', <%=i%>)" onMouseOver="window.status=''; return true" title='����'><img src=/acar/images/center/button_in_modify.gif  align=absmiddle border="0"></a>
                      <%	}%>	
        			 
        			  <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){//����,����%>					
        				<a href="javascript:parent.change_scd('d', <%=i%>)" onMouseOver="window.status=''; return true" title='����'><img src=/acar/images/center/button_in_delete.gif  align=absmiddle border="0"></a>
        			  <%	}%>
        		 <%}%>	  
                    </td>
                </tr>	  
<%		}%>
                <tr> 
                    <td class="title" colspan='5'>�հ�</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%>��&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>��&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>��&nbsp;</td>
        	    <td class="title" colspan='7'>&nbsp;</td>
                </tr>
<%	}%>
<%if(!mode.equals("view")){%>
<!--�߰�-->
			        <input type='hidden' name='tm' value=''>	
			        <input type='hidden' name='rest_amt' value=''>		
                <tr> 
                    <td align='center'>-</td>
                    <td align='center'>
        			<select name="rent_st">
            	              	  <option value="">==����==</option>			  
                	          <option value="1">�����</option>
                    	          <option value="2">�����뿩��</option>
                    	          <option value="3">�뿩��</option>
                    	          <option value="5">����뿩��</option>
                    	          <option value="4">�����</option>
                    	          <option value="6">������</option>
                    	          <option value="7">��ü����</option>
                    	           <option value="8">���·�</option>
        	                </select>
        			</td>
        	    <td align='center'>
        	    		<input type='text' name='ext_seq' size='2' value='' class='text'>
        	    </td>		
        	    <td align='center'>
        			<select name="paid_st">
                	          <option value="1">����</option>
                    <!--	          <option value="2">�ſ�ī��</option> -->
                    	          <option value="3">�ڵ���ü</option>					  
                    	          <option value="4">�������Ա�</option>					  					  
        	                </select>
        			</td>		
                    <td align='center'><input type='text' name='est_dt' size='11' value='' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='center'><input type='text' name='rent_s_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_rent_amt(<%=cont_size%>);'></td>			
                    <td align='center'><input type='text' name='rent_v_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=cont_size%>);'></td>			
                    <td align='center'><input type='text' name='rent_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rent_amt(<%=cont_size%>);'></td>
                    <td align='center'><input type='text' name='pay_dt' size='11' value='' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align='center'><input type='text' name='pay_amt' size='8' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_rest_amt();'></td>                    
                    <td align='right'>-&nbsp;</td>
                    <td align='right'>-&nbsp;</td>					
                    <td align='right'>-&nbsp;</td>
                    <td align='center'>
                      <%//	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        	              <a href="javascript:parent.change_scd('a', <%=cont_size%>)" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_plus.gif  align=absmiddle border="0"></a>
        			  <%//	}%>				  
        			</td>
                    <td align='center'>-</td>
                </tr>	
<%}%>                  
            </table>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
//	set_rest_amt()
//-->
</script>
</body>
</html>